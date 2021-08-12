Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FBC3EA5A1
	for <lists+live-patching@lfdr.de>; Thu, 12 Aug 2021 15:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbhHLNZa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 12 Aug 2021 09:25:30 -0400
Received: from linux.microsoft.com ([13.77.154.182]:40486 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237318AbhHLNZX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 12 Aug 2021 09:25:23 -0400
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id C376F20C171A;
        Thu, 12 Aug 2021 06:24:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C376F20C171A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1628774697;
        bh=HJY2GOAOOvc8RDfN7JED+eTXmUXW5HORS7eNhRhtjow=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=G+LPJ99WMtHJ9GZ/X8ZWPiC+O1rUz/7lzeJ303JEoLOBsRdc9UbyFHIrsP+i868H5
         u+cIjmAD8Yxc1QfoidmwzKWdd1z9UUfY077VK1zhWtBbv6oaEs17T7oyNEcWmHaZ4M
         hMTou7YG7RPClmgdDlxZDjxAUB2gG4ZbrKdhDiFc=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v7 4/4] arm64: Create a list of SYM_CODE functions, check return PC against list
Date:   Thu, 12 Aug 2021 08:24:35 -0500
Message-Id: <20210812132435.6143-5-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210812132435.6143-1-madvenka@linux.microsoft.com>
References: <3f2aab69a35c243c5e97f47c4ad84046355f5b90>
 <20210812132435.6143-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

SYM_CODE functions don't follow the usual calling conventions. Check if the
return PC in a stack frame falls in any of these. If it does, consider the
stack trace unreliable.

Define a special section for unreliable functions
=================================================

Define a SYM_CODE_END() macro for arm64 that adds the function address
range to a new section called "sym_code_functions".

Linker file
===========

Include the "sym_code_functions" section under read-only data in
vmlinux.lds.S.

Initialization
==============

Define an early_initcall() to create a sym_code_functions[] array from
the linker data.

Unwinder check
==============

Add a reliability check in unwind_is_reliable() that compares a return
PC with sym_code_functions[]. If there is a match, then return failure.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/linkage.h  | 12 +++++++
 arch/arm64/include/asm/sections.h |  1 +
 arch/arm64/kernel/stacktrace.c    | 53 +++++++++++++++++++++++++++++++
 arch/arm64/kernel/vmlinux.lds.S   | 10 ++++++
 4 files changed, 76 insertions(+)

diff --git a/arch/arm64/include/asm/linkage.h b/arch/arm64/include/asm/linkage.h
index 9906541a6861..616bad74e297 100644
--- a/arch/arm64/include/asm/linkage.h
+++ b/arch/arm64/include/asm/linkage.h
@@ -68,4 +68,16 @@
 		SYM_FUNC_END_ALIAS(x);		\
 		SYM_FUNC_END_ALIAS(__pi_##x)
 
+/*
+ * Record the address range of each SYM_CODE function in a struct code_range
+ * in a special section.
+ */
+#define SYM_CODE_END(name)				\
+	SYM_END(name, SYM_T_NONE)			;\
+	99:						;\
+	.pushsection "sym_code_functions", "aw"		;\
+	.quad	name					;\
+	.quad	99b					;\
+	.popsection
+
 #endif
diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index e4ad9db53af1..c84c71063d6e 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -21,5 +21,6 @@ extern char __exittext_begin[], __exittext_end[];
 extern char __irqentry_text_start[], __irqentry_text_end[];
 extern char __mmuoff_data_start[], __mmuoff_data_end[];
 extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
+extern char __sym_code_functions_start[], __sym_code_functions_end[];
 
 #endif /* __ASM_SECTIONS_H */
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index b60f8a20ba64..26dbdd4fff77 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -18,6 +18,31 @@
 #include <asm/stack_pointer.h>
 #include <asm/stacktrace.h>
 
+struct code_range {
+	unsigned long	start;
+	unsigned long	end;
+};
+
+static struct code_range	*sym_code_functions;
+static int			num_sym_code_functions;
+
+int __init init_sym_code_functions(void)
+{
+	size_t size = (unsigned long)__sym_code_functions_end -
+		      (unsigned long)__sym_code_functions_start;
+
+	sym_code_functions = (struct code_range *)__sym_code_functions_start;
+	/*
+	 * Order it so that sym_code_functions is not visible before
+	 * num_sym_code_functions.
+	 */
+	smp_mb();
+	num_sym_code_functions = size / sizeof(struct code_range);
+
+	return 0;
+}
+early_initcall(init_sym_code_functions);
+
 /*
  * AArch64 PCS assigns the frame pointer to x29.
  *
@@ -185,6 +210,10 @@ void show_stack(struct task_struct *tsk, unsigned long *sp, const char *loglvl)
  */
 static bool notrace unwind_is_reliable(struct stackframe *frame)
 {
+	const struct code_range *range;
+	unsigned long pc;
+	int i;
+
 	/*
 	 * If the PC is not a known kernel text address, then we cannot
 	 * be sure that a subsequent unwind will be reliable, as we
@@ -192,6 +221,30 @@ static bool notrace unwind_is_reliable(struct stackframe *frame)
 	 */
 	if (!__kernel_text_address(frame->pc))
 		return false;
+
+	/*
+	 * Check the return PC against sym_code_functions[]. If there is a
+	 * match, then the consider the stack frame unreliable.
+	 *
+	 * As SYM_CODE functions don't follow the usual calling conventions,
+	 * we assume by default that any SYM_CODE function cannot be unwound
+	 * reliably.
+	 *
+	 * Note that this includes:
+	 *
+	 * - Exception handlers and entry assembly
+	 * - Trampoline assembly (e.g., ftrace, kprobes)
+	 * - Hypervisor-related assembly
+	 * - Hibernation-related assembly
+	 * - CPU start-stop, suspend-resume assembly
+	 * - Kernel relocation assembly
+	 */
+	pc = frame->pc;
+	for (i = 0; i < num_sym_code_functions; i++) {
+		range = &sym_code_functions[i];
+		if (pc >= range->start && pc < range->end)
+			return false;
+	}
 	return true;
 }
 
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 709d2c433c5e..2bf769f45b54 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -111,6 +111,14 @@ jiffies = jiffies_64;
 #define TRAMP_TEXT
 #endif
 
+#define SYM_CODE_FUNCTIONS				\
+	. = ALIGN(16);					\
+	.symcode : AT(ADDR(.symcode) - LOAD_OFFSET) {	\
+		__sym_code_functions_start = .;		\
+		KEEP(*(sym_code_functions))		\
+		__sym_code_functions_end = .;		\
+	}
+
 /*
  * The size of the PE/COFF section that covers the kernel image, which
  * runs from _stext to _edata, must be a round multiple of the PE/COFF
@@ -196,6 +204,8 @@ SECTIONS
 	swapper_pg_dir = .;
 	. += PAGE_SIZE;
 
+	SYM_CODE_FUNCTIONS
+
 	. = ALIGN(SEGMENT_ALIGN);
 	__init_begin = .;
 	__inittext_begin = .;
-- 
2.25.1

