Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7124867B4
	for <lists+live-patching@lfdr.de>; Thu,  6 Jan 2022 17:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241167AbiAFQbe (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 Jan 2022 11:31:34 -0500
Received: from foss.arm.com ([217.140.110.172]:56360 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241130AbiAFQbd (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 Jan 2022 11:31:33 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4C51D1042;
        Thu,  6 Jan 2022 08:31:33 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.10.56])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 583883F5A1;
        Thu,  6 Jan 2022 08:31:31 -0800 (PST)
Date:   Thu, 6 Jan 2022 16:31:28 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 04/10] arm64: Split unwind_init()
Message-ID: <YdcZYGI42h7zybqo@FVFF77S0Q05N>
References: <0d0eb36f348fb5a6af6eb592c0525f6e94007328>
 <20220103165212.9303-1-madvenka@linux.microsoft.com>
 <20220103165212.9303-5-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103165212.9303-5-madvenka@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Jan 03, 2022 at 10:52:06AM -0600, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> unwind_init() is currently a single function that initializes all of the
> unwind state. Split it into the following functions and call them
> appropriately:
> 
> 	- unwind_init_regs() - initialize from regs passed by caller.
> 
> 	- unwind_init_current() - initialize for the current task from the
> 	  caller of arch_stack_walk().
> 
> 	- unwind_init_from_task() - initialize from the saved state of a
> 	  task other than the current task. In this case, the other
> 	  task must not be running.
> 
> 	- unwind_init_common() - initialize fields that are common across
> 	  the above 3 cases.
> 
> This is done so that specialized initialization can be added to each case
> in the future.
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  arch/arm64/kernel/stacktrace.c | 50 +++++++++++++++++++++++++++-------
>  1 file changed, 40 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index a1a7ff93b84f..bd797e3f7789 100644
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
> @@ -56,6 +53,40 @@ static void unwind_init(struct unwind_state *state, unsigned long fp,
>  	state->prev_type = STACK_TYPE_UNKNOWN;
>  }
>  
> +/*
> + * TODO: document requirements here.
> + */
> +static inline void unwind_init_regs(struct unwind_state *state,
> +				    struct pt_regs *regs)
> +{
> +	state->fp = regs->regs[29];
> +	state->pc = regs->pc;
> +}

When I suggested this back in:

  https://lore.kernel.org/linux-arm-kernel/20211123193723.12112-1-madvenka@linux.microsoft.com/T/#md91fbfe08ceab2a02d9f5c326e17997786e53208

... my intent was that each unwind_init_from_*() helpers was the sole
initializer of the structure, and the caller only had to call one function.
That way it's not possible to construct an object with an erroneous combination
of arguments because the prototype enforces the set of arguments, and the
helper function can operate on a consistent snapshot of those arguments.

So I'd much prefer that each of these helpers called unwind_init_common(),
rather than leaving that to the caller to do. I don't mind if those pass
arguments to unwind_init_common(), or explciitly initialize their respective
fields, but I don' think the caller should have to care about unwind_init_common().

I'd also prefer the unwind_init_from*() naming I'd previously suggested, so
that it's clear which direction information is flowing.

>
> +
> +/*
> + * TODO: document requirements here.
> + *
> + * Note: this is always inlined, and we expect our caller to be a noinline
> + * function, such that this starts from our caller's caller.
> + */
> +static __always_inline void unwind_init_current(struct unwind_state *state)
> +{
> +	state->fp = (unsigned long)__builtin_frame_address(1);
> +	state->pc = (unsigned long)__builtin_return_address(0);
> +}
> +
> +/*
> + * TODO: document requirements here.
> + *
> + * The caller guarantees that the task is not running.
> + */
> +static inline void unwind_init_task(struct unwind_state *state,
> +				    struct task_struct *task)
> +{
> +	state->fp = thread_saved_fp(task);
> +	state->pc = thread_saved_pc(task);
> +}
> +
>  /*
>   * Unwind from one frame record (A) to the next frame record (B).
>   *
> @@ -194,15 +225,14 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
>  {
>  	struct unwind_state state;
>  
> +	unwind_init_common(&state);

As above, I really don't like that the caller has to call both the common
initializer and a specialized initializer here.

Thanks,
Mark.

> +
>  	if (regs)
> -		unwind_init(&state, regs->regs[29], regs->pc);
> +		unwind_init_regs(&state, regs);
>  	else if (task == current)
> -		unwind_init(&state,
> -				(unsigned long)__builtin_frame_address(1),
> -				(unsigned long)__builtin_return_address(0));
> +		unwind_init_current(&state);
>  	else
> -		unwind_init(&state, thread_saved_fp(task),
> -				thread_saved_pc(task));
> +		unwind_init_task(&state, task);
>  
>  	unwind(task, &state, consume_entry, cookie);
>  }
> -- 
> 2.25.1
> 
