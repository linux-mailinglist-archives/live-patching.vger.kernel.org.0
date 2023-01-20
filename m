Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590C2675ABB
	for <lists+live-patching@lfdr.de>; Fri, 20 Jan 2023 18:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjATRES (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 20 Jan 2023 12:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjATRER (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 20 Jan 2023 12:04:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0817495C;
        Fri, 20 Jan 2023 09:04:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DE6CB82851;
        Fri, 20 Jan 2023 17:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF18C433EF;
        Fri, 20 Jan 2023 17:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674234249;
        bh=MZB2AJVHjaHKKeWv8HiYKeBwBR2FnNdfcEnwPVnHAB4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QTtleG8XR6r12kK9VbmjD7Ile2P1Ge+RZO57nCKiT9yf7jX1kZ+Z2htIh53Yuyvuo
         MDOoYxWq5i+JU/S4uOqYXnD5UGOL3KYqOWZeQG+31s6oR0+nNiDMkEzEPyf5AkCmai
         toiwsHFiGzGyL5JHWNDJYCwMopDTqgGcd3Z5pZfurfQavdduUOAOYuViIj2nJTVGUI
         bfbO6jauKLseAZ1bqEIDmHYlUndX1EoeMz1gV4rjK+Xn3Wb2g32hkpGqw4VhgXzdfS
         pUuUJf0AmGkDyU4nBOCAaO2pZ4zjsqXB9RM1Ia56dA82UTEX0YsnFw4pCn0cQIYizF
         l3NIMAsZYzghw==
Received: by mail-lj1-f173.google.com with SMTP id z7so6172503ljz.4;
        Fri, 20 Jan 2023 09:04:09 -0800 (PST)
X-Gm-Message-State: AFqh2krI1Xrn9p9rtKHw8culVvyAUtNXKDRw4VOQgJMjeTD8a5fQ7x90
        qI0RKzPInXkD0iZNmvvXDhp+qQk5h+p7TJLxLbM=
X-Google-Smtp-Source: AMrXdXtPd4uwRkyODiNjHUxB3oPWipLVksXHKche4TR40TcNMRllk0B00VMifauy+ir4u0XDhhGsAxckV3Is1ateNzY=
X-Received: by 2002:a2e:7d04:0:b0:285:3383:6635 with SMTP id
 y4-20020a2e7d04000000b0028533836635mr1186691ljc.323.1674234247847; Fri, 20
 Jan 2023 09:04:07 -0800 (PST)
MIME-Version: 1.0
References: <20230118204728.1876249-1-song@kernel.org> <20230118220812.dvztwhlmliypefha@treble>
 <CAPhsuW6FyHLeG3XMMMJiNnhwzW3dPXKrj3ksyB-C_iK1PNk71Q@mail.gmail.com> <20230120064215.cdyfbjlas5noxam6@treble>
In-Reply-To: <20230120064215.cdyfbjlas5noxam6@treble>
From:   Song Liu <song@kernel.org>
Date:   Fri, 20 Jan 2023 09:03:55 -0800
X-Gmail-Original-Message-ID: <CAPhsuW75hr5kp85X3C45u071PyUHQ8NG0dnOajTc9O976wN0vg@mail.gmail.com>
Message-ID: <CAPhsuW75hr5kp85X3C45u071PyUHQ8NG0dnOajTc9O976wN0vg@mail.gmail.com>
Subject: Re: [PATCH v9] livepatch: Clear relocation targets on a module removal
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, x86@kernel.org, jikos@kernel.org,
        pmladek@suse.com, joe.lawrence@redhat.com,
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

On Thu, Jan 19, 2023 at 10:42 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>
> On Thu, Jan 19, 2023 at 11:06:35AM -0800, Song Liu wrote:
> > On Wed, Jan 18, 2023 at 2:08 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > >
> > > On Wed, Jan 18, 2023 at 12:47:28PM -0800, Song Liu wrote:
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
> > > >   On ppc64le, we have a similar issue:
> > > >
> > > >   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
> > > >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> > > >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> > >
> > > Shouldn't there also be a fix for this powerpc issue?
> >
> > There was a working version, but it was not very clean. We couldn't agree
> > on the path forward for powerpc, so we are hoping to ship the fix to x86 (and
> > s390?) first [1].
>
> Sorry for coming in late, I was on leave so I missed a lot of the
> discussions on previous versions.  The decision to leave powerpc broken
> wasn't clear from reading the commit message.  The bug is mentioned, and
> the fix is implied, but surprisingly there's no fix.
>
> I agree that the powerpc fix should be in a separate patch, but I still
> don't feel comfortable merging the x86 fix without the corresponding
> powerpc fix.
>
> powerpc is a major arch and not a second-class citizen.  If we don't fix
> it now then it'll probably never get fixed until it blows up in the real
> world.
>
> For powerpc, instead of clearing, how about just "fixing" the warning
> site, something like so (untested)?

This version looks reasonable to me.

Thanks,
Song

>
> diff --git a/arch/powerpc/kernel/module_64.c b/arch/powerpc/kernel/module_64.c
> index 1096d6b3a62c..1a12463ba674 100644
> --- a/arch/powerpc/kernel/module_64.c
> +++ b/arch/powerpc/kernel/module_64.c
> @@ -499,9 +499,11 @@ static unsigned long stub_for_addr(const Elf64_Shdr *sechdrs,
>
>  /* We expect a noop next: if it is, replace it with instruction to
>     restore r2. */
> -static int restore_r2(const char *name, u32 *instruction, struct module *me)
> +static int restore_r2(const char *name, u32 *instruction, struct module *me,
> +                     bool klp_sym)
>  {
>         u32 *prev_insn = instruction - 1;
> +       u32 insn_val = *instruction;
>
>         if (is_mprofile_ftrace_call(name))
>                 return 1;
> @@ -514,9 +516,18 @@ static int restore_r2(const char *name, u32 *instruction, struct module *me)
>         if (!instr_is_relative_link_branch(ppc_inst(*prev_insn)))
>                 return 1;
>
> -       if (*instruction != PPC_RAW_NOP()) {
> +       /*
> +        * For a livepatch relocation, the restore r2 instruction might have
> +        * been previously written if the relocation references a symbol in a
> +        * module which was unloaded and is now being reloaded.  In that case,
> +        * skip the warning and instruction write.
> +        */
> +       if (klp_sym && insn_val == PPC_INST_LD_TOC)
> +               return 0;
> +
> +       if (insn_val != PPC_RAW_NOP()) {
>                 pr_err("%s: Expected nop after call, got %08x at %pS\n",
> -                       me->name, *instruction, instruction);
> +                       me->name, insn_val, instruction);
>                 return 0;
>         }
>
> @@ -649,7 +660,8 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
>                                 if (!value)
>                                         return -ENOENT;
>                                 if (!restore_r2(strtab + sym->st_name,
> -                                                       (u32 *)location + 1, me))
> +                                               (u32 *)location + 1, me,
> +                                               sym->st_shndx == SHN_LIVEPATCH))
>                                         return -ENOEXEC;
>                         } else
>                                 value += local_entry_offset(sym);
