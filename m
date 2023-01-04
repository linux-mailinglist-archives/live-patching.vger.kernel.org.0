Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338DB65E0C9
	for <lists+live-patching@lfdr.de>; Thu,  5 Jan 2023 00:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjADXN5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 Jan 2023 18:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235015AbjADXNu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 Jan 2023 18:13:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE13347311
        for <live-patching@vger.kernel.org>; Wed,  4 Jan 2023 15:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672873971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fHtHb5ikEKIZxkQUnt0d0HB7KnRrvdlr4sFNm/RiHsU=;
        b=haSJ3ZRUX7qWieh4arbxIRH1Pk7yZWcFd5krdoZ5eevoGzAsM0A66csQ7y44XYz2ZQmSI3
        vZDbWVIyNoTVv+fXN97SLNueKEHbELGxKiIT7wsasVVRK61ZRsAMJIgy5eEYIGtoGTOxIS
        4FqbwXmJA7yke0TUxO+Y7ddbJrgaaIM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-245-zInoduwsNvWsw-oY8SBalw-1; Wed, 04 Jan 2023 18:12:47 -0500
X-MC-Unique: zInoduwsNvWsw-oY8SBalw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32C178028B0;
        Wed,  4 Jan 2023 23:12:47 +0000 (UTC)
Received: from redhat.com (unknown [10.22.34.179])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C516F40C945A;
        Wed,  4 Jan 2023 23:12:46 +0000 (UTC)
Date:   Wed, 4 Jan 2023 18:12:45 -0500
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Song Liu <song@kernel.org>
Cc:     Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org,
        jpoimboe@kernel.org, jikos@kernel.org,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v7] livepatch: Clear relocation targets on a module
 removal
Message-ID: <Y7YH7SwveCyNPxWC@redhat.com>
References: <20221214174035.1012183-1-song@kernel.org>
 <Y7VUPAEFFFougaoC@alley>
 <CAPhsuW7EAFgUUgh3Q6wbE-PNLGnSFFWmdQaYfOqVW6adM0+G4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW7EAFgUUgh3Q6wbE-PNLGnSFFWmdQaYfOqVW6adM0+G4g@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_FILL_THIS_FORM_SHORT
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jan 04, 2023 at 09:34:25AM -0800, Song Liu wrote:
> On Wed, Jan 4, 2023 at 2:26 AM Petr Mladek <pmladek@suse.com> wrote:
> >
> > On Wed 2022-12-14 09:40:35, Song Liu wrote:
> > > From: Miroslav Benes <mbenes@suse.cz>
> > >
> > > Josh reported a bug:
> > >
> > >   When the object to be patched is a module, and that module is
> > >   rmmod'ed and reloaded, it fails to load with:
> > >
> > >   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
> > >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> > >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> > >
> > >   The livepatch module has a relocation which references a symbol
> > >   in the _previous_ loading of nfsd. When apply_relocate_add()
> > >   tries to replace the old relocation with a new one, it sees that
> > >   the previous one is nonzero and it errors out.
> > >
> > > We thus decided to reverse the relocation patching (clear all relocation
> > > targets on x86_64). The solution is not
> > > universal and is too much arch-specific, but it may prove to be simpler
> > > in the end.
> > >
> > > --- a/arch/powerpc/kernel/module_64.c
> > > +++ b/arch/powerpc/kernel/module_64.c
> > > @@ -739,6 +739,67 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
> > >       return 0;
> > >  }
> > >
> > > +#ifdef CONFIG_LIVEPATCH
> > > +void clear_relocate_add(Elf64_Shdr *sechdrs,
> > > +                    const char *strtab,
> > > +                    unsigned int symindex,
> > > +                    unsigned int relsec,
> > > +                    struct module *me)
> > > +{
> > > +     unsigned int i;
> > > +     Elf64_Rela *rela = (void *)sechdrs[relsec].sh_addr;
> > > +     Elf64_Sym *sym;
> > > +     unsigned long *location;
> > > +     const char *symname;
> > > +     u32 *instruction;
> > > +
> > > +     pr_debug("Clearing ADD relocate section %u to %u\n", relsec,
> > > +              sechdrs[relsec].sh_info);
> > > +
> > > +     for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rela); i++) {
> > > +             location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
> > > +                     + rela[i].r_offset;
> > > +             sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
> > > +                     + ELF64_R_SYM(rela[i].r_info);
> > > +             symname = me->core_kallsyms.strtab
> > > +                     + sym->st_name;
> > > +
> > > +             if (ELF64_R_TYPE(rela[i].r_info) != R_PPC_REL24)
> > > +                     continue;
> >
> > Is it OK to continue?
> >
> > IMHO, we should at least warn here. It means that the special elf
> > section contains a relocation that we are not able to clear. It will
> > most likely blow up when we try to load the livepatched module
> > again.
> >
> > > +             /*
> > > +              * reverse the operations in apply_relocate_add() for case
> > > +              * R_PPC_REL24.
> > > +              */
> > > +             if (sym->st_shndx != SHN_UNDEF &&
> > > +                 sym->st_shndx != SHN_LIVEPATCH)
> > > +                     continue;
> >
> > Same here. IMHO, we should warn when the section contains something
> > that we are not able to clear.
> >
> > > +             /* skip mprofile and ftrace calls, same as restore_r2() */
> > > +             if (is_mprofile_ftrace_call(symname))
> > > +                     continue;
> >
> > Is this correct? restore_r2() returns "1" in this case. As a result
> > apply_relocate_add() returns immediately with -ENOEXEC. IMHO, we
> > should print a warning and return as well.
> >
> > > +             instruction = (u32 *)location;
> > > +             /* skip sibling call, same as restore_r2() */
> > > +             if (!instr_is_relative_link_branch(ppc_inst(*instruction)))
> > > +                     continue;
> >
> > Same here. restore_r2() returns '1' in this case...
> >
> > > +
> > > +             instruction += 1;
> > > +             /*
> > > +              * Patch location + 1 back to NOP so the next
> > > +              * apply_relocate_add() call (reload the module) will not
> > > +              * fail the sanity check in restore_r2():
> > > +              *
> > > +              *         if (*instruction != PPC_RAW_NOP()) {
> > > +              *             pr_err(...);
> > > +              *             return 0;
> > > +              *         }
> > > +              */
> > > +             patch_instruction(instruction, ppc_inst(PPC_RAW_NOP()));
> > > +     }
> >
> > This seems incomplete. The above code reverts patch_instruction() called
> > from restore_r2(). But there is another patch_instruction() called in
> > apply_relocate_add() for case R_PPC_REL24. IMHO, we should revert this
> > as well.
> >
> > > +}
> > > +#endif
> >
> > IMHO, this approach is really bad. The function is not maintainable.
> > It will be very hard to keep it in sync with apply_relocate_add().
> > And all the mistakes are just a proof.
> 
> I don't really think the above are mistakes. This should be the same
> as the version that passed Joe's tests. (I didn't test it myself).
> 
> >
> > IMHO, the only sane way is to avoid the code duplication.
> 
> I think this falls back to the question that do we want
> clear_relocate_add() to
>    1) undo everything by apply_relocate_add();
> or
>    2) make sure the next apply_relocate_add() succeeds.
> 

This is a really good question and I think relates to your follow up
question to my earlier reply, "What's the failure like if we don't
handle R_PPC64_ADDR64 and R_PPC64_REL64?"

If the code only needs to accomplish (2), then the incoming patch simply
overwrites old relocation values.  If we prefer (1), then needs to do
the full reversal on unload.

Stepping back, this feature is definitely foot-gun capable.
Kpatch-build would expect that klp-relocations would only ever be needed
in code that will patch the very same module that provides the
relocation destination -- that is, it was never intended to reference
through one of these klp-relocations unless it resolved to a live
module.

On the other hand, when writing the selftests, verifying against NULL
[1] provided 1) a quick sanity check that something was "cleared" and 2)
protected the machine against said foot-gun.

[1] https://github.com/joe-lawrence/klp-convert-tree/commit/643acbb8f4c0240030b45b64a542d126370d3e6c

> Current version does 2). If we want to share a lot of code
> between apply_ and clear_, we need to go with 1). Do we
> want something like:
> 
>                 /* `Everything is relative'. */
>                 value = sym->st_value + rela[i].r_addend;
>                 if (!apply)
>                         value = 0;
> 
>                 switch (ELF64_R_TYPE(rela[i].r_info)) {
>                 case R_PPC64_ADDR32:
>                         /* Simply set it */
>                         *(u32 *)location = value;
>                         break;
> 
>                 case R_PPC64_ADDR64:
>                         /* Simply set it */
>                         *(unsigned long *)location = value;
>                         break;
> 
>                 case R_PPC64_TOC:
>                        value = apply ? my_r2(sechdrs, me) : 0;
>                         *(unsigned long *)location = value;
>                         break;
> ... (a lot more).
> 
> Actually, since R_PPC64_ADDR32 etc. don't cause
> the next apply_ to fail, we can make clear_ to the same
> thing as apply_ (write the same value again).
> 
> These approaches don't look better to me. But I am ok
> with any of them. Please just let me know which one is
> most preferable:
> 
> a. current version;
> b. clear_ undo everything of apply_ (the sample code
>    above)
> c. clear_ undo R_PPC_REL24, but _redo_ everything
>    of apply_ for other ELF64_R_TYPEs. (should be
>   clearer code than option b).
> 

This was my attempt at combining and slightly refactoring the power64
version.  There is so much going on here I was tempted to split off it
into separate value assignment and write functions.  Some changes I
liked, but I wasn't all too happy with the result.  Also, as you
mention, completely undoing R_PPC_REL24 is less than trivial... for this
arch, there are basically three major tasks:

  1) calculate the new value, including range checking
  2) special constructs created by restore_r2 / create_stub
  3) writing out the value

and many cases are similar, but subtly different enough to avoid easy
code consolidation.


static int write_relocate_add(Elf64_Shdr *sechdrs,
		   const char *strtab,
		   unsigned int symindex,
		   unsigned int relsec,
		   struct module *me,
		   bool apply)
{
	unsigned int i;
	Elf64_Rela *rela = (void *)sechdrs[relsec].sh_addr;
	Elf64_Sym *sym;
	unsigned long *location;
	unsigned long value;

	pr_debug("Applying ADD relocate section %u to %u\n", relsec,
	       sechdrs[relsec].sh_info);

	/* First time we're called, we can fix up .TOC. */
	if (!me->arch.toc_fixed) {
		sym = find_dot_toc(sechdrs, strtab, symindex);
		/* It's theoretically possible that a module doesn't want a
		 * .TOC. so don't fail it just for that. */
		if (sym)
			sym->st_value = my_r2(sechdrs, me);
		me->arch.toc_fixed = true;
	}

	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rela); i++) {
		/* This is where to make the change */
		location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
			+ rela[i].r_offset;
		/* This is the symbol it is referring to */
		sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
			+ ELF64_R_SYM(rela[i].r_info);

		pr_debug("RELOC at %p: %li-type as %s (0x%lx) + %li\n",
		       location, (long)ELF64_R_TYPE(rela[i].r_info),
		       strtab + sym->st_name, (unsigned long)sym->st_value,
		       (long)rela[i].r_addend);

		/* Calculate value (or zero if clearing) */
		if (apply) {

			/* `Everything is relative'. */
			value = sym->st_value + rela[i].r_addend;

			switch (ELF64_R_TYPE(rela[i].r_info)) {
			case R_PPC64_TOC16:
				/* Subtract TOC pointer */
				value -= my_r2(sechdrs, me);
				if (value + 0x8000 > 0xffff) {
					pr_err("%s: bad TOC16 relocation (0x%lx)\n",
					       me->name, value);
					return -ENOEXEC;
				}
				break;

			case R_PPC64_TOC16_LO:
				/* Subtract TOC pointer */
				value -= my_r2(sechdrs, me);
				value = (*((uint16_t *) location) & ~0xffff) |
					(value & 0xffff);
				break;

			case R_PPC64_TOC16_DS:
				/* Subtract TOC pointer */
				value -= my_r2(sechdrs, me);
				if ((value & 3) != 0 || value + 0x8000 > 0xffff) {
					pr_err("%s: bad TOC16_DS relocation (0x%lx)\n",
					       me->name, value);
					return -ENOEXEC;
				}
				value = (*((uint16_t *) location) & ~0xfffc) |
					(value & 0xfffc);
				break;

			case R_PPC64_TOC16_LO_DS:
				/* Subtract TOC pointer */
				value -= my_r2(sechdrs, me);
				if ((value & 3) != 0) {
					pr_err("%s: bad TOC16_LO_DS relocation (0x%lx)\n",
					       me->name, value);
					return -ENOEXEC;
				}
				value = (*((uint16_t *) location) & ~0xfffc) |
					(value & 0xfffc);
				break;

			case R_PPC64_TOC16_HA:
				/* Subtract TOC pointer */
				value -= my_r2(sechdrs, me);
				value = ((value + 0x8000) >> 16);
				value = (*((uint16_t *) location) & ~0xffff) |
					(value & 0xffff);
				break;

			case R_PPC_REL24:
				/* FIXME: Handle weak symbols here --RR */
				if (sym->st_shndx == SHN_UNDEF ||
				    sym->st_shndx == SHN_LIVEPATCH) {
					/* External: go via stub */
					value = stub_for_addr(sechdrs, value, me,
							strtab + sym->st_name);
					if (!value)
						return -ENOENT;
					if (!restore_r2(strtab + sym->st_name,
								(u32 *)location + 1, me))
						return -ENOEXEC;
				} else
					value += local_entry_offset(sym);

				/* Convert value to relative */
				value -= (unsigned long)location;
				if (value + 0x2000000 > 0x3ffffff || (value & 3) != 0){
					pr_err("%s: REL24 %li out of range!\n",
					       me->name, (long int)value);
					return -ENOEXEC;
				}

				/* Only replace bits 2 through 26 */
				value = (*(uint32_t *)location & ~PPC_LI_MASK) | PPC_LI(value);
				break;

			case R_PPC64_REL64:
				/* 64 bits relative (used by features fixups) */
				value -= (unsigned long)location;
				break;

			case R_PPC64_REL32:
				/* 32 bits relative (used by relative exception tables) */
				value -= (unsigned long)location;
				if (value + 0x80000000 > 0xffffffff) {
					pr_err("%s: REL32 %li out of range!\n",
					       me->name, (long int)value);
					return -ENOEXEC;
				}
				break;

			case R_PPC64_ENTRY:
				/*
				 * Optimize ELFv2 large code model entry point if
				 * the TOC is within 2GB range of current location.
				 */
				value = my_r2(sechdrs, me) - (unsigned long)location;
				if (value + 0x80008000 > 0xffffffff)
					break; /* JL TODO: this should be a continue? */
				break;

			case R_PPC64_REL16_HA:
				/* Subtract location pointer */
				value -= (unsigned long)location;
				value = ((value + 0x8000) >> 16);
				value = (*((uint16_t *) location) & ~0xffff) |
					(value & 0xffff);
				break;

			case R_PPC64_REL16_LO:
				/* Subtract location pointer */
				value -= (unsigned long)location;
				value = (*((uint16_t *) location) & ~0xffff) |
					(value & 0xffff);
				break;
			}
		} else {
			if (ELF64_R_TYPE(rela[i].r_info) == R_PPC_REL24) {
				/* skip mprofile and ftrace calls, same as restore_r2() */
				if (is_mprofile_ftrace_call(me->core_kallsyms.strtab + sym->st_name))
					continue;

				/* skip sibling call, same as restore_r2() */
				if (!instr_is_relative_link_branch(ppc_inst(*(u32 *)location)))
					continue;

				/*
				 * Patch location + 1 back to NOP so the next
				 * apply_relocate_add() call (reload the module) will not
				 * fail the sanity check in restore_r2():
				 *
				 *         if (*instruction != PPC_RAW_NOP()) {
				 *             pr_err(...);
				 *             return 0;
				 *         }
				 */
				location = (unsigned long *)((u32 *)location + 1);
				value = PPC_RAW_NOP();
			} else {
				value = 0UL;
			}
		}

		/* Apply/clear relocation value */
		switch (ELF64_R_TYPE(rela[i].r_info)) {
		case R_PPC64_ADDR32:
		case R_PPC64_REL32:
			if (apply && *(u32 *)location != 0)
				goto invalid_relocation;
			/* Simply set it */
			*(u32 *)location = value;
			break;

		case R_PPC64_ADDR64:
			if (apply && *(unsigned long *)location != 0)
				goto invalid_relocation;
			/* Simply set it */
			*(unsigned long *)location = value;
			break;

		case R_PPC64_TOC:
			if (apply && *(unsigned long *)location != 0)
				goto invalid_relocation;
			*(unsigned long *)location = my_r2(sechdrs, me);
			break;

		case R_PPC64_TOC16:
		case R_PPC64_TOC16_LO:
		case R_PPC64_TOC16_HA:
		case R_PPC64_REL16_HA:
		case R_PPC64_REL16_LO:
			if (apply && (*((uint16_t *) location) & 0xffff) != 0)
				goto invalid_relocation;
			*((uint16_t *) location) = value;
			break;

		case R_PPC64_TOC16_DS:
		case R_PPC64_TOC16_LO_DS:
			if (apply && (*((uint16_t *) location) & 0xfffc) != 0)
				goto invalid_relocation;
			*((uint16_t *) location) = value;
			break;

		case R_PPC_REL24:
			/* restore_r2() already checked for invalid relocation */
			if (patch_instruction((u32 *)location, ppc_inst(value)))
				return -EFAULT;
			break;

		case R_PPC64_REL64:
			if (apply && *location != 0)
				goto invalid_relocation;
			/* 64 bits relative (used by features fixups) */
			*location = value;
			break;

		case R_PPC64_TOCSAVE:
			/*
			 * Marker reloc indicates we don't have to save r2.
			 * That would only save us one instruction, so ignore
			 * it.
			 */
			break;

		case R_PPC64_ENTRY:
			/*
			 * Check for the large code model prolog sequence:
		         *	ld r2, ...(r12)
			 *	add r2, r2, r12
			 */
			if ((((uint32_t *)location)[0] & ~0xfffc) != PPC_RAW_LD(_R2, _R12, 0))
				break;
			if (((uint32_t *)location)[1] != PPC_RAW_ADD(_R2, _R2, _R12))
				break;
			/*
			 * If found, replace it with:
			 *	addis r2, r12, (.TOC.-func)@ha
			 *	addi  r2,  r2, (.TOC.-func)@l
			 */
			((uint32_t *)location)[0] = PPC_RAW_ADDIS(_R2, _R12, PPC_HA(value));
			((uint32_t *)location)[1] = PPC_RAW_ADDI(_R2, _R2, PPC_LO(value));
			break;

		default:
			pr_err("%s: Unknown ADD relocation: %lu\n",
			       me->name,
			       (unsigned long)ELF64_R_TYPE(rela[i].r_info));
			return -ENOEXEC;
		}
	}

	return 0;

invalid_relocation:
	pr_err("ppc64le/modules: Skipping invalid relocation target, existing value is nonzero for type %d, location %p, value %lx\n",
	       (int)ELF64_R_TYPE(rela[i].r_info), location, value);
	return -ENOEXEC;

}

> btw: undo the follow logic for R_PPC_REL24 alone is
> not really easy (for me)
> 
>                 case R_PPC_REL24:
>                         /* FIXME: Handle weak symbols here --RR */
>                         if (sym->st_shndx == SHN_UNDEF ||
>                             sym->st_shndx == SHN_LIVEPATCH) {
>                                 /* External: go via stub */
>                                 value = stub_for_addr(sechdrs, value, me,
>                                                 strtab + sym->st_name);
>                                 if (!value)
>                                         return -ENOENT;
>                                 if (!restore_r2(strtab + sym->st_name,
>                                                         (u32
> *)location + 1, me))
>                                         return -ENOEXEC;
>                         } else
>                                 value += local_entry_offset(sym);
> 
>                         /* Convert value to relative */
>                         value -= (unsigned long)location;
>                         if (value + 0x2000000 > 0x3ffffff || (value & 3) != 0){
>                                 pr_err("%s: REL24 %li out of range!\n",
>                                        me->name, (long int)value);
>                                 return -ENOEXEC;
>                         }
> 
>                         /* Only replace bits 2 through 26 */
>                         value = (*(uint32_t *)location & ~PPC_LI_MASK)
> | PPC_LI(value);
> 
>                         if (patch_instruction((u32 *)location, ppc_inst(value)))
>                                 return -EFAULT;
> 
>                         break;
> 

I agree.  I think the only way through it is to refactor it down to
something we do understand first :D   And also settling on our
requirements as you asked about. 

-- Joe

