Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49FE566A3C1
	for <lists+live-patching@lfdr.de>; Fri, 13 Jan 2023 20:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbjAMTzp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 13 Jan 2023 14:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjAMTzo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 13 Jan 2023 14:55:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E0488A30
        for <live-patching@vger.kernel.org>; Fri, 13 Jan 2023 11:55:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 422F7B821E3
        for <live-patching@vger.kernel.org>; Fri, 13 Jan 2023 19:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B44C433F0
        for <live-patching@vger.kernel.org>; Fri, 13 Jan 2023 19:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673639740;
        bh=xNL9EfJxgdNVdCGzqsni0FIy6X2bq68dqMwhvgoKD4M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TdUT4KXH6OypTjp2mZrdQ8Z13z9/pj6BQpG5OQWzFp/TAiSTkHsR1O0jq29s3ZwSP
         14R230oxfwvqBvRUauceMjDuxlxsYcLrCIcFZRRn/2+x9l9zLvMeXGnkdG7/8e9O6N
         JwaO3jF5NH+cksVs8nHFTNdeBfqQXro6lOoFpIGsKebP7XXqevnSjPl0CLNiw2p7B1
         HdGmevKWc24H1MTU8ACFaXCGj4WtM2Aqeu8wkxy6mcCInFB9dYKsALsO39b74sBR00
         5uS35Yn9jVFhzzSn0eLrwOFRLufbz12lGjAJSUMsB/HLr/Rzsj3TqtAd4KRHlzmZ0I
         rDJQjiSPwRV0Q==
Received: by mail-lj1-f173.google.com with SMTP id y18so19996895ljk.11
        for <live-patching@vger.kernel.org>; Fri, 13 Jan 2023 11:55:40 -0800 (PST)
X-Gm-Message-State: AFqh2kqbDAxEBJIMoDvvfXGcl+qcoBLBJlwyaiJ53dDXA7+dNjA7AKHx
        935k7D7cCSS4IMzqJUkYUgyLyd57OqKRhWpqhC8=
X-Google-Smtp-Source: AMrXdXtoi6ri5wz6DUaTNk/OMmcRokmSkezt0xDmOChY5ingFN5JduHnJs0GF0N2E89VxVbtfIx3JaEcmjH6HeDa/FQ=
X-Received: by 2002:a2e:9382:0:b0:284:b05a:9e82 with SMTP id
 g2-20020a2e9382000000b00284b05a9e82mr1365121ljh.479.1673639738825; Fri, 13
 Jan 2023 11:55:38 -0800 (PST)
MIME-Version: 1.0
References: <20230106200109.2546997-1-song@kernel.org> <alpine.LSU.2.21.2301131012110.1565@pobox.suse.cz>
In-Reply-To: <alpine.LSU.2.21.2301131012110.1565@pobox.suse.cz>
From:   Song Liu <song@kernel.org>
Date:   Fri, 13 Jan 2023 11:55:25 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6JKSYjfPab9k_SCtoPQMGTX2ZXkSTMnZEOCMf-yo29rg@mail.gmail.com>
Message-ID: <CAPhsuW6JKSYjfPab9k_SCtoPQMGTX2ZXkSTMnZEOCMf-yo29rg@mail.gmail.com>
Subject: Re: [PATCH v8] livepatch: Clear relocation targets on a module removal
To:     Miroslav Benes <mbenes@suse.cz>, X86 ML <x86@kernel.org>
Cc:     live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com,
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

On Fri, Jan 13, 2023 at 1:18 AM Miroslav Benes <mbenes@suse.cz> wrote:
>
> Hi,
>
> On Fri, 6 Jan 2023, Song Liu wrote:
>
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
> > targets on x86_64). The solution is not
> > universal and is too much arch-specific, but it may prove to be simpler
> > in the end.
> >
> > Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> > Signed-off-by: Song Liu <song@kernel.org>
> > Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
>
> I would be fine if you just claimed the authorship (and include my
> Originally-by: tag for example), because you have reworked it quite a lot
> since my first attempts.

I am ok with either way. Or maybe with

Co-developed-by: Song Liu <song@kernel.org>

>
> > +int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
> > +                          const char *shstrtab, const char *strtab,
> > +                          unsigned int symndx, unsigned int secndx,
> > +                          const char *objname)
> > +{
> > +     return klp_write_section_relocs(pmod, sechdrs, shstrtab, strtab, symndx,
> > +                                     secndx, objname, true);
> >  }
>
> Is this redirection needed somewhere? You could just replace
> klp_apply_section_relocs() with klp_write_section_relocs() in
> include/linux/livepatch.h and kernel/module/main.c.
>
> It may be cleaned up later.

It might be a good practice to keep _write_ static in this file, and
only expose _apply_ (maybe also _clear_ in the future)?

I don't have a strong preference either way.

>
> Acked-by: Miroslav Benes <mbenes@suse.cz>

Thanks!

>
> It would be nice to get an Acked-by from a x86 maintainter as well.

Adding x86@ to the cc

Song
