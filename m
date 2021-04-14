Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9678335F32A
	for <lists+live-patching@lfdr.de>; Wed, 14 Apr 2021 14:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350684AbhDNMJd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Apr 2021 08:09:33 -0400
Received: from linux.microsoft.com ([13.77.154.182]:42242 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350681AbhDNMJb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Apr 2021 08:09:31 -0400
Received: from [192.168.254.32] (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id C1CE120B8001;
        Wed, 14 Apr 2021 05:09:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C1CE120B8001
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618402150;
        bh=v0ULWuQjUPYwa15zeI0R/EsTera5cyCTMJvOs4xIdvc=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=RA8ZE1f1UgKRggZIoza2duaJ2xS8CVO+xzv6iBgiZXQQAv5rEjZLdF3FvjOPvpGt7
         TH9zkAHuPVcUc42Jbb6Zbkgnj1Hc/fTh9zTYtN2h9i5um49c8FSMDxn42qf5Y/9HDW
         25Pkf0xjwxKl1OmhsCw1t7adgnxBObu7r3TMjaQA=
Subject: Re: [RFC PATCH v2 1/1] arm64: Implement stack trace termination
 record
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <659f3d5cc025896ba4c49aea431aa8b1abc2b741>
 <20210402032404.47239-1-madvenka@linux.microsoft.com>
 <20210402032404.47239-2-madvenka@linux.microsoft.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <dfa80040-8ac2-3694-4f69-a10b0e5dd959@linux.microsoft.com>
Date:   Wed, 14 Apr 2021 07:09:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210402032404.47239-2-madvenka@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Mark Rutland, Mark Brown,

Could you take a look at this version for proper stack termination and let me know
what you think?

Thanks!

Madhavan

On 4/1/21 10:24 PM, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Reliable stacktracing requires that we identify when a stacktrace is
> terminated early. We can do this by ensuring all tasks have a final
> frame record at a known location on their task stack, and checking
> that this is the final frame record in the chain.
> 
> Kernel Tasks
> ============
> 
> All tasks except the idle task have a pt_regs structure right after the
> task stack. This is called the task pt_regs. The pt_regs structure has a
> special stackframe field. Make this stackframe field the final frame in the
> task stack. This needs to be done in copy_thread() which initializes a new
> task's pt_regs and initial CPU context.
> 
> For the idle task, there is no task pt_regs. For our purpose, we need one.
> So, create a pt_regs just like other kernel tasks and make
> pt_regs->stackframe the final frame in the idle task stack. This needs to be
> done at two places:
> 
> 	- On the primary CPU, the boot task runs. It calls start_kernel()
> 	  and eventually becomes the idle task for the primary CPU. Just
> 	  before start_kernel() is called, set up the final frame.
> 
> 	- On each secondary CPU, a startup task runs that calls
> 	  secondary_startup_kernel() and eventually becomes the idle task
> 	  on the secondary CPU. Just before secondary_start_kernel() is
> 	  called, set up the final frame.
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
> task pt_regs->stackframe as the final frame in the EL0 exception stack.
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
>  arch/arm64/kernel/head.S       | 29 +++++++++++++++++++++++------
>  arch/arm64/kernel/process.c    |  5 +++++
>  arch/arm64/kernel/stacktrace.c | 10 +++++-----
>  4 files changed, 38 insertions(+), 14 deletions(-)
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
> index 840bda1869e9..743c019a42c7 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -393,6 +393,23 @@ SYM_FUNC_START_LOCAL(__create_page_tables)
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
> +	 * set up to be the final frame on the idle task stack just like
> +	 * all the other kernel tasks. This helps the unwinder to
> +	 * terminate the stack trace at a well-known stack offset.
> +	 */
> +	.macro setup_final_frame
> +	sub	sp, sp, #PT_REGS_SIZE
> +	stp	xzr, xzr, [sp, #S_STACKFRAME]
> +	add	x29, sp, #S_STACKFRAME
> +	.endm
> +
>  /*
>   * The following fragment of code is executed with the MMU enabled.
>   *
> @@ -447,9 +464,9 @@ SYM_FUNC_START_LOCAL(__primary_switched)
>  #endif
>  	bl	switch_to_vhe			// Prefer VHE if possible
>  	add	sp, sp, #16
> -	mov	x29, #0
> -	mov	x30, #0
> -	b	start_kernel
> +	setup_final_frame
> +	bl	start_kernel
> +	nop
>  SYM_FUNC_END(__primary_switched)
>  
>  	.pushsection ".rodata", "a"
> @@ -606,14 +623,14 @@ SYM_FUNC_START_LOCAL(__secondary_switched)
>  	cbz	x2, __secondary_too_slow
>  	msr	sp_el0, x2
>  	scs_load x2, x3
> -	mov	x29, #0
> -	mov	x30, #0
> +	setup_final_frame
>  
>  #ifdef CONFIG_ARM64_PTR_AUTH
>  	ptrauth_keys_init_cpu x2, x3, x4, x5
>  #endif
>  
> -	b	secondary_start_kernel
> +	bl	secondary_start_kernel
> +	nop
>  SYM_FUNC_END(__secondary_switched)
>  
>  SYM_FUNC_START_LOCAL(__secondary_too_slow)
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 325c83b1a24d..906baa232a89 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -437,6 +437,11 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
>  	}
>  	p->thread.cpu_context.pc = (unsigned long)ret_from_fork;
>  	p->thread.cpu_context.sp = (unsigned long)childregs;
> +	/*
> +	 * For the benefit of the unwinder, set up childregs->stackframe
> +	 * as the final frame for the new task.
> +	 */
> +	p->thread.cpu_context.fp = (unsigned long)childregs->stackframe;
>  
>  	ptrace_hw_copy_thread(p);
>  
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index ad20981dfda4..72f5af8c69dc 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -44,16 +44,16 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>  	unsigned long fp = frame->fp;
>  	struct stack_info info;
>  
> -	/* Terminal record; nothing to unwind */
> -	if (!fp)
> +	if (!tsk)
> +		tsk = current;
> +
> +	/* Final frame; nothing to unwind */
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
> 
