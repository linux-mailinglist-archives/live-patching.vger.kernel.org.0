Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC583F9942
	for <lists+live-patching@lfdr.de>; Fri, 27 Aug 2021 14:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbhH0Mz3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 27 Aug 2021 08:55:29 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:34670 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbhH0Mz3 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 27 Aug 2021 08:55:29 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 9BBB42022C;
        Fri, 27 Aug 2021 12:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630068879; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PmIoYEQGodRJmMWo7Y06lgBn7jiODJwF67Pn0cQCnrg=;
        b=dcHFc6MmXLODLgyqfIENf0jVMpsJgcM2cBEx9UBmJueTL+hicd+b7WWMj/zMXuGgyy6Hyy
        L67YJXPMUmMZj0LUMc2hWBF7xAOPS8xvA/BDDHYqJ/CtGFgQqosMqIwmm+rt06tCTzG7Iw
        LJVfrmtjLKSpLvU6SaCvXwF98IaJ+NU=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 809B7A3B95;
        Fri, 27 Aug 2021 12:54:39 +0000 (UTC)
Date:   Fri, 27 Aug 2021 14:54:39 +0200
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
Message-ID: <YSjgj+ZzOutFxevl@alley>
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
> 
> without any signs of progress. Ending up with "failed to complete
> transition".
> 
> On s390 LPAR with 128 cpus not a single transition is able to complete
> and livepatch kselftests fail.
> 
> To deal with that, make sure we break out of do_idle() inner loop to
> reach klp_update_patch_state() by marking idle tasks as NEED_RESCHED
> as well as kick cpus out of idle state.

I see.

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

Is this really needed?

> +				kick_process(task);

This would probably do the job. Well, I wonder if the following is
a bit cleaner.

		wake_up_if_idle(cpu);


Also, please do this in klp_send_signals(). We kick there all other
tasks that block the transition for too long.

Best Regards,
Petr
