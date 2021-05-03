Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5F7371EBA
	for <lists+live-patching@lfdr.de>; Mon,  3 May 2021 19:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhECRhV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 May 2021 13:37:21 -0400
Received: from linux.microsoft.com ([13.77.154.182]:54536 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbhECRhU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 May 2021 13:37:20 -0400
Received: from x64host.home (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id 06AE520B800D;
        Mon,  3 May 2021 10:36:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 06AE520B800D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1620063386;
        bh=v2cyhZUNZcYe1H/VOKKxtcwZCxtIV7TELkPZ3X/Arwk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OoXki5imJ+8pNO4oOmUdP8FN9UipgdR+/oDvH64HF0NGvxuZJ06Ecd2HOx0bnt8sa
         gWjOTOJbur2XEx9clwqch3PG0bZ6F4msEG+lWIYBTPVCwSY3H5kYQYHsd7rkH0ZMeT
         7Ns09s+vfBByCEms+XXf88eARNbEk7iXuPp6GBxQ=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, jpoimboe@redhat.com, mark.rutland@arm.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 3/4] arm64: Handle miscellaneous functions in .text and .init.text
Date:   Mon,  3 May 2021 12:36:14 -0500
Message-Id: <20210503173615.21576-4-madvenka@linux.microsoft.com>
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

There are some SYM_CODE functions that are currently in ".text" or
".init.text" sections. Some of these are functions that the unwinder
does not care about as they are not "interesting" to livepatch. These
will remain in their current sections. The rest I have moved into a
new section called ".code.text".

Include .code.text in sym_code_ranges[] so the unwinder can check it.

I have listed the names of the functions along with the name of their
existing section.

Don't care functions
====================

	efi-entry.S:
		efi_enter_kernel		.init.text

	relocate_kernel.S:
		arm64_relocate_new_kernel	.text

	sigreturn.S:
		__kernel_rt_sigreturn		.text

	arch/arm64/kvm/hyp/hyp-entry.S:
		el2t_sync_invalid		.text
		el2t_irq_invalid		.text
		el2t_fiq_invalid		.text
		el2t_error_invalid		.text
		el2h_irq_invalid		.text
		el2h_fiq_invalid		.text
		el1_fiq_invalid			.text
		__kvm_hyp_vector		.text
		__bp_harden_hyp_vecs		.text

	arch/arm64/kvm/hyp/nvhe/host.S:
		__kvm_hyp_host_vector		.text
		__kvm_hyp_host_forward_smc	.text

Rest of the functions (moved to .code.text)
=====================

	entry.S:
		__swpan_entry_el1		.text
		__swpan_exit_el1		.text
		__swpan_entry_el0		.text
		__swpan_exit_el0		.text
		ret_from_fork			.text
		__sdei_asm_handler		.text

	head.S:
		primary_entry			.init.text
		preserve_boot_args		.init.text

	entry-ftrace.S:
		ftrace_regs_caller		.text
		ftrace_caller			.text
		ftrace_common			.text
		ftrace_graph_caller		.text
		return_to_handler		.text

	kprobes_trampoline.S:
		kretprobe_trampoline		.text

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/sections.h             | 1 +
 arch/arm64/kernel/entry-ftrace.S              | 5 +++++
 arch/arm64/kernel/entry.S                     | 6 ++++++
 arch/arm64/kernel/head.S                      | 3 ++-
 arch/arm64/kernel/probes/kprobes_trampoline.S | 2 ++
 arch/arm64/kernel/stacktrace.c                | 2 ++
 arch/arm64/kernel/vmlinux.lds.S               | 7 +++++++
 7 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 2f36b16a5b5d..bceda68aaa79 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -20,5 +20,6 @@ extern char __exittext_begin[], __exittext_end[];
 extern char __irqentry_text_start[], __irqentry_text_end[];
 extern char __mmuoff_data_start[], __mmuoff_data_end[];
 extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
+extern char __code_text_start[], __code_text_end[];
 
 #endif /* __ASM_SECTIONS_H */
diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
index b3e4f9a088b1..c0831a49c290 100644
--- a/arch/arm64/kernel/entry-ftrace.S
+++ b/arch/arm64/kernel/entry-ftrace.S
@@ -12,7 +12,9 @@
 #include <asm/ftrace.h>
 #include <asm/insn.h>
 
+	.text
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+	.pushsection ".code.text", "ax"
 /*
  * Due to -fpatchable-function-entry=2, the compiler has placed two NOPs before
  * the regular function prologue. For an enabled callsite, ftrace_init_nop() and
@@ -135,6 +137,7 @@ SYM_CODE_START(ftrace_graph_caller)
 	b	ftrace_common_return
 SYM_CODE_END(ftrace_graph_caller)
 #endif
+	.popsection
 
 #else /* CONFIG_DYNAMIC_FTRACE_WITH_REGS */
 
@@ -315,6 +318,7 @@ SYM_FUNC_START(ftrace_stub)
 SYM_FUNC_END(ftrace_stub)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	.pushsection ".code.text", "ax"
 /*
  * void return_to_handler(void)
  *
@@ -342,4 +346,5 @@ SYM_CODE_START(return_to_handler)
 
 	ret
 SYM_CODE_END(return_to_handler)
+	.popsection
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 6acfc5e6b5e0..3f9f7f80cd65 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -402,6 +402,7 @@ alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
 	.endm
 
 #ifdef CONFIG_ARM64_SW_TTBR0_PAN
+	.pushsection ".code.text", "ax"
 	/*
 	 * Set the TTBR0 PAN bit in SPSR. When the exception is taken from
 	 * EL0, there is no need to check the state of TTBR0_EL1 since
@@ -442,6 +443,7 @@ SYM_CODE_START_LOCAL(__swpan_exit_el0)
 	 */
 	b	post_ttbr_update_workaround
 SYM_CODE_END(__swpan_exit_el0)
+	.popsection
 #endif
 
 	.macro	irq_stack_entry
@@ -950,6 +952,7 @@ SYM_FUNC_START(cpu_switch_to)
 SYM_FUNC_END(cpu_switch_to)
 NOKPROBE(cpu_switch_to)
 
+	.pushsection ".code.text", "ax"
 /*
  * This is how we return from a fork.
  */
@@ -962,6 +965,7 @@ SYM_CODE_START(ret_from_fork)
 	b	ret_to_user
 SYM_CODE_END(ret_from_fork)
 NOKPROBE(ret_from_fork)
+	.popsection
 
 #ifdef CONFIG_ARM_SDE_INTERFACE
 
@@ -1040,6 +1044,7 @@ SYM_DATA_END(__sdei_asm_trampoline_next_handler)
 #endif /* CONFIG_RANDOMIZE_BASE */
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
 
+	.pushsection ".code.text", "ax"
 /*
  * Software Delegated Exception entry point.
  *
@@ -1150,4 +1155,5 @@ alternative_else_nop_endif
 #endif
 SYM_CODE_END(__sdei_asm_handler)
 NOKPROBE(__sdei_asm_handler)
+	.popsection
 #endif /* CONFIG_ARM_SDE_INTERFACE */
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 840bda1869e9..4ce96dfac2b8 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -75,7 +75,7 @@
 	__EFI_PE_HEADER
 
 	__INIT
-
+	.pushsection ".code.text", "ax"
 	/*
 	 * The following callee saved general purpose registers are used on the
 	 * primary lowlevel boot path:
@@ -120,6 +120,7 @@ SYM_CODE_START_LOCAL(preserve_boot_args)
 	mov	x1, #0x20			// 4 x 8 bytes
 	b	__inval_dcache_area		// tail call
 SYM_CODE_END(preserve_boot_args)
+	.popsection
 
 /*
  * Macro to create a table entry to the next page.
diff --git a/arch/arm64/kernel/probes/kprobes_trampoline.S b/arch/arm64/kernel/probes/kprobes_trampoline.S
index 288a84e253cc..9244e119af3e 100644
--- a/arch/arm64/kernel/probes/kprobes_trampoline.S
+++ b/arch/arm64/kernel/probes/kprobes_trampoline.S
@@ -8,6 +8,7 @@
 #include <asm/assembler.h>
 
 	.text
+	.pushsection ".code.text", "ax"
 
 	.macro	save_all_base_regs
 	stp x0, x1, [sp, #S_X0]
@@ -80,3 +81,4 @@ SYM_CODE_START(kretprobe_trampoline)
 	ret
 
 SYM_CODE_END(kretprobe_trampoline)
+	.popsection
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 1ff14615a55a..33e174160f9b 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -43,6 +43,8 @@ struct code_range	sym_code_ranges[] =
 	{ (unsigned long)__entry_tramp_text_start,
 	  (unsigned long)__entry_tramp_text_end },
 #endif
+	{ (unsigned long)__code_text_start,
+	  (unsigned long)__code_text_end },
 	{ /* sentinel */ }
 };
 
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 7eea7888bb02..c00b3232e6dc 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -103,6 +103,12 @@ jiffies = jiffies_64;
 #define TRAMP_TEXT
 #endif
 
+#define CODE_TEXT					\
+	. = ALIGN(SZ_4K);				\
+	__code_text_start = .;				\
+	*(.code.text)					\
+	__code_text_end = .;
+
 /*
  * The size of the PE/COFF section that covers the kernel image, which
  * runs from _stext to _edata, must be a round multiple of the PE/COFF
@@ -145,6 +151,7 @@ SECTIONS
 			SOFTIRQENTRY_TEXT
 			ENTRY_TEXT
 			TEXT_TEXT
+			CODE_TEXT
 			SCHED_TEXT
 			CPUIDLE_TEXT
 			LOCK_TEXT
-- 
2.25.1

