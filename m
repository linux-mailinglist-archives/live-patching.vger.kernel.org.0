Return-Path: <live-patching+bounces-2629-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AM9jCTco9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2629-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:12:39 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 79C2C4AA1BF
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:12:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 79523305BAA3
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:09:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4004314D37;
	Fri,  1 May 2026 04:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lLf5jVpd"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4F53148B5;
	Fri,  1 May 2026 04:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608535; cv=none; b=e449aDWjfkcCz50ey2C2R1NDwmDh5fGsZeFfDfL3ld07mTfc83iEi6m4s2nI0b+/mJzi/JLMPYwEUd+arX9CfNoRZYkIFS4UFMTyzUjnkela5PlYYHHS3faenKgqfUmbM/loX+UfT7+6GqRpK5CW4nAkwSiYrv98qi4lqbk1kxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608535; c=relaxed/simple;
	bh=1MDEzI3Nle2lKZXTUSbVIrCvlFXpF+YXjQJda5aqVt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbuL4+GY3kcqJbb716CJjU+OXy9X/4RDp+bXp2FTx/JF8SpNVrx/FbrEQGZkSrVTApm8QF/HX8C4U2gGkuEZxwbD7fSuv5v7OpFz5IsFUxcDO2MX4n4E7QhXAOYT4v+ZkObsFgBO+22si0HZ2PTppyoN+m/iBZT/ACVgPGZnnDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lLf5jVpd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CD4C2BCFD;
	Fri,  1 May 2026 04:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608535;
	bh=1MDEzI3Nle2lKZXTUSbVIrCvlFXpF+YXjQJda5aqVt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lLf5jVpdcQC7cXR6Fq96WXy/So4qfDmqfzuw8oILFU5NUAL0FSZ+Bl5eCECnGZUrx
	 oMBadNg/72EcohP4qqAsH2FyvevlY/oxc5pN3wpQJ+5ErUJKHCOlLaP3JaF0AJc3gw
	 lRdzgoFBGS76uhtILlOSCkgxr0Wj70h3zY297gIo7LiQ914B4omPJ1K+5/gqpnkfJm
	 l0dh3KLUjIqYfa4xzysxjIAaJ1CNfHtT2jPxP9GUHD+9ICnn2g1tUAJHVcS+hhPsAL
	 LlrJWKRHkZ1HDIO62JBQHnyEpX9RW0cHw7T3eVHAZQfxdixhDDcR/02FpbWZRRns1t
	 UJUyK6TGjfIoQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 11/53] objtool/klp: Fix handling of zero-length .altinstr_replacement sections
Date: Thu, 30 Apr 2026 21:07:59 -0700
Message-ID: <f44069ed907f82e687c4f2ae02b5ffe55c5ca9dc.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: 79C2C4AA1BF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
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
	TAGGED_FROM(0.00)[bounces-2629-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

When a section is empty (e.g. only zero-length alternative
replacements), there are no symbols to convert a section symbol
reference to.  Skip the reloc instead of erroring out.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 30ce234e01a1..a226e99948b3 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1005,6 +1005,13 @@ static int convert_reloc_secsym_to_sym(struct elf *elf, struct reloc *reloc)
 	/* No dedicated section; find the symbol manually */
 	sym = find_symbol_containing(sec, arch_adjusted_addend(reloc));
 	if (!sym) {
+		/*
+		 * This is presumably an .altinstr_replacement section which is
+		 * empty due to it only having zero-length replacement(s).
+		 */
+		if (!sec_size(sec))
+			return 1;
+
 		/*
 		 * This can happen for special section references to weak code
 		 * whose symbol has been stripped by the linker.
@@ -1265,6 +1272,7 @@ static int clone_sym_relocs(struct elfs *e, struct symbol *patched_sym)
 
 	for_each_reloc(patched_rsec, patched_reloc) {
 		unsigned long offset;
+		int ret;
 
 		if (reloc_offset(patched_reloc) < start ||
 		    reloc_offset(patched_reloc) >= end)
@@ -1278,12 +1286,15 @@ static int clone_sym_relocs(struct elfs *e, struct symbol *patched_sym)
 		    !strcmp(patched_reloc->sym->sec->name, ".altinstr_aux"))
 			continue;
 
-		if (convert_reloc_sym(e->patched, patched_reloc)) {
+		ret = convert_reloc_sym(e->patched, patched_reloc);
+		if (ret < 0) {
 			ERROR_FUNC(patched_rsec->base, reloc_offset(patched_reloc),
 				   "failed to convert reloc sym '%s' to its proper format",
 				   patched_reloc->sym->name);
 			return -1;
 		}
+		if (ret > 0)
+			continue;
 
 		offset = out_sym->offset + (reloc_offset(patched_reloc) - patched_sym->offset);
 
-- 
2.53.0


