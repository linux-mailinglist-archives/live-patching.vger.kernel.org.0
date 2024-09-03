Return-Path: <live-patching+bounces-553-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 834BB96928F
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:03:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BAF9283951
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80B6A1D54EB;
	Tue,  3 Sep 2024 04:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fVYa7cBD"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559451D54DB;
	Tue,  3 Sep 2024 04:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336039; cv=none; b=u0F7mtUVl2wyiRR0E1Y8c33rI9C6WSpmPN9Y79vLuLsR9QGN3/vFRdKIZfMJA3/Gp7URWWwKHDJN+yu5GHSWKJn1QDP5sgMDw0SEJcG2PRbge4PLyg6IAuPPhZS4/LtxpHqG6hVjHq+MjyKwCHpabroumTmJOCFN/EVZovo3T3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336039; c=relaxed/simple;
	bh=XEuuJCImEqHAJnZPhF5hOjypD7T7+zQrodOehIwpmB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FW3Ut3zNEaFM8Z1WYEB+OiRHc/oQeW4uBmc1w2YUA3Qmww4wLL2YZd7hM7zV/B7nstdX8CRnzvIl580kkTaGHuLRDN+KCv7uHvHypkVNP/TJiZkifhdUi6dpQUZUXtH1ryn3qqKXC0A0lOE/hef3aYX09B9DKiplNi7iGcw2wuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fVYa7cBD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EBAC4CECE;
	Tue,  3 Sep 2024 04:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336038;
	bh=XEuuJCImEqHAJnZPhF5hOjypD7T7+zQrodOehIwpmB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVYa7cBD/1ZimqvEz8IK6nx5SuH7FXyZfy2um+a0+TXvWg8OcStxPA+rsUJ9bOZhy
	 E2RjopDBowpMIXJfsO56r94AWSZ6fEg+hVwxN0R5OyESVpTKdTaVmzIjntkZwC/kmd
	 47quGtYfouqIERUS6xVFDsd72rBTyT/rXnjbPu54Nlm0cQlVwB65WCmIzzUgLlsrgL
	 8KHBcmLSwLfLsL/ognmwpBRf3ZXwopbFbOMT78TeQPHC9xtQ3f2JPep1MeCCPl924h
	 trX/BqzLfxEcyhHEc7J/FW0IEowDJCMD/o+uFucYPBWNokx4is7YzrlmXot9azXmGI
	 /xA4WhL1HcdOw==
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
Subject: [RFC 19/31] objtool: Add elf_create_file()
Date: Mon,  2 Sep 2024 21:00:02 -0700
Message-ID: <327dc97a71aea6e9e5fa51960e0da62188da27f9.1725334260.git.jpoimboe@kernel.org>
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

Add interface to enable the creation of a new ELF file.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c                 | 118 ++++++++++++++++++++++++++++
 tools/objtool/include/objtool/elf.h |   3 +-
 2 files changed, 120 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 748c170b931a..7f89b0a99886 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -16,6 +16,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <errno.h>
+#include <libgen.h>
 #include <linux/interval_tree_generic.h>
 #include <objtool/builtin.h>
 #include <objtool/elf.h>
@@ -926,6 +927,9 @@ struct elf *elf_open_read(const char *name, int flags)
 	elf->fd = open(name, flags);
 	ERROR_ON(elf->fd == -1, "can't open '%s': %s", name, strerror(errno));
 
+	elf->name = strdup(name);
+	ERROR_ON(!elf->name, "strdup");
+
 	if ((flags & O_ACCMODE) == O_RDONLY)
 		cmd = ELF_C_READ_MMAP;
 	else if ((flags & O_ACCMODE) == O_RDWR)
@@ -949,6 +953,108 @@ struct elf *elf_open_read(const char *name, int flags)
 	return elf;
 }
 
+struct elf *elf_create_file(GElf_Ehdr *ehdr, const char *name)
+{
+	struct section *null, *symtab, *strtab, *shstrtab;
+	char *dir, *base, *tmp_name;
+	struct symbol *sym;
+	struct elf *elf;
+
+	elf_version(EV_CURRENT);
+
+	elf = calloc(1, sizeof(*elf));
+	ERROR_ON(!elf, "calloc");
+
+	INIT_LIST_HEAD(&elf->sections);
+
+	dir = strdup(name);
+	ERROR_ON(!dir, "strdup");
+	dir = dirname(dir);
+
+	base = strdup(name);
+	ERROR_ON(!base, "strdup");
+	base = basename(base);
+
+	tmp_name = malloc(256);
+	ERROR_ON(!tmp_name, "malloc");
+
+	snprintf(tmp_name, 256, "%s/%s.XXXXXX", dir, base);
+
+	elf->fd = mkstemp(tmp_name);
+	if (elf->fd == -1) {
+		fprintf(stderr, "objtool: Can't open '%s': %s\n",
+			elf->tmp_name, strerror(errno));
+		exit(1);
+	}
+
+	elf->tmp_name = tmp_name;
+
+	elf->name = strdup(name);
+	ERROR_ON(!elf->name, "strdup");
+
+	elf->elf = elf_begin(elf->fd, ELF_C_WRITE, NULL);
+	if (!elf->elf)
+		ERROR_ELF("elf_begin");
+
+	if (!gelf_newehdr(elf->elf, ELFCLASS64))
+		ERROR_ELF("gelf_newehdr");
+
+	memcpy(&elf->ehdr, ehdr, sizeof(elf->ehdr));
+
+	if (!gelf_update_ehdr(elf->elf, &elf->ehdr))
+		ERROR_ELF("gelf_update_ehdr");
+
+	INIT_LIST_HEAD(&elf->symbols);
+
+	elf_alloc_hash(section, 1000);
+	elf_alloc_hash(section_name, 1000);
+
+	elf_alloc_hash(symbol, 10000);
+	elf_alloc_hash(symbol_name, 10000);
+
+	elf_alloc_hash(reloc, 100000);
+
+	/*
+	 * NULL section: add it to the section list without actually adding it
+	 * to elf as we use it for some things (such as?)
+	 */
+	null		= elf_create_section(elf, NULL, 0, 0, SHT_NULL, 0, 0);
+	null->name	= "";
+
+	shstrtab	= elf_create_section(elf, NULL, 0, 0, SHT_STRTAB, 1, 0);
+	shstrtab->name	= ".shstrtab";
+
+	strtab		= elf_create_section(elf, NULL, 0, 0, SHT_STRTAB, 1, 0);
+	strtab->name	= ".strtab";
+
+	null->sh.sh_name	= elf_add_string(elf, shstrtab, null->name);
+	shstrtab->sh.sh_name	= elf_add_string(elf, shstrtab, shstrtab->name);
+	strtab->sh.sh_name	= elf_add_string(elf, shstrtab, strtab->name);
+
+	elf_hash_add(section_name, &null->name_hash,		str_hash(null->name));
+	elf_hash_add(section_name, &strtab->name_hash,		str_hash(strtab->name));
+	elf_hash_add(section_name, &shstrtab->name_hash,	str_hash(shstrtab->name));
+
+	elf_add_string(elf, strtab, "");
+
+	symtab = elf_create_section(elf, ".symtab", 0x18, 0x18, SHT_SYMTAB, 0x8, 0);
+	symtab->sh.sh_link = strtab->idx;
+	symtab->sh.sh_info = 1;
+
+	elf->ehdr.e_shstrndx = shstrtab->idx;
+	if (!gelf_update_ehdr(elf->elf, &elf->ehdr))
+		ERROR_ELF("gelf_update_ehdr");
+
+	sym = calloc(1, sizeof(*sym));
+	ERROR_ON(!sym, "calloc");
+
+	sym->name = "";
+	sym->sec = null;
+	elf_add_symbol(elf, sym);
+
+	return elf;
+}
+
 unsigned long elf_add_string(struct elf *elf, struct section *strtab, const char *str)
 {
 	unsigned long offset;
@@ -1281,6 +1387,18 @@ void elf_write(struct elf *elf)
 		ERROR_ELF("elf_update");
 
 	elf->changed = false;
+
+	if (elf->tmp_name) {
+		int ret;
+
+		unlink(elf->name);
+
+		ret = linkat(AT_FDCWD, elf->tmp_name, AT_FDCWD, elf->name, 0);
+		ERROR_ON(ret, "linkat");
+
+		close(elf->fd);
+		unlink(elf->tmp_name);
+	}
 }
 
 void elf_close(struct elf *elf)
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 5ac5e7cdddee..f759686d46d7 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -87,7 +87,7 @@ struct elf {
 	GElf_Ehdr ehdr;
 	int fd;
 	bool changed;
-	const char *name;
+	const char *name, *tmp_name;
 	unsigned int num_files;
 	struct list_head sections;
 	unsigned long num_relocs;
@@ -109,6 +109,7 @@ struct elf {
 };
 
 struct elf *elf_open_read(const char *name, int flags);
+struct elf *elf_create_file(GElf_Ehdr *ehdr, const char *name);
 
 struct section *elf_create_section(struct elf *elf, const char *name,
 				   size_t size, size_t entsize,
-- 
2.45.2


