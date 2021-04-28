Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A89D36D032
	for <lists+live-patching@lfdr.de>; Wed, 28 Apr 2021 03:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235501AbhD1BSa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 27 Apr 2021 21:18:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230460AbhD1BS3 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 27 Apr 2021 21:18:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 09DCF613F8;
        Wed, 28 Apr 2021 01:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619572666;
        bh=Qnc6uhcRff+i34WfEKh4LGbm3CqRJi/J5yXrNAXMVog=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=D8Wwfn3Yv2yQVaUIXZQ0Daucaf6u0wOlEo/WjwcHxlf9q/ttpzNt5qn9kH2casxIh
         2GJwXxFgojy3jx/ok49Emn3aO4lqNOOS5BsILe+clI7YGqtui2oGr6pbRwyTP5XrHt
         xZH/KDnd3ijeUDnJPVHhhujkq4aWuECXnYwBlxVXZEIawgwBHceWqKY/aSz5lYwooc
         UzCTNRr066GIZ0s+YEyj3Kq39PasZ13Lcxc05584wkqEy5aigQyFKnduNDlk/bmh2j
         +449U6Q5u98ifw/XzDCnXA6UKOn0D5DKmrJl4oGSBFKuW248w5BQHMnzsLKvqKzNU+
         O9+cd36/E4mFQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 043B9609B0;
        Wed, 28 Apr 2021 01:17:46 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 5.13
From:   pr-tracker-bot@kernel.org
In-Reply-To: <YIgfdoZ88RrdQ1e8@alley>
References: <YIgfdoZ88RrdQ1e8@alley>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <YIgfdoZ88RrdQ1e8@alley>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-5.13
X-PR-Tracked-Commit-Id: 8df1947c71ee53c7e21c96c83796dd8cf06ae77c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: eb6bbacc46720b8b36eb85b2cdd91b9e691959e4
Message-Id: <161957266601.1632.1631528056790413828.pr-tracker-bot@kernel.org>
Date:   Wed, 28 Apr 2021 01:17:46 +0000
To:     Petr Mladek <pmladek@suse.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The pull request you sent on Tue, 27 Apr 2021 16:28:06 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-5.13

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/eb6bbacc46720b8b36eb85b2cdd91b9e691959e4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
