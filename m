Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12CE655AFEE
	for <lists+live-patching@lfdr.de>; Sun, 26 Jun 2022 09:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiFZHjl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 26 Jun 2022 03:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiFZHjk (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 26 Jun 2022 03:39:40 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8914BFD22;
        Sun, 26 Jun 2022 00:39:36 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3A3BED6E;
        Sun, 26 Jun 2022 00:39:36 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.71.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 13F243F792;
        Sun, 26 Jun 2022 00:39:33 -0700 (PDT)
Date:   Sun, 26 Jun 2022 08:39:26 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v15 1/6] arm64: Split unwind_init()
Message-ID: <YrgNLjLnug6PfgO2@FVFF77S0Q05N>
References: <ff68fb850d42e1adaa6a0a6c9c258acabb898b24>
 <20220617210717.27126-1-madvenka@linux.microsoft.com>
 <20220617210717.27126-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617210717.27126-2-madvenka@linux.microsoft.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jun 17, 2022 at 04:07:12PM -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> unwind_init() is currently a single function that initializes all of the
> unwind state. Split it into the following functions and call them
> appropriately:
> 
> 	- unwind_init_from_regs() - initialize from regs passed by caller.
> 
> 	- unwind_init_from_caller() - initialize for the current task
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
> Reviewed-by: Mark Brown <broonie@kernel.org>

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/kernel/stacktrace.c | 66 ++++++++++++++++++++++++++++------
>  1 file changed, 55 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index 0467cb79f080..e44f93ff25f0 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -50,11 +50,8 @@ struct unwind_state {
>  #endif
>  };
>  
> -static notrace void unwind_init(struct unwind_state *state, unsigned long fp,
> -				unsigned long pc)
> +static void unwind_init_common(struct unwind_state *state)
>  {
> -	state->fp = fp;
> -	state->pc = pc;
>  #ifdef CONFIG_KRETPROBES
>  	state->kr_cur = NULL;
>  #endif
> @@ -72,7 +69,57 @@ static notrace void unwind_init(struct unwind_state *state, unsigned long fp,
>  	state->prev_fp = 0;
>  	state->prev_type = STACK_TYPE_UNKNOWN;
>  }
> -NOKPROBE_SYMBOL(unwind_init);
> +
> +/*
> + * Start an unwind from a pt_regs.
> + *
> + * The unwind will begin at the PC within the regs.
> + *
> + * The regs must be on a stack currently owned by the calling task.
> + */
> +static inline void unwind_init_from_regs(struct unwind_state *state,
> +					 struct pt_regs *regs)
> +{
> +	unwind_init_common(state);
> +
> +	state->fp = regs->regs[29];
> +	state->pc = regs->pc;
> +}
> +
> +/*
> + * Start an unwind from a caller.
> + *
> + * The unwind will begin at the caller of whichever function this is inlined
> + * into.
> + *
> + * The function which invokes this must be noinline.
> + */
> +static __always_inline void unwind_init_from_caller(struct unwind_state *state)
> +{
> +	unwind_init_common(state);
> +
> +	state->fp = (unsigned long)__builtin_frame_address(1);
> +	state->pc = (unsigned long)__builtin_return_address(0);
> +}
> +
> +/*
> + * Start an unwind from a blocked task.
> + *
> + * The unwind will begin at the blocked tasks saved PC (i.e. the caller of
> + * cpu_switch_to()).
> + *
> + * The caller should ensure the task is blocked in cpu_switch_to() for the
> + * duration of the unwind, or the unwind will be bogus. It is never valid to
> + * call this for the current task.
> + */
> +static inline void unwind_init_from_task(struct unwind_state *state,
> +					 struct task_struct *task)
> +{
> +	unwind_init_common(state);
> +
> +	state->fp = thread_saved_fp(task);
> +	state->pc = thread_saved_pc(task);
> +}
>  
>  /*
>   * Unwind from one frame record (A) to the next frame record (B).
> @@ -213,14 +260,11 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
>  	struct unwind_state state;
>  
>  	if (regs)
> -		unwind_init(&state, regs->regs[29], regs->pc);
> +		unwind_init_from_regs(&state, regs);
>  	else if (task == current)
> -		unwind_init(&state,
> -				(unsigned long)__builtin_frame_address(1),
> -				(unsigned long)__builtin_return_address(0));
> +		unwind_init_from_caller(&state);
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
