Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F7334CEEF
	for <lists+live-patching@lfdr.de>; Mon, 29 Mar 2021 13:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhC2L2K (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 29 Mar 2021 07:28:10 -0400
Received: from foss.arm.com ([217.140.110.172]:48490 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232386AbhC2L1r (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 29 Mar 2021 07:27:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE4D1142F;
        Mon, 29 Mar 2021 04:27:46 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.24.130])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D52AC3F7D7;
        Mon, 29 Mar 2021 04:27:44 -0700 (PDT)
Date:   Mon, 29 Mar 2021 12:27:33 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/1] arm64: Implement stack trace termination
 record
Message-ID: <20210329112724.GA93057@C02TD0UTHF1T.local>
References: <b6144b5b1dc66bf775fe66374bba31af7e5f1d54>
 <20210324184607.120948-1-madvenka@linux.microsoft.com>
 <20210324184607.120948-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324184607.120948-2-madvenka@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Madhavan,

Overall this looks pretty good; I have a few comments below.

On Wed, Mar 24, 2021 at 01:46:07PM -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> The unwinder needs to be able to reliably tell when it has reached the end
> of a stack trace. One way to do this is to have the last stack frame at a
> fixed offset from the base of the task stack. When the unwinder reaches
> that offset, it knows it is done.

To make the relationship with reliable stacktrace clearer, how about:

| Reliable stacktracing requires that we identify when a stacktrace is
| terminated early. We can do this by ensuring all tasks have a final
| frame record at a known location on their task stack, and checking
| that this is the final frame record in the chain.

Currently we use inconsistent terminology to refer to the final frame
record, and it would be good if we could be consistent. The existing
code uses "terminal record" (which I appreciate isn't clear), and this
series largely uses "last frame". It'd be nice to make that consistent.

For clarity could we please use "final" rather than "last"? That avoids
the ambiguity of "last" also meaning "previous".

e.g. below this'd mean having `setup_final_frame`.

> 
> Kernel Tasks
> ============
> 
> All tasks except the idle task have a pt_regs structure right after the
> task stack. This is called the task pt_regs. The pt_regs structure has a
> special stackframe field. Make this stackframe field the last frame in the
> task stack. This needs to be done in copy_thread() which initializes a new
> task's pt_regs and initial CPU context.
> 
> For the idle task, there is no task pt_regs. For our purpose, we need one.
> So, create a pt_regs just like other kernel tasks and make
> pt_regs->stackframe the last frame in the idle task stack. This needs to be
> done at two places:
> 
> 	- On the primary CPU, the boot task runs. It calls start_kernel()
> 	  and eventually becomes the idle task for the primary CPU. Just
> 	  before start_kernel() is called, set up the last frame.
> 
> 	- On each secondary CPU, a startup task runs that calls
> 	  secondary_startup_kernel() and eventually becomes the idle task
> 	  on the secondary CPU. Just before secondary_start_kernel() is
> 	  called, set up the last frame.
> 
> User Tasks
> ==========
> 
> User tasks are initially set up like kernel tasks when they are created.
> Then, they return to userland after fork via ret_from_fork(). After that,
> they enter the kernel only on an EL0 exception. (In arm64, system calls are
> also EL0 exceptions). The EL0 exception handler stores state in the task
> pt_regs and calls different functions based on the type of exception. The
> stack trace for an EL0 exception must end at the task pt_regs. So, make
> task pt_regs->stackframe as the last frame in the EL0 exception stack.
> 
> In summary, task pt_regs->stackframe is where a successful stack trace ends.
> 
> Stack trace termination
> =======================
> 
> In the unwinder, terminate the stack trace successfully when
> task_pt_regs(task)->stackframe is reached. For stack traces in the kernel,
> this will correctly terminate the stack trace at the right place.
> 
> However, debuggers terminate the stack trace when FP == 0. In the
> pt_regs->stackframe, the PC is 0 as well. So, stack traces taken in the
> debugger may print an extra record 0x0 at the end. While this is not
> pretty, this does not do any harm. This is a small price to pay for
> having reliable stack trace termination in the kernel.
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  arch/arm64/kernel/entry.S      |  8 +++++---
>  arch/arm64/kernel/head.S       | 28 ++++++++++++++++++++++++----
>  arch/arm64/kernel/process.c    |  5 +++++
>  arch/arm64/kernel/stacktrace.c |  8 ++++----
>  4 files changed, 38 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index a31a0a713c85..e2dc2e998934 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -261,16 +261,18 @@ alternative_else_nop_endif
>  	stp	lr, x21, [sp, #S_LR]
>  
>  	/*
> -	 * For exceptions from EL0, terminate the callchain here.
> +	 * For exceptions from EL0, terminate the callchain here at
> +	 * task_pt_regs(current)->stackframe.
> +	 *
>  	 * For exceptions from EL1, create a synthetic frame record so the
>  	 * interrupted code shows up in the backtrace.
>  	 */
>  	.if \el == 0
> -	mov	x29, xzr
> +	stp	xzr, xzr, [sp, #S_STACKFRAME]
>  	.else
>  	stp	x29, x22, [sp, #S_STACKFRAME]
> -	add	x29, sp, #S_STACKFRAME
>  	.endif
> +	add	x29, sp, #S_STACKFRAME
>  
>  #ifdef CONFIG_ARM64_SW_TTBR0_PAN
>  alternative_if_not ARM64_HAS_PAN
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 840bda1869e9..b8003fb9cfa5 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -393,6 +393,28 @@ SYM_FUNC_START_LOCAL(__create_page_tables)
>  	ret	x28
>  SYM_FUNC_END(__create_page_tables)
>  
> +	/*
> +	 * The boot task becomes the idle task for the primary CPU. The
> +	 * CPU startup task on each secondary CPU becomes the idle task
> +	 * for the secondary CPU.
> +	 *
> +	 * The idle task does not require pt_regs. But create a dummy
> +	 * pt_regs so that task_pt_regs(idle_task)->stackframe can be
> +	 * set up to be the last frame on the idle task stack just like
> +	 * all the other kernel tasks. This helps the unwinder to
> +	 * terminate the stack trace at a well-known stack offset.
> +	 *
> +	 * Also, set up the last return PC to be ret_from_fork() just
> +	 * like all the other kernel tasks so that the stack trace of
> +	 * all kernel tasks ends with the same function.
> +	 */
> +	.macro setup_last_frame
> +	sub	sp, sp, #PT_REGS_SIZE
> +	stp	xzr, xzr, [sp, #S_STACKFRAME]
> +	add	x29, sp, #S_STACKFRAME
> +	ldr	x30, =ret_from_fork
> +	.endm

Why do you need to put `ret_from_fork` into the chain here?

I'm not keen on adding synthetic entries to the trace; is there a
problem if we don't override x30 here?

Thanks,
Mark.

> +
>  /*
>   * The following fragment of code is executed with the MMU enabled.
>   *
> @@ -447,8 +469,7 @@ SYM_FUNC_START_LOCAL(__primary_switched)
>  #endif
>  	bl	switch_to_vhe			// Prefer VHE if possible
>  	add	sp, sp, #16
> -	mov	x29, #0
> -	mov	x30, #0
> +	setup_last_frame
>  	b	start_kernel
>  SYM_FUNC_END(__primary_switched)
>  
> @@ -606,8 +627,7 @@ SYM_FUNC_START_LOCAL(__secondary_switched)
>  	cbz	x2, __secondary_too_slow
>  	msr	sp_el0, x2
>  	scs_load x2, x3
> -	mov	x29, #0
> -	mov	x30, #0
> +	setup_last_frame
>  
>  #ifdef CONFIG_ARM64_PTR_AUTH
>  	ptrauth_keys_init_cpu x2, x3, x4, x5
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 325c83b1a24d..7ffa689e8b60 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -437,6 +437,11 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
>  	}
>  	p->thread.cpu_context.pc = (unsigned long)ret_from_fork;
>  	p->thread.cpu_context.sp = (unsigned long)childregs;
> +	/*
> +	 * For the benefit of the unwinder, set up childregs->stackframe
> +	 * as the last frame for the new task.
> +	 */
> +	p->thread.cpu_context.fp = (unsigned long)childregs->stackframe;
>  
>  	ptrace_hw_copy_thread(p);
>  
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index ad20981dfda4..a35b760a1892 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -44,16 +44,16 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>  	unsigned long fp = frame->fp;
>  	struct stack_info info;
>  
> +	if (!tsk)
> +		tsk = current;
> +
>  	/* Terminal record; nothing to unwind */
> -	if (!fp)
> +	if (fp == (unsigned long) task_pt_regs(tsk)->stackframe)
>  		return -ENOENT;
>  
>  	if (fp & 0xf)
>  		return -EINVAL;
>  
> -	if (!tsk)
> -		tsk = current;
> -
>  	if (!on_accessible_stack(tsk, fp, &info))
>  		return -EINVAL;
>  
> -- 
> 2.25.1
> 
