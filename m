Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E8D56A689
	for <lists+live-patching@lfdr.de>; Thu,  7 Jul 2022 17:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235695AbiGGPBq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 7 Jul 2022 11:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235371AbiGGPBo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 7 Jul 2022 11:01:44 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 734AA2BDF;
        Thu,  7 Jul 2022 08:01:43 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7014820CD165;
        Thu,  7 Jul 2022 08:01:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7014820CD165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1657206103;
        bh=G21EJ7SE+XCC9ZZMsTm4WIVXZYvt5Jnw7LGE7kc6+dk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ZQJIpVH5rS7VIG12aACYGcGJNPvADzsro7W8i4AjYnknKRhsGshuf222V7fq6vg5M
         kEXc/KPgv5JEy5TeRlizs79B2aL9d8DzrJ6284Srytd2opCjm5RN/fAsxMA0iLfOqN
         JKa6zsgQwRXzbWHZYUxhaakBdbgSWGzRlV85onNA=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v16 1/1] arm64: Make the unwind loop similar to other architectures
Date:   Thu,  7 Jul 2022 10:01:34 -0500
Message-Id: <20220707150134.4614-2-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220707150134.4614-1-madvenka@linux.microsoft.com>
References: <1be3f2d391cd5d29da988242375c5fbc79aebb8f>
 <20220707150134.4614-1-madvenka@linux.microsoft.com>
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

Change the unwind loop to this
==============================

	for (unwind_start(&state, task, regs); !unwind_done(state);
	     unwind_next(state)) {

		if (unwind_failed(state)) {
			/* PC is suspect. Cannot consume it. */
			return;
		}

		if (!consume_entry(cookie, state->pc)) {
			/* Caller terminated the unwind. */
			return;
		}
	}

unwind_start()
==============

Define this new function to perform all of the initialization prior to
doing a stack trace. So, the unwind_init_*() functions will be called
from here.

unwind_done()
=============

Define this new helper function to return true upon reaching the end
of the stack successfully.

unwind_failed()
===============

Define this new helper function to return true if any type of stack
corruption is detected.

unwind_next()
=============

Change this function to record stack corruption or other failures in the
state rather than return an error.

Use the unwind loop directly in arch_stack_walk()
=================================================

Remove the unwind() function. Instead, inline the unwind loop in
arch_stack_walk().

In the future, arch_stack_walk_reliable() will also inline the unwind
loop and add reliability checks to the loop.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/stacktrace.c | 121 ++++++++++++++++++++++-----------
 1 file changed, 81 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index fcaa151b81f1..3ddf0f9ae081 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -40,6 +40,12 @@
  *               value.
  *
  * @task:        The task being unwound.
+ *
+ * @final_fp:    Pointer to the final frame.
+ *
+ * @done:        Unwind completed successfully.
+ *
+ * @failed:      Unwind failed.
  */
 struct unwind_state {
 	unsigned long fp;
@@ -51,6 +57,9 @@ struct unwind_state {
 	struct llist_node *kr_cur;
 #endif
 	struct task_struct *task;
+	unsigned long final_fp;
+	bool done;
+	bool failed;
 };
 
 static void unwind_init_common(struct unwind_state *state,
@@ -73,6 +82,26 @@ static void unwind_init_common(struct unwind_state *state,
 	bitmap_zero(state->stacks_done, __NR_STACK_TYPES);
 	state->prev_fp = 0;
 	state->prev_type = STACK_TYPE_UNKNOWN;
+	state->done = false;
+	state->failed = false;
+
+	/* Stack trace terminates here. */
+	state->final_fp = (unsigned long)task_pt_regs(task)->stackframe;
+}
+
+static inline bool unwind_final_frame(struct unwind_state *state)
+{
+	return state->fp == state->final_fp;
+}
+
+static inline bool unwind_done(struct unwind_state *state)
+{
+	return state->done;
+}
+
+static inline bool unwind_failed(struct unwind_state *state)
+{
+	return state->failed;
 }
 
 /*
@@ -133,24 +162,31 @@ static inline void unwind_init_from_task(struct unwind_state *state,
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
+	if (unwind_final_frame(state)) {
+		state->done = true;
+		return;
+	}
 
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
@@ -166,8 +202,10 @@ static int notrace unwind_next(struct unwind_state *state)
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
 		__set_bit(state->prev_type, state->stacks_done);
 	}
@@ -195,8 +233,10 @@ static int notrace unwind_next(struct unwind_state *state)
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
@@ -204,26 +244,9 @@ static int notrace unwind_next(struct unwind_state *state)
 	if (is_kretprobe_trampoline(state->pc))
 		state->pc = kretprobe_find_ret_addr(tsk, (void *)state->fp, &state->kr_cur);
 #endif
-
-	return 0;
 }
 NOKPROBE_SYMBOL(unwind_next);
 
-static void notrace unwind(struct unwind_state *state,
-			   stack_trace_consume_fn consume_entry, void *cookie)
-{
-	while (1) {
-		int ret;
-
-		if (!consume_entry(cookie, state->pc))
-			break;
-		ret = unwind_next(state);
-		if (ret < 0)
-			break;
-	}
-}
-NOKPROBE_SYMBOL(unwind);
-
 static bool dump_backtrace_entry(void *arg, unsigned long where)
 {
 	char *loglvl = arg;
@@ -257,21 +280,39 @@ void show_stack(struct task_struct *tsk, unsigned long *sp, const char *loglvl)
 	barrier();
 }
 
+static __always_inline void unwind_start(struct unwind_state *state,
+					 struct task_struct *task,
+					 struct pt_regs *regs)
+{
+	if (regs)
+		unwind_init_from_regs(state, regs);
+	else if (task == current)
+		unwind_init_from_caller(state);
+	else
+		unwind_init_from_task(state, task);
+
+}
+
 noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 			      void *cookie, struct task_struct *task,
 			      struct pt_regs *regs)
 {
 	struct unwind_state state;
 
-	if (regs) {
-		if (task != current)
+	if (regs && task != current)
+		return;
+
+	for (unwind_start(&state, task, regs); !unwind_done(&state);
+	     unwind_next(&state)) {
+
+		if (unwind_failed(&state)) {
+			/* PC is suspect. Cannot consume it. */
 			return;
-		unwind_init_from_regs(&state, regs);
-	} else if (task == current) {
-		unwind_init_from_caller(&state);
-	} else {
-		unwind_init_from_task(&state, task);
-	}
+		}
 
-	unwind(&state, consume_entry, cookie);
+		if (!consume_entry(cookie, state.pc)) {
+			/* Caller terminated the unwind. */
+			return;
+		}
+	}
 }
-- 
2.25.1

