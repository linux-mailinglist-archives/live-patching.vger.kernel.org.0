Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52305872F9
	for <lists+live-patching@lfdr.de>; Mon,  1 Aug 2022 23:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbiHAVTr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 1 Aug 2022 17:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbiHAVTq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 1 Aug 2022 17:19:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A0F2DDF;
        Mon,  1 Aug 2022 14:19:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADE1F61366;
        Mon,  1 Aug 2022 21:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A202C433B5;
        Mon,  1 Aug 2022 21:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659388784;
        bh=LnX9Iq/9UyjPv/ISzagIdNfDPD8aiL7nS2m3xQlGJk0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bxjMC122Whn7OU7jjheEwfE6amRqHjYvQE9anGVm53yMEkQKlZY6v65q6Fg+IofL6
         QigXNy4UQh3RwXfudmwVxJIJXI026dNAVoULvD9ip+rJ9Ll6yUkbAMJMUg/cGm8/Zk
         zzh7wXuuM/phv6gbdVwVttBsMrSjvxw4jErfXVmkjKavxM96RjJCrhVDgw9/0yczXE
         4h1VLRN84TFClVrZUFrmsn4OUlE3tb3CEY8DaTIRHcRkxNJK3Jin3/CxvtDolKCoXx
         q6cZqSGhH/mKbLoYYgSCom78Il5jiRGyyXvmJ8wQR5oHHXmLAvKNLKk62ob7dX6lH+
         +M4F+nu0ctkQQ==
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-31f41584236so122167207b3.5;
        Mon, 01 Aug 2022 14:19:43 -0700 (PDT)
X-Gm-Message-State: ACgBeo3EbfcyOp3Hv2zINcpkmYteNv5XqUcL+niLWJC1DtpId+1Td3WV
        lwSRnjPbjbfAqwNPK6wTAX1qt2gPUyMYg3hI/RM=
X-Google-Smtp-Source: AA6agR6RzewLQl8j0NFHBFGHWv+K5hmWOYixtWpjPzUqr0nI/udvvD+DfiblQqzDcmdr9bcPmmmBgxdB930OfIc361E=
X-Received: by 2002:a0d:f985:0:b0:31f:5a01:eaf2 with SMTP id
 j127-20020a0df985000000b0031f5a01eaf2mr15016315ywf.447.1659388783009; Mon, 01
 Aug 2022 14:19:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220721175147.214642-1-song@kernel.org> <20220726233302.zwloxsammnu7clu4@treble>
 <CAPhsuW7tmRt=yx1+i62HPRJJ4Gp8xB_3XvpVxUC=SyGv6iCBEQ@mail.gmail.com>
 <CAPhsuW4F8f9GLHF9C54oWyFiyJ0eT5HOwfhmoxSJ3HeRr8zCSw@mail.gmail.com>
 <CAPhsuW4VFjyoYta6fEGXg4S1dbg8ynkdKZzuwYSp3FMEGPP0aA@mail.gmail.com> <Yuep+uKnDc0L2ICi@alley>
In-Reply-To: <Yuep+uKnDc0L2ICi@alley>
From:   Song Liu <song@kernel.org>
Date:   Mon, 1 Aug 2022 14:19:32 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7FLVQ4CeBp0crTh5TQk30E113=ZMz_iHh5xK-QGNcT+g@mail.gmail.com>
Message-ID: <CAPhsuW7FLVQ4CeBp0crTh5TQk30E113=ZMz_iHh5xK-QGNcT+g@mail.gmail.com>
Subject: Re: [PATCH v3] livepatch: Clear relocation targets on a module removal
To:     Petr Mladek <pmladek@suse.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        live-patching@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
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

On Mon, Aug 1, 2022 at 3:25 AM Petr Mladek <pmladek@suse.com> wrote:
>
> On Sat 2022-07-30 20:20:22, Song Liu wrote:
> > On Sat, Jul 30, 2022 at 3:32 PM Song Liu <song@kernel.org> wrote:
> > >
> > > On Tue, Jul 26, 2022 at 8:54 PM Song Liu <song@kernel.org> wrote:
> > > >
> > > > On Tue, Jul 26, 2022 at 4:33 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > > > >
> > > > > On Thu, Jul 21, 2022 at 10:51:47AM -0700, Song Liu wrote:
> > > > > > From: Miroslav Benes <mbenes@suse.cz>
> > > > > >
> > > > > > Josh reported a bug:
> > > > > >
> > > > > >   When the object to be patched is a module, and that module is
> > > > > >   rmmod'ed and reloaded, it fails to load with:
> > > > > >
> > > > > >   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
> > > > > >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> > > > > >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> > > > > >
> > > > > >   The livepatch module has a relocation which references a symbol
> > > > > >   in the _previous_ loading of nfsd. When apply_relocate_add()
> > > > > >   tries to replace the old relocation with a new one, it sees that
> > > > > >   the previous one is nonzero and it errors out.
> > > > > >
> > > > > >   On ppc64le, we have a similar issue:
> > > > > >
> > > > > >   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
> > > > > >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> > > > > >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> > > > > >
> > > > > 3) A selftest would be a good idea.
> > > >
> > >
> > > I found it is pretty tricky to run the selftests inside a qemu VM. How about
> > > we test it with modules in samples/livepatch? Specifically, we can add a
> > > script try to reload livepatch-shadow-mod.ko.
> >
> > Actually, livepatch-shadow-mod.ko doesn't have the reload problem before
> > the fix. Is this expected?
>
> Good question. I am afraid that there is no easy way to prepare
> the selftest at the moment.
>
> There are two situations when a symbol from the livepatched module is
> relocated:
>
>
> 1. The livepatch might access a symbol exported by the module via
>    EXPORT_SYMBOL(). In this case, it is "normal" external symbol
>    and it gets relocated by the module loader.
>
>    But EXPORT_SYMBOL() will create an explicit dependency between the
>    livepatch and livepatched module. As a result, the livepatch
>    module could be loaded only when the livepatched module is loaded.
>    And the livepatched module could not be removed when the livepatch
>    module is loaded.
>
>    In this case, the problem will not exist. Well, the developers
>    of the livepatch module will probably want to avoid this
>    dependency.
>
>
> 2. The livepatch module might access a non-exported symbol from another
>    module using the special elf section for klp relocation, see
>    section, see Documentation/livepatch/module-elf-format.rst
>
>    These symbols are relocated in klp_apply_section_relocs().
>
>    The problem is that upstream does not have a support to
>    create this elf section. There is a patchset for this, see
>    https://lore.kernel.org/all/20220216163940.228309-1-joe.lawrence@redhat.com/
>    It requires some more review.
>
>
> Resume: I think that we could not prepare the selftest without
>         upstreaming klp-convert tool.

Thanks for the explanation! I suspected the same issue, but couldn't
connect all the logic.

I guess the selftests can wait until the klp-convert tool.

Thanks,
Song
