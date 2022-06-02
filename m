Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D8653BC14
	for <lists+live-patching@lfdr.de>; Thu,  2 Jun 2022 18:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236832AbiFBQHt (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Jun 2022 12:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236809AbiFBQHp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Jun 2022 12:07:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3443F2332CE;
        Thu,  2 Jun 2022 09:07:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9C2FB81F1B;
        Thu,  2 Jun 2022 16:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7CB44C34119;
        Thu,  2 Jun 2022 16:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654186061;
        bh=piSsa5NXHClFSMvolxyl6ObGes8bs9PpEYYDP1ICBkk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=iE+d1SZSgNYs9Y9rIigdY6ev/MLwNp5+kPn+Bj9zirS92KyM/W9uU2iWQFLBgvdIj
         QWxtEHwI7g3YFtQ2nbTVwTzNbq1UF4kkwkZr/fI7kN55TzQnZQCor5jixE6uZUaeuB
         ud6iDD5fTO3/VlG8x0oLFMhGUF+St2CdwWDScgDOTy3gVGbMybpmW0v6pgyZiTcpds
         MgMHlbCnskizdAcOaEwMHI9uje3SVtjBYgk0LLGdsRPbLMT9tCaQhwFZD/lVEinHaj
         yO1DZAc47mSBYmSfOq+gwZfSY9zGXzTBjxlGXQAHQFQb4w/cgZUJpeLmnxkJ+pVXLa
         LQQvxChd9Jh4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 68A6FEAC09C;
        Thu,  2 Jun 2022 16:07:41 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 5.19
From:   pr-tracker-bot@kernel.org
In-Reply-To: <Ypi2UYFKG9ilflSh@alley>
References: <Ypi2UYFKG9ilflSh@alley>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <Ypi2UYFKG9ilflSh@alley>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-5.19
X-PR-Tracked-Commit-Id: 5d7c854593a460706dacf8e1b16c9bdcb1c2d7bb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7c9e960c636306f632ccae623bf94b2b53d35cbd
Message-Id: <165418606142.19639.9440847963346503877.pr-tracker-bot@kernel.org>
Date:   Thu, 02 Jun 2022 16:07:41 +0000
To:     Petr Mladek <pmladek@suse.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The pull request you sent on Thu, 2 Jun 2022 15:08:33 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-5.19

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7c9e960c636306f632ccae623bf94b2b53d35cbd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
