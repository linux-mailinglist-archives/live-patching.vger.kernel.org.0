Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9B3585C83
	for <lists+live-patching@lfdr.de>; Sun, 31 Jul 2022 00:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiG3WdN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 30 Jul 2022 18:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiG3WdL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 30 Jul 2022 18:33:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDABC13D4F;
        Sat, 30 Jul 2022 15:33:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FAB960FA7;
        Sat, 30 Jul 2022 22:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC004C433D7;
        Sat, 30 Jul 2022 22:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659220389;
        bh=/uOO/KL7L4YkvwKvPZQ++G9L5z04U+oo483Vn4Rn5eQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=HiblzlVe9bdmg1Y9KDD3TP9y4K4fTmHeo5z75qWEKNxIEbVuB73Cj8ztvGLnDuoLu
         zMxO7rLJnLMQN02lvaTjCRVg20Gt617LwiP8O7QesV4htlcVJ0GO/GlDQZjX50QR7p
         RwZONNKP80Z1jVrJjvfrxnAED1k85061WK0I5mwwDlAH2gwlkX26X1MlO1gTbaMRWD
         f8X1IIVayEYOhbkH9kV4x1ltChzoItgVit9TISUp/H7adT5hOb4n8PHRXkJp0D9mSo
         4PK4LlYdOV34ajBshZRcAlAum6u8LtImp7IpmxyevdT1HqYc7Hu1Kq8TYTflGVabLK
         8cBK/klHJJSXw==
Received: by mail-yb1-f178.google.com with SMTP id n8so13577843yba.2;
        Sat, 30 Jul 2022 15:33:09 -0700 (PDT)
X-Gm-Message-State: ACgBeo1cwTHoNoOF1GhcRJKFmiT65eQHQT75XCpjOOl+laqErY9lQfOG
        PmZqWPi4lvPd3frxvgLW6Nzgec79pXsORG+jyWM=
X-Google-Smtp-Source: AA6agR6WDDFseGD/TwPqCV2Y1Iml5n8zfGlAx7AMlx8SDo+nfLKD0gzIbh9Nofd8dLYrylXx6CcY/yz+mckVNNgx3hI=
X-Received: by 2002:a25:8b92:0:b0:66d:553a:f309 with SMTP id
 j18-20020a258b92000000b0066d553af309mr6838431ybl.322.1659220388722; Sat, 30
 Jul 2022 15:33:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220721175147.214642-1-song@kernel.org> <20220726233302.zwloxsammnu7clu4@treble>
 <CAPhsuW7tmRt=yx1+i62HPRJJ4Gp8xB_3XvpVxUC=SyGv6iCBEQ@mail.gmail.com>
In-Reply-To: <CAPhsuW7tmRt=yx1+i62HPRJJ4Gp8xB_3XvpVxUC=SyGv6iCBEQ@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Sat, 30 Jul 2022 15:32:58 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4F8f9GLHF9C54oWyFiyJ0eT5HOwfhmoxSJ3HeRr8zCSw@mail.gmail.com>
Message-ID: <CAPhsuW4F8f9GLHF9C54oWyFiyJ0eT5HOwfhmoxSJ3HeRr8zCSw@mail.gmail.com>
Subject: Re: [PATCH v3] livepatch: Clear relocation targets on a module removal
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     live-patching@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        X86 ML <x86@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jul 26, 2022 at 8:54 PM Song Liu <song@kernel.org> wrote:
>
> On Tue, Jul 26, 2022 at 4:33 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > On Thu, Jul 21, 2022 at 10:51:47AM -0700, Song Liu wrote:
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
> > >   On ppc64le, we have a similar issue:
> > >
> > >   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
> > >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> > >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> > >
> > > He also proposed three different solutions. We could remove the error
> > > check in apply_relocate_add() introduced by commit eda9cec4c9a1
> > > ("x86/module: Detect and skip invalid relocations"). However the check
> > > is useful for detecting corrupted modules.
> > >
> > > We could also deny the patched modules to be removed. If it proved to be
> > > a major drawback for users, we could still implement a different
> > > approach. The solution would also complicate the existing code a lot.
> > >
> > > We thus decided to reverse the relocation patching (clear all relocation
> > > targets on x86_64). The solution is not
> > > universal and is too much arch-specific, but it may prove to be simpler
> > > in the end.
> > >
> > > Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > > Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> > > Signed-off-by: Song Liu <song@kernel.org>
> > >
> > > ---
> > >
> > > Changes from v2:
> > > 1. Rewrite x86 changes to match current code style.
> > > 2. Remove powerpc changes as there is no test coverage in v3.
> > > 3. Only keep 1/3 of v2.
> >
> > 1) All the copy/paste is ugly and IMO guaranteed to eventually introduce
> >    bugs when somebody forgets to update the copy.  Wouldn't it be more
> >    robust to reuse the existing apply_relocate_add() code by making it
> >    more generic somehow, like with a new 'clear' bool arg which sets
> >    'val' to zero?
>
> Agreed. I can give it a try.

I finished this part, though it is not really clean (added if else for
each "case:").

>
> >
> > 2) We can't only fix x86, powerpc also needs a fix.
>
> I have very little experience with powerpc. Would someone be willing to
> help with powerpc part of this?

I guess folks are all busy. Any suggestions on how to test powerpc changes?

>
> > 3) A selftest would be a good idea.
>

I found it is pretty tricky to run the selftests inside a qemu VM. How about
we test it with modules in samples/livepatch? Specifically, we can add a
script try to reload livepatch-shadow-mod.ko.

Thanks,
Song
