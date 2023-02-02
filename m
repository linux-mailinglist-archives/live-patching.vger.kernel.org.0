Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6066876A7
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 08:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbjBBHnm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 02:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbjBBHnS (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 02:43:18 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 894DF84B41;
        Wed,  1 Feb 2023 23:42:44 -0800 (PST)
Received: from x64host.home (unknown [47.187.213.40])
        by linux.microsoft.com (Postfix) with ESMTPSA id 96F9F2086204;
        Wed,  1 Feb 2023 23:42:43 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 96F9F2086204
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675323764;
        bh=syyTIiCMmSq1Y7SegNUoz2WcQt0ayamimN+gUTnents=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=WNHp0Jg1XbGogtJLrp5HyBNcrB4/SAW3s5VtOmHsMAQedVtxDSEwAcbSowjtwErlN
         GSCZM2JHP1+z7YnZ1dgrIIFYPPSuaZg/Lq4TQIZN3cFCowOpO2kthYr3V0zV+vKMhP
         OHvRhwArCvYdD2JlUCNArkstF0j4ElJXLhrwIm5U=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 19/22] arm64: unwinder: Add a reliability check in the unwinder based on ORC
Date:   Thu,  2 Feb 2023 01:40:33 -0600
Message-Id: <20230202074036.507249-20-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202074036.507249-1-madvenka@linux.microsoft.com>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Introduce a reliability flag in struct unwind_state. This will be set to
false if the PC does not have a valid ORC or if the frame pointer computed
from the ORC does not match the actual frame pointer.

Now that the unwinder can validate the frame pointer, introduce
arch_stack_walk_reliable().

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/stacktrace/common.h |  15 ++
 arch/arm64/kernel/stacktrace.c             | 167 ++++++++++++++++++++-
 2 files changed, 175 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace/common.h b/arch/arm64/include/asm/stacktrace/common.h
index 508f734de46e..064aaf5dc3a0 100644
--- a/arch/arm64/include/asm/stacktrace/common.h
+++ b/arch/arm64/include/asm/stacktrace/common.h
@@ -11,6 +11,7 @@
 
 #include <linux/kprobes.h>
 #include <linux/types.h>
+#include <linux/objtool.h>
 
 struct stack_info {
 	unsigned long low;
@@ -23,6 +24,7 @@ struct stack_info {
  * @fp:          The fp value in the frame record (or the real fp)
  * @pc:          The lr value in the frame record (or the real lr)
  *
+ * @prev_pc:     The lr value in the previous frame record.
  * @kr_cur:      When KRETPROBES is selected, holds the kretprobe instance
  *               associated with the most recently encountered replacement lr
  *               value.
@@ -32,10 +34,15 @@ struct stack_info {
  * @stack:       The stack currently being unwound.
  * @stacks:      An array of stacks which can be unwound.
  * @nr_stacks:   The number of stacks in @stacks.
+ *
+ * @cfa:         The sp value at the call site of the current function.
+ * @unwind_type  The previous frame's unwind type.
+ * @reliable:    Stack trace is reliable.
  */
 struct unwind_state {
 	unsigned long fp;
 	unsigned long pc;
+	unsigned long prev_pc;
 #ifdef CONFIG_KRETPROBES
 	struct llist_node *kr_cur;
 #endif
@@ -44,6 +51,9 @@ struct unwind_state {
 	struct stack_info stack;
 	struct stack_info *stacks;
 	int nr_stacks;
+	unsigned long cfa;
+	int unwind_type;
+	bool reliable;
 };
 
 static inline struct stack_info stackinfo_get_unknown(void)
@@ -70,11 +80,15 @@ static inline void unwind_init_common(struct unwind_state *state,
 				      struct task_struct *task)
 {
 	state->task = task;
+	state->prev_pc = 0;
 #ifdef CONFIG_KRETPROBES
 	state->kr_cur = NULL;
 #endif
 
 	state->stack = stackinfo_get_unknown();
+	state->reliable = true;
+	state->cfa = 0;
+	state->unwind_type = UNWIND_HINT_TYPE_CALL;
 }
 
 static struct stack_info *unwind_find_next_stack(const struct unwind_state *state,
@@ -167,6 +181,7 @@ unwind_next_frame_record(struct unwind_state *state)
 	/*
 	 * Record this frame record's values.
 	 */
+	state->prev_pc = state->pc;
 	state->fp = READ_ONCE(*(unsigned long *)(fp));
 	state->pc = READ_ONCE(*(unsigned long *)(fp + 8));
 
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 634279b3b03d..fbcb14539816 100644
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
 #include <linux/sched.h>
@@ -16,6 +18,122 @@
 #include <asm/stack_pointer.h>
 #include <asm/stacktrace.h>
 
+static inline bool unwind_completed(struct unwind_state *state)
+{
+	if (state->fp == (unsigned long)task_pt_regs(state->task)->stackframe) {
+		/* Final frame; nothing to unwind */
+		return true;
+	}
+	return false;
+}
+
+#ifdef CONFIG_FRAME_POINTER_VALIDATION
+
+static void unwind_check_reliable(struct unwind_state *state)
+{
+	unsigned long pc, fp;
+	struct orc_entry *orc;
+	bool adjust_pc = false;
+
+	if (unwind_completed(state))
+		return;
+
+	/*
+	 * If a previous frame was unreliable, the CFA cannot be reliably
+	 * computed anymore.
+	 */
+	if (!state->reliable)
+		return;
+
+	pc = state->pc;
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
+		if (state->unwind_type == UNWIND_HINT_TYPE_CALL) {
+			pc -= 4;
+			adjust_pc = true;
+			orc = orc_find(pc);
+		}
+	}
+	if (!orc) {
+		state->reliable = false;
+		goto out;
+	}
+	state->unwind_type = orc->type;
+
+	if (!state->cfa) {
+		/* Set up the initial CFA and return. */
+		state->cfa = state->fp - orc->fp_offset;
+		goto out;
+	}
+
+	/* Compute the next CFA and FP. */
+	switch (orc->type) {
+	case UNWIND_HINT_TYPE_CALL:
+		/* Normal call */
+		state->cfa += orc->sp_offset;
+		fp = state->cfa + orc->fp_offset;
+		break;
+
+	case UNWIND_HINT_TYPE_REGS:
+		/*
+		 * pt_regs hint: The frame pointer points to either the
+		 * synthetic frame within pt_regs or to the place where
+		 * x29 and x30 are saved in the register save area in
+		 * pt_regs.
+		 */
+		state->cfa += orc->sp_offset;
+		fp = state->cfa + offsetof(struct pt_regs, stackframe) -
+		     sizeof(struct pt_regs);
+		if (state->fp != fp) {
+			fp = state->cfa + offsetof(struct pt_regs, regs[29]) -
+			     sizeof(struct pt_regs);
+		}
+		break;
+
+	case UNWIND_HINT_TYPE_IRQ_STACK:
+		/* Hint to unwind from the IRQ stack to the task stack. */
+		state->cfa = state->fp + orc->sp_offset;
+		fp = state->fp;
+		break;
+
+	default:
+		fp = 0;
+		break;
+	}
+
+	/* Validate the actual FP with the computed one. */
+	if (state->fp != fp)
+		state->reliable = false;
+out:
+	if (state->reliable && adjust_pc)
+		state->pc = pc;
+	preempt_enable();
+}
+
+#else /* !CONFIG_FRAME_POINTER_VALIDATION */
+
+static void unwind_check_reliable(struct unwind_state *state)
+{
+}
+
+#endif /* CONFIG_FRAME_POINTER_VALIDATION */
+
 /*
  * Start an unwind from a pt_regs.
  *
@@ -77,11 +195,9 @@ static inline void unwind_init_from_task(struct unwind_state *state,
 static int notrace unwind_next(struct unwind_state *state)
 {
 	struct task_struct *tsk = state->task;
-	unsigned long fp = state->fp;
 	int err;
 
-	/* Final frame; nothing to unwind */
-	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
+	if (unwind_completed(state))
 		return -ENOENT;
 
 	err = unwind_next_frame_record(state);
@@ -116,18 +232,23 @@ static int notrace unwind_next(struct unwind_state *state)
 }
 NOKPROBE_SYMBOL(unwind_next);
 
-static void notrace unwind(struct unwind_state *state,
+static int notrace unwind(struct unwind_state *state, bool need_reliable,
 			   stack_trace_consume_fn consume_entry, void *cookie)
 {
-	while (1) {
-		int ret;
+	int ret = 0;
 
+	while (1) {
+		if (need_reliable && !state->reliable)
+			return -EINVAL;
 		if (!consume_entry(cookie, state->pc))
 			break;
 		ret = unwind_next(state);
+		if (need_reliable && !ret)
+			unwind_check_reliable(state);
 		if (ret < 0)
 			break;
 	}
+	return ret;
 }
 NOKPROBE_SYMBOL(unwind);
 
@@ -216,5 +337,37 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 		unwind_init_from_task(&state, task);
 	}
 
-	unwind(&state, consume_entry, cookie);
+	unwind(&state, false, consume_entry, cookie);
+}
+
+noinline notrace int arch_stack_walk_reliable(
+				stack_trace_consume_fn consume_entry,
+				void *cookie, struct task_struct *task)
+{
+	struct stack_info stacks[] = {
+		stackinfo_get_task(task),
+		STACKINFO_CPU(irq),
+#if defined(CONFIG_VMAP_STACK)
+		STACKINFO_CPU(overflow),
+#endif
+#if defined(CONFIG_VMAP_STACK) && defined(CONFIG_ARM_SDE_INTERFACE)
+		STACKINFO_SDEI(normal),
+		STACKINFO_SDEI(critical),
+#endif
+	};
+	struct unwind_state state = {
+		.stacks = stacks,
+		.nr_stacks = ARRAY_SIZE(stacks),
+	};
+	int ret;
+
+	if (task == current)
+		unwind_init_from_caller(&state);
+	else
+		unwind_init_from_task(&state, task);
+	unwind_check_reliable(&state);
+
+	ret = unwind(&state, true, consume_entry, cookie);
+
+	return ret == -ENOENT ? 0 : -EINVAL;
 }
-- 
2.25.1

