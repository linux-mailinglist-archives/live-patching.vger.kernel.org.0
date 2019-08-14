Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36F4B8D32E
	for <lists+live-patching@lfdr.de>; Wed, 14 Aug 2019 14:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfHNMds (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Aug 2019 08:33:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:56832 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726575AbfHNMds (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Aug 2019 08:33:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BAE19AECA;
        Wed, 14 Aug 2019 12:33:46 +0000 (UTC)
Date:   Wed, 14 Aug 2019 14:33:41 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     jikos@kernel.org, jpoimboe@redhat.com, joe.lawrence@redhat.com,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
In-Reply-To: <20190722093314.reobkfhdzqb7ch2d@pathway.suse.cz>
Message-ID: <alpine.LSU.2.21.1908141427560.16696@pobox.suse.cz>
References: <20190719122840.15353-1-mbenes@suse.cz> <20190719122840.15353-3-mbenes@suse.cz> <20190722093314.reobkfhdzqb7ch2d@pathway.suse.cz>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 22 Jul 2019, Petr Mladek wrote:

> On Fri 2019-07-19 14:28:40, Miroslav Benes wrote:
> > Josh reported a bug:
> > 
> >   When the object to be patched is a module, and that module is
> >   rmmod'ed and reloaded, it fails to load with:
> > 
> >   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
> >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> > 
> >   The livepatch module has a relocation which references a symbol
> >   in the _previous_ loading of nfsd. When apply_relocate_add()
> >   tries to replace the old relocation with a new one, it sees that
> >   the previous one is nonzero and it errors out.
> > 
> >   On ppc64le, we have a similar issue:
> > 
> >   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
> >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> > 
> > He also proposed three different solutions. We could remove the error
> > check in apply_relocate_add() introduced by commit eda9cec4c9a1
> > ("x86/module: Detect and skip invalid relocations"). However the check
> > is useful for detecting corrupted modules.
> > 
> > We could also deny the patched modules to be removed. If it proved to be
> > a major drawback for users, we could still implement a different
> > approach. The solution would also complicate the existing code a lot.
> > 
> > We thus decided to reverse the relocation patching (clear all relocation
> > targets on x86_64, or return back nops on powerpc). The solution is not
> > universal and is too much arch-specific, but it may prove to be simpler
> > in the end.
> > 
> > Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> > ---
> >  arch/powerpc/kernel/Makefile    |  1 +
> >  arch/powerpc/kernel/livepatch.c | 75 +++++++++++++++++++++++++++++++++
> >  arch/powerpc/kernel/module.h    | 15 +++++++
> >  arch/powerpc/kernel/module_64.c |  7 +--
> >  arch/x86/kernel/livepatch.c     | 67 +++++++++++++++++++++++++++++
> >  include/linux/livepatch.h       |  5 +++
> >  kernel/livepatch/core.c         | 17 +++++---
> >  7 files changed, 176 insertions(+), 11 deletions(-)
> >  create mode 100644 arch/powerpc/kernel/livepatch.c
> >  create mode 100644 arch/powerpc/kernel/module.h
> > 
> > diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
> > index 0ea6c4aa3a20..639000f78dc3 100644
> > --- a/arch/powerpc/kernel/Makefile
> > +++ b/arch/powerpc/kernel/Makefile
> > @@ -154,6 +154,7 @@ endif
> >  
> >  obj-$(CONFIG_EPAPR_PARAVIRT)	+= epapr_paravirt.o epapr_hcalls.o
> >  obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvm_emul.o
> > +obj-$(CONFIG_LIVEPATCH)	+= livepatch.o
> >  
> >  # Disable GCOV, KCOV & sanitizers in odd or sensitive code
> >  GCOV_PROFILE_prom_init.o := n
> > diff --git a/arch/powerpc/kernel/livepatch.c b/arch/powerpc/kernel/livepatch.c
> > new file mode 100644
> > index 000000000000..6f2468c60695
> > --- /dev/null
> > +++ b/arch/powerpc/kernel/livepatch.c
> > @@ -0,0 +1,75 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/*
> > + * livepatch.c - powerpc-specific Kernel Live Patching Core
> > + */
> > +
> > +#include <linux/livepatch.h>
> > +#include <asm/code-patching.h>
> > +#include "module.h"
> > +
> > +void arch_klp_free_object_loaded(struct klp_patch *patch,
> > +				 struct klp_object *obj)
> 
> If I get it correctly then this functions reverts changes done by
> klp_write_object_relocations(). Therefore it should get called
> klp_clear_object_relocations() or so.

Good point. Especially when we want to split the function to 
arch-independent and arch-specific parts.
 
> There is also arch_klp_init_object_loaded() but it does different
> things, for example it applies alternatives or paravirt instructions.
> Do we need to revert these as well?

No, I don't think so. They should not change because the patch module 
stays loaded.
 
> > +{
> > +	const char *objname, *secname, *symname;
> > +	char sec_objname[MODULE_NAME_LEN];
> > +	struct klp_modinfo *info;
> > +	Elf64_Shdr *s;
> > +	Elf64_Rela *rel;
> > +	Elf64_Sym *sym;
> > +	void *loc;
> > +	u32 *instruction;
> > +	int i, cnt;
> > +
> > +	info = patch->mod->klp_info;
> > +	objname = klp_is_module(obj) ? obj->name : "vmlinux";
> > +
> > +	/* See livepatch core code for BUILD_BUG_ON() explanation */
> > +	BUILD_BUG_ON(MODULE_NAME_LEN < 56 || KSYM_NAME_LEN != 128);
> > +
> > +	/* For each klp relocation section */
> > +	for (s = info->sechdrs; s < info->sechdrs + info->hdr.e_shnum; s++) {
> > +		if (!(s->sh_flags & SHF_RELA_LIVEPATCH))
> > +			continue;
> > +
> > +		/*
> > +		 * Format: .klp.rela.sec_objname.section_name
> > +		 */
> > +		secname = info->secstrings + s->sh_name;
> > +		cnt = sscanf(secname, ".klp.rela.%55[^.]", sec_objname);
> > +		if (cnt != 1) {
> > +			pr_err("section %s has an incorrectly formatted name\n",
> > +			       secname);
> > +			continue;
> > +		}
> > +
> > +		if (strcmp(objname, sec_objname))
> > +			continue;
> 
> The above code seems to be arch-independent. Please, move it into
> klp_clear_object_relocations() or so.

Yes.
 
> > +		rel = (void *)s->sh_addr;
> > +		for (i = 0; i < s->sh_size / sizeof(*rel); i++) {
> > +			loc = (void *)info->sechdrs[s->sh_info].sh_addr
> > +				+ rel[i].r_offset;
> > +			sym = (Elf64_Sym *)info->sechdrs[info->symndx].sh_addr
> > +				+ ELF64_R_SYM(rel[i].r_info);
> > +			symname = patch->mod->core_kallsyms.strtab
> > +				+ sym->st_name;
> > +
> > +			if (ELF64_R_TYPE(rel[i].r_info) != R_PPC_REL24)
> > +				continue;
> > +
> > +			if (sym->st_shndx != SHN_UNDEF &&
> > +			    sym->st_shndx != SHN_LIVEPATCH)
> > +				continue;
> 
> The above check is livepatch-specific. But in principle, this should
> revert changes done by apply_relocate_add(). I would implement
> apply_relocation_clear() or apply_relocation_del() or ...
> and call it from the generic klp_clear_object_relocations().
> 
> The code should be put into the same source files as
> apply_relocate_add(). It will increase the chance that
> any changes will be in sync.

Yes, it would be more consistent. It also shows how much code have to be 
introduced to fix the issue :/
 
> Of course, it is possible that there was a reason for the
> livepatch-specific filtering that I am not aware of.
> 
> > +
> > +			instruction = (u32 *)loc;
> > +			if (is_mprofile_mcount_callsite(symname, instruction))
> > +				continue;
> > +
> > +			if (!instr_is_relative_link_branch(*instruction))
> > +				continue;
> > +
> > +			instruction += 1;
> > +			*instruction = PPC_INST_NOP;
> > +		}
> > +	}
> > +}
> 
> Otherwise, this approach looks fine to me. I believe that this area
> is pretty stable and the maintenance should be rather cheap.

Thanks for the review. I'll try to fix the first approach (which denies 
the modules to be removed) now so we can compare.

Miroslav
