Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8177415DD3
	for <lists+live-patching@lfdr.de>; Thu, 23 Sep 2021 14:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240762AbhIWMGh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Sep 2021 08:06:37 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:60798 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240619AbhIWMGg (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Sep 2021 08:06:36 -0400
Received: from relay1.suse.de (relay1.suse.de [149.44.160.133])
        by smtp-out2.suse.de (Postfix) with ESMTP id 3D2CB20285;
        Thu, 23 Sep 2021 12:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1632398704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jRTTr3tT3mc6B1FXnLLhRSQsAfVrVVBvEwXwyAD58no=;
        b=gt39SOXv/CzNYroOu5Z5wgAtDkaJrV4PMQYJqkGxLuQNVQSHfmwwMAZaVy97rFhMznhJ3l
        zUuCmunFykXTd6mb4tVD+sZIVRjZiEgNj99K0r2lU/aJ9PIfWdPIb8sRM7a7XGXHPep5PW
        C/rACECHFy2qD15Rnve0/dzPV7dASxo=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay1.suse.de (Postfix) with ESMTPS id 0C8BD25D3C;
        Thu, 23 Sep 2021 12:05:04 +0000 (UTC)
Date:   Thu, 23 Sep 2021 14:05:00 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, mingo@kernel.org, linux-kernel@vger.kernel.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org
Subject: Re: [RFC][PATCH 3/7] sched,livepatch: Use task_try_func()
Message-ID: <YUxtbCthpr+l9XM0@alley>
References: <20210922110506.703075504@infradead.org>
 <20210922110836.065940560@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922110836.065940560@infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2021-09-22 13:05:09, Peter Zijlstra wrote:
> Instead of frobbing around with scheduler internals, use the shiny new
> task_try_func() interface.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  kernel/livepatch/transition.c |   84 ++++++++++++++++++------------------------
>  1 file changed, 37 insertions(+), 47 deletions(-)
> 
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -274,6 +266,22 @@ static int klp_check_stack(struct task_s
>  	return 0;
>  }
>  
> +static int klp_check_task(struct task_struct *task, void *arg)

Please, call this klp_check_and_switch_task() to make it clear
that it actually does the switch.

> +{
> +	int ret;
> +
> +	if (task_curr(task))
> +		return -EBUSY;
> +
> +	ret = klp_check_stack(task, arg);
> +	if (ret)
> +		return ret;
> +
> +	clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
> +	task->patch_state = klp_target_state;
> +	return 0;
> +}
> +
>  /*
>   * Try to safely switch a task to the target patch state.  If it's currently
>   * running, or it's sleeping on a to-be-patched or to-be-unpatched function, or
> @@ -305,36 +308,23 @@ static bool klp_try_switch_task(struct t
>  	 * functions.  If all goes well, switch the task to the target patch
>  	 * state.
>  	 */
> -	rq = task_rq_lock(task, &flags);
> -
> -	if (task_running(rq, task) && task != current) {
> -		snprintf(err_buf, STACK_ERR_BUF_SIZE,
> -			 "%s: %s:%d is running\n", __func__, task->comm,
> -			 task->pid);
> -		goto done;
> +	ret = task_try_func(task, klp_check_task, &old_name);
> +	switch (ret) {
> +	case -EBUSY:
> +		pr_debug("%s: %s:%d is running\n",
> +			 __func__, task->comm, task->pid);
> +		break;
> +	case -EINVAL:
> +		pr_debug("%s: %s:%d has an unreliable stack\n",
> +			 __func__, task->comm, task->pid);
> +		break;
> +	case -EADDRINUSE:
> +		pr_debug("%s: %s:%d is sleeping on function %s\n",
> +			 __func__, task->comm, task->pid, old_name);
> +		break;

I would prefer to be on the safe side and catch error codes that might
eventually appear in the future.

	case 0:
		/* success */
		break;
	default:
		pr_debug("%s: Unknown error code (%d) when trying to switch %s:%d\n",
			 __func__, ret, task->comm, task->pid);

>  	}
>  
> -	ret = klp_check_stack(task, err_buf);
> -	if (ret)
> -		goto done;
> -
> -	success = true;
> -
> -	clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
> -	task->patch_state = klp_target_state;
> -
> -done:
> -	task_rq_unlock(rq, task, &flags);
> -
> -	/*
> -	 * Due to console deadlock issues, pr_debug() can't be used while
> -	 * holding the task rq lock.  Instead we have to use a temporary buffer
> -	 * and print the debug message after releasing the lock.
> -	 */
> -	if (err_buf[0] != '\0')
> -		pr_debug("%s", err_buf);
> -
> -	return success;
> +	return !ret;
>  }

Otherwise, it is great improvement!

Best Regards,
Petr
