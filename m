Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926B64867C3
	for <lists+live-patching@lfdr.de>; Thu,  6 Jan 2022 17:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241289AbiAFQhc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 Jan 2022 11:37:32 -0500
Received: from foss.arm.com ([217.140.110.172]:56466 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241323AbiAFQhc (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 Jan 2022 11:37:32 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C37291042;
        Thu,  6 Jan 2022 08:37:31 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.10.56])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D09E43F5A1;
        Thu,  6 Jan 2022 08:37:29 -0800 (PST)
Date:   Thu, 6 Jan 2022 16:37:27 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 05/10] arm64: Copy unwind arguments to unwind_state
Message-ID: <Ydcax2E9u4D4/3Q9@FVFF77S0Q05N>
References: <0d0eb36f348fb5a6af6eb592c0525f6e94007328>
 <20220103165212.9303-1-madvenka@linux.microsoft.com>
 <20220103165212.9303-6-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103165212.9303-6-madvenka@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Jan 03, 2022 at 10:52:07AM -0600, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Copy the following arguments passed to arch_stack_walk() to unwind_state
> so that they can be passed to unwind functions via unwind_state rather
> than as separate arguments:
> 
> 	- task

I agree the task should be placed in the unwind state, since it's a key part of
the environment for the unwind.

> 	- regs

This isn't relevant in all cases, and so for now I'd strongly prefer *not* to
have this in the unwind state as it's liable to lead to confusion and get
misused.

> 	- consume_entry
> 	- cookie

These are only relevant for the invocation of the consume_entry() function, and
so similarly I do not think they should be part of the state. It's simpler for
these to be local variables.

> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  arch/arm64/include/asm/stacktrace.h | 12 ++++++++
>  arch/arm64/kernel/stacktrace.c      | 45 ++++++++++++++++-------------
>  2 files changed, 37 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
> index fc828c3c5dfd..322817d40a75 100644
> --- a/arch/arm64/include/asm/stacktrace.h
> +++ b/arch/arm64/include/asm/stacktrace.h
> @@ -51,6 +51,14 @@ struct stack_info {
>   * @kr_cur:      When KRETPOLINES is selected, holds the kretprobe instance
>   *               associated with the most recently encountered replacement lr
>   *               value.
> + *
> + * @task:        Pointer to the task structure.
> + *
> + * @regs:        Registers, if any.
> + *
> + * @consume_pc   Consume PC function pointer.
> + *
> + * @cookie       Argument to consume_pc().
>   */
>  struct unwind_state {
>  	unsigned long fp;
> @@ -61,6 +69,10 @@ struct unwind_state {
>  #ifdef CONFIG_KRETPROBES
>  	struct llist_node *kr_cur;
>  #endif
> +	struct task_struct *task;
> +	struct pt_regs *regs;
> +	stack_trace_consume_fn consume_pc;
> +	void *cookie;
>  };
>  
>  extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index bd797e3f7789..3ecb8242caa5 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -33,8 +33,17 @@
>   */
>  
>  
> -static void unwind_init_common(struct unwind_state *state)
> +static void unwind_init_common(struct unwind_state *state,
> +			       struct task_struct *task,
> +			       struct pt_regs *regs,
> +			       stack_trace_consume_fn consume_pc,
> +			       void *cookie)
>  {
> +	state->task = task;
> +	state->regs = regs;
> +	state->consume_pc = consume_pc;
> +	state->cookie = cookie;
> +
>  #ifdef CONFIG_KRETPROBES
>  	state->kr_cur = NULL;
>  #endif
> @@ -56,11 +65,10 @@ static void unwind_init_common(struct unwind_state *state)
>  /*
>   * TODO: document requirements here.
>   */
> -static inline void unwind_init_regs(struct unwind_state *state,
> -				    struct pt_regs *regs)
> +static inline void unwind_init_regs(struct unwind_state *state)
>  {
> -	state->fp = regs->regs[29];
> -	state->pc = regs->pc;
> +	state->fp = state->regs->regs[29];
> +	state->pc = state->regs->pc;
>  }
>  
>  /*
> @@ -80,11 +88,10 @@ static __always_inline void unwind_init_current(struct unwind_state *state)
>   *
>   * The caller guarantees that the task is not running.
>   */
> -static inline void unwind_init_task(struct unwind_state *state,
> -				    struct task_struct *task)
> +static inline void unwind_init_task(struct unwind_state *state)
>  {
> -	state->fp = thread_saved_fp(task);
> -	state->pc = thread_saved_pc(task);
> +	state->fp = thread_saved_fp(state->task);
> +	state->pc = thread_saved_pc(state->task);
>  }
>  
>  /*
> @@ -94,9 +101,9 @@ static inline void unwind_init_task(struct unwind_state *state,
>   * records (e.g. a cycle), determined based on the location and fp value of A
>   * and the location (but not the fp value) of B.
>   */
> -static int notrace unwind_next(struct task_struct *tsk,
> -			       struct unwind_state *state)
> +static int notrace unwind_next(struct unwind_state *state)
>  {
> +	struct task_struct *tsk = state->task;
>  	unsigned long fp = state->fp;
>  	struct stack_info info;
>  
> @@ -170,16 +177,14 @@ static int notrace unwind_next(struct task_struct *tsk,
>  }
>  NOKPROBE_SYMBOL(unwind_next);
>  
> -static void notrace unwind(struct task_struct *tsk,
> -			   struct unwind_state *state,
> -			   bool (*fn)(void *, unsigned long), void *data)
> +static void notrace unwind(struct unwind_state *state)
>  {
>  	while (1) {
>  		int ret;
>  
> -		if (!fn(data, state->pc))
> +		if (!state->consume_pc(state->cookie, state->pc))
>  			break;
> -		ret = unwind_next(tsk, state);
> +		ret = unwind_next(state);
>  		if (ret < 0)
>  			break;
>  	}
> @@ -225,14 +230,14 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
>  {
>  	struct unwind_state state;
>  
> -	unwind_init_common(&state);
> +	unwind_init_common(&state, task, regs, consume_entry, cookie);
>  
>  	if (regs)
> -		unwind_init_regs(&state, regs);
> +		unwind_init_regs(&state);
>  	else if (task == current)
>  		unwind_init_current(&state);
>  	else
> -		unwind_init_task(&state, task);
> +		unwind_init_task(&state);
>  
> -	unwind(task, &state, consume_entry, cookie);
> +	unwind(&state);

I don't like the changes here in particular since they hide the information
flow relevant to each case.

Thanks,
Mark.

>  }
> -- 
> 2.25.1
> 
