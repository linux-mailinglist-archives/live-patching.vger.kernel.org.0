Return-Path: <live-patching+bounces-2466-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +FaZCCGd6Wm3ewIAu9opvQ
	(envelope-from <live-patching+bounces-2466-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:16:33 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CC4F44CD96
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:16:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B1E42306DA01
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62C2B3DCD9B;
	Thu, 23 Apr 2026 04:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dsSoejWm"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381913DCD81;
	Thu, 23 Apr 2026 04:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917084; cv=none; b=jLehWfi/dOu8BylVuBPoe4VYRVsqCvUFSJwui0SPSsFkrs/AOhbnU+B2K+1ttL3ZZvH3wLDt7PYVwcqAeMimxO36iuVXoxHUHncrBE7IPw1zEhMt1aLxIJQpuZY5cRYv6LTXbknQrs8fKKbvtC+Hv88FAvNtqXkuYhJaxHKD+EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917084; c=relaxed/simple;
	bh=2w8CeG6pOvd1rlnM0WqP9uenooE/GJd9V/fFSVkUS7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MS1uolsFztXhFrqc8lTX9HUy3hCnO/noWTUMwO9W5j1Ame4zY2ORs+H8OJXkW/rfNZrMb3ZNaOq2/6ag9ffyEdRepV3m9lzyYqK4fvCfmGgR0mzPtMAntIy3IIfxh/C0CAjuw+YlDgdq1rCR28b/CAC5zl5LKm7N09k2LYtbzk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dsSoejWm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE38C2BCB2;
	Thu, 23 Apr 2026 04:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917084;
	bh=2w8CeG6pOvd1rlnM0WqP9uenooE/GJd9V/fFSVkUS7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsSoejWmlSmCA//um+LUJ88uf9VRQfFOq38cZX3PdaA6PVbi6Wy4kZ8g+fa2xAIHS
	 bNV9uRlcQgYg/CDRdw5KWUXGZGpoIh/wx9fvvsAFFfTKS8xYK3VZ0//x+uqcM3phsh
	 U07HWUzeF/z6HawjOuI+fkng42a4WBNkxq+5yniBdHfl4KB9qBDn61RJL3/7fvdtNY
	 Zn/dWrdyJTPdldNCyV8J1vQ9r4/fObQP/xrOQKleKTt+Bru3OxHXb9mQ0XIKhm1HLW
	 e9DpjdFY/xyEGOygu8Jp/rqtLIbRw87FDWnBLnurQcb1CiA5SCfN4Iv/3EHMfbAfZD
	 Pfw6O4i3sSvuw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 39/48] objtool: Replace iterator callbacks with for_each_sym_by_*()
Date: Wed, 22 Apr 2026 21:04:07 -0700
Message-ID: <03f7804ae62c5c4521053afc3f6a1c4a11bc85de.1776916871.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2466-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1CC4F44CD96
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Convert the callback-based iterate_sym_by_name() and
iterate_sym_by_demangled_name() callers to use new
for_each_sym_by[_demangled]_name() macros.  This eliminates the callback
structs and functions and makes the code more compact and readable.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c                 | 80 ++++++-----------------------
 tools/objtool/include/objtool/elf.h | 40 ++++++++++++---
 tools/objtool/klp-checksum.c        | 20 +++-----
 tools/objtool/klp-diff.c            | 42 +++++----------
 4 files changed, 73 insertions(+), 109 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 8a6e1338af97..8d823e96b7c9 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -27,27 +27,16 @@
 
 static ssize_t demangled_name_len(const char *name);
 
-static inline u32 str_hash(const char *str)
-{
-	return jhash(str, strlen(str), 0);
-}
-
-static inline u32 str_hash_demangled(const char *str)
+u32 str_hash_demangled(const char *str)
 {
 	return jhash(str, demangled_name_len(str), 0);
 }
 
-#define __elf_table(name)	(elf->name##_hash)
-#define __elf_bits(name)	(elf->name##_bits)
-
-#define __elf_table_entry(name, key) \
-	__elf_table(name)[hash_min(key, __elf_bits(name))]
-
 #define elf_hash_add(name, node, key)					\
 ({									\
 	struct elf_hash_node *__node = node;				\
-	__node->next = __elf_table_entry(name, key);			\
-	__elf_table_entry(name, key) = __node;				\
+	__node->next = __elf_table_entry(elf, name, key);		\
+	__elf_table_entry(elf, name, key) = __node;			\
 })
 
 static inline void __elf_hash_del(struct elf_hash_node *node,
@@ -69,30 +58,20 @@ static inline void __elf_hash_del(struct elf_hash_node *node,
 }
 
 #define elf_hash_del(name, node, key) \
-	__elf_hash_del(node, &__elf_table_entry(name, key))
-
-#define elf_list_entry(ptr, type, member)				\
-({									\
-	typeof(ptr) __ptr = (ptr);					\
-	__ptr ? container_of(__ptr, type, member) : NULL;		\
-})
-
-#define elf_hash_for_each_possible(name, obj, member, key)		\
-	for (obj = elf_list_entry(__elf_table_entry(name, key), typeof(*obj), member); \
-	     obj;							\
-	     obj = elf_list_entry(obj->member.next, typeof(*(obj)), member))
+	__elf_hash_del(node, &__elf_table_entry(elf, name, key))
 
 #define elf_alloc_hash(name, size)					\
 ({									\
-	__elf_bits(name) = max(10, ilog2(size));			\
-	__elf_table(name) = mmap(NULL, sizeof(struct elf_hash_node *) << __elf_bits(name), \
+	__elf_bits(elf, name) = max(10, ilog2(size));			\
+	__elf_table(elf, name) = mmap(NULL,				\
+				 sizeof(struct elf_hash_node *) << __elf_bits(elf, name), \
 				 PROT_READ|PROT_WRITE,			\
 				 MAP_PRIVATE|MAP_ANON, -1, 0);		\
-	if (__elf_table(name) == (void *)-1L) {				\
+	if (__elf_table(elf, name) == (void *)-1L) {			\
 		ERROR_GLIBC("mmap fail " #name);			\
-		__elf_table(name) = NULL;				\
+		__elf_table(elf, name) = NULL;				\
 	}								\
-	__elf_table(name);						\
+	__elf_table(elf, name);						\
 })
 
 static inline unsigned long __sym_start(struct symbol *s)
@@ -141,7 +120,7 @@ struct section *find_section_by_name(const struct elf *elf, const char *name)
 {
 	struct section *sec;
 
-	elf_hash_for_each_possible(section_name, sec, name_hash, str_hash(name)) {
+	elf_hash_for_each_possible(elf, section_name, sec, name_hash, str_hash(name)) {
 		if (!strcmp(sec->name, name))
 			return sec;
 	}
@@ -154,7 +133,7 @@ static struct section *find_section_by_index(struct elf *elf,
 {
 	struct section *sec;
 
-	elf_hash_for_each_possible(section, sec, hash, idx) {
+	elf_hash_for_each_possible(elf, section, sec, hash, idx) {
 		if (sec->idx == idx)
 			return sec;
 	}
@@ -166,7 +145,7 @@ static struct symbol *find_symbol_by_index(struct elf *elf, unsigned int idx)
 {
 	struct symbol *sym;
 
-	elf_hash_for_each_possible(symbol, sym, hash, idx) {
+	elf_hash_for_each_possible(elf, symbol, sym, hash, idx) {
 		if (sym->idx == idx)
 			return sym;
 	}
@@ -285,7 +264,7 @@ struct symbol *find_symbol_by_name(const struct elf *elf, const char *name)
 {
 	struct symbol *sym;
 
-	elf_hash_for_each_possible(symbol_name, sym, name_hash, str_hash(name)) {
+	elf_hash_for_each_possible(elf, symbol_name, sym, name_hash, str_hash(name)) {
 		if (!strcmp(sym->name, name))
 			return sym;
 	}
@@ -300,7 +279,7 @@ static struct symbol *find_local_symbol_by_file_and_name(const struct elf *elf,
 {
 	struct symbol *sym;
 
-	elf_hash_for_each_possible(symbol_name, sym, name_hash, str_hash_demangled(name)) {
+	elf_hash_for_each_possible(elf, symbol_name, sym, name_hash, str_hash_demangled(name)) {
 		if (sym->bind == STB_LOCAL && sym->file == file &&
 		    !strcmp(sym->name, name)) {
 			return sym;
@@ -314,7 +293,7 @@ struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *nam
 {
 	struct symbol *sym;
 
-	elf_hash_for_each_possible(symbol_name, sym, name_hash, str_hash_demangled(name)) {
+	elf_hash_for_each_possible(elf, symbol_name, sym, name_hash, str_hash_demangled(name)) {
 		if (!strcmp(sym->name, name) && !is_local_sym(sym))
 			return sym;
 	}
@@ -322,31 +301,6 @@ struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *nam
 	return NULL;
 }
 
-void iterate_global_symbol_by_demangled_name(const struct elf *elf,
-					     const char *demangled_name,
-					     void (*process)(struct symbol *sym, void *data),
-					     void *data)
-{
-	struct symbol *sym;
-
-	elf_hash_for_each_possible(symbol_name, sym, name_hash, str_hash(demangled_name)) {
-		if (!strcmp(sym->demangled_name, demangled_name) && !is_local_sym(sym))
-			process(sym, data);
-	}
-}
-
-void iterate_sym_by_name(const struct elf *elf, const char *name,
-			 void (*process)(struct symbol *sym, void *data),
-			 void *data)
-{
-	struct symbol *sym;
-
-	elf_hash_for_each_possible(symbol_name, sym, name_hash, str_hash_demangled(name)) {
-		if (!strcmp(sym->name, name))
-			process(sym, data);
-	}
-}
-
 struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *sec,
 				     unsigned long offset, unsigned int len)
 {
@@ -359,7 +313,7 @@ struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *se
 		return NULL;
 
 	for_offset_range(o, offset, offset + len) {
-		elf_hash_for_each_possible(reloc, reloc, hash,
+		elf_hash_for_each_possible(elf, reloc, reloc, hash,
 					   sec_offset_hash(rsec, o)) {
 			if (reloc->sec != rsec)
 				continue;
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 82b9fb05af26..ba13dd67cf26 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -21,6 +21,13 @@
 #define SEC_NAME_LEN		1024
 #define SYM_NAME_LEN		512
 
+static inline u32 str_hash(const char *str)
+{
+	return jhash(str, strlen(str), 0);
+}
+
+u32 str_hash_demangled(const char *str);
+
 #define bswap_if_needed(elf, val) __bswap_if_needed(&elf->ehdr, val)
 
 #ifdef LIBELF_USE_DEPRECATED
@@ -129,6 +136,23 @@ struct elf {
 	struct symbol *symbol_data;
 };
 
+#define __elf_table(elf, name)	((elf)->name##_hash)
+#define __elf_bits(elf, name)	((elf)->name##_bits)
+
+#define __elf_table_entry(elf, name, key) \
+	__elf_table(elf, name)[hash_min(key, __elf_bits(elf, name))]
+
+#define elf_list_entry(ptr, type, member)				\
+({									\
+	typeof(ptr) __ptr = (ptr);					\
+	__ptr ? container_of(__ptr, type, member) : NULL;		\
+})
+
+#define elf_hash_for_each_possible(elf, name, obj, member, key)		\
+	for (obj = elf_list_entry(__elf_table_entry(elf, name, key), typeof(*obj), member); \
+	     obj;							\
+	     obj = elf_list_entry(obj->member.next, typeof(*(obj)), member))
+
 struct elf *elf_open_read(const char *name, int flags);
 struct elf *elf_create_file(GElf_Ehdr *ehdr, const char *name);
 
@@ -185,12 +209,6 @@ struct symbol *find_func_by_offset(struct section *sec, unsigned long offset);
 struct symbol *find_symbol_by_offset(struct section *sec, unsigned long offset);
 struct symbol *find_symbol_by_name(const struct elf *elf, const char *name);
 struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *name);
-void iterate_global_symbol_by_demangled_name(const struct elf *elf, const char *demangled_name,
-					     void (*process)(struct symbol *sym, void *data),
-					     void *data);
-void iterate_sym_by_name(const struct elf *elf, const char *name,
-			 void (*process)(struct symbol *sym, void *data),
-			 void *data);
 struct symbol *find_symbol_containing(const struct section *sec, unsigned long offset);
 int find_symbol_hole_containing(const struct section *sec, unsigned long offset);
 struct reloc *find_reloc_by_dest(const struct elf *elf, struct section *sec, unsigned long offset);
@@ -485,6 +503,16 @@ static inline void set_sym_next_reloc(struct reloc *reloc, struct reloc *next)
 #define for_each_sym_continue(elf, sym)					\
 	list_for_each_entry_continue(sym, &elf->symbols, global_list)
 
+#define for_each_sym_by_name(elf, _name, sym)				\
+	elf_hash_for_each_possible(elf, symbol_name, sym, name_hash,	\
+				   str_hash_demangled(_name))		\
+		if (!strcmp(sym->name, _name))
+
+#define for_each_sym_by_demangled_name(elf, name, sym)			\
+	elf_hash_for_each_possible(elf, symbol_name, sym, name_hash,	\
+				   str_hash(name))			\
+		if (!strcmp(sym->demangled_name, name))
+
 #define rsec_next_reloc(rsec, reloc)					\
 	reloc_idx(reloc) < sec_num_entries(rsec) - 1 ? reloc + 1 : NULL
 
diff --git a/tools/objtool/klp-checksum.c b/tools/objtool/klp-checksum.c
index 4edd29028bff..e4a910f3211c 100644
--- a/tools/objtool/klp-checksum.c
+++ b/tools/objtool/klp-checksum.c
@@ -11,17 +11,6 @@
 #include <objtool/warn.h>
 #include <objtool/checksum.h>
 
-static void enable_debug_checksum_cb(struct symbol *sym, void *d)
-{
-	bool *found = d;
-
-	if (!is_func_sym(sym))
-		return;
-
-	sym->debug_checksum = 1;
-	*found = true;
-}
-
 static int checksum_debug_init(struct objtool_file *file)
 {
 	char *dup, *s;
@@ -38,13 +27,20 @@ static int checksum_debug_init(struct objtool_file *file)
 	s = dup;
 	while (*s) {
 		bool found = false;
+		struct symbol *sym;
 		char *comma;
 
 		comma = strchr(s, ',');
 		if (comma)
 			*comma = '\0';
 
-		iterate_sym_by_name(file->elf, s, enable_debug_checksum_cb, &found);
+		for_each_sym_by_name(file->elf, s, sym) {
+			if (!is_func_sym(sym))
+				continue;
+			sym->debug_checksum = 1;
+			found = true;
+		}
+
 		if (!found)
 			WARN("--debug-checksum: can't find '%s'", s);
 
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index c903aa65d4b6..33e401b85001 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -46,11 +46,6 @@ static const struct option klp_diff_options[] = {
 
 static DEFINE_HASHTABLE(exports, 15);
 
-static inline u32 str_hash(const char *str)
-{
-	return jhash(str, strlen(str), 0);
-}
-
 static char *escape_str(const char *orig)
 {
 	size_t len = 0;
@@ -398,22 +393,6 @@ static bool dont_correlate(struct symbol *sym)
 	       is_special_section_aux(sym->sec);
 }
 
-struct process_demangled_name_data {
-	struct symbol *ret;
-	int count;
-};
-
-static void process_demangled_name(struct symbol *sym, void *d)
-{
-	struct process_demangled_name_data *data = d;
-
-	if (sym->twin)
-		return;
-
-	data->count++;
-	data->ret = sym;
-}
-
 /*
  * When there is no full name match, try match demangled_name. This would
  * match original foo.llvm.123 to patched foo.llvm.456.
@@ -425,16 +404,23 @@ static void process_demangled_name(struct symbol *sym, void *d)
 static int find_global_symbol_by_demangled_name(struct elf *elf, struct symbol *sym,
 						struct symbol **out_sym)
 {
-	struct process_demangled_name_data data = {};
+	struct symbol *sym2, *result = NULL;
+	int count = 0;
 
-	iterate_global_symbol_by_demangled_name(elf, sym->demangled_name,
-						process_demangled_name,
-						&data);
-	if (data.count > 1) {
-		ERROR("Multiple (%d) correlation candidates for %s", data.count, sym->name);
+	for_each_sym_by_demangled_name(elf, sym->demangled_name, sym2) {
+		if (is_local_sym(sym2) || sym2->twin)
+			continue;
+
+		count++;
+		result = sym2;
+	}
+
+	if (count > 1) {
+		ERROR("Multiple (%d) correlation candidates for %s", count, sym->name);
 		return -1;
 	}
-	*out_sym = data.ret;
+
+	*out_sym = result;
 	return 0;
 }
 
-- 
2.53.0


