Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299F742E6F5
	for <lists+live-patching@lfdr.de>; Fri, 15 Oct 2021 04:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235189AbhJODBV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Oct 2021 23:01:21 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58248 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbhJODBR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Oct 2021 23:01:17 -0400
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id E7D2120B9D21;
        Thu, 14 Oct 2021 19:59:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E7D2120B9D21
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634266751;
        bh=6bWkd/ZYo9iwC5D6ljtnqzr8MoO2MeG2exKw7wTf0A8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=aiS3cVux9FCKsVix3SaXW/0koiK0Oxq8ZfyTRpRo7ty5gw6WgfhpgQSREPsIIeZHR
         HdrXCNoiWO1PwwnxV2yrA1mRfeGfUoP5HHTFcl4U+OFT6POPkabsa6bDZoonDbIzvH
         A7N/wBvi03oKwT38Y2PcOjv6l/KdsqgOjvXuWwnk=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v10 08/11] arm64: Rename unwinder functions, prevent them from being traced and kprobed
Date:   Thu, 14 Oct 2021 21:58:44 -0500
Message-Id: <20211015025847.17694-9-madvenka@linux.microsoft.com>
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

Rename unwinder functions for consistency and better naming.

	- Rename start_backtrace() to unwind_start().
	- Rename unwind_frame() to unwind_next().
	- Rename walk_stackframe() to unwind().

Prevent the following unwinder functions from being traced:

	- unwind_start()
	- unwind_next()

	unwind() is already prevented from being traced.

Prevent the following unwinder functions from being kprobed:

	- unwind_start()

	unwind_next() and unwind() are already prevented from being kprobed.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/stacktrace.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 7d32cee9ef4b..f4f3575f71fd 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -33,8 +33,8 @@
  */
 
 
-static void start_backtrace(struct stackframe *frame, unsigned long fp,
-			    unsigned long pc)
+static void notrace unwind_start(struct stackframe *frame, unsigned long fp,
+				 unsigned long pc)
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
@@ -56,6 +56,8 @@ static void start_backtrace(struct stackframe *frame, unsigned long fp,
 	frame->prev_type = STACK_TYPE_UNKNOWN;
 }
 
+NOKPROBE_SYMBOL(unwind_start);
+
 /*
  * Unwind from one frame record (A) to the next frame record (B).
  *
@@ -63,8 +65,8 @@ static void start_backtrace(struct stackframe *frame, unsigned long fp,
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
@@ -104,7 +106,7 @@ static int notrace unwind_frame(struct task_struct *tsk,
 
 	/*
 	 * Record this frame record's values and location. The prev_fp and
-	 * prev_type are only meaningful to the next unwind_frame() invocation.
+	 * prev_type are only meaningful to the next unwind_next() invocation.
 	 */
 	frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp));
 	frame->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp + 8));
@@ -132,28 +134,30 @@ static int notrace unwind_frame(struct task_struct *tsk,
 
 	return 0;
 }
-NOKPROBE_SYMBOL(unwind_frame);
 
-static void notrace walk_stackframe(struct task_struct *tsk,
-				    unsigned long fp, unsigned long pc,
-				    bool (*fn)(void *, unsigned long),
-				    void *data)
+NOKPROBE_SYMBOL(unwind_next);
+
+static void notrace unwind(struct task_struct *tsk,
+			   unsigned long fp, unsigned long pc,
+			   bool (*fn)(void *, unsigned long),
+			   void *data)
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
+
+NOKPROBE_SYMBOL(unwind);
 
 static bool dump_backtrace_entry(void *arg, unsigned long where)
 {
@@ -208,7 +212,7 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 		fp = thread_saved_fp(task);
 		pc = thread_saved_pc(task);
 	}
-	walk_stackframe(task, fp, pc, consume_entry, cookie);
+	unwind(task, fp, pc, consume_entry, cookie);
 
 }
 
-- 
2.25.1

