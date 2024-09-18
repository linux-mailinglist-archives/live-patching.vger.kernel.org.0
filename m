Return-Path: <live-patching+bounces-664-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC3F597BD7E
	for <lists+live-patching@lfdr.de>; Wed, 18 Sep 2024 16:00:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D00EB261F8
	for <lists+live-patching@lfdr.de>; Wed, 18 Sep 2024 14:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B90CC18E039;
	Wed, 18 Sep 2024 14:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s5zescft"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B3018E032;
	Wed, 18 Sep 2024 14:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726668008; cv=none; b=bgSUNQriazeFJrYvlx/PMcYkGXEZfqA6+6l1eQDg/zVE73t9twMTBDpR3lpKYcmozCCorhsXT2TdlS2X4258Q7rsB1s7mnVTFuc1BHZMbr6HPw7Ypf9chVMBBIxCniDMrMYFU8eumCXQccSqoVxrIIhxgaw7Cmau/6CFLlYvX+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726668008; c=relaxed/simple;
	bh=9VgOGKhCo0YAkjhA8rQ+C4wk6dKqJ+EW9r0VPog7qZw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=FqnxhjyHFUioxf0Eosg78yoEMjPca6WxyzFRKRCGgJK+nZC+JtsYV8EUe5N+Z/eb9/Bx/zX6NWweL6qCDZGLvtHU1dUWrtuWxW7kTt3gEV32gqec/LFgtNj3g6yQGEFl67UuWVObqo6HT1BhQG8mURldJR5EkEgGYt5mN5+XUXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s5zescft; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E9AC4CECE;
	Wed, 18 Sep 2024 14:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726668008;
	bh=9VgOGKhCo0YAkjhA8rQ+C4wk6dKqJ+EW9r0VPog7qZw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=s5zescftMly3ch09l28Cgsg/ID3FuRdKgUUgLuITRakMymaGPWyEytPKE7rb6+BEw
	 rI537sTCMluIG78X7EER0gksXZVtrIndfYQLKrYqEXgG2uWOmRtMej80VcS39qxw2Z
	 gILHNlhzodDg1Gm2FfYvPQYgnugODL12jhhn7IfWC8x+Zq/+gvpOJhHPoN7IHxuz+p
	 WX4VOerjbzIZ20wza9QtABEVeuLV+52IEo0zt0MO0bTwb9VFaB6Ms+tNNbIf0xfJf7
	 pIgaYc8uZONEQe5Smt90JHZleM2TrtXFfm2ilenIcpsfpBJOPgm17zdkE9Syu+W+P3
	 BZhuTFaxvXICA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 346643806656;
	Wed, 18 Sep 2024 14:00:11 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 6.12
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZuhEKz4pBXuNJDgX@pathway.suse.cz>
References: <ZuhEKz4pBXuNJDgX@pathway.suse.cz>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZuhEKz4pBXuNJDgX@pathway.suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.12
X-PR-Tracked-Commit-Id: 3360211b2a955a30458de1f2657f0c9f75ef839c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c8d8a35d094626808cd07ed0758e14c7e4cf61ac
Message-Id: <172666801005.843157.1912600870512832376.pr-tracker-bot@kernel.org>
Date: Wed, 18 Sep 2024 14:00:10 +0000
To: Petr Mladek <pmladek@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 16 Sep 2024 16:43:55 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-6.12

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c8d8a35d094626808cd07ed0758e14c7e4cf61ac

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

