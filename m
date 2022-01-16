Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D64748FB96
	for <lists+live-patching@lfdr.de>; Sun, 16 Jan 2022 09:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234659AbiAPIWa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 16 Jan 2022 03:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234688AbiAPIWa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 16 Jan 2022 03:22:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F45C061574;
        Sun, 16 Jan 2022 00:22:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BACF60DD9;
        Sun, 16 Jan 2022 08:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0C99EC36AEC;
        Sun, 16 Jan 2022 08:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642321349;
        bh=Yrvpbuod0RygtyS4mkrxsscJP7cfOB6nMZf6I5/H6Es=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=rjQbzy3Wxh/srDtH6DX5CHpBW/ZdwOe5ktYdiXQ9h0A/4NnTU5KjWX0UdETZmKdYb
         5U+jbbVKney6XlQITlmbqQUGXAphh2oHfDGimOTAhc89q7FdmPwX6FswkvBudV7THv
         LUFgtsPH+UydOZ6HVWOaMnv4d5qMMOh7SVJctM61l6p5KGdVao643EhjJgtVolahET
         rxtgR3jsSGoMS9l8zPvXLC1tW1lRHSDjjH2O+VtNaCTi4oEEu2jGNJHap71Gl+zX9+
         4l4dl2oh7SrzQXnr+CPwiUo7OlCPVwpGM6eblD1Pgn+Mi+aNqRxQYI+MRfGTKowQtN
         5XFDelZB9ZD/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EF6C1F60794;
        Sun, 16 Jan 2022 08:22:28 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 5.17
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220114155727.GA17419@pathway.suse.cz>
References: <20220114155727.GA17419@pathway.suse.cz>
X-PR-Tracked-List-Id: <live-patching.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220114155727.GA17419@pathway.suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-5.17
X-PR-Tracked-Commit-Id: b2dfc3fe73b5b305b13467e39386f77133590ea8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 77dbd72b982ca648b42b4feac5f8b2ea55e4ed09
Message-Id: <164232134896.9530.10751707727863195985.pr-tracker-bot@kernel.org>
Date:   Sun, 16 Jan 2022 08:22:28 +0000
To:     Petr Mladek <pmladek@suse.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The pull request you sent on Fri, 14 Jan 2022 16:57:27 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-5.17

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/77dbd72b982ca648b42b4feac5f8b2ea55e4ed09

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
