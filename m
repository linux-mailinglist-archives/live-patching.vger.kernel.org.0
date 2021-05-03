Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55510371EB8
	for <lists+live-patching@lfdr.de>; Mon,  3 May 2021 19:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbhECRhT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 May 2021 13:37:19 -0400
Received: from linux.microsoft.com ([13.77.154.182]:54506 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbhECRhT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 May 2021 13:37:19 -0400
Received: from x64host.home (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id 02C9920B8008;
        Mon,  3 May 2021 10:36:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 02C9920B8008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1620063385;
        bh=EYht7bnnZALqCAngJGQY0oHKDEKVB3mk09HnhdDDWvk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=k223RR53gCBeR0IYEEx2yTde/21IkoXVl7restM7bssa2WtPe/+q/LDATZTRexhGT
         apAZ38tojvUlpG1qXWDwE0WPk3Tt8Ylk2028pLx/ruhcc1CeTEQ7DeXnPcHE9dbg5k
         GYdcoU6v5P/kCeNomEshBtzuJRFn0RU3ONJILvsU=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, jpoimboe@redhat.com, mark.rutland@arm.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 2/4] arm64: Check the return PC against unreliable code sections
Date:   Mon,  3 May 2021 12:36:13 -0500
Message-Id: <20210503173615.21576-3-madvenka@linux.microsoft.com>
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

Create a sym_code_ranges[] array to cover the following text sections that
contain functions defined as SYM_CODE_*(). These functions are low-level
functions (and do not have a proper frame pointer prolog and epilog). So,
they are inherently unreliable from a stack unwinding perspective.

	.entry.text
	.idmap.text
	.hyp.idmap.text
	.hyp.text
	.hibernate_exit.text
	.entry.tramp.text

If a return PC falls in any of these, mark the stack trace unreliable.

The only exception to this is - if the unwinder has reached the last
frame already, it will not mark the stack trace unreliable since there
is no more unwinding to do. E.g.,

	- ret_from_fork() occurs at the end of the stack trace of
	  kernel tasks.

	- el0_*() functions occur at the end of EL0 exception stack
	  traces. This covers all user task entries into the kernel.

NOTE:
	- EL1 exception handlers are in .entry.text. So, stack traces that
	  contain those functions will be marked not reliable. This covers
	  interrupts, exceptions and breakpoints encountered while executing
	  in the kernel.

	- At the end of an interrupt, the kernel can preempt the current
	  task if required. So, the stack traces of all preempted tasks will
	  show the interrupt frame and will be considered unreliable.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/kernel/stacktrace.c | 54 ++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index c21a1bca28f3..1ff14615a55a 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -15,9 +15,48 @@
 
 #include <asm/irq.h>
 #include <asm/pointer_auth.h>
+#include <asm/sections.h>
 #include <asm/stack_pointer.h>
 #include <asm/stacktrace.h>
 
+struct code_range {
+	unsigned long	start;
+	unsigned long	end;
+};
+
+struct code_range	sym_code_ranges[] =
+{
+	/* non-unwindable ranges */
+	{ (unsigned long)__entry_text_start,
+	  (unsigned long)__entry_text_end },
+	{ (unsigned long)__idmap_text_start,
+	  (unsigned long)__idmap_text_end },
+	{ (unsigned long)__hyp_idmap_text_start,
+	  (unsigned long)__hyp_idmap_text_end },
+	{ (unsigned long)__hyp_text_start,
+	  (unsigned long)__hyp_text_end },
+#ifdef CONFIG_HIBERNATION
+	{ (unsigned long)__hibernate_exit_text_start,
+	  (unsigned long)__hibernate_exit_text_end },
+#endif
+#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
+	{ (unsigned long)__entry_tramp_text_start,
+	  (unsigned long)__entry_tramp_text_end },
+#endif
+	{ /* sentinel */ }
+};
+
+static struct code_range *lookup_range(unsigned long pc)
+{
+	struct code_range *range;
+
+	for (range = sym_code_ranges; range->start; range++) {
+		if (pc >= range->start && pc < range->end)
+			return range;
+	}
+	return range;
+}
+
 /*
  * AArch64 PCS assigns the frame pointer to x29.
  *
@@ -43,6 +82,7 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 {
 	unsigned long fp = frame->fp;
 	struct stack_info info;
+	struct code_range *range;
 
 	frame->reliable = true;
 
@@ -103,6 +143,8 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 		return 0;
 	}
 
+	range = lookup_range(frame->pc);
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	if (tsk->ret_stack &&
 		frame->pc == (unsigned long)return_to_handler) {
@@ -118,9 +160,21 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 			return -EINVAL;
 		frame->pc = ret_stack->ret;
 		frame->pc = ptrauth_strip_insn_pac(frame->pc);
+		return 0;
 	}
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
+	if (!range->start)
+		return 0;
+
+	/*
+	 * The return PC falls in an unreliable function. If the final frame
+	 * has been reached, no more unwinding is needed. Otherwise, mark the
+	 * stack trace not reliable.
+	 */
+	if (frame->fp)
+		frame->reliable = false;
+
 	return 0;
 }
 NOKPROBE_SYMBOL(unwind_frame);
-- 
2.25.1

