Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A844EA2D8
	for <lists+live-patching@lfdr.de>; Tue, 29 Mar 2022 00:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiC1WPa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 28 Mar 2022 18:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiC1WPP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 28 Mar 2022 18:15:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AB8E06;
        Mon, 28 Mar 2022 15:06:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB0A9B8125A;
        Mon, 28 Mar 2022 22:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D40FC340ED;
        Mon, 28 Mar 2022 22:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648505169;
        bh=XbjSIYBECTdlqxBwdR5hkQ/7bp3J54rhe+gDKbk/cJ8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=O/LSMHR4gdjBW1HErBvauRWUZP6xgyIBMeMZO2/ZCvQpwv5fAc1gzyUdAO7GMw2wu
         RGbRYjncoMbrNPAbLbGw3veUPzkWfistGjMJJNLszLbcrT5lX13tjxZW0PJ+xBxqb8
         FL43lvlYrjaVtXiVvWA7JSTTg0zxxVyIP/g32WOV//E8V0Mn/YXl+V49CREvlOSvyq
         KRn1l1p7/QeE838K0OqrSe8qhEXblGMtmAv2xUfwU5cG8biXxRn5B7VJqEvg809Y1G
         V/UqU5yLPV1X10+yyKfQUf5nkfK3s4MKcrBuUaDcWPWkthyx5Ke1rCz4sPeDCZifTx
         T99M35rEOr+sg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39A7DEAC081;
        Mon, 28 Mar 2022 22:06:09 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 5.18
From:   pr-tracker-bot@kernel.org
In-Reply-To: <YkGcSUol2xzW62tQ@alley>
References: <YkGcSUol2xzW62tQ@alley>
X-PR-Tracked-List-Id: <live-patching.vger.kernel.org>
X-PR-Tracked-Message-Id: <YkGcSUol2xzW62tQ@alley>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-5.18
X-PR-Tracked-Commit-Id: e7dbd4d5369df7d101d6fde5595229df7060939d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d111c9f0344a5e2454726553c663d25e24e38555
Message-Id: <164850516922.27348.1412703268531103352.pr-tracker-bot@kernel.org>
Date:   Mon, 28 Mar 2022 22:06:09 +0000
To:     Petr Mladek <pmladek@suse.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The pull request you sent on Mon, 28 Mar 2022 13:30:17 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-5.18

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d111c9f0344a5e2454726553c663d25e24e38555

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
