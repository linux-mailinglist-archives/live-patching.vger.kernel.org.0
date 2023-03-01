Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED0B6A6F18
	for <lists+live-patching@lfdr.de>; Wed,  1 Mar 2023 16:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjCAPOq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 Mar 2023 10:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjCAPOp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 Mar 2023 10:14:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FBE3D92E
        for <live-patching@vger.kernel.org>; Wed,  1 Mar 2023 07:14:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D071613C5
        for <live-patching@vger.kernel.org>; Wed,  1 Mar 2023 15:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5235C4339C;
        Wed,  1 Mar 2023 15:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677683679;
        bh=hQggb5ZZXNDV16jcODH662HABh4JpBPfxOUkCAZls0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P2Z31Vgc2/Tw5fsh5TsXtY72aQgVOOZ5DIIktb2Ba0MzNwSPf/Ijey6DHkPgmQQOS
         EC9nk3aK3sZoa6c6CrwyIcFtD/8z2DSu6s3w1XVtUkYe1kU/qFSvfhAQ1vea+eRilk
         Y27mO/TIDtBJiL/XXqY+77ur/p999YKwt50S7hwFmllLtV8nfGySu2Fhq4uKrevKvC
         C4uLximV+PthHjgc5cjFp4veErv+GUmfiKkMg4u+4Czgi7k2JKWRPymLHeRDDu53x9
         I47Qa+CCGXVjPR5TsRUGvLMr6tZst7zHZzIjJn2ouB8Q9pIFSbOWRcUQpa2PGJH14C
         7x90lqXiHbMdg==
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     x86@kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        live-patching@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6/6] x86,objtool: Split UNWIND_HINT_EMPTY in two
Date:   Wed,  1 Mar 2023 07:13:12 -0800
Message-Id: <fd6212c8b450d3564b855e1cb48404d6277b4d9f.1677683419.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677683419.git.jpoimboe@kernel.org>
References: <cover.1677683419.git.jpoimboe@kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Mark reported that the ORC unwinder incorrectly marks an unwind as
reliable when the unwind terminates prematurely in the dark corners of
return_to_handler() due to lack of information about the next frame.

The problem is UNWIND_HINT_EMPTY is used in two different situations:

  1) The end of the kernel stack unwind before hitting user entry, boot
     code, or fork entry

  2) A blind spot in ORC coverage where the unwinder has to bail due to
     lack of information about the next frame

The ORC unwinder has no way to tell the difference between the two.
When it encounters an undefined stack state with 'end=1', it blindly
marks the stack reliable, which can break the livepatch consistency
model.

Fix it by splitting UNWIND_HINT_EMPTY into UNWIND_HINT_UNDEFINED and
UNWIND_HINT_END_OF_STACK.

Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 .../livepatch/reliable-stacktrace.rst         |  2 +-
 arch/x86/entry/entry_64.S                     | 12 ++++-----
 arch/x86/include/asm/orc_types.h              | 14 +++++-----
 arch/x86/include/asm/unwind_hints.h           | 12 ++++++---
 arch/x86/kernel/ftrace_64.S                   |  2 +-
 arch/x86/kernel/head_64.S                     | 12 ++++-----
 arch/x86/kernel/relocate_kernel_64.S          | 10 +++----
 arch/x86/kernel/unwind_orc.c                  | 15 +++++------
 arch/x86/lib/retpoline.S                      |  6 ++---
 arch/x86/platform/pvh/head.S                  |  2 +-
 arch/x86/xen/xen-asm.S                        |  4 +--
 arch/x86/xen/xen-head.S                       |  4 +--
 include/linux/objtool.h                       | 10 +++----
 include/linux/objtool_types.h                 | 27 ++++++++++++-------
 scripts/sorttable.h                           |  2 +-
 tools/arch/x86/include/asm/orc_types.h        | 14 +++++-----
 tools/include/linux/objtool_types.h           | 27 ++++++++++++-------
 tools/objtool/check.c                         |  2 +-
 tools/objtool/orc_dump.c                      |  8 ++++--
 tools/objtool/orc_gen.c                       | 26 +++++++++---------
 20 files changed, 116 insertions(+), 95 deletions(-)

diff --git a/Documentation/livepatch/reliable-stacktrace.rst b/Documentation/livepatch/reliable-stacktrace.rst
index 67459d2ca2af..d56bb706172f 100644
--- a/Documentation/livepatch/reliable-stacktrace.rst
+++ b/Documentation/livepatch/reliable-stacktrace.rst
@@ -183,7 +183,7 @@ trampoline or return trampoline. For example, considering the x86_64
 .. code-block:: none
 
    SYM_CODE_START(return_to_handler)
-           UNWIND_HINT_EMPTY
+           UNWIND_HINT_UNDEFINED
            subq  $24, %rsp
 
            /* Save the return values */
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 5b93eb7db0ab..45e135be2a9f 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -205,7 +205,7 @@ syscall_return_via_sysret:
 	 */
 	movq	%rsp, %rdi
 	movq	PER_CPU_VAR(cpu_tss_rw + TSS_sp0), %rsp
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_END_OF_STACK
 
 	pushq	RSP-RDI(%rdi)	/* RSP */
 	pushq	(%rdi)		/* RDI */
@@ -286,7 +286,7 @@ SYM_FUNC_END(__switch_to_asm)
 .pushsection .text, "ax"
 	__FUNC_ALIGN
 SYM_CODE_START_NOALIGN(ret_from_fork)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_END_OF_STACK
 	ANNOTATE_NOENDBR // copy_thread
 	CALL_DEPTH_ACCOUNT
 	movq	%rax, %rdi
@@ -303,7 +303,7 @@ SYM_CODE_START_NOALIGN(ret_from_fork)
 
 1:
 	/* kernel thread */
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_END_OF_STACK
 	movq	%r12, %rdi
 	CALL_NOSPEC rbx
 	/*
@@ -643,7 +643,7 @@ SYM_INNER_LABEL(swapgs_restore_regs_and_return_to_usermode, SYM_L_GLOBAL)
 	 */
 	movq	%rsp, %rdi
 	movq	PER_CPU_VAR(cpu_tss_rw + TSS_sp0), %rsp
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_END_OF_STACK
 
 	/* Copy the IRET frame to the trampoline stack. */
 	pushq	6*8(%rdi)	/* SS */
@@ -869,7 +869,7 @@ SYM_CODE_END(exc_xen_hypervisor_callback)
  */
 	__FUNC_ALIGN
 SYM_CODE_START_NOALIGN(xen_failsafe_callback)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_UNDEFINED
 	ENDBR
 	movl	%ds, %ecx
 	cmpw	%cx, 0x10(%rsp)
@@ -1520,7 +1520,7 @@ SYM_CODE_END(asm_exc_nmi)
  * MSRs to fully disable 32-bit SYSCALL.
  */
 SYM_CODE_START(ignore_sysret)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_END_OF_STACK
 	ENDBR
 	mov	$-ENOSYS, %eax
 	sysretl
diff --git a/arch/x86/include/asm/orc_types.h b/arch/x86/include/asm/orc_types.h
index b4d4ec78589e..46d7e06763c9 100644
--- a/arch/x86/include/asm/orc_types.h
+++ b/arch/x86/include/asm/orc_types.h
@@ -39,9 +39,11 @@
 #define ORC_REG_SP_INDIRECT		9
 #define ORC_REG_MAX			15
 
-#define ORC_TYPE_CALL			0
-#define ORC_TYPE_REGS			1
-#define ORC_TYPE_REGS_PARTIAL		2
+#define ORC_TYPE_UNDEFINED		0
+#define ORC_TYPE_END_OF_STACK		1
+#define ORC_TYPE_CALL			2
+#define ORC_TYPE_REGS			3
+#define ORC_TYPE_REGS_PARTIAL		4
 
 #ifndef __ASSEMBLY__
 #include <asm/byteorder.h>
@@ -60,16 +62,14 @@ struct orc_entry {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
 	unsigned	sp_reg:4;
 	unsigned	bp_reg:4;
-	unsigned	type:2;
+	unsigned	type:3;
 	unsigned	signal:1;
-	unsigned	end:1;
 #elif defined(__BIG_ENDIAN_BITFIELD)
 	unsigned	bp_reg:4;
 	unsigned	sp_reg:4;
 	unsigned	unused:4;
-	unsigned	end:1;
 	unsigned	signal:1;
-	unsigned	type:2;
+	unsigned	type:3;
 #endif
 } __packed;
 
diff --git a/arch/x86/include/asm/unwind_hints.h b/arch/x86/include/asm/unwind_hints.h
index 4c0f28d665eb..01cb9692b160 100644
--- a/arch/x86/include/asm/unwind_hints.h
+++ b/arch/x86/include/asm/unwind_hints.h
@@ -7,13 +7,17 @@
 
 #ifdef __ASSEMBLY__
 
-.macro UNWIND_HINT_EMPTY
-	UNWIND_HINT type=UNWIND_HINT_TYPE_CALL end=1
+.macro UNWIND_HINT_END_OF_STACK
+	UNWIND_HINT type=UNWIND_HINT_TYPE_END_OF_STACK
+.endm
+
+.macro UNWIND_HINT_UNDEFINED
+	UNWIND_HINT type=UNWIND_HINT_TYPE_UNDEFINED
 .endm
 
 .macro UNWIND_HINT_ENTRY
 	VALIDATE_UNRET_BEGIN
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_END_OF_STACK
 .endm
 
 .macro UNWIND_HINT_REGS base=%rsp offset=0 indirect=0 extra=1 partial=0 signal=1
@@ -73,7 +77,7 @@
 #else
 
 #define UNWIND_HINT_FUNC \
-	UNWIND_HINT(UNWIND_HINT_TYPE_FUNC, ORC_REG_SP, 8, 0, 0)
+	UNWIND_HINT(UNWIND_HINT_TYPE_FUNC, ORC_REG_SP, 8, 0)
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
index 1265ad519249..0387732e9c3f 100644
--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -340,7 +340,7 @@ STACK_FRAME_NON_STANDARD_FP(__fentry__)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 SYM_CODE_START(return_to_handler)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_UNDEFINED
 	ANNOTATE_NOENDBR
 	subq  $16, %rsp
 
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index ee3ed15ee1f8..8d8d25c64827 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -42,7 +42,7 @@ L3_START_KERNEL = pud_index(__START_KERNEL_map)
 	__HEAD
 	.code64
 SYM_CODE_START_NOALIGN(startup_64)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_END_OF_STACK
 	/*
 	 * At this point the CPU runs in 64bit mode CS.L = 1 CS.D = 0,
 	 * and someone has loaded an identity mapped page table
@@ -105,7 +105,7 @@ SYM_CODE_START_NOALIGN(startup_64)
 	lretq
 
 .Lon_kernel_cs:
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_END_OF_STACK
 
 	/* Sanitize CPU configuration */
 	call verify_cpu
@@ -127,7 +127,7 @@ SYM_CODE_START_NOALIGN(startup_64)
 SYM_CODE_END(startup_64)
 
 SYM_CODE_START(secondary_startup_64)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_END_OF_STACK
 	ANNOTATE_NOENDBR
 	/*
 	 * At this point the CPU runs in 64bit mode CS.L = 1 CS.D = 0,
@@ -156,7 +156,7 @@ SYM_CODE_START(secondary_startup_64)
 	 * verify_cpu() above to make sure NX is enabled.
 	 */
 SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_END_OF_STACK
 	ANNOTATE_NOENDBR
 
 	/*
@@ -238,7 +238,7 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	ANNOTATE_RETPOLINE_SAFE
 	jmp	*%rax
 1:
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_END_OF_STACK
 	ANNOTATE_NOENDBR // above
 
 	/*
@@ -371,7 +371,7 @@ SYM_CODE_END(secondary_startup_64)
  */
 SYM_CODE_START(start_cpu0)
 	ANNOTATE_NOENDBR
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_END_OF_STACK
 	movq	initial_stack(%rip), %rsp
 	jmp	.Ljump_to_C_code
 SYM_CODE_END(start_cpu0)
diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
index 4a73351f87f8..56cab1bb25f5 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -43,7 +43,7 @@
 	.code64
 SYM_CODE_START_NOALIGN(relocate_range)
 SYM_CODE_START_NOALIGN(relocate_kernel)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_END_OF_STACK
 	ANNOTATE_NOENDBR
 	/*
 	 * %rdi indirection_page
@@ -113,7 +113,7 @@ SYM_CODE_START_NOALIGN(relocate_kernel)
 SYM_CODE_END(relocate_kernel)
 
 SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_END_OF_STACK
 	/* set return address to 0 if not preserving context */
 	pushq	$0
 	/* store the start address on the stack */
@@ -231,7 +231,7 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
 SYM_CODE_END(identity_mapped)
 
 SYM_CODE_START_LOCAL_NOALIGN(virtual_mapped)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_END_OF_STACK
 	ANNOTATE_NOENDBR // RET target, above
 	movq	RSP(%r8), %rsp
 	movq	CR4(%r8), %rax
@@ -256,8 +256,8 @@ SYM_CODE_END(virtual_mapped)
 
 	/* Do the copies */
 SYM_CODE_START_LOCAL_NOALIGN(swap_pages)
-	UNWIND_HINT_EMPTY
-	movq	%rdi, %rcx 	/* Put the page_list in %rcx */
+	UNWIND_HINT_END_OF_STACK
+	movq	%rdi, %rcx	/* Put the page_list in %rcx */
 	xorl	%edi, %edi
 	xorl	%esi, %esi
 	jmp	1f
diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 8348ac581de3..3ac50b7298d1 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -158,7 +158,6 @@ static struct orc_entry orc_fp_entry = {
 	.sp_offset	= 16,
 	.bp_reg		= ORC_REG_PREV_SP,
 	.bp_offset	= -16,
-	.end		= 0,
 };
 
 static struct orc_entry *orc_find(unsigned long ip)
@@ -250,13 +249,13 @@ static int orc_sort_cmp(const void *_a, const void *_b)
 		return -1;
 
 	/*
-	 * The "weak" section terminator entries need to always be on the left
+	 * The "weak" section terminator entries need to always be first
 	 * to ensure the lookup code skips them in favor of real entries.
 	 * These terminator entries exist to handle any gaps created by
 	 * whitelisted .o files which didn't get objtool generation.
 	 */
 	orc_a = cur_orc_table + (a - cur_orc_ip_table);
-	return orc_a->sp_reg == ORC_REG_UNDEFINED && !orc_a->end ? -1 : 1;
+	return orc_a->type == ORC_TYPE_UNDEFINED ? -1 : 1;
 }
 
 void unwind_module_init(struct module *mod, void *_orc_ip, size_t orc_ip_size,
@@ -474,14 +473,12 @@ bool unwind_next_frame(struct unwind_state *state)
 		 */
 		orc = &orc_fp_entry;
 		state->error = true;
-	}
-
-	/* End-of-stack check for kernel threads: */
-	if (orc->sp_reg == ORC_REG_UNDEFINED) {
-		if (!orc->end)
+	} else {
+		if (orc->type == ORC_TYPE_UNDEFINED)
 			goto err;
 
-		goto the_end;
+		if (orc->type == ORC_TYPE_END_OF_STACK)
+			goto the_end;
 	}
 
 	state->signal = orc->signal;
diff --git a/arch/x86/lib/retpoline.S b/arch/x86/lib/retpoline.S
index 5f61c65322be..27ef53fab6bd 100644
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -33,7 +33,7 @@
 
 	.align RETPOLINE_THUNK_SIZE
 SYM_INNER_LABEL(__x86_indirect_thunk_\reg, SYM_L_GLOBAL)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_UNDEFINED
 	ANNOTATE_NOENDBR
 
 	ALTERNATIVE_2 __stringify(RETPOLINE \reg), \
@@ -75,7 +75,7 @@ SYM_CODE_END(__x86_indirect_thunk_array)
 	.align RETPOLINE_THUNK_SIZE
 
 SYM_INNER_LABEL(__x86_indirect_call_thunk_\reg, SYM_L_GLOBAL)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_UNDEFINED
 	ANNOTATE_NOENDBR
 
 	CALL_DEPTH_ACCOUNT
@@ -103,7 +103,7 @@ SYM_CODE_END(__x86_indirect_call_thunk_array)
 	.align RETPOLINE_THUNK_SIZE
 
 SYM_INNER_LABEL(__x86_indirect_jump_thunk_\reg, SYM_L_GLOBAL)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_UNDEFINED
 	ANNOTATE_NOENDBR
 	POLINE \reg
 	ANNOTATE_UNRET_SAFE
diff --git a/arch/x86/platform/pvh/head.S b/arch/x86/platform/pvh/head.S
index 7fe564eaf228..c4365a05ab83 100644
--- a/arch/x86/platform/pvh/head.S
+++ b/arch/x86/platform/pvh/head.S
@@ -50,7 +50,7 @@
 #define PVH_DS_SEL		(PVH_GDT_ENTRY_DS * 8)
 
 SYM_CODE_START_LOCAL(pvh_start_xen)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_END_OF_STACK
 	cld
 
 	lgdt (_pa(gdt))
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index 4a184f6e4e4d..08f1ceb9eb81 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -165,7 +165,7 @@ xen_pv_trap asm_exc_xen_hypervisor_callback
 SYM_CODE_START(xen_early_idt_handler_array)
 	i = 0
 	.rept NUM_EXCEPTION_VECTORS
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_UNDEFINED
 	ENDBR
 	pop %rcx
 	pop %r11
@@ -193,7 +193,7 @@ hypercall_iret = hypercall_page + __HYPERVISOR_iret * 32
  * rsp->rax		}
  */
 SYM_CODE_START(xen_iret)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_UNDEFINED
 	ANNOTATE_NOENDBR
 	pushq $0
 	jmp hypercall_iret
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index e36ea4268bd2..6eafdd17c242 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -45,7 +45,7 @@ SYM_CODE_END(hypercall_page)
 #ifdef CONFIG_XEN_PV
 	__INIT
 SYM_CODE_START(startup_xen)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_END_OF_STACK
 	ANNOTATE_NOENDBR
 	cld
 
@@ -71,7 +71,7 @@ SYM_CODE_END(startup_xen)
 #ifdef CONFIG_XEN_PV_SMP
 .pushsection .text
 SYM_CODE_START(asm_cpu_bringup_and_idle)
-	UNWIND_HINT_EMPTY
+	UNWIND_HINT_END_OF_STACK
 	ENDBR
 
 	call cpu_bringup_and_idle
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index 5aa475118820..03f82c2c2ebf 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -10,7 +10,7 @@
 
 #ifndef __ASSEMBLY__
 
-#define UNWIND_HINT(type, sp_reg, sp_offset, signal, end)	\
+#define UNWIND_HINT(type, sp_reg, sp_offset, signal)	\
 	"987: \n\t"						\
 	".pushsection .discard.unwind_hints\n\t"		\
 	/* struct unwind_hint */				\
@@ -19,7 +19,6 @@
 	".byte " __stringify(sp_reg) "\n\t"			\
 	".byte " __stringify(type) "\n\t"			\
 	".byte " __stringify(signal) "\n\t"			\
-	".byte " __stringify(end) "\n\t"			\
 	".balign 4 \n\t"					\
 	".popsection\n\t"
 
@@ -91,7 +90,7 @@
  * the debuginfo as necessary.  It will also warn if it sees any
  * inconsistencies.
  */
-.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0 end=0
+.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0
 .Lhere_\@:
 	.pushsection .discard.unwind_hints
 		/* struct unwind_hint */
@@ -100,7 +99,6 @@
 		.byte \sp_reg
 		.byte \type
 		.byte \signal
-		.byte \end
 		.balign 4
 	.popsection
 .endm
@@ -153,14 +151,14 @@
 
 #ifndef __ASSEMBLY__
 
-#define UNWIND_HINT(type, sp_reg, sp_offset, signal, end) "\n\t"
+#define UNWIND_HINT(type, sp_reg, sp_offset, signal) "\n\t"
 #define STACK_FRAME_NON_STANDARD(func)
 #define STACK_FRAME_NON_STANDARD_FP(func)
 #define ANNOTATE_NOENDBR
 #define ASM_REACHABLE
 #else
 #define ANNOTATE_INTRA_FUNCTION_CALL
-.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0 end=0
+.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0
 .endm
 .macro STACK_FRAME_NON_STANDARD func:req
 .endm
diff --git a/include/linux/objtool_types.h b/include/linux/objtool_types.h
index 9787ad0f2ef4..453a4f4ef39d 100644
--- a/include/linux/objtool_types.h
+++ b/include/linux/objtool_types.h
@@ -16,12 +16,18 @@ struct unwind_hint {
 	u8		sp_reg;
 	u8		type;
 	u8		signal;
-	u8		end;
 };
 
 #endif /* __ASSEMBLY__ */
 
 /*
+ * UNWIND_HINT_TYPE_UNDEFINED: A blind spot in ORC coverage which can result in
+ * a truncated and unreliable stack unwind.
+ *
+ * UNWIND_HINT_TYPE_END_OF_STACK: The end of the kernel stack unwind before
+ * hitting user entry, boot code, or fork entry (when there are no pt_regs
+ * available).
+ *
  * UNWIND_HINT_TYPE_CALL: Indicates that sp_reg+sp_offset resolves to PREV_SP
  * (the caller's SP right before it made the call).  Used for all callable
  * functions, i.e. all C code and all callable asm functions.
@@ -32,17 +38,20 @@ struct unwind_hint {
  * UNWIND_HINT_TYPE_REGS_PARTIAL: Used in entry code to indicate that
  * sp_reg+sp_offset points to the iret return frame.
  *
- * UNWIND_HINT_FUNC: Generate the unwind metadata of a callable function.
+ * UNWIND_HINT_TYPE_FUNC: Generate the unwind metadata of a callable function.
  * Useful for code which doesn't have an ELF function annotation.
  *
- * UNWIND_HINT_ENTRY: machine entry without stack, SYSCALL/SYSENTER etc.
+ * UNWIND_HINT_TYPE_{SAVE,RESTORE}: Save the unwind metadata at a certain
+ * location so that it can be restored later.
  */
-#define UNWIND_HINT_TYPE_CALL		0
-#define UNWIND_HINT_TYPE_REGS		1
-#define UNWIND_HINT_TYPE_REGS_PARTIAL	2
+#define UNWIND_HINT_TYPE_UNDEFINED	0
+#define UNWIND_HINT_TYPE_END_OF_STACK	1
+#define UNWIND_HINT_TYPE_CALL		2
+#define UNWIND_HINT_TYPE_REGS		3
+#define UNWIND_HINT_TYPE_REGS_PARTIAL	4
 /* The below hint types don't have corresponding ORC types */
-#define UNWIND_HINT_TYPE_FUNC		3
-#define UNWIND_HINT_TYPE_SAVE		4
-#define UNWIND_HINT_TYPE_RESTORE	5
+#define UNWIND_HINT_TYPE_FUNC		5
+#define UNWIND_HINT_TYPE_SAVE		6
+#define UNWIND_HINT_TYPE_RESTORE	7
 
 #endif /* _LINUX_OBJTOOL_TYPES_H */
diff --git a/scripts/sorttable.h b/scripts/sorttable.h
index deb7c1d3e979..7bd0184380d3 100644
--- a/scripts/sorttable.h
+++ b/scripts/sorttable.h
@@ -128,7 +128,7 @@ static int orc_sort_cmp(const void *_a, const void *_b)
 	 * whitelisted .o files which didn't get objtool generation.
 	 */
 	orc_a = g_orc_table + (a - g_orc_ip_table);
-	return orc_a->sp_reg == ORC_REG_UNDEFINED && !orc_a->end ? -1 : 1;
+	return orc_a->type == ORC_TYPE_UNDEFINED ? -1 : 1;
 }
 
 static void *sort_orctable(void *arg)
diff --git a/tools/arch/x86/include/asm/orc_types.h b/tools/arch/x86/include/asm/orc_types.h
index b4d4ec78589e..46d7e06763c9 100644
--- a/tools/arch/x86/include/asm/orc_types.h
+++ b/tools/arch/x86/include/asm/orc_types.h
@@ -39,9 +39,11 @@
 #define ORC_REG_SP_INDIRECT		9
 #define ORC_REG_MAX			15
 
-#define ORC_TYPE_CALL			0
-#define ORC_TYPE_REGS			1
-#define ORC_TYPE_REGS_PARTIAL		2
+#define ORC_TYPE_UNDEFINED		0
+#define ORC_TYPE_END_OF_STACK		1
+#define ORC_TYPE_CALL			2
+#define ORC_TYPE_REGS			3
+#define ORC_TYPE_REGS_PARTIAL		4
 
 #ifndef __ASSEMBLY__
 #include <asm/byteorder.h>
@@ -60,16 +62,14 @@ struct orc_entry {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
 	unsigned	sp_reg:4;
 	unsigned	bp_reg:4;
-	unsigned	type:2;
+	unsigned	type:3;
 	unsigned	signal:1;
-	unsigned	end:1;
 #elif defined(__BIG_ENDIAN_BITFIELD)
 	unsigned	bp_reg:4;
 	unsigned	sp_reg:4;
 	unsigned	unused:4;
-	unsigned	end:1;
 	unsigned	signal:1;
-	unsigned	type:2;
+	unsigned	type:3;
 #endif
 } __packed;
 
diff --git a/tools/include/linux/objtool_types.h b/tools/include/linux/objtool_types.h
index 9787ad0f2ef4..453a4f4ef39d 100644
--- a/tools/include/linux/objtool_types.h
+++ b/tools/include/linux/objtool_types.h
@@ -16,12 +16,18 @@ struct unwind_hint {
 	u8		sp_reg;
 	u8		type;
 	u8		signal;
-	u8		end;
 };
 
 #endif /* __ASSEMBLY__ */
 
 /*
+ * UNWIND_HINT_TYPE_UNDEFINED: A blind spot in ORC coverage which can result in
+ * a truncated and unreliable stack unwind.
+ *
+ * UNWIND_HINT_TYPE_END_OF_STACK: The end of the kernel stack unwind before
+ * hitting user entry, boot code, or fork entry (when there are no pt_regs
+ * available).
+ *
  * UNWIND_HINT_TYPE_CALL: Indicates that sp_reg+sp_offset resolves to PREV_SP
  * (the caller's SP right before it made the call).  Used for all callable
  * functions, i.e. all C code and all callable asm functions.
@@ -32,17 +38,20 @@ struct unwind_hint {
  * UNWIND_HINT_TYPE_REGS_PARTIAL: Used in entry code to indicate that
  * sp_reg+sp_offset points to the iret return frame.
  *
- * UNWIND_HINT_FUNC: Generate the unwind metadata of a callable function.
+ * UNWIND_HINT_TYPE_FUNC: Generate the unwind metadata of a callable function.
  * Useful for code which doesn't have an ELF function annotation.
  *
- * UNWIND_HINT_ENTRY: machine entry without stack, SYSCALL/SYSENTER etc.
+ * UNWIND_HINT_TYPE_{SAVE,RESTORE}: Save the unwind metadata at a certain
+ * location so that it can be restored later.
  */
-#define UNWIND_HINT_TYPE_CALL		0
-#define UNWIND_HINT_TYPE_REGS		1
-#define UNWIND_HINT_TYPE_REGS_PARTIAL	2
+#define UNWIND_HINT_TYPE_UNDEFINED	0
+#define UNWIND_HINT_TYPE_END_OF_STACK	1
+#define UNWIND_HINT_TYPE_CALL		2
+#define UNWIND_HINT_TYPE_REGS		3
+#define UNWIND_HINT_TYPE_REGS_PARTIAL	4
 /* The below hint types don't have corresponding ORC types */
-#define UNWIND_HINT_TYPE_FUNC		3
-#define UNWIND_HINT_TYPE_SAVE		4
-#define UNWIND_HINT_TYPE_RESTORE	5
+#define UNWIND_HINT_TYPE_FUNC		5
+#define UNWIND_HINT_TYPE_SAVE		6
+#define UNWIND_HINT_TYPE_RESTORE	7
 
 #endif /* _LINUX_OBJTOOL_TYPES_H */
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 226c2db3df89..d04711d4b2cd 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2240,6 +2240,7 @@ static void set_func_state(struct cfi_state *state)
 	memcpy(&state->regs, &initial_func_cfi.regs,
 	       CFI_NUM_REGS * sizeof(struct cfi_reg));
 	state->stack_size = initial_func_cfi.cfa.offset;
+	state->type = UNWIND_HINT_TYPE_CALL;
 }
 
 static int read_unwind_hints(struct objtool_file *file)
@@ -2324,7 +2325,6 @@ static int read_unwind_hints(struct objtool_file *file)
 		cfi.cfa.offset = bswap_if_needed(file->elf, hint->sp_offset);
 		cfi.type = hint->type;
 		cfi.signal = hint->signal;
-		cfi.end = hint->end;
 
 		insn->cfi = cfi_hash_find_or_add(&cfi);
 	}
diff --git a/tools/objtool/orc_dump.c b/tools/objtool/orc_dump.c
index 97ecbb8b9034..0e183bb1c720 100644
--- a/tools/objtool/orc_dump.c
+++ b/tools/objtool/orc_dump.c
@@ -38,6 +38,10 @@ static const char *reg_name(unsigned int reg)
 static const char *orc_type_name(unsigned int type)
 {
 	switch (type) {
+	case ORC_TYPE_UNDEFINED:
+		return "(und)";
+	case ORC_TYPE_END_OF_STACK:
+		return "end";
 	case ORC_TYPE_CALL:
 		return "call";
 	case ORC_TYPE_REGS:
@@ -201,6 +205,7 @@ int orc_dump(const char *_objname)
 			printf("%llx:", (unsigned long long)(orc_ip_addr + (i * sizeof(int)) + orc_ip[i]));
 		}
 
+		printf("type:%s", orc_type_name(orc[i].type));
 
 		printf(" sp:");
 
@@ -210,8 +215,7 @@ int orc_dump(const char *_objname)
 
 		print_reg(orc[i].bp_reg, bswap_if_needed(&dummy_elf, orc[i].bp_offset));
 
-		printf(" type:%s signal:%d end:%d\n",
-		       orc_type_name(orc[i].type), orc[i].signal, orc[i].end);
+		printf(" signal:%d\n", orc[i].signal);
 	}
 
 	elf_end(elf);
diff --git a/tools/objtool/orc_gen.c b/tools/objtool/orc_gen.c
index e85bbb996f6c..b327f9ccfe73 100644
--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
@@ -21,12 +21,22 @@ static int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi,
 	memset(orc, 0, sizeof(*orc));
 
 	if (!cfi) {
-		orc->end = 0;
-		orc->sp_reg = ORC_REG_UNDEFINED;
+		/*
+		 * This is usually either unreachable nops/traps (which don't
+		 * trigger unreachable instruction warnings), or
+		 * STACK_FRAME_NON_STANDARD functions.
+		 */
+		orc->type = ORC_TYPE_UNDEFINED;
 		return 0;
 	}
 
 	switch (cfi->type) {
+	case UNWIND_HINT_TYPE_UNDEFINED:
+		orc->type = ORC_TYPE_UNDEFINED;
+		return 0;
+	case UNWIND_HINT_TYPE_END_OF_STACK:
+		orc->type = ORC_TYPE_END_OF_STACK;
+		return 0;
 	case UNWIND_HINT_TYPE_CALL:
 		orc->type = ORC_TYPE_CALL;
 		break;
@@ -42,14 +52,8 @@ static int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi,
 		return -1;
 	}
 
-	orc->end = cfi->end;
 	orc->signal = cfi->signal;
 
-	if (cfi->cfa.base == CFI_UNDEFINED) {
-		orc->sp_reg = ORC_REG_UNDEFINED;
-		return 0;
-	}
-
 	switch (cfi->cfa.base) {
 	case CFI_SP:
 		orc->sp_reg = ORC_REG_SP;
@@ -163,11 +167,7 @@ int orc_create(struct objtool_file *file)
 	struct orc_list_entry *entry;
 	struct list_head orc_list;
 
-	struct orc_entry null = {
-		.sp_reg  = ORC_REG_UNDEFINED,
-		.bp_reg  = ORC_REG_UNDEFINED,
-		.type    = ORC_TYPE_CALL,
-	};
+	struct orc_entry null = { .type = ORC_TYPE_UNDEFINED };
 
 	/* Build a deduplicated list of ORC entries: */
 	INIT_LIST_HEAD(&orc_list);
-- 
2.39.1

