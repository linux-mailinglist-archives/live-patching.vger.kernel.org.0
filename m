Return-Path: <live-patching+bounces-527-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C4E4961711
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2024 20:36:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58472288BE8
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2024 18:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1EB31D2F61;
	Tue, 27 Aug 2024 18:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WkD3w1zd"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2231D2F57;
	Tue, 27 Aug 2024 18:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724783786; cv=none; b=U1t/gWvxzu9cyZPQgxIESz8Q9+/1rM+hkAqsaK9YlxkqgmXJW8OB8/sR709oLCuhUh0j7Ja0pYWDDJRrijAQv0mEZPIb7OmxIuVPffjbHLRBA5ePkLOJY5OSPny2fEKa1vebghSXPBrJ4LUSy+zleRszbXHSGTSIjoohMuJbXBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724783786; c=relaxed/simple;
	bh=19ZGdic4r/rZCyXjoXMmK4vPxZJc0UQvbrDYnxb8K4M=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=mp6IFcNPW0JzUQ/bXXKGPXgFjCmh2i8ArAmbze069bzsle0iWRkIGaBMzuiPtxaSLNqJOQG8g1O+Wk43b52ScPekQ5OZXbBY3F5AeIxj5ofs0FtOnDIotRP4LTLcoxMn/nVhCfdNsQxa6YjoH21wK5/nHrSeDP011b5micQnhnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WkD3w1zd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7DFC4AF55;
	Tue, 27 Aug 2024 18:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724783786;
	bh=19ZGdic4r/rZCyXjoXMmK4vPxZJc0UQvbrDYnxb8K4M=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=WkD3w1zdajJn/+SRkpZZHcoqm+KzhmwjrUbLe93TDXtsgNRxsE2SQbmYdYsO80Mmz
	 Y3+CxCrsNtYaEFmXL72U25+VJ7ktxs9Qf0oTLo6qYaTgazCzt3A8bWTynQFg2Af1va
	 k96oO2VcNPpG77pPyhnF9goCGEjTUxn1DmViPZcAjCh0E9klgXPC6WF0cw2GbssDBt
	 QgzPUSZTYXcgk6n3+aLz+T9MEF1/vhYcIIoFpwVhtzRZFoSI4YmGpRE80onldCOhWH
	 YaqvxMWKdY+FXrqHyKDde/XOr5CHuTf75mcDLghrFB9+/TfVG7Ej0RTR9iLLvwt9aj
	 3L6AEoCxWSE0A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADDD53822D6D;
	Tue, 27 Aug 2024 18:36:27 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching selftest fixup for 6.11-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <Zs2rKFzj-EhYoHa3@pathway.suse.cz>
References: <Zs2rKFzj-EhYoHa3@pathway.suse.cz>
X-PR-Tracked-List-Id: <live-patching.vger.kernel.org>
X-PR-Tracked-Message-Id: <Zs2rKFzj-EhYoHa3@pathway.suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching tags/livepatching-for-6.11-rc6
X-PR-Tracked-Commit-Id: 052f3951640fd96d2e777b3272a925ec6c0c8100
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3ec3f5fc4a91e389ea56b111a73d97ffc94f19c6
Message-Id: <172478378619.730673.12714360658710834024.pr-tracker-bot@kernel.org>
Date: Tue, 27 Aug 2024 18:36:26 +0000
To: Petr Mladek <pmladek@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 27 Aug 2024 12:32:08 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching tags/livepatching-for-6.11-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3ec3f5fc4a91e389ea56b111a73d97ffc94f19c6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

