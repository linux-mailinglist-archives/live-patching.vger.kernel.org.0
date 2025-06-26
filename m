Return-Path: <live-patching+bounces-1583-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A8D55AEAB6B
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:05:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 709091899B2F
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19891290DB2;
	Thu, 26 Jun 2025 23:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BUznRFpj"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2465290D83;
	Thu, 26 Jun 2025 23:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982209; cv=none; b=V2M6iHS+MZv9eH1Knd0tpiD9hKesyKxRhD/pmgAu2vBlhAfT7/4JU0LTzzDyoJLz7aJ8ENlIqL/iTfKicxzNjNFfuJkBiOhW9ZivEQF6q8YH7iJn0lSW6/CHo5SxjCBrovLhxbh4C+rtrj7Oa6rrHSV1CInPTl0UJEC1pmwwBi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982209; c=relaxed/simple;
	bh=P7Lmx069P9t+Q6SOpAKxHr+0/2SiR5xXTd+e7kEt5dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nL7AjfSg8dexsOw8uo37OtY9F0df7He1CemKh4XyXS2xmF7XvS9dFsAAjOAUsLO50qWzY5kXey0u924dwz9RwXeoAk7gHyEGKFQGhM0w1vcrfTG2/KNUSCyX4AhwNkiY4hcLeKkA+Dp8NwCPI8BKWjEHtnIZt/q+0r690dijbxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BUznRFpj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433B7C4CEF4;
	Thu, 26 Jun 2025 23:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982208;
	bh=P7Lmx069P9t+Q6SOpAKxHr+0/2SiR5xXTd+e7kEt5dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUznRFpj71vYtEYkDCpLU4MJ7k5gjN/AsP/RgXKhiokshqWH7IBNpluBlYyDIE0tL
	 q5HbkXt0sghvTusMGt0TbvWC8HzWMXSrJ8PN+KqZjPwoNtqUjlu52WSPzP/YDevQl0
	 xG/ehG9O0jILlhsImdEveDTkxe8Cav6UAA6Z3LvjspD3C/aTQNUvieXLemv1aHuuu3
	 zL7weTiK0JKkCwu7lWHnyVgvUQd6QUo+YrnvllIQi+uUlEVYlpc79W2Psa0ElixPAw
	 zXnBxS6YxD9b6VyAfH/ngm0RniB+mj1e473Ybf4P2paezGzyy7xci/29Fl5/5umHEm
	 XXDt84rmzuEqg==
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
Subject: [PATCH v3 53/64] objtool/klp: Add --debug option to show cloning decisions
Date: Thu, 26 Jun 2025 16:55:40 -0700
Message-ID: <cdc42fe6c27a0a8e9c5ab01cea61fd2556eeb3a8.1750980517.git.jpoimboe@kernel.org>
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

Add a --debug option to klp diff which prints cloning decisions and an
indented dependency tree for all cloned symbols and relocations.  This
helps visualize which symbols and relocations were included and why.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/include/objtool/warn.h | 21 ++++++++
 tools/objtool/klp-diff.c             | 75 ++++++++++++++++++++++++++++
 tools/objtool/objtool.c              |  3 ++
 3 files changed, 99 insertions(+)

diff --git a/tools/objtool/include/objtool/warn.h b/tools/objtool/include/objtool/warn.h
index 29173a1368d7..e88322d97573 100644
--- a/tools/objtool/include/objtool/warn.h
+++ b/tools/objtool/include/objtool/warn.h
@@ -102,6 +102,10 @@ static inline char *offstr(struct section *sec, unsigned long offset)
 #define ERROR_FUNC(sec, offset, format, ...) __WARN_FUNC(ERROR_STR, sec, offset, format, ##__VA_ARGS__)
 #define ERROR_INSN(insn, format, ...) WARN_FUNC(insn->sec, insn->offset, format, ##__VA_ARGS__)
 
+extern bool debug;
+extern int indent;
+
+static inline void unindent(int *unused) { indent--; }
 
 #define __dbg(format, ...)						\
 	fprintf(stderr,							\
@@ -110,6 +114,23 @@ static inline char *offstr(struct section *sec, unsigned long offset)
 		objname ? ": " : "",					\
 		##__VA_ARGS__)
 
+#define dbg(args...)							\
+({									\
+	if (unlikely(debug))						\
+		__dbg(args);						\
+})
+
+#define __dbg_indent(format, ...)					\
+({									\
+	if (unlikely(debug))						\
+		__dbg("%*s" format, indent * 8, "", ##__VA_ARGS__);	\
+})
+
+#define dbg_indent(args...)						\
+	int __attribute__((cleanup(unindent))) __dummy_##__COUNTER__;	\
+	__dbg_indent(args);						\
+	indent++
+
 #define dbg_checksum(func, insn, checksum)				\
 ({									\
 	if (unlikely(insn->sym && insn->sym->pfunc &&			\
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 85c6a480ecdb..c9320ce39578 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -37,6 +37,8 @@ static const char * const klp_diff_usage[] = {
 };
 
 static const struct option klp_diff_options[] = {
+	OPT_GROUP("Options:"),
+	OPT_BOOLEAN('d', "debug", &debug, "enable debug output"),
 	OPT_END(),
 };
 
@@ -47,6 +49,38 @@ static inline u32 str_hash(const char *str)
 	return jhash(str, strlen(str), 0);
 }
 
+static char *escape_str(const char *orig)
+{
+	size_t len = 0;
+	const char *a;
+	char *b, *new;
+
+	for (a = orig; *a; a++) {
+		switch (*a) {
+		case '\001': len += 5; break;
+		case '\n':
+		case '\t':   len += 2; break;
+		default: len++;
+		}
+	}
+
+	new = malloc(len + 1);
+	if (!new)
+		return NULL;
+
+	for (a = orig, b = new; *a; a++) {
+		switch (*a) {
+		case '\001': memcpy(b, "<SOH>", 5); b += 5; break;
+		case '\n': *b++ = '\\'; *b++ = 'n'; break;
+		case '\t': *b++ = '\\'; *b++ = 't'; break;
+		default:   *b++ = *a;
+		}
+	}
+
+	*b = '\0';
+	return new;
+}
+
 static int read_exports(void)
 {
 	const char *symvers = "Module.symvers";
@@ -527,6 +561,28 @@ static struct symbol *__clone_symbol(struct elf *elf, struct symbol *patched_sym
 	return out_sym;
 }
 
+static const char *sym_type(struct symbol *sym)
+{
+	switch (sym->type) {
+	case STT_NOTYPE:  return "NOTYPE";
+	case STT_OBJECT:  return "OBJECT";
+	case STT_FUNC:    return "FUNC";
+	case STT_SECTION: return "SECTION";
+	case STT_FILE:    return "FILE";
+	default:	  return "UNKNOWN";
+	}
+}
+
+static const char *sym_bind(struct symbol *sym)
+{
+	switch (sym->bind) {
+	case STB_LOCAL:   return "LOCAL";
+	case STB_GLOBAL:  return "GLOBAL";
+	case STB_WEAK:    return "WEAK";
+	default:	  return "UNKNOWN";
+	}
+}
+
 /*
  * Copy a symbol to the output object, optionally including its data and
  * relocations.
@@ -539,6 +595,8 @@ static struct symbol *clone_symbol(struct elfs *e, struct symbol *patched_sym,
 	if (patched_sym->clone)
 		return patched_sym->clone;
 
+	dbg_indent("%s%s", patched_sym->name, data_too ? " [+DATA]" : "");
+
 	/* Make sure the prefix gets cloned first */
 	if (is_func_sym(patched_sym) && data_too) {
 		pfx = get_func_prefix(patched_sym);
@@ -901,6 +959,8 @@ static int clone_reloc_klp(struct elfs *e, struct reloc *patched_reloc,
 
 	klp_sym = find_symbol_by_name(e->out, sym_name);
 	if (!klp_sym) {
+		__dbg_indent("%s", sym_name);
+
 		/* STB_WEAK: avoid modpost undefined symbol warnings */
 		klp_sym = elf_create_symbol(e->out, sym_name, NULL,
 					    STB_WEAK, patched_sym->type, 0, 0);
@@ -949,6 +1009,17 @@ static int clone_reloc_klp(struct elfs *e, struct reloc *patched_reloc,
 	return 0;
 }
 
+#define dbg_clone_reloc(sec, offset, patched_sym, addend, export, klp)			\
+	dbg_indent("%s+0x%lx: %s%s0x%lx [%s%s%s%s%s%s]",				\
+		   sec->name, offset, patched_sym->name,				\
+		   addend >= 0 ? "+" : "-", labs(addend),				\
+		   sym_type(patched_sym),						\
+		   patched_sym->type == STT_SECTION ? "" : " ",				\
+		   patched_sym->type == STT_SECTION ? "" : sym_bind(patched_sym),	\
+		   is_undef_sym(patched_sym) ? " UNDEF" : "",				\
+		   export ? " EXPORTED" : "",						\
+		   klp ? " KLP" : "")
+
 /* Copy a reloc and its symbol to the output object */
 static int clone_reloc(struct elfs *e, struct reloc *patched_reloc,
 			struct section *sec, unsigned long offset)
@@ -968,6 +1039,8 @@ static int clone_reloc(struct elfs *e, struct reloc *patched_reloc,
 
 	klp = klp_reloc_needed(patched_reloc);
 
+	dbg_clone_reloc(sec, offset, patched_sym, addend, export, klp);
+
 	if (klp) {
 		if (clone_reloc_klp(e, patched_reloc, sec, offset, export))
 			return -1;
@@ -999,6 +1072,8 @@ static int clone_reloc(struct elfs *e, struct reloc *patched_reloc,
 	if (is_string_sec(patched_sym->sec)) {
 		const char *str = patched_sym->sec->data->d_buf + addend;
 
+		__dbg_indent("\"%s\"", escape_str(str));
+
 		addend = elf_add_string(e->out, out_sym->sec, str);
 		if (addend == -1)
 			return -1;
diff --git a/tools/objtool/objtool.c b/tools/objtool/objtool.c
index c8f611c1320d..3c26ed561c7e 100644
--- a/tools/objtool/objtool.c
+++ b/tools/objtool/objtool.c
@@ -16,6 +16,9 @@
 #include <objtool/objtool.h>
 #include <objtool/warn.h>
 
+bool debug;
+int indent;
+
 static struct objtool_file file;
 
 struct objtool_file *objtool_open_read(const char *filename)
-- 
2.49.0


