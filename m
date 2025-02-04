Return-Path: <live-patching+bounces-1110-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58837A27A2E
	for <lists+live-patching@lfdr.de>; Tue,  4 Feb 2025 19:40:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C973E3A3AE5
	for <lists+live-patching@lfdr.de>; Tue,  4 Feb 2025 18:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8753121885B;
	Tue,  4 Feb 2025 18:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n1oXreGq"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7312185B1;
	Tue,  4 Feb 2025 18:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738694387; cv=none; b=O/Y6Uze928VjlXllLDreugMGUse9v5Fd7uJ50MkLjN945oiJ1edj6lourVpaGzDVAcKJJAF9cezzIejO9gca7AVJ26Fs15UnwKTq6Pwl7z5gJts+OC7/9POIdfxbV1nR5EOp3buckESokGg679HYysMvMopOrAqPiR8sLZxhF2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738694387; c=relaxed/simple;
	bh=nXDppY7hVhMN2RySzAJomNjjStNhe8pVrcD+Grqba8Q=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=bwOdIr5nuOtsSgq35ShFPpj7Jye4t7EXPLEoBsN1JrADjjdh9+66UNWjuCo59LNHatyVXxISp5m+8iNaWtvjTUYLuwT5b3g1HNOx4spieYUjpnE74pgW6MZvTNeEEShclIq7XPxFpyG3zhcZG2KjwKgesa+vtTAun4Dotv0NtjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n1oXreGq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DC5C4CEDF;
	Tue,  4 Feb 2025 18:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738694386;
	bh=nXDppY7hVhMN2RySzAJomNjjStNhe8pVrcD+Grqba8Q=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=n1oXreGqJzGRtXvuzdQzvqaws8v3aEWUGNTu1WKo+INZg+oIyI5XDajC6ViEdca+h
	 kNNiIgmSvQF4U3HXZeRacUgbmdEB1B1w+KH+u3nkqI6A+yI4lj/QebNcguIMIp33Lm
	 ygH8s4pVAVTCU487aLCGsNlvAUBwX6Sgfk0MtIGVl237+S9JuowRAAn3xSnJ+dS9ck
	 KLWD9bPeg73X2dpPPtgcmxaCsXgQN6HYL4reVoJCGz08J9DZQ4KcgPox9RqfXTK085
	 5yvw5TOsn6RKjKLuDSchWILiwe/LWyOXZGzuYbPuFhdrvhHI91TsJ9umn7cFw9nEat
	 pA8nqU1F6PjRQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33F93380AA7E;
	Tue,  4 Feb 2025 18:40:15 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 6.14-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <Z6IFwZwdjFGvpYMP@pathway.suse.cz>
References: <Z6IFwZwdjFGvpYMP@pathway.suse.cz>
X-PR-Tracked-List-Id: <live-patching.vger.kernel.org>
X-PR-Tracked-Message-Id: <Z6IFwZwdjFGvpYMP@pathway.suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.14-rc2
X-PR-Tracked-Commit-Id: 28aecef5b1015bf6023ddc12b1a67f6678271fcb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d009de7d54281f5c23d7d82ec5e6e2d54609791a
Message-Id: <173869441387.99131.7251613705763744190.pr-tracker-bot@kernel.org>
Date: Tue, 04 Feb 2025 18:40:13 +0000
To: Petr Mladek <pmladek@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 4 Feb 2025 13:19:13 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.14-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d009de7d54281f5c23d7d82ec5e6e2d54609791a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

