Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04667736520
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 09:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjFTHr2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 03:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbjFTHr0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 03:47:26 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C61419A;
        Tue, 20 Jun 2023 00:47:19 -0700 (PDT)
Received: from loongson.cn (unknown [113.200.148.30])
        by gateway (Coremail) with SMTP id _____8CxvOqGWZFkmBoHAA--.14557S3;
        Tue, 20 Jun 2023 15:47:18 +0800 (CST)
Received: from bogon.localdomain (unknown [113.200.148.30])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxK8pvWZFkJGYhAA--.19652S4;
        Tue, 20 Jun 2023 15:47:16 +0800 (CST)
From:   Youling Tang <tangyouling@loongson.cn>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        madvenka@linux.microsoft.com
Cc:     chenzhongjin@huawei.com, WANG Xuerui <kernel@xen0n.name>,
        Xi Ruoyao <xry111@xry111.site>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        tangyouling00@gmail.com, youling.tang@outlook.com
Subject: [RFC PATCH v1 02/23] objtool: Reorganize instruction-related code
Date:   Tue, 20 Jun 2023 15:46:28 +0800
Message-Id: <1687247209-31676-3-git-send-email-tangyouling@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1687247209-31676-1-git-send-email-tangyouling@loongson.cn>
References: <1687247209-31676-1-git-send-email-tangyouling@loongson.cn>
X-CM-TRANSID: AQAAf8DxK8pvWZFkJGYhAA--.19652S4
X-CM-SenderInfo: 5wdqw5prxox03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj9fXoWfCr1rAw43uF4DCw4UXr4kXwc_yoW8uF1kZo
        W2qan8WrW8GryUCrWDAw1xJF45ua1kWr4UJrW5XrZ8u3Z8Aw1jgw1xua1UXa42qr40gFWU
        Ar9aqa48WFZ7WF1rl-sFpf9Il3svdjkaLaAFLSUrUUUUnb8apTn2vfkv8UJUUUU8wcxFpf
        9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
        UjIYCTnIWjp_UUUYC7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
        8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
        Y2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
        wI0_Gr1j6F4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
        xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
        Jw0_WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x
        0EwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
        bVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E74
        80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0
        I7IYx2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04
        k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7Cj
        xVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jz5lbUUUUU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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
 tools/objtool/check.c                 | 231 --------------------------
 tools/objtool/include/objtool/check.h |  92 +---------
 tools/objtool/include/objtool/insn.h  | 163 ++++++++++++++++++
 tools/objtool/insn.c                  | 195 ++++++++++++++++++++++
 5 files changed, 360 insertions(+), 322 deletions(-)
 create mode 100644 tools/objtool/include/objtool/insn.h
 create mode 100644 tools/objtool/insn.c

diff --git a/tools/objtool/Build b/tools/objtool/Build
index 9f23d1f4c716..c04e36267379 100644
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
index 803764f4d4d8..619f7467e39c 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -28,121 +28,6 @@ struct alternative {
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
-struct instruction *next_insn_same_sec(struct objtool_file *file,
-				       struct instruction *insn)
-{
-	if (insn->idx == INSN_CHUNK_MAX)
-		return find_insn(file, insn->sec, insn->offset + insn->len);
-
-	insn++;
-	if (!insn->len)
-		return NULL;
-
-	return insn;
-}
-
-static struct instruction *next_insn_same_func(struct objtool_file *file,
-					       struct instruction *insn)
-{
-	struct instruction *next = next_insn_same_sec(file, insn);
-	struct symbol *func = insn_func(insn);
-
-	if (!func)
-		return NULL;
-
-	if (next && insn_func(next) == func)
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
-static struct instruction *prev_insn_same_sec(struct objtool_file *file,
-					      struct instruction *insn)
-{
-	if (insn->idx == 0) {
-		if (insn->prev_len)
-			return find_insn(file, insn->sec, insn->offset - insn->prev_len);
-		return NULL;
-	}
-
-	return insn - 1;
-}
-
-static struct instruction *prev_insn_same_sym(struct objtool_file *file,
-					      struct instruction *insn)
-{
-	struct instruction *prev = prev_insn_same_sec(file, insn);
-
-	if (prev && insn_func(prev) == insn_func(insn))
-		return prev;
-
-	return NULL;
-}
-
-#define for_each_insn(file, insn)					\
-	for (struct section *__sec, *__fake = (struct section *)1;	\
-	     __fake; __fake = NULL)					\
-		for_each_sec(file, __sec)				\
-			sec_for_each_insn(file, __sec, insn)
-
-#define func_for_each_insn(file, func, insn)				\
-	for (insn = find_insn(file, func->sec, func->offset);		\
-	     insn;							\
-	     insn = next_insn_same_func(file, insn))
-
-#define sym_for_each_insn(file, sym, insn)				\
-	for (insn = find_insn(file, sym->sec, sym->offset);		\
-	     insn && insn->offset < sym->offset + sym->len;		\
-	     insn = next_insn_same_sec(file, insn))
-
-#define sym_for_each_insn_continue_reverse(file, sym, insn)		\
-	for (insn = prev_insn_same_sec(file, insn);			\
-	     insn && insn->offset >= sym->offset;			\
-	     insn = prev_insn_same_sec(file, insn))
-
-#define sec_for_each_insn_from(file, insn)				\
-	for (; insn; insn = next_insn_same_sec(file, insn))
-
-#define sec_for_each_insn_continue(file, insn)				\
-	for (insn = next_insn_same_sec(file, insn); insn;		\
-	     insn = next_insn_same_sec(file, insn))
-
-static inline struct symbol *insn_call_dest(struct instruction *insn)
-{
-	if (insn->type == INSN_JUMP_DYNAMIC ||
-	    insn->type == INSN_CALL_DYNAMIC)
-		return NULL;
-
-	return insn->_call_dest;
-}
-
-static inline struct reloc *insn_jump_table(struct instruction *insn)
-{
-	if (insn->type == INSN_JUMP_DYNAMIC ||
-	    insn->type == INSN_CALL_DYNAMIC)
-		return insn->_jump_table;
-
-	return NULL;
-}
-
 static bool is_jump_table_jump(struct instruction *insn)
 {
 	struct alt_group *alt_group = insn->alt_group;
@@ -282,21 +167,6 @@ static bool dead_end_function(struct objtool_file *file, struct symbol *func)
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
-	 * not correctly determine insn_call_dest(insn)->sec (external symbols
-	 * do not have a section).
-	 */
-	if (opts.link && opts.noinstr && sec)
-		state->noinstr = sec->noinstr;
-}
-
 static unsigned long nr_insns;
 static unsigned long nr_insns_visited;
 
@@ -501,19 +371,6 @@ static int init_pv_ops(struct objtool_file *file)
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
@@ -1263,26 +1120,6 @@ __weak bool arch_is_rethunk(struct symbol *sym)
 	return false;
 }
 
-static struct reloc *insn_reloc(struct objtool_file *file, struct instruction *insn)
-{
-	struct reloc *reloc;
-
-	if (insn->no_reloc)
-		return NULL;
-
-	if (!file)
-		return NULL;
-
-	reloc = find_reloc_by_dest_range(file->elf, insn->sec,
-					 insn->offset, insn->len);
-	if (!reloc) {
-		insn->no_reloc = 1;
-		return NULL;
-	}
-
-	return reloc;
-}
-
 static void remove_insn_ops(struct instruction *insn)
 {
 	struct stack_op *op, *next;
@@ -1446,24 +1283,6 @@ static void add_return_call(struct objtool_file *file, struct instruction *insn,
 		list_add_tail(&insn->call_node, &file->return_thunk_list);
 }
 
-static bool is_first_func_insn(struct objtool_file *file,
-			       struct instruction *insn, struct symbol *sym)
-{
-	if (insn->offset == sym->offset)
-		return true;
-
-	/* Allow direct CALL/JMP past ENDBR */
-	if (opts.ibt) {
-		struct instruction *prev = prev_insn_same_sym(file, insn);
-
-		if (prev && prev->type == INSN_ENDBR &&
-		    insn->offset == sym->offset + prev->len)
-			return true;
-	}
-
-	return false;
-}
-
 /*
  * A sibling call is a tail-call to another symbol -- to differentiate from a
  * recursive tail-call which is to the same symbol.
@@ -3224,56 +3043,6 @@ static int handle_insn_ops(struct instruction *insn,
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
index 3e7c7004f7df..450ebc092b1f 100644
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
@@ -36,89 +26,9 @@ struct alt_group {
 	struct cfi_state **cfi;
 };
 
-#define INSN_CHUNK_BITS		8
-#define INSN_CHUNK_SIZE		(1 << INSN_CHUNK_BITS)
-#define INSN_CHUNK_MAX		(INSN_CHUNK_SIZE - 1)
-
-struct instruction {
-	struct hlist_node hash;
-	struct list_head call_node;
-	struct section *sec;
-	unsigned long offset;
-	unsigned long immediate;
-
-	u8 len;
-	u8 prev_len;
-	u8 type;
-	s8 instr;
-
-	u32 idx			: INSN_CHUNK_BITS,
-	    dead_end		: 1,
-	    ignore		: 1,
-	    ignore_alts		: 1,
-	    hint		: 1,
-	    save		: 1,
-	    restore		: 1,
-	    retpoline_safe	: 1,
-	    noendbr		: 1,
-	    entry		: 1,
-	    visited		: 4,
-	    no_reloc		: 1;
-		/* 10 bit hole */
-
-	struct alt_group *alt_group;
-	struct instruction *jump_dest;
-	struct instruction *first_jump_src;
-	union {
-		struct symbol *_call_dest;
-		struct reloc *_jump_table;
-	};
-	struct alternative *alts;
-	struct symbol *sym;
-	struct stack_op *stack_ops;
-	struct cfi_state *cfi;
-};
-
-static inline struct symbol *insn_func(struct instruction *insn)
-{
-	struct symbol *sym = insn->sym;
-
-	if (sym && sym->type != STT_FUNC)
-		sym = NULL;
-
-	return sym;
-}
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
-struct instruction *next_insn_same_sec(struct objtool_file *file, struct instruction *insn);
-
-#define sec_for_each_insn(file, _sec, insn)				\
-	for (insn = find_insn(file, _sec, 0);				\
-	     insn && insn->sec == _sec;					\
-	     insn = next_insn_same_sec(file, insn))
-
 #endif /* _CHECK_H */
diff --git a/tools/objtool/include/objtool/insn.h b/tools/objtool/include/objtool/insn.h
new file mode 100644
index 000000000000..edd46b5ea1e4
--- /dev/null
+++ b/tools/objtool/include/objtool/insn.h
@@ -0,0 +1,163 @@
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
+#define INSN_CHUNK_BITS		8
+#define INSN_CHUNK_SIZE		(1 << INSN_CHUNK_BITS)
+#define INSN_CHUNK_MAX		(INSN_CHUNK_SIZE - 1)
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
+	struct hlist_node hash;
+	struct list_head call_node;
+	struct section *sec;
+	unsigned long offset;
+	unsigned long immediate;
+
+	u8 len;
+	u8 prev_len;
+	u8 type;
+	s8 instr;
+
+	u32 idx			: INSN_CHUNK_BITS,
+	    dead_end		: 1,
+	    ignore		: 1,
+	    ignore_alts		: 1,
+	    hint		: 1,
+	    save		: 1,
+	    restore		: 1,
+	    retpoline_safe	: 1,
+	    noendbr		: 1,
+	    entry		: 1,
+	    visited		: 4,
+	    no_reloc		: 1;
+		/* 10 bit hole */
+
+	struct alt_group *alt_group;
+	struct instruction *jump_dest;
+	struct instruction *first_jump_src;
+	union {
+		struct symbol *_call_dest;
+		struct reloc *_jump_table;
+	};
+	struct alternative *alts;
+	struct symbol *sym;
+	struct stack_op *stack_ops;
+	struct cfi_state *cfi;
+};
+
+static inline struct symbol *insn_func(struct instruction *insn)
+{
+	struct symbol *sym = insn->sym;
+
+	if (sym && sym->type != STT_FUNC)
+		sym = NULL;
+
+	return sym;
+}
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
+static inline struct symbol *insn_call_dest(struct instruction *insn)
+{
+	if (insn->type == INSN_JUMP_DYNAMIC ||
+	    insn->type == INSN_CALL_DYNAMIC)
+		return NULL;
+
+	return insn->_call_dest;
+}
+
+static inline struct reloc *insn_jump_table(struct instruction *insn)
+{
+	if (insn->type == INSN_JUMP_DYNAMIC ||
+	    insn->type == INSN_CALL_DYNAMIC)
+		return insn->_jump_table;
+
+	return NULL;
+}
+
+void init_insn_state(struct objtool_file *file, struct insn_state *state,
+		     struct section *sec);
+struct instruction *find_insn(struct objtool_file *file,
+			      struct section *sec, unsigned long offset);
+struct instruction *find_last_insn(struct objtool_file *file,
+				   struct section *sec);
+struct instruction *prev_insn_same_sec(struct objtool_file *file,
+				       struct instruction *insn);
+struct instruction *prev_insn_same_sym(struct objtool_file *file,
+				       struct instruction *insn);
+struct instruction *next_insn_same_sec(struct objtool_file *file,
+				       struct instruction *insn);
+struct instruction *next_insn_same_func(struct objtool_file *file,
+					struct instruction *insn);
+struct reloc *insn_reloc(struct objtool_file *file, struct instruction *insn);
+bool insn_cfi_match(struct instruction *insn, struct cfi_state *cfi2);
+bool same_function(struct instruction *insn1, struct instruction *insn2);
+bool is_first_func_insn(struct objtool_file *file,
+			       struct instruction *insn, struct symbol *sym);
+
+
+#define for_each_insn(file, insn)					\
+	for (struct section *__sec, *__fake = (struct section *)1;	\
+	     __fake; __fake = NULL)					\
+		for_each_sec(file, __sec)				\
+			sec_for_each_insn(file, __sec, insn)
+
+#define sec_for_each_insn(file, _sec, insn)				\
+	for (insn = find_insn(file, _sec, 0);				\
+	     insn && insn->sec == _sec;					\
+	     insn = next_insn_same_sec(file, insn))
+
+#define func_for_each_insn(file, func, insn)				\
+	for (insn = find_insn(file, func->sec, func->offset);		\
+	     insn;							\
+	     insn = next_insn_same_func(file, insn))
+
+#define sym_for_each_insn(file, sym, insn)				\
+	for (insn = find_insn(file, sym->sec, sym->offset);		\
+	     insn && insn->offset < sym->offset + sym->len;		\
+	     insn = next_insn_same_sec(file, insn))
+
+#define sym_for_each_insn_continue_reverse(file, sym, insn)		\
+	for (insn = prev_insn_same_sec(file, insn);			\
+	     insn && insn->offset >= sym->offset;			\
+	     insn = prev_insn_same_sec(file, insn))
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
index 000000000000..c020cb84489d
--- /dev/null
+++ b/tools/objtool/insn.c
@@ -0,0 +1,195 @@
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
+	if (insn->idx == INSN_CHUNK_MAX)
+		return find_insn(file, insn->sec, insn->offset + insn->len);
+
+	insn++;
+	if (!insn->len)
+		return NULL;
+
+	return insn;
+}
+
+struct instruction *next_insn_same_func(struct objtool_file *file,
+					struct instruction *insn)
+{
+	struct instruction *next = next_insn_same_sec(file, insn);
+	struct symbol *func = insn_func(insn);
+
+	if (!func)
+		return NULL;
+
+	if (next && insn_func(next) == func)
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
+struct instruction *prev_insn_same_sec(struct objtool_file *file,
+				       struct instruction *insn)
+{
+	if (insn->idx == 0) {
+		if (insn->prev_len)
+			return find_insn(file, insn->sec, insn->offset - insn->prev_len);
+		return NULL;
+	}
+
+	return insn - 1;
+}
+
+struct instruction *prev_insn_same_sym(struct objtool_file *file,
+				       struct instruction *insn)
+{
+	struct instruction *prev = prev_insn_same_sec(file, insn);
+
+	if (prev && insn_func(prev) == insn_func(insn))
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
+	 * not correctly determine insn_call_dest(insn)->sec (external symbols
+	 * do not have a section).
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
+struct reloc *insn_reloc(struct objtool_file *file, struct instruction *insn)
+{
+	struct reloc *reloc;
+
+	if (insn->no_reloc)
+		return NULL;
+
+	if (!file)
+		return NULL;
+
+	reloc = find_reloc_by_dest_range(file->elf, insn->sec,
+					 insn->offset, insn->len);
+	if (!reloc) {
+		insn->no_reloc = 1;
+		return NULL;
+	}
+
+	return reloc;
+}
+
+bool is_first_func_insn(struct objtool_file *file,
+			       struct instruction *insn, struct symbol *sym)
+{
+	if (insn->offset == sym->offset)
+		return true;
+
+	/* Allow direct CALL/JMP past ENDBR */
+	if (opts.ibt) {
+		struct instruction *prev = prev_insn_same_sym(file, insn);
+
+		if (prev && prev->type == INSN_ENDBR &&
+		    insn->offset == sym->offset + prev->len)
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
2.39.2

