Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C762371EB7
	for <lists+live-patching@lfdr.de>; Mon,  3 May 2021 19:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbhECRhS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 May 2021 13:37:18 -0400
Received: from linux.microsoft.com ([13.77.154.182]:54486 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbhECRhS (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 May 2021 13:37:18 -0400
Received: from x64host.home (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id F400B20B8006;
        Mon,  3 May 2021 10:36:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F400B20B8006
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1620063384;
        bh=27H+BvFer3s1Y37vngYKoBI/y9wscqHm39MmyAoxw0U=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dl6V/Uswvh85+qjvxPyvO12cWqKGTHC7p2cooPOwG26LmWMxATKi/fYBN53tScEXR
         1mhyM3FpBIYEpnthksh7zyag6o50NOTInqXXOS+BFbhMwN40GRdJA/denkOBcnikNf
         WGxKCP2a75rmSDeUb6UPt6EdYGgAM7nKWerpV8pc=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, jpoimboe@redhat.com, mark.rutland@arm.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 1/4] arm64: Introduce stack trace reliability checks in the unwinder
Date:   Mon,  3 May 2021 12:36:12 -0500
Message-Id: <20210503173615.21576-2-madvenka@linux.microsoft.com>
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

The unwinder should check for the presence of various features and
conditions that can render the stack trace unreliable and mark the
the stack trace as unreliable for the benefit of the caller.

Introduce the first reliability check - If a return PC encountered in a
stack trace is not a valid kernel text address, the stack trace is
considered unreliable. It could be some generated code. Mark the stack
trace unreliable.

Other reliability checks will be added in the future.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/stacktrace.h |  4 ++++
 arch/arm64/kernel/stacktrace.c      | 19 ++++++++++++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index eb29b1fe8255..f1eab6b029f7 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -49,6 +49,8 @@ struct stack_info {
  *
  * @graph:       When FUNCTION_GRAPH_TRACER is selected, holds the index of a
  *               replacement lr value in the ftrace graph stack.
+ *
+ * @reliable:	Is this stack frame reliable?
  */
 struct stackframe {
 	unsigned long fp;
@@ -59,6 +61,7 @@ struct stackframe {
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	int graph;
 #endif
+	bool reliable;
 };
 
 extern int unwind_frame(struct task_struct *tsk, struct stackframe *frame);
@@ -169,6 +172,7 @@ static inline void start_backtrace(struct stackframe *frame,
 	bitmap_zero(frame->stacks_done, __NR_STACK_TYPES);
 	frame->prev_fp = 0;
 	frame->prev_type = STACK_TYPE_UNKNOWN;
+	frame->reliable = true;
 }
 
 #endif	/* __ASM_STACKTRACE_H */
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index d55bdfb7789c..c21a1bca28f3 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -44,6 +44,8 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 	unsigned long fp = frame->fp;
 	struct stack_info info;
 
+	frame->reliable = true;
+
 	/* Terminal record; nothing to unwind */
 	if (!fp)
 		return -ENOENT;
@@ -86,12 +88,24 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 	 */
 	frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp));
 	frame->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp + 8));
+	frame->pc = ptrauth_strip_insn_pac(frame->pc);
 	frame->prev_fp = fp;
 	frame->prev_type = info.type;
 
+	/*
+	 * First, make sure that the return address is a proper kernel text
+	 * address. A NULL or invalid return address probably means there's
+	 * some generated code which __kernel_text_address() doesn't know
+	 * about. Mark the stack trace as not reliable.
+	 */
+	if (!__kernel_text_address(frame->pc)) {
+		frame->reliable = false;
+		return 0;
+	}
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	if (tsk->ret_stack &&
-		(ptrauth_strip_insn_pac(frame->pc) == (unsigned long)return_to_handler)) {
+		frame->pc == (unsigned long)return_to_handler) {
 		struct ftrace_ret_stack *ret_stack;
 		/*
 		 * This is a case where function graph tracer has
@@ -103,11 +117,10 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 		if (WARN_ON_ONCE(!ret_stack))
 			return -EINVAL;
 		frame->pc = ret_stack->ret;
+		frame->pc = ptrauth_strip_insn_pac(frame->pc);
 	}
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
-	frame->pc = ptrauth_strip_insn_pac(frame->pc);
-
 	return 0;
 }
 NOKPROBE_SYMBOL(unwind_frame);
-- 
2.25.1

