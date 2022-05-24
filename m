Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD57531F9C
	for <lists+live-patching@lfdr.de>; Tue, 24 May 2022 02:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbiEXAQz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 23 May 2022 20:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbiEXAQx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 23 May 2022 20:16:53 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 840EB6D1BA;
        Mon, 23 May 2022 17:16:51 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7D5EE20B894E;
        Mon, 23 May 2022 17:16:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7D5EE20B894E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1653351411;
        bh=6K1f7gtO5pFA0H990GU3QXDIIsrQWqqHKexvfsHsLu0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=cmMTbX/hfEn/x/ZGQ9MMZljReSKrjJ818UryE5soz/YdfwGh6TLFrR4rHbMvBK9jm
         qU51OEWFkkzObIOVdn/5NFm6gA72u0Bj3cAAkZf5SdPUDrRaGJ07Gi5km65MSyJnqN
         UmW+9JWMD+vqfwgDzYoE6Jnms5RRU6htOiRCUiMA=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 04/20] objtool: Reorganize Unwind hint code
Date:   Mon, 23 May 2022 19:16:21 -0500
Message-Id: <20220524001637.1707472-5-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220524001637.1707472-1-madvenka@linux.microsoft.com>
References: <e81e773678f88f7c2ff7480e2eb096973ec198db>
 <20220524001637.1707472-1-madvenka@linux.microsoft.com>
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

Unwind hint macros and struct unwind_hint are arch-specific. Move them
into the arch-specific file asm/unwind_hints.h. But the unwind hint
types are generic. Retain them in linux/objtool.h.

Unwind hints can be used with static stack validation as well as other
forms of validation such as dynamic FP validation. Move the function
read_unwind_hints() from check.c to a new file unwind_hints.c so that
it can be shared across validation schemes.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/x86/include/asm/unwind_hints.h       |  85 +++++++++++++
 arch/x86/kernel/unwind_orc.c              |   2 +-
 include/linux/objtool.h                   |  67 ----------
 tools/arch/x86/include/asm/unwind_hints.h | 147 ++++++++++++++++++++++
 tools/include/linux/objtool.h             |  67 ----------
 tools/objtool/Build                       |   2 +
 tools/objtool/check.c                     |  77 ------------
 tools/objtool/include/objtool/insn.h      |   1 +
 tools/objtool/sync-check.sh               |   1 +
 tools/objtool/unwind_hints.c              |  87 +++++++++++++
 10 files changed, 324 insertions(+), 212 deletions(-)
 create mode 100644 tools/arch/x86/include/asm/unwind_hints.h
 create mode 100644 tools/objtool/unwind_hints.c

diff --git a/arch/x86/include/asm/unwind_hints.h b/arch/x86/include/asm/unwind_hints.h
index 8b33674288ea..d5a33561a64e 100644
--- a/arch/x86/include/asm/unwind_hints.h
+++ b/arch/x86/include/asm/unwind_hints.h
@@ -1,10 +1,95 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 #ifndef _ASM_X86_UNWIND_HINTS_H
 #define _ASM_X86_UNWIND_HINTS_H
 
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+
+/*
+ * This struct is used by asm and inline asm code to manually annotate the
+ * location of registers on the stack.
+ */
+struct unwind_hint {
+	u32		ip;
+	s16		sp_offset;
+	u8		sp_reg;
+	u8		type;
+	u8		end;
+};
+#endif
+
 #include <linux/objtool.h>
 
 #include "orc_types.h"
 
+#ifdef CONFIG_STACK_VALIDATION
+
+#ifndef __ASSEMBLY__
+
+#define UNWIND_HINT(sp_reg, sp_offset, type, end)		\
+	"987: \n\t"						\
+	".pushsection .discard.unwind_hints\n\t"		\
+	/* struct unwind_hint */				\
+	".long 987b - .\n\t"					\
+	".short " __stringify(sp_offset) "\n\t"			\
+	".byte " __stringify(sp_reg) "\n\t"			\
+	".byte " __stringify(type) "\n\t"			\
+	".byte " __stringify(end) "\n\t"			\
+	".balign 4 \n\t"					\
+	".popsection\n\t"
+
+#else /* __ASSEMBLY__ */
+
+/*
+ * In asm, there are two kinds of code: normal C-type callable functions and
+ * the rest.  The normal callable functions can be called by other code, and
+ * don't do anything unusual with the stack.  Such normal callable functions
+ * are annotated with the ENTRY/ENDPROC macros.  Most asm code falls in this
+ * category.  In this case, no special debugging annotations are needed because
+ * objtool can automatically generate the ORC data for the ORC unwinder to read
+ * at runtime.
+ *
+ * Anything which doesn't fall into the above category, such as syscall and
+ * interrupt handlers, tends to not be called directly by other functions, and
+ * often does unusual non-C-function-type things with the stack pointer.  Such
+ * code needs to be annotated such that objtool can understand it.  The
+ * following CFI hint macros are for this type of code.
+ *
+ * These macros provide hints to objtool about the state of the stack at each
+ * instruction.  Objtool starts from the hints and follows the code flow,
+ * making automatic CFI adjustments when it sees pushes and pops, filling out
+ * the debuginfo as necessary.  It will also warn if it sees any
+ * inconsistencies.
+ */
+.macro UNWIND_HINT sp_reg:req sp_offset=0 type:req end=0
+.Lunwind_hint_ip_\@:
+	.pushsection .discard.unwind_hints
+		/* struct unwind_hint */
+		.long .Lunwind_hint_ip_\@ - .
+		.short \sp_offset
+		.byte \sp_reg
+		.byte \type
+		.byte \end
+		.balign 4
+	.popsection
+.endm
+
+#endif /* __ASSEMBLY__ */
+
+#else /* !CONFIG_STACK_VALIDATION */
+
+#ifndef __ASSEMBLY__
+
+#define UNWIND_HINT(sp_reg, sp_offset, type, end)	\
+	"\n\t"
+#else
+.macro UNWIND_HINT sp_reg:req sp_offset=0 type:req end=0
+.endm
+#endif
+
+#endif /* CONFIG_STACK_VALIDATION */
+
 #ifdef __ASSEMBLY__
 
 .macro UNWIND_HINT_EMPTY
diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 794fdef2501a..7cae5bfa56c7 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-#include <linux/objtool.h>
+#include <asm/unwind_hints.h>
 #include <linux/module.h>
 #include <linux/sort.h>
 #include <asm/ptrace.h>
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index 586d35720f13..00bb449777d0 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -2,23 +2,6 @@
 #ifndef _LINUX_OBJTOOL_H
 #define _LINUX_OBJTOOL_H
 
-#ifndef __ASSEMBLY__
-
-#include <linux/types.h>
-
-/*
- * This struct is used by asm and inline asm code to manually annotate the
- * location of registers on the stack.
- */
-struct unwind_hint {
-	u32		ip;
-	s16		sp_offset;
-	u8		sp_reg;
-	u8		type;
-	u8		end;
-};
-#endif
-
 /*
  * UNWIND_HINT_TYPE_CALL: Indicates that sp_reg+sp_offset resolves to PREV_SP
  * (the caller's SP right before it made the call).  Used for all callable
@@ -42,18 +25,6 @@ struct unwind_hint {
 
 #ifndef __ASSEMBLY__
 
-#define UNWIND_HINT(sp_reg, sp_offset, type, end)		\
-	"987: \n\t"						\
-	".pushsection .discard.unwind_hints\n\t"		\
-	/* struct unwind_hint */				\
-	".long 987b - .\n\t"					\
-	".short " __stringify(sp_offset) "\n\t"			\
-	".byte " __stringify(sp_reg) "\n\t"			\
-	".byte " __stringify(type) "\n\t"			\
-	".byte " __stringify(end) "\n\t"			\
-	".balign 4 \n\t"					\
-	".popsection\n\t"
-
 /*
  * This macro marks the given function's stack frame as "non-standard", which
  * tells objtool to ignore the function when doing stack metadata validation.
@@ -101,40 +72,6 @@ struct unwind_hint {
 	.long 999b;						\
 	.popsection;
 
-/*
- * In asm, there are two kinds of code: normal C-type callable functions and
- * the rest.  The normal callable functions can be called by other code, and
- * don't do anything unusual with the stack.  Such normal callable functions
- * are annotated with the ENTRY/ENDPROC macros.  Most asm code falls in this
- * category.  In this case, no special debugging annotations are needed because
- * objtool can automatically generate the ORC data for the ORC unwinder to read
- * at runtime.
- *
- * Anything which doesn't fall into the above category, such as syscall and
- * interrupt handlers, tends to not be called directly by other functions, and
- * often does unusual non-C-function-type things with the stack pointer.  Such
- * code needs to be annotated such that objtool can understand it.  The
- * following CFI hint macros are for this type of code.
- *
- * These macros provide hints to objtool about the state of the stack at each
- * instruction.  Objtool starts from the hints and follows the code flow,
- * making automatic CFI adjustments when it sees pushes and pops, filling out
- * the debuginfo as necessary.  It will also warn if it sees any
- * inconsistencies.
- */
-.macro UNWIND_HINT sp_reg:req sp_offset=0 type:req end=0
-.Lunwind_hint_ip_\@:
-	.pushsection .discard.unwind_hints
-		/* struct unwind_hint */
-		.long .Lunwind_hint_ip_\@ - .
-		.short \sp_offset
-		.byte \sp_reg
-		.byte \type
-		.byte \end
-		.balign 4
-	.popsection
-.endm
-
 .macro STACK_FRAME_NON_STANDARD func:req
 	.pushsection .discard.func_stack_frame_non_standard, "aw"
 		.long \func - .
@@ -161,16 +98,12 @@ struct unwind_hint {
 
 #ifndef __ASSEMBLY__
 
-#define UNWIND_HINT(sp_reg, sp_offset, type, end)	\
-	"\n\t"
 #define STACK_FRAME_NON_STANDARD(func)
 #define STACK_FRAME_NON_STANDARD_FP(func)
 #define ANNOTATE_NOENDBR
 #define ASM_REACHABLE
 #else
 #define ANNOTATE_INTRA_FUNCTION_CALL
-.macro UNWIND_HINT sp_reg:req sp_offset=0 type:req end=0
-.endm
 .macro STACK_FRAME_NON_STANDARD func:req
 .endm
 .macro ANNOTATE_NOENDBR
diff --git a/tools/arch/x86/include/asm/unwind_hints.h b/tools/arch/x86/include/asm/unwind_hints.h
new file mode 100644
index 000000000000..d5a33561a64e
--- /dev/null
+++ b/tools/arch/x86/include/asm/unwind_hints.h
@@ -0,0 +1,147 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASM_X86_UNWIND_HINTS_H
+#define _ASM_X86_UNWIND_HINTS_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+
+/*
+ * This struct is used by asm and inline asm code to manually annotate the
+ * location of registers on the stack.
+ */
+struct unwind_hint {
+	u32		ip;
+	s16		sp_offset;
+	u8		sp_reg;
+	u8		type;
+	u8		end;
+};
+#endif
+
+#include <linux/objtool.h>
+
+#include "orc_types.h"
+
+#ifdef CONFIG_STACK_VALIDATION
+
+#ifndef __ASSEMBLY__
+
+#define UNWIND_HINT(sp_reg, sp_offset, type, end)		\
+	"987: \n\t"						\
+	".pushsection .discard.unwind_hints\n\t"		\
+	/* struct unwind_hint */				\
+	".long 987b - .\n\t"					\
+	".short " __stringify(sp_offset) "\n\t"			\
+	".byte " __stringify(sp_reg) "\n\t"			\
+	".byte " __stringify(type) "\n\t"			\
+	".byte " __stringify(end) "\n\t"			\
+	".balign 4 \n\t"					\
+	".popsection\n\t"
+
+#else /* __ASSEMBLY__ */
+
+/*
+ * In asm, there are two kinds of code: normal C-type callable functions and
+ * the rest.  The normal callable functions can be called by other code, and
+ * don't do anything unusual with the stack.  Such normal callable functions
+ * are annotated with the ENTRY/ENDPROC macros.  Most asm code falls in this
+ * category.  In this case, no special debugging annotations are needed because
+ * objtool can automatically generate the ORC data for the ORC unwinder to read
+ * at runtime.
+ *
+ * Anything which doesn't fall into the above category, such as syscall and
+ * interrupt handlers, tends to not be called directly by other functions, and
+ * often does unusual non-C-function-type things with the stack pointer.  Such
+ * code needs to be annotated such that objtool can understand it.  The
+ * following CFI hint macros are for this type of code.
+ *
+ * These macros provide hints to objtool about the state of the stack at each
+ * instruction.  Objtool starts from the hints and follows the code flow,
+ * making automatic CFI adjustments when it sees pushes and pops, filling out
+ * the debuginfo as necessary.  It will also warn if it sees any
+ * inconsistencies.
+ */
+.macro UNWIND_HINT sp_reg:req sp_offset=0 type:req end=0
+.Lunwind_hint_ip_\@:
+	.pushsection .discard.unwind_hints
+		/* struct unwind_hint */
+		.long .Lunwind_hint_ip_\@ - .
+		.short \sp_offset
+		.byte \sp_reg
+		.byte \type
+		.byte \end
+		.balign 4
+	.popsection
+.endm
+
+#endif /* __ASSEMBLY__ */
+
+#else /* !CONFIG_STACK_VALIDATION */
+
+#ifndef __ASSEMBLY__
+
+#define UNWIND_HINT(sp_reg, sp_offset, type, end)	\
+	"\n\t"
+#else
+.macro UNWIND_HINT sp_reg:req sp_offset=0 type:req end=0
+.endm
+#endif
+
+#endif /* CONFIG_STACK_VALIDATION */
+
+#ifdef __ASSEMBLY__
+
+.macro UNWIND_HINT_EMPTY
+	UNWIND_HINT sp_reg=ORC_REG_UNDEFINED type=UNWIND_HINT_TYPE_CALL end=1
+.endm
+
+.macro UNWIND_HINT_REGS base=%rsp offset=0 indirect=0 extra=1 partial=0
+	.if \base == %rsp
+		.if \indirect
+			.set sp_reg, ORC_REG_SP_INDIRECT
+		.else
+			.set sp_reg, ORC_REG_SP
+		.endif
+	.elseif \base == %rbp
+		.set sp_reg, ORC_REG_BP
+	.elseif \base == %rdi
+		.set sp_reg, ORC_REG_DI
+	.elseif \base == %rdx
+		.set sp_reg, ORC_REG_DX
+	.elseif \base == %r10
+		.set sp_reg, ORC_REG_R10
+	.else
+		.error "UNWIND_HINT_REGS: bad base register"
+	.endif
+
+	.set sp_offset, \offset
+
+	.if \partial
+		.set type, UNWIND_HINT_TYPE_REGS_PARTIAL
+	.elseif \extra == 0
+		.set type, UNWIND_HINT_TYPE_REGS_PARTIAL
+		.set sp_offset, \offset + (16*8)
+	.else
+		.set type, UNWIND_HINT_TYPE_REGS
+	.endif
+
+	UNWIND_HINT sp_reg=sp_reg sp_offset=sp_offset type=type
+.endm
+
+.macro UNWIND_HINT_IRET_REGS base=%rsp offset=0
+	UNWIND_HINT_REGS base=\base offset=\offset partial=1
+.endm
+
+.macro UNWIND_HINT_FUNC
+	UNWIND_HINT sp_reg=ORC_REG_SP sp_offset=8 type=UNWIND_HINT_TYPE_FUNC
+.endm
+
+#else
+
+#define UNWIND_HINT_FUNC \
+	UNWIND_HINT(ORC_REG_SP, 8, UNWIND_HINT_TYPE_FUNC, 0)
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_X86_UNWIND_HINTS_H */
diff --git a/tools/include/linux/objtool.h b/tools/include/linux/objtool.h
index 586d35720f13..00bb449777d0 100644
--- a/tools/include/linux/objtool.h
+++ b/tools/include/linux/objtool.h
@@ -2,23 +2,6 @@
 #ifndef _LINUX_OBJTOOL_H
 #define _LINUX_OBJTOOL_H
 
-#ifndef __ASSEMBLY__
-
-#include <linux/types.h>
-
-/*
- * This struct is used by asm and inline asm code to manually annotate the
- * location of registers on the stack.
- */
-struct unwind_hint {
-	u32		ip;
-	s16		sp_offset;
-	u8		sp_reg;
-	u8		type;
-	u8		end;
-};
-#endif
-
 /*
  * UNWIND_HINT_TYPE_CALL: Indicates that sp_reg+sp_offset resolves to PREV_SP
  * (the caller's SP right before it made the call).  Used for all callable
@@ -42,18 +25,6 @@ struct unwind_hint {
 
 #ifndef __ASSEMBLY__
 
-#define UNWIND_HINT(sp_reg, sp_offset, type, end)		\
-	"987: \n\t"						\
-	".pushsection .discard.unwind_hints\n\t"		\
-	/* struct unwind_hint */				\
-	".long 987b - .\n\t"					\
-	".short " __stringify(sp_offset) "\n\t"			\
-	".byte " __stringify(sp_reg) "\n\t"			\
-	".byte " __stringify(type) "\n\t"			\
-	".byte " __stringify(end) "\n\t"			\
-	".balign 4 \n\t"					\
-	".popsection\n\t"
-
 /*
  * This macro marks the given function's stack frame as "non-standard", which
  * tells objtool to ignore the function when doing stack metadata validation.
@@ -101,40 +72,6 @@ struct unwind_hint {
 	.long 999b;						\
 	.popsection;
 
-/*
- * In asm, there are two kinds of code: normal C-type callable functions and
- * the rest.  The normal callable functions can be called by other code, and
- * don't do anything unusual with the stack.  Such normal callable functions
- * are annotated with the ENTRY/ENDPROC macros.  Most asm code falls in this
- * category.  In this case, no special debugging annotations are needed because
- * objtool can automatically generate the ORC data for the ORC unwinder to read
- * at runtime.
- *
- * Anything which doesn't fall into the above category, such as syscall and
- * interrupt handlers, tends to not be called directly by other functions, and
- * often does unusual non-C-function-type things with the stack pointer.  Such
- * code needs to be annotated such that objtool can understand it.  The
- * following CFI hint macros are for this type of code.
- *
- * These macros provide hints to objtool about the state of the stack at each
- * instruction.  Objtool starts from the hints and follows the code flow,
- * making automatic CFI adjustments when it sees pushes and pops, filling out
- * the debuginfo as necessary.  It will also warn if it sees any
- * inconsistencies.
- */
-.macro UNWIND_HINT sp_reg:req sp_offset=0 type:req end=0
-.Lunwind_hint_ip_\@:
-	.pushsection .discard.unwind_hints
-		/* struct unwind_hint */
-		.long .Lunwind_hint_ip_\@ - .
-		.short \sp_offset
-		.byte \sp_reg
-		.byte \type
-		.byte \end
-		.balign 4
-	.popsection
-.endm
-
 .macro STACK_FRAME_NON_STANDARD func:req
 	.pushsection .discard.func_stack_frame_non_standard, "aw"
 		.long \func - .
@@ -161,16 +98,12 @@ struct unwind_hint {
 
 #ifndef __ASSEMBLY__
 
-#define UNWIND_HINT(sp_reg, sp_offset, type, end)	\
-	"\n\t"
 #define STACK_FRAME_NON_STANDARD(func)
 #define STACK_FRAME_NON_STANDARD_FP(func)
 #define ANNOTATE_NOENDBR
 #define ASM_REACHABLE
 #else
 #define ANNOTATE_INTRA_FUNCTION_CALL
-.macro UNWIND_HINT sp_reg:req sp_offset=0 type:req end=0
-.endm
 .macro STACK_FRAME_NON_STANDARD func:req
 .endm
 .macro ANNOTATE_NOENDBR
diff --git a/tools/objtool/Build b/tools/objtool/Build
index 199561f86c1e..9c2a332f61f3 100644
--- a/tools/objtool/Build
+++ b/tools/objtool/Build
@@ -6,11 +6,13 @@ objtool-$(SUBCMD_CHECK) += check.o
 objtool-$(SUBCMD_CHECK) += cfi.o
 objtool-$(SUBCMD_CHECK) += insn.o
 objtool-$(SUBCMD_CHECK) += decode.o
+objtool-$(SUBCMD_CHECK) += unwind_hints.o
 objtool-$(SUBCMD_CHECK) += special.o
 objtool-$(SUBCMD_ORC) += check.o
 objtool-$(SUBCMD_ORC) += cfi.o
 objtool-$(SUBCMD_ORC) += insn.o
 objtool-$(SUBCMD_ORC) += decode.o
+objtool-$(SUBCMD_ORC) += unwind_hints.o
 objtool-$(SUBCMD_ORC) += orc_gen.o
 objtool-$(SUBCMD_ORC) += orc_dump.o
 
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 334ddc737bf9..43f3d7819277 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1541,83 +1541,6 @@ static int add_jump_table_alts(struct objtool_file *file)
 	return 0;
 }
 
-static int read_unwind_hints(struct objtool_file *file)
-{
-	struct cfi_state cfi = init_cfi;
-	struct section *sec, *relocsec;
-	struct unwind_hint *hint;
-	struct instruction *insn;
-	struct reloc *reloc;
-	int i;
-
-	sec = find_section_by_name(file->elf, ".discard.unwind_hints");
-	if (!sec)
-		return 0;
-
-	relocsec = sec->reloc;
-	if (!relocsec) {
-		WARN("missing .rela.discard.unwind_hints section");
-		return -1;
-	}
-
-	if (sec->sh.sh_size % sizeof(struct unwind_hint)) {
-		WARN("struct unwind_hint size mismatch");
-		return -1;
-	}
-
-	file->hints = true;
-
-	for (i = 0; i < sec->sh.sh_size / sizeof(struct unwind_hint); i++) {
-		hint = (struct unwind_hint *)sec->data->d_buf + i;
-
-		reloc = find_reloc_by_dest(file->elf, sec, i * sizeof(*hint));
-		if (!reloc) {
-			WARN("can't find reloc for unwind_hints[%d]", i);
-			return -1;
-		}
-
-		insn = find_insn(file, reloc->sym->sec, reloc->addend);
-		if (!insn) {
-			WARN("can't find insn for unwind_hints[%d]", i);
-			return -1;
-		}
-
-		insn->hint = true;
-
-		if (ibt && hint->type == UNWIND_HINT_TYPE_REGS_PARTIAL) {
-			struct symbol *sym = find_symbol_by_offset(insn->sec, insn->offset);
-
-			if (sym && sym->bind == STB_GLOBAL &&
-			    insn->type != INSN_ENDBR && !insn->noendbr) {
-				WARN_FUNC("UNWIND_HINT_IRET_REGS without ENDBR",
-					  insn->sec, insn->offset);
-			}
-		}
-
-		if (hint->type == UNWIND_HINT_TYPE_FUNC) {
-			insn->cfi = &func_cfi;
-			continue;
-		}
-
-		if (insn->cfi)
-			cfi = *(insn->cfi);
-
-		if (arch_decode_hint_reg(hint->sp_reg, &cfi.cfa.base)) {
-			WARN_FUNC("unsupported unwind_hint sp base reg %d",
-				  insn->sec, insn->offset, hint->sp_reg);
-			return -1;
-		}
-
-		cfi.cfa.offset = bswap_if_needed(hint->sp_offset);
-		cfi.type = hint->type;
-		cfi.end = hint->end;
-
-		insn->cfi = cfi_hash_find_or_add(&cfi);
-	}
-
-	return 0;
-}
-
 static int read_noendbr_hints(struct objtool_file *file)
 {
 	struct section *sec;
diff --git a/tools/objtool/include/objtool/insn.h b/tools/objtool/include/objtool/insn.h
index 5f01fd0ce8ed..0b5596f8b12f 100644
--- a/tools/objtool/include/objtool/insn.h
+++ b/tools/objtool/include/objtool/insn.h
@@ -84,6 +84,7 @@ bool insn_cfi_match(struct instruction *insn, struct cfi_state *cfi2);
 bool same_function(struct instruction *insn1, struct instruction *insn2);
 bool is_first_func_insn(struct instruction *insn);
 int decode_instructions(struct objtool_file *file);
+int read_unwind_hints(struct objtool_file *file);
 
 #define for_each_insn(file, insn)					\
 	list_for_each_entry(insn, &file->insn_list, list)
diff --git a/tools/objtool/sync-check.sh b/tools/objtool/sync-check.sh
index 105a291ff8e7..ee49b4e9e72c 100755
--- a/tools/objtool/sync-check.sh
+++ b/tools/objtool/sync-check.sh
@@ -14,6 +14,7 @@ arch/x86/include/asm/nops.h
 arch/x86/include/asm/inat_types.h
 arch/x86/include/asm/orc_types.h
 arch/x86/include/asm/emulate_prefix.h
+arch/x86/include/asm/unwind_hints.h
 arch/x86/lib/x86-opcode-map.txt
 arch/x86/tools/gen-insn-attr-x86.awk
 include/linux/static_call_types.h
diff --git a/tools/objtool/unwind_hints.c b/tools/objtool/unwind_hints.c
new file mode 100644
index 000000000000..d4e41c67403b
--- /dev/null
+++ b/tools/objtool/unwind_hints.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2015-2017 Josh Poimboeuf <jpoimboe@redhat.com>
+ */
+#include <asm/unwind_hints.h>
+
+#include <objtool/builtin.h>
+#include <objtool/endianness.h>
+#include <objtool/insn.h>
+#include <objtool/warn.h>
+
+int read_unwind_hints(struct objtool_file *file)
+{
+	struct cfi_state cfi = init_cfi;
+	struct section *sec, *relocsec;
+	struct unwind_hint *hint;
+	struct instruction *insn;
+	struct reloc *reloc;
+	int i;
+
+	sec = find_section_by_name(file->elf, ".discard.unwind_hints");
+	if (!sec)
+		return 0;
+
+	relocsec = sec->reloc;
+	if (!relocsec) {
+		WARN("missing .rela.discard.unwind_hints section");
+		return -1;
+	}
+
+	if (sec->sh.sh_size % sizeof(struct unwind_hint)) {
+		WARN("struct unwind_hint size mismatch");
+		return -1;
+	}
+
+	file->hints = true;
+
+	for (i = 0; i < sec->sh.sh_size / sizeof(struct unwind_hint); i++) {
+		hint = (struct unwind_hint *)sec->data->d_buf + i;
+
+		reloc = find_reloc_by_dest(file->elf, sec, i * sizeof(*hint));
+		if (!reloc) {
+			WARN("can't find reloc for unwind_hints[%d]", i);
+			return -1;
+		}
+
+		insn = find_insn(file, reloc->sym->sec, reloc->addend);
+		if (!insn) {
+			WARN("can't find insn for unwind_hints[%d]", i);
+			return -1;
+		}
+
+		insn->hint = true;
+
+		if (ibt && hint->type == UNWIND_HINT_TYPE_REGS_PARTIAL) {
+			struct symbol *sym = find_symbol_by_offset(insn->sec, insn->offset);
+
+			if (sym && sym->bind == STB_GLOBAL &&
+			    insn->type != INSN_ENDBR && !insn->noendbr) {
+				WARN_FUNC("UNWIND_HINT_IRET_REGS without ENDBR",
+					  insn->sec, insn->offset);
+			}
+		}
+
+		if (hint->type == UNWIND_HINT_TYPE_FUNC) {
+			insn->cfi = &func_cfi;
+			continue;
+		}
+
+		if (insn->cfi)
+			cfi = *(insn->cfi);
+
+		if (arch_decode_hint_reg(hint->sp_reg, &cfi.cfa.base)) {
+			WARN_FUNC("unsupported unwind_hint sp base reg %d",
+				  insn->sec, insn->offset, hint->sp_reg);
+			return -1;
+		}
+
+		cfi.cfa.offset = bswap_if_needed(hint->sp_offset);
+		cfi.type = hint->type;
+		cfi.end = hint->end;
+
+		insn->cfi = cfi_hash_find_or_add(&cfi);
+	}
+
+	return 0;
+}
-- 
2.25.1

