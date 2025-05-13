Return-Path: <live-patching+bounces-1426-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99A48AB56B2
	for <lists+live-patching@lfdr.de>; Tue, 13 May 2025 16:03:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC7F14A4DD2
	for <lists+live-patching@lfdr.de>; Tue, 13 May 2025 14:03:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 802F027FB39;
	Tue, 13 May 2025 14:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qjr2TtXz"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11EB19AD8C;
	Tue, 13 May 2025 14:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747145001; cv=none; b=bQUNb4vPErLvNjHmGtZmETH6nwT8IRJ7INzhfMIcYn4K2qjoN8qSaCbxaAPOJgDHfFug0CJrimCAbI5E3ht5t01LAMjqs60cd+OWW0HDmtlu8MVAIFFMzZOOH4Nwr8Dm1zCGguQFirO/YDD3EiiREQpdIU4kw++mZurIMMKgUMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747145001; c=relaxed/simple;
	bh=kLyZ/99H6Nrs953XFgOblqgubGudNxOxkE8hiciKiNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I5w8K1zCOtu/FcEZh8mODXamtusgccR9U5F0Aoj3AkMFf2Oh7oP1b1m4GFPpMd52VehQEl4CV5L9irr4yS4hyTsSMYnDxVD32AgdIT+7dAA+SeKBCmqoQhSKenoblB22F3g+q4S1y16Njj3ZNGYlmxkiBGqlGLugd+NCiaNnPI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Qjr2TtXz; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tCpy3MCMjOcZ+1ae9yHQGikdXzsY+8s0qC6qF1kYN5M=; b=Qjr2TtXz5ZG3ryWGM/AEPgURp6
	lfH7HVkvUAz0asI2QGdUS+bPiVq/v7rU40uCt0YALjYMpaooOE4GtWW/qYluCVpXW7Z+cfHTb/CLC
	PpUtm9IJeAAqswVrR2iMLsTCRdcXEkcNRc6IDAAfi09KocqOW367FYMyHQkRYHc8XZvv6mDl8NoaX
	Jx8ATsqlDrY7+Rf+J3sI95AH544COTkfTKQ+AqjLR0O/LeLVfdM8IzuzlyEVOJHMDeZQZSXnG2m56
	Ot+TXfI0xs8QmBBVWMiHz/NeZe/LbnZ4MQdjmlw/499LTkfmeynBN1SpTKouDlULjQhQOB4O485IZ
	lFc2sTGw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1uEqDv-0000000GzS6-2dNu;
	Tue, 13 May 2025 14:03:12 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 15296300342; Tue, 13 May 2025 16:03:11 +0200 (CEST)
Date: Tue, 13 May 2025 16:03:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
	Josh Poimboeuf <jpoimboe@redhat.com>, mingo@kernel.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, jpoimboe@kernel.org,
	jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] sched,livepatch: Untangle cond_resched() and
 live-patching
Message-ID: <20250513140310.GA25639@noisy.programming.kicks-ass.net>
References: <20250509113659.wkP_HJ5z@linutronix.de>
 <alpine.LSU.2.21.2505131529080.19621@pobox.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2505131529080.19621@pobox.suse.cz>

On Tue, May 13, 2025 at 03:34:50PM +0200, Miroslav Benes wrote:
> Hi,
> 
> thanks for the updated version.
> 
> On Fri, 9 May 2025, Sebastian Andrzej Siewior wrote:
> 
> > From: Peter Zijlstra <peterz@infradead.org>
> > 
> > With the goal of deprecating / removing VOLUNTARY preempt, live-patch
> > needs to stop relying on cond_resched() to make forward progress.
> > 
> > Instead, rely on schedule() with TASK_FREEZABLE set. Just like
> > live-patching, the freezer needs to be able to stop tasks in a safe /
> > known state.
> > 
> > Compile tested only.
> 
> livepatch selftests pass and I also ran some more.
>  
> > [bigeasy: use likely() in __klp_sched_try_switch() and update comments]
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> Acked-by: Miroslav Benes <mbenes@suse.cz>
> 
> A nit below if there is an another version, otherwise Petr might fix it 
> when merging.

Petr or Peter?

That is, who are we expecting to merge this :-)

Anyway, I've zapped the line in my copy.

> > @@ -365,27 +356,20 @@ static bool klp_try_switch_task(struct task_struct *task)
> >  
> >  void __klp_sched_try_switch(void)
> >  {
> > +	/*
> > +	 * This function is called from __schedule() while a context switch is
> > +	 * about to happen. Preemption is already disabled and klp_mutex
> > +	 * can't be acquired.
> > +	 * Disabled preemption is used to prevent racing with other callers of
> > +	 * klp_try_switch_task(). Thanks to task_call_func() they won't be
> > +	 * able to switch to this task while it's running.
> > +	 */
> > +	lockdep_assert_preemption_disabled();
> > +
> > +	/* Make sure current didn't get patched */
> >       if (likely(!klp_patch_pending(current)))
> >                return;
> 
> This last comment is not precise. If !klp_patch_pending(), there is 
> nothing to do. Fast way out. So if it was up to me, I would remove the 
> line all together.
> 
> Miroslav

