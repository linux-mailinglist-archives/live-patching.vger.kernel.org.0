Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF156422571
	for <lists+live-patching@lfdr.de>; Tue,  5 Oct 2021 13:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhJELmU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 5 Oct 2021 07:42:20 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:44790 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234394AbhJELmU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 5 Oct 2021 07:42:20 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id BAF361FE48;
        Tue,  5 Oct 2021 11:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633434028; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YrWYcUlP1sQfT+/jOsfeMnCp6UQhI/Qs3tOchoPDyGI=;
        b=coLosvQ3jMU9psxOrTmI23xgUqlrufwY+sMKlHWAEa81GoretKibg67WInnSFKmszW2iq+
        pgq3O6yiP+QWqUWgc7wDPxGVtk9vRJzFeB37Rv7YmlSKhR3199Pt+4/4W0l7jfUQ9BHz7V
        y/BjYT1cvWn8kPLscp4WSORnFiE/ujE=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 26B07A3B8E;
        Tue,  5 Oct 2021 11:40:28 +0000 (UTC)
Date:   Tue, 5 Oct 2021 13:40:24 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, mingo@kernel.org, linux-kernel@vger.kernel.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: Re: [PATCH v2 03/11] sched,livepatch: Use task_call_func()
Message-ID: <YVw5qO0rLA/GduFm@alley>
References: <20210929151723.162004989@infradead.org>
 <20210929152428.709906138@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929152428.709906138@infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2021-09-29 17:17:26, Peter Zijlstra wrote:
> Instead of frobbing around with scheduler internals, use the shiny new
> task_call_func() interface.
> 
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -274,6 +266,22 @@ static int klp_check_stack(struct task_s
>  	return 0;
>  }
>  
> +static int klp_check_and_switch_task(struct task_struct *task, void *arg)
> +{
> +	int ret;
> +
> +	if (task_curr(task))

This must be

	if (task_curr(task) && task != current)

, otherwise the task is not able to migrate itself. The condition was
lost when reshuffling the original code, see below.

JFYI, I have missed it during review. I am actually surprised that the
process could check its own stack reliably. But it seems to work.

I found the problem when "busy target module" selftest failed.
It was not able to livepatch the workqueue worker that was
proceeding klp_transition_work_fn().


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
> @@ -305,36 +308,31 @@ static bool klp_try_switch_task(struct t
>  	 * functions.  If all goes well, switch the task to the target patch
>  	 * state.
>  	 */
> -	rq = task_rq_lock(task, &flags);
> +	ret = task_call_func(task, klp_check_and_switch_task, &old_name);

It looks correct. JFYI, this is why:

The logic seems to be exactly the same, except for the one fallout
mentioned above. So the only problem might be races.

The only important thing is that the task must not be running on any CPU
when klp_check_stack(task, arg) is called. By other word, the stack
must stay the same when being checked.

The original code prevented races by taking task_rq_lock().
And task_call_func() is slightly more relaxed but it looks safe enough:

  + it still takes rq lock when the task is in runnable state.
  + it always takes p->pi_lock that prevents moving the task
    into runnable state by try_to_wake_up().


> +	switch (ret) {
> +	case 0:		/* success */
> +		break;
>  
> -	if (task_running(rq, task) && task != current) {

This is the original code that checked (task != current).

> -		snprintf(err_buf, STACK_ERR_BUF_SIZE,
> -			 "%s: %s:%d is running\n", __func__, task->comm,
> -			 task->pid);
> -		goto done;

With the added (task != current) check:

Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
