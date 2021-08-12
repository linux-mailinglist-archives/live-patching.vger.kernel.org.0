Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3313EA59D
	for <lists+live-patching@lfdr.de>; Thu, 12 Aug 2021 15:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237129AbhHLNZV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 12 Aug 2021 09:25:21 -0400
Received: from linux.microsoft.com ([13.77.154.182]:40442 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237011AbhHLNZU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 12 Aug 2021 09:25:20 -0400
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 1D71C20C155A;
        Thu, 12 Aug 2021 06:24:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1D71C20C155A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1628774695;
        bh=A0Iq4hB4rYFGIumW8LpdP2LbJpF1RNqiSB5aZK65wpo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=KzDrHNxrFjPLy7msFviJfP5IOM2RBKbIpNRyQoe/aTwLXj5EcOq+LA7B6XjHx6s5W
         m+QaOCegsxc57b726eP7itbCUvuZDtW/O+lRhWrYGDFyZ2ZYKZFgo2HHLIYFj7wwoh
         r0LKCHpOV1P4lr8eKv/xK6CSzckYeoSYZp9Yb598=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v7 2/4] arm64: Reorganize the unwinder code for better consistency and maintenance
Date:   Thu, 12 Aug 2021 08:24:33 -0500
Message-Id: <20210812132435.6143-3-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210812132435.6143-1-madvenka@linux.microsoft.com>
References: <3f2aab69a35c243c5e97f47c4ad84046355f5b90>
 <20210812132435.6143-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Renaming of unwinder functions
==============================

Rename unwinder functions to unwind_*() similar to other architectures
for naming consistency. More on this below.

unwind function attributes
==========================

Mark all of the unwind_*() functions with notrace so they cannot be ftraced
and NOKPROBE_SYMBOL() so they cannot be kprobed. Ftrace and Kprobe code
can call the unwinder.

start_backtrace()
=================

start_backtrace() is only called by arch_stack_walk(). Make it static.
Rename start_backtrace() to unwind_start() for naming consistency.

unwind_frame()
==============

Rename this to unwind_next() for naming consistency.

Replace walk_stackframe() with unwind()
=======================================

walk_stackframe() contains the unwinder loop that walks the stack
frames. Currently, start_backtrace() and walk_stackframe() are called
separately. They should be combined in the same function. Also, the
loop in walk_stackframe() should be simplified and should look like
the unwind loops in other architectures such as X86 and S390.

Remove walk_stackframe(). Define a new function called "unwind()" in
its place. Define the following unwinder loop:

	unwind_start(&frame, task, fp, pc);
	while (unwind_consume(&frame, consume_entry, cookie))
		unwind_next(&frame);
	return !unwind_failed(&frame);

unwind_start()
	Same as the original start_backtrace().

unwind_consume()
	This is a new function that calls the callback function to
	consume the PC in a stackframe. Do it this way so that checks
	can be performed before and after the callback to determine
	whether the unwind should continue or terminate.

unwind_next()
	Same as the original unwind_frame() except for two things:

		- the stack trace termination check has been moved from
		  here to unwind_consume(). So, unwind_next() is always
		  called on a valid fp.

		- unwind_frame() used to return an error value. This
		  function does not return anything.

unwind_failed()
	Return a boolean to indicate if the stack trace completed
	successfully or failed. arch_stack_walk() ignores the return
	value. But arch_stack_walk_reliable() in the future will look
	at the return value.

Unwind status
=============

Introduce a new flag called "failed" in struct stackframe. unwind_next()
and unwind_consume() will set this flag when an error is encountered and
unwind_consume() will check this flag. This is in keeping with other
architectures.

The failed flags is accessed via the helper unwind_failed().

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/stacktrace.h |   9 +-
 arch/arm64/kernel/stacktrace.c      | 145 ++++++++++++++++++----------
 2 files changed, 99 insertions(+), 55 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index e43dea1c6b41..407007376e97 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -34,6 +34,8 @@ struct stack_info {
  * A snapshot of a frame record or fp/lr register values, along with some
  * accounting information necessary for robust unwinding.
  *
+ * @task:        The task whose stack is being unwound.
+ *
  * @fp:          The fp value in the frame record (or the real fp)
  * @pc:          The lr value in the frame record (or the real lr)
  *
@@ -49,8 +51,11 @@ struct stack_info {
  *
  * @graph:       When FUNCTION_GRAPH_TRACER is selected, holds the index of a
  *               replacement lr value in the ftrace graph stack.
+ *
+ * @failed:      Unwind failed.
  */
 struct stackframe {
+	struct task_struct *task;
 	unsigned long fp;
 	unsigned long pc;
 	DECLARE_BITMAP(stacks_done, __NR_STACK_TYPES);
@@ -59,6 +64,7 @@ struct stackframe {
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	int graph;
 #endif
+	bool failed;
 };
 
 extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
@@ -145,7 +151,4 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
 	return false;
 }
 
-void start_backtrace(struct stackframe *frame, unsigned long fp,
-		     unsigned long pc);
-
 #endif	/* __ASM_STACKTRACE_H */
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 1800310f92be..ec8f5163c4d0 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -32,10 +32,11 @@
  *	add	sp, sp, #0x10
  */
 
-
-void start_backtrace(struct stackframe *frame, unsigned long fp,
-		     unsigned long pc)
+static void notrace unwind_start(struct stackframe *frame,
+				 struct task_struct *task,
+				 unsigned long fp, unsigned long pc)
 {
+	frame->task = task;
 	frame->fp = fp;
 	frame->pc = pc;
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -45,7 +46,7 @@ void start_backtrace(struct stackframe *frame, unsigned long fp,
 	/*
 	 * Prime the first unwind.
 	 *
-	 * In unwind_frame() we'll check that the FP points to a valid stack,
+	 * In unwind_next() we'll check that the FP points to a valid stack,
 	 * which can't be STACK_TYPE_UNKNOWN, and the first unwind will be
 	 * treated as a transition to whichever stack that happens to be. The
 	 * prev_fp value won't be used, but we set it to 0 such that it is
@@ -54,8 +55,11 @@ void start_backtrace(struct stackframe *frame, unsigned long fp,
 	bitmap_zero(frame->stacks_done, __NR_STACK_TYPES);
 	frame->prev_fp = 0;
 	frame->prev_type = STACK_TYPE_UNKNOWN;
+	frame->failed = false;
 }
 
+NOKPROBE_SYMBOL(unwind_start);
+
 /*
  * Unwind from one frame record (A) to the next frame record (B).
  *
@@ -63,26 +67,26 @@ void start_backtrace(struct stackframe *frame, unsigned long fp,
  * records (e.g. a cycle), determined based on the location and fp value of A
  * and the location (but not the fp value) of B.
  */
-int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
+static void notrace unwind_next(struct stackframe *frame)
 {
 	unsigned long fp = frame->fp;
 	struct stack_info info;
+	struct task_struct *tsk = frame->task;
 
-	if (!tsk)
-		tsk = current;
-
-	/* Final frame; nothing to unwind */
-	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
-		return -ENOENT;
-
-	if (fp & 0x7)
-		return -EINVAL;
+	if (fp & 0x7) {
+		frame->failed = true;
+		return;
+	}
 
-	if (!on_accessible_stack(tsk, fp, 16, &info))
-		return -EINVAL;
+	if (!on_accessible_stack(tsk, fp, 16, &info)) {
+		frame->failed = true;
+		return;
+	}
 
-	if (test_bit(info.type, frame->stacks_done))
-		return -EINVAL;
+	if (test_bit(info.type, frame->stacks_done)) {
+		frame->failed = true;
+		return;
+	}
 
 	/*
 	 * As stacks grow downward, any valid record on the same stack must be
@@ -98,15 +102,17 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 	 * stack.
 	 */
 	if (info.type == frame->prev_type) {
-		if (fp <= frame->prev_fp)
-			return -EINVAL;
+		if (fp <= frame->prev_fp) {
+			frame->failed = true;
+			return;
+		}
 	} else {
 		set_bit(frame->prev_type, frame->stacks_done);
 	}
 
 	/*
 	 * Record this frame record's values and location. The prev_fp and
-	 * prev_type are only meaningful to the next unwind_frame() invocation.
+	 * prev_type are only meaningful to the next unwind_next() invocation.
 	 */
 	frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp));
 	frame->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp + 8));
@@ -124,32 +130,18 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 		 * So replace it to an original value.
 		 */
 		ret_stack = ftrace_graph_get_ret_stack(tsk, frame->graph++);
-		if (WARN_ON_ONCE(!ret_stack))
-			return -EINVAL;
+		if (WARN_ON_ONCE(!ret_stack)) {
+			frame->failed = true;
+			return;
+		}
 		frame->pc = ret_stack->ret;
 	}
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
 	frame->pc = ptrauth_strip_insn_pac(frame->pc);
-
-	return 0;
 }
-NOKPROBE_SYMBOL(unwind_frame);
 
-void notrace walk_stackframe(struct task_struct *tsk, struct stackframe *frame,
-			     bool (*fn)(void *, unsigned long), void *data)
-{
-	while (1) {
-		int ret;
-
-		if (!fn(data, frame->pc))
-			break;
-		ret = unwind_frame(tsk, frame);
-		if (ret < 0)
-			break;
-	}
-}
-NOKPROBE_SYMBOL(walk_stackframe);
+NOKPROBE_SYMBOL(unwind_next);
 
 static bool dump_backtrace_entry(void *arg, unsigned long where)
 {
@@ -186,25 +178,74 @@ void show_stack(struct task_struct *tsk, unsigned long *sp, const char *loglvl)
 	barrier();
 }
 
+static bool notrace unwind_consume(struct stackframe *frame,
+				   stack_trace_consume_fn consume_entry,
+				   void *cookie)
+{
+	if (frame->failed) {
+		/* PC is suspect. Cannot consume it. */
+		return false;
+	}
+
+	if (!consume_entry(cookie, frame->pc)) {
+		/* Caller terminated the unwind. */
+		frame->failed = true;
+		return false;
+	}
+
+	if (frame->fp == (unsigned long)task_pt_regs(frame->task)->stackframe) {
+		/* Final frame; nothing to unwind */
+		return false;
+	}
+	return true;
+}
+
+NOKPROBE_SYMBOL(unwind_consume);
+
+static inline bool unwind_failed(struct stackframe *frame)
+{
+	return frame->failed;
+}
+
+/* Core unwind function */
+static bool notrace unwind(stack_trace_consume_fn consume_entry, void *cookie,
+			   struct task_struct *task,
+			   unsigned long fp, unsigned long pc)
+{
+	struct stackframe frame;
+
+	unwind_start(&frame, task, fp, pc);
+	while (unwind_consume(&frame, consume_entry, cookie))
+		unwind_next(&frame);
+	return !unwind_failed(&frame);
+}
+
+NOKPROBE_SYMBOL(unwind);
+
 #ifdef CONFIG_STACKTRACE
 
 noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 			      void *cookie, struct task_struct *task,
 			      struct pt_regs *regs)
 {
-	struct stackframe frame;
+	unsigned long fp, pc;
+
+	if (!task)
+		task = current;
 
-	if (regs)
-		start_backtrace(&frame, regs->regs[29], regs->pc);
-	else if (task == current)
-		start_backtrace(&frame,
-				(unsigned long)__builtin_frame_address(1),
-				(unsigned long)__builtin_return_address(0));
-	else
-		start_backtrace(&frame, thread_saved_fp(task),
-				thread_saved_pc(task));
-
-	walk_stackframe(task, &frame, consume_entry, cookie);
+	if (regs) {
+		fp = regs->regs[29];
+		pc = regs->pc;
+	} else if (task == current) {
+		/* Skip arch_stack_walk() in the stack trace. */
+		fp = (unsigned long)__builtin_frame_address(1);
+		pc = (unsigned long)__builtin_return_address(0);
+	} else {
+		/* Caller guarantees that the task is not running. */
+		fp = thread_saved_fp(task);
+		pc = thread_saved_pc(task);
+	}
+	unwind(consume_entry, cookie, task, fp, pc);
 }
 
 #endif
-- 
2.25.1

