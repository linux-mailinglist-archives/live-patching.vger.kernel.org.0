Return-Path: <live-patching+bounces-2661-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id II9FC2Qp9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2661-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:17:40 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F1814AA31A
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:17:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9C845306C3CD
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:11:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1594E37269C;
	Fri,  1 May 2026 04:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k7DBzBml"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D95371860;
	Fri,  1 May 2026 04:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608551; cv=none; b=IYxOTljLKfkuGupWNw37J5JyYsYQUmCYx1m3cNmRgJKNw1H9EslSRETkladAdLg6VLinjXyr5mMuSbFOUFdzdnsUENNInJCosRMzYy6OVmNXVIkIHVZ+vXYQPfYTIiWwGuJk+8mh6yMQLg/0W3h9PAABo0Xk7Ir5yifM4DY5zcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608551; c=relaxed/simple;
	bh=skBrr+d0x5OlbzSPiRUmEpwwkkQKh50vJi5udw4p/z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPikooPbk94xAlfxn0NfK7JzU1sRbsDdTZiDhj5f8NE7qWt6eZ5W5JtSYIzIgOytoGP70tGGxK8d7tv4py1c318D6R5GaR9M8t6FcShzQHSiFvLKO/Ycr0gUZiVUmuAyBqVDqemVXsaCIR1/yVv7WRu3B6C7IFWXqptwEEbPbbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k7DBzBml; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F25C2BCC6;
	Fri,  1 May 2026 04:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608550;
	bh=skBrr+d0x5OlbzSPiRUmEpwwkkQKh50vJi5udw4p/z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7DBzBmly+j4UDzTMfYvTIabhC7DUTV8tZaJtqq0peOSDZIzmTUHiFMXr/3qeXUk+
	 uW6cxD8N+/6N1yOiwE/kfbQgDxkRAKkU7FjoJEnspdS8YO3jWuaAnuj/8PS+zYC7xv
	 OwlJFN+roWHEE9sDpsGqr4hc8cEMDRUmpHac8KRh9nCOuWtqge6g9IN57TxK1/tmLo
	 sMwp57+crUzcrnYlGPc6dBwuLcu2HCEnx+TfOOEZmv0cFMnusrjcbe83MZAYO26pj/
	 tBzjCiOOL7cqqGFuLn3biZFNM+A199yQay9ebcjOOcYjzfmX9cHgRspQ3QppC4RyVB
	 PcVBUd+dhlQHA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 44/53] klp-build: Validate short-circuit prerequisites
Date: Thu, 30 Apr 2026 21:08:32 -0700
Message-ID: <ec40bb551a583c7a7c329199e41d21a0f086775c.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: 9F1814AA31A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2661-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

The --short-circuit option implicitly requires that certain directories
are already in klp-tmp.  Enforce that to prevent confusing errors.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index f8a80ad0f829..3adb2a7fd9c1 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -437,6 +437,20 @@ do_init() {
 	# builds in pwd.
 	[[ ! "$PWD" -ef "$SCRIPT_DIR/../.." ]] && die "please run from the kernel root directory"
 
+	if (( SHORT_CIRCUIT >= 2 )); then
+		[[ -f "$ORIG_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $ORIG_DIR"
+	fi
+	if (( SHORT_CIRCUIT >= 3 )); then
+		[[ -f "$PATCHED_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $PATCHED_DIR"
+	fi
+	if (( SHORT_CIRCUIT >= 4 )); then
+		[[ -f "$ORIG_CSUM_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $ORIG_CSUM_DIR"
+		[[ -f "$PATCHED_CSUM_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $PATCHED_CSUM_DIR"
+	fi
+	if (( SHORT_CIRCUIT >= 5 )); then
+		[[ -f "$DIFF_DIR/.complete" ]] || die "-S $SHORT_CIRCUIT requires completed $DIFF_DIR"
+	fi
+
 	(( SHORT_CIRCUIT <= 1 )) && rm -rf "$TMP_DIR"
 	mkdir -p "$TMP_DIR"
 
@@ -593,6 +607,7 @@ copy_orig_objects() {
 
 	mv -f "$TMP_DIR/build.log" "$ORIG_DIR"
 	touch "$TIMESTAMP"
+	touch "$ORIG_DIR/.complete"
 }
 
 # Copy all changed objects to $PATCHED_DIR
@@ -631,6 +646,7 @@ copy_patched_objects() {
 	(( found == 0 )) && die "no changes detected"
 
 	mv -f "$TMP_DIR/build.log" "$PATCHED_DIR"
+	touch "$PATCHED_DIR/.complete"
 }
 
 # Copy .o files to a separate directory and run "objtool klp checksum" on each
@@ -712,6 +728,8 @@ diff_objects() {
 				die "objtool klp diff failed"
 		)
 	done
+
+	touch "$DIFF_DIR/.complete"
 }
 
 # For each changed object, run "objtool klp checksum" with --debug-checksum to
-- 
2.53.0


