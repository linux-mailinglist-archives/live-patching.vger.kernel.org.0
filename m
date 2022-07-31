Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82982585D0C
	for <lists+live-patching@lfdr.de>; Sun, 31 Jul 2022 05:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbiGaDUi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 30 Jul 2022 23:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbiGaDUh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 30 Jul 2022 23:20:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB2EDF4A;
        Sat, 30 Jul 2022 20:20:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F62CB80C81;
        Sun, 31 Jul 2022 03:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1755C433C1;
        Sun, 31 Jul 2022 03:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659237633;
        bh=VOtoZ5iECvEx4fV8ID9OJ2/O/BIwBZyTE7ux/0psXvU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iXkRfpQbvcrXyA1Okk0JpAUyP28VB+kMbJ1woMLLDBOplsXnFqNjYd4bd0tQ6mePg
         EyxUTkvyZglYqIb7SwN3gVdkoPVeXC9sSLTMTWDAj/Sw+hKpLOftxKZmsjP6piKztW
         UuQIXY5MQbhND9xaR8bTSMTO+ZBWcC0HmuX0hNRXL2R957/XCpZ0l0oiLqfNaUoTxO
         Mv1+x6vd5dwC4ICaoW+v7S9gNTF9+M0qqbco6lRc1JMNtnxniMMSNo9q4eoc7ojOxb
         7bD+QEfWiu2FAGr3iNlytDeGQkLeDEN8R3zxEG4q76aQqeQxEB89sJcYIWmTi8ymZj
         CrpJ+ZECjPa3g==
Received: by mail-yb1-f174.google.com with SMTP id j63so13983607ybb.13;
        Sat, 30 Jul 2022 20:20:33 -0700 (PDT)
X-Gm-Message-State: ACgBeo01Xcj44qskwYhgG7osyzYkltFfIu5qwNq/fCsfiu1MoHdqcDv3
        WWsjzy3q1DLIKCk5rAByGsCBWfrNlUWgLF4TjpY=
X-Google-Smtp-Source: AA6agR7W/LeHBfUIkMisxFlsh1jnqMx0gsP3Zcc4ncCFYxTrx1E8c7ZPOU8bkzY/Tktpnb7hnhjEaNya4mGngg2nVcE=
X-Received: by 2002:a05:6902:110d:b0:670:b10b:d16e with SMTP id
 o13-20020a056902110d00b00670b10bd16emr7413912ybu.259.1659237632804; Sat, 30
 Jul 2022 20:20:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220721175147.214642-1-song@kernel.org> <20220726233302.zwloxsammnu7clu4@treble>
 <CAPhsuW7tmRt=yx1+i62HPRJJ4Gp8xB_3XvpVxUC=SyGv6iCBEQ@mail.gmail.com> <CAPhsuW4F8f9GLHF9C54oWyFiyJ0eT5HOwfhmoxSJ3HeRr8zCSw@mail.gmail.com>
In-Reply-To: <CAPhsuW4F8f9GLHF9C54oWyFiyJ0eT5HOwfhmoxSJ3HeRr8zCSw@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Sat, 30 Jul 2022 20:20:22 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4VFjyoYta6fEGXg4S1dbg8ynkdKZzuwYSp3FMEGPP0aA@mail.gmail.com>
Message-ID: <CAPhsuW4VFjyoYta6fEGXg4S1dbg8ynkdKZzuwYSp3FMEGPP0aA@mail.gmail.com>
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

On Sat, Jul 30, 2022 at 3:32 PM Song Liu <song@kernel.org> wrote:
>
> On Tue, Jul 26, 2022 at 8:54 PM Song Liu <song@kernel.org> wrote:
> >
> > On Tue, Jul 26, 2022 at 4:33 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > >
> > > On Thu, Jul 21, 2022 at 10:51:47AM -0700, Song Liu wrote:
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
> > > >
> > > > He also proposed three different solutions. We could remove the error
> > > > check in apply_relocate_add() introduced by commit eda9cec4c9a1
> > > > ("x86/module: Detect and skip invalid relocations"). However the check
> > > > is useful for detecting corrupted modules.
> > > >
> > > > We could also deny the patched modules to be removed. If it proved to be
> > > > a major drawback for users, we could still implement a different
> > > > approach. The solution would also complicate the existing code a lot.
> > > >
> > > > We thus decided to reverse the relocation patching (clear all relocation
> > > > targets on x86_64). The solution is not
> > > > universal and is too much arch-specific, but it may prove to be simpler
> > > > in the end.
> > > >
> > > > Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > > > Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> > > > Signed-off-by: Song Liu <song@kernel.org>
> > > >
> > > > ---
> > > >
> > > > Changes from v2:
> > > > 1. Rewrite x86 changes to match current code style.
> > > > 2. Remove powerpc changes as there is no test coverage in v3.
> > > > 3. Only keep 1/3 of v2.
> > >
> > > 1) All the copy/paste is ugly and IMO guaranteed to eventually introduce
> > >    bugs when somebody forgets to update the copy.  Wouldn't it be more
> > >    robust to reuse the existing apply_relocate_add() code by making it
> > >    more generic somehow, like with a new 'clear' bool arg which sets
> > >    'val' to zero?
> >
> > Agreed. I can give it a try.
>
> I finished this part, though it is not really clean (added if else for
> each "case:").
>
> >
> > >
> > > 2) We can't only fix x86, powerpc also needs a fix.
> >
> > I have very little experience with powerpc. Would someone be willing to
> > help with powerpc part of this?
>
> I guess folks are all busy. Any suggestions on how to test powerpc changes?
>
> >
> > > 3) A selftest would be a good idea.
> >
>
> I found it is pretty tricky to run the selftests inside a qemu VM. How about
> we test it with modules in samples/livepatch? Specifically, we can add a
> script try to reload livepatch-shadow-mod.ko.

Actually, livepatch-shadow-mod.ko doesn't have the reload problem before
the fix. Is this expected?

Thanks,
Song
