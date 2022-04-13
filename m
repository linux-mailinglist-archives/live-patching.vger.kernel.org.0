Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68D54FF88B
	for <lists+live-patching@lfdr.de>; Wed, 13 Apr 2022 16:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbiDMOIF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 13 Apr 2022 10:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbiDMOIE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 13 Apr 2022 10:08:04 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0834025E8C;
        Wed, 13 Apr 2022 07:05:44 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0B0D520C34CA;
        Wed, 13 Apr 2022 07:05:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0B0D520C34CA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1649858743;
        bh=rq9hnVI/Y4H4vRXgmKmfpdtj1W5zhGVLrIDwQqVIs14=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=YnYthjC6iqx7LeDpXzExD1CxOuAjqVKKh4uIgRwTboHD90c5Icl2kMNXalfpKjKJ+
         euHXz2aEmDqAZZ1h5hjufGIQdqXfTxdNhYhA537RlPEc3D3beHcZaqk3i0B31bkrFi
         O2pPULrCAKsQNHJh6Iv/dcQtJwkddF8hyr+/D/f4=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v14 1/7] arm64: Split unwind_init()
Date:   Wed, 13 Apr 2022 09:05:22 -0500
Message-Id: <20220413140528.3815-2-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413140528.3815-1-madvenka@linux.microsoft.com>
References: <f460a35f88195413bcf7305e5083480aab3ca858>
 <20220413140528.3815-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

unwind_init() is currently a single function that initializes all of the
unwind state. Split it into the following functions and call them
appropriately:

	- unwind_init_from_regs() - initialize from regs passed by caller.

	- unwind_init_from_caller() - initialize for the current task
	  from the caller of arch_stack_walk().

	- unwind_init_from_task() - initialize from the saved state of a
	  task other than the current task. In this case, the other
	  task must not be running.

This is done for two reasons:

	- the different ways of initializing are clear

	- specialized code can be added to each initializer in the future.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/stacktrace.c | 66 ++++++++++++++++++++++++++++------
 1 file changed, 55 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 0467cb79f080..e44f93ff25f0 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -50,11 +50,8 @@ struct unwind_state {
 #endif
 };
 
-static notrace void unwind_init(struct unwind_state *state, unsigned long fp,
-				unsigned long pc)
+static void unwind_init_common(struct unwind_state *state)
 {
-	state->fp = fp;
-	state->pc = pc;
 #ifdef CONFIG_KRETPROBES
 	state->kr_cur = NULL;
 #endif
@@ -72,7 +69,57 @@ static notrace void unwind_init(struct unwind_state *state, unsigned long fp,
 	state->prev_fp = 0;
 	state->prev_type = STACK_TYPE_UNKNOWN;
 }
-NOKPROBE_SYMBOL(unwind_init);
+
+/*
+ * Start an unwind from a pt_regs.
+ *
+ * The unwind will begin at the PC within the regs.
+ *
+ * The regs must be on a stack currently owned by the calling task.
+ */
+static inline void unwind_init_from_regs(struct unwind_state *state,
+					 struct pt_regs *regs)
+{
+	unwind_init_common(state);
+
+	state->fp = regs->regs[29];
+	state->pc = regs->pc;
+}
+
+/*
+ * Start an unwind from a caller.
+ *
+ * The unwind will begin at the caller of whichever function this is inlined
+ * into.
+ *
+ * The function which invokes this must be noinline.
+ */
+static __always_inline void unwind_init_from_caller(struct unwind_state *state)
+{
+	unwind_init_common(state);
+
+	state->fp = (unsigned long)__builtin_frame_address(1);
+	state->pc = (unsigned long)__builtin_return_address(0);
+}
+
+/*
+ * Start an unwind from a blocked task.
+ *
+ * The unwind will begin at the blocked tasks saved PC (i.e. the caller of
+ * cpu_switch_to()).
+ *
+ * The caller should ensure the task is blocked in cpu_switch_to() for the
+ * duration of the unwind, or the unwind will be bogus. It is never valid to
+ * call this for the current task.
+ */
+static inline void unwind_init_from_task(struct unwind_state *state,
+					 struct task_struct *task)
+{
+	unwind_init_common(state);
+
+	state->fp = thread_saved_fp(task);
+	state->pc = thread_saved_pc(task);
+}
 
 /*
  * Unwind from one frame record (A) to the next frame record (B).
@@ -213,14 +260,11 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 	struct unwind_state state;
 
 	if (regs)
-		unwind_init(&state, regs->regs[29], regs->pc);
+		unwind_init_from_regs(&state, regs);
 	else if (task == current)
-		unwind_init(&state,
-				(unsigned long)__builtin_frame_address(1),
-				(unsigned long)__builtin_return_address(0));
+		unwind_init_from_caller(&state);
 	else
-		unwind_init(&state, thread_saved_fp(task),
-				thread_saved_pc(task));
+		unwind_init_from_task(&state, task);
 
 	unwind(task, &state, consume_entry, cookie);
 }
-- 
2.25.1

