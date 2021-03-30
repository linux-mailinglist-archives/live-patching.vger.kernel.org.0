Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29EC734F176
	for <lists+live-patching@lfdr.de>; Tue, 30 Mar 2021 21:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbhC3TK0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Mar 2021 15:10:26 -0400
Received: from linux.microsoft.com ([13.77.154.182]:33638 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbhC3TKF (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Mar 2021 15:10:05 -0400
Received: from x64host.home (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 3ABA320B5681;
        Tue, 30 Mar 2021 12:10:04 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3ABA320B5681
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617131404;
        bh=8WqRBqOL5eacZZZ/2y2AI7eJekzqSItDIQKWe5DSzMo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pR2pY9KKd8J3Bj0Xvj/kLNGgCmwf4ynx7Xk8uUqwRdn2ubbi8J9qCGcMq9VItPQcu
         PiooUS+0/EnjY76r5o1lNbfiTgIb90FsZYBBIQkHIGBa+NBSFcBTZ5NJ2/yHy/Hv6I
         BDmIqNEfwOAJKWk+JiAEjVmWvyo/ph5ZgdRyXmwg=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v1 2/4] arm64: Mark a stack trace unreliable if an EL1 exception frame is detected
Date:   Tue, 30 Mar 2021 14:09:53 -0500
Message-Id: <20210330190955.13707-3-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210330190955.13707-1-madvenka@linux.microsoft.com>
References: <77bd5edeea72d44533c769b1e8c0fea7a9d7eb3a>
 <20210330190955.13707-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

EL1 exceptions can happen on any instruction including instructions in
the frame pointer prolog or epilog. Depending on where exactly they happen,
they could render the stack trace unreliable.

If an EL1 exception frame is found on the stack, mark the stack trace as
unreliable. Now, the EL1 exception frame is not at any well-known offset
on the stack. It can be anywhere on the stack. In order to properly detect
an EL1 exception frame, the return address must be checked against all of
the possible EL1 exception handlers.

Preemption
==========

Interrupts encountered in kernel code are also EL1 exceptions. At the end
of an interrupt, the interrupt handler checks if the current task must be
preempted for any reason. If so, it calls the preemption code which takes
the task off the CPU. A stack trace taken on the task after the preemption
will show the EL1 frame and will be considered unreliable. This is correct
behavior as preemption can happen practically at any point in code.

Probing
=======

Breakpoints encountered in kernel code are also EL1 exceptions. The probing
infrastructure uses breakpoints for executing probe code. While in the probe
code, the stack trace will show an EL1 frame and will be considered
unreliable. This is also correct behavior.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/exception.h |  8 +++++++
 arch/arm64/kernel/entry.S          | 14 +++++------
 arch/arm64/kernel/stacktrace.c     | 37 ++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/exception.h b/arch/arm64/include/asm/exception.h
index 6546158d2f2d..4ebd2390ef54 100644
--- a/arch/arm64/include/asm/exception.h
+++ b/arch/arm64/include/asm/exception.h
@@ -35,6 +35,14 @@ asmlinkage void el1_sync_handler(struct pt_regs *regs);
 asmlinkage void el0_sync_handler(struct pt_regs *regs);
 asmlinkage void el0_sync_compat_handler(struct pt_regs *regs);
 
+asmlinkage void el1_sync(void);
+asmlinkage void el1_irq(void);
+asmlinkage void el1_error(void);
+asmlinkage void el1_sync_invalid(void);
+asmlinkage void el1_irq_invalid(void);
+asmlinkage void el1_fiq_invalid(void);
+asmlinkage void el1_error_invalid(void);
+
 asmlinkage void noinstr enter_el1_irq_or_nmi(struct pt_regs *regs);
 asmlinkage void noinstr exit_el1_irq_or_nmi(struct pt_regs *regs);
 asmlinkage void enter_from_user_mode(void);
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index a31a0a713c85..9fe3aaeff019 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -630,19 +630,19 @@ SYM_CODE_START_LOCAL(el0_fiq_invalid_compat)
 SYM_CODE_END(el0_fiq_invalid_compat)
 #endif
 
-SYM_CODE_START_LOCAL(el1_sync_invalid)
+SYM_CODE_START(el1_sync_invalid)
 	inv_entry 1, BAD_SYNC
 SYM_CODE_END(el1_sync_invalid)
 
-SYM_CODE_START_LOCAL(el1_irq_invalid)
+SYM_CODE_START(el1_irq_invalid)
 	inv_entry 1, BAD_IRQ
 SYM_CODE_END(el1_irq_invalid)
 
-SYM_CODE_START_LOCAL(el1_fiq_invalid)
+SYM_CODE_START(el1_fiq_invalid)
 	inv_entry 1, BAD_FIQ
 SYM_CODE_END(el1_fiq_invalid)
 
-SYM_CODE_START_LOCAL(el1_error_invalid)
+SYM_CODE_START(el1_error_invalid)
 	inv_entry 1, BAD_ERROR
 SYM_CODE_END(el1_error_invalid)
 
@@ -650,7 +650,7 @@ SYM_CODE_END(el1_error_invalid)
  * EL1 mode handlers.
  */
 	.align	6
-SYM_CODE_START_LOCAL_NOALIGN(el1_sync)
+SYM_CODE_START_NOALIGN(el1_sync)
 	kernel_entry 1
 	mov	x0, sp
 	bl	el1_sync_handler
@@ -658,7 +658,7 @@ SYM_CODE_START_LOCAL_NOALIGN(el1_sync)
 SYM_CODE_END(el1_sync)
 
 	.align	6
-SYM_CODE_START_LOCAL_NOALIGN(el1_irq)
+SYM_CODE_START_NOALIGN(el1_irq)
 	kernel_entry 1
 	gic_prio_irq_setup pmr=x20, tmp=x1
 	enable_da_f
@@ -737,7 +737,7 @@ el0_irq_naked:
 	b	ret_to_user
 SYM_CODE_END(el0_irq)
 
-SYM_CODE_START_LOCAL(el1_error)
+SYM_CODE_START(el1_error)
 	kernel_entry 1
 	mrs	x1, esr_el1
 	gic_prio_kentry_setup tmp=x2
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index ff35b3953c39..7662f57d3e88 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -14,6 +14,7 @@
 #include <linux/stacktrace.h>
 
 #include <asm/irq.h>
+#include <asm/exception.h>
 #include <asm/pointer_auth.h>
 #include <asm/stack_pointer.h>
 #include <asm/stacktrace.h>
@@ -25,8 +26,44 @@ struct function_range {
 
 /*
  * Special functions where the stack trace is unreliable.
+ *
+ * EL1 exceptions
+ * ==============
+ *
+ * EL1 exceptions can happen on any instruction including instructions in
+ * the frame pointer prolog or epilog. Depending on where exactly they happen,
+ * they could render the stack trace unreliable.
+ *
+ * If an EL1 exception frame is found on the stack, mark the stack trace as
+ * unreliable. Now, the EL1 exception frame is not at any well-known offset
+ * on the stack. It can be anywhere on the stack. In order to properly detect
+ * an EL1 exception frame, the return address must be checked against all of
+ * the possible EL1 exception handlers.
+ *
+ * Interrupts encountered in kernel code are also EL1 exceptions. At the end
+ * of an interrupt, the current task can get preempted. A stack trace taken
+ * on the task after the preemption will show the EL1 frame and will be
+ * considered unreliable. This is correct behavior as preemption can happen
+ * practically at any point in code.
+ *
+ * Breakpoints encountered in kernel code are also EL1 exceptions. Breakpoints
+ * can happen practically on any instruction. Mark the stack trace as
+ * unreliable. Breakpoints are used for executing probe code. Stack traces
+ * taken while in the probe code will show an EL1 frame and will be considered
+ * unreliable. This is correct behavior.
  */
 static struct function_range	special_functions[] = {
+	/*
+	 * EL1 exception handlers.
+	 */
+	{ (unsigned long) el1_sync, 0 },
+	{ (unsigned long) el1_irq, 0 },
+	{ (unsigned long) el1_error, 0 },
+	{ (unsigned long) el1_sync_invalid, 0 },
+	{ (unsigned long) el1_irq_invalid, 0 },
+	{ (unsigned long) el1_fiq_invalid, 0 },
+	{ (unsigned long) el1_error_invalid, 0 },
+
 	{ 0, 0 }
 };
 
-- 
2.25.1

