Return-Path: <live-patching+bounces-1695-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF553B80E45
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:13:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67F5454231B
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:11:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55AD033BB1E;
	Wed, 17 Sep 2025 16:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rVWGIzSN"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D10C2F90EA;
	Wed, 17 Sep 2025 16:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125085; cv=none; b=fFUlS+nnVILAS6Z5AlHB8tm6qM3ZOQjl9SbbZ+WnWvzdgbiZVFHeDq1zZGA+9PSXbXn3Nhnr4yA+le4ki/5RwL0aPIl4YbxmIU6pmYIkRQLwxqKgWxZvJ0Fe4gMwoE3mmS+aHk/zeRuRAfIauQHDi1ErPr3Dqohdofm074YYBX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125085; c=relaxed/simple;
	bh=bZ8tEY6fGWjq2WSiBZfavgEoDtttGsNKWxFegWLNgOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUZOyuuKT3Ga01xRy2hjIheeIhCnFFh9R0yPMTibakfr0DQHd4gu0R3OLNkjO/uk/jIXIoSghpKsPTmFaBmQsIEZi36Ty43XtnnlvNvlq1s0IyjXUrpJtFgApi5uE9XQs/ByvIHg59QeUXTIfD6jqe/rs5rKM6HRf+A9mpte/SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rVWGIzSN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F05EC4CEF9;
	Wed, 17 Sep 2025 16:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125084;
	bh=bZ8tEY6fGWjq2WSiBZfavgEoDtttGsNKWxFegWLNgOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rVWGIzSNHdQmUVkztjCwLd8IZJKYJkn5NfMsr8hSd3bkvezMT7gpB3ota0ZldNC93
	 WYoEwafUrYB3Awukdc+9aHQr6697jtWqJxxRwubOo9LKTHMT7MJnxOCN3lmFcWJerq
	 +MLR6jqOnh76cO/NjSJXTv0aOJj6f8pa7ISOKAYSfkU+LFHrlyt6S975NW9jrYGfo+
	 i1m7uztiLfH7y94I/Cj6nDVdIPoz3Papf5zPjVsDwk16f13KF42Fvu6i9GXOYzORYU
	 qZ6S2MiD6nfdZz2y3FycOO4xMJiJtFeCYCFhM/wePURMiSqrMX3eALaf9RLxa8rz7k
	 XvnRWprokJ6GA==
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
Subject: [PATCH v4 40/63] objtool: Generalize elf_create_section()
Date: Wed, 17 Sep 2025 09:03:48 -0700
Message-ID: <1300a2fb07a17c878598aaa276c2222ed085ac1d.1758067943.git.jpoimboe@kernel.org>
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

In preparation for the objtool klp diff subcommand, broaden the
elf_create_section() interface to give callers more control and reduce
duplication of some subtle setup logic.

While at it, make elf_create_rela_section() global so sections can be
created by the upcoming klp diff code.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c                 | 118 ++++++++++++++++------------
 tools/objtool/include/objtool/elf.h |   7 +-
 tools/objtool/orc_gen.c             |   6 +-
 3 files changed, 77 insertions(+), 54 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index d7703c848ce02..7a7e63c7153f4 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -1138,51 +1138,53 @@ static int elf_add_string(struct elf *elf, struct section *strtab, const char *s
 }
 
 struct section *elf_create_section(struct elf *elf, const char *name,
-				   size_t entsize, unsigned int nr)
+				   size_t size, size_t entsize,
+				   unsigned int type, unsigned int align,
+				   unsigned int flags)
 {
 	struct section *sec, *shstrtab;
-	size_t size = entsize * nr;
 	Elf_Scn *s;
 
-	sec = malloc(sizeof(*sec));
-	if (!sec) {
-		ERROR_GLIBC("malloc");
+	if (name && find_section_by_name(elf, name)) {
+		ERROR("section '%s' already exists", name);
+		return NULL;
+	}
+
+	sec = calloc(1, sizeof(*sec));
+	if (!sec) {
+		ERROR_GLIBC("calloc");
 		return NULL;
 	}
-	memset(sec, 0, sizeof(*sec));
 
 	INIT_LIST_HEAD(&sec->symbol_list);
 
+	/* don't actually create the section, just the data structures */
+	if (type == SHT_NULL)
+		goto add;
+
 	s = elf_newscn(elf->elf);
 	if (!s) {
 		ERROR_ELF("elf_newscn");
 		return NULL;
 	}
 
-	sec->name = strdup(name);
-	if (!sec->name) {
-		ERROR_GLIBC("strdup");
-		return NULL;
-	}
-
 	sec->idx = elf_ndxscn(s);
 
-	sec->data = elf_newdata(s);
-	if (!sec->data) {
-		ERROR_ELF("elf_newdata");
-		return NULL;
-	}
-
-	sec->data->d_size = size;
-	sec->data->d_align = 1;
-
 	if (size) {
-		sec->data->d_buf = malloc(size);
-		if (!sec->data->d_buf) {
-			ERROR_GLIBC("malloc");
+		sec->data = elf_newdata(s);
+		if (!sec->data) {
+			ERROR_ELF("elf_newdata");
+			return NULL;
+		}
+
+		sec->data->d_size = size;
+		sec->data->d_align = 1;
+
+		sec->data->d_buf = calloc(1, size);
+		if (!sec->data->d_buf) {
+			ERROR_GLIBC("calloc");
 			return NULL;
 		}
-		memset(sec->data->d_buf, 0, size);
 	}
 
 	if (!gelf_getshdr(s, &sec->sh)) {
@@ -1192,34 +1194,44 @@ struct section *elf_create_section(struct elf *elf, const char *name,
 
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
-	if (!shstrtab)
-		shstrtab = find_section_by_name(elf, ".strtab");
-	if (!shstrtab) {
-		ERROR("can't find .shstrtab or .strtab section");
-		return NULL;
+	if (name) {
+		sec->name = strdup(name);
+		if (!sec->name) {
+			ERROR("strdup");
+			return NULL;
+		}
+
+		/* Add section name to .shstrtab (or .strtab for Clang) */
+		shstrtab = find_section_by_name(elf, ".shstrtab");
+		if (!shstrtab) {
+			shstrtab = find_section_by_name(elf, ".strtab");
+			if (!shstrtab) {
+				ERROR("can't find .shstrtab or .strtab");
+				return NULL;
+			}
+		}
+		sec->sh.sh_name = elf_add_string(elf, shstrtab, sec->name);
+		if (sec->sh.sh_name == -1)
+			return NULL;
+
+		elf_hash_add(section_name, &sec->name_hash, str_hash(sec->name));
 	}
-	sec->sh.sh_name = elf_add_string(elf, shstrtab, sec->name);
-	if (sec->sh.sh_name == -1)
-		return NULL;
 
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
@@ -1232,22 +1244,23 @@ static struct section *elf_create_rela_section(struct elf *elf,
 	strcpy(rsec_name, ".rela");
 	strcat(rsec_name, sec->name);
 
-	rsec = elf_create_section(elf, rsec_name, elf_rela_size(elf), reloc_nr);
+	rsec = elf_create_section(elf, rsec_name, reloc_nr * elf_rela_size(elf),
+				  elf_rela_size(elf), SHT_RELA, elf_addr_size(elf),
+				  SHF_INFO_LINK);
 	free(rsec_name);
 	if (!rsec)
 		return NULL;
 
-	rsec->data->d_type = ELF_T_RELA;
-	rsec->sh.sh_type = SHT_RELA;
-	rsec->sh.sh_addralign = elf_addr_size(elf);
 	rsec->sh.sh_link = find_section_by_name(elf, ".symtab")->idx;
 	rsec->sh.sh_info = sec->idx;
-	rsec->sh.sh_flags = SHF_INFO_LINK;
 
-	rsec->relocs = calloc(sec_num_entries(rsec), sizeof(struct reloc));
-	if (!rsec->relocs) {
-		ERROR_GLIBC("calloc");
-		return NULL;
+	if (reloc_nr) {
+		rsec->data->d_type = ELF_T_RELA;
+		rsec->relocs = calloc(sec_num_entries(rsec), sizeof(struct reloc));
+		if (!rsec->relocs) {
+			ERROR_GLIBC("calloc");
+			return NULL;
+		}
 	}
 
 	sec->rsec = rsec;
@@ -1262,7 +1275,8 @@ struct section *elf_create_section_pair(struct elf *elf, const char *name,
 {
 	struct section *sec;
 
-	sec = elf_create_section(elf, name, entsize, nr);
+	sec = elf_create_section(elf, name, nr * entsize, entsize,
+				 SHT_PROGBITS, 1, SHF_ALLOC);
 	if (!sec)
 		return NULL;
 
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index c33b8fa0e3cec..badb10926d1e9 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -117,11 +117,16 @@ struct elf {
 struct elf *elf_open_read(const char *name, int flags);
 
 struct section *elf_create_section(struct elf *elf, const char *name,
-				   size_t entsize, unsigned int nr);
+				   size_t size, size_t entsize,
+				   unsigned int type, unsigned int align,
+				   unsigned int flags);
 struct section *elf_create_section_pair(struct elf *elf, const char *name,
 					size_t entsize, unsigned int nr,
 					unsigned int reloc_nr);
 
+struct section *elf_create_rela_section(struct elf *elf, struct section *sec,
+					unsigned int reloc_nr);
+
 struct symbol *elf_create_symbol(struct elf *elf, const char *name,
 				 struct section *sec, unsigned int bind,
 				 unsigned int type, unsigned long offset,
diff --git a/tools/objtool/orc_gen.c b/tools/objtool/orc_gen.c
index 6eff3d6a125c2..9d380abc2ed35 100644
--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
@@ -127,7 +127,11 @@ int orc_create(struct objtool_file *file)
 		return -1;
 	}
 	orc_sec = elf_create_section(file->elf, ".orc_unwind",
-				     sizeof(struct orc_entry), nr);
+				     nr * sizeof(struct orc_entry),
+				     sizeof(struct orc_entry),
+				     SHT_PROGBITS,
+				     1,
+				     SHF_ALLOC);
 	if (!orc_sec)
 		return -1;
 
-- 
2.50.0


