Return-Path: <live-patching+bounces-1396-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 627F7AB1E10
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:24:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A26B3B770A
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30A50298265;
	Fri,  9 May 2025 20:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GKQnQ267"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDAD29825C;
	Fri,  9 May 2025 20:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821891; cv=none; b=sXxkBCazxZyiwukVWo52ms1xBNjS7XF8VmXZ6AtNmMCtrlW2bMJ4UMnZV3+Sy2wv4NxOgnVczFYUfYy42gJ4byY8TwzATUfXxrIGmyuM2Puk5oRsqljUILCuQXt2ZJzaV0IYZ1aG3cvsl4nmYyCtBkvQ07qh2zOfAoBTHnhQNnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821891; c=relaxed/simple;
	bh=7swKUK/3k6EQBq1Fv6U9z1jYwUKygY8A2CCrfaG+2Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TntNwG+EXjD+soIML9bfEbJoUZIwi+CqU/trKEWGBsum6fE/mYC/8AQsh4Sif2QslWfg23MwVKJwrB5FcOefKyH4GK5ZTRggq8+P9A2JQMbb8pJTabgUfkg0L6V5ziS4gYPhTtNpDEsni/b32TlBhDhVGJ8apVwiP1BCZRkc4o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GKQnQ267; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CE8C4CEEF;
	Fri,  9 May 2025 20:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821890;
	bh=7swKUK/3k6EQBq1Fv6U9z1jYwUKygY8A2CCrfaG+2Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GKQnQ267ruruAesKwORHho6uxAxcSXM8yFFdLWo9zsckgONLLkH5J7J7bXrrxPpX3
	 t+3iVQpG81jB7F+sfxAa5NJGUansJsxi4nG0Zmxo7dIFn8g9yh68Y21n+4YBj/SYSm
	 dy9wtn22Ng5Hj4JeOcppvotCQ36YpLRLmQsJrSGsWuJ/6Drt9QuXe9Mlcl4aMu5LOu
	 RxlGgtC63h31ndJyo0snoows7C4VfBWnai/DmLxDgR/fmTjYcp+WpxgGHYZXOwGn5v
	 DrgrLe1KEBpNCpWPoHxrqbdpNvZiDQr+XVuE4eDPZtGIB38K9WatHAgHF9Vg4AZqgX
	 Un+Snc+SFW7AA==
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
Subject: [PATCH v2 37/62] objtool: Generalize elf_create_symbol()
Date: Fri,  9 May 2025 13:17:01 -0700
Message-ID: <c42e73faa0cbc4ea17efff201994305e2d6b3770.1746821544.git.jpoimboe@kernel.org>
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
index 859d677e172c..38bf9ae86c89 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -761,24 +761,60 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
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
@@ -816,10 +852,8 @@ __elf_create_symbol(struct elf *elf, struct symbol *sym)
 
 non_local:
 	sym->idx = new_idx;
-	if (elf_update_symbol(elf, symtab, symtab_shndx, sym)) {
-		ERROR("elf_update_symbol");
+	if (sym->idx && elf_update_symbol(elf, symtab, symtab_shndx, sym))
 		return NULL;
-	}
 
 	symtab->sh.sh_size += symtab->sh.sh_entsize;
 	mark_sec_changed(elf, symtab, true);
@@ -829,64 +863,39 @@ __elf_create_symbol(struct elf *elf, struct symbol *sym)
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
@@ -932,7 +941,7 @@ struct reloc *elf_init_reloc_text_sym(struct elf *elf, struct section *sec,
 				      unsigned long insn_off)
 {
 	struct symbol *sym = insn_sec->sym;
-	int addend = insn_off;
+	s64 addend = insn_off;
 
 	if (!is_text_sec(insn_sec)) {
 		ERROR("bad call to %s() for data symbol %s", __func__, sym->name);
@@ -949,8 +958,6 @@ struct reloc *elf_init_reloc_text_sym(struct elf *elf, struct section *sec,
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


