Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D42468769F
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 08:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbjBBHnW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 02:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbjBBHm5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 02:42:57 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD2E684B5D;
        Wed,  1 Feb 2023 23:42:40 -0800 (PST)
Received: from x64host.home (unknown [47.187.213.40])
        by linux.microsoft.com (Postfix) with ESMTPSA id A0C5E20B2EE1;
        Wed,  1 Feb 2023 23:42:39 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A0C5E20B2EE1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675323760;
        bh=y3qsADNio9+dY4UdeX2rS9vahgQ8I1RdPk9wpVWAKKk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=QbCigbfUQUdYrfpoaBfqtidMu56nuRH8VwMDzxOyNicKedC4AWx9LpldEKyQxKxYE
         mrudZPVymG6n0BhuyUinr0jgeJ1ftU9C8w3mCRm4yOaWtLQR6/rfCt+hB9JiQclgrU
         OTmcCV9iRRFgQ6KhBHfjiw3/FbGTxWUucTHWyd7U=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 15/22] objtool: arm64: Add unwind hint support
Date:   Thu,  2 Feb 2023 01:40:29 -0600
Message-Id: <20230202074036.507249-16-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202074036.507249-1-madvenka@linux.microsoft.com>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
 include/linux/objtool.h                     |   3 +
 tools/arch/arm64/include/asm/unwind_hints.h | 104 ++++++++++++++++++++
 tools/include/linux/objtool.h               |   3 +
 tools/objtool/Build                         |   2 +-
 tools/objtool/arch/arm64/decode.c           |  21 ++++
 tools/objtool/arch/arm64/orc.c              |   4 +
 tools/objtool/dcheck.c                      |   4 +
 tools/objtool/include/objtool/endianness.h  |   1 +
 tools/objtool/sync-check.sh                 |   1 +
 tools/objtool/unwind_hints.c                |  24 +++--
 11 files changed, 260 insertions(+), 11 deletions(-)
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
index 1af295efc12c..dcbd365944f6 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -17,6 +17,8 @@
  * Useful for code which doesn't have an ELF function annotation.
  *
  * UNWIND_HINT_ENTRY: machine entry without stack, SYSCALL/SYSENTER etc.
+ *
+ * UNWIND_HINT_TYPE_IRQ_STACK: Used to unwind through the IRQ stack.
  */
 #define UNWIND_HINT_TYPE_CALL		0
 #define UNWIND_HINT_TYPE_REGS		1
@@ -25,6 +27,7 @@
 #define UNWIND_HINT_TYPE_ENTRY		4
 #define UNWIND_HINT_TYPE_SAVE		5
 #define UNWIND_HINT_TYPE_RESTORE	6
+#define UNWIND_HINT_TYPE_IRQ_STACK	7
 
 #ifdef CONFIG_OBJTOOL
 
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
index 1af295efc12c..dcbd365944f6 100644
--- a/tools/include/linux/objtool.h
+++ b/tools/include/linux/objtool.h
@@ -17,6 +17,8 @@
  * Useful for code which doesn't have an ELF function annotation.
  *
  * UNWIND_HINT_ENTRY: machine entry without stack, SYSCALL/SYSENTER etc.
+ *
+ * UNWIND_HINT_TYPE_IRQ_STACK: Used to unwind through the IRQ stack.
  */
 #define UNWIND_HINT_TYPE_CALL		0
 #define UNWIND_HINT_TYPE_REGS		1
@@ -25,6 +27,7 @@
 #define UNWIND_HINT_TYPE_ENTRY		4
 #define UNWIND_HINT_TYPE_SAVE		5
 #define UNWIND_HINT_TYPE_RESTORE	6
+#define UNWIND_HINT_TYPE_IRQ_STACK	7
 
 #ifdef CONFIG_OBJTOOL
 
diff --git a/tools/objtool/Build b/tools/objtool/Build
index fb0846b7d95e..2780e402babb 100644
--- a/tools/objtool/Build
+++ b/tools/objtool/Build
@@ -9,7 +9,7 @@ objtool-y += builtin-check.o
 objtool-y += cfi.o
 objtool-y += insn.o
 objtool-y += decode.o
-objtool-$(STATIC_CHECK) += unwind_hints.o
+objtool-y += unwind_hints.o
 objtool-y += elf.o
 objtool-y += objtool.o
 
diff --git a/tools/objtool/arch/arm64/decode.c b/tools/objtool/arch/arm64/decode.c
index f723be80c09a..570069ac68ae 100644
--- a/tools/objtool/arch/arm64/decode.c
+++ b/tools/objtool/arch/arm64/decode.c
@@ -17,6 +17,8 @@
 #include <objtool/elf.h>
 #include <objtool/warn.h>
 
+#include <asm/orc_types.h>
+
 /* ARM64 instructions are all 4 bytes wide. */
 #define INSN_SIZE	4
 
@@ -47,6 +49,25 @@ unsigned long arch_jump_destination(struct instruction *insn)
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
 /* --------------------- instruction decode structs ------------------------ */
 
 struct decode_var {
diff --git a/tools/objtool/arch/arm64/orc.c b/tools/objtool/arch/arm64/orc.c
index cef14114e1ec..5b155585258a 100644
--- a/tools/objtool/arch/arm64/orc.c
+++ b/tools/objtool/arch/arm64/orc.c
@@ -57,6 +57,10 @@ const char *orc_type_name(unsigned int type)
 	switch (type) {
 	case UNWIND_HINT_TYPE_CALL:
 		return "call";
+	case UNWIND_HINT_TYPE_REGS:
+		return "regs";
+	case UNWIND_HINT_TYPE_IRQ_STACK:
+		return "irqstack";
 	default:
 		return "?";
 	}
diff --git a/tools/objtool/dcheck.c b/tools/objtool/dcheck.c
index 57499752c523..567f492b0e3e 100644
--- a/tools/objtool/dcheck.c
+++ b/tools/objtool/dcheck.c
@@ -349,6 +349,10 @@ int check(struct objtool_file *file)
 
 	walk_sections(file);
 
+	ret = read_unwind_hints(file);
+	if (ret)
+		return ret;
+
 	if (opts.orc)
 		ret = orc_create(file);
 
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
index f2521659bae5..c51013c5d0b3 100644
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
@@ -52,18 +56,18 @@ int read_unwind_hints(struct objtool_file *file)
 
 		insn->hint = true;
 
-		if (hint->type == UNWIND_HINT_TYPE_SAVE) {
+		if (type == UNWIND_HINT_TYPE_SAVE) {
 			insn->hint = false;
 			insn->save = true;
 			continue;
 		}
 
-		if (hint->type == UNWIND_HINT_TYPE_RESTORE) {
+		if (type == UNWIND_HINT_TYPE_RESTORE) {
 			insn->restore = true;
 			continue;
 		}
 
-		if (hint->type == UNWIND_HINT_TYPE_REGS_PARTIAL) {
+		if (type == UNWIND_HINT_TYPE_REGS_PARTIAL) {
 			struct symbol *sym = find_symbol_by_offset(insn->sec, insn->offset);
 
 			if (sym && sym->bind == STB_GLOBAL) {
@@ -76,12 +80,12 @@ int read_unwind_hints(struct objtool_file *file)
 			}
 		}
 
-		if (hint->type == UNWIND_HINT_TYPE_ENTRY) {
-			hint->type = UNWIND_HINT_TYPE_CALL;
+		if (type == UNWIND_HINT_TYPE_ENTRY) {
+			type = UNWIND_HINT_TYPE_CALL;
 			insn->entry = 1;
 		}
 
-		if (hint->type == UNWIND_HINT_TYPE_FUNC) {
+		if (type == UNWIND_HINT_TYPE_FUNC) {
 			insn->cfi = &func_cfi;
 			continue;
 		}
@@ -89,15 +93,15 @@ int read_unwind_hints(struct objtool_file *file)
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

