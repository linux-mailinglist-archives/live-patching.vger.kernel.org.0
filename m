Return-Path: <live-patching+bounces-2645-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qMjrEYEo9Gki+wEAu9opvQ
	(envelope-from <live-patching+bounces-2645-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:13:53 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B16864AA256
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:13:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0312130837EC
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:10:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CF88347BC6;
	Fri,  1 May 2026 04:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rcarRnlD"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B4B30E82E;
	Fri,  1 May 2026 04:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608543; cv=none; b=EXCw4DVA7cT0udqxHxj7t8SHVBBZrPfXHKYrb82yF2D4F4BMC9uhldBDx6dh2ZvIbVdsM53hClzPH+FkleA9RXqBkcv4EtqF6fetttUhNgSjG0sCLX+RRDKkm7vcRug1HEqlAn/gQy5ybib+/58L+9rZJ9FAlJm93nxxY33TfWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608543; c=relaxed/simple;
	bh=oFTd3CoD070wB8gHxriUGzEnBTACmjhaEPjW0KBDv1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4+2GrYiF2+4nBADpdm0N6RRh5Cck7uucM5/BkdkEdG8k2z3GPpzr2qdmo6dDRXAqJ5XfovXn5gZeoUQcFsMPKmwfPaku84m7ybN3rY2TSLAxQbmJT8mI6CcW085VbqAwBF+xu1wJh3R5zubbMvLh35k5J567kr3dj8gED2lcNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rcarRnlD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8C6C2BCC6;
	Fri,  1 May 2026 04:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608542;
	bh=oFTd3CoD070wB8gHxriUGzEnBTACmjhaEPjW0KBDv1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rcarRnlD26HqEgvI7xic180+F53CTTA1E5esi71LVi8gjdMXKaXgLqQhxkURa9Xo2
	 iAxRfECGaQUquV57U6kLmLbJzQGrgMFCAeraRQ2xoezblduOkBRC5wjvYxL92BG1dG
	 zNHcM31MjdWy5BlVL8nL7BwZ1iBF13oDvbGj84C63mnwSQzlLmyfs6ihmhOTHj9SX+
	 RUjnu9WFLYqv1NLwBMGi3zutILopxMlsn+m3MnB21y1q7PyNe4STVjpSjL+xx43wmt
	 WpxB/wxy9+J9u/Mg/1tGS4r1oy+jt3dWHAvbpVvO94xIH9SqHVv8b6E1jTtJMmu1dR
	 RUfZE4hGTQMeQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 27/53] klp-build: Suppress excessive fuzz output by default
Date: Thu, 30 Apr 2026 21:08:15 -0700
Message-ID: <cb47907091c171a5a13dd2fc33a9576f6b23c84d.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: B16864AA256
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
	TAGGED_FROM(0.00)[bounces-2645-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.cz:email]

When a patch applies with fuzz, the detailed output from the patch tool
can be very noisy, especially for big patches.

Suppress the fuzz details by default, while keeping the "applied with
fuzz" warning.  The noise can be restored with '--verbose'.

Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 13709d20e295..dc2c5c33d1db 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -19,12 +19,11 @@ set -o nounset
 # This helps keep execution in pipes so pipefail+ERR trap can catch errors.
 shopt -s lastpipe
 
-unset DEBUG_CLONE DIFF_CHECKSUM SKIP_CLEANUP XTRACE
+unset DEBUG_CLONE DIFF_CHECKSUM SKIP_CLEANUP VERBOSE XTRACE
 
 REPLACE=1
 SHORT_CIRCUIT=0
 JOBS="$(getconf _NPROCESSORS_ONLN)"
-VERBOSE="-s"
 shopt -o xtrace | grep -q 'on' && XTRACE=1
 
 # Avoid removing the previous $TMP_DIR until args have been fully processed.
@@ -194,7 +193,7 @@ process_args() {
 				shift
 				;;
 			-v | --verbose)
-				VERBOSE="V=1"
+				VERBOSE=1
 				shift
 				;;
 			-d | --debug)
@@ -381,7 +380,7 @@ apply_patch() {
 		echo "$output" >&2
 		die "$patch did not apply"
 	elif [[ "$output" =~ $drift_regex ]]; then
-		echo "$output" >&2
+		[[ -v VERBOSE ]] && echo "$output" >&2
 		warn "${patch} applied with fuzz"
 	fi
 
@@ -544,7 +543,11 @@ build_kernel() {
 	#
 	cmd+=("KBUILD_MODPOST_WARN=1")
 
-	cmd+=("$VERBOSE")
+	if [[ -v VERBOSE ]]; then
+		cmd+=("V=1")
+	else
+		cmd+=("-s")
+	fi
 	cmd+=("-j$JOBS")
 	cmd+=("KCFLAGS=-ffunction-sections -fdata-sections")
 	cmd+=("OBJTOOL_ARGS=${objtool_args[*]}")
@@ -805,7 +808,11 @@ build_patch_module() {
 	[[ $REPLACE -eq 0 ]] && cflags+=("-DKLP_NO_REPLACE")
 
 	cmd=("make")
-	cmd+=("$VERBOSE")
+	if [[ -v VERBOSE ]]; then
+		cmd+=("V=1")
+	else
+		cmd+=("-s")
+	fi
 	cmd+=("-j$JOBS")
 	cmd+=("--directory=.")
 	cmd+=("M=$KMOD_DIR")
-- 
2.53.0


