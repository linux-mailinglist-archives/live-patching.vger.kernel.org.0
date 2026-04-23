Return-Path: <live-patching+bounces-2468-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8EcNGmOc6Wm3ewIAu9opvQ
	(envelope-from <live-patching+bounces-2468-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:13:23 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1177E44CCBE
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:13:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 679D930411E1
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:08:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE7BF3DD537;
	Thu, 23 Apr 2026 04:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="unLZLjaL"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863DF3DD52F;
	Thu, 23 Apr 2026 04:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917085; cv=none; b=KTBGxmbeOyIiFHfctWJqVbqWKM2g3xoZWW0lM+Oh5Vuqrpvx7mpxfcLusD2Ys4vO09so0JoYd1RSKPtVDzJ9M0ndkoiKvhyQPt+fxPO/m4TmU9Scm5E+4ahKgOcL+ema1pJcEUEVwmKZF8WhSdVwuYc4LDJewk9a4fWipa7GLlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917085; c=relaxed/simple;
	bh=v3Bzrs9qCVgv3gQrZ2y2TiXWIceFm8oIUME09GIvrXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=We9t2BRjYsL67bv9VIJ+tZ6k+p3lgoYX8nD2695nj4iRGZOsN5ptvnl3kqn9r/vsrcdfqIZ7jIr28sQh8XWOebMxx2QM/AAv76GBWVTe6a35ml7Q3ig+PKwZfP6yd+VAAJ/drwc7L1wGaVCZKv11f6PkxcZ/R1FV/rPfiDH0PGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=unLZLjaL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CA7C2BCB5;
	Thu, 23 Apr 2026 04:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917085;
	bh=v3Bzrs9qCVgv3gQrZ2y2TiXWIceFm8oIUME09GIvrXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=unLZLjaL1v3E2CnB+I5597Ry3C6UXa5pYmOBDX7fVM08xcg+IbYn5SE29giEGe3Nb
	 DkFjjE8onuKJ9eQzfLuOTFTks+932N4bwqDCyiJWNimzpYfRxbeGhK5JuhurpLF9vT
	 e0bd0P1B5/AdJv3G1dEle8MFHr2gFaVwhf5WUzFvEpGKNK0LFDLDq+nPhOzJfi2Msi
	 KahdAGH4a5FaAhvAaZn3dkE+bC/6SP5jJcTMiAwIS0L5rvpD6oDyxlshYOdemzdS/T
	 Gistc5GThLk28R8sldGfEZ+kYqls/xeBOJKwzdkzKCO0q4QJCX+XrEDuLXuKlnTqpH
	 uTXvoW/46Vn3Q==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 41/48] objtool/klp: Rewrite symbol correlation algorithm
Date: Wed, 22 Apr 2026 21:04:09 -0700
Message-ID: <284944d45120ff69959c4d9cde90db13e493d223.1776916871.git.jpoimboe@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2468-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1177E44CCBE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Rewrite the symbol correlation code, using a tiered list of
deterministic strategies in a loop.  For duplicately named symbols, each
tier applies a filter with the goal of finding a 1:1 deterministic
correlation between the original and patched version of the symbol.

Overall this works much better than the existing algorithm, particularly
with LTO kernels.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 482 ++++++++++++++++++++++++++++-----------
 1 file changed, 346 insertions(+), 136 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 8d64d4c691cb..6d7fbb16e59c 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -393,78 +393,319 @@ static bool dont_correlate(struct symbol *sym)
 	       is_special_section_aux(sym->sec);
 }
 
-/*
- * When there is no full name match, try match demangled_name. This would
- * match original foo.llvm.123 to patched foo.llvm.456.
- *
- * Note that, in very rare cases, it is possible to have multiple
- * foo.llvm.<hash> in the same kernel. When this happens, report error and
- * fail the diff.
- */
-static int find_global_symbol_by_demangled_name(struct elf *elf, struct symbol *sym,
-						struct symbol **out_sym)
+static const char *llvm_suffix(const char *name)
 {
-	struct symbol *sym2, *result = NULL;
-	int count = 0;
+	return strstr(name, ".llvm.");
+}
 
-	for_each_sym_by_demangled_name(elf, sym->demangled_name, sym2) {
-		if (is_local_sym(sym2) || sym2->twin)
+static bool is_llvm_sym(struct symbol *sym)
+{
+	return llvm_suffix(sym->name);
+}
+
+/*
+ * Determine if two symbols have compatible source file origins:
+ *
+ *   - If both symbols are local, only return true if they belong to the same
+ *     ELF file symbol.
+ *
+ *   - If both symbols are global, always return true, as globals don't have
+ *     file associations.
+ *
+ *   - If they have different scopes, also return true, as the patch might have
+ *     changed the symbol's scope.
+ *
+ * Works for both same-ELF (direct pointer compare) and cross-ELF
+ * (compare via file->twin) cases.
+ */
+static bool maybe_same_file(struct symbol *sym1, struct symbol *sym2)
+{
+	if (!sym1->file || !sym2->file)
+		return true;
+	if (sym1->file == sym2->file)
+		return true;
+	return sym1->file->twin == sym2->file;
+}
+
+/*
+ * Similar to maybe_same_file(), but strict: no scope changes allowed.
+ *
+ * Works for both same-ELF (direct pointer compare) and cross-ELF
+ * (compare via file->twin) cases.
+ */
+static bool same_file(struct symbol *sym1, struct symbol *sym2)
+{
+	if (llvm_suffix(sym1->name) && llvm_suffix(sym2->name))
+		return true;
+	if (!sym1->file && !sym2->file)
+		return true;
+	if (!sym1->file || !sym2->file)
+		return false;
+	if (sym1->file == sym2->file)
+		return true;
+	return sym1->file->twin == sym2->file;
+}
+
+/*
+ * Is it a local symbol, or at least was it local in the translation unit
+ * before LLVM promoted it?
+ */
+static bool is_tu_local_sym(struct symbol *sym)
+{
+	return is_local_sym(sym) || is_llvm_sym(sym);
+}
+
+/*
+ * Try to find sym1's twin in patched using deterministic matching.
+ *
+ * Multiple symbols can share a demangled name (e.g., static functions in
+ * different TUs).  This function counts same-named candidates through a
+ * funnel of progressively tighter filters.  Each level is a strict subset
+ * of the previous one.
+ *
+ * The widest level that yields a 1:1 match wins.  Narrower levels are only
+ * needed when the wider level is ambiguous (count > 1).
+ */
+static struct symbol *find_twin(struct elfs *e, struct symbol *sym1)
+{
+	struct symbol *name_last = NULL, *scope_last = NULL,
+		      *file_last = NULL, *csum_last = NULL;
+	unsigned int name_orig = 0, name_patched = 0;
+	unsigned int scope_orig = 0, scope_patched = 0;
+	unsigned int file_orig = 0, file_patched = 0;
+	unsigned int csum_orig = 0, csum_patched = 0;
+	struct symbol *sym2, *match = NULL;
+
+	/* Count orig candidates */
+	for_each_sym_by_demangled_name(e->orig, sym1->demangled_name, sym2) {
+		if (sym2->twin || sym1->type != sym2->type || dont_correlate(sym2) ||
+		    (!maybe_same_file(sym1, sym2)))
 			continue;
 
-		count++;
-		result = sym2;
+		/* Level 1: name match (widest filter)  */
+		name_orig++;
+
+		/* Level 2: scope (scope changes allowed) */
+		if (is_tu_local_sym(sym1) != is_tu_local_sym(sym2))
+			continue;
+		scope_orig++;
+
+		/* Level 3: file (scope changes disallowed) */
+		if (!same_file(sym1, sym2))
+			continue;
+		file_orig++;
+
+		/* Level 4: checksum (unchanged symbols) */
+		if (sym1->len != sym2->len || !sym1->csum.checksum ||
+		    sym1->csum.checksum != sym2->csum.checksum)
+			continue;
+		csum_orig++;
 	}
 
-	if (count > 1) {
-		ERROR("Multiple (%d) correlation candidates for %s", count, sym->name);
-		return -1;
+	/* Count patched candidates */
+	for_each_sym_by_demangled_name(e->patched, sym1->demangled_name, sym2) {
+		if (sym2->twin || sym1->type != sym2->type || dont_correlate(sym2))
+			continue;
+
+		/* Level 1 */
+		if (!maybe_same_file(sym1, sym2))
+			continue;
+		name_patched++;
+		name_last = sym2;
+
+		/* Level 2 */
+		if (is_tu_local_sym(sym1) != is_tu_local_sym(sym2))
+			continue;
+		scope_patched++;
+		scope_last = sym2;
+
+		/* Level 3 */
+		if (!same_file(sym1, sym2))
+			continue;
+		file_patched++;
+		file_last = sym2;
+
+		/* Level 4 */
+		if (sym1->len != sym2->len || !sym1->csum.checksum ||
+		    sym1->csum.checksum != sym2->csum.checksum)
+			continue;
+		csum_patched++;
+		csum_last = sym2;
+	}
+
+	/* Return the widest level that yields a unique (1:1) match */
+	if (name_orig == 1 && name_patched == 1)
+		match = name_last;
+	else if (scope_orig == 1 && scope_patched == 1)
+		match = scope_last;
+	else if (file_orig == 1 && file_patched == 1)
+		match = file_last;
+	else if (csum_orig == 1 && csum_patched == 1)
+		match = csum_last;
+
+	return match;
+}
+
+struct llvm_suffix_pair {
+	struct hlist_node hash;
+	const char *orig;
+	const char *patched;
+};
+
+static DECLARE_HASHTABLE(suffix_map, 7);
+
+/*
+ * Build a mapping of known orig-to-patched LLVM suffixes based on
+ * already-correlated symbol pairs.  All promoted symbols from the same TU
+ * share the same .llvm.<hash> suffix, so one correlated pair seeds the map
+ * for the entire TU.
+ */
+static int update_suffix_map(struct elf *elf)
+{
+	struct llvm_suffix_pair *entry;
+	struct symbol *sym;
+
+	for_each_sym(elf, sym) {
+		const char *s1, *s2;
+		bool found;
+
+		if (!sym->twin)
+			continue;
+
+		s1 = llvm_suffix(sym->name);
+		s2 = llvm_suffix(sym->twin->name);
+
+		if (!s1 || !s2)
+			continue;
+
+		found = false;
+		hash_for_each_possible(suffix_map, entry, hash, str_hash(s1)) {
+			if (!strcmp(entry->orig, s1)) {
+				found = true;
+				break;
+			}
+		}
+		if (found)
+			continue;
+
+		entry = calloc(1, sizeof(*entry));
+		if (!entry) {
+			ERROR_GLIBC("calloc");
+			return -1;
+		}
+
+		entry->orig = s1;
+		entry->patched = s2;
+		hash_add(suffix_map, &entry->hash, str_hash(s1));
 	}
 
-	*out_sym = result;
 	return 0;
 }
 
 /*
- * For each symbol in the original kernel, find its corresponding "twin" in the
- * patched kernel.
+ * Match by translating the symbol's .llvm.<hash> suffix through the suffix
+ * map to find the corresponding hash suffix for the patched object.
+ */
+static struct symbol *find_twin_suffixed(struct elf *elf, struct symbol *sym1)
+{
+	const char *suffix, *patched_suffix = NULL;
+	struct symbol *sym2, *match = NULL;
+	char name[SYM_NAME_LEN];
+	struct llvm_suffix_pair *entry;
+	int count = 0;
+
+	suffix = llvm_suffix(sym1->name);
+	if (!suffix)
+		return NULL;
+
+	hash_for_each_possible(suffix_map, entry, hash, str_hash(suffix)) {
+		if (!strcmp(entry->orig, suffix)) {
+			patched_suffix = entry->patched;
+			break;
+		}
+	}
+	if (!patched_suffix)
+		return NULL;
+
+	if (snprintf_check(name, SYM_NAME_LEN, "%s%s",
+			   sym1->demangled_name, patched_suffix))
+		return NULL;
+
+	for_each_sym_by_name(elf, name, sym2) {
+		if (sym2->twin || sym1->type != sym2->type || dont_correlate(sym2))
+			continue;
+		count++;
+		match = sym2;
+	}
+
+	if (count == 1)
+		return match;
+
+	return NULL;
+}
+
+/*
+ * Last-resort positional matching.
+ *
+ * Finds a symbol with the same position in the symbol table among
+ * same-demangled-name candidates, similar to livepatch sympos.  Note that
+ * LLVM-promoted symbols are globals, which come after locals in the symbol
+ * table, so we have to be careful not to compare different scopes.
+ *
+ * This is a bit less deterministic than the other matching strategies, so it
+ * should be done last.
+ */
+static struct symbol *find_twin_positional(struct elfs *e, struct symbol *sym1)
+{
+	unsigned int idx_orig = 0, idx_patched = 0;
+	unsigned int sym1_pos = 0;
+	struct symbol *sym2, *match = NULL;
+
+	for_each_sym_by_demangled_name(e->orig, sym1->demangled_name, sym2) {
+		if (sym2->twin || sym1->type != sym2->type || dont_correlate(sym2) ||
+		    !maybe_same_file(sym1, sym2))
+			continue;
+		if (is_tu_local_sym(sym1) != is_tu_local_sym(sym2) ||
+		    is_llvm_sym(sym1) != is_llvm_sym(sym2))
+			continue;
+		if (sym1 == sym2)
+			sym1_pos = idx_orig;
+		idx_orig++;
+	}
+
+	for_each_sym_by_demangled_name(e->patched, sym1->demangled_name, sym2) {
+		if (sym2->twin || sym1->type != sym2->type || dont_correlate(sym2) ||
+		    !maybe_same_file(sym1, sym2))
+			continue;
+		if (is_tu_local_sym(sym1) != is_tu_local_sym(sym2) ||
+		    is_llvm_sym(sym1) != is_llvm_sym(sym2))
+			continue;
+		if (idx_patched == sym1_pos)
+			match = sym2;
+		idx_patched++;
+	}
+
+	if (idx_orig != idx_patched)
+		return NULL;
+
+	return match;
+}
+
+/*
+ * Correlate symbols between the orig and patched objects.  This is a
+ * prerequisite for detecting changed functions, as well as for properly
+ * translating relocations so they point to the correct symbol.
  */
 static int correlate_symbols(struct elfs *e)
 {
 	struct symbol *file1_sym, *file2_sym;
 	struct symbol *sym1, *sym2;
+	bool progress;
 
+	/* Correlate FILE symbols */
 	file1_sym = first_file_symbol(e->orig);
 	file2_sym = first_file_symbol(e->patched);
 
-	/*
-	 * Correlate any locals before the first FILE symbol.  This has been
-	 * seen when LTO inexplicably strips the initramfs_data.o FILE symbol
-	 * due to the file only containing data and no code.
-	 */
-	for_each_sym(e->orig, sym1) {
-		if (sym1 == file1_sym || !is_local_sym(sym1))
-			break;
-
-		if (dont_correlate(sym1))
-			continue;
-
-		for_each_sym(e->patched, sym2) {
-			if (sym2 == file2_sym || !is_local_sym(sym2))
-				break;
-
-			if (sym2->twin || dont_correlate(sym2))
-				continue;
-
-			if (strcmp(sym1->demangled_name, sym2->demangled_name))
-				continue;
-
-			sym1->twin = sym2;
-			sym2->twin = sym1;
-			break;
-		}
-	}
-
-	/* Correlate locals after the first FILE symbol */
 	for (; ; file1_sym = next_file_symbol(e->orig, file1_sym),
 		 file2_sym = next_file_symbol(e->patched, file2_sym)) {
 
@@ -488,92 +729,52 @@ static int correlate_symbols(struct elfs *e)
 
 		file1_sym->twin = file2_sym;
 		file2_sym->twin = file1_sym;
-
-		sym1 = file1_sym;
-
-		for_each_sym_continue(e->orig, sym1) {
-			if (is_file_sym(sym1) || !is_local_sym(sym1))
-				break;
-
-			if (dont_correlate(sym1))
-				continue;
-
-			sym2 = file2_sym;
-			for_each_sym_continue(e->patched, sym2) {
-				if (is_file_sym(sym2) || !is_local_sym(sym2))
-					break;
-
-				if (sym2->twin || dont_correlate(sym2))
-					continue;
-
-				if (strcmp(sym1->demangled_name, sym2->demangled_name))
-					continue;
-
-				sym1->twin = sym2;
-				sym2->twin = sym1;
-				break;
-			}
-		}
 	}
 
-	/* Correlate globals */
-	for_each_sym(e->orig, sym1) {
-		if (sym1->bind == STB_LOCAL)
-			continue;
-
-		sym2 = find_global_symbol_by_name(e->patched, sym1->name);
-		if (sym2 && !sym2->twin) {
-			sym1->twin = sym2;
-			sym2->twin = sym1;
-		}
-	}
 
 	/*
-	 * Correlate globals with demangled_name.
-	 * A separate loop is needed because we want to finish all the
-	 * full name correlations first.
+	 * Correlate in two phases: loop deterministic levels until no more
+	 * progress, then use positional fallback for the rest.  This prevents
+	 * the nondeterministic positional matching from stealing symbols that
+	 * have deterministic matches.
 	 */
+	hash_init(suffix_map);
+	do {
+		progress = false;
+		for_each_sym(e->orig, sym1) {
+			if (sym1->twin || dont_correlate(sym1))
+				continue;
+			sym2 = find_twin(e, sym1);
+			if (!sym2)
+				continue;
+			sym1->twin = sym2;
+			sym2->twin = sym1;
+			progress = true;
+		}
+
+		if (update_suffix_map(e->orig))
+			return -1;
+
+		for_each_sym(e->orig, sym1) {
+			if (sym1->twin || dont_correlate(sym1))
+				continue;
+			sym2 = find_twin_suffixed(e->patched, sym1);
+			if (!sym2)
+				continue;
+			sym1->twin = sym2;
+			sym2->twin = sym1;
+			progress = true;
+		}
+	} while (progress);
+
 	for_each_sym(e->orig, sym1) {
-		if (sym1->bind == STB_LOCAL || sym1->twin)
+		if (sym1->twin || dont_correlate(sym1))
 			continue;
-
-		if (find_global_symbol_by_demangled_name(e->patched, sym1, &sym2))
-			return -1;
-
-		if (sym2 && !sym2->twin) {
-			sym1->twin = sym2;
-			sym2->twin = sym1;
-		}
-	}
-
-	/* Correlate original locals with patched globals */
-	for_each_sym(e->orig, sym1) {
-		if (sym1->twin || dont_correlate(sym1) || !is_local_sym(sym1))
+		sym2 = find_twin_positional(e, sym1);
+		if (!sym2)
 			continue;
-
-		sym2 = find_global_symbol_by_name(e->patched, sym1->name);
-		if (!sym2 && find_global_symbol_by_demangled_name(e->patched, sym1, &sym2))
-			return -1;
-
-		if (sym2 && !sym2->twin) {
-			sym1->twin = sym2;
-			sym2->twin = sym1;
-		}
-	}
-
-	/* Correlate original globals with patched locals */
-	for_each_sym(e->patched, sym2) {
-		if (sym2->twin || dont_correlate(sym2) || !is_local_sym(sym2))
-			continue;
-
-		sym1 = find_global_symbol_by_name(e->orig, sym2->name);
-		if (!sym1 && find_global_symbol_by_demangled_name(e->orig, sym2, &sym1))
-			return -1;
-
-		if (sym1 && !sym1->twin) {
-			sym2->twin = sym1;
-			sym1->twin = sym2;
-		}
+		sym1->twin = sym2;
+		sym2->twin = sym1;
 	}
 
 	for_each_sym(e->orig, sym1) {
@@ -785,19 +986,24 @@ static void mark_included_function(struct symbol *func)
  */
 static int mark_changed_functions(struct elfs *e)
 {
-	struct symbol *sym_orig, *patched_sym;
+	struct symbol *orig_sym, *patched_sym;
 	bool changed = false;
 
 	/* Find changed functions */
-	for_each_sym(e->orig, sym_orig) {
-		if (!is_func_sym(sym_orig) || dont_correlate(sym_orig))
+	for_each_sym(e->orig, orig_sym) {
+		if (dont_correlate(orig_sym))
 			continue;
 
-		patched_sym = sym_orig->twin;
+		patched_sym = orig_sym->twin;
 		if (!patched_sym)
 			continue;
 
-		if (sym_orig->csum.checksum != patched_sym->csum.checksum) {
+		if (orig_sym->csum.checksum != patched_sym->csum.checksum) {
+			if (!is_func_sym(orig_sym)) {
+				ERROR("changed data: %s", orig_sym->name);
+				return -1;
+			}
+
 			patched_sym->changed = 1;
 			mark_included_function(patched_sym);
 			changed = true;
@@ -822,7 +1028,7 @@ static int mark_changed_functions(struct elfs *e)
 			printf("%s: changed function: %s\n", objname, patched_sym->name);
 	}
 
-	return !changed ? -1 : 0;
+	return !changed ? 1 : 0;
 }
 
 static int clone_included_functions(struct elfs *e)
@@ -1865,6 +2071,7 @@ static int copy_import_ns(struct elfs *e)
 int cmd_klp_diff(int argc, const char **argv)
 {
 	struct elfs e = {0};
+	int ret;
 
 	argc = parse_options(argc, argv, klp_diff_options, klp_diff_usage, 0);
 	if (argc != 3)
@@ -1891,7 +2098,10 @@ int cmd_klp_diff(int argc, const char **argv)
 	if (correlate_symbols(&e))
 		return -1;
 
-	if (mark_changed_functions(&e))
+	ret = mark_changed_functions(&e);
+	if (ret < 0)
+		return -1;
+	if (ret > 0)
 		return 0;
 
 	e.out = elf_create_file(&e.orig->ehdr, argv[2]);
-- 
2.53.0


