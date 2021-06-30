Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576663B8A80
	for <lists+live-patching@lfdr.de>; Thu,  1 Jul 2021 00:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbhF3Wgm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 30 Jun 2021 18:36:42 -0400
Received: from linux.microsoft.com ([13.77.154.182]:44558 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbhF3Wgh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 30 Jun 2021 18:36:37 -0400
Received: from x64host.home (unknown [47.187.214.213])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5D74320B6C50;
        Wed, 30 Jun 2021 15:34:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5D74320B6C50
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1625092448;
        bh=vvpqMQAHDttXStCeHW5CJ8/Wc5hwp1u/fuylw90c96k=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=a1psfSJyxoBli1dd32NGtI32qMUWrmrp6sTy1CCHLu3gX2KXBWDcwHBarGoSXhPay
         F+euBIEVzUjv2Wdl2YQrdq9wowl2DistAvqba19L4lMYnGInhahOspvRZy+/8DhNLR
         g08JtM77Z5Z2+YPzM4f/psmtIaqv9oSeU31QxZxI=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v6 2/3] arm64: Introduce stack trace reliability checks in the unwinder
Date:   Wed, 30 Jun 2021 17:33:55 -0500
Message-Id: <20210630223356.58714-3-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210630223356.58714-1-madvenka@linux.microsoft.com>
References: <3f2aab69a35c243c5e97f47c4ad84046355f5b90>
 <20210630223356.58714-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

The unwinder should check for the presence of various features and
conditions that can render the stack trace unreliable. Introduce a
function unwind_check_frame() for this purpose.

Introduce the first reliability check in unwind_check_frame() - If
a return PC is not a valid kernel text address, consider the stack
trace unreliable. It could be some generated code.

Other reliability checks will be added in the future.

If a reliability check fails, it is a non-fatal error. Introduce a new
return code, UNWIND_CONTINUE_WITH_RISK, for non-fatal errors.

Call unwind_check_frame() from unwind_frame(). Also, call it from
start_backtrace() to remove the current assumption that the starting
frame is reliable.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/stacktrace.h |  4 +++-
 arch/arm64/kernel/stacktrace.c      | 17 ++++++++++++++++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 6fcd58553fb1..d1625d55b980 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -32,6 +32,7 @@ struct stack_info {
 
 enum unwind_rc {
 	UNWIND_CONTINUE,		/* No errors encountered */
+	UNWIND_CONTINUE_WITH_RISK,	/* Non-fatal errors encountered */
 	UNWIND_ABORT,			/* Fatal errors encountered */
 	UNWIND_FINISH,			/* End of stack reached successfully */
 };
@@ -73,6 +74,7 @@ extern void walk_stackframe(struct task_struct *tsk, struct stackframe *frame,
 			    bool (*fn)(void *, unsigned long), void *data);
 extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
 			   const char *loglvl);
+extern enum unwind_rc unwind_check_frame(struct stackframe *frame);
 
 DECLARE_PER_CPU(unsigned long *, irq_stack_ptr);
 
@@ -176,7 +178,7 @@ static inline enum unwind_rc start_backtrace(struct stackframe *frame,
 	bitmap_zero(frame->stacks_done, __NR_STACK_TYPES);
 	frame->prev_fp = 0;
 	frame->prev_type = STACK_TYPE_UNKNOWN;
-	return UNWIND_CONTINUE;
+	return unwind_check_frame(frame);
 }
 
 #endif	/* __ASM_STACKTRACE_H */
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index e9c2c1fa9dde..ba7b97b119e4 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -18,6 +18,21 @@
 #include <asm/stack_pointer.h>
 #include <asm/stacktrace.h>
 
+/*
+ * Check the stack frame for conditions that make unwinding unreliable.
+ */
+enum unwind_rc unwind_check_frame(struct stackframe *frame)
+{
+	/*
+	 * If the PC is not a known kernel text address, then we cannot
+	 * be sure that a subsequent unwind will be reliable, as we
+	 * don't know that the code follows our unwind requirements.
+	 */
+	if (!__kernel_text_address(frame->pc))
+		return UNWIND_CONTINUE_WITH_RISK;
+	return UNWIND_CONTINUE;
+}
+
 /*
  * AArch64 PCS assigns the frame pointer to x29.
  *
@@ -109,7 +124,7 @@ enum unwind_rc notrace unwind_frame(struct task_struct *tsk,
 
 	frame->pc = ptrauth_strip_insn_pac(frame->pc);
 
-	return UNWIND_CONTINUE;
+	return unwind_check_frame(frame);
 }
 NOKPROBE_SYMBOL(unwind_frame);
 
-- 
2.25.1

