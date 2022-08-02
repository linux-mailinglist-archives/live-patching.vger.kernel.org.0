Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80AFA588045
	for <lists+live-patching@lfdr.de>; Tue,  2 Aug 2022 18:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiHBQa0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Aug 2022 12:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbiHBQaT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Aug 2022 12:30:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACE56262;
        Tue,  2 Aug 2022 09:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C904B81FA1;
        Tue,  2 Aug 2022 16:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FF4C433D7;
        Tue,  2 Aug 2022 16:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659457815;
        bh=VeLurwGxR30GtM5SeSZWafh3FNbK4ffoLCs50abMsyI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bLfA82nLK7vOkso4Uh48U0ipF3AZFk4DroBfT0hYZIDZQ0RbCdxSRGKYmi3sLQzIb
         1GiIjJVtrDl0HEb71zgQZPRnEU6esdUo21sFgYP88FUSW3HhYURoye4cIlr0fku2Hv
         CUWvWyxxwe13xPoXsXtk2aJxoIiLL3LqtVr/TSt4MhePhCfuNdX7SkdWrZPhLYyHzT
         kU+KkhY0oRvCtCsr6bMl27Nn6byziJ8Dp60lKoSJcQQXCnV5Nbrk0ism7Stnzv1/e+
         LDSBP/2Mx0RjnCJ9kNaLCsAceVQUuaZPSb2Cw1GJ9e3FAVUBA6sgWyDQ652KCdWB+2
         Jn5rvhu5HUb5Q==
Received: by mail-yb1-f170.google.com with SMTP id 7so24444333ybw.0;
        Tue, 02 Aug 2022 09:30:15 -0700 (PDT)
X-Gm-Message-State: ACgBeo3o73Rb3OW5Q3nkNFyEVjwSOE0R1JNgjR587XziA4L1DYSMQyMI
        hIoIcfH1HoFNNmW1/hJAeZnd2B6jKA8kDs0frT8=
X-Google-Smtp-Source: AA6agR6PSSqZ7q1ceG6hzbb78ReaWO2Pt+7JC8R0WOtp4QIqJwfIq5Lxxb5H2W3s//8Igj7ToX2ruWrko7AbmuMAGtM=
X-Received: by 2002:a25:41d6:0:b0:673:817c:e163 with SMTP id
 o205-20020a2541d6000000b00673817ce163mr14789383yba.561.1659457814933; Tue, 02
 Aug 2022 09:30:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220721175147.214642-1-song@kernel.org> <20220726233302.zwloxsammnu7clu4@treble>
 <CAPhsuW7tmRt=yx1+i62HPRJJ4Gp8xB_3XvpVxUC=SyGv6iCBEQ@mail.gmail.com>
 <CAPhsuW4F8f9GLHF9C54oWyFiyJ0eT5HOwfhmoxSJ3HeRr8zCSw@mail.gmail.com>
 <CAPhsuW4VFjyoYta6fEGXg4S1dbg8ynkdKZzuwYSp3FMEGPP0aA@mail.gmail.com>
 <Yuep+uKnDc0L2ICi@alley> <CAPhsuW7FLVQ4CeBp0crTh5TQk30E113=ZMz_iHh5xK-QGNcT+g@mail.gmail.com>
 <d216c822-aa79-7ad8-2f6c-d74406ee8632@redhat.com>
In-Reply-To: <d216c822-aa79-7ad8-2f6c-d74406ee8632@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 2 Aug 2022 09:30:04 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5sQX53W8_8vvPk_Uhj5LCF-k_7-b8uCnOu-safdRRi=A@mail.gmail.com>
Message-ID: <CAPhsuW5sQX53W8_8vvPk_Uhj5LCF-k_7-b8uCnOu-safdRRi=A@mail.gmail.com>
Subject: Re: [PATCH v3] livepatch: Clear relocation targets on a module removal
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        live-patching@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, X86 ML <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Joe,

On Tue, Aug 2, 2022 at 5:31 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>
> On 8/1/22 17:19, Song Liu wrote:
> > On Mon, Aug 1, 2022 at 3:25 AM Petr Mladek <pmladek@suse.com> wrote:
> >>
> >> On Sat 2022-07-30 20:20:22, Song Liu wrote:
> >>> On Sat, Jul 30, 2022 at 3:32 PM Song Liu <song@kernel.org> wrote:
> >>>>
> >>>> On Tue, Jul 26, 2022 at 8:54 PM Song Liu <song@kernel.org> wrote:
> >>>>>
> >>>>> On Tue, Jul 26, 2022 at 4:33 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >>>>>>
> >>>>>> On Thu, Jul 21, 2022 at 10:51:47AM -0700, Song Liu wrote:
> >>>>>>> From: Miroslav Benes <mbenes@suse.cz>
> >>>>>>>
> >>>>>>> Josh reported a bug:
> >>>>>>>
> >>>>>>>   When the object to be patched is a module, and that module is
> >>>>>>>   rmmod'ed and reloaded, it fails to load with:
> >>>>>>>
> >>>>>>>   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
> >>>>>>>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> >>>>>>>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> >>>>>>>
> >>>>>>>   The livepatch module has a relocation which references a symbol
> >>>>>>>   in the _previous_ loading of nfsd. When apply_relocate_add()
> >>>>>>>   tries to replace the old relocation with a new one, it sees that
> >>>>>>>   the previous one is nonzero and it errors out.
> >>>>>>>
> >>>>>>>   On ppc64le, we have a similar issue:
> >>>>>>>
> >>>>>>>   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
> >>>>>>>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> >>>>>>>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> >>>>>>>
> >>>>>> 3) A selftest would be a good idea.
> >>>>>
> >>>>
> >>>> I found it is pretty tricky to run the selftests inside a qemu VM. How about
> >>>> we test it with modules in samples/livepatch? Specifically, we can add a
> >>>> script try to reload livepatch-shadow-mod.ko.
> >>>
> >>> Actually, livepatch-shadow-mod.ko doesn't have the reload problem before
> >>> the fix. Is this expected?
> >>
> >> Good question. I am afraid that there is no easy way to prepare
> >> the selftest at the moment.
> >>
> >> There are two situations when a symbol from the livepatched module is
> >> relocated:
> >>
> >>
> >> 1. The livepatch might access a symbol exported by the module via
> >>    EXPORT_SYMBOL(). In this case, it is "normal" external symbol
> >>    and it gets relocated by the module loader.
> >>
> >>    But EXPORT_SYMBOL() will create an explicit dependency between the
> >>    livepatch and livepatched module. As a result, the livepatch
> >>    module could be loaded only when the livepatched module is loaded.
> >>    And the livepatched module could not be removed when the livepatch
> >>    module is loaded.
> >>
> >>    In this case, the problem will not exist. Well, the developers
> >>    of the livepatch module will probably want to avoid this
> >>    dependency.
> >>
> >>
> >> 2. The livepatch module might access a non-exported symbol from another
> >>    module using the special elf section for klp relocation, see
> >>    section, see Documentation/livepatch/module-elf-format.rst
> >>
> >>    These symbols are relocated in klp_apply_section_relocs().
> >>
> >>    The problem is that upstream does not have a support to
> >>    create this elf section. There is a patchset for this, see
> >>    https://lore.kernel.org/all/20220216163940.228309-1-joe.lawrence@redhat.com/
> >>    It requires some more review.
> >>
> >>
> >> Resume: I think that we could not prepare the selftest without
> >>         upstreaming klp-convert tool.
> >
> > Thanks for the explanation! I suspected the same issue, but couldn't
> > connect all the logic.
> >
> > I guess the selftests can wait until the klp-convert tool.
> >
>
> Hi Song,
>
> Petr is correct about selftests and these relocations.  Let me know if
> rebasing the klp-convert patchset would be helpful in your testing.
> Otherwise kpatch-build is the only (easy?) way to create klp-relocations
> as far as I know.  (For limited arches anyway.)

I was able to test the patch on x86_64 with kpatch-build. I will look into
klp-convert later (after I fix kpatch-build for some OOT modules..)

I the meanwhile, I guess this patch doesn't need to wait for klp-convert
and the selftest?

Thanks,
Song
