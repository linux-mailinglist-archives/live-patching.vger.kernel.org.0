Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5511C345C1B
	for <lists+live-patching@lfdr.de>; Tue, 23 Mar 2021 11:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhCWKn3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Mar 2021 06:43:29 -0400
Received: from foss.arm.com ([217.140.110.172]:43768 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230295AbhCWKm4 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Mar 2021 06:42:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A999E1042;
        Tue, 23 Mar 2021 03:42:55 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CDE633F719;
        Tue, 23 Mar 2021 03:42:53 -0700 (PDT)
Date:   Tue, 23 Mar 2021 10:42:51 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/8] arm64: Detect an EL1 exception frame and mark
 a stack trace unreliable
Message-ID: <20210323104251.GD95840@C02TD0UTHF1T.local>
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-5-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315165800.5948-5-madvenka@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Mar 15, 2021 at 11:57:56AM -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> EL1 exceptions can happen on any instruction including instructions in
> the frame pointer prolog or epilog. Depending on where exactly they happen,
> they could render the stack trace unreliable.
> 
> If an EL1 exception frame is found on the stack, mark the stack trace as
> unreliable.
> 
> Now, the EL1 exception frame is not at any well-known offset on the stack.
> It can be anywhere on the stack. In order to properly detect an EL1
> exception frame the following checks must be done:
> 
> 	- The frame type must be EL1_FRAME.
> 
> 	- When the register state is saved in the EL1 pt_regs, the frame
> 	  pointer x29 is saved in pt_regs->regs[29] and the return PC
> 	  is saved in pt_regs->pc. These must match with the current
> 	  frame.

Before you can do this, you need to reliably identify that you have a
pt_regs on the stack, but this patch uses a heuristic, which is not
reliable.

However, instead you can identify whether you're trying to unwind
through one of the EL1 entry functions, which tells you the same thing
without even having to look at the pt_regs.

We can do that based on the entry functions all being in .entry.text,
which we could further sub-divide to split the EL0 and EL1 entry
functions.

> 
> Interrupts encountered in kernel code are also EL1 exceptions. At the end
> of an interrupt, the interrupt handler checks if the current task must be
> preempted for any reason. If so, it calls the preemption code which takes
> the task off the CPU. A stack trace taken on the task after the preemption
> will show the EL1 frame and will be considered unreliable. This is correct
> behavior as preemption can happen practically at any point in code
> including the frame pointer prolog and epilog.
> 
> Breakpoints encountered in kernel code are also EL1 exceptions. The probing
> infrastructure uses breakpoints for executing probe code. While in the probe
> code, the stack trace will show an EL1 frame and will be considered
> unreliable. This is also correct behavior.
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  arch/arm64/include/asm/stacktrace.h |  2 +
>  arch/arm64/kernel/stacktrace.c      | 57 +++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
> index eb29b1fe8255..684f65808394 100644
> --- a/arch/arm64/include/asm/stacktrace.h
> +++ b/arch/arm64/include/asm/stacktrace.h
> @@ -59,6 +59,7 @@ struct stackframe {
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  	int graph;
>  #endif
> +	bool reliable;
>  };
>  
>  extern int unwind_frame(struct task_struct *tsk, struct stackframe *frame);
> @@ -169,6 +170,7 @@ static inline void start_backtrace(struct stackframe *frame,
>  	bitmap_zero(frame->stacks_done, __NR_STACK_TYPES);
>  	frame->prev_fp = 0;
>  	frame->prev_type = STACK_TYPE_UNKNOWN;
> +	frame->reliable = true;
>  }
>  
>  #endif	/* __ASM_STACKTRACE_H */
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index 504cd161339d..6ae103326f7b 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -18,6 +18,58 @@
>  #include <asm/stack_pointer.h>
>  #include <asm/stacktrace.h>
>  
> +static void check_if_reliable(unsigned long fp, struct stackframe *frame,
> +			      struct stack_info *info)
> +{
> +	struct pt_regs *regs;
> +	unsigned long regs_start, regs_end;
> +
> +	/*
> +	 * If the stack trace has already been marked unreliable, just
> +	 * return.
> +	 */
> +	if (!frame->reliable)
> +		return;
> +
> +	/*
> +	 * Assume that this is an intermediate marker frame inside a pt_regs
> +	 * structure created on the stack and get the pt_regs pointer. Other
> +	 * checks will be done below to make sure that this is a marker
> +	 * frame.
> +	 */

Sorry, but NAK to this approach specifically. This isn't reliable (since
it can be influenced by arbitrary data on the stack), and it's far more
complicated than identifying the entry functions specifically.

Thanks,
Mark.

> +	regs_start = fp - offsetof(struct pt_regs, stackframe);
> +	if (regs_start < info->low)
> +		return;
> +	regs_end = regs_start + sizeof(*regs);
> +	if (regs_end > info->high)
> +		return;
> +	regs = (struct pt_regs *) regs_start;
> +
> +	/*
> +	 * When an EL1 exception happens, a pt_regs structure is created
> +	 * on the stack and the register state is recorded. Part of the
> +	 * state is the FP and PC at the time of the exception.
> +	 *
> +	 * In addition, the FP and PC are also stored in pt_regs->stackframe
> +	 * and pt_regs->stackframe is chained with other frames on the stack.
> +	 * This is so that the interrupted function shows up in the stack
> +	 * trace.
> +	 *
> +	 * The exception could have happened during the frame pointer
> +	 * prolog or epilog. This could result in a missing frame in
> +	 * the stack trace so that the caller of the interrupted
> +	 * function does not show up in the stack trace.
> +	 *
> +	 * So, mark the stack trace as unreliable if an EL1 frame is
> +	 * detected.
> +	 */
> +	if (regs->frame_type == EL1_FRAME && regs->pc == frame->pc &&
> +	    regs->regs[29] == frame->fp) {
> +		frame->reliable = false;
> +		return;
> +	}
> +}
> +
>  /*
>   * AArch64 PCS assigns the frame pointer to x29.
>   *
> @@ -114,6 +166,11 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>  
>  	frame->pc = ptrauth_strip_insn_pac(frame->pc);
>  
> +	/*
> +	 * Check for features that render the stack trace unreliable.
> +	 */
> +	check_if_reliable(fp, frame, &info);
> +
>  	return 0;
>  }
>  NOKPROBE_SYMBOL(unwind_frame);
> -- 
> 2.25.1
> 
