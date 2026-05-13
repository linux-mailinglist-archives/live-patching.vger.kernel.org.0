Return-Path: <live-patching+bounces-2782-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gPTOJRLzA2prBAIAu9opvQ
	(envelope-from <live-patching+bounces-2782-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:42:10 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F0B1452CE2E
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:42:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4D75030A9E4C
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 03:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8CE13AC0D7;
	Wed, 13 May 2026 03:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hA06cJnD"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC7E3A4257;
	Wed, 13 May 2026 03:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778643291; cv=none; b=G+rILZlhkQGmItYezR67Fs4mUQuoaG9Zjr+2asMXSS+JWtdfyofqTZeZ62WmRkEqxSFXH7Wlbsoyp0HhptNfNwWmGUR8h6JnA3isHkyIdcX3cJupn0WsmRWYXdqAygLmRQYNe/MNIDZOFmf62/G/S88yS3Gb7tB7UGHXUfBz9rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778643291; c=relaxed/simple;
	bh=voedLEVhufD2EC2qnX2retheCvvJ6sgwG1j/M2rJ6o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Inqwj1zXiWSCTW9C7y6j+/ywxZZKCNMprMV98kQKjpp/fXQRVp1t0JcknHyKSflw5kbB0OxSMb+y5JpQWUZHs5QoBvcttYQc5UNLrbKoubm0raT0/SE27Rh2H1NboiR3CejwHqv049Y43p4iy/tzTrXw7ijTe0sG5tUhpw1UR2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hA06cJnD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F3CC2BCFB;
	Wed, 13 May 2026 03:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778643291;
	bh=voedLEVhufD2EC2qnX2retheCvvJ6sgwG1j/M2rJ6o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hA06cJnDIUfmXB/3JBgPXTt/tPmcVQStNmHqYSgYdqyZK1z0fhnA5E1Wg+3OSwk4a
	 l8+c9EEraTlHhcNn7ogPeQ/SxzRmhMbzbhv5S5t+feNsOaX+Kpu2J0K4LNjATTU4+X
	 Hsv7TAQEP9qJYXyTOZnWW8Io2lS2QDF3YQ6h7tScpWhbeD2JBV8QITnFwehBfkuSYh
	 p46H1xKZh9y+H9uzV/VPpcoRn3KpKS80XEnstUKE19kRTS2KmXnsYyDhAyzGzSAOn/
	 NxWt21EH45/0Jg707+N2zxMaWD/QGFatK5a9YDhSE1a5Fy/JXEp9CvMx/87hyCf7/R
	 fKGB57IpVN9Bg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v3 10/21] objtool: Ignore jumps to the end of the function for checksum runs
Date: Tue, 12 May 2026 20:34:06 -0700
Message-ID: <b3b58101e15e1bb5266e57134f0b65f7d8efdd4b.1778642120.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1778642120.git.jpoimboe@kernel.org>
References: <cover.1778642120.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F0B1452CE2E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2782-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

Sometimes Clang arm64 code jumps to the end of the function for UB.
No need to make that an error for checksum runs.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 10b18cf9c3608..73451aef68029 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -37,6 +37,22 @@ struct disas_context *objtool_disas_ctx;
 
 size_t sym_name_max_len;
 
+static bool validate_branch_enabled(void)
+{
+	return opts.stackval	||
+	       opts.orc		||
+	       opts.uaccess;
+}
+
+static bool alts_needed(void)
+{
+	return validate_branch_enabled()	||
+	       opts.noinstr			||
+	       opts.hack_jump_label		||
+	       opts.disas			||
+	       opts.checksum;
+}
+
 struct instruction *find_insn(struct objtool_file *file,
 			      struct section *sec, unsigned long offset)
 {
@@ -1593,10 +1609,14 @@ static int add_jump_destinations(struct objtool_file *file)
 			/*
 			 * GCOV/KCOV dead code can jump to the end of
 			 * the function/section.
+			 *
+			 * Clang on arm64 also does this sometimes for
+			 * undefined behavior.
 			 */
-			if (file->ignore_unreachables && func &&
-			    dest_sec == insn->sec &&
-			    dest_off == func->offset + func->len)
+			if (!validate_branch_enabled() ||
+			    (file->ignore_unreachables && func &&
+			     dest_sec == insn->sec &&
+			     dest_off == func->offset + func->len))
 				continue;
 
 			ERROR_INSN(insn, "can't find jump dest instruction at %s",
@@ -2584,22 +2604,6 @@ static void mark_holes(struct objtool_file *file)
 	}
 }
 
-static bool validate_branch_enabled(void)
-{
-	return opts.stackval	||
-	       opts.orc		||
-	       opts.uaccess;
-}
-
-static bool alts_needed(void)
-{
-	return validate_branch_enabled()	||
-	       opts.noinstr			||
-	       opts.hack_jump_label		||
-	       opts.disas			||
-	       opts.checksum;
-}
-
 int decode_file(struct objtool_file *file)
 {
 	arch_initial_func_cfi_state(&initial_func_cfi);
-- 
2.53.0


