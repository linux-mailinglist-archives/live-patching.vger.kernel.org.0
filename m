Return-Path: <live-patching+bounces-1883-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16A33C991D2
	for <lists+live-patching@lfdr.de>; Mon, 01 Dec 2025 22:00:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 728833A2434
	for <lists+live-patching@lfdr.de>; Mon,  1 Dec 2025 20:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C618274671;
	Mon,  1 Dec 2025 20:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ed5lq1k/"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA0726E6E4;
	Mon,  1 Dec 2025 20:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764622795; cv=none; b=d6xt2h7nwedtEBXycD4OXnwG+nfOqM7MKQA0l/M3U3jUcApNa/NXzfWseeqTBgKY9TrVYvDeeRBbVHqx4ZQz8GfvSbKVRYmOOvUhG2Fxx7TfL0RENLyfCclHOM8FvIwl2LpH1nILR/wgUr4fGMZsW+vL6RAKAGXp3cZo5qLSsmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764622795; c=relaxed/simple;
	bh=ogYk6ytUMxwf37ycTCeWUDl6832ehiNIbrkMPwwndOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l+gwaNKht30czelmeAE00VO2Ak8C9sO6q3bsbfZlJYFyGK+TqcH24h3Msp02nFhj/kCCMmVfLNpthd6rkvhedE8vB3iDI8mkHIV5uw4CvDPqACm0UhDhphYLCoXryRbfNxWYx36+1XpgR40yJM+08/aeZ0ZDnMhYgaPZinf9zp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ed5lq1k/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBE7C4CEF1;
	Mon,  1 Dec 2025 20:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764622794;
	bh=ogYk6ytUMxwf37ycTCeWUDl6832ehiNIbrkMPwwndOw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ed5lq1k/5ylR5wtGcuaszcIYdI0BkkDkp9RuybDEwRXO7qoP8qLod6Tn+vMODRyyW
	 GoRw7Rs2TwwbYUaXhTPmwAsMAJydaxR0+/YhptHC5iwALYvJaC91nTelraC15d1gWD
	 R7hpPOtVTrWnto3LsEiQixPkp1L4ehuVBMFVAvSZguUAcc7x/+0oKJfSrD/90m+1wp
	 uqdYsgSk/51I7UTzoY0NLV2nmJ7qBmarjvfbhZTgdAVxSmd4K4kIzqOTwwPo+FLepX
	 KyGagdFgmb2cQ1vQXjxDZ76mEKVDh0y15AqQEXZAhSnuDvMHEmfzUonQ5IOa7ZGJX6
	 46g/hEYa0ACfw==
Date: Mon, 1 Dec 2025 12:59:52 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Cc: Miroslav Benes <mbenes@suse.cz>, bpf@vger.kernel.org, 
	live-patching@vger.kernel.org, DL Linux Open Source Team <linux-open-source@crowdstrike.com>, 
	Petr Mladek <pmladek@suse.com>, Song Liu <song@kernel.org>, andrii@kernel.org, 
	Raja Khan <raja.khan@crowdstrike.com>
Subject: Re: [External] Re: BPF fentry/fexit trampolines stall livepatch
 stalls transition due to missing ORC unwind metadata
Message-ID: <pngpi6g2rfxq4q62voj6daedongyymzvmibx7ypjvsjsbe2ahk@neoukzanuwr2>
References: <0e555733-c670-4e84-b2e6-abb8b84ade38@crowdstrike.com>
 <alpine.LSU.2.21.2511201311570.16226@pobox.suse.cz>
 <h4e7ar2fckfs6y2c2tm4lq4r54edzvqdq6cy5qctb7v3bi5s2u@q4hfzrlembrn>
 <d7b75cdc-a872-4425-a5f6-d41b1982cca7@crowdstrike.com>
 <3irfgmzksrfchngic6eowdu7ii5a5axrx5ofgneqastd4cjkpk@xrhabkis5z2k>
 <30ddcf30-f176-48f5-b00f-967f5409243f@crowdstrike.com>
 <755zk5mhyujqwnrbiwanbz6emfv4d3ohuocx5modw5i23tnerf@ydbdhw2bnxkf>
 <50dd3865-613d-4254-a7e8-cc3d97282f3c@crowdstrike.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50dd3865-613d-4254-a7e8-cc3d97282f3c@crowdstrike.com>

On Thu, Nov 27, 2025 at 09:55:15AM -0500, Andrey Grodzovsky wrote:
> On 11/24/25 19:06, Josh Poimboeuf wrote:
> > On Mon, Nov 24, 2025 at 05:54:15PM -0500, Andrey Grodzovsky wrote:
> > > On 11/24/25 17:51, Josh Poimboeuf wrote:
> > > > On Mon, Nov 24, 2025 at 05:06:04PM -0500, Andrey Grodzovsky wrote:
> > > > > > Andrey, can you try this patch?
> > > > > 
> > > > > Hey Josh, thank you for looking, can you please advise the stable
> > > > > kernel version you have made this changes on top off so I can cleanly
> > > > > apply ? Alternatively just provide git commit sha in Linus
> > > > > tree I can reset my branch to.
> > > > > 
> > > > > 
> > > > > I will happily test this as soon as I can and report back.
> > > > 
> > > > It's based on Linus's tree.
> > > > 
> > > 
> > > Latest more or less ?
> > 
> > Yes, it still applies to his latest master (v6.18-rc7).
> > 
> 
> Tested, looks good.

Thanks, I'll post proper patches shortly.

-- 
Josh

