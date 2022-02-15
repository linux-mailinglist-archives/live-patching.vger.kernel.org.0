Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE4B4B6D4B
	for <lists+live-patching@lfdr.de>; Tue, 15 Feb 2022 14:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238216AbiBONW7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Feb 2022 08:22:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238192AbiBONW6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Feb 2022 08:22:58 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0443106626;
        Tue, 15 Feb 2022 05:22:48 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 688541480;
        Tue, 15 Feb 2022 05:22:48 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.89.173])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A9D33F718;
        Tue, 15 Feb 2022 05:22:46 -0800 (PST)
Date:   Tue, 15 Feb 2022 13:22:42 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 05/11] arm64: Copy the task argument to unwind_state
Message-ID: <YgupIuJgL7nreT+1@FVFF77S0Q05N>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-6-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220117145608.6781-6-madvenka@linux.microsoft.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Jan 17, 2022 at 08:56:02AM -0600, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Copy the task argument passed to arch_stack_walk() to unwind_state so that
> it can be passed to unwind functions via unwind_state rather than as a
> separate argument. The task is a fundamental part of the unwind state.
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  arch/arm64/include/asm/stacktrace.h |  3 +++
>  arch/arm64/kernel/stacktrace.c      | 29 ++++++++++++++++-------------
>  2 files changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
> index 41ec360515f6..af423f5d7ad8 100644
> --- a/arch/arm64/include/asm/stacktrace.h
> +++ b/arch/arm64/include/asm/stacktrace.h
> @@ -51,6 +51,8 @@ struct stack_info {
>   * @kr_cur:      When KRETPROBES is selected, holds the kretprobe instance
>   *               associated with the most recently encountered replacement lr
>   *               value.
> + *
> + * @task:        Pointer to the task structure.

Can we please say:

	@task:	The task being unwound.

>   */
>  struct unwind_state {
>  	unsigned long fp;
> @@ -61,6 +63,7 @@ struct unwind_state {
>  #ifdef CONFIG_KRETPROBES
>  	struct llist_node *kr_cur;
>  #endif
> +	struct task_struct *task;
>  };
>  
>  extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index b2b568e5deba..1b32e55735aa 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -33,8 +33,10 @@
>   */
>  
>  
> -static void unwind_init_common(struct unwind_state *state)
> +static void unwind_init_common(struct unwind_state *state,
> +			       struct task_struct *task)
>  {
> +	state->task = task;
>  #ifdef CONFIG_KRETPROBES
>  	state->kr_cur = NULL;
>  #endif
> @@ -57,9 +59,10 @@ static void unwind_init_common(struct unwind_state *state)
>   * TODO: document requirements here.
>   */
>  static inline void unwind_init_from_regs(struct unwind_state *state,
> +					 struct task_struct *task,

Please drop the `task` parameter here ...

>  					 struct pt_regs *regs)
>  {
> -	unwind_init_common(state);
> +	unwind_init_common(state, task);

... and make this:

	unwind_init_common(state, current);

... since that way it's *impossible* to have ismatched parameters, which is one
of the reasons for having separate functions in the first place.

>  	state->fp = regs->regs[29];
>  	state->pc = regs->pc;
> @@ -71,9 +74,10 @@ static inline void unwind_init_from_regs(struct unwind_state *state,
>   * Note: this is always inlined, and we expect our caller to be a noinline
>   * function, such that this starts from our caller's caller.
>   */
> -static __always_inline void unwind_init_from_current(struct unwind_state *state)
> +static __always_inline void unwind_init_from_current(struct unwind_state *state,
> +						     struct task_struct *task)
>  {
> -	unwind_init_common(state);
> +	unwind_init_common(state, task);

Same comments as for unwind_init_from_regs(): please drop the `task` parameter
and hard-code `current` in the call to unwind_init_common().

>  	state->fp = (unsigned long)__builtin_frame_address(1);
>  	state->pc = (unsigned long)__builtin_return_address(0);
> @@ -87,7 +91,7 @@ static __always_inline void unwind_init_from_current(struct unwind_state *state)
>  static inline void unwind_init_from_task(struct unwind_state *state,
>  					 struct task_struct *task)
>  {
> -	unwind_init_common(state);
> +	unwind_init_common(state, task);
>  
>  	state->fp = thread_saved_fp(task);
>  	state->pc = thread_saved_pc(task);
> @@ -100,11 +104,11 @@ static inline void unwind_init_from_task(struct unwind_state *state,
>   * records (e.g. a cycle), determined based on the location and fp value of A
>   * and the location (but not the fp value) of B.
>   */
> -static int notrace unwind_next(struct task_struct *tsk,
> -			       struct unwind_state *state)
> +static int notrace unwind_next(struct unwind_state *state)
>  {
>  	unsigned long fp = state->fp;
>  	struct stack_info info;
> +	struct task_struct *tsk = state->task;
>  
>  	/* Final frame; nothing to unwind */
>  	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
> @@ -176,8 +180,7 @@ static int notrace unwind_next(struct task_struct *tsk,
>  }
>  NOKPROBE_SYMBOL(unwind_next);
>  
> -static void notrace unwind(struct task_struct *tsk,
> -			   struct unwind_state *state,
> +static void notrace unwind(struct unwind_state *state,
>  			   bool (*fn)(void *, unsigned long), void *data)
>  {
>  	while (1) {
> @@ -185,7 +188,7 @@ static void notrace unwind(struct task_struct *tsk,
>  
>  		if (!fn(data, state->pc))
>  			break;
> -		ret = unwind_next(tsk, state);
> +		ret = unwind_next(state);
>  		if (ret < 0)
>  			break;
>  	}
> @@ -232,11 +235,11 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
>  	struct unwind_state state;
>  
>  	if (regs)
> -		unwind_init_from_regs(&state, regs);
> +		unwind_init_from_regs(&state, task, regs);
>  	else if (task == current)
> -		unwind_init_from_current(&state);
> +		unwind_init_from_current(&state, task);
>  	else
>  		unwind_init_from_task(&state, task);

As above we shouldn't need these two changes.

For the regs case we might want to sanity-check that task == current.

> -	unwind(task, &state, consume_entry, cookie);
> +	unwind(&state, consume_entry, cookie);

Otherwise, this looks good to me.

Thanks,
Mark.
