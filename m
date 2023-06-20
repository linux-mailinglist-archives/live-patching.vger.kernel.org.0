Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06FEA736539
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 09:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbjFTHuY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 03:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbjFTHuT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 03:50:19 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4DFA510E2;
        Tue, 20 Jun 2023 00:49:58 -0700 (PDT)
Received: from loongson.cn (unknown [113.200.148.30])
        by gateway (Coremail) with SMTP id _____8BxL_AkWpFkJxsHAA--.14619S3;
        Tue, 20 Jun 2023 15:49:56 +0800 (CST)
Received: from bogon.localdomain (unknown [113.200.148.30])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxG8oiWpFkN2chAA--.19346S2;
        Tue, 20 Jun 2023 15:49:54 +0800 (CST)
From:   Youling Tang <tangyouling@loongson.cn>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        madvenka@linux.microsoft.com
Cc:     chenzhongjin@huawei.com, WANG Xuerui <kernel@xen0n.name>,
        Xi Ruoyao <xry111@xry111.site>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        tangyouling00@gmail.com, youling.tang@outlook.com
Subject: [RFC PATCH v1 05/23] objtool: Reorganize ORC code
Date:   Tue, 20 Jun 2023 15:49:46 +0800
Message-Id: <1687247390-31979-1-git-send-email-tangyouling@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf8CxG8oiWpFkN2chAA--.19346S2
X-CM-SenderInfo: 5wdqw5prxox03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoWfGF4kGr1kur15XF13GF45urX_yoWkJF4xpF
        n8CrWDGrW7XFy3Awn2qan7u3y5Cws7WryktrnxG34xZ3yIqw1fJrsIkryjvF98Wws5Way3
        uFZIqF4YkF4qvrcCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUBvb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
        wI0_Gr1j6F4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
        xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
        Wrv_ZF1lYx0Ex4A2jsIE14v26F4j6r4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2
        Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
        z7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Ar0_tr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6x
        AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Cr0_Gr1UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jxxhdUUUUU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

The ORC code needs to be reorganized into arch-specific and generic parts
so that architectures other than X86 can avail the generic parts.

Some arch-specific ORC code is present in orc_gen.c and orc_dump.c. Create
the following two files for such code:

        - tools/objtool/include/objtool/orc.h
        - tools/objtool/arch/x86/orc.c

Move the following arch-specific function from tools/objtool/orc_gen.c
to tools/objtool/arch/x86/orc.c:

        - init_orc_entry()

Move the following arch-specific functions from tools/objtool/orc_dump.c
to tools/objtool/arch/x86/orc.c:

        - reg_name()
        - orc_type_name()
        - print_reg()

Create arch-specific functions to print the names of the SP and FP
registers.

The relocation type for relocation entries for ORC structures is
arch-specific. Define it in tools/objtool/arch/x86/include/arch/elf.h:

        #define R_PCREL R_X86_64_PC32

and use that in orc_gen.c so each architecture can provide its own
relocation type.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 tools/objtool/arch/x86/Build              |   1 +
 tools/objtool/arch/x86/include/arch/elf.h |   1 +
 tools/objtool/arch/x86/orc.c              | 151 ++++++++++++++++++++++
 tools/objtool/include/objtool/orc.h       |  18 +++
 tools/objtool/orc_dump.c                  |  63 +--------
 tools/objtool/orc_gen.c                   |  80 +-----------
 6 files changed, 180 insertions(+), 134 deletions(-)
 create mode 100644 tools/objtool/arch/x86/orc.c
 create mode 100644 tools/objtool/include/objtool/orc.h

diff --git a/tools/objtool/arch/x86/Build b/tools/objtool/arch/x86/Build
index 9f7869b5c5e0..77b9a66cd6da 100644
--- a/tools/objtool/arch/x86/Build
+++ b/tools/objtool/arch/x86/Build
@@ -1,5 +1,6 @@
 objtool-y += special.o
 objtool-y += decode.o
+objtool-$(BUILD_ORC) += orc.o
 
 inat_tables_script = ../arch/x86/tools/gen-insn-attr-x86.awk
 inat_tables_maps = ../arch/x86/lib/x86-opcode-map.txt
diff --git a/tools/objtool/arch/x86/include/arch/elf.h b/tools/objtool/arch/x86/include/arch/elf.h
index ac14987cf687..30147417f08c 100644
--- a/tools/objtool/arch/x86/include/arch/elf.h
+++ b/tools/objtool/arch/x86/include/arch/elf.h
@@ -4,5 +4,6 @@
 #define R_NONE R_X86_64_NONE
 #define R_ABS64 R_X86_64_64
 #define R_ABS32 R_X86_64_32
+#define R_PCREL R_X86_64_PC32
 
 #endif /* _OBJTOOL_ARCH_ELF */
diff --git a/tools/objtool/arch/x86/orc.c b/tools/objtool/arch/x86/orc.c
new file mode 100644
index 000000000000..a0c00e136089
--- /dev/null
+++ b/tools/objtool/arch/x86/orc.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2017 Josh Poimboeuf <jpoimboe@redhat.com>
+ */
+
+#include <stdlib.h>
+#include <string.h>
+
+#include <linux/objtool.h>
+
+#include <objtool/check.h>
+#include <objtool/orc.h>
+#include <objtool/warn.h>
+#include <objtool/endianness.h>
+
+int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi,
+		   struct instruction *insn)
+{
+	struct cfi_reg *bp = &cfi->regs[CFI_BP];
+
+	memset(orc, 0, sizeof(*orc));
+
+	if (!cfi) {
+		orc->end = 0;
+		orc->sp_reg = ORC_REG_UNDEFINED;
+		return 0;
+	}
+
+	orc->end = cfi->end;
+	orc->signal = cfi->signal;
+
+	if (cfi->cfa.base == CFI_UNDEFINED) {
+		orc->sp_reg = ORC_REG_UNDEFINED;
+		return 0;
+	}
+
+	switch (cfi->cfa.base) {
+	case CFI_SP:
+		orc->sp_reg = ORC_REG_SP;
+		break;
+	case CFI_SP_INDIRECT:
+		orc->sp_reg = ORC_REG_SP_INDIRECT;
+		break;
+	case CFI_BP:
+		orc->sp_reg = ORC_REG_BP;
+		break;
+	case CFI_BP_INDIRECT:
+		orc->sp_reg = ORC_REG_BP_INDIRECT;
+		break;
+	case CFI_R10:
+		orc->sp_reg = ORC_REG_R10;
+		break;
+	case CFI_R13:
+		orc->sp_reg = ORC_REG_R13;
+		break;
+	case CFI_DI:
+		orc->sp_reg = ORC_REG_DI;
+		break;
+	case CFI_DX:
+		orc->sp_reg = ORC_REG_DX;
+		break;
+	default:
+		WARN_FUNC("unknown CFA base reg %d",
+			  insn->sec, insn->offset, cfi->cfa.base);
+		return -1;
+	}
+
+	switch (bp->base) {
+	case CFI_UNDEFINED:
+		orc->bp_reg = ORC_REG_UNDEFINED;
+		break;
+	case CFI_CFA:
+		orc->bp_reg = ORC_REG_PREV_SP;
+		break;
+	case CFI_BP:
+		orc->bp_reg = ORC_REG_BP;
+		break;
+	default:
+		WARN_FUNC("unknown BP base reg %d",
+			  insn->sec, insn->offset, bp->base);
+		return -1;
+	}
+
+	orc->sp_offset = cfi->cfa.offset;
+	orc->bp_offset = bp->offset;
+	orc->type = cfi->type;
+
+	return 0;
+}
+
+static const char *reg_name(unsigned int reg)
+{
+	switch (reg) {
+	case ORC_REG_PREV_SP:
+		return "prevsp";
+	case ORC_REG_DX:
+		return "dx";
+	case ORC_REG_DI:
+		return "di";
+	case ORC_REG_BP:
+		return "bp";
+	case ORC_REG_SP:
+		return "sp";
+	case ORC_REG_R10:
+		return "r10";
+	case ORC_REG_R13:
+		return "r13";
+	case ORC_REG_BP_INDIRECT:
+		return "bp(ind)";
+	case ORC_REG_SP_INDIRECT:
+		return "sp(ind)";
+	default:
+		return "?";
+	}
+}
+
+const char *orc_type_name(unsigned int type)
+{
+	switch (type) {
+	case UNWIND_HINT_TYPE_CALL:
+		return "call";
+	case UNWIND_HINT_TYPE_REGS:
+		return "regs";
+	case UNWIND_HINT_TYPE_REGS_PARTIAL:
+		return "regs (partial)";
+	default:
+		return "?";
+	}
+}
+
+void orc_print_reg(unsigned int reg, int offset)
+{
+	if (reg == ORC_REG_BP_INDIRECT)
+		printf("(bp%+d)", offset);
+	else if (reg == ORC_REG_SP_INDIRECT)
+		printf("(sp)%+d", offset);
+	else if (reg == ORC_REG_UNDEFINED)
+		printf("(und)");
+	else
+		printf("%s%+d", reg_name(reg), offset);
+}
+
+void orc_print_sp(void)
+{
+	printf(" sp:");
+}
+
+void orc_print_fp(void)
+{
+	printf(" bp:");
+}
diff --git a/tools/objtool/include/objtool/orc.h b/tools/objtool/include/objtool/orc.h
new file mode 100644
index 000000000000..bf141134c56f
--- /dev/null
+++ b/tools/objtool/include/objtool/orc.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2015-2017 Josh Poimboeuf <jpoimboe@redhat.com>
+ */
+
+#ifndef _OBJTOOL_ORC_H
+#define _OBJTOOL_ORC_H
+
+#include <asm/orc_types.h>
+
+int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi,
+		   struct instruction *insn);
+const char *orc_type_name(unsigned int type);
+void orc_print_reg(unsigned int reg, int offset);
+void orc_print_sp(void);
+void orc_print_fp(void);
+
+#endif /* _OBJTOOL_ORC_H */
diff --git a/tools/objtool/orc_dump.c b/tools/objtool/orc_dump.c
index 2d8ebdcd1db3..82bdd33dbc39 100644
--- a/tools/objtool/orc_dump.c
+++ b/tools/objtool/orc_dump.c
@@ -5,63 +5,12 @@
 
 #include <unistd.h>
 #include <linux/objtool.h>
-#include <asm/orc_types.h>
 #include <objtool/objtool.h>
+#include <objtool/check.h>
+#include <objtool/orc.h>
 #include <objtool/warn.h>
 #include <objtool/endianness.h>
 
-static const char *reg_name(unsigned int reg)
-{
-	switch (reg) {
-	case ORC_REG_PREV_SP:
-		return "prevsp";
-	case ORC_REG_DX:
-		return "dx";
-	case ORC_REG_DI:
-		return "di";
-	case ORC_REG_BP:
-		return "bp";
-	case ORC_REG_SP:
-		return "sp";
-	case ORC_REG_R10:
-		return "r10";
-	case ORC_REG_R13:
-		return "r13";
-	case ORC_REG_BP_INDIRECT:
-		return "bp(ind)";
-	case ORC_REG_SP_INDIRECT:
-		return "sp(ind)";
-	default:
-		return "?";
-	}
-}
-
-static const char *orc_type_name(unsigned int type)
-{
-	switch (type) {
-	case UNWIND_HINT_TYPE_CALL:
-		return "call";
-	case UNWIND_HINT_TYPE_REGS:
-		return "regs";
-	case UNWIND_HINT_TYPE_REGS_PARTIAL:
-		return "regs (partial)";
-	default:
-		return "?";
-	}
-}
-
-static void print_reg(unsigned int reg, int offset)
-{
-	if (reg == ORC_REG_BP_INDIRECT)
-		printf("(bp%+d)", offset);
-	else if (reg == ORC_REG_SP_INDIRECT)
-		printf("(sp)%+d", offset);
-	else if (reg == ORC_REG_UNDEFINED)
-		printf("(und)");
-	else
-		printf("%s%+d", reg_name(reg), offset);
-}
-
 int orc_dump(const char *_objname)
 {
 	int fd, nr_entries, i, *orc_ip = NULL, orc_size = 0;
@@ -203,13 +152,13 @@ int orc_dump(const char *_objname)
 		}
 
 
-		printf(" sp:");
+		orc_print_sp();
 
-		print_reg(orc[i].sp_reg, bswap_if_needed(&dummy_elf, orc[i].sp_offset));
+		orc_print_reg(orc[i].sp_reg, bswap_if_needed(&dummy_elf, orc[i].sp_offset));
 
-		printf(" bp:");
+		orc_print_fp();
 
-		print_reg(orc[i].bp_reg, bswap_if_needed(&dummy_elf, orc[i].bp_offset));
+		orc_print_reg(orc[i].bp_reg, bswap_if_needed(&dummy_elf, orc[i].bp_offset));
 
 		printf(" type:%s signal:%d end:%d\n",
 		       orc_type_name(orc[i].type), orc[i].signal, orc[i].end);
diff --git a/tools/objtool/orc_gen.c b/tools/objtool/orc_gen.c
index 57a4527d5988..08c5a27252a2 100644
--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
@@ -7,87 +7,13 @@
 #include <string.h>
 
 #include <linux/objtool.h>
-#include <asm/orc_types.h>
+#include <arch/elf.h>
 
 #include <objtool/check.h>
+#include <objtool/orc.h>
 #include <objtool/warn.h>
 #include <objtool/endianness.h>
 
-static int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi,
-			  struct instruction *insn)
-{
-	struct cfi_reg *bp = &cfi->regs[CFI_BP];
-
-	memset(orc, 0, sizeof(*orc));
-
-	if (!cfi) {
-		orc->end = 0;
-		orc->sp_reg = ORC_REG_UNDEFINED;
-		return 0;
-	}
-
-	orc->end = cfi->end;
-	orc->signal = cfi->signal;
-
-	if (cfi->cfa.base == CFI_UNDEFINED) {
-		orc->sp_reg = ORC_REG_UNDEFINED;
-		return 0;
-	}
-
-	switch (cfi->cfa.base) {
-	case CFI_SP:
-		orc->sp_reg = ORC_REG_SP;
-		break;
-	case CFI_SP_INDIRECT:
-		orc->sp_reg = ORC_REG_SP_INDIRECT;
-		break;
-	case CFI_BP:
-		orc->sp_reg = ORC_REG_BP;
-		break;
-	case CFI_BP_INDIRECT:
-		orc->sp_reg = ORC_REG_BP_INDIRECT;
-		break;
-	case CFI_R10:
-		orc->sp_reg = ORC_REG_R10;
-		break;
-	case CFI_R13:
-		orc->sp_reg = ORC_REG_R13;
-		break;
-	case CFI_DI:
-		orc->sp_reg = ORC_REG_DI;
-		break;
-	case CFI_DX:
-		orc->sp_reg = ORC_REG_DX;
-		break;
-	default:
-		WARN_FUNC("unknown CFA base reg %d",
-			  insn->sec, insn->offset, cfi->cfa.base);
-		return -1;
-	}
-
-	switch (bp->base) {
-	case CFI_UNDEFINED:
-		orc->bp_reg = ORC_REG_UNDEFINED;
-		break;
-	case CFI_CFA:
-		orc->bp_reg = ORC_REG_PREV_SP;
-		break;
-	case CFI_BP:
-		orc->bp_reg = ORC_REG_BP;
-		break;
-	default:
-		WARN_FUNC("unknown BP base reg %d",
-			  insn->sec, insn->offset, bp->base);
-		return -1;
-	}
-
-	orc->sp_offset = cfi->cfa.offset;
-	orc->bp_offset = bp->offset;
-	orc->type = cfi->type;
-
-	return 0;
-}
-
 static int write_orc_entry(struct elf *elf, struct section *orc_sec,
 			   struct section *ip_sec, unsigned int idx,
 			   struct section *insn_sec, unsigned long insn_off,
@@ -102,7 +28,7 @@ static int write_orc_entry(struct elf *elf, struct section *orc_sec,
 	orc->bp_offset = bswap_if_needed(elf, orc->bp_offset);
 
 	/* populate reloc for ip */
-	if (elf_add_reloc_to_insn(elf, ip_sec, idx * sizeof(int), R_X86_64_PC32,
+	if (elf_add_reloc_to_insn(elf, ip_sec, idx * sizeof(int), R_PCREL,
 				  insn_sec, insn_off))
 		return -1;
 
-- 
2.39.2

