Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318A0359EA1
	for <lists+live-patching@lfdr.de>; Fri,  9 Apr 2021 14:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbhDIM1U (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Apr 2021 08:27:20 -0400
Received: from foss.arm.com ([217.140.110.172]:50344 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232855AbhDIM1T (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Apr 2021 08:27:19 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6275F1063;
        Fri,  9 Apr 2021 05:27:06 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.28.223])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 36AC63F694;
        Fri,  9 Apr 2021 05:27:04 -0700 (PDT)
Date:   Fri, 9 Apr 2021 13:27:01 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] arm64: Detect FTRACE cases that make the
 stack trace unreliable
Message-ID: <20210409122701.GB51636@C02TD0UTHF1T.local>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210405204313.21346-4-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405204313.21346-4-madvenka@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Apr 05, 2021 at 03:43:12PM -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> When CONFIG_DYNAMIC_FTRACE_WITH_REGS is enabled and tracing is activated
> for a function, the ftrace infrastructure is called for the function at
> the very beginning. Ftrace creates two frames:
> 
> 	- One for the traced function
> 
> 	- One for the caller of the traced function
> 
> That gives a reliable stack trace while executing in the ftrace code. When
> ftrace returns to the traced function, the frames are popped and everything
> is back to normal.
> 
> However, in cases like live patch, a tracer function may redirect execution
> to a different function when it returns. A stack trace taken while still in
> the tracer function will not show the target function. The target function
> is the real function that we want to track.
> 
> So, if an FTRACE frame is detected on the stack, just mark the stack trace
> as unreliable. The detection is done by checking the return PC against
> FTRACE trampolines.
> 
> Also, the Function Graph Tracer modifies the return address of a traced
> function to a return trampoline to gather tracing data on function return.
> Stack traces taken from that trampoline and functions it calls are
> unreliable as the original return address may not be available in
> that context. Mark the stack trace unreliable accordingly.
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  arch/arm64/kernel/entry-ftrace.S | 12 +++++++
>  arch/arm64/kernel/stacktrace.c   | 61 ++++++++++++++++++++++++++++++++
>  2 files changed, 73 insertions(+)
> 
> diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
> index b3e4f9a088b1..1f0714a50c71 100644
> --- a/arch/arm64/kernel/entry-ftrace.S
> +++ b/arch/arm64/kernel/entry-ftrace.S
> @@ -86,6 +86,18 @@ SYM_CODE_START(ftrace_caller)
>  	b	ftrace_common
>  SYM_CODE_END(ftrace_caller)
>  
> +/*
> + * A stack trace taken from anywhere in the FTRACE trampoline code should be
> + * considered unreliable as a tracer function (patched at ftrace_call) could
> + * potentially set pt_regs->pc and redirect execution to a function different
> + * than the traced function. E.g., livepatch.

IIUC the issue here that we have two copies of the pc: one in the regs,
and one in a frame record, and so after the update to the regs, the
frame record is stale.

This is something that we could fix by having
ftrace_instruction_pointer_set() set both.

However, as noted elsewhere there are other issues which mean we'd still
need special unwinding code for this.

Thanks,
Mark.

> + *
> + * No stack traces are taken in this FTRACE trampoline assembly code. But
> + * they can be taken from C functions that get called from here. The unwinder
> + * checks if a return address falls in this FTRACE trampoline code. See
> + * stacktrace.c. If function calls in this code are changed, please keep the
> + * special_functions[] array in stacktrace.c in sync.
> + */
>  SYM_CODE_START(ftrace_common)
>  	sub	x0, x30, #AARCH64_INSN_SIZE	// ip (callsite's BL insn)
>  	mov	x1, x9				// parent_ip (callsite's LR)
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index fb11e4372891..7a3c638d4aeb 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -51,6 +51,52 @@ struct function_range {
>   * unreliable. Breakpoints are used for executing probe code. Stack traces
>   * taken while in the probe code will show an EL1 frame and will be considered
>   * unreliable. This is correct behavior.
> + *
> + * FTRACE
> + * ======
> + *
> + * When CONFIG_DYNAMIC_FTRACE_WITH_REGS is enabled, the FTRACE trampoline code
> + * is called from a traced function even before the frame pointer prolog.
> + * FTRACE sets up two stack frames (one for the traced function and one for
> + * its caller) so that the unwinder can provide a sensible stack trace for
> + * any tracer function called from the FTRACE trampoline code.
> + *
> + * There are two cases where the stack trace is not reliable.
> + *
> + * (1) The task gets preempted before the two frames are set up. Preemption
> + *     involves an interrupt which is an EL1 exception. The unwinder already
> + *     handles EL1 exceptions.
> + *
> + * (2) The tracer function that gets called by the FTRACE trampoline code
> + *     changes the return PC (e.g., livepatch).
> + *
> + *     Not all tracer functions do that. But to err on the side of safety,
> + *     consider the stack trace as unreliable in all cases.
> + *
> + * When Function Graph Tracer is used, FTRACE modifies the return address of
> + * the traced function in its stack frame to an FTRACE return trampoline
> + * (return_to_handler). When the traced function returns, control goes to
> + * return_to_handler. return_to_handler calls FTRACE to gather tracing data
> + * and to obtain the original return address. Then, return_to_handler returns
> + * to the original return address.
> + *
> + * There are two cases to consider from a stack trace reliability point of
> + * view:
> + *
> + * (1) Stack traces taken within the traced function (and functions that get
> + *     called from there) will show return_to_handler instead of the original
> + *     return address. The original return address can be obtained from FTRACE.
> + *     The unwinder already obtains it and modifies the return PC in its copy
> + *     of the stack frame to the original return address. So, this is handled.
> + *
> + * (2) return_to_handler calls FTRACE as mentioned before. FTRACE discards
> + *     the record of the original return address along the way as it does not
> + *     need to maintain it anymore. This means that the unwinder cannot get
> + *     the original return address beyond that point while the task is still
> + *     executing in return_to_handler. So, consider the stack trace unreliable
> + *     if return_to_handler is detected on the stack.
> + *
> + * NOTE: The unwinder must do (1) before (2).
>   */
>  static struct function_range	special_functions[] = {
>  	/*
> @@ -64,6 +110,21 @@ static struct function_range	special_functions[] = {
>  	{ (unsigned long) el1_fiq_invalid, 0 },
>  	{ (unsigned long) el1_error_invalid, 0 },
>  
> +	/*
> +	 * FTRACE trampolines.
> +	 *
> +	 * Tracer function gets patched at the label ftrace_call. Its return
> +	 * address is the next instruction address.
> +	 */
> +#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
> +	{ (unsigned long) ftrace_call + 4, 0 },
> +#endif
> +
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	{ (unsigned long) ftrace_graph_caller, 0 },
> +	{ (unsigned long) return_to_handler, 0 },
> +#endif
> +
>  	{ /* sentinel */ }
>  };
>  
> -- 
> 2.25.1
> 
