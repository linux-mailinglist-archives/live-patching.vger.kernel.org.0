Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF6CBBC39
	for <lists+live-patching@lfdr.de>; Mon, 23 Sep 2019 21:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440470AbfIWTZ1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 23 Sep 2019 15:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727206AbfIWTZ0 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 23 Sep 2019 15:25:26 -0400
Subject: Re: [GIT PULL] livepatching for 5.4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569266726;
        bh=0l4ZfPNuZ16anhWKGlYT8WoJs78vbxnUQFvQklQhILo=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=oNA1cupY3hOSkeT+hFVKG5GEIAsuS0jlHDh+mJjIZcwm5TjaAiIB278jFnnCuMbsu
         wDlmqu9L6+sseYKoISm8RII/nNwiLyifp+/eg6JhkqjX7qgzoVybld6s5K82URUTDH
         +I/XlTADPZgqfDpaXqr8lzuLijLitrN50FaSqsgg=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <nycvar.YFH.7.76.1909222252260.1459@cbobk.fhfr.pm>
References: <nycvar.YFH.7.76.1909222252260.1459@cbobk.fhfr.pm>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <nycvar.YFH.7.76.1909222252260.1459@cbobk.fhfr.pm>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git
 for-linus
X-PR-Tracked-Commit-Id: 4ff96fb52c6964ad42e0a878be8f86a2e8052ddd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9f7582d15f82e86b2041ab22327b7d769e061c1f
Message-Id: <156926672607.9893.2020070265416069332.pr-tracker-bot@kernel.org>
Date:   Mon, 23 Sep 2019 19:25:26 +0000
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The pull request you sent on Sun, 22 Sep 2019 22:56:23 +0200 (CEST):

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9f7582d15f82e86b2041ab22327b7d769e061c1f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
