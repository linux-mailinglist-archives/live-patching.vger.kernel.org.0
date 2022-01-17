Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51E1490AE4
	for <lists+live-patching@lfdr.de>; Mon, 17 Jan 2022 15:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240311AbiAQO4m (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 17 Jan 2022 09:56:42 -0500
Received: from linux.microsoft.com ([13.77.154.182]:59528 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240211AbiAQO4e (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 17 Jan 2022 09:56:34 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id E001120B9143;
        Mon, 17 Jan 2022 06:56:32 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E001120B9143
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1642431393;
        bh=xafsbMfU+et9efkkBLXyx0qT50e2RVE8G6KU0KNMtOM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Ioa7zbuSfxYtS7hklK90XFWTYwe00nCuwgwWJcAuMa98j3UOzGnH6RQS7m0qIRoma
         WTCCnyTWddqR85bOb46b0541x7CKMl0lmZlGlJt/sBIMgoblzO4cifUV7eMR8ticPC
         /FSDPeWhqIfh4x40BfRLAMZSvESHGeYTFgZeZhyI=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v13 09/11] arm64: Create a list of SYM_CODE functions, check return PC against list
Date:   Mon, 17 Jan 2022 08:56:06 -0600
Message-Id: <20220117145608.6781-10-madvenka@linux.microsoft.com>
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

Add a reliability check in unwind_check_reliability() that compares a
return PC with sym_code_functions[]. If there is a match, then return
failure.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/linkage.h  | 12 +++++++
 arch/arm64/include/asm/sections.h |  1 +
 arch/arm64/kernel/stacktrace.c    | 55 +++++++++++++++++++++++++++++++
 arch/arm64/kernel/vmlinux.lds.S   | 10 ++++++
 4 files changed, 78 insertions(+)

diff --git a/arch/arm64/include/asm/linkage.h b/arch/arm64/include/asm/linkage.h
index b77e9b3f5371..a47e7914b289 100644
--- a/arch/arm64/include/asm/linkage.h
+++ b/arch/arm64/include/asm/linkage.h
@@ -63,4 +63,16 @@
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
index 152cb35bf9df..ac01189668c5 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -22,5 +22,6 @@ extern char __irqentry_text_start[], __irqentry_text_end[];
 extern char __mmuoff_data_start[], __mmuoff_data_end[];
 extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
 extern char __relocate_new_kernel_start[], __relocate_new_kernel_end[];
+extern char __sym_code_functions_start[], __sym_code_functions_end[];
 
 #endif /* __ASM_SECTIONS_H */
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 3dc0374e83f7..8bfe31cbee46 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -18,11 +18,40 @@
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
  * Check the stack frame for conditions that make further unwinding unreliable.
  */
 static void unwind_check_reliability(struct unwind_state *state)
 {
+	const struct code_range *range;
+	unsigned long pc;
+	int i;
+
 	if (state->fp == state->final_fp) {
 		/* Final frame; no more unwind, no need to check reliability */
 		return;
@@ -35,6 +64,32 @@ static void unwind_check_reliability(struct unwind_state *state)
 	 */
 	if (!__kernel_text_address(state->pc))
 		state->reliable = false;
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
+	pc = state->pc;
+	for (i = 0; i < num_sym_code_functions; i++) {
+		range = &sym_code_functions[i];
+		if (pc >= range->start && pc < range->end) {
+			state->reliable = false;
+			return;
+		}
+	}
 }
 
 /*
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 50bab186c49b..6381e75e566e 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -122,6 +122,14 @@ jiffies = jiffies_64;
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
@@ -209,6 +217,8 @@ SECTIONS
 	swapper_pg_dir = .;
 	. += PAGE_SIZE;
 
+	SYM_CODE_FUNCTIONS
+
 	. = ALIGN(SEGMENT_ALIGN);
 	__init_begin = .;
 	__inittext_begin = .;
-- 
2.25.1

