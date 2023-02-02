Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2536F687685
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 08:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjBBHma (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 02:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbjBBHm3 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 02:42:29 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C66AD751BE;
        Wed,  1 Feb 2023 23:42:27 -0800 (PST)
Received: from x64host.home (unknown [47.187.213.40])
        by linux.microsoft.com (Postfix) with ESMTPSA id AA81E20B74F8;
        Wed,  1 Feb 2023 23:42:26 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AA81E20B74F8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675323747;
        bh=Dvi0sg7fNuFFbBH2nQXmc7LKL1McUIEsYXR3ernuKUg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=l+zQFcwZXVAVxrTLIKvrKvC5DKsTieLcvIIOOTnUFliWxXaOMEkHTL0uh8OoX+eRF
         sYk7GrU4mZiOu51Q7on0MD7dozaRld9DmufEc16kdV/4nTDLBRok9zdjCQmjsWBIWx
         kdwO1HwVANVeHSVImlg/sim8QNdBCHYtd34/lGcc=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 02/22] objtool: Reorganize instruction-related code
Date:   Thu,  2 Feb 2023 01:40:16 -0600
Message-Id: <20230202074036.507249-3-madvenka@linux.microsoft.com>
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

check.c implements static stack validation. But the instruction-related
code that it contains can be shared with other types of validation. E.g.,
dynamic FP validation. Move the instruction-related code to its own files
- insn.h and insn.c.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 tools/objtool/Build                   |   1 +
 tools/objtool/check.c                 | 201 --------------------------
 tools/objtool/include/objtool/check.h |  77 +---------
 tools/objtool/include/objtool/insn.h  | 125 ++++++++++++++++
 tools/objtool/insn.c                  | 186 ++++++++++++++++++++++++
 5 files changed, 313 insertions(+), 277 deletions(-)
 create mode 100644 tools/objtool/include/objtool/insn.h
 create mode 100644 tools/objtool/insn.c

diff --git a/tools/objtool/Build b/tools/objtool/Build
index 21db9d79c69f..1149048e6b3e 100644
--- a/tools/objtool/Build
+++ b/tools/objtool/Build
@@ -6,6 +6,7 @@ objtool-y += check.o
 objtool-y += special.o
 objtool-y += builtin-check.o
 objtool-y += cfi.o
+objtool-y += insn.o
 objtool-y += elf.o
 objtool-y += objtool.o
 
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index e6a2afa08748..d208086a8a18 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -28,86 +28,6 @@ struct alternative {
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
@@ -249,21 +169,6 @@ static bool dead_end_function(struct objtool_file *file, struct symbol *func)
 	return __dead_end_function(file, func, 0);
 }
 
-static void init_insn_state(struct objtool_file *file, struct insn_state *state,
-			    struct section *sec)
-{
-	memset(state, 0, sizeof(*state));
-	init_cfi_state(&state->cfi);
-
-	/*
-	 * We need the full vmlinux for noinstr validation, otherwise we can
-	 * not correctly determine insn->call_dest->sec (external symbols do
-	 * not have a section).
-	 */
-	if (opts.link && opts.noinstr && sec)
-		state->noinstr = sec->noinstr;
-}
-
 static unsigned long nr_insns;
 static unsigned long nr_insns_visited;
 
@@ -439,19 +344,6 @@ static int init_pv_ops(struct objtool_file *file)
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
@@ -1072,28 +964,6 @@ __weak bool arch_is_rethunk(struct symbol *sym)
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
@@ -1252,27 +1122,6 @@ static void add_return_call(struct objtool_file *file, struct instruction *insn,
 		list_add_tail(&insn->call_node, &file->return_thunk_list);
 }
 
-static bool same_function(struct instruction *insn1, struct instruction *insn2)
-{
-	return insn1->func->pfunc == insn2->func->pfunc;
-}
-
-static bool is_first_func_insn(struct objtool_file *file, struct instruction *insn)
-{
-	if (insn->offset == insn->func->offset)
-		return true;
-
-	if (opts.ibt) {
-		struct instruction *prev = prev_insn_same_sym(file, insn);
-
-		if (prev && prev->type == INSN_ENDBR &&
-		    insn->offset == insn->func->offset + prev->len)
-			return true;
-	}
-
-	return false;
-}
-
 /*
  * Find the destination instructions for all jumps.
  */
@@ -2987,56 +2836,6 @@ static int handle_insn_ops(struct instruction *insn,
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
index 036129cebeee..a093f5cb100a 100644
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
@@ -36,74 +26,9 @@ struct alt_group {
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
-	u16 dead_end		: 1,
-	   ignore		: 1,
-	   ignore_alts		: 1,
-	   hint			: 1,
-	   save			: 1,
-	   restore		: 1,
-	   retpoline_safe	: 1,
-	   noendbr		: 1,
-	   entry		: 1;
-		/* 7 bit hole */
-
-	s8 instr;
-	u8 visited;
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
 #define VISITED_BRANCH		0x01
 #define VISITED_BRANCH_UACCESS	0x02
 #define VISITED_BRANCH_MASK	0x03
 #define VISITED_ENTRY		0x04
 
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
index 000000000000..b40756a38994
--- /dev/null
+++ b/tools/objtool/include/objtool/insn.h
@@ -0,0 +1,125 @@
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
+	u16 dead_end		: 1,
+	   ignore		: 1,
+	   ignore_alts		: 1,
+	   hint			: 1,
+	   save			: 1,
+	   restore		: 1,
+	   retpoline_safe	: 1,
+	   noendbr		: 1,
+	   entry		: 1;
+		/* 7 bit hole */
+
+	s8 instr;
+	u8 visited;
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
+void init_insn_state(struct objtool_file *file, struct insn_state *state,
+		     struct section *sec);
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
+bool is_first_func_insn(struct objtool_file *file, struct instruction *insn);
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
index 000000000000..e570b46ad39e
--- /dev/null
+++ b/tools/objtool/insn.c
@@ -0,0 +1,186 @@
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
+void init_insn_state(struct objtool_file *file, struct insn_state *state,
+		     struct section *sec)
+{
+	memset(state, 0, sizeof(*state));
+	init_cfi_state(&state->cfi);
+
+	/*
+	 * We need the full vmlinux for noinstr validation, otherwise we can
+	 * not correctly determine insn->call_dest->sec (external symbols do
+	 * not have a section).
+	 */
+	if (opts.link && opts.noinstr && sec)
+		state->noinstr = sec->noinstr;
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
+
+bool same_function(struct instruction *insn1, struct instruction *insn2)
+{
+	return insn1->func->pfunc == insn2->func->pfunc;
+}
+
+bool is_first_func_insn(struct objtool_file *file, struct instruction *insn)
+{
+	if (insn->offset == insn->func->offset)
+		return true;
+
+	if (opts.ibt) {
+		struct instruction *prev = prev_insn_same_sym(file, insn);
+
+		if (prev && prev->type == INSN_ENDBR &&
+		    insn->offset == insn->func->offset + prev->len)
+			return true;
+	}
+
+	return false;
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
-- 
2.25.1

