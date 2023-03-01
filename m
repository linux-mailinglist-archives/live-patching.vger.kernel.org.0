Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBA96A6F1D
	for <lists+live-patching@lfdr.de>; Wed,  1 Mar 2023 16:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbjCAPOv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 Mar 2023 10:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjCAPOu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 Mar 2023 10:14:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AA943468
        for <live-patching@vger.kernel.org>; Wed,  1 Mar 2023 07:14:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 005EBB81085
        for <live-patching@vger.kernel.org>; Wed,  1 Mar 2023 15:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66843C433D2;
        Wed,  1 Mar 2023 15:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677683678;
        bh=BVq4nDjmEjGilJtgco8pKwnjnvmwtvQWRmU3WOpe31g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cwtqepf/plWQHtEgPmrKRDI5uNt417J3gkQWxRM/Qtg71lviBjCBd3G31B9F+BRw0
         jaZ6V6ISr4JwT8ggx6/kAwLissCyG28pIsy5WzowZpxYfpDFTrxy5heZw6pbBnnsRH
         BO33/DtfohMv2OC7Wlw8OVhPvjZz2ZuwJ8K980n/1I3PFhDuLKZrXOQXuteDshhkhs
         87yEFWbDvdjm5xvgvyPKqkZyhYMaA8isk+vuDBlIpHbgQh0lqGCQTvH0uU/zSd3u5j
         Dv7wVT9Lz8jQ19RDDS/tT3kC+9uyozEZKuCCkaMXB7FRtDflYWU5A1uyREp5Nmv4YQ
         zKmviydqPxICw==
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     x86@kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        live-patching@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5/6] x86,objtool: Separate unret validation from unwind hints
Date:   Wed,  1 Mar 2023 07:13:11 -0800
Message-Id: <ff7448d492ea21b86d8a90264b105fbd0d751077.1677683419.git.jpoimboe@kernel.org>
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

The ENTRY unwind hint type is serving double duty as both an empty
unwind hint and an unret validation annotation.

Unret validation is unrelated to unwinding. Separate it out into its own
annotation.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/entry/entry_64.S             | 14 +++---
 arch/x86/include/asm/nospec-branch.h  |  8 ++--
 arch/x86/include/asm/unwind_hints.h   |  8 +++-
 arch/x86/kernel/head_64.S             |  5 ---
 include/linux/objtool.h               | 16 +++++++
 include/linux/objtool_types.h         |  5 +--
 tools/include/linux/objtool_types.h   |  5 +--
 tools/objtool/check.c                 | 65 ++++++++++++++++++---------
 tools/objtool/include/objtool/check.h |  4 +-
 9 files changed, 85 insertions(+), 45 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index eccc3431e515..5b93eb7db0ab 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -388,9 +388,9 @@ SYM_CODE_START(\asmsym)
 
 	.if \vector == X86_TRAP_BP
 		/* #BP advances %rip to the next instruction */
-		UNWIND_HINT_IRET_REGS offset=\has_error_code*8 signal=0
+		UNWIND_HINT_IRET_ENTRY offset=\has_error_code*8 signal=0
 	.else
-		UNWIND_HINT_IRET_REGS offset=\has_error_code*8
+		UNWIND_HINT_IRET_ENTRY offset=\has_error_code*8
 	.endif
 
 	ENDBR
@@ -461,7 +461,7 @@ SYM_CODE_END(\asmsym)
  */
 .macro idtentry_mce_db vector asmsym cfunc
 SYM_CODE_START(\asmsym)
-	UNWIND_HINT_IRET_REGS
+	UNWIND_HINT_IRET_ENTRY
 	ENDBR
 	ASM_CLAC
 	cld
@@ -518,7 +518,7 @@ SYM_CODE_END(\asmsym)
  */
 .macro idtentry_vc vector asmsym cfunc
 SYM_CODE_START(\asmsym)
-	UNWIND_HINT_IRET_REGS
+	UNWIND_HINT_IRET_ENTRY
 	ENDBR
 	ASM_CLAC
 	cld
@@ -582,7 +582,7 @@ SYM_CODE_END(\asmsym)
  */
 .macro idtentry_df vector asmsym cfunc
 SYM_CODE_START(\asmsym)
-	UNWIND_HINT_IRET_REGS offset=8
+	UNWIND_HINT_IRET_ENTRY offset=8
 	ENDBR
 	ASM_CLAC
 	cld
@@ -1107,7 +1107,7 @@ SYM_CODE_START(error_entry)
 	FENCE_SWAPGS_KERNEL_ENTRY
 	CALL_DEPTH_ACCOUNT
 	leaq	8(%rsp), %rax			/* return pt_regs pointer */
-	ANNOTATE_UNRET_END
+	VALIDATE_UNRET_END
 	RET
 
 .Lbstep_iret:
@@ -1153,7 +1153,7 @@ SYM_CODE_END(error_return)
  *	      when PAGE_TABLE_ISOLATION is in use.  Do not clobber.
  */
 SYM_CODE_START(asm_exc_nmi)
-	UNWIND_HINT_IRET_REGS
+	UNWIND_HINT_IRET_ENTRY
 	ENDBR
 
 	/*
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 78ed1546b775..edb2b0cb8efe 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -210,8 +210,8 @@
  * Abuse ANNOTATE_RETPOLINE_SAFE on a NOP to indicate UNRET_END, should
  * eventually turn into it's own annotation.
  */
-.macro ANNOTATE_UNRET_END
-#ifdef CONFIG_DEBUG_ENTRY
+.macro VALIDATE_UNRET_END
+#if defined(CONFIG_NOINSTR_VALIDATION) && defined(CONFIG_CPU_UNRET_ENTRY)
 	ANNOTATE_RETPOLINE_SAFE
 	nop
 #endif
@@ -286,7 +286,7 @@
 .macro UNTRAIN_RET
 #if defined(CONFIG_CPU_UNRET_ENTRY) || defined(CONFIG_CPU_IBPB_ENTRY) || \
 	defined(CONFIG_CALL_DEPTH_TRACKING)
-	ANNOTATE_UNRET_END
+	VALIDATE_UNRET_END
 	ALTERNATIVE_3 "",						\
 		      CALL_ZEN_UNTRAIN_RET, X86_FEATURE_UNRET,		\
 		      "call entry_ibpb", X86_FEATURE_ENTRY_IBPB,	\
@@ -297,7 +297,7 @@
 .macro UNTRAIN_RET_FROM_CALL
 #if defined(CONFIG_CPU_UNRET_ENTRY) || defined(CONFIG_CPU_IBPB_ENTRY) || \
 	defined(CONFIG_CALL_DEPTH_TRACKING)
-	ANNOTATE_UNRET_END
+	VALIDATE_UNRET_END
 	ALTERNATIVE_3 "",						\
 		      CALL_ZEN_UNTRAIN_RET, X86_FEATURE_UNRET,		\
 		      "call entry_ibpb", X86_FEATURE_ENTRY_IBPB,	\
diff --git a/arch/x86/include/asm/unwind_hints.h b/arch/x86/include/asm/unwind_hints.h
index 97b392217c0f..4c0f28d665eb 100644
--- a/arch/x86/include/asm/unwind_hints.h
+++ b/arch/x86/include/asm/unwind_hints.h
@@ -12,7 +12,8 @@
 .endm
 
 .macro UNWIND_HINT_ENTRY
-	UNWIND_HINT type=UNWIND_HINT_TYPE_ENTRY end=1
+	VALIDATE_UNRET_BEGIN
+	UNWIND_HINT_EMPTY
 .endm
 
 .macro UNWIND_HINT_REGS base=%rsp offset=0 indirect=0 extra=1 partial=0 signal=1
@@ -52,6 +53,11 @@
 	UNWIND_HINT_REGS base=\base offset=\offset partial=1 signal=\signal
 .endm
 
+.macro UNWIND_HINT_IRET_ENTRY base=%rsp offset=0 signal=1
+	VALIDATE_UNRET_BEGIN
+	UNWIND_HINT_IRET_REGS base=\base offset=\offset signal=\signal
+.endm
+
 .macro UNWIND_HINT_FUNC
 	UNWIND_HINT sp_reg=ORC_REG_SP sp_offset=8 type=UNWIND_HINT_TYPE_FUNC
 .endm
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 222efd4a09bc..ee3ed15ee1f8 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -390,8 +390,6 @@ SYM_CODE_START_NOALIGN(vc_boot_ghcb)
 	UNWIND_HINT_IRET_REGS offset=8
 	ENDBR
 
-	ANNOTATE_UNRET_END
-
 	/* Build pt_regs */
 	PUSH_AND_CLEAR_REGS
 
@@ -451,7 +449,6 @@ SYM_CODE_END(early_idt_handler_array)
 
 SYM_CODE_START_LOCAL(early_idt_handler_common)
 	UNWIND_HINT_IRET_REGS offset=16
-	ANNOTATE_UNRET_END
 	/*
 	 * The stack is the hardware frame, an error code or zero, and the
 	 * vector number.
@@ -501,8 +498,6 @@ SYM_CODE_START_NOALIGN(vc_no_ghcb)
 	UNWIND_HINT_IRET_REGS offset=8
 	ENDBR
 
-	ANNOTATE_UNRET_END
-
 	/* Build pt_regs */
 	PUSH_AND_CLEAR_REGS
 
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index 725d7f0b6748..5aa475118820 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -124,6 +124,22 @@
 	.popsection
 .endm
 
+/*
+ * Use objtool to validate the entry requirement that all code paths do
+ * VALIDATE_UNRET_END before RET.
+ *
+ * NOTE: The macro must be used at the beginning of a global symbol, otherwise
+ * it will be ignored.
+ */
+.macro VALIDATE_UNRET_BEGIN
+#if defined(CONFIG_NOINSTR_VALIDATION) && defined(CONFIG_CPU_UNRET_ENTRY)
+.Lhere_\@:
+	.pushsection .discard.validate_unret
+	.long	.Lhere_\@ - .
+	.popsection
+#endif
+.endm
+
 .macro REACHABLE
 .Lhere_\@:
 	.pushsection .discard.reachable
diff --git a/include/linux/objtool_types.h b/include/linux/objtool_types.h
index 9a83468c0039..9787ad0f2ef4 100644
--- a/include/linux/objtool_types.h
+++ b/include/linux/objtool_types.h
@@ -42,8 +42,7 @@ struct unwind_hint {
 #define UNWIND_HINT_TYPE_REGS_PARTIAL	2
 /* The below hint types don't have corresponding ORC types */
 #define UNWIND_HINT_TYPE_FUNC		3
-#define UNWIND_HINT_TYPE_ENTRY		4
-#define UNWIND_HINT_TYPE_SAVE		5
-#define UNWIND_HINT_TYPE_RESTORE	6
+#define UNWIND_HINT_TYPE_SAVE		4
+#define UNWIND_HINT_TYPE_RESTORE	5
 
 #endif /* _LINUX_OBJTOOL_TYPES_H */
diff --git a/tools/include/linux/objtool_types.h b/tools/include/linux/objtool_types.h
index 9a83468c0039..9787ad0f2ef4 100644
--- a/tools/include/linux/objtool_types.h
+++ b/tools/include/linux/objtool_types.h
@@ -42,8 +42,7 @@ struct unwind_hint {
 #define UNWIND_HINT_TYPE_REGS_PARTIAL	2
 /* The below hint types don't have corresponding ORC types */
 #define UNWIND_HINT_TYPE_FUNC		3
-#define UNWIND_HINT_TYPE_ENTRY		4
-#define UNWIND_HINT_TYPE_SAVE		5
-#define UNWIND_HINT_TYPE_RESTORE	6
+#define UNWIND_HINT_TYPE_SAVE		4
+#define UNWIND_HINT_TYPE_RESTORE	5
 
 #endif /* _LINUX_OBJTOOL_TYPES_H */
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 3d4b650d3284..226c2db3df89 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2304,16 +2304,9 @@ static int read_unwind_hints(struct objtool_file *file)
 					WARN_FUNC("UNWIND_HINT_IRET_REGS without ENDBR",
 						  insn->sec, insn->offset);
 				}
-
-				insn->entry = 1;
 			}
 		}
 
-		if (hint->type == UNWIND_HINT_TYPE_ENTRY) {
-			hint->type = UNWIND_HINT_TYPE_CALL;
-			insn->entry = 1;
-		}
-
 		if (hint->type == UNWIND_HINT_TYPE_FUNC) {
 			insn->cfi = &func_cfi;
 			continue;
@@ -2446,6 +2439,34 @@ static int read_instr_hints(struct objtool_file *file)
 	return 0;
 }
 
+static int read_validate_unret_hints(struct objtool_file *file)
+{
+	struct section *sec;
+	struct instruction *insn;
+	struct reloc *reloc;
+
+	sec = find_section_by_name(file->elf, ".rela.discard.validate_unret");
+	if (!sec)
+		return 0;
+
+	list_for_each_entry(reloc, &sec->reloc_list, list) {
+		if (reloc->sym->type != STT_SECTION) {
+			WARN("unexpected relocation symbol type in %s", sec->name);
+			return -1;
+		}
+
+		insn = find_insn(file, reloc->sym->sec, reloc->addend);
+		if (!insn) {
+			WARN("bad .discard.instr_end entry");
+			return -1;
+		}
+		insn->unret = 1;
+	}
+
+	return 0;
+}
+
+
 static int read_intra_function_calls(struct objtool_file *file)
 {
 	struct instruction *insn;
@@ -2664,6 +2685,10 @@ static int decode_sections(struct objtool_file *file)
 	if (ret)
 		return ret;
 
+	ret = read_validate_unret_hints(file);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
@@ -3860,10 +3885,10 @@ static int validate_unwind_hints(struct objtool_file *file, struct section *sec)
 /*
  * Validate rethunk entry constraint: must untrain RET before the first RET.
  *
- * Follow every branch (intra-function) and ensure ANNOTATE_UNRET_END comes
+ * Follow every branch (intra-function) and ensure VALIDATE_UNRET_END comes
  * before an actual RET instruction.
  */
-static int validate_entry(struct objtool_file *file, struct instruction *insn)
+static int validate_unret(struct objtool_file *file, struct instruction *insn)
 {
 	struct instruction *next, *dest;
 	int ret, warnings = 0;
@@ -3871,10 +3896,10 @@ static int validate_entry(struct objtool_file *file, struct instruction *insn)
 	for (;;) {
 		next = next_insn_to_validate(file, insn);
 
-		if (insn->visited & VISITED_ENTRY)
+		if (insn->visited & VISITED_UNRET)
 			return 0;
 
-		insn->visited |= VISITED_ENTRY;
+		insn->visited |= VISITED_UNRET;
 
 		if (!insn->ignore_alts && insn->alts) {
 			struct alternative *alt;
@@ -3884,7 +3909,7 @@ static int validate_entry(struct objtool_file *file, struct instruction *insn)
 				if (alt->skip_orig)
 					skip_orig = true;
 
-				ret = validate_entry(file, alt->insn);
+				ret = validate_unret(file, alt->insn);
 				if (ret) {
 				        if (opts.backtrace)
 						BT_FUNC("(alt)", insn);
@@ -3912,7 +3937,7 @@ static int validate_entry(struct objtool_file *file, struct instruction *insn)
 						  insn->sec, insn->offset);
 					return -1;
 				}
-				ret = validate_entry(file, insn->jump_dest);
+				ret = validate_unret(file, insn->jump_dest);
 				if (ret) {
 					if (opts.backtrace) {
 						BT_FUNC("(branch%s)", insn,
@@ -3937,7 +3962,7 @@ static int validate_entry(struct objtool_file *file, struct instruction *insn)
 				return -1;
 			}
 
-			ret = validate_entry(file, dest);
+			ret = validate_unret(file, dest);
 			if (ret) {
 				if (opts.backtrace)
 					BT_FUNC("(call)", insn);
@@ -3973,19 +3998,19 @@ static int validate_entry(struct objtool_file *file, struct instruction *insn)
 }
 
 /*
- * Validate that all branches starting at 'insn->entry' encounter UNRET_END
- * before RET.
+ * Validate that all branches starting at VALIDATE_UNRET_BEGIN encounter
+ * VALIDATE_UNRET_END before RET.
  */
-static int validate_unret(struct objtool_file *file)
+static int validate_unrets(struct objtool_file *file)
 {
 	struct instruction *insn;
 	int ret, warnings = 0;
 
 	for_each_insn(file, insn) {
-		if (!insn->entry)
+		if (!insn->unret)
 			continue;
 
-		ret = validate_entry(file, insn);
+		ret = validate_unret(file, insn);
 		if (ret < 0) {
 			WARN_FUNC("Failed UNRET validation", insn->sec, insn->offset);
 			return ret;
@@ -4604,7 +4629,7 @@ int check(struct objtool_file *file)
 		 * Must be after validate_branch() and friends, it plays
 		 * further games with insn->visited.
 		 */
-		ret = validate_unret(file);
+		ret = validate_unrets(file);
 		if (ret < 0)
 			return ret;
 		warnings += ret;
diff --git a/tools/objtool/include/objtool/check.h b/tools/objtool/include/objtool/check.h
index 3e7c7004f7df..daa46f1f0965 100644
--- a/tools/objtool/include/objtool/check.h
+++ b/tools/objtool/include/objtool/check.h
@@ -61,7 +61,7 @@ struct instruction {
 	    restore		: 1,
 	    retpoline_safe	: 1,
 	    noendbr		: 1,
-	    entry		: 1,
+	    unret		: 1,
 	    visited		: 4,
 	    no_reloc		: 1;
 		/* 10 bit hole */
@@ -92,7 +92,7 @@ static inline struct symbol *insn_func(struct instruction *insn)
 #define VISITED_BRANCH		0x01
 #define VISITED_BRANCH_UACCESS	0x02
 #define VISITED_BRANCH_MASK	0x03
-#define VISITED_ENTRY		0x04
+#define VISITED_UNRET		0x04
 
 static inline bool is_static_jump(struct instruction *insn)
 {
-- 
2.39.1

