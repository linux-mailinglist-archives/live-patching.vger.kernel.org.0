Return-Path: <live-patching+bounces-2432-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KBlgE2+a6Wm0egIAu9opvQ
	(envelope-from <live-patching+bounces-2432-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:05:03 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 2022344CADC
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:05:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 86428300A30A
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DD323CEB80;
	Thu, 23 Apr 2026 04:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HGGXrATR"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABF73CE493;
	Thu, 23 Apr 2026 04:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917066; cv=none; b=en13oUU/BGzG8AnVOdes1TPyR9+w+wk4nwSdQOaGo4hJ93R12OLD5ZTXSrt5YV5LayBstGSMUCDRN6rp9dZC2Qgbi8D9VjclAu2+oNxZVA0/2wOXmYrRFN+c0bLOG2tTJEKI49jbno8LY4OugBVzkTWzaD13hobpXhAeHOznhkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917066; c=relaxed/simple;
	bh=ugHeCutv5a7BLLAyhgSmNXWzhfKrZRVBZiPfR6m9uQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVYnv00y/jsZBzRMQyMZGL1aeFP7rwR/40FZoLQYHNkr5Zf9D6HO56s0DWg9AQuq/SRt3Hr5NlMdFw2/Vgf+QRaJA4JToBQ0pDWYTCJnW9km9SsGUlDJtjCE4gD1jxfmHp0zEfC9SMwiFjJzQqUGtegCeUjZXLrqeKmoxM0iYEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HGGXrATR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7948C2BCB5;
	Thu, 23 Apr 2026 04:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917066;
	bh=ugHeCutv5a7BLLAyhgSmNXWzhfKrZRVBZiPfR6m9uQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HGGXrATRJK551pU1DVlQhCmfzQEuln84NTfxhxnOl/UvTIjJTTxsvkmBw43oIazrl
	 PDVMEAX9gOk0v/1AVGfvFUkmSgKEo70IVCoRK/60gbOx3vLMrJ93c5myeRWJk3k/u5
	 xx8WVwlCMN0zkvnBw3xOtbQOwbYaU1x8JioWh0NVRTHl912mGEs6pJpUqodKMEeiHq
	 nyDXprCadM46yb1BIwSmE7Esbi39Q27MPXNfK+rn3ibkOnOHJEL4BpMnoOzIBEluVb
	 gwxFfGuciLL9ig9WO4dJkP6qRdJENKpEKsFrIoU26sC+giePFfW/u375LqfzO3gRz5
	 uQwieM5bZaeFA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 05/48] objtool: Move mark_rodata() to elf.c
Date: Wed, 22 Apr 2026 21:03:33 -0700
Message-ID: <c32b3d8d0770c93f8c0d8e4a989f2f43c29e9a5f.1776916871.git.jpoimboe@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2432-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2022344CADC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Move the sec->rodata marking from check.c to elf.c so it's set during
ELF reading rather than during the check pipeline.  This makes the
rodata flag available to all objtool users, including klp-diff which
reads ELF files directly without running check().

Add an is_rodata_sec() helper to elf.h for consistency with
is_text_sec() and is_string_sec().

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c               | 11 +++--------
 tools/objtool/elf.c                 | 13 +++++++++++++
 tools/objtool/include/objtool/elf.h |  5 +++++
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 9b11cf3193b9..5722d4568401 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2566,7 +2566,6 @@ static int classify_symbols(struct objtool_file *file)
 static void mark_rodata(struct objtool_file *file)
 {
 	struct section *sec;
-	bool found = false;
 
 	/*
 	 * Search for the following rodata sections, each of which can
@@ -2579,15 +2578,11 @@ static void mark_rodata(struct objtool_file *file)
 	 * .rodata.str1.* sections are ignored; they don't contain jump tables.
 	 */
 	for_each_sec(file->elf, sec) {
-		if ((!strncmp(sec->name, ".rodata", 7) &&
-		     !strstr(sec->name, ".str1.")) ||
-		    !strncmp(sec->name, ".data.rel.ro", 12)) {
-			sec->rodata = true;
-			found = true;
+		if (is_rodata_sec(sec)) {
+			file->rodata = true;
+			return;
 		}
 	}
-
-	file->rodata = found;
 }
 
 static void mark_holes(struct objtool_file *file)
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index f3df2bde119f..ac9da81a7a2f 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -1172,6 +1172,17 @@ static int read_relocs(struct elf *elf)
 	return 0;
 }
 
+static void mark_rodata(struct elf *elf)
+{
+	struct section *sec;
+
+	for_each_sec(elf, sec) {
+		if ((strstarts(sec->name, ".rodata") && !strstr(sec->name, ".str1.")) ||
+		    strstarts(sec->name, ".data.rel.ro"))
+			sec->rodata = true;
+	}
+}
+
 struct elf *elf_open_read(const char *name, int flags)
 {
 	struct elf *elf;
@@ -1222,6 +1233,8 @@ struct elf *elf_open_read(const char *name, int flags)
 	if (read_sections(elf))
 		goto err;
 
+	mark_rodata(elf);
+
 	if (read_symbols(elf))
 		goto err;
 
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 25573e5af76e..c61bd57767f9 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -296,6 +296,11 @@ static inline bool is_text_sec(struct section *sec)
 	return sec->sh.sh_flags & SHF_EXECINSTR;
 }
 
+static inline bool is_rodata_sec(struct section *sec)
+{
+	return sec->rodata;
+}
+
 static inline bool sec_changed(struct section *sec)
 {
 	return sec->_changed;
-- 
2.53.0


