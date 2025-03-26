Return-Path: <live-patching+bounces-1338-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44537A71500
	for <lists+live-patching@lfdr.de>; Wed, 26 Mar 2025 11:39:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B916C3B4892
	for <lists+live-patching@lfdr.de>; Wed, 26 Mar 2025 10:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F2981C6FF5;
	Wed, 26 Mar 2025 10:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Yc4ddnmN"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8856019F495;
	Wed, 26 Mar 2025 10:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742985533; cv=none; b=RgnGGtap9IaILJsKFcFnbE6RpiWIHwpryLUV5XPcP4ziVjAzuVnNazaZW6Emd6vKxfLOtX6HCtGKxcnE+adwxxCXKP0050vJQH6483iBtgO0jTOU7aCi2ny9cGG9wkg9Dig9+ymL+TlQZyaYk/xyMVBj2CurxpyqtC1+eKNB6jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742985533; c=relaxed/simple;
	bh=TwVrby1x9qMf1Pcrh5IouJqZ49ShDOifVJ5ebj2gNS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DVg3I8jGahIr7Go1nJJQiRIstWrVerKH+qmzojqpzFRZK4F/W1nAHe8AZF7QfgZlvINFn64pS3Do+TnXx+Urw+RmpDyHSvJsd2Hog0BKewbmfNvz/xNK8n9CeqGc6SkeHDEdaESlt2u9dvRESENtSvThU9QD6gKtU59Grki6IMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Yc4ddnmN; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1zKKwHBQrnwVUIfjr6+BTrqXcVsJWLW7+XZ5P4QFKY0=; b=Yc4ddnmNxsrcSqpdBS+y64zIAN
	JweeQOFvhwe6NNKb+x/d65ZLrL75hxSxK5GX95hv7Og/4x4Cnq4oRYBFhKuQvbteRpauo3hlAW45w
	6pcAKnL9H+4Jm0GmDYlFvvT4UujPndPwBIzJVcIbW3Eg3Wf6fky/J7FxTmnWc3RpTQ8EgenqhU4I/
	B6nJx3sW9M+GXspZzPDd4Z70D8IegCuofQ1Ps08kmXCvdaiUKXgsP+7KDaLx9DnE9KP/kpIadJ32n
	gWhVjw/+lFXm2P7FfZcbdXyaXxVQYmxdR4Dk3z09l8sjq9L6NgAC5ewmcm5eIiv9TfvY+zm9hpSyI
	+51lU4XQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1txO9k-00000005mqV-0bGP;
	Wed, 26 Mar 2025 10:38:44 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B46CA3003C4; Wed, 26 Mar 2025 11:38:43 +0100 (CET)
Date: Wed, 26 Mar 2025 11:38:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Petr Mladek <pmladek@suse.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, mingo@kernel.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, jpoimboe@kernel.org,
	jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [RFC][PATCH] sched,livepatch: Untangle cond_resched() and
 live-patching
Message-ID: <20250326103843.GB5880@noisy.programming.kicks-ass.net>
References: <20250324134909.GA14718@noisy.programming.kicks-ass.net>
 <Z-PNll7fJQzCDH35@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-PNll7fJQzCDH35@pathway.suse.cz>

On Wed, Mar 26, 2025 at 10:49:10AM +0100, Petr Mladek wrote:
> On Mon 2025-03-24 14:49:09, Peter Zijlstra wrote:
> > 
> > With the goal of deprecating / removing VOLUNTARY preempt, live-patch
> > needs to stop relying on cond_resched() to make forward progress.
> > 
> > Instead, rely on schedule() with TASK_FREEZABLE set. Just like
> > live-patching, the freezer needs to be able to stop tasks in a safe /
> > known state.
> 
> > Compile tested only.
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  include/linux/livepatch_sched.h | 15 +++++--------
> >  include/linux/sched.h           |  6 -----
> >  kernel/livepatch/transition.c   | 30 ++++++-------------------
> >  kernel/sched/core.c             | 50 +++++++----------------------------------
> >  4 files changed, 21 insertions(+), 80 deletions(-)
> > 
> > diff --git a/include/linux/livepatch_sched.h b/include/linux/livepatch_sched.h
> > index 013794fb5da0..7e8171226dd7 100644
> > --- a/include/linux/livepatch_sched.h
> > +++ b/include/linux/livepatch_sched.h
> > @@ -3,27 +3,24 @@
> >  #define _LINUX_LIVEPATCH_SCHED_H_
> >  
> >  #include <linux/jump_label.h>
> > -#include <linux/static_call_types.h>
> > +#include <linux/sched.h>
> > +
> >  
> >  #ifdef CONFIG_LIVEPATCH
> >  
> >  void __klp_sched_try_switch(void);
> >  
> > -#if !defined(CONFIG_PREEMPT_DYNAMIC) || !defined(CONFIG_HAVE_PREEMPT_DYNAMIC_CALL)
> > -
> >  DECLARE_STATIC_KEY_FALSE(klp_sched_try_switch_key);
> >  
> > -static __always_inline void klp_sched_try_switch(void)
> > +static __always_inline void klp_sched_try_switch(struct task_struct *curr)
> >  {
> > -	if (static_branch_unlikely(&klp_sched_try_switch_key))
> > +	if (static_branch_unlikely(&klp_sched_try_switch_key) &&
> > +	    READ_ONCE(curr->__state) & TASK_FREEZABLE)
> >  		__klp_sched_try_switch();
> >  }
> 
> Do we really need to check the TASK_FREEZABLE state, please?
> 
> My understanding is that TASK_FREEZABLE is set when kernel kthreads go into
> a "freezable" sleep, e.g. wait_event_freezable().

Right.

> But __klp_sched_try_switch() should be safe when the task is not
> running and the stack is reliable. IMHO, it should be safe anytime
> it is being scheduled out.

So for the reasons you touched upon in the next paragraph, FREEZABLE
seemed like a more suitable location.

> Note that wait_event_freezable() is a good location. It is usually called in
> the main loop of the kthread where the stack is small. So that the chance
> that it is not running a livepatched function is higher than on
> another random schedulable location.

Right, it is the natural quiescent state of the kthread, it holds no
resources.

> But we actually wanted to have it in cond_resched() because
> it might take a long time to reach the main loop, and sleep there.

Well, cond_resched() is going to get deleted, so we need to find
something else. And I was thinking that the suspend people want
reasonable timeliness too -- you don't want your laptop to continue
running for many seconds after you close the lid and stuff it in your
bag, now do you.

So per that reasoning I figured FREEZABLE should be good enough.

Sharing the pain with suspend can only lead to improving both -- faster
patching progress leads to faster suspend and vice-versa.

