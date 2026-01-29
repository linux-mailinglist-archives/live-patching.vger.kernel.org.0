Return-Path: <live-patching+bounces-1928-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UBgTDO2Se2nOGAIAu9opvQ
	(envelope-from <live-patching+bounces-1928-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 29 Jan 2026 18:03:41 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C3D5B2998
	for <lists+live-patching@lfdr.de>; Thu, 29 Jan 2026 18:03:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 931883006137
	for <lists+live-patching@lfdr.de>; Thu, 29 Jan 2026 17:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0ED0346A0F;
	Thu, 29 Jan 2026 17:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p3uFI9yW"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0743469F7
	for <live-patching@vger.kernel.org>; Thu, 29 Jan 2026 17:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769706211; cv=none; b=pLpuUJmhYwpyQzmsLGCXyaRxAm/nU+x++XF4G/uQMIulm0EAeJx6e3GV2mfO2d23Z0j3M50Ov+tVFPbPTRQ/5Lw/6zaoTivsdqcVwPSmrixpaQ5fNYYsB3lXjTy2aKiIsL3CrTTw9Mo1PA1U34bzORf8b50ajGh6mPfXIOu2WvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769706211; c=relaxed/simple;
	bh=BXMXcvhvqYkbsGGauH3Bjgt099YSb4lnuBRdlb4ZDQs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fDzBmpW4OgV6MQ3tv5BfzkYnq/SzG4mmaDw/fbm6w53d6ekvsqlG1gPPuikd07lq0aq+Gi5qX0wdxc+qQqbodc+DuZyu6fo5imzWZSYiGJ95K1RhEDSicUmSxTRgUG9+O321KXlKsjWO2XGnHYBIFXRzD7tbGhCBYKicxjCwoFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p3uFI9yW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51226C4CEF7;
	Thu, 29 Jan 2026 17:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769706211;
	bh=BXMXcvhvqYkbsGGauH3Bjgt099YSb4lnuBRdlb4ZDQs=;
	h=From:To:Cc:Subject:Date:From;
	b=p3uFI9yWSZcKEUyYym+OTEJQdEzcOmYWKdihiG59PWjVBpqJJlSlMsEEFF958Mnis
	 hsHP4OIAa+q4pk+hCridIfNsZMFOmrk8Y3GgEmA0OyNifgqjWFXSuIReJBDpTMpFgH
	 NrKBZcJzSXzcJ2CxOBdRwm3GQX7te6YGstYA3kBRH2REcXz0FXkNZPu50ylplHIwFR
	 UPfNqvYw/8OGSvPBFU7LxQKpZ1YZE3Qr0fxdArA1SMM1f7+ThnzFsSdSaIGnLw3pg/
	 Eo0Q5gwwnrTwM1/gGmnKf3cRuL1JCwwlngxEDgRoWRkazRgOne5nThF6KAoya0Zjjo
	 3ArpQ7vSEgujQ==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	kernel-team@meta.com,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	Song Liu <song@kernel.org>
Subject: [PATCH] klp-build: Support clang/llvm built kernel
Date: Thu, 29 Jan 2026 09:03:21 -0800
Message-ID: <20260129170321.700854-1-song@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1928-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RSPAMD_EMAILBL_FAIL(0.00)[song.kernel.org:query timed out];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 3C3D5B2998
X-Rspamd-Action: no action

When the kernel is built with clang/llvm, it is expected to run make
with "make LLVM=1 ...". The same is needed when building livepatches.

Use CONFIG_CC_IS_CLANG as the flag to detect kernel built with
clang/llvm, and add LLVM=1 to make commands from klp-build

Signed-off-by: Song Liu <song@kernel.org>
---
 scripts/livepatch/klp-build | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index a73515a82272..6a446ca7d968 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -49,6 +49,7 @@ KMOD_DIR="$TMP_DIR/kmod"
 STASH_DIR="$TMP_DIR/stash"
 TIMESTAMP="$TMP_DIR/timestamp"
 PATCH_TMP_DIR="$TMP_DIR/tmp"
+USE_LLVM=0
 
 KLP_DIFF_LOG="$DIFF_DIR/diff.log"
 
@@ -249,6 +250,8 @@ validate_config() {
 	[[ -v CONFIG_GCC_PLUGIN_RANDSTRUCT ]] &&	\
 		die "kernel option 'CONFIG_GCC_PLUGIN_RANDSTRUCT' not supported"
 
+	[[ -v CONFIG_CC_IS_CLANG ]] && USE_LLVM=1
+
 	return 0
 }
 
@@ -480,6 +483,7 @@ clean_kernel() {
 	cmd+=("--silent")
 	cmd+=("-j$JOBS")
 	cmd+=("clean")
+	[[ "$USE_LLVM" -eq 1 ]] && cmd+=("LLVM=1")
 
 	(
 		cd "$SRC"
@@ -519,6 +523,7 @@ build_kernel() {
 	cmd+=("OBJTOOL_ARGS=${objtool_args[*]}")
 	cmd+=("vmlinux")
 	cmd+=("modules")
+	[[ "$USE_LLVM" -eq 1 ]] && cmd+=("LLVM=1")
 
 	(
 		cd "$SRC"
@@ -764,6 +769,7 @@ build_patch_module() {
 	cmd+=("--directory=.")
 	cmd+=("M=$KMOD_DIR")
 	cmd+=("KCFLAGS=${cflags[*]}")
+	[[ "$USE_LLVM" -eq 1 ]] && cmd+=("LLVM=1")
 
 	# Build a "normal" kernel module with init.c and the diffed objects
 	(
-- 
2.47.3


