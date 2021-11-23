Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2623945ACA8
	for <lists+live-patching@lfdr.de>; Tue, 23 Nov 2021 20:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbhKWTkr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Nov 2021 14:40:47 -0500
Received: from linux.microsoft.com ([13.77.154.182]:41888 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238344AbhKWTko (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Nov 2021 14:40:44 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id D82DA20D4D35;
        Tue, 23 Nov 2021 11:37:34 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D82DA20D4D35
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1637696255;
        bh=H/EAM8XTL11m8uJh5cKvuLNCQnwF39y51M9DbDTiLvs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PPD3YXWkzU90QtJeg8CPKxmJitFE6ph3inHyeoaCG7+MRCWBnfa/I9sn74ilvyqtl
         oNTiQu35Xd9OIoEfjX+XvS32aXKNt2oPv1Tu7cqNDvy1poXAbOFTGDK/SahyseZ/In
         S5MhBZKPUEEelvDLrbFy9BDSxuD/Qwj1RPuDibxs=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v11 2/5] arm64: Rename unwinder functions
Date:   Tue, 23 Nov 2021 13:37:20 -0600
Message-Id: <20211123193723.12112-3-madvenka@linux.microsoft.com>
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

Rename unwinder functions for consistency and better naming.

	- Rename start_backtrace() to unwind_start().
	- Rename unwind_frame() to unwind_next().
	- Rename walk_stackframe() to unwind().

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/stacktrace.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 7217c4f63ef7..918852cd2681 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -33,8 +33,8 @@
  */
 
 
-static void start_backtrace(struct stackframe *frame, unsigned long fp,
-			    unsigned long pc)
+static void unwind_start(struct stackframe *frame, unsigned long fp,
+			 unsigned long pc)
 {
 	frame->fp = fp;
 	frame->pc = pc;
@@ -45,7 +45,7 @@ static void start_backtrace(struct stackframe *frame, unsigned long fp,
 	/*
 	 * Prime the first unwind.
 	 *
-	 * In unwind_frame() we'll check that the FP points to a valid stack,
+	 * In unwind_next() we'll check that the FP points to a valid stack,
 	 * which can't be STACK_TYPE_UNKNOWN, and the first unwind will be
 	 * treated as a transition to whichever stack that happens to be. The
 	 * prev_fp value won't be used, but we set it to 0 such that it is
@@ -63,8 +63,8 @@ static void start_backtrace(struct stackframe *frame, unsigned long fp,
  * records (e.g. a cycle), determined based on the location and fp value of A
  * and the location (but not the fp value) of B.
  */
-static int notrace unwind_frame(struct task_struct *tsk,
-				struct stackframe *frame)
+static int notrace unwind_next(struct task_struct *tsk,
+			       struct stackframe *frame)
 {
 	unsigned long fp = frame->fp;
 	struct stack_info info;
@@ -104,7 +104,7 @@ static int notrace unwind_frame(struct task_struct *tsk,
 
 	/*
 	 * Record this frame record's values and location. The prev_fp and
-	 * prev_type are only meaningful to the next unwind_frame() invocation.
+	 * prev_type are only meaningful to the next unwind_next() invocation.
 	 */
 	frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp));
 	frame->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp + 8));
@@ -137,27 +137,27 @@ static int notrace unwind_frame(struct task_struct *tsk,
 
 	return 0;
 }
-NOKPROBE_SYMBOL(unwind_frame);
+NOKPROBE_SYMBOL(unwind_next);
 
-static void notrace walk_stackframe(struct task_struct *tsk,
-				    unsigned long fp, unsigned long pc,
-				    bool (*fn)(void *, unsigned long), void *data)
+static void notrace unwind(struct task_struct *tsk,
+			   unsigned long fp, unsigned long pc,
+			   bool (*fn)(void *, unsigned long), void *data)
 {
 	struct stackframe frame;
 
-	start_backtrace(&frame, fp, pc);
+	unwind_start(&frame, fp, pc);
 
 	while (1) {
 		int ret;
 
 		if (!fn(data, frame.pc))
 			break;
-		ret = unwind_frame(tsk, &frame);
+		ret = unwind_next(tsk, &frame);
 		if (ret < 0)
 			break;
 	}
 }
-NOKPROBE_SYMBOL(walk_stackframe);
+NOKPROBE_SYMBOL(unwind);
 
 static bool dump_backtrace_entry(void *arg, unsigned long where)
 {
@@ -210,5 +210,5 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 		fp = thread_saved_fp(task);
 		pc = thread_saved_pc(task);
 	}
-	walk_stackframe(task, fp, pc, consume_entry, cookie);
+	unwind(task, fp, pc, consume_entry, cookie);
 }
-- 
2.25.1

