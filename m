Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1BAC57E025
	for <lists+live-patching@lfdr.de>; Fri, 22 Jul 2022 12:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiGVKlF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 22 Jul 2022 06:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiGVKlE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 22 Jul 2022 06:41:04 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF3EBB23C
        for <live-patching@vger.kernel.org>; Fri, 22 Jul 2022 03:41:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 5AFF937CBE;
        Fri, 22 Jul 2022 10:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1658486461; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oL8le2mq6ryfC2BV1eQoauq2m+H+jBVmGCFv7zZIY4A=;
        b=MIlsjM6pgmimo7TZ/CSHRyqimR63+R521qLKbqUwdlyqT+9LGzk/t7grwOvTLlU5Imwpjz
        JNMlx0ONqf5r7+Dr0T29BO2lewHfWWWS0Yg+H3CXpPN0ogGfB55aqVL17Q+N0oyEEtIedc
        z91Fslh+ItioepBJyrsUhQT3bsrVTx0=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E13B42C15A;
        Fri, 22 Jul 2022 10:41:00 +0000 (UTC)
Date:   Fri, 22 Jul 2022 12:40:59 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     live-patching@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Cheng Jian <cj.chengjian@huawei.com>,
        Song Liu <songliubraving@fb.com>
Subject: Re: unload and reload modules with patched function
Message-ID: <Ytp+u2mGPk5+7Tvf@alley>
References: <CAPhsuW6xiWe-WSVtJDhcu0+aLN+bKXd76rNcZzx4cpMig2ryNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW6xiWe-WSVtJDhcu0+aLN+bKXd76rNcZzx4cpMig2ryNg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-07-20 23:57:25, Song Liu wrote:
> Hi folks,
> 
> While testing livepatch kernel modules, we found that if a kernel module has
> patched functions, we cannot unload and load it again (rmmod, then insmod).
> This hasn't happened in production yet, but it feels very risky. We use
> automation (chef to be specific) to handle kernel modules and livepatch.
> It is totally possible some weird sequence of operations would cause insmod
> errors on thousands of servers. Therefore, we would like to fix this issue
> before it hits us hard.
> 
> A bit of searching with the error message shows it was a known issue [1], and
> a few options are discussed:
> 
> "Possible ways to fix it:
> 
> 1) Remove the error check in apply_relocate_add().  I don't think we
>    should do this, because the error is actually useful for detecting
>    corrupt modules.  And also, powerpc has the similar error so this
>    wouldn't be a universal solution.
> 
> 2) In klp_unpatch_object(), call an arch-specific arch_unpatch_object()
>    which reverses any arch-specific patching: on x86, clearing all
>    relocation targets to zero; on powerpc, converting the instructions
>    after relative link branches to nops.  I don't think we should do
>    this because it's not a global solution and requires fidgety
>    arch-specific patching code.
> 
> 3) Don't allow patched modules to be removed.  I think this makes the
>    most sense.  Nobody needs this functionality anyway (right?).
> "

Just for completeness there is one more possibility. We have sometimes
discussed a split of the livepatch module into per-object
(vmlinux + per-module) modules. So that modules can be loaded and
unloaded together with the respective livepatch counter parts.

I have played with this idea some (years) ago. It was quite
complicated because of the consistency model. If I remember correctly
the main challenges were:

1. The livepatch module must be loaded together with all related
   livepatch modules for all loaded modules before the transition
   is started.

2. If any module is loaded then it must wait in MODULE_STATE_COMMING
   until the related livepatch module is loaded and the livepatch
   ftrace callbacks applied.

3. The naming is a nightmare.


Ad 1. and 2.: It needs some "hacks" in the module loader. It requires
    calling modprobe from kernel code which some people hate.

Ad 3: Livepatch is a module. The per-object livepatch is set of related
    modules. The livepatch modules do livepatch vmlinux and "normal"
    modules. It is easy to get lost in the terms. Especially it hard
    to distinguish "livepatched modules" and "livepatch modules"
    in code (variable and function names) and comments.


I have never published the POC because it was not finished and it got
less important after removing the most of the arch-specific code.
I could put it somewhere when anyone is interested.

Anyway, I think that it is _not_ the way to go. IMHO, the split
livepatch modules bring more problems than they solve.

Best Regards,
Petr
