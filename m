Return-Path: <live-patching+bounces-515-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7698095E50E
	for <lists+live-patching@lfdr.de>; Sun, 25 Aug 2024 22:17:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E23A1C21312
	for <lists+live-patching@lfdr.de>; Sun, 25 Aug 2024 20:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 657A94174C;
	Sun, 25 Aug 2024 20:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t/ZMbf1c"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3FB801;
	Sun, 25 Aug 2024 20:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724617062; cv=none; b=N6wt/MoDnLCq1uqWNQ51JQmAtP/4F5oH6xatz20xUg65Dbs7KHa4gtwq3Llim7OM/7+t+sSWbTbLeXuBB0RmOKo3dAesO8OhPqJYtDsS1H905h0DF4T55XMPob+W7YsupBP1nTGGFw8gxpzO86GWp7AmRReClZfU1tNR1PoS+Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724617062; c=relaxed/simple;
	bh=C74OSvHzRND/e7Ggp1uacl4U3kqzaNnlaNgtes9YIeE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=IC2r8VWGgoYDUUQm4gbt+KuU/PsdLPa88KvMtMhgTYhqRaxV3mgomyPCj8Z22lzk5taaCLv1Apc0y7x5us7UeAL5XrAD1dDxWvcGWRISBLzB6WrpC+s6mFAuBxvUCT92t+gzCEU2V5YNX+c/VmqLCHbrxeHWZQaDTwSubdO67IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t/ZMbf1c; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D870C32782;
	Sun, 25 Aug 2024 20:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724617061;
	bh=C74OSvHzRND/e7Ggp1uacl4U3kqzaNnlaNgtes9YIeE=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=t/ZMbf1coqTI2L7aCYPNPVagKj6dFueespmzd13k0mNFYL5WpmfGD62YZkRlKur1s
	 0S3t8OVp8S5yO9uqO0XTEZEKw3MCrayDmN5qvFOKJyLcIpNkmpEjxl15wI1gpgR45y
	 NMtU88gxyc74GOwl23WbD38QvxZHoG2ZMAhLGTYsbPE9+v7hQbU4KyUYDCMk5fV7sZ
	 qzC9hzfc8+sJoLyufSFdR4pmPykugdQ4wwHfLeMn8oxwqY5jgpladkA8L1D42KbLaU
	 cBq+OsuAtyCsKTjr2LBrSOXEy17DwNagRhqvMhuIeWVwqK8ylOCWic8Io9oQzleCqB
	 sCmjt3I+GnkXA==
Date: Sun, 25 Aug 2024 22:17:39 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
To: zhang warden <zhangwarden@gmail.com>
cc: Christoph Hellwig <hch@infradead.org>, 
    Josh Poimboeuf <jpoimboe@kernel.org>, Miroslav Benes <mbenes@suse.cz>, 
    pmladek@suse.com, joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Introduce klp_ops into klp_func structure
In-Reply-To: <C3B45B71-C7D1-45EB-B749-39514A49C521@gmail.com>
Message-ID: <nycvar.YFH.7.76.2408252216300.12664@cbobk.fhfr.pm>
References: <20240822030159.96035-1-zhangwarden@gmail.com> <20240822030159.96035-2-zhangwarden@gmail.com> <Zsq3g4HE4LWcHHDb@infradead.org> <C3B45B71-C7D1-45EB-B749-39514A49C521@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Sun, 25 Aug 2024, zhang warden wrote:

> >> 1. Move klp_ops into klp_func structure.
> >> Rewrite the logic of klp_find_ops and
> >> other logic to get klp_ops of a function.
> >> 
> >> 2. Move definition of struct klp_ops into
> >> include/linux/livepatch.h
> > 
> > Why?
> > 
> 
> Hi, Christoph.
> 
> When introducing feature of "using", we should handle the klp_ops check.
> In order to get klp_ops from transition, we may have more complex logic for 
> checking.
> 
> If we move klp_ops into klp_func. We can remove the global list head of klp_ops.
> What's more, there are some code in livepatch should get function's ops.
> With this feature, we don't need the original search to the one ops.
> It can be simple and straightforward.

I believe that Christoph's "Why?" in fact meant "please include the 
rationale for the changes being made (such as the above) in the patch 
changelog" :)

Thanks,

-- 
Jiri Kosina
SUSE Labs


