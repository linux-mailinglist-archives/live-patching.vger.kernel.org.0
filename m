Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76066415F4E
	for <lists+live-patching@lfdr.de>; Thu, 23 Sep 2021 15:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241209AbhIWNQV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Sep 2021 09:16:21 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:44954 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241211AbhIWNQV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Sep 2021 09:16:21 -0400
Received: from relay1.suse.de (relay1.suse.de [149.44.160.133])
        by smtp-out2.suse.de (Postfix) with ESMTP id C1CFC1FFB0;
        Thu, 23 Sep 2021 13:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1632402888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N1FFFjqNtxvFumHoY1HQ7sDzxjdq1AfkS9o1k39AM/Q=;
        b=pZbh0RwXnp69/q47cYgywHtYNNFir4kHJ/mvQH68hramJR7aBMKTY8ntFCvwjBSVZvlkoS
        OetBEOW1y0aG2JTpetfTIlWgbRIHrfI+H0QHKaG0cenqE5PNeXJYAr2nqkY0BlZ+t8ibAb
        UnCs+Vsn0zFfPCR0OlyYQbXBoxVEhNo=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay1.suse.de (Postfix) with ESMTPS id 9AD8025D3C;
        Thu, 23 Sep 2021 13:14:48 +0000 (UTC)
Date:   Thu, 23 Sep 2021 15:14:48 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, mingo@kernel.org, linux-kernel@vger.kernel.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org
Subject: Re: [RFC][PATCH 7/7] livepatch,context_tracking: Avoid disturbing
 NOHZ_FULL tasks
Message-ID: <YUx9yNfgm4nnd23y@alley>
References: <20210922110506.703075504@infradead.org>
 <20210922110836.304335737@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922110836.304335737@infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2021-09-22 13:05:13, Peter Zijlstra wrote:
> When a task is stuck in NOHZ_FULL usermode, we can simply mark the
> livepatch state complete.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  kernel/livepatch/transition.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -270,13 +270,24 @@ static int klp_check_task(struct task_st
>  {
>  	int ret;
>  
> -	if (task_curr(task))
> +	if (task_curr(task)) {
> +		if (context_tracking_state_cpu(task_cpu(task)) == CONTEXT_USER) {
> +			/*
> +			 * If we observe the CPU being in USER context, they
> +			 * must issue an smp_mb() before doing much kernel
> +			 * space and as such will observe the patched state,
> +			 * mark it clean.
> +			 */
> +			goto complete;

IMHO, this is not safe:

CPU0				CPU1

klp_check_task(A)
  if (context_tracking_state_cpu(task_cpu(task)) == CONTEXT_USER)
     goto complete;

  clear_tsk_thread_flag(task, TIF_PATCH_PENDING);

				# task switching to kernel space
				klp_update_patch_state(A)
				       if (test_and_clear_tsk_thread_flag(task,	TIF_PATCH_PENDING))
				       //false

				# calling kernel code with old task->patch_state

	task->patch_state = klp_target_state;

BANG: CPU0 sets task->patch_state when task A is already running
	kernel code on CPU1.

> +		}
>  		return -EBUSY;
> +	}
>  
>  	ret = klp_check_stack(task, arg);
>  	if (ret)
>  		return ret;
>  
> +complete:
>  	clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
>  	task->patch_state = klp_target_state;

A solution might be to switch ordering and add a barrier here.

>  	return 0;


The code might look like:

static int klp_check_task(struct task_struct *task, void *arg)
{
	int ret;

	if (task_curr(task)) {
		if (context_tracking_state_cpu(task_cpu(task)) == CONTEXT_USER) {
			/*
			 * Task running in USER mode might get switched
			 * immediately. They are switched when entering
			 * kernel code anyway.
			 */
			goto complete;
		}
		return -EBUSY;
	}

	ret = klp_check_stack(task, arg);
	if (ret)
		return ret;

complete:
	WRITE_ONCE(task->patch_state, klp_target_state);
	/*
	 * We switch also tasks running in USER mode here. They must
	 * see the new state before clearing the pending flag.
	 * Otherwise, they might enter kernel mode without switching
	 * the state in klp_update_patch_state().
	 */
	smp_wmb();
	clear_tsk_thread_flag(task, TIF_PATCH_PENDING);

	return 0;
}

The only problem is that the corresponding read barrier is not clear.
It will make more sense if it is paired with some read barrier
in the scheduler after handling TIF flags.

But we should be on the safe side because klp_ftrace_handler() always
does read barrier before reading the state. Though, it is done
there from other reasons.

Best Regards,
Petr
