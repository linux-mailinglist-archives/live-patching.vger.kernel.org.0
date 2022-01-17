Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01815490ADF
	for <lists+live-patching@lfdr.de>; Mon, 17 Jan 2022 15:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240267AbiAQO4h (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 17 Jan 2022 09:56:37 -0500
Received: from linux.microsoft.com ([13.77.154.182]:59502 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240048AbiAQO4c (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 17 Jan 2022 09:56:32 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id E00C620B913D;
        Mon, 17 Jan 2022 06:56:30 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E00C620B913D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1642431391;
        bh=ZhoGzr5Fv5bSybGDUyS+xs/qmB4s2zJk9d0Xu+fRQ/I=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Sxlm95ovv7KYAdyqSO8ETsDjzRa64NrRhOPqwk+/WX9uvsPqtDPO8iDj849Vgrw6c
         KHcjy670Cv1nD0Owt0eq0a9WILtP5mClBNV71dv61ayqYmcJ/H/+IIaWY95BWTywb9
         LK2ICaOSmcKF5iPizI0TAHIXwCUE9GdTDxL4VMbk=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v13 07/11] arm64: Make the unwind loop in unwind() similar to other architectures
Date:   Mon, 17 Jan 2022 08:56:04 -0600
Message-Id: <20220117145608.6781-8-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220117145608.6781-1-madvenka@linux.microsoft.com>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Change the loop in unwind()
===========================

Change the unwind loop in unwind() to:

	while (unwind_continue(state, consume_entry, cookie))
		unwind_next(state);

This is easy to understand and maintain.

New function unwind_continue()
==============================

Define a new function unwind_continue() that is used in the unwind loop
to check for conditions that terminate a stack trace.

The conditions checked are:

	- If the bottom of the stack (final frame) has been reached,
	  terminate.

	- If the consume_entry() function returns false, the caller of
	  unwind has asked to terminate the stack trace. So, terminate.

	- If unwind_next() failed for some reason (like stack corruption),
	  terminate.

Do not return an error value from unwind_next()
===============================================

We want to check for terminating conditions only in unwind_continue() from
the unwinder loop. So, do not return an error value from unwind_next().
Simply set a flag in unwind_state and check the flag in unwind_continue().

Final FP
========

Introduce a new field "final_fp" in "struct unwind_state". Initialize this
to the final frame of the stack trace:

	task_pt_regs(task)->stackframe

This is where the stacktrace must terminate if it is successful. Add an
explicit comment to that effect.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/stacktrace.h |  6 +++
 arch/arm64/kernel/stacktrace.c      | 72 ++++++++++++++++++-----------
 2 files changed, 52 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index af423f5d7ad8..c11b048ffd0e 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -53,6 +53,10 @@ struct stack_info {
  *               value.
  *
  * @task:        Pointer to the task structure.
+ *
+ * @final_fp	 Pointer to the final frame.
+ *
+ * @failed:      Unwind failed.
  */
 struct unwind_state {
 	unsigned long fp;
@@ -64,6 +68,8 @@ struct unwind_state {
 	struct llist_node *kr_cur;
 #endif
 	struct task_struct *task;
+	unsigned long final_fp;
+	bool failed;
 };
 
 extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index f772dac78b11..73fc6b5ee6fd 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -53,6 +53,10 @@ static void unwind_init_common(struct unwind_state *state,
 	bitmap_zero(state->stacks_done, __NR_STACK_TYPES);
 	state->prev_fp = 0;
 	state->prev_type = STACK_TYPE_UNKNOWN;
+	state->failed = false;
+
+	/* Stack trace terminates here. */
+	state->final_fp = (unsigned long)task_pt_regs(task)->stackframe;
 }
 
 /*
@@ -97,6 +101,25 @@ static inline void unwind_init_from_task(struct unwind_state *state,
 	state->pc = thread_saved_pc(task);
 }
 
+static bool notrace unwind_continue(struct unwind_state *state,
+				    stack_trace_consume_fn consume_entry,
+				    void *cookie)
+{
+	if (state->failed) {
+		/* PC is suspect. Cannot consume it. */
+		return false;
+	}
+
+	if (!consume_entry(cookie, state->pc)) {
+		/* Caller terminated the unwind. */
+		state->failed = true;
+		return false;
+	}
+
+	return state->fp != state->final_fp;
+}
+NOKPROBE_SYMBOL(unwind_continue);
+
 /*
  * Unwind from one frame record (A) to the next frame record (B).
  *
@@ -104,24 +127,26 @@ static inline void unwind_init_from_task(struct unwind_state *state,
  * records (e.g. a cycle), determined based on the location and fp value of A
  * and the location (but not the fp value) of B.
  */
-static int notrace unwind_next(struct unwind_state *state)
+static void notrace unwind_next(struct unwind_state *state)
 {
 	unsigned long fp = state->fp;
 	struct stack_info info;
 	struct task_struct *tsk = state->task;
 
-	/* Final frame; nothing to unwind */
-	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
-		return -ENOENT;
-
-	if (fp & 0x7)
-		return -EINVAL;
+	if (fp & 0x7) {
+		state->failed = true;
+		return;
+	}
 
-	if (!on_accessible_stack(tsk, fp, 16, &info))
-		return -EINVAL;
+	if (!on_accessible_stack(tsk, fp, 16, &info)) {
+		state->failed = true;
+		return;
+	}
 
-	if (test_bit(info.type, state->stacks_done))
-		return -EINVAL;
+	if (test_bit(info.type, state->stacks_done)) {
+		state->failed = true;
+		return;
+	}
 
 	/*
 	 * As stacks grow downward, any valid record on the same stack must be
@@ -137,8 +162,10 @@ static int notrace unwind_next(struct unwind_state *state)
 	 * stack.
 	 */
 	if (info.type == state->prev_type) {
-		if (fp <= state->prev_fp)
-			return -EINVAL;
+		if (fp <= state->prev_fp) {
+			state->failed = true;
+			return;
+		}
 	} else {
 		set_bit(state->prev_type, state->stacks_done);
 	}
@@ -166,8 +193,10 @@ static int notrace unwind_next(struct unwind_state *state)
 		 */
 		orig_pc = ftrace_graph_ret_addr(tsk, NULL, state->pc,
 						(void *)state->fp);
-		if (WARN_ON_ONCE(state->pc == orig_pc))
-			return -EINVAL;
+		if (WARN_ON_ONCE(state->pc == orig_pc)) {
+			state->failed = true;
+			return;
+		}
 		state->pc = orig_pc;
 	}
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
@@ -175,23 +204,14 @@ static int notrace unwind_next(struct unwind_state *state)
 	if (is_kretprobe_trampoline(state->pc))
 		state->pc = kretprobe_find_ret_addr(tsk, (void *)state->fp, &state->kr_cur);
 #endif
-
-	return 0;
 }
 NOKPROBE_SYMBOL(unwind_next);
 
 static void notrace unwind(struct unwind_state *state,
 			   stack_trace_consume_fn consume_entry, void *cookie)
 {
-	while (1) {
-		int ret;
-
-		if (!consume_entry(cookie, state->pc))
-			break;
-		ret = unwind_next(state);
-		if (ret < 0)
-			break;
-	}
+	while (unwind_continue(state, consume_entry, cookie))
+		unwind_next(state);
 }
 NOKPROBE_SYMBOL(unwind);
 
-- 
2.25.1

