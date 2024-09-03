Return-Path: <live-patching+bounces-551-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 370C296928C
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:03:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C43C1C21541
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ECD31D47CC;
	Tue,  3 Sep 2024 04:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="to2guu/g"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652F41D47B1;
	Tue,  3 Sep 2024 04:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336038; cv=none; b=WoIgPYCpTRA92XID017sHxidg6JpYA02r487hgXN0ysfVbfnyk3HXE6P0rrgC/WEJtxUTSeOIyr7DbVAhLd7Z9MKRPdx9DENe0UhnL3WYQXTDyUFyue5/UWki+n8MkFDoTBTSXYiTcPY4gD4saUQ/jeRs0DnwPyyp3bUjdgxSq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336038; c=relaxed/simple;
	bh=HWBwAIL74R3NuwZPju7TxulBJPG6tdUTrDLO12HHwQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUR6U5cJVycePR5QsFHtxgSM0l9PRehe8EIe8T0Sx52Z6EITjYc4oIf/cmQma73LbCWCvgKiZWqgw1kJPhkT0ZLreSvQvxYjGGGUHa51iJ1kkiWyOg4/wgCwm5mM906ptha7O3E+s06PAeHFJiBmaQNiPmtCa96anzHdiA69wns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=to2guu/g; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C12C4CEC8;
	Tue,  3 Sep 2024 04:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336037;
	bh=HWBwAIL74R3NuwZPju7TxulBJPG6tdUTrDLO12HHwQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=to2guu/gJpq9Qs3QDqyHk7IPs9o3HoWtZIU1STBfc0s6W4Tcrzi6uh8p0lcFurbW9
	 jMpK/PUVuTdJgoQspc9z0X4RvFtsT6Ena7QX1yDXEN+bsR5tsm3SBql4bfiOb6WeGA
	 8s8iqZANTfokzzCwwcfIUwuLUp+GcrWeEwMXo1CNLoeDZpytAnj5Sd+tVp0I4QnTSc
	 jvubKcODeqCKEqXAZ6v3dlQrhkyB4cF6t5UTvjHLa8lvG0XvOH8S8XK0JrDBoY09zx
	 exLjXmv/ecUeq/H3QjQ2m8WD4L6FtUrb38E35T90/RNnlNVpT77CTVbPmg1fWGvjKb
	 MjWWQz3qUJRhw==
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
Subject: [RFC 17/31] objtool: Open up the elf API
Date: Mon,  2 Sep 2024 21:00:00 -0700
Message-ID: <ebf2286ed0aeb66c61501c9df935b1193eeeb702.1725334260.git.jpoimboe@kernel.org>
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

Expose more functionality in the ELF library.  This will be needed for
the upcoming "objtool klp" support.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c                 | 338 +++++++++++++++++++---------
 tools/objtool/include/objtool/elf.h |  30 ++-
 tools/objtool/orc_gen.c             |   6 +-
 3 files changed, 260 insertions(+), 114 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 84cb6fc235c9..0c95d7cdf0f5 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -18,10 +18,11 @@
 #include <errno.h>
 #include <linux/interval_tree_generic.h>
 #include <objtool/builtin.h>
-
 #include <objtool/elf.h>
 #include <objtool/warn.h>
 
+#define ALIGN_UP(x, align_to) (((x) + ((align_to)-1)) & ~((align_to)-1))
+
 static inline u32 str_hash(const char *str)
 {
 	return jhash(str, strlen(str), 0);
@@ -261,6 +262,18 @@ struct symbol *find_symbol_by_name(const struct elf *elf, const char *name)
 	return NULL;
 }
 
+struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *name)
+{
+	struct symbol *sym;
+
+	elf_hash_for_each_possible(symbol_name, sym, name_hash, str_hash(name)) {
+		if (!strcmp(sym->name, name) && !is_local_symbol(sym))
+			return sym;
+	}
+
+	return NULL;
+}
+
 struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *sec,
 				     unsigned long offset, unsigned int len)
 {
@@ -549,7 +562,7 @@ static void elf_update_sym_relocs(struct elf *elf, struct symbol *sym)
 static void elf_update_symbol(struct elf *elf, struct section *symtab,
 			     struct section *symtab_shndx, struct symbol *sym)
 {
-	Elf32_Word shndx = sym->sec ? sym->sec->idx : SHN_UNDEF;
+	Elf32_Word shndx;
 	Elf_Data *symtab_data = NULL, *shndx_data = NULL;
 	Elf64_Xword entsize = symtab->sh.sh_entsize;
 	int max_idx, idx = sym->idx;
@@ -557,8 +570,7 @@ static void elf_update_symbol(struct elf *elf, struct section *symtab,
 	bool is_special_shndx = sym->sym.st_shndx >= SHN_LORESERVE &&
 				sym->sym.st_shndx != SHN_XINDEX;
 
-	if (is_special_shndx)
-		shndx = sym->sym.st_shndx;
+	shndx = is_special_shndx ? sym->sym.st_shndx : sym->sec->idx;
 
 	s = elf_getscn(elf->elf, symtab->idx);
 	if (!s)
@@ -654,12 +666,29 @@ static void elf_update_symbol(struct elf *elf, struct section *symtab,
 		ERROR_ELF("gelf_update_symshndx");
 }
 
-static struct symbol *
-__elf_create_symbol(struct elf *elf, struct symbol *sym)
+static struct symbol *__elf_create_symbol(struct elf *elf, const char *name,
+					  struct section *sec, unsigned int bind,
+					  unsigned int type, unsigned long offset,
+					  size_t size)
 {
 	struct section *symtab, *symtab_shndx;
 	Elf32_Word first_non_local, new_idx;
-	struct symbol *old;
+	struct symbol *old, *sym;
+
+	sym = calloc(1, sizeof(*sym));
+	ERROR_ON(!sym, "calloc");
+
+	if (name) {
+		sym->name = strdup(name);
+		if (type != STT_SECTION)
+			sym->sym.st_name = elf_add_string(elf, NULL, sym->name);
+	}
+
+	sym->sec = sec ? : find_section_by_index(elf, 0);
+
+	sym->sym.st_info  = GELF_ST_INFO(bind, type);
+	sym->sym.st_value = offset;
+	sym->sym.st_size  = size;
 
 	symtab = find_section_by_name(elf, ".symtab");
 	if (!symtab)
@@ -669,7 +698,7 @@ __elf_create_symbol(struct elf *elf, struct symbol *sym)
 
 	new_idx = sec_num_entries(symtab);
 
-	if (GELF_ST_BIND(sym->sym.st_info) != STB_LOCAL)
+	if (bind != STB_LOCAL)
 		goto non_local;
 
 	/*
@@ -698,7 +727,8 @@ __elf_create_symbol(struct elf *elf, struct symbol *sym)
 
 non_local:
 	sym->idx = new_idx;
-	elf_update_symbol(elf, symtab, symtab_shndx, sym);
+	if (sym->idx)
+		elf_update_symbol(elf, symtab, symtab_shndx, sym);
 
 	symtab->sh.sh_size += symtab->sh.sh_entsize;
 	mark_sec_changed(elf, symtab, true);
@@ -708,63 +738,49 @@ __elf_create_symbol(struct elf *elf, struct symbol *sym)
 		mark_sec_changed(elf, symtab_shndx, true);
 	}
 
+	elf_add_symbol(elf, sym);
+
 	return sym;
 }
 
-static struct symbol *
-elf_create_section_symbol(struct elf *elf, struct section *sec)
+struct symbol *elf_create_symbol(struct elf *elf, const char *name,
+				   struct section *sec, unsigned int bind,
+				   unsigned int type, unsigned long offset,
+				   size_t size)
+{
+	return __elf_create_symbol(elf, name, sec, bind, type, offset, size);
+}
+
+struct symbol *elf_create_section_symbol(struct elf *elf, struct section *sec)
 {
 	struct symbol *sym;
 
-	sym = calloc(1, sizeof(*sym));
-	ERROR_ON(!sym, "calloc");
-
-	sym->name = sec->name;
-	sym->sec = sec;
-
-	// st_name 0
-	sym->sym.st_info = GELF_ST_INFO(STB_LOCAL, STT_SECTION);
-	// st_other 0
-	// st_value 0
-	// st_size 0
-
-	sym = __elf_create_symbol(elf, sym);
-	elf_add_symbol(elf, sym);
+	sym = elf_create_symbol(elf, sec->name, sec, STB_LOCAL, STT_SECTION, 0, 0);
+	sec->sym = sym;
 
 	return sym;
 }
 
-static int elf_add_string(struct elf *elf, struct section *strtab, const char *str);
-
 struct symbol *
-elf_create_prefix_symbol(struct elf *elf, struct symbol *orig, long size)
+elf_create_prefix_symbol(struct elf *elf, struct symbol *orig, size_t size)
 {
-	struct symbol *sym = calloc(1, sizeof(*sym));
 	size_t namelen = strlen(orig->name) + sizeof("__pfx_");
-	char *name = malloc(namelen);
-
-	ERROR_ON(!sym || !name, "malloc");
+	char name[SYM_NAME_LEN];
+	unsigned long offset;
 
 	snprintf(name, namelen, "__pfx_%s", orig->name);
 
-	sym->name = name;
-	sym->sec = orig->sec;
+	offset = orig->sym.st_value - size;
 
-	sym->sym.st_name = elf_add_string(elf, NULL, name);
-	sym->sym.st_info = orig->sym.st_info;
-	sym->sym.st_value = orig->sym.st_value - size;
-	sym->sym.st_size = size;
-
-	sym = __elf_create_symbol(elf, sym);
-	elf_add_symbol(elf, sym);
-
-	return sym;
+	return elf_create_symbol(elf, name, orig->sec,
+				 GELF_ST_BIND(orig->sym.st_info),
+				 GELF_ST_TYPE(orig->sym.st_info),
+				 offset, size);
 }
 
-static struct reloc *elf_init_reloc(struct elf *elf, struct section *rsec,
-				    unsigned int reloc_idx,
-				    unsigned long offset, struct symbol *sym,
-				    s64 addend, unsigned int type)
+struct reloc *elf_init_reloc(struct elf *elf, struct section *rsec,
+			     unsigned int reloc_idx, unsigned long offset,
+			     struct symbol *sym, s64 addend, unsigned int type)
 {
 	struct reloc *reloc, empty = { 0 };
 
@@ -800,7 +816,7 @@ struct reloc *elf_init_reloc_text_sym(struct elf *elf, struct section *sec,
 				    unsigned long insn_off)
 {
 	struct symbol *sym = insn_sec->sym;
-	int addend = insn_off;
+	s64 addend = insn_off;
 
 	if (!is_text_section(insn_sec))
 		ERROR("bad call to %s() for data symbol %s", __func__, sym->name);
@@ -813,8 +829,6 @@ struct reloc *elf_init_reloc_text_sym(struct elf *elf, struct section *sec,
 		 * non-weak function after linking.
 		 */
 		sym = elf_create_section_symbol(elf, insn_sec);
-
-		insn_sec->sym = sym;
 	}
 
 	return elf_init_reloc(elf, sec->rsec, reloc_idx, offset, sym, addend,
@@ -926,11 +940,9 @@ struct elf *elf_open_read(const char *name, int flags)
 	return elf;
 }
 
-static int elf_add_string(struct elf *elf, struct section *strtab, const char *str)
+unsigned long elf_add_string(struct elf *elf, struct section *strtab, const char *str)
 {
-	Elf_Data *data;
-	Elf_Scn *s;
-	int len;
+	unsigned long offset;
 
 	if (!strtab) {
 		strtab = find_section_by_name(elf, ".strtab");
@@ -938,56 +950,77 @@ static int elf_add_string(struct elf *elf, struct section *strtab, const char *s
 			ERROR("can't find .strtab section");
 	}
 
-	s = elf_getscn(elf->elf, strtab->idx);
-	if (!s)
-		ERROR_ELF("elf_getscn");
+	offset = ALIGN_UP(strtab->sh.sh_size, strtab->sh.sh_addralign);
 
-	data = elf_newdata(s);
-	if (!data)
-		ERROR_ELF("elf_newdata");
+	elf_add_data(elf, strtab, str, strlen(str) + 1);
 
-	data->d_buf = strdup(str);
-	data->d_size = strlen(str) + 1;
-	data->d_align = 1;
-
-	len = strtab->sh.sh_size;
-	strtab->sh.sh_size += data->d_size;
-
-	mark_sec_changed(elf, strtab, true);
-
-	return len;
+	return offset;
 }
 
-struct section *elf_create_section(struct elf *elf, const char *name,
-				   size_t entsize, unsigned int nr)
+void *elf_add_data(struct elf *elf, struct section *sec, const void *data, size_t size)
 {
-	struct section *sec, *shstrtab;
-	size_t size = entsize * nr;
+	unsigned long offset;
 	Elf_Scn *s;
 
-	sec = malloc(sizeof(*sec));
-	ERROR_ON(!sec, "malloc");
-	memset(sec, 0, sizeof(*sec));
-
-	INIT_LIST_HEAD(&sec->symbol_list);
-
-	s = elf_newscn(elf->elf);
+	s = elf_getscn(elf->elf, sec->idx);
 	if (!s)
-		ERROR_ELF("elf_newscn");
-
-	sec->name = strdup(name);
-	ERROR_ON(!sec->name, "strdup");
-
-	sec->idx = elf_ndxscn(s);
+		ERROR_ELF("elf_getscn");
 
 	sec->data = elf_newdata(s);
 	if (!sec->data)
 		ERROR_ELF("elf_newdata");
 
+	sec->data->d_buf = calloc(1, size);
+	ERROR_ON(!sec->data->d_buf, "calloc");
+
+	if (data)
+		memcpy(sec->data->d_buf, data, size);
+
 	sec->data->d_size = size;
-	sec->data->d_align = 1;
+	sec->data->d_align = sec->sh.sh_addralign;
+
+	offset = ALIGN_UP(sec->sh.sh_size, sec->sh.sh_addralign);
+	sec->sh.sh_size = offset + size;
+
+	mark_sec_changed(elf, sec, true);
+
+	return sec->data->d_buf;
+}
+
+struct section *elf_create_section(struct elf *elf, const char *name,
+				   size_t size, size_t entsize,
+				   unsigned int type, unsigned int align,
+				   unsigned int flags)
+{
+	struct section *sec, *shstrtab;
+	Elf_Scn *s;
+
+	if (name && find_section_by_name(elf, name))
+		ERROR("section '%s' already exists", name);
+
+	sec = calloc(1, sizeof(*sec));
+	ERROR_ON(!sec, "calloc");
+
+	INIT_LIST_HEAD(&sec->symbol_list);
+
+	/* don't actually create the section, just the data structures */
+	if (type == SHT_NULL)
+		goto add;
+
+	s = elf_newscn(elf->elf);
+	if (!s)
+		ERROR_ELF("elf_newscn");
+
+	sec->idx = elf_ndxscn(s);
 
 	if (size) {
+		sec->data = elf_newdata(s);
+		if (!sec->data)
+			ERROR_ELF("elf_newdata");
+
+		sec->data->d_size = size;
+		sec->data->d_align = 1;
+
 		sec->data->d_buf = calloc(1, size);
 		ERROR_ON(!sec->data->d_buf, "calloc");
 	}
@@ -997,31 +1030,37 @@ struct section *elf_create_section(struct elf *elf, const char *name,
 
 	sec->sh.sh_size = size;
 	sec->sh.sh_entsize = entsize;
-	sec->sh.sh_type = SHT_PROGBITS;
-	sec->sh.sh_addralign = 1;
-	sec->sh.sh_flags = SHF_ALLOC;
+	sec->sh.sh_type = type;
+	sec->sh.sh_addralign = align;
+	sec->sh.sh_flags = flags;
 
-	/* Add section name to .shstrtab (or .strtab for Clang) */
-	shstrtab = find_section_by_name(elf, ".shstrtab");
-	if (!shstrtab) {
-		shstrtab = find_section_by_name(elf, ".strtab");
-		if (!shstrtab)
-			ERROR("can't find .shstrtab or .strtab section");
+	if (name) {
+		sec->name = strdup(name);
+		ERROR_ON(!sec->name, "strdup");
+
+		/* Add section name to .shstrtab (or .strtab for Clang) */
+		shstrtab = find_section_by_name(elf, ".shstrtab");
+		if (!shstrtab) {
+			shstrtab = find_section_by_name(elf, ".strtab");
+			if (!shstrtab)
+				ERROR("can't find .shstrtab or .strtab section");
+		}
+		sec->sh.sh_name = elf_add_string(elf, shstrtab, sec->name);
+
+		elf_hash_add(section_name, &sec->name_hash, str_hash(sec->name));
 	}
-	sec->sh.sh_name = elf_add_string(elf, shstrtab, sec->name);
 
+add:
 	list_add_tail(&sec->list, &elf->sections);
 	elf_hash_add(section, &sec->hash, sec->idx);
-	elf_hash_add(section_name, &sec->name_hash, str_hash(sec->name));
 
 	mark_sec_changed(elf, sec, true);
 
 	return sec;
 }
 
-static struct section *elf_create_rela_section(struct elf *elf,
-					       struct section *sec,
-					       unsigned int reloc_nr)
+struct section *elf_create_rela_section(struct elf *elf, struct section *sec,
+					unsigned int reloc_nr)
 {
 	struct section *rsec;
 	char *rsec_name;
@@ -1032,33 +1071,110 @@ static struct section *elf_create_rela_section(struct elf *elf,
 	strcpy(rsec_name, ".rela");
 	strcat(rsec_name, sec->name);
 
-	rsec = elf_create_section(elf, rsec_name, elf_rela_size(elf), reloc_nr);
-	free(rsec_name);
+	rsec = elf_create_section(elf, rsec_name, reloc_nr * elf_rela_size(elf),
+				  elf_rela_size(elf), SHT_RELA, elf_addr_size(elf),
+				  SHF_INFO_LINK);
 
-	rsec->data->d_type = ELF_T_RELA;
-	rsec->sh.sh_type = SHT_RELA;
-	rsec->sh.sh_addralign = elf_addr_size(elf);
 	rsec->sh.sh_link = find_section_by_name(elf, ".symtab")->idx;
 	rsec->sh.sh_info = sec->idx;
-	rsec->sh.sh_flags = SHF_INFO_LINK;
 
-	rsec->relocs = calloc(sec_num_entries(rsec), sizeof(struct reloc));
-	ERROR_ON(!rsec->relocs, "calloc");
+	if (reloc_nr) {
+		rsec->data->d_type = ELF_T_RELA;
+		rsec->relocs = calloc(sec_num_entries(rsec), sizeof(struct reloc));
+		ERROR_ON(!rsec->relocs, "calloc");
+	}
 
 	sec->rsec = rsec;
+	free(rsec_name);
+
 	rsec->base = sec;
 
 	return rsec;
 }
 
+// TODO: preallocate sec->relocs so this doesn't happen often
+// TODO: can avoid for bundled sections
+static void elf_alloc_reloc(struct elf *elf, struct section *rsec)
+{
+	unsigned int nr_relocs = sec_num_entries(rsec);
+	struct reloc *old_relocs, *new_relocs;
+	struct symbol *sym;
+
+	old_relocs = rsec->relocs;
+	new_relocs = calloc(1, (nr_relocs + 1) * sizeof(struct reloc));
+	ERROR_ON(!new_relocs, "calloc");
+
+	if (!old_relocs)
+		goto done;
+
+	// update syms and relocs which reference the reloc
+	for_each_sym(elf, sym) {
+		struct reloc **reloc;
+
+		for (reloc = &sym->relocs; *reloc; ) {
+			struct reloc **next = &((*reloc)->sym_next_reloc);
+			if (*reloc >= old_relocs && *reloc < &old_relocs[nr_relocs]) {
+				*reloc = &new_relocs[*reloc - old_relocs];
+			}
+			reloc = next;
+		}
+	}
+
+	memcpy(new_relocs, old_relocs, (nr_relocs * sizeof(struct reloc)));
+
+	for (int i = 0; i < nr_relocs; i++) {
+		struct reloc *old = &old_relocs[i];
+		struct reloc *new = &new_relocs[i];
+		u32 key = reloc_hash(old);
+
+		elf_hash_del(reloc, &old->hash, key);
+		elf_hash_add(reloc, &new->hash, key);
+	}
+
+	free(old_relocs);
+done:
+	rsec->relocs = new_relocs;
+}
+
+struct reloc *elf_create_reloc(struct elf *elf, struct section *sec,
+			       unsigned long offset,
+			       struct symbol *sym, s64 addend,
+			       unsigned int type)
+{
+	struct section *rsec = sec->rsec;
+
+	if (!rsec)
+		rsec = elf_create_rela_section(elf, sec, 0);
+
+	if (find_reloc_by_dest(elf, sec, offset))
+		ERROR_FUNC(sec, offset, "duplicate reloc");
+
+	if (!rsec->data) {
+		rsec->data = elf_newdata(elf_getscn(elf->elf, rsec->idx));
+		rsec->data->d_align = 1;
+		rsec->data->d_type = ELF_T_RELA;
+	}
+
+	elf_alloc_reloc(elf, rsec);
+
+	rsec->sh.sh_size += elf_rela_size(elf);
+	rsec->data->d_size = rsec->sh.sh_size;
+	rsec->data->d_buf = realloc(rsec->data->d_buf, rsec->sh.sh_size);
+	return elf_init_reloc(elf, rsec, sec_num_entries(rsec) - 1, offset, sym,
+			      addend, type);
+}
+
 struct section *elf_create_section_pair(struct elf *elf, const char *name,
 					size_t entsize, unsigned int nr,
 					unsigned int reloc_nr)
 {
 	struct section *sec;
 
-	sec = elf_create_section(elf, name, entsize, nr);
+	sec = elf_create_section(elf, name, nr * entsize, entsize,
+				 SHT_PROGBITS, 1, SHF_ALLOC);
+
 	elf_create_rela_section(elf, sec, reloc_nr);
+
 	return sec;
 }
 
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 8585b9802e1b..e91bbe7f07bf 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -15,6 +15,8 @@
 #include <linux/jhash.h>
 #include <arch/elf.h>
 
+#define SYM_NAME_LEN		512
+
 #ifdef LIBELF_USE_DEPRECATED
 # define elf_getshdrnum    elf_getshnum
 # define elf_getshdrstrndx elf_getshstrndx
@@ -109,12 +111,33 @@ struct elf {
 struct elf *elf_open_read(const char *name, int flags);
 
 struct section *elf_create_section(struct elf *elf, const char *name,
-				   size_t entsize, unsigned int nr);
+				   size_t size, size_t entsize,
+				   unsigned int type, unsigned int align,
+				   unsigned int flags);
 struct section *elf_create_section_pair(struct elf *elf, const char *name,
 					size_t entsize, unsigned int nr,
 					unsigned int reloc_nr);
 
-struct symbol *elf_create_prefix_symbol(struct elf *elf, struct symbol *orig, long size);
+struct section *elf_create_rela_section(struct elf *elf, struct section *sec,
+					unsigned int reloc_nr);
+
+struct symbol *elf_create_symbol(struct elf *elf, const char *name,
+				 struct section *sec, unsigned int bind,
+				 unsigned int type, unsigned long offset,
+				 size_t size);
+struct symbol *elf_create_section_symbol(struct elf *elf, struct section *sec);
+struct symbol *elf_create_prefix_symbol(struct elf *elf, struct symbol *orig,
+					size_t size);
+
+struct reloc *elf_create_reloc(struct elf *elf, struct section *sec,
+			       unsigned long offset, struct symbol *sym,
+			       s64 addend, unsigned int type);
+void *elf_add_data(struct elf *elf, struct section *sec, const void *data,
+		   size_t size);
+
+struct reloc *elf_init_reloc(struct elf *elf, struct section *rsec,
+			     unsigned int reloc_idx, unsigned long offset,
+			     struct symbol *sym, s64 addend, unsigned int type);
 
 struct reloc *elf_init_reloc_text_sym(struct elf *elf, struct section *sec,
 				      unsigned long offset,
@@ -128,6 +151,8 @@ struct reloc *elf_init_reloc_data_sym(struct elf *elf, struct section *sec,
 				      struct symbol *sym,
 				      s64 addend);
 
+unsigned long elf_add_string(struct elf *elf, struct section *strtab, const char *str);
+
 void elf_write_insn(struct elf *elf, struct section *sec,
 		    unsigned long offset, unsigned int len,
 		    const char *insn);
@@ -138,6 +163,7 @@ struct section *find_section_by_name(const struct elf *elf, const char *name);
 struct symbol *find_func_by_offset(struct section *sec, unsigned long offset);
 struct symbol *find_symbol_by_offset(struct section *sec, unsigned long offset);
 struct symbol *find_symbol_by_name(const struct elf *elf, const char *name);
+struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *name);
 struct symbol *find_symbol_containing(const struct section *sec, unsigned long offset);
 int find_symbol_hole_containing(const struct section *sec, unsigned long offset);
 struct reloc *find_reloc_by_dest(const struct elf *elf, struct section *sec, unsigned long offset);
diff --git a/tools/objtool/orc_gen.c b/tools/objtool/orc_gen.c
index 56aca3845e20..3301128b5188 100644
--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
@@ -121,7 +121,11 @@ int orc_create(struct objtool_file *file)
 		return 0;
 	}
 	orc_sec = elf_create_section(file->elf, ".orc_unwind",
-				     sizeof(struct orc_entry), nr);
+				     nr * sizeof(struct orc_entry),
+				     sizeof(struct orc_entry),
+				     SHT_PROGBITS,
+				     1,
+				     SHF_ALLOC);
 
 	sec = elf_create_section_pair(file->elf, ".orc_unwind_ip", sizeof(int), nr, nr);
 
-- 
2.45.2


