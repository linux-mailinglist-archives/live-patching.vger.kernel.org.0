Return-Path: <live-patching+bounces-2441-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aJpuB1ie6WkAfQIAu9opvQ
	(envelope-from <live-patching+bounces-2441-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:21:44 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D50B44CE72
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:21:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B50FF311B310
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A7733D47D9;
	Thu, 23 Apr 2026 04:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jE1GO0Qx"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053CF3D5221;
	Thu, 23 Apr 2026 04:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917071; cv=none; b=Jbo1+Q2K7fIlcOcainFSuN7g1XbatEYfk05LdY71n3MdPSA0dKfxLMafFH1VGtiPurYkV1StpLpieMYUxVF0zQwcCOocsjhy9mRsZw4XurOjoWizeIbKYbAzDQMS5oN9U9P4WVZeBd4oS//Pjz6itRxHxBQ3miGMbGE716rpKME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917071; c=relaxed/simple;
	bh=LKvhLrcHURxd3W/qU1rasqzFGdBHUvsFoEIkyy4Mb8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtAJ9LRh3LAJjTzXPQYJW+ULS/nHRBZZftlyopLKg964CmYkAk/cmCN7JYFLjgG/IuHiX0mcGoxRj3O/GFKDu7VVEXDuY8ipmb7b5MooqSx/xmy/Oqn1nnQ6Lku8RkNhA+nDnI887u5k4DAhF38ExH3yVnH4CPWpIZoC4c1Xnww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jE1GO0Qx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E2FC2BCB5;
	Thu, 23 Apr 2026 04:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917070;
	bh=LKvhLrcHURxd3W/qU1rasqzFGdBHUvsFoEIkyy4Mb8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jE1GO0Qx29cBxaWwjd1HT8uX0hHmetXbzBybGhea+So6PxHq2TeZBLsB6ehYTa5jC
	 BY+Ye6tf1OorGxQqUNeMGeqvLhkAQd4dvkPunW30ETIMx57s4EyxoMe7WNnvCPUcOx
	 lvT7UC1iMV1aqbMoMdjgy079w9nj+ePnIq2PCnl5uiU2XohBk7wTHzjzidT/fBI2dg
	 RikdFrMicNgcDsY+zF+i/ZN4SOIlx4FkdE8mc4zfUicDjbMAqc8n/OByeIyFN5avfG
	 39ncUmIy8yHOoFZ59XTQPcfFKn1njxiJXF47WX439KLeLraalFefqhr/JeyphrJFIT
	 mOANcLTZsCAWA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 14/48] objtool/klp: Fix extraction of text annotations for alternatives
Date: Wed, 22 Apr 2026 21:03:42 -0700
Message-ID: <5e67de043745aec66abf963edbd74d13c5ea142a.1776916871.git.jpoimboe@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2441-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6D50B44CE72
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Objtool is failing to extract text annotations which reference
.altinstr_replacement instructions:

  1) Alternative replacement fake symbols are NOTYPE rather than FUNC,
     and they don't have sym->included set, thus they aren't recognized
     by should_keep_special_sym().

  2) .discard.annotate_insn gets processed before .altinstr_replacement,
     so the referenced (fake) symbols don't have clones yet.

Fix the first issue by checking for a valid clone instead of
sym->included and by accepting NOTYPE symbols when processing
.discard.annotate_insn.

Fix the second issue by deferring text annotation processing until after
the other special sections have been cloned.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 3303664a39d7..22942f394745 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1452,6 +1452,7 @@ static int create_fake_symbols(struct elf *elf)
 /* Keep a special section entry if it references an included function */
 static bool should_keep_special_sym(struct elf *elf, struct symbol *sym)
 {
+	bool annotate_insn = !strcmp(sym->sec->name, ".discard.annotate_insn");
 	struct reloc *reloc;
 
 	if (is_sec_sym(sym) || !sym->sec->rsec)
@@ -1461,7 +1462,16 @@ static bool should_keep_special_sym(struct elf *elf, struct symbol *sym)
 		if (convert_reloc_sym(elf, reloc))
 			continue;
 
-		if (is_func_sym(reloc->sym) && reloc->sym->included)
+		if (!reloc->sym->clone || is_undef_sym(reloc->sym->clone))
+			continue;
+
+		/*
+		 * Keep special section references to cloned functions.
+		 * In some cases annotate_insn can also reference cloned alt
+		 * replacement fake symbols; keep those references as well.
+		 */
+		if (is_func_sym(reloc->sym) ||
+		    (annotate_insn && is_notype_sym(reloc->sym)))
 			return true;
 	}
 
@@ -1605,15 +1615,28 @@ static int clone_special_section(struct elfs *e, struct section *patched_sec)
 /* Extract only the needed bits from special sections */
 static int clone_special_sections(struct elfs *e)
 {
-	struct section *patched_sec;
+	struct section *sec, *annotate_insn = NULL;
 
-	for_each_sec(e->patched, patched_sec) {
-		if (is_special_section(patched_sec)) {
-			if (clone_special_section(e, patched_sec))
+	for_each_sec(e->patched, sec) {
+		if (is_special_section(sec)) {
+			if (!strcmp(sec->name, ".discard.annotate_insn")) {
+				annotate_insn = sec;
+				continue;
+			}
+			if (clone_special_section(e, sec))
 				return -1;
 		}
 	}
 
+	/*
+	 * Do .discard.annotate_insn last, it can reference other special
+	 * sections (alt replacements) so they need to be cloned first.
+	 */
+	if (annotate_insn) {
+		if (clone_special_section(e, annotate_insn))
+			return -1;
+	}
+
 	return 0;
 }
 
-- 
2.53.0


