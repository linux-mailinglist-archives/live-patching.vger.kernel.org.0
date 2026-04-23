Return-Path: <live-patching+bounces-2449-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0OmdJWWb6Wm3ewIAu9opvQ
	(envelope-from <live-patching+bounces-2449-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:09:09 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 36B7B44CB99
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:09:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0944E300D1D6
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:06:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AD6C3D8100;
	Thu, 23 Apr 2026 04:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FC31JauQ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB2E3CC9E4;
	Thu, 23 Apr 2026 04:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917074; cv=none; b=JauWeMce0G7DdBqpfonQkFM25QS7D5CWmubXaOz5ffSC5GnEBhhxoWQ/ofA1c6zN480s2EjxSfPJ9LFfVNsDpyc7J2SHK5+Rs/kS6afG09mhQor2YbSGYFihD3gGeoA9q9grmA4MrA6P+hLqvcRg/FqABbEO+vYTEoo5e9A48V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917074; c=relaxed/simple;
	bh=02VvGyXarl2XFlvNz5pnH+G+BL/1jtvXwmkMaOF0LH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GbX6bi7Q4lmCvSdMthuM02/k1TOCHCquiD/gEYUb4njbNNY8Pxi3Ktjgorhl6RHikKcp0IPs1hKv5o+NiAgdSdT1M+li7L7F+Jy4xWBbcU5IeiAFCMqiuWXg+coJ7dIdVt5Q9NbKn6Uig9LxeCU1HDbv0mATQUPEC89s1+CMDfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FC31JauQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9A4C2BCB2;
	Thu, 23 Apr 2026 04:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917074;
	bh=02VvGyXarl2XFlvNz5pnH+G+BL/1jtvXwmkMaOF0LH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FC31JauQdS3femwHcLxBjpzz68ctv4cFhjgWmC/5RCyFjScntWT1a41mjH0OWkSF/
	 9/th9W9QuRuLZj/7GxXuLbcXMWNlMDIeCgvzLewXW99g4EBzU3DYX7M582VD8NaiXJ
	 1EdlmPeG+qVUPjoCPgDEAuwzRWYXCMxOWJq1gg7FKC8C5CX9l9eqRm91gpiD0ZL3n9
	 +vOsCYMeDIlpUWR/Vz6S8Jje43fe/LqK6yrjXTJAWQG6a7fCb1dGry9ZemZwBFzEc3
	 uf01VYiOsIFNc+tLEad0/P9xp+nsSVG3AN+PEXih3vyLom41zmqp8LtTRmsUBvb8WF
	 tTQB5fYTYFbww==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 22/48] klp-build: Suppress excessive fuzz output by default
Date: Wed, 22 Apr 2026 21:03:50 -0700
Message-ID: <58c5ac9ae38760beb06e5ddddb742ea54f922371.1776916871.git.jpoimboe@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-2449-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: 36B7B44CB99
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

When a patch applies with fuzz, the detailed output from the patch tool
can be very noisy, especially for big patches.

Suppress the fuzz details by default, while keeping the "applied with
fuzz" warning.  The noise can be restored with '--verbose'.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 115f68db49c9..a7f571df7813 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -19,12 +19,11 @@ set -o nounset
 # This helps keep execution in pipes so pipefail+errexit can catch errors.
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


