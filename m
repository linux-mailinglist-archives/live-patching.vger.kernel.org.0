Return-Path: <live-patching+bounces-1709-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E2ACB80E4E
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:14:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17CB81C279E9
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:14:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29A8E393DE2;
	Wed, 17 Sep 2025 16:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bc7yvrDX"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005CF2F9C29;
	Wed, 17 Sep 2025 16:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125095; cv=none; b=YfaxUBRqJ6F7+hrA6LpQD1SppFUf+3Zoaqtd9Jn+pOxTPvy3gVnghzxipLz4KZwi7EgHle1HxWKMSX9ef7oqnYlWka5dIRnNvoXMjWRhD72h/LrSbi9dare4la3JdXvXn8KbiH9RF6VPmH5NsiaoUBQdSIovFZiEvJidXKKHzEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125095; c=relaxed/simple;
	bh=CxqXkRxmaX2Gn7Pj+gtedTApnCvzeM3SuqqxEafnHcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXTl/KOBpxqSMZmt3mS6NxDucQ+UqdN0ZgY72H+BK6jd3NAznN0z9hPBxTefwp5S6y/pZi1+VL3KY0nq1k87HVQ6h9xNuqR0LzBOTMfWUXEnlL9ChxhzOrYP3S4VuGCmlG+o0s62hNyMVaGhYhSnDrzJPZTgngw+G1A0EJffijk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bc7yvrDX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2890EC4CEFC;
	Wed, 17 Sep 2025 16:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125094;
	bh=CxqXkRxmaX2Gn7Pj+gtedTApnCvzeM3SuqqxEafnHcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bc7yvrDXGyyisMLxnkHT+FN3vEAWK6CdjjCa+e9l9eHqQqVXnPkjFzq9d0mI3p9X7
	 vTaHdUmAQPpSTG/RBk6VismyrE3R0CHE6c3n4dVwMiXKg/m0rt1EjTrGLv2vBOwZ1u
	 cLss5FjTj+tk/X45QNsUc+w2XUlxaUzcNO6L91CacmQx0jIAA7LXC+HYq/eGZXaZjR
	 XdOrmPqwfNowc75z7TA+7FrE2ezF14ZAwWqrMVqRjIz9O+PqpmQ2JPKZ16mh4tSJUY
	 8dpqaOOQ1cD2ziCbxXM+kOn3bIr8DbfUos1VUaZb9AYCOGfpyi0DxQnMqvcLMRwWyb
	 CWtE485lNxeBw==
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
Subject: [PATCH v4 54/63] objtool: Refactor prefix symbol creation code
Date: Wed, 17 Sep 2025 09:04:02 -0700
Message-ID: <86761fd1402f1187d23c655edee766cd2c96c5e7.1758067943.git.jpoimboe@kernel.org>
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

The prefix symbol creation code currently ignores all errors, presumably
because some functions don't have the leading NOPs.

Shuffle the code around a bit, improve the error handling and document
why some errors are ignored.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c               | 59 ++++++++++++++++++++++-------
 tools/objtool/elf.c                 | 17 ---------
 tools/objtool/include/objtool/elf.h |  2 -
 3 files changed, 46 insertions(+), 32 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 6eaae3c007486..6a9ce090a2cde 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -15,6 +15,7 @@
 #include <objtool/special.h>
 #include <objtool/warn.h>
 #include <objtool/checksum.h>
+#include <objtool/util.h>
 
 #include <linux/objtool_types.h>
 #include <linux/hashtable.h>
@@ -4243,37 +4244,71 @@ static bool ignore_unreachable_insn(struct objtool_file *file, struct instructio
 	return false;
 }
 
-static int add_prefix_symbol(struct objtool_file *file, struct symbol *func)
+/*
+ * For FineIBT or kCFI, a certain number of bytes preceding the function may be
+ * NOPs.  Those NOPs may be rewritten at runtime and executed, so give them a
+ * proper function name: __pfx_<func>.
+ *
+ * The NOPs may not exist for the following cases:
+ *
+ *   - compiler cloned functions (*.cold, *.part0, etc)
+ *   - asm functions created with inline asm or without SYM_FUNC_START()
+ *
+ * So return 0 if the NOPs are missing or the function already has a prefix
+ * symbol.
+ */
+static int create_prefix_symbol(struct objtool_file *file, struct symbol *func)
 {
 	struct instruction *insn, *prev;
+	char name[SYM_NAME_LEN];
 	struct cfi_state *cfi;
 
-	insn = find_insn(file, func->sec, func->offset);
-	if (!insn)
+	if (!is_func_sym(func) || is_prefix_func(func) ||
+	    func->cold || func->static_call_tramp)
+		return 0;
+
+	if ((strlen(func->name) + sizeof("__pfx_") > SYM_NAME_LEN)) {
+		WARN("%s: symbol name too long, can't create __pfx_ symbol",
+		      func->name);
+		return 0;
+	}
+
+	if (snprintf_check(name, SYM_NAME_LEN, "__pfx_%s", func->name))
 		return -1;
 
+	insn = find_insn(file, func->sec, func->offset);
+	if (!insn) {
+		WARN("%s: can't find starting instruction", func->name);
+		return -1;
+	}
+
 	for (prev = prev_insn_same_sec(file, insn);
 	     prev;
 	     prev = prev_insn_same_sec(file, prev)) {
 		u64 offset;
 
 		if (prev->type != INSN_NOP)
-			return -1;
+			return 0;
 
 		offset = func->offset - prev->offset;
 
 		if (offset > opts.prefix)
-			return -1;
+			return 0;
 
 		if (offset < opts.prefix)
 			continue;
 
-		elf_create_prefix_symbol(file->elf, func, opts.prefix);
+		if (!elf_create_symbol(file->elf, name, func->sec,
+				       GELF_ST_BIND(func->sym.st_info),
+				       GELF_ST_TYPE(func->sym.st_info),
+				       prev->offset, opts.prefix))
+			return -1;
+
 		break;
 	}
 
 	if (!prev)
-		return -1;
+		return 0;
 
 	if (!insn->cfi) {
 		/*
@@ -4291,7 +4326,7 @@ static int add_prefix_symbol(struct objtool_file *file, struct symbol *func)
 	return 0;
 }
 
-static int add_prefix_symbols(struct objtool_file *file)
+static int create_prefix_symbols(struct objtool_file *file)
 {
 	struct section *sec;
 	struct symbol *func;
@@ -4301,10 +4336,8 @@ static int add_prefix_symbols(struct objtool_file *file)
 			continue;
 
 		sec_for_each_sym(sec, func) {
-			if (!is_func_sym(func))
-				continue;
-
-			add_prefix_symbol(file, func);
+			if (create_prefix_symbol(file, func))
+				return -1;
 		}
 	}
 
@@ -4931,7 +4964,7 @@ int check(struct objtool_file *file)
 	}
 
 	if (opts.prefix) {
-		ret = add_prefix_symbols(file);
+		ret = create_prefix_symbols(file);
 		if (ret)
 			goto out;
 	}
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index e1daae0630be9..4bb7ce994b6a7 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -942,23 +942,6 @@ struct symbol *elf_create_section_symbol(struct elf *elf, struct section *sec)
 	return sym;
 }
 
-struct symbol *
-elf_create_prefix_symbol(struct elf *elf, struct symbol *orig, size_t size)
-{
-	size_t namelen = strlen(orig->name) + sizeof("__pfx_");
-	char name[SYM_NAME_LEN];
-	unsigned long offset;
-
-	snprintf(name, namelen, "__pfx_%s", orig->name);
-
-	offset = orig->sym.st_value - size;
-
-	return elf_create_symbol(elf, name, orig->sec,
-				 GELF_ST_BIND(orig->sym.st_info),
-				 GELF_ST_TYPE(orig->sym.st_info),
-				 offset, size);
-}
-
 struct reloc *elf_init_reloc(struct elf *elf, struct section *rsec,
 			     unsigned int reloc_idx, unsigned long offset,
 			     struct symbol *sym, s64 addend, unsigned int type)
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index e2cd817fca522..60f844e43c5a2 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -148,8 +148,6 @@ struct symbol *elf_create_symbol(struct elf *elf, const char *name,
 				 unsigned int type, unsigned long offset,
 				 size_t size);
 struct symbol *elf_create_section_symbol(struct elf *elf, struct section *sec);
-struct symbol *elf_create_prefix_symbol(struct elf *elf, struct symbol *orig,
-					size_t size);
 
 void *elf_add_data(struct elf *elf, struct section *sec, const void *data,
 		   size_t size);
-- 
2.50.0


