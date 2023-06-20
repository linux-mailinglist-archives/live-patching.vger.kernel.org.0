Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8AA4736523
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 09:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjFTHre (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 03:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjFTHrb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 03:47:31 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2427CE4D;
        Tue, 20 Jun 2023 00:47:23 -0700 (PDT)
Received: from loongson.cn (unknown [113.200.148.30])
        by gateway (Coremail) with SMTP id _____8AxEemKWZFkthoHAA--.12525S3;
        Tue, 20 Jun 2023 15:47:22 +0800 (CST)
Received: from bogon.localdomain (unknown [113.200.148.30])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxK8pvWZFkJGYhAA--.19652S6;
        Tue, 20 Jun 2023 15:47:21 +0800 (CST)
From:   Youling Tang <tangyouling@loongson.cn>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        madvenka@linux.microsoft.com
Cc:     chenzhongjin@huawei.com, WANG Xuerui <kernel@xen0n.name>,
        Xi Ruoyao <xry111@xry111.site>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        tangyouling00@gmail.com, youling.tang@outlook.com
Subject: [RFC PATCH v1 04/23] objtool: Reorganize Unwind hint code
Date:   Tue, 20 Jun 2023 15:46:30 +0800
Message-Id: <1687247209-31676-5-git-send-email-tangyouling@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1687247209-31676-1-git-send-email-tangyouling@loongson.cn>
References: <1687247209-31676-1-git-send-email-tangyouling@loongson.cn>
X-CM-TRANSID: AQAAf8DxK8pvWZFkJGYhAA--.19652S6
X-CM-SenderInfo: 5wdqw5prxox03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj9fXoWfCrWkWryDWw15Xr4kArW3CFX_yoW8Kr45Co
        WSqr4Fkw43Xry5CFyDJ348GFsYqw4kKFW5JrZ0qrZxZ3Z5C3y29r4Iqa17AanxtF4kKrWD
        AFWaq3yfJrWDGFn3l-sFpf9Il3svdjkaLaAFLSUrUUUUnb8apTn2vfkv8UJUUUU8wcxFpf
        9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
        UjIYCTnIWjp_UUUYt7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
        8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
        Y2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14
        v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E
        14v26r4UJVWxJr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6x
        kI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v2
        6rWY6Fy7McIj6I8E87Iv67AKxVWxJVW8Jr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48Icx
        kI7VAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
        c4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
        Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
        6xIIjxv20xvE14v26F1j6w1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcV
        CF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jxxhdUUUUU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/unwind_hints.h       |  86 ++++++++++++
 arch/x86/kernel/unwind_orc.c              |   2 +-
 include/linux/objtool.h                   |  70 ----------
 tools/arch/x86/include/asm/unwind_hints.h | 160 ++++++++++++++++++++++
 tools/include/linux/objtool.h             |  70 ----------
 tools/objtool/Build                       |   1 +
 tools/objtool/check.c                     |  97 -------------
 tools/objtool/include/objtool/insn.h      |   1 +
 tools/objtool/sync-check.sh               |   1 +
 tools/objtool/unwind_hints.c              | 107 +++++++++++++++
 10 files changed, 357 insertions(+), 238 deletions(-)
 create mode 100644 tools/arch/x86/include/asm/unwind_hints.h
 create mode 100644 tools/objtool/unwind_hints.c

diff --git a/arch/x86/include/asm/unwind_hints.h b/arch/x86/include/asm/unwind_hints.h
index e7c71750b309..2570edfa8c35 100644
--- a/arch/x86/include/asm/unwind_hints.h
+++ b/arch/x86/include/asm/unwind_hints.h
@@ -1,10 +1,96 @@
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
+	u8		signal;
+	u8		end;
+};
+#endif
+
 #include <linux/objtool.h>
 
 #include "orc_types.h"
 
+#ifdef CONFIG_OBJTOOL
+
+#ifndef __ASSEMBLY__
+
+#define UNWIND_HINT(sp_reg, sp_offset, type, signal, end)	\
+	"987: \n\t"						\
+	".pushsection .discard.unwind_hints\n\t"		\
+	/* struct unwind_hint */				\
+	".long 987b - .\n\t"					\
+	".short " __stringify(sp_offset) "\n\t"			\
+	".byte " __stringify(sp_reg) "\n\t"			\
+	".byte " __stringify(type) "\n\t"			\
+	".byte " __stringify(signal) "\n\t"			\
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
+.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0 end=0
+.Lunwind_hint_ip_\@:
+	.pushsection .discard.unwind_hints
+		/* struct unwind_hint */
+		.long .Lunwind_hint_ip_\@ - .
+		.short \sp_offset
+		.byte \sp_reg
+		.byte \type
+		.byte \signal
+		.byte \end
+		.balign 4
+	.popsection
+.endm
+
+#endif /* __ASSEMBLY__ */
+
+#else /* !CONFIG_OBJTOOL */
+
+#ifndef __ASSEMBLY__
+#define UNWIND_HINT(sp_reg, sp_offset, type, signal, end)	\
+	"\n\t"
+#else
+.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0 end=0
+.endm
+#endif
+
+#endif /* CONFIG_OBJTOOL */
+
 #ifdef __ASSEMBLY__
 
 .macro UNWIND_HINT_EMPTY
diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 37307b40f8da..01b89f2039c3 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -1,10 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0-only
-#include <linux/objtool.h>
 #include <linux/module.h>
 #include <linux/sort.h>
 #include <asm/ptrace.h>
 #include <asm/stacktrace.h>
 #include <asm/unwind.h>
+#include <asm/unwind_hints.h>
 #include <asm/orc_types.h>
 #include <asm/orc_lookup.h>
 
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index 9ac3df3fccf0..1af295efc12c 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -2,24 +2,6 @@
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
-	u8		signal;
-	u8		end;
-};
-#endif
-
 /*
  * UNWIND_HINT_TYPE_CALL: Indicates that sp_reg+sp_offset resolves to PREV_SP
  * (the caller's SP right before it made the call).  Used for all callable
@@ -50,19 +32,6 @@ struct unwind_hint {
 
 #ifndef __ASSEMBLY__
 
-#define UNWIND_HINT(sp_reg, sp_offset, type, signal, end)	\
-	"987: \n\t"						\
-	".pushsection .discard.unwind_hints\n\t"		\
-	/* struct unwind_hint */				\
-	".long 987b - .\n\t"					\
-	".short " __stringify(sp_offset) "\n\t"			\
-	".byte " __stringify(sp_reg) "\n\t"			\
-	".byte " __stringify(type) "\n\t"			\
-	".byte " __stringify(signal) "\n\t"			\
-	".byte " __stringify(end) "\n\t"			\
-	".balign 4 \n\t"					\
-	".popsection\n\t"
-
 /*
  * This macro marks the given function's stack frame as "non-standard", which
  * tells objtool to ignore the function when doing stack metadata validation.
@@ -110,41 +79,6 @@ struct unwind_hint {
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
-.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0 end=0
-.Lunwind_hint_ip_\@:
-	.pushsection .discard.unwind_hints
-		/* struct unwind_hint */
-		.long .Lunwind_hint_ip_\@ - .
-		.short \sp_offset
-		.byte \sp_reg
-		.byte \type
-		.byte \signal
-		.byte \end
-		.balign 4
-	.popsection
-.endm
-
 .macro STACK_FRAME_NON_STANDARD func:req
 	.pushsection .discard.func_stack_frame_non_standard, "aw"
 	_ASM_PTR \func
@@ -177,16 +111,12 @@ struct unwind_hint {
 
 #ifndef __ASSEMBLY__
 
-#define UNWIND_HINT(sp_reg, sp_offset, type, signal, end) \
-	"\n\t"
 #define STACK_FRAME_NON_STANDARD(func)
 #define STACK_FRAME_NON_STANDARD_FP(func)
 #define ANNOTATE_NOENDBR
 #define ASM_REACHABLE
 #else
 #define ANNOTATE_INTRA_FUNCTION_CALL
-.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0 end=0
-.endm
 .macro STACK_FRAME_NON_STANDARD func:req
 .endm
 .macro ANNOTATE_NOENDBR
diff --git a/tools/arch/x86/include/asm/unwind_hints.h b/tools/arch/x86/include/asm/unwind_hints.h
new file mode 100644
index 000000000000..2570edfa8c35
--- /dev/null
+++ b/tools/arch/x86/include/asm/unwind_hints.h
@@ -0,0 +1,160 @@
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
+	u8		signal;
+	u8		end;
+};
+#endif
+
+#include <linux/objtool.h>
+
+#include "orc_types.h"
+
+#ifdef CONFIG_OBJTOOL
+
+#ifndef __ASSEMBLY__
+
+#define UNWIND_HINT(sp_reg, sp_offset, type, signal, end)	\
+	"987: \n\t"						\
+	".pushsection .discard.unwind_hints\n\t"		\
+	/* struct unwind_hint */				\
+	".long 987b - .\n\t"					\
+	".short " __stringify(sp_offset) "\n\t"			\
+	".byte " __stringify(sp_reg) "\n\t"			\
+	".byte " __stringify(type) "\n\t"			\
+	".byte " __stringify(signal) "\n\t"			\
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
+.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0 end=0
+.Lunwind_hint_ip_\@:
+	.pushsection .discard.unwind_hints
+		/* struct unwind_hint */
+		.long .Lunwind_hint_ip_\@ - .
+		.short \sp_offset
+		.byte \sp_reg
+		.byte \type
+		.byte \signal
+		.byte \end
+		.balign 4
+	.popsection
+.endm
+
+#endif /* __ASSEMBLY__ */
+
+#else /* !CONFIG_OBJTOOL */
+
+#ifndef __ASSEMBLY__
+#define UNWIND_HINT(sp_reg, sp_offset, type, signal, end)	\
+	"\n\t"
+#else
+.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0 end=0
+.endm
+#endif
+
+#endif /* CONFIG_OBJTOOL */
+
+#ifdef __ASSEMBLY__
+
+.macro UNWIND_HINT_EMPTY
+	UNWIND_HINT type=UNWIND_HINT_TYPE_CALL end=1
+.endm
+
+.macro UNWIND_HINT_ENTRY
+	UNWIND_HINT type=UNWIND_HINT_TYPE_ENTRY end=1
+.endm
+
+.macro UNWIND_HINT_REGS base=%rsp offset=0 indirect=0 extra=1 partial=0 signal=1
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
+	UNWIND_HINT sp_reg=sp_reg sp_offset=sp_offset type=type signal=\signal
+.endm
+
+.macro UNWIND_HINT_IRET_REGS base=%rsp offset=0 signal=1
+	UNWIND_HINT_REGS base=\base offset=\offset partial=1 signal=\signal
+.endm
+
+.macro UNWIND_HINT_FUNC
+	UNWIND_HINT sp_reg=ORC_REG_SP sp_offset=8 type=UNWIND_HINT_TYPE_FUNC
+.endm
+
+.macro UNWIND_HINT_SAVE
+	UNWIND_HINT type=UNWIND_HINT_TYPE_SAVE
+.endm
+
+.macro UNWIND_HINT_RESTORE
+	UNWIND_HINT type=UNWIND_HINT_TYPE_RESTORE
+.endm
+
+#else
+
+#define UNWIND_HINT_FUNC \
+	UNWIND_HINT(ORC_REG_SP, 8, UNWIND_HINT_TYPE_FUNC, 0, 0)
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_X86_UNWIND_HINTS_H */
diff --git a/tools/include/linux/objtool.h b/tools/include/linux/objtool.h
index 9ac3df3fccf0..1af295efc12c 100644
--- a/tools/include/linux/objtool.h
+++ b/tools/include/linux/objtool.h
@@ -2,24 +2,6 @@
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
-	u8		signal;
-	u8		end;
-};
-#endif
-
 /*
  * UNWIND_HINT_TYPE_CALL: Indicates that sp_reg+sp_offset resolves to PREV_SP
  * (the caller's SP right before it made the call).  Used for all callable
@@ -50,19 +32,6 @@ struct unwind_hint {
 
 #ifndef __ASSEMBLY__
 
-#define UNWIND_HINT(sp_reg, sp_offset, type, signal, end)	\
-	"987: \n\t"						\
-	".pushsection .discard.unwind_hints\n\t"		\
-	/* struct unwind_hint */				\
-	".long 987b - .\n\t"					\
-	".short " __stringify(sp_offset) "\n\t"			\
-	".byte " __stringify(sp_reg) "\n\t"			\
-	".byte " __stringify(type) "\n\t"			\
-	".byte " __stringify(signal) "\n\t"			\
-	".byte " __stringify(end) "\n\t"			\
-	".balign 4 \n\t"					\
-	".popsection\n\t"
-
 /*
  * This macro marks the given function's stack frame as "non-standard", which
  * tells objtool to ignore the function when doing stack metadata validation.
@@ -110,41 +79,6 @@ struct unwind_hint {
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
-.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0 end=0
-.Lunwind_hint_ip_\@:
-	.pushsection .discard.unwind_hints
-		/* struct unwind_hint */
-		.long .Lunwind_hint_ip_\@ - .
-		.short \sp_offset
-		.byte \sp_reg
-		.byte \type
-		.byte \signal
-		.byte \end
-		.balign 4
-	.popsection
-.endm
-
 .macro STACK_FRAME_NON_STANDARD func:req
 	.pushsection .discard.func_stack_frame_non_standard, "aw"
 	_ASM_PTR \func
@@ -177,16 +111,12 @@ struct unwind_hint {
 
 #ifndef __ASSEMBLY__
 
-#define UNWIND_HINT(sp_reg, sp_offset, type, signal, end) \
-	"\n\t"
 #define STACK_FRAME_NON_STANDARD(func)
 #define STACK_FRAME_NON_STANDARD_FP(func)
 #define ANNOTATE_NOENDBR
 #define ASM_REACHABLE
 #else
 #define ANNOTATE_INTRA_FUNCTION_CALL
-.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0 end=0
-.endm
 .macro STACK_FRAME_NON_STANDARD func:req
 .endm
 .macro ANNOTATE_NOENDBR
diff --git a/tools/objtool/Build b/tools/objtool/Build
index 64ccae49cd5f..4e9ec210f134 100644
--- a/tools/objtool/Build
+++ b/tools/objtool/Build
@@ -8,6 +8,7 @@ objtool-y += builtin-check.o
 objtool-y += cfi.o
 objtool-y += insn.o
 objtool-y += decode.o
+objtool-y += unwind_hints.o
 objtool-y += elf.o
 objtool-y += objtool.o
 
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 26ed9b0b8f49..f91723010d6b 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1842,103 +1842,6 @@ static int add_jump_table_alts(struct objtool_file *file)
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
-		if (hint->type == UNWIND_HINT_TYPE_SAVE) {
-			insn->hint = false;
-			insn->save = true;
-			continue;
-		}
-
-		if (hint->type == UNWIND_HINT_TYPE_RESTORE) {
-			insn->restore = true;
-			continue;
-		}
-
-		if (hint->type == UNWIND_HINT_TYPE_REGS_PARTIAL) {
-			struct symbol *sym = find_symbol_by_offset(insn->sec, insn->offset);
-
-			if (sym && sym->bind == STB_GLOBAL) {
-				if (opts.ibt && insn->type != INSN_ENDBR && !insn->noendbr) {
-					WARN_FUNC("UNWIND_HINT_IRET_REGS without ENDBR",
-						  insn->sec, insn->offset);
-				}
-
-				insn->entry = 1;
-			}
-		}
-
-		if (hint->type == UNWIND_HINT_TYPE_ENTRY) {
-			hint->type = UNWIND_HINT_TYPE_CALL;
-			insn->entry = 1;
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
-		cfi.cfa.offset = bswap_if_needed(file->elf, hint->sp_offset);
-		cfi.type = hint->type;
-		cfi.signal = hint->signal;
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
index 92f8f1ff6c09..0b37d72f06eb 100644
--- a/tools/objtool/include/objtool/insn.h
+++ b/tools/objtool/include/objtool/insn.h
@@ -128,6 +128,7 @@ bool is_first_func_insn(struct objtool_file *file,
 
 
 int decode_instructions(struct objtool_file *file);
+int read_unwind_hints(struct objtool_file *file);
 
 #define for_each_insn(file, insn)					\
 	for (struct section *__sec, *__fake = (struct section *)1;	\
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
index 000000000000..a5aaeaafc16e
--- /dev/null
+++ b/tools/objtool/unwind_hints.c
@@ -0,0 +1,107 @@
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
+		if (hint->type == UNWIND_HINT_TYPE_SAVE) {
+			insn->hint = false;
+			insn->save = true;
+			continue;
+		}
+
+		if (hint->type == UNWIND_HINT_TYPE_RESTORE) {
+			insn->restore = true;
+			continue;
+		}
+
+		if (hint->type == UNWIND_HINT_TYPE_REGS_PARTIAL) {
+			struct symbol *sym = find_symbol_by_offset(insn->sec, insn->offset);
+
+			if (sym && sym->bind == STB_GLOBAL) {
+				if (opts.ibt && insn->type != INSN_ENDBR && !insn->noendbr) {
+					WARN_FUNC("UNWIND_HINT_IRET_REGS without ENDBR",
+						  insn->sec, insn->offset);
+				}
+
+				insn->entry = 1;
+			}
+		}
+
+		if (hint->type == UNWIND_HINT_TYPE_ENTRY) {
+			hint->type = UNWIND_HINT_TYPE_CALL;
+			insn->entry = 1;
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
+		cfi.cfa.offset = bswap_if_needed(file->elf, hint->sp_offset);
+		cfi.type = hint->type;
+		cfi.signal = hint->signal;
+		cfi.end = hint->end;
+
+		insn->cfi = cfi_hash_find_or_add(&cfi);
+	}
+
+	return 0;
+}
-- 
2.39.2

