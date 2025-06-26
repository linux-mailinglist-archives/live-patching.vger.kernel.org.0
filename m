Return-Path: <live-patching+bounces-1570-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C7833AEAB54
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7BB417B7CC5
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:02:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 356B32797B3;
	Thu, 26 Jun 2025 23:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T80YUVuU"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1E927814F;
	Thu, 26 Jun 2025 23:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982200; cv=none; b=WF9Fx2hF1/E3pIGaJ/bDoCRYgOowstqhsWNgwjH2DGgKkP8GasbR8TcYsrOObHeJ3yb8Q1Kk4IeZGPHdHO9psqiPMGKo8tZZwunTEh2sddTzW6BHnCkN1XBwQTSLk/lLRvRy2xStuPona1BV0oF4M3EQY088a0Rl0i8Qqt0IKF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982200; c=relaxed/simple;
	bh=ZQdHrtvLDERCGJxK7kndLOryOSth6EpE24Kv/FPD/3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VV8H9sXyH1zR2A9rDFDtTOVzCO8GX7r5NYRFCSYra6Q3+hT+rYU0Qt8EZgP+ICmnW8ybZiy85IXdgBoBPzZvO8HKv1PI58sjMEvQHtZwBabaS11lBBYNxqYmPR5bCfK1pYRKuYkgTKaU9RZ9reS/bu8goIny6VY29VX+C7KSvgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T80YUVuU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F423FC4AF0B;
	Thu, 26 Jun 2025 23:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982199;
	bh=ZQdHrtvLDERCGJxK7kndLOryOSth6EpE24Kv/FPD/3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T80YUVuUuchJodLH/7BdJ5S7sACD0kAxNbfgImC2480UxvLvn72X58p850Sy7XuV0
	 KZaHRaCpWox7miMdMdZsKOucFqQvKZZIdYTccBY0ggtdL2DI3/TbwrU8zn6eA3fC2W
	 IU48+lVyaOZb+RT3qDuXVUnDHLc84LEMMNIViTTze5/fXOOEA6MfVvU1zFxtiROZIO
	 YIPXCsC7epi+cJqk7PAEQ1S3giYAyBZ7zr9jMlgg2LUIuRgZoXO6tUwdrwkkK3HVjQ
	 tagjg5evpw5oYtIzNdKnrOmMWv2T52DiKuULOow775gm4JBko6gUdiHFkIusn69WyM
	 7rV6a9oCDB6jg==
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
Subject: [PATCH v3 40/64] objtool: Add elf_create_reloc() and elf_init_reloc()
Date: Thu, 26 Jun 2025 16:55:27 -0700
Message-ID: <28472bc6f2c7e25cd034d1ba6d591ba1c0252933.1750980517.git.jpoimboe@kernel.org>
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

elf_create_rela_section() is quite limited in that it requires the
caller to know how many relocations need to be allocated up front.

In preparation for the objtool klp diff subcommand, allow an arbitrary
number of relocations to be created and initialized on demand after
section creation.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c                 | 151 +++++++++++++++++++++++++---
 tools/objtool/include/objtool/elf.h |   9 ++
 2 files changed, 145 insertions(+), 15 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 535bdcf077d0..0e98cf2ab533 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -22,6 +22,8 @@
 #include <objtool/warn.h>
 
 #define ALIGN_UP(x, align_to) (((x) + ((align_to)-1)) & ~((align_to)-1))
+#define ALIGN_UP_POW2(x) (1U << ((8 * sizeof(x)) - __builtin_clz((x) - 1U)))
+#define MAX(a, b) ((a) > (b) ? (a) : (b))
 
 static inline u32 str_hash(const char *str)
 {
@@ -896,10 +898,9 @@ elf_create_prefix_symbol(struct elf *elf, struct symbol *orig, size_t size)
 				 offset, size);
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
 
@@ -1001,12 +1002,14 @@ static int read_relocs(struct elf *elf)
 
 		rsec->base->rsec = rsec;
 
-		nr_reloc = 0;
-		rsec->relocs = calloc(sec_num_entries(rsec), sizeof(*reloc));
+		rsec->nr_alloc_relocs = sec_num_entries(rsec);
+		rsec->relocs = calloc(rsec->nr_alloc_relocs, sizeof(*reloc));
 		if (!rsec->relocs) {
 			ERROR_GLIBC("calloc");
 			return -1;
 		}
+
+		nr_reloc = 0;
 		for (i = 0; i < sec_num_entries(rsec); i++) {
 			reloc = &rsec->relocs[i];
 
@@ -1255,8 +1258,99 @@ struct section *elf_create_section(struct elf *elf, const char *name,
 	return sec;
 }
 
+static int elf_alloc_reloc(struct elf *elf, struct section *rsec)
+{
+	struct reloc *old_relocs, *old_relocs_end, *new_relocs;
+	unsigned int nr_relocs_old = sec_num_entries(rsec);
+	unsigned int nr_relocs_new = nr_relocs_old + 1;
+	unsigned long nr_alloc;
+	struct symbol *sym;
+
+	if (!rsec->data) {
+		rsec->data = elf_newdata(elf_getscn(elf->elf, rsec->idx));
+		if (!rsec->data) {
+			ERROR_ELF("elf_newdata");
+			return -1;
+		}
+
+		rsec->data->d_align = 1;
+		rsec->data->d_type = ELF_T_RELA;
+		rsec->data->d_buf = NULL;
+	}
+
+	rsec->data->d_size = nr_relocs_new * elf_rela_size(elf);
+	rsec->sh.sh_size   = rsec->data->d_size;
+
+	nr_alloc = MAX(64, ALIGN_UP_POW2(nr_relocs_new));
+	if (nr_alloc <= rsec->nr_alloc_relocs)
+		return 0;
+	rsec->nr_alloc_relocs = nr_alloc;
+
+	rsec->data->d_buf = realloc(rsec->data->d_buf,
+				    nr_alloc * elf_rela_size(elf));
+	if (!rsec->data->d_buf) {
+		ERROR_GLIBC("realloc");
+		return -1;
+	}
+
+	old_relocs = rsec->relocs;
+	new_relocs = calloc(nr_alloc, sizeof(struct reloc));
+	if (!new_relocs) {
+		ERROR_GLIBC("calloc");
+		return -1;
+	}
+
+	if (!old_relocs)
+		goto done;
+
+	/*
+	 * The struct reloc's address has changed.  Update all the symbols and
+	 * relocs which reference it.
+	 */
+
+	old_relocs_end = &old_relocs[nr_relocs_old];
+	for_each_sym(elf, sym) {
+		struct reloc *reloc;
+
+		reloc = sym->relocs;
+		if (!reloc)
+			continue;
+
+		if (reloc >= old_relocs && reloc < old_relocs_end)
+			sym->relocs = &new_relocs[reloc - old_relocs];
+
+		while (1) {
+			struct reloc *next_reloc = sym_next_reloc(reloc);
+
+			if (!next_reloc)
+				break;
+
+			if (next_reloc >= old_relocs && next_reloc < old_relocs_end)
+				set_sym_next_reloc(reloc, &new_relocs[next_reloc - old_relocs]);
+
+			reloc = next_reloc;
+		}
+	}
+
+	memcpy(new_relocs, old_relocs, nr_relocs_old * sizeof(struct reloc));
+
+	for (int i = 0; i < nr_relocs_old; i++) {
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
+	return 0;
+}
+
 struct section *elf_create_rela_section(struct elf *elf, struct section *sec,
-					unsigned int reloc_nr)
+					unsigned int nr_relocs)
 {
 	struct section *rsec;
 	char *rsec_name;
@@ -1269,34 +1363,61 @@ struct section *elf_create_rela_section(struct elf *elf, struct section *sec,
 	strcpy(rsec_name, ".rela");
 	strcat(rsec_name, sec->name);
 
-	rsec = elf_create_section(elf, rsec_name, reloc_nr * elf_rela_size(elf),
+	rsec = elf_create_section(elf, rsec_name, nr_relocs * elf_rela_size(elf),
 				  elf_rela_size(elf), SHT_RELA, elf_addr_size(elf),
 				  SHF_INFO_LINK);
 	free(rsec_name);
 	if (!rsec)
 		return NULL;
 
-	rsec->sh.sh_link = find_section_by_name(elf, ".symtab")->idx;
-	rsec->sh.sh_info = sec->idx;
-
-	if (reloc_nr) {
+	if (nr_relocs) {
 		rsec->data->d_type = ELF_T_RELA;
-		rsec->relocs = calloc(sec_num_entries(rsec), sizeof(struct reloc));
+
+		rsec->nr_alloc_relocs = nr_relocs;
+		rsec->relocs = calloc(nr_relocs, sizeof(struct reloc));
 		if (!rsec->relocs) {
 			ERROR_GLIBC("calloc");
 			return NULL;
 		}
 	}
 
+	rsec->sh.sh_link = find_section_by_name(elf, ".symtab")->idx;
+	rsec->sh.sh_info = sec->idx;
+
 	sec->rsec = rsec;
 	rsec->base = sec;
 
 	return rsec;
 }
 
+struct reloc *elf_create_reloc(struct elf *elf, struct section *sec,
+			       unsigned long offset,
+			       struct symbol *sym, s64 addend,
+			       unsigned int type)
+{
+	struct section *rsec = sec->rsec;
+
+	if (!rsec) {
+		rsec = elf_create_rela_section(elf, sec, 0);
+		if (!rsec)
+			return NULL;
+	}
+
+	if (find_reloc_by_dest(elf, sec, offset)) {
+		ERROR_FUNC(sec, offset, "duplicate reloc");
+		return NULL;
+	}
+
+	if (elf_alloc_reloc(elf, rsec))
+		return NULL;
+
+	return elf_init_reloc(elf, rsec, sec_num_entries(rsec) - 1, offset, sym,
+			      addend, type);
+}
+
 struct section *elf_create_section_pair(struct elf *elf, const char *name,
 					size_t entsize, unsigned int nr,
-					unsigned int reloc_nr)
+					unsigned int nr_relocs)
 {
 	struct section *sec;
 
@@ -1305,7 +1426,7 @@ struct section *elf_create_section_pair(struct elf *elf, const char *name,
 	if (!sec)
 		return NULL;
 
-	if (!elf_create_rela_section(elf, sec, reloc_nr))
+	if (!elf_create_rela_section(elf, sec, nr_relocs))
 		return NULL;
 
 	return sec;
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index fc00f86bedba..5c663e475890 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -47,6 +47,7 @@ struct section {
 	int idx;
 	bool _changed, text, rodata, noinstr, init, truncate;
 	struct reloc *relocs;
+	unsigned long nr_alloc_relocs;
 };
 
 struct symbol {
@@ -139,6 +140,14 @@ void *elf_add_data(struct elf *elf, struct section *sec, const void *data,
 
 unsigned int elf_add_string(struct elf *elf, struct section *strtab, const char *str);
 
+struct reloc *elf_create_reloc(struct elf *elf, struct section *sec,
+			       unsigned long offset, struct symbol *sym,
+			       s64 addend, unsigned int type);
+
+struct reloc *elf_init_reloc(struct elf *elf, struct section *rsec,
+			     unsigned int reloc_idx, unsigned long offset,
+			     struct symbol *sym, s64 addend, unsigned int type);
+
 struct reloc *elf_init_reloc_text_sym(struct elf *elf, struct section *sec,
 				      unsigned long offset,
 				      unsigned int reloc_idx,
-- 
2.49.0


