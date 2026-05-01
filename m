Return-Path: <live-patching+bounces-2635-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CMtNFswn9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2635-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:10:52 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C2BDF4AA13A
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:10:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 856F2305FCA4
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E90732A3DA;
	Fri,  1 May 2026 04:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X/ujpJEp"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2292FE579;
	Fri,  1 May 2026 04:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608538; cv=none; b=L7/+m6pJ3vJQpVRuXBQQ/MIzG23NEU9bxAcKdU7elC5xYewbY4nN37jYf5dgBkqdq9qySM3t0CUOu+XYmajsaA6u0oDHFN1KTLehXX/bJa/9PI2PmchFtT/L1820YhjJ3uNqpCXiCLoeaM3z6fsYKxNOU3c04uBEC2K3Dvum3v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608538; c=relaxed/simple;
	bh=3Cgl/k80HbhHMq6p97AxTmNaySd47AXzO0dWEwccxCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Af9cJ5Tvzt6IZ8GFe2aAxZfj3oSy7DUwSggvQZeb7g5nxfY6Hbn94NOVVANyZC+WWGhqps5Kq9q8qq/wKNHJgSPr4zRhgoYR2WpWfUEZr+FV//YS1t9o/Nbm9RyDRYlfn5FH6VAbtsrmbiO54MFqNLQAH9/uxybXFzra517zfoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X/ujpJEp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2541C2BCB7;
	Fri,  1 May 2026 04:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608538;
	bh=3Cgl/k80HbhHMq6p97AxTmNaySd47AXzO0dWEwccxCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X/ujpJEphJ5hNsqCwfa4FxBrdGCJVrqMsGiJnj4t4FxzP560WlKdRFc+/JD7Bl2bu
	 7bvh0OvSxHxyLcav7+Gtz/3j8GgTATC+bBZjh2s0aaUoLKZzOpGHX5UczIAMsyGV5n
	 hzVcYBya97om9ZLPy1HOCMJ92dYDRA5iSAPHLSRWX1WrzskK37dc2qhnbMSnNHTUV2
	 NFJNimcWfzTUlNZcs4XbukQGPP5JsCID7VWqBE8+LNIJMNfjDegoKu7i09d/I0qq+8
	 FCgqCCFNotuVLir6gxojEnXWkw9+NN5GOQfxoOIn3sKyMoht0DBcsVrAhGHV3mHc1D
	 o4AeDeMxCvVMA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 17/53] objtool: Move mark_rodata() to elf.c
Date: Thu, 30 Apr 2026 21:08:05 -0700
Message-ID: <1462986f6b02ad95ac87115b5ddcc5260c036faf.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: C2BDF4AA13A
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
	TAGGED_FROM(0.00)[bounces-2635-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

Move the sec->rodata marking from check.c to elf.c so it's set during
ELF reading rather than during the check pipeline.  This makes the
rodata flag available to all objtool users, including klp-diff which
reads ELF files directly without running check().

Add an is_rodata_sec() helper to elf.h for consistency with
is_text_sec() and is_string_sec().

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c               | 11 +++--------
 tools/objtool/elf.c                 | 13 +++++++++++++
 tools/objtool/include/objtool/elf.h |  5 +++++
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index e3604b1201f9..e7579c4e46dc 100644
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
index dc39132f71c1..87c6e00749c6 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -1138,6 +1138,17 @@ static int read_relocs(struct elf *elf)
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
@@ -1188,6 +1199,8 @@ struct elf *elf_open_read(const char *name, int flags)
 	if (read_sections(elf))
 		goto err;
 
+	mark_rodata(elf);
+
 	if (read_symbols(elf))
 		goto err;
 
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 00b04029023e..ab5f7017ec34 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -317,6 +317,11 @@ static inline bool is_text_sec(struct section *sec)
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


