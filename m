Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01F1531FB6
	for <lists+live-patching@lfdr.de>; Tue, 24 May 2022 02:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbiEXARk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 23 May 2022 20:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbiEXAR2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 23 May 2022 20:17:28 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B4CA792D12;
        Mon, 23 May 2022 17:17:05 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8509520B5B4E;
        Mon, 23 May 2022 17:17:04 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8509520B5B4E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1653351425;
        bh=F+06QZixvxLg5mYB/7rdwOhFtinfWWMMUPEPRY4OtFI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fNUshMRvBVgso8WBJO4GkUQQK0Q8bi4QV+zVHOgHgrHmj0j+0jo9zP6py6SVb8xip
         fjz8QwDwctqwlJYT+ENWJT3lZZrgUpArvBvHx2po1pDhGjUVvmrLR3bfnkF2xE097s
         cq2Ds76QQ4c4IGWT4Sqi2kkTj0xKg50unsT0I/0Q=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 18/20] arm64: unwinder: Add a reliability check in the unwinder based on ORC
Date:   Mon, 23 May 2022 19:16:35 -0500
Message-Id: <20220524001637.1707472-19-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220524001637.1707472-1-madvenka@linux.microsoft.com>
References: <e81e773678f88f7c2ff7480e2eb096973ec198db>
 <20220524001637.1707472-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Introduce a reliability flag in struct stackframe. This will be set to
false if the PC does not have a valid ORC or if the frame pointer computed
from the ORC does not match the actual frame pointer.

Now that the unwinder can validate the frame pointer, introduce
arch_stack_walk_reliable().

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/stacktrace.h |   9 ++
 arch/arm64/kernel/ftrace.c          |  16 +++
 arch/arm64/kernel/stacktrace.c      | 153 ++++++++++++++++++++++++++++
 include/linux/ftrace.h              |   4 +
 4 files changed, 182 insertions(+)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index e77cdef9ca29..f5d9bbed53e6 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -44,6 +44,7 @@ struct stack_info {
  * @prev_fp:     The fp that pointed to this frame record, or a synthetic value
  *               of 0. This is used to ensure that within a stack, each
  *               subsequent frame record is at an increasing address.
+ * @prev_pc:     The pc in the previous frame.
  * @prev_type:   The type of stack this frame record was on, or a synthetic
  *               value of STACK_TYPE_UNKNOWN. This is used to detect a
  *               transition from one stack to another.
@@ -51,16 +52,24 @@ struct stack_info {
  * @kr_cur:      When KRETPROBES is selected, holds the kretprobe instance
  *               associated with the most recently encountered replacement lr
  *               value.
+ *
+ * @cfa:         The sp value at the call site of the current function.
+ * @unwind_type  The previous frame's unwind type.
+ * @reliable:    Stack trace is reliable.
  */
 struct stackframe {
 	unsigned long fp;
 	unsigned long pc;
 	DECLARE_BITMAP(stacks_done, __NR_STACK_TYPES);
 	unsigned long prev_fp;
+	unsigned long prev_pc;
 	enum stack_type prev_type;
 #ifdef CONFIG_KRETPROBES
 	struct llist_node *kr_cur;
 #endif
+	unsigned long cfa;
+	int unwind_type;
+	bool reliable;
 };
 
 extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
index 4506c4a90ac1..ec9a00d714e5 100644
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -299,3 +299,19 @@ int ftrace_disable_ftrace_graph_caller(void)
 }
 #endif /* CONFIG_DYNAMIC_FTRACE */
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+
+bool is_ftrace_entry(unsigned long pc)
+{
+	if (pc == (unsigned long)&ftrace_call_entry)
+		return true;
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	if (pc == (unsigned long)&ftrace_graph_caller_entry)
+		return true;
+#endif
+	return false;
+}
+
+#endif
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index e4103e085681..31184d64edb6 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -5,6 +5,8 @@
  * Copyright (C) 2012 ARM Ltd.
  */
 #include <linux/kernel.h>
+#include <asm/unwind_hints.h>
+#include <asm-generic/orc_lookup.h>
 #include <linux/export.h>
 #include <linux/ftrace.h>
 #include <linux/kprobes.h>
@@ -18,6 +20,120 @@
 #include <asm/stack_pointer.h>
 #include <asm/stacktrace.h>
 
+#ifdef CONFIG_FRAME_POINTER_VALIDATION
+
+static void unwind_check_frame(struct stackframe *frame)
+{
+	unsigned long pc, fp;
+	struct orc_entry *orc;
+	bool adjust_pc = false;
+
+	/*
+	 * If a previous frame was unreliable, the CFA cannot be reliably
+	 * computed anymore.
+	 */
+	if (!frame->reliable)
+		return;
+
+	pc = frame->pc;
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+	if (is_ftrace_entry(frame->prev_pc))
+		pc = (unsigned long)&ftrace_callsite;
+#endif
+
+	/* Don't let modules unload while we're reading their ORC data. */
+	preempt_disable();
+
+	orc = orc_find(pc);
+	if (!orc || (!orc->fp_offset && orc->type == UNWIND_HINT_TYPE_CALL)) {
+		/*
+		 * If the final instruction in a function happens to be a call
+		 * instruction, the return address would fall outside of the
+		 * function. That could be the case here. This can happen, for
+		 * instance, if the called function is a "noreturn" function.
+		 * The compiler can optimize away the instructions after the
+		 * call. So, adjust the PC so it falls inside the function and
+		 * retry.
+		 *
+		 * We only do this if the current and the previous frames
+		 * are call frames and not hint frames.
+		 */
+		if (frame->unwind_type == UNWIND_HINT_TYPE_CALL) {
+			pc -= 4;
+			adjust_pc = true;
+			orc = orc_find(pc);
+		}
+	}
+	if (!orc) {
+		frame->reliable = false;
+		goto out;
+	}
+	frame->unwind_type = orc->type;
+
+	if (!frame->cfa) {
+		/* Set up the initial CFA and return. */
+		frame->cfa = frame->fp - orc->fp_offset;
+		goto out;
+	}
+
+	/* Compute the next CFA and FP. */
+	switch (orc->type) {
+	case UNWIND_HINT_TYPE_CALL:
+		/* Normal call */
+		frame->cfa += orc->sp_offset;
+		fp = frame->cfa + orc->fp_offset;
+		break;
+
+	case UNWIND_HINT_TYPE_REGS:
+		/*
+		 * pt_regs hint: The frame pointer points to either the
+		 * synthetic frame within pt_regs or to the place where
+		 * x29 and x30 are saved in the register save area in
+		 * pt_regs.
+		 */
+		frame->cfa += orc->sp_offset;
+		fp = frame->cfa + offsetof(struct pt_regs, stackframe) -
+		     sizeof(struct pt_regs);
+		if (frame->fp != fp) {
+			fp = frame->cfa + offsetof(struct pt_regs, regs[29]) -
+			     sizeof(struct pt_regs);
+		}
+		break;
+
+	case UNWIND_HINT_TYPE_FTRACE:
+		/* ftrace callsite hint */
+		frame->cfa += orc->sp_offset;
+		fp = frame->cfa - orc->sp_offset;
+		break;
+
+	case UNWIND_HINT_TYPE_IRQ_STACK:
+		/* Hint to unwind from the IRQ stack to the task stack. */
+		frame->cfa = frame->fp + orc->sp_offset;
+		fp = frame->fp;
+		break;
+
+	default:
+		fp = 0;
+		break;
+	}
+
+	/* Validate the actual FP with the computed one. */
+	if (frame->fp != fp)
+		frame->reliable = false;
+out:
+	if (frame->reliable && adjust_pc)
+		frame->pc = pc;
+	preempt_enable();
+}
+
+#else /* !CONFIG_FRAME_POINTER_VALIDATION */
+
+static void unwind_check_frame(struct stackframe *frame)
+{
+}
+
+#endif /* CONFIG_FRAME_POINTER_VALIDATION */
+
 /*
  * AArch64 PCS assigns the frame pointer to x29.
  *
@@ -53,7 +169,13 @@ static notrace void start_backtrace(struct stackframe *frame, unsigned long fp,
 	 */
 	bitmap_zero(frame->stacks_done, __NR_STACK_TYPES);
 	frame->prev_fp = 0;
+	frame->prev_pc = 0;
 	frame->prev_type = STACK_TYPE_UNKNOWN;
+
+	frame->reliable = true;
+	frame->cfa = 0;
+	frame->unwind_type = UNWIND_HINT_TYPE_CALL;
+	unwind_check_frame(frame);
 }
 NOKPROBE_SYMBOL(start_backtrace);
 
@@ -110,6 +232,7 @@ static int notrace unwind_frame(struct task_struct *tsk,
 	 * Record this frame record's values and location. The prev_fp and
 	 * prev_type are only meaningful to the next unwind_frame() invocation.
 	 */
+	frame->prev_pc = frame->pc;
 	frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp));
 	frame->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp + 8));
 	frame->prev_fp = fp;
@@ -139,6 +262,10 @@ static int notrace unwind_frame(struct task_struct *tsk,
 		frame->pc = kretprobe_find_ret_addr(tsk, (void *)frame->fp, &frame->kr_cur);
 #endif
 
+	/* If it is the final frame, no need to check reliability. */
+	if (frame->fp != (unsigned long)task_pt_regs(tsk)->stackframe)
+		unwind_check_frame(frame);
+
 	return 0;
 }
 NOKPROBE_SYMBOL(unwind_frame);
@@ -210,3 +337,29 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 
 	walk_stackframe(task, &frame, consume_entry, cookie);
 }
+
+noinline int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
+			      void *cookie, struct task_struct *task)
+{
+	struct stackframe frame;
+	int ret = 0;
+
+	if (task == current) {
+		start_backtrace(&frame,
+				(unsigned long)__builtin_frame_address(1),
+				(unsigned long)__builtin_return_address(0));
+	} else {
+		start_backtrace(&frame, thread_saved_fp(task),
+				thread_saved_pc(task));
+	}
+
+	while (!ret) {
+		if (!frame.reliable)
+			return -EINVAL;
+		if (!consume_entry(cookie, frame.pc))
+			return -EINVAL;
+		ret = unwind_frame(task, &frame);
+	}
+
+	return ret == -ENOENT ? 0 : -EINVAL;
+}
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 4816b7e11047..2324f0b25674 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -616,6 +616,10 @@ extern int ftrace_update_ftrace_func(ftrace_func_t func);
 extern void ftrace_caller(void);
 extern void ftrace_regs_caller(void);
 extern void ftrace_call(void);
+extern void ftrace_call_entry(void);
+extern void ftrace_graph_caller_entry(void);
+extern void ftrace_callsite(void);
+extern bool is_ftrace_entry(unsigned long pc);
 extern void ftrace_regs_call(void);
 extern void mcount_call(void);
 
-- 
2.25.1

