Return-Path: <live-patching+bounces-612-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E62D696DFE5
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 18:35:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08B061C23A32
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2024 16:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C2B377F10;
	Thu,  5 Sep 2024 16:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HXFvdW5w"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2374A383A3;
	Thu,  5 Sep 2024 16:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725554092; cv=none; b=VXYL3kv4BJ1ZoxHySy/1Hkyv1MFeeWGy2Nm9zS0o5abgS7/sWpfTeBB7cj4W9qdHuTHiD/K9hce6QY2SCYvhmhGiBdK0R6m4TkNFkwFmLKxaTaPr1zEbaBKQmUUyIOOPmzO/dxTovaBeTYlV3g2kaQrROdQuUczMuGd+lvlRi3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725554092; c=relaxed/simple;
	bh=/fTC7ZnLz/HxGywyh919pXu1R19VkeDSSkMMvbHSAdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aXSZJna6cEQgMKv8rh+u42RKe+8LTAEsEdd+eE/hsLzUBWC0ACVvLyMRO9jBWJ+wOuICV3xA8J/EH5+B4EoUS48YKqWdTRJUKYFeNC8ECROeV8yyH3Tpo/qBaZ2nP0NAXAbb23LIbPpXECdXIteRu/Lj9jHZHG91HpH3eT1fYm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HXFvdW5w; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A12C4CEC3;
	Thu,  5 Sep 2024 16:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725554091;
	bh=/fTC7ZnLz/HxGywyh919pXu1R19VkeDSSkMMvbHSAdw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HXFvdW5wYWLeZbzskpYX0Ey8zZS04RnlurLU9uN+hgRR/WxD6e9opbBfDRVGxhjJY
	 ANeg+P2uCvy8a/pwHmqSsb88QxbIq3Jo+0ywOl0SNHHgm+WGtLkjI6qupZtojxKLaS
	 6xtslvDMBAD9ExkahFgXKa2z5hVWPUguyKJJ9G/JvocnXrdbOv/1WtR2QN+jyQqz0J
	 weF2GXkfcew0k7wWlWjUg5kfyJ0nMyFLS44GVVJZUmnhMR/t10He0rcZoAVhk9K2yo
	 eNG+LjfzWr2vPJyWIRbEW6CbiLKDyqLdaz6CSP7VYYHlhfeHHYimNOnjGMwyFL3fC9
	 NTy/zc52n1XrQ==
Date: Thu, 5 Sep 2024 09:34:49 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Wardenjohn <zhangwarden@gmail.com>, jikos@kernel.org, pmladek@suse.com,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] livepatch: Add using attribute to klp_func for
 using function show
Message-ID: <20240905163449.ly6gbpizooqwwvt6@treble>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
 <20240828022350.71456-3-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2409051215140.8559@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2409051215140.8559@pobox.suse.cz>

On Thu, Sep 05, 2024 at 12:23:20PM +0200, Miroslav Benes wrote:
> I am not a fan. Josh wrote most of my objections already so I will not 
> repeat them. I understand that the attribute might be useful but the 
> amount of code it adds to sensitive functions like 
> klp_complete_transition() is no fun.
> 
> Would it be possible to just use klp_transition_patch and implement the 
> logic just in using_show()?

Yes, containing the logic to the sysfs file sounds a lot better.

> I have not thought through it completely but 
> klp_transition_patch is also an indicator that there is a transition going 
> on. It is set to NULL only after all func->transition are false. So if you 
> check that, you can assign -1 in using_show() immediately and then just 
> look at the top of func_stack.

sysfs already has per-patch 'transition' and 'enabled' files so I don't
like duplicating that information.

The only thing missing is the patch stack order.  How about a simple
per-patch file which indicates that?

  /sys/kernel/livepatch/<patchA>/order => 1
  /sys/kernel/livepatch/<patchB>/order => 2

The implementation should be trivial with the use of
klp_for_each_patch() to count the patches.

-- 
Josh

