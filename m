Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3835A381C58
	for <lists+live-patching@lfdr.de>; Sun, 16 May 2021 06:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhEPEBq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 16 May 2021 00:01:46 -0400
Received: from linux.microsoft.com ([13.77.154.182]:45124 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhEPEBp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 16 May 2021 00:01:45 -0400
Received: from x64host.home (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2268D20B8006;
        Sat, 15 May 2021 21:00:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2268D20B8006
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1621137631;
        bh=Dz0YnSe+6/RNJMKZ7AszyCNm1xp4eykmTR9aH7S0FJM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=GMcyFxcaYX8ZIE/ZdYxSnasZZUTSox1Yci1qO2nQ0UCupX+ELPZ0SlrCDCRYatm/P
         Uhnr0/CQ4XpcpDqdPYkTi8409gaYkAyjnZ5JD46jYu+l8819HSsKvUmqRabYYGvXrv
         E5YnBY7/oax0DrIUMFBa82d/SJv9xw/vxZqiU9mo=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        ardb@kernel.org, jthierry@redhat.com, catalin.marinas@arm.com,
        will@kernel.org, jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v4 1/2] arm64: Introduce stack trace reliability checks in the unwinder
Date:   Sat, 15 May 2021 23:00:17 -0500
Message-Id: <20210516040018.128105-2-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210516040018.128105-1-madvenka@linux.microsoft.com>
References: <68eeda61b3e9579d65698a884b26c8632025e503>
 <20210516040018.128105-1-madvenka@linux.microsoft.com>
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
 arch/arm64/include/asm/stacktrace.h |  4 ++++
 arch/arm64/kernel/stacktrace.c      | 35 ++++++++++++++++++++++++-----
 2 files changed, 34 insertions(+), 5 deletions(-)

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
index d55bdfb7789c..d38232cab3ee 100644
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
@@ -100,14 +110,29 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
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
+	 * A NULL or invalid return address probably means there's some
+	 * generated code which __kernel_text_address() doesn't know about.
+	 */
+	if (!__kernel_text_address(frame->pc))
+		frame->reliable = false;
+
 	return 0;
 }
 NOKPROBE_SYMBOL(unwind_frame);
-- 
2.25.1

