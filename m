Return-Path: <live-patching+bounces-854-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AC6A19D4204
	for <lists+live-patching@lfdr.de>; Wed, 20 Nov 2024 19:31:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 697DA1F22A58
	for <lists+live-patching@lfdr.de>; Wed, 20 Nov 2024 18:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4174C15624B;
	Wed, 20 Nov 2024 18:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HSDrsFFm"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D7114F126;
	Wed, 20 Nov 2024 18:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732127490; cv=none; b=cjWnHDBpMnuHlbmO+UeJ6t90cGAvd6nWhP5cyFSAgYPZDQI0gUkmTAxUlvFOL6gocEfsGOvtLMoTQiKlkK539WOJSMvvhkdCVSVc096CmtOuPwRNOGufNHCBe7TQIRjHLBFOX/bx3sBLFR5fUP1xZTFCXrkovRrxec6jeKZLqXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732127490; c=relaxed/simple;
	bh=/RTeZEsROiao5aurbkqLV/hthy8C5jOMbSZ3c2PYNe0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=QHqG241ZnoiYNRFNL9yyNsXAfLq5wQ3vDYBD/5Q9l1XsjET2SX1+blGgOB3vJUWQ/YoSibhp494NbvYfhe0EeauQpx1QKsuhmMaJyc1FLlwsNPekqYYErqzg6rYpVR9JQS6wNBs+LwgRE2b7H28+wlO5u/wv5SCsUeQwwArrhkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HSDrsFFm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F130DC4CECD;
	Wed, 20 Nov 2024 18:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732127490;
	bh=/RTeZEsROiao5aurbkqLV/hthy8C5jOMbSZ3c2PYNe0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=HSDrsFFmfjzXXqXiwZ3cLwGCehR4ue1iiRD/r3tZGATur6CZj6Sii2n6VpdooM69e
	 7QwthJQIzwC+dYnoxSTq4In9mN254psp0Wxbo3MUnZtrpHCIRUUbtAEQeQp7ZmgIoF
	 StqfqlXW/lGHYkkQ/E3FtlSpCrRMn5Zj0PErBKyhZw8zKmz83V7on9szRgGEpZL5NM
	 TiZwcLyDhGVBOk3e9J21jUJMN5evxYJ3TzMEDiylHcmQW1VwX8+Obh4W+dgwEUrX10
	 TeNm6deineiu13KcSZ6rxtYTlMbxnxorSuThzCxCTu1k8UAdLhF+9AxBSulpbwuO1u
	 RJCk+nwAhHjgw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAF2C3809A80;
	Wed, 20 Nov 2024 18:31:42 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 6.13
From: pr-tracker-bot@kernel.org
In-Reply-To: <Zzs7U8VsO8YmxxD4@pathway.suse.cz>
References: <Zzs7U8VsO8YmxxD4@pathway.suse.cz>
X-PR-Tracked-List-Id: <live-patching.vger.kernel.org>
X-PR-Tracked-Message-Id: <Zzs7U8VsO8YmxxD4@pathway.suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.13
X-PR-Tracked-Commit-Id: 62597edf6340191511bdf9a7f64fa315ddc58805
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: aa44f41470450f3f4fc74526c1f7369771545205
Message-Id: <173212750156.1310468.13211242005675507614.pr-tracker-bot@kernel.org>
Date: Wed, 20 Nov 2024 18:31:41 +0000
To: Petr Mladek <pmladek@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 18 Nov 2024 14:04:19 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.13

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/aa44f41470450f3f4fc74526c1f7369771545205

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

