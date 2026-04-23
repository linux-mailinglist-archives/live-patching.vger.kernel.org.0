Return-Path: <live-patching+bounces-2475-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yCmSHO6d6WkAfQIAu9opvQ
	(envelope-from <live-patching+bounces-2475-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:19:58 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E80E644CE44
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:19:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9DECB3109AE2
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89A4B3DF00B;
	Thu, 23 Apr 2026 04:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YsM4P7Am"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6052B3DC4D8;
	Thu, 23 Apr 2026 04:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917089; cv=none; b=kT7h3+pXztRoDRtjbA1pH8+tlFRgwBVIAWhNq1kYghX1uMoN5t6M5lk+x+iLhpLd40eqFAriTA1nFinbZBrFCMdvSWMiddk/9fDlg7Jd9gCq64YeeDqVBVjK3mMIwL+3m+oTmOPqRe+BHS49/fCamgEX8rRu30hIpMk4nrMWdLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917089; c=relaxed/simple;
	bh=X4dg66aAqYt7wEo6E6eFhwh+BC1shUoGhNLsTu5F2rE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MB/0ntorqAUMa97QXH/ucF6V1jZpcNVEimXQjw2HtB15viuSb/OZfFNn5PMfB++3nfAjTeVXjBztNOrV51YQg3upxi5fII9U73hTXqAPNaP8+M7ugkPn79ubk/4B2EGvvr90htpxjQVJU7f6mMsP1LCW1QZ0UbnLE+uciILximY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YsM4P7Am; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D82C2BCC4;
	Thu, 23 Apr 2026 04:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917089;
	bh=X4dg66aAqYt7wEo6E6eFhwh+BC1shUoGhNLsTu5F2rE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YsM4P7AmPt9KiGADmJ6hySaQDs+6gyWzU/RrRKxa4nUy1uDiVl98dKnH4voyGKd+S
	 tIm6twNhHkFtSiGWTy1NhctxW+l4TKfgyaUKUx3GWLxcNw/gKCSS0662y2tdVCfJIk
	 Nh4oBi7bSTBt9xtuqwjSHyrItzz4ID3c/LXQZKI8J8hX1+mlCmMwOAfMzNLC6FsZKq
	 fe5Qggou7fVP+ARzyKufEeeRBDnEjizkEdryGZc6ZlIpq+gIOi8WmZP9DIJ/tTQ6Xk
	 1eCGs1G1cP+V57kV3VISVQT/NkBuCe2ShozP3VMKPqvbfCwu/Adro+MdcCyUOPxxaf
	 jr2Pu5Rcjbczg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 48/48] objtool/klp: Cache dont_correlate() result
Date: Wed, 22 Apr 2026 21:04:16 -0700
Message-ID: <c5c4467abea21d4962b4a61c5d6023482e01bd8e.1776916871.git.jpoimboe@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-2475-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: E80E644CE44
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Cache the dont_correlate() result once per symbol at the start of
correlate_symbols().  This reduces klp diff time on an arm64 LTO
vmlinux.o from 2m51s to 35s.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/include/objtool/elf.h |  1 +
 tools/objtool/klp-diff.c            | 29 +++++++++++++++++------------
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 21441bd72971..fb4fec7d8a6e 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -95,6 +95,7 @@ struct symbol {
 	u8 changed	     : 1;
 	u8 included	     : 1;
 	u8 klp		     : 1;
+	u8 dont_correlate     : 1;
 	struct list_head pv_target;
 	struct reloc *relocs;
 	struct section *group_sec;
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 420d05633aba..a848015b477c 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -566,7 +566,7 @@ static struct symbol *find_twin(struct elfs *e, struct symbol *sym1)
 
 	/* Count orig candidates */
 	for_each_sym_by_demangled_name(e->orig, sym1->demangled_name, sym2) {
-		if (sym2->twin || sym1->type != sym2->type || dont_correlate(sym2) ||
+		if (sym2->twin || sym1->type != sym2->type || sym2->dont_correlate ||
 		    (!maybe_same_file(sym1, sym2)))
 			continue;
 
@@ -592,7 +592,7 @@ static struct symbol *find_twin(struct elfs *e, struct symbol *sym1)
 
 	/* Count patched candidates */
 	for_each_sym_by_demangled_name(e->patched, sym1->demangled_name, sym2) {
-		if (sym2->twin || sym1->type != sym2->type || dont_correlate(sym2))
+		if (sym2->twin || sym1->type != sym2->type || sym2->dont_correlate)
 			continue;
 
 		/* Level 1 */
@@ -728,7 +728,7 @@ static struct symbol *find_twin_suffixed(struct elf *elf, struct symbol *sym1)
 		return NULL;
 
 	for_each_sym_by_name(elf, name, sym2) {
-		if (sym2->twin || sym1->type != sym2->type || dont_correlate(sym2))
+		if (sym2->twin || sym1->type != sym2->type || sym2->dont_correlate)
 			continue;
 		count++;
 		match = sym2;
@@ -762,7 +762,7 @@ static struct symbol *find_twin_positional(struct elfs *e, struct symbol *sym1)
 	struct symbol *sym2, *match = NULL;
 
 	for_each_sym_by_demangled_name(e->orig, sym1->demangled_name, sym2) {
-		if (sym2->twin || sym1->type != sym2->type || dont_correlate(sym2) ||
+		if (sym2->twin || sym1->type != sym2->type || sym2->dont_correlate ||
 		    !maybe_same_file(sym1, sym2))
 			continue;
 		if (is_tu_local_sym(sym1) != is_tu_local_sym(sym2) ||
@@ -774,7 +774,7 @@ static struct symbol *find_twin_positional(struct elfs *e, struct symbol *sym1)
 	}
 
 	for_each_sym_by_demangled_name(e->patched, sym1->demangled_name, sym2) {
-		if (sym2->twin || sym1->type != sym2->type || dont_correlate(sym2) ||
+		if (sym2->twin || sym1->type != sym2->type || sym2->dont_correlate ||
 		    !maybe_same_file(sym1, sym2))
 			continue;
 		if (is_tu_local_sym(sym1) != is_tu_local_sym(sym2) ||
@@ -806,6 +806,11 @@ static int correlate_symbols(struct elfs *e)
 	struct symbol *sym1, *sym2;
 	bool progress;
 
+	for_each_sym(e->orig, sym1)
+		sym1->dont_correlate = dont_correlate(sym1);
+	for_each_sym(e->patched, sym2)
+		sym2->dont_correlate = dont_correlate(sym2);
+
 	/* Correlate FILE symbols */
 	file1_sym = first_file_symbol(e->orig);
 	file2_sym = first_file_symbol(e->patched);
@@ -846,7 +851,7 @@ static int correlate_symbols(struct elfs *e)
 	do {
 		progress = false;
 		for_each_sym(e->orig, sym1) {
-			if (sym1->twin || dont_correlate(sym1))
+			if (sym1->twin || sym1->dont_correlate)
 				continue;
 			sym2 = find_twin(e, sym1);
 			if (!sym2)
@@ -860,7 +865,7 @@ static int correlate_symbols(struct elfs *e)
 			return -1;
 
 		for_each_sym(e->orig, sym1) {
-			if (sym1->twin || dont_correlate(sym1))
+			if (sym1->twin || sym1->dont_correlate)
 				continue;
 			sym2 = find_twin_suffixed(e->patched, sym1);
 			if (!sym2)
@@ -872,7 +877,7 @@ static int correlate_symbols(struct elfs *e)
 	} while (progress);
 
 	for_each_sym(e->orig, sym1) {
-		if (sym1->twin || dont_correlate(sym1))
+		if (sym1->twin || sym1->dont_correlate)
 			continue;
 		sym2 = find_twin_positional(e, sym1);
 		if (!sym2)
@@ -882,7 +887,7 @@ static int correlate_symbols(struct elfs *e)
 	}
 
 	for_each_sym(e->orig, sym1) {
-		if (sym1->twin || dont_correlate(sym1))
+		if (sym1->twin || sym1->dont_correlate)
 			continue;
 		WARN("no correlation: %s", sym1->name);
 	}
@@ -1102,7 +1107,7 @@ static int mark_changed_functions(struct elfs *e)
 
 	/* Find changed functions */
 	for_each_sym(e->orig, orig_sym) {
-		if (dont_correlate(orig_sym))
+		if (orig_sym->dont_correlate)
 			continue;
 
 		patched_sym = orig_sym->twin;
@@ -1123,7 +1128,7 @@ static int mark_changed_functions(struct elfs *e)
 
 	/* Find added functions and print them */
 	for_each_sym(e->patched, patched_sym) {
-		if (!is_func_sym(patched_sym) || dont_correlate(patched_sym))
+		if (!is_func_sym(patched_sym) || patched_sym->dont_correlate)
 			continue;
 
 		if (!patched_sym->twin) {
@@ -1263,7 +1268,7 @@ static bool klp_reloc_needed(struct reloc *patched_reloc)
 	struct export *export;
 
 	/* no external symbol to reference */
-	if (dont_correlate(patched_sym))
+	if (patched_sym->dont_correlate)
 		return false;
 
 	/* For included functions, a regular reloc will do. */
-- 
2.53.0


