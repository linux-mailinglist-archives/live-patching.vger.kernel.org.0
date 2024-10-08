Return-Path: <live-patching+bounces-726-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7349995575
	for <lists+live-patching@lfdr.de>; Tue,  8 Oct 2024 19:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DD7A1F21DAC
	for <lists+live-patching@lfdr.de>; Tue,  8 Oct 2024 17:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12C771F9AAF;
	Tue,  8 Oct 2024 17:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FoRiJjCy"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6B31F9AAA;
	Tue,  8 Oct 2024 17:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728407851; cv=none; b=edg4AkrUvpor8Tw9l3txT3G1RHhg+rmjXMWG+2hY+A8IbpLtThu2vNxWZRjHF297KMsNMAT0cqD5MAtqRUIgo5oQwITUbrXMxpNbST1PBcAHK/bieLLx4xQosz8rf+7pHGIlDi/l/XG+nyoRfTYNCKv9DE0gFHfBClDDXyisARY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728407851; c=relaxed/simple;
	bh=CZvDc2Cw2sFbq09Uga+bN5k0/TSuwUv2X5A5/C2KSto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gHbdsySbRGONhHMxsuMv0GRYOLm4WkndWx/+RV77+uaDvXgzqw5xyPzbK/ym7258KoM5NLrpIe6LJwZuYmqUb/68TW40dqJbaABjpBEs/WZ82EQeTiBJfKoyCnp9pdDEk/x5Ryezkpahtg1n7pH4Mt1BS8RqT3luVfmcCSA52Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FoRiJjCy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39172C4CEC7;
	Tue,  8 Oct 2024 17:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728407850;
	bh=CZvDc2Cw2sFbq09Uga+bN5k0/TSuwUv2X5A5/C2KSto=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FoRiJjCy0SNrGHvyUsA43lXrG7+F0hygEk2ya+5XZJEixRI+7TNY+IoNidftqiPtw
	 UVCrGjzitwGArS58KcpRJXh/fxs9BuBwjgyXG6V63LxNF81fu2KJurJkZTSv+pqBEs
	 +6+K5HsXa55Yqtvy1Q62l6Vwp64ZHH/lc17JzKWhJ/5BHiBEChVmBM4mrZ9Yw/yWuG
	 7iRw2Ykki7frU4WXNryDLjdBO+uLIuQmR4K6Dfzq8JbRUSV5rUAAifebY84NMIdShm
	 wirI0vBarnpoRwkkHeWqndn7MFEfHL2R3vpMdnX6I8/bQSxLckOShAYEKV8F3bVWem
	 r8DsFKSnQ7D/A==
Date: Tue, 8 Oct 2024 10:17:28 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Wardenjohn <zhangwarden@gmail.com>
Cc: mbenes@suse.cz, jikos@kernel.org, pmladek@suse.com,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 1/1] livepatch: Add stack_order sysfs attribute
Message-ID: <20241008171728.ue3pmqivppryhf2h@treble>
References: <20241008014856.3729-1-zhangwarden@gmail.com>
 <20241008014856.3729-2-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241008014856.3729-2-zhangwarden@gmail.com>

On Tue, Oct 08, 2024 at 09:48:56AM +0800, Wardenjohn wrote:
> Add "stack_order" sysfs attribute which holds the order in which a live
> patch module was loaded into the system. A user can then determine an
> active live patched version of a function.
> 
> cat /sys/kernel/livepatch/livepatch_1/stack_order -> 1
> 
> means that livepatch_1 is the first live patch applied
> 
> cat /sys/kernel/livepatch/livepatch_module/stack_order -> N
> 
> means that livepatch_module is the Nth live patch applied
> 
> Suggested-by: Petr Mladek <pmladek@suse.com>
> Suggested-by: Miroslav Benes <mbenes@suse.cz>
> Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>

Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>

-- 
Josh

