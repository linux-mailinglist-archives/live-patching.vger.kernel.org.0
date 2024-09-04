Return-Path: <live-patching+bounces-579-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 43FBB96B014
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 06:48:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01A6C28AADD
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 04:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7188823DE;
	Wed,  4 Sep 2024 04:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C/X1XCkk"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7CF823AC;
	Wed,  4 Sep 2024 04:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725425290; cv=none; b=PrxTD2p0KmNoPO9MIEXiMLBeJQ0n69dOIY5MYwPKTXgp5aUD9mST+EFrUYcilTAThJAU3Klb4wfNre10tA+SWl8JO9aM/LADXoN/YXonDTQGIbK14v3a3v1EIzGYGzcrz8D0rP8276GYImYMITqJs6TaB0Xg9G4gMuuO0mm2bu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725425290; c=relaxed/simple;
	bh=HAYsxipU8e9QPCgKAxzYKhFcQZURoMS7AbvtgJ2/AdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gZT0PTWAQTtEglYHlR5f8CLUqdlEftLlW2hUnJV9oa0T/8Gf5lAJ2jggNerf5JSlLPnVexj1RPUVuUbUeHZV1BIqg7wfyfQKVp0tOBzObu36CX3V0OFjiBMh9k8WatQWPrnroYZlCuEgFh1hRp72h62YCntKA4fdq8maqQ2CxjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C/X1XCkk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BE1C4CEC2;
	Wed,  4 Sep 2024 04:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725425289;
	bh=HAYsxipU8e9QPCgKAxzYKhFcQZURoMS7AbvtgJ2/AdY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C/X1XCkk000AAYUTzS3yJTTwlztHCbxk1z/k04QlP7/C3w37PVmJMclRVp2vmi+A6
	 wy3MRbNoTAjKXHUl64p8dH2R9/e4pYn8+cCquqEwmdZv/1eVJd05T4O0KC+gP2hbZq
	 jMqEvZ/WwfC5Sf+KpD7+c07I+/fY7NWa+O7+GVFVJQ1IFUQzSw4FZeWat3J9GKJ45y
	 TfZF/Ujzn145ex0jRB3OF43bSX597BDAts3IqFNToX4InuB4Ez24GfUni4BBzgel59
	 z275LthfbfexgPnCap2GWER9J1ECIQ+yiENyGRUYkH4rOqJ7Vsk0Un37Vzedn3vdPz
	 KEYIDbZDru8Gg==
Date: Tue, 3 Sep 2024 21:48:07 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Wardenjohn <zhangwarden@gmail.com>
Cc: mbenes@suse.cz, jikos@kernel.org, pmladek@suse.com,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] livepatch: Add using attribute to klp_func for
 using function show
Message-ID: <20240904044807.nnfqlku5hnq5sx3m@treble>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
 <20240828022350.71456-3-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240828022350.71456-3-zhangwarden@gmail.com>

On Wed, Aug 28, 2024 at 10:23:50AM +0800, Wardenjohn wrote:
> One system may contains more than one livepatch module. We can see
> which patch is enabled. If some patches applied to one system
> modifing the same function, livepatch will use the function enabled
> on top of the function stack. However, we can not excatly know
> which function of which patch is now enabling.
> 
> This patch introduce one sysfs attribute of "using" to klp_func.
> For example, if there are serval patches  make changes to function
> "meminfo_proc_show", the attribute "enabled" of all the patch is 1.
> With this attribute, we can easily know the version enabling belongs
> to which patch.
> 
> The "using" is set as three state. 0 is disabled, it means that this
> version of function is not used. 1 is running, it means that this
> version of function is now running. -1 is unknown, it means that
> this version of function is under transition, some task is still
> chaning their running version of this function.

I'm missing how this is actually useful in the real world.  It feels
like a solution in search of a problem.  And it adds significant
maintenance burden.  Why?

Do you not have any control over what order your patches are applied?
If not, that sounds dangerous and you have much bigger problems.

This "problem" needs to be managed in user space.

-- 
Josh

