Return-Path: <live-patching+bounces-1340-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 75905A718B6
	for <lists+live-patching@lfdr.de>; Wed, 26 Mar 2025 15:40:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00602188853F
	for <lists+live-patching@lfdr.de>; Wed, 26 Mar 2025 14:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ACAF1F30D1;
	Wed, 26 Mar 2025 14:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="s1C+acTD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KDeJ3oyt";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="s1C+acTD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KDeJ3oyt"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582771F2360
	for <live-patching@vger.kernel.org>; Wed, 26 Mar 2025 14:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742999873; cv=none; b=q102dg3uYsJ6y4YaKEb7nT88T+BTgsXqzThRmYxOwE99PYorFgPfh19WV2BqX4eSTuM6zwadhvLxZ549H/hUgO9pyPEGwMTZ4hvvxccHft7L+8Ry6Bs14G13BoqsdGYlNuHJZMmD3b2fTS8Rj5NnZWeV98/jrOV+N4B6Sh/SQeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742999873; c=relaxed/simple;
	bh=aF4BxnLqgMaCkIfKhFH1072+sZe6ru3YYsMv3ROsBew=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ujkTDqU39DQIufp+fnhv4GnI3Mh9x3sXsBNLCz3GVrZ7+8XAyr75V7PbYZopEFDFxZ0pkF1618kjLb0igi0EyQc9T9HmBSMNPydjqj4UuQ2id/snU7RhJjnm5z7Lb2PTEeJJBFtTGjJNKeGWJ78rmdS9AAX4730RWcxNFWG5yKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=s1C+acTD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KDeJ3oyt; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=s1C+acTD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KDeJ3oyt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8D9A621169;
	Wed, 26 Mar 2025 14:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1742999870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Iei0290+sElRTf7ajx+JEEEsALtKWNsDpN8ouPBF5NI=;
	b=s1C+acTDi4pQtD7Fkqnv9T2NwSmTkPHzo31rH4lPc2vwW3RyXci6ueDDk3xfxjDeHiK8ed
	4nD7dz7n79JaFfRxPDxko+mFdg0ZkwYL9zfPxo+nGR8IjCNKAGh5Hx3lDvY04LwS8oeG4A
	4DSUDNOlf4CuQJ2B8larNlm+BMTlc8A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1742999870;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Iei0290+sElRTf7ajx+JEEEsALtKWNsDpN8ouPBF5NI=;
	b=KDeJ3oytxjLjk3SZcWH4nMykOItOK1V0kZykfzaGK9MQS0dxuQYEARJk1u1RLWL2vxLg53
	5I4DV8mjVQ3pSpAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1742999870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Iei0290+sElRTf7ajx+JEEEsALtKWNsDpN8ouPBF5NI=;
	b=s1C+acTDi4pQtD7Fkqnv9T2NwSmTkPHzo31rH4lPc2vwW3RyXci6ueDDk3xfxjDeHiK8ed
	4nD7dz7n79JaFfRxPDxko+mFdg0ZkwYL9zfPxo+nGR8IjCNKAGh5Hx3lDvY04LwS8oeG4A
	4DSUDNOlf4CuQJ2B8larNlm+BMTlc8A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1742999870;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Iei0290+sElRTf7ajx+JEEEsALtKWNsDpN8ouPBF5NI=;
	b=KDeJ3oytxjLjk3SZcWH4nMykOItOK1V0kZykfzaGK9MQS0dxuQYEARJk1u1RLWL2vxLg53
	5I4DV8mjVQ3pSpAQ==
Date: Wed, 26 Mar 2025 15:37:50 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>
cc: Petr Mladek <pmladek@suse.com>, Josh Poimboeuf <jpoimboe@redhat.com>, 
    mingo@kernel.com, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
    dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
    mgorman@suse.de, vschneid@redhat.com, jpoimboe@kernel.org, 
    jikos@kernel.org, joe.lawrence@redhat.com, linux-kernel@vger.kernel.org, 
    live-patching@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [RFC][PATCH] sched,livepatch: Untangle cond_resched() and
 live-patching
In-Reply-To: <20250326103843.GB5880@noisy.programming.kicks-ass.net>
Message-ID: <alpine.LSU.2.21.2503261534450.4152@pobox.suse.cz>
References: <20250324134909.GA14718@noisy.programming.kicks-ass.net> <Z-PNll7fJQzCDH35@pathway.suse.cz> <20250326103843.GB5880@noisy.programming.kicks-ass.net>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.990];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[18];
	RCVD_COUNT_ZERO(0.00)[0];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:email]
X-Spam-Score: -4.30
X-Spam-Flag: NO

Hi,

On Wed, 26 Mar 2025, Peter Zijlstra wrote:

> On Wed, Mar 26, 2025 at 10:49:10AM +0100, Petr Mladek wrote:
> > On Mon 2025-03-24 14:49:09, Peter Zijlstra wrote:
> > > 
> > > With the goal of deprecating / removing VOLUNTARY preempt, live-patch
> > > needs to stop relying on cond_resched() to make forward progress.
> > > 
> > > Instead, rely on schedule() with TASK_FREEZABLE set. Just like
> > > live-patching, the freezer needs to be able to stop tasks in a safe /
> > > known state.
> > 
> > > Compile tested only.
> > > 
> > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > > ---
> > >  include/linux/livepatch_sched.h | 15 +++++--------
> > >  include/linux/sched.h           |  6 -----
> > >  kernel/livepatch/transition.c   | 30 ++++++-------------------
> > >  kernel/sched/core.c             | 50 +++++++----------------------------------
> > >  4 files changed, 21 insertions(+), 80 deletions(-)
> > > 
> > > diff --git a/include/linux/livepatch_sched.h b/include/linux/livepatch_sched.h
> > > index 013794fb5da0..7e8171226dd7 100644
> > > --- a/include/linux/livepatch_sched.h
> > > +++ b/include/linux/livepatch_sched.h
> > > @@ -3,27 +3,24 @@
> > >  #define _LINUX_LIVEPATCH_SCHED_H_
> > >  
> > >  #include <linux/jump_label.h>
> > > -#include <linux/static_call_types.h>
> > > +#include <linux/sched.h>
> > > +
> > >  
> > >  #ifdef CONFIG_LIVEPATCH
> > >  
> > >  void __klp_sched_try_switch(void);
> > >  
> > > -#if !defined(CONFIG_PREEMPT_DYNAMIC) || !defined(CONFIG_HAVE_PREEMPT_DYNAMIC_CALL)
> > > -
> > >  DECLARE_STATIC_KEY_FALSE(klp_sched_try_switch_key);
> > >  
> > > -static __always_inline void klp_sched_try_switch(void)
> > > +static __always_inline void klp_sched_try_switch(struct task_struct *curr)
> > >  {
> > > -	if (static_branch_unlikely(&klp_sched_try_switch_key))
> > > +	if (static_branch_unlikely(&klp_sched_try_switch_key) &&
> > > +	    READ_ONCE(curr->__state) & TASK_FREEZABLE)
> > >  		__klp_sched_try_switch();
> > >  }
> > 
> > Do we really need to check the TASK_FREEZABLE state, please?
> > 
> > My understanding is that TASK_FREEZABLE is set when kernel kthreads go into
> > a "freezable" sleep, e.g. wait_event_freezable().
> 
> Right.
> 
> > But __klp_sched_try_switch() should be safe when the task is not
> > running and the stack is reliable. IMHO, it should be safe anytime
> > it is being scheduled out.
> 
> So for the reasons you touched upon in the next paragraph, FREEZABLE
> seemed like a more suitable location.
> 
> > Note that wait_event_freezable() is a good location. It is usually called in
> > the main loop of the kthread where the stack is small. So that the chance
> > that it is not running a livepatched function is higher than on
> > another random schedulable location.
> 
> Right, it is the natural quiescent state of the kthread, it holds no
> resources.
> 
> > But we actually wanted to have it in cond_resched() because
> > it might take a long time to reach the main loop, and sleep there.
> 
> Well, cond_resched() is going to get deleted, so we need to find
> something else. And I was thinking that the suspend people want
> reasonable timeliness too -- you don't want your laptop to continue
> running for many seconds after you close the lid and stuff it in your
> bag, now do you.
> 
> So per that reasoning I figured FREEZABLE should be good enough.
> 
> Sharing the pain with suspend can only lead to improving both -- faster
> patching progress leads to faster suspend and vice-versa.

If I remember correctly, we had something like this in the old kGraft 
implementation of the live patching (SUSE way). We exactly had a hook 
somewhere in the kthread freezing code. This looks much cleaner and as far 
as I know the fridge went through improvements recently.

Peter, so that I understand it correctly... we would rely on all kthreads 
becoming freezable eventually so that both suspend and livepatch benefit. 
Is that what you meant by the above?

Miroslav


