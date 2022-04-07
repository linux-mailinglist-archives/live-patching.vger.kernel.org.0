Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38494F8A4C
	for <lists+live-patching@lfdr.de>; Fri,  8 Apr 2022 00:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbiDGUkG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 7 Apr 2022 16:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiDGUjs (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 7 Apr 2022 16:39:48 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C9E6354D0A;
        Thu,  7 Apr 2022 13:26:06 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5396D201CBCE;
        Thu,  7 Apr 2022 13:26:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5396D201CBCE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1649363166;
        bh=IxH5f/rG0qHAdKJ19wqUTznmank9iR+DfeF+leQMuho=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OpiX1ntGZX7hhslS/KHl/yvU0PMaM3l/8k8ZBwmn42T/pvpIKsU6CMkMeVKdK5PVg
         BHokwtZ/S90gwxJH9SGOimfby3wNdOnnrcDZOchbV/B0sMGriMv0aTYjA9KjKdCcts
         4c3M1J1ZKiJHAq7Y9nF+h7uKx3EsyZ3CAkq412IM=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v1 6/9] arm64: unwinder: Add a reliability check in the unwinder based on DWARF CFI
Date:   Thu,  7 Apr 2022 15:25:15 -0500
Message-Id: <20220407202518.19780-7-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407202518.19780-1-madvenka@linux.microsoft.com>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Introduce a reliability flag in struct stackframe. This will be set to false
if the PC does not have valid DWARF rules or if the frame pointer computed
from the DWARF rules does not match the actual frame pointer.

Now that the unwinder can validate the frame pointer, introduce
arch_stack_walk_reliable().

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/stacktrace.h |  6 +++
 arch/arm64/kernel/stacktrace.c      | 69 +++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 6564a01cc085..93adee4219ed 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -5,6 +5,7 @@
 #ifndef __ASM_STACKTRACE_H
 #define __ASM_STACKTRACE_H
 
+#include <linux/dwarf.h>
 #include <linux/percpu.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
@@ -35,6 +36,7 @@ struct stack_info {
  * A snapshot of a frame record or fp/lr register values, along with some
  * accounting information necessary for robust unwinding.
  *
+ * @sp:          The sp value (CFA) at the call site of the current function.
  * @fp:          The fp value in the frame record (or the real fp)
  * @pc:          The lr value in the frame record (or the real lr)
  *
@@ -47,8 +49,11 @@ struct stack_info {
  * @prev_type:   The type of stack this frame record was on, or a synthetic
  *               value of STACK_TYPE_UNKNOWN. This is used to detect a
  *               transition from one stack to another.
+ *
+ * @reliable     Stack trace is reliable.
  */
 struct stackframe {
+	unsigned long sp;
 	unsigned long fp;
 	unsigned long pc;
 	DECLARE_BITMAP(stacks_done, __NR_STACK_TYPES);
@@ -57,6 +62,7 @@ struct stackframe {
 #ifdef CONFIG_KRETPROBES
 	struct llist_node *kr_cur;
 #endif
+	bool reliable;
 };
 
 extern int unwind_frame(struct task_struct *tsk, struct stackframe *frame);
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 94f83cd44e50..f9ef7a3e7296 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2012 ARM Ltd.
  */
 #include <linux/kernel.h>
+#include <linux/dwarf.h>
 #include <linux/export.h>
 #include <linux/ftrace.h>
 #include <linux/kprobes.h>
@@ -36,8 +37,22 @@
 void start_backtrace(struct stackframe *frame, unsigned long fp,
 		     unsigned long pc)
 {
+	struct dwarf_rule *rule;
+
+	frame->reliable = true;
 	frame->fp = fp;
 	frame->pc = pc;
+	frame->sp = 0;
+	/*
+	 * Lookup the dwarf rule for PC. If it exists, initialize the SP
+	 * based on the frame pointer passed in.
+	 */
+	rule = dwarf_lookup(pc);
+	if (rule)
+		frame->sp = fp - rule->fp_offset;
+	else
+		frame->reliable = false;
+
 #ifdef CONFIG_KRETPROBES
 	frame->kr_cur = NULL;
 #endif
@@ -67,6 +82,8 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 {
 	unsigned long fp = frame->fp;
 	struct stack_info info;
+	struct dwarf_rule *rule;
+	unsigned long lookup_pc;
 
 	if (!tsk)
 		tsk = current;
@@ -137,6 +154,32 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 		frame->pc = kretprobe_find_ret_addr(tsk, (void *)frame->fp, &frame->kr_cur);
 #endif
 
+	/*
+	 * If it is the last frame, no need to check dwarf.
+	 */
+	if (frame->fp == (unsigned long)task_pt_regs(tsk)->stackframe)
+		return 0;
+
+	if (!frame->reliable) {
+		/*
+		 * The sp value cannot be reliably computed anymore because a
+		 * previous frame was unreliable.
+		 */
+		return 0;
+	}
+	lookup_pc = frame->pc;
+
+	rule = dwarf_lookup(lookup_pc);
+	if (!rule) {
+		frame->reliable = false;
+		return 0;
+	}
+
+	frame->sp += rule->sp_offset;
+	if (frame->fp != (frame->sp + rule->fp_offset)) {
+		frame->reliable = false;
+		return 0;
+	}
 	return 0;
 }
 NOKPROBE_SYMBOL(unwind_frame);
@@ -242,4 +285,30 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
 	walk_stackframe(task, &frame, consume_entry, cookie);
 }
 
+noinline int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
+			      void *cookie, struct task_struct *task)
+{
+	struct stackframe frame;
+	int ret = 0;
+
+	if (task == current) {
+		start_backtrace(&frame,
+				(unsigned long)__builtin_frame_address(1),
+				(unsigned long)__builtin_return_address(0));
+	} else {
+		start_backtrace(&frame, thread_saved_fp(task),
+				thread_saved_pc(task));
+	}
+
+	while (!ret) {
+		if (!frame.reliable)
+			return -EINVAL;
+		if (!consume_entry(cookie, frame.pc))
+			return -EINVAL;
+		ret = unwind_frame(task, &frame);
+	}
+
+	return ret == -ENOENT ? 0 : -EINVAL;
+}
+
 #endif
-- 
2.25.1

