Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7633531FA1
	for <lists+live-patching@lfdr.de>; Tue, 24 May 2022 02:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiEXAQw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 23 May 2022 20:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiEXAQw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 23 May 2022 20:16:52 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D11B6CF4E;
        Mon, 23 May 2022 17:16:50 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7A49E20B87F6;
        Mon, 23 May 2022 17:16:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7A49E20B87F6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1653351410;
        bh=PrjM6sNWCbaOpnfA+c2bSGMaKIm9RjxL72wTSFxI6qc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=N5oJapbEd2k+mIf2MT3PqvMssXV2Hg5mEIlndw3toTXfRJIqSFIq8DFKNsEdXLRmA
         NaQd7x4nC43KjAcSSYr3lhrX4iSOmcQkNxWsaxLDP4octNv5y2mcSSXufmzLw6RNdl
         RaK+pdtWBUqFBdG54tIPJpI5LN0kSv1iiGTwfFAM=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 03/20] objtool: Move decode_instructions() to a separate file
Date:   Mon, 23 May 2022 19:16:20 -0500
Message-Id: <20220524001637.1707472-4-madvenka@linux.microsoft.com>
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

check.c implements static stack validation. But decode_instructions() which
resides in it can be shared with other types of validation. E.g., dynamic
FP validation. Move the function to its own file - decode.c.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 tools/objtool/Build                  |   2 +
 tools/objtool/check.c                |  96 ------------------------
 tools/objtool/decode.c               | 106 +++++++++++++++++++++++++++
 tools/objtool/include/objtool/insn.h |   1 +
 4 files changed, 109 insertions(+), 96 deletions(-)
 create mode 100644 tools/objtool/decode.c

diff --git a/tools/objtool/Build b/tools/objtool/Build
index 52ed2f710d2a..199561f86c1e 100644
--- a/tools/objtool/Build
+++ b/tools/objtool/Build
@@ -5,10 +5,12 @@ objtool-y += weak.o
 objtool-$(SUBCMD_CHECK) += check.o
 objtool-$(SUBCMD_CHECK) += cfi.o
 objtool-$(SUBCMD_CHECK) += insn.o
+objtool-$(SUBCMD_CHECK) += decode.o
 objtool-$(SUBCMD_CHECK) += special.o
 objtool-$(SUBCMD_ORC) += check.o
 objtool-$(SUBCMD_ORC) += cfi.o
 objtool-$(SUBCMD_ORC) += insn.o
+objtool-$(SUBCMD_ORC) += decode.o
 objtool-$(SUBCMD_ORC) += orc_gen.o
 objtool-$(SUBCMD_ORC) += orc_dump.o
 
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 78168e0ad2bf..334ddc737bf9 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -163,104 +163,8 @@ static bool dead_end_function(struct objtool_file *file, struct symbol *func)
 	return __dead_end_function(file, func, 0);
 }
 
-static unsigned long nr_insns;
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
-		    !strcmp(sec->name, ".entry.text"))
-			sec->noinstr = true;
-
-		for (offset = 0; offset < sec->sh.sh_size; offset += insn->len) {
-			insn = malloc(sizeof(*insn));
-			if (!insn) {
-				WARN("malloc failed");
-				return -1;
-			}
-			memset(insn, 0, sizeof(*insn));
-			INIT_LIST_HEAD(&insn->alts);
-			INIT_LIST_HEAD(&insn->stack_ops);
-			INIT_LIST_HEAD(&insn->call_node);
-
-			insn->sec = sec;
-			insn->offset = offset;
-
-			ret = arch_decode_instruction(file, sec, offset,
-						      sec->sh.sh_size - offset,
-						      &insn->len, &insn->type,
-						      &insn->immediate,
-						      &insn->stack_ops);
-			if (ret)
-				goto err;
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
-			list_add_tail(&insn->list, &file->insn_list);
-			nr_insns++;
-		}
-
-		list_for_each_entry(func, &sec->symbol_list, list) {
-			if (func->type != STT_FUNC || func->alias != func)
-				continue;
-
-			if (!find_insn(file, sec, func->offset)) {
-				WARN("%s(): can't find starting instruction",
-				     func->name);
-				return -1;
-			}
-
-			sym_for_each_insn(file, func, insn) {
-				insn->func = func;
-				if (insn->type == INSN_ENDBR && list_empty(&insn->call_node)) {
-					if (insn->offset == insn->func->offset) {
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
-	if (stats)
-		printf("nr_insns: %lu\n", nr_insns);
-
-	return 0;
-
-err:
-	free(insn);
-	return ret;
-}
-
 /*
  * Read the pv_ops[] .data table to find the static initialized values.
  */
diff --git a/tools/objtool/decode.c b/tools/objtool/decode.c
new file mode 100644
index 000000000000..4ed438ccc07f
--- /dev/null
+++ b/tools/objtool/decode.c
@@ -0,0 +1,106 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2015-2017 Josh Poimboeuf <jpoimboe@redhat.com>
+ */
+#include <linux/objtool.h>
+
+#include <objtool/builtin.h>
+#include <objtool/insn.h>
+#include <objtool/warn.h>
+
+static unsigned long nr_insns;
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
+		    !strcmp(sec->name, ".entry.text"))
+			sec->noinstr = true;
+
+		for (offset = 0; offset < sec->sh.sh_size; offset += insn->len) {
+			insn = malloc(sizeof(*insn));
+			if (!insn) {
+				WARN("malloc failed");
+				return -1;
+			}
+			memset(insn, 0, sizeof(*insn));
+			INIT_LIST_HEAD(&insn->alts);
+			INIT_LIST_HEAD(&insn->stack_ops);
+			INIT_LIST_HEAD(&insn->call_node);
+
+			insn->sec = sec;
+			insn->offset = offset;
+
+			ret = arch_decode_instruction(file, sec, offset,
+						      sec->sh.sh_size - offset,
+						      &insn->len, &insn->type,
+						      &insn->immediate,
+						      &insn->stack_ops);
+			if (ret)
+				goto err;
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
+			list_add_tail(&insn->list, &file->insn_list);
+			nr_insns++;
+		}
+
+		list_for_each_entry(func, &sec->symbol_list, list) {
+			if (func->type != STT_FUNC || func->alias != func)
+				continue;
+
+			if (!find_insn(file, sec, func->offset)) {
+				WARN("%s(): can't find starting instruction",
+				     func->name);
+				return -1;
+			}
+
+			sym_for_each_insn(file, func, insn) {
+				insn->func = func;
+				if (insn->type == INSN_ENDBR && list_empty(&insn->call_node)) {
+					if (insn->offset == insn->func->offset) {
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
+	if (stats)
+		printf("nr_insns: %lu\n", nr_insns);
+
+	return 0;
+
+err:
+	free(insn);
+	return ret;
+}
diff --git a/tools/objtool/include/objtool/insn.h b/tools/objtool/include/objtool/insn.h
index 1b9fce586679..5f01fd0ce8ed 100644
--- a/tools/objtool/include/objtool/insn.h
+++ b/tools/objtool/include/objtool/insn.h
@@ -83,6 +83,7 @@ struct reloc *insn_reloc(struct objtool_file *file, struct instruction *insn);
 bool insn_cfi_match(struct instruction *insn, struct cfi_state *cfi2);
 bool same_function(struct instruction *insn1, struct instruction *insn2);
 bool is_first_func_insn(struct instruction *insn);
+int decode_instructions(struct objtool_file *file);
 
 #define for_each_insn(file, insn)					\
 	list_for_each_entry(insn, &file->insn_list, list)
-- 
2.25.1

