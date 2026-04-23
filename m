Return-Path: <live-patching+bounces-2473-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SBjJHOOd6WkAfQIAu9opvQ
	(envelope-from <live-patching+bounces-2473-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:19:47 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C8C9E44CE3D
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:19:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6E29431ED46A
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7640B3DEAE3;
	Thu, 23 Apr 2026 04:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pD5Pn2A0"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FC43DEAD6;
	Thu, 23 Apr 2026 04:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917088; cv=none; b=lgyzIMFkij+QfKbJN3SGuoh+8OtCDSc1G+GlJT2qX/fpTkTOYnEu4ajHETd9fWTrOF0L4cTUKbFUvHzyQS5Lope5xOnlXkM8Ss25NPwEQHWKOsH2sTgjlNINkzbuVGKiySYA4qz5sJTljOub/xRX13r78jDhD8iQwlneaPRElmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917088; c=relaxed/simple;
	bh=h6zRAY4MZHAqnNqN11j07fqZ4dA1MwgNBlIVRviGFls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2yIzVyBd+kkP6luyczZ8VILPOoq0gTSlgZnGd7s6GAIKhnJEbr7jmnQRmsIxBSi2BhGcvuLM3g4iR5hKGJliUu+6BeJEUSofvkHE7iwYqHKPUODg85wGsoh6Aq+gw1jnr77yDNsoVH1O1ssvrfMU0yOUtdO212eE42/hKj8LKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pD5Pn2A0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EB4C2BCB5;
	Thu, 23 Apr 2026 04:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917088;
	bh=h6zRAY4MZHAqnNqN11j07fqZ4dA1MwgNBlIVRviGFls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pD5Pn2A05HKIyzHzGgjocnBkW9h13tTbHMpYaSB+LoQuxa02+rNQvVYntBZHrn8Us
	 SmN0uIgy1/44Qnsf7nru9XlUPR2z99xTMShg9NsU4VxdwVSj+F8Y5FEKAMp2ujAZii
	 /TymBO3EuwGfPCzUoh/6m9o716vGUai8ufEtV6nyl+GGiTd5Qg+NIZLppALTyFaUIR
	 VKioCiwCNODctswhYKpPbTILHpGjmlmgHZtcK0zWqra/1nlzCKsqgwCc8hw9otbvsH
	 lOETFFVYH7n8iTamlU+RAj2zoNHhTZF/wq9qiWIcUhXgbOb9QyJT4CL0Pp+NLxiQt1
	 grigtftmUAzqA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 46/48] objtool/klp: Make function prefix handling more generic
Date: Wed, 22 Apr 2026 21:04:14 -0700
Message-ID: <666c12d66a3bc3c628a265da67801090132956ca.1776916871.git.jpoimboe@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2473-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C8C9E44CE3D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The way x86 klp-diff handles function prefix symbols is a bit awkward,
Also, x86 is the only arch which needs the __pfx_/cfi_ prefix symbols,
so this approach isn't extensible to other arches.  And while other
arches *do* use __patchable_function_entries (PFEs), they use them in
completely different ways.

In preparation for supporting other arches, use a more generic approach
that will work for all arches with prefixed areas and/or PFE sections.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/include/objtool/elf.h |  15 +--
 tools/objtool/klp-diff.c            | 187 ++++++++++++++++++++++++----
 2 files changed, 161 insertions(+), 41 deletions(-)

diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index ba13dd67cf26..21441bd72971 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -119,6 +119,7 @@ struct elf {
 	struct list_head sections;
 	struct list_head symbols;
 	unsigned long num_relocs;
+	int pfe_offset;
 
 	int symbol_bits;
 	int symbol_name_bits;
@@ -532,20 +533,6 @@ static inline void set_sym_next_reloc(struct reloc *reloc, struct reloc *next)
 	     reloc && reloc_offset(reloc) <  sym->offset + sym->len;	\
 	     reloc = rsec_next_reloc(sym->sec->rsec, reloc))
 
-static inline struct symbol *get_func_prefix(struct symbol *func)
-{
-	struct symbol *prev;
-
-	if (!is_func_sym(func))
-		return NULL;
-
-	prev = sec_prev_sym(func);
-	if (prev && is_prefix_func(prev))
-		return prev;
-
-	return NULL;
-}
-
 #define OFFSET_STRIDE_BITS	4
 #define OFFSET_STRIDE		(1UL << OFFSET_STRIDE_BITS)
 #define OFFSET_STRIDE_MASK	(~(OFFSET_STRIDE - 1))
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index acb76aefd04f..420d05633aba 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -213,6 +213,88 @@ static int read_sym_checksums(struct elf *elf)
 	return 0;
 }
 
+/*
+ * Detect the offset from the function entry point to its
+ * __patchable_function_entries (PFE) relocation target.
+ *
+ * offset < 0 (before function entry):
+ *
+ *    CONFIG_FINEIBT (x86)
+ *    CONFIG_MITIGATION_CALL_DEPTH_TRACKING (x86)
+ */
+static int read_pfe_offset(struct elf *elf)
+{
+	bool has_pfe = false;
+	struct section *sec;
+
+	for_each_sec(elf, sec) {
+		struct reloc *reloc;
+
+		if (strcmp(sec->name, "__patchable_function_entries"))
+			continue;
+		if (!sec->rsec)
+			continue;
+
+		has_pfe = true;
+
+		for_each_reloc(sec->rsec, reloc) {
+			unsigned long target = reloc->sym->offset + reloc_addend(reloc);
+			struct symbol *func;
+
+			func = find_func_containing(reloc->sym->sec, target);
+			if (func) {
+				if (is_prefix_func(func))
+					elf->pfe_offset = target - (func->offset + func->len);
+				else
+					elf->pfe_offset = target - func->offset;
+				return 0;
+			}
+		}
+	}
+
+	if (has_pfe) {
+		ERROR("can't find __patchable_function_entries offset");
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * Detect the size of the area before a function's entry point.  This prefix
+ * area is used for CFI type hashes, call thunks, or ftrace call ops.
+ *
+ *  __pfx_ prefix function (x86):
+ *
+ *    CONFIG_MITIGATION_CALL_DEPTH_TRACKING
+ *
+ *  __cfi_ prefix function (x86):
+ *
+ *    CONFIG_CFI
+ */
+static unsigned long func_pfx_size(struct elf *elf, struct symbol *func)
+{
+	struct symbol *pfx;
+
+	/* x86 __pfx_ and/or __cfi_ */
+	if (func->offset) {
+		pfx = find_func_containing(func->sec, func->offset - 1);
+		if (pfx && pfx->prefix) {
+			struct symbol *pfx2;
+
+			/* FineIBT has both */
+			if (pfx->offset) {
+				pfx2 = find_func_containing(func->sec, pfx->offset - 1);
+				if (pfx2 && pfx2->prefix)
+					pfx = pfx2;
+			}
+
+			return func->offset - pfx->offset;
+		}
+	}
+	return 0;
+}
+
 static struct symbol *first_file_symbol(struct elf *elf)
 {
 	struct symbol *sym;
@@ -302,6 +384,7 @@ static bool is_special_section(struct section *sec)
 		"__ex_table",
 		"__jump_table",
 		"__mcount_loc",
+		"__patchable_function_entries",
 
 		/*
 		 * Extract .static_call_sites here to inherit non-module
@@ -872,7 +955,7 @@ static struct symbol *__clone_symbol(struct elf *elf, struct symbol *patched_sym
 				     bool data_too)
 {
 	struct section *out_sec = NULL;
-	unsigned long offset = 0;
+	unsigned long offset = 0, pfx_size = 0;
 	struct symbol *out_sym;
 
 	if (data_too && !is_undef_sym(patched_sym)) {
@@ -901,20 +984,26 @@ static struct symbol *__clone_symbol(struct elf *elf, struct symbol *patched_sym
 			offset = ALIGN(sec_size(out_sec), out_sec->sh.sh_addralign);
 
 		if (patched_sym->len || is_sec_sym(patched_sym)) {
-			void *data = NULL;
 			size_t size;
+			void *data = NULL;
+
+			/* Clone function prefix area */
+			if (is_func_sym(patched_sym))
+				pfx_size = func_pfx_size(elf, patched_sym);
 
 			/* bss doesn't have data */
 			if (patched_sym->sec->data && patched_sym->sec->data->d_buf)
-				data = patched_sym->sec->data->d_buf + patched_sym->offset;
+				data = patched_sym->sec->data->d_buf + patched_sym->offset - pfx_size;
 
 			if (is_sec_sym(patched_sym))
 				size = sec_size(patched_sym->sec);
 			else
-				size = patched_sym->len;
+				size = patched_sym->len + pfx_size;
 
 			if (!elf_add_data(elf, out_sec, data, size))
 				return NULL;
+
+			offset += pfx_size;
 		}
 	}
 
@@ -924,6 +1013,23 @@ static struct symbol *__clone_symbol(struct elf *elf, struct symbol *patched_sym
 	if (!out_sym)
 		return NULL;
 
+	/*
+	 * The copied prefixed area may have had a __cfi_ symbol which needs to
+	 * be copied.  During the module link, objtool collates these in a
+	 * .cfi_sites section for FineIBT.
+	 */
+	if (pfx_size && is_func_sym(patched_sym)) {
+		struct symbol *cfi_sym;
+
+		cfi_sym = find_func_containing(patched_sym->sec, patched_sym->offset - pfx_size);
+		if (cfi_sym && strstarts(cfi_sym->name, "__cfi_")) {
+			if (!elf_create_symbol(elf, cfi_sym->name, out_sec,
+					       cfi_sym->bind, cfi_sym->type,
+					       offset - pfx_size, cfi_sym->len))
+				return NULL;
+		}
+	}
+
 sym_created:
 	patched_sym->clone = out_sym;
 	out_sym->clone = patched_sym;
@@ -960,20 +1066,11 @@ static const char *sym_bind(struct symbol *sym)
 static struct symbol *clone_symbol(struct elfs *e, struct symbol *patched_sym,
 				   bool data_too)
 {
-	struct symbol *pfx;
-
 	if (patched_sym->clone)
 		return patched_sym->clone;
 
 	dbg_clone("%s%s", patched_sym->name, data_too ? " [+DATA]" : "");
 
-	/* Make sure the prefix gets cloned first */
-	if (is_func_sym(patched_sym) && data_too) {
-		pfx = get_func_prefix(patched_sym);
-		if (pfx)
-			clone_symbol(e, pfx, true);
-	}
-
 	if (!__clone_symbol(e->out, patched_sym, data_too))
 		return NULL;
 
@@ -985,15 +1082,8 @@ static struct symbol *clone_symbol(struct elfs *e, struct symbol *patched_sym,
 
 static void mark_included_function(struct symbol *func)
 {
-	struct symbol *pfx;
-
 	func->included = 1;
 
-	/* Include prefix function */
-	pfx = get_func_prefix(func);
-	if (pfx)
-		pfx->included = 1;
-
 	/* Make sure .cold parent+child always stay together */
 	if (func->cfunc && func->cfunc != func)
 		func->cfunc->included = 1;
@@ -1222,17 +1312,37 @@ static int convert_reloc_sym_to_secsym(struct elf *elf, struct reloc *reloc)
 	return 0;
 }
 
+/*
+ * __patchable_function_entries relocs point to the patchable entry NOPs,
+ * which are at 'pfe_offset' bytes from the function symbol.
+ *
+ * Some entries (e.g., removed weak functions, syscall -ENOSYS stubs) don't
+ * have a corresponding function symbol.  Skip those with a return value of 1.
+ */
+static int convert_pfe_reloc(struct elf *elf, struct reloc *reloc)
+{
+	struct symbol *func;
+
+	func = find_func_by_offset(reloc->sym->sec,
+				   reloc->sym->offset +
+				   reloc_addend(reloc) - elf->pfe_offset);
+	if (!func)
+		return 1;
+
+	reloc->sym = func;
+	set_reloc_sym(elf, reloc, func->idx);
+	set_reloc_addend(elf, reloc, elf->pfe_offset);
+	return 0;
+}
+
 static int convert_reloc_secsym_to_sym(struct elf *elf, struct reloc *reloc)
 {
 	struct symbol *sym = reloc->sym;
 	struct section *sec = sym->sec;
 
-	/* If the symbol has a dedicated section, it's easy to find */
-	sym = find_symbol_by_offset(sec, 0);
-	if (sym && sym->len == sec_size(sec))
-		goto found_sym;
+	if (!strcmp(reloc->sec->name, ".rela__patchable_function_entries"))
+		return convert_pfe_reloc(elf, reloc);
 
-	/* No dedicated section; find the symbol manually */
 	sym = find_symbol_containing(sec, arch_adjusted_addend(reloc));
 	if (!sym) {
 		/*
@@ -1249,7 +1359,6 @@ static int convert_reloc_secsym_to_sym(struct elf *elf, struct reloc *reloc)
 		return -1;
 	}
 
-found_sym:
 	reloc->sym = sym;
 	set_reloc_sym(elf, reloc, sym->idx);
 	set_reloc_addend(elf, reloc, reloc_addend(reloc) - sym->offset);
@@ -1802,6 +1911,9 @@ static int validate_special_section_klp_reloc(struct elfs *e, struct symbol *sym
 
 static int clone_special_section(struct elfs *e, struct section *patched_sec)
 {
+	bool is_pfe = !strcmp(patched_sec->name, "__patchable_function_entries");
+	struct section *out_sec = NULL;
+	struct reloc *patched_reloc;
 	struct symbol *patched_sym;
 
 	/*
@@ -1809,6 +1921,7 @@ static int clone_special_section(struct elfs *e, struct section *patched_sec)
 	 * reference included functions.
 	 */
 	sec_for_each_sym(patched_sec, patched_sym) {
+		struct symbol *out_sym;
 		int ret;
 
 		if (!is_object_sym(patched_sym))
@@ -1823,8 +1936,23 @@ static int clone_special_section(struct elfs *e, struct section *patched_sec)
 		if (ret > 0)
 			continue;
 
-		if (!clone_symbol(e, patched_sym, true))
+		out_sym = clone_symbol(e, patched_sym, true);
+		if (!out_sym)
 			return -1;
+
+		if (!is_pfe || (out_sec && out_sec->sh.sh_link))
+			continue;
+
+		/*
+		 * For reasons, the patched object has multiple PFE sections,
+		 * but we only need to create one combined section for the
+		 * output.  Link the single PFE ouput section to a random text
+		 * section to satisfy the linker for SHF_LINK_ORDER.
+		 */
+		out_sec = out_sym->sec;
+		patched_reloc = find_reloc_by_dest(e->patched, patched_sec,
+						   patched_sym->offset);
+		out_sec->sh.sh_link = patched_reloc->sym->clone->sec->idx;
 	}
 
 	return 0;
@@ -2121,6 +2249,9 @@ int cmd_klp_diff(int argc, const char **argv)
 	if (read_sym_checksums(e.patched))
 		return -1;
 
+	if (read_pfe_offset(e.patched))
+		return -1;
+
 	if (correlate_symbols(&e))
 		return -1;
 
@@ -2134,6 +2265,8 @@ int cmd_klp_diff(int argc, const char **argv)
 	if (!e.out)
 		return -1;
 
+	e.out->pfe_offset = e.patched->pfe_offset;
+
 	/*
 	 * Special section fake symbols are needed so that individual special
 	 * section entries can be extracted by clone_special_sections().
-- 
2.53.0


