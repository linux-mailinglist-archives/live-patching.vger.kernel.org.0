Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A028531FA0
	for <lists+live-patching@lfdr.de>; Tue, 24 May 2022 02:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiEXAQy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 23 May 2022 20:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbiEXAQw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 23 May 2022 20:16:52 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 82A3A6CF4A;
        Mon, 23 May 2022 17:16:49 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 6B09120B87F3;
        Mon, 23 May 2022 17:16:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6B09120B87F3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1653351409;
        bh=9y9cKfbuBrO4EQ8RsLvl2cKNoiaW3hR9J0HP0SgQ7u0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=i404wv+sEbiZeISJwXrV6WeDh+LN1W9HkOvwtb9lKhqKCwjzbUyjC6IvG81oaTtUU
         e89NHGe+cavsthhRcY6+Pl0S4FbdAgo5pA/r4aZLc7H3o9NnzsAMw3PN2FFkd3EGAT
         jIpueh+uizFJX1JyOj9Nv9ORukALbNDuckET/4bc=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 02/20] objtool: Reorganize instruction-related code
Date:   Mon, 23 May 2022 19:16:19 -0500
Message-Id: <20220524001637.1707472-3-madvenka@linux.microsoft.com>
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

check.c implements static stack validation. But the instruction-related
code that it contains can be shared with other types of validation. E.g.,
dynamic FP validation. Move the instruction-related code to its own files
- insn.h and insn.c.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 tools/objtool/Build                   |   2 +
 tools/objtool/check.c                 | 191 --------------------------
 tools/objtool/include/objtool/check.h |  74 +---------
 tools/objtool/include/objtool/insn.h  | 121 ++++++++++++++++
 tools/objtool/insn.c                  | 177 ++++++++++++++++++++++++
 5 files changed, 301 insertions(+), 264 deletions(-)
 create mode 100644 tools/objtool/include/objtool/insn.h
 create mode 100644 tools/objtool/insn.c

diff --git a/tools/objtool/Build b/tools/objtool/Build
index 695cfee5cfde..52ed2f710d2a 100644
--- a/tools/objtool/Build
+++ b/tools/objtool/Build
@@ -4,9 +4,11 @@ objtool-y += weak.o
 
 objtool-$(SUBCMD_CHECK) += check.o
 objtool-$(SUBCMD_CHECK) += cfi.o
+objtool-$(SUBCMD_CHECK) += insn.o
 objtool-$(SUBCMD_CHECK) += special.o
 objtool-$(SUBCMD_ORC) += check.o
 objtool-$(SUBCMD_ORC) += cfi.o
+objtool-$(SUBCMD_ORC) += insn.o
 objtool-$(SUBCMD_ORC) += orc_gen.o
 objtool-$(SUBCMD_ORC) += orc_dump.o
 
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 12acc9d329de..78168e0ad2bf 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -27,86 +27,6 @@ struct alternative {
 	bool skip_orig;
 };
 
-struct instruction *find_insn(struct objtool_file *file,
-			      struct section *sec, unsigned long offset)
-{
-	struct instruction *insn;
-
-	hash_for_each_possible(file->insn_hash, insn, hash, sec_offset_hash(sec, offset)) {
-		if (insn->sec == sec && insn->offset == offset)
-			return insn;
-	}
-
-	return NULL;
-}
-
-static struct instruction *next_insn_same_sec(struct objtool_file *file,
-					      struct instruction *insn)
-{
-	struct instruction *next = list_next_entry(insn, list);
-
-	if (!next || &next->list == &file->insn_list || next->sec != insn->sec)
-		return NULL;
-
-	return next;
-}
-
-static struct instruction *next_insn_same_func(struct objtool_file *file,
-					       struct instruction *insn)
-{
-	struct instruction *next = list_next_entry(insn, list);
-	struct symbol *func = insn->func;
-
-	if (!func)
-		return NULL;
-
-	if (&next->list != &file->insn_list && next->func == func)
-		return next;
-
-	/* Check if we're already in the subfunction: */
-	if (func == func->cfunc)
-		return NULL;
-
-	/* Move to the subfunction: */
-	return find_insn(file, func->cfunc->sec, func->cfunc->offset);
-}
-
-static struct instruction *prev_insn_same_sym(struct objtool_file *file,
-					       struct instruction *insn)
-{
-	struct instruction *prev = list_prev_entry(insn, list);
-
-	if (&prev->list != &file->insn_list && prev->func == insn->func)
-		return prev;
-
-	return NULL;
-}
-
-#define func_for_each_insn(file, func, insn)				\
-	for (insn = find_insn(file, func->sec, func->offset);		\
-	     insn;							\
-	     insn = next_insn_same_func(file, insn))
-
-#define sym_for_each_insn(file, sym, insn)				\
-	for (insn = find_insn(file, sym->sec, sym->offset);		\
-	     insn && &insn->list != &file->insn_list &&			\
-		insn->sec == sym->sec &&				\
-		insn->offset < sym->offset + sym->len;			\
-	     insn = list_next_entry(insn, list))
-
-#define sym_for_each_insn_continue_reverse(file, sym, insn)		\
-	for (insn = list_prev_entry(insn, list);			\
-	     &insn->list != &file->insn_list &&				\
-		insn->sec == sym->sec && insn->offset >= sym->offset;	\
-	     insn = list_prev_entry(insn, list))
-
-#define sec_for_each_insn_from(file, insn)				\
-	for (; insn; insn = next_insn_same_sec(file, insn))
-
-#define sec_for_each_insn_continue(file, insn)				\
-	for (insn = next_insn_same_sec(file, insn); insn;		\
-	     insn = next_insn_same_sec(file, insn))
-
 static bool is_jump_table_jump(struct instruction *insn)
 {
 	struct alt_group *alt_group = insn->alt_group;
@@ -243,20 +163,6 @@ static bool dead_end_function(struct objtool_file *file, struct symbol *func)
 	return __dead_end_function(file, func, 0);
 }
 
-static void init_insn_state(struct insn_state *state, struct section *sec)
-{
-	memset(state, 0, sizeof(*state));
-	init_cfi_state(&state->cfi);
-
-	/*
-	 * We need the full vmlinux for noinstr validation, otherwise we can
-	 * not correctly determine insn->call_dest->sec (external symbols do
-	 * not have a section).
-	 */
-	if (vmlinux && noinstr && sec)
-		state->noinstr = sec->noinstr;
-}
-
 static unsigned long nr_insns;
 static unsigned long nr_insns_visited;
 
@@ -431,19 +337,6 @@ static int init_pv_ops(struct objtool_file *file)
 	return 0;
 }
 
-static struct instruction *find_last_insn(struct objtool_file *file,
-					  struct section *sec)
-{
-	struct instruction *insn = NULL;
-	unsigned int offset;
-	unsigned int end = (sec->sh.sh_size > 10) ? sec->sh.sh_size - 10 : 0;
-
-	for (offset = sec->sh.sh_size - 1; offset >= end && !insn; offset--)
-		insn = find_insn(file, sec, offset);
-
-	return insn;
-}
-
 /*
  * Mark "ud2" instructions and manually annotated dead ends.
  */
@@ -990,28 +883,6 @@ __weak bool arch_is_retpoline(struct symbol *sym)
 	return false;
 }
 
-#define NEGATIVE_RELOC	((void *)-1L)
-
-static struct reloc *insn_reloc(struct objtool_file *file, struct instruction *insn)
-{
-	if (insn->reloc == NEGATIVE_RELOC)
-		return NULL;
-
-	if (!insn->reloc) {
-		if (!file)
-			return NULL;
-
-		insn->reloc = find_reloc_by_dest_range(file->elf, insn->sec,
-						       insn->offset, insn->len);
-		if (!insn->reloc) {
-			insn->reloc = NEGATIVE_RELOC;
-			return NULL;
-		}
-	}
-
-	return insn->reloc;
-}
-
 static void remove_insn_ops(struct instruction *insn)
 {
 	struct stack_op *op, *tmp;
@@ -1146,18 +1017,6 @@ static void add_retpoline_call(struct objtool_file *file, struct instruction *in
 	annotate_call_site(file, insn, false);
 }
 
-static bool same_function(struct instruction *insn1, struct instruction *insn2)
-{
-	return insn1->func->pfunc == insn2->func->pfunc;
-}
-
-static bool is_first_func_insn(struct instruction *insn)
-{
-	return insn->offset == insn->func->offset ||
-	       (insn->type == INSN_ENDBR &&
-		insn->offset == insn->func->offset + insn->len);
-}
-
 /*
  * Find the destination instructions for all jumps.
  */
@@ -2826,56 +2685,6 @@ static int handle_insn_ops(struct instruction *insn,
 	return 0;
 }
 
-static bool insn_cfi_match(struct instruction *insn, struct cfi_state *cfi2)
-{
-	struct cfi_state *cfi1 = insn->cfi;
-	int i;
-
-	if (!cfi1) {
-		WARN("CFI missing");
-		return false;
-	}
-
-	if (memcmp(&cfi1->cfa, &cfi2->cfa, sizeof(cfi1->cfa))) {
-
-		WARN_FUNC("stack state mismatch: cfa1=%d%+d cfa2=%d%+d",
-			  insn->sec, insn->offset,
-			  cfi1->cfa.base, cfi1->cfa.offset,
-			  cfi2->cfa.base, cfi2->cfa.offset);
-
-	} else if (memcmp(&cfi1->regs, &cfi2->regs, sizeof(cfi1->regs))) {
-		for (i = 0; i < CFI_NUM_REGS; i++) {
-			if (!memcmp(&cfi1->regs[i], &cfi2->regs[i],
-				    sizeof(struct cfi_reg)))
-				continue;
-
-			WARN_FUNC("stack state mismatch: reg1[%d]=%d%+d reg2[%d]=%d%+d",
-				  insn->sec, insn->offset,
-				  i, cfi1->regs[i].base, cfi1->regs[i].offset,
-				  i, cfi2->regs[i].base, cfi2->regs[i].offset);
-			break;
-		}
-
-	} else if (cfi1->type != cfi2->type) {
-
-		WARN_FUNC("stack state mismatch: type1=%d type2=%d",
-			  insn->sec, insn->offset, cfi1->type, cfi2->type);
-
-	} else if (cfi1->drap != cfi2->drap ||
-		   (cfi1->drap && cfi1->drap_reg != cfi2->drap_reg) ||
-		   (cfi1->drap && cfi1->drap_offset != cfi2->drap_offset)) {
-
-		WARN_FUNC("stack state mismatch: drap1=%d(%d,%d) drap2=%d(%d,%d)",
-			  insn->sec, insn->offset,
-			  cfi1->drap, cfi1->drap_reg, cfi1->drap_offset,
-			  cfi2->drap, cfi2->drap_reg, cfi2->drap_offset);
-
-	} else
-		return true;
-
-	return false;
-}
-
 static inline bool func_uaccess_safe(struct symbol *func)
 {
 	if (func)
diff --git a/tools/objtool/include/objtool/check.h b/tools/objtool/include/objtool/check.h
index f10d7374f388..7c9d55319986 100644
--- a/tools/objtool/include/objtool/check.h
+++ b/tools/objtool/include/objtool/check.h
@@ -7,17 +7,7 @@
 #define _CHECK_H
 
 #include <stdbool.h>
-#include <objtool/cfi.h>
-#include <objtool/arch.h>
-
-struct insn_state {
-	struct cfi_state cfi;
-	unsigned int uaccess_stack;
-	bool uaccess;
-	bool df;
-	bool noinstr;
-	s8 instr;
-};
+#include <objtool/insn.h>
 
 struct alt_group {
 	/*
@@ -36,66 +26,4 @@ struct alt_group {
 	struct cfi_state **cfi;
 };
 
-struct instruction {
-	struct list_head list;
-	struct hlist_node hash;
-	struct list_head call_node;
-	struct section *sec;
-	unsigned long offset;
-	unsigned int len;
-	enum insn_type type;
-	unsigned long immediate;
-
-	u8 dead_end	: 1,
-	   ignore	: 1,
-	   ignore_alts	: 1,
-	   hint		: 1,
-	   retpoline_safe : 1,
-	   noendbr	: 1;
-		/* 2 bit hole */
-	s8 instr;
-	u8 visited;
-	/* u8 hole */
-
-	struct alt_group *alt_group;
-	struct symbol *call_dest;
-	struct instruction *jump_dest;
-	struct instruction *first_jump_src;
-	struct reloc *jump_table;
-	struct reloc *reloc;
-	struct list_head alts;
-	struct symbol *func;
-	struct list_head stack_ops;
-	struct cfi_state *cfi;
-};
-
-static inline bool is_static_jump(struct instruction *insn)
-{
-	return insn->type == INSN_JUMP_CONDITIONAL ||
-	       insn->type == INSN_JUMP_UNCONDITIONAL;
-}
-
-static inline bool is_dynamic_jump(struct instruction *insn)
-{
-	return insn->type == INSN_JUMP_DYNAMIC ||
-	       insn->type == INSN_JUMP_DYNAMIC_CONDITIONAL;
-}
-
-static inline bool is_jump(struct instruction *insn)
-{
-	return is_static_jump(insn) || is_dynamic_jump(insn);
-}
-
-struct instruction *find_insn(struct objtool_file *file,
-			      struct section *sec, unsigned long offset);
-
-#define for_each_insn(file, insn)					\
-	list_for_each_entry(insn, &file->insn_list, list)
-
-#define sec_for_each_insn(file, sec, insn)				\
-	for (insn = find_insn(file, sec, 0);				\
-	     insn && &insn->list != &file->insn_list &&			\
-			insn->sec == sec;				\
-	     insn = list_next_entry(insn, list))
-
 #endif /* _CHECK_H */
diff --git a/tools/objtool/include/objtool/insn.h b/tools/objtool/include/objtool/insn.h
new file mode 100644
index 000000000000..1b9fce586679
--- /dev/null
+++ b/tools/objtool/include/objtool/insn.h
@@ -0,0 +1,121 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2017 Josh Poimboeuf <jpoimboe@redhat.com>
+ */
+
+#ifndef _INSN_H
+#define _INSN_H
+
+#include <objtool/objtool.h>
+#include <objtool/arch.h>
+
+struct insn_state {
+	struct cfi_state cfi;
+	unsigned int uaccess_stack;
+	bool uaccess;
+	bool df;
+	bool noinstr;
+	s8 instr;
+};
+
+struct instruction {
+	struct list_head list;
+	struct hlist_node hash;
+	struct list_head call_node;
+	struct section *sec;
+	unsigned long offset;
+	unsigned int len;
+	enum insn_type type;
+	unsigned long immediate;
+
+	u8 dead_end	: 1,
+	   ignore	: 1,
+	   ignore_alts	: 1,
+	   hint		: 1,
+	   retpoline_safe : 1,
+	   noendbr	: 1;
+		/* 2 bit hole */
+	s8 instr;
+	u8 visited;
+	/* u8 hole */
+
+	struct alt_group *alt_group;
+	struct symbol *call_dest;
+	struct instruction *jump_dest;
+	struct instruction *first_jump_src;
+	struct reloc *jump_table;
+	struct reloc *reloc;
+	struct list_head alts;
+	struct symbol *func;
+	struct list_head stack_ops;
+	struct cfi_state *cfi;
+};
+
+static inline bool is_static_jump(struct instruction *insn)
+{
+	return insn->type == INSN_JUMP_CONDITIONAL ||
+	       insn->type == INSN_JUMP_UNCONDITIONAL;
+}
+
+static inline bool is_dynamic_jump(struct instruction *insn)
+{
+	return insn->type == INSN_JUMP_DYNAMIC ||
+	       insn->type == INSN_JUMP_DYNAMIC_CONDITIONAL;
+}
+
+static inline bool is_jump(struct instruction *insn)
+{
+	return is_static_jump(insn) || is_dynamic_jump(insn);
+}
+
+void init_insn_state(struct insn_state *state, struct section *sec);
+struct instruction *find_insn(struct objtool_file *file,
+			      struct section *sec, unsigned long offset);
+struct instruction *find_last_insn(struct objtool_file *file,
+				   struct section *sec);
+struct instruction *prev_insn_same_sym(struct objtool_file *file,
+				       struct instruction *insn);
+struct instruction *next_insn_same_sec(struct objtool_file *file,
+				       struct instruction *insn);
+struct instruction *next_insn_same_func(struct objtool_file *file,
+					struct instruction *insn);
+struct reloc *insn_reloc(struct objtool_file *file, struct instruction *insn);
+bool insn_cfi_match(struct instruction *insn, struct cfi_state *cfi2);
+bool same_function(struct instruction *insn1, struct instruction *insn2);
+bool is_first_func_insn(struct instruction *insn);
+
+#define for_each_insn(file, insn)					\
+	list_for_each_entry(insn, &file->insn_list, list)
+
+#define sec_for_each_insn(file, sec, insn)				\
+	for (insn = find_insn(file, sec, 0);				\
+	     insn && &insn->list != &file->insn_list &&			\
+			insn->sec == sec;				\
+	     insn = list_next_entry(insn, list))
+
+#define func_for_each_insn(file, func, insn)				\
+	for (insn = find_insn(file, func->sec, func->offset);		\
+	     insn;							\
+	     insn = next_insn_same_func(file, insn))
+
+#define sym_for_each_insn(file, sym, insn)				\
+	for (insn = find_insn(file, sym->sec, sym->offset);		\
+	     insn && &insn->list != &file->insn_list &&			\
+		insn->sec == sym->sec &&				\
+		insn->offset < sym->offset + sym->len;			\
+	     insn = list_next_entry(insn, list))
+
+#define sym_for_each_insn_continue_reverse(file, sym, insn)		\
+	for (insn = list_prev_entry(insn, list);			\
+	     &insn->list != &file->insn_list &&				\
+		insn->sec == sym->sec && insn->offset >= sym->offset;	\
+	     insn = list_prev_entry(insn, list))
+
+#define sec_for_each_insn_from(file, insn)				\
+	for (; insn; insn = next_insn_same_sec(file, insn))
+
+#define sec_for_each_insn_continue(file, insn)				\
+	for (insn = next_insn_same_sec(file, insn); insn;		\
+	     insn = next_insn_same_sec(file, insn))
+
+#endif /* _INSN_H */
diff --git a/tools/objtool/insn.c b/tools/objtool/insn.c
new file mode 100644
index 000000000000..669fca9b8e0d
--- /dev/null
+++ b/tools/objtool/insn.c
@@ -0,0 +1,177 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2015-2017 Josh Poimboeuf <jpoimboe@redhat.com>
+ */
+
+#include <string.h>
+
+#include <objtool/builtin.h>
+#include <objtool/insn.h>
+#include <objtool/warn.h>
+
+struct instruction *find_insn(struct objtool_file *file,
+			      struct section *sec, unsigned long offset)
+{
+	struct instruction *insn;
+
+	offset -= sec->sh.sh_addr;
+	hash_for_each_possible(file->insn_hash, insn, hash, sec_offset_hash(sec, offset)) {
+		if (insn->sec == sec && insn->offset == offset)
+			return insn;
+	}
+
+	return NULL;
+}
+
+struct instruction *next_insn_same_sec(struct objtool_file *file,
+				       struct instruction *insn)
+{
+	struct instruction *next = list_next_entry(insn, list);
+
+	if (!next || &next->list == &file->insn_list || next->sec != insn->sec)
+		return NULL;
+
+	return next;
+}
+
+struct instruction *next_insn_same_func(struct objtool_file *file,
+					struct instruction *insn)
+{
+	struct instruction *next = list_next_entry(insn, list);
+	struct symbol *func = insn->func;
+
+	if (!func)
+		return NULL;
+
+	if (&next->list != &file->insn_list && next->func == func)
+		return next;
+
+	/* Check if we're already in the subfunction: */
+	if (func == func->cfunc)
+		return NULL;
+
+	/* Move to the subfunction: */
+	return find_insn(file, func->cfunc->sec, func->cfunc->offset);
+}
+
+struct instruction *prev_insn_same_sym(struct objtool_file *file,
+				       struct instruction *insn)
+{
+	struct instruction *prev = list_prev_entry(insn, list);
+
+	if (&prev->list != &file->insn_list && prev->func == insn->func)
+		return prev;
+
+	return NULL;
+}
+
+struct instruction *find_last_insn(struct objtool_file *file,
+				   struct section *sec)
+{
+	struct instruction *insn = NULL;
+	unsigned int offset;
+	unsigned int end = (sec->sh.sh_size > 10) ? sec->sh.sh_size - 10 : 0;
+
+	for (offset = sec->sh.sh_size - 1; offset >= end && !insn; offset--)
+		insn = find_insn(file, sec, offset);
+
+	return insn;
+}
+
+bool same_function(struct instruction *insn1, struct instruction *insn2)
+{
+	return insn1->func->pfunc == insn2->func->pfunc;
+}
+
+bool is_first_func_insn(struct instruction *insn)
+{
+	return insn->offset == insn->func->offset ||
+	       (insn->type == INSN_ENDBR &&
+		insn->offset == insn->func->offset + insn->len);
+}
+
+bool insn_cfi_match(struct instruction *insn, struct cfi_state *cfi2)
+{
+	struct cfi_state *cfi1 = insn->cfi;
+	int i;
+
+	if (!cfi1) {
+		WARN("CFI missing");
+		return false;
+	}
+
+	if (memcmp(&cfi1->cfa, &cfi2->cfa, sizeof(cfi1->cfa))) {
+
+		WARN_FUNC("stack state mismatch: cfa1=%d%+d cfa2=%d%+d",
+			  insn->sec, insn->offset,
+			  cfi1->cfa.base, cfi1->cfa.offset,
+			  cfi2->cfa.base, cfi2->cfa.offset);
+
+	} else if (memcmp(&cfi1->regs, &cfi2->regs, sizeof(cfi1->regs))) {
+		for (i = 0; i < CFI_NUM_REGS; i++) {
+			if (!memcmp(&cfi1->regs[i], &cfi2->regs[i],
+				    sizeof(struct cfi_reg)))
+				continue;
+
+			WARN_FUNC("stack state mismatch: reg1[%d]=%d%+d reg2[%d]=%d%+d",
+				  insn->sec, insn->offset,
+				  i, cfi1->regs[i].base, cfi1->regs[i].offset,
+				  i, cfi2->regs[i].base, cfi2->regs[i].offset);
+			break;
+		}
+
+	} else if (cfi1->type != cfi2->type) {
+
+		WARN_FUNC("stack state mismatch: type1=%d type2=%d",
+			  insn->sec, insn->offset, cfi1->type, cfi2->type);
+
+	} else if (cfi1->drap != cfi2->drap ||
+		   (cfi1->drap && cfi1->drap_reg != cfi2->drap_reg) ||
+		   (cfi1->drap && cfi1->drap_offset != cfi2->drap_offset)) {
+
+		WARN_FUNC("stack state mismatch: drap1=%d(%d,%d) drap2=%d(%d,%d)",
+			  insn->sec, insn->offset,
+			  cfi1->drap, cfi1->drap_reg, cfi1->drap_offset,
+			  cfi2->drap, cfi2->drap_reg, cfi2->drap_offset);
+
+	} else
+		return true;
+
+	return false;
+}
+
+void init_insn_state(struct insn_state *state, struct section *sec)
+{
+	memset(state, 0, sizeof(*state));
+	init_cfi_state(&state->cfi);
+
+	/*
+	 * We need the full vmlinux for noinstr validation, otherwise we can
+	 * not correctly determine insn->call_dest->sec (external symbols do
+	 * not have a section).
+	 */
+	if (vmlinux && noinstr && sec)
+		state->noinstr = sec->noinstr;
+}
+
+#define NEGATIVE_RELOC	((void *)-1L)
+
+struct reloc *insn_reloc(struct objtool_file *file, struct instruction *insn)
+{
+	if (insn->reloc == NEGATIVE_RELOC)
+		return NULL;
+
+	if (!insn->reloc) {
+		if (!file)
+			return NULL;
+
+		insn->reloc = find_reloc_by_dest_range(file->elf, insn->sec,
+						       insn->offset, insn->len);
+		if (!insn->reloc) {
+			insn->reloc = NEGATIVE_RELOC;
+			return NULL;
+		}
+	}
+
+	return insn->reloc;
+}
-- 
2.25.1

