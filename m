Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E14854FF1E
	for <lists+live-patching@lfdr.de>; Fri, 17 Jun 2022 23:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382870AbiFQVH1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jun 2022 17:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350908AbiFQVH1 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jun 2022 17:07:27 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7DE6C5E170;
        Fri, 17 Jun 2022 14:07:26 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 86B1320C3497;
        Fri, 17 Jun 2022 14:07:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 86B1320C3497
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1655500046;
        bh=4OYwsLak9eV14Lqr9wB+riHSEW5S0byajhIbP13YtuM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=NHcRNHW3qMsPN8XpBfaza4SLuStnGT0ip20a0XQVToKUrAWJXDl3xN5xJtSBF5H2a
         tVZo+mLonzjULpFET9TnXsBQvtCA/Qk4493o8pdVDTVNad4xf3z4Ji4c+AaumjfojH
         wb0d2gDJfP5/2sXcvsohEKJkqM9NIWbD9DFIR8a8=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v15 2/6] arm64: Copy the task argument to unwind_state
Date:   Fri, 17 Jun 2022 16:07:13 -0500
Message-Id: <20220617210717.27126-3-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220617210717.27126-1-madvenka@linux.microsoft.com>
References: <ff68fb850d42e1adaa6a0a6c9c258acabb898b24>
 <20220617210717.27126-1-madvenka@linux.microsoft.com>
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

Copy the task argument passed to arch_stack_walk() to unwind_state so that
it can be passed to unwind functions via unwind_state rather than as a
separate argument. The task is a fundamental part of the unwind state.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kernel/stacktrace.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index e44f93ff25f0..8e43444d50e2 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -38,6 +38,8 @@
  * @kr_cur:      When KRETPROBES is selected, holds the kretprobe instance
  *               associated with the most recently encountered replacement lr
  *               value.
+ *
+ * @task:        The task being unwound.
  */
 struct unwind_state {
 	unsigned long fp;
@@ -48,10 +50,13 @@ struct unwind_state {
 #ifdef CONFIG_KRETPROBES
 	struct llist_node *kr_cur;
 #endif
+	struct task_struct *task;
 };
 
-static void unwind_init_common(struct unwind_state *state)
+static void unwind_init_common(struct unwind_state *state,
+			       struct task_struct *task)
 {
+	state->task = task;
 #ifdef CONFIG_KRETPROBES
 	state->kr_cur = NULL;
 #endif
@@ -80,7 +85,7 @@ static void unwind_init_common(struct unwind_state *state)
 static inline void unwind_init_from_regs(struct unwind_state *state,
 					 struct pt_regs *regs)
 {
-	unwind_init_common(state);
+	unwind_init_common(state, current);
 
 	state->fp = regs->regs[29];
 	state->pc = regs->pc;
@@ -96,7 +101,7 @@ static inline void unwind_init_from_regs(struct unwind_state *state,
  */
 static __always_inline void unwind_init_from_caller(struct unwind_state *state)
 {
-	unwind_init_common(state);
+	unwind_init_common(state, current);
 
 	state->fp = (unsigned long)__builtin_frame_address(1);
 	state->pc = (unsigned long)__builtin_return_address(0);
@@ -115,7 +120,7 @@ static __always_inline void unwind_init_from_caller(struct unwind_state *state)
 static inline void unwind_init_from_task(struct unwind_state *state,
 					 struct task_struct *task)
 {
-	unwind_init_common(state);
+	unwind_init_common(state, task);
 
 	state->fp = thread_saved_fp(task);
 	state->pc = thread_saved_pc(task);
@@ -128,9 +133,9 @@ static inline void unwind_init_from_task(struct unwind_state *state,
  * records (e.g. a cycle), determined based on the location and fp value of A
  * and the location (but not the fp value) of B.
  */
-static int notrace unwind_next(struct task_struct *tsk,
-			       struct unwind_state *state)
+static int notrace unwind_next(struct unwind_state *state)
 {
+	struct task_struct *tsk = state->task;
 	unsigned long fp = state->fp;
 	struct stack_info info;
 
@@ -204,8 +209,7 @@ static int notrace unwind_next(struct task_struct *tsk,
 }
 NOKPROBE_SYMBOL(unwind_next);
 
-static void notrace unwind(struct task_struct *tsk,
-			   struct unwind_state *state,
+static void notrace unwind(struct unwind_state *state,
 			   stack_trace_consume_fn consume_entry, void *cookie)
 {
 	while (1) {
@@ -213,7 +217,7 @@ static void notrace unwind(struct task_struct *tsk,
 
 		if (!consume_entry(cookie, state->pc))
 			break;
-		ret = unwind_next(tsk, state);
+		ret = unwind_next(state);
 		if (ret < 0)
 			break;
 	}
@@ -259,12 +263,15 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 {
 	struct unwind_state state;
 
-	if (regs)
+	if (regs) {
+		if (task != current)
+			return;
 		unwind_init_from_regs(&state, regs);
-	else if (task == current)
+	} else if (task == current) {
 		unwind_init_from_caller(&state);
-	else
+	} else {
 		unwind_init_from_task(&state, task);
+	}
 
-	unwind(task, &state, consume_entry, cookie);
+	unwind(&state, consume_entry, cookie);
 }
-- 
2.25.1

