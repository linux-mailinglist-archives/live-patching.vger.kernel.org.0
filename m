Return-Path: <live-patching+bounces-2224-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eLh4EDfbuWlHOgIAu9opvQ
	(envelope-from <live-patching+bounces-2224-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 23:52:39 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DF92E2B33BB
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 23:52:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 677C53111E37
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 22:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAA2C3F7AA7;
	Tue, 17 Mar 2026 22:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F9dGKUuC"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975D23F7897;
	Tue, 17 Mar 2026 22:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773787894; cv=none; b=ZQeIjEko4bKpJG2+ys5+eIUqpwHsj7oJzojfezzNqffsjbzHQgL8/D7C2Shx1qYqj9QpkQQI2ZVCVRJQT2jNqf7ut3gFtdb09xsEJwY7h6MiLZm1/bT1W+tcHm34yxWSL59NUFRmD9SJCPSzEX1jMfIitK79AlI20Rd253qCDfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773787894; c=relaxed/simple;
	bh=VHYVcG46HDcvFMvnPYNK+XTdXj0sPBym+XtZyAEFC2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kK1vRsmJYo+3s5gh4hYArGbQPzaYlV+HAm27hqH4r/TS51ZATG6qxctwOJRHKjZHYQUVIV3EX6LqGA4Q881BXFk0xlXEvRIjH7FFFMuJH90ney8ZNdBEQcnR3QNU0jrzgoFbgsT4G1uIKC06AV5Uj1GRa3Nb9zxiq9d+/k0tL1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F9dGKUuC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D8BC2BCB0;
	Tue, 17 Mar 2026 22:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773787894;
	bh=VHYVcG46HDcvFMvnPYNK+XTdXj0sPBym+XtZyAEFC2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9dGKUuCdmTIFVIN8p79f8n/HoYP/FrAAPJsea2JO7/IgAUlFJuHz+bDQ++e1OaJN
	 uucFILufRXwG4QS26FVQPIgUGDwpvGjdDb06ia8qXAVXmC1XAsVtBCsX8i2PXoa5xW
	 9YzHtwrdnVrku7HBboc/o4g2Pa1NW9oC1SV8K7T4KYBAByYBEoODFo3scSP31Ndeho
	 GSWloLMay0XDavuTrYWPAzlNQBSr14Vrev+vEcxsDIk0+PRr5fbP1IVDlYClrnZVmc
	 MibKcYQlxy54qGPNOMU7waOMBpzXSAdTRwCDI/rDEiYIPjchNfCWadhHdVtMLKX25Z
	 MjBoKcliSAbFA==
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
Subject: [PATCH v2 04/12] crypto: arm64: Move data to .rodata
Date: Tue, 17 Mar 2026 15:51:04 -0700
Message-ID: <d853a364bfb7a61d72a95d117572b0563e8f6e9e.1773787568.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773787568.git.jpoimboe@kernel.org>
References: <cover.1773787568.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
	TAGGED_FROM(0.00)[bounces-2224-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DF92E2B33BB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Data embedded in .text pollutes i-cache and confuses objtool and other
tools that try to disassemble it.  Move it to .rodata.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 lib/crypto/arm64/sha2-armv8.pl | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/lib/crypto/arm64/sha2-armv8.pl b/lib/crypto/arm64/sha2-armv8.pl
index 35ec9ae99fe1..8cd86768bf5c 100644
--- a/lib/crypto/arm64/sha2-armv8.pl
+++ b/lib/crypto/arm64/sha2-armv8.pl
@@ -237,7 +237,8 @@ $code.=<<___;
 	ldp	$E,$F,[$ctx,#4*$SZ]
 	add	$num,$inp,$num,lsl#`log(16*$SZ)/log(2)`	// end of input
 	ldp	$G,$H,[$ctx,#6*$SZ]
-	adr	$Ktbl,.LK$BITS
+	adrp	$Ktbl,.LK$BITS
+	add	$Ktbl,$Ktbl,:lo12:.LK$BITS
 	stp	$ctx,$num,[x29,#96]
 
 .Loop:
@@ -286,6 +287,7 @@ $code.=<<___;
 	ret
 .size	$func,.-$func
 
+.pushsection .rodata
 .align	6
 .type	.LK$BITS,%object
 .LK$BITS:
@@ -365,6 +367,7 @@ $code.=<<___;
 #endif
 .asciz	"SHA$BITS block transform for ARMv8, CRYPTOGAMS by <appro\@openssl.org>"
 .align	2
+.popsection
 ___
 
 if ($SZ==4) {
@@ -385,7 +388,8 @@ sha256_block_armv8:
 	add		x29,sp,#0
 
 	ld1.32		{$ABCD,$EFGH},[$ctx]
-	adr		$Ktbl,.LK256
+	adrp		$Ktbl,.LK256
+	add		$Ktbl,$Ktbl,:lo12:.LK256
 
 .Loop_hw:
 	ld1		{@MSG[0]-@MSG[3]},[$inp],#64
@@ -648,7 +652,8 @@ sha256_block_neon:
 	mov	x29, sp
 	sub	sp,sp,#16*4
 
-	adr	$Ktbl,.LK256
+	adrp	$Ktbl,.LK256
+	add	$Ktbl,$Ktbl,:lo12:.LK256
 	add	$num,$inp,$num,lsl#6	// len to point at the end of inp
 
 	ld1.8	{@X[0]},[$inp], #16
-- 
2.53.0


