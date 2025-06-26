Return-Path: <live-patching+bounces-1571-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EAF1AEAB59
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:04:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB7F63A534B
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D6FF27FB26;
	Thu, 26 Jun 2025 23:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XwtktkA7"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555D227A108;
	Thu, 26 Jun 2025 23:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982200; cv=none; b=iRFGLqXH2h5aOQJSd0pko7OKLZX7vuvnbzxByc8SQ40gaoj/Rtv+E5XbxFg4br5IJtQuTitLKSublp8eyefcruRqJV4PbMP8ELWIwMXIVt67tBOszEgiMpiv1DNJVcRuwCyvXMF3tdTts32RDiMZE3KH136SRSuYb7+Erb3bO4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982200; c=relaxed/simple;
	bh=daLeRIb64mJwGXJxduTyEBKlfEDuaQKm6VsobyffD3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4QLzHHJxtITqyr8kHyY5u5GMbnwlwZX/yUji1mtkhv0TR+mHfABa072V1XxzqbyEYZnz+yil1Y6VMk/mFGFW2eyd7FJOF+M8trd+b3ndKDcjMzRgP+t1IGXzMXhkrpI0jjWiWFvumNOXY6T1wpbgE/vOjFs5u5PByCXfVBMuOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XwtktkA7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F77C4CEEF;
	Thu, 26 Jun 2025 23:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982200;
	bh=daLeRIb64mJwGXJxduTyEBKlfEDuaQKm6VsobyffD3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XwtktkA7dU6HHcLw1HpgkOtThBgTdZ5+d5WkSZQLwtFiLtfmyAgRWvCbGjottG70S
	 IHvcFDKHCNu8mVg9Yju0TZXY3rT98x/m5psvnHaizJWlbmjXHfoT47Ms0tBWe8gnRb
	 mkTpEFMnAxq6gjaKl1wDMfN1Fg8vhgU4sINzLZCxRmf3IDifAz/zbuQ8Mw8TLtS706
	 4w3UlbPHElS2jr4Zpp2qdPYz5tJ5aTBWihl11hp3QMrYpk74gUlzDHP4kN2PjQwy6z
	 IZmwfCDSNE72lMw9YfptigXlgCcN3wqstb7cHBvQ6PcucxvkNtAyHVY3XkKYocOjpn
	 8pgrSWZzXiTJQ==
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
Subject: [PATCH v3 41/64] objtool: Add elf_create_file()
Date: Thu, 26 Jun 2025 16:55:28 -0700
Message-ID: <c0b43a4f23ab4c7fdf9a398e91ce5fd9952a6c54.1750980517.git.jpoimboe@kernel.org>
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

Add interface to enable the creation of a new ELF file.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/builtin-check.c       |   2 +-
 tools/objtool/elf.c                 | 144 +++++++++++++++++++++++++++-
 tools/objtool/include/objtool/elf.h |   5 +-
 3 files changed, 147 insertions(+), 4 deletions(-)

diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 86b1a05c9353..3172f7e98147 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -327,5 +327,5 @@ int objtool_run(int argc, const char **argv)
 	if (!opts.dryrun && file->elf->changed && elf_write(file->elf))
 		return 1;
 
-	return 0;
+	return elf_close(file->elf);
 }
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 0e98cf2ab533..b88190fe7131 100644
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
@@ -1062,6 +1063,12 @@ struct elf *elf_open_read(const char *name, int flags)
 		goto err;
 	}
 
+	elf->name = strdup(name);
+	if (!elf->name) {
+		ERROR_GLIBC("strdup");
+		return NULL;
+	}
+
 	if ((flags & O_ACCMODE) == O_RDONLY)
 		cmd = ELF_C_READ_MMAP;
 	else if ((flags & O_ACCMODE) == O_RDWR)
@@ -1099,6 +1106,137 @@ struct elf *elf_open_read(const char *name, int flags)
 	return NULL;
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
+	if (!elf) {
+		ERROR_GLIBC("calloc");
+		return NULL;
+	}
+
+	INIT_LIST_HEAD(&elf->sections);
+
+	dir = strdup(name);
+	if (!dir) {
+		ERROR_GLIBC("strdup");
+		return NULL;
+	}
+
+	dir = dirname(dir);
+
+	base = strdup(name);
+	if (!base) {
+		ERROR_GLIBC("strdup");
+		return NULL;
+	}
+
+	base = basename(base);
+
+	tmp_name = malloc(256);
+	if (!tmp_name) {
+		ERROR_GLIBC("malloc");
+		return NULL;
+	}
+
+	snprintf(tmp_name, 256, "%s/%s.XXXXXX", dir, base);
+
+	elf->fd = mkstemp(tmp_name);
+	if (elf->fd == -1) {
+		ERROR_GLIBC("can't create tmp file");
+		exit(1);
+	}
+
+	elf->tmp_name = tmp_name;
+
+	elf->name = strdup(name);
+	if (!elf->name) {
+		ERROR_GLIBC("strdup");
+		return NULL;
+	}
+
+	elf->elf = elf_begin(elf->fd, ELF_C_WRITE, NULL);
+	if (!elf->elf) {
+		ERROR_ELF("elf_begin");
+		return NULL;
+	}
+
+	if (!gelf_newehdr(elf->elf, ELFCLASS64)) {
+		ERROR_ELF("gelf_newehdr");
+		return NULL;
+	}
+
+	memcpy(&elf->ehdr, ehdr, sizeof(elf->ehdr));
+
+	if (!gelf_update_ehdr(elf->elf, &elf->ehdr)) {
+		ERROR_ELF("gelf_update_ehdr");
+		return NULL;
+	}
+
+	if (!elf_alloc_hash(section,		1000) ||
+	    !elf_alloc_hash(section_name,	1000) ||
+	    !elf_alloc_hash(symbol,		10000) ||
+	    !elf_alloc_hash(symbol_name,	10000) ||
+	    !elf_alloc_hash(reloc,		100000))
+		return NULL;
+
+	null		= elf_create_section(elf, NULL, 0, 0, SHT_NULL, 0, 0);
+	shstrtab	= elf_create_section(elf, NULL, 0, 0, SHT_STRTAB, 1, 0);
+	strtab		= elf_create_section(elf, NULL, 0, 0, SHT_STRTAB, 1, 0);
+
+	if (!null || !shstrtab || !strtab)
+		return NULL;
+
+	null->name	= "";
+	shstrtab->name	= ".shstrtab";
+	strtab->name	= ".strtab";
+
+	null->sh.sh_name	= elf_add_string(elf, shstrtab, null->name);
+	shstrtab->sh.sh_name	= elf_add_string(elf, shstrtab, shstrtab->name);
+	strtab->sh.sh_name	= elf_add_string(elf, shstrtab, strtab->name);
+
+	if (null->sh.sh_name == -1 || shstrtab->sh.sh_name == -1 || strtab->sh.sh_name == -1)
+		return NULL;
+
+	elf_hash_add(section_name, &null->name_hash,		str_hash(null->name));
+	elf_hash_add(section_name, &strtab->name_hash,		str_hash(strtab->name));
+	elf_hash_add(section_name, &shstrtab->name_hash,	str_hash(shstrtab->name));
+
+	if (elf_add_string(elf, strtab, "") == -1)
+		return NULL;
+
+	symtab = elf_create_section(elf, ".symtab", 0x18, 0x18, SHT_SYMTAB, 0x8, 0);
+	if (!symtab)
+		return NULL;
+
+	symtab->sh.sh_link = strtab->idx;
+	symtab->sh.sh_info = 1;
+
+	elf->ehdr.e_shstrndx = shstrtab->idx;
+	if (!gelf_update_ehdr(elf->elf, &elf->ehdr)) {
+		ERROR_ELF("gelf_update_ehdr");
+		return NULL;
+	}
+
+	sym = calloc(1, sizeof(*sym));
+	if (!sym) {
+		ERROR_GLIBC("calloc");
+		return NULL;
+	}
+
+	sym->name = "";
+	sym->sec = null;
+	elf_add_symbol(elf, sym);
+
+	return elf;
+}
+
 unsigned int elf_add_string(struct elf *elf, struct section *strtab, const char *str)
 {
 	unsigned int offset;
@@ -1544,7 +1682,7 @@ int elf_write(struct elf *elf)
 	return 0;
 }
 
-void elf_close(struct elf *elf)
+int elf_close(struct elf *elf)
 {
 	if (elf->elf)
 		elf_end(elf->elf);
@@ -1552,8 +1690,12 @@ void elf_close(struct elf *elf)
 	if (elf->fd > 0)
 		close(elf->fd);
 
+	if (elf->tmp_name && rename(elf->tmp_name, elf->name))
+		return -1;
+
 	/*
 	 * NOTE: All remaining allocations are leaked on purpose.  Objtool is
 	 * about to exit anyway.
 	 */
+	return 0;
 }
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 5c663e475890..a0fc252e1993 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -93,7 +93,7 @@ struct elf {
 	GElf_Ehdr ehdr;
 	int fd;
 	bool changed;
-	const char *name;
+	const char *name, *tmp_name;
 	unsigned int num_files;
 	struct list_head sections;
 	unsigned long num_relocs;
@@ -115,6 +115,7 @@ struct elf {
 };
 
 struct elf *elf_open_read(const char *name, int flags);
+struct elf *elf_create_file(GElf_Ehdr *ehdr, const char *name);
 
 struct section *elf_create_section(struct elf *elf, const char *name,
 				   size_t size, size_t entsize,
@@ -164,7 +165,7 @@ int elf_write_insn(struct elf *elf, struct section *sec, unsigned long offset,
 		   unsigned int len, const char *insn);
 
 int elf_write(struct elf *elf);
-void elf_close(struct elf *elf);
+int elf_close(struct elf *elf);
 
 struct section *find_section_by_name(const struct elf *elf, const char *name);
 struct symbol *find_func_by_offset(struct section *sec, unsigned long offset);
-- 
2.49.0


