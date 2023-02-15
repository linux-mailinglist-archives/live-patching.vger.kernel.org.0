Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F80697D68
	for <lists+live-patching@lfdr.de>; Wed, 15 Feb 2023 14:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjBONbI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Feb 2023 08:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBONbH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Feb 2023 08:31:07 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F1B5BAC;
        Wed, 15 Feb 2023 05:30:42 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1689D20237;
        Wed, 15 Feb 2023 13:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1676467841; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z4o/RZL4W/1EfFic+1I2XQt1s3U2azieD+gXW2jpD8s=;
        b=CjOoCbbr2yTFTHsa7xC3DGL9liISXB6NpajRjmzVre2LHkf4eiGcKr69LVaJxK2Jqu8eww
        5bQp4Flq0cWthcgKDgbQcFWUutFHdsYFDD65SyZ4lp5teT32LNW2/aNnvLDvtsBREVTIJ/
        xoOMXTuU/TiQd8IZCUp2Mbs5Ujlb9Cg=
Received: from suse.cz (pmladek.tcp.ovpn2.prg.suse.de [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 754FC2C141;
        Wed, 15 Feb 2023 13:30:40 +0000 (UTC)
Date:   Wed, 15 Feb 2023 14:30:36 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <sforshee@digitalocean.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/3] livepatch,sched: Add livepatch task switching to
 cond_resched()
Message-ID: <Y+zefMw6wqaXHZSz@alley>
References: <cover.1675969869.git.jpoimboe@kernel.org>
 <58cd637f7557e829142a2eb255daa91fa57e6321.1675969869.git.jpoimboe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58cd637f7557e829142a2eb255daa91fa57e6321.1675969869.git.jpoimboe@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2023-02-09 11:17:48, Josh Poimboeuf wrote:
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
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2085,20 +2090,25 @@ static __always_inline int _cond_resched(void)
>  	return dynamic_cond_resched();
>  }
>  
> -#else
> +#else /* !CONFIG_PREEMPTION */
>  
>  static inline int _cond_resched(void)
>  {
> +	klp_sched_try_switch();
>  	return __cond_resched();

My only concern is if it might cause any performance problems.

On one hand, cond_resched() is used in code paths that are slow
on its own. Also it will do nothing most of the time.

On the other hand, cond_resched() is typically used in cycles.
One cycle might be fast. The code might be slow because there
are too many cycles. Repeating the same failing test might
prolong the time significantly.

An idea is to try the switch only when it was not done during
a real schedule. Something like:

static inline int _cond_resched(void)
{
	int scheduled;

	scheduled = __cond_resched();
	if (scheduled)
		klp_sched_try_switch();

	return scheduled();
}

But it would make it less reliable/predictable. Also it won't work
in configurations when cond_resched() is always a nop.

I am probably too careful. We might keep it simple until any real
life problems are reported.

> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -76,6 +96,8 @@ static void klp_complete_transition(void)
>  		 klp_transition_patch->mod->name,
>  		 klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
>  
> +	klp_cond_resched_disable();
> +

Nit: Strictly speaking, this is not needed when klp_complete_transition()
     is called from klp_cancel_transition(). In this case,
     klp_cond_resched_enable() was not called. So it might be moved into
     klp_try_complete_transition().


More important thing, thinking loudly:

We need to make sure that no task is in the middle
klp_cond_resched_disable() when we modify anything that is used there.

We seem to be on the safe side in klp_complete_transition(). We are
here only when all tasks have TIF_PATCH_PENDING cleared. In this case,
__klp_sched_try_switch() just returns. Also it calls
klp_synchronize_transition() so that all tasks finish the critical part
in __klp_sched_try_switch() before any new transition starts.

But it is not the case in klp_reverse_transition(). It modifies
klp_target_state() when __klp_sched_try_switch might be in the middle
of klp_check_stack() and it might give wrong result.

klp_reverse_transition() already solves similar race with
klp_update_patch_state() by clearing all TIF_PATCH_PENDING flags
and calling klp_synchronize_transition(). We just need to do
it earlier. Something like:

--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -642,14 +642,11 @@ void klp_reverse_transition(void)
 		 klp_target_state == KLP_PATCHED ? "patching to unpatching" :
 						   "unpatching to patching");
 
-	klp_transition_patch->enabled = !klp_transition_patch->enabled;
-
-	klp_target_state = !klp_target_state;
 
 	/*
 	 * Clear all TIF_PATCH_PENDING flags to prevent races caused by
-	 * klp_update_patch_state() running in parallel with
-	 * klp_start_transition().
+	 * klp_update_patch_state() and __klp_sched_try_switch()
+	 * running in parallel.
 	 */
 	read_lock(&tasklist_lock);
 	for_each_process_thread(g, task)
@@ -659,9 +656,16 @@ void klp_reverse_transition(void)
 	for_each_possible_cpu(cpu)
 		clear_tsk_thread_flag(idle_task(cpu), TIF_PATCH_PENDING);
 
-	/* Let any remaining calls to klp_update_patch_state() complete */
+	/*
+	 * Make sure that both klp_update_patch_state() and
+	 * __klp_sched_try_switch() see the TIF_PATCH_PENDING cleared.
+	 */
 	klp_synchronize_transition();
 
+	klp_transition_patch->enabled = !klp_transition_patch->enabled;
+
+	klp_target_state = !klp_target_state;
+
 	klp_start_transition();
 }
 


>  	if (klp_transition_patch->replace && klp_target_state == KLP_PATCHED) {
>  		klp_unpatch_replaced_patches(klp_transition_patch);
>  		klp_discard_nops(klp_transition_patch);


Otherwise, the patch looks fine. I looked at it primary from
the livepatching code side.

Best Regards,
Petr
