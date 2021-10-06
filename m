Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC25423975
	for <lists+live-patching@lfdr.de>; Wed,  6 Oct 2021 10:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237761AbhJFIOP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 6 Oct 2021 04:14:15 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:34768 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237772AbhJFIOO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 6 Oct 2021 04:14:14 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5EE1420322;
        Wed,  6 Oct 2021 08:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633507941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2Ex/uCnma/tiMObj88oRVc2SIybziL1O5YZ+npjAnOY=;
        b=LSORa5Nt3IiYoNElzpeQULqRJqORVrYH23kM4QiB0dRBSeuvavO6viXo15de3SZ3pIKbCQ
        Q9TrAYhL+mu0KdbiETbJXx3aD3ulVkGziO0NGJ9hWp4S9CR1yoem+Qy795fhyTDx0dhdzz
        +F//VyxwAqx7kp5b+OSsEC+0bc95aJ4=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 0985DA3B95;
        Wed,  6 Oct 2021 08:12:21 +0000 (UTC)
Date:   Wed, 6 Oct 2021 10:12:17 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, mingo@kernel.org, linux-kernel@vger.kernel.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: Re: [RFC][PATCH v2 09/11] context_tracking,livepatch: Dont disturb
 NOHZ_FULL
Message-ID: <YV1aYaHEynjSAUuI@alley>
References: <20210929151723.162004989@infradead.org>
 <20210929152429.067060646@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929152429.067060646@infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2021-09-29 17:17:32, Peter Zijlstra wrote:
> Using the new context_tracking infrastructure, avoid disturbing
> userspace tasks when context tracking is enabled.
> 
> When context_tracking_set_cpu_work() returns true, we have the
> guarantee that klp_update_patch_state() is called from noinstr code
> before it runs normal kernel code. This covers
> syscall/exceptions/interrupts and NMI entry.

This patch touches the most tricky (lockless) parts of the livepatch code.
I always have to refresh my head about all the dependencies.

Sigh, I guess that the livepatch code looks over complicated to you.

The main problem is that we want to migrate tasks only when they
are not inside any livepatched function. It allows to do semantic
changes which is needed by some sort of critical security fixes.


> --- a/kernel/context_tracking.c
> +++ b/kernel/context_tracking.c
> @@ -55,15 +56,13 @@ static noinstr void ct_exit_user_work(struct
>  {
>  	unsigned int work = arch_atomic_read(&ct->work);
>  
> -#if 0
> -	if (work & CT_WORK_n) {
> +	if (work & CT_WORK_KLP) {
>  		/* NMI happens here and must still do/finish CT_WORK_n */
> -		do_work_n();
> +		__klp_update_patch_state(current);
>  
>  		smp_mb__before_atomic();
> -		arch_atomic_andnot(CT_WORK_n, &ct->work);
> +		arch_atomic_andnot(CT_WORK_KLP, &ct->work);
>  	}
> -#endif
>  
>  	smp_mb__before_atomic();
>  	arch_atomic_andnot(CT_SEQ_WORK, &ct->seq);
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -153,6 +154,11 @@ void klp_cancel_transition(void)
>  	klp_complete_transition();
>  }
>  
> +noinstr void __klp_update_patch_state(struct task_struct *task)
> +{
> +	task->patch_state = READ_ONCE(klp_target_state);
> +}
> +
>  /*
>   * Switch the patched state of the task to the set of functions in the target
>   * patch state.
> @@ -180,8 +186,10 @@ void klp_update_patch_state(struct task_
>  	 *    of func->transition, if klp_ftrace_handler() is called later on
>  	 *    the same CPU.  See __klp_disable_patch().
>  	 */
> -	if (test_and_clear_tsk_thread_flag(task, TIF_PATCH_PENDING))
> +	if (test_tsk_thread_flag(task, TIF_PATCH_PENDING)) {

This would require smp_rmb() here. It will make sure that we will
read the right @klp_target_state when TIF_PATCH_PENDING is set.

, where @klp_target_state is set in klp_init_transition()
  and TIF_PATCH_PENDING is set in klp_start_transition()

There are actually two related smp_wmp() barriers between these two
assignments in:

	1st in klp_init_transition()
	2nd in __klp_enable_patch()

One would be enough for klp_update_patch_state(). But we need
both for klp_ftrace_handler(), see the smp_rmb() there.
In particular, they synchronize:

   + ops->func_stack vs.
   + func->transition vs.
   + current->patch_state


>  		task->patch_state = READ_ONCE(klp_target_state);

Note that smp_wmb() is not needed here because
klp_complete_transition() calls klp_synchronize_transition()
aka synchronize_rcu() before clearing klp_target_state.
This is why the original code worked.


> +		clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
> +	}
>  
>  	preempt_enable_notrace();
>  }
> @@ -270,15 +278,30 @@ static int klp_check_and_switch_task(str
>  {
>  	int ret;
>  
> -	if (task_curr(task))
> +	if (task_curr(task)) {
> +		/*
> +		 * This only succeeds when the task is in NOHZ_FULL user
> +		 * mode, the true return value guarantees any kernel entry
> +		 * will call klp_update_patch_state().
> +		 *
> +		 * XXX: ideally we'd simply return 0 here and leave
> +		 * TIF_PATCH_PENDING alone, to be fixed up by
> +		 * klp_update_patch_state(), except livepatching goes wobbly
> +		 * with 'pending' TIF bits on.
> +		 */
> +		if (context_tracking_set_cpu_work(task_cpu(task), CT_WORK_KLP))
> +			goto clear;

If I get it correctly, this will clear TIF_PATCH_PENDING immediately
but task->patch_state = READ_ONCE(klp_target_state) will be
done later by ct_exit_user_work().

This is a bit problematic:

  1. The global @klp_target_state is set to KLP_UNDEFINED when all
     processes have TIF_PATCH_PENDING is cleared. This is actually
     still fine because func->transition is cleared as well.
     As a result, current->patch_state is ignored in klp_ftrace_handler.

  2. The real problem happens when another livepatch is enabled.
     The global @klp_target_state is set to new value and
     func->transition is set again. In this case, the delayed
     ct_exit_user_work() might assign wrong value that might
     really be used by klp_ftrace_handler().


IMHO, the original solution from v1 was better. We only needed to
be careful when updating task->patch_state and clearing
TIF_PATCH_PENDING to avoid the race.

The following might work:

static int klp_check_and_switch_task(struct task_struct *task, void *arg)
{
	int ret;

	/*
	 * Stack is reliable only when the task is not running on any CPU,
	 * except for the task running this code.
	 */
	if (task_curr(task) && task != current) {
		/*
		 * This only succeeds when the task is in NOHZ_FULL user
		 * mode. Such a task might be migrated immediately. We
		 * only need to be careful to set task->patch_state before
		 * clearing TIF_PATCH_PENDING so that the task migrates
		 * itself when entring kernel in the meatime.
		 */
		if (is_ct_user(task)) {
			klp_update_patch_state(task);
			return 0;
		}

		return -EBUSY;
	}

	ret = klp_check_stack(task, arg);
	if (ret)
		return ret;

	/*
	 * The task neither is running on any CPU and nor it can get
	 * running. As a result, the ordering is not important and
	 * barrier is not needed.
	 */
	task->patch_state = klp_target_state;
	clear_tsk_thread_flag(task, TIF_PATCH_PENDING);

	return 0;
}

, where is_ct_user(task) would return true when task is running in
CONTEXT_USER. If I get the context_tracking API correctly then
it might be implemeted the following way:


#ifdef CONFIG_CONTEXT_TRACKING

/*
 * XXX: The value is reliable depending the context where this is called.
 * At least migrating between CPUs should get prevented.
 */
static __always_inline bool is_ct_user(struct task_struct *task)
{
	int seq;

	if (!context_tracking_enabled())
		return false;

	seq = __context_tracking_cpu_seq(task_cpu(task));
	return __context_tracking_seq_in_user(seq);
}

#else

static __always_inline bool is_ct_user(struct task_struct *task)
{
	return false;
}

#endif /* CONFIG_CONTEXT_TRACKING */

Best Regards,
Petr

>  		return -EBUSY;
> +	}
>  
>  	ret = klp_check_stack(task, arg);
>  	if (ret)
>  		return ret;
>  
> -	clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
>  	task->patch_state = klp_target_state;
> +clear:
> +	clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
>  	return 0;
>  }
