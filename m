Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DF4490AD7
	for <lists+live-patching@lfdr.de>; Mon, 17 Jan 2022 15:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239694AbiAQO42 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 17 Jan 2022 09:56:28 -0500
Received: from linux.microsoft.com ([13.77.154.182]:59428 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234410AbiAQO41 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 17 Jan 2022 09:56:27 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id DF0C020B9134;
        Mon, 17 Jan 2022 06:56:25 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DF0C020B9134
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1642431386;
        bh=nCGfF1Ec543gDZX90i0Wj4ykW5t8sYcF+sNVLRaM38M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=mkFciEK9/fF7l/P0E9YH87kZ2BjkgwDOzGA7nToGLvMs+qGXslobneuM6UmiQoIF9
         /5Ll9sKjwo6N+VLz7OfrFkykyLLDngPS+w/XvzUSGqbtPzIDDxBzs1urDo8Itv/OY9
         ctWoNs6RKGtHiW/IF9ptI6OBAOMPTR5MAj9hYnKs=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v13 02/11] arm64: Rename unwinder functions
Date:   Mon, 17 Jan 2022 08:55:59 -0600
Message-Id: <20220117145608.6781-3-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220117145608.6781-1-madvenka@linux.microsoft.com>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Rename unwinder functions for consistency and better naming.

	- Rename start_backtrace() to unwind_init().
	- Rename unwind_frame() to unwind_next().
	- Rename walk_stackframe() to unwind().

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/kernel/stacktrace.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 5f5bb35b7b41..b980d96dccfc 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -33,8 +33,8 @@
  */
 
 
-static void start_backtrace(struct stackframe *frame, unsigned long fp,
-			    unsigned long pc)
+static void unwind_init(struct stackframe *frame, unsigned long fp,
+			unsigned long pc)
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
@@ -137,23 +137,23 @@ static int notrace unwind_frame(struct task_struct *tsk,
 
 	return 0;
 }
-NOKPROBE_SYMBOL(unwind_frame);
+NOKPROBE_SYMBOL(unwind_next);
 
-static void notrace walk_stackframe(struct task_struct *tsk,
-				    struct stackframe *frame,
-				    bool (*fn)(void *, unsigned long), void *data)
+static void notrace unwind(struct task_struct *tsk,
+			   struct stackframe *frame,
+			   bool (*fn)(void *, unsigned long), void *data)
 {
 	while (1) {
 		int ret;
 
 		if (!fn(data, frame->pc))
 			break;
-		ret = unwind_frame(tsk, frame);
+		ret = unwind_next(tsk, frame);
 		if (ret < 0)
 			break;
 	}
 }
-NOKPROBE_SYMBOL(walk_stackframe);
+NOKPROBE_SYMBOL(unwind);
 
 static bool dump_backtrace_entry(void *arg, unsigned long where)
 {
@@ -195,14 +195,14 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 	struct stackframe frame;
 
 	if (regs)
-		start_backtrace(&frame, regs->regs[29], regs->pc);
+		unwind_init(&frame, regs->regs[29], regs->pc);
 	else if (task == current)
-		start_backtrace(&frame,
+		unwind_init(&frame,
 				(unsigned long)__builtin_frame_address(1),
 				(unsigned long)__builtin_return_address(0));
 	else
-		start_backtrace(&frame, thread_saved_fp(task),
+		unwind_init(&frame, thread_saved_fp(task),
 				thread_saved_pc(task));
 
-	walk_stackframe(task, &frame, consume_entry, cookie);
+	unwind(task, &frame, consume_entry, cookie);
 }
-- 
2.25.1

