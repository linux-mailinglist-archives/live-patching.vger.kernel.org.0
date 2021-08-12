Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D87A3EAA50
	for <lists+live-patching@lfdr.de>; Thu, 12 Aug 2021 20:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbhHLSgw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 12 Aug 2021 14:36:52 -0400
Received: from linux.microsoft.com ([13.77.154.182]:56250 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234316AbhHLSgr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 12 Aug 2021 14:36:47 -0400
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2503D20C155A;
        Thu, 12 Aug 2021 11:36:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2503D20C155A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1628793382;
        bh=9UDTW5f/wu5lTfTc51GK4zB/v63pXMsEhlhyVfcdK1w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=q+dG6hS/SQkwyQnqznHnzOCXmdgQjSU6BNGiXtOESewB6pZiHNuNiW6cXI5BSfo4L
         97U/9pp3jh2kJdzDZ7czxRD5NaV3xCS9eLlPHnthFg/O7z8h4zLwi7mTZTtuPi6LSP
         2z7Ma98LKOxlMoOkA08PGtHJiD2+LbXRiU06VExY=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v7 3/4] arm64: Introduce stack trace reliability checks in the unwinder
Date:   Thu, 12 Aug 2021 13:35:57 -0500
Message-Id: <20210812183559.22693-4-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210812183559.22693-1-madvenka@linux.microsoft.com>
References: <3f2aab69a35c243c5e97f47c4ad84046355f5b90>
 <20210812183559.22693-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

There are some kernel features and conditions that make a stack trace
unreliable. Callers may require the unwinder to detect these cases.
E.g., livepatch.

Introduce a new function called unwind_is_reliable() that will detect
these cases and return a boolean.

Introduce a new argument to unwind() called "need_reliable" so a caller
can tell unwind() that it requires a reliable stack trace. For such a
caller, any unreliability in the stack trace must be treated as a fatal
error and the unwind must be aborted.

Call unwind_is_reliable() from unwind_consume() like this:

	if (frame->need_reliable && !unwind_is_reliable(frame)) {
		frame->failed = true;
		return false;
	}

In other words, if the return PC in the stackframe falls in unreliable code,
then it cannot be unwound reliably.

arch_stack_walk() will pass "false" for need_reliable because its callers
don't care about reliability. arch_stack_walk() is used for debug and
test purposes.

Introduce arch_stack_walk_reliable() for ARM64. This works like
arch_stack_walk() except for two things:

	- It passes "true" for need_reliable.

	- It returns -EINVAL if unwind() says that the stack trace is
	  unreliable.

Introduce the first reliability check in unwind_is_reliable() - If
a return PC is not a valid kernel text address, consider the stack
trace unreliable. It could be some generated code.

Other reliability checks will be added in the future. Until all of the
checks are in place, arch_stack_walk_reliable() may not be used by
livepatch. But it may be used by debug and test code.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/stacktrace.h |  4 ++
 arch/arm64/kernel/stacktrace.c      | 63 +++++++++++++++++++++++++++--
 2 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 407007376e97..65ea151da5da 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -53,6 +53,9 @@ struct stack_info {
  *               replacement lr value in the ftrace graph stack.
  *
  * @failed:      Unwind failed.
+ *
+ * @need_reliable The caller needs a reliable stack trace. Treat any
+ *                unreliability as a fatal error.
  */
 struct stackframe {
 	struct task_struct *task;
@@ -65,6 +68,7 @@ struct stackframe {
 	int graph;
 #endif
 	bool failed;
+	bool need_reliable;
 };
 
 extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index ec8f5163c4d0..b60f8a20ba64 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -34,7 +34,8 @@
 
 static void notrace unwind_start(struct stackframe *frame,
 				 struct task_struct *task,
-				 unsigned long fp, unsigned long pc)
+				 unsigned long fp, unsigned long pc,
+				 bool need_reliable)
 {
 	frame->task = task;
 	frame->fp = fp;
@@ -56,6 +57,7 @@ static void notrace unwind_start(struct stackframe *frame,
 	frame->prev_fp = 0;
 	frame->prev_type = STACK_TYPE_UNKNOWN;
 	frame->failed = false;
+	frame->need_reliable = need_reliable;
 }
 
 NOKPROBE_SYMBOL(unwind_start);
@@ -178,6 +180,23 @@ void show_stack(struct task_struct *tsk, unsigned long *sp, const char *loglvl)
 	barrier();
 }
 
+/*
+ * Check the stack frame for conditions that make further unwinding unreliable.
+ */
+static bool notrace unwind_is_reliable(struct stackframe *frame)
+{
+	/*
+	 * If the PC is not a known kernel text address, then we cannot
+	 * be sure that a subsequent unwind will be reliable, as we
+	 * don't know that the code follows our unwind requirements.
+	 */
+	if (!__kernel_text_address(frame->pc))
+		return false;
+	return true;
+}
+
+NOKPROBE_SYMBOL(unwind_is_reliable);
+
 static bool notrace unwind_consume(struct stackframe *frame,
 				   stack_trace_consume_fn consume_entry,
 				   void *cookie)
@@ -197,6 +216,12 @@ static bool notrace unwind_consume(struct stackframe *frame,
 		/* Final frame; nothing to unwind */
 		return false;
 	}
+
+	if (frame->need_reliable && !unwind_is_reliable(frame)) {
+		/* Cannot unwind to the next frame reliably. */
+		frame->failed = true;
+		return false;
+	}
 	return true;
 }
 
@@ -210,11 +235,12 @@ static inline bool unwind_failed(struct stackframe *frame)
 /* Core unwind function */
 static bool notrace unwind(stack_trace_consume_fn consume_entry, void *cookie,
 			   struct task_struct *task,
-			   unsigned long fp, unsigned long pc)
+			   unsigned long fp, unsigned long pc,
+			   bool need_reliable)
 {
 	struct stackframe frame;
 
-	unwind_start(&frame, task, fp, pc);
+	unwind_start(&frame, task, fp, pc, need_reliable);
 	while (unwind_consume(&frame, consume_entry, cookie))
 		unwind_next(&frame);
 	return !unwind_failed(&frame);
@@ -245,7 +271,36 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 		fp = thread_saved_fp(task);
 		pc = thread_saved_pc(task);
 	}
-	unwind(consume_entry, cookie, task, fp, pc);
+	unwind(consume_entry, cookie, task, fp, pc, false);
+}
+
+/*
+ * arch_stack_walk_reliable() may not be used for livepatch until all of
+ * the reliability checks are in place in unwind_consume(). However,
+ * debug and test code can choose to use it even if all the checks are not
+ * in place.
+ */
+noinline int notrace arch_stack_walk_reliable(stack_trace_consume_fn consume_fn,
+					      void *cookie,
+					      struct task_struct *task)
+{
+	unsigned long fp, pc;
+
+	if (!task)
+		task = current;
+
+	if (task == current) {
+		/* Skip arch_stack_walk_reliable() in the stack trace. */
+		fp = (unsigned long)__builtin_frame_address(1);
+		pc = (unsigned long)__builtin_return_address(0);
+	} else {
+		/* Caller guarantees that the task is not running. */
+		fp = thread_saved_fp(task);
+		pc = thread_saved_pc(task);
+	}
+	if (unwind(consume_fn, cookie, task, fp, pc, true))
+		return 0;
+	return -EINVAL;
 }
 
 #endif
-- 
2.25.1

