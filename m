Return-Path: <live-patching+bounces-1567-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FB79AEAB4B
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:03:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF8781883E35
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3048274669;
	Thu, 26 Jun 2025 23:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="maD1xZCx"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBF0231826;
	Thu, 26 Jun 2025 23:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982197; cv=none; b=ezfHoDjeLZrMarn3bnDzsl79HplBHQj0naK2srDBbb1Vk26Y4tmNdx24UPaoOs2UngXFpiOVjvMRMqjyWwp5LkpPvPE5TgYXCjaNstqaFPHSZ+sU3zKZ4VEXbWUTp2pWDGJC9RL/kmDXwQ0gj2BnXW7YvTgmyE/nDh0GmeLt0Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982197; c=relaxed/simple;
	bh=rV++lTEUCxJNpGpjQ29tLRexF/YRf03FlfJGjPVnCTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXwHo3Z0981X8g+egvuVNtOzCwn6yfl0NXRjdV1WMSX7sB7cCAowxrdI0tcKjSqjdL4tcKHxqHHq7oL2UpEiWwR+TBlIoSw29yjJRvYths2b6xQ2MT1N5l1CqenYbVFdyuVWHCgdHMQtMLSxDfuGebylhn7TmA5aizNkGFmOoAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=maD1xZCx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75C6C4CEEF;
	Thu, 26 Jun 2025 23:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982197;
	bh=rV++lTEUCxJNpGpjQ29tLRexF/YRf03FlfJGjPVnCTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=maD1xZCx8WLLYd+AbYrClCUB8gM2VFKjUQn94jBjco6SgL2VRjZTUtuTjtOB6KTDI
	 2Gxg2pMTlaymQhBlADXPMnVRy/EHxbYmUldq9XvFTp+3mgzL7d6R78iFGG/lfEnToP
	 wZ/KBlW3iHtsX8JiZI2fz2d9mBzSyd3x7j4uRZEmqqqZ2fHz7CVk1gysIK7Y0lzup+
	 9V3/k8DiXY/be5mrYomvgENDC7mOaxzxIhPmgk9WAezM5kyWIDzWVWIKdsBiTBWLB1
	 FQ0dUJ0JdAPekTTT2ejfbSg8y68idDRzqYdNgIlcUFL86V3YImm/qPPvv+pkMcqbSg
	 ATNDpRDRD4I8A==
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
Subject: [PATCH v3 37/64] objtool: Generalize elf_create_symbol()
Date: Thu, 26 Jun 2025 16:55:24 -0700
Message-ID: <00b7e0dd3f8ffe4061f6e4ba0e16d3948edabf47.1750980517.git.jpoimboe@kernel.org>
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
elf_create_symbol() interface to give callers more control and reduce
duplication of some subtle setup logic.

While at it, make elf_create_symbol() and elf_create_section_symbol()
public so sections can be created by the upcoming klp diff code.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c                 | 111 +++++++++++++++-------------
 tools/objtool/include/objtool/elf.h |  11 ++-
 2 files changed, 69 insertions(+), 53 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 4e274197bcd6..127e39b05a86 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -760,24 +760,60 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
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
@@ -815,10 +851,8 @@ __elf_create_symbol(struct elf *elf, struct symbol *sym)
 
 non_local:
 	sym->idx = new_idx;
-	if (elf_update_symbol(elf, symtab, symtab_shndx, sym)) {
-		ERROR("elf_update_symbol");
+	if (sym->idx && elf_update_symbol(elf, symtab, symtab_shndx, sym))
 		return NULL;
-	}
 
 	symtab->sh.sh_size += symtab->sh.sh_entsize;
 	mark_sec_changed(elf, symtab, true);
@@ -828,64 +862,39 @@ __elf_create_symbol(struct elf *elf, struct symbol *sym)
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
@@ -931,7 +940,7 @@ struct reloc *elf_init_reloc_text_sym(struct elf *elf, struct section *sec,
 				      unsigned long insn_off)
 {
 	struct symbol *sym = insn_sec->sym;
-	int addend = insn_off;
+	s64 addend = insn_off;
 
 	if (!is_text_sec(insn_sec)) {
 		ERROR("bad call to %s() for data symbol %s", __func__, sym->name);
@@ -948,8 +957,6 @@ struct reloc *elf_init_reloc_text_sym(struct elf *elf, struct section *sec,
 		sym = elf_create_section_symbol(elf, insn_sec);
 		if (!sym)
 			return NULL;
-
-		insn_sec->sym = sym;
 	}
 
 	return elf_init_reloc(elf, sec->rsec, reloc_idx, offset, sym, addend,
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 74c7b84b5310..ffdf9ec3882e 100644
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
@@ -119,7 +121,14 @@ struct section *elf_create_section_pair(struct elf *elf, const char *name,
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
2.49.0


