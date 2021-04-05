Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18EF13547BA
	for <lists+live-patching@lfdr.de>; Mon,  5 Apr 2021 22:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241053AbhDEUnd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 5 Apr 2021 16:43:33 -0400
Received: from linux.microsoft.com ([13.77.154.182]:36162 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhDEUnb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 5 Apr 2021 16:43:31 -0400
Received: from x64host.home (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id D0A9120B5680;
        Mon,  5 Apr 2021 13:43:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D0A9120B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617655404;
        bh=3vjl15rMiDqv4mSST8OwRNwQRjNnBcJQwVTVSJPcYkA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hZp/7PiOyWv/RbE7eT/geBSDlVqU4jfhQfGR1weB0Z2iISStiTC/KzpKnVj9f6jBJ
         jCeZ3hkIyOOtPEZrOGHpNwwkhHO9028vBX7qES7qrMaJbdmdGyGFwqgUJtivrt8UGf
         +F5HbAdGBMOinF3E8YctgCYWbZwJqb211LKnnyBw=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 1/4] arm64: Implement infrastructure for stack trace reliability checks
Date:   Mon,  5 Apr 2021 15:43:10 -0500
Message-Id: <20210405204313.21346-2-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210405204313.21346-1-madvenka@linux.microsoft.com>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Implement a check_reliability() function that will contain checks for the
presence of various features and conditions that can render the stack trace
unreliable.

Introduce the first reliability check - If a return PC encountered in a
stack trace is not a valid kernel text address, the stack trace is
considered unreliable. It could be some generated code.

Other reliability checks will be added in the future.

These checks will involve checking the return PC to see if it falls inside
any special functions where the stack trace is considered unreliable.
Implement the infrastructure needed for this.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/stacktrace.h |  2 +
 arch/arm64/kernel/stacktrace.c      | 80 +++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index eb29b1fe8255..684f65808394 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -59,6 +59,7 @@ struct stackframe {
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	int graph;
 #endif
+	bool reliable;
 };
 
 extern int unwind_frame(struct task_struct *tsk, struct stackframe *frame);
@@ -169,6 +170,7 @@ static inline void start_backtrace(struct stackframe *frame,
 	bitmap_zero(frame->stacks_done, __NR_STACK_TYPES);
 	frame->prev_fp = 0;
 	frame->prev_type = STACK_TYPE_UNKNOWN;
+	frame->reliable = true;
 }
 
 #endif	/* __ASM_STACKTRACE_H */
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index ad20981dfda4..557657d6e6bd 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -18,6 +18,84 @@
 #include <asm/stack_pointer.h>
 #include <asm/stacktrace.h>
 
+struct function_range {
+	unsigned long	start;
+	unsigned long	end;
+};
+
+/*
+ * Special functions where the stack trace is unreliable.
+ */
+static struct function_range	special_functions[] = {
+	{ /* sentinel */ }
+};
+
+static bool is_reliable_function(unsigned long pc)
+{
+	static bool inited = false;
+	struct function_range *func;
+
+	if (!inited) {
+		static char sym[KSYM_NAME_LEN];
+		unsigned long size, offset;
+
+		for (func = special_functions; func->start; func++) {
+			if (kallsyms_lookup(func->start, &size, &offset,
+					    NULL, sym)) {
+				func->start -= offset;
+				func->end = func->start + size;
+			} else {
+				/*
+				 * This is just a label. So, we only need to
+				 * consider that particular location. So, size
+				 * is the size of one Aarch64 instruction.
+				 */
+				func->end = func->start + 4;
+			}
+		}
+		inited = true;
+	}
+
+	for (func = special_functions; func->start; func++) {
+		if (pc >= func->start && pc < func->end)
+			return false;
+	}
+	return true;
+}
+
+/*
+ * Check for the presence of features and conditions that render the stack
+ * trace unreliable.
+ *
+ * Once all such cases have been addressed, this function can aid live
+ * patching (and this comment can be removed).
+ */
+static void check_reliability(struct stackframe *frame)
+{
+	/*
+	 * If the stack trace has already been marked unreliable, just return.
+	 */
+	if (!frame->reliable)
+		return;
+
+	/*
+	 * First, make sure that the return address is a proper kernel text
+	 * address. A NULL or invalid return address probably means there's
+	 * some generated code which __kernel_text_address() doesn't know
+	 * about. Mark the stack trace as not reliable.
+	 */
+	if (!__kernel_text_address(frame->pc)) {
+		frame->reliable = false;
+		return;
+	}
+
+	/*
+	 * Check the reliability of the return PC's function.
+	 */
+	if (!is_reliable_function(frame->pc))
+		frame->reliable = false;
+}
+
 /*
  * AArch64 PCS assigns the frame pointer to x29.
  *
@@ -108,6 +186,8 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 
 	frame->pc = ptrauth_strip_insn_pac(frame->pc);
 
+	check_reliability(frame);
+
 	return 0;
 }
 NOKPROBE_SYMBOL(unwind_frame);
-- 
2.25.1

