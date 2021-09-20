Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2311E4110EE
	for <lists+live-patching@lfdr.de>; Mon, 20 Sep 2021 10:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235727AbhITI30 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 20 Sep 2021 04:29:26 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:53922 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbhITI3Y (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 20 Sep 2021 04:29:24 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A308220041;
        Mon, 20 Sep 2021 08:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1632126477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z+DyQBE+Aw6OsR4ekUpN555NEMRZAU9u2xlWGbDULjw=;
        b=NG+to2HtxbQTOVZ92SXq71NNm3suX62MSSCS0DG8Dzkt2SOl0aaJWr7OFRj2xRRUWCLbRx
        qu2yQLCH3VZ8clBv4ql6+se/US9y9NQ3xKkE5B/xk0RLVYX4USkLMuy4fww6ZHUWKdcVxO
        BhNcXBbSJUgymBT6UNyb2loDiU+5cUA=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7F7CBA3B87;
        Mon, 20 Sep 2021 08:27:57 +0000 (UTC)
Date:   Mon, 20 Sep 2021 10:27:57 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Vasily Gorbik <gor@linux.ibm.com>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] livepatch: Fix idle cpu's tasks transition
Message-ID: <YUhGDXzg2VhycKlR@alley>
References: <patch.git-94c1daf66a9c.your-ad-here.call-01631714463-ext-3692@work.hours>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patch.git-94c1daf66a9c.your-ad-here.call-01631714463-ext-3692@work.hours>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2021-09-15 16:18:01, Vasily Gorbik wrote:
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
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Acked-by: Miroslav Benes <mbenes@suse.cz>
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> ---
> Ingo/Peter, as Josh mentioned, could you please ack if you are ok with
> livepatch calling this private scheduler interface?

Ingo, Peter, Josh, could anyone please ack that it is acceptable
to call resched_curr(rq) from the livepatch code?

Or is there a better way to make an idle task go through
the main cycle?

Best Regards,
Petr

> 
> Changes since v1:
> - added comments suggested by Petr
>   lkml.kernel.org/r/patch.git-a4aad6b1540d.your-ad-here.call-01631177886-ext-3083@work.hours
> 
> Previous discussion and RFC PATCH:
>   lkml.kernel.org/r/patch.git-b76842ceb035.your-ad-here.call-01625661932-ext-1304@work.hours
> 
>  kernel/livepatch/transition.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index 291b857a6e20..2846a879f2dc 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -278,6 +278,8 @@ static int klp_check_stack(struct task_struct *task, char *err_buf)
>   * Try to safely switch a task to the target patch state.  If it's currently
>   * running, or it's sleeping on a to-be-patched or to-be-unpatched function, or
>   * if the stack is unreliable, return false.
> + *
> + * Idle tasks are switched in the main loop when running.
>   */
>  static bool klp_try_switch_task(struct task_struct *task)
>  {
> @@ -308,6 +310,12 @@ static bool klp_try_switch_task(struct task_struct *task)
>  	rq = task_rq_lock(task, &flags);
>  
>  	if (task_running(rq, task) && task != current) {
> +		/*
> +		 * Idle task might stay running for a long time. Switch them
> +		 * in the main loop.
> +		 */
> +		if (is_idle_task(task))
> +			resched_curr(rq);
>  		snprintf(err_buf, STACK_ERR_BUF_SIZE,
>  			 "%s: %s:%d is running\n", __func__, task->comm,
>  			 task->pid);
> -- 
> 2.25.4
