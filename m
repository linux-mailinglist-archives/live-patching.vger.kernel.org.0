Return-Path: <live-patching+bounces-2637-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SHhIGvUn9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2637-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:11:33 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D4C364AA164
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:11:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7DCA930671A6
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:09:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2202332ED3;
	Fri,  1 May 2026 04:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eeYeQbLY"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3AD3321A2;
	Fri,  1 May 2026 04:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608539; cv=none; b=pM9v52AmQ/3BfsYpshZBrtKo5V+0Y5uXkZR18i9b9tzyoCK5Kml2sWEW3mcYVs2Z661ZumIY1tokxPQAZAjURd+MymjzbieiNEhWHfdsyjVe2ufOrV63WoKklsIgeGaxv7bP/ZCI9e6wNflCswdxD5XoYv+K6sn67mPPIEe3tbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608539; c=relaxed/simple;
	bh=XjTMzGfi8bZF7bQaM0dm87pbnohW8womDStrdD8mTyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNBgTN9JLFX9cPo1Wu+jChITu2WJuLkfaWtQ8+a+6kUSUCN8zaTya11ZudXf4KY+SZVuSl+/wgQgcX6YfS05zmuL5jriDNwVjBvFmdb4MUxE8yes9cjGrpK/KjwBkd1O8YCixQq3esjVA8L3ZC+H170Csw/wwOtJsMgDvSEHoQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eeYeQbLY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3C4C2BCC6;
	Fri,  1 May 2026 04:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608538;
	bh=XjTMzGfi8bZF7bQaM0dm87pbnohW8womDStrdD8mTyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eeYeQbLYVHzIAYgoVCJFcHqKXLQjZ6IERnz0WUlH5bXoZhf45SEI0y2gpegqMRtfb
	 4PUy5c33fyEAPpM6X2pSz+1NoEyEsBontSQ7yWehuik01iZmHfQspmZW2zwKpah0wN
	 T7ErI20WADNcoo4RvoSI6bbs1o8xsRUzA7TN8uZw4rGKha+l/qrsDqASzpzU8iO9GP
	 YXSEvx5LGWwFVXEpolCGE4WJG0cgmurInRrlJRy+qseO+NigbwzuxnCwjZoFtrvgWE
	 lFxOtKhFBmrTOKPnD8HYTvdH46reddefPyLkCgsBRl9xgaZ/VhEupkVl7SkW4mM/c9
	 macECQx4QKxfQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 18/53] objtool/klp: Simplify reloc symbol conversion
Date: Thu, 30 Apr 2026 21:08:06 -0700
Message-ID: <9572b2e15500e5ed8dcbaac78c966557d3000d85.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: D4C364AA164
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2637-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

Inline section_reference_needed() and is_reloc_allowed() into
convert_reloc_sym() and remove the redundant is_reloc_allowed() check in
clone_reloc().

Move the is_sec_sym() checks into the convert callees so they become
no-ops when the reloc is already in the right format.  This allows
convert_reloc_sym() to unconditionally dispatch to the right converter
based on section type.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 76 +++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 48 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 19bc811db396..78633c9b68eb 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -838,39 +838,6 @@ static int clone_included_functions(struct elfs *e)
 	return 0;
 }
 
-/*
- * Determine whether a relocation should reference the section rather than the
- * underlying symbol.
- */
-static bool section_reference_needed(struct section *sec)
-{
-	/*
-	 * String symbols are zero-length and uncorrelated.  It's easier to
-	 * deal with them as section symbols.
-	 */
-	if (is_string_sec(sec))
-		return true;
-
-	/*
-	 * .rodata has mostly anonymous data so there's no way to determine the
-	 * length of a needed reference.  just copy the whole section if needed.
-	 */
-	if (strstarts(sec->name, ".rodata"))
-		return true;
-
-	/* UBSAN anonymous data */
-	if (strstarts(sec->name, ".data..Lubsan") ||	/* GCC */
-	    strstarts(sec->name, ".data..L__unnamed_"))	/* Clang */
-		return true;
-
-	return false;
-}
-
-static bool is_reloc_allowed(struct reloc *reloc)
-{
-	return section_reference_needed(reloc->sym->sec) == is_sec_sym(reloc->sym);
-}
-
 static struct export *find_export(struct symbol *sym)
 {
 	struct export *export;
@@ -979,11 +946,15 @@ static bool klp_reloc_needed(struct reloc *patched_reloc)
 	return true;
 }
 
+/* Return -1 error, 0 success, 1 skip */
 static int convert_reloc_sym_to_secsym(struct elf *elf, struct reloc *reloc)
 {
 	struct symbol *sym = reloc->sym;
 	struct section *sec = sym->sec;
 
+	if (is_sec_sym(sym))
+		return 0;
+
 	if (!sec->sym && !elf_create_section_symbol(elf, sec))
 		return -1;
 
@@ -993,11 +964,15 @@ static int convert_reloc_sym_to_secsym(struct elf *elf, struct reloc *reloc)
 	return 0;
 }
 
+/* Return -1 error, 0 success, 1 skip */
 static int convert_reloc_secsym_to_sym(struct elf *elf, struct reloc *reloc)
 {
 	struct symbol *sym = reloc->sym;
 	struct section *sec = sym->sec;
 
+	if (!is_sec_sym(sym))
+		return 0;
+
 	/* If the symbol has a dedicated section, it's easy to find */
 	sym = find_symbol_by_offset(sec, 0);
 	if (sym && sym->len == sec_size(sec))
@@ -1027,22 +1002,34 @@ static int convert_reloc_secsym_to_sym(struct elf *elf, struct reloc *reloc)
 	return 0;
 }
 
+/*
+ * Sections with anonymous or uncorrelated data (strings, UBSAN data)
+ * need section symbol references.
+ */
+static bool is_uncorrelated_section(struct section *sec)
+{
+	return is_string_sec(sec) ||
+	       strstarts(sec->name, ".rodata") ||
+	       strstarts(sec->name, ".data..Lubsan") ||		/* GCC */
+	       strstarts(sec->name, ".data..L__unnamed_");	/* Clang */
+}
+
 /*
  * Convert a relocation symbol reference to the needed format: either a section
- * symbol or the underlying symbol itself.
+ * symbol or the underlying symbol itself.  Return -1 error, 0 success, 1 skip.
  */
 static int convert_reloc_sym(struct elf *elf, struct reloc *reloc)
 {
+	struct section *sec = reloc->sym->sec;
+
 	if (reloc_type(reloc) == R_NONE)
 		return 1;
 
-	if (is_reloc_allowed(reloc))
-		return 0;
-
-	if (section_reference_needed(reloc->sym->sec))
+	if (is_uncorrelated_section(sec))
 		return convert_reloc_sym_to_secsym(elf, reloc);
-	else
-		return convert_reloc_secsym_to_sym(elf, reloc);
+
+	/* Everything else: references should use named symbols. */
+	return convert_reloc_secsym_to_sym(elf, reloc);
 }
 
 /*
@@ -1187,13 +1174,6 @@ static int clone_reloc(struct elfs *e, struct reloc *patched_reloc,
 	struct symbol *out_sym;
 	bool klp;
 
-	if (!is_reloc_allowed(patched_reloc)) {
-		ERROR_FUNC(patched_reloc->sec->base, reloc_offset(patched_reloc),
-			   "missing symbol for reference to %s+%ld",
-			   patched_sym->name, addend);
-		return -1;
-	}
-
 	klp = klp_reloc_needed(patched_reloc);
 
 	dbg_clone_reloc(sec, offset, patched_sym, addend, export, klp);
@@ -1223,7 +1203,7 @@ static int clone_reloc(struct elfs *e, struct reloc *patched_reloc,
 
 	/*
 	 * For strings, all references use section symbols, thanks to
-	 * section_reference_needed().  clone_symbol() has cloned an empty
+	 * convert_reloc_sym().  clone_symbol() has cloned an empty
 	 * version of the string section.  Now copy the string itself.
 	 */
 	if (is_string_sec(patched_sym->sec)) {
-- 
2.53.0


