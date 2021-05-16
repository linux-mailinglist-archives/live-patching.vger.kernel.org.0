Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32C3381C59
	for <lists+live-patching@lfdr.de>; Sun, 16 May 2021 06:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbhEPEBr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 16 May 2021 00:01:47 -0400
Received: from linux.microsoft.com ([13.77.154.182]:45138 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhEPEBr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 16 May 2021 00:01:47 -0400
Received: from x64host.home (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id 225D420B8008;
        Sat, 15 May 2021 21:00:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 225D420B8008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1621137632;
        bh=PYPweDHqRbvaXjH+hEzoM6fCWoLSO1BbHSyYQNeiAMk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=QyEgrz8a9rVQovyNyJ/dLIxwtCAnzK1ZnN5qpjEPwfKau0EWGxXXLSwnnW8u86VUS
         u91FVwf7wRqQnGXWJwXXeI4lFm2udMShxrRJOsj0RP+0SpDdx+gD59Ym35yhzx2IS5
         wCp5srgruELA42KE6obHzTkdaxOeJSvgqgxvfNDY=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        ardb@kernel.org, jthierry@redhat.com, catalin.marinas@arm.com,
        will@kernel.org, jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v4 2/2] arm64: Create a list of SYM_CODE functions, blacklist them in the unwinder
Date:   Sat, 15 May 2021 23:00:18 -0500
Message-Id: <20210516040018.128105-3-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210516040018.128105-1-madvenka@linux.microsoft.com>
References: <68eeda61b3e9579d65698a884b26c8632025e503>
 <20210516040018.128105-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

The unwinder should check if the return PC falls in any function that
is considered unreliable from an unwinding perspective. If it does,
mark the stack trace unreliable.

Function types
==============

The compiler generates code for C functions and assigns the type STT_FUNC
to them.

Assembly functions are manually assigned a type:

	- STT_FUNC for functions defined with SYM_FUNC*() macros

	- STT_NONE for functions defined with SYM_CODE*() macros

In the future, STT_FUNC functions will be analyzed by objtool and "fixed"
as necessary. So, they are not "interesting" to the reliable unwinder in
the kernel.

That leaves SYM_CODE*() functions. These contain low-level code that is
difficult or impossible for objtool to analyze. So, objtool ignores them
leaving them to the reliable unwinder. These functions must be blacklisted
for unwinding in some way.

Blacklisting functions
======================

Define a SYM_CODE_END() macro for arm64 that adds the function address
range to a new section called "sym_code_functions".

Linker file
===========

Include the "sym_code_functions" section under initdata in vmlinux.lds.S.

Initialization
==============

Define an early_initcall() to copy the function address ranges from the
"sym_code_functions" section to an array by the same name.

Unwinder check
==============

Define a function called unwinder_blacklisted() that compares a return
PC with sym_code_functions[]. If there is a match, then mark the stack trace
as unreliable. Call unwinder_blacklisted() from unwind_frame().

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/linkage.h  | 12 ++++++
 arch/arm64/include/asm/sections.h |  1 +
 arch/arm64/kernel/stacktrace.c    | 61 ++++++++++++++++++++++++++++++-
 arch/arm64/kernel/vmlinux.lds.S   |  7 ++++
 4 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/linkage.h b/arch/arm64/include/asm/linkage.h
index ba89a9af820a..3b5f1fd332b0 100644
--- a/arch/arm64/include/asm/linkage.h
+++ b/arch/arm64/include/asm/linkage.h
@@ -60,4 +60,16 @@
 		SYM_FUNC_END(x);		\
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
index 2f36b16a5b5d..29cb566f65ec 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -20,5 +20,6 @@ extern char __exittext_begin[], __exittext_end[];
 extern char __irqentry_text_start[], __irqentry_text_end[];
 extern char __mmuoff_data_start[], __mmuoff_data_end[];
 extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
+extern char __sym_code_functions_start[], __sym_code_functions_end[];
 
 #endif /* __ASM_SECTIONS_H */
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index d38232cab3ee..f488425cacf1 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -18,6 +18,52 @@
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
+	size_t size;
+
+	size = (unsigned long)__sym_code_functions_end -
+	       (unsigned long)__sym_code_functions_start;
+
+	sym_code_functions = kmalloc(size, GFP_KERNEL);
+	if (!sym_code_functions)
+		return -ENOMEM;
+
+	memcpy(sym_code_functions, __sym_code_functions_start, size);
+	/* Update num_sym_code_functions after copying sym_code_functions. */
+	smp_mb();
+	num_sym_code_functions = size / sizeof(struct code_range);
+
+	return 0;
+}
+early_initcall(init_sym_code_functions);
+
+static bool unwinder_blacklisted(unsigned long pc)
+{
+	const struct code_range *range;
+	int i;
+
+	/*
+	 * If sym_code_functions[] were sorted, a binary search could be
+	 * done to make this more performant.
+	 */
+	for (i = 0; i < num_sym_code_functions; i++) {
+		range = &sym_code_functions[i];
+		if (pc >= range->start && pc < range->end)
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * AArch64 PCS assigns the frame pointer to x29.
  *
@@ -130,7 +176,20 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 	 * A NULL or invalid return address probably means there's some
 	 * generated code which __kernel_text_address() doesn't know about.
 	 */
-	if (!__kernel_text_address(frame->pc))
+	if (!__kernel_text_address(frame->pc)) {
+		frame->reliable = false;
+		return 0;
+	}
+
+	/*
+	 * If the final frame has been reached, there is no more unwinding
+	 * to do. There is no need to check if the return PC is blacklisted
+	 * by the unwinder.
+	 */
+	if (!frame->fp)
+		return 0;
+
+	if (unwinder_blacklisted(frame->pc))
 		frame->reliable = false;
 
 	return 0;
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 7eea7888bb02..32e8d57397a1 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -103,6 +103,12 @@ jiffies = jiffies_64;
 #define TRAMP_TEXT
 #endif
 
+#define SYM_CODE_FUNCTIONS                                     \
+       . = ALIGN(16);                                           \
+       __sym_code_functions_start = .;                         \
+       KEEP(*(sym_code_functions))                             \
+       __sym_code_functions_end = .;
+
 /*
  * The size of the PE/COFF section that covers the kernel image, which
  * runs from _stext to _edata, must be a round multiple of the PE/COFF
@@ -218,6 +224,7 @@ SECTIONS
 		CON_INITCALL
 		INIT_RAM_FS
 		*(.init.altinstructions .init.bss)	/* from the EFI stub */
+               SYM_CODE_FUNCTIONS
 	}
 	.exit.data : {
 		EXIT_DATA
-- 
2.25.1

