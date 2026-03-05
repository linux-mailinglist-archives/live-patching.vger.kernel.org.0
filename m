Return-Path: <live-patching+bounces-2122-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oJXzNYX6qGnVzwAAu9opvQ
	(envelope-from <live-patching+bounces-2122-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 04:37:41 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 83F7220A976
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 04:37:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9A6AF3144559
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 03:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F12D2882D7;
	Thu,  5 Mar 2026 03:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jO4MLE0y"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7E827B343;
	Thu,  5 Mar 2026 03:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772681522; cv=none; b=Zm/T4MqCx++HkuYOdSOp5DEYbGPUAK+NWaRlt13QRFFQU+KkPiwkyDRoHs43SrXcoAjVH9c/mgMs/0yV0WSCgc16CTVjsJrxuCy7hQ9eqWwJnhCcLw6xeKZmeyJqdwKHKsBcZKOOT5I2zG34qxcoqxdv+0BHAiC27ex6AOJpPZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772681522; c=relaxed/simple;
	bh=y7mJtqRMIyYxCk1D8Nsk0D/Rqo0GqzF9Z7aw/XJAZkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7gHFNt6fYcV73ZDSFLKmok/ZmBoOmw4C/H8JixhqOLGxZ7pGi2s3NUSrkDQfXaxvm9sXr/J7rosNTKcVCgiVvX1QDihHhQRs3rOSDIfPwaUPMRoVLv7Pn/4+HO7OrvoywVvM5BlGOfT7rg/pVOQs/RI7tzbYGMag20MCkajlrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jO4MLE0y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5478DC2BCB6;
	Thu,  5 Mar 2026 03:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772681521;
	bh=y7mJtqRMIyYxCk1D8Nsk0D/Rqo0GqzF9Z7aw/XJAZkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jO4MLE0y+XVePdzaVdE68vXz7JQqqVf+lnn4o0UVyNFosJKc2k1E4UVnCsvXs66zB
	 wB93vgw9EBaAV/YKdnEy0WtFqGkZ9EBI6gK1E5y1rJFWjh+hYJnlPVG+BdrPBPZLO6
	 6wBwyP8bbFS5AwN2jW081RF1t3neD09RgxFj/RFw8WhQFBnUpNQEOR3B+h7jUULLFN
	 jAERCQrP4fzL7B/Ll5Vkn0x8FZlJCYUpjmayqA3H1Oqh1swc/t5o523KgVUaeCAZFk
	 0hvvCMiCSGhNGQAJ6lJ39yJynMCREPTg4ce3MEX2/a6+asVgOsq0HaqBPpeJ9quA2P
	 CjcsAQuwx7pLQ==
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
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 14/14] klp-build: Support cross-compilation
Date: Wed,  4 Mar 2026 19:31:33 -0800
Message-ID: <697c09ca0a8ffd545aa875e507502f62ad983419.1772681234.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772681234.git.jpoimboe@kernel.org>
References: <cover.1772681234.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 83F7220A976
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
	TAGGED_FROM(0.00)[bounces-2122-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Add support for cross-compilation.  The user must export ARCH, and
either CROSS_COMPILE or LLVM.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 809e198a561d..b6c057e2120f 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -404,6 +404,14 @@ validate_patches() {
 	revert_patches
 }
 
+cross_compile_init() {
+	if [[ -v LLVM ]]; then
+		OBJCOPY=llvm-objcopy
+	else
+		OBJCOPY="${CROSS_COMPILE:-}objcopy"
+	fi
+}
+
 do_init() {
 	# We're not yet smart enough to handle anything other than in-tree
 	# builds in pwd.
@@ -420,6 +428,7 @@ do_init() {
 	validate_config
 	set_module_name
 	set_kernelversion
+	cross_compile_init
 }
 
 # Refresh the patch hunk headers, specifically the line numbers and counts.
@@ -783,7 +792,7 @@ build_patch_module() {
 	cp -f "$kmod_file" "$kmod_file.orig"
 
 	# Work around issue where slight .config change makes corrupt BTF
-	objcopy --remove-section=.BTF "$kmod_file"
+	"$OBJCOPY" --remove-section=.BTF "$kmod_file"
 
 	# Fix (and work around) linker wreckage for klp syms / relocs
 	"$SRC/tools/objtool/objtool" klp post-link "$kmod_file" || die "objtool klp post-link failed"
-- 
2.53.0


