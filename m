Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F3365D099
	for <lists+live-patching@lfdr.de>; Wed,  4 Jan 2023 11:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbjADK0e (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 Jan 2023 05:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234790AbjADK0J (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 Jan 2023 05:26:09 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5619819C2B
        for <live-patching@vger.kernel.org>; Wed,  4 Jan 2023 02:26:06 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 0F2E8200F5;
        Wed,  4 Jan 2023 10:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1672827965; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X7IBaLw771Z8vQUKTCr4bJTZzbQ0ETCl0BkMtR0mi64=;
        b=kKjPxazvj1P1puyL/E7xwnmEiup4IFXu0Zt9werD0gq7uv0ctmV44sJDsHJD1QEK9MfVig
        iY9EbDSo9nl9qvgkVZ7I6S7X1foZl5G0+KPWKICkTuHrDZdDcNSj/2dpQIGD3AxG57K0le
        TbeLIS4aKz5YcDIHG3VdexAUX5oEJJc=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D69A12C143;
        Wed,  4 Jan 2023 10:26:04 +0000 (UTC)
Date:   Wed, 4 Jan 2023 11:26:04 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, joe.lawrence@redhat.com,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v7] livepatch: Clear relocation targets on a module
 removal
Message-ID: <Y7VUPAEFFFougaoC@alley>
References: <20221214174035.1012183-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214174035.1012183-1-song@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-12-14 09:40:35, Song Liu wrote:
> From: Miroslav Benes <mbenes@suse.cz>
> 
> Josh reported a bug:
> 
>   When the object to be patched is a module, and that module is
>   rmmod'ed and reloaded, it fails to load with:
> 
>   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> 
>   The livepatch module has a relocation which references a symbol
>   in the _previous_ loading of nfsd. When apply_relocate_add()
>   tries to replace the old relocation with a new one, it sees that
>   the previous one is nonzero and it errors out.
> 
> We thus decided to reverse the relocation patching (clear all relocation
> targets on x86_64). The solution is not
> universal and is too much arch-specific, but it may prove to be simpler
> in the end.
> 
> --- a/arch/powerpc/kernel/module_64.c
> +++ b/arch/powerpc/kernel/module_64.c
> @@ -739,6 +739,67 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_LIVEPATCH
> +void clear_relocate_add(Elf64_Shdr *sechdrs,
> +		       const char *strtab,
> +		       unsigned int symindex,
> +		       unsigned int relsec,
> +		       struct module *me)
> +{
> +	unsigned int i;
> +	Elf64_Rela *rela = (void *)sechdrs[relsec].sh_addr;
> +	Elf64_Sym *sym;
> +	unsigned long *location;
> +	const char *symname;
> +	u32 *instruction;
> +
> +	pr_debug("Clearing ADD relocate section %u to %u\n", relsec,
> +		 sechdrs[relsec].sh_info);
> +
> +	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rela); i++) {
> +		location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
> +			+ rela[i].r_offset;
> +		sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
> +			+ ELF64_R_SYM(rela[i].r_info);
> +		symname = me->core_kallsyms.strtab
> +			+ sym->st_name;
> +
> +		if (ELF64_R_TYPE(rela[i].r_info) != R_PPC_REL24)
> +			continue;

Is it OK to continue?

IMHO, we should at least warn here. It means that the special elf
section contains a relocation that we are not able to clear. It will
most likely blow up when we try to load the livepatched module
again.

> +		/*
> +		 * reverse the operations in apply_relocate_add() for case
> +		 * R_PPC_REL24.
> +		 */
> +		if (sym->st_shndx != SHN_UNDEF &&
> +		    sym->st_shndx != SHN_LIVEPATCH)
> +			continue;

Same here. IMHO, we should warn when the section contains something
that we are not able to clear.

> +		/* skip mprofile and ftrace calls, same as restore_r2() */
> +		if (is_mprofile_ftrace_call(symname))
> +			continue;

Is this correct? restore_r2() returns "1" in this case. As a result
apply_relocate_add() returns immediately with -ENOEXEC. IMHO, we
should print a warning and return as well.

> +		instruction = (u32 *)location;
> +		/* skip sibling call, same as restore_r2() */
> +		if (!instr_is_relative_link_branch(ppc_inst(*instruction)))
> +			continue;

Same here. restore_r2() returns '1' in this case...

> +
> +		instruction += 1;
> +		/*
> +		 * Patch location + 1 back to NOP so the next
> +		 * apply_relocate_add() call (reload the module) will not
> +		 * fail the sanity check in restore_r2():
> +		 *
> +		 *         if (*instruction != PPC_RAW_NOP()) {
> +		 *             pr_err(...);
> +		 *             return 0;
> +		 *         }
> +		 */
> +		patch_instruction(instruction, ppc_inst(PPC_RAW_NOP()));
> +	}

This seems incomplete. The above code reverts patch_instruction() called
from restore_r2(). But there is another patch_instruction() called in
apply_relocate_add() for case R_PPC_REL24. IMHO, we should revert this
as well.

> +}
> +#endif

IMHO, this approach is really bad. The function is not maintainable.
It will be very hard to keep it in sync with apply_relocate_add().
And all the mistakes are just a proof.

IMHO, the only sane way is to avoid the code duplication.


>  #ifdef CONFIG_DYNAMIC_FTRACE
>  int module_trampoline_target(struct module *mod, unsigned long addr,
>  			     unsigned long *target)
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -261,6 +261,41 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
>  	return 0;
>  }
>  
> +static int klp_write_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
> +				    const char *shstrtab, const char *strtab,
> +				    unsigned int symndx, unsigned int secndx,
> +				    const char *objname, bool apply)
> +{
> +	int cnt, ret;
> +	char sec_objname[MODULE_NAME_LEN];
> +	Elf_Shdr *sec = sechdrs + secndx;
> +
> +	/*
> +	 * Format: .klp.rela.sec_objname.section_name
> +	 * See comment in klp_resolve_symbols() for an explanation
> +	 * of the selected field width value.
> +	 */
> +	cnt = sscanf(shstrtab + sec->sh_name, ".klp.rela.%55[^.]",
> +		     sec_objname);
> +	if (cnt != 1) {
> +		pr_err("section %s has an incorrectly formatted name\n",
> +		       shstrtab + sec->sh_name);
> +		return -EINVAL;
> +	}
> +
> +	if (strcmp(objname ? objname : "vmlinux", sec_objname))
> +		return 0;
> +
> +	ret = klp_resolve_symbols(sechdrs, strtab, symndx, sec, sec_objname);
> +	if (ret)
> +		return ret;

We do not need to call klp_resolve_symbols() when clearing the relocations.

> +
> +	if (apply)
> +		return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);

Please, add an empty line here.

> +	clear_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
> +	return 0;
> +}
> +
>  /*
>   * At a high-level, there are two types of klp relocation sections: those which
>   * reference symbols which live in vmlinux; and those which reference symbols

Please, keep these comments above klp_write_section_relocs().
It is the function that implements these details and it is
called from more locations.

> @@ -289,31 +324,8 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
>  			     unsigned int symndx, unsigned int secndx,
>  			     const char *objname)
>  {
> -	int cnt, ret;
> -	char sec_objname[MODULE_NAME_LEN];
> -	Elf_Shdr *sec = sechdrs + secndx;
> -
> -	/*
> -	 * Format: .klp.rela.sec_objname.section_name
> -	 * See comment in klp_resolve_symbols() for an explanation
> -	 * of the selected field width value.
> -	 */
> -	cnt = sscanf(shstrtab + sec->sh_name, ".klp.rela.%55[^.]",
> -		     sec_objname);
> -	if (cnt != 1) {
> -		pr_err("section %s has an incorrectly formatted name\n",
> -		       shstrtab + sec->sh_name);
> -		return -EINVAL;
> -	}
> -
> -	if (strcmp(objname ? objname : "vmlinux", sec_objname))
> -		return 0;
> -
> -	ret = klp_resolve_symbols(sechdrs, strtab, symndx, sec, sec_objname);
> -	if (ret)
> -		return ret;
> -
> -	return apply_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
> +	return klp_write_section_relocs(pmod, sechdrs, shstrtab, strtab, symndx,
> +					secndx, objname, true);
>  }
>  
>  /*

Best Regards,
Petr
