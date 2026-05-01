Return-Path: <live-patching+bounces-2627-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qKxTOX0n9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2627-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:09:33 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E77E4AA0DD
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:09:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 384CD30498DC
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB425310651;
	Fri,  1 May 2026 04:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UTBP2cOo"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8773230FC21;
	Fri,  1 May 2026 04:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608534; cv=none; b=qoOb/unQQoST3HRqngKKbPDq95DCyDbyzwkJr0XwCSW74lKP8TzRUZZObxZqC4vaW8Bm3tNZ85CEOjHulF19dGz/CH6YI9inXjzND53tnMU53bPCvygdSY4qkcRh/vGvbEK5fpX74PY2VApUOh/AnyFIO/iBDS9RbDuJNB322Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608534; c=relaxed/simple;
	bh=b5BNPd+bg7GvS5BnsS8maFnsD2ISFL3v5zG+hbXUHwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTdH83vunT/FEfMqslZv0ujId2tDuDO02SaKoOSqGVarN0sQNDVC+GOa4x6nzNMB89ZZWlZv77I4xNdv9+hLWupSbex4qNwUHCYzykgf8vTPqRmOlbsXYwTptXLWwh+dUBFrldS8LiVsFwCe9VQrKgoUfKMhc2QG1VxbDSgkmzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UTBP2cOo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22505C2BCC7;
	Fri,  1 May 2026 04:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608534;
	bh=b5BNPd+bg7GvS5BnsS8maFnsD2ISFL3v5zG+hbXUHwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTBP2cOoLzjVoyofU8VG7UTLzKhH2cfjA9kzbwvdWCS2187vTOqBFKTOMfdzoOh/D
	 F7vYvz27Lu3c0YE0j8DLyP/1BFmsJndujJ2f2aC4eJtXPL0Ee8iMWlKVTRsefQ204t
	 TtvhtS6FoLhgaxgqWgrQCIb4nNRsyRoxwDGy5bRDIhrv8S/l9/+DiJw7Bsix7o5vYj
	 bMFnQT/Um3qkyeFteL2anebEUSaxc5LbzY6xY+IL9cPMzDRozrm6kMCJ28xil7iFiK
	 2ZqR8Ctck6q9uuBWyuSyvec93FFdtWjM1bQcfzy+s4cp9g81EOVw4OqA2MByx4fope
	 QyjqxV6kb7BAw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 09/53] objtool: Replace iterator callback with for_each_sym_by_mangled_name()
Date: Thu, 30 Apr 2026 21:07:57 -0700
Message-ID: <cb95eae9cc63ca04f881c69c93eed6bac0c751fe.1777575752.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5E77E4AA0DD
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2627-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]

Convert the callback-based iterate_sym_by_demangled_name() with a new
for_each_sym_by_demangled_name() macro.  This eliminates the callback
struct/function and makes the code more compact and readable.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c                 | 68 ++++++++---------------------
 tools/objtool/include/objtool/elf.h | 32 ++++++++++++--
 tools/objtool/klp-diff.c            | 42 ++++++------------
 3 files changed, 60 insertions(+), 82 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index f3df2bde119f..dc39132f71c1 100644
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
@@ -322,19 +301,6 @@ struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *nam
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
 struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *sec,
 				     unsigned long offset, unsigned int len)
 {
@@ -347,7 +313,7 @@ struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *se
 		return NULL;
 
 	for_offset_range(o, offset, offset + len) {
-		elf_hash_for_each_possible(reloc, reloc, hash,
+		elf_hash_for_each_possible(elf, reloc, reloc, hash,
 					   sec_offset_hash(rsec, o)) {
 			if (reloc->sec != rsec)
 				continue;
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 25573e5af76e..b142984eb9b5 100644
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
@@ -130,6 +137,23 @@ struct elf {
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
 
@@ -186,9 +210,6 @@ struct symbol *find_func_by_offset(struct section *sec, unsigned long offset);
 struct symbol *find_symbol_by_offset(struct section *sec, unsigned long offset);
 struct symbol *find_symbol_by_name(const struct elf *elf, const char *name);
 struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *name);
-void iterate_global_symbol_by_demangled_name(const struct elf *elf, const char *demangled_name,
-					     void (*process)(struct symbol *sym, void *data),
-					     void *data);
 struct symbol *find_symbol_containing(const struct section *sec, unsigned long offset);
 int find_symbol_hole_containing(const struct section *sec, unsigned long offset);
 struct reloc *find_reloc_by_dest(const struct elf *elf, struct section *sec, unsigned long offset);
@@ -468,6 +489,11 @@ static inline void set_sym_next_reloc(struct reloc *reloc, struct reloc *next)
 #define for_each_sym_continue(elf, sym)					\
 	list_for_each_entry_continue(sym, &elf->symbols, global_list)
 
+#define for_each_sym_by_demangled_name(elf, name, sym)			\
+	elf_hash_for_each_possible(elf, symbol_name, sym, name_hash,	\
+				   str_hash(name))			\
+		if (strcmp(sym->demangled_name, name)) {} else
+
 #define rsec_next_reloc(rsec, reloc)					\
 	reloc_idx(reloc) < sec_num_entries(rsec) - 1 ? reloc + 1 : NULL
 
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 0653bf6a33bd..30ce234e01a1 100644
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
@@ -396,22 +391,6 @@ static bool dont_correlate(struct symbol *sym)
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
@@ -423,16 +402,23 @@ static void process_demangled_name(struct symbol *sym, void *d)
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


