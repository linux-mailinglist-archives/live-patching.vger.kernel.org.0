Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4913BF825
	for <lists+live-patching@lfdr.de>; Thu,  8 Jul 2021 12:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhGHKPD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 8 Jul 2021 06:15:03 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:43140 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbhGHKPD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 8 Jul 2021 06:15:03 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7DF342235F;
        Thu,  8 Jul 2021 10:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625739140; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hYO8eT5RyGu5yME6TLfsn3cvME04291AisNrXHN42ug=;
        b=FMqIVL5DsqDK/v7wUKeoFLCQta7Y8JBC5wBM0zoHpMn9spJsdGBgYE+TcXQIC3E8sxTR23
        Fb7JYnB+8s91edikLw1VgqjLg8zLKtLWom1edHedxiUdafxFxLNTh1rf/hdFuWv0duzCPh
        IZ5RVsYP/gYJLwRDuYwVC1S2IESEl5o=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 62A64A3B88;
        Thu,  8 Jul 2021 10:12:20 +0000 (UTC)
Date:   Thu, 8 Jul 2021 12:12:20 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Vasily Gorbik <gor@linux.ibm.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] livepatch: Kick idle cpu's tasks to perform
 transition
Message-ID: <YObPhPkzRSqnzgK3@alley>
References: <patch.git-b76842ceb035.your-ad-here.call-01625661932-ext-1304@work.hours>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patch.git-b76842ceb035.your-ad-here.call-01625661932-ext-1304@work.hours>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2021-07-07 14:49:38, Vasily Gorbik wrote:
> On an idle system with large amount of cpus it might happen that
> klp_update_patch_state() is not reached in do_idle() for a long periods
> of time. With debug messages enabled log is filled with:
> [  499.442643] livepatch: klp_try_switch_task: swapper/63:0 is running

I see. I guess that the problem is only when CONFIG_NO_HZ is enabled.
Do I get it correctly, please?

> without any signs of progress. Ending up with "failed to complete
> transition".
> 
> On s390 LPAR with 128 cpus not a single transition is able to complete
> and livepatch kselftests fail.
> 
> To deal with that, make sure we break out of do_idle() inner loop to
> reach klp_update_patch_state() by marking idle tasks as NEED_RESCHED
> as well as kick cpus out of idle state.
>
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> ---
>  kernel/livepatch/transition.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index 3a4beb9395c4..793eba46e970 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -415,8 +415,11 @@ void klp_try_complete_transition(void)
>  	for_each_possible_cpu(cpu) {
>  		task = idle_task(cpu);
>  		if (cpu_online(cpu)) {
> -			if (!klp_try_switch_task(task))
> +			if (!klp_try_switch_task(task)) {
>  				complete = false;
> +				set_tsk_need_resched(task);
> +				kick_process(task);

First, we should kick the idle threads in klp_send_signals().
It already solves similar problem when normal threads and kthreads
stay in the incorruptible sleep for too long.

Second, the way looks a bit hacky to me. need_resched() depends on
the currect implementation of the idle loop. kick_process() has
a completely different purpose and does checks that do not fit well
this use-case.

I wonder if wake_up_nohz_cpu() would fit better here. Please, add
scheduler people into CC, namely:

    Ingo Molnar <mingo@redhat.com>
    Peter Zijlstra <peterz@infradead.org>

and NOHZ guys:

    Frederic Weisbecker <fweisbec@gmail.com>
    Thomas Gleixner <tglx@linutronix.de>


Best Regards,
Petr
