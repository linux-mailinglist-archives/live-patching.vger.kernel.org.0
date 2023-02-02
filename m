Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0FE68768E
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 08:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjBBHmu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 02:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbjBBHmd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 02:42:33 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C1B25841B2;
        Wed,  1 Feb 2023 23:42:31 -0800 (PST)
Received: from x64host.home (unknown [47.187.213.40])
        by linux.microsoft.com (Postfix) with ESMTPSA id B152720B74FC;
        Wed,  1 Feb 2023 23:42:30 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B152720B74FC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675323751;
        bh=+AlBF++HfEjWxbMQxYX0cu/v4CKaFSwJ25deZh05K3w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fByeDPulsa8VK8LD0iM3o4DwrsmWvw5a4JRV6lMdFJOUjt7oH293G6lCnqyPLJNCX
         03e6pPeuzI4X3M5IitSNPt1IYI3xd5FhPfxaaSIY5rpoy/lpxyjaMTF8bbXrkIL2rO
         SE1QxDuW+y0RsBCih8HV5UV/HBPX2iMtV5TCngBw=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 06/22] objtool: Reorganize ORC code
Date:   Thu,  2 Feb 2023 01:40:20 -0600
Message-Id: <20230202074036.507249-7-madvenka@linux.microsoft.com>
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
 tools/objtool/arch/x86/orc.c              | 150 ++++++++++++++++++++++
 tools/objtool/include/objtool/orc.h       |  18 +++
 tools/objtool/orc_dump.c                  |  63 +--------
 tools/objtool/orc_gen.c                   |  79 +-----------
 6 files changed, 179 insertions(+), 133 deletions(-)
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
index 69cc4264b28a..3a7eb515dbb9 100644
--- a/tools/objtool/arch/x86/include/arch/elf.h
+++ b/tools/objtool/arch/x86/include/arch/elf.h
@@ -2,5 +2,6 @@
 #define _OBJTOOL_ARCH_ELF
 
 #define R_NONE R_X86_64_NONE
+#define R_PCREL R_X86_64_PC32
 
 #endif /* _OBJTOOL_ARCH_ELF */
diff --git a/tools/objtool/arch/x86/orc.c b/tools/objtool/arch/x86/orc.c
new file mode 100644
index 000000000000..a075737d4503
--- /dev/null
+++ b/tools/objtool/arch/x86/orc.c
@@ -0,0 +1,150 @@
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
index f5a8508c42d6..61b39960ab6a 100644
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
@@ -196,13 +145,13 @@ int orc_dump(const char *_objname)
 		}
 
 
-		printf(" sp:");
+		orc_print_sp();
 
-		print_reg(orc[i].sp_reg, bswap_if_needed(orc[i].sp_offset));
+		orc_print_reg(orc[i].sp_reg, bswap_if_needed(orc[i].sp_offset));
 
-		printf(" bp:");
+		orc_print_fp();
 
-		print_reg(orc[i].bp_reg, bswap_if_needed(orc[i].bp_offset));
+		orc_print_reg(orc[i].fp_reg, bswap_if_needed(orc[i].fp_offset));
 
 		printf(" type:%s end:%d\n",
 		       orc_type_name(orc[i].type), orc[i].end);
diff --git a/tools/objtool/orc_gen.c b/tools/objtool/orc_gen.c
index 68c317daadbf..ea2e361ff7bc 100644
--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
@@ -7,86 +7,13 @@
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
@@ -101,7 +28,7 @@ static int write_orc_entry(struct elf *elf, struct section *orc_sec,
 	orc->fp_offset = bswap_if_needed(orc->fp_offset);
 
 	/* populate reloc for ip */
-	if (elf_add_reloc_to_insn(elf, ip_sec, idx * sizeof(int), R_X86_64_PC32,
+	if (elf_add_reloc_to_insn(elf, ip_sec, idx * sizeof(int), R_PCREL,
 				  insn_sec, insn_off))
 		return -1;
 
-- 
2.25.1

