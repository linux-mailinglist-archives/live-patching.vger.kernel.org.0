Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1AE4F89C9
	for <lists+live-patching@lfdr.de>; Fri,  8 Apr 2022 00:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiDGUj7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 7 Apr 2022 16:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiDGUjo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 7 Apr 2022 16:39:44 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 830DA3542AB;
        Thu,  7 Apr 2022 13:26:02 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8655420B9CEF;
        Thu,  7 Apr 2022 13:26:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8655420B9CEF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1649363162;
        bh=nVQ+gSE19+X//O4Sk/QNhBvnuZzB5LkL5Rb13i7ZcgM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OWvphc47b+i0m2hrrF/YK+J97hpiVwg11oPGOgHp+WyQ/kxYXSDdyvxPpRSF3QlLF
         Ha3DE7NTMcK093by8SoU3mv+gvHEDxUl4hmEGjYbJLaxGXxjxRrPLI0x/WWIYMThKF
         Ld6a1GspxHld3r2DbDCzm0GGq+b2AbEB/pyQxydM=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v1 2/9] objtool: Generate DWARF rules and place them in a special section
Date:   Thu,  7 Apr 2022 15:25:11 -0500
Message-Id: <20220407202518.19780-3-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407202518.19780-1-madvenka@linux.microsoft.com>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Convert the DWARF Call Frame Information parsed by dwarf_parse() into
compact DWARF rules that are usable by the kernel. Place the rules in a
special section called .dwarf_rules. Also, place the PCs for the rules in
a special section called .dwarf_pcs. In addition, define relocation
entries for the PCs as they will change during linking.

An entry in .dwarf_rules and its corresponding entry in .dwarf_pcs together
describe a code range and DWARF rules for the code range. In the future,
the kernel will use the rules to compute the frame pointer at a given
instruction address. The unwinder can use the computed frame pointer to
validate the actual frame pointer for a reliable stack trace.

During rule generation, eliminate null offset rules and merge adjacent rules
that are identical to minimize the number of rules.

Also add an objtool option to dump the DWARF rules for debugging purposes.
It is invoked as follows:

	objtool dwarf dump <object-file>

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 include/linux/dwarf.h                     |  43 +++++
 tools/include/linux/dwarf.h               |  43 +++++
 tools/objtool/builtin-dwarf.c             |  22 ++-
 tools/objtool/dwarf_rules.c               | 181 +++++++++++++++++++++-
 tools/objtool/include/objtool/dwarf_def.h |  12 ++
 tools/objtool/include/objtool/objtool.h   |   2 +
 tools/objtool/sync-check.sh               |   6 +
 tools/objtool/weak.c                      |  11 ++
 8 files changed, 311 insertions(+), 9 deletions(-)
 create mode 100644 include/linux/dwarf.h
 create mode 100644 tools/include/linux/dwarf.h

diff --git a/include/linux/dwarf.h b/include/linux/dwarf.h
new file mode 100644
index 000000000000..16e9dd8c60c8
--- /dev/null
+++ b/include/linux/dwarf.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * dwarf.h - DWARF data structures used by the unwinder.
+ *
+ * Author: Madhavan T. Venkataraman (madvenka@linux.microsoft.com)
+ *
+ * Copyright (c) 2022 Microsoft Corporation
+ */
+
+#ifndef _LINUX_DWARF_H
+#define _LINUX_DWARF_H
+
+#include <linux/types.h>
+
+/*
+ * objtool generates two special sections that contain DWARF information that
+ * will be used by the reliable unwinder to validate the frame pointer in every
+ * frame:
+ *
+ * .dwarf_rules:
+ *	This contains an array of struct dwarf_rule. Each rule contains the
+ *	size of a code range. In addition, a rule contains the offsets that
+ *	must be used to compute the frame pointer at any of the instructions
+ *	within the code range. The computation is:
+ *
+ *		CFA = %sp + sp_offset
+ *		FP = CFA + fp_offset
+ *
+ *	where %sp is the stack pointer at the instruction address and FP is
+ *	the frame pointer.
+ *
+ * .dwarf_pcs:
+ *	This contains an array of starting PCs, one for each rule.
+ */
+struct dwarf_rule {
+	unsigned int	size:30;
+	unsigned int	sp_saved:1;
+	unsigned int	fp_saved:1;
+	short		sp_offset;
+	short		fp_offset;
+};
+
+#endif /* _LINUX_DWARF_H */
diff --git a/tools/include/linux/dwarf.h b/tools/include/linux/dwarf.h
new file mode 100644
index 000000000000..16e9dd8c60c8
--- /dev/null
+++ b/tools/include/linux/dwarf.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * dwarf.h - DWARF data structures used by the unwinder.
+ *
+ * Author: Madhavan T. Venkataraman (madvenka@linux.microsoft.com)
+ *
+ * Copyright (c) 2022 Microsoft Corporation
+ */
+
+#ifndef _LINUX_DWARF_H
+#define _LINUX_DWARF_H
+
+#include <linux/types.h>
+
+/*
+ * objtool generates two special sections that contain DWARF information that
+ * will be used by the reliable unwinder to validate the frame pointer in every
+ * frame:
+ *
+ * .dwarf_rules:
+ *	This contains an array of struct dwarf_rule. Each rule contains the
+ *	size of a code range. In addition, a rule contains the offsets that
+ *	must be used to compute the frame pointer at any of the instructions
+ *	within the code range. The computation is:
+ *
+ *		CFA = %sp + sp_offset
+ *		FP = CFA + fp_offset
+ *
+ *	where %sp is the stack pointer at the instruction address and FP is
+ *	the frame pointer.
+ *
+ * .dwarf_pcs:
+ *	This contains an array of starting PCs, one for each rule.
+ */
+struct dwarf_rule {
+	unsigned int	size:30;
+	unsigned int	sp_saved:1;
+	unsigned int	fp_saved:1;
+	short		sp_offset;
+	short		fp_offset;
+};
+
+#endif /* _LINUX_DWARF_H */
diff --git a/tools/objtool/builtin-dwarf.c b/tools/objtool/builtin-dwarf.c
index f44b35eb3f55..1b451e830140 100644
--- a/tools/objtool/builtin-dwarf.c
+++ b/tools/objtool/builtin-dwarf.c
@@ -25,6 +25,10 @@ static const char * const dwarf_usage[] = {
 	 * information.
 	 */
 	"objtool dwarf generate file",
+	/*
+	 * Dump DWARF rules for debugging purposes.
+	 */
+	"objtool dwarf dump file",
 
 	NULL,
 };
@@ -37,6 +41,7 @@ int cmd_dwarf(int argc, const char **argv)
 {
 	const char		*object;
 	struct objtool_file	*file;
+	int			ret;
 
 	argc--; argv++;
 	if (argc != 2)
@@ -48,8 +53,21 @@ int cmd_dwarf(int argc, const char **argv)
 	if (!file)
 		return 1;
 
-	if (!strncmp(argv[0], "gen", 3))
-		return dwarf_parse(file);
+	if (!strncmp(argv[0], "gen", 3)) {
+		ret = dwarf_parse(file);
+		if (!ret)
+			ret = dwarf_write(file);
+		if (!ret && file->elf->changed)
+			ret = elf_write(file->elf);
+		return ret;
+	}
+
+	if (!strcmp(argv[0], "dump")) {
+		ret = dwarf_parse(file);
+		if (!ret)
+			dwarf_dump();
+		return ret;
+	}
 
 	usage_with_options(dwarf_usage, dwarf_options);
 
diff --git a/tools/objtool/dwarf_rules.c b/tools/objtool/dwarf_rules.c
index 9cf201de392a..a118b392aac8 100644
--- a/tools/objtool/dwarf_rules.c
+++ b/tools/objtool/dwarf_rules.c
@@ -13,25 +13,192 @@
 #include <objtool/dwarf_def.h>
 #include <linux/compiler.h>
 
-/*
- * The following are stubs for now. Later, they will be filled to create
- * DWARF rules that the kernel can use to compute the frame pointer at
- * a given instruction address.
- */
+struct section			*dwarf_rules_sec;
+struct section			*dwarf_pcs_sec;
+
+static struct fde_entry		*cur_entry;
+static int			nentries;
+
+static int dwarf_rule_insert(struct fde *fde, unsigned long addr,
+			     struct rule *sp_rule, struct rule *fp_rule);
+
 void dwarf_rule_start(struct fde *fde)
 {
+	fde->head = NULL;
+	fde->tail = NULL;
+	cur_entry = NULL;
 }
 
 int dwarf_rule_add(struct fde *fde, unsigned long addr,
-	     struct rule *sp_rule, struct rule *fp_rule)
+		   struct rule *sp_rule, struct rule *fp_rule)
 {
-	return 0;
+	if (cur_entry) {
+		struct rule		*esp_rule = &cur_entry->sp_rule;
+		struct rule		*efp_rule = &cur_entry->fp_rule;
+
+		/*
+		 * If the rules have not changed, there is nothing to do.
+		 */
+		if (esp_rule->offset == sp_rule->offset &&
+		    efp_rule->offset == fp_rule->offset &&
+		    esp_rule->saved == sp_rule->saved &&
+		    efp_rule->saved == fp_rule->saved) {
+			return 0;
+		}
+		/* Close out the current range. */
+		cur_entry->size = addr - cur_entry->addr;
+	}
+	return dwarf_rule_insert(fde, addr, sp_rule, fp_rule);
 }
 
 void dwarf_rule_next(struct fde *fde, unsigned long addr)
 {
+	if (cur_entry) {
+		/* Close out the current range. */
+		cur_entry->size = addr - cur_entry->addr;
+		cur_entry = NULL;
+	}
 }
 
 void dwarf_rule_reset(struct fde *fde)
 {
+	struct fde_entry	*entry;
+
+	while (fde->head) {
+		entry = fde->head;
+		fde->head = entry->next;
+		free(entry);
+		nentries--;
+	}
+	fde->tail = NULL;
+	cur_entry = NULL;
+}
+
+static int dwarf_rule_insert(struct fde *fde, unsigned long addr,
+			     struct rule *sp_rule, struct rule *fp_rule)
+{
+	struct fde_entry	*entry;
+
+	entry = dwarf_alloc(sizeof(*entry));
+	if (!entry)
+		return -1;
+
+	/* Add the entry to the FDE list. */
+	if (fde->tail)
+		fde->tail->next = entry;
+	else
+		fde->head = entry;
+	fde->tail = entry;
+	entry->next = NULL;
+
+	/*
+	 * Record the starting address of the code range here. The size of
+	 * the range will be known only when the next rule comes in. At that
+	 * time, we will close out this range.
+	 */
+	entry->addr = addr;
+
+	/* Copy the rules. */
+	entry->sp_rule = *sp_rule;
+	entry->fp_rule = *fp_rule;
+
+	cur_entry = entry;
+	nentries++;
+	return 0;
+}
+
+static int dwarf_rule_write(struct elf *elf, struct fde *fde,
+			    struct fde_entry *entry, unsigned int index)
+{
+	struct dwarf_rule	rule, *drule;
+
+	/*
+	 * Encode the SP and FP rules from the entry into a single dwarf_rule
+	 * for the kernel's benefit. Copy it into .dwarf_rules.
+	 */
+	rule.size = entry->size;
+	rule.sp_saved = entry->sp_rule.saved;
+	rule.fp_saved = entry->fp_rule.saved;
+	rule.sp_offset = entry->sp_rule.offset;
+	rule.fp_offset = entry->fp_rule.offset;
+
+	drule = (struct dwarf_rule *) dwarf_rules_sec->data->d_buf + index;
+	memcpy(drule, &rule, sizeof(rule));
+
+	/* Add relocation information for the code range. */
+	if (elf_add_reloc_to_insn(elf, dwarf_pcs_sec,
+				  index * sizeof(unsigned long),
+				  R_AARCH64_ABS64,
+				  fde->section, entry->addr)) {
+		return -1;
+	}
+	return 0;
+}
+
+int dwarf_write(struct objtool_file *file)
+{
+	struct elf		*elf = file->elf;
+	struct fde		*fde;
+	struct fde_entry	*entry;
+	int			index;
+
+	/*
+	 * Check if .dwarf_rules already exists. If it doesn't, we will
+	 * assume that .dwarf_pcs doesn't exist either.
+	 */
+	if (find_section_by_name(elf, ".dwarf_rules")) {
+		WARN("file already has .dwarf_rules section");
+		return -1;
+	}
+
+	/* Create .dwarf_rules. */
+	dwarf_rules_sec = elf_create_section(elf, ".dwarf_rules", 0,
+					     sizeof(struct dwarf_rule),
+					     nentries);
+	if (!dwarf_rules_sec) {
+		WARN("Unable to create .dwarf_rules");
+		return -1;
+	}
+
+	/* Create .dwarf_pcs. */
+	dwarf_pcs_sec = elf_create_section(elf, ".dwarf_pcs", 0,
+					   sizeof(unsigned long), nentries);
+	if (!dwarf_pcs_sec) {
+		WARN("Unable to create .dwarf_pcs");
+		return -1;
+	}
+
+	/* Write DWARF rules to sections. */
+	index = 0;
+	for (fde = fdes; fde != NULL; fde = fde->next) {
+		for (entry = fde->head; entry != NULL; entry = entry->next) {
+			if (dwarf_rule_write(elf, fde, entry, index))
+				return -1;
+			index++;
+		}
+	}
+
+	return 0;
+}
+
+void dwarf_dump(void)
+{
+	struct fde		*fde;
+	struct fde_entry	*entry;
+	struct rule		*sp_rule, *fp_rule;
+	int			index = 0;
+
+	for (fde = fdes; fde != NULL; fde = fde->next) {
+		for (entry = fde->head; entry != NULL; entry = entry->next) {
+			sp_rule = &entry->sp_rule;
+			fp_rule = &entry->fp_rule;
+
+			printf("addr=%lx size=%lx:",
+			       entry->addr, entry->size);
+			printf("\tsp=%ld sp_saved=%d fp=%ld fp_saved=%d\n",
+			       sp_rule->offset, sp_rule->saved,
+			       fp_rule->offset, fp_rule->saved);
+			index++;
+		}
+	}
 }
diff --git a/tools/objtool/include/objtool/dwarf_def.h b/tools/objtool/include/objtool/dwarf_def.h
index 7a0a18480d2b..af56ccb52fff 100644
--- a/tools/objtool/include/objtool/dwarf_def.h
+++ b/tools/objtool/include/objtool/dwarf_def.h
@@ -10,6 +10,8 @@
 #ifndef _OBJTOOL_DWARF_DEF_H
 #define _OBJTOOL_DWARF_DEF_H
 
+#include <linux/dwarf.h>
+
 /*
  * The DWARF Call Frame Information (CFI) is encoded in a self-contained
  * section called .debug_frame.
@@ -228,6 +230,14 @@ struct cie {
 	bool			unusable;
 };
 
+struct fde_entry {
+	struct fde_entry	*next;
+	unsigned long		addr;
+	size_t			size;
+	struct rule		sp_rule;
+	struct rule		fp_rule;
+};
+
 /*
  * Frame Description Entry (FDE):
  *
@@ -290,6 +300,8 @@ struct fde {
 	struct section		*section;
 	unsigned long		offset;
 	unsigned long		sp_offset;
+	struct fde_entry	*head;
+	struct fde_entry	*tail;
 };
 
 /*
diff --git a/tools/objtool/include/objtool/objtool.h b/tools/objtool/include/objtool/objtool.h
index 0344e89a10e8..93e62639ab01 100644
--- a/tools/objtool/include/objtool/objtool.h
+++ b/tools/objtool/include/objtool/objtool.h
@@ -42,5 +42,7 @@ int check(struct objtool_file *file);
 int orc_dump(const char *objname);
 int orc_create(struct objtool_file *file);
 int dwarf_parse(struct objtool_file *file);
+void dwarf_dump(void);
+int dwarf_write(struct objtool_file *file);
 
 #endif /* _OBJTOOL_H */
diff --git a/tools/objtool/sync-check.sh b/tools/objtool/sync-check.sh
index 105a291ff8e7..345c259a115c 100755
--- a/tools/objtool/sync-check.sh
+++ b/tools/objtool/sync-check.sh
@@ -27,6 +27,12 @@ arch/x86/lib/insn.c
 '
 fi
 
+if [ "$SRCARCH" = "arm64" ]; then
+FILES="$FILES
+include/linux/dwarf.h
+"
+fi
+
 check_2 () {
   file1=$1
   file2=$2
diff --git a/tools/objtool/weak.c b/tools/objtool/weak.c
index 67b5016a8327..9d89d4fad8a1 100644
--- a/tools/objtool/weak.c
+++ b/tools/objtool/weak.c
@@ -38,6 +38,17 @@ int __weak dwarf_parse(struct objtool_file *file)
 	return -EOPNOTSUPP;
 }
 
+int __weak dwarf_write(struct objtool_file *file)
+{
+	fprintf(stderr, "error: objtool: %s not implemented\n", __func__);
+	return -1;
+}
+
+void __weak dwarf_dump(void)
+{
+	fprintf(stderr, "error: objtool: %s not implemented\n", __func__);
+}
+
 int __weak arch_dwarf_fde_reloc(struct fde *fde)
 {
 	fprintf(stderr, "error: objtool: %s not implemented\n", __func__);
-- 
2.25.1

