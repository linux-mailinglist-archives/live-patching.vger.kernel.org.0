Return-Path: <live-patching+bounces-1893-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF1ACA1BEE
	for <lists+live-patching@lfdr.de>; Wed, 03 Dec 2025 22:58:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EDAF03048D81
	for <lists+live-patching@lfdr.de>; Wed,  3 Dec 2025 21:53:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C73D31280A;
	Wed,  3 Dec 2025 21:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WYwQJNMK"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7807311C0C;
	Wed,  3 Dec 2025 21:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764798787; cv=none; b=tGgV+LA3ibHZQ5PsbYbiGWDXsKjfig0YCaflYc7niJC6GDcNvWl25mXICVMQDlsBjWkbRrz5ydql3TTOa5xePpLwamBa2FGFszfL5PABDuMV+dItCN44K1nzaWMOFstyAZlHe1jMluUS9UhKEoNPZREZQaFxhigRiUWPbOPF19E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764798787; c=relaxed/simple;
	bh=nvNN01Y0phDGJJ/zY9KMZTceEFJSuyq4wI5SSqpSyGc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=JYtMr/lVq9KwQ5akB2LX30UVHNXK6KI0BoHoQgUk/CFXmHLUY+Ko7lKQ7/3Us7pctGXJMtePYh4yutFcmFyr/nqd7YPYEcB75s8tFok8r+q/ZZ0VOWF7QbJr5ffBS3PRADR+MyjaDoa3RBpdTRsf8KN5AixpYIDCTO0e0d57EyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WYwQJNMK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6137C4CEFB;
	Wed,  3 Dec 2025 21:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764798786;
	bh=nvNN01Y0phDGJJ/zY9KMZTceEFJSuyq4wI5SSqpSyGc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=WYwQJNMK793dlrRoGjk9ybenVvJJ0BQQ8YLbV6gvRL2RT6rETGch/ctXnAjJu8EJ+
	 ZdSN5BZz2uOpdV7/3dDIElCHUICYpiohMiktfiFhOKnj/JLpdumoupdYWkmak7vFUF
	 2xx4Iojw2eEtkuHGSx3izkavBy3Ro35iOaN1v7hdI8Npy6PM2T4IIdyEm6855ixiwM
	 CptM4T2QSAhvcPGatN593UfDaLsvVB9V/2uJm/CJEZ59xc2Fo9wvdyXFeZ3b3DGYwq
	 aXHiXLLHKHd8GN0ksiPVS+2+7mTU0BM2f3qmOM26pKG0nFY0x8urKM7h/cDgNBEzJH
	 Y5EyE5GBRdBcQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B8CB23AA9A83;
	Wed,  3 Dec 2025 21:50:06 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 6.19
From: pr-tracker-bot@kernel.org
In-Reply-To: <aS64Vrv7L2ZfVkM9@pathway.suse.cz>
References: <aS64Vrv7L2ZfVkM9@pathway.suse.cz>
X-PR-Tracked-List-Id: <live-patching.vger.kernel.org>
X-PR-Tracked-Message-Id: <aS64Vrv7L2ZfVkM9@pathway.suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.19
X-PR-Tracked-Commit-Id: 5cb5575308bce9d63178fe943bf89c520a348808
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 51ab33fc0a8bef9454849371ef897a1241911b37
Message-Id: <176479860563.93346.12102481800053046095.pr-tracker-bot@kernel.org>
Date: Wed, 03 Dec 2025 21:50:05 +0000
To: Petr Mladek <pmladek@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 2 Dec 2025 10:58:46 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.19

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/51ab33fc0a8bef9454849371ef897a1241911b37

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

