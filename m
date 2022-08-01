Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D64586E7D
	for <lists+live-patching@lfdr.de>; Mon,  1 Aug 2022 18:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiHAQYc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 1 Aug 2022 12:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232032AbiHAQYb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 1 Aug 2022 12:24:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1391835C;
        Mon,  1 Aug 2022 09:24:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AE73B8159B;
        Mon,  1 Aug 2022 16:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B115C433D7;
        Mon,  1 Aug 2022 16:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659371068;
        bh=A1RbxLvQa3KCWFb52lrCFsaDg25vJK6GYA+aGp3dizc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Reu66qNV0FnzVvJlKfEvy0vUUrlU+9XCIXRSpdj91NTrJVaodVXVL/xaqCAPV3A5T
         LTHv97KBvdb1BCiGrdVF5GSCVyaJlLPKnfGZmqNIT5Nr5uvbPerAxrnD7UjmyGaw7k
         zLuF0KPeRuZncPEbUBxJllk7ohRa3lL0FczICwma0yrJRcsqRA9f9Z7SqJANkoRfPq
         0MqCZI8F0f+NdyKkkvQUDKRazlR2rXqGEIbcrhg+3aJIBFYXvihqiJu7faO7zVEmhZ
         ldwwj50YJ5U95nz7GAdCeCFeqlJJZieSPC2RBk20umotynnahc3WS8ivVk5KC43dkq
         hXt5g0jAsCX+Q==
Received: by mail-yb1-f172.google.com with SMTP id e127so19012634yba.12;
        Mon, 01 Aug 2022 09:24:27 -0700 (PDT)
X-Gm-Message-State: ACgBeo0qpgCCZvSv8/VS+/PuozatuzNR0YZo+vPhMp9xua5WLF5IwFnY
        8MQd8LcqD9IrCuTKXhxHdoR0m7GHdDwm8JjXbY8=
X-Google-Smtp-Source: AA6agR4v/raQnFILKKm1xhtb4XddsBSQOk8rqJ0sPgcEfnqTO0BM4Koso/btvEPQTHnkFect2LHXHi3pdpgDqDw1D7A=
X-Received: by 2002:a05:6902:110d:b0:670:b10b:d16e with SMTP id
 o13-20020a056902110d00b00670b10bd16emr12277757ybu.259.1659371066993; Mon, 01
 Aug 2022 09:24:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220721175147.214642-1-song@kernel.org> <20220726233302.zwloxsammnu7clu4@treble>
 <CAPhsuW7tmRt=yx1+i62HPRJJ4Gp8xB_3XvpVxUC=SyGv6iCBEQ@mail.gmail.com>
 <CAPhsuW4F8f9GLHF9C54oWyFiyJ0eT5HOwfhmoxSJ3HeRr8zCSw@mail.gmail.com> <YuerYVD+C3XVzDAi@alley>
In-Reply-To: <YuerYVD+C3XVzDAi@alley>
From:   Song Liu <song@kernel.org>
Date:   Mon, 1 Aug 2022 09:24:16 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6M=wOk-72F20p-Vbzka_--k8P3DAziJJh8oi1spEmP-g@mail.gmail.com>
Message-ID: <CAPhsuW6M=wOk-72F20p-Vbzka_--k8P3DAziJJh8oi1spEmP-g@mail.gmail.com>
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

On Mon, Aug 1, 2022 at 3:31 AM Petr Mladek <pmladek@suse.com> wrote:
>
> On Sat 2022-07-30 15:32:58, Song Liu wrote:
> > On Tue, Jul 26, 2022 at 8:54 PM Song Liu <song@kernel.org> wrote:
> > >
> > > On Tue, Jul 26, 2022 at 4:33 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > > >
> > > > On Thu, Jul 21, 2022 at 10:51:47AM -0700, Song Liu wrote:
> > > > > From: Miroslav Benes <mbenes@suse.cz>
> > > > >
> > > > > Josh reported a bug:
> > > > >
> > > > >   When the object to be patched is a module, and that module is
> > > > >   rmmod'ed and reloaded, it fails to load with:
> > > > >
> > > > >   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
> > > > >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> > > > >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> > > > >
> > > > >   The livepatch module has a relocation which references a symbol
> > > > >   in the _previous_ loading of nfsd. When apply_relocate_add()
> > > > >   tries to replace the old relocation with a new one, it sees that
> > > > >   the previous one is nonzero and it errors out.
> > > > >
> > > > >   On ppc64le, we have a similar issue:
> > > > >
> > > > >   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
> > > > >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> > > > >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> > > > >
> > > > 2) We can't only fix x86, powerpc also needs a fix.
> > >
> > > I have very little experience with powerpc. Would someone be willing to
> > > help with powerpc part of this?
> >
> > I guess folks are all busy. Any suggestions on how to test powerpc changes?
>
> You might also send the patch and just mention that you were not able
> to test it on powerpc. There are people with access to powerpc that
> might check it.

Let me give it a try.

>
> Another question is how to actually test it. I wonder how you do
> it for x86.

I tested it with a patch on an in-tree module. I was using kpatch-build and
testing it on 5.18 kernels. This is tricky at the moment for 5.19 because of
this issue:

https://github.com/dynup/kpatch/issues/1277

>
> Finally, also s390 supports livepatching. I guess that the problem is
> there as well. Is is straightforward to write the revert code, please?

v2 of the work doesn't have any real logic for s390. I wonder whether
it is needed.

Thanks,
Song

v2: https://lore.kernel.org/all/20190905124514.8944-1-mbenes@suse.cz/T/#u
