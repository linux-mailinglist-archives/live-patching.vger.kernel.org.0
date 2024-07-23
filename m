Return-Path: <live-patching+bounces-402-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54E6293A78C
	for <lists+live-patching@lfdr.de>; Tue, 23 Jul 2024 21:03:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E8C81C2241B
	for <lists+live-patching@lfdr.de>; Tue, 23 Jul 2024 19:03:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6526B13DDA7;
	Tue, 23 Jul 2024 19:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MkOZ69tg"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F96B13DBA4;
	Tue, 23 Jul 2024 19:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721761426; cv=none; b=Bij+w+UHDCQzLpk/Vp1eK9yoW9sqESHTYCRU3/paGZrf4n31+BZssktTGYZhUS/r3czVhTYpbuv69h1SItocUbJ5KnGrN3QeffGqaMiGWbMBSy8xeI1wH+zX0+cWBCWqdTbZRqoIr3kFIr3ZTl/QypOdUv3T8g+etQYWlHNv6As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721761426; c=relaxed/simple;
	bh=LybILGvh50PjrvN7E4HwtbEPNWsoKdkuRaBz4Dms1sE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=BxTVOhgR19rDDUdXVOWTfa/1lmitExfTbgEojAZd5yQkjZzE9okURj+yPeRp0s1zBWa5Xs2cqO3BeXNW32FBb+C+VJf0YBtVlsm099wyZd+zZRzZoMSt3sMH/JRaf3ygBarFbEcJGshJznqi3bBhI/WekgjhVdFM2WrSreppoEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MkOZ69tg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9830C4AF0E;
	Tue, 23 Jul 2024 19:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721761425;
	bh=LybILGvh50PjrvN7E4HwtbEPNWsoKdkuRaBz4Dms1sE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=MkOZ69tgsVMYN2Ahyrt2UAo9pS9lVfaoI38v8l+DaiN3tXAeymakoXCpXXobtjzw8
	 O7ontA5mCbHqff8a/G+yu7V3FNMqLiYEU7LZRXrRIKBQjj3SFK9cPG0dP0OlS7KBYx
	 ROvc8SY8DgypDi8tzpu++6Now7wgyfqGSlr2Xa6SHBVtY1WV9UMQ361wcAeatvGfzB
	 LoWlw7PhPCEyTnyX8/DOrd1HQdLGmVF9a7gCZUIZVZUrj7hSoFjgsay9EbwiZiNDvN
	 eYxL2HZ8usA2C+vcvO56SgfLU0bd3YBDqy8ppWk6889n2faT3kSEKeOE9Hcq1bqALE
	 oTeIhM/a32cqw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA44DC43443;
	Tue, 23 Jul 2024 19:03:45 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 6.11
From: pr-tracker-bot@kernel.org
In-Reply-To: <Zp_QTDDsvyPtCgrl@pathway.suse.cz>
References: <Zp_QTDDsvyPtCgrl@pathway.suse.cz>
X-PR-Tracked-List-Id: <live-patching.vger.kernel.org>
X-PR-Tracked-Message-Id: <Zp_QTDDsvyPtCgrl@pathway.suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching tags/livepatching-for-6.11
X-PR-Tracked-Commit-Id: ea5377ec49f29baaf50cbffa986a8ae667b7eaff
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d2d721e2eb1337c67f0c5bba303f8a013b622bed
Message-Id: <172176142569.11519.7619428302013998165.pr-tracker-bot@kernel.org>
Date: Tue, 23 Jul 2024 19:03:45 +0000
To: Petr Mladek <pmladek@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 23 Jul 2024 17:46:20 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching tags/livepatching-for-6.11

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d2d721e2eb1337c67f0c5bba303f8a013b622bed

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

