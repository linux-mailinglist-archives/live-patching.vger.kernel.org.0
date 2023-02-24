Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7ABE6A1F39
	for <lists+live-patching@lfdr.de>; Fri, 24 Feb 2023 17:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjBXQBr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 24 Feb 2023 11:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjBXQBi (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 24 Feb 2023 11:01:38 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEBB6EB19;
        Fri, 24 Feb 2023 08:01:33 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E01066092D;
        Fri, 24 Feb 2023 16:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1677254491; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tgTWfleAXKax/MjMcdtBmTWoYmYuDGvm13wqKadZJr8=;
        b=LxN5XqnVxI+Dj/TLfvKp8yMkcD5vQ48Il5MAWg9BmS37oQ4A0C5G586Rn1C5fYCcqAlty0
        1VwEG1v1XMrxewSeHv6sbHtw3S4FDHFSCiEuw+xMKFiu3Lsbk6/pPRpI+Sr9N4B00WIosR
        PvpRZtdEIRHsBR4ZellOPbm78xA0buA=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9193D2C141;
        Fri, 24 Feb 2023 16:01:28 +0000 (UTC)
Date:   Fri, 24 Feb 2023 17:01:22 +0100
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
Message-ID: <Y/jfUlPm7uCWvHPl@alley>
References: <cover.1676672328.git.jpoimboe@kernel.org>
 <9f09bff809fc026618108e8bbaac67ef2f8e6d3d.1676672328.git.jpoimboe@kernel.org>
 <Y/YgARbqsyvzebAl@alley>
 <20230224013402.hpq5ka4exetrdh4t@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224013402.hpq5ka4exetrdh4t@treble>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2023-02-23 17:34:02, Josh Poimboeuf wrote:
> On Wed, Feb 22, 2023 at 03:00:33PM +0100, Petr Mladek wrote:
> > > +	/* All patching has stopped, now start the reverse transition. */
> > > +	klp_transition_patch->enabled = !klp_transition_patch->enabled;
> > > +	klp_target_state = !klp_target_state;
> > 
> > I have double checked the synchronization and we need here:
> > 
> > 	/*
> > 	 * Make sure klp_update_patch_state() and __klp_sched_try_switch()
> > 	 * see the updated klp_target_state before TIF_PATCH_PENDING
> > 	 * is set again in klp_start_transition().
> > 	 */
> > 	smp_wmb();
> > 
> > The same is achieved by smp_wmb() in klp_init_transition().
> > 
> > Note that the extra barrier was missing here because klp_target_state
> > was set before klp_synchronize_transition(). It was fine because
> > klp_update_patch_state() was called on locations where a transition
> > in any direction was always safe.
> > 
> > Just for record. We need to modify @klp_target_state after
> > klp_synchronize_transition() now. The value is used by
> > __klp_sched_try_switch() to decide when the transition
> > is safe. It defines what functions must not be on the stack.
> 
> Yes, makes sense.  And we need a corresponding smp_rmb() in
> __klp_sched_try_switch() before the call to klp_try_switch_task(),
> right?

Yes. Great catch!

I feel shame that I missed this counter piece when I realized that
the write barrier was missing.

> Something like this on top?  Also updated a few more comments.
>
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index b9e006632124..218ef4a5d575 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -192,8 +192,8 @@ void klp_update_patch_state(struct task_struct *task)
>  	 * barrier (smp_rmb) for two cases:
>  	 *
>  	 * 1) Enforce the order of the TIF_PATCH_PENDING read and the
> -	 *    klp_target_state read.  The corresponding write barrier is in
> -	 *    klp_init_transition().
> +	 *    klp_target_state read.  The corresponding write barriers are in
> +	 *    klp_init_transition() and klp_reverse_transition().
>  	 *
>  	 * 2) Enforce the order of the TIF_PATCH_PENDING read and a future read
>  	 *    of func->transition, if klp_ftrace_handler() is called later on
> @@ -381,6 +381,14 @@ void __klp_sched_try_switch(void)
>  	if (unlikely(!klp_patch_pending(current)))
>  		goto out;
>  
> +	/*
> +	 * Enforce the order of the TIF_PATCH_PENDING read above and the
> +	 * klp_target_state read in klp_try_switch_task().  The corresponding
> +	 * write barriers are in klp_init_transition() and
> +	 * klp_reverse_transition().
> +	 */
> +	smp_rmb();

This barrier has basically the same purpose as the implicit read
barrier in klp_update_patch_state().

The comment in klp_update_patch_state() says that the read barrier
actually has two purposes. The 1st one is easy. It is the one
described above.

It took me quite some time to understand the 2nd purpose again.
The original comment was:

	 * 2) Enforce the order of the TIF_PATCH_PENDING read and a future read
	 *    of func->transition, if klp_ftrace_handler() is called later on
	 *    the same CPU.  See __klp_disable_patch().

I think that a better description would be:

	 * 2) Make sure that this CPU sees func->transition enabled when
	 *    it sees the TIF_PATCH_PENDING enabled. This is important when
	 *    the current task is transitioning itself and then calls
	 *    klp_ftrace_handler() later. It ensures that the ftrace handler
	 *    would check the state change that we did here.
	 *    The corresponding write barrier is in __klp_enable_patch()
	 *    and __klp_disable_patch().

Note that the previous comment wasn't correct. IMHO, the related write
barrier is needed in both __klp_enable_patch() and __klp_disable_patch().

> +
>  	klp_try_switch_task(current);
>  
>  out:
> @@ -604,8 +612,9 @@ void klp_init_transition(struct klp_patch *patch, int state)
>  	 * see a func in transition with a task->patch_state of KLP_UNDEFINED.
>  	 *
>  	 * Also enforce the order of the klp_target_state write and future
> -	 * TIF_PATCH_PENDING writes to ensure klp_update_patch_state() doesn't
> -	 * set a task->patch_state to KLP_UNDEFINED.
> +	 * TIF_PATCH_PENDING writes to ensure klp_update_patch_state() and
> +	 * __klp_sched_try_switch() don't set a task->patch_state to
> +	 * KLP_UNDEFINED.
>  	 */
>  	smp_wmb();
>  
> @@ -661,9 +670,19 @@ void klp_reverse_transition(void)
>  	 */
>  	klp_synchronize_transition();
>  
> -	/* All patching has stopped, now start the reverse transition. */
> +	/* All patching has stopped, now start the reverse transition: */
> +

Is the extra empty line intended?

>  	klp_transition_patch->enabled = !klp_transition_patch->enabled;
>  	klp_target_state = !klp_target_state;
> +
> +	/*
> +	 * Enforce the order of the klp_target_state write and the
> +	 * TIF_PATCH_PENDING writes in klp_start_transition() to ensure
> +	 * klp_update_patch_state() and __klp_sched_try_switch() don't set
> +	 * task->patch_state to the wrong value.
> +	 */
> +	smp_wmb();
> +
>  	klp_start_transition();
>  }

This made me to revisit all the barriers in the livepatch code.
The good thing is that it seems that all the barriers are correct,
including the new ones proposed in this patchset.

But some comments are a bit misleading. I would like to update
them a bit. I have started working on it but it goes slowly.
I often get lost...

I am not sure about the ordering. I do not want to block this patchset
by the clean up of the comments. The currently proposed ones are
good enough. Feel free to send v3.

Or would you prefer to wait for my clean up of the comments?

Best Regards,
Petr
