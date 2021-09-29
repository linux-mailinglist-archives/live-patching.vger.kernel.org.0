Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FAA41CBF6
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 20:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345967AbhI2Sio (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 14:38:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244341AbhI2Sin (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 14:38:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B05561216;
        Wed, 29 Sep 2021 18:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632940622;
        bh=CPrhUAEPrVxG1blhPy4KvTAh2nFGye7EBkU8S2JHDEE=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=jVqtu8KNl8ASKAxreKydqZivN0T3piGVZPtlZ2eXWEQPg7SZTYdU0UG++QONs6biT
         wLqaPU9WD34wdxmR67m0DXbnuBySiInlWPQqzSg2V68oymI/hmYZGHhs8Xy3nJQsk3
         NS+kAKAQS06OADLWEleeX+0yvCvVoQ15wjHjtVCSRDvQcXEOTXyhdbxld065SIqvsx
         K2UjEkJVvk3wq0vAp/MxxSgV0xNUOxVFQX3Jq4E9BhIsk/t2mBt2LOAZY8WdJ/+iMh
         fyJRqYaaoRfbelcexsGsFos3uFvrQSk0w1sjjWPkAwShmPLGIrL9BlVNINmdn7LTvg
         HYM4hUW+IjSHw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id EE0E75C06B9; Wed, 29 Sep 2021 11:37:01 -0700 (PDT)
Date:   Wed, 29 Sep 2021 11:37:01 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, rostedt@goodmis.org, x86@kernel.org
Subject: Re: [RFC][PATCH v2 08/11] context_tracking,rcu: Replace RCU dynticks
 counter with context_tracking
Message-ID: <20210929183701.GY880162@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20210929151723.162004989@infradead.org>
 <20210929152429.007420590@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929152429.007420590@infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 29, 2021 at 05:17:31PM +0200, Peter Zijlstra wrote:
> XXX I'm pretty sure I broke task-trace-rcu.
> XXX trace_rcu_*() now gets an unconditional 0
> 
> Other than that, it seems like a fairly straight-forward replacement
> of the RCU count with the context_tracking count.
> 
> Using context-tracking for this avoids having two (expensive) atomic
> ops on the entry paths where one will do.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

A few questions and exclamations interspersed.

> ---
>  include/linux/context_tracking.h |    6 ++
>  kernel/context_tracking.c        |   14 +++++
>  kernel/rcu/tree.c                |  101 +++++----------------------------------
>  kernel/rcu/tree.h                |    1 
>  4 files changed, 33 insertions(+), 89 deletions(-)
> 
> --- a/include/linux/context_tracking.h
> +++ b/include/linux/context_tracking.h
> @@ -50,6 +50,9 @@ extern void context_tracking_user_exit(v
>  
>  extern bool context_tracking_set_cpu_work(unsigned int cpu, unsigned int work);
>  
> +extern void context_tracking_idle(void);
> +extern void context_tracking_online(void);
> +
>  static inline void ct_user_enter(void)
>  {
>  	if (context_tracking_enabled())
> @@ -162,6 +165,9 @@ static __always_inline unsigned int __co
>  	return 0;
>  }
>  
> +static inline void context_tracking_idle(void) { }
> +static inline void context_tracking_online(void) { }
> +
>  #endif /* !CONFIG_CONTEXT_TRACKING */
>  
>  static __always_inline bool context_tracking_cpu_in_user(unsigned int cpu)
> --- a/kernel/context_tracking.c
> +++ b/kernel/context_tracking.c
> @@ -281,6 +281,20 @@ void noinstr __context_tracking_nmi_exit
>  		ct_seq_nmi_exit(raw_cpu_ptr(&context_tracking));
>  }
>  
> +void context_tracking_online(void)
> +{
> +	struct context_tracking *ct = raw_cpu_ptr(&context_tracking);
> +	unsigned int seq = atomic_read(&ct->seq);
> +
> +	if (__context_tracking_seq_in_user(seq))
> +		atomic_add_return(CT_SEQ - CT_SEQ_USER, &ct->seq);

What if the CPU went offline marked idle instead of user?  (Yes, that
no longer happens, but checking my understanding.)

The CT_SEQ_WORK bit means neither idle nor nohz_full user, correct?

So let's see if I intuited the decoder ring, where "kernel" means that
portion of the kernel that is non-noinstr...

CT_SEQ_WORK	CT_SEQ_NMI	CT_SEQ_USER	Description?
0		0		0		Idle or non-nohz_full user
0		0		1		nohz_full user
0		1		0		NMI from 0,0,0
0		1		1		NMI from 0,0,1
1		0		0		Non-idle kernel
1		0		1		Cannot happen?
1		1		0		NMI from 1,0,1
1		1		1		NMI from cannot happen

And of course if a state cannot happen, Murphy says that you will take
an NMI in that state.

> +}
> +
> +void context_tracking_idle(void)
> +{
> +	atomic_add_return(CT_SEQ, &raw_cpu_ptr(&context_tracking)->seq);

This is presumably a momentary idle.

And what happens to all of this in !CONFIG_CONTEXT_TRACKING kernels?
Of course, RCU needs it unconditionally.  (There appear to be at least
parts of it that are unconditionally available, but I figured that I
should ask.  Especially given the !CONFIG_CONTEXT_TRACKING definition
of the __context_tracking_cpu_seq() function.)

> +}
> +
>  void __init context_tracking_cpu_set(int cpu)
>  {
>  	static __initdata bool initialized = false;
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -62,6 +62,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/mm.h>
>  #include <linux/kasan.h>
> +#include <linux/context_tracking.h>
>  #include "../time/tick-internal.h"
>  
>  #include "tree.h"
> @@ -77,7 +78,6 @@
>  static DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_data, rcu_data) = {
>  	.dynticks_nesting = 1,
>  	.dynticks_nmi_nesting = DYNTICK_IRQ_NONIDLE,
> -	.dynticks = ATOMIC_INIT(1),
>  #ifdef CONFIG_RCU_NOCB_CPU
>  	.cblist.flags = SEGCBLIST_SOFTIRQ_ONLY,
>  #endif
> @@ -252,56 +252,6 @@ void rcu_softirq_qs(void)
>  }
>  
>  /*
> - * Increment the current CPU's rcu_data structure's ->dynticks field
> - * with ordering.  Return the new value.
> - */
> -static noinline noinstr unsigned long rcu_dynticks_inc(int incby)
> -{
> -	return arch_atomic_add_return(incby, this_cpu_ptr(&rcu_data.dynticks));
> -}
> -
> -/*
> - * Record entry into an extended quiescent state.  This is only to be
> - * called when not already in an extended quiescent state, that is,
> - * RCU is watching prior to the call to this function and is no longer
> - * watching upon return.
> - */
> -static noinstr void rcu_dynticks_eqs_enter(void)
> -{
> -	int seq;
> -
> -	/*
> -	 * CPUs seeing atomic_add_return() must see prior RCU read-side
> -	 * critical sections, and we also must force ordering with the
> -	 * next idle sojourn.
> -	 */
> -	rcu_dynticks_task_trace_enter();  // Before ->dynticks update!
> -	seq = rcu_dynticks_inc(1);
> -	// RCU is no longer watching.  Better be in extended quiescent state!
> -	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && (seq & 0x1));
> -}
> -
> -/*
> - * Record exit from an extended quiescent state.  This is only to be
> - * called from an extended quiescent state, that is, RCU is not watching
> - * prior to the call to this function and is watching upon return.
> - */
> -static noinstr void rcu_dynticks_eqs_exit(void)
> -{
> -	int seq;
> -
> -	/*
> -	 * CPUs seeing atomic_add_return() must see prior idle sojourns,
> -	 * and we also must force ordering with the next RCU read-side
> -	 * critical section.
> -	 */
> -	seq = rcu_dynticks_inc(1);
> -	// RCU is now watching.  Better not be in an extended quiescent state!
> -	rcu_dynticks_task_trace_exit();  // After ->dynticks update!
> -	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !(seq & 0x1));
> -}
> -
> -/*
>   * Reset the current CPU's ->dynticks counter to indicate that the
>   * newly onlined CPU is no longer in an extended quiescent state.
>   * This will either leave the counter unchanged, or increment it
> @@ -313,11 +263,7 @@ static noinstr void rcu_dynticks_eqs_exi
>   */
>  static void rcu_dynticks_eqs_online(void)
>  {
> -	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
> -
> -	if (atomic_read(&rdp->dynticks) & 0x1)
> -		return;
> -	rcu_dynticks_inc(1);
> +	context_tracking_online();
>  }
>  
>  /*
> @@ -327,7 +273,7 @@ static void rcu_dynticks_eqs_online(void
>   */
>  static __always_inline bool rcu_dynticks_curr_cpu_in_eqs(void)
>  {
> -	return !(atomic_read(this_cpu_ptr(&rcu_data.dynticks)) & 0x1);
> +	return context_tracking_cpu_in_user(smp_processor_id());

This needs to return true in any type of extended quiescent state,
not just nohz_full user execution.

>  }
>  
>  /*
> @@ -337,7 +283,7 @@ static __always_inline bool rcu_dynticks
>  static int rcu_dynticks_snap(struct rcu_data *rdp)
>  {
>  	smp_mb();  // Fundamental RCU ordering guarantee.
> -	return atomic_read_acquire(&rdp->dynticks);
> +	return __context_tracking_cpu_seq(rdp->cpu);

This will most definitely break RCU in !CONFIG_CONTEXT_TRACKING kernels.
It will always return zero.  Albeit fully ordered.  Might this be
why RCU Tasks Trace is unhappy?

Similar issues for later uses of __context_tracking_cpu_seq().

>  }
>  
>  /*
> @@ -346,7 +292,7 @@ static int rcu_dynticks_snap(struct rcu_
>   */
>  static bool rcu_dynticks_in_eqs(int snap)
>  {
> -	return !(snap & 0x1);
> +	return __context_tracking_seq_in_user(snap);
>  }
>  
>  /* Return true if the specified CPU is currently idle from an RCU viewpoint.  */
> @@ -377,7 +323,7 @@ bool rcu_dynticks_zero_in_eqs(int cpu, i
>  	int snap;
>  
>  	// If not quiescent, force back to earlier extended quiescent state.
> -	snap = atomic_read(&rdp->dynticks) & ~0x1;
> +	snap = __context_tracking_cpu_seq(rdp->cpu) & ~0x7;
>  
>  	smp_rmb(); // Order ->dynticks and *vp reads.
>  	if (READ_ONCE(*vp))
> @@ -385,7 +331,7 @@ bool rcu_dynticks_zero_in_eqs(int cpu, i
>  	smp_rmb(); // Order *vp read and ->dynticks re-read.
>  
>  	// If still in the same extended quiescent state, we are good!
> -	return snap == atomic_read(&rdp->dynticks);
> +	return snap == __context_tracking_cpu_seq(rdp->cpu);
>  }
>  
>  /*
> @@ -401,12 +347,8 @@ bool rcu_dynticks_zero_in_eqs(int cpu, i
>   */
>  notrace void rcu_momentary_dyntick_idle(void)
>  {
> -	int seq;
> -
>  	raw_cpu_write(rcu_data.rcu_need_heavy_qs, false);
> -	seq = rcu_dynticks_inc(2);
> -	/* It is illegal to call this from idle state. */
> -	WARN_ON_ONCE(!(seq & 0x1));
> +	context_tracking_idle();
>  	rcu_preempt_deferred_qs(current);
>  }
>  EXPORT_SYMBOL_GPL(rcu_momentary_dyntick_idle);
> @@ -622,18 +564,15 @@ static noinstr void rcu_eqs_enter(bool u
>  
>  	lockdep_assert_irqs_disabled();
>  	instrumentation_begin();
> -	trace_rcu_dyntick(TPS("Start"), rdp->dynticks_nesting, 0, atomic_read(&rdp->dynticks));
> +	trace_rcu_dyntick(TPS("Start"), rdp->dynticks_nesting, 0, 0);

Why not get the value from __context_tracking_cpu_seq()?

Ditto for similar changes later on.

>  	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
>  	rcu_prepare_for_idle();
>  	rcu_preempt_deferred_qs(current);
>  
> -	// instrumentation for the noinstr rcu_dynticks_eqs_enter()
> -	instrument_atomic_write(&rdp->dynticks, sizeof(rdp->dynticks));
>  
>  	instrumentation_end();
>  	WRITE_ONCE(rdp->dynticks_nesting, 0); /* Avoid irq-access tearing. */
>  	// RCU is watching here ...
> -	rcu_dynticks_eqs_enter();
>  	// ... but is no longer watching here.

OK, at the very least, these two comments are now nonsense.  ;-)

Is the intent to drive this from context tracking, so that these functions
only push the various required RCU state transitions?

Same for the similar changes below.

Anyway, unless I am missing something subtle (quite possible given
that I haven't looked closely at context tracking), you did succeed in
breaking RCU!  ;-)

>  	rcu_dynticks_task_enter();
>  }
> @@ -756,8 +695,7 @@ noinstr void rcu_nmi_exit(void)
>  	 * leave it in non-RCU-idle state.
>  	 */
>  	if (rdp->dynticks_nmi_nesting != 1) {
> -		trace_rcu_dyntick(TPS("--="), rdp->dynticks_nmi_nesting, rdp->dynticks_nmi_nesting - 2,
> -				  atomic_read(&rdp->dynticks));
> +		trace_rcu_dyntick(TPS("--="), rdp->dynticks_nmi_nesting, rdp->dynticks_nmi_nesting - 2, 0);
>  		WRITE_ONCE(rdp->dynticks_nmi_nesting, /* No store tearing. */
>  			   rdp->dynticks_nmi_nesting - 2);
>  		instrumentation_end();
> @@ -765,18 +703,15 @@ noinstr void rcu_nmi_exit(void)
>  	}
>  
>  	/* This NMI interrupted an RCU-idle CPU, restore RCU-idleness. */
> -	trace_rcu_dyntick(TPS("Startirq"), rdp->dynticks_nmi_nesting, 0, atomic_read(&rdp->dynticks));
> +	trace_rcu_dyntick(TPS("Startirq"), rdp->dynticks_nmi_nesting, 0, 0);
>  	WRITE_ONCE(rdp->dynticks_nmi_nesting, 0); /* Avoid store tearing. */
>  
>  	if (!in_nmi())
>  		rcu_prepare_for_idle();
>  
> -	// instrumentation for the noinstr rcu_dynticks_eqs_enter()
> -	instrument_atomic_write(&rdp->dynticks, sizeof(rdp->dynticks));
>  	instrumentation_end();
>  
>  	// RCU is watching here ...
> -	rcu_dynticks_eqs_enter();
>  	// ... but is no longer watching here.
>  
>  	if (!in_nmi())
> @@ -865,15 +800,11 @@ static void noinstr rcu_eqs_exit(bool us
>  	}
>  	rcu_dynticks_task_exit();
>  	// RCU is not watching here ...
> -	rcu_dynticks_eqs_exit();
>  	// ... but is watching here.
>  	instrumentation_begin();
>  
> -	// instrumentation for the noinstr rcu_dynticks_eqs_exit()
> -	instrument_atomic_write(&rdp->dynticks, sizeof(rdp->dynticks));
> -
>  	rcu_cleanup_after_idle();
> -	trace_rcu_dyntick(TPS("End"), rdp->dynticks_nesting, 1, atomic_read(&rdp->dynticks));
> +	trace_rcu_dyntick(TPS("End"), rdp->dynticks_nesting, 1, 0);
>  	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
>  	WRITE_ONCE(rdp->dynticks_nesting, 1);
>  	WARN_ON_ONCE(rdp->dynticks_nmi_nesting);
> @@ -1011,7 +942,6 @@ noinstr void rcu_nmi_enter(void)
>  			rcu_dynticks_task_exit();
>  
>  		// RCU is not watching here ...
> -		rcu_dynticks_eqs_exit();
>  		// ... but is watching here.
>  
>  		if (!in_nmi()) {
> @@ -1021,11 +951,6 @@ noinstr void rcu_nmi_enter(void)
>  		}
>  
>  		instrumentation_begin();
> -		// instrumentation for the noinstr rcu_dynticks_curr_cpu_in_eqs()
> -		instrument_atomic_read(&rdp->dynticks, sizeof(rdp->dynticks));
> -		// instrumentation for the noinstr rcu_dynticks_eqs_exit()
> -		instrument_atomic_write(&rdp->dynticks, sizeof(rdp->dynticks));
> -
>  		incby = 1;
>  	} else if (!in_nmi()) {
>  		instrumentation_begin();
> @@ -1036,7 +961,7 @@ noinstr void rcu_nmi_enter(void)
>  
>  	trace_rcu_dyntick(incby == 1 ? TPS("Endirq") : TPS("++="),
>  			  rdp->dynticks_nmi_nesting,
> -			  rdp->dynticks_nmi_nesting + incby, atomic_read(&rdp->dynticks));
> +			  rdp->dynticks_nmi_nesting + incby, 0);
>  	instrumentation_end();
>  	WRITE_ONCE(rdp->dynticks_nmi_nesting, /* Prevent store tearing. */
>  		   rdp->dynticks_nmi_nesting + incby);
> --- a/kernel/rcu/tree.h
> +++ b/kernel/rcu/tree.h
> @@ -184,7 +184,6 @@ struct rcu_data {
>  	int dynticks_snap;		/* Per-GP tracking for dynticks. */
>  	long dynticks_nesting;		/* Track process nesting level. */
>  	long dynticks_nmi_nesting;	/* Track irq/NMI nesting level. */
> -	atomic_t dynticks;		/* Even value for idle, else odd. */
>  	bool rcu_need_heavy_qs;		/* GP old, so heavy quiescent state! */
>  	bool rcu_urgent_qs;		/* GP old need light quiescent state. */
>  	bool rcu_forced_tick;		/* Forced tick to provide QS. */
> 
> 
