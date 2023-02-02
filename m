Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710F9687686
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 08:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbjBBHmb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 02:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbjBBHma (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 02:42:30 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B6F96751AD;
        Wed,  1 Feb 2023 23:42:28 -0800 (PST)
Received: from x64host.home (unknown [47.187.213.40])
        by linux.microsoft.com (Postfix) with ESMTPSA id B550620B74F9;
        Wed,  1 Feb 2023 23:42:27 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B550620B74F9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675323748;
        bh=VgJmVJl6Papix+FhD8GwfbZQPwIUNdokfUvzBDbDxWI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=IDYMbof1UTFfrC5kbDefzSA8lVeQcs595K/O7jT7jQiIyQjeMmrU+FNh9s6oyigYw
         6+fCMZAcA9nxed7a8EJRiRrdCto8ECYtpXzlriME7w0dNdRd+ltE0j2FGHEbb72Nzy
         jBt5KRq7KPVb3EHA6Va+x3Mb2KZ+l6S5jVdGVq+A=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 03/22] objtool: Move decode_instructions() to a separate file
Date:   Thu,  2 Feb 2023 01:40:17 -0600
Message-Id: <20230202074036.507249-4-madvenka@linux.microsoft.com>
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

check.c implements static stack validation. But decode_instructions() which
resides in it can be shared with other types of validation. E.g., dynamic
FP validation. Move the function to its own file - decode.c.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 tools/objtool/Build                  |   1 +
 tools/objtool/check.c                |  97 ------------------------
 tools/objtool/decode.c               | 107 +++++++++++++++++++++++++++
 tools/objtool/include/objtool/insn.h |   2 +
 4 files changed, 110 insertions(+), 97 deletions(-)
 create mode 100644 tools/objtool/decode.c

diff --git a/tools/objtool/Build b/tools/objtool/Build
index 1149048e6b3e..8afe56cd0c2d 100644
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
index d208086a8a18..be3f6564104a 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -169,105 +169,8 @@ static bool dead_end_function(struct objtool_file *file, struct symbol *func)
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
-		    !strcmp(sec->name, ".entry.text") ||
-		    !strncmp(sec->name, ".text.__x86.", 12))
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
-	if (opts.stats)
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
index 000000000000..dcec3efc2afb
--- /dev/null
+++ b/tools/objtool/decode.c
@@ -0,0 +1,107 @@
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
+		    !strcmp(sec->name, ".entry.text") ||
+		    !strncmp(sec->name, ".text.__x86.", 12))
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
+	if (opts.stats)
+		printf("nr_insns: %lu\n", nr_insns);
+
+	return 0;
+
+err:
+	free(insn);
+	return ret;
+}
diff --git a/tools/objtool/include/objtool/insn.h b/tools/objtool/include/objtool/insn.h
index b40756a38994..b74c7f0d9076 100644
--- a/tools/objtool/include/objtool/insn.h
+++ b/tools/objtool/include/objtool/insn.h
@@ -88,6 +88,8 @@ bool insn_cfi_match(struct instruction *insn, struct cfi_state *cfi2);
 bool same_function(struct instruction *insn1, struct instruction *insn2);
 bool is_first_func_insn(struct objtool_file *file, struct instruction *insn);
 
+int decode_instructions(struct objtool_file *file);
+
 #define for_each_insn(file, insn)					\
 	list_for_each_entry(insn, &file->insn_list, list)
 
-- 
2.25.1

