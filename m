Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B3654FF25
	for <lists+live-patching@lfdr.de>; Fri, 17 Jun 2022 23:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383640AbiFQVHn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jun 2022 17:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383555AbiFQVHa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jun 2022 17:07:30 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D74C5E15E;
        Fri, 17 Jun 2022 14:07:29 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 608BB20C34AD;
        Fri, 17 Jun 2022 14:07:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 608BB20C34AD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1655500049;
        bh=rIRHg9h9dL7P6AtbbpVArTGj3H2jde9z184QDNjMMj4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=XCeD0roxKYtNx0ScoExMX+gQ6GAr79i02sc7v5AkMtB/x4v6/NfqE5n0VFatXmgKl
         l+PEeOpnG8k7lbGKPGcYmHiMruV+1RPef7bivh7rn0sfYM0Yu8SA0So0kqtB68vtGJ
         86LOY+NcnNoUbtgRglKBGoC9pU5FitOenCsbFt6w=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v15 5/6] arm64: Create a list of SYM_CODE functions, check return PC against list
Date:   Fri, 17 Jun 2022 16:07:16 -0500
Message-Id: <20220617210717.27126-6-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220617210717.27126-1-madvenka@linux.microsoft.com>
References: <ff68fb850d42e1adaa6a0a6c9c258acabb898b24>
 <20220617210717.27126-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 arch/arm64/include/asm/linkage.h  | 11 +++++++
 arch/arm64/include/asm/sections.h |  1 +
 arch/arm64/kernel/stacktrace.c    | 55 +++++++++++++++++++++++++++++++
 arch/arm64/kernel/vmlinux.lds.S   | 10 ++++++
 4 files changed, 77 insertions(+)

diff --git a/arch/arm64/include/asm/linkage.h b/arch/arm64/include/asm/linkage.h
index 43f8c25b3fda..d4058de4af78 100644
--- a/arch/arm64/include/asm/linkage.h
+++ b/arch/arm64/include/asm/linkage.h
@@ -39,4 +39,15 @@
 	SYM_START(name, SYM_L_WEAK, SYM_A_NONE)		\
 	bti c ;
 
+/*
+ * Record the address range of each SYM_CODE function in a struct code_range
+ * in a special section.
+ */
+#define SYM_CODE_END(name)				\
+	SYM_END(name, SYM_T_NONE)			;\
+99:	.pushsection "sym_code_functions", "aw"		;\
+	.quad	name					;\
+	.quad	99b					;\
+	.popsection
+
 #endif
diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 40971ac1303f..50cfd1083563 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -22,6 +22,7 @@ extern char __irqentry_text_start[], __irqentry_text_end[];
 extern char __mmuoff_data_start[], __mmuoff_data_end[];
 extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
 extern char __relocate_new_kernel_start[], __relocate_new_kernel_end[];
+extern char __sym_code_functions_start[], __sym_code_functions_end[];
 
 static inline size_t entry_tramp_text_size(void)
 {
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 5ef2ce217324..eda8581f7dbe 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -62,6 +62,31 @@ struct unwind_state {
 	bool reliable;
 };
 
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
 static void unwind_init_common(struct unwind_state *state,
 			       struct task_struct *task)
 {
@@ -251,6 +276,10 @@ NOKPROBE_SYMBOL(unwind_next);
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
@@ -263,6 +292,32 @@ static void unwind_check_reliability(struct unwind_state *state)
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
 
 static bool notrace unwind(struct unwind_state *state,
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 2d4a8f995175..414dbc82d0a6 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -120,6 +120,14 @@ jiffies = jiffies_64;
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
@@ -212,6 +220,8 @@ SECTIONS
 	swapper_pg_dir = .;
 	. += PAGE_SIZE;
 
+	SYM_CODE_FUNCTIONS
+
 	. = ALIGN(SEGMENT_ALIGN);
 	__init_begin = .;
 	__inittext_begin = .;
-- 
2.25.1

