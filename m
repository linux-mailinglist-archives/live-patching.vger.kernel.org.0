Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74D3531FB0
	for <lists+live-patching@lfdr.de>; Tue, 24 May 2022 02:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbiEXARR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 23 May 2022 20:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbiEXARH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 23 May 2022 20:17:07 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B0DD0880DF;
        Mon, 23 May 2022 17:17:01 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8477D20B71D5;
        Mon, 23 May 2022 17:17:00 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8477D20B71D5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1653351421;
        bh=h2BRZVfqw9e4ZLjkYIMOXm6ORlgnxhf1dKgvX5B6Qfk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=eWWAIR0crFm1ImkNRj3/EvKHk/8ZsWs1Wl26TlJ6GKSxhomuoBentuNI2GAVBasJK
         WgLvyRwsVOBSOkdZeTVyNSo4uDGKvbgV9xuc1TAynForPTj/5/l98+vvxgJ9+QNNur
         68deLiw4HismEjRk1sihGH5ciaG7ucfamQOKgb0Y=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 14/20] objtool: arm64: Add unwind hint support
Date:   Mon, 23 May 2022 19:16:31 -0500
Message-Id: <20220524001637.1707472-15-madvenka@linux.microsoft.com>
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

Implement the unwind hint macros for ARM64. Define the unwind hint types
as well.

Process the unwind hints section for dynamic FP validation for ARM64.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/unwind_hints.h       | 104 ++++++++++++++++++++
 include/linux/objtool.h                     |   6 ++
 tools/arch/arm64/include/asm/unwind_hints.h | 104 ++++++++++++++++++++
 tools/include/linux/objtool.h               |   6 ++
 tools/objtool/Build                         |   1 +
 tools/objtool/arch/arm64/decode.c           |  20 ++++
 tools/objtool/arch/arm64/orc.c              |   6 ++
 tools/objtool/fpv.c                         |   4 +
 tools/objtool/include/objtool/endianness.h  |   1 +
 tools/objtool/sync-check.sh                 |   1 +
 tools/objtool/unwind_hints.c                |  16 +--
 11 files changed, 263 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm64/include/asm/unwind_hints.h
 create mode 100644 tools/arch/arm64/include/asm/unwind_hints.h

diff --git a/arch/arm64/include/asm/unwind_hints.h b/arch/arm64/include/asm/unwind_hints.h
new file mode 100644
index 000000000000..fb1b924d85bc
--- /dev/null
+++ b/arch/arm64/include/asm/unwind_hints.h
@@ -0,0 +1,104 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASM_ARM64_UNWIND_HINTS_H
+#define _ASM_ARM64_UNWIND_HINTS_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+
+/*
+ * This struct is used by asm and inline asm code to manually annotate the
+ * CFI for an instruction. We have to use s16 instead of s8 for some of these
+ * fields as 8-bit fields are not relocated by some assemblers.
+ */
+struct unwind_hint {
+	u32		ip;
+	s16		sp_offset;
+	s16		sp_reg;
+	s16		type;
+	s16		end;
+};
+
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
+	".short " __stringify(sp_reg) "\n\t"			\
+	".short " __stringify(type) "\n\t"			\
+	".short " __stringify(end) "\n\t"			\
+	".popsection\n\t"
+
+#else /* __ASSEMBLY__ */
+
+/*
+ * There are points in ASM code where it is useful to unwind through even
+ * though the ASM code itself may be unreliable from an unwind perspective.
+ * E.g., interrupt and exception handlers.
+ *
+ * These macros provide hints to objtool to compute the CFI information at
+ * such instructions.
+ */
+.macro UNWIND_HINT sp_reg:req sp_offset=0 type:req end=0
+.Lunwind_hint_pc_\@:
+	.pushsection .discard.unwind_hints
+		/* struct unwind_hint */
+		.long .Lunwind_hint_pc_\@ - .
+		.short \sp_offset
+		.short \sp_reg
+		.short \type
+		.short \end
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
+#ifdef __ASSEMBLY__
+
+.macro UNWIND_HINT_FTRACE, offset
+	.set sp_reg, ORC_REG_SP
+	.set sp_offset, \offset
+	.set type, UNWIND_HINT_TYPE_FTRACE
+	UNWIND_HINT sp_reg=sp_reg sp_offset=sp_offset type=type
+.endm
+
+.macro UNWIND_HINT_REGS, offset
+	.set sp_reg, ORC_REG_SP
+	.set sp_offset, \offset
+	.set type, UNWIND_HINT_TYPE_REGS
+	UNWIND_HINT sp_reg=sp_reg sp_offset=sp_offset type=type
+.endm
+
+.macro UNWIND_HINT_IRQ, offset
+	.set sp_reg, ORC_REG_SP
+	.set sp_offset, \offset
+	.set type, UNWIND_HINT_TYPE_IRQ_STACK
+	UNWIND_HINT sp_reg=sp_reg sp_offset=sp_offset type=type
+.endm
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_ARM64_UNWIND_HINTS_H */
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index 00bb449777d0..c28e3cff3b83 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -15,11 +15,17 @@
  *
  * UNWIND_HINT_FUNC: Generate the unwind metadata of a callable function.
  * Useful for code which doesn't have an ELF function annotation.
+ *
+ * UNWIND_HINT_TYPE_FTRACE: Used to unwind through an ftrace callsite.
+ *
+ * UNWIND_HINT_TYPE_IRQ_STACK: Used to unwind through the IRQ stack.
  */
 #define UNWIND_HINT_TYPE_CALL		0
 #define UNWIND_HINT_TYPE_REGS		1
 #define UNWIND_HINT_TYPE_REGS_PARTIAL	2
 #define UNWIND_HINT_TYPE_FUNC		3
+#define UNWIND_HINT_TYPE_FTRACE		4
+#define UNWIND_HINT_TYPE_IRQ_STACK	5
 
 #ifdef CONFIG_STACK_VALIDATION
 
diff --git a/tools/arch/arm64/include/asm/unwind_hints.h b/tools/arch/arm64/include/asm/unwind_hints.h
new file mode 100644
index 000000000000..fb1b924d85bc
--- /dev/null
+++ b/tools/arch/arm64/include/asm/unwind_hints.h
@@ -0,0 +1,104 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASM_ARM64_UNWIND_HINTS_H
+#define _ASM_ARM64_UNWIND_HINTS_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+
+/*
+ * This struct is used by asm and inline asm code to manually annotate the
+ * CFI for an instruction. We have to use s16 instead of s8 for some of these
+ * fields as 8-bit fields are not relocated by some assemblers.
+ */
+struct unwind_hint {
+	u32		ip;
+	s16		sp_offset;
+	s16		sp_reg;
+	s16		type;
+	s16		end;
+};
+
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
+	".short " __stringify(sp_reg) "\n\t"			\
+	".short " __stringify(type) "\n\t"			\
+	".short " __stringify(end) "\n\t"			\
+	".popsection\n\t"
+
+#else /* __ASSEMBLY__ */
+
+/*
+ * There are points in ASM code where it is useful to unwind through even
+ * though the ASM code itself may be unreliable from an unwind perspective.
+ * E.g., interrupt and exception handlers.
+ *
+ * These macros provide hints to objtool to compute the CFI information at
+ * such instructions.
+ */
+.macro UNWIND_HINT sp_reg:req sp_offset=0 type:req end=0
+.Lunwind_hint_pc_\@:
+	.pushsection .discard.unwind_hints
+		/* struct unwind_hint */
+		.long .Lunwind_hint_pc_\@ - .
+		.short \sp_offset
+		.short \sp_reg
+		.short \type
+		.short \end
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
+#ifdef __ASSEMBLY__
+
+.macro UNWIND_HINT_FTRACE, offset
+	.set sp_reg, ORC_REG_SP
+	.set sp_offset, \offset
+	.set type, UNWIND_HINT_TYPE_FTRACE
+	UNWIND_HINT sp_reg=sp_reg sp_offset=sp_offset type=type
+.endm
+
+.macro UNWIND_HINT_REGS, offset
+	.set sp_reg, ORC_REG_SP
+	.set sp_offset, \offset
+	.set type, UNWIND_HINT_TYPE_REGS
+	UNWIND_HINT sp_reg=sp_reg sp_offset=sp_offset type=type
+.endm
+
+.macro UNWIND_HINT_IRQ, offset
+	.set sp_reg, ORC_REG_SP
+	.set sp_offset, \offset
+	.set type, UNWIND_HINT_TYPE_IRQ_STACK
+	UNWIND_HINT sp_reg=sp_reg sp_offset=sp_offset type=type
+.endm
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_ARM64_UNWIND_HINTS_H */
diff --git a/tools/include/linux/objtool.h b/tools/include/linux/objtool.h
index 00bb449777d0..c28e3cff3b83 100644
--- a/tools/include/linux/objtool.h
+++ b/tools/include/linux/objtool.h
@@ -15,11 +15,17 @@
  *
  * UNWIND_HINT_FUNC: Generate the unwind metadata of a callable function.
  * Useful for code which doesn't have an ELF function annotation.
+ *
+ * UNWIND_HINT_TYPE_FTRACE: Used to unwind through an ftrace callsite.
+ *
+ * UNWIND_HINT_TYPE_IRQ_STACK: Used to unwind through the IRQ stack.
  */
 #define UNWIND_HINT_TYPE_CALL		0
 #define UNWIND_HINT_TYPE_REGS		1
 #define UNWIND_HINT_TYPE_REGS_PARTIAL	2
 #define UNWIND_HINT_TYPE_FUNC		3
+#define UNWIND_HINT_TYPE_FTRACE		4
+#define UNWIND_HINT_TYPE_IRQ_STACK	5
 
 #ifdef CONFIG_STACK_VALIDATION
 
diff --git a/tools/objtool/Build b/tools/objtool/Build
index d40ee95039cf..4a57d7c7d31e 100644
--- a/tools/objtool/Build
+++ b/tools/objtool/Build
@@ -19,6 +19,7 @@ objtool-$(SUBCMD_FPV) += fpv.o
 objtool-$(SUBCMD_FPV) += cfi.o
 objtool-$(SUBCMD_FPV) += insn.o
 objtool-$(SUBCMD_FPV) += decode.o
+objtool-$(SUBCMD_FPV) += unwind_hints.o
 objtool-$(SUBCMD_FPV) += orc_gen.o
 objtool-$(SUBCMD_FPV) += orc_dump.o
 
diff --git a/tools/objtool/arch/arm64/decode.c b/tools/objtool/arch/arm64/decode.c
index 93ef7c0811f1..d3c650ca044e 100644
--- a/tools/objtool/arch/arm64/decode.c
+++ b/tools/objtool/arch/arm64/decode.c
@@ -15,6 +15,7 @@
 #include <objtool/elf.h>
 #include <objtool/warn.h>
 #include <arch/cfi_regs.h>
+#include <asm/orc_types.h>
 
 /* ARM64 instructions are all 4 bytes wide. */
 #define INSN_SIZE	4
@@ -60,6 +61,25 @@ unsigned long arch_jump_destination(struct instruction *insn)
 	return insn->offset + insn->immediate;
 }
 
+int arch_decode_hint_reg(u8 sp_reg, int *base)
+{
+	switch (sp_reg) {
+	case ORC_REG_UNDEFINED:
+		*base = CFI_UNDEFINED;
+		break;
+	case ORC_REG_SP:
+		*base = CFI_SP;
+		break;
+	case ORC_REG_FP:
+		*base = CFI_FP;
+		break;
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
 /* --------------------- miscellaneous functions --------------------------- */
 
 static void reg_check(unsigned int sp_check, unsigned int fp_check,
diff --git a/tools/objtool/arch/arm64/orc.c b/tools/objtool/arch/arm64/orc.c
index cef14114e1ec..fecbed12b3f1 100644
--- a/tools/objtool/arch/arm64/orc.c
+++ b/tools/objtool/arch/arm64/orc.c
@@ -57,6 +57,12 @@ const char *orc_type_name(unsigned int type)
 	switch (type) {
 	case UNWIND_HINT_TYPE_CALL:
 		return "call";
+	case UNWIND_HINT_TYPE_REGS:
+		return "regs";
+	case UNWIND_HINT_TYPE_FTRACE:
+		return "ftrace";
+	case UNWIND_HINT_TYPE_IRQ_STACK:
+		return "irqstack";
 	default:
 		return "?";
 	}
diff --git a/tools/objtool/fpv.c b/tools/objtool/fpv.c
index 52f613ae998f..346e0de787f3 100644
--- a/tools/objtool/fpv.c
+++ b/tools/objtool/fpv.c
@@ -257,6 +257,10 @@ int fpv_decode(struct objtool_file *file)
 
 	add_jump_destinations(file);
 
+	ret = read_unwind_hints(file);
+	if (ret)
+		return ret;
+
 	if (!list_empty(&file->insn_list)) {
 		fill = false;
 		walk_sections(file);
diff --git a/tools/objtool/include/objtool/endianness.h b/tools/objtool/include/objtool/endianness.h
index 10241341eff3..9a53ab421a19 100644
--- a/tools/objtool/include/objtool/endianness.h
+++ b/tools/objtool/include/objtool/endianness.h
@@ -29,6 +29,7 @@
 	case 8: __ret = __NEED_BSWAP ? bswap_64(val) : (val); break;	\
 	case 4: __ret = __NEED_BSWAP ? bswap_32(val) : (val); break;	\
 	case 2: __ret = __NEED_BSWAP ? bswap_16(val) : (val); break;	\
+	case 1: __ret = (val); break;					\
 	default:							\
 		BUILD_BUG(); break;					\
 	}								\
diff --git a/tools/objtool/sync-check.sh b/tools/objtool/sync-check.sh
index 0d0656f6ce4a..3742d1e2585c 100755
--- a/tools/objtool/sync-check.sh
+++ b/tools/objtool/sync-check.sh
@@ -31,6 +31,7 @@ fi
 
 if [ "$SRCARCH" = "arm64" ]; then
 FILES="$FILES
+arch/arm64/include/asm/unwind_hints.h
 arch/arm64/include/asm/orc_types.h
 include/linux/orc_entry.h
 "
diff --git a/tools/objtool/unwind_hints.c b/tools/objtool/unwind_hints.c
index d4e41c67403b..91ceea3f7fd7 100644
--- a/tools/objtool/unwind_hints.c
+++ b/tools/objtool/unwind_hints.c
@@ -16,6 +16,7 @@ int read_unwind_hints(struct objtool_file *file)
 	struct unwind_hint *hint;
 	struct instruction *insn;
 	struct reloc *reloc;
+	u8 sp_reg, type;
 	int i;
 
 	sec = find_section_by_name(file->elf, ".discard.unwind_hints");
@@ -38,6 +39,9 @@ int read_unwind_hints(struct objtool_file *file)
 	for (i = 0; i < sec->sh.sh_size / sizeof(struct unwind_hint); i++) {
 		hint = (struct unwind_hint *)sec->data->d_buf + i;
 
+		sp_reg = bswap_if_needed(hint->sp_reg);
+		type = bswap_if_needed(hint->type);
+
 		reloc = find_reloc_by_dest(file->elf, sec, i * sizeof(*hint));
 		if (!reloc) {
 			WARN("can't find reloc for unwind_hints[%d]", i);
@@ -52,7 +56,7 @@ int read_unwind_hints(struct objtool_file *file)
 
 		insn->hint = true;
 
-		if (ibt && hint->type == UNWIND_HINT_TYPE_REGS_PARTIAL) {
+		if (ibt && type == UNWIND_HINT_TYPE_REGS_PARTIAL) {
 			struct symbol *sym = find_symbol_by_offset(insn->sec, insn->offset);
 
 			if (sym && sym->bind == STB_GLOBAL &&
@@ -62,7 +66,7 @@ int read_unwind_hints(struct objtool_file *file)
 			}
 		}
 
-		if (hint->type == UNWIND_HINT_TYPE_FUNC) {
+		if (type == UNWIND_HINT_TYPE_FUNC) {
 			insn->cfi = &func_cfi;
 			continue;
 		}
@@ -70,15 +74,15 @@ int read_unwind_hints(struct objtool_file *file)
 		if (insn->cfi)
 			cfi = *(insn->cfi);
 
-		if (arch_decode_hint_reg(hint->sp_reg, &cfi.cfa.base)) {
+		if (arch_decode_hint_reg(sp_reg, &cfi.cfa.base)) {
 			WARN_FUNC("unsupported unwind_hint sp base reg %d",
-				  insn->sec, insn->offset, hint->sp_reg);
+				  insn->sec, insn->offset, sp_reg);
 			return -1;
 		}
 
 		cfi.cfa.offset = bswap_if_needed(hint->sp_offset);
-		cfi.type = hint->type;
-		cfi.end = hint->end;
+		cfi.type = type;
+		cfi.end = bswap_if_needed(hint->end);
 
 		insn->cfi = cfi_hash_find_or_add(&cfi);
 	}
-- 
2.25.1

