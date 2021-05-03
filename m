Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8FE371EBC
	for <lists+live-patching@lfdr.de>; Mon,  3 May 2021 19:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhECRh0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 May 2021 13:37:26 -0400
Received: from linux.microsoft.com ([13.77.154.182]:54548 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbhECRhV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 May 2021 13:37:21 -0400
Received: from x64host.home (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0CEFF20B8016;
        Mon,  3 May 2021 10:36:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0CEFF20B8016
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1620063387;
        bh=bYCJMeYNqN5Rl7cucEEXyAKwSqecSENtHSd9RFOfCiw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=n6j/xBMhadoUBM8BC5SAejnw2WorVnwcXyM8I9FLKnihE+3sp1AzlpoKaNnOspqUJ
         StwncmZF/PXyvbXi0ZHShyESiDMjPTSHsmW7r9aD5340M4yFz6AiYf6DQPegeBU9a5
         g/w6xnSg0NPRwqikcnZoeokiAmcNA1n44Dn6vup0=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, jpoimboe@redhat.com, mark.rutland@arm.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 4/4] arm64: Handle funtion graph tracer better in the unwinder
Date:   Mon,  3 May 2021 12:36:15 -0500
Message-Id: <20210503173615.21576-5-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210503173615.21576-1-madvenka@linux.microsoft.com>
References: <65cf4dfbc439b010b50a0c46ec500432acde86d6>
 <20210503173615.21576-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

The Function Graph Tracer modifies the return address of a traced function
to a return trampoline (return_to_handler()) to gather tracing data on
function return. When the unwinder encounters return_to_handler(), it calls
ftrace_graph_get_ret_stack() to lookup the original return address in the
return address stack.

This lookup will succeed as long as the unwinder is invoked when the traced
function is executing. However, when the traced function returns and control
goes to return_to_handler(), this lookup will not succeed because:

- the return address on the stack would not be return_to_handler. It would
  be return_to_handler+someoffset. To solve this, get the address range for
  return_to_handler() by looking up its symbol table entry and check if
  frame->pc falls in the range. This is also required for the unwinder to
  maintain the index into the return address stack correctly as it unwinds
  through Function Graph trace return trampolines.

- the original return address will be popped off the return address stack
  at some point. From this point till the end of return_to_handler(),
  the lookup will not succeed. The stack trace is unreliable in that
  window.

On arm64, each return address stack entry also stores the FP of the
caller of the traced function. Compare the FP in the current frame
with the entry that is looked up. If the FP matches, then, all is
well. Else, it is in the window. mark the stack trace unreliable.

Although it is possible to close the window mentioned above, it is
not worth it. It is a tiny window.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/stacktrace.h |  3 ++
 arch/arm64/kernel/stacktrace.c      | 60 ++++++++++++++++++++++++-----
 2 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index f1eab6b029f7..e70a2a6451db 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -69,6 +69,7 @@ extern void walk_stackframe(struct task_struct *tsk, struct stackframe *frame,
 			    bool (*fn)(void *, unsigned long), void *data);
 extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
 			   const char *loglvl);
+extern void init_ranges(void);
 
 DECLARE_PER_CPU(unsigned long *, irq_stack_ptr);
 
@@ -154,6 +155,8 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
 static inline void start_backtrace(struct stackframe *frame,
 				   unsigned long fp, unsigned long pc)
 {
+	init_ranges();
+
 	frame->fp = fp;
 	frame->pc = pc;
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 33e174160f9b..7504aec79faa 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -26,6 +26,9 @@ struct code_range {
 
 struct code_range	sym_code_ranges[] =
 {
+	/* unwindable ranges */
+	{ (unsigned long)return_to_handler, 0 },
+
 	/* non-unwindable ranges */
 	{ (unsigned long)__entry_text_start,
 	  (unsigned long)__entry_text_end },
@@ -48,6 +51,33 @@ struct code_range	sym_code_ranges[] =
 	{ /* sentinel */ }
 };
 
+void init_ranges(void)
+{
+	static char sym[KSYM_NAME_LEN];
+	static bool inited = false;
+	struct code_range *range;
+	unsigned long pc, size, offset;
+
+	if (inited)
+		return;
+
+	for (range = sym_code_ranges; range->start; range++) {
+		if (range->end)
+			continue;
+
+		pc = (unsigned long)range->start;
+		if (kallsyms_lookup(pc, &size, &offset, NULL, sym)) {
+			range->start = pc - offset;
+			range->end = range->start + size;
+		} else {
+			/* Range will only include one instruction */
+			range->start = pc;
+			range->end = pc + 4;
+		}
+	}
+	inited = true;
+}
+
 static struct code_range *lookup_range(unsigned long pc)
 {
 	struct code_range *range;
@@ -149,19 +179,29 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	if (tsk->ret_stack &&
-		frame->pc == (unsigned long)return_to_handler) {
+		range->start == (unsigned long)return_to_handler) {
 		struct ftrace_ret_stack *ret_stack;
 		/*
-		 * This is a case where function graph tracer has
-		 * modified a return address (LR) in a stack frame
-		 * to hook a function return.
-		 * So replace it to an original value.
+		 * Either the function graph tracer has modified a return
+		 * address (LR) in a stack frame to the return trampoline.
+		 * Or, the return trampoline itself is executing upon the
+		 * return of a traced function. Lookup the original return
+		 * address and replace frame->pc with it.
+		 *
+		 * However, the return trampoline pops the original return
+		 * address off the return address stack at some point. So,
+		 * there is a small window towards the end of the return
+		 * trampoline where the lookup will fail. In that case,
+		 * mark the stack trace as unreliable and proceed.
 		 */
-		ret_stack = ftrace_graph_get_ret_stack(tsk, frame->graph++);
-		if (WARN_ON_ONCE(!ret_stack))
-			return -EINVAL;
-		frame->pc = ret_stack->ret;
-		frame->pc = ptrauth_strip_insn_pac(frame->pc);
+		ret_stack = ftrace_graph_get_ret_stack(tsk, frame->graph);
+		if (!ret_stack || frame->fp != ret_stack->fp) {
+			frame->reliable = false;
+		} else {
+			frame->pc = ret_stack->ret;
+			frame->pc = ptrauth_strip_insn_pac(frame->pc);
+			frame->graph++;
+		}
 		return 0;
 	}
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
-- 
2.25.1

