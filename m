Return-Path: <live-patching+bounces-1399-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57BA2AB1E14
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:25:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 669A5A01496
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:24:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 713D32989B7;
	Fri,  9 May 2025 20:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eDMKCPXc"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E6F2989AF;
	Fri,  9 May 2025 20:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821893; cv=none; b=MZofZYmTuF92THmJKNaPWOMZSlEF3iI6BmF2Wsj/OYetre1W6dqKsBOOkKP78b1K5q+v7sQ2B6ibXvgjWh3LzMcfVc2YBLB7Ao98qW/Wm3rXzwmcADmR7Ohht2zYZLJBStmo93AzmLttyO28Uod54R9yL1c2eAy1FKi8mF7tsiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821893; c=relaxed/simple;
	bh=g3favnQ2TasT07axjoxQsRRs95xIcj3hy0hj5Qm7MVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCd2fJKNOH4suGTPVTYP7CZBjZof/lNzYC0DsxnDGNV1pd2pGOCGC2d6Dd+5w8VcxTcq+B00wgGYw0qBcfRKPNvxkXUk4/gYg4irKgyL3VtR8yFlA/VNT3bq2SK3xN0os4jQRsKoto78wxpSY1IZtZ5bwWXNDPJRvgnHGMW0XP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eDMKCPXc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6A3C4CEE4;
	Fri,  9 May 2025 20:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821893;
	bh=g3favnQ2TasT07axjoxQsRRs95xIcj3hy0hj5Qm7MVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eDMKCPXcHmKQq6TFumRtM7si9IejQD31KydsxGJqnYYJ7dR6zkcBAJE5GSP5owKAZ
	 jB2IULLblNQyheueODNyO6Psux44q1+bYDQnH2k6VD8vk/pps5Phx4DdnD/+J8isr6
	 DutD3ozAjD2KTtr0312Axzu5MXUwgJhc0OP1Ltr/3oTQfMarC6rFUnvFi+Cgykn2H2
	 frtBQCnoNFwZX3INp+bTtL2TBLRchO4xcMz4CLZXFqs0AiZxSCT3Ln44VmkOL5goNy
	 1kPdhYd+JO4soKtpMkLOReZYgJ7+8bFQpm1HLNnMAW4MJ57zEWEESIYOe2fnjdfiyH
	 cFUby31vXkvKw==
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
	Puranjay Mohan <puranjay@kernel.org>
Subject: [PATCH v2 40/62] objtool: Introduce elf_create_reloc() and elf_init_reloc()
Date: Fri,  9 May 2025 13:17:04 -0700
Message-ID: <8c045c6e3048507898e9229ddd1aa7eb9ecbd0f6.1746821544.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746821544.git.jpoimboe@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
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
index 1b5528065df7..8fc6e6c75b88 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -22,6 +22,8 @@
 #include <objtool/warn.h>
 
 #define ALIGN_UP(x, align_to) (((x) + ((align_to)-1)) & ~((align_to)-1))
+#define ALIGN_UP_POW2(x) (1U << ((8 * sizeof(x)) - __builtin_clz((x) - 1U)))
+#define MAX(a, b) ((a) > (b) ? (a) : (b))
 
 static inline u32 str_hash(const char *str)
 {
@@ -897,10 +899,9 @@ elf_create_prefix_symbol(struct elf *elf, struct symbol *orig, size_t size)
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
 
@@ -1002,12 +1003,14 @@ static int read_relocs(struct elf *elf)
 
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
 
@@ -1256,8 +1259,99 @@ struct section *elf_create_section(struct elf *elf, const char *name,
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
@@ -1270,34 +1364,61 @@ struct section *elf_create_rela_section(struct elf *elf, struct section *sec,
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
 
@@ -1306,7 +1427,7 @@ struct section *elf_create_section_pair(struct elf *elf, const char *name,
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


