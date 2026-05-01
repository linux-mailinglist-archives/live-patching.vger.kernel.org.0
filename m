Return-Path: <live-patching+bounces-2670-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YhROLIcq9Glp+wEAu9opvQ
	(envelope-from <live-patching+bounces-2670-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:22:31 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C30454AA497
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:22:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 44D7E306FD6F
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F75237E307;
	Fri,  1 May 2026 04:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fb03TBxR"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2410637DE8E;
	Fri,  1 May 2026 04:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608556; cv=none; b=fXfQbYUxS7EhGSC3/tO+nCwPz982R7eBZD3E/U97cp+fbcU0gLj3iosY2P5pmIbsIFv+kI1nj3vU1JxTSmeZsKyCZlNprgcF7mZpwQvn6bG6OgRFnZzHS5DyABdeMqT84nniM92vMon0Pvm6JnETr013/e1wPv5dMAZ3toJjQBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608556; c=relaxed/simple;
	bh=GF28pI1dFS/n6Z9A4UM/rCVDz8QhPIV1HAHHVKcRD2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZzXsu9RHwa5qGALEkl4mSsu4rR+FZiVjViM8/jlnjJ381vKufw1K6yAjmr9H+YehVuKOnilohHvIfy1dAVz/QcSiWk1tanywnFFfMgRgpbgXprzyNOLpMAvgT5G1ZBtvIHDuhRCPMRCCYhZ9LW0miaXXJAaLFfjQkrhcexYIwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fb03TBxR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28C4C2BCB9;
	Fri,  1 May 2026 04:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608556;
	bh=GF28pI1dFS/n6Z9A4UM/rCVDz8QhPIV1HAHHVKcRD2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fb03TBxR69SS0/X2CYZAQnq+qKnZnfZD7FGOkwpdDBVAyJpKUz8/fK4xJq3Gs+2a0
	 0nU23QtD1ffjeMtLEXTVG1Sfcts7hwA9TiN9/rwJ9rqMBnVmqCYraKAq02B9CxLzcv
	 ihHS6uocB2/1i+tx438IGbScAdKVn9C9w/6Fzpvjo6TP/SMXul29FVojJ7xkI92KF+
	 fLPTe9PJeQcgOeRYzS3K/4wFOmq7RUjmMLLVz9jhN0dYwgHdGMtfgtwujKwO48UwkK
	 JmvtHEKNwk57/ABZPpTkoZKjcplyyFVyRFm7Oh1y1OBBC58A4w1uQkwXg9/uDUQfmb
	 XVLAhnHFkjgPA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 53/53] objtool/klp: Cache dont_correlate() result
Date: Thu, 30 Apr 2026 21:08:41 -0700
Message-ID: <b13cf9c9e942563b4a9b19494a83f4abf073b0c5.1777575753.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: C30454AA497
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2670-lists,live-patching=lfdr.de];
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

Cache the dont_correlate() result once per symbol at the start of
correlate_symbols().  This reduces klp diff time on an arm64 LTO
vmlinux.o from 2m51s to 35s.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/include/objtool/elf.h |  1 +
 tools/objtool/klp-diff.c            | 29 +++++++++++++++++------------
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index fccf72cbd343..d9c44df9cc76 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -96,6 +96,7 @@ struct symbol {
 	u8 changed	     : 1;
 	u8 included	     : 1;
 	u8 klp		     : 1;
+	u8 dont_correlate    : 1;
 	struct list_head pv_target;
 	struct reloc *relocs;
 	struct section *group_sec;
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index ed3bf1c55001..f8787d7d1454 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -524,7 +524,7 @@ static struct symbol *find_twin(struct elfs *e, struct symbol *sym1)
 
 	/* Count orig candidates */
 	for_each_sym_by_demangled_name(e->orig, sym1->demangled_name, sym2) {
-		if (sym2->twin || sym1->type != sym2->type || dont_correlate(sym2) ||
+		if (sym2->twin || sym1->type != sym2->type || sym2->dont_correlate ||
 		    (!maybe_same_file(sym1, sym2)))
 			continue;
 
@@ -550,7 +550,7 @@ static struct symbol *find_twin(struct elfs *e, struct symbol *sym1)
 
 	/* Count patched candidates */
 	for_each_sym_by_demangled_name(e->patched, sym1->demangled_name, sym2) {
-		if (sym2->twin || sym1->type != sym2->type || dont_correlate(sym2) ||
+		if (sym2->twin || sym1->type != sym2->type || sym2->dont_correlate ||
 		    !maybe_same_file(sym1, sym2))
 			continue;
 
@@ -693,7 +693,7 @@ static struct symbol *find_twin_suffixed(struct elf *elf, struct symbol *sym1)
 		return NULL;
 
 	for_each_sym_by_name(elf, name, sym2) {
-		if (sym2->twin || sym1->type != sym2->type || dont_correlate(sym2))
+		if (sym2->twin || sym1->type != sym2->type || sym2->dont_correlate)
 			continue;
 		count++;
 		match = sym2;
@@ -733,7 +733,7 @@ static struct symbol *find_twin_positional(struct elfs *e, struct symbol *sym1)
 	struct symbol *sym2, *match = NULL;
 
 	for_each_sym_by_demangled_name(e->orig, sym1->demangled_name, sym2) {
-		if (sym2->twin || sym1->type != sym2->type || dont_correlate(sym2) ||
+		if (sym2->twin || sym1->type != sym2->type || sym2->dont_correlate ||
 		    !maybe_same_file(sym1, sym2))
 			continue;
 		if (is_tu_local_sym(sym1) != is_tu_local_sym(sym2) ||
@@ -745,7 +745,7 @@ static struct symbol *find_twin_positional(struct elfs *e, struct symbol *sym1)
 	}
 
 	for_each_sym_by_demangled_name(e->patched, sym1->demangled_name, sym2) {
-		if (sym2->twin || sym1->type != sym2->type || dont_correlate(sym2) ||
+		if (sym2->twin || sym1->type != sym2->type || sym2->dont_correlate ||
 		    !maybe_same_file(sym1, sym2))
 			continue;
 		if (is_tu_local_sym(sym1) != is_tu_local_sym(sym2) ||
@@ -777,6 +777,11 @@ static int correlate_symbols(struct elfs *e)
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
@@ -817,7 +822,7 @@ static int correlate_symbols(struct elfs *e)
 	do {
 		progress = false;
 		for_each_sym(e->orig, sym1) {
-			if (sym1->twin || dont_correlate(sym1))
+			if (sym1->twin || sym1->dont_correlate)
 				continue;
 			sym2 = find_twin(e, sym1);
 			if (!sym2)
@@ -831,7 +836,7 @@ static int correlate_symbols(struct elfs *e)
 			return -1;
 
 		for_each_sym(e->orig, sym1) {
-			if (sym1->twin || dont_correlate(sym1))
+			if (sym1->twin || sym1->dont_correlate)
 				continue;
 			sym2 = find_twin_suffixed(e->patched, sym1);
 			if (!sym2)
@@ -843,7 +848,7 @@ static int correlate_symbols(struct elfs *e)
 	} while (progress);
 
 	for_each_sym(e->orig, sym1) {
-		if (sym1->twin || dont_correlate(sym1))
+		if (sym1->twin || sym1->dont_correlate)
 			continue;
 		sym2 = find_twin_positional(e, sym1);
 		if (!sym2)
@@ -853,7 +858,7 @@ static int correlate_symbols(struct elfs *e)
 	}
 
 	for_each_sym(e->orig, sym1) {
-		if (sym1->twin || dont_correlate(sym1))
+		if (sym1->twin || sym1->dont_correlate)
 			continue;
 		WARN("no correlation: %s", sym1->name);
 	}
@@ -1066,7 +1071,7 @@ static int mark_changed_functions(struct elfs *e)
 
 	/* Find changed functions */
 	for_each_sym(e->orig, orig_sym) {
-		if (dont_correlate(orig_sym))
+		if (orig_sym->dont_correlate)
 			continue;
 
 		patched_sym = orig_sym->twin;
@@ -1087,7 +1092,7 @@ static int mark_changed_functions(struct elfs *e)
 
 	/* Find added functions and print them */
 	for_each_sym(e->patched, patched_sym) {
-		if (!is_func_sym(patched_sym) || dont_correlate(patched_sym))
+		if (!is_func_sym(patched_sym) || patched_sym->dont_correlate)
 			continue;
 
 		if (!patched_sym->twin) {
@@ -1193,7 +1198,7 @@ static bool klp_reloc_needed(struct reloc *patched_reloc)
 	struct export *export;
 
 	/* no external symbol to reference */
-	if (dont_correlate(patched_sym))
+	if (patched_sym->dont_correlate)
 		return false;
 
 	/* For included functions, a regular reloc will do. */
-- 
2.53.0


