Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A09C3480DF
	for <lists+live-patching@lfdr.de>; Wed, 24 Mar 2021 19:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237617AbhCXSrC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 24 Mar 2021 14:47:02 -0400
Received: from linux.microsoft.com ([13.77.154.182]:57482 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237587AbhCXSqh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 24 Mar 2021 14:46:37 -0400
Received: from x64host.home (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id A55A120B5681;
        Wed, 24 Mar 2021 11:46:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A55A120B5681
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1616611597;
        bh=O0Xo222j3HUUqYE2adi3j5rA6WqxDaOVPOHeGftjrmQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=VDTbhvoS2Y1trI16NROtHj/UZMJGrJ9AIY7JjFMdJFZIbgs3TAnneRMs/QWcezPCg
         msx0Km0tj9cpMNoXk8cxR3meguqewfKmXqcKcczV8oZKspBYVP/tiwWAyV9Ng9c0zK
         TTwgLoyzyPFOFWRfYT897U22AZ2/75Uu9sLwUWCM=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v1 1/1] arm64: Implement stack trace termination record
Date:   Wed, 24 Mar 2021 13:46:07 -0500
Message-Id: <20210324184607.120948-2-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210324184607.120948-1-madvenka@linux.microsoft.com>
References: <b6144b5b1dc66bf775fe66374bba31af7e5f1d54>
 <20210324184607.120948-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

The unwinder needs to be able to reliably tell when it has reached the end
of a stack trace. One way to do this is to have the last stack frame at a
fixed offset from the base of the task stack. When the unwinder reaches
that offset, it knows it is done.

Kernel Tasks
============

All tasks except the idle task have a pt_regs structure right after the
task stack. This is called the task pt_regs. The pt_regs structure has a
special stackframe field. Make this stackframe field the last frame in the
task stack. This needs to be done in copy_thread() which initializes a new
task's pt_regs and initial CPU context.

For the idle task, there is no task pt_regs. For our purpose, we need one.
So, create a pt_regs just like other kernel tasks and make
pt_regs->stackframe the last frame in the idle task stack. This needs to be
done at two places:

	- On the primary CPU, the boot task runs. It calls start_kernel()
	  and eventually becomes the idle task for the primary CPU. Just
	  before start_kernel() is called, set up the last frame.

	- On each secondary CPU, a startup task runs that calls
	  secondary_startup_kernel() and eventually becomes the idle task
	  on the secondary CPU. Just before secondary_start_kernel() is
	  called, set up the last frame.

User Tasks
==========

User tasks are initially set up like kernel tasks when they are created.
Then, they return to userland after fork via ret_from_fork(). After that,
they enter the kernel only on an EL0 exception. (In arm64, system calls are
also EL0 exceptions). The EL0 exception handler stores state in the task
pt_regs and calls different functions based on the type of exception. The
stack trace for an EL0 exception must end at the task pt_regs. So, make
task pt_regs->stackframe as the last frame in the EL0 exception stack.

In summary, task pt_regs->stackframe is where a successful stack trace ends.

Stack trace termination
=======================

In the unwinder, terminate the stack trace successfully when
task_pt_regs(task)->stackframe is reached. For stack traces in the kernel,
this will correctly terminate the stack trace at the right place.

However, debuggers terminate the stack trace when FP == 0. In the
pt_regs->stackframe, the PC is 0 as well. So, stack traces taken in the
debugger may print an extra record 0x0 at the end. While this is not
pretty, this does not do any harm. This is a small price to pay for
having reliable stack trace termination in the kernel.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/entry.S      |  8 +++++---
 arch/arm64/kernel/head.S       | 28 ++++++++++++++++++++++++----
 arch/arm64/kernel/process.c    |  5 +++++
 arch/arm64/kernel/stacktrace.c |  8 ++++----
 4 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index a31a0a713c85..e2dc2e998934 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -261,16 +261,18 @@ alternative_else_nop_endif
 	stp	lr, x21, [sp, #S_LR]
 
 	/*
-	 * For exceptions from EL0, terminate the callchain here.
+	 * For exceptions from EL0, terminate the callchain here at
+	 * task_pt_regs(current)->stackframe.
+	 *
 	 * For exceptions from EL1, create a synthetic frame record so the
 	 * interrupted code shows up in the backtrace.
 	 */
 	.if \el == 0
-	mov	x29, xzr
+	stp	xzr, xzr, [sp, #S_STACKFRAME]
 	.else
 	stp	x29, x22, [sp, #S_STACKFRAME]
-	add	x29, sp, #S_STACKFRAME
 	.endif
+	add	x29, sp, #S_STACKFRAME
 
 #ifdef CONFIG_ARM64_SW_TTBR0_PAN
 alternative_if_not ARM64_HAS_PAN
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 840bda1869e9..b8003fb9cfa5 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -393,6 +393,28 @@ SYM_FUNC_START_LOCAL(__create_page_tables)
 	ret	x28
 SYM_FUNC_END(__create_page_tables)
 
+	/*
+	 * The boot task becomes the idle task for the primary CPU. The
+	 * CPU startup task on each secondary CPU becomes the idle task
+	 * for the secondary CPU.
+	 *
+	 * The idle task does not require pt_regs. But create a dummy
+	 * pt_regs so that task_pt_regs(idle_task)->stackframe can be
+	 * set up to be the last frame on the idle task stack just like
+	 * all the other kernel tasks. This helps the unwinder to
+	 * terminate the stack trace at a well-known stack offset.
+	 *
+	 * Also, set up the last return PC to be ret_from_fork() just
+	 * like all the other kernel tasks so that the stack trace of
+	 * all kernel tasks ends with the same function.
+	 */
+	.macro setup_last_frame
+	sub	sp, sp, #PT_REGS_SIZE
+	stp	xzr, xzr, [sp, #S_STACKFRAME]
+	add	x29, sp, #S_STACKFRAME
+	ldr	x30, =ret_from_fork
+	.endm
+
 /*
  * The following fragment of code is executed with the MMU enabled.
  *
@@ -447,8 +469,7 @@ SYM_FUNC_START_LOCAL(__primary_switched)
 #endif
 	bl	switch_to_vhe			// Prefer VHE if possible
 	add	sp, sp, #16
-	mov	x29, #0
-	mov	x30, #0
+	setup_last_frame
 	b	start_kernel
 SYM_FUNC_END(__primary_switched)
 
@@ -606,8 +627,7 @@ SYM_FUNC_START_LOCAL(__secondary_switched)
 	cbz	x2, __secondary_too_slow
 	msr	sp_el0, x2
 	scs_load x2, x3
-	mov	x29, #0
-	mov	x30, #0
+	setup_last_frame
 
 #ifdef CONFIG_ARM64_PTR_AUTH
 	ptrauth_keys_init_cpu x2, x3, x4, x5
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 325c83b1a24d..7ffa689e8b60 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -437,6 +437,11 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
 	}
 	p->thread.cpu_context.pc = (unsigned long)ret_from_fork;
 	p->thread.cpu_context.sp = (unsigned long)childregs;
+	/*
+	 * For the benefit of the unwinder, set up childregs->stackframe
+	 * as the last frame for the new task.
+	 */
+	p->thread.cpu_context.fp = (unsigned long)childregs->stackframe;
 
 	ptrace_hw_copy_thread(p);
 
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index ad20981dfda4..a35b760a1892 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -44,16 +44,16 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 	unsigned long fp = frame->fp;
 	struct stack_info info;
 
+	if (!tsk)
+		tsk = current;
+
 	/* Terminal record; nothing to unwind */
-	if (!fp)
+	if (fp == (unsigned long) task_pt_regs(tsk)->stackframe)
 		return -ENOENT;
 
 	if (fp & 0xf)
 		return -EINVAL;
 
-	if (!tsk)
-		tsk = current;
-
 	if (!on_accessible_stack(tsk, fp, &info))
 		return -EINVAL;
 
-- 
2.25.1

