Return-Path: <live-patching+bounces-2372-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kPy6A+3+4GkSoQAAu9opvQ
	(envelope-from <live-patching+bounces-2372-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 17:23:25 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 692A24109C6
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 17:23:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C8F82311F2DE
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 15:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3561C3E3D83;
	Thu, 16 Apr 2026 15:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GYvTB9sz"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12326368275;
	Thu, 16 Apr 2026 15:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776352777; cv=none; b=hhMl+EIKMISBmMXrBvEw3ZThX9QAzRz8JLm/Fs41GrjlGR3VTaepp0KAa60wFh1u4UONvzdelR47IMM/5PhJzgDI/WFFpoRMgHi+iFhh61yF7t4j8X9meBuP8y5s8IwydEEURZR99cSGNFrmRzYUrxW8FgbJnEQ6tw5rokFOQ5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776352777; c=relaxed/simple;
	bh=NAP8nR3InBqu3NuNlfAW6q1rBnMAOMNUDGEZDTM3E/8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=UB68Lw8AEMEFSTrtgpQt/Ep5/V9hubzbZSNcomPaKMLCFTroRj5hADkQPjXn7k6roXVBgR0f1U0hx8TE/R2HtJxVFrU0/p35LRdWOnyXFdWX6y1FlLuXG5NKDJoHuco1vsg4dKHAFo1ubVoYKp61wyXJ511bgvz1JoI/WYayTOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GYvTB9sz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1AEC2BCAF;
	Thu, 16 Apr 2026 15:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776352777;
	bh=NAP8nR3InBqu3NuNlfAW6q1rBnMAOMNUDGEZDTM3E/8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=GYvTB9szTElidivLREY/d1pjjeWMXpi7h6i/Be5VnB/P85iSvwFo5j/uajk1WMaq8
	 sGmJq7aei1zrb4u1JNCFk1geFle+bL9eJhgjTmGuJWwW1sW2kp0EBEcs5jSOg5ryD+
	 q0qmtcDNsqgCCO5N4KCwCHp1mxUPk9Oj+oTuNpvpkroQUOk0sHM0pJOSM0gcKDJoTH
	 dCrhZnVgjWlOBCyapMeCnAhzKjrn6LtWSg3Grq/n3whlOzL9qjNLB25oY9vvI3VIRO
	 OdCWkbVV0e+tlFNKuk+iMJVgqzY0q3q6NWyzLQeGAtKaai7qgJ/TY7iETqHPE0nZ5B
	 sbr1tnF/aR2Eg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9E90380AA63;
	Thu, 16 Apr 2026 15:19:06 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 7.1
From: pr-tracker-bot@kernel.org
In-Reply-To: <aeCoZ4GkkSzOLA68@pathway.suse.cz>
References: <aeCoZ4GkkSzOLA68@pathway.suse.cz>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <aeCoZ4GkkSzOLA68@pathway.suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-7.1
X-PR-Tracked-Commit-Id: 448c0f8cb7cdf2e6d6e9d1ed3bb8c7397bc71c66
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d3d9443f8bac799340bb04db51ef4ababc4f7267
Message-Id: <177635274529.3274006.16159367685542363933.pr-tracker-bot@kernel.org>
Date: Thu, 16 Apr 2026 15:19:05 +0000
To: Petr Mladek <pmladek@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_FROM(0.00)[bounces-2372-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 692A24109C6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The pull request you sent on Thu, 16 Apr 2026 11:14:15 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-7.1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d3d9443f8bac799340bb04db51ef4ababc4f7267

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

