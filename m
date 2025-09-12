Return-Path: <live-patching+bounces-1645-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D614AB5439D
	for <lists+live-patching@lfdr.de>; Fri, 12 Sep 2025 09:14:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90EB63B7B32
	for <lists+live-patching@lfdr.de>; Fri, 12 Sep 2025 07:14:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF6E2BCF6A;
	Fri, 12 Sep 2025 07:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wthmgBzU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kVUIzgFS";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wthmgBzU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kVUIzgFS"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C0226CE39
	for <live-patching@vger.kernel.org>; Fri, 12 Sep 2025 07:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757661280; cv=none; b=cluamrrcxt53ggtI189r3ytKExXxRUKdJYdPmUNP2cD8CGd5ZY+7vxfh/2OUXSvWXjcyeShtX5Wli+jKdchjVq4kioAuvo/JTtFjfVtNyU+xEB7v+qyqUofK4dJTlXe3M7I35rckR9gEoBmsgI1Y+6Guyb95nvnl16Etio0ElhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757661280; c=relaxed/simple;
	bh=5UmTb29+wvToZMjF8jQIGCifuFHDDgC/fASNWQ5bMto=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=WSVVjFVyy+Skf6cqzyWeAyDDdwGEapq4/I+hkDIpQhwF4HQNg1gyqRd4mkJsYBYDyIo9tougIg00XDKo8QL/l+dqbcrQyKKe2TBZ3JtdVR3pyb40GX85sDaOXDyZ27YA6QjCz67naeGcaUNICU2Jhfpg5xXyx59kvEIsnEPOHU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wthmgBzU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kVUIzgFS; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wthmgBzU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kVUIzgFS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 40A0521B3B;
	Fri, 12 Sep 2025 07:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757661277; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mV+s3hEFUvEmsYvcUZo46b54180UGBE4ZzHhrPY5VJY=;
	b=wthmgBzU5MqeZQ8GPkP8sVM8PukPsWHv/xchnTHeWA/+n3qzv64N44nSbrasl86vJtBUEi
	/9j54MY7pLycjNQ+uzI1HjD8rwi/O1dCNSUPkVx4V41ijIkepSW9rkx8l8mbuExhuHbtc9
	fKQqgrmOwtqHC2Z3Y0Vuw53brqGXdmA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757661277;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mV+s3hEFUvEmsYvcUZo46b54180UGBE4ZzHhrPY5VJY=;
	b=kVUIzgFS7+Ux6qoePXWUBwc129xgSHIx9SuT4CFqrXag2o7X7pVCJP3DTErdigZMQ/KPBk
	iF8ilg/CmqjnlqBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757661277; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mV+s3hEFUvEmsYvcUZo46b54180UGBE4ZzHhrPY5VJY=;
	b=wthmgBzU5MqeZQ8GPkP8sVM8PukPsWHv/xchnTHeWA/+n3qzv64N44nSbrasl86vJtBUEi
	/9j54MY7pLycjNQ+uzI1HjD8rwi/O1dCNSUPkVx4V41ijIkepSW9rkx8l8mbuExhuHbtc9
	fKQqgrmOwtqHC2Z3Y0Vuw53brqGXdmA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757661277;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mV+s3hEFUvEmsYvcUZo46b54180UGBE4ZzHhrPY5VJY=;
	b=kVUIzgFS7+Ux6qoePXWUBwc129xgSHIx9SuT4CFqrXag2o7X7pVCJP3DTErdigZMQ/KPBk
	iF8ilg/CmqjnlqBg==
Date: Fri, 12 Sep 2025 09:14:37 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Tiezhu Yang <yangtiezhu@loongson.cn>
cc: Josh Poimboeuf <jpoimboe@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
    Xi Zhang <zhangxi@kylinos.cn>, live-patching@vger.kernel.org, 
    loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] livepatch: Add config LIVEPATCH_DEBUG to get
 debug information
In-Reply-To: <8dcdba05-4d8c-83ff-f337-b6e71546e1a0@loongson.cn>
Message-ID: <alpine.LSU.2.21.2509120912510.26788@pobox.suse.cz>
References: <20250909113106.22992-1-yangtiezhu@loongson.cn> <20250909113106.22992-2-yangtiezhu@loongson.cn> <alpine.LSU.2.21.2509111549200.29971@pobox.suse.cz> <8dcdba05-4d8c-83ff-f337-b6e71546e1a0@loongson.cn>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1678380546-2262061-1757661277=:26788"
X-Spamd-Result: default: False [-3.29 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	CTYPE_MIXED_BOGUS(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.19)[-0.949];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	FROM_EQ_ENVFROM(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -3.29

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1678380546-2262061-1757661277=:26788
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 12 Sep 2025, Tiezhu Yang wrote:

> On 2025/9/11 下午9:50, Miroslav Benes wrote:
> > Hi,
> > 
> > On Tue, 9 Sep 2025, Tiezhu Yang wrote:
> > 
> >> Add config LIVEPATCH_DEBUG and define DEBUG if CONFIG_LIVEPATCH_DEBUG
> >> is set, then pr_debug() can print a debug level message, it is a easy
> >> way to get debug information without dynamic debugging.
> > 
> > I do not have a strong opinion but is it really worth it? Configuring
> 
> This is an alternative way, there are some similar usages:
> 
> drivers/iommu/exynos-iommu.c:
> #ifdef CONFIG_EXYNOS_IOMMU_DEBUG
> #define DEBUG
> #endif
> 
> drivers/mtd/nand/raw/s3c2410.c:
> #ifdef CONFIG_MTD_NAND_S3C2410_DEBUG
> #define DEBUG
> #endif
> 
> drivers/usb/storage/usb.c:
> #ifdef CONFIG_USB_STORAGE_DEBUG
> #define DEBUG
> #endif
> 
> > dynamic debug is not difficult, it is more targetted (you can enable it
> > just for a subset of functions in livepatch subsystem) and it can also be
> > done on the command line.
> 
> Yes, this is true. It is up to the maintainers to apply this patch
> or not.

Right and I do not see the point to have it in the tree for the reasons 
above.

Miroslav
--1678380546-2262061-1757661277=:26788--

