Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 538EE648957
	for <lists+live-patching@lfdr.de>; Fri,  9 Dec 2022 20:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiLIT74 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Dec 2022 14:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLIT7w (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Dec 2022 14:59:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BE313E01;
        Fri,  9 Dec 2022 11:59:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FBEC6232B;
        Fri,  9 Dec 2022 19:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FA5C43398;
        Fri,  9 Dec 2022 19:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670615989;
        bh=2pRNCKcx+i/2M8U3jcMWgUdti6tr4GG5KNF2eAQP4h8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ei1w6rkTpoCOrZByMzmU6oIfniP14jEO8wLveqCL6uOOKGPG61lzBU5/Rg0SUqUgR
         u1qW21EICqdTdAPTK9WyXLAsiX2hTbL7mXnK1vzltmrh2DIqKqQ+xrf5wkkxY9G0KV
         6dLdpu8BxyYjNU3Ok1bQ9QJxpOr24FZVs8KaO7FLQnPqEHl81P+pSLv+WVmL80RUX5
         RpEdShAcfiIPdK2frOOnG6rAPXS7Y+Po2ApOgHNYw1wncxs1osFKAhimvD1kA02usj
         Af9R8zL32ZhOJiZXpZZ5Trk4o+KVFAQwEC6TvSnh8UflJc36F+kG9TArF5cw1yMiQP
         5yRRp9t+P0zcA==
Received: by mail-ej1-f51.google.com with SMTP id m18so13922681eji.5;
        Fri, 09 Dec 2022 11:59:49 -0800 (PST)
X-Gm-Message-State: ANoB5pkMau7Haj9lWBMvfr2+fSDLwG+dXluiG1FeqTzsXci9fcMTIIec
        ZFtljsEF1w7+CV31q8cDZ57QBpE8qLjzGU6uGfA=
X-Google-Smtp-Source: AA0mqf5N+MHdzv0AWM6a+1eLCTIN06JvpjHTPV3WoGK/6sQfl/2nPDCMAb9CxcqMvxTa/B7fVazmmSShMdXYy+kJ+gk=
X-Received: by 2002:a17:906:a198:b0:7b4:bc42:3b44 with SMTP id
 s24-20020a170906a19800b007b4bc423b44mr73801661ejy.101.1670615988052; Fri, 09
 Dec 2022 11:59:48 -0800 (PST)
MIME-Version: 1.0
References: <20220901171252.2148348-1-song@kernel.org> <Y3expGRt4cPoZgHL@alley>
 <CAPhsuW4qYpX7wzHn5J5Hn9cnOFSZwwQPCjTM_HPTt_zbBS03ww@mail.gmail.com> <Y5Me5dTGv+GznvtO@alley>
In-Reply-To: <Y5Me5dTGv+GznvtO@alley>
From:   Song Liu <song@kernel.org>
Date:   Fri, 9 Dec 2022 11:59:35 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4pt7vfHTj8KorTRCx5zJaoUiyYUOLy8uXZDbTbur4RRA@mail.gmail.com>
Message-ID: <CAPhsuW4pt7vfHTj8KorTRCx5zJaoUiyYUOLy8uXZDbTbur4RRA@mail.gmail.com>
Subject: Re: powerpc-part: was: Re: [PATCH v6] livepatch: Clear relocation
 targets on a module removal
To:     Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
        x86@kernel.org, joe.lawrence@redhat.com,
        linuxppc-dev@lists.ozlabs.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Dec 9, 2022 at 3:41 AM Petr Mladek <pmladek@suse.com> wrote:
>
> Hi,
>
> this reply is only about the powerpc-specific part.
>
> Also adding Kamalesh and Michael into Cc who worked on the related
> commit a443bf6e8a7674b86221f49 ("powerpc/modules: Add REL24 relocation
> support of livepatch symbols").
>
>
> On Mon 2022-11-28 17:57:06, Song Liu wrote:
> > On Fri, Nov 18, 2022 at 8:24 AM Petr Mladek <pmladek@suse.com> wrote:
> > >
> > > > --- a/arch/powerpc/kernel/module_64.c
> > > > +++ b/arch/powerpc/kernel/module_64.c
>
> I put back the name of the modified file so that it is easier
> to know what changes we are talking about.
>
> [...]
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
>
> The above calculation is quite complex. It seems to be copied from
> apply_relocate_add(). If I maintained this code I would want to avoid
> the duplication. definitely.
>
>
> > > > +
> > > > +             if (ELF64_R_TYPE(rela[i].r_info) != R_PPC_REL24)
> > > > +                     continue;
>
> Why are we interested only into R_PPC_REL24 relocation types, please?
>
> The code for generating the special SHN_LIVEPATCH section is not in
> the mainline so it is not well defined.
>
> I guess that R_PPC_REL24 relocation type is used by kPatch. Are we
> sure that other relocation types wont be needed?
>
> Anyway, we must warn when an unsupported type is used in SHN_LIVEPATCH
> section here.
>
>
> > > > +             /*
> > > > +              * reverse the operations in apply_relocate_add() for case
> > > > +              * R_PPC_REL24.
> > > > +              */
> > > > +             if (sym->st_shndx != SHN_UNDEF &&
>
> Do we want to handle SHN_UNDEF symbols here?
>
> The commit a443bf6e8a7674b86221f49 ("powerpc/modules: Add REL24
> relocation support of livepatch symbols") explains that
> R_PPC_REL24 relocations in SHN_LIVEPATCH section are handled
> __like__ relocations in SHN_UNDEF sections.
>
> My understanding is that R_PPC_REL24 reallocation type has
> two variants. Where the variant used in SHN_UNDEF and
> SHN_LIVEPATCH sections need some preprocessing.
>
> Anyway, if this function is livepatch-specific that we should
> clear only symbols from SHN_LIVEPATCH sections. I mean that
> we should probably ignore SHN_UNDEF here.
>
> > > > +                 sym->st_shndx != SHN_LIVEPATCH)
> > > > +                     continue;
> > > > +
> > > > +
> > > > +             instruction = (u32 *)location;
> > > > +             if (is_mprofile_ftrace_call(symname))
> > > > +                     continue;
>
> Why do we ignore these symbols?
>
> I can't find any counter-part in apply_relocate_add(). It looks super
> tricky. It would deserve a comment.
>
> And I have no idea how we could maintain these exceptions.
>
> > > > +             if (!instr_is_relative_link_branch(ppc_inst(*instruction)))
> > > > +                     continue;
>
> Same here. It looks super tricky and there is no explanation.

The two checks are from restore_r2(). But I cannot really remember
why we needed them. It is probably an updated version from an earlier
version (3 year earlier..).

>
> > > > +             instruction += 1;
> > > > +             patch_instruction(instruction, ppc_inst(PPC_RAW_NOP()));
> > > > +     }
> > > > +
> > > > +}
> > >
> > > This looks like a lot of duplicated code. Isn't it?
> >
> > TBH, I think the duplicated code is not really bad.
>
> How exactly do you mean it, please?
>
> Do you think that the amount of duplicated code is small enough?
> Or that the new function looks better that updating the existing one?
>
> > apply_relocate_add() is a much more complicated function, I would
> > rather not mess it up to make this function a little simpler.
>
> IMHO, the duplicated code is quite tricky. And if we really do
> not need to clear all relocation types then we could avoid
> the duplication another way, for example:
>
> int update_relocate_add(Elf64_Shdr *sechdrs,
>                        const char *strtab,
>                        unsigned int symindex,
>                        unsigned int relsec,
>                        struct module *me,
>                        bool apply)
> {
>         unsigned int i;
>         Elf64_Rela *rela = (void *)sechdrs[relsec].sh_addr;
>         Elf64_Sym *sym;
>         Elf64_Xword r_type;
>         unsigned long *location;
>
>         if (apply) {
>                 pr_debug("Applying ADD relocate section %u to %u\n", relsec,
>                        sechdrs[relsec].sh_info);
>         } else {
>                 pr_debug("Clearing ADD relocate section %u\n", relsec");
>         }
>
>         for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rela); i++) {
>                 /* This is where to make the change */
>                 location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
>                         + rela[i].r_offset;
>                 /* This is the symbol it is referring to */
>                 sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
>                         + ELF64_R_SYM(rela[i].r_info);
>
>                 r_type = ELF64_R_TYPE(rela[i].r_info);
>
>                 if (apply) {
>                         apply_relocate_location(sym, location, r_type, rela[i].r_addend);
>                 } else {
>                         clear_relocate_location(sym, location, r_type);
>                 }

I personally don't like too many "if (apply) {...} else {...}" patterns in
a function. And these new functions confuse me sometimes:

    update_relocate_add(..., apply);
    apply_relocate_location();
    clear_relocate_location();

And I did think there wasn't too much duplicated code.

I know this is very personal. And I can understand your preference.
I can make the code to remove more duplicated code. But I guess
I need a better understanding of powerpc logic..

Thanks,
Song
