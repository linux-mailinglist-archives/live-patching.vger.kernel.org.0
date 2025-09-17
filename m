Return-Path: <live-patching+bounces-1694-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5804B80E27
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:13:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CE2627B8641
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE0C733BB0E;
	Wed, 17 Sep 2025 16:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NJZTbxBm"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7020933BB04;
	Wed, 17 Sep 2025 16:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125084; cv=none; b=Ln2nv7Xoh9rXGIK0PdR7y+l2TuBoRhZ+U5N70//bg/sQfOe7WWSNY5wWGQrdN0QoiuREDWijbozL8UhCaXblC53ePwKj87kkBUMGBF6Z14/rYuUvoG6wK2+3slNfF8xjfDGWF//UVtrSGBSfzc3Qy3R7SA5zApX9lJnm8ScR06Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125084; c=relaxed/simple;
	bh=trd6++QtGl+7QlxwQZpMPZaXgQnYf1ijFBqtdwlzsYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdawhQAbj3SB3qwQXEiqpHL/QzQCti4glB+ypvxyHhU7csodVoP+h9K3TkmP96NbERBlTlm1sjZTE4fb0MKcCRiKF1Vdhw2lzwh3+UvNdikP5uwkeJY5JVZBvdv+aWlqmbSzGOj0GoesM4L1VcwOZY5bc6q3vXpGjhSMfbMNazM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NJZTbxBm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75803C4CEFB;
	Wed, 17 Sep 2025 16:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125084;
	bh=trd6++QtGl+7QlxwQZpMPZaXgQnYf1ijFBqtdwlzsYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJZTbxBmES8k3OaubQbYtVrzWuY6jp3GQ+EL6xX7RP6o7Rh+4QmIEwiM8fkTBykND
	 LbXbPBx1ugNDsRCxtpaj2JrCFPa73dPJMdTaTXOLSlSYiEXetAKa1eKboi3qMrDUVP
	 C05mIVmnEsLHjtbTr2B/b3WBGFuu5+iUYIWqAgXEkOYE9ek4Xaxhs8s5+PbZAvHRT2
	 ywgDPiXeuDK5rmlSeFUZIZOKlSUJzCM3nYa4wUdOU9gyIk7XyhucEg1fZ/xDvrolr+
	 MNNGEvXROPXMO2FmOqBhaqYmC6ekTb3ddFJxLXbza307cw7zYekp9Vj5ZFEAew4xW/
	 y8+NeAAr2tIwQ==
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
Subject: [PATCH v4 39/63] objtool: Generalize elf_create_symbol()
Date: Wed, 17 Sep 2025 09:03:47 -0700
Message-ID: <104bcacf077a1c8a7d8cdb9167a9e4911555fdbd.1758067943.git.jpoimboe@kernel.org>
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
elf_create_symbol() interface to give callers more control and reduce
duplication of some subtle setup logic.

While at it, make elf_create_symbol() and elf_create_section_symbol()
global so sections can be created by the upcoming klp diff code.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c                 | 111 +++++++++++++++-------------
 tools/objtool/include/objtool/elf.h |  11 ++-
 2 files changed, 69 insertions(+), 53 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index c35726a47c07c..d7703c848ce02 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -763,24 +763,60 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
 	return 0;
 }
 
-static struct symbol *
-__elf_create_symbol(struct elf *elf, struct symbol *sym)
+static int elf_add_string(struct elf *elf, struct section *strtab, const char *str);
+
+struct symbol *elf_create_symbol(struct elf *elf, const char *name,
+				 struct section *sec, unsigned int bind,
+				 unsigned int type, unsigned long offset,
+				 size_t size)
 {
 	struct section *symtab, *symtab_shndx;
 	Elf32_Word first_non_local, new_idx;
-	struct symbol *old;
+	struct symbol *old, *sym;
+
+	sym = calloc(1, sizeof(*sym));
+	if (!sym) {
+		ERROR_GLIBC("calloc");
+		return NULL;
+	}
+
+	sym->name = strdup(name);
+	if (!sym->name) {
+		ERROR_GLIBC("strdup");
+		return NULL;
+	}
+
+	if (type != STT_SECTION) {
+		sym->sym.st_name = elf_add_string(elf, NULL, sym->name);
+		if (sym->sym.st_name == -1)
+			return NULL;
+	}
+
+	if (sec) {
+		sym->sec = sec;
+	} else {
+		sym->sec = find_section_by_index(elf, 0);
+		if (!sym->sec) {
+			ERROR("no NULL section");
+			return NULL;
+		}
+	}
+
+	sym->sym.st_info  = GELF_ST_INFO(bind, type);
+	sym->sym.st_value = offset;
+	sym->sym.st_size  = size;
 
 	symtab = find_section_by_name(elf, ".symtab");
-	if (symtab) {
-		symtab_shndx = find_section_by_name(elf, ".symtab_shndx");
-	} else {
+	if (!symtab) {
 		ERROR("no .symtab");
 		return NULL;
 	}
 
+	symtab_shndx = find_section_by_name(elf, ".symtab_shndx");
+
 	new_idx = sec_num_entries(symtab);
 
-	if (GELF_ST_BIND(sym->sym.st_info) != STB_LOCAL)
+	if (bind != STB_LOCAL)
 		goto non_local;
 
 	/*
@@ -818,10 +854,8 @@ __elf_create_symbol(struct elf *elf, struct symbol *sym)
 
 non_local:
 	sym->idx = new_idx;
-	if (elf_update_symbol(elf, symtab, symtab_shndx, sym)) {
-		ERROR("elf_update_symbol");
+	if (sym->idx && elf_update_symbol(elf, symtab, symtab_shndx, sym))
 		return NULL;
-	}
 
 	symtab->sh.sh_size += symtab->sh.sh_entsize;
 	mark_sec_changed(elf, symtab, true);
@@ -831,64 +865,39 @@ __elf_create_symbol(struct elf *elf, struct symbol *sym)
 		mark_sec_changed(elf, symtab_shndx, true);
 	}
 
+	elf_add_symbol(elf, sym);
+
 	return sym;
 }
 
-static struct symbol *
-elf_create_section_symbol(struct elf *elf, struct section *sec)
+struct symbol *elf_create_section_symbol(struct elf *elf, struct section *sec)
 {
 	struct symbol *sym = calloc(1, sizeof(*sym));
 
-	if (!sym) {
-		ERROR_GLIBC("malloc");
+	sym = elf_create_symbol(elf, sec->name, sec, STB_LOCAL, STT_SECTION, 0, 0);
+	if (!sym)
 		return NULL;
-	}
 
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
-	if (sym)
-		elf_add_symbol(elf, sym);
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
-	if (!sym || !name) {
-		ERROR_GLIBC("malloc");
-		return NULL;
-	}
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
-	if (sym)
-		elf_add_symbol(elf, sym);
-
-	return sym;
+	return elf_create_symbol(elf, name, orig->sec,
+				 GELF_ST_BIND(orig->sym.st_info),
+				 GELF_ST_TYPE(orig->sym.st_info),
+				 offset, size);
 }
 
 static struct reloc *elf_init_reloc(struct elf *elf, struct section *rsec,
@@ -934,7 +943,7 @@ struct reloc *elf_init_reloc_text_sym(struct elf *elf, struct section *sec,
 				      unsigned long insn_off)
 {
 	struct symbol *sym = insn_sec->sym;
-	int addend = insn_off;
+	s64 addend = insn_off;
 
 	if (!is_text_sec(insn_sec)) {
 		ERROR("bad call to %s() for data symbol %s", __func__, sym->name);
@@ -951,8 +960,6 @@ struct reloc *elf_init_reloc_text_sym(struct elf *elf, struct section *sec,
 		sym = elf_create_section_symbol(elf, insn_sec);
 		if (!sym)
 			return NULL;
-
-		insn_sec->sym = sym;
 	}
 
 	return elf_init_reloc(elf, sec->rsec, reloc_idx, offset, sym, addend,
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 07fc41f574b90..c33b8fa0e3cec 100644
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
@@ -120,7 +122,14 @@ struct section *elf_create_section_pair(struct elf *elf, const char *name,
 					size_t entsize, unsigned int nr,
 					unsigned int reloc_nr);
 
-struct symbol *elf_create_prefix_symbol(struct elf *elf, struct symbol *orig, long size);
+struct symbol *elf_create_symbol(struct elf *elf, const char *name,
+				 struct section *sec, unsigned int bind,
+				 unsigned int type, unsigned long offset,
+				 size_t size);
+struct symbol *elf_create_section_symbol(struct elf *elf, struct section *sec);
+struct symbol *elf_create_prefix_symbol(struct elf *elf, struct symbol *orig,
+					size_t size);
+
 
 struct reloc *elf_init_reloc_text_sym(struct elf *elf, struct section *sec,
 				      unsigned long offset,
-- 
2.50.0


