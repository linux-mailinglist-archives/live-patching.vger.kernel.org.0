Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5ED65E553
	for <lists+live-patching@lfdr.de>; Thu,  5 Jan 2023 07:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbjAEF7o (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Jan 2023 00:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbjAEF7a (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Jan 2023 00:59:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2369F48824
        for <live-patching@vger.kernel.org>; Wed,  4 Jan 2023 21:59:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7035F618E1
        for <live-patching@vger.kernel.org>; Thu,  5 Jan 2023 05:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6A2C433F1
        for <live-patching@vger.kernel.org>; Thu,  5 Jan 2023 05:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672898367;
        bh=nC4Hh5t53cA5M5d5RFWClA70SFkEp+egESOgILpE+rY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=d9U8qZ9D4SmbqvvzZUOZkxYPB7AS9O92TuRa1D/7zSDh8+PHP8CfPnoKSVPlazz70
         pINtfCls5GjtgDh+/tVIkQx+GRdJHbdvPOe1IjbL5uYkcCNWDqXTsUQ/iBrGCC38Tf
         CCR5x/ZHkc6R7uRTg+kgbfTkEPzEXtuXHvBAOZ9FNmDrYdt+/ON+wTpQsP5fAX808i
         ZLQmFDt+jE4vYxZGmeSiIDjrc8/Sszw0JxVMAl6NyL9Z/tYH1ft9eHHqoMqNm+6Fm2
         H3UxGn0abjjno8AiF5sCJ67NaxY7eGcqUremTiQN0jfEIT9W/LahUGXBffBSaFuQUV
         bZ2vm3Hf6PXNw==
Received: by mail-lf1-f52.google.com with SMTP id f34so53624989lfv.10
        for <live-patching@vger.kernel.org>; Wed, 04 Jan 2023 21:59:27 -0800 (PST)
X-Gm-Message-State: AFqh2kpp1+hxz4xfTzNrszL5pCWowO700CUrsZQWUfNO6fHWf3K66KaZ
        bAGtvycX7yLqC4DdZLGWvLUnsSxCF1alrqfeiK4=
X-Google-Smtp-Source: AMrXdXvsqJin81rGbzoo9YcaXufmuWKMEfEK/rHePUSsvG+xcVXW/DFlin5glodlv/VY/ZVoroeceKPMQs97PPRIQe0=
X-Received: by 2002:a05:6512:3f07:b0:4ca:f873:7cf3 with SMTP id
 y7-20020a0565123f0700b004caf8737cf3mr3315723lfa.89.1672898365753; Wed, 04 Jan
 2023 21:59:25 -0800 (PST)
MIME-Version: 1.0
References: <20221214174035.1012183-1-song@kernel.org> <Y7VUPAEFFFougaoC@alley>
 <CAPhsuW7EAFgUUgh3Q6wbE-PNLGnSFFWmdQaYfOqVW6adM0+G4g@mail.gmail.com> <Y7YH7SwveCyNPxWC@redhat.com>
In-Reply-To: <Y7YH7SwveCyNPxWC@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 4 Jan 2023 21:59:13 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6tje3AN+7mw73uQBO8N=cu=w=7a7wTJ5eeCMV-HS0KSg@mail.gmail.com>
Message-ID: <CAPhsuW6tje3AN+7mw73uQBO8N=cu=w=7a7wTJ5eeCMV-HS0KSg@mail.gmail.com>
Subject: Re: [PATCH v7] livepatch: Clear relocation targets on a module removal
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org,
        jpoimboe@kernel.org, jikos@kernel.org,
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

On Wed, Jan 4, 2023 at 3:12 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>
> On Wed, Jan 04, 2023 at 09:34:25AM -0800, Song Liu wrote:
> > On Wed, Jan 4, 2023 at 2:26 AM Petr Mladek <pmladek@suse.com> wrote:
> > >
> > > On Wed 2022-12-14 09:40:35, Song Liu wrote:
> > > > From: Miroslav Benes <mbenes@suse.cz>
> > > >
> > > > Josh reported a bug:
> > > >
> > > >   When the object to be patched is a module, and that module is
> > > >   rmmod'ed and reloaded, it fails to load with:
> > > >
> > > >   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
> > > >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> > > >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> > > >
> > > >   The livepatch module has a relocation which references a symbol
> > > >   in the _previous_ loading of nfsd. When apply_relocate_add()
> > > >   tries to replace the old relocation with a new one, it sees that
> > > >   the previous one is nonzero and it errors out.
> > > >
> > > > We thus decided to reverse the relocation patching (clear all relocation
> > > > targets on x86_64). The solution is not
> > > > universal and is too much arch-specific, but it may prove to be simpler
> > > > in the end.
> > > >
> > > > --- a/arch/powerpc/kernel/module_64.c
> > > > +++ b/arch/powerpc/kernel/module_64.c
> > > > @@ -739,6 +739,67 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
> > > >       return 0;
> > > >  }
> > > >
> > > > +#ifdef CONFIG_LIVEPATCH
> > > > +void clear_relocate_add(Elf64_Shdr *sechdrs,
> > > > +                    const char *strtab,
> > > > +                    unsigned int symindex,
> > > > +                    unsigned int relsec,
> > > > +                    struct module *me)
> > > > +{
> > > > +     unsigned int i;
> > > > +     Elf64_Rela *rela = (void *)sechdrs[relsec].sh_addr;
> > > > +     Elf64_Sym *sym;
> > > > +     unsigned long *location;
> > > > +     const char *symname;
> > > > +     u32 *instruction;
> > > > +
> > > > +     pr_debug("Clearing ADD relocate section %u to %u\n", relsec,
> > > > +              sechdrs[relsec].sh_info);
> > > > +
> > > > +     for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rela); i++) {
> > > > +             location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
> > > > +                     + rela[i].r_offset;
> > > > +             sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
> > > > +                     + ELF64_R_SYM(rela[i].r_info);
> > > > +             symname = me->core_kallsyms.strtab
> > > > +                     + sym->st_name;
> > > > +
> > > > +             if (ELF64_R_TYPE(rela[i].r_info) != R_PPC_REL24)
> > > > +                     continue;
> > >
> > > Is it OK to continue?
> > >
> > > IMHO, we should at least warn here. It means that the special elf
> > > section contains a relocation that we are not able to clear. It will
> > > most likely blow up when we try to load the livepatched module
> > > again.
> > >
> > > > +             /*
> > > > +              * reverse the operations in apply_relocate_add() for case
> > > > +              * R_PPC_REL24.
> > > > +              */
> > > > +             if (sym->st_shndx != SHN_UNDEF &&
> > > > +                 sym->st_shndx != SHN_LIVEPATCH)
> > > > +                     continue;
> > >
> > > Same here. IMHO, we should warn when the section contains something
> > > that we are not able to clear.
> > >
> > > > +             /* skip mprofile and ftrace calls, same as restore_r2() */
> > > > +             if (is_mprofile_ftrace_call(symname))
> > > > +                     continue;
> > >
> > > Is this correct? restore_r2() returns "1" in this case. As a result
> > > apply_relocate_add() returns immediately with -ENOEXEC. IMHO, we
> > > should print a warning and return as well.
> > >
> > > > +             instruction = (u32 *)location;
> > > > +             /* skip sibling call, same as restore_r2() */
> > > > +             if (!instr_is_relative_link_branch(ppc_inst(*instruction)))
> > > > +                     continue;
> > >
> > > Same here. restore_r2() returns '1' in this case...
> > >
> > > > +
> > > > +             instruction += 1;
> > > > +             /*
> > > > +              * Patch location + 1 back to NOP so the next
> > > > +              * apply_relocate_add() call (reload the module) will not
> > > > +              * fail the sanity check in restore_r2():
> > > > +              *
> > > > +              *         if (*instruction != PPC_RAW_NOP()) {
> > > > +              *             pr_err(...);
> > > > +              *             return 0;
> > > > +              *         }
> > > > +              */
> > > > +             patch_instruction(instruction, ppc_inst(PPC_RAW_NOP()));
> > > > +     }
> > >
> > > This seems incomplete. The above code reverts patch_instruction() called
> > > from restore_r2(). But there is another patch_instruction() called in
> > > apply_relocate_add() for case R_PPC_REL24. IMHO, we should revert this
> > > as well.
> > >
> > > > +}
> > > > +#endif
> > >
> > > IMHO, this approach is really bad. The function is not maintainable.
> > > It will be very hard to keep it in sync with apply_relocate_add().
> > > And all the mistakes are just a proof.
> >
> > I don't really think the above are mistakes. This should be the same
> > as the version that passed Joe's tests. (I didn't test it myself).
> >
> > >
> > > IMHO, the only sane way is to avoid the code duplication.
> >
> > I think this falls back to the question that do we want
> > clear_relocate_add() to
> >    1) undo everything by apply_relocate_add();
> > or
> >    2) make sure the next apply_relocate_add() succeeds.
> >
>
> This is a really good question and I think relates to your follow up
> question to my earlier reply, "What's the failure like if we don't
> handle R_PPC64_ADDR64 and R_PPC64_REL64?"
>
> If the code only needs to accomplish (2), then the incoming patch simply
> overwrites old relocation values.  If we prefer (1), then needs to do
> the full reversal on unload.
>
> Stepping back, this feature is definitely foot-gun capable.
> Kpatch-build would expect that klp-relocations would only ever be needed
> in code that will patch the very same module that provides the
> relocation destination -- that is, it was never intended to reference
> through one of these klp-relocations unless it resolved to a live
> module.
>
> On the other hand, when writing the selftests, verifying against NULL
> [1] provided 1) a quick sanity check that something was "cleared" and 2)
> protected the machine against said foot-gun.
>
> [1] https://github.com/joe-lawrence/klp-convert-tree/commit/643acbb8f4c0240030b45b64a542d126370d3e6c

I don't quite follow the foot-gun here. What's the failure mode?

[...]

> > These approaches don't look better to me. But I am ok
> > with any of them. Please just let me know which one is
> > most preferable:
> >
> > a. current version;
> > b. clear_ undo everything of apply_ (the sample code
> >    above)
> > c. clear_ undo R_PPC_REL24, but _redo_ everything
> >    of apply_ for other ELF64_R_TYPEs. (should be
> >   clearer code than option b).
> >
>
> This was my attempt at combining and slightly refactoring the power64
> version.  There is so much going on here I was tempted to split off it
> into separate value assignment and write functions.  Some changes I
> liked, but I wasn't all too happy with the result.  Also, as you
> mention, completely undoing R_PPC_REL24 is less than trivial... for this
> arch, there are basically three major tasks:
>
>   1) calculate the new value, including range checking
>   2) special constructs created by restore_r2 / create_stub
>   3) writing out the value
>
> and many cases are similar, but subtly different enough to avoid easy
> code consolidation.

Thanks for exploring this direction. I guess this part won't be perfect
anyway.

PS: While we discuss a solution for ppc64, how about we ship the
fix for other archs first? I think there are only a few small things to
be addressed.

Song

>
> static int write_relocate_add(Elf64_Shdr *sechdrs,
>                    const char *strtab,
>                    unsigned int symindex,
>                    unsigned int relsec,
>                    struct module *me,
>                    bool apply)
> {
>         unsigned int i;
>         Elf64_Rela *rela = (void *)sechdrs[relsec].sh_addr;
>         Elf64_Sym *sym;
>         unsigned long *location;
>         unsigned long value;
>

[...]
