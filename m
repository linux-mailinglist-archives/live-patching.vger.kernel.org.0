Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39A3423B81
	for <lists+live-patching@lfdr.de>; Wed,  6 Oct 2021 12:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237846AbhJFKb0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 6 Oct 2021 06:31:26 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:43732 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbhJFKbZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 6 Oct 2021 06:31:25 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D701A21D68;
        Wed,  6 Oct 2021 10:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633516172; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9KBKsL8zLff22l5Rpnoc/zRyiW+wR+4SxGgHqzHBEhg=;
        b=GU62xEwRr8e8KO+PTkPP8uWUS056DOO+XUlCKswkvfK43EwJFhRnurtBdXg1/sH3AcnUZG
        r/M/JSzMpYl3SA1D+i4qMvBbJnJnJthq4WuWmT6bZpprL3c0zbkNREU5yyimbtcXBi90j0
        HBhnY1z8zVOcLiWe8rpR4oYnRpzX8vc=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7AA69A3B83;
        Wed,  6 Oct 2021 10:29:32 +0000 (UTC)
Date:   Wed, 6 Oct 2021 12:29:32 +0200
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
Message-ID: <YV16jKrB5Azu/nD+@alley>
References: <20210929151723.162004989@infradead.org>
 <20210929152429.067060646@infradead.org>
 <YV1aYaHEynjSAUuI@alley>
 <YV1mmv5QbB/vf3/O@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV1mmv5QbB/vf3/O@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2021-10-06 11:04:26, Peter Zijlstra wrote:
> On Wed, Oct 06, 2021 at 10:12:17AM +0200, Petr Mladek wrote:
> > IMHO, the original solution from v1 was better. We only needed to
> 
> It was also terribly broken in other 'fun' ways. See below.
> 
> > be careful when updating task->patch_state and clearing
> > TIF_PATCH_PENDING to avoid the race.
> > 
> > The following might work:
> > 
> > static int klp_check_and_switch_task(struct task_struct *task, void *arg)
> > {
> > 	int ret;
> > 
> > 	/*
> > 	 * Stack is reliable only when the task is not running on any CPU,
> > 	 * except for the task running this code.
> > 	 */
> > 	if (task_curr(task) && task != current) {
> > 		/*
> > 		 * This only succeeds when the task is in NOHZ_FULL user
> > 		 * mode. Such a task might be migrated immediately. We
> > 		 * only need to be careful to set task->patch_state before
> > 		 * clearing TIF_PATCH_PENDING so that the task migrates
> > 		 * itself when entring kernel in the meatime.
> > 		 */
> > 		if (is_ct_user(task)) {
> > 			klp_update_patch_state(task);
> > 			return 0;
> > 		}
> > 
> > 		return -EBUSY;
> > 	}
> > 
> > 	ret = klp_check_stack(task, arg);
> > 	if (ret)
> > 		return ret;
> > 
> > 	/*
> > 	 * The task neither is running on any CPU and nor it can get
> > 	 * running. As a result, the ordering is not important and
> > 	 * barrier is not needed.
> > 	 */
> > 	task->patch_state = klp_target_state;
> > 	clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
> > 
> > 	return 0;
> > }
> > 
> > , where is_ct_user(task) would return true when task is running in
> > CONTEXT_USER. If I get the context_tracking API correctly then
> > it might be implemeted the following way:
> 
> That's not sufficient, you need to tag the remote task with a ct_work
> item to also runs klp_update_patch_state(), otherwise the remote CPU can
> enter kernel space between checking is_ct_user() and doing
> klp_update_patch_state():
> 
> 	CPU0				CPU1
> 
> 					<user>
> 
> 	if (is_ct_user()) // true
> 					<kernel-entry>
> 					  // run some kernel code
> 	  klp_update_patch_state()
> 	  *WHOOPSIE*
> 
> 
> So it needs to be something like:
> 
> 
> 	CPU0				CPU1
> 
> 					<user>
> 
> 	if (context_tracking_set_cpu_work(task_cpu(), CT_WORK_KLP))
> 
> 					<kernel-entry>
> 	  klp_update_patch_state	  klp_update_patch_state()
> 
> 
> So that CPU0 and CPU1 race to complete klp_update_patch_state() *before*
> any regular (!noinstr) code gets run.

Grr, you are right. I thought that we migrated the task when entering
kernel even before. But it seems that we do it only when leaving
the kernel in exit_to_user_mode_loop().


> Which then means it needs to look something like:
> 
> noinstr void klp_update_patch_state(struct task_struct *task)
> {
> 	struct thread_info *ti = task_thread_info(task);
> 
> 	preempt_disable_notrace();
> 	if (arch_test_bit(TIF_PATCH_PENDING, (unsigned long *)&ti->flags)) {
> 		/*
> 		 * Order loads of TIF_PATCH_PENDING vs klp_target_state.
> 		 * See klp_init_transition().
> 		 */
> 		smp_rmb();
> 		task->patch_state = __READ_ONCE(klp_target_state);
> 		/*
> 		 * Concurrent against self; must observe updated
> 		 * task->patch_state if !TIF_PATCH_PENDING.
> 		 */
> 		smp_mb__before_atomic();

IMHO, smp_wmb() should be enough. We are here only when this
CPU set task->patch_state right above. So that CPU running
this code should see the correct task->patch_state.

The read barrier is needed only when @task is entering kernel and
does not see TIF_PATCH_PENDING. It is handled by smp_rmb() in
the "else" branch below.

It is possible that both CPUs see TIF_PATCH_PENDING and both
set task->patch_state. But it should not cause any harm
because they set the same value. Unless something really
crazy happens with the internal CPU busses and caches.


> 		arch_clear_bit(TIF_PATCH_PENDING, (unsigned long *)&ti->flags);
> 	} else {
> 		/*
> 		 * Concurrent against self, see smp_mb__before_atomic()
> 		 * above.
> 		 */
> 		smp_rmb();

Yeah, this is the counter part against the above smp_wmb().

> 	}
> 	preempt_enable_notrace();
> }

Now, I am scared to increase my paranoia level and search for even more
possible races. I feel overwhelmed at the moment ;-)

Best Regards,
Petr
