Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B4442E6AE
	for <lists+live-patching@lfdr.de>; Fri, 15 Oct 2021 04:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbhJOChV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Oct 2021 22:37:21 -0400
Received: from linux.microsoft.com ([13.77.154.182]:55514 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235096AbhJOChJ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Oct 2021 22:37:09 -0400
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id CDA1620B9D1C;
        Thu, 14 Oct 2021 19:35:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CDA1620B9D1C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634265303;
        bh=57BcPNouzyU3TXGJbaeOWDPyH6v6sumOk7RFMlmMA60=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=NXvi169aT9nM+JwiUhCgxT0D4mfOcrQKBeiuqNVAxe0SCRcJqYyDu8v3KaseOvRpc
         OESiXg0go7QR9VWlcVAhkKQtj41EDVdel++VU0O8CD1ajK+enXqtrnUs19amFc8bbk
         R+7MGXeP1F9MYUoiDPqyOTSPr7++JX0+HBKk4u0Y=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v9 09/11] arm64: Make the unwind loop in unwind() similar to other architectures
Date:   Thu, 14 Oct 2021 21:34:13 -0500
Message-Id: <20211015023413.16614-12-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211015023413.16614-1-madvenka@linux.microsoft.com>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015023413.16614-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Change the loop in unwind()
===========================

Change the unwind loop in unwind() to:

	unwind_start(&frame, fp, pc);
	while (unwind_continue(tsk, &frame, fn, data))
		unwind_next(tsk, &frame);

New function unwind_continue()
==============================

Define a new function unwind_continue() that is used in the unwind loop
to check for conditions that terminate a stack trace.

The conditions checked are:

	- If the bottom of the stack has been reached, terminate.

	- If the consume_entry() function returns false, the caller of
	  unwind has asked to terminate the stack trace. So, terminate.

	- If unwind_next() failed for some reason (like stack corruption),
	  terminate.

Do not return an error value from unwind_next()
===============================================

We want to check for terminating conditions only in unwind_continue() from
the unwinder loop. So, do not return an error value from unwind_next().
Simply set a flag in the stackframe and check the flag in unwind_continue().

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/stacktrace.h |  3 ++
 arch/arm64/kernel/stacktrace.c      | 78 ++++++++++++++++++-----------
 2 files changed, 53 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index c239f357d779..ba2180c7d5cd 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -49,6 +49,8 @@ struct stack_info {
  *
  * @graph:       When FUNCTION_GRAPH_TRACER is selected, holds the index of a
  *               replacement lr value in the ftrace graph stack.
+ *
+ * @failed:      Unwind failed.
  */
 struct stackframe {
 	unsigned long fp;
@@ -59,6 +61,7 @@ struct stackframe {
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	int graph;
 #endif
+	bool failed;
 };
 
 extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index f4f3575f71fd..8e9e6f38c975 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -54,6 +54,7 @@ static void notrace unwind_start(struct stackframe *frame, unsigned long fp,
 	bitmap_zero(frame->stacks_done, __NR_STACK_TYPES);
 	frame->prev_fp = 0;
 	frame->prev_type = STACK_TYPE_UNKNOWN;
+	frame->failed = false;
 }
 
 NOKPROBE_SYMBOL(unwind_start);
@@ -65,24 +66,26 @@ NOKPROBE_SYMBOL(unwind_start);
  * records (e.g. a cycle), determined based on the location and fp value of A
  * and the location (but not the fp value) of B.
  */
-static int notrace unwind_next(struct task_struct *tsk,
-			       struct stackframe *frame)
+static void notrace unwind_next(struct task_struct *tsk,
+				struct stackframe *frame)
 {
 	unsigned long fp = frame->fp;
 	struct stack_info info;
 
-	/* Final frame; nothing to unwind */
-	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
-		return -ENOENT;
-
-	if (fp & 0x7)
-		return -EINVAL;
+	if (fp & 0x7) {
+		frame->failed = true;
+		return;
+	}
 
-	if (!on_accessible_stack(tsk, fp, 16, &info))
-		return -EINVAL;
+	if (!on_accessible_stack(tsk, fp, 16, &info)) {
+		frame->failed = true;
+		return;
+	}
 
-	if (test_bit(info.type, frame->stacks_done))
-		return -EINVAL;
+	if (test_bit(info.type, frame->stacks_done)) {
+		frame->failed = true;
+		return;
+	}
 
 	/*
 	 * As stacks grow downward, any valid record on the same stack must be
@@ -98,8 +101,10 @@ static int notrace unwind_next(struct task_struct *tsk,
 	 * stack.
 	 */
 	if (info.type == frame->prev_type) {
-		if (fp <= frame->prev_fp)
-			return -EINVAL;
+		if (fp <= frame->prev_fp) {
+			frame->failed = true;
+			return;
+		}
 	} else {
 		set_bit(frame->prev_type, frame->stacks_done);
 	}
@@ -124,19 +129,44 @@ static int notrace unwind_next(struct task_struct *tsk,
 		 * So replace it to an original value.
 		 */
 		ret_stack = ftrace_graph_get_ret_stack(tsk, frame->graph++);
-		if (WARN_ON_ONCE(!ret_stack))
-			return -EINVAL;
+		if (WARN_ON_ONCE(!ret_stack)) {
+			frame->failed = true;
+			return;
+		}
 		frame->pc = ret_stack->ret;
 	}
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
 	frame->pc = ptrauth_strip_insn_pac(frame->pc);
-
-	return 0;
 }
 
 NOKPROBE_SYMBOL(unwind_next);
 
+static bool notrace unwind_continue(struct task_struct *task,
+				    struct stackframe *frame,
+				    stack_trace_consume_fn consume_entry,
+				    void *cookie)
+{
+	if (frame->failed) {
+		/* PC is suspect. Cannot consume it. */
+		return false;
+	}
+
+	if (!consume_entry(cookie, frame->pc)) {
+		/* Caller terminated the unwind. */
+		frame->failed = true;
+		return false;
+	}
+
+	if (frame->fp == (unsigned long)task_pt_regs(task)->stackframe) {
+		/* Final frame; nothing to unwind */
+		return false;
+	}
+	return true;
+}
+
+NOKPROBE_SYMBOL(unwind_continue);
+
 static void notrace unwind(struct task_struct *tsk,
 			   unsigned long fp, unsigned long pc,
 			   bool (*fn)(void *, unsigned long),
@@ -145,16 +175,8 @@ static void notrace unwind(struct task_struct *tsk,
 	struct stackframe frame;
 
 	unwind_start(&frame, fp, pc);
-
-	while (1) {
-		int ret;
-
-		if (!fn(data, frame.pc))
-			break;
-		ret = unwind_next(tsk, &frame);
-		if (ret < 0)
-			break;
-	}
+	while (unwind_continue(tsk, &frame, fn, data))
+		unwind_next(tsk, &frame);
 }
 
 NOKPROBE_SYMBOL(unwind);
-- 
2.25.1

