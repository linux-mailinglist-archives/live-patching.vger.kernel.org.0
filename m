Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BC534F173
	for <lists+live-patching@lfdr.de>; Tue, 30 Mar 2021 21:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhC3TKZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Mar 2021 15:10:25 -0400
Received: from linux.microsoft.com ([13.77.154.182]:33648 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233037AbhC3TKG (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Mar 2021 15:10:06 -0400
Received: from x64host.home (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2059920B5682;
        Tue, 30 Mar 2021 12:10:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2059920B5682
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617131405;
        bh=hJ+tRyaOajTKVDku/PeJpOdfpmhUZp9TFHFGI2dnanc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=G8rLUhl3BJ4zjRJeNxjMkf0XMN2QZMfRlr51MvT+D4OKGuwB/pMgpdP2qHA7DvCYc
         79p+hGKoAGYcE2NAuWr/qZNdOQn1iU/7CTXCrzxEv9SBghKlXLua08lLlYbpQ9m53o
         vqwLTDFFUvulLl1qSYxTRuSo0zVKRs754n1b+sx0=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v1 3/4] arm64: Detect FTRACE cases that make the stack trace unreliable
Date:   Tue, 30 Mar 2021 14:09:54 -0500
Message-Id: <20210330190955.13707-4-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210330190955.13707-1-madvenka@linux.microsoft.com>
References: <77bd5edeea72d44533c769b1e8c0fea7a9d7eb3a>
 <20210330190955.13707-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

When CONFIG_DYNAMIC_FTRACE_WITH_REGS is enabled and tracing is activated
for a function, the ftrace infrastructure is called for the function at
the very beginning. Ftrace creates two frames:

	- One for the traced function

	- One for the caller of the traced function

That gives a reliable stack trace while executing in the ftrace code. When
ftrace returns to the traced function, the frames are popped and everything
is back to normal.

However, in cases like live patch, a tracer function may redirect execution
to a different function when it returns. A stack trace taken while still in
the tracer function will not show the target function. The target function
is the real function that we want to track.

So, if an FTRACE frame is detected on the stack, just mark the stack trace
as unreliable. The detection is done by checking the return PC against
FTRACE trampolines.

Also, the Function Graph Tracer modifies the return address of a traced
function to a return trampoline to gather tracing data on function return.
Stack traces taken from that trampoline and functions it calls are
unreliable as the original return address may not be available in
that context. Mark the stack trace unreliable accordingly.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/entry-ftrace.S | 10 ++++++
 arch/arm64/kernel/stacktrace.c   | 57 ++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)

diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
index b3e4f9a088b1..5373f88b4c44 100644
--- a/arch/arm64/kernel/entry-ftrace.S
+++ b/arch/arm64/kernel/entry-ftrace.S
@@ -95,6 +95,16 @@ SYM_CODE_START(ftrace_common)
 SYM_INNER_LABEL(ftrace_call, SYM_L_GLOBAL)
 	bl	ftrace_stub
 
+	/*
+	 * The only call in the FTRACE trampoline code is above. The above
+	 * instruction is patched to call a tracer function. Its return
+	 * address is below (ftrace_graph_call). In a stack trace taken from
+	 * a tracer function, ftrace_graph_call() will show. The unwinder
+	 * checks this for reliable stack trace. Please see the comments
+	 * in stacktrace.c. If another call is added in the FTRACE
+	 * trampoline code, the special_functions[] array in stacktrace.c
+	 * must be updated.
+	 */
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 SYM_INNER_LABEL(ftrace_graph_call, SYM_L_GLOBAL) // ftrace_graph_caller();
 	nop				// If enabled, this will be replaced
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 7662f57d3e88..8b493a90c9f3 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -51,6 +51,52 @@ struct function_range {
  * unreliable. Breakpoints are used for executing probe code. Stack traces
  * taken while in the probe code will show an EL1 frame and will be considered
  * unreliable. This is correct behavior.
+ *
+ * FTRACE
+ * ======
+ *
+ * When CONFIG_DYNAMIC_FTRACE_WITH_REGS is enabled, the FTRACE trampoline code
+ * is called from a traced function even before the frame pointer prolog.
+ * FTRACE sets up two stack frames (one for the traced function and one for
+ * its caller) so that the unwinder can provide a sensible stack trace for
+ * any tracer function called from the FTRACE trampoline code.
+ *
+ * There are two cases where the stack trace is not reliable.
+ *
+ * (1) The task gets preempted before the two frames are set up. Preemption
+ *     involves an interrupt which is an EL1 exception. The unwinder already
+ *     handles EL1 exceptions.
+ *
+ * (2) The tracer function that gets called by the FTRACE trampoline code
+ *     changes the return PC (e.g., livepatch).
+ *
+ *     Not all tracer functions do that. But to err on the side of safety,
+ *     consider the stack trace as unreliable in all cases.
+ *
+ * When Function Graph Tracer is used, FTRACE modifies the return address of
+ * the traced function in its stack frame to an FTRACE return trampoline
+ * (return_to_handler). When the traced function returns, control goes to
+ * return_to_handler. return_to_handler calls FTRACE to gather tracing data
+ * and to obtain the original return address. Then, return_to_handler returns
+ * to the original return address.
+ *
+ * There are two cases to consider from a stack trace reliability point of
+ * view:
+ *
+ * (1) Stack traces taken within the traced function (and functions that get
+ *     called from there) will show return_to_handler instead of the original
+ *     return address. The original return address can be obtained from FTRACE.
+ *     The unwinder already obtains it and modifies the return PC in its copy
+ *     of the stack frame to the original return address. So, this is handled.
+ *
+ * (2) return_to_handler calls FTRACE as mentioned before. FTRACE discards
+ *     the record of the original return address along the way as it does not
+ *     need to maintain it anymore. This means that the unwinder cannot get
+ *     the original return address beyond that point while the task is still
+ *     executing in return_to_handler. So, consider the stack trace unreliable
+ *     if return_to_handler is detected on the stack.
+ *
+ * NOTE: The unwinder must do (1) before (2).
  */
 static struct function_range	special_functions[] = {
 	/*
@@ -64,6 +110,17 @@ static struct function_range	special_functions[] = {
 	{ (unsigned long) el1_fiq_invalid, 0 },
 	{ (unsigned long) el1_error_invalid, 0 },
 
+	/*
+	 * FTRACE trampolines.
+	 */
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+	{ (unsigned long) &ftrace_graph_call, 0 },
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	{ (unsigned long) ftrace_graph_caller, 0 },
+	{ (unsigned long) return_to_handler, 0 },
+#endif
+#endif
+
 	{ 0, 0 }
 };
 
-- 
2.25.1

