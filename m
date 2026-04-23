Return-Path: <live-patching+bounces-2474-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UMNlBJqc6Wm3ewIAu9opvQ
	(envelope-from <live-patching+bounces-2474-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:14:18 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A78D044CD04
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:14:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C46F43045B5C
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D63433DEAFF;
	Thu, 23 Apr 2026 04:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DPDOBKmO"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD753DEAEC;
	Thu, 23 Apr 2026 04:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917088; cv=none; b=A7bDgVt6yA6VF4kawgccNNmWaRKVtm3Sz8SxsgnCzcPjOPfPRBpj7SjW2VsIQVE47gshm+OQ8id5CdLs3PIJSEzXiLPUJ0oMESMq/MX63iKpAh1q12ZqmVI/UpfWU+BSfHspA86WaJqbvkFt/uPPQLw+Un5pF6ZCuVulC37Xep0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917088; c=relaxed/simple;
	bh=wIc5nXX6Jz223dE6PJMDQQKraiu/sKQQ6i4/IJEIOzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6BGV8Oy1BkbfyBJYcfP3YKPgJ6HPtrREYPP2SuAUoro0rJ+usTYuTpDyMWL9Ap8KUQbELZ11fM0RlTUx8vRei6WKHInkoa65uwA7s+625Tr5D13jBJr5pHrp3rXcrp9Jf+qwT2IUJwyWMMvM2GlnMHJ1HrM470kLZSIQ96VN/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DPDOBKmO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30829C2BCB4;
	Thu, 23 Apr 2026 04:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917088;
	bh=wIc5nXX6Jz223dE6PJMDQQKraiu/sKQQ6i4/IJEIOzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPDOBKmO2SCP1Q0QS2lpJONcdtDtFgooduX4v8wrwmnWZAkDcYnI8dCoR6pYLHnc6
	 d9a+6uv6A9LTydM49dUzS+D0R4DPGS+eLrtiHwKbjrwQ1u6V+wzIalmtAoO70h8ngb
	 GkPpFpQAaqmhSrPuEnLhHOQSXqEppNmxP9oqteHR9f3DwdMmv1E0+yVwEObw5LZWxu
	 7lfWWtRoenRte2w/IzVsDGqtRNk6H1EySJLSex3UwVvzSG7xb5wZAECZjeOcAX2Ehh
	 7iNDXJaP1nvPbZWmzqxPE4fG3EIlClAcioE1LITQmw39FbQTi07n7Gave4z+9UPMhK
	 arwVO6tyrOgDQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 47/48] objtool: Improve and simplify prefix symbol detection
Date: Wed, 22 Apr 2026 21:04:15 -0700
Message-ID: <45d385f7112ccb71f991a8524e3f9f48b37c1fd9.1776916871.git.jpoimboe@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2474-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A78D044CD04
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Only create prefix symbols for functions that have
__patchable_function_entries entries, since those are the only functions
where prefix NOPs are intentional.

This both simplifies the detection and makes it more accurate.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 90 ++++++++++---------------------------------
 1 file changed, 21 insertions(+), 69 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 410061aeed26..d438c5a4444b 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4271,17 +4271,6 @@ static bool ignore_unreachable_insn(struct objtool_file *file, struct instructio
  * For FineIBT or kCFI, a certain number of bytes preceding the function may be
  * NOPs.  Those NOPs may be rewritten at runtime and executed, so give them a
  * proper function name: __pfx_<func>.
- *
- * The NOPs may not exist for the following cases:
- *
- *   - compiler cloned functions (*.cold, *.part0, etc)
- *   - asm functions created with inline asm or without SYM_FUNC_START()
- *
- * Also, the function may already have a prefix from a previous objtool run
- * (livepatch extracted functions, or manually running objtool multiple times).
- *
- * So return 0 if the NOPs are missing or the function already has a prefix
- * symbol.
  */
 static int create_prefix_symbol(struct objtool_file *file, struct symbol *func)
 {
@@ -4289,10 +4278,6 @@ static int create_prefix_symbol(struct objtool_file *file, struct symbol *func)
 	char name[SYM_NAME_LEN];
 	struct cfi_state *cfi;
 
-	if (!is_func_sym(func) || is_prefix_func(func) || is_cold_func(func) ||
-	    func->static_call_tramp)
-		return 0;
-
 	if ((strlen(func->name) + sizeof("__pfx_") > SYM_NAME_LEN)) {
 		WARN("%s: symbol name too long, can't create __pfx_ symbol",
 		      func->name);
@@ -4302,59 +4287,21 @@ static int create_prefix_symbol(struct objtool_file *file, struct symbol *func)
 	if (snprintf_check(name, SYM_NAME_LEN, "__pfx_%s", func->name))
 		return -1;
 
-	if (file->klp) {
-		struct symbol *pfx;
-
-		pfx = find_symbol_by_offset(func->sec, func->offset - opts.prefix);
-		if (pfx && is_prefix_func(pfx) && !strcmp(pfx->name, name))
-			return 0;
-	}
-
-	insn = find_insn(file, func->sec, func->offset);
-	if (!insn) {
-		WARN("%s: can't find starting instruction", func->name);
+	if (!elf_create_symbol(file->elf, name, func->sec,
+			       GELF_ST_BIND(func->sym.st_info),
+			       GELF_ST_TYPE(func->sym.st_info),
+			       func->offset - opts.prefix, opts.prefix))
 		return -1;
-	}
-
-	for (prev = prev_insn_same_sec(file, insn);
-	     prev;
-	     prev = prev_insn_same_sec(file, prev)) {
-		u64 offset;
-
-		if (prev->type != INSN_NOP)
-			return 0;
-
-		offset = func->offset - prev->offset;
-
-		if (offset > opts.prefix)
-			return 0;
-
-		if (offset < opts.prefix)
-			continue;
-
-		if (!elf_create_symbol(file->elf, name, func->sec,
-				       GELF_ST_BIND(func->sym.st_info),
-				       GELF_ST_TYPE(func->sym.st_info),
-				       prev->offset, opts.prefix))
-			return -1;
-
-		break;
-	}
-
-	if (!prev)
-		return 0;
-
-	if (!insn->cfi) {
-		/*
-		 * This can happen if stack validation isn't enabled or the
-		 * function is annotated with STACK_FRAME_NON_STANDARD.
-		 */
-		return 0;
-	}
 
 	/* Propagate insn->cfi to the prefix code */
+	insn = find_insn(file, func->sec, func->offset);
+	if (!insn || !insn->cfi)
+		return 0;
+
 	cfi = cfi_hash_find_or_add(insn->cfi);
-	for (; prev != insn; prev = next_insn_same_sec(file, prev))
+	for (prev = find_insn(file, func->sec, func->offset - opts.prefix);
+	     prev && prev != insn;
+	     prev = next_insn_same_sec(file, prev))
 		prev->cfi = cfi;
 
 	return 0;
@@ -4362,15 +4309,20 @@ static int create_prefix_symbol(struct objtool_file *file, struct symbol *func)
 
 static int create_prefix_symbols(struct objtool_file *file)
 {
-	struct section *sec;
+	struct section *pfe_sec;
 	struct symbol *func;
+	struct reloc *reloc;
 
-	for_each_sec(file->elf, sec) {
-		if (!is_text_sec(sec))
+	for_each_sec(file->elf, pfe_sec) {
+		if (strcmp(pfe_sec->name, "__patchable_function_entries"))
+			continue;
+		if (!pfe_sec->rsec)
 			continue;
 
-		sec_for_each_sym(sec, func) {
-			if (create_prefix_symbol(file, func))
+		for_each_reloc(pfe_sec->rsec, reloc) {
+			func = find_func_by_offset(reloc->sym->sec,
+						   reloc->sym->offset + reloc_addend(reloc) + opts.prefix);
+			if (func && create_prefix_symbol(file, func))
 				return -1;
 		}
 	}
-- 
2.53.0


