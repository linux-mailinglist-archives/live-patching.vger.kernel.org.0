Return-Path: <live-patching+bounces-2465-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wCWoK0Cc6Wm3ewIAu9opvQ
	(envelope-from <live-patching+bounces-2465-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:12:48 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5485D44CCA8
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:12:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CC192306B270
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:08:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBCCD3DCD80;
	Thu, 23 Apr 2026 04:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nZTuU3K3"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C325D3DC4D7;
	Thu, 23 Apr 2026 04:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917083; cv=none; b=AWtmoRulD+5vzlOXSNi6I8WokGnCLB7mhjKD5VxNco4rF+9ptMJxZsE+4VzsEWi25Jlg7ZEVbat6Yk0C/LkT4Z4PU8vDoWY5KAPo7j5XQxIQewCkRURDgZcxRKuhvq+uSdxabf85GYLnFcoVt2uoUctD+RG6vsVVXvc9PyvhEJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917083; c=relaxed/simple;
	bh=pu/FDwgsFYcunTKMSHAiFW7k0utTyQ1Y/HhIEU5kLD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gef7H1srOljz8i3fmApGwDbECKr9tU0ySMfByx5eLkRcAULPkTnlslNyp6tXzovul0ereaC5tR4BZgY4+cwKhN5TlavwQrM24RHbjfnVLtiMMsXtZupWr2I4VpHqArZW8d2V3hDv00+VSI6EwHfmA6Kihp/mraUpBiIUb7IUVXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nZTuU3K3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05612C2BCC4;
	Thu, 23 Apr 2026 04:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917083;
	bh=pu/FDwgsFYcunTKMSHAiFW7k0utTyQ1Y/HhIEU5kLD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZTuU3K3bwi2vviefcyLAlSKZwJjGC1BUgZiQZpzBgd2gADC11RARsh/t6DS+l0b7
	 ++rsuh1DBX6lgS5Pq4bCeNmM6wpf67lSdXFLw6G3PgUM5gXp5ts2So20tViXD0P4vr
	 0rlneApSEpHym3fs4ngPsASGSXVh2Pf1XWe+cAjNOrBsoyvlBAwTSe/0NZ2g2mifzY
	 wzV42QxYXaaboEHPtk8X9D3yJw1bWZR9N0BTNCV0hTRBrxsu2ZhC2UbUp7MwjjDmXZ
	 cw2yT4cmk+1Ss0J9Y+VJ3ZPu+5gFVfel9hdMh9r1g+JiKWVsF/92lJ9rYbwYjoWIBu
	 xI2FFf8G1K6YQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 38/48] klp-build: Validate short-circuit prerequisites
Date: Wed, 22 Apr 2026 21:04:06 -0700
Message-ID: <338295e0bf3353dd62536df672a2615f72be013b.1776916871.git.jpoimboe@kernel.org>
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
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2465-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 5485D44CCA8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The --short-circuit option implicitly requires that certain directories
are already in klp-tmp.  Enforce that to prevent confusing errors.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index eda690b297cc..b44924d097a5 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -440,6 +440,20 @@ do_init() {
 	[[ ! "$SRC" -ef "$SCRIPT_DIR/../.." ]] && die "please run from the kernel root directory"
 	[[ ! "$OBJ" -ef "$SCRIPT_DIR/../.." ]] && die "please run from the kernel root directory"
 
+	if (( SHORT_CIRCUIT >= 2 )); then
+		[[ -f "$ORIG_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $ORIG_DIR"
+		if (( SHORT_CIRCUIT >= 3 )); then
+			[[ -f "$PATCHED_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $PATCHED_DIR"
+			if (( SHORT_CIRCUIT >= 4 )); then
+				[[ -f "$ORIG_CSUM_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $ORIG_CSUM_DIR"
+				[[ -f "$PATCHED_CSUM_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $PATCHED_CSUM_DIR"
+				if (( SHORT_CIRCUIT >= 5 )); then
+					[[ -f "$DIFF_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $DIFF_DIR"
+				fi
+			fi
+		fi
+	fi
+
 	(( SHORT_CIRCUIT <= 1 )) && rm -rf "$TMP_DIR"
 	mkdir -p "$TMP_DIR"
 
@@ -601,6 +615,7 @@ copy_orig_objects() {
 
 	mv -f "$TMP_DIR/build.log" "$ORIG_DIR"
 	touch "$TIMESTAMP"
+	touch "$ORIG_DIR/.complete"
 }
 
 # Copy all changed objects to $PATCHED_DIR
@@ -639,6 +654,7 @@ copy_patched_objects() {
 	(( found == 0 )) && die "no changes detected"
 
 	mv -f "$TMP_DIR/build.log" "$PATCHED_DIR"
+	touch "$PATCHED_DIR/.complete"
 }
 
 # Copy .o files to a separate directory and run "objtool klp checksum" on each
@@ -720,6 +736,8 @@ diff_objects() {
 				die "objtool klp diff failed"
 		)
 	done
+
+	touch "$DIFF_DIR/.complete"
 }
 
 # For each changed object, run "objtool klp checksum" with --debug-checksum to
-- 
2.53.0


