Return-Path: <live-patching+bounces-1244-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08C56A484E5
	for <lists+live-patching@lfdr.de>; Thu, 27 Feb 2025 17:27:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A7CC3AD19E
	for <lists+live-patching@lfdr.de>; Thu, 27 Feb 2025 16:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC1991B040D;
	Thu, 27 Feb 2025 16:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gx9PcnI3"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AB11AF0C7
	for <live-patching@vger.kernel.org>; Thu, 27 Feb 2025 16:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740673381; cv=none; b=QF7rjLe3o8qHUy841XSSFxUrac0+pwus1Vdc/4cs2lqqOi8N3n4WpHAtxclcraFedTvbpNrZLhSavsRWQy6OIvPn3zhP4hPs4WdLdleTN/HL8XJrQHN+VaJhAWFB16KA0ecuuuiDQcF6XVvBzOfO4cgrAqzy3C9o8sIoUSYngVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740673381; c=relaxed/simple;
	bh=AcPJLUGk2dcHlvwzu4YVkp0mw2qYpkb+Lf73+ctq3/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YOVt2ab5zIj7Zr5BV6sGudOW4rug0Ie82pZgBXNCgqPw4scAoIZ2ihrLBGlsPMrUbCSOWkN24GmS8KRtTFWXUFHZLJHSRF2QPyUz4j62/4RTb6Q+RG+1O77K8L1emJSAFfydOTZHlwmVfRu+SU/wl2Za3Iknpn95XljNWKCw6Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gx9PcnI3; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4394036c0efso7972295e9.2
        for <live-patching@vger.kernel.org>; Thu, 27 Feb 2025 08:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1740673378; x=1741278178; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cmi2Uie+nmj2G4n8XOMI78dcty56DPKIvCdsqDQf9ds=;
        b=gx9PcnI3qhY7gBlyuZhWsjKdO26l5gm6JEWGbRWlSl77jHc0/Vl6qRDGlm168L9Jq9
         bpx/WWdzNzlwMu2oRcqsJI86os7aOw+qt+J2evOtqU/VK2vMcxOyGa1e4ZXzVPFiyx5K
         eth8bkFTioRDt1vtigCQMmQuXQo7hqtrXMq+iGU+c2eQreTAOxLKld05buJIy2kj9Pgd
         K0HiF8tw4JdjQ+NkR6dIBOg0W4vYMW109SVHQZpDG9nEwV0LJpsKjLlnJEaDsYYhrtgh
         BrpptGJ6r1oABfbIccaJbSHmfhPzZgqtq7fyAuH/G4yxz3wumxiiualHJ0WlVSOXr4C1
         PFSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740673378; x=1741278178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cmi2Uie+nmj2G4n8XOMI78dcty56DPKIvCdsqDQf9ds=;
        b=lsaFJGmh76QNCHt3PQ0GQLKnWsChXX2qyGOBZrgYIb1TxI1LMgLjf1eHBqlacQYJ5F
         2zXFlx/+LGYetKr40XA21yMFnnCynvJddHR3yPThPA5RnCIIa8xQrWf6Z55ratY26FYt
         EUvPPgajPTU59qVWzOq0yIBwifumPfjOw+qKvAezpfhiLyvmNwPaz5GlOEeloiOS8ukK
         29DWxgSjfBE5UCH/HWShsuCSG25pKBk9Ek6RjJS9qz31fbJ+3MQveSlLoQj6n1gMchmW
         PxibG8dHxLsPH3y1rRSTQq54NGOka+K542QwpMP+Dob0moC3Cq7Zbo0OolVP7B27Rb+b
         osgQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrW0u5sVAn5gOOUIaFvZQj/6JucmXCjEEieCidBWpV+cipf+qx4//UqLo8uw4tVIFITf2GZBE3PcvWQJ0k@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp6DVThdL/jW+k2APidlFNq4D/Zt/pu1gYc21N3IwS6HaKlRMc
	joe9kppzbfz2uEKy/9ph3Y6OoxPb6Cr83N4WhQ/52WgjNuf0bneRb0Fi1myP5Y8=
X-Gm-Gg: ASbGnctFJ1tOHciHvLJuCwVm3/keJgpOXAWjJy0tkSFeJsU7t3iGxDEX0KHPzzBqw3u
	Pg9riAomkibOmF0d6q2RBKxgE/IiD4Zzh1RFb1XtQB8E5fAhMtKhHQuYuowKIXyLAX5YDkQIsK1
	7SX9BGJNoAIh+wyfLK2UDJxSV3xInHyNG2PVUe/NCbGlCRpRTOeJocH/qbIzWaWPjWoZJFewk6S
	hT8CLrtMQh0NTO1ZV2p/r04y/DwTh3FEOvo2pBO+VH793TjfKRFjosP68EaOGbDK9mYUuzS3t7+
	LJriy42chdN/2ZFN07LwBzDAGhJM
X-Google-Smtp-Source: AGHT+IFredrVjALqgQC0RTNti//8cVC+vyqmqfp82TGOri1SR8IxBEOn4bF4kRsdQf2Q50SjYNqQtw==
X-Received: by 2002:a05:600c:1c03:b0:439:8a62:db42 with SMTP id 5b1f17b1804b1-43ab8fd8e71mr69837095e9.8.1740673377699;
        Thu, 27 Feb 2025 08:22:57 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43b73702bd0sm29001465e9.10.2025.02.27.08.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 08:22:57 -0800 (PST)
Date: Thu, 27 Feb 2025 17:22:55 +0100
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH v3 2/2] livepatch: Replace tasklist_lock with RCU
Message-ID: <Z8CRXxfI24E9_IHC@pathway.suse.cz>
References: <20250227024733.16989-1-laoar.shao@gmail.com>
 <20250227024733.16989-3-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227024733.16989-3-laoar.shao@gmail.com>

On Thu 2025-02-27 10:47:33, Yafang Shao wrote:
> The tasklist_lock in the KLP transition might result high latency under
> specific workload. We can replace it with RCU.
> 
> After a new task is forked, its kernel stack is always set to empty[0].
> Therefore, we can init these new tasks to KLP_TRANSITION_IDLE state
> after they are forked. If these tasks are forked during the KLP
> transition but before klp_check_and_switch_task(), they can be safely
> skipped during klp_check_and_switch_task(). Additionally, if
> klp_ftrace_handler() is triggered right after forking, the task can
> determine which function to use based on the klp_target_state.
> 
> With the above change, we can safely convert the tasklist_lock to RCU.
> 
> Link: https://lore.kernel.org/all/20250213173253.ovivhuq2c5rmvkhj@jpoimboe/ [0]
> Link: https://lore.kernel.org/all/20250214181206.xkvxohoc4ft26uhf@jpoimboe/ [1]
> Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
> --- a/kernel/livepatch/patch.c
> +++ b/kernel/livepatch/patch.c
> @@ -95,7 +95,13 @@ static void notrace klp_ftrace_handler(unsigned long ip,
>  
>  		patch_state = current->patch_state;
>  
> -		WARN_ON_ONCE(patch_state == KLP_TRANSITION_IDLE);
> +		/* If the patch_state is KLP_TRANSITION_IDLE, it means the task
> +		 * was forked after klp_init_transition(). In this case, the
> +		 * newly forked task can determine which function to use based
> +		 * on the klp_target_state.
> +		 */
> +		if (patch_state == KLP_TRANSITION_IDLE)
> +			patch_state = klp_target_state;
>  

CPU0				CPU1

task_0 (forked process):

funcA
  klp_ftrace_handler()
    if (patch_state == KLP_TRANSITION_IDLE)
       patch_state = klp_target_state
	# set to KLP_TRANSITION_PATCHED

  # redirected to klp_funcA()


				echo 0 >/sys/kernel/livepatch/patch1/enabled

				klp_reverse_transition()

				  klp_target_state = !klp_target_state;
				    # set to KLP_TRANSITION_UNPATCHED


   funcB
     if (patch_state == KLP_TRANSITION_IDLE)
       patch_state = klp_target_state
	 # set to KLP_TRANSITION_UNPATCHED

   # staying in origianl funcB


BANG: livepatched and original function called at the same time

      => broken consistency model.

BTW: This is what I tried to warn you about at
     https://lore.kernel.org/r/Z69Wuhve2vnsrtp_@pathway.suse.cz

See below for more:

>  		if (patch_state == KLP_TRANSITION_UNPATCHED) {
>  			/*
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index ba069459c101..af76defca67a 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -23,7 +23,7 @@ static DEFINE_PER_CPU(unsigned long[MAX_STACK_ENTRIES], klp_stack_entries);
>  
>  struct klp_patch *klp_transition_patch;
>  
> -static int klp_target_state = KLP_TRANSITION_IDLE;
> +int klp_target_state = KLP_TRANSITION_IDLE;
>  
>  static unsigned int klp_signals_cnt;
>  
> @@ -294,6 +294,14 @@ static int klp_check_and_switch_task(struct task_struct *task, void *arg)
>  {
>  	int ret;
>  
> +	/*
> +	 * If the patch_state remains KLP_TRANSITION_IDLE at this point, it
> +	 * indicates that the task was forked after klp_init_transition().
> +	 * In this case, it is safe to skip the task.
> +	 */
> +	if (!test_tsk_thread_flag(task, TIF_PATCH_PENDING))
> +		return 0;
> +
>  	if (task_curr(task) && task != current)
>  		return -EBUSY;
>  
> @@ -466,11 +474,11 @@ void klp_try_complete_transition(void)
>  	 * Usually this will transition most (or all) of the tasks on a system
>  	 * unless the patch includes changes to a very common function.
>  	 */
> -	read_lock(&tasklist_lock);
> +	rcu_read_lock();
>  	for_each_process_thread(g, task)
>  		if (!klp_try_switch_task(task))
>  			complete = false;
> -	read_unlock(&tasklist_lock);
> +	rcu_read_unlock();
>  
>  	/*
>  	 * Ditto for the idle "swapper" tasks.
> @@ -694,25 +702,10 @@ void klp_reverse_transition(void)
>  }
>  
>  /* Called from copy_process() during fork */
> -void klp_copy_process(struct task_struct *child)
> +void klp_init_process(struct task_struct *child)
>  {
> -
> -	/*
> -	 * The parent process may have gone through a KLP transition since
> -	 * the thread flag was copied in setup_thread_stack earlier. Bring
> -	 * the task flag up to date with the parent here.
> -	 *
> -	 * The operation is serialized against all klp_*_transition()
> -	 * operations by the tasklist_lock. The only exceptions are
> -	 * klp_update_patch_state(current) and __klp_sched_try_switch(), but we
> -	 * cannot race with them because we are current.
> -	 */
> -	if (test_tsk_thread_flag(current, TIF_PATCH_PENDING))
> -		set_tsk_thread_flag(child, TIF_PATCH_PENDING);
> -	else
> -		clear_tsk_thread_flag(child, TIF_PATCH_PENDING);
> -
> -	child->patch_state = current->patch_state;
> +	clear_tsk_thread_flag(child, TIF_PATCH_PENDING);
> +	child->patch_state = KLP_TRANSITION_IDLE;

I thought that we might do:

	child->patch_state = klp_target_state;

to avoid the race in the klp_ftrace_handler() described above.

But the following might happen:

CPU0				CPU1

klp_init_process(child)

  child->patch_state = KLP_TRANSITION_IDLE

				klp_enable_patch()
				  # setup ftrace handlers
				  # initialize all processes
				  # in the task list

  # add "child" into the task list

  schedule()

[running child now]

funcA()

  klp_ftrace_handler()

    child->patch_state = KLP_TRANSITION_IDLE

BANG: Same problem as with the original patch.


Hmm, the 2nd version of this patchset tried to do:

diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
index 90408500e5a3..5e523a3fbb3c 100644
--- a/kernel/livepatch/patch.c
+++ b/kernel/livepatch/patch.c
@@ -95,7 +95,12 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 
 		patch_state = current->patch_state;
 
-		WARN_ON_ONCE(patch_state == KLP_TRANSITION_IDLE);
+		/* If the patch_state is KLP_TRANSITION_IDLE, it indicates the
+		 * task was forked after klp_init_transition(). For this newly
+		 * forked task, it is safe to switch it to klp_target_state.
+		 */
+		if (patch_state == KLP_TRANSITION_IDLE)
+			current->patch_state = klp_target_state;
 
 		if (patch_state == KLP_TRANSITION_UNPATCHED) {
 			/*

Note: It is broken. It sets current->patch_state but it later
      checks the local variable "patch_state" which is still
      KLP_TRANSITION_IDLE.

But is is safe when we fix it?

It might be as long as we run klp_synchronize_transition() between
updating the global @klp_target_state and the other operations.

Especially, we need to make sure that @klp_target_state always have
either KLP_TRANSITION_PATCHED or KLP_TRANSITION_UNPATCHED when
func->transition is set.

For this, we would need to add klp_synchronize_transition() into

  + klp_init_transition() between setting @klp_target_state
    and func->transition = true.

  + klp_complete_transition() also for KLP_TRANSITION_UNPATCHED way.
    It is currently called only for the PATCHED target state.

Will this be enough?

FACT: It is more complicated than it looked.
QUESTION: Is this worth the effort?

NOTE: The rcu_read_lock() does not solve the reported stall.
      We are spending time on it only because it looked nice and
      simple to you.

My opinion: I would personally prefer to focus on solving
	the stall and the use-after-free access in do_exit().

Best Regards,
Petr

