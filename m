Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9FD483520
	for <lists+live-patching@lfdr.de>; Mon,  3 Jan 2022 17:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbiACQwt (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 Jan 2022 11:52:49 -0500
Received: from linux.microsoft.com ([13.77.154.182]:53198 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbiACQwr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 Jan 2022 11:52:47 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id CE73A20B7185;
        Mon,  3 Jan 2022 08:52:46 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CE73A20B7185
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1641228767;
        bh=CypTM8/tYm9H4rq+eanWDFrMlvgKtxFpVbwHffdlOTw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=cGXHjtTndquuMwttSOuTNfzk+aaI7X6j3AtZ6zGgXvg75D8LVeY3SoNXNAOAVTam9
         VQxadth6hjIbmL4nTt7/iwVwLfjnG7ztsrPrNRtnX1q+1roCmm/e6Oq/4O8lL6jp9u
         /1q0KfcNpcMWTCMUQIFE3V4ve4CjOYxF9rxCIa0M=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v12 03/10] arm64: Rename stackframe to unwind_state
Date:   Mon,  3 Jan 2022 10:52:05 -0600
Message-Id: <20220103165212.9303-4-madvenka@linux.microsoft.com>
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

Rename "struct stackframe" to "struct unwind_state" for consistency and
better naming. Accordingly, rename variable/argument "frame" to "state".

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/stacktrace.h |  2 +-
 arch/arm64/kernel/stacktrace.c      | 66 ++++++++++++++---------------
 2 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 3a15d376ab36..fc828c3c5dfd 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -52,7 +52,7 @@ struct stack_info {
  *               associated with the most recently encountered replacement lr
  *               value.
  */
-struct stackframe {
+struct unwind_state {
 	unsigned long fp;
 	unsigned long pc;
 	DECLARE_BITMAP(stacks_done, __NR_STACK_TYPES);
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index b980d96dccfc..a1a7ff93b84f 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -33,13 +33,13 @@
  */
 
 
-static void unwind_init(struct stackframe *frame, unsigned long fp,
+static void unwind_init(struct unwind_state *state, unsigned long fp,
 			unsigned long pc)
 {
-	frame->fp = fp;
-	frame->pc = pc;
+	state->fp = fp;
+	state->pc = pc;
 #ifdef CONFIG_KRETPROBES
-	frame->kr_cur = NULL;
+	state->kr_cur = NULL;
 #endif
 
 	/*
@@ -51,9 +51,9 @@ static void unwind_init(struct stackframe *frame, unsigned long fp,
 	 * prev_fp value won't be used, but we set it to 0 such that it is
 	 * definitely not an accessible stack address.
 	 */
-	bitmap_zero(frame->stacks_done, __NR_STACK_TYPES);
-	frame->prev_fp = 0;
-	frame->prev_type = STACK_TYPE_UNKNOWN;
+	bitmap_zero(state->stacks_done, __NR_STACK_TYPES);
+	state->prev_fp = 0;
+	state->prev_type = STACK_TYPE_UNKNOWN;
 }
 
 /*
@@ -64,9 +64,9 @@ static void unwind_init(struct stackframe *frame, unsigned long fp,
  * and the location (but not the fp value) of B.
  */
 static int notrace unwind_next(struct task_struct *tsk,
-			       struct stackframe *frame)
+			       struct unwind_state *state)
 {
-	unsigned long fp = frame->fp;
+	unsigned long fp = state->fp;
 	struct stack_info info;
 
 	/* Final frame; nothing to unwind */
@@ -79,7 +79,7 @@ static int notrace unwind_next(struct task_struct *tsk,
 	if (!on_accessible_stack(tsk, fp, 16, &info))
 		return -EINVAL;
 
-	if (test_bit(info.type, frame->stacks_done))
+	if (test_bit(info.type, state->stacks_done))
 		return -EINVAL;
 
 	/*
@@ -95,27 +95,27 @@ static int notrace unwind_next(struct task_struct *tsk,
 	 * stack to another, it's never valid to unwind back to that first
 	 * stack.
 	 */
-	if (info.type == frame->prev_type) {
-		if (fp <= frame->prev_fp)
+	if (info.type == state->prev_type) {
+		if (fp <= state->prev_fp)
 			return -EINVAL;
 	} else {
-		set_bit(frame->prev_type, frame->stacks_done);
+		set_bit(state->prev_type, state->stacks_done);
 	}
 
 	/*
 	 * Record this frame record's values and location. The prev_fp and
 	 * prev_type are only meaningful to the next unwind_next() invocation.
 	 */
-	frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp));
-	frame->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp + 8));
-	frame->prev_fp = fp;
-	frame->prev_type = info.type;
+	state->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp));
+	state->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp + 8));
+	state->prev_fp = fp;
+	state->prev_type = info.type;
 
-	frame->pc = ptrauth_strip_insn_pac(frame->pc);
+	state->pc = ptrauth_strip_insn_pac(state->pc);
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	if (tsk->ret_stack &&
-		(frame->pc == (unsigned long)return_to_handler)) {
+		(state->pc == (unsigned long)return_to_handler)) {
 		unsigned long orig_pc;
 		/*
 		 * This is a case where function graph tracer has
@@ -123,16 +123,16 @@ static int notrace unwind_next(struct task_struct *tsk,
 		 * to hook a function return.
 		 * So replace it to an original value.
 		 */
-		orig_pc = ftrace_graph_ret_addr(tsk, NULL, frame->pc,
-						(void *)frame->fp);
-		if (WARN_ON_ONCE(frame->pc == orig_pc))
+		orig_pc = ftrace_graph_ret_addr(tsk, NULL, state->pc,
+						(void *)state->fp);
+		if (WARN_ON_ONCE(state->pc == orig_pc))
 			return -EINVAL;
-		frame->pc = orig_pc;
+		state->pc = orig_pc;
 	}
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 #ifdef CONFIG_KRETPROBES
-	if (is_kretprobe_trampoline(frame->pc))
-		frame->pc = kretprobe_find_ret_addr(tsk, (void *)frame->fp, &frame->kr_cur);
+	if (is_kretprobe_trampoline(state->pc))
+		state->pc = kretprobe_find_ret_addr(tsk, (void *)state->fp, &state->kr_cur);
 #endif
 
 	return 0;
@@ -140,15 +140,15 @@ static int notrace unwind_next(struct task_struct *tsk,
 NOKPROBE_SYMBOL(unwind_next);
 
 static void notrace unwind(struct task_struct *tsk,
-			   struct stackframe *frame,
+			   struct unwind_state *state,
 			   bool (*fn)(void *, unsigned long), void *data)
 {
 	while (1) {
 		int ret;
 
-		if (!fn(data, frame->pc))
+		if (!fn(data, state->pc))
 			break;
-		ret = unwind_next(tsk, frame);
+		ret = unwind_next(tsk, state);
 		if (ret < 0)
 			break;
 	}
@@ -192,17 +192,17 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 			      void *cookie, struct task_struct *task,
 			      struct pt_regs *regs)
 {
-	struct stackframe frame;
+	struct unwind_state state;
 
 	if (regs)
-		unwind_init(&frame, regs->regs[29], regs->pc);
+		unwind_init(&state, regs->regs[29], regs->pc);
 	else if (task == current)
-		unwind_init(&frame,
+		unwind_init(&state,
 				(unsigned long)__builtin_frame_address(1),
 				(unsigned long)__builtin_return_address(0));
 	else
-		unwind_init(&frame, thread_saved_fp(task),
+		unwind_init(&state, thread_saved_fp(task),
 				thread_saved_pc(task));
 
-	unwind(task, &frame, consume_entry, cookie);
+	unwind(task, &state, consume_entry, cookie);
 }
-- 
2.25.1

