Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB22C490ADE
	for <lists+live-patching@lfdr.de>; Mon, 17 Jan 2022 15:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240248AbiAQO4f (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 17 Jan 2022 09:56:35 -0500
Received: from linux.microsoft.com ([13.77.154.182]:59472 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239896AbiAQO4a (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 17 Jan 2022 09:56:30 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id E00A120B9138;
        Mon, 17 Jan 2022 06:56:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E00A120B9138
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1642431389;
        bh=HZJdhCECd6gjD/mxDs8WLqHpl5qu7cQyOQ3KiJ9KXYU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=nP/zzg3esa0VcP74oi3KabpAsDkeUAmwCdd3XX795VVJNrJJOrkjrEG+ip0EYSTX0
         VZirOXFdgxuMxMdw1phY5C/akDYDFDy498xDaCgkr2uw3fYghmIRmcpSHRmR0/P6W9
         wsbOySuf6qIH11D3mw1x/v/qLW86O76WdcdKtStM=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v13 05/11] arm64: Copy the task argument to unwind_state
Date:   Mon, 17 Jan 2022 08:56:02 -0600
Message-Id: <20220117145608.6781-6-madvenka@linux.microsoft.com>
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

Copy the task argument passed to arch_stack_walk() to unwind_state so that
it can be passed to unwind functions via unwind_state rather than as a
separate argument. The task is a fundamental part of the unwind state.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/stacktrace.h |  3 +++
 arch/arm64/kernel/stacktrace.c      | 29 ++++++++++++++++-------------
 2 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 41ec360515f6..af423f5d7ad8 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -51,6 +51,8 @@ struct stack_info {
  * @kr_cur:      When KRETPROBES is selected, holds the kretprobe instance
  *               associated with the most recently encountered replacement lr
  *               value.
+ *
+ * @task:        Pointer to the task structure.
  */
 struct unwind_state {
 	unsigned long fp;
@@ -61,6 +63,7 @@ struct unwind_state {
 #ifdef CONFIG_KRETPROBES
 	struct llist_node *kr_cur;
 #endif
+	struct task_struct *task;
 };
 
 extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index b2b568e5deba..1b32e55735aa 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -33,8 +33,10 @@
  */
 
 
-static void unwind_init_common(struct unwind_state *state)
+static void unwind_init_common(struct unwind_state *state,
+			       struct task_struct *task)
 {
+	state->task = task;
 #ifdef CONFIG_KRETPROBES
 	state->kr_cur = NULL;
 #endif
@@ -57,9 +59,10 @@ static void unwind_init_common(struct unwind_state *state)
  * TODO: document requirements here.
  */
 static inline void unwind_init_from_regs(struct unwind_state *state,
+					 struct task_struct *task,
 					 struct pt_regs *regs)
 {
-	unwind_init_common(state);
+	unwind_init_common(state, task);
 
 	state->fp = regs->regs[29];
 	state->pc = regs->pc;
@@ -71,9 +74,10 @@ static inline void unwind_init_from_regs(struct unwind_state *state,
  * Note: this is always inlined, and we expect our caller to be a noinline
  * function, such that this starts from our caller's caller.
  */
-static __always_inline void unwind_init_from_current(struct unwind_state *state)
+static __always_inline void unwind_init_from_current(struct unwind_state *state,
+						     struct task_struct *task)
 {
-	unwind_init_common(state);
+	unwind_init_common(state, task);
 
 	state->fp = (unsigned long)__builtin_frame_address(1);
 	state->pc = (unsigned long)__builtin_return_address(0);
@@ -87,7 +91,7 @@ static __always_inline void unwind_init_from_current(struct unwind_state *state)
 static inline void unwind_init_from_task(struct unwind_state *state,
 					 struct task_struct *task)
 {
-	unwind_init_common(state);
+	unwind_init_common(state, task);
 
 	state->fp = thread_saved_fp(task);
 	state->pc = thread_saved_pc(task);
@@ -100,11 +104,11 @@ static inline void unwind_init_from_task(struct unwind_state *state,
  * records (e.g. a cycle), determined based on the location and fp value of A
  * and the location (but not the fp value) of B.
  */
-static int notrace unwind_next(struct task_struct *tsk,
-			       struct unwind_state *state)
+static int notrace unwind_next(struct unwind_state *state)
 {
 	unsigned long fp = state->fp;
 	struct stack_info info;
+	struct task_struct *tsk = state->task;
 
 	/* Final frame; nothing to unwind */
 	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
@@ -176,8 +180,7 @@ static int notrace unwind_next(struct task_struct *tsk,
 }
 NOKPROBE_SYMBOL(unwind_next);
 
-static void notrace unwind(struct task_struct *tsk,
-			   struct unwind_state *state,
+static void notrace unwind(struct unwind_state *state,
 			   bool (*fn)(void *, unsigned long), void *data)
 {
 	while (1) {
@@ -185,7 +188,7 @@ static void notrace unwind(struct task_struct *tsk,
 
 		if (!fn(data, state->pc))
 			break;
-		ret = unwind_next(tsk, state);
+		ret = unwind_next(state);
 		if (ret < 0)
 			break;
 	}
@@ -232,11 +235,11 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 	struct unwind_state state;
 
 	if (regs)
-		unwind_init_from_regs(&state, regs);
+		unwind_init_from_regs(&state, task, regs);
 	else if (task == current)
-		unwind_init_from_current(&state);
+		unwind_init_from_current(&state, task);
 	else
 		unwind_init_from_task(&state, task);
 
-	unwind(task, &state, consume_entry, cookie);
+	unwind(&state, consume_entry, cookie);
 }
-- 
2.25.1

