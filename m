Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7211245ACAB
	for <lists+live-patching@lfdr.de>; Tue, 23 Nov 2021 20:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239953AbhKWTkz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Nov 2021 14:40:55 -0500
Received: from linux.microsoft.com ([13.77.154.182]:41928 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238846AbhKWTkr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Nov 2021 14:40:47 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 062DB20D4D3D;
        Tue, 23 Nov 2021 11:37:36 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 062DB20D4D3D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1637696257;
        bh=ANijem9qrqDRCyqcDOusbbhCMatgyg1SMa0VQG+ycgk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FDK5nwZ6mp0rwag3tiw+83PEtTTQG2hsym0HD4/QKmyTZH6ca4rRngn+vdO5ZzQTs
         hJgZMffOgqx1+WS2EgyScKVsK7BEeUOuvmURYFtcyjS6+rRgyAXnQQ9+IUFXpsNQb1
         FOh07RjB5AJVx13n2fluXl7haaRuQjzzaJ5EDsoc=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v11 4/5] arm64: Introduce stack trace reliability checks in the unwinder
Date:   Tue, 23 Nov 2021 13:37:22 -0600
Message-Id: <20211123193723.12112-5-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211123193723.12112-1-madvenka@linux.microsoft.com>
References: <8b861784d85a21a9bf08598938c11aff1b1249b9>
 <20211123193723.12112-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

There are some kernel features and conditions that make a stack trace
unreliable. Callers may require the unwinder to detect these cases.
E.g., livepatch.

Introduce a new function called unwind_check_reliability() that will
detect these cases and set a flag in the stack frame. Call
unwind_check_reliability() for every frame, that is, in unwind_start()
and unwind_next().

Introduce the first reliability check in unwind_check_reliability() - If
a return PC is not a valid kernel text address, consider the stack
trace unreliable. It could be some generated code. Other reliability checks
will be added in the future.

Let unwind() return a boolean to indicate if the stack trace is
reliable.

Introduce arch_stack_walk_reliable() for ARM64. This works like
arch_stack_walk() except that it returns -EINVAL if the stack trace is not
reliable.

Until all the reliability checks are in place, arch_stack_walk_reliable()
may not be used by livepatch. But it may be used by debug and test code.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/stacktrace.h |  3 ++
 arch/arm64/kernel/stacktrace.c      | 59 +++++++++++++++++++++++++++--
 2 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index d838586adef9..7143e80c3d96 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -53,6 +53,8 @@ struct stack_info {
  *               value.
  *
  * @failed:      Unwind failed.
+ *
+ * @reliable:    Stack trace is reliable.
  */
 struct stackframe {
 	unsigned long fp;
@@ -64,6 +66,7 @@ struct stackframe {
 	struct llist_node *kr_cur;
 #endif
 	bool failed;
+	bool reliable;
 };
 
 extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 3b670ab1f0e9..77eb00e45558 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -18,6 +18,26 @@
 #include <asm/stack_pointer.h>
 #include <asm/stacktrace.h>
 
+/*
+ * Check the stack frame for conditions that make further unwinding unreliable.
+ */
+static void unwind_check_reliability(struct task_struct *task,
+				     struct stackframe *frame)
+{
+	if (frame->fp == (unsigned long)task_pt_regs(task)->stackframe) {
+		/* Final frame; no more unwind, no need to check reliability */
+		return;
+	}
+
+	/*
+	 * If the PC is not a known kernel text address, then we cannot
+	 * be sure that a subsequent unwind will be reliable, as we
+	 * don't know that the code follows our unwind requirements.
+	 */
+	if (!__kernel_text_address(frame->pc))
+		frame->reliable = false;
+}
+
 /*
  * AArch64 PCS assigns the frame pointer to x29.
  *
@@ -33,8 +53,9 @@
  */
 
 
-static void unwind_start(struct stackframe *frame, unsigned long fp,
-			 unsigned long pc)
+static void unwind_start(struct task_struct *task,
+			 struct stackframe *frame,
+			 unsigned long fp, unsigned long pc)
 {
 	frame->fp = fp;
 	frame->pc = pc;
@@ -55,6 +76,8 @@ static void unwind_start(struct stackframe *frame, unsigned long fp,
 	frame->prev_fp = 0;
 	frame->prev_type = STACK_TYPE_UNKNOWN;
 	frame->failed = false;
+	frame->reliable = true;
+	unwind_check_reliability(task, frame);
 }
 
 /*
@@ -141,6 +164,7 @@ static void notrace unwind_next(struct task_struct *tsk,
 	if (is_kretprobe_trampoline(frame->pc))
 		frame->pc = kretprobe_find_ret_addr(tsk, (void *)frame->fp, &frame->kr_cur);
 #endif
+	unwind_check_reliability(tsk, frame);
 }
 NOKPROBE_SYMBOL(unwind_next);
 
@@ -166,15 +190,16 @@ static bool unwind_continue(struct task_struct *task,
 	return true;
 }
 
-static void notrace unwind(struct task_struct *tsk,
+static bool notrace unwind(struct task_struct *tsk,
 			   unsigned long fp, unsigned long pc,
 			   bool (*fn)(void *, unsigned long), void *data)
 {
 	struct stackframe frame;
 
-	unwind_start(&frame, fp, pc);
+	unwind_start(tsk, &frame, fp, pc);
 	while (unwind_continue(tsk, &frame, fn, data))
 		unwind_next(tsk, &frame);
+	return !frame.failed && frame.reliable;
 }
 NOKPROBE_SYMBOL(unwind);
 
@@ -231,3 +256,29 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 	}
 	unwind(task, fp, pc, consume_entry, cookie);
 }
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
+	if (task == current) {
+		/* Skip arch_stack_walk_reliable() in the stack trace. */
+		fp = (unsigned long)__builtin_frame_address(1);
+		pc = (unsigned long)__builtin_return_address(0);
+	} else {
+		/* Caller guarantees that the task is not running. */
+		fp = thread_saved_fp(task);
+		pc = thread_saved_pc(task);
+	}
+	if (unwind(task, fp, pc, consume_fn, cookie))
+		return 0;
+	return -EINVAL;
+}
-- 
2.25.1

