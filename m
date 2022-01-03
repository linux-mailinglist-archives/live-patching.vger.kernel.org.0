Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A465483527
	for <lists+live-patching@lfdr.de>; Mon,  3 Jan 2022 17:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbiACQwz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 Jan 2022 11:52:55 -0500
Received: from linux.microsoft.com ([13.77.154.182]:53278 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234899AbiACQww (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 Jan 2022 11:52:52 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id CD79E20B718A;
        Mon,  3 Jan 2022 08:52:50 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CD79E20B718A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1641228771;
        bh=k0L/6HF0XSKKkYTWUToL3wE6EoMVilDa95cDIedw94E=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pY92LoKgoXa2SoD4BwTeElCgeiSgs8onNLmiX4+ShFKPz7yM2gvTEcAEqQ0l2vUev
         R+ApgO3xM78oO3lKMxJf3x7As3Cme4PjSaXoz5DMDWmbap0kwZg3hQWfBJvp1X65mK
         qRB+Vtpt6MuRRyGQKed9jEI9QsDDXsxhZuaDz1B4=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v12 07/10] arm64: Introduce stack trace reliability checks in the unwinder
Date:   Mon,  3 Jan 2022 10:52:09 -0600
Message-Id: <20220103165212.9303-8-madvenka@linux.microsoft.com>
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
---
 arch/arm64/include/asm/stacktrace.h |  3 +++
 arch/arm64/kernel/stacktrace.c      | 29 +++++++++++++++++++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 9d1fddc26586..47d4be69799a 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -63,6 +63,8 @@ struct stack_info {
  * @final_fp	 Pointer to the final frame.
  *
  * @failed:      Unwind failed.
+ *
+ * @reliable:    Stack trace is reliable.
  */
 struct unwind_state {
 	unsigned long fp;
@@ -79,6 +81,7 @@ struct unwind_state {
 	void *cookie;
 	unsigned long final_fp;
 	bool failed;
+	bool reliable;
 };
 
 extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index af0949f028c9..54c3396a65c3 100644
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
@@ -64,6 +83,8 @@ static void unwind_init_common(struct unwind_state *state,
 
 	/* Stack trace terminates here. */
 	state->final_fp = (unsigned long)task_pt_regs(task)->stackframe;
+
+	state->reliable = true;
 }
 
 /*
@@ -202,10 +223,14 @@ static void notrace unwind_next(struct unwind_state *state)
 }
 NOKPROBE_SYMBOL(unwind_next);
 
-static void notrace unwind(struct unwind_state *state)
+static bool notrace unwind(struct unwind_state *state)
 {
-	while (unwind_continue(state))
+	unwind_check_reliability(state);
+	while (unwind_continue(state)) {
 		unwind_next(state);
+		unwind_check_reliability(state);
+	}
+	return !state->failed && state->reliable;
 }
 NOKPROBE_SYMBOL(unwind);
 
-- 
2.25.1

