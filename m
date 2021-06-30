Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D683B8A7C
	for <lists+live-patching@lfdr.de>; Thu,  1 Jul 2021 00:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbhF3Wgj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 30 Jun 2021 18:36:39 -0400
Received: from linux.microsoft.com ([13.77.154.182]:44522 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhF3Wgg (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 30 Jun 2021 18:36:36 -0400
Received: from x64host.home (unknown [47.187.214.213])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4005620B7188;
        Wed, 30 Jun 2021 15:34:06 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4005620B7188
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1625092447;
        bh=Gr8ouXN268cAeUy8k+pwSBgaBbzeDcX4e30mNG/JOrQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=lRY/qmCVWLW1T4MtBQvjwz1vDpW+QkLTwKyKyI5gFcDkVJmth0HxxRTMqu6sjeMWO
         3UCOIUn70Ne3V9z6qU3o46HTavSZyKdKILuXK6pG17YGn6U3gu1E16Wi/mhJjxMZ5t
         u4BRnBIyeW1F/kI3sz9JYIOAwqCDh1thdcSgvDpw=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v6 1/3] arm64: Improve the unwinder return value
Date:   Wed, 30 Jun 2021 17:33:54 -0500
Message-Id: <20210630223356.58714-2-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210630223356.58714-1-madvenka@linux.microsoft.com>
References: <3f2aab69a35c243c5e97f47c4ad84046355f5b90>
 <20210630223356.58714-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Currently, the unwinder returns a tri-state return value:

	0		means "continue with the unwind"
	-ENOENT		means "successful termination of the stack trace"
	-EINVAL		means "fatal error, abort the stack trace"

This is confusing. To fix this, define an enumeration of different return
codes to make it clear. Handle the return codes in all of the unwind
consumers.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/stacktrace.h | 14 ++++++--
 arch/arm64/kernel/perf_callchain.c  |  5 ++-
 arch/arm64/kernel/process.c         |  8 +++--
 arch/arm64/kernel/return_address.c  | 10 ++++--
 arch/arm64/kernel/stacktrace.c      | 53 ++++++++++++++++-------------
 arch/arm64/kernel/time.c            |  9 +++--
 6 files changed, 64 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index eb29b1fe8255..6fcd58553fb1 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -30,6 +30,12 @@ struct stack_info {
 	enum stack_type type;
 };
 
+enum unwind_rc {
+	UNWIND_CONTINUE,		/* No errors encountered */
+	UNWIND_ABORT,			/* Fatal errors encountered */
+	UNWIND_FINISH,			/* End of stack reached successfully */
+};
+
 /*
  * A snapshot of a frame record or fp/lr register values, along with some
  * accounting information necessary for robust unwinding.
@@ -61,7 +67,8 @@ struct stackframe {
 #endif
 };
 
-extern int unwind_frame(struct task_struct *tsk, struct stackframe *frame);
+extern enum unwind_rc unwind_frame(struct task_struct *tsk,
+				   struct stackframe *frame);
 extern void walk_stackframe(struct task_struct *tsk, struct stackframe *frame,
 			    bool (*fn)(void *, unsigned long), void *data);
 extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
@@ -148,8 +155,8 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
 	return false;
 }
 
-static inline void start_backtrace(struct stackframe *frame,
-				   unsigned long fp, unsigned long pc)
+static inline enum unwind_rc start_backtrace(struct stackframe *frame,
+					     unsigned long fp, unsigned long pc)
 {
 	frame->fp = fp;
 	frame->pc = pc;
@@ -169,6 +176,7 @@ static inline void start_backtrace(struct stackframe *frame,
 	bitmap_zero(frame->stacks_done, __NR_STACK_TYPES);
 	frame->prev_fp = 0;
 	frame->prev_type = STACK_TYPE_UNKNOWN;
+	return UNWIND_CONTINUE;
 }
 
 #endif	/* __ASM_STACKTRACE_H */
diff --git a/arch/arm64/kernel/perf_callchain.c b/arch/arm64/kernel/perf_callchain.c
index 88ff471b0bce..f459208149ae 100644
--- a/arch/arm64/kernel/perf_callchain.c
+++ b/arch/arm64/kernel/perf_callchain.c
@@ -148,13 +148,16 @@ void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 			   struct pt_regs *regs)
 {
 	struct stackframe frame;
+	enum unwind_rc rc;
 
 	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
 		/* We don't support guest os callchain now */
 		return;
 	}
 
-	start_backtrace(&frame, regs->regs[29], regs->pc);
+	rc = start_backtrace(&frame, regs->regs[29], regs->pc);
+	if (rc == UNWIND_FINISH || rc == UNWIND_ABORT)
+		return;
 	walk_stackframe(current, &frame, callchain_trace, entry);
 }
 
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 6e60aa3b5ea9..e9c763b44fd4 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -573,6 +573,7 @@ unsigned long get_wchan(struct task_struct *p)
 	struct stackframe frame;
 	unsigned long stack_page, ret = 0;
 	int count = 0;
+	enum unwind_rc rc;
 	if (!p || p == current || p->state == TASK_RUNNING)
 		return 0;
 
@@ -580,10 +581,13 @@ unsigned long get_wchan(struct task_struct *p)
 	if (!stack_page)
 		return 0;
 
-	start_backtrace(&frame, thread_saved_fp(p), thread_saved_pc(p));
+	rc = start_backtrace(&frame, thread_saved_fp(p), thread_saved_pc(p));
+	if (rc == UNWIND_FINISH || rc == UNWIND_ABORT)
+		return 0;
 
 	do {
-		if (unwind_frame(p, &frame))
+		rc = unwind_frame(p, &frame);
+		if (rc == UNWIND_FINISH || rc == UNWIND_ABORT)
 			goto out;
 		if (!in_sched_functions(frame.pc)) {
 			ret = frame.pc;
diff --git a/arch/arm64/kernel/return_address.c b/arch/arm64/kernel/return_address.c
index a6d18755652f..1224e043e98f 100644
--- a/arch/arm64/kernel/return_address.c
+++ b/arch/arm64/kernel/return_address.c
@@ -36,13 +36,17 @@ void *return_address(unsigned int level)
 {
 	struct return_address_data data;
 	struct stackframe frame;
+	enum unwind_rc rc;
 
 	data.level = level + 2;
 	data.addr = NULL;
 
-	start_backtrace(&frame,
-			(unsigned long)__builtin_frame_address(0),
-			(unsigned long)return_address);
+	rc = start_backtrace(&frame,
+			     (unsigned long)__builtin_frame_address(0),
+			     (unsigned long)return_address);
+	if (rc == UNWIND_FINISH || rc == UNWIND_ABORT)
+		return NULL;
+
 	walk_stackframe(current, &frame, save_return_addr, &data);
 
 	if (!data.level)
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index d55bdfb7789c..e9c2c1fa9dde 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -39,26 +39,27 @@
  * records (e.g. a cycle), determined based on the location and fp value of A
  * and the location (but not the fp value) of B.
  */
-int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
+enum unwind_rc notrace unwind_frame(struct task_struct *tsk,
+					struct stackframe *frame)
 {
 	unsigned long fp = frame->fp;
 	struct stack_info info;
 
 	/* Terminal record; nothing to unwind */
 	if (!fp)
-		return -ENOENT;
+		return UNWIND_FINISH;
 
 	if (fp & 0xf)
-		return -EINVAL;
+		return UNWIND_ABORT;
 
 	if (!tsk)
 		tsk = current;
 
 	if (!on_accessible_stack(tsk, fp, &info))
-		return -EINVAL;
+		return UNWIND_ABORT;
 
 	if (test_bit(info.type, frame->stacks_done))
-		return -EINVAL;
+		return UNWIND_ABORT;
 
 	/*
 	 * As stacks grow downward, any valid record on the same stack must be
@@ -75,7 +76,7 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 	 */
 	if (info.type == frame->prev_type) {
 		if (fp <= frame->prev_fp)
-			return -EINVAL;
+			return UNWIND_ABORT;
 	} else {
 		set_bit(frame->prev_type, frame->stacks_done);
 	}
@@ -101,14 +102,14 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 		 */
 		ret_stack = ftrace_graph_get_ret_stack(tsk, frame->graph++);
 		if (WARN_ON_ONCE(!ret_stack))
-			return -EINVAL;
+			return UNWIND_ABORT;
 		frame->pc = ret_stack->ret;
 	}
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
 	frame->pc = ptrauth_strip_insn_pac(frame->pc);
 
-	return 0;
+	return UNWIND_CONTINUE;
 }
 NOKPROBE_SYMBOL(unwind_frame);
 
@@ -116,12 +117,12 @@ void notrace walk_stackframe(struct task_struct *tsk, struct stackframe *frame,
 			     bool (*fn)(void *, unsigned long), void *data)
 {
 	while (1) {
-		int ret;
+		enum unwind_rc rc;
 
 		if (!fn(data, frame->pc))
 			break;
-		ret = unwind_frame(tsk, frame);
-		if (ret < 0)
+		rc = unwind_frame(tsk, frame);
+		if (rc == UNWIND_FINISH || rc == UNWIND_ABORT)
 			break;
 	}
 }
@@ -137,6 +138,7 @@ void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
 {
 	struct stackframe frame;
 	int skip = 0;
+	enum unwind_rc rc;
 
 	pr_debug("%s(regs = %p tsk = %p)\n", __func__, regs, tsk);
 
@@ -153,17 +155,19 @@ void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
 		return;
 
 	if (tsk == current) {
-		start_backtrace(&frame,
-				(unsigned long)__builtin_frame_address(0),
-				(unsigned long)dump_backtrace);
+		rc = start_backtrace(&frame,
+				     (unsigned long)__builtin_frame_address(0),
+				     (unsigned long)dump_backtrace);
 	} else {
 		/*
 		 * task blocked in __switch_to
 		 */
-		start_backtrace(&frame,
-				thread_saved_fp(tsk),
-				thread_saved_pc(tsk));
+		rc = start_backtrace(&frame,
+				     thread_saved_fp(tsk),
+				     thread_saved_pc(tsk));
 	}
+	if (rc == UNWIND_FINISH || rc == UNWIND_ABORT)
+		return;
 
 	printk("%sCall trace:\n", loglvl);
 	do {
@@ -181,7 +185,8 @@ void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
 			 */
 			dump_backtrace_entry(regs->pc, loglvl);
 		}
-	} while (!unwind_frame(tsk, &frame));
+		rc = unwind_frame(tsk, &frame);
+	} while (rc != UNWIND_FINISH && rc != UNWIND_ABORT);
 
 	put_task_stack(tsk);
 }
@@ -199,17 +204,19 @@ noinline void arch_stack_walk(stack_trace_consume_fn consume_entry,
 			      struct pt_regs *regs)
 {
 	struct stackframe frame;
+	enum unwind_rc rc;
 
 	if (regs)
-		start_backtrace(&frame, regs->regs[29], regs->pc);
+		rc = start_backtrace(&frame, regs->regs[29], regs->pc);
 	else if (task == current)
-		start_backtrace(&frame,
+		rc = start_backtrace(&frame,
 				(unsigned long)__builtin_frame_address(1),
 				(unsigned long)__builtin_return_address(0));
 	else
-		start_backtrace(&frame, thread_saved_fp(task),
-				thread_saved_pc(task));
-
+		rc = start_backtrace(&frame, thread_saved_fp(task),
+				     thread_saved_pc(task));
+	if (rc == UNWIND_FINISH || rc == UNWIND_ABORT)
+		return;
 	walk_stackframe(task, &frame, consume_entry, cookie);
 }
 
diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
index eebbc8d7123e..eb50218ec9a4 100644
--- a/arch/arm64/kernel/time.c
+++ b/arch/arm64/kernel/time.c
@@ -35,15 +35,18 @@
 unsigned long profile_pc(struct pt_regs *regs)
 {
 	struct stackframe frame;
+	enum unwind_rc rc;
 
 	if (!in_lock_functions(regs->pc))
 		return regs->pc;
 
-	start_backtrace(&frame, regs->regs[29], regs->pc);
+	rc = start_backtrace(&frame, regs->regs[29], regs->pc);
+	if (rc == UNWIND_FINISH || rc == UNWIND_ABORT)
+		return 0;
 
 	do {
-		int ret = unwind_frame(NULL, &frame);
-		if (ret < 0)
+		rc = unwind_frame(NULL, &frame);
+		if (rc == UNWIND_FINISH || rc == UNWIND_ABORT)
 			return 0;
 	} while (in_lock_functions(frame.pc));
 
-- 
2.25.1

