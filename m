Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF84C45ACA5
	for <lists+live-patching@lfdr.de>; Tue, 23 Nov 2021 20:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbhKWTkn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Nov 2021 14:40:43 -0500
Received: from linux.microsoft.com ([13.77.154.182]:41870 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbhKWTkn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Nov 2021 14:40:43 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id C5AF920D4D2F;
        Tue, 23 Nov 2021 11:37:33 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C5AF920D4D2F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1637696254;
        bh=aBWkrJAFXMJSS+1WUdBJpRlaPcIVMzXm3IBpam3uJ9Y=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=TJytDyRf37Fgz7JgNuv0WuLabLv1H8vkSUBnbEQgY7ZF6U4RwYZ4K+WJLUlurJcBf
         kiR9pf1NI5YpZWeq7VWjgM/YiVre44eCrIUi4PrE2mExPC+gLT16G8657dAPf70qad
         I+4Ze/ulCKeoNicrQuBaxlwLMUFlUGFD5t3VdTKk=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v11 1/5] arm64: Call stack_backtrace() only from within walk_stackframe()
Date:   Tue, 23 Nov 2021 13:37:19 -0600
Message-Id: <20211123193723.12112-2-madvenka@linux.microsoft.com>
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

Currently, arch_stack_walk() calls start_backtrace() and walk_stackframe()
separately. There is no need to do that. Instead, call start_backtrace()
from within walk_stackframe(). In other words, walk_stackframe() is the only
unwind function a consumer needs to call.

Currently, the only consumer is arch_stack_walk(). In the future,
arch_stack_walk_reliable() will be another consumer.

Currently, there is a check for a NULL task in unwind_frame(). It is not
needed since all current consumers pass a non-NULL task.

Use struct stackframe only within the unwind functions.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/stacktrace.c | 41 ++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 0fb58fed54cb..7217c4f63ef7 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -69,9 +69,6 @@ static int notrace unwind_frame(struct task_struct *tsk,
 	unsigned long fp = frame->fp;
 	struct stack_info info;
 
-	if (!tsk)
-		tsk = current;
-
 	/* Final frame; nothing to unwind */
 	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
 		return -ENOENT;
@@ -143,15 +140,19 @@ static int notrace unwind_frame(struct task_struct *tsk,
 NOKPROBE_SYMBOL(unwind_frame);
 
 static void notrace walk_stackframe(struct task_struct *tsk,
-				    struct stackframe *frame,
+				    unsigned long fp, unsigned long pc,
 				    bool (*fn)(void *, unsigned long), void *data)
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
@@ -195,17 +196,19 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 			      void *cookie, struct task_struct *task,
 			      struct pt_regs *regs)
 {
-	struct stackframe frame;
-
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
 }
-- 
2.25.1

