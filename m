Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08A468769D
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 08:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbjBBHnT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 02:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbjBBHmx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 02:42:53 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0ED1E84B45;
        Wed,  1 Feb 2023 23:42:39 -0800 (PST)
Received: from x64host.home (unknown [47.187.213.40])
        by linux.microsoft.com (Postfix) with ESMTPSA id A2D4620B2EE0;
        Wed,  1 Feb 2023 23:42:38 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A2D4620B2EE0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675323759;
        bh=jNAeObYr1g94vg9HIxaKJNneDImCayRVcc8/ZI8nYbk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=E9qmkBC171byJFAPg/JByrrx9hcL68uTd/qai9oaoDmLm0tCmvAFBq2TX6t/yicvC
         rtKPgYcBIXzeXXLw/9Oj5oe1//Fukn/nHcR/X+2aYF9a6I2RCDSvJdTU//O7x8VmQK
         vh1Q6ZkqmZQqeezBJsKuqZyuOHwM5rXCTH/g7MEk=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 14/22] objtool: arm64: Generate ORC data from CFI for object files
Date:   Thu,  2 Feb 2023 01:40:28 -0600
Message-Id: <20230202074036.507249-15-madvenka@linux.microsoft.com>
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

Enable ORC data for ARM64.

Call orc_create() from check() in dcheck.c to generate the ORC sections in
object files for dynamic frame pointer validation.

Define support functions for ORC data creation.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm64/include/asm/orc_types.h          | 35 +++++++++
 tools/arch/arm64/include/asm/orc_types.h    | 35 +++++++++
 tools/objtool/Makefile                      |  1 +
 tools/objtool/arch/arm64/Build              |  1 +
 tools/objtool/arch/arm64/include/arch/elf.h |  9 +++
 tools/objtool/arch/arm64/orc.c              | 86 +++++++++++++++++++++
 tools/objtool/dcheck.c                      |  5 +-
 tools/objtool/include/objtool/insn.h        |  1 +
 tools/objtool/include/objtool/objtool.h     |  1 +
 tools/objtool/insn.c                        | 20 +++++
 tools/objtool/orc_gen.c                     | 12 ++-
 tools/objtool/sync-check.sh                 |  7 ++
 12 files changed, 210 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm64/include/asm/orc_types.h
 create mode 100644 tools/arch/arm64/include/asm/orc_types.h
 create mode 100644 tools/objtool/arch/arm64/include/arch/elf.h
 create mode 100644 tools/objtool/arch/arm64/orc.c

diff --git a/arch/arm64/include/asm/orc_types.h b/arch/arm64/include/asm/orc_types.h
new file mode 100644
index 000000000000..c7bb690ca7d9
--- /dev/null
+++ b/arch/arm64/include/asm/orc_types.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Author: Madhavan T. Venkataraman (madvenka@linux.microsoft.com)
+ *
+ * Copyright (C) 2022 Microsoft Corporation
+ */
+
+#ifndef _ORC_TYPES_H
+#define _ORC_TYPES_H
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <linux/orc_entry.h>
+
+/*
+ * The ORC_REG_* registers are base registers which are used to find other
+ * registers on the stack.
+ *
+ * ORC_REG_PREV_SP, also known as DWARF Call Frame Address (CFA), is the
+ * address of the previous frame: the caller's SP before it called the current
+ * function.
+ *
+ * ORC_REG_UNDEFINED means the corresponding register's value didn't change in
+ * the current frame.
+ *
+ * We only use base registers SP and FP -- which the previous SP is based on --
+ * and PREV_SP and UNDEFINED -- which the previous FP is based on.
+ */
+#define ORC_REG_UNDEFINED		0
+#define ORC_REG_PREV_SP			1
+#define ORC_REG_SP			2
+#define ORC_REG_FP			3
+#define ORC_REG_MAX			4
+
+#endif /* _ORC_TYPES_H */
diff --git a/tools/arch/arm64/include/asm/orc_types.h b/tools/arch/arm64/include/asm/orc_types.h
new file mode 100644
index 000000000000..c7bb690ca7d9
--- /dev/null
+++ b/tools/arch/arm64/include/asm/orc_types.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Author: Madhavan T. Venkataraman (madvenka@linux.microsoft.com)
+ *
+ * Copyright (C) 2022 Microsoft Corporation
+ */
+
+#ifndef _ORC_TYPES_H
+#define _ORC_TYPES_H
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <linux/orc_entry.h>
+
+/*
+ * The ORC_REG_* registers are base registers which are used to find other
+ * registers on the stack.
+ *
+ * ORC_REG_PREV_SP, also known as DWARF Call Frame Address (CFA), is the
+ * address of the previous frame: the caller's SP before it called the current
+ * function.
+ *
+ * ORC_REG_UNDEFINED means the corresponding register's value didn't change in
+ * the current frame.
+ *
+ * We only use base registers SP and FP -- which the previous SP is based on --
+ * and PREV_SP and UNDEFINED -- which the previous FP is based on.
+ */
+#define ORC_REG_UNDEFINED		0
+#define ORC_REG_PREV_SP			1
+#define ORC_REG_SP			2
+#define ORC_REG_FP			3
+#define ORC_REG_MAX			4
+
+#endif /* _ORC_TYPES_H */
diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index 92583b82eb78..14bb324d9385 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -47,6 +47,7 @@ ifeq ($(SRCARCH),x86)
 endif
 
 ifeq ($(SRCARCH),arm64)
+	BUILD_ORC := y
 	DYNAMIC_CHECK := y
 endif
 
diff --git a/tools/objtool/arch/arm64/Build b/tools/objtool/arch/arm64/Build
index 3ff1f00c6a47..8615abfb12cf 100644
--- a/tools/objtool/arch/arm64/Build
+++ b/tools/objtool/arch/arm64/Build
@@ -1 +1,2 @@
 objtool-y += decode.o
+objtool-y += orc.o
diff --git a/tools/objtool/arch/arm64/include/arch/elf.h b/tools/objtool/arch/arm64/include/arch/elf.h
new file mode 100644
index 000000000000..4ae6df2bd90c
--- /dev/null
+++ b/tools/objtool/arch/arm64/include/arch/elf.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+
+#ifndef _OBJTOOL_ARCH_ELF
+#define _OBJTOOL_ARCH_ELF
+
+#define R_NONE		R_AARCH64_NONE
+#define R_PCREL		R_AARCH64_PREL32
+
+#endif /* _OBJTOOL_ARCH_ELF */
diff --git a/tools/objtool/arch/arm64/orc.c b/tools/objtool/arch/arm64/orc.c
new file mode 100644
index 000000000000..cef14114e1ec
--- /dev/null
+++ b/tools/objtool/arch/arm64/orc.c
@@ -0,0 +1,86 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Author: Madhavan T. Venkataraman (madvenka@linux.microsoft.com)
+ *
+ * Copyright (C) 2022 Microsoft Corporation
+ */
+#include <string.h>
+
+#include <linux/objtool.h>
+
+#include <objtool/insn.h>
+#include <objtool/orc.h>
+
+int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi,
+		   struct instruction *insn)
+{
+	struct cfi_reg *fp = &cfi->regs[CFI_FP];
+
+	memset(orc, 0, sizeof(*orc));
+
+	orc->sp_reg = ORC_REG_SP;
+	orc->fp_reg = ORC_REG_PREV_SP;
+
+	if (!cfi || cfi->cfa.base == CFI_UNDEFINED ||
+	    (cfi->type == UNWIND_HINT_TYPE_CALL && !fp->offset)) {
+		/*
+		 * The frame pointer has not been set up. This instruction is
+		 * unreliable from an unwind perspective.
+		 */
+		return 0;
+	}
+
+	orc->sp_offset = cfi->cfa.offset;
+	orc->fp_offset = fp->offset;
+	orc->type = cfi->type;
+	orc->end = cfi->end;
+
+	return 0;
+}
+
+static const char *reg_name(unsigned int reg)
+{
+	switch (reg) {
+	case ORC_REG_PREV_SP:
+		return "cfa";
+	case ORC_REG_FP:
+		return "x29";
+	case ORC_REG_SP:
+		return "sp";
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
+	default:
+		return "?";
+	}
+}
+
+void orc_print_reg(unsigned int reg, int offset)
+{
+	if (reg == ORC_REG_UNDEFINED)
+		printf("(und)");
+	else
+		printf("%s%+d", reg_name(reg), offset);
+}
+
+void orc_print_sp(void)
+{
+	printf(" cfa:");
+}
+
+void orc_print_fp(void)
+{
+	printf(" x29:");
+}
+
+bool orc_ignore_section(struct section *sec)
+{
+	return !strcmp(sec->name, ".head.text");
+}
diff --git a/tools/objtool/dcheck.c b/tools/objtool/dcheck.c
index 8b78cb608528..57499752c523 100644
--- a/tools/objtool/dcheck.c
+++ b/tools/objtool/dcheck.c
@@ -349,5 +349,8 @@ int check(struct objtool_file *file)
 
 	walk_sections(file);
 
-	return 0;
+	if (opts.orc)
+		ret = orc_create(file);
+
+	return ret;
 }
diff --git a/tools/objtool/include/objtool/insn.h b/tools/objtool/include/objtool/insn.h
index 3a43a591b318..ac718f1e2d2f 100644
--- a/tools/objtool/include/objtool/insn.h
+++ b/tools/objtool/include/objtool/insn.h
@@ -84,6 +84,7 @@ struct instruction *next_insn_same_sec(struct objtool_file *file,
 struct instruction *next_insn_same_func(struct objtool_file *file,
 					struct instruction *insn);
 struct reloc *insn_reloc(struct objtool_file *file, struct instruction *insn);
+bool insn_can_reloc(struct instruction *insn);
 bool insn_cfi_match(struct instruction *insn, struct cfi_state *cfi2,
 		    bool print);
 bool same_function(struct instruction *insn1, struct instruction *insn2);
diff --git a/tools/objtool/include/objtool/objtool.h b/tools/objtool/include/objtool/objtool.h
index 7f2d1b095333..b7655ad3e402 100644
--- a/tools/objtool/include/objtool/objtool.h
+++ b/tools/objtool/include/objtool/objtool.h
@@ -46,5 +46,6 @@ void objtool_pv_add(struct objtool_file *file, int idx, struct symbol *func);
 int check(struct objtool_file *file);
 int orc_dump(const char *objname);
 int orc_create(struct objtool_file *file);
+bool orc_ignore_section(struct section *sec);
 
 #endif /* _OBJTOOL_H */
diff --git a/tools/objtool/insn.c b/tools/objtool/insn.c
index be3617d55aea..af48319f2225 100644
--- a/tools/objtool/insn.c
+++ b/tools/objtool/insn.c
@@ -193,3 +193,23 @@ bool insn_cfi_match(struct instruction *insn, struct cfi_state *cfi2,
 
 	return false;
 }
+
+/*
+ * This is a hack for Clang. Clang is aggressive about removing section
+ * symbols and then some. If we cannot find something to relocate an
+ * instruction against, we must not generate CFI for it or the ORC
+ * generation will fail later.
+ */
+bool insn_can_reloc(struct instruction *insn)
+{
+	struct section *insn_sec = insn->sec;
+	unsigned long insn_off = insn->offset;
+
+	if (insn_sec->sym ||
+	    find_symbol_containing(insn_sec, insn_off) ||
+	    find_symbol_containing(insn_sec, insn_off - 1)) {
+		/* See elf_add_reloc_to_insn(). */
+		return true;
+	}
+	return false;
+}
diff --git a/tools/objtool/orc_gen.c b/tools/objtool/orc_gen.c
index ea2e361ff7bc..bddf5889466f 100644
--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
@@ -14,6 +14,11 @@
 #include <objtool/warn.h>
 #include <objtool/endianness.h>
 
+bool __weak orc_ignore_section(struct section *sec)
+{
+	return false;
+}
+
 static int write_orc_entry(struct elf *elf, struct section *orc_sec,
 			   struct section *ip_sec, unsigned int idx,
 			   struct section *insn_sec, unsigned long insn_off,
@@ -87,13 +92,16 @@ int orc_create(struct objtool_file *file)
 		struct instruction *insn;
 		bool empty = true;
 
-		if (!sec->text)
+		if (!sec->text || orc_ignore_section(sec))
 			continue;
 
 		sec_for_each_insn(file, sec, insn) {
 			struct alt_group *alt_group = insn->alt_group;
 			int i;
 
+			if (!insn_can_reloc(insn))
+				continue;
+
 			if (!alt_group) {
 				if (init_orc_entry(&orc, insn->cfi, insn))
 					return -1;
@@ -137,7 +145,7 @@ int orc_create(struct objtool_file *file)
 		}
 
 		/* Add a section terminator */
-		if (!empty) {
+		if (!empty && sec->sym) {
 			orc_list_add(&orc_list, &null, sec, sec->sh.sh_size);
 			nr++;
 		}
diff --git a/tools/objtool/sync-check.sh b/tools/objtool/sync-check.sh
index ef1acb064605..0d0656f6ce4a 100755
--- a/tools/objtool/sync-check.sh
+++ b/tools/objtool/sync-check.sh
@@ -29,6 +29,13 @@ arch/x86/lib/insn.c
 '
 fi
 
+if [ "$SRCARCH" = "arm64" ]; then
+FILES="$FILES
+arch/arm64/include/asm/orc_types.h
+include/linux/orc_entry.h
+"
+fi
+
 check_2 () {
   file1=$1
   file2=$2
-- 
2.25.1

