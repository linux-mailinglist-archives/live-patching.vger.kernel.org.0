Return-Path: <live-patching+bounces-2755-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gJtWOFbxA2prBAIAu9opvQ
	(envelope-from <live-patching+bounces-2755-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:34:46 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FA9D52CC76
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:34:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7918C304777D
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 03:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE5AE397AE5;
	Wed, 13 May 2026 03:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LTOCjVpC"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2F939734D;
	Wed, 13 May 2026 03:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778643272; cv=none; b=uV6dfNqoJAvfy/gh5Co2SGpO7PayWQ2hDXlNJMYx7moyFhgWUo2r9Ke2nT1vYr/X3wuC7aTV4lGwUO220JoFnrFk1N3wz2eHlDbA95WlQtvQdUQvylnXOuSN9E33RFL6jYjkPlPg39TKsCe1vCo6kYUd5jSaqN5eUIDBw3dJxTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778643272; c=relaxed/simple;
	bh=Ab2hQoImpnCesBxD7mSC6H2W3UbT0AZPaZqbzGazFII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ht5xAKCZFplKIxiscXFAQJ8QYnzMM8nyq0jWIsFlLWaE53oS02wf6Jql8GWQdx6xJGz61texjDgE9PGsVjWSl8YiUVu6JrHAjj9Ovnxr/8Jj9kEp+742UQqt9JAIrn+AAgaAO/YWmhZSB8/teJR/MhJyse1odm4Q6D7LnMBH3gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LTOCjVpC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46335C2BCFA;
	Wed, 13 May 2026 03:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778643272;
	bh=Ab2hQoImpnCesBxD7mSC6H2W3UbT0AZPaZqbzGazFII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LTOCjVpCjl9KwyWSki2aEgEylNyJ1o0zPJj19wM8xNi9yqDeQLZYo9yS/anZD6//6
	 Sk9KFdSblayCO9ZjJpR7OgXC25hdS3614+CFYV0AZeuCJ3K4XBoVUTvTRF20/TTzWA
	 OKEq3SFKPpekh/yHn7F3eSPHTmC/jZ/J3FkEpwqltWCUeJdTXYPe7LD/jBFwhr21/t
	 HlhanXoxgjhP2uP2Uc4gtkBaRWe08Xv09WQPs/4bC1wuNqsRQgAYVe4bQPMkLJGiK7
	 ypytQeY4yrCTWocStNcyjk2h+Xo43/5H2wFSscEQjdxLCs+wKnMFdxqtgdqkpkT8mv
	 lfAZoD3Xwq2rw==
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
Subject: [PATCH v3 04/21] arm64: Rename TRAMP_VALIAS -> TRAMP_VALIAS_ASM in asm-offsets
Date: Tue, 12 May 2026 20:33:38 -0700
Message-ID: <74623fad8c45d26a3da6c5420b00156d8f7c2150.1778642120.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: 5FA9D52CC76
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2755-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

Rename the asm-offsets TRAMP_VALIAS macro to TRAMP_VALIAS_ASM, following
the naming convention already used by PIE_E0_ASM and PIE_E1_ASM.  This
disambiguates the asm-offsets-generated constant from the C macro of the
same name defined in fixmap.h and vectors.h.

This is needed by a later patch which adds new includes to asm-offsets.c
that would otherwise conflict with the C version.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/arm64/kernel/asm-offsets.c | 2 +-
 arch/arm64/kernel/entry.S       | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index b6367ff3a49ca..44b92f582c127 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -153,7 +153,7 @@ int main(void)
   DEFINE(ARM64_FTR_SYSVAL,	offsetof(struct arm64_ftr_reg, sys_val));
   BLANK();
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-  DEFINE(TRAMP_VALIAS,		TRAMP_VALIAS);
+  DEFINE(TRAMP_VALIAS_ASM,	TRAMP_VALIAS);
 #endif
 #ifdef CONFIG_ARM_SDE_INTERFACE
   DEFINE(SDEI_EVENT_INTREGS,	offsetof(struct sdei_registered_event, interrupted_regs));
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index d4cbdfb23d733..85f6305c1f568 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -102,7 +102,7 @@
 	.endm
 
 	.macro	tramp_alias, dst, sym
-	.set	.Lalias\@, TRAMP_VALIAS + \sym - .entry.tramp.text
+	.set	.Lalias\@, TRAMP_VALIAS_ASM + \sym - .entry.tramp.text
 	movz	\dst, :abs_g2_s:.Lalias\@
 	movk	\dst, :abs_g1_nc:.Lalias\@
 	movk	\dst, :abs_g0_nc:.Lalias\@
@@ -626,10 +626,10 @@ SYM_CODE_END(ret_to_user)
 #ifdef CONFIG_QCOM_FALKOR_ERRATUM_1003
 alternative_if ARM64_WORKAROUND_QCOM_FALKOR_E1003
 	/* ASID already in \tmp[63:48] */
-	movk	\tmp, #:abs_g2_nc:(TRAMP_VALIAS >> 12)
-	movk	\tmp, #:abs_g1_nc:(TRAMP_VALIAS >> 12)
+	movk	\tmp, #:abs_g2_nc:(TRAMP_VALIAS_ASM >> 12)
+	movk	\tmp, #:abs_g1_nc:(TRAMP_VALIAS_ASM >> 12)
 	/* 2MB boundary containing the vectors, so we nobble the walk cache */
-	movk	\tmp, #:abs_g0_nc:((TRAMP_VALIAS & ~(SZ_2M - 1)) >> 12)
+	movk	\tmp, #:abs_g0_nc:((TRAMP_VALIAS_ASM & ~(SZ_2M - 1)) >> 12)
 	isb
 	tlbi	vae1, \tmp
 	dsb	nsh
-- 
2.53.0


