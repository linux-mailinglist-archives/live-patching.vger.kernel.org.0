Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDBFE64AC83
	for <lists+live-patching@lfdr.de>; Tue, 13 Dec 2022 01:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbiLMAg1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 12 Dec 2022 19:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbiLMAg0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 12 Dec 2022 19:36:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68805164AB;
        Mon, 12 Dec 2022 16:36:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06A0C612C5;
        Tue, 13 Dec 2022 00:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6DFF6C43392;
        Tue, 13 Dec 2022 00:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670891785;
        bh=IO7W4zaIVFcQ4Xs66RZkLODQ/o0b/RqwpwH9576oMqE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=VYIbFH8I6qRsHYTBKv3aG+/WpYueQy9FcTmXTPT25Ie/kATh5yHkqw1UB5L/5qmn1
         HtJffpbC8FcfKwjbijmyKvnSyGVKaFRm61XTYzHsN31xb6vwvY3ZJwTfiOhUcT1Dvo
         7HB40eP7HCPyNEN/5/S5tNrCiaOuDtbV53WDHNjQfvVsQKj3XmoJYKqrKVN2TaTAeq
         l9lQevxstKglN2cRo119q7QVHu+dlwBe1jIsBnUdHUY1o3+6i9FLJVYUHUNLjsoTU6
         DXw6kb4dXxSIGvWJ5rnVYs0a0J6njmsF36AxutnmFYTsEbgFQ54vdHAuDv/e1pyGKi
         Yzi7p+yaMcFgw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5DEB1C00445;
        Tue, 13 Dec 2022 00:36:25 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 6.2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <Y5dBjz3g1V0exuIp@alley>
References: <Y5dBjz3g1V0exuIp@alley>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <Y5dBjz3g1V0exuIp@alley>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.2
X-PR-Tracked-Commit-Id: 53910ef7ba04fbf1ea74037fa997d3aa1ae3e0bd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e1a1ccef7a4f3a3058cd6c039a56b4c2c98479f1
Message-Id: <167089178538.4798.1205537189473527433.pr-tracker-bot@kernel.org>
Date:   Tue, 13 Dec 2022 00:36:25 +0000
To:     Petr Mladek <pmladek@suse.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The pull request you sent on Mon, 12 Dec 2022 15:58:23 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e1a1ccef7a4f3a3058cd6c039a56b4c2c98479f1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
