Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE3473653A
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 09:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbjFTHuZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 03:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjFTHuU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 03:50:20 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D3B681BB;
        Tue, 20 Jun 2023 00:50:01 -0700 (PDT)
Received: from loongson.cn (unknown [113.200.148.30])
        by gateway (Coremail) with SMTP id _____8AxEekoWpFkTxsHAA--.12533S3;
        Tue, 20 Jun 2023 15:50:00 +0800 (CST)
Received: from bogon.localdomain (unknown [113.200.148.30])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxG8oiWpFkN2chAA--.19346S6;
        Tue, 20 Jun 2023 15:49:59 +0800 (CST)
From:   Youling Tang <tangyouling@loongson.cn>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        madvenka@linux.microsoft.com
Cc:     chenzhongjin@huawei.com, WANG Xuerui <kernel@xen0n.name>,
        Xi Ruoyao <xry111@xry111.site>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        tangyouling00@gmail.com, youling.tang@outlook.com,
        Jinyang He <hejinyang@loongson.cn>
Subject: [RFC PATCH v1 09/23] objtool: LoongArch: Add base definition for LoongArch
Date:   Tue, 20 Jun 2023 15:49:50 +0800
Message-Id: <1687247390-31979-5-git-send-email-tangyouling@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1687247390-31979-1-git-send-email-tangyouling@loongson.cn>
References: <1687247390-31979-1-git-send-email-tangyouling@loongson.cn>
X-CM-TRANSID: AQAAf8CxG8oiWpFkN2chAA--.19346S6
X-CM-SenderInfo: 5wdqw5prxox03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoW3XF1kAr4kZw47CFy7XF1xCrX_yoWfJrW8pF
        1DCrZ7GF48WryfGw1Ut3W5urZ8Gan7ury2ga47Wry8ZFZrXrykJrs2yryDAFyrXwsYgryI
        grnag3WYyF48tabCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUBKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E
        14v26r4UJVWxJr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6x
        kI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v2
        6Fy26r45twAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2
        IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC
        6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s
        026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF
        0xvE2Ix0cI8IcVAFwI0_tr0E3s1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIx
        AIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26F4j6r4UJwCI42IY6I8E
        87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU0hjjDUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Provide needed definitions for a new architecture instruction decoder.
No proper decoding is done yet.

There is currently no unwind hint implementation added, the unwind_hints.h
file is added only to avoid build errors.

Co-developed-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Youling Tang <tangyouling@loongson.cn>
---
 .../arch/loongarch/include/asm/unwind_hints.h |  24 ++++
 tools/objtool/Makefile                        |   4 +
 tools/objtool/arch/loongarch/Build            |   2 +
 tools/objtool/arch/loongarch/decode.c         | 125 ++++++++++++++++++
 .../arch/loongarch/include/arch/cfi_regs.h    |  14 ++
 .../objtool/arch/loongarch/include/arch/elf.h |  15 +++
 .../arch/loongarch/include/arch/special.h     |  21 +++
 tools/objtool/arch/loongarch/special.c        |  20 +++
 8 files changed, 225 insertions(+)
 create mode 100644 tools/arch/loongarch/include/asm/unwind_hints.h
 create mode 100644 tools/objtool/arch/loongarch/Build
 create mode 100644 tools/objtool/arch/loongarch/decode.c
 create mode 100644 tools/objtool/arch/loongarch/include/arch/cfi_regs.h
 create mode 100644 tools/objtool/arch/loongarch/include/arch/elf.h
 create mode 100644 tools/objtool/arch/loongarch/include/arch/special.h
 create mode 100644 tools/objtool/arch/loongarch/special.c

diff --git a/tools/arch/loongarch/include/asm/unwind_hints.h b/tools/arch/loongarch/include/asm/unwind_hints.h
new file mode 100644
index 000000000000..ac48ee34bf7b
--- /dev/null
+++ b/tools/arch/loongarch/include/asm/unwind_hints.h
@@ -0,0 +1,24 @@
+#ifndef _ASM_LOONGARCH_UNWIND_HINTS_H
+#define _ASM_LOONGARCH_UNWIND_HINTS_H
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
+#endif /* _ASM_LOONGARCH_UNWIND_HINTS_H */
diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index 2262b49691b8..034fbd9f3f13 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -58,6 +58,10 @@ ifeq ($(SRCARCH),x86)
 	STATIC_CHECK := y
 endif
 
+ifeq ($(SRCARCH),loongarch)
+	STATIC_CHECK := y
+endif
+
 export BUILD_ORC STATIC_CHECK
 export srctree OUTPUT CFLAGS SRCARCH AWK
 include $(srctree)/tools/build/Makefile.include
diff --git a/tools/objtool/arch/loongarch/Build b/tools/objtool/arch/loongarch/Build
new file mode 100644
index 000000000000..d24d5636a5b8
--- /dev/null
+++ b/tools/objtool/arch/loongarch/Build
@@ -0,0 +1,2 @@
+objtool-y += decode.o
+objtool-y += special.o
diff --git a/tools/objtool/arch/loongarch/decode.c b/tools/objtool/arch/loongarch/decode.c
new file mode 100644
index 000000000000..3f795f57e914
--- /dev/null
+++ b/tools/objtool/arch/loongarch/decode.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <stdio.h>
+#include <stdlib.h>
+
+#include <asm/inst.h>
+
+#include <objtool/check.h>
+#include <objtool/elf.h>
+#include <objtool/arch.h>
+#include <objtool/warn.h>
+#include <objtool/builtin.h>
+#include <objtool/endianness.h>
+#include <arch/cfi_regs.h>
+
+int arch_ftrace_match(char *name)
+{
+	return !strcmp(name, "_mcount");
+}
+
+static int is_loongarch(const struct elf *elf)
+{
+	if (elf->ehdr.e_machine == EM_LOONGARCH)
+		return 1;
+
+	WARN("unexpected ELF machine type %d", elf->ehdr.e_machine);
+	return 0;
+}
+
+unsigned long arch_dest_reloc_offset(int addend)
+{
+	return addend;
+}
+
+bool arch_callee_saved_reg(unsigned char reg)
+{
+	switch (reg) {
+	case LOONGARCH_GPR_S0 ... LOONGARCH_GPR_S8:
+	case LOONGARCH_GPR_FP:
+	case LOONGARCH_GPR_RA:
+		return true;
+	default:
+		return false;
+	}
+}
+
+int arch_decode_hint_reg(u8 sp_reg, int *base)
+{
+	exit(-1);
+}
+
+const char *arch_nop_insn(int len)
+{
+	static u32 nop;
+
+	if (len != LOONGARCH_INSN_SIZE)
+		WARN("invalid NOP size: %d\n", len);
+
+	nop = LOONGARCH_INSN_NOP;
+
+	return (const char *)&nop;
+}
+
+const char *arch_ret_insn(int len)
+{
+	static u32 ret;
+
+	if (len != LOONGARCH_INSN_SIZE)
+		WARN("invalid RET size: %d\n", len);
+
+	emit_jirl((union loongarch_instruction *)&ret, LOONGARCH_GPR_RA,
+		  LOONGARCH_GPR_ZERO, 0);
+
+	return (const char *)&ret;
+}
+
+int arch_decode_instruction(struct objtool_file *file, const struct section *sec,
+			    unsigned long offset, unsigned int maxlen,
+			    struct instruction *insn)
+{
+	const struct elf *elf = file->elf;
+	union loongarch_instruction inst;
+
+	if (!is_loongarch(elf))
+		return -1;
+
+	if (maxlen < LOONGARCH_INSN_SIZE)
+		return 0;
+
+	insn->len = LOONGARCH_INSN_SIZE;
+	insn->type = INSN_OTHER;
+	insn->immediate = 0;
+
+	inst = *(union loongarch_instruction *)(sec->data->d_buf + offset);
+
+	/* For some where we .fill 0 and we cannot execute it. */
+	if (inst.word == 0)
+		insn->type = INSN_NOP;
+
+	return 0;
+}
+
+unsigned long arch_jump_destination(struct instruction *insn)
+{
+	return insn->offset + insn->immediate * 4;
+}
+
+bool arch_pc_relative_reloc(struct reloc *reloc)
+{
+	return false;
+}
+
+void arch_initial_func_cfi_state(struct cfi_init_state *state)
+{
+	int i;
+
+	for (i = 0; i < CFI_NUM_REGS; i++) {
+		state->regs[i].base = CFI_UNDEFINED;
+		state->regs[i].offset = 0;
+	}
+
+	/* initial CFA (call frame address) */
+	state->cfa.base = CFI_SP;
+	state->cfa.offset = 0;
+}
diff --git a/tools/objtool/arch/loongarch/include/arch/cfi_regs.h b/tools/objtool/arch/loongarch/include/arch/cfi_regs.h
new file mode 100644
index 000000000000..8077287066af
--- /dev/null
+++ b/tools/objtool/arch/loongarch/include/arch/cfi_regs.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _OBJTOOL_CFI_REGS_H
+#define _OBJTOOL_CFI_REGS_H
+
+#include <asm/inst.h>
+
+#define CFI_RA		LOONGARCH_GPR_RA
+#define CFI_SP		LOONGARCH_GPR_SP
+#define CFI_FP		LOONGARCH_GPR_FP
+#define CFI_BP		CFI_FP
+#define CFI_NUM_REGS	32
+
+#endif /* _OBJTOOL_CFI_REGS_H */
diff --git a/tools/objtool/arch/loongarch/include/arch/elf.h b/tools/objtool/arch/loongarch/include/arch/elf.h
new file mode 100644
index 000000000000..6a3ec9bf3fd2
--- /dev/null
+++ b/tools/objtool/arch/loongarch/include/arch/elf.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _OBJTOOL_ARCH_ELF
+#define _OBJTOOL_ARCH_ELF
+
+#ifndef R_LARCH_32_PCREL
+#define R_LARCH_32_PCREL 99
+#endif
+
+#define R_NONE R_LARCH_NONE
+#define R_ABS64 R_LARCH_64
+#define R_ABS32 R_LARCH_32
+#define R_PCREL R_LARCH_32_PCREL
+
+#endif /* _OBJTOOL_ARCH_ELF */
diff --git a/tools/objtool/arch/loongarch/include/arch/special.h b/tools/objtool/arch/loongarch/include/arch/special.h
new file mode 100644
index 000000000000..fa07a3616288
--- /dev/null
+++ b/tools/objtool/arch/loongarch/include/arch/special.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _LOONGARCH_ARCH_SPECIAL_H
+#define _LOONGARCH_ARCH_SPECIAL_H
+
+#define EX_ENTRY_SIZE 12
+#define EX_ORIG_OFFSET 0
+#define EX_NEW_OFFSET 4
+
+#define JUMP_ENTRY_SIZE 16
+#define JUMP_ORIG_OFFSET 0
+#define JUMP_NEW_OFFSET 4
+#define JUMP_KEY_OFFSET 8
+
+#define ALT_ENTRY_SIZE 12
+#define ALT_ORIG_OFFSET 0
+#define ALT_NEW_OFFSET 4
+#define ALT_FEATURE_OFFSET 8
+#define ALT_ORIG_LEN_OFFSET 10
+#define ALT_NEW_LEN_OFFSET 11
+
+#endif /* _LOONGARCH_ARCH_SPECIAL_H */
diff --git a/tools/objtool/arch/loongarch/special.c b/tools/objtool/arch/loongarch/special.c
new file mode 100644
index 000000000000..8669dbe44459
--- /dev/null
+++ b/tools/objtool/arch/loongarch/special.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <string.h>
+#include <stdlib.h>
+#include <objtool/special.h>
+#include <objtool/builtin.h>
+
+
+bool arch_support_alt_relocation(struct special_alt *special_alt,
+				 struct instruction *insn,
+				 struct reloc *reloc)
+{
+	return NULL;
+}
+
+struct reloc *arch_find_switch_table(struct objtool_file *file,
+				    struct instruction *insn)
+{
+	return NULL;
+}
-- 
2.39.2

