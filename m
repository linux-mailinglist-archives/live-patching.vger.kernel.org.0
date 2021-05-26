Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3884C39224F
	for <lists+live-patching@lfdr.de>; Wed, 26 May 2021 23:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbhEZVvA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 26 May 2021 17:51:00 -0400
Received: from linux.microsoft.com ([13.77.154.182]:49990 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234181AbhEZVu7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 26 May 2021 17:50:59 -0400
Received: from x64host.home (unknown [47.187.214.213])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0995520B8006;
        Wed, 26 May 2021 14:49:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0995520B8006
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1622065767;
        bh=ihZF+GLrE0mD1iSEIwOBnY6H49hrBdX+eSLd+PDM1JY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=TAcE4DaL553IBcGipZlwzGy8I0pFBSND9rvBo8RoO28SetNzeU5UfSTy1alujvBMX
         b1TejqPPuQm6E/TDjpj863F5Z/oLBtCBuphAOTHhIRrnhslu4NfRBaaBdKx/2qtODI
         nSrePeiti1oYacAsUAZFD8RKtSgrOzsX5l+bvh/8=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com, catalin.marinas@arm.com,
        will@kernel.org, jmorris@namei.org, pasha.tatashin@soleen.com,
        jthierry@redhat.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v5 1/2] arm64: Introduce stack trace reliability checks in the unwinder
Date:   Wed, 26 May 2021 16:49:16 -0500
Message-Id: <20210526214917.20099-2-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210526214917.20099-1-madvenka@linux.microsoft.com>
References: <ea0ef9ed6eb34618bcf468fbbf8bdba99e15df7d>
 <20210526214917.20099-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

The unwinder should check for the presence of various features and
conditions that can render the stack trace unreliable and mark the
the stack trace as unreliable for the benefit of the caller.

Introduce the first reliability check - If a return PC is not a valid
kernel text address, consider the stack trace unreliable. It could be
some generated code.

Other reliability checks will be added in the future.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/stacktrace.h |  9 +++++++
 arch/arm64/kernel/stacktrace.c      | 38 +++++++++++++++++++++++++----
 2 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index eb29b1fe8255..4c822ef7f588 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -49,6 +49,13 @@ struct stack_info {
  *
  * @graph:       When FUNCTION_GRAPH_TRACER is selected, holds the index of a
  *               replacement lr value in the ftrace graph stack.
+ *
+ * @reliable:	Is this stack frame reliable? There are several checks that
+ *              need to be performed in unwind_frame() before a stack frame
+ *              is truly reliable. Until all the checks are present, this flag
+ *              is just a place holder. Once all the checks are implemented,
+ *              this comment will be updated and the flag can be used by the
+ *              caller of unwind_frame().
  */
 struct stackframe {
 	unsigned long fp;
@@ -59,6 +66,7 @@ struct stackframe {
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	int graph;
 #endif
+	bool reliable;
 };
 
 extern int unwind_frame(struct task_struct *tsk, struct stackframe *frame);
@@ -169,6 +177,7 @@ static inline void start_backtrace(struct stackframe *frame,
 	bitmap_zero(frame->stacks_done, __NR_STACK_TYPES);
 	frame->prev_fp = 0;
 	frame->prev_type = STACK_TYPE_UNKNOWN;
+	frame->reliable = true;
 }
 
 #endif	/* __ASM_STACKTRACE_H */
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index d55bdfb7789c..9061375c8785 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -44,21 +44,29 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 	unsigned long fp = frame->fp;
 	struct stack_info info;
 
+	frame->reliable = true;
+
 	/* Terminal record; nothing to unwind */
 	if (!fp)
 		return -ENOENT;
 
-	if (fp & 0xf)
+	if (fp & 0xf) {
+		frame->reliable = false;
 		return -EINVAL;
+	}
 
 	if (!tsk)
 		tsk = current;
 
-	if (!on_accessible_stack(tsk, fp, &info))
+	if (!on_accessible_stack(tsk, fp, &info)) {
+		frame->reliable = false;
 		return -EINVAL;
+	}
 
-	if (test_bit(info.type, frame->stacks_done))
+	if (test_bit(info.type, frame->stacks_done)) {
+		frame->reliable = false;
 		return -EINVAL;
+	}
 
 	/*
 	 * As stacks grow downward, any valid record on the same stack must be
@@ -74,8 +82,10 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 	 * stack.
 	 */
 	if (info.type == frame->prev_type) {
-		if (fp <= frame->prev_fp)
+		if (fp <= frame->prev_fp) {
+			frame->reliable = false;
 			return -EINVAL;
+		}
 	} else {
 		set_bit(frame->prev_type, frame->stacks_done);
 	}
@@ -100,14 +110,32 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 		 * So replace it to an original value.
 		 */
 		ret_stack = ftrace_graph_get_ret_stack(tsk, frame->graph++);
-		if (WARN_ON_ONCE(!ret_stack))
+		if (WARN_ON_ONCE(!ret_stack)) {
+			frame->reliable = false;
 			return -EINVAL;
+		}
 		frame->pc = ret_stack->ret;
 	}
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
 	frame->pc = ptrauth_strip_insn_pac(frame->pc);
 
+	/*
+	 * Check the return PC for conditions that make unwinding unreliable.
+	 * In each case, mark the stack trace as such.
+	 */
+
+	/*
+	 * Make sure that the return address is a proper kernel text address.
+	 * A NULL or invalid return address could mean:
+	 *
+	 *	- generated code such as eBPF and optprobe trampolines
+	 *	- Foreign code (e.g. EFI runtime services)
+	 *	- Procedure Linkage Table (PLT) entries and veneer functions
+	 */
+	if (!__kernel_text_address(frame->pc))
+		frame->reliable = false;
+
 	return 0;
 }
 NOKPROBE_SYMBOL(unwind_frame);
-- 
2.25.1

