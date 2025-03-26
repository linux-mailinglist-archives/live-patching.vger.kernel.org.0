Return-Path: <live-patching+bounces-1341-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED2CCA71946
	for <lists+live-patching@lfdr.de>; Wed, 26 Mar 2025 15:49:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1E53179711
	for <lists+live-patching@lfdr.de>; Wed, 26 Mar 2025 14:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 036E01F471D;
	Wed, 26 Mar 2025 14:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fi5grXho"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9B41F4716;
	Wed, 26 Mar 2025 14:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743000142; cv=none; b=c7eRWZGk/TxFmLQk7i1x0LBNrz/Z6Md02tI2Lyu4xK4HU3q4UAKPVHwSEkcSgeertvxplYgLUOGgYklugQsGRu6JlUrw8UOHaj93T6/2PHxo/rhxBHVrbTGZv4IclBCVxZj+th5s4/6Eu7aCN5A2NV1J4+q36AfQNXEYwRpbkHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743000142; c=relaxed/simple;
	bh=QOSV12oqDthT8kmpiZMJDPHD5H7Z+8eiVAijdvHwdyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rtNIqh4ZadfYvkaE+Ra2N4bmWsnCUdUNv/B6qvmHI4DQ+XA9GsGumnF0YPUCwGLZE6zyyz3PK+K6bdp5X3uP6Mq2mIbuIsbPXe6YJKJyxl64jiCPNJVGyR0aKrJuM9G+9tS0xypoklZBXbC5JjWvjiXbrxhBQdqui3VZ8D487M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fi5grXho; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CyI5K/SbyVvcE4g5wfQNWdFDhiMRKaxUcHqMuaIlGQc=; b=fi5grXhoyB3Nj5W5Qhy3rhB7rf
	GFTaVdZNcQgjPb39f83cVHaeL/TySAew0gXvxNjKcoWCASs28BrAgFzAC7DqOG2yfte72K/z3wosl
	nIwbhsVEkmPIjwUaYpVSYfOjInU703Ma9KUxeRcjOd+jh0awIW6Nj+rjtddXmWk7YhUuppkrO1/Og
	biyhbFtRJ96MEoTXuJO/RSnCWiUCBhRF5Cx04G4MqFLTWYbM2YxRKekAKokiY52/jExtVITG+egW0
	fwznsyAflV7BTPwZO9YqS/sCTHeVhdYUBZ/z0p4drZVSjC/qgu8nw5S2HU40MDRlEyG0JWEjJCSyE
	m62pcuuA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1txRxN-00000005on6-2zyn;
	Wed, 26 Mar 2025 14:42:14 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id BD2A23004AF; Wed, 26 Mar 2025 15:42:12 +0100 (CET)
Date: Wed, 26 Mar 2025 15:42:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
	mingo@kernel.com, juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, jpoimboe@kernel.org,
	jikos@kernel.org, joe.lawrence@redhat.com,
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [RFC][PATCH] sched,livepatch: Untangle cond_resched() and
 live-patching
Message-ID: <20250326144212.GG25239@noisy.programming.kicks-ass.net>
References: <20250324134909.GA14718@noisy.programming.kicks-ass.net>
 <Z-PNll7fJQzCDH35@pathway.suse.cz>
 <20250326103843.GB5880@noisy.programming.kicks-ass.net>
 <alpine.LSU.2.21.2503261534450.4152@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2503261534450.4152@pobox.suse.cz>

On Wed, Mar 26, 2025 at 03:37:50PM +0100, Miroslav Benes wrote:

> If I remember correctly, we had something like this in the old kGraft 
> implementation of the live patching (SUSE way). We exactly had a hook 
> somewhere in the kthread freezing code. This looks much cleaner and as far 
> as I know the fridge went through improvements recently.

Yeah, I rewrote it a while ago :-)

> Peter, so that I understand it correctly... we would rely on all kthreads 
> becoming freezable eventually so that both suspend and livepatch benefit. 
> Is that what you meant by the above?

Well, IIRC (its been a while already) all kthreads should have a
FREEZABLE already. Things like suspend-to-idle don't hit the hotplug
path at all anymore and everything must freeze, otherwise they fail.

I was more meaning the time-to-freeze; if some kthreads take a long time
to freeze/patch then this would want improving on both ends.

