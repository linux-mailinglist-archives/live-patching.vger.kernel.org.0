Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA45323BD1
	for <lists+live-patching@lfdr.de>; Wed, 24 Feb 2021 13:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbhBXMSK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 24 Feb 2021 07:18:10 -0500
Received: from foss.arm.com ([217.140.110.172]:56500 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232564AbhBXMSI (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 24 Feb 2021 07:18:08 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1AF61FB;
        Wed, 24 Feb 2021 04:17:21 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.52.137])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BEEA03F73B;
        Wed, 24 Feb 2021 04:17:19 -0800 (PST)
Date:   Wed, 24 Feb 2021 12:17:16 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/1] arm64: Unwinder enhancements for reliable
 stack trace
Message-ID: <20210224121716.GE50741@C02TD0UTHF1T.local>
References: <bc4761a47ad08ab7fdd555fc8094beb8fc758d33>
 <20210223181243.6776-1-madvenka@linux.microsoft.com>
 <20210223181243.6776-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223181243.6776-2-madvenka@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Madhavan,

As Mark Brown says, I think this needs to be split into several
patches. i have some comments on the general approach, but I'll save
in-depth review until this has been split.

On Tue, Feb 23, 2021 at 12:12:43PM -0600, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Unwinder changes
> ================
> 
> 	Termination
> 	===========
> 
> 	Currently, the unwinder terminates when both the FP (frame pointer)
> 	and the PC (return address) of a frame are 0. But a frame could get
> 	corrupted and zeroed. There needs to be a better check.
> 
> 	The following special terminating frame and function have been
> 	defined for this purpose:
> 
> 	const u64    arm64_last_frame[2] __attribute__ ((aligned (16)));
> 
> 	void arm64_last_func(void)
> 	{
> 	}
> 
> 	So, set the FP to arm64_last_frame and the PC to arm64_last_func in
> 	the bottom most frame.

My expectation was that we'd do this per-task, creating an empty frame
record (i.e. with fp=NULL and lr=NULL) on the task's stack at the
instant it was created, and chaining this into x29. That way the address
is known (since it can be derived from the task), and the frame will
also implicitly check that the callchain terminates on the task stack
without loops. That also means that we can use it to detect the entry
code going wrong (e.g. if the SP gets corrupted), since in that case the
entry code would place the record at a different location.

> 
> 	Exception/Interrupt detection
> 	=============================
> 
> 	An EL1 exception renders the stack trace unreliable as it can happen
> 	anywhere including the frame pointer prolog and epilog. The
> 	unwinder needs to be able to detect the exception on the stack.
> 
> 	Currently, the EL1 exception handler sets up pt_regs on the stack
> 	and chains pt_regs->stackframe with the other frames on the stack.
> 	But, the unwinder does not know where this exception frame is in
> 	the stack trace.
> 
> 	Set the LSB of the exception frame FP to allow the unwinder to
> 	detect the exception frame. When the unwinder detects the frame,
> 	it needs to make sure that it is really an exception frame and
> 	not the result of any stack corruption.

I'm not keen on messing with the encoding of the frame record as this
will break external unwinders (e.g. using GDB on a kernel running under
QEMU). I'd rather that we detected the exception boundary based on the
LR, similar to what we did in commit:

  7326749801396105 ("arm64: unwind: reference pt_regs via embedded stack frame")

... I reckon once we've moved the last of the exception triage out to C
this will be relatively simple, since all of the exception handlers will
look like:

| SYM_CODE_START_LOCAL(elX_exception)
| 	kernel_entry X
| 	mov	x0, sp
| 	bl	elX_exception_handler
| 	kernel_exit X
| SYM_CODE_END(elX_exception)

... and so we just need to identify the set of elX_exception functions
(which we'll never expect to take exceptions from directly). We could be
strict and reject unwinding into arbitrary bits of the entry code (e.g.
if we took an unexpected exception), and only permit unwinding to the
BL.

> 	It can do this if the FP and PC are also recorded elsewhere in the
> 	pt_regs for comparison. Currently, the FP is also stored in
> 	regs->regs[29]. The PC is stored in regs->pc. However, regs->pc can
> 	be changed by lower level functions.
> 
> 	Create a new field, pt_regs->orig_pc, and record the return address
> 	PC there. With this, the unwinder can validate the exception frame
> 	and set a flag so that the caller of the unwinder can know when
> 	an exception frame is encountered.

I don't understand the case you're trying to solve here. When is
regs->pc changed in a way that's problematic?

> 	Unwinder return value
> 	=====================
> 
> 	Currently, the unwinder returns -EINVAL for stack trace termination
> 	as well as stack trace error. Return -ENOENT for stack trace
> 	termination and -EINVAL for error to disambiguate. This idea has
> 	been borrowed from Mark Brown.

IIRC Mark Brown already has a patch for this (and it could be queued on
its own if it hasn't already been).

Thanks,
Mark.

> 
> Reliable stack trace function
> =============================
> 
> Implement arch_stack_walk_reliable(). This function walks the stack like
> the existing stack trace functions with a couple of additional checks:
> 
> 	Return address check
> 	--------------------
> 
> 	For each frame, check the return address to see if it is a
> 	proper kernel text address. If not, return -EINVAL.
> 
> 	Exception frame check
> 	---------------------
> 
> 	Check each frame to see if it is an EL1 exception frame. If it is,
> 	return -EINVAL.
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  arch/arm64/include/asm/processor.h  |   2 +
>  arch/arm64/include/asm/ptrace.h     |   7 ++
>  arch/arm64/include/asm/stacktrace.h |   5 ++
>  arch/arm64/kernel/asm-offsets.c     |   1 +
>  arch/arm64/kernel/entry.S           |  14 +++-
>  arch/arm64/kernel/head.S            |   8 +--
>  arch/arm64/kernel/process.c         |  12 ++++
>  arch/arm64/kernel/stacktrace.c      | 103 +++++++++++++++++++++++++---
>  8 files changed, 137 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> index ca2cd75d3286..d268c74d262e 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -195,6 +195,8 @@ static inline void start_thread_common(struct pt_regs *regs, unsigned long pc)
>  	memset(regs, 0, sizeof(*regs));
>  	forget_syscall(regs);
>  	regs->pc = pc;
> +	regs->stackframe[0] = (u64) arm64_last_frame;
> +	regs->stackframe[1] = (u64) arm64_last_func;
>  
>  	if (system_uses_irq_prio_masking())
>  		regs->pmr_save = GIC_PRIO_IRQON;
> diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
> index e58bca832dff..a15750a9f6e5 100644
> --- a/arch/arm64/include/asm/ptrace.h
> +++ b/arch/arm64/include/asm/ptrace.h
> @@ -201,8 +201,15 @@ struct pt_regs {
>  	/* Only valid for some EL1 exceptions. */
>  	u64 lockdep_hardirqs;
>  	u64 exit_rcu;
> +
> +	/* Only valid for EL1 exceptions. */
> +	u64 orig_pc;
> +	u64 unused1;
>  };
>  
> +extern const u64 arm64_last_frame[2];
> +extern void arm64_last_func(void);
> +
>  static inline bool in_syscall(struct pt_regs const *regs)
>  {
>  	return regs->syscallno != NO_SYSCALL;
> diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
> index eb29b1fe8255..9760ceddbd78 100644
> --- a/arch/arm64/include/asm/stacktrace.h
> +++ b/arch/arm64/include/asm/stacktrace.h
> @@ -49,6 +49,9 @@ struct stack_info {
>   *
>   * @graph:       When FUNCTION_GRAPH_TRACER is selected, holds the index of a
>   *               replacement lr value in the ftrace graph stack.
> + *
> + * @exception_frame
> + *		EL1 exception frame.
>   */
>  struct stackframe {
>  	unsigned long fp;
> @@ -59,6 +62,7 @@ struct stackframe {
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  	int graph;
>  #endif
> +	bool exception_frame;
>  };
>  
>  extern int unwind_frame(struct task_struct *tsk, struct stackframe *frame);
> @@ -169,6 +173,7 @@ static inline void start_backtrace(struct stackframe *frame,
>  	bitmap_zero(frame->stacks_done, __NR_STACK_TYPES);
>  	frame->prev_fp = 0;
>  	frame->prev_type = STACK_TYPE_UNKNOWN;
> +	frame->exception_frame = false;
>  }
>  
>  #endif	/* __ASM_STACKTRACE_H */
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index 301784463587..a9fbe1ca6d8a 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -75,6 +75,7 @@ int main(void)
>    DEFINE(S_SDEI_TTBR1,		offsetof(struct pt_regs, sdei_ttbr1));
>    DEFINE(S_PMR_SAVE,		offsetof(struct pt_regs, pmr_save));
>    DEFINE(S_STACKFRAME,		offsetof(struct pt_regs, stackframe));
> +  DEFINE(S_ORIG_PC,		offsetof(struct pt_regs, orig_pc));
>    DEFINE(PT_REGS_SIZE,		sizeof(struct pt_regs));
>    BLANK();
>  #ifdef CONFIG_COMPAT
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index c9bae73f2621..b2d6c73dd054 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -264,10 +264,21 @@ alternative_else_nop_endif
>  	 * In order to be able to dump the contents of struct pt_regs at the
>  	 * time the exception was taken (in case we attempt to walk the call
>  	 * stack later), chain it together with the stack frames.
> +	 *
> +	 * Set up a synthetic EL0 frame such that the unwinder can recognize
> +	 * it and stop the unwind.
> +	 *
> +	 * Set up a synthetic EL1 frame such that the unwinder can recognize
> +	 * it. For a reliable stack trace, the unwinder stops here. Else, it
> +	 * continues. Also, record the return address in regs->orig_pc for
> +	 * the unwinder's benefit because regs->pc can be changed.
>  	 */
>  	.if \el == 0
> -	stp	xzr, xzr, [sp, #S_STACKFRAME]
> +	ldr	x29, =arm64_last_frame
> +	ldr	x17, =arm64_last_func
> +	stp	x29, x17, [sp, #S_STACKFRAME]
>  	.else
> +	orr	x29, x29, #1
>  	stp	x29, x22, [sp, #S_STACKFRAME]
>  	.endif
>  	add	x29, sp, #S_STACKFRAME
> @@ -279,6 +290,7 @@ alternative_else_nop_endif
>  #endif
>  
>  	stp	x22, x23, [sp, #S_PC]
> +	str	x22, [sp, #S_ORIG_PC]
>  
>  	/* Not in a syscall by default (el0_svc overwrites for real syscall) */
>  	.if	\el == 0
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index a0dc987724ed..2cce019f29fa 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -448,8 +448,8 @@ SYM_FUNC_START_LOCAL(__primary_switched)
>  0:
>  #endif
>  	add	sp, sp, #16
> -	mov	x29, #0
> -	mov	x30, #0
> +	ldr	x29, =arm64_last_frame
> +	ldr	x30, =arm64_last_func
>  	b	start_kernel
>  SYM_FUNC_END(__primary_switched)
>  
> @@ -644,8 +644,8 @@ SYM_FUNC_START_LOCAL(__secondary_switched)
>  	cbz	x2, __secondary_too_slow
>  	msr	sp_el0, x2
>  	scs_load x2, x3
> -	mov	x29, #0
> -	mov	x30, #0
> +	ldr	x29, =arm64_last_frame
> +	ldr	x30, =arm64_last_func
>  
>  #ifdef CONFIG_ARM64_PTR_AUTH
>  	ptrauth_keys_init_cpu x2, x3, x4, x5
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 6616486a58fe..bac13fc33914 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -380,6 +380,12 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
>  
>  asmlinkage void ret_from_fork(void) asm("ret_from_fork");
>  
> +const u64	arm64_last_frame[2] __attribute__ ((aligned (16)));
> +
> +void arm64_last_func(void)
> +{
> +}
> +
>  int copy_thread(unsigned long clone_flags, unsigned long stack_start,
>  		unsigned long stk_sz, struct task_struct *p, unsigned long tls)
>  {
> @@ -437,6 +443,12 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
>  	}
>  	p->thread.cpu_context.pc = (unsigned long)ret_from_fork;
>  	p->thread.cpu_context.sp = (unsigned long)childregs;
> +	/*
> +	 * Set up a special termination stack frame for the task.
> +	 */
> +	p->thread.cpu_context.fp = (unsigned long)childregs->stackframe;
> +	childregs->stackframe[0] = (u64) arm64_last_frame;
> +	childregs->stackframe[1] = (u64) arm64_last_func;
>  
>  	ptrace_hw_copy_thread(p);
>  
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index fa56af1a59c3..26ac4dd54eaf 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -18,6 +18,60 @@
>  #include <asm/stack_pointer.h>
>  #include <asm/stacktrace.h>
>  
> +static notrace struct pt_regs *get_frame_regs(struct task_struct *task,
> +					      struct stackframe *frame)
> +{
> +	unsigned long stackframe, regs_start, regs_end;
> +	struct stack_info info;
> +
> +	stackframe = frame->prev_fp;
> +	if (!stackframe)
> +		return NULL;
> +
> +	(void) on_accessible_stack(task, stackframe, &info);
> +
> +	regs_start = stackframe - offsetof(struct pt_regs, stackframe);
> +	if (regs_start < info.low)
> +		return NULL;
> +	regs_end = regs_start + sizeof(struct pt_regs);
> +	if (regs_end > info.high)
> +		return NULL;
> +	return (struct pt_regs *) regs_start;
> +}
> +
> +static notrace int update_frame(struct task_struct *task,
> +				struct stackframe *frame)
> +{
> +	unsigned long lsb = frame->fp & 0xf;
> +	unsigned long fp = frame->fp & ~lsb;
> +	unsigned long pc = frame->pc;
> +	struct pt_regs *regs;
> +
> +	frame->exception_frame = false;
> +
> +	if (fp == (unsigned long) arm64_last_frame &&
> +	    pc == (unsigned long) arm64_last_func)
> +		return -ENOENT;
> +
> +	if (!lsb)
> +		return 0;
> +	if (lsb != 1)
> +		return -EINVAL;
> +
> +	/*
> +	 * This looks like an EL1 exception frame.
> +	 * Make sure the frame matches the EL1 pt_regs.
> +	 */
> +	regs = get_frame_regs(task, frame);
> +	if (!regs || fp != READ_ONCE_NOCHECK(regs->regs[29]) ||
> +	   pc != regs->orig_pc)
> +		return -EINVAL;
> +
> +	frame->exception_frame = true;
> +	frame->fp = fp;
> +	return 0;
> +}
> +
>  /*
>   * AArch64 PCS assigns the frame pointer to x29.
>   *
> @@ -104,16 +158,7 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>  
>  	frame->pc = ptrauth_strip_insn_pac(frame->pc);
>  
> -	/*
> -	 * Frames created upon entry from EL0 have NULL FP and PC values, so
> -	 * don't bother reporting these. Frames created by __noreturn functions
> -	 * might have a valid FP even if PC is bogus, so only terminate where
> -	 * both are NULL.
> -	 */
> -	if (!frame->fp && !frame->pc)
> -		return -EINVAL;
> -
> -	return 0;
> +	return update_frame(tsk, frame);
>  }
>  NOKPROBE_SYMBOL(unwind_frame);
>  
> @@ -217,4 +262,42 @@ void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
>  	walk_stackframe(task, &frame, consume_entry, cookie);
>  }
>  
> +int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
> +			      void *cookie, struct task_struct *task)
> +{
> +	struct stackframe frame;
> +	int ret = 0;
> +
> +	if (task == current) {
> +		start_backtrace(&frame,
> +				(unsigned long)__builtin_frame_address(0),
> +				(unsigned long)arch_stack_walk_reliable);
> +	} else {
> +		start_backtrace(&frame, thread_saved_fp(task),
> +				thread_saved_pc(task));
> +	}
> +
> +	while (!ret) {
> +		/*
> +		 * If the task encountered an EL1 exception, the stack trace
> +		 * is unreliable.
> +		 */
> +		if (frame.exception_frame)
> +			return -EINVAL;
> +
> +		/*
> +		 * A NULL or invalid return address probably means there's
> +		 * some generated code which __kernel_text_address() doesn't
> +		 * know about.
> +		 */
> +		if (!__kernel_text_address(frame.pc))
> +			return -EINVAL;
> +		if (!consume_entry(cookie, frame.pc))
> +			return -EINVAL;
> +		ret = unwind_frame(task, &frame);
> +	}
> +
> +	return ret == -ENOENT ? 0 : -EINVAL;
> +}
> +
>  #endif
> -- 
> 2.25.1
> 
