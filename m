Return-Path: <live-patching+bounces-1601-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D757AEB571
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 12:52:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 711C83AF6CF
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 10:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 122B7298CAB;
	Fri, 27 Jun 2025 10:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WoHOtl4o"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CB72980B2;
	Fri, 27 Jun 2025 10:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751021535; cv=none; b=QPXg9Nn2J1Bb/nRO3eE83F4yROYGUg9CdkX8muwwBMo+y9/H6f2qLwcgsCyu8iW7RsiSv8OjcqqXHNHItybpbTUzIA215YoWpQkjsZd20mrUwOgqnPhF05HicqlhEFkvjVnmj14wqOWRQxjpreBFIUJ8kQgsI+Ns+xvnDYA1Oeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751021535; c=relaxed/simple;
	bh=HbR6SPn3F0JueHJ4F/q6o4HfMOlQLCupl1O9Rireycc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qn/L+BrJGT9fnHLGzAP2dy0jaEyOZmRuIAHh8CciCJFP3yqdKL/cUf2POVpvko6ToHg4qo60vbnQM/JsNDSNEjAEa4CeXLhqM7kerK29DxIJ0zM2GB/xJLfQA6dBg2UCB1N3uvU2EMEuEftFfBImaRFbnq/hAcyeP6mEK51MO1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WoHOtl4o; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=v2XjhXXjoVlHC+MJiTSQDgatPB8bllHZZSaqdgyRjXI=; b=WoHOtl4oJO/nf79w7IeiTc6TGM
	hKBTTlL/4/iJ6QpFOeoc1YgEv0UwX6m04qOF570CB3IHsrF/ijkLqx8QRWBpIM6BMlV5kK7mg5RiV
	Xw9QPr95AJKnzwsRj8Y+K31dfWfeqspeQWeq8yl5fhT6DDVSToJzSqDFhlI4CdWhmcOUw/QyZtw0P
	DDvM0tM42NLnVRL9p0Ah8/F3USUyCINfkS22XYt7AziL236EnZ1wudaTcqHzXXcY0CRLvpOdPA+Qq
	c9At+Gh6x8nDRarHcf2Bfy6EB9vQ1cARCvQ6Aq49+OT71yz6133IHf91pyvas/uThAB+BNLMa/l/6
	x02iFxsQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uV6gg-0000000Ds10-0vfU;
	Fri, 27 Jun 2025 10:52:06 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B5B1F30017D; Fri, 27 Jun 2025 12:52:05 +0200 (CEST)
Date: Fri, 27 Jun 2025 12:52:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>
Subject: Re: [PATCH v3 46/64] x86/extable: Define ELF section entry size for
 exception table
Message-ID: <20250627105205.GY1613200@noisy.programming.kicks-ass.net>
References: <cover.1750980516.git.jpoimboe@kernel.org>
 <1a53b6dcf236ce1fe0f0cd0d4441fc2bd9022cb3.1750980517.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a53b6dcf236ce1fe0f0cd0d4441fc2bd9022cb3.1750980517.git.jpoimboe@kernel.org>

On Thu, Jun 26, 2025 at 04:55:33PM -0700, Josh Poimboeuf wrote:

> @@ -193,7 +193,8 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
>  	".purgem extable_type_reg\n"
>  
>  # define _ASM_EXTABLE_TYPE(from, to, type)			\
> -	" .pushsection \"__ex_table\",\"a\"\n"			\
> +	" .pushsection __ex_table, \"aM\", @progbits, "		\
> +		       __stringify(EXTABLE_SIZE) "\n"		\
>  	" .balign 4\n"						\
>  	" .long (" #from ") - .\n"				\
>  	" .long (" #to ") - .\n"				\
> @@ -201,7 +202,8 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
>  	" .popsection\n"
>  
>  # define _ASM_EXTABLE_TYPE_REG(from, to, type, reg)				\
> -	" .pushsection \"__ex_table\",\"a\"\n"					\
> +	" .pushsection __ex_table, \"aM\", @progbits, "				\
> +		       __stringify(EXTABLE_SIZE) "\n"				\
>  	" .balign 4\n"								\
>  	" .long (" #from ") - .\n"						\
>  	" .long (" #to ") - .\n"						\

This style is much better.

