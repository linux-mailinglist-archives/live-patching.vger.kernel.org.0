Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9042C14AA4E
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2020 20:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgA0TPN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 27 Jan 2020 14:15:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729191AbgA0TPJ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 27 Jan 2020 14:15:09 -0500
Subject: Re: [GIT PULL] livepatching for 5.6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580152509;
        bh=1azPFhs+ngU+mm6Kh1N8rpJSKafszaa7XNMV6XziuuQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=k5eD9p7l0DTe/h8iF8tlqMieKwcejDaQNEKeHxCq2XhlnudvB0rADeBBdQ/gKCFIV
         1ViXiHGlP6bKdUVxA0USJ8s0qJt3+Y4DJZBTZYY8D7FHLHseeR0yflRfh96rJ/ApsI
         0JTN9Zp8IPGuphW4JYeNi8uOI1d/Wv0YBz3+7HR8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <nycvar.YFH.7.76.2001271556370.31058@cbobk.fhfr.pm>
References: <nycvar.YFH.7.76.2001271556370.31058@cbobk.fhfr.pm>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <nycvar.YFH.7.76.2001271556370.31058@cbobk.fhfr.pm>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git
 for-linus
X-PR-Tracked-Commit-Id: f46e49a9cc3814f3564477f0fffc00e0a2bc9e80
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 715d1285695382b5074e49a0fe475b9ba56a1101
Message-Id: <158015250923.1024.16463433153496465405.pr-tracker-bot@kernel.org>
Date:   Mon, 27 Jan 2020 19:15:09 +0000
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The pull request you sent on Mon, 27 Jan 2020 15:59:38 +0100 (CET):

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/715d1285695382b5074e49a0fe475b9ba56a1101

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
