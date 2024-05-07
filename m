Return-Path: <live-patching+bounces-247-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2E398BD9BA
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 05:29:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DBF3284793
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 03:29:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E781EB3E;
	Tue,  7 May 2024 03:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AYJOtp55"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1994C94;
	Tue,  7 May 2024 03:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715052567; cv=none; b=O/8JjvIRT9NT9WENTWLn/SnAfzYMf22jgrkeYNpHdYQBwFWlJrDEJgnunLeVF4eHMidU0pBkCbn3kz5HxY9HhXECIYwTxc2se/myYqMpwZMeQuAv4H+I//QVAU/Du+O0Lugn8NCCWWsUgIh1IKianG7jKX0IYx7cedxRlmUB8Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715052567; c=relaxed/simple;
	bh=CCU+3G3786o55uqluG43dyB9AWpsNTLLpCXa6nXoX/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bQxy+AyGeWnbJS09BVkR1iYJuN9Hfk5HNyw8+NemaGGS2LZZ79c2CPmVxwWkJbqop31X2ut3npOfdiX+i52o8RyTTwiyrHy3bB9mTvX5+P8R17ULq8FG3CVJoD3qsxBDuRUCeRvoOvpfkeXhCHdzXSHOtN6As16BeTX063Myjh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AYJOtp55; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D9DC2BBFC;
	Tue,  7 May 2024 03:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715052567;
	bh=CCU+3G3786o55uqluG43dyB9AWpsNTLLpCXa6nXoX/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AYJOtp55CqE+SveBfADLzWSgb58zzrIQXHHvlGCTvVonRszQRzc1uAShBreXBxRiJ
	 Y7FtBIIOrCHjoxLGYxCUOZJ7XD7B6pyiGg25IsZPCSlWur1VooUNaMBrI53kqInwZf
	 FnoTYIHI3l6umoIVVv4qvZQG1E1OxROasWJG8TIee/4h4wVp8KS0H7NqcIW3tj2eVe
	 o5hn1PRuByrKZFXYHioKdGnPCraKixGIn44BJTY7v3DdckFIYPf7lCZbB6m+VV9wEz
	 XKQYg9a+EyNCsag+rKJK9EL3MzhFXLU8ALXB7JvRyLb2IXU6kwn9GoI1QQwu6PxTBN
	 KuDbtGPFZ9cvw==
Date: Mon, 6 May 2024 20:29:25 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: zhang warden <zhangwarden@gmail.com>
Cc: mbenes@suse.cz, jikos@kernel.org, Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] *** Replace KLP_* to KLP_TRANSITION_* ***
Message-ID: <20240507032925.fva2jalnshp44k2p@treble>
References: <20240507021714.29689-1-zhangwarden@gmail.com>
 <0E399FCD-396E-448B-A974-6034F4CF2B53@gmail.com>
 <20240507024151.6jto4zraqfbqxcw2@treble>
 <4010C687-88C9-43FC-B8C9-80981B04807F@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4010C687-88C9-43FC-B8C9-80981B04807F@gmail.com>

On Tue, May 07, 2024 at 10:56:09AM +0800, zhang warden wrote:
> 
> 
> > On May 7, 2024, at 10:41, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > 
> > On Tue, May 07, 2024 at 10:21:40AM +0800, zhang warden wrote:
> >> 
> >> 
> >>> 
> >>> transition state. With this marcos renamed, comments are not 
> >>> necessary at this point.
> >>> 
> >> Sorry for my careless, the comment still remains in the code. However,
> >> comment in the code do no harms here. Maybe it can be kept.
> > 
> > The comments aren't actually correct.
> > 
> > For example, KLP_TRANSITION_UNPATCHED doesn't always mean "transitioning
> > to unpatched state".  Sometimes it means "transitioning *from* unpatched
> > state".
> > 
> > -- 
> > Josh
> 
> OK, I got it. I will remove the comment later. After all, comment is
> not necessary at this point after we rename the macros.

Yeah, removing them altogether might be best, as the meaning of these
can vary slightly depending on the operation (patching vs unpatching),
and also depending on where it's stored (task->patch_state vs klp_target_state).

-- 
Josh

