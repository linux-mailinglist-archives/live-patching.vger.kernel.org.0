Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F20736521
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 09:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjFTHr3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 03:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjFTHr1 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 03:47:27 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 173E31A5;
        Tue, 20 Jun 2023 00:47:22 -0700 (PDT)
Received: from loongson.cn (unknown [113.200.148.30])
        by gateway (Coremail) with SMTP id _____8Cxd+mJWZFkohoHAA--.12661S3;
        Tue, 20 Jun 2023 15:47:21 +0800 (CST)
Received: from bogon.localdomain (unknown [113.200.148.30])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxK8pvWZFkJGYhAA--.19652S5;
        Tue, 20 Jun 2023 15:47:19 +0800 (CST)
From:   Youling Tang <tangyouling@loongson.cn>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        madvenka@linux.microsoft.com
Cc:     chenzhongjin@huawei.com, WANG Xuerui <kernel@xen0n.name>,
        Xi Ruoyao <xry111@xry111.site>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        tangyouling00@gmail.com, youling.tang@outlook.com
Subject: [RFC PATCH v1 03/23] objtool: Move decode_instructions() to a separate file
Date:   Tue, 20 Jun 2023 15:46:29 +0800
Message-Id: <1687247209-31676-4-git-send-email-tangyouling@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1687247209-31676-1-git-send-email-tangyouling@loongson.cn>
References: <1687247209-31676-1-git-send-email-tangyouling@loongson.cn>
X-CM-TRANSID: AQAAf8DxK8pvWZFkJGYhAA--.19652S5
X-CM-SenderInfo: 5wdqw5prxox03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoW3XryDAr13CFyfXFyDWrWUJrc_yoWfWw1kpF
        45C3yxWrW7Xr93Ww4ftr1DCr9xKws7Wr1UG345Wa4Sy34aqrn3JF4ayw4F9as2gr45W3W3
        tFZ0grW8ur45A3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUBab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
        wI0_Gr1j6F4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
        xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
        Wrv_ZF1lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x
        0EwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
        bVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E74
        80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0
        I7IYx2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04
        k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7Cj
        xVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j6rWOUUUUU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

check.c implements static stack validation. But decode_instructions() which
resides in it can be shared with other types of validation. E.g., dynamic
FP validation. Move the function to its own file - decode.c.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 tools/objtool/Build                   |   1 +
 tools/objtool/check.c                 | 127 +-----------------------
 tools/objtool/decode.c                | 136 ++++++++++++++++++++++++++
 tools/objtool/include/objtool/check.h |   2 +
 tools/objtool/include/objtool/insn.h  |   2 +
 5 files changed, 142 insertions(+), 126 deletions(-)
 create mode 100644 tools/objtool/decode.c

diff --git a/tools/objtool/Build b/tools/objtool/Build
index c04e36267379..64ccae49cd5f 100644
--- a/tools/objtool/Build
+++ b/tools/objtool/Build
@@ -7,6 +7,7 @@ objtool-y += special.o
 objtool-y += builtin-check.o
 objtool-y += cfi.o
 objtool-y += insn.o
+objtool-y += decode.o
 objtool-y += elf.o
 objtool-y += objtool.o
 
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 619f7467e39c..26ed9b0b8f49 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -167,134 +167,9 @@ static bool dead_end_function(struct objtool_file *file, struct symbol *func)
 	return __dead_end_function(file, func, 0);
 }
 
-static unsigned long nr_insns;
+unsigned long nr_insns;
 static unsigned long nr_insns_visited;
 
-/*
- * Call the arch-specific instruction decoder for all the instructions and add
- * them to the global instruction list.
- */
-static int decode_instructions(struct objtool_file *file)
-{
-	struct section *sec;
-	struct symbol *func;
-	unsigned long offset;
-	struct instruction *insn;
-	int ret;
-
-	for_each_sec(file, sec) {
-		struct instruction *insns = NULL;
-		u8 prev_len = 0;
-		u8 idx = 0;
-
-		if (!(sec->sh.sh_flags & SHF_EXECINSTR))
-			continue;
-
-		if (strcmp(sec->name, ".altinstr_replacement") &&
-		    strcmp(sec->name, ".altinstr_aux") &&
-		    strncmp(sec->name, ".discard.", 9))
-			sec->text = true;
-
-		if (!strcmp(sec->name, ".noinstr.text") ||
-		    !strcmp(sec->name, ".entry.text") ||
-		    !strcmp(sec->name, ".cpuidle.text") ||
-		    !strncmp(sec->name, ".text.__x86.", 12))
-			sec->noinstr = true;
-
-		/*
-		 * .init.text code is ran before userspace and thus doesn't
-		 * strictly need retpolines, except for modules which are
-		 * loaded late, they very much do need retpoline in their
-		 * .init.text
-		 */
-		if (!strcmp(sec->name, ".init.text") && !opts.module)
-			sec->init = true;
-
-		for (offset = 0; offset < sec->sh.sh_size; offset += insn->len) {
-			if (!insns || idx == INSN_CHUNK_MAX) {
-				insns = calloc(sizeof(*insn), INSN_CHUNK_SIZE);
-				if (!insns) {
-					WARN("malloc failed");
-					return -1;
-				}
-				idx = 0;
-			} else {
-				idx++;
-			}
-			insn = &insns[idx];
-			insn->idx = idx;
-
-			INIT_LIST_HEAD(&insn->call_node);
-			insn->sec = sec;
-			insn->offset = offset;
-			insn->prev_len = prev_len;
-
-			ret = arch_decode_instruction(file, sec, offset,
-						      sec->sh.sh_size - offset,
-						      insn);
-			if (ret)
-				return ret;
-
-			prev_len = insn->len;
-
-			/*
-			 * By default, "ud2" is a dead end unless otherwise
-			 * annotated, because GCC 7 inserts it for certain
-			 * divide-by-zero cases.
-			 */
-			if (insn->type == INSN_BUG)
-				insn->dead_end = true;
-
-			hash_add(file->insn_hash, &insn->hash, sec_offset_hash(sec, insn->offset));
-			nr_insns++;
-		}
-
-//		printf("%s: last chunk used: %d\n", sec->name, (int)idx);
-
-		list_for_each_entry(func, &sec->symbol_list, list) {
-			if (func->type != STT_NOTYPE && func->type != STT_FUNC)
-				continue;
-
-			if (func->offset == sec->sh.sh_size) {
-				/* Heuristic: likely an "end" symbol */
-				if (func->type == STT_NOTYPE)
-					continue;
-				WARN("%s(): STT_FUNC at end of section",
-				     func->name);
-				return -1;
-			}
-
-			if (func->return_thunk || func->alias != func)
-				continue;
-
-			if (!find_insn(file, sec, func->offset)) {
-				WARN("%s(): can't find starting instruction",
-				     func->name);
-				return -1;
-			}
-
-			sym_for_each_insn(file, func, insn) {
-				insn->sym = func;
-				if (func->type == STT_FUNC &&
-				    insn->type == INSN_ENDBR &&
-				    list_empty(&insn->call_node)) {
-					if (insn->offset == func->offset) {
-						list_add_tail(&insn->call_node, &file->endbr_list);
-						file->nr_endbr++;
-					} else {
-						file->nr_endbr_int++;
-					}
-				}
-			}
-		}
-	}
-
-	if (opts.stats)
-		printf("nr_insns: %lu\n", nr_insns);
-
-	return 0;
-}
-
 /*
  * Read the pv_ops[] .data table to find the static initialized values.
  */
diff --git a/tools/objtool/decode.c b/tools/objtool/decode.c
new file mode 100644
index 000000000000..f369412ffce1
--- /dev/null
+++ b/tools/objtool/decode.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2015-2017 Josh Poimboeuf <jpoimboe@redhat.com>
+ */
+#include <linux/objtool.h>
+
+#include <objtool/builtin.h>
+#include <objtool/check.h>
+#include <objtool/insn.h>
+#include <objtool/warn.h>
+
+/*
+ * Call the arch-specific instruction decoder for all the instructions and add
+ * them to the global instruction list.
+ */
+int decode_instructions(struct objtool_file *file)
+{
+	struct section *sec;
+	struct symbol *func;
+	unsigned long offset;
+	struct instruction *insn;
+	int ret;
+
+	for_each_sec(file, sec) {
+		struct instruction *insns = NULL;
+		u8 prev_len = 0;
+		u8 idx = 0;
+
+		if (!(sec->sh.sh_flags & SHF_EXECINSTR))
+			continue;
+
+		if (strcmp(sec->name, ".altinstr_replacement") &&
+		    strcmp(sec->name, ".altinstr_aux") &&
+		    strncmp(sec->name, ".discard.", 9))
+			sec->text = true;
+
+		if (!strcmp(sec->name, ".noinstr.text") ||
+		    !strcmp(sec->name, ".entry.text") ||
+		    !strcmp(sec->name, ".cpuidle.text") ||
+		    !strncmp(sec->name, ".text.__x86.", 12))
+			sec->noinstr = true;
+
+		/*
+		 * .init.text code is ran before userspace and thus doesn't
+		 * strictly need retpolines, except for modules which are
+		 * loaded late, they very much do need retpoline in their
+		 * .init.text
+		 */
+		if (!strcmp(sec->name, ".init.text") && !opts.module)
+			sec->init = true;
+
+		for (offset = 0; offset < sec->sh.sh_size; offset += insn->len) {
+			if (!insns || idx == INSN_CHUNK_MAX) {
+				insns = calloc(sizeof(*insn), INSN_CHUNK_SIZE);
+				if (!insns) {
+					WARN("malloc failed");
+					return -1;
+				}
+				idx = 0;
+			} else {
+				idx++;
+			}
+			insn = &insns[idx];
+			insn->idx = idx;
+
+			INIT_LIST_HEAD(&insn->call_node);
+			insn->sec = sec;
+			insn->offset = offset;
+			insn->prev_len = prev_len;
+
+			ret = arch_decode_instruction(file, sec, offset,
+						      sec->sh.sh_size - offset,
+						      insn);
+			if (ret)
+				return ret;
+
+			prev_len = insn->len;
+
+			/*
+			 * By default, "ud2" is a dead end unless otherwise
+			 * annotated, because GCC 7 inserts it for certain
+			 * divide-by-zero cases.
+			 */
+			if (insn->type == INSN_BUG)
+				insn->dead_end = true;
+
+			hash_add(file->insn_hash, &insn->hash, sec_offset_hash(sec, insn->offset));
+			nr_insns++;
+		}
+
+//		printf("%s: last chunk used: %d\n", sec->name, (int)idx);
+
+		list_for_each_entry(func, &sec->symbol_list, list) {
+			if (func->type != STT_NOTYPE && func->type != STT_FUNC)
+				continue;
+
+			if (func->offset == sec->sh.sh_size) {
+				/* Heuristic: likely an "end" symbol */
+				if (func->type == STT_NOTYPE)
+					continue;
+				WARN("%s(): STT_FUNC at end of section",
+				     func->name);
+				return -1;
+			}
+
+			if (func->return_thunk || func->alias != func)
+				continue;
+
+			if (!find_insn(file, sec, func->offset)) {
+				WARN("%s(): can't find starting instruction",
+				     func->name);
+				return -1;
+			}
+
+			sym_for_each_insn(file, func, insn) {
+				insn->sym = func;
+				if (func->type == STT_FUNC &&
+				    insn->type == INSN_ENDBR &&
+				    list_empty(&insn->call_node)) {
+					if (insn->offset == func->offset) {
+						list_add_tail(&insn->call_node, &file->endbr_list);
+						file->nr_endbr++;
+					} else {
+						file->nr_endbr_int++;
+					}
+				}
+			}
+		}
+	}
+
+	if (opts.stats)
+		printf("nr_insns: %lu\n", nr_insns);
+
+	return 0;
+}
+
diff --git a/tools/objtool/include/objtool/check.h b/tools/objtool/include/objtool/check.h
index 450ebc092b1f..34898364bf03 100644
--- a/tools/objtool/include/objtool/check.h
+++ b/tools/objtool/include/objtool/check.h
@@ -31,4 +31,6 @@ struct alt_group {
 #define VISITED_BRANCH_MASK	0x03
 #define VISITED_ENTRY		0x04
 
+extern unsigned long nr_insns;
+
 #endif /* _CHECK_H */
diff --git a/tools/objtool/include/objtool/insn.h b/tools/objtool/include/objtool/insn.h
index edd46b5ea1e4..92f8f1ff6c09 100644
--- a/tools/objtool/include/objtool/insn.h
+++ b/tools/objtool/include/objtool/insn.h
@@ -127,6 +127,8 @@ bool is_first_func_insn(struct objtool_file *file,
 			       struct instruction *insn, struct symbol *sym);
 
 
+int decode_instructions(struct objtool_file *file);
+
 #define for_each_insn(file, insn)					\
 	for (struct section *__sec, *__fake = (struct section *)1;	\
 	     __fake; __fake = NULL)					\
-- 
2.39.2

