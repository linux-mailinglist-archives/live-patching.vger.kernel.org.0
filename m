Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243BD64AA21
	for <lists+live-patching@lfdr.de>; Mon, 12 Dec 2022 23:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbiLLWWy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 12 Dec 2022 17:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbiLLWWx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 12 Dec 2022 17:22:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AC118B0B;
        Mon, 12 Dec 2022 14:22:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12F7B61253;
        Mon, 12 Dec 2022 22:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E79AC433F1;
        Mon, 12 Dec 2022 22:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670883769;
        bh=n5kPNNhdXbnyRzK8fG8dSHsqMwjIURUJUUfsT+bCSIY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uX9a4tcbD9kOr2VNj9hH26OWcgJ38BgsgDyj+a7s57ZeqXcvrErXbQXTyF5eGoGzG
         UE+iVToIqmpgFFfCF8xkzLbLUO1wbTL8vuwB+ooaYanU/ACv5ZGpBQDujzyLVVnTYo
         4fI9djDEINFkdFGJ9LQcDgA2l3VJAiVapMXWx6E/NMcVXn3zh7MpQRbkOcnqUoUR/V
         66g+fJmC6cKSm+xYZo/m1bx10XbdS6reZ82BqprRCQLPqeq2YlZcx/kWZGwO8C5ezQ
         y0+paTvr/n47nFMv3dC9qTChmabeS3jy8+J4/SJFcvIhnwBBfGGfsWrjHLodAuTRuz
         kFUc357YELgww==
Received: by mail-ej1-f50.google.com with SMTP id m18so31908205eji.5;
        Mon, 12 Dec 2022 14:22:49 -0800 (PST)
X-Gm-Message-State: ANoB5ply7p+myEkn4Mhj2+5bUKtSQZQPXYc1LNasIuLnFQJgKnmUeJpT
        ixKhL+zvmczwkzY4qwh6bn4yEUGFzlQ9rxgakyk=
X-Google-Smtp-Source: AA0mqf5+VFAQMcPQ4+iivrJPmx3NCjdvN9Hej6g/VYxLSOLU4o/4+vthXi42Iri/VPUa4PI0jlUTqYMriXXuVdTNuJg=
X-Received: by 2002:a17:906:3711:b0:7c1:d4b:7541 with SMTP id
 d17-20020a170906371100b007c10d4b7541mr9199551ejc.614.1670883767606; Mon, 12
 Dec 2022 14:22:47 -0800 (PST)
MIME-Version: 1.0
References: <20220901171252.2148348-1-song@kernel.org> <Y3expGRt4cPoZgHL@alley>
 <CAPhsuW4qYpX7wzHn5J5Hn9cnOFSZwwQPCjTM_HPTt_zbBS03ww@mail.gmail.com>
 <Y5Me5dTGv+GznvtO@alley> <CAPhsuW4pt7vfHTj8KorTRCx5zJaoUiyYUOLy8uXZDbTbur4RRA@mail.gmail.com>
 <Y5dg25LV24mBRf4t@alley>
In-Reply-To: <Y5dg25LV24mBRf4t@alley>
From:   Song Liu <song@kernel.org>
Date:   Mon, 12 Dec 2022 14:22:35 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4nmMSQf+DqcfkwmX=A2g92=6w1CXpNdWrFzwQebR4i=g@mail.gmail.com>
Message-ID: <CAPhsuW4nmMSQf+DqcfkwmX=A2g92=6w1CXpNdWrFzwQebR4i=g@mail.gmail.com>
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

On Mon, Dec 12, 2022 at 9:12 AM Petr Mladek <pmladek@suse.com> wrote:
>
> On Fri 2022-12-09 11:59:35, Song Liu wrote:
> > On Fri, Dec 9, 2022 at 3:41 AM Petr Mladek <pmladek@suse.com> wrote:
> > > On Mon 2022-11-28 17:57:06, Song Liu wrote:
> > > > On Fri, Nov 18, 2022 at 8:24 AM Petr Mladek <pmladek@suse.com> wrote:
> > > > >
> > > > > > --- a/arch/powerpc/kernel/module_64.c
> > > > > > +++ b/arch/powerpc/kernel/module_64.c
> > > > > > +#ifdef CONFIG_LIVEPATCH
> > > > > > +void clear_relocate_add(Elf64_Shdr *sechdrs,
> > > > > > +                    const char *strtab,
> > > > > > +                    unsigned int symindex,
> > > > > > +                    unsigned int relsec,
> > > > > > +                    struct module *me)
> > > > > > +{
>
> [...]
>
> > > > > > +
> > > > > > +             instruction = (u32 *)location;
> > > > > > +             if (is_mprofile_ftrace_call(symname))
> > > > > > +                     continue;
> > >
> > > Why do we ignore these symbols?
> > >
> > > I can't find any counter-part in apply_relocate_add(). It looks super
> > > tricky. It would deserve a comment.
> > >
> > > And I have no idea how we could maintain these exceptions.
> > >
> > > > > > +             if (!instr_is_relative_link_branch(ppc_inst(*instruction)))
> > > > > > +                     continue;
> > >
> > > Same here. It looks super tricky and there is no explanation.
> >
> > The two checks are from restore_r2(). But I cannot really remember
> > why we needed them. It is probably an updated version from an earlier
> > version (3 year earlier..).
>
> This is a good sign that it has to be explained in a comment.
> Or even better, it should not by copy pasted.
>
> > > > > > +             instruction += 1;
> > > > > > +             patch_instruction(instruction, ppc_inst(PPC_RAW_NOP()));
>
> I believe that this is not enough. apply_relocate_add() does this:
>
> int apply_relocate_add(Elf64_Shdr *sechdrs,
> [...]
>                        struct module *me)
> {
> [...]
>                 case R_PPC_REL24:
>                         /* FIXME: Handle weak symbols here --RR */
>                         if (sym->st_shndx == SHN_UNDEF ||
>                             sym->st_shndx == SHN_LIVEPATCH) {
> [...]
>                         if (!restore_r2(strtab + sym->st_name,
>                                                         (u32 *)location + 1, me))
> [...]                                   return -ENOEXEC;
>
> --->                    if (patch_instruction((u32 *)location, ppc_inst(value)))
>                                 return -EFAULT;
>
> , where restore_r2() does:
>
> static int restore_r2(const char *name, u32 *instruction, struct module *me)
> {
> [...]
>         /* ld r2,R2_STACK_OFFSET(r1) */
> --->    if (patch_instruction(instruction, ppc_inst(PPC_INST_LD_TOC)))
>                 return 0;
> [...]
> }
>
> By other words, apply_relocate_add() modifies two instructions:
>
>    + patch_instruction() called in restore_r2() writes into "location + 1"
>    + patch_instruction() called in apply_relocate_add() writes into "location"
>
> IMHO, we have to clear both.
>
> IMHO, we need to implement a function that reverts the changes done
> in restore_r2(). Also we need to revert the changes done in
> apply_relocate_add().
>
> Please, avoid code duplication as much as possible. Especially,
> the two checks is_mprofile_ftrace_call() and
> instr_is_relative_link_branch() must be shared. IMHO, it is
> the only way to keep the code maintainable. We must make sure that
> we will clear the instructions only when they were patched. And
> copy pasting various tricky exceptions is a way to hell.
>
>
> > > int update_relocate_add(Elf64_Shdr *sechdrs,
> > >                        const char *strtab,
> > >                        unsigned int symindex,
> > >                        unsigned int relsec,
> > >                        struct module *me,
> > >                        bool apply)
> > > {
> > >         unsigned int i;
> > >         Elf64_Rela *rela = (void *)sechdrs[relsec].sh_addr;
> > >         Elf64_Sym *sym;
> > >         Elf64_Xword r_type;
> > >         unsigned long *location;
> > >
> > >         if (apply) {
> > >                 pr_debug("Applying ADD relocate section %u to %u\n", relsec,
> > >                        sechdrs[relsec].sh_info);
> > >         } else {
> > >                 pr_debug("Clearing ADD relocate section %u\n", relsec");
> > >         }
> > >
> > >         for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rela); i++) {
> > >                 /* This is where to make the change */
> > >                 location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
> > >                         + rela[i].r_offset;
> > >                 /* This is the symbol it is referring to */
> > >                 sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
> > >                         + ELF64_R_SYM(rela[i].r_info);
> > >
> > >                 r_type = ELF64_R_TYPE(rela[i].r_info);
> > >
> > >                 if (apply) {
> > >                         apply_relocate_location(sym, location, r_type, rela[i].r_addend);
> > >                 } else {
> > >                         clear_relocate_location(sym, location, r_type);
> > >                 }
> >
> > I personally don't like too many "if (apply) {...} else {...}" patterns in
> > a function. And these new functions confuse me sometimes:
> >
> >     update_relocate_add(..., apply);
> >     apply_relocate_location();
> >     clear_relocate_location();
>
> Feel free to come up with another way how to avoid code duplication.
>
> > And I did think there wasn't too much duplicated code.
>
> I think that it looks very different when you are writing or reading
> or mantainting the code. It might be easier to write code and modify
> it. It is more complicated to find the differences later. Also it is
> more complicated to do the same changes many times when the common
> code is updated later.

Agreed that we need to keep the code understandable and maintainable.
And I need to try harder to understand how these codes work as-is.

Thanks,
Song
