Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5AB44068F5
	for <lists+live-patching@lfdr.de>; Fri, 10 Sep 2021 11:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbhIJJTF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 10 Sep 2021 05:19:05 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:39382 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbhIJJTD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 10 Sep 2021 05:19:03 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 0EDF62004E;
        Fri, 10 Sep 2021 09:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631265472; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=moHXYj60rmUxw69TqVB2I1EUdoaGUyAX40Cx2K50WEg=;
        b=DSoJfhyDOrfPRQPgAYdin7CPWS3zQcUAfCeDyzdTG5WEr+vz+E5JEdKralyWWuHysshepo
        WPWuT6A5m7cz+4o4CHlIJu0kApzMApvR2Z9BsifaRmXBQLLmn9Z+PzgUvY78+y8AJKUffP
        BmCxzu9zKuD6vAU/ixOpsDD/25JIyRw=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D7E78A3B99;
        Fri, 10 Sep 2021 09:17:51 +0000 (UTC)
Date:   Fri, 10 Sep 2021 11:17:51 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Vasily Gorbik <gor@linux.ibm.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: Fix idle cpu's tasks transition
Message-ID: <YTsiv1xtiLT37iQR@alley>
References: <patch.git-a4aad6b1540d.your-ad-here.call-01631177886-ext-3083@work.hours>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patch.git-a4aad6b1540d.your-ad-here.call-01631177886-ext-3083@work.hours>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2021-09-09 11:16:01, Vasily Gorbik wrote:
> On an idle system with large amount of cpus it might happen that
> klp_update_patch_state() is not reached in do_idle() for a long periods
> of time. With debug messages enabled log is filled with:
> [  499.442643] livepatch: klp_try_switch_task: swapper/63:0 is running
> 
> without any signs of progress. Ending up with "failed to complete
> transition".
> 
> On s390 LPAR with 128 cpus not a single transition is able to complete
> and livepatch kselftests fail. Tests on idling x86 kvm instance with 128
> cpus demonstrate similar symptoms with and without CONFIG_NO_HZ.
> 
> To deal with that, since runqueue is already locked in
> klp_try_switch_task() identify idling cpus and trigger rescheduling
> potentially waking them up and making sure idle tasks break out of
> do_idle() inner loop and reach klp_update_patch_state(). This helps to
> speed up transition time while avoiding unnecessary extra system load.
> 
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> ---
> Previous discussion and RFC PATCH:
> lkml.kernel.org/r/patch.git-b76842ceb035.your-ad-here.call-01625661932-ext-1304@work.hours
> 
>  kernel/livepatch/transition.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index 3a4beb9395c4..c5832b2dd081 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -308,6 +308,8 @@ static bool klp_try_switch_task(struct task_struct *task)

Please, update also the comment above klp_try_switch_task(). I would
write something like:

/*
 * Try to safely switch a task to the target patch state.  If it's currently
 * running, or it's sleeping on a to-be-patched or to-be-unpatched function, or
 * if the stack is unreliable, return false.
 *
 * Idle tasks are switched in the main loop when running.
 */

>  	rq = task_rq_lock(task, &flags);
>  
>  	if (task_running(rq, task) && task != current) {

This would deserve a comment, for example:

		/*
		 * Idle task might stay running for a long time. Switch them
		 * in the main loop.
		 */

> +		if (is_idle_task(task))
> +			resched_curr(rq);
>  		snprintf(err_buf, STACK_ERR_BUF_SIZE,
>  			 "%s: %s:%d is running\n", __func__, task->comm,
>  			 task->pid);

Otherwise, it looks good to me. With the two comments:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
