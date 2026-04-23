Return-Path: <live-patching+bounces-2445-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oG/jFqSb6Wm3ewIAu9opvQ
	(envelope-from <live-patching+bounces-2445-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:10:12 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C9AE44CBF4
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:10:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1E3333029B03
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:06:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02DBB3D6696;
	Thu, 23 Apr 2026 04:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EW64AaX2"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BB23D6674;
	Thu, 23 Apr 2026 04:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917072; cv=none; b=PjAm0RIZ1dmjATl9ddY2VvenKp3n1xcdRXfA/o6FbfRveVI5+1/ZVXCAyBzNmttCOmAQ2OnQRKmJnwPhQoAh9QaEC1pZ6LjKdL1hgXnH+HP/6c8eNhG+T+uAZOK4dczLAEiMTzqPf4MHguNIXKBrz75BsUbnfdCHt6xF0vk+53I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917072; c=relaxed/simple;
	bh=ks80gAFM+9j74ozL8rTgGc80chRVvZX5kr5nIZrm2Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/gPp5H9ghfjfj1WwDvRIOYrWfZZr5ZMskNO+mN9eKCNe1OlChgwuJXtxtRaHtMiNuIlvoIl5HwRXIQnEfsCJg8niHfhya1LmXPyZcgaM2fjVrhQqTPWFDnvyBlZtr1be57BH0AsS/rmahUCX39i0B4+EybZkLaoJ9ySAO3Yn2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EW64AaX2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55751C2BCB2;
	Thu, 23 Apr 2026 04:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917072;
	bh=ks80gAFM+9j74ozL8rTgGc80chRVvZX5kr5nIZrm2Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EW64AaX2kYMDykl26Mi439TtATlDMaKbfnk8zNIC1O8Ti91qwrOSoyQ01zf9CNy4R
	 n5wMB7sKnLnAIcz5K49m56MY5e5VFR6uENAe2vafjswJnmHpDshdc/ngckupsUvAvi
	 Dzbmj1E68k1bHsOq3hLJgZZEPflUz+p2l5YCqhx4+LJ+1LQa9ZKCu4YfTo3QU4dHwY
	 FpetTuFJwiz7TglKAcHfGhZ+dLUZlE+ZpRtJG6Sw8un8KPFW8SXaN3il2zBz+3frp+
	 /77S6ufJ+KFeS/W/09d/oQzB60qdtrZnAi41bO3qq2FbkxbQppuR2sL1FYtzlMYrKS
	 ubHH5Lepex5Ww==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 18/48] klp-build: Fix hang on out-of-date .config
Date: Wed, 22 Apr 2026 21:03:46 -0700
Message-ID: <1b3add71a35ff83fc9653c2c872b811cfd5629a3.1776916871.git.jpoimboe@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2445-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 4C9AE44CBF4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

If .config is out of date with the kernel source, 'make syncconfig'
hangs while waiting for user input on new config options.  Detect the
mismatch and return an error.

Fixes: 6f93f7b06810 ("livepatch/klp-build: Fix inconsistent kernel version")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 0ad7e6631314..81b35fc10877 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -306,7 +306,12 @@ set_kernelversion() {
 
 	stash_file "$file"
 
-	kernelrelease="$(cd "$SRC" && make syncconfig &>/dev/null && make -s kernelrelease)"
+	if [[ -n "$(make -s listnewconfig 2>/dev/null)" ]]; then
+		die ".config mismatch, check your .config or run 'make olddefconfig'"
+	fi
+	make syncconfig &>/dev/null || die "make syncconfig failed"
+
+	kernelrelease="$(cd "$SRC" && make -s kernelrelease)"
 	[[ -z "$kernelrelease" ]] && die "failed to get kernel version"
 
 	sed -i "2i echo $kernelrelease; exit 0" scripts/setlocalversion
-- 
2.53.0


