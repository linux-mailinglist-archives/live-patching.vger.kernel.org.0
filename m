Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC5E16900
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2019 19:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbfEGRUI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 May 2019 13:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727444AbfEGRUI (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 May 2019 13:20:08 -0400
Subject: Re: [GIT PULL] livepatching for 5.2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557249607;
        bh=t9O2eKSF+zDivq1waaSuJAKn2KvU3HkDABeNSg8XkJk=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=a0eEB/H8jCyUqfxQKWGbvDScpD4de46m5hTN7c6u26RQ+ZJ6VHTirMWyS4qR0PZzc
         uim1j48DUNvZCxF+iFIzHNCPxY0NMFGWwQQ/T6CJhFCbwj9+DUb2iQHqZKmmWeoGwC
         +VnJP28Pqbrv50NLhtY34RSOgnDK8XvPx9TyzlQA=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <nycvar.YFH.7.76.1905061556400.17054@cbobk.fhfr.pm>
References: <nycvar.YFH.7.76.1905061556400.17054@cbobk.fhfr.pm>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <nycvar.YFH.7.76.1905061556400.17054@cbobk.fhfr.pm>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git
 for-linus
X-PR-Tracked-Commit-Id: 1efbd99ed41db9ddc3ae7e189934c62e9dbe55c4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 573de2a6e844cb230c4483833f29b8344a6a17cc
Message-Id: <155724960792.23705.9549107939395279414.pr-tracker-bot@kernel.org>
Date:   Tue, 07 May 2019 17:20:07 +0000
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The pull request you sent on Mon, 6 May 2019 16:04:19 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/573de2a6e844cb230c4483833f29b8344a6a17cc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
