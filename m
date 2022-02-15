Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C964B6D05
	for <lists+live-patching@lfdr.de>; Tue, 15 Feb 2022 14:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbiBONIN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Feb 2022 08:08:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbiBONIM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Feb 2022 08:08:12 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2178AB16EC;
        Tue, 15 Feb 2022 05:08:02 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD2631480;
        Tue, 15 Feb 2022 05:08:01 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.89.173])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 099533F718;
        Tue, 15 Feb 2022 05:07:59 -0800 (PST)
Date:   Tue, 15 Feb 2022 13:07:56 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 04/11] arm64: Split unwind_init()
Message-ID: <YgulrExdlfBcHoKP@FVFF77S0Q05N>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-5-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220117145608.6781-5-madvenka@linux.microsoft.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Madhavan,

The diff itself largely looks good, but we need to actually write the comments.
Can you pleaes pick up the wording I've written below for those?

That and renaming `unwind_init_from_current` to `unwind_init_from_caller`.

With those I think this is good, but I'd like to see the updated version before
I provide Acked-by or Reviewed-by tags -- hopefully that's just a formality! :)

On Mon, Jan 17, 2022 at 08:56:01AM -0600, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> unwind_init() is currently a single function that initializes all of the
> unwind state. Split it into the following functions and call them
> appropriately:
> 
> 	- unwind_init_from_regs() - initialize from regs passed by caller.
> 
> 	- unwind_init_from_current() - initialize for the current task
> 	  from the caller of arch_stack_walk().
> 
> 	- unwind_init_from_task() - initialize from the saved state of a
> 	  task other than the current task. In this case, the other
> 	  task must not be running.
> 
> This is done for two reasons:
> 
> 	- the different ways of initializing are clear
> 
> 	- specialized code can be added to each initializer in the future.
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  arch/arm64/kernel/stacktrace.c | 54 +++++++++++++++++++++++++++-------
>  1 file changed, 44 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index a1a7ff93b84f..b2b568e5deba 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -33,11 +33,8 @@
>   */
>  
>  
> -static void unwind_init(struct unwind_state *state, unsigned long fp,
> -			unsigned long pc)
> +static void unwind_init_common(struct unwind_state *state)
>  {
> -	state->fp = fp;
> -	state->pc = pc;
>  #ifdef CONFIG_KRETPROBES
>  	state->kr_cur = NULL;
>  #endif
> @@ -56,6 +53,46 @@ static void unwind_init(struct unwind_state *state, unsigned long fp,
>  	state->prev_type = STACK_TYPE_UNKNOWN;
>  }
>  
> +/*
> + * TODO: document requirements here.
> + */

Please make this:

/*
 * Start an unwind from a pt_regs.
 *
 * The unwind will begin at the PC within the regs.
 *
 * The regs must be on a stack currently owned by the calling task.
 */

> +static inline void unwind_init_from_regs(struct unwind_state *state,
> +					 struct pt_regs *regs)
> +{

In future we could add:

	WARN_ON_ONCE(!on_accessible_stack(current, regs, sizeof(*regs), NULL));

... to validate the requirements, but I'm happy to lave that for a future patch
so this patch can be a pure refactoring.

> +	unwind_init_common(state);
> +
> +	state->fp = regs->regs[29];
> +	state->pc = regs->pc;
> +}
> +
> +/*
> + * TODO: document requirements here.
> + *
> + * Note: this is always inlined, and we expect our caller to be a noinline
> + * function, such that this starts from our caller's caller.
> + */

Please make this:

/*
 * Start an unwind from a caller.
 *
 * The unwind will begin at the caller of whichever function this is inlined
 * into.
 *
 * The function which invokes this must be noinline.
 */

> +static __always_inline void unwind_init_from_current(struct unwind_state *state)

Can we please rename s/current/caller/ here? That way it's clear *where* in
current we're unwinding from, and the fact that it's current is implicit but
obvious.

> +{

Similarly to unwind_init_from_regs(), in a future patch we could add:

	WARN_ON_ONCE(task == current);

... but for now we can omit that so this patch can be a pure refactoring.

> +	unwind_init_common(state);
> +
> +	state->fp = (unsigned long)__builtin_frame_address(1);
> +	state->pc = (unsigned long)__builtin_return_address(0);
> +}
> +
> +/*
> + * TODO: document requirements here.
> + *
> + * The caller guarantees that the task is not running.
> + */

Please make this:

/*
 * Start an unwind from a blocked task.
 *
 * The unwind will begin at the blocked tasks saved PC (i.e. the caller of
 * cpu_switch_to()).
 *
 * The caller should ensure the task is blocked in cpu_switch_to() for the
 * duration of the unwind, or the unwind will be bogus. It is never valid to
 * call this for the current task.
 */

Thanks,
Mark.

> +static inline void unwind_init_from_task(struct unwind_state *state,
> +					 struct task_struct *task)
> +{
> +	unwind_init_common(state);
> +
> +	state->fp = thread_saved_fp(task);
> +	state->pc = thread_saved_pc(task);
> +}
> +
>  /*
>   * Unwind from one frame record (A) to the next frame record (B).
>   *
> @@ -195,14 +232,11 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
>  	struct unwind_state state;
>  
>  	if (regs)
> -		unwind_init(&state, regs->regs[29], regs->pc);
> +		unwind_init_from_regs(&state, regs);
>  	else if (task == current)
> -		unwind_init(&state,
> -				(unsigned long)__builtin_frame_address(1),
> -				(unsigned long)__builtin_return_address(0));
> +		unwind_init_from_current(&state);
>  	else
> -		unwind_init(&state, thread_saved_fp(task),
> -				thread_saved_pc(task));
> +		unwind_init_from_task(&state, task);
>  
>  	unwind(task, &state, consume_entry, cookie);
>  }
> -- 
> 2.25.1
> 
