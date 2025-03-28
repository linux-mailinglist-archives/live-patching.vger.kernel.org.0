Return-Path: <live-patching+bounces-1345-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E4314A7424E
	for <lists+live-patching@lfdr.de>; Fri, 28 Mar 2025 03:31:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBCA71B6026F
	for <lists+live-patching@lfdr.de>; Fri, 28 Mar 2025 02:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA0220E01A;
	Fri, 28 Mar 2025 02:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XF6AeWLv"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344A120E00F;
	Fri, 28 Mar 2025 02:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743129041; cv=none; b=Uz7E0YGIuPLLlF3P84pxtLZM7AciHhVP7+7P4yYeblWvtYrQffdO3YjcBpioF2yMv5a9UUF0cXz2SsNGWPYQ5xE1tebTG8MWgq7L8L3lji6LEe5ukw0EVZTX425YauQXCFWN/c1N1KqQAKfUMIXYejElsxbCH4vimPgr6yMhJnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743129041; c=relaxed/simple;
	bh=0VtiQ4EFYgr9gJBGY0SElaop9wa03AbmHYms8v1IkEU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=hooVJ368JIhzspeykbHkIwB9GG9giCi09iD20PtWc/RmWyncz9UC/ZhM5lf7SdnP93S+FKV0vnEYk9Mmo2wFM9SwC+v+ZfOxlcfp+3V2cp0422oIcnLKCqI3IKcStKlvONXzapdpzU6+l3f86hF1oDGzIthgSEpGRTrukzeGFwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XF6AeWLv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F40C4CEEB;
	Fri, 28 Mar 2025 02:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743129040;
	bh=0VtiQ4EFYgr9gJBGY0SElaop9wa03AbmHYms8v1IkEU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=XF6AeWLvAXyICt3N4im0X4z7HIMs6UDb93bU6qbz50dljIh3vWLdI/C5M89CfgiqS
	 RuWbxUpUC4z0sjZXCPGWNzDbO99YMzaMPu8EfSx3MIegvnwStsITLYtLZpJe/mSnzQ
	 uAA5ccar64S3fHDiJCvPHZc9W7dbY6IizQO67xaHCnsm38rYwKDxjPwMVsnIgtzjVB
	 6ODpEYFa2gBsYo6f1Sthhzfr2tdrBBli2TJjUdZ7yMF2illonSmQAR1guBocD5jbqB
	 D6Q1+hWf2WWSk82ny2az96EzU4UBqOZOiAuXkY/NaIkRt4fVSD0bsch8jXAH2Ghw9E
	 LXoULpAAPiDzQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33D65380AAEB;
	Fri, 28 Mar 2025 02:31:18 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 6.15
From: pr-tracker-bot@kernel.org
In-Reply-To: <Z-UzRZybK1du6HYM@pathway.suse.cz>
References: <Z-UzRZybK1du6HYM@pathway.suse.cz>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <Z-UzRZybK1du6HYM@pathway.suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.15
X-PR-Tracked-Commit-Id: d11f0d172a3c2ea9cbe9b07abd47d5b767600ad9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: dcf9f31c62b3d31c033ee5bce522855c3d7f56b1
Message-Id: <174312907683.2320867.6977831162850105594.pr-tracker-bot@kernel.org>
Date: Fri, 28 Mar 2025 02:31:16 +0000
To: Petr Mladek <pmladek@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 27 Mar 2025 12:15:17 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.15

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/dcf9f31c62b3d31c033ee5bce522855c3d7f56b1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

