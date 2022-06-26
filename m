Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDF555B035
	for <lists+live-patching@lfdr.de>; Sun, 26 Jun 2022 10:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbiFZIVa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 26 Jun 2022 04:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbiFZIVa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 26 Jun 2022 04:21:30 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26C1912AB3;
        Sun, 26 Jun 2022 01:21:29 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C77DD6E;
        Sun, 26 Jun 2022 01:21:29 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.71.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 14C293F792;
        Sun, 26 Jun 2022 01:21:26 -0700 (PDT)
Date:   Sun, 26 Jun 2022 09:21:23 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v15 3/6] arm64: Make the unwind loop in unwind() similar
 to other architectures
Message-ID: <YrgXA/x6uw1z75R2@FVFF77S0Q05N>
References: <ff68fb850d42e1adaa6a0a6c9c258acabb898b24>
 <20220617210717.27126-1-madvenka@linux.microsoft.com>
 <20220617210717.27126-4-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617210717.27126-4-madvenka@linux.microsoft.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jun 17, 2022 at 04:07:14PM -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Change the loop in unwind()
> ===========================
> 
> Change the unwind loop in unwind() to:
> 
> 	while (unwind_continue(state, consume_entry, cookie))
> 		unwind_next(state);
> 
> This is easy to understand and maintain.
> New function unwind_continue()
> ==============================
> 
> Define a new function unwind_continue() that is used in the unwind loop
> to check for conditions that terminate a stack trace.
> 
> The conditions checked are:
> 
> 	- If the bottom of the stack (final frame) has been reached,
> 	  terminate.
> 
> 	- If the consume_entry() function returns false, the caller of
> 	  unwind has asked to terminate the stack trace. So, terminate.
> 
> 	- If unwind_next() failed for some reason (like stack corruption),
> 	  terminate.

I'm a bit confused as to why this structure, since AFAICT this doesn't match
other architectures (looking at x86, powerpc, and s390). I note that x86 has:

* In arch_stack_walk():

        for (unwind_start(&state, task, regs, NULL); !unwind_done(&state);
             unwind_next_frame(&state)) {
		...
		if (!consume_entry(...))
			break;
		...
	}

* In arch_stack_walk_reliable():

        for (unwind_start(&state, task, NULL, NULL);
             !unwind_done(&state) && !unwind_error(&state);
             unwind_next_frame(&state)) {
		...
		if (!consume_entry(...)
			return -EINVAL;
	}

... and back in v6 I suggeted exactly that shape:

  https://lore.kernel.org/linux-arm-kernel/20210728165635.GA47345@C02TD0UTHF1T.local/

> 
> Do not return an error value from unwind_next()
> ===============================================
> 
> We want to check for terminating conditions only in unwind_continue() from
> the unwinder loop. So, do not return an error value from unwind_next().
> Simply set a flag in unwind_state and check the flag in unwind_continue().

I'm fine with the concept of moving ghe return value out of unwind_next() (e.g.
if we go with an x86-like structure), but I don't think that we should
centralize the other checks *and* the consumption within unwind_continue(), as
I think those are two separate things.

> 
> Final FP
> ========
> 
> Introduce a new field "final_fp" in "struct unwind_state". Initialize this
> to the final frame of the stack trace:
> 
> 	task_pt_regs(task)->stackframe
> 
> This is where the stacktrace must terminate if it is successful. Add an
> explicit comment to that effect.

Can we please make this change as a preparatory step, as with the 'task' field?

We can wrap this in a helper like:

static bool is_final_frame(struct unwind state *state)
{
	return state->fp == state->final_fp;
}

... and use that in the main loop.

Thanks,
Mark.

> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kernel/stacktrace.c | 78 ++++++++++++++++++++++------------
>  1 file changed, 52 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index 8e43444d50e2..c749129aba5a 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -40,6 +40,10 @@
>   *               value.
>   *
>   * @task:        The task being unwound.
> + *
> + * @final_fp:	 Pointer to the final frame.
> + *
> + * @failed:      Unwind failed.
>   */
>  struct unwind_state {
>  	unsigned long fp;
> @@ -51,6 +55,8 @@ struct unwind_state {
>  	struct llist_node *kr_cur;
>  #endif
>  	struct task_struct *task;
> +	unsigned long final_fp;
> +	bool failed;
>  };
>  
>  static void unwind_init_common(struct unwind_state *state,
> @@ -73,6 +79,10 @@ static void unwind_init_common(struct unwind_state *state,
>  	bitmap_zero(state->stacks_done, __NR_STACK_TYPES);
>  	state->prev_fp = 0;
>  	state->prev_type = STACK_TYPE_UNKNOWN;
> +	state->failed = false;
> +
> +	/* Stack trace terminates here. */
> +	state->final_fp = (unsigned long)task_pt_regs(task)->stackframe;
>  }
>  
>  /*
> @@ -126,6 +136,25 @@ static inline void unwind_init_from_task(struct unwind_state *state,
>  	state->pc = thread_saved_pc(task);
>  }
>  
> +static bool notrace unwind_continue(struct unwind_state *state,
> +				    stack_trace_consume_fn consume_entry,
> +				    void *cookie)
> +{
> +	if (state->failed) {
> +		/* PC is suspect. Cannot consume it. */
> +		return false;
> +	}
> +
> +	if (!consume_entry(cookie, state->pc)) {
> +		/* Caller terminated the unwind. */
> +		state->failed = true;
> +		return false;
> +	}
> +
> +	return state->fp != state->final_fp;
> +}
> +NOKPROBE_SYMBOL(unwind_continue);
> +
>  /*
>   * Unwind from one frame record (A) to the next frame record (B).
>   *
> @@ -133,24 +162,26 @@ static inline void unwind_init_from_task(struct unwind_state *state,
>   * records (e.g. a cycle), determined based on the location and fp value of A
>   * and the location (but not the fp value) of B.
>   */
> -static int notrace unwind_next(struct unwind_state *state)
> +static void notrace unwind_next(struct unwind_state *state)
>  {
>  	struct task_struct *tsk = state->task;
>  	unsigned long fp = state->fp;
>  	struct stack_info info;
>  
> -	/* Final frame; nothing to unwind */
> -	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
> -		return -ENOENT;
> -
> -	if (fp & 0x7)
> -		return -EINVAL;
> +	if (fp & 0x7) {
> +		state->failed = true;
> +		return;
> +	}
>  
> -	if (!on_accessible_stack(tsk, fp, 16, &info))
> -		return -EINVAL;
> +	if (!on_accessible_stack(tsk, fp, 16, &info)) {
> +		state->failed = true;
> +		return;
> +	}

>  
> -	if (test_bit(info.type, state->stacks_done))
> -		return -EINVAL;
> +	if (test_bit(info.type, state->stacks_done)) {
> +		state->failed = true;
> +		return;
> +	}
>  
>  	/*
>  	 * As stacks grow downward, any valid record on the same stack must be
> @@ -166,8 +197,10 @@ static int notrace unwind_next(struct unwind_state *state)
>  	 * stack.
>  	 */
>  	if (info.type == state->prev_type) {
> -		if (fp <= state->prev_fp)
> -			return -EINVAL;
> +		if (fp <= state->prev_fp) {
> +			state->failed = true;
> +			return;
> +		}
>  	} else {
>  		set_bit(state->prev_type, state->stacks_done);
>  	}
> @@ -195,8 +228,10 @@ static int notrace unwind_next(struct unwind_state *state)
>  		 */
>  		orig_pc = ftrace_graph_ret_addr(tsk, NULL, state->pc,
>  						(void *)state->fp);
> -		if (WARN_ON_ONCE(state->pc == orig_pc))
> -			return -EINVAL;
> +		if (WARN_ON_ONCE(state->pc == orig_pc)) {
> +			state->failed = true;
> +			return;
> +		}
>  		state->pc = orig_pc;
>  	}
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> @@ -204,23 +239,14 @@ static int notrace unwind_next(struct unwind_state *state)
>  	if (is_kretprobe_trampoline(state->pc))
>  		state->pc = kretprobe_find_ret_addr(tsk, (void *)state->fp, &state->kr_cur);
>  #endif
> -
> -	return 0;
>  }
>  NOKPROBE_SYMBOL(unwind_next);
>  
>  static void notrace unwind(struct unwind_state *state,
>  			   stack_trace_consume_fn consume_entry, void *cookie)
>  {
> -	while (1) {
> -		int ret;
> -
> -		if (!consume_entry(cookie, state->pc))
> -			break;
> -		ret = unwind_next(state);
> -		if (ret < 0)
> -			break;
> -	}
> +	while (unwind_continue(state, consume_entry, cookie))
> +		unwind_next(state);
>  }
>  NOKPROBE_SYMBOL(unwind);
>  
> -- 
> 2.25.1
> 
