Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4027EC9A46
	for <lists+live-patching@lfdr.de>; Thu,  3 Oct 2019 10:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbfJCIzf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 3 Oct 2019 04:55:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:48432 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727912AbfJCIze (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 3 Oct 2019 04:55:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E6793B15F;
        Thu,  3 Oct 2019 08:55:32 +0000 (UTC)
Date:   Thu, 3 Oct 2019 10:55:08 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     jikos@kernel.org, jpoimboe@redhat.com, joe.lawrence@redhat.com,
        nstange@suse.de, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/3] livepatch: Clear relocation targets on a
 module removal
In-Reply-To: <20191002132252.wufgbd23sgqptyye@pathway.suse.cz>
Message-ID: <alpine.LSU.2.21.1910031050440.9011@pobox.suse.cz>
References: <20190905124514.8944-1-mbenes@suse.cz> <20190905124514.8944-2-mbenes@suse.cz> <20191002132252.wufgbd23sgqptyye@pathway.suse.cz>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 2 Oct 2019, Petr Mladek wrote:

> On Thu 2019-09-05 14:45:12, Miroslav Benes wrote:
> > We thus decided to reverse the relocation patching (clear all relocation
> > targets on x86_64, or return back nops on powerpc). The solution is not
> > universal and is too much arch-specific, but it may prove to be simpler
> > in the end.
> > 
> > diff --git a/arch/powerpc/kernel/module_64.c b/arch/powerpc/kernel/module_64.c
> > index a93b10c48000..e461d456e447 100644
> > --- a/arch/powerpc/kernel/module_64.c
> > +++ b/arch/powerpc/kernel/module_64.c
> > @@ -741,6 +741,51 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
> >  	return 0;
> >  }
> >  
> > +#ifdef CONFIG_LIVEPATCH
> > +void clear_relocate_add(Elf64_Shdr *sechdrs,
> > +		       const char *strtab,
> > +		       unsigned int symindex,
> > +		       unsigned int relsec,
> > +		       struct module *me)
> > +{
> > +	unsigned int i;
> > +	Elf64_Rela *rela = (void *)sechdrs[relsec].sh_addr;
> > +	Elf64_Sym *sym;
> > +	unsigned long *location;
> > +	const char *symname;
> > +	u32 *instruction;
> > +
> > +	pr_debug("Applying ADD relocate section %u to %u\n", relsec,
> 
> s/Applying/Clearing/

Ugh. Thanks for noticing.
 
> > +	       sechdrs[relsec].sh_info);
> > +
> > +	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rela); i++) {
> > +		location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
> > +			+ rela[i].r_offset;
> > +		sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
> > +			+ ELF64_R_SYM(rela[i].r_info);
> > +		symname = me->core_kallsyms.strtab
> > +			+ sym->st_name;
> > +
> > +		if (ELF64_R_TYPE(rela[i].r_info) != R_PPC_REL24)
> > +			continue;
> 
> I expected that the code below would reverse the operations
> in apply_relocate_add() for case R_PPC_REL24. But it is not
> obvious for me.

It should, but it is not obvious. See restore_r2(). We only need to 
replace PPC_INST_LD_TOC instruction with PPC_INST_NOP and that's it.

> It might be because I am not familiar with the code. Or would
> it deserve some comments?

Maybe.

> > +
> > +		if (sym->st_shndx != SHN_UNDEF &&
> > +		    sym->st_shndx != SHN_LIVEPATCH)
> > +			continue;
> > +
> > +		instruction = (u32 *)location;
> > +		if (is_mprofile_mcount_callsite(symname, instruction))
> > +			continue;
> > +
> > +		if (!instr_is_relative_link_branch(*instruction))
> > +			continue;
> > +
> > +		instruction += 1;
> > +		*instruction = PPC_INST_NOP;
> > +	}
> > +}
> > +#endif
> > +
> >  #ifdef CONFIG_DYNAMIC_FTRACE
> >  
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > index ab4a4606d19b..f0b380d2a17a 100644
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -295,6 +295,45 @@ static int klp_write_object_relocations(struct module *pmod,
> >  	return ret;
> >  }
> >  
> > +static void klp_clear_object_relocations(struct module *pmod,
> > +					struct klp_object *obj)
> > +{
> > +	int i, cnt;
> > +	const char *objname, *secname;
> > +	char sec_objname[MODULE_NAME_LEN];
> > +	Elf_Shdr *sec;
> > +
> > +	objname = klp_is_module(obj) ? obj->name : "vmlinux";
> > +
> > +	/* For each klp relocation section */
> > +	for (i = 1; i < pmod->klp_info->hdr.e_shnum; i++) {
> > +		sec = pmod->klp_info->sechdrs + i;
> > +		secname = pmod->klp_info->secstrings + sec->sh_name;
> > +		if (!(sec->sh_flags & SHF_RELA_LIVEPATCH))
> > +			continue;
> > +
> > +		/*
> > +		 * Format: .klp.rela.sec_objname.section_name
> > +		 * See comment in klp_resolve_symbols() for an explanation
> > +		 * of the selected field width value.
> > +		 */
> > +		secname = pmod->klp_info->secstrings + sec->sh_name;
> > +		cnt = sscanf(secname, ".klp.rela.%55[^.]", sec_objname);
> > +		if (cnt != 1) {
> > +			pr_err("section %s has an incorrectly formatted name\n",
> > +			       secname);
> > +			continue;
> > +		}
> > +
> > +		if (strcmp(objname, sec_objname))
> > +			continue;
> > +
> 
> It would make the review easier when the order of 1st and 2nd
> patch was swaped. I mean that I would not need to check twice
> that the two functions actually share the same code.

Ok.
 
> > +		clear_relocate_add(pmod->klp_info->sechdrs,
> > +				   pmod->core_kallsyms.strtab,
> > +				   pmod->klp_info->symndx, i, pmod);
> > +	}
> > +}
> > +
> >  /*
> >   * Sysfs Interface
> >   *
> 
> I was not able to check correctness of the ppc and s390 parts.
> Otherwise, it looks good to me.

Thanks
Miroslav
