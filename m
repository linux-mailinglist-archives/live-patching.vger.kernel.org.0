Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DC6321FFD
	for <lists+live-patching@lfdr.de>; Mon, 22 Feb 2021 20:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhBVTU0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 22 Feb 2021 14:20:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:51048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232913AbhBVTRA (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 22 Feb 2021 14:17:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 47AED64E57;
        Mon, 22 Feb 2021 19:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614021124;
        bh=TisF0WqPeRTvGcIracJDLuQa1NMfjGLI/c/0Pm+E6Bw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=n8+cgbF/f0zsy3Sbif/F/nvT2jjOiQPbKIKuSWwVIuXSjav6UUeWc8Kg/wtA2gFc+
         GaQrVD0nkIUjCSXPG+e2Ve2hpKaoY9QGE3kkfBfGFhxN0DXRGosiBjxwv7mV9bPmf9
         9mDdxZUvBa3W8mALfhJdDukEMkwZwvN3NNBdNpcdtEs3OrPK0sWkDG1ccLtmy5UTar
         oEUnsmMjfUh8puO+dhKZYJmmg/eYFZ8ORzyy14G71LgA6brfJE+Bu4tfmWaawWZQE1
         WnEzmPU74i6VhAzijYijnggyFjlNirZ8iFUsCavrjdsPXZeqt9gFe6/BHoKAnS97hk
         k7AFbVwdw9izg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4326160963;
        Mon, 22 Feb 2021 19:12:04 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 5.12
From:   pr-tracker-bot@kernel.org
In-Reply-To: <YDO/aM82PiGprdPQ@alley>
References: <YDO/aM82PiGprdPQ@alley>
X-PR-Tracked-List-Id: <live-patching.vger.kernel.org>
X-PR-Tracked-Message-Id: <YDO/aM82PiGprdPQ@alley>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-5.12
X-PR-Tracked-Commit-Id: f89f20acff2d0f7a4801dc6ecde3de1ef0abe1d2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 54ab35d6bbc0d3175b0a74282c3365c80a43a93c
Message-Id: <161402112427.16114.2758103562111713691.pr-tracker-bot@kernel.org>
Date:   Mon, 22 Feb 2021 19:12:04 +0000
To:     Petr Mladek <pmladek@suse.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The pull request you sent on Mon, 22 Feb 2021 15:27:52 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-5.12

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/54ab35d6bbc0d3175b0a74282c3365c80a43a93c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
