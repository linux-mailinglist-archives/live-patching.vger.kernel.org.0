Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44F969F604
	for <lists+live-patching@lfdr.de>; Wed, 22 Feb 2023 15:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjBVOAp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Feb 2023 09:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbjBVOAo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Feb 2023 09:00:44 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCFB38B5D;
        Wed, 22 Feb 2023 06:00:40 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 2E8671FF7D;
        Wed, 22 Feb 2023 14:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1677074439; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WSDQiRA2AYzsxlloYerB5tA2IBPaY4XYdKty9gtQYyw=;
        b=PGgsj8L18mYbSW5wamy0ofQk8SRjVRXXrHZaAyZRgzZYKqOc8AdqcPzAf6IPDlcxE3emoW
        8yOQntrSAwDIAWWWnVoIqoB6zkZSS0szZbOX9caAws0E7kktbtFq5KA9WTCwzCYWTFPgON
        2pVEafI++qGgdPSFfZlLW8ssQMsS1ro=
Received: from suse.cz (pmladek.tcp.ovpn2.prg.suse.de [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 6B2662C141;
        Wed, 22 Feb 2023 14:00:37 +0000 (UTC)
Date:   Wed, 22 Feb 2023 15:00:33 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <sforshee@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH v2 2/3] livepatch,sched: Add livepatch task switching to
 cond_resched()
Message-ID: <Y/YgARbqsyvzebAl@alley>
References: <cover.1676672328.git.jpoimboe@kernel.org>
 <9f09bff809fc026618108e8bbaac67ef2f8e6d3d.1676672328.git.jpoimboe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f09bff809fc026618108e8bbaac67ef2f8e6d3d.1676672328.git.jpoimboe@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2023-02-17 14:22:55, Josh Poimboeuf wrote:
> There have been reports [1][2] of live patches failing to complete
> within a reasonable amount of time due to CPU-bound kthreads.
> 
> Fix it by patching tasks in cond_resched().
> 
> There are four different flavors of cond_resched(), depending on the
> kernel configuration.  Hook into all of them.
> 
> A more elegant solution might be to use a preempt notifier.  However,
> non-ORC unwinders can't unwind a preempted task reliably.
> 
> [1] https://lore.kernel.org/lkml/20220507174628.2086373-1-song@kernel.org/
> [2] https://lkml.kernel.org/lkml/20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org
> 
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -588,14 +641,10 @@ void klp_reverse_transition(void)
>  		 klp_target_state == KLP_PATCHED ? "patching to unpatching" :
>  						   "unpatching to patching");
>  
> -	klp_transition_patch->enabled = !klp_transition_patch->enabled;
> -
> -	klp_target_state = !klp_target_state;
> -
>  	/*
>  	 * Clear all TIF_PATCH_PENDING flags to prevent races caused by
> -	 * klp_update_patch_state() running in parallel with
> -	 * klp_start_transition().
> +	 * klp_update_patch_state() or __klp_sched_try_switch() running in
> +	 * parallel with the reverse transition.
>  	 */
>  	read_lock(&tasklist_lock);
>  	for_each_process_thread(g, task)
> @@ -605,9 +654,16 @@ void klp_reverse_transition(void)
>  	for_each_possible_cpu(cpu)
>  		clear_tsk_thread_flag(idle_task(cpu), TIF_PATCH_PENDING);
>  
> -	/* Let any remaining calls to klp_update_patch_state() complete */
> +	/*
> +	 * Make sure all existing invocations of klp_update_patch_state() and
> +	 * __klp_sched_try_switch() see the cleared TIF_PATCH_PENDING before
> +	 * starting the reverse transition.
> +	 */
>  	klp_synchronize_transition();
>  
> +	/* All patching has stopped, now start the reverse transition. */
> +	klp_transition_patch->enabled = !klp_transition_patch->enabled;
> +	klp_target_state = !klp_target_state;

I have double checked the synchronization and we need here:

	/*
	 * Make sure klp_update_patch_state() and __klp_sched_try_switch()
	 * see the updated klp_target_state before TIF_PATCH_PENDING
	 * is set again in klp_start_transition().
	 */
	smp_wmb();

The same is achieved by smp_wmb() in klp_init_transition().

Note that the extra barrier was missing here because klp_target_state
was set before klp_synchronize_transition(). It was fine because
klp_update_patch_state() was called on locations where a transition
in any direction was always safe.

Just for record. We need to modify @klp_target_state after
klp_synchronize_transition() now. The value is used by
__klp_sched_try_switch() to decide when the transition
is safe. It defines what functions must not be on the stack.

I am sorry that I missed this when reviewing v1. I think that I needed
to see the new code with a fresh head.

>  	klp_start_transition();
>  }

I do not see any other problem. With the above barrier added,
feel free to use:

Reviewed-by: Petr Mladek <pmladek@suse.com>

It is for the livepatching part. I checked also the scheduler
code and it looked fine but I would not put my hand in the fire
for it.

Best Regards,
Petr
