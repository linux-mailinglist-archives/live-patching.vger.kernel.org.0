Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694DC490ADA
	for <lists+live-patching@lfdr.de>; Mon, 17 Jan 2022 15:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240178AbiAQO4d (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 17 Jan 2022 09:56:33 -0500
Received: from linux.microsoft.com ([13.77.154.182]:59462 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239743AbiAQO43 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 17 Jan 2022 09:56:29 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id E01FE20B9137;
        Mon, 17 Jan 2022 06:56:27 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E01FE20B9137
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1642431388;
        bh=iltLKVcth/w3lsN6QiNX6zEGsWq02EiMywUsEzd+d2M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=iWhhFPx637qzAF3ITigRhhH+CktW3lAtlGV+dBWjbpWnRabUxsnwV7e7QblUUF6L3
         VenP3F4tnqMpYQslpDCFb3RmflP1hMfWQk0Kf5AJTBkOSpIIQpQJ41Io+9fuuuEKHU
         ahFGTNjGC6+b9sj7iq/VPMgOdynTd5luwbD/cKQk=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v13 04/11] arm64: Split unwind_init()
Date:   Mon, 17 Jan 2022 08:56:01 -0600
Message-Id: <20220117145608.6781-5-madvenka@linux.microsoft.com>
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

unwind_init() is currently a single function that initializes all of the
unwind state. Split it into the following functions and call them
appropriately:

	- unwind_init_from_regs() - initialize from regs passed by caller.

	- unwind_init_from_current() - initialize for the current task
	  from the caller of arch_stack_walk().

	- unwind_init_from_task() - initialize from the saved state of a
	  task other than the current task. In this case, the other
	  task must not be running.

This is done for two reasons:

	- the different ways of initializing are clear

	- specialized code can be added to each initializer in the future.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/stacktrace.c | 54 +++++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index a1a7ff93b84f..b2b568e5deba 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -33,11 +33,8 @@
  */
 
 
-static void unwind_init(struct unwind_state *state, unsigned long fp,
-			unsigned long pc)
+static void unwind_init_common(struct unwind_state *state)
 {
-	state->fp = fp;
-	state->pc = pc;
 #ifdef CONFIG_KRETPROBES
 	state->kr_cur = NULL;
 #endif
@@ -56,6 +53,46 @@ static void unwind_init(struct unwind_state *state, unsigned long fp,
 	state->prev_type = STACK_TYPE_UNKNOWN;
 }
 
+/*
+ * TODO: document requirements here.
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
+ * TODO: document requirements here.
+ *
+ * Note: this is always inlined, and we expect our caller to be a noinline
+ * function, such that this starts from our caller's caller.
+ */
+static __always_inline void unwind_init_from_current(struct unwind_state *state)
+{
+	unwind_init_common(state);
+
+	state->fp = (unsigned long)__builtin_frame_address(1);
+	state->pc = (unsigned long)__builtin_return_address(0);
+}
+
+/*
+ * TODO: document requirements here.
+ *
+ * The caller guarantees that the task is not running.
+ */
+static inline void unwind_init_from_task(struct unwind_state *state,
+					 struct task_struct *task)
+{
+	unwind_init_common(state);
+
+	state->fp = thread_saved_fp(task);
+	state->pc = thread_saved_pc(task);
+}
+
 /*
  * Unwind from one frame record (A) to the next frame record (B).
  *
@@ -195,14 +232,11 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 	struct unwind_state state;
 
 	if (regs)
-		unwind_init(&state, regs->regs[29], regs->pc);
+		unwind_init_from_regs(&state, regs);
 	else if (task == current)
-		unwind_init(&state,
-				(unsigned long)__builtin_frame_address(1),
-				(unsigned long)__builtin_return_address(0));
+		unwind_init_from_current(&state);
 	else
-		unwind_init(&state, thread_saved_fp(task),
-				thread_saved_pc(task));
+		unwind_init_from_task(&state, task);
 
 	unwind(task, &state, consume_entry, cookie);
 }
-- 
2.25.1

