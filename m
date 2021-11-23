Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3A245ACA9
	for <lists+live-patching@lfdr.de>; Tue, 23 Nov 2021 20:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239144AbhKWTkt (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Nov 2021 14:40:49 -0500
Received: from linux.microsoft.com ([13.77.154.182]:41914 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238723AbhKWTkp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Nov 2021 14:40:45 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id E8CAD20D4D39;
        Tue, 23 Nov 2021 11:37:35 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E8CAD20D4D39
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1637696256;
        bh=4186IGzt9P0jgk6sDPjuuzrx/GJRpOlohBw5fEU6ZnY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=NH1mpd/pqVIHkZwa0kb2q2g1Eu3HnL+HMfUmRnjAxgTMIakYJdyLKv2ou5oesH8Rq
         6TJfVLVB+W9m5yYguic9FbIGxz2CUfmlw9VDulannLVk4axoBFi9r6vaegNSLk4oVt
         DI9JiII0OOI8WkWuv4tglMKWPh7uY5A+7ny5yvdw=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v11 3/5] arm64: Make the unwind loop in unwind() similar to other architectures
Date:   Tue, 23 Nov 2021 13:37:21 -0600
Message-Id: <20211123193723.12112-4-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211123193723.12112-1-madvenka@linux.microsoft.com>
References: <8b861784d85a21a9bf08598938c11aff1b1249b9>
 <20211123193723.12112-1-madvenka@linux.microsoft.com>
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
 arch/arm64/kernel/stacktrace.c      | 75 ++++++++++++++++++-----------
 2 files changed, 50 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 3a15d376ab36..d838586adef9 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -51,6 +51,8 @@ struct stack_info {
  * @kr_cur:      When KRETPOLINES is selected, holds the kretprobe instance
  *               associated with the most recently encountered replacement lr
  *               value.
+ *
+ * @failed:      Unwind failed.
  */
 struct stackframe {
 	unsigned long fp;
@@ -61,6 +63,7 @@ struct stackframe {
 #ifdef CONFIG_KRETPROBES
 	struct llist_node *kr_cur;
 #endif
+	bool failed;
 };
 
 extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 918852cd2681..3b670ab1f0e9 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -54,6 +54,7 @@ static void unwind_start(struct stackframe *frame, unsigned long fp,
 	bitmap_zero(frame->stacks_done, __NR_STACK_TYPES);
 	frame->prev_fp = 0;
 	frame->prev_type = STACK_TYPE_UNKNOWN;
+	frame->failed = false;
 }
 
 /*
@@ -63,24 +64,26 @@ static void unwind_start(struct stackframe *frame, unsigned long fp,
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
@@ -96,8 +99,10 @@ static int notrace unwind_next(struct task_struct *tsk,
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
@@ -125,8 +130,10 @@ static int notrace unwind_next(struct task_struct *tsk,
 		 */
 		orig_pc = ftrace_graph_ret_addr(tsk, NULL, frame->pc,
 						(void *)frame->fp);
-		if (WARN_ON_ONCE(frame->pc == orig_pc))
-			return -EINVAL;
+		if (WARN_ON_ONCE(frame->pc == orig_pc)) {
+			frame->failed = true;
+			return;
+		}
 		frame->pc = orig_pc;
 	}
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
@@ -134,11 +141,31 @@ static int notrace unwind_next(struct task_struct *tsk,
 	if (is_kretprobe_trampoline(frame->pc))
 		frame->pc = kretprobe_find_ret_addr(tsk, (void *)frame->fp, &frame->kr_cur);
 #endif
-
-	return 0;
 }
 NOKPROBE_SYMBOL(unwind_next);
 
+static bool unwind_continue(struct task_struct *task,
+			    struct stackframe *frame,
+			    stack_trace_consume_fn consume_entry, void *cookie)
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
 static void notrace unwind(struct task_struct *tsk,
 			   unsigned long fp, unsigned long pc,
 			   bool (*fn)(void *, unsigned long), void *data)
@@ -146,16 +173,8 @@ static void notrace unwind(struct task_struct *tsk,
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

