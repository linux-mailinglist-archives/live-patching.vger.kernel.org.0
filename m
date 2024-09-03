Return-Path: <live-patching+bounces-545-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EA4296927F
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:02:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35A8C282D3E
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF0F71D04B0;
	Tue,  3 Sep 2024 04:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vFfLNUDr"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CF71CE702;
	Tue,  3 Sep 2024 04:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336034; cv=none; b=Q6Pjx9bORMYUbXuWOrWex/Gf9T649Objyg7zztN+9zj3huwd2i5AcibT8qC1pwDLbN36Kt1xTNNKh6SmuAm6Toxc906vgLi9u3MZ/mwtqss7wuE04XgcSjmJ1B2uzT/sT1EfvP58UVMuZoQq6HIxws99bi/Q0E+OYbY9l3bVvvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336034; c=relaxed/simple;
	bh=OEqbNdqC0dxSvyjQ4fvXbWDvm270/3j2sh22+EBhvEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3+pQoprQi6ipIvfgFG9R3UT+cTIn7n0uVjbFLWU4V7IlTyPNOc7gVBjMk4uihgfR8o9qWAjxxNjypYtlLnciYUvguIweG7OmN3kdNX/7OYeuZUzrkJiRNSnNDtZD2Vp0tVhDYI/dbPVx4sfTILDPnGOP0Zpyx0ehnhsPksWJTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vFfLNUDr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D45C4CECF;
	Tue,  3 Sep 2024 04:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336034;
	bh=OEqbNdqC0dxSvyjQ4fvXbWDvm270/3j2sh22+EBhvEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFfLNUDreYzNXKGscIYivu1G93jT0bH7Bb3oVBmHck0b3odnwd4GaZFKJm2LlpbEa
	 PJj8alvZXG0XtabG/sFLh5AUoPBcYYx5gIQ6YcRrsiako1kV9R6hUow/GIKArINgAY
	 7o8fqCqL4qzjwRvAtf0VXzxJkBVTRQHYG3GBC8SteCsbuwahSjZk06wK9JPP3wP5dV
	 flzM8v9ztB2pg9RHzrm8aQ3IBaZ0HFsvkI0dDsFMncbD2+jatw+EEr17nYjoNyaG4G
	 CJkoLyVdxKt+CJFfBm6kT9qROy3uIQzz6OtohLuhG0tNDV8YCLZGq2I9qFeK5vIZhy
	 ScIn9vCVNZnVA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: [RFC 11/31] objtool: Add section/symbol type helpers
Date: Mon,  2 Sep 2024 20:59:54 -0700
Message-ID: <bb8f3cd7119d98da5a4ac0dd9d2cdf5012f08b8d.1725334260.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
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
 tools/objtool/check.c               | 66 +++++++++++++-------------
 tools/objtool/elf.c                 | 24 +++++-----
 tools/objtool/include/objtool/elf.h | 73 ++++++++++++++++++++++++++++-
 tools/objtool/special.c             |  4 +-
 5 files changed, 120 insertions(+), 49 deletions(-)

diff --git a/tools/objtool/arch/x86/special.c b/tools/objtool/arch/x86/special.c
index 4134d27c696b..b0e21b2e9f53 100644
--- a/tools/objtool/arch/x86/special.c
+++ b/tools/objtool/arch/x86/special.c
@@ -95,7 +95,7 @@ struct reloc *arch_find_switch_table(struct objtool_file *file,
 	/* look for a relocation which references .rodata */
 	text_reloc = find_reloc_by_dest_range(file->elf, insn->sec,
 					      insn->offset, insn->len);
-	if (!text_reloc || text_reloc->sym->type != STT_SECTION ||
+	if (!text_reloc || !is_section_symbol(text_reloc->sym) ||
 	    !text_reloc->sym->sec->rodata)
 		return NULL;
 
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 06e7b3f5481d..95f5de0c293d 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -202,12 +202,12 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 	if (!func)
 		return false;
 
-	if (func->bind == STB_GLOBAL || func->bind == STB_WEAK)
+	if (!is_local_symbol(func))
 		for (i = 0; i < ARRAY_SIZE(global_noreturns); i++)
 			if (!strcmp(func->name, global_noreturns[i]))
 				return true;
 
-	if (func->bind == STB_WEAK)
+	if (is_weak_symbol(func))
 		return false;
 
 	if (!func->len)
@@ -379,7 +379,7 @@ static int decode_instructions(struct objtool_file *file)
 		u8 prev_len = 0;
 		u8 idx = 0;
 
-		if (!(sec->sh.sh_flags & SHF_EXECINSTR))
+		if (!is_text_section(sec))
 			continue;
 
 		if (strcmp(sec->name, ".altinstr_replacement") &&
@@ -402,7 +402,7 @@ static int decode_instructions(struct objtool_file *file)
 		if (!strcmp(sec->name, ".init.text") && !opts.module)
 			sec->init = true;
 
-		for (offset = 0; offset < sec->sh.sh_size; offset += insn->len) {
+		for (offset = 0; offset < sec_size(sec); offset += insn->len) {
 			if (!insns || idx == INSN_CHUNK_MAX) {
 				insns = calloc(sizeof(*insn), INSN_CHUNK_SIZE);
 				if (!insns) {
@@ -422,7 +422,7 @@ static int decode_instructions(struct objtool_file *file)
 			insn->prev_len = prev_len;
 
 			ret = arch_decode_instruction(file, sec, offset,
-						      sec->sh.sh_size - offset,
+						      sec_size(sec) - offset,
 						      insn);
 			if (ret)
 				return ret;
@@ -444,12 +444,12 @@ static int decode_instructions(struct objtool_file *file)
 //		printf("%s: last chunk used: %d\n", sec->name, (int)idx);
 
 		sec_for_each_sym(sec, func) {
-			if (func->type != STT_NOTYPE && func->type != STT_FUNC)
+			if (!is_notype_symbol(func) && !is_function_symbol(func))
 				continue;
 
-			if (func->offset == sec->sh.sh_size) {
+			if (func->offset == sec_size(sec)) {
 				/* Heuristic: likely an "end" symbol */
-				if (func->type == STT_NOTYPE)
+				if (is_notype_symbol(func))
 					continue;
 				WARN("%s(): STT_FUNC at end of section",
 				     func->name);
@@ -467,7 +467,7 @@ static int decode_instructions(struct objtool_file *file)
 
 			sym_for_each_insn(file, func, insn) {
 				insn->sym = func;
-				if (func->type == STT_FUNC &&
+				if (is_function_symbol(func) &&
 				    insn->type == INSN_ENDBR &&
 				    list_empty(&insn->call_node)) {
 					if (insn->offset == func->offset) {
@@ -509,7 +509,7 @@ static int add_pv_ops(struct objtool_file *file, const char *symname)
 			break;
 
 		func = reloc->sym;
-		if (func->type == STT_SECTION)
+		if (is_section_symbol(func))
 			func = find_symbol_by_offset(reloc->sym->sec,
 						     reloc_addend(reloc));
 
@@ -569,9 +569,9 @@ static struct instruction *find_last_insn(struct objtool_file *file,
 {
 	struct instruction *insn = NULL;
 	unsigned int offset;
-	unsigned int end = (sec->sh.sh_size > 10) ? sec->sh.sh_size - 10 : 0;
+	unsigned int end = (sec_size(sec) > 10) ? sec_size(sec) - 10 : 0;
 
-	for (offset = sec->sh.sh_size - 1; offset >= end && !insn; offset--)
+	for (offset = sec_size(sec) - 1; offset >= end && !insn; offset--)
 		insn = find_insn(file, sec, offset);
 
 	return insn;
@@ -607,7 +607,7 @@ static int add_dead_ends(struct objtool_file *file)
 		insn = find_insn(file, reloc->sym->sec, offset);
 		if (insn)
 			insn = prev_insn_same_sec(file, insn);
-		else if (offset == reloc->sym->sec->sh.sh_size) {
+		else if (offset == sec_size(reloc->sym->sec)) {
 			insn = find_last_insn(file, reloc->sym->sec);
 			if (!insn) {
 				WARN("can't find unreachable insn at %s+0x%" PRIx64,
@@ -647,7 +647,7 @@ static int add_dead_ends(struct objtool_file *file)
 		insn = find_insn(file, reloc->sym->sec, offset);
 		if (insn)
 			insn = prev_insn_same_sec(file, insn);
-		else if (offset == reloc->sym->sec->sh.sh_size) {
+		else if (offset == sec_size(reloc->sym->sec)) {
 			insn = find_last_insn(file, reloc->sym->sec);
 			if (!insn) {
 				WARN("can't find reachable insn at %s+0x%" PRIx64,
@@ -868,7 +868,7 @@ static int create_ibt_endbr_seal_sections(struct objtool_file *file)
 		struct symbol *sym = insn->sym;
 		*site = 0;
 
-		if (opts.module && sym && sym->type == STT_FUNC &&
+		if (opts.module && sym && is_function_symbol(sym) &&
 		    insn->offset == sym->offset &&
 		    (!strcmp(sym->name, "init_module") ||
 		     !strcmp(sym->name, "cleanup_module")))
@@ -900,7 +900,7 @@ static int create_cfi_sections(struct objtool_file *file)
 
 	idx = 0;
 	for_each_sym(file->elf, sym) {
-		if (sym->type != STT_FUNC)
+		if (!is_function_symbol(sym))
 			continue;
 
 		if (strncmp(sym->name, "__cfi_", 6))
@@ -916,7 +916,7 @@ static int create_cfi_sections(struct objtool_file *file)
 
 	idx = 0;
 	for_each_sym(file->elf, sym) {
-		if (sym->type != STT_FUNC)
+		if (!is_function_symbol(sym))
 			continue;
 
 		if (strncmp(sym->name, "__cfi_", 6))
@@ -1534,7 +1534,7 @@ static bool jump_is_sibling_call(struct objtool_file *file,
 		return false;
 
 	/* Disallow sibling calls into STT_NOTYPE */
-	if (ts->type == STT_NOTYPE)
+	if (is_notype_symbol(ts))
 		return false;
 
 	/* Must not be self to be a sibling */
@@ -1566,7 +1566,7 @@ static int add_jump_destinations(struct objtool_file *file)
 		if (!reloc) {
 			dest_sec = insn->sec;
 			dest_off = arch_jump_destination(insn);
-		} else if (reloc->sym->type == STT_SECTION) {
+		} else if (is_section_symbol(reloc->sym)) {
 			dest_sec = reloc->sym->sec;
 			dest_off = arch_dest_reloc_offset(reloc_addend(reloc));
 		} else if (reloc->sym->retpoline_thunk) {
@@ -1712,12 +1712,12 @@ static int add_call_destinations(struct objtool_file *file)
 				return -1;
 			}
 
-			if (insn_func(insn) && insn_call_dest(insn)->type != STT_FUNC) {
+			if (insn_func(insn) && !is_function_symbol(insn_call_dest(insn))) {
 				WARN_INSN(insn, "unsupported call to non-function");
 				return -1;
 			}
 
-		} else if (reloc->sym->type == STT_SECTION) {
+		} else if (is_section_symbol(reloc->sym)) {
 			dest_off = arch_dest_reloc_offset(reloc_addend(reloc));
 			dest = find_call_destination(reloc->sym->sec, dest_off);
 			if (!dest) {
@@ -2199,7 +2199,7 @@ static int add_jump_table_alts(struct objtool_file *file)
 		return 0;
 
 	for_each_sym(file->elf, func) {
-		if (func->type != STT_FUNC)
+		if (!is_function_symbol(func))
 			continue;
 
 		mark_func_jump_tables(file, func);
@@ -2239,14 +2239,14 @@ static int read_unwind_hints(struct objtool_file *file)
 		return -1;
 	}
 
-	if (sec->sh.sh_size % sizeof(struct unwind_hint)) {
+	if (sec_size(sec) % sizeof(struct unwind_hint)) {
 		WARN("struct unwind_hint size mismatch");
 		return -1;
 	}
 
 	file->hints = true;
 
-	for (i = 0; i < sec->sh.sh_size / sizeof(struct unwind_hint); i++) {
+	for (i = 0; i < sec_size(sec) / sizeof(struct unwind_hint); i++) {
 		hint = (struct unwind_hint *)sec->data->d_buf + i;
 
 		reloc = find_reloc_by_dest(file->elf, sec, i * sizeof(*hint));
@@ -2291,7 +2291,7 @@ static int read_unwind_hints(struct objtool_file *file)
 		if (hint->type == UNWIND_HINT_TYPE_REGS_PARTIAL) {
 			struct symbol *sym = find_symbol_by_offset(insn->sec, insn->offset);
 
-			if (sym && sym->bind == STB_GLOBAL) {
+			if (sym && is_global_symbol(sym)) {
 				if (opts.ibt && insn->type != INSN_ENDBR && !insn->noendbr) {
 					WARN_INSN(insn, "UNWIND_HINT_IRET_REGS without ENDBR");
 				}
@@ -2469,7 +2469,7 @@ static int read_intra_function_calls(struct objtool_file *file)
 	for_each_reloc(rsec, reloc) {
 		unsigned long dest_off;
 
-		if (reloc->sym->type != STT_SECTION) {
+		if (!is_section_symbol(reloc->sym)) {
 			WARN("unexpected relocation symbol type in %s",
 			     rsec->name);
 			return -1;
@@ -2535,10 +2535,10 @@ static int classify_symbols(struct objtool_file *file)
 	struct symbol *func;
 
 	for_each_sym(file->elf, func) {
-		if (func->type == STT_NOTYPE && strstarts(func->name, ".L"))
+		if (is_notype_symbol(func) && strstarts(func->name, ".L"))
 			func->local_label = true;
 
-		if (func->bind != STB_GLOBAL)
+		if (!is_global_symbol(func))
 			continue;
 
 		if (!strncmp(func->name, STATIC_CALL_TRAMP_PREFIX_STR,
@@ -4199,11 +4199,11 @@ static int add_prefix_symbols(struct objtool_file *file)
 	struct symbol *func;
 
 	for_each_sec(file->elf, sec) {
-		if (!(sec->sh.sh_flags & SHF_EXECINSTR))
+		if (!is_text_section(sec))
 			continue;
 
 		sec_for_each_sym(sec, func) {
-			if (func->type != STT_FUNC)
+			if (!is_function_symbol(func))
 				continue;
 
 			add_prefix_symbol(file, func);
@@ -4246,7 +4246,7 @@ static int validate_section(struct objtool_file *file, struct section *sec)
 	int warnings = 0;
 
 	sec_for_each_sym(sec, func) {
-		if (func->type != STT_FUNC)
+		if (!is_function_symbol(func))
 			continue;
 
 		init_insn_state(file, &state, sec);
@@ -4290,7 +4290,7 @@ static int validate_functions(struct objtool_file *file)
 	int warnings = 0;
 
 	for_each_sec(file->elf, sec) {
-		if (!(sec->sh.sh_flags & SHF_EXECINSTR))
+		if (!is_text_section(sec))
 			continue;
 
 		warnings += validate_section(file, sec);
@@ -4461,7 +4461,7 @@ static int validate_ibt(struct objtool_file *file)
 	for_each_sec(file->elf, sec) {
 
 		/* Already done by validate_ibt_insn() */
-		if (sec->sh.sh_flags & SHF_EXECINSTR)
+		if (is_text_section(sec))
 			continue;
 
 		if (!sec->rsec)
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index b42ee4ef7015..5301fff87bea 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -170,7 +170,7 @@ struct symbol *find_symbol_by_offset(struct section *sec, unsigned long offset)
 	struct symbol *iter;
 
 	__sym_for_each(iter, tree, offset, offset) {
-		if (iter->offset == offset && iter->type != STT_SECTION)
+		if (iter->offset == offset && !is_section_symbol(iter))
 			return iter;
 	}
 
@@ -183,7 +183,7 @@ struct symbol *find_func_by_offset(struct section *sec, unsigned long offset)
 	struct symbol *iter;
 
 	__sym_for_each(iter, tree, offset, offset) {
-		if (iter->offset == offset && iter->type == STT_FUNC)
+		if (iter->offset == offset && is_function_symbol(iter))
 			return iter;
 	}
 
@@ -244,7 +244,7 @@ struct symbol *find_func_containing(struct section *sec, unsigned long offset)
 	struct symbol *iter;
 
 	__sym_for_each(iter, tree, offset, offset) {
-		if (iter->type == STT_FUNC)
+		if (is_function_symbol(iter))
 			return iter;
 	}
 
@@ -353,14 +353,14 @@ static int read_sections(struct elf *elf)
 			return -1;
 		}
 
-		if (sec->sh.sh_size != 0 && !is_dwarf_section(sec)) {
+		if (sec_size(sec) != 0 && !is_dwarf_section(sec)) {
 			sec->data = elf_getdata(s, NULL);
 			if (!sec->data) {
 				WARN_ELF("elf_getdata");
 				return -1;
 			}
 			if (sec->data->d_off != 0 ||
-			    sec->data->d_size != sec->sh.sh_size) {
+			    sec->data->d_size != sec_size(sec)) {
 				WARN("unexpected data attributes for %s",
 				     sec->name);
 				return -1;
@@ -371,7 +371,7 @@ static int read_sections(struct elf *elf)
 		elf_hash_add(section, &sec->hash, sec->idx);
 		elf_hash_add(section_name, &sec->name_hash, str_hash(sec->name));
 
-		if (is_reloc_sec(sec))
+		if (is_reloc_section(sec))
 			elf->num_relocs += sec_num_entries(sec);
 	}
 
@@ -401,7 +401,7 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 	sym->type = GELF_ST_TYPE(sym->sym.st_info);
 	sym->bind = GELF_ST_BIND(sym->sym.st_info);
 
-	if (sym->type == STT_FILE)
+	if (is_file_symbol(sym))
 		elf->num_files++;
 
 	sym->offset = sym->sym.st_value;
@@ -515,7 +515,7 @@ static int read_symbols(struct elf *elf)
 		sec_for_each_sym(sec, sym) {
 			char *pname;
 			size_t pnamelen;
-			if (sym->type != STT_FUNC)
+			if (!is_function_symbol(sym))
 				continue;
 
 			if (sym->pfunc == NULL)
@@ -890,7 +890,7 @@ struct reloc *elf_init_reloc_text_sym(struct elf *elf, struct section *sec,
 	struct symbol *sym = insn_sec->sym;
 	int addend = insn_off;
 
-	if (!(insn_sec->sh.sh_flags & SHF_EXECINSTR)) {
+	if (!is_text_section(insn_sec)) {
 		WARN("bad call to %s() for data symbol %s",
 		     __func__, sym->name);
 		return NULL;
@@ -920,7 +920,7 @@ struct reloc *elf_init_reloc_data_sym(struct elf *elf, struct section *sec,
 				      struct symbol *sym,
 				      s64 addend)
 {
-	if (sym->sec && (sec->sh.sh_flags & SHF_EXECINSTR)) {
+	if (is_text_section(sec)) {
 		WARN("bad call to %s() for text symbol %s",
 		     __func__, sym->name);
 		return NULL;
@@ -943,7 +943,7 @@ static int read_relocs(struct elf *elf)
 		return -1;
 
 	list_for_each_entry(rsec, &elf->sections, list) {
-		if (!is_reloc_sec(rsec))
+		if (!is_reloc_section(rsec))
 			continue;
 
 		rsec->base = find_section_by_index(elf, rsec->sh.sh_info);
@@ -1249,7 +1249,7 @@ int elf_write_insn(struct elf *elf, struct section *sec,
  */
 static int elf_truncate_section(struct elf *elf, struct section *sec)
 {
-	u64 size = sec->sh.sh_size;
+	u64 size = sec_size(sec);
 	bool truncated = false;
 	Elf_Data *data = NULL;
 	Elf_Scn *s;
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 7524510b5565..0c2af699b1bf 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -8,6 +8,7 @@
 
 #include <stdio.h>
 #include <gelf.h>
+#include <linux/string.h>
 #include <linux/list.h>
 #include <linux/hashtable.h>
 #include <linux/rbtree.h>
@@ -174,11 +175,76 @@ static inline unsigned int elf_text_rela_type(struct elf *elf)
 	return elf_addr_size(elf) == 4 ? R_TEXT32 : R_TEXT64;
 }
 
-static inline bool is_reloc_sec(struct section *sec)
+static inline bool sym_has_section(struct symbol *sym)
+{
+	return sym->sec->idx;
+}
+
+static inline bool is_null_symbol(struct symbol *sym)
+{
+	return !sym->idx;
+}
+
+static inline bool is_section_symbol(struct symbol *sym)
+{
+	return sym->type == STT_SECTION;
+}
+
+static inline bool is_object_symbol(struct symbol *sym)
+{
+	return sym->type == STT_OBJECT;
+}
+
+static inline bool is_function_symbol(struct symbol *sym)
+{
+	return sym->type == STT_FUNC;
+}
+
+static inline bool is_file_symbol(struct symbol *sym)
+{
+	return sym->type == STT_FILE;
+}
+
+static inline bool is_notype_symbol(struct symbol *sym)
+{
+	return sym->type == STT_NOTYPE;
+}
+
+static inline bool is_prefix_symbol(struct symbol *sym)
+{
+	return is_function_symbol(sym) && strstarts(sym->name, "__pfx_");
+}
+
+static inline bool is_global_symbol(struct symbol *sym)
+{
+	return sym->bind == STB_GLOBAL;
+}
+
+static inline bool is_weak_symbol(struct symbol *sym)
+{
+	return sym->bind == STB_WEAK;
+}
+
+static inline bool is_local_symbol(struct symbol *sym)
+{
+	return sym->bind == STB_LOCAL;
+}
+
+static inline bool is_reloc_section(struct section *sec)
 {
 	return sec->sh.sh_type == SHT_RELA || sec->sh.sh_type == SHT_REL;
 }
 
+static inline bool is_string_section(struct section *sec)
+{
+	return sec->sh.sh_flags & SHF_STRINGS;
+}
+
+static inline bool is_text_section(struct section *sec)
+{
+	return sec->sh.sh_flags & SHF_EXECINSTR;
+}
+
 static inline bool sec_changed(struct section *sec)
 {
 	return sec->_changed;
@@ -219,6 +285,11 @@ static inline bool is_32bit_reloc(struct reloc *reloc)
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
index 91b1950f5bd8..312d01684e21 100644
--- a/tools/objtool/special.c
+++ b/tools/objtool/special.c
@@ -152,13 +152,13 @@ int special_get_alts(struct elf *elf, struct list_head *alts)
 		if (!sec)
 			continue;
 
-		if (sec->sh.sh_size % entry->size != 0) {
+		if (sec_size(sec) % entry->size != 0) {
 			WARN("%s size not a multiple of %d",
 			     sec->name, entry->size);
 			return -1;
 		}
 
-		nr_entries = sec->sh.sh_size / entry->size;
+		nr_entries = sec_size(sec) / entry->size;
 
 		for (idx = 0; idx < nr_entries; idx++) {
 			alt = malloc(sizeof(*alt));
-- 
2.45.2


