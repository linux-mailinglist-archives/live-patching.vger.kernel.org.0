Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE36142E6F0
	for <lists+live-patching@lfdr.de>; Fri, 15 Oct 2021 04:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbhJODBR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Oct 2021 23:01:17 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58238 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235174AbhJODBQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Oct 2021 23:01:16 -0400
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id D64C920B9D20;
        Thu, 14 Oct 2021 19:59:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D64C920B9D20
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634266750;
        bh=Sre2VpLzl4RVm2McLfD5iL1Uc+pnLRObb9ujvhfag6U=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Z+AxsZl6I0JgvMqLrKwgz+4rtObTdr9Dqfbk3LTAN9EL8/wdtbKyhPq6PRQE2MpvM
         eDS6EScXgN15chPkStv/j0mhp+d/X8lli59q8ZMUiWRA8+WiuWtbCEQjr6xTi8PxJR
         RuAyETDy9v7OeSr+NxBm6nwbv+I/LMbM43zwWvw8=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v10 07/11] arm64: Call stack_backtrace() only from within walk_stackframe()
Date:   Thu, 14 Oct 2021 21:58:43 -0500
Message-Id: <20211015025847.17694-8-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211015025847.17694-1-madvenka@linux.microsoft.com>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Currently, arch_stack_walk() calls start_backtrace() and walk_stackframe()
separately. There is no need to do that. Instead, call start_backtrace()
from within walk_stackframe(). In other words, walk_stackframe() is the only
unwind function a consumer needs to call.

Currently, the only consumer is arch_stack_walk(). In the future,
arch_stack_walk_reliable() will be another consumer.

start_backtrace(), unwind_frame() and walk_stackframe() are only used
within arm64/kernel/stacktrace.c. Make them static and remove them from
arch/arm64/include/asm/stacktrace.h.

Currently, there is a check for a NULL task in unwind_frame(). It is not
needed since all current consumers pass a non-NULL task.

Use struct stackframe only within the unwind functions.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/stacktrace.h |  6 ----
 arch/arm64/kernel/stacktrace.c      | 51 ++++++++++++++++-------------
 2 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 8aebc00c1718..c239f357d779 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -61,9 +61,6 @@ struct stackframe {
 #endif
 };
 
-extern int unwind_frame(struct task_struct *tsk, struct stackframe *frame);
-extern void walk_stackframe(struct task_struct *tsk, struct stackframe *frame,
-			    bool (*fn)(void *, unsigned long), void *data);
 extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
 			   const char *loglvl);
 
@@ -148,7 +145,4 @@ static inline bool on_accessible_stack(const struct task_struct *tsk,
 	return false;
 }
 
-void start_backtrace(struct stackframe *frame, unsigned long fp,
-		     unsigned long pc);
-
 #endif	/* __ASM_STACKTRACE_H */
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 776c4debb5a7..7d32cee9ef4b 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -33,8 +33,8 @@
  */
 
 
-void start_backtrace(struct stackframe *frame, unsigned long fp,
-		     unsigned long pc)
+static void start_backtrace(struct stackframe *frame, unsigned long fp,
+			    unsigned long pc)
 {
 	frame->fp = fp;
 	frame->pc = pc;
@@ -63,14 +63,12 @@ void start_backtrace(struct stackframe *frame, unsigned long fp,
  * records (e.g. a cycle), determined based on the location and fp value of A
  * and the location (but not the fp value) of B.
  */
-int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
+static int notrace unwind_frame(struct task_struct *tsk,
+				struct stackframe *frame)
 {
 	unsigned long fp = frame->fp;
 	struct stack_info info;
 
-	if (!tsk)
-		tsk = current;
-
 	/* Final frame; nothing to unwind */
 	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
 		return -ENOENT;
@@ -136,15 +134,21 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 }
 NOKPROBE_SYMBOL(unwind_frame);
 
-void notrace walk_stackframe(struct task_struct *tsk, struct stackframe *frame,
-			     bool (*fn)(void *, unsigned long), void *data)
+static void notrace walk_stackframe(struct task_struct *tsk,
+				    unsigned long fp, unsigned long pc,
+				    bool (*fn)(void *, unsigned long),
+				    void *data)
 {
+	struct stackframe frame;
+
+	start_backtrace(&frame, fp, pc);
+
 	while (1) {
 		int ret;
 
-		if (!fn(data, frame->pc))
+		if (!fn(data, frame.pc))
 			break;
-		ret = unwind_frame(tsk, frame);
+		ret = unwind_frame(tsk, &frame);
 		if (ret < 0)
 			break;
 	}
@@ -190,19 +194,22 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 			      void *cookie, struct task_struct *task,
 			      struct pt_regs *regs)
 {
-	struct stackframe frame;
+	unsigned long fp, pc;
+
+	if (regs) {
+		fp = regs->regs[29];
+		pc = regs->pc;
+	} else if (task == current) {
+		/* Skip arch_stack_walk() in the stack trace. */
+		fp = (unsigned long)__builtin_frame_address(1);
+		pc = (unsigned long)__builtin_return_address(0);
+	} else {
+		/* Caller guarantees that the task is not running. */
+		fp = thread_saved_fp(task);
+		pc = thread_saved_pc(task);
+	}
+	walk_stackframe(task, fp, pc, consume_entry, cookie);
 
-	if (regs)
-		start_backtrace(&frame, regs->regs[29], regs->pc);
-	else if (task == current)
-		start_backtrace(&frame,
-				(unsigned long)__builtin_frame_address(1),
-				(unsigned long)__builtin_return_address(0));
-	else
-		start_backtrace(&frame, thread_saved_fp(task),
-				thread_saved_pc(task));
-
-	walk_stackframe(task, &frame, consume_entry, cookie);
 }
 
 #endif
-- 
2.25.1

