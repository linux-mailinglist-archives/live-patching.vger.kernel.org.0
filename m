Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADAA4483524
	for <lists+live-patching@lfdr.de>; Mon,  3 Jan 2022 17:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbiACQwv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 Jan 2022 11:52:51 -0500
Received: from linux.microsoft.com ([13.77.154.182]:53258 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbiACQwv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 Jan 2022 11:52:51 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id CD83920B7189;
        Mon,  3 Jan 2022 08:52:49 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CD83920B7189
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1641228770;
        bh=ZYsAIIQWNkzUjPZHyFb4uiuraQ+DJVDMfx0RavVNtlw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rLG4paSwHHt9dfLGWUHF9y/6vMCw61ZwGhiCBpXWIvlVm16p6geI9IslDjRQW6t7q
         zwCfQJXPLRUim9WZ27Eel7yv8Av5yV8j14DbWKyRDX9QPpoalUweWlTVGjeGLuUSV9
         /xEI9H7+DG9/3nWQ3q+G/Fid0IEwigqtQTvJOAaA=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v12 06/10] arm64: Make the unwind loop in unwind() similar to other architectures
Date:   Mon,  3 Jan 2022 10:52:08 -0600
Message-Id: <20220103165212.9303-7-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220103165212.9303-1-madvenka@linux.microsoft.com>
References: <0d0eb36f348fb5a6af6eb592c0525f6e94007328>
 <20220103165212.9303-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Change the loop in unwind()
===========================

Change the unwind loop in unwind() to:

	while (unwind_continue(state))
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
 arch/arm64/kernel/stacktrace.c      | 70 ++++++++++++++++++-----------
 2 files changed, 50 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 322817d40a75..9d1fddc26586 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -59,6 +59,10 @@ struct stack_info {
  * @consume_pc   Consume PC function pointer.
  *
  * @cookie       Argument to consume_pc().
+ *
+ * @final_fp	 Pointer to the final frame.
+ *
+ * @failed:      Unwind failed.
  */
 struct unwind_state {
 	unsigned long fp;
@@ -73,6 +77,8 @@ struct unwind_state {
 	struct pt_regs *regs;
 	stack_trace_consume_fn consume_pc;
 	void *cookie;
+	unsigned long final_fp;
+	bool failed;
 };
 
 extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 3ecb8242caa5..af0949f028c9 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -60,6 +60,10 @@ static void unwind_init_common(struct unwind_state *state,
 	bitmap_zero(state->stacks_done, __NR_STACK_TYPES);
 	state->prev_fp = 0;
 	state->prev_type = STACK_TYPE_UNKNOWN;
+	state->failed = false;
+
+	/* Stack trace terminates here. */
+	state->final_fp = (unsigned long)task_pt_regs(task)->stackframe;
 }
 
 /*
@@ -94,6 +98,23 @@ static inline void unwind_init_task(struct unwind_state *state)
 	state->pc = thread_saved_pc(state->task);
 }
 
+static bool notrace unwind_continue(struct unwind_state *state)
+{
+	if (state->failed) {
+		/* PC is suspect. Cannot consume it. */
+		return false;
+	}
+
+	if (!state->consume_pc(state->cookie, state->pc)) {
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
@@ -101,24 +122,26 @@ static inline void unwind_init_task(struct unwind_state *state)
  * records (e.g. a cycle), determined based on the location and fp value of A
  * and the location (but not the fp value) of B.
  */
-static int notrace unwind_next(struct unwind_state *state)
+static void notrace unwind_next(struct unwind_state *state)
 {
 	struct task_struct *tsk = state->task;
 	unsigned long fp = state->fp;
 	struct stack_info info;
 
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
@@ -134,8 +157,10 @@ static int notrace unwind_next(struct unwind_state *state)
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
@@ -163,8 +188,10 @@ static int notrace unwind_next(struct unwind_state *state)
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
@@ -172,22 +199,13 @@ static int notrace unwind_next(struct unwind_state *state)
 	if (is_kretprobe_trampoline(state->pc))
 		state->pc = kretprobe_find_ret_addr(tsk, (void *)state->fp, &state->kr_cur);
 #endif
-
-	return 0;
 }
 NOKPROBE_SYMBOL(unwind_next);
 
 static void notrace unwind(struct unwind_state *state)
 {
-	while (1) {
-		int ret;
-
-		if (!state->consume_pc(state->cookie, state->pc))
-			break;
-		ret = unwind_next(state);
-		if (ret < 0)
-			break;
-	}
+	while (unwind_continue(state))
+		unwind_next(state);
 }
 NOKPROBE_SYMBOL(unwind);
 
-- 
2.25.1

