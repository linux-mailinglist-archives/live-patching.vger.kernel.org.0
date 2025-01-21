Return-Path: <live-patching+bounces-1027-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F31A4A1881C
	for <lists+live-patching@lfdr.de>; Wed, 22 Jan 2025 00:03:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6ECA18863F9
	for <lists+live-patching@lfdr.de>; Tue, 21 Jan 2025 23:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 374D61F5413;
	Tue, 21 Jan 2025 23:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cnEZXtaU"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F28D1714A5;
	Tue, 21 Jan 2025 23:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737500630; cv=none; b=rEq75kCsL4wM31OmmlZQH7051MHUAWvXDcmhanYT6MaWclx3rXK9tqnhyjaKHBjw9syAFxmyloy+Dxb2jwJTG3C7Zd6rS6X6GgchoS2Ed4FQw+iHXMDZB5WDAQDiKPvx/+62CL8+VTcSOnU6IE55jZKXs7KxiXgwNybWPjWncc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737500630; c=relaxed/simple;
	bh=TEVj1p1QNDxYjeLcHROrbDCcS5+FcEa7+bKkTN4K9PQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=uXfhgEc+ZT8YyHcek+uw3vrVG8t13yfbAxlkMvLaGVySZn/Ch/iz9ChMtNZSazJRzKoL3tyYQo/QOLZ3zkqiA8wLWs7uhH9aDZMfvvX+M9O3/BboKf33Sz8FMwJPTbt1y/jx1DkNEnuYn2rruY5s5iOHAyGtNq42mFleRzDlsss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cnEZXtaU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E505DC4CEDF;
	Tue, 21 Jan 2025 23:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737500629;
	bh=TEVj1p1QNDxYjeLcHROrbDCcS5+FcEa7+bKkTN4K9PQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=cnEZXtaUES3DIl83onScYum0dKFrZeQYIscY2gK+KLQfjENEdtw3j3BkaTzkyM1n1
	 mF+MG+jLP6EK82GZZoqPN6x/exRf/k7AHYNZF1h9xtdce9yY/DuBT/ZXfs9t8WQ+Q4
	 EBKIwZE6KvMaOfvAoJcI+5r6jrH4PO0aMjysEghwSqbUsMl9WigJP7TXZGmIQ9Hgc1
	 Z6CHcJoowX1FCFjMJRtmSv2K8LOedjBxWYT7F9EKnCcYS2QL3SbQj8MxVDPq9oKwcE
	 qWUrmpDTWu2imMqlyvCCOkIMcRkSObaiwI7FUobmxaYl/LOACIHWykwVfQV96t9QmR
	 L/h8aamlNxD4g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7118B380AA6B;
	Tue, 21 Jan 2025 23:04:15 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 6.14
From: pr-tracker-bot@kernel.org
In-Reply-To: <Z45sEOihzNaOqGwO@pathway.suse.cz>
References: <Z45sEOihzNaOqGwO@pathway.suse.cz>
X-PR-Tracked-List-Id: <live-patching.vger.kernel.org>
X-PR-Tracked-Message-Id: <Z45sEOihzNaOqGwO@pathway.suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.14
X-PR-Tracked-Commit-Id: 49dcb50d6ce33320c28f572f90a9bb9c33d92042
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 336088234e9f85f6221135ba698c41dbf3c9e78e
Message-Id: <173750065408.144655.9125300102485835900.pr-tracker-bot@kernel.org>
Date: Tue, 21 Jan 2025 23:04:14 +0000
To: Petr Mladek <pmladek@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 20 Jan 2025 16:30:24 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.14

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/336088234e9f85f6221135ba698c41dbf3c9e78e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

