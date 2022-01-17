Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E18A490AE2
	for <lists+live-patching@lfdr.de>; Mon, 17 Jan 2022 15:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239896AbiAQO4l (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 17 Jan 2022 09:56:41 -0500
Received: from linux.microsoft.com ([13.77.154.182]:59516 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240192AbiAQO4d (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 17 Jan 2022 09:56:33 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id E005B20B9132;
        Mon, 17 Jan 2022 06:56:31 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E005B20B9132
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1642431392;
        bh=Gu/RiiXWRBLp+NeSXyYMhePY/Y68RWORmCeNAWcv3uE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Hlbw1O1WRSKKJdXQXYgsD8vj8ZdO0MtoFe2CmlOg2sJ8bXm8U+vKAkrIlzfjzrikN
         zk6H5cDNDrMliL5T+9EfagreP5IwaaG/b92mp4m61pu7a1UanupbiDafz1Cx9eXf6A
         cFm/RaeCISpCzj8UatjExxyWnkmYn8jP7pHfRtFo=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v13 08/11] arm64: Introduce stack trace reliability checks in the unwinder
Date:   Mon, 17 Jan 2022 08:56:05 -0600
Message-Id: <20220117145608.6781-9-madvenka@linux.microsoft.com>
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

There are some kernel features and conditions that make a stack trace
unreliable. Callers may require the unwinder to detect these cases.
E.g., livepatch.

Introduce a new function called unwind_check_reliability() that will
detect these cases and set a flag in the stack frame. Call
unwind_check_reliability() for every frame in unwind().

Introduce the first reliability check in unwind_check_reliability() - If
a return PC is not a valid kernel text address, consider the stack
trace unreliable. It could be some generated code. Other reliability checks
will be added in the future.

Let unwind() return a boolean to indicate if the stack trace is
reliable.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/stacktrace.h |  3 +++
 arch/arm64/kernel/stacktrace.c      | 28 ++++++++++++++++++++++++++--
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index c11b048ffd0e..26eba9d7e5c7 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -57,6 +57,8 @@ struct stack_info {
  * @final_fp	 Pointer to the final frame.
  *
  * @failed:      Unwind failed.
+ *
+ * @reliable:    Stack trace is reliable.
  */
 struct unwind_state {
 	unsigned long fp;
@@ -70,6 +72,7 @@ struct unwind_state {
 	struct task_struct *task;
 	unsigned long final_fp;
 	bool failed;
+	bool reliable;
 };
 
 extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 73fc6b5ee6fd..3dc0374e83f7 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -18,6 +18,25 @@
 #include <asm/stack_pointer.h>
 #include <asm/stacktrace.h>
 
+/*
+ * Check the stack frame for conditions that make further unwinding unreliable.
+ */
+static void unwind_check_reliability(struct unwind_state *state)
+{
+	if (state->fp == state->final_fp) {
+		/* Final frame; no more unwind, no need to check reliability */
+		return;
+	}
+
+	/*
+	 * If the PC is not a known kernel text address, then we cannot
+	 * be sure that a subsequent unwind will be reliable, as we
+	 * don't know that the code follows our unwind requirements.
+	 */
+	if (!__kernel_text_address(state->pc))
+		state->reliable = false;
+}
+
 /*
  * AArch64 PCS assigns the frame pointer to x29.
  *
@@ -54,6 +73,7 @@ static void unwind_init_common(struct unwind_state *state,
 	state->prev_fp = 0;
 	state->prev_type = STACK_TYPE_UNKNOWN;
 	state->failed = false;
+	state->reliable = true;
 
 	/* Stack trace terminates here. */
 	state->final_fp = (unsigned long)task_pt_regs(task)->stackframe;
@@ -207,11 +227,15 @@ static void notrace unwind_next(struct unwind_state *state)
 }
 NOKPROBE_SYMBOL(unwind_next);
 
-static void notrace unwind(struct unwind_state *state,
+static bool notrace unwind(struct unwind_state *state,
 			   stack_trace_consume_fn consume_entry, void *cookie)
 {
-	while (unwind_continue(state, consume_entry, cookie))
+	unwind_check_reliability(state);
+	while (unwind_continue(state, consume_entry, cookie)) {
 		unwind_next(state);
+		unwind_check_reliability(state);
+	}
+	return !state->failed && state->reliable;
 }
 NOKPROBE_SYMBOL(unwind);
 
-- 
2.25.1

