Return-Path: <live-patching+bounces-1471-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 73CEDAC670D
	for <lists+live-patching@lfdr.de>; Wed, 28 May 2025 12:35:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 676EC9E238F
	for <lists+live-patching@lfdr.de>; Wed, 28 May 2025 10:34:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FE5227603D;
	Wed, 28 May 2025 10:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GzxH4KTy"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9451427A10D;
	Wed, 28 May 2025 10:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748428511; cv=none; b=C+GjA6jLcRFqQuGxw9MX1jiFzr3ra7mXqqzP4+pFOtGNqYFc+55+ix4BUR3NATN7S8mH3hpfnln1E7zn694X8ik2oQbGjJyTiXd9wxlEbqxPc4kf1Ml3BoDorD0rhX82MvmXYmXGxJI6DYE+PM6JJJNy3VENC1Qc9Bzsoz7J9Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748428511; c=relaxed/simple;
	bh=cYSghLuIhAoYSTdvRYsMj6ugu4cjASHNZF8y376rXmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sekQcCP2bJCjSnOco/Ei7cs7s0HEuYf1xDoXvE8nw0ilvEYgid421XG+73vq+LuXsXawJFV/SxlYFQOn0l25mn7CDzTxM08d8pCbkJ+CmfexDQ4f7JiJJnpYaUP4bXjAYm25mMwxFjgg3A+/BOSIiCtcE4hFphUi6I4lKctqDZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GzxH4KTy; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=P34XLFCfzk1CsPAhulJ9PexBHwchNyZWZ/M1aK5mWj4=; b=GzxH4KTyBYgzlK+BLZIYMj9CgF
	jhUPSv2YMQExg63qcZElNpp45T5MrXfr7t9LHiZEslu9zMzJVwk37qXpLllekoKS9tZev0pBHlOWv
	J57p4ntWNAJuvr03JyB1K8Hewp2kX+/RZUHqsbA24d9de19GnlSttYCPxrGMYj3NgKWm84xjIGuIQ
	dZPiZEzkkm9TOiBjRKXHvIBTfp5RuEm5bts+FYj6mXoyDA1ZBYNz2EnUOy3GhnTZzvNOhwuKmHmJk
	yyWOo8y0fE4ZRBKHNCtbITDoC8E8nAWcliX4CNFgiad+eG73SMkWf1LueC5PnDEN/EZpRvMt57/mv
	kzl/bj/g==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uKE7c-0000000DV7N-2syw;
	Wed, 28 May 2025 10:34:56 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4887330066A; Wed, 28 May 2025 12:34:53 +0200 (CEST)
Date: Wed, 28 May 2025 12:34:53 +0200
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
Message-ID: <20250528103453.GF31726@noisy.programming.kicks-ass.net>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <7eccdb0b09eff581377e5efab8377b6a37596992.1746821544.git.jpoimboe@kernel.org>
 <20250526105240.GN24938@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250526105240.GN24938@noisy.programming.kicks-ass.net>

On Mon, May 26, 2025 at 12:52:40PM +0200, Peter Zijlstra wrote:
> On Fri, May 09, 2025 at 01:16:56PM -0700, Josh Poimboeuf wrote:
> > It's common to use --dryrun on binaries that have already been
> > processed.  Don't print the section skipping warnings in that case.
> 
> Ah, I rather like this warning, it gives me an easy check to see if the
> file has already been processed.
> 
> I typically do a OBJTOOL_ARGS="--backup" build and run dryrun debug
> sessions against those .orig files.

Turns out, you already broke this.. :-(

I'm now having a case where objtool fails on vmlinux.o and make happily
deletes vmlinux.o and I'm left empty handed.

Let me go resurrect --backup


