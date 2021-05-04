Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80159372CCF
	for <lists+live-patching@lfdr.de>; Tue,  4 May 2021 17:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbhEDPOm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 4 May 2021 11:14:42 -0400
Received: from foss.arm.com ([217.140.110.172]:59896 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230415AbhEDPOl (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 4 May 2021 11:14:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83CADD6E;
        Tue,  4 May 2021 08:13:46 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.1.6])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E64133F718;
        Tue,  4 May 2021 08:13:43 -0700 (PDT)
Date:   Tue, 4 May 2021 16:13:37 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com, broonie@kernel.org
Cc:     jpoimboe@redhat.com, jthierry@redhat.com, catalin.marinas@arm.com,
        will@kernel.org, jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] arm64: Implement stack trace termination record
Message-ID: <20210504151337.GA92881@C02TD0UTHF1T.local>
References: <80cac661608c8d3623328b37b9b1696f63f45968>
 <20210420184447.16306-1-madvenka@linux.microsoft.com>
 <20210420184447.16306-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420184447.16306-2-madvenka@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Madhavan,

Sorry for the long radiosilence on this. I finally had some time to take
a look, and this is pretty good!

We had to make some changes in the arm64 unwinder last week, as Leo Yan
reported an existing regression. I've rebased your patch atop that with
some additional fixups -- I've noted those below, with a copy of the
altered patch at the end of the mail. If you're happy with the result,
I'll ask Will and Catalin to queue that come -rc1.

I've also pushed that to my arm64/stacktrace-termination branch:

  https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=arm64/stacktrace-termination
  git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git arm64/stacktrace-termination

Mark (Brown), I've kept your Reviewed-by, since I don't think any of
those changes were against the spirit of that review. If you want that
dropped, please shout!

The conflicting commit (in the arm64 for-next/core branch) is:

  8533d5bfad41e74b ("arm64: stacktrace: restore terminal records")

If you want to check Leo's test case, be aware you'll also need commit:

  5fd65aeb22b72682i ("tracing: Fix stack trace event size")

... which made it into v5.12-rc6 (while the arm64 for-next/core branch
is based on v5.12-rc3).

On Tue, Apr 20, 2021 at 01:44:47PM -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 6acfc5e6b5e0..e677b9a2b8f8 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -263,16 +263,18 @@ alternative_else_nop_endif
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

In 8533d5bfad41e74b we made the same logic change, so now we only need
to update the comment.

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

I'd prefer to simplify this to:

        /*  
         * Create a final frame record at task_pt_regs(current)->stackframe, so
         * that the unwinder can identify the final frame record of any task by
         * its location in the task stack. We reserve the entire pt_regs space
         * for consistency with user tasks and other kernel threads.
         */

... saying `current` rather than `idle_task` makes it clear that this is
altering the current task's state, and so long as we note that we do
this when creating each task, we don't need to call out the idle tasks
specifically.

> +	.macro setup_final_frame
> +	sub	sp, sp, #PT_REGS_SIZE
> +	stp	xzr, xzr, [sp, #S_STACKFRAME]
> +	add	x29, sp, #S_STACKFRAME
> +	.endm

It's probably worth noting in the commit message that a stacktrace will
now include __primary_switched and __secondary_switched. I think that's
fine, but we should be explict that this is expected as it is a small
behavioural change.

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

I'd prefr to use ASM_BUG() here. That'll match what we do in entry.S,
and also catch any unexpected return.

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

Likewise, I'd prefer ASM_BUG() here.

>  SYM_FUNC_END(__secondary_switched)
>  
>  SYM_FUNC_START_LOCAL(__secondary_too_slow)
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 6e60aa3b5ea9..999711c55274 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -439,6 +439,11 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
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
> index d55bdfb7789c..774d9af2f0b6 100644
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
> +	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
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

This looks good. Commit 8533d5bfad41e74b made us check the unwound
frame's FP, but when we identify the frame by location rather than
contents we'll need to check the FP prior to unwinding as you have here.

---->8----
From eb795c46ad5d3c49c5401d5716c9674e52b22591 Mon Sep 17 00:00:00 2001
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Date: Tue, 20 Apr 2021 13:44:47 -0500
Subject: [PATCH] arm64: Implement stack trace termination record

Reliable stacktracing requires that we identify when a stacktrace is
terminated early. We can do this by ensuring all tasks have a final
frame record at a known location on their task stack, and checking
that this is the final frame record in the chain.

We'd like to use task_pt_regs(task)->stackframe as the final frame
record, as this is already setup upon exception entry from EL0. For
kernel tasks we need to consistently reserve the pt_regs and point x29
at this, which we can do with small changes to __primary_switched,
__secondary_switched, and copy_process().

Since the final frame record must be at a specific location, we must
create the final frame record in __primary_switched and
__secondary_switched rather than leaving this to start_kernel and
secondary_start_kernel. Thus, __primary_switched and
__secondary_switched will now show up in stacktraces for the idle tasks.

Since the final frame record is now identified by its location rather
than by its contents, we identify it at the start of unwind_frame(),
before we read any values from it.

External debuggers may terminate the stack trace when FP == 0. In the
pt_regs->stackframe, the PC is 0 as well. So, stack traces taken in the
debugger may print an extra record 0x0 at the end. While this is not
pretty, this does not do any harm. This is a small price to pay for
having reliable stack trace termination in the kernel. That said, gdb
does not show the extra record probably because it uses DWARF and not
frame pointers for stack traces.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
[Mark: rebase, use ASM_BUG(), update comments, update commit message]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/kernel/entry.S      |  2 +-
 arch/arm64/kernel/head.S       | 25 +++++++++++++++++++------
 arch/arm64/kernel/process.c    |  5 +++++
 arch/arm64/kernel/stacktrace.c | 16 +++++++---------
 4 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 806a39635482..a5bb8c9c8ace 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -283,7 +283,7 @@ alternative_else_nop_endif
 	stp	lr, x21, [sp, #S_LR]
 
 	/*
-	 * For exceptions from EL0, create a terminal frame record.
+	 * For exceptions from EL0, create a final frame record.
 	 * For exceptions from EL1, create a synthetic frame record so the
 	 * interrupted code shows up in the backtrace.
 	 */
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 96873dfa67fd..cc2d45d54838 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -16,6 +16,7 @@
 #include <asm/asm_pointer_auth.h>
 #include <asm/assembler.h>
 #include <asm/boot.h>
+#include <asm/bug.h>
 #include <asm/ptrace.h>
 #include <asm/asm-offsets.h>
 #include <asm/cache.h>
@@ -393,6 +394,18 @@ SYM_FUNC_START_LOCAL(__create_page_tables)
 	ret	x28
 SYM_FUNC_END(__create_page_tables)
 
+	/*
+	 * Create a final frame record at task_pt_regs(current)->stackframe, so
+	 * that the unwinder can identify the final frame record of any task by
+	 * its location in the task stack. We reserve the entire pt_regs space
+	 * for consistency with user tasks and kthreads.
+	 */
+	.macro setup_final_frame
+	sub	sp, sp, #PT_REGS_SIZE
+	stp	xzr, xzr, [sp, #S_STACKFRAME]
+	add	x29, sp, #S_STACKFRAME
+	.endm
+
 /*
  * The following fragment of code is executed with the MMU enabled.
  *
@@ -447,9 +460,9 @@ SYM_FUNC_START_LOCAL(__primary_switched)
 #endif
 	bl	switch_to_vhe			// Prefer VHE if possible
 	add	sp, sp, #16
-	mov	x29, #0
-	mov	x30, #0
-	b	start_kernel
+	setup_final_frame
+	bl	start_kernel
+	ASM_BUG()
 SYM_FUNC_END(__primary_switched)
 
 	.pushsection ".rodata", "a"
@@ -639,14 +652,14 @@ SYM_FUNC_START_LOCAL(__secondary_switched)
 	cbz	x2, __secondary_too_slow
 	msr	sp_el0, x2
 	scs_load x2, x3
-	mov	x29, #0
-	mov	x30, #0
+	setup_final_frame
 
 #ifdef CONFIG_ARM64_PTR_AUTH
 	ptrauth_keys_init_cpu x2, x3, x4, x5
 #endif
 
-	b	secondary_start_kernel
+	bl	secondary_start_kernel
+	ASM_BUG()
 SYM_FUNC_END(__secondary_switched)
 
 SYM_FUNC_START_LOCAL(__secondary_too_slow)
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 0da0fd4ed1d0..31d98fe2e303 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -433,6 +433,11 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
 	}
 	p->thread.cpu_context.pc = (unsigned long)ret_from_fork;
 	p->thread.cpu_context.sp = (unsigned long)childregs;
+	/*
+	 * For the benefit of the unwinder, set up childregs->stackframe
+	 * as the final frame for the new task.
+	 */
+	p->thread.cpu_context.fp = (unsigned long)childregs->stackframe;
 
 	ptrace_hw_copy_thread(p);
 
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index c22706aa32a1..1e4d44751492 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -68,12 +68,16 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 	unsigned long fp = frame->fp;
 	struct stack_info info;
 
-	if (fp & 0xf)
-		return -EINVAL;
-
 	if (!tsk)
 		tsk = current;
 
+	/* Final frame; nothing to unwind */
+	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
+		return -ENOENT;
+
+	if (fp & 0xf)
+		return -EINVAL;
+
 	if (!on_accessible_stack(tsk, fp, &info))
 		return -EINVAL;
 
@@ -128,12 +132,6 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 
 	frame->pc = ptrauth_strip_insn_pac(frame->pc);
 
-	/*
-	 * This is a terminal record, so we have finished unwinding.
-	 */
-	if (!frame->fp && !frame->pc)
-		return -ENOENT;
-
 	return 0;
 }
 NOKPROBE_SYMBOL(unwind_frame);
-- 
2.11.0

