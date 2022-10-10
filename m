Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A065FA396
	for <lists+live-patching@lfdr.de>; Mon, 10 Oct 2022 20:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiJJSsI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 10 Oct 2022 14:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiJJSry (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 10 Oct 2022 14:47:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071FC75398;
        Mon, 10 Oct 2022 11:47:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95D4C60CA0;
        Mon, 10 Oct 2022 18:47:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04EA3C433C1;
        Mon, 10 Oct 2022 18:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665427673;
        bh=gNhxWyCbaLy/U/RSwMltdYkdSEy7q7mdMGMgreLkGxE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=YxHiTEwiBibTlxXhtFZETMoMYT8b2bRt3ZnEo8/Ncgmd+4kRMH0Un2/GX1PzPSi6y
         ABcNog/ep0vQbs/Wsz62lN0Gbop0HCm3dj6C//3nL7xvBRQtWbGtl9DbPYOI7X7cAv
         agG31WHUi+SqzTzSZqHfrORNdF6mK8PS7LLDPZp9XS0r3BMpXfWjmf8uqDIe7CHlwv
         I7L8XkVf/HL6ZdRh+gap3PWMlQZxmO/vl7cIUyy+tAtkRUQASUt0pt1EjT3Sk+cxzH
         yz5ptGCRk3cE+n70WwPv+/T38RNP1QMnILHaFDzycDMYgiZ4kKHCOxLX5XjLgDX5UP
         rOPx4CCTmrtcA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E701EE4D00E;
        Mon, 10 Oct 2022 18:47:52 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 6.1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <Yz1qgrJA+wmbVILN@alley>
References: <Yz1qgrJA+wmbVILN@alley>
X-PR-Tracked-List-Id: <live-patching.vger.kernel.org>
X-PR-Tracked-Message-Id: <Yz1qgrJA+wmbVILN@alley>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.1
X-PR-Tracked-Commit-Id: 59b2a38c6afdc9341ac4fcff455bfdf77113ed37
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4de65c5830233e7a4adf2e679510089ec4e210c7
Message-Id: <166542767293.29715.2266313574078975168.pr-tracker-bot@kernel.org>
Date:   Mon, 10 Oct 2022 18:47:52 +0000
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

The pull request you sent on Wed, 5 Oct 2022 13:29:06 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4de65c5830233e7a4adf2e679510089ec4e210c7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
