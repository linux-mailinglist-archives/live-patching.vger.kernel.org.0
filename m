Return-Path: <live-patching+bounces-2461-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id APT/KQ2c6WlgfAIAu9opvQ
	(envelope-from <live-patching+bounces-2461-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:11:57 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 897CD44CC7B
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:11:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 32391300FEE7
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:08:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45DDC3DBD48;
	Thu, 23 Apr 2026 04:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BwoG2ZMD"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BCD3DB65C;
	Thu, 23 Apr 2026 04:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917081; cv=none; b=Flm6UQHlHNRFQhbpgP+s1jEeACnns0GZNnqWI4M2cDkqs2REDr2bA7AOkci0ai9qNkcrdFUoo8h4Ko1ZlK2uWeFDS+mqychb4L9kuR/Efs2psRhTy5hs3dE5gkROP6BVrjSvnl6Voy/4WrqjVf3ShbLbcbg79n/p61U94ppYkVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917081; c=relaxed/simple;
	bh=kwelDbqX8+gKK6dbL+lWyI5iAhkQ0lkBTLIv2bxDSQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0iAuWiHHCJUndsxQYH9vGBTNRZTDl4nxNXRmP1yvm8edtWaqCVcDAi4xijKkObzyp8rDaj5tiUPkUV3jeK8WuCXjrRRoO27uDv6xpY1VYTwo5R3PTbt97wd5EwzoHufFh8yoUXr5yfgCpDZA5d/Yo/DVAO42v3DqfuZneUhB9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BwoG2ZMD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2CEC2BCB2;
	Thu, 23 Apr 2026 04:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917080;
	bh=kwelDbqX8+gKK6dbL+lWyI5iAhkQ0lkBTLIv2bxDSQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BwoG2ZMDfvZcKFKOY5T087PGCTED4dTs6Mm1wSEgU0LvfrE6S7K61vokrKzA8C5er
	 A4PKpfWBKcKWOJsspMy/w64JRDSFy/Zormb0tkrDheUP40fy3WFvr+J8fWbNCYaLao
	 ESQCC44PlFGoJCZgeZYYU5ocnB8HTk5idbJ4xdiUfpSwf2c/P69NI9yaNbKRetqsvg
	 IgXuROd6cNej3bDcY9+VJTbtlBZIAr80xb0cxzQtlpd3XabLuMdIWbiQ+0zyl8FRdD
	 ZvINGtcaOTvPQ3RznDIIQWIiBXRlrcwlV1tBDvM+NdGaOMZcd/7izAh2POuahuxSd8
	 qXsUauhTXlzWw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 34/48] objtool: Consolidate file decoding into decode_file()
Date: Wed, 22 Apr 2026 21:04:02 -0700
Message-ID: <1b6557569cbdf893b832c37ba16dafaf69f9c3f6.1776916871.git.jpoimboe@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-2461-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: 897CD44CC7B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

decode_sections() relies on CFI and cfi_hash initialization done
separately in check(), making it unusable outside of check().

Consolidate the initialization into decode_sections() and rename it to
decode_file(), and make it global along with free_insns() and
insn_reloc() for use by other objtool components -- namely, the checksum
code which will be moving to another file.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c                 | 36 +++++++++++++--------------
 tools/objtool/include/objtool/check.h |  5 ++++
 2 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index c8208caa4b2c..17cb9265973d 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1346,7 +1346,7 @@ __weak bool arch_is_embedded_insn(struct symbol *sym)
 	return false;
 }
 
-static struct reloc *insn_reloc(struct objtool_file *file, struct instruction *insn)
+struct reloc *insn_reloc(struct objtool_file *file, struct instruction *insn)
 {
 	struct reloc *reloc;
 
@@ -2633,8 +2633,21 @@ static bool alts_needed(void)
 	       opts.checksum;
 }
 
-static int decode_sections(struct objtool_file *file)
+int decode_file(struct objtool_file *file)
 {
+	arch_initial_func_cfi_state(&initial_func_cfi);
+	init_cfi_state(&init_cfi);
+	init_cfi_state(&func_cfi);
+	set_func_state(&func_cfi);
+	init_cfi_state(&force_undefined_cfi);
+	force_undefined_cfi.force_undefined = true;
+
+	if (!cfi_hash_alloc(1UL << (file->elf->symbol_bits - 3)))
+		return -1;
+
+	cfi_hash_add(&init_cfi);
+	cfi_hash_add(&func_cfi);
+
 	file->klp = is_livepatch_module(file);
 
 	mark_rodata(file);
@@ -5002,7 +5015,7 @@ struct insn_chunk {
  * which can trigger more allocations for .debug_* sections whose data hasn't
  * been read yet.
  */
-static void free_insns(struct objtool_file *file)
+void free_insns(struct objtool_file *file)
 {
 	struct instruction *insn;
 	struct insn_chunk *chunks = NULL, *chunk;
@@ -5049,22 +5062,7 @@ int check(struct objtool_file *file)
 		objtool_disas_ctx = disas_ctx;
 	}
 
-	arch_initial_func_cfi_state(&initial_func_cfi);
-	init_cfi_state(&init_cfi);
-	init_cfi_state(&func_cfi);
-	set_func_state(&func_cfi);
-	init_cfi_state(&force_undefined_cfi);
-	force_undefined_cfi.force_undefined = true;
-
-	if (!cfi_hash_alloc(1UL << (file->elf->symbol_bits - 3))) {
-		ret = -1;
-		goto out;
-	}
-
-	cfi_hash_add(&init_cfi);
-	cfi_hash_add(&func_cfi);
-
-	ret = decode_sections(file);
+	ret = decode_file(file);
 	if (ret)
 		goto out;
 
diff --git a/tools/objtool/include/objtool/check.h b/tools/objtool/include/objtool/check.h
index 5f2f77bd9b41..6489e52ea2f2 100644
--- a/tools/objtool/include/objtool/check.h
+++ b/tools/objtool/include/objtool/check.h
@@ -155,6 +155,11 @@ struct instruction *next_insn_same_sec(struct objtool_file *file, struct instruc
 	     insn && insn->offset < sym->offset + sym->len;		\
 	     insn = next_insn_same_sec(file, insn))
 
+struct reloc *insn_reloc(struct objtool_file *file, struct instruction *insn);
+
+int decode_file(struct objtool_file *file);
+void free_insns(struct objtool_file *file);
+
 const char *objtool_disas_insn(struct instruction *insn);
 
 extern size_t sym_name_max_len;
-- 
2.53.0


