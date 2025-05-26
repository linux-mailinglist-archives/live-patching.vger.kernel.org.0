Return-Path: <live-patching+bounces-1462-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBDA4AC3E27
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 12:53:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82FEA3A2D67
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 10:52:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3712A1F7569;
	Mon, 26 May 2025 10:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F9+SzIYD"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3001D63C0;
	Mon, 26 May 2025 10:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748256772; cv=none; b=XotMSKgned/zWi/s+76YGeWy0xlR8Rn27lC3Ptjod5Q/+YlOy6Q15W+PIFH2jZjkXilE8+947taCX9BkUDjC3O/5WNAGyi7+HFfGaGqI2ceBErSkmVJC/d3SRLpx5nXzBEDD+C756RY5OvXl/F7r6AZEXOHANRWmwmu7wBbFVSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748256772; c=relaxed/simple;
	bh=/7jg7VkWiTT5oHSedXxFS3R0qLl8xBBSZBExtmj2NmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bGrPF7gvrg3kzyT+fRGZjWjQ8Udg078X351xNV6rBnjSDLDfsi/13x1SLuITUSOJebUb3V+1Fvf3n/yVfd84vU6ZqNdPd4EDHVYe/jEGhd5Mea1vQCyAkDYSLxvuGIllk0b386liJdrc1JOjJ14vSKIXXzt195LEqjxoK2OX3ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F9+SzIYD; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BjNV+9klChm6GiHn/lfYnQtxdOsgnerlGz2cAgy0C9Y=; b=F9+SzIYDtkKFJjMd3hQ7rFPjTR
	57ikJeeXgNw9MIFCqJL5oBv1OOdL7GyZvQCmPC0VJvBBhyxwlG4Td5qyq1/Ue4BciV4nsRIDWDl5d
	94Y1/At6vMl1yVlGzmLf2SrTfHXVjZSRa7tH6LSVN1XbaRhdJz0jg5Ua6gzkqtJlYiH733bdmOO5T
	sGF/nAl4Ql+Z3aQj4NpRPiuZ2bY+8xIM+F55/qfOuH/I0yQ06z90+k6Xj0QOupKMZ3K5CuanbTb1q
	T7GLvWlbMvTIJbVjqSKGNuwNBczTNeeaVeXZN4KgaBQCEHvNBUY5ljjauzDPunsrod9kSXTRXQbCr
	TuwwvRiw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uJVRg-00000001s1k-3mt9;
	Mon, 26 May 2025 10:52:41 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 78A97300472; Mon, 26 May 2025 12:52:40 +0200 (CEST)
Date: Mon, 26 May 2025 12:52:40 +0200
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
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 32/62] objtool: Suppress section skipping warnings
 with --dryrun
Message-ID: <20250526105240.GN24938@noisy.programming.kicks-ass.net>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <7eccdb0b09eff581377e5efab8377b6a37596992.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7eccdb0b09eff581377e5efab8377b6a37596992.1746821544.git.jpoimboe@kernel.org>

On Fri, May 09, 2025 at 01:16:56PM -0700, Josh Poimboeuf wrote:
> It's common to use --dryrun on binaries that have already been
> processed.  Don't print the section skipping warnings in that case.

Ah, I rather like this warning, it gives me an easy check to see if the
file has already been processed.

I typically do a OBJTOOL_ARGS="--backup" build and run dryrun debug
sessions against those .orig files.

