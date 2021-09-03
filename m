Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DE8400536
	for <lists+live-patching@lfdr.de>; Fri,  3 Sep 2021 20:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349933AbhICSqn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 Sep 2021 14:46:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349741AbhICSqm (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 Sep 2021 14:46:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9251E61051;
        Fri,  3 Sep 2021 18:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630694742;
        bh=JvQTnVEs9NJbwgJjg00AGoLLig7sFDfmJ80sdCYqlGQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=t4C2uEr91mZwrHYm2M6SOHAuET6+/9Tm1tK0yDBNKRGV/tYnKTQq0R1Ok6DfrJ08w
         19/ZTIgPgPWUyOBAJ13EZPje5LRRejRUTx1JuoEjKMbMuK53QcaqjS1brbeRvwoD/u
         O7bX1NkO2lcMM3aisPO/FY7zeSYXTsMEau1I/DWyr8wg06cql43VJf7MKp2S1X6b6n
         OtHaoJmzLWnmvESekwnKDeJVlQFWvfp793TqEFk38zXwUxAaax7WqZe3YAeM9CP+ql
         IJJqRnbXRIatH74PpAVVF0ogZi1He0hqriDO8W86ZI0euVDVzef7ovaVfgoZLaVhXD
         RNRkC1CerRbfA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7FE2F609D9;
        Fri,  3 Sep 2021 18:45:42 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 5.15
From:   pr-tracker-bot@kernel.org
In-Reply-To: <YTCZ07u6Fx4QiGoy@alley>
References: <YTCZ07u6Fx4QiGoy@alley>
X-PR-Tracked-List-Id: <live-patching.vger.kernel.org>
X-PR-Tracked-Message-Id: <YTCZ07u6Fx4QiGoy@alley>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-5.15
X-PR-Tracked-Commit-Id: 1daf08a066cfe500587affd3fa3be8c13b8ff007
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 50ddcdb2635c82e195a2557341d759c5b9419bf1
Message-Id: <163069474246.21432.13500487839725018871.pr-tracker-bot@kernel.org>
Date:   Fri, 03 Sep 2021 18:45:42 +0000
To:     Petr Mladek <pmladek@suse.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The pull request you sent on Thu, 2 Sep 2021 11:30:59 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-5.15

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/50ddcdb2635c82e195a2557341d759c5b9419bf1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
