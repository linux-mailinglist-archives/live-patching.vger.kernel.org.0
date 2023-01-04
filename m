Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258F465DB4E
	for <lists+live-patching@lfdr.de>; Wed,  4 Jan 2023 18:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjADRfA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 Jan 2023 12:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239749AbjADRep (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 Jan 2023 12:34:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163D739F89
        for <live-patching@vger.kernel.org>; Wed,  4 Jan 2023 09:34:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FEF2617CB
        for <live-patching@vger.kernel.org>; Wed,  4 Jan 2023 17:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC28DC433EF
        for <live-patching@vger.kernel.org>; Wed,  4 Jan 2023 17:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672853680;
        bh=2qfKFj1rNu9AKaKm7p6M3NrWlptbeWSYWn408HFguKw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=p1iK7JBa2mvjG35DleR97f9ycZ/zmmtfeqcgjUVUBlsOjXvEJbBgcASPJGLyZ+5MY
         dfVV/r6Qmo/Y21WG0YxdvHs3epeVkFVsYRUmao+dlbf6r3bHCg5jYftqsqsjnTGCNZ
         I1Y57xdzUWQL5I9i1iMDjMOKvuYwj/3ask1gJZLeePNHapfL3/ypN7cKZ64m0QP80o
         djcX7dEtM/yKZbHKpZqHFmfI01xo+5xMh8XGEFAWCq5Vxib3e3XCDHbozfnp1szhET
         e7nFHTrC8k8t4GGGV6kU/mr3oTg1fMwbxZd9nMfyo3c+hdIoZTCH0i9iii3F0tqGGC
         HZUoUs4czKFZw==
Received: by mail-lj1-f181.google.com with SMTP id bn6so26274318ljb.13
        for <live-patching@vger.kernel.org>; Wed, 04 Jan 2023 09:34:40 -0800 (PST)
X-Gm-Message-State: AFqh2kqdZRgIdr15RRnyK6jbas4+3+45es2ExHe9yGIy2pIl7B+s55de
        JnrnDe7Rk+Nm6dv/EV2p0CWIxznW8Bi8pXQYV5o=
X-Google-Smtp-Source: AMrXdXtVmP8SiA5JuxG2RbNSVxtTlOStqY/2c+gr84YL13pwUj998yqFB4fv3Zwxq9ZQKrxH+hvaFkjVY5hlyRYoUag=
X-Received: by 2002:a2e:8018:0:b0:27f:bf70:e55b with SMTP id
 j24-20020a2e8018000000b0027fbf70e55bmr1411912ljg.421.1672853678918; Wed, 04
 Jan 2023 09:34:38 -0800 (PST)
MIME-Version: 1.0
References: <20221214174035.1012183-1-song@kernel.org> <Y7VUPAEFFFougaoC@alley>
In-Reply-To: <Y7VUPAEFFFougaoC@alley>
From:   Song Liu <song@kernel.org>
Date:   Wed, 4 Jan 2023 09:34:25 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7EAFgUUgh3Q6wbE-PNLGnSFFWmdQaYfOqVW6adM0+G4g@mail.gmail.com>
Message-ID: <CAPhsuW7EAFgUUgh3Q6wbE-PNLGnSFFWmdQaYfOqVW6adM0+G4g@mail.gmail.com>
Subject: Re: [PATCH v7] livepatch: Clear relocation targets on a module removal
To:     Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, joe.lawrence@redhat.com,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jan 4, 2023 at 2:26 AM Petr Mladek <pmladek@suse.com> wrote:
>
> On Wed 2022-12-14 09:40:35, Song Liu wrote:
> > From: Miroslav Benes <mbenes@suse.cz>
> >
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
> > We thus decided to reverse the relocation patching (clear all relocation
> > targets on x86_64). The solution is not
> > universal and is too much arch-specific, but it may prove to be simpler
> > in the end.
> >
> > --- a/arch/powerpc/kernel/module_64.c
> > +++ b/arch/powerpc/kernel/module_64.c
> > @@ -739,6 +739,67 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
> >       return 0;
> >  }
> >
> > +#ifdef CONFIG_LIVEPATCH
> > +void clear_relocate_add(Elf64_Shdr *sechdrs,
> > +                    const char *strtab,
> > +                    unsigned int symindex,
> > +                    unsigned int relsec,
> > +                    struct module *me)
> > +{
> > +     unsigned int i;
> > +     Elf64_Rela *rela = (void *)sechdrs[relsec].sh_addr;
> > +     Elf64_Sym *sym;
> > +     unsigned long *location;
> > +     const char *symname;
> > +     u32 *instruction;
> > +
> > +     pr_debug("Clearing ADD relocate section %u to %u\n", relsec,
> > +              sechdrs[relsec].sh_info);
> > +
> > +     for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rela); i++) {
> > +             location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
> > +                     + rela[i].r_offset;
> > +             sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
> > +                     + ELF64_R_SYM(rela[i].r_info);
> > +             symname = me->core_kallsyms.strtab
> > +                     + sym->st_name;
> > +
> > +             if (ELF64_R_TYPE(rela[i].r_info) != R_PPC_REL24)
> > +                     continue;
>
> Is it OK to continue?
>
> IMHO, we should at least warn here. It means that the special elf
> section contains a relocation that we are not able to clear. It will
> most likely blow up when we try to load the livepatched module
> again.
>
> > +             /*
> > +              * reverse the operations in apply_relocate_add() for case
> > +              * R_PPC_REL24.
> > +              */
> > +             if (sym->st_shndx != SHN_UNDEF &&
> > +                 sym->st_shndx != SHN_LIVEPATCH)
> > +                     continue;
>
> Same here. IMHO, we should warn when the section contains something
> that we are not able to clear.
>
> > +             /* skip mprofile and ftrace calls, same as restore_r2() */
> > +             if (is_mprofile_ftrace_call(symname))
> > +                     continue;
>
> Is this correct? restore_r2() returns "1" in this case. As a result
> apply_relocate_add() returns immediately with -ENOEXEC. IMHO, we
> should print a warning and return as well.
>
> > +             instruction = (u32 *)location;
> > +             /* skip sibling call, same as restore_r2() */
> > +             if (!instr_is_relative_link_branch(ppc_inst(*instruction)))
> > +                     continue;
>
> Same here. restore_r2() returns '1' in this case...
>
> > +
> > +             instruction += 1;
> > +             /*
> > +              * Patch location + 1 back to NOP so the next
> > +              * apply_relocate_add() call (reload the module) will not
> > +              * fail the sanity check in restore_r2():
> > +              *
> > +              *         if (*instruction != PPC_RAW_NOP()) {
> > +              *             pr_err(...);
> > +              *             return 0;
> > +              *         }
> > +              */
> > +             patch_instruction(instruction, ppc_inst(PPC_RAW_NOP()));
> > +     }
>
> This seems incomplete. The above code reverts patch_instruction() called
> from restore_r2(). But there is another patch_instruction() called in
> apply_relocate_add() for case R_PPC_REL24. IMHO, we should revert this
> as well.
>
> > +}
> > +#endif
>
> IMHO, this approach is really bad. The function is not maintainable.
> It will be very hard to keep it in sync with apply_relocate_add().
> And all the mistakes are just a proof.

I don't really think the above are mistakes. This should be the same
as the version that passed Joe's tests. (I didn't test it myself).

>
> IMHO, the only sane way is to avoid the code duplication.

I think this falls back to the question that do we want
clear_relocate_add() to
   1) undo everything by apply_relocate_add();
or
   2) make sure the next apply_relocate_add() succeeds.

Current version does 2). If we want to share a lot of code
between apply_ and clear_, we need to go with 1). Do we
want something like:

                /* `Everything is relative'. */
                value = sym->st_value + rela[i].r_addend;
                if (!apply)
                        value = 0;

                switch (ELF64_R_TYPE(rela[i].r_info)) {
                case R_PPC64_ADDR32:
                        /* Simply set it */
                        *(u32 *)location = value;
                        break;

                case R_PPC64_ADDR64:
                        /* Simply set it */
                        *(unsigned long *)location = value;
                        break;

                case R_PPC64_TOC:
                       value = apply ? my_r2(sechdrs, me) : 0;
                        *(unsigned long *)location = value;
                        break;
... (a lot more).

Actually, since R_PPC64_ADDR32 etc. don't cause
the next apply_ to fail, we can make clear_ to the same
thing as apply_ (write the same value again).

These approaches don't look better to me. But I am ok
with any of them. Please just let me know which one is
most preferable:

a. current version;
b. clear_ undo everything of apply_ (the sample code
   above)
c. clear_ undo R_PPC_REL24, but _redo_ everything
   of apply_ for other ELF64_R_TYPEs. (should be
  clearer code than option b).

btw: undo the follow logic for R_PPC_REL24 alone is
not really easy (for me)

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
                                                        (u32
*)location + 1, me))
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
                        value = (*(uint32_t *)location & ~PPC_LI_MASK)
| PPC_LI(value);

                        if (patch_instruction((u32 *)location, ppc_inst(value)))
                                return -EFAULT;

                        break;

Thanks,
Song
