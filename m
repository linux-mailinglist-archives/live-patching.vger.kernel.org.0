Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6233557C4C8
	for <lists+live-patching@lfdr.de>; Thu, 21 Jul 2022 08:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiGUG5m (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Jul 2022 02:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiGUG5l (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Jul 2022 02:57:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F52978DF7
        for <live-patching@vger.kernel.org>; Wed, 20 Jul 2022 23:57:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BCECB8232C
        for <live-patching@vger.kernel.org>; Thu, 21 Jul 2022 06:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A5DC341D0
        for <live-patching@vger.kernel.org>; Thu, 21 Jul 2022 06:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658386657;
        bh=vCzn6s2vYVeLUiUKCDROwYEVymreMIWcXtcygZOTNPI=;
        h=From:Date:Subject:To:From;
        b=Y2P6Qj0XbjiWn9tz54toEKjSybXJqEeguCQe8GI2vYWZabtpcXG+f528zxcbcC+kX
         8+LjTtaRnH8iUNb9f8br+PEb3DZOQTOWZVTHrKABlRp0PMvU+HfTvf4eW5yHuyTqRo
         hjspp0v47WFocbR4+ljjNe2ou7MfvarBjm0Ax/PLLEe3V0+F/MwWdEuM1P6o0eT3D5
         xS/EEBk2kP67FX3l7tHpE+0leG+c13vVIT/Ku6biOEo50cGVV6WpdqLusJNJEY3o9g
         gT2RHa3JfIu4deRPvfUbUsLYe0OdCHxgvpI4k3Ejg4hcZ542VUfop2mDvY/YC0fNXd
         UDNK6iVikCRTQ==
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-31e623a4ff4so7729167b3.4
        for <live-patching@vger.kernel.org>; Wed, 20 Jul 2022 23:57:37 -0700 (PDT)
X-Gm-Message-State: AJIora9hxqSHkyvElBhfjf7IDKUhb++AsfMkxsDX4XQEQudDjSNhpUNb
        devc5yigsjdD6hJO+XN+6db6/glSRTDeUF/KX7s=
X-Google-Smtp-Source: AGRyM1tcOm9I7ECbRplQQEHkDNi8pV21cTuL9gKFWYPGJK9SWHrD7n2J5b5Q/wAN1p27iNPS7ZP3+G67DvIFeYl610w=
X-Received: by 2002:a81:6a83:0:b0:31e:65a5:dae3 with SMTP id
 f125-20020a816a83000000b0031e65a5dae3mr9355007ywc.148.1658386656675; Wed, 20
 Jul 2022 23:57:36 -0700 (PDT)
MIME-Version: 1.0
From:   Song Liu <song@kernel.org>
Date:   Wed, 20 Jul 2022 23:57:25 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6xiWe-WSVtJDhcu0+aLN+bKXd76rNcZzx4cpMig2ryNg@mail.gmail.com>
Message-ID: <CAPhsuW6xiWe-WSVtJDhcu0+aLN+bKXd76rNcZzx4cpMig2ryNg@mail.gmail.com>
Subject: unload and reload modules with patched function
To:     live-patching@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Cheng Jian <cj.chengjian@huawei.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi folks,

While testing livepatch kernel modules, we found that if a kernel module has
patched functions, we cannot unload and load it again (rmmod, then insmod).
This hasn't happened in production yet, but it feels very risky. We use
automation (chef to be specific) to handle kernel modules and livepatch.
It is totally possible some weird sequence of operations would cause insmod
errors on thousands of servers. Therefore, we would like to fix this issue
before it hits us hard.

A bit of searching with the error message shows it was a known issue [1], and
a few options are discussed:

"Possible ways to fix it:

1) Remove the error check in apply_relocate_add().  I don't think we
   should do this, because the error is actually useful for detecting
   corrupt modules.  And also, powerpc has the similar error so this
   wouldn't be a universal solution.

2) In klp_unpatch_object(), call an arch-specific arch_unpatch_object()
   which reverses any arch-specific patching: on x86, clearing all
   relocation targets to zero; on powerpc, converting the instructions
   after relative link branches to nops.  I don't think we should do
   this because it's not a global solution and requires fidgety
   arch-specific patching code.

3) Don't allow patched modules to be removed.  I think this makes the
   most sense.  Nobody needs this functionality anyway (right?).
"

I personally think 2) is a better approach, as it doesn't introduce any
new limitations. (I admit that I only plan to implement the fix for x86).
3) seems easier to implement, we just need the livepatch to hold a
reference to the module, right? But Miroslav mentioned there are
some issues with 3), which I can't figure out.

So, what would be the right approach to fix this issue? Is anybody
working on this already? If we can agree the right approach, I am
more than happy to implement it (well, x86 only for option 2).

Thanks,
Song

[1] https://lore.kernel.org/all/1561019068-132672-1-git-send-email-cj.chengjian@huawei.com/T/#u
