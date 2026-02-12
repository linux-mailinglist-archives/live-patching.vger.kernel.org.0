Return-Path: <live-patching+bounces-2012-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wHy2B5AojmkMAQEAu9opvQ
	(envelope-from <live-patching+bounces-2012-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 12 Feb 2026 20:22:56 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D0378130AD1
	for <lists+live-patching@lfdr.de>; Thu, 12 Feb 2026 20:22:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C776C30154A0
	for <lists+live-patching@lfdr.de>; Thu, 12 Feb 2026 19:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 351B32D061D;
	Thu, 12 Feb 2026 19:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ttuzR2vi"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C629293C44
	for <live-patching@vger.kernel.org>; Thu, 12 Feb 2026 19:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770924172; cv=none; b=NaKSS7qbmoj0ZoOxZzCqHTNKzvtfqISf222WOGaLFsXA8JoKwGi1IvWeIF6t1kSypIqrmwJYF8TgzSAeXYl+BIJZSuYC82drFvERQhyZNNesRW4WtYCZAql0JXUHvftQVGv//+o5I0U05AYAl44sQyzxoJbSvJ9LtjfJJJJIZLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770924172; c=relaxed/simple;
	bh=VHAIdvMAUVWKE9jRZPNKLFRQSAHOp4Kyjnqy9uv8znI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHPa0nw5rnBy7aNybjyfwBjPgxZvnmkMzGpIcjTT4dzzhhhTuZvXJSo0PgskvCsM3kBVUbsHiE86tWGNa1OidiAzRfGIvEZ40L9CnABJQBdhw6bpWK7vbsXoLyPw/78uC8uCgdzmfmnXjXXS48hqic6XXc3AHWUBhqlKbMUAYoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ttuzR2vi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C51CC4CEF7;
	Thu, 12 Feb 2026 19:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770924171;
	bh=VHAIdvMAUVWKE9jRZPNKLFRQSAHOp4Kyjnqy9uv8znI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ttuzR2viOtmP9BH/c1T3CHWcmdHzTk6jACkK1OIS3fcsxkTZzPycSOUK+QeB6sJr+
	 e92HbiHUKmNmjm5GIXdrkJMGZwb/GbXTdE4VfNLLmsWPSM2Dfxn8rSvNHUXHnbbgEj
	 6f9pJ/hwuOEDW13nXBgPPacrL8Qe05p4pnjFZgjqDzidIqawcOrVphy7Bh1pHU5FIs
	 HnRVyXwvDT6kY/Z42F+eABi4bRk58rS9W6u+ulwdhRyzqlYyBSydbaVdFm0RIMw1f+
	 GhJkP+X+Xm6MncQOqe2pWddVXYM/1Z88wq8mpGBVmHTT2a2RizqE325M9x9O73eAFH
	 lzDu8x86S/8lQ==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH 6/8] objtool/klp: Match symbols based on demangled_name for global variables
Date: Thu, 12 Feb 2026 11:21:59 -0800
Message-ID: <20260212192201.3593879-7-song@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212192201.3593879-1-song@kernel.org>
References: <20260212192201.3593879-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2012-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D0378130AD1
X-Rspamd-Action: no action

correlate_symbols will always try to match full name first. If there is no
match, try match only demangled_name.

In very rare cases, it is possible to have multiple foo.llvm.<hash> in
the same kernel. So this match is not guaranteed to be correct. Show
a warning here so that the user can double check.

Signed-off-by: Song Liu <song@kernel.org>
---
 tools/objtool/elf.c                 | 13 +++++++++++++
 tools/objtool/include/objtool/elf.h |  2 ++
 tools/objtool/klp-diff.c            | 23 +++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index efb13ec0a89d..d26ee877e613 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -323,6 +323,19 @@ struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *nam
 	return NULL;
 }
 
+struct symbol *find_global_symbol_by_demangled_name(const struct elf *elf,
+						    const char *demangled_name)
+{
+	struct symbol *sym;
+
+	elf_hash_for_each_possible(symbol_name, sym, name_hash, str_hash(demangled_name)) {
+		if (!strcmp(sym->demangled_name, demangled_name) && !is_local_sym(sym))
+			return sym;
+	}
+
+	return NULL;
+}
+
 struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *sec,
 				     unsigned long offset, unsigned int len)
 {
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index e12c516bd320..f757850b8ff1 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -186,6 +186,8 @@ struct symbol *find_func_by_offset(struct section *sec, unsigned long offset);
 struct symbol *find_symbol_by_offset(struct section *sec, unsigned long offset);
 struct symbol *find_symbol_by_name(const struct elf *elf, const char *name);
 struct symbol *find_global_symbol_by_name(const struct elf *elf, const char *name);
+struct symbol *find_global_symbol_by_demangled_name(const struct elf *elf,
+						    const char *demangled_name);
 struct symbol *find_symbol_containing(const struct section *sec, unsigned long offset);
 int find_symbol_hole_containing(const struct section *sec, unsigned long offset);
 struct reloc *find_reloc_by_dest(const struct elf *elf, struct section *sec, unsigned long offset);
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 57606bc3390a..cd82f674862a 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -453,6 +453,29 @@ static int correlate_symbols(struct elfs *e)
 			continue;
 
 		sym2 = find_global_symbol_by_name(e->patched, sym1->name);
+		if (!sym2) {
+			/*
+			 * No full name match, try match demangled_name.
+			 * This would match foo.llvm.123 and foo.llvm.456.
+			 *
+			 * Note that, in very rare cases, it is possible
+			 * to have multiple foo.llvm.<hash> in the same
+			 * kernel, e.g., foo.llvm.123 in the original
+			 * kernel, and both foo.llvm.456 and foo.llvm.789
+			 * in the patched kernel. The correlation is not
+			 * guaranteed to be correct in such cases.
+			 *
+			 * Show a warning to remind the user to double
+			 * check the correlation.
+			 */
+
+			sym2 = find_global_symbol_by_demangled_name(e->patched,
+								    sym1->demangled_name);
+			if (sym2) {
+				WARN("correlate %s (origial) to %s (patched)",
+				     sym1->name, sym2->name);
+			}
+		}
 
 		if (sym2 && !sym2->twin) {
 			sym1->twin = sym2;
-- 
2.47.3


