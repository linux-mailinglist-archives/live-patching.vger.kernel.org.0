Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AA9392251
	for <lists+live-patching@lfdr.de>; Wed, 26 May 2021 23:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbhEZVvB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 26 May 2021 17:51:01 -0400
Received: from linux.microsoft.com ([13.77.154.182]:50008 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234205AbhEZVvB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 26 May 2021 17:51:01 -0400
Received: from x64host.home (unknown [47.187.214.213])
        by linux.microsoft.com (Postfix) with ESMTPSA id 29A1220B8008;
        Wed, 26 May 2021 14:49:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 29A1220B8008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1622065769;
        bh=ESpyZLlRv061AvnJH30Utw2fdRza4055Ovdy85dsDXg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=f/Vyemg+FkJKCXaxElSXEgx9V5gTmlvl9sXoxlz52UakYV8r8xF59xccvCfphZF4X
         PcC5OOk1riwJPduVhGoVKI5As2mZnb2gDPo5LR0m1hpaZNDo6ueRoQ1J2CbuAjZLtn
         AAW7d5+BrxmRcQy03Gdwl9kFHwgLpw9hShcr0uNM=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com, catalin.marinas@arm.com,
        will@kernel.org, jmorris@namei.org, pasha.tatashin@soleen.com,
        jthierry@redhat.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v5 2/2] arm64: Create a list of SYM_CODE functions, check return PC against list
Date:   Wed, 26 May 2021 16:49:17 -0500
Message-Id: <20210526214917.20099-3-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210526214917.20099-1-madvenka@linux.microsoft.com>
References: <ea0ef9ed6eb34618bcf468fbbf8bdba99e15df7d>
 <20210526214917.20099-1-madvenka@linux.microsoft.com>
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
leaving them to the reliable unwinder. These functions must be considered
unreliable from an unwinding perspective.

Define a special section for unreliable functions
=================================================

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

Define a function called unwinder_is_unreliable() that compares a return
PC with sym_code_functions[]. If there is a match, then mark the stack trace
as unreliable. Call unwinder_is_unreliable() from unwind_frame().

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/linkage.h  |  12 +++
 arch/arm64/include/asm/sections.h |   1 +
 arch/arm64/kernel/stacktrace.c    | 118 +++++++++++++++++++++++++++++-
 arch/arm64/kernel/vmlinux.lds.S   |   7 ++
 4 files changed, 137 insertions(+), 1 deletion(-)

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
index 9061375c8785..5477a9d39b12 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -18,6 +18,109 @@
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
+/*
+ * Check the return PC against sym_code_functions[]. If there is a match, then
+ * the consider the stack frame unreliable. These functions contain low-level
+ * code where the frame pointer and/or the return address register cannot be
+ * relied upon. This addresses the following situations:
+ *
+ *	- Exception handlers and entry assembly
+ *	- Trampoline assembly (e.g., ftrace, kprobes)
+ *	- Hypervisor-related assembly
+ *	- Hibernation-related assembly
+ *	- CPU start-stop, suspend-resume assembly
+ *	- Kernel relocation assembly
+ *
+ * Some special cases covered by sym_code_functions[] deserve a mention here:
+ *
+ *	- All EL1 interrupt and exception stack traces will be considered
+ *	  unreliable. This is the correct behavior as interrupts and exceptions
+ *	  can happen on any instruction including ones in the frame pointer
+ *	  prolog and epilog. Unless stack metadata is available so the unwinder
+ *	  can unwind through these special cases, such stack traces will be
+ *	  considered unreliable.
+ *
+ *	- A task can get preempted at the end of an interrupt. Stack traces
+ *	  of preempted tasks will show the interrupt frame in the stack trace
+ *	  and will be considered unreliable.
+ *
+ *	- Breakpoints are exceptions. So, all stack traces in the break point
+ *	  handler (including probes) will be considered unreliable.
+ *
+ *	- All of the ftrace entry trampolines are considered unreliable. So,
+ *	  all stack traces taken from tracer functions will be considered
+ *	  unreliable.
+ *
+ *	- The Function Graph Tracer return trampoline (return_to_handler)
+ *	  and the Kretprobe return trampoline (kretprobe_trampoline) are
+ *	  also considered unreliable.
+ *
+ * Some of the special cases above can be unwound through using special logic
+ * in unwind_frame().
+ *
+ *	- return_to_handler() is handled by the unwinder by attempting to
+ *	  retrieve the original return address from the per-task return
+ *	  address stack.
+ *
+ *	- kretprobe_trampoline() can be handled in a similar fashion by
+ *	  attempting to retrieve the original return address from the per-task
+ *	  kretprobe instance list.
+ *
+ *	- I reckon optprobes can be handled in a similar fashion in the future?
+ *
+ *	- Stack traces taken from the FTrace tracer functions can be handled
+ *	  as well. ftrace_call is an inner label defined in the Ftrace entry
+ *	  trampoline. This is the location where the call to a tracer function
+ *	  is patched. So, if the return PC equals ftrace_call+4, it is
+ *	  reliable. At that point, proper stack frames have already been set
+ *	  up for the traced function and its caller.
+ */
+static bool unwinder_is_unreliable(unsigned long pc)
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
@@ -133,7 +236,20 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 	 *	- Foreign code (e.g. EFI runtime services)
 	 *	- Procedure Linkage Table (PLT) entries and veneer functions
 	 */
-	if (!__kernel_text_address(frame->pc))
+	if (!__kernel_text_address(frame->pc)) {
+		frame->reliable = false;
+		return 0;
+	}
+
+	/*
+	 * If the final frame has been reached, there is no more unwinding
+	 * to do. There is no need to check if the return PC is considered
+	 * unreliable by the unwinder.
+	 */
+	if (!frame->fp)
+		return 0;
+
+	if (unwinder_is_unreliable(frame->pc))
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

