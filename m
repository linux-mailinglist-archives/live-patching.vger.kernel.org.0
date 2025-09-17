Return-Path: <live-patching+bounces-1683-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AE4CDB80DC7
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:09:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB06D7BFB6B
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA023314D37;
	Wed, 17 Sep 2025 16:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ehROBB7F"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90519314D31;
	Wed, 17 Sep 2025 16:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125076; cv=none; b=gGfkMNu8D256wv/K0a4LhxmqN7ipsGd54NGOsX+8Oxw2zNla80eSLDUVlTFUpuFuS3Jt8qCkWT+Ar/3PcG7ZeuZQ1wV8b/vuQk+TwhNYuauiBDJOFuQJ1Lci8Jrsu3BjjenUc6+sRdSysRWx5xSASn+6ayvefqjoG4SfLrA6VCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125076; c=relaxed/simple;
	bh=qNMWFJq/XeTcnn0b2PsT1vcrtp65g2RtoGw2GwqFzcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7YWqhsotrNFNm3jT39K9iydh7mFdJvyaKrmMFbk/jplHQloumJmfQE8N+sYhcIGYLEq6G/uGGTSIfT0KAkeNZReZkRTi530/BqFbpl96yPCxNtJI2l0FuDI8Bx5JSe/4Mb1Kry8fxntTm3jCruAo+lDSewsBjIxPXjAcHBjVzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ehROBB7F; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DEBC4CEF7;
	Wed, 17 Sep 2025 16:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125076;
	bh=qNMWFJq/XeTcnn0b2PsT1vcrtp65g2RtoGw2GwqFzcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehROBB7FIPVleOLHFmr02szr7XBg4SjeigvgwL8ku5haBtrhEA/UwmSnDS5S1hB0Q
	 /lDB7q3KqJY1SpnQfTVTLl/GfRpFL66HDuUF64725c0n7NWwZ14ftCYg/b4O7YpZld
	 DVsRa/pRfTEWtkKaGPboBlkXn6jkWm9kubcS/Wmz8K8vYSHJPJKvR5+IgS5rSSbbo3
	 jDJbXjVXiJKGvy/OFFZa4BjwTOGV27uBB0pkmPmyP0AKo+Y5OmWYtZzsID2afnxP46
	 /dTehaofjoDp+/7MFPbnNy1Z8YeaiB2qEfAguM58xkZ53to5VdtRJgAVW3NsPGbWXR
	 gxXuLoMcLkLfg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org,
	Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v4 28/63] objtool: Add section/symbol type helpers
Date: Wed, 17 Sep 2025 09:03:36 -0700
Message-ID: <0e96f232b7fff4ea216ad729761b89ccb686760f.1758067943.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <cover.1758067942.git.jpoimboe@kernel.org>
References: <cover.1758067942.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add some helper macros to improve readability.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/arch/x86/special.c    |  2 +-
 tools/objtool/check.c               | 58 ++++++++++++-------------
 tools/objtool/elf.c                 | 20 ++++-----
 tools/objtool/include/objtool/elf.h | 66 +++++++++++++++++++++++++++++
 tools/objtool/special.c             |  4 +-
 5 files changed, 108 insertions(+), 42 deletions(-)

diff --git a/tools/objtool/arch/x86/special.c b/tools/objtool/arch/x86/special.c
index 06ca4a2659a45..09300761f1085 100644
--- a/tools/objtool/arch/x86/special.c
+++ b/tools/objtool/arch/x86/special.c
@@ -89,7 +89,7 @@ struct reloc *arch_find_switch_table(struct objtool_file *file,
 	/* look for a relocation which references .rodata */
 	text_reloc = find_reloc_by_dest_range(file->elf, insn->sec,
 					      insn->offset, insn->len);
-	if (!text_reloc || text_reloc->sym->type != STT_SECTION ||
+	if (!text_reloc || !is_sec_sym(text_reloc->sym) ||
 	    !text_reloc->sym->sec->rodata)
 		return NULL;
 
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 6923be1b7cf34..165ea9b0fdca5 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -261,7 +261,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 	if (!func)
 		return false;
 
-	if (func->bind == STB_GLOBAL || func->bind == STB_WEAK) {
+	if (!is_local_sym(func)) {
 		if (is_rust_noreturn(func))
 			return true;
 
@@ -270,7 +270,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 				return true;
 	}
 
-	if (func->bind == STB_WEAK)
+	if (is_weak_sym(func))
 		return false;
 
 	if (!func->len)
@@ -436,7 +436,7 @@ static int decode_instructions(struct objtool_file *file)
 		u8 prev_len = 0;
 		u8 idx = 0;
 
-		if (!(sec->sh.sh_flags & SHF_EXECINSTR))
+		if (!is_text_sec(sec))
 			continue;
 
 		if (strcmp(sec->name, ".altinstr_replacement") &&
@@ -459,7 +459,7 @@ static int decode_instructions(struct objtool_file *file)
 		if (!strcmp(sec->name, ".init.text") && !opts.module)
 			sec->init = true;
 
-		for (offset = 0; offset < sec->sh.sh_size; offset += insn->len) {
+		for (offset = 0; offset < sec_size(sec); offset += insn->len) {
 			if (!insns || idx == INSN_CHUNK_MAX) {
 				insns = calloc(INSN_CHUNK_SIZE, sizeof(*insn));
 				if (!insns) {
@@ -478,7 +478,7 @@ static int decode_instructions(struct objtool_file *file)
 			insn->offset = offset;
 			insn->prev_len = prev_len;
 
-			if (arch_decode_instruction(file, sec, offset, sec->sh.sh_size - offset, insn))
+			if (arch_decode_instruction(file, sec, offset, sec_size(sec) - offset, insn))
 				return -1;
 
 			prev_len = insn->len;
@@ -496,12 +496,12 @@ static int decode_instructions(struct objtool_file *file)
 		}
 
 		sec_for_each_sym(sec, func) {
-			if (func->type != STT_NOTYPE && func->type != STT_FUNC)
+			if (!is_notype_sym(func) && !is_func_sym(func))
 				continue;
 
-			if (func->offset == sec->sh.sh_size) {
+			if (func->offset == sec_size(sec)) {
 				/* Heuristic: likely an "end" symbol */
-				if (func->type == STT_NOTYPE)
+				if (is_notype_sym(func))
 					continue;
 				ERROR("%s(): STT_FUNC at end of section", func->name);
 				return -1;
@@ -517,7 +517,7 @@ static int decode_instructions(struct objtool_file *file)
 
 			sym_for_each_insn(file, func, insn) {
 				insn->sym = func;
-				if (func->type == STT_FUNC &&
+				if (is_func_sym(func) &&
 				    insn->type == INSN_ENDBR &&
 				    list_empty(&insn->call_node)) {
 					if (insn->offset == func->offset) {
@@ -561,7 +561,7 @@ static int add_pv_ops(struct objtool_file *file, const char *symname)
 		idx = (reloc_offset(reloc) - sym->offset) / sizeof(unsigned long);
 
 		func = reloc->sym;
-		if (func->type == STT_SECTION)
+		if (is_sec_sym(func))
 			func = find_symbol_by_offset(reloc->sym->sec,
 						     reloc_addend(reloc));
 		if (!func) {
@@ -823,7 +823,7 @@ static int create_ibt_endbr_seal_sections(struct objtool_file *file)
 		struct symbol *sym = insn->sym;
 		*site = 0;
 
-		if (opts.module && sym && sym->type == STT_FUNC &&
+		if (opts.module && sym && is_func_sym(sym) &&
 		    insn->offset == sym->offset &&
 		    (!strcmp(sym->name, "init_module") ||
 		     !strcmp(sym->name, "cleanup_module"))) {
@@ -858,7 +858,7 @@ static int create_cfi_sections(struct objtool_file *file)
 
 	idx = 0;
 	for_each_sym(file->elf, sym) {
-		if (sym->type != STT_FUNC)
+		if (!is_func_sym(sym))
 			continue;
 
 		if (strncmp(sym->name, "__cfi_", 6))
@@ -874,7 +874,7 @@ static int create_cfi_sections(struct objtool_file *file)
 
 	idx = 0;
 	for_each_sym(file->elf, sym) {
-		if (sym->type != STT_FUNC)
+		if (!is_func_sym(sym))
 			continue;
 
 		if (strncmp(sym->name, "__cfi_", 6))
@@ -1463,7 +1463,7 @@ static bool jump_is_sibling_call(struct objtool_file *file,
 		return false;
 
 	/* Disallow sibling calls into STT_NOTYPE */
-	if (ts->type == STT_NOTYPE)
+	if (is_notype_sym(ts))
 		return false;
 
 	/* Must not be self to be a sibling */
@@ -1497,7 +1497,7 @@ static int add_jump_destinations(struct objtool_file *file)
 		if (!reloc) {
 			dest_sec = insn->sec;
 			dest_off = arch_jump_destination(insn);
-		} else if (reloc->sym->type == STT_SECTION) {
+		} else if (is_sec_sym(reloc->sym)) {
 			dest_sec = reloc->sym->sec;
 			dest_off = arch_insn_adjusted_addend(insn, reloc);
 		} else if (reloc->sym->retpoline_thunk) {
@@ -1657,12 +1657,12 @@ static int add_call_destinations(struct objtool_file *file)
 				return -1;
 			}
 
-			if (func && insn_call_dest(insn)->type != STT_FUNC) {
+			if (func && !is_func_sym(insn_call_dest(insn))) {
 				ERROR_INSN(insn, "unsupported call to non-function");
 				return -1;
 			}
 
-		} else if (reloc->sym->type == STT_SECTION) {
+		} else if (is_sec_sym(reloc->sym)) {
 			dest_off = arch_insn_adjusted_addend(insn, reloc);
 			dest = find_call_destination(reloc->sym->sec, dest_off);
 			if (!dest) {
@@ -2146,7 +2146,7 @@ static int add_jump_table_alts(struct objtool_file *file)
 		return 0;
 
 	for_each_sym(file->elf, func) {
-		if (func->type != STT_FUNC)
+		if (!is_func_sym(func))
 			continue;
 
 		mark_func_jump_tables(file, func);
@@ -2185,14 +2185,14 @@ static int read_unwind_hints(struct objtool_file *file)
 		return -1;
 	}
 
-	if (sec->sh.sh_size % sizeof(struct unwind_hint)) {
+	if (sec_size(sec) % sizeof(struct unwind_hint)) {
 		ERROR("struct unwind_hint size mismatch");
 		return -1;
 	}
 
 	file->hints = true;
 
-	for (i = 0; i < sec->sh.sh_size / sizeof(struct unwind_hint); i++) {
+	for (i = 0; i < sec_size(sec) / sizeof(struct unwind_hint); i++) {
 		hint = (struct unwind_hint *)sec->data->d_buf + i;
 
 		reloc = find_reloc_by_dest(file->elf, sec, i * sizeof(*hint));
@@ -2201,7 +2201,7 @@ static int read_unwind_hints(struct objtool_file *file)
 			return -1;
 		}
 
-		if (reloc->sym->type == STT_SECTION) {
+		if (is_sec_sym(reloc->sym)) {
 			offset = reloc_addend(reloc);
 		} else if (reloc->sym->local_label) {
 			offset = reloc->sym->offset;
@@ -2237,7 +2237,7 @@ static int read_unwind_hints(struct objtool_file *file)
 		if (hint->type == UNWIND_HINT_TYPE_REGS_PARTIAL) {
 			struct symbol *sym = find_symbol_by_offset(insn->sec, insn->offset);
 
-			if (sym && sym->bind == STB_GLOBAL) {
+			if (sym && is_global_sym(sym)) {
 				if (opts.ibt && insn->type != INSN_ENDBR && !insn->noendbr) {
 					ERROR_INSN(insn, "UNWIND_HINT_IRET_REGS without ENDBR");
 					return -1;
@@ -2462,10 +2462,10 @@ static int classify_symbols(struct objtool_file *file)
 	struct symbol *func;
 
 	for_each_sym(file->elf, func) {
-		if (func->type == STT_NOTYPE && strstarts(func->name, ".L"))
+		if (is_notype_sym(func) && strstarts(func->name, ".L"))
 			func->local_label = true;
 
-		if (func->bind != STB_GLOBAL)
+		if (!is_global_sym(func))
 			continue;
 
 		if (!strncmp(func->name, STATIC_CALL_TRAMP_PREFIX_STR,
@@ -4188,11 +4188,11 @@ static int add_prefix_symbols(struct objtool_file *file)
 	struct symbol *func;
 
 	for_each_sec(file->elf, sec) {
-		if (!(sec->sh.sh_flags & SHF_EXECINSTR))
+		if (!is_text_sec(sec))
 			continue;
 
 		sec_for_each_sym(sec, func) {
-			if (func->type != STT_FUNC)
+			if (!is_func_sym(func))
 				continue;
 
 			add_prefix_symbol(file, func);
@@ -4236,7 +4236,7 @@ static int validate_section(struct objtool_file *file, struct section *sec)
 	int warnings = 0;
 
 	sec_for_each_sym(sec, func) {
-		if (func->type != STT_FUNC)
+		if (!is_func_sym(func))
 			continue;
 
 		init_insn_state(file, &state, sec);
@@ -4280,7 +4280,7 @@ static int validate_functions(struct objtool_file *file)
 	int warnings = 0;
 
 	for_each_sec(file->elf, sec) {
-		if (!(sec->sh.sh_flags & SHF_EXECINSTR))
+		if (!is_text_sec(sec))
 			continue;
 
 		warnings += validate_section(file, sec);
@@ -4461,7 +4461,7 @@ static int validate_ibt(struct objtool_file *file)
 	for_each_sec(file->elf, sec) {
 
 		/* Already done by validate_ibt_insn() */
-		if (sec->sh.sh_flags & SHF_EXECINSTR)
+		if (is_text_sec(sec))
 			continue;
 
 		if (!sec->rsec)
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index c27edeed2dd03..d36c0d42fd7ba 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -170,7 +170,7 @@ struct symbol *find_symbol_by_offset(struct section *sec, unsigned long offset)
 	struct symbol *iter;
 
 	__sym_for_each(iter, tree, offset, offset) {
-		if (iter->offset == offset && iter->type != STT_SECTION)
+		if (iter->offset == offset && !is_sec_sym(iter))
 			return iter;
 	}
 
@@ -183,7 +183,7 @@ struct symbol *find_func_by_offset(struct section *sec, unsigned long offset)
 	struct symbol *iter;
 
 	__sym_for_each(iter, tree, offset, offset) {
-		if (iter->offset == offset && iter->type == STT_FUNC)
+		if (iter->offset == offset && is_func_sym(iter))
 			return iter;
 	}
 
@@ -264,7 +264,7 @@ struct symbol *find_func_containing(struct section *sec, unsigned long offset)
 	struct symbol *iter;
 
 	__sym_for_each(iter, tree, offset, offset) {
-		if (iter->type == STT_FUNC)
+		if (is_func_sym(iter))
 			return iter;
 	}
 
@@ -373,14 +373,14 @@ static int read_sections(struct elf *elf)
 			return -1;
 		}
 
-		if (sec->sh.sh_size != 0 && !is_dwarf_section(sec)) {
+		if (sec_size(sec) != 0 && !is_dwarf_section(sec)) {
 			sec->data = elf_getdata(s, NULL);
 			if (!sec->data) {
 				ERROR_ELF("elf_getdata");
 				return -1;
 			}
 			if (sec->data->d_off != 0 ||
-			    sec->data->d_size != sec->sh.sh_size) {
+			    sec->data->d_size != sec_size(sec)) {
 				ERROR("unexpected data attributes for %s", sec->name);
 				return -1;
 			}
@@ -420,7 +420,7 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 	sym->type = GELF_ST_TYPE(sym->sym.st_info);
 	sym->bind = GELF_ST_BIND(sym->sym.st_info);
 
-	if (sym->type == STT_FILE)
+	if (is_file_sym(sym))
 		elf->num_files++;
 
 	sym->offset = sym->sym.st_value;
@@ -527,7 +527,7 @@ static int read_symbols(struct elf *elf)
 		sec_for_each_sym(sec, sym) {
 			char *pname;
 			size_t pnamelen;
-			if (sym->type != STT_FUNC)
+			if (!is_func_sym(sym))
 				continue;
 
 			if (sym->pfunc == NULL)
@@ -929,7 +929,7 @@ struct reloc *elf_init_reloc_text_sym(struct elf *elf, struct section *sec,
 	struct symbol *sym = insn_sec->sym;
 	int addend = insn_off;
 
-	if (!(insn_sec->sh.sh_flags & SHF_EXECINSTR)) {
+	if (!is_text_sec(insn_sec)) {
 		ERROR("bad call to %s() for data symbol %s", __func__, sym->name);
 		return NULL;
 	}
@@ -958,7 +958,7 @@ struct reloc *elf_init_reloc_data_sym(struct elf *elf, struct section *sec,
 				      struct symbol *sym,
 				      s64 addend)
 {
-	if (sym->sec && (sec->sh.sh_flags & SHF_EXECINSTR)) {
+	if (is_text_sec(sec)) {
 		ERROR("bad call to %s() for text symbol %s", __func__, sym->name);
 		return NULL;
 	}
@@ -1287,7 +1287,7 @@ int elf_write_insn(struct elf *elf, struct section *sec,
  */
 static int elf_truncate_section(struct elf *elf, struct section *sec)
 {
-	u64 size = sec->sh.sh_size;
+	u64 size = sec_size(sec);
 	bool truncated = false;
 	Elf_Data *data = NULL;
 	Elf_Scn *s;
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 4d5f27b497249..f2dbcaa42a9c9 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -8,6 +8,7 @@
 
 #include <stdio.h>
 #include <gelf.h>
+#include <linux/string.h>
 #include <linux/list.h>
 #include <linux/hashtable.h>
 #include <linux/rbtree.h>
@@ -178,11 +179,71 @@ static inline unsigned int elf_text_rela_type(struct elf *elf)
 	return elf_addr_size(elf) == 4 ? R_TEXT32 : R_TEXT64;
 }
 
+static inline bool sym_has_sec(struct symbol *sym)
+{
+	return sym->sec->idx;
+}
+
+static inline bool is_null_sym(struct symbol *sym)
+{
+	return !sym->idx;
+}
+
+static inline bool is_sec_sym(struct symbol *sym)
+{
+	return sym->type == STT_SECTION;
+}
+
+static inline bool is_object_sym(struct symbol *sym)
+{
+	return sym->type == STT_OBJECT;
+}
+
+static inline bool is_func_sym(struct symbol *sym)
+{
+	return sym->type == STT_FUNC;
+}
+
+static inline bool is_file_sym(struct symbol *sym)
+{
+	return sym->type == STT_FILE;
+}
+
+static inline bool is_notype_sym(struct symbol *sym)
+{
+	return sym->type == STT_NOTYPE;
+}
+
+static inline bool is_global_sym(struct symbol *sym)
+{
+	return sym->bind == STB_GLOBAL;
+}
+
+static inline bool is_weak_sym(struct symbol *sym)
+{
+	return sym->bind == STB_WEAK;
+}
+
+static inline bool is_local_sym(struct symbol *sym)
+{
+	return sym->bind == STB_LOCAL;
+}
+
 static inline bool is_reloc_sec(struct section *sec)
 {
 	return sec->sh.sh_type == SHT_RELA || sec->sh.sh_type == SHT_REL;
 }
 
+static inline bool is_string_sec(struct section *sec)
+{
+	return sec->sh.sh_flags & SHF_STRINGS;
+}
+
+static inline bool is_text_sec(struct section *sec)
+{
+	return sec->sh.sh_flags & SHF_EXECINSTR;
+}
+
 static inline bool sec_changed(struct section *sec)
 {
 	return sec->_changed;
@@ -223,6 +284,11 @@ static inline bool is_32bit_reloc(struct reloc *reloc)
 	return reloc->sec->sh.sh_entsize < 16;
 }
 
+static inline unsigned long sec_size(struct section *sec)
+{
+	return sec->sh.sh_size;
+}
+
 #define __get_reloc_field(reloc, field)					\
 ({									\
 	is_32bit_reloc(reloc) ?						\
diff --git a/tools/objtool/special.c b/tools/objtool/special.c
index c0beefb93b62e..fc2cf8dba1c03 100644
--- a/tools/objtool/special.c
+++ b/tools/objtool/special.c
@@ -142,12 +142,12 @@ int special_get_alts(struct elf *elf, struct list_head *alts)
 		if (!sec)
 			continue;
 
-		if (sec->sh.sh_size % entry->size != 0) {
+		if (sec_size(sec) % entry->size != 0) {
 			ERROR("%s size not a multiple of %d", sec->name, entry->size);
 			return -1;
 		}
 
-		nr_entries = sec->sh.sh_size / entry->size;
+		nr_entries = sec_size(sec) / entry->size;
 
 		for (idx = 0; idx < nr_entries; idx++) {
 			alt = malloc(sizeof(*alt));
-- 
2.50.0


