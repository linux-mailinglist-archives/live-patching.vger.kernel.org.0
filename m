Return-Path: <live-patching+bounces-2438-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eM78Kkie6WkAfQIAu9opvQ
	(envelope-from <live-patching+bounces-2438-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:21:28 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 31DE944CE61
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:21:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A19D13111A5F
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C292F3D4105;
	Thu, 23 Apr 2026 04:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TRx94qkc"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D20D337107;
	Thu, 23 Apr 2026 04:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917069; cv=none; b=sxbP8a3F2jIKT1AYDSIuwU1BWup4pnZmA6ufO8KJv0ScZqqpzr8lVBamC9nQ5ypBm+8HW/AezbzINrKxymigCjW4iEC0rz4BNgsJ6DQ0SVWmFHX/oFsNh9Nur6Q5A/g1ONU72/j5mvoXRlFDIgviHC8Lts7ICTkfTHh05O7Qla4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917069; c=relaxed/simple;
	bh=vLGLOGLMn3+R/d2XjxqRW6cGvDuWqyjdilzW6mjwMpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOc8trYCOyatfWJsXxSHUE+6WJl95N3nT0ui/ygcGRISfphm0yqfViwA9ELpzipPHgpGboOGMJYhzQkTwgUTAz68hrZVGTlk/sjhDZEM7AfAupv0Lt/vVFs42DYwt1AMEUlz+y3f8cB0/thhW7iAfkoWW5gAGMsKhmH0gCtEgbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TRx94qkc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5D3C2BCB2;
	Thu, 23 Apr 2026 04:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917069;
	bh=vLGLOGLMn3+R/d2XjxqRW6cGvDuWqyjdilzW6mjwMpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRx94qkcUM1obFtUfNlL3X8/3lfcwjbvfy0ytGsJKHWKsZd767DsJd6v735nDIRN+
	 7shKOEQa5YhtB2FHSRye4Pu15CtVGxwzxBtxzl3CNZgrFOC46BO0KpAZAhkiWyId9I
	 o9ouDVMJEqBdywl+aRssHLG+YZ4Sd8oaO/r2SHzDjjVN7EpXuUcs8z9NhVP/POfy+1
	 ytyVlj+uwwov1Zjh3m5jN+KiGb31ASh1+IBlYWjyqAqQ02nHPYToR+LbLuUIrf0T5C
	 asU+huj+EFhrP5LH7HOYcLbNLIJ1lBIOB1Pk+KuzDRoIxBA4bG6KB7PPwkB9kyYv+n
	 72H8qtt2v7jZw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 11/48] objtool/klp: Fix handling of zero-length .altinstr_replacement sections
Date: Wed, 22 Apr 2026 21:03:39 -0700
Message-ID: <99099e77dffb352f97c5276298ab344c186a3ee2.1776916871.git.jpoimboe@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-2438-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: 31DE944CE61
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

When a section is empty (e.g. only zero-length alternative
replacements), there are no symbols to convert a section symbol
reference to.  Skip the reloc instead of erroring out.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 767716766d41..7f6f86117394 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1020,6 +1020,13 @@ static int convert_reloc_secsym_to_sym(struct elf *elf, struct reloc *reloc)
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
@@ -1280,6 +1287,7 @@ static int clone_sym_relocs(struct elfs *e, struct symbol *patched_sym)
 
 	for_each_reloc(patched_rsec, patched_reloc) {
 		unsigned long offset;
+		int ret;
 
 		if (reloc_offset(patched_reloc) < start ||
 		    reloc_offset(patched_reloc) >= end)
@@ -1293,12 +1301,15 @@ static int clone_sym_relocs(struct elfs *e, struct symbol *patched_sym)
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


