Return-Path: <live-patching+bounces-265-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 700578C6D3F
	for <lists+live-patching@lfdr.de>; Wed, 15 May 2024 22:30:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AC71281268
	for <lists+live-patching@lfdr.de>; Wed, 15 May 2024 20:30:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0435315B113;
	Wed, 15 May 2024 20:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AxGAGwMK"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18EF13328D;
	Wed, 15 May 2024 20:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715805008; cv=none; b=MXvzn2uXHH6kmlgFj6kN2swEf5hmn7PX7mlZJbF8vbLokBIQTYnMtNHqUBnoH3NfNoXSIdZAMnP/yJiwtcTOYyl/KFF3j48JdAWyNIohurDUu3S+qB45jeMi0KNXf8TDtkk88FbbxO5ccoJOyyFfUnEiAWvENS/qg6RhZPPbrM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715805008; c=relaxed/simple;
	bh=LYOoT5oWHceAxQrv2KQWRDCy706AfHjcDfaS/US3UZk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=EtK4ZGZ/1BYHxpL1x525dSQ1kyrwKxrghOEM8bJOH1wBUUMinrxhP2JTB+Zq59kjZTH9/hKHDCoQYw2zS89tO+oaZrBYZgNup2D1kXorNDo/X2hfNHiuOdULJmQHW+JXM/U/PMtKFsRveOAE5x0dKr1EzTvego7W+YgR8WbOyFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AxGAGwMK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F9C5C116B1;
	Wed, 15 May 2024 20:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715805008;
	bh=LYOoT5oWHceAxQrv2KQWRDCy706AfHjcDfaS/US3UZk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=AxGAGwMKlXNc+BkpsI2Hw0lM2ZEXvrTs2BljGg44UUFCjs7jLZI5uZ6MYgFP+1wM3
	 81vl7CJk9tJs3psjafMflh5d3NnC76G93lgCIH1sIsPuZ3I3JlHHAekdwUtc+Lc6cr
	 5EjdY1CI6Z5NXMzC5RhD8gcYUcwE4KkSW/jGzSEUXIGR75e/FiKoKzA0yDrS9mXBzd
	 nOSUCTvd0W30MBp1hazizhgAEmBPlDM5ZjunkP5BlBgXN0yHs/e8FAuU5xy03fLnQV
	 laVixoWtGnfYrkxO6rCnUSh1YPLffGTfwuT3ifIifbE8NsfCkGsgj0LzR2KkVKtH9C
	 B9sw316LSrjJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 547C7C4333A;
	Wed, 15 May 2024 20:30:08 +0000 (UTC)
Subject: Re: [GIT PULL] livepatching for 6.10
From: pr-tracker-bot@kernel.org
In-Reply-To: <ZkSpicJYoMleJRkY@pathway.suse.cz>
References: <ZkSpicJYoMleJRkY@pathway.suse.cz>
X-PR-Tracked-List-Id: <live-patching.vger.kernel.org>
X-PR-Tracked-Message-Id: <ZkSpicJYoMleJRkY@pathway.suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching tags/livepatching-for-6.10
X-PR-Tracked-Commit-Id: d927752f287fe10965612541593468ffcfa9231f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8c06da67d0bd3139a97f301b4aa9c482b9d4f29e
Message-Id: <171580500833.11265.1333866415358381084.pr-tracker-bot@kernel.org>
Date: Wed, 15 May 2024 20:30:08 +0000
To: Petr Mladek <pmladek@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 15 May 2024 14:24:41 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching tags/livepatching-for-6.10

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8c06da67d0bd3139a97f301b4aa9c482b9d4f29e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

