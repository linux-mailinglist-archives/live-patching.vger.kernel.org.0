Return-Path: <live-patching+bounces-15-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 856917E09AD
	for <lists+live-patching@lfdr.de>; Fri,  3 Nov 2023 20:53:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 32DF0B21240
	for <lists+live-patching@lfdr.de>; Fri,  3 Nov 2023 19:53:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DCA622F19;
	Fri,  3 Nov 2023 19:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XhTAP0uL"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1361414F88
	for <live-patching@vger.kernel.org>; Fri,  3 Nov 2023 19:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9889C433C8;
	Fri,  3 Nov 2023 19:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699041206;
	bh=UBtYjEjxkKNO72SVLpcqrHR1PFbxMty7li5i6Z5KTu0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=XhTAP0uLM1DElz2mmZLmTyRi3sjXuhhN4jbgR4CzL2D4yemzScieu3TO1BhemCHA/
	 uNJsDmhAjdH/M87aDq84QBYU4wxD5bOJqmn0ZmD5hLWTyCxFPMnJYjsdPgTHQ6bg59
	 y0nwYPj5GseQhMcduMUSSHC9cJD5zlL6PBR9Y7l/2QJAiSUJ8jgK3Svxn5qw7keAax
	 lbg8bjPno2k6aY6cuMY+k3OW2LwQIUn0yVSsgjJzJSuhsZKA3wsFzp0yPC3Ya2kf+g
	 YlhgvF1RGgp31lnkVU0WeRgakc2VEwkh5hOfkNLpVgC+WYxRp3dUADzLNbu51rQOb/
	 RqW1JSAdS9ipQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C7FDEC04DD9;
	Fri,  3 Nov 2023 19:53:26 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 6.7
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZUOLil38w_VHEdvD@alley>
References: <ZUOLil38w_VHEdvD@alley>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZUOLil38w_VHEdvD@alley>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching tags/livepatching-for-6.7
X-PR-Tracked-Commit-Id: 67e18e132f0fd738f8c8cac3aa1420312073f795
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 00657bb3dbecee324336e1da1ad71b670b6aee60
Message-Id: <169904120681.17286.4453249699265290666.pr-tracker-bot@kernel.org>
Date: Fri, 03 Nov 2023 19:53:26 +0000
To: Petr Mladek <pmladek@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 2 Nov 2023 12:44:10 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching tags/livepatching-for-6.7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/00657bb3dbecee324336e1da1ad71b670b6aee60

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

