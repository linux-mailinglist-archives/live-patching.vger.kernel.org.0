Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD7E423D13
	for <lists+live-patching@lfdr.de>; Wed,  6 Oct 2021 13:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238167AbhJFLpa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 6 Oct 2021 07:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238117AbhJFLpa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 6 Oct 2021 07:45:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D02C061749;
        Wed,  6 Oct 2021 04:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3+cjgHpVIJ1Jp74Tyj6Y7cKbt0XA1yGO6iHMekMDTPE=; b=s3gWLLKhPKzGlgIHtncCoEZ93G
        vK6y5ZLQguOAO/cV2YIBNxPJAGxqEKGl2OnKhOhCpDmjhsvZ4+kL0BpGUyo+HfS/82wbCs4gb9Lsk
        MXo8qXvvy4jWa0cPxlKo+t/kr/s0UDZuCeTHCbMRmB+4ax/x9joroXNQIhxQhCFDfBYrxCNiE/Oxw
        EJ3hXqyptQBlrO49pUUgDGB3f39VNcUBH89QERB1KbLJppW32ckmRx/X+tt3bErVoIg7V4Dtrp+nQ
        qV/f1LxZdMDiiUEArwWm5Hy/wCP+S4QESGTskFKUrK86h3uh7v6VMA1MridpO0ar/fTgfD8M6y/nA
        rWoUZK7A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mY5Is-000pri-FE; Wed, 06 Oct 2021 11:41:53 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 37F5E98623A; Wed,  6 Oct 2021 13:41:39 +0200 (CEST)
Date:   Wed, 6 Oct 2021 13:41:39 +0200
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
Message-ID: <20211006114139.GG174703@worktop.programming.kicks-ass.net>
References: <20210929151723.162004989@infradead.org>
 <20210929152429.067060646@infradead.org>
 <YV1aYaHEynjSAUuI@alley>
 <YV1mmv5QbB/vf3/O@hirez.programming.kicks-ass.net>
 <YV16jKrB5Azu/nD+@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV16jKrB5Azu/nD+@alley>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Oct 06, 2021 at 12:29:32PM +0200, Petr Mladek wrote:
> On Wed 2021-10-06 11:04:26, Peter Zijlstra wrote:

> > So it needs to be something like:
> > 
> > 
> > 	CPU0				CPU1
> > 
> > 					<user>
> > 
> > 	if (context_tracking_set_cpu_work(task_cpu(), CT_WORK_KLP))
> > 
> > 					<kernel-entry>
> > 	  klp_update_patch_state	  klp_update_patch_state()
> > 
> > 
> > So that CPU0 and CPU1 race to complete klp_update_patch_state() *before*
> > any regular (!noinstr) code gets run.
> 
> Grr, you are right. I thought that we migrated the task when entering
> kernel even before. But it seems that we do it only when leaving
> the kernel in exit_to_user_mode_loop().

Yep... :-)

> > Which then means it needs to look something like:
> > 
> > noinstr void klp_update_patch_state(struct task_struct *task)
> > {
> > 	struct thread_info *ti = task_thread_info(task);
> > 
> > 	preempt_disable_notrace();
> > 	if (arch_test_bit(TIF_PATCH_PENDING, (unsigned long *)&ti->flags)) {
> > 		/*
> > 		 * Order loads of TIF_PATCH_PENDING vs klp_target_state.
> > 		 * See klp_init_transition().
> > 		 */
> > 		smp_rmb();
> > 		task->patch_state = __READ_ONCE(klp_target_state);
> > 		/*
> > 		 * Concurrent against self; must observe updated
> > 		 * task->patch_state if !TIF_PATCH_PENDING.
> > 		 */
> > 		smp_mb__before_atomic();
> 
> IMHO, smp_wmb() should be enough. We are here only when this
> CPU set task->patch_state right above. So that CPU running
> this code should see the correct task->patch_state.

Yes, I think smp_wmb() and smp_mb__before_atomic() are NOPS for all the
same architectures, so that might indeed be a better choice.

> The read barrier is needed only when @task is entering kernel and
> does not see TIF_PATCH_PENDING. It is handled by smp_rmb() in
> the "else" branch below.
> 
> It is possible that both CPUs see TIF_PATCH_PENDING and both
> set task->patch_state. But it should not cause any harm
> because they set the same value. Unless something really
> crazy happens with the internal CPU busses and caches.

Right, not our problem :-) Lots would be broken beyond repair in that
case.

> > 		arch_clear_bit(TIF_PATCH_PENDING, (unsigned long *)&ti->flags);
> > 	} else {
> > 		/*
> > 		 * Concurrent against self, see smp_mb__before_atomic()
> > 		 * above.
> > 		 */
> > 		smp_rmb();
> 
> Yeah, this is the counter part against the above smp_wmb().
> 
> > 	}
> > 	preempt_enable_notrace();
> > }
> 
> Now, I am scared to increase my paranoia level and search for even more
> possible races. I feel overwhelmed at the moment ;-)

:-)

Anyway, I still need to figure out how to extract this context tracking
stuff from RCU and not make a giant mess of things, so until that
time....
