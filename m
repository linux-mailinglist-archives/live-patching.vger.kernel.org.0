Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DB228FB11
	for <lists+live-patching@lfdr.de>; Fri, 16 Oct 2020 00:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731645AbgJOWT0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 15 Oct 2020 18:19:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731189AbgJOWTZ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 15 Oct 2020 18:19:25 -0400
Subject: Re: [GIT PULL] livepatching for 5.10
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602800364;
        bh=AmD9eF7iGEc0dwK/aaxxnC31vs9NAjgaesdQHjBBHsE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=fcWiFlGsQIkIcfqfvbL0eV2qD9NOHaHE6mrLgYHikHYIQFSAlD0Pz8fPlNgD2t3Md
         yiPP9dpyeQnwk7Iv2PU/fQS32ooXPw+n4ZHxpsqXkbSbjPzAmgXGQiwVSNaYcqSEZJ
         9USRAYsj8vyLuDRZF5/j2RimskNLChW/+HrHoz3w=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <nycvar.YFH.7.76.2010151950140.18859@cbobk.fhfr.pm>
References: <nycvar.YFH.7.76.2010151950140.18859@cbobk.fhfr.pm>
X-PR-Tracked-List-Id: <live-patching.vger.kernel.org>
X-PR-Tracked-Message-Id: <nycvar.YFH.7.76.2010151950140.18859@cbobk.fhfr.pm>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching for-linus
X-PR-Tracked-Commit-Id: 884ee754f5aedbe54406a4d308a6cc57335747ce
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0cd7d9795fa82226e7516d38b474bddae8b1ff26
Message-Id: <160280036480.16623.4178503158509734625.pr-tracker-bot@kernel.org>
Date:   Thu, 15 Oct 2020 22:19:24 +0000
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The pull request you sent on Thu, 15 Oct 2020 20:31:55 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0cd7d9795fa82226e7516d38b474bddae8b1ff26

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
