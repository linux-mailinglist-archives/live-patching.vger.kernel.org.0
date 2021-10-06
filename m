Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E422F423A2D
	for <lists+live-patching@lfdr.de>; Wed,  6 Oct 2021 11:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhJFJGk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 6 Oct 2021 05:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbhJFJGj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 6 Oct 2021 05:06:39 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF63C061749;
        Wed,  6 Oct 2021 02:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mcZ2BZ0T57l31xzV2p4lUGoPJ7rclyZKodqgekDqvvM=; b=XUTRvrEUBeNvwzyL8W63zp1ldp
        c9Yq1fetRFd2/JmZ9VhgMI3sDk/mei64BNs/xXN6rUybdLA+MYWmDoyU91J2atoS5J1IkF23060Xp
        VK9eDJS9lAS5nqNXMLG9pNLeCkkVBupafUCUaASCY6SF3dVctBAWFDfGfA1Omk/paBU4ZIxnFUaf/
        qbrXguAszBGXKTFUbZy0gp81o25wxPmgqtU95oo53yb4+wtHnAyRf85o7uAMQ1/oDdniM27cffGto
        J/Cks5PBL4dJrAWZ5xZwe7p0hjk55Af6Ff6mLFcpuJxO5kX53lVaClU9KdZP/dnmf2bBO5WFIK/jH
        y7fkIn4A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mY2qi-008F3t-S9; Wed, 06 Oct 2021 09:04:29 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 38A04300347;
        Wed,  6 Oct 2021 11:04:27 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 086B02136BA91; Wed,  6 Oct 2021 11:04:27 +0200 (CEST)
Date:   Wed, 6 Oct 2021 11:04:26 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, mingo@kernel.org, linux-kernel@vger.kernel.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: Re: [RFC][PATCH v2 09/11] context_tracking,livepatch: Dont disturb
 NOHZ_FULL
Message-ID: <YV1mmv5QbB/vf3/O@hirez.programming.kicks-ass.net>
References: <20210929151723.162004989@infradead.org>
 <20210929152429.067060646@infradead.org>
 <YV1aYaHEynjSAUuI@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV1aYaHEynjSAUuI@alley>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Oct 06, 2021 at 10:12:17AM +0200, Petr Mladek wrote:

> > @@ -180,8 +186,10 @@ void klp_update_patch_state(struct task_
> >  	 *    of func->transition, if klp_ftrace_handler() is called later on
> >  	 *    the same CPU.  See __klp_disable_patch().
> >  	 */
> > -	if (test_and_clear_tsk_thread_flag(task, TIF_PATCH_PENDING))
> > +	if (test_tsk_thread_flag(task, TIF_PATCH_PENDING)) {
> 
> This would require smp_rmb() here. It will make sure that we will
> read the right @klp_target_state when TIF_PATCH_PENDING is set.

Bah, yes.

> >  		task->patch_state = READ_ONCE(klp_target_state);
> 
> Note that smp_wmb() is not needed here because
> klp_complete_transition() calls klp_synchronize_transition()
> aka synchronize_rcu() before clearing klp_target_state.
> This is why the original code worked.
> 
> 
> > +		clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
> > +	}
> >  
> >  	preempt_enable_notrace();
> >  }
> > @@ -270,15 +278,30 @@ static int klp_check_and_switch_task(str
> >  {
> >  	int ret;
> >  
> > -	if (task_curr(task))
> > +	if (task_curr(task)) {
> > +		/*
> > +		 * This only succeeds when the task is in NOHZ_FULL user
> > +		 * mode, the true return value guarantees any kernel entry
> > +		 * will call klp_update_patch_state().
> > +		 *
> > +		 * XXX: ideally we'd simply return 0 here and leave
> > +		 * TIF_PATCH_PENDING alone, to be fixed up by
> > +		 * klp_update_patch_state(), except livepatching goes wobbly
> > +		 * with 'pending' TIF bits on.
> > +		 */
> > +		if (context_tracking_set_cpu_work(task_cpu(task), CT_WORK_KLP))
> > +			goto clear;
> 
> If I get it correctly, this will clear TIF_PATCH_PENDING immediately
> but task->patch_state = READ_ONCE(klp_target_state) will be
> done later by ct_exit_user_work().
> 
> This is a bit problematic:
> 
>   1. The global @klp_target_state is set to KLP_UNDEFINED when all
>      processes have TIF_PATCH_PENDING is cleared. This is actually
>      still fine because func->transition is cleared as well.
>      As a result, current->patch_state is ignored in klp_ftrace_handler.
> 
>   2. The real problem happens when another livepatch is enabled.
>      The global @klp_target_state is set to new value and
>      func->transition is set again. In this case, the delayed
>      ct_exit_user_work() might assign wrong value that might
>      really be used by klp_ftrace_handler().

Urgghh.. totally missed that.

> IMHO, the original solution from v1 was better. We only needed to

It was also terribly broken in other 'fun' ways. See below.

> be careful when updating task->patch_state and clearing
> TIF_PATCH_PENDING to avoid the race.
> 
> The following might work:
> 
> static int klp_check_and_switch_task(struct task_struct *task, void *arg)
> {
> 	int ret;
> 
> 	/*
> 	 * Stack is reliable only when the task is not running on any CPU,
> 	 * except for the task running this code.
> 	 */
> 	if (task_curr(task) && task != current) {
> 		/*
> 		 * This only succeeds when the task is in NOHZ_FULL user
> 		 * mode. Such a task might be migrated immediately. We
> 		 * only need to be careful to set task->patch_state before
> 		 * clearing TIF_PATCH_PENDING so that the task migrates
> 		 * itself when entring kernel in the meatime.
> 		 */
> 		if (is_ct_user(task)) {
> 			klp_update_patch_state(task);
> 			return 0;
> 		}
> 
> 		return -EBUSY;
> 	}
> 
> 	ret = klp_check_stack(task, arg);
> 	if (ret)
> 		return ret;
> 
> 	/*
> 	 * The task neither is running on any CPU and nor it can get
> 	 * running. As a result, the ordering is not important and
> 	 * barrier is not needed.
> 	 */
> 	task->patch_state = klp_target_state;
> 	clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
> 
> 	return 0;
> }
> 
> , where is_ct_user(task) would return true when task is running in
> CONTEXT_USER. If I get the context_tracking API correctly then
> it might be implemeted the following way:

That's not sufficient, you need to tag the remote task with a ct_work
item to also runs klp_update_patch_state(), otherwise the remote CPU can
enter kernel space between checking is_ct_user() and doing
klp_update_patch_state():

	CPU0				CPU1

					<user>

	if (is_ct_user()) // true
					<kernel-entry>
					  // run some kernel code
	  klp_update_patch_state()
	  *WHOOPSIE*


So it needs to be something like:


	CPU0				CPU1

					<user>

	if (context_tracking_set_cpu_work(task_cpu(), CT_WORK_KLP))

					<kernel-entry>
	  klp_update_patch_state	  klp_update_patch_state()


So that CPU0 and CPU1 race to complete klp_update_patch_state() *before*
any regular (!noinstr) code gets run.

Which then means it needs to look something like:

noinstr void klp_update_patch_state(struct task_struct *task)
{
	struct thread_info *ti = task_thread_info(task);

	preempt_disable_notrace();
	if (arch_test_bit(TIF_PATCH_PENDING, (unsigned long *)&ti->flags)) {
		/*
		 * Order loads of TIF_PATCH_PENDING vs klp_target_state.
		 * See klp_init_transition().
		 */
		smp_rmb();
		task->patch_state = __READ_ONCE(klp_target_state);
		/*
		 * Concurrent against self; must observe updated
		 * task->patch_state if !TIF_PATCH_PENDING.
		 */
		smp_mb__before_atomic();
		arch_clear_bit(TIF_PATCH_PENDING, (unsigned long *)&ti->flags);
	} else {
		/*
		 * Concurrent against self, see smp_mb__before_atomic()
		 * above.
		 */
		smp_rmb();
	}
	preempt_enable_notrace();
}
