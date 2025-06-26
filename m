Return-Path: <live-patching+bounces-1568-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C17C2AEAB4F
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:03:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7014618852E5
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C46F274FC4;
	Thu, 26 Jun 2025 23:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t0grTCpZ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F57274B55;
	Thu, 26 Jun 2025 23:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982198; cv=none; b=MME7/Eo+k+ChxQSJ8BZAXqOdwAYq40xckHHUgScPsrG0G7CqjthcSjoF+ZTi9tuOc/M/USvvqolbrd5xg3zhcYXAWmgmwrycRXybsdx2rYIbHvTs9LBbI05RjNEwKKCUPTTCoOZL7ZQd2FRmhojyfi7UnQLm3U+ZLeWKxSd6opw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982198; c=relaxed/simple;
	bh=Pm8RxnQLlIxXxlljwhf0EW5+XJmHA7lAA9ItrPUCHW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L20WcPz2okrYxY7byTleJNrO1J0tAtXivRfR3uNmAeu8TItSw7ZdRPUpr7D7IhuH0rahXWYePWzmWNATqJSQkJf2UbVoh6tXynTA/xqErFh7K+fS2h4fHT6I5qJcs/9ISBVkrsLU144vMcnCrTQfd+/KIr8fNfH5ff3ulGBaseg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t0grTCpZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957EDC4CEEB;
	Thu, 26 Jun 2025 23:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982198;
	bh=Pm8RxnQLlIxXxlljwhf0EW5+XJmHA7lAA9ItrPUCHW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0grTCpZdEY2/Yusq+3EE2/622CyD3J5c0+MUfp9sPlJ2nCUyNlxgeCiE1zjMoKjV
	 Sh8UjtXN04METfZHCgw5gLjO3wTasIEM9QiQxTZCbniEZgnujsTo3Mcx3sGgie6EOi
	 hzVLcCoihZMG0Kfnb1gdFr4l65fud+vqNoNtDngJlAcyKcUVuxlJ/vH1nq7+BO/ho3
	 2MYsuVpR20kkRasOwZ7WpDFAETjJl5jqHAb+BGBmnVWQcvATF08vXuAyhI/gg+2fZR
	 k+YHBwFKRk9A97fR3fN/B/rAuYmAbFIh47OMaH9AABj03Qa4iMXgiScW8+f9hGbNp+
	 e2gEWfmhu6vMw==
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
	Dylan Hatch <dylanbhatch@google.com>
Subject: [PATCH v3 38/64] objtool: Generalize elf_create_section()
Date: Thu, 26 Jun 2025 16:55:25 -0700
Message-ID: <ebcc791211149e00f79bb5cecaead7fba2486231.1750980517.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750980516.git.jpoimboe@kernel.org>
References: <cover.1750980516.git.jpoimboe@kernel.org>
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

While at it, make elf_create_rela_section() public so sections can be
created by the upcoming klp diff code.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c                 | 118 ++++++++++++++++------------
 tools/objtool/include/objtool/elf.h |   7 +-
 tools/objtool/orc_gen.c             |   6 +-
 3 files changed, 77 insertions(+), 54 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 127e39b05a86..4f56ea426683 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -1135,51 +1135,53 @@ static int elf_add_string(struct elf *elf, struct section *strtab, const char *s
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
@@ -1189,34 +1191,44 @@ struct section *elf_create_section(struct elf *elf, const char *name,
 
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
@@ -1229,22 +1241,23 @@ static struct section *elf_create_rela_section(struct elf *elf,
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
@@ -1259,7 +1272,8 @@ struct section *elf_create_section_pair(struct elf *elf, const char *name,
 {
 	struct section *sec;
 
-	sec = elf_create_section(elf, name, entsize, nr);
+	sec = elf_create_section(elf, name, nr * entsize, entsize,
+				 SHT_PROGBITS, 1, SHF_ALLOC);
 	if (!sec)
 		return NULL;
 
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index ffdf9ec3882e..b366516b119d 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -116,11 +116,16 @@ struct elf {
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
index 6eff3d6a125c..9d380abc2ed3 100644
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
2.49.0


