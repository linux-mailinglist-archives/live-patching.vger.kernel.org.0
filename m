Return-Path: <live-patching+bounces-2858-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SI9gBPcJDGo5UQUAu9opvQ
	(envelope-from <live-patching+bounces-2858-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:57:59 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 98AD957879B
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:57:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4BE5D309E336
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 06:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C9E73A719B;
	Tue, 19 May 2026 06:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iVGBpMGI"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8303A1D01
	for <live-patching@vger.kernel.org>; Tue, 19 May 2026 06:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779173419; cv=none; b=BMrADR0Q/H1h62gYgGxm3aZp+qm4i+0bYzfEVqiax3Z0vwLj2hEayVMmYK53x8iKSHStGO+6lduZT7FQCc0xEm68etpe1piI5bZVepst3CZG/MFZgBbFMhb7X7sIJTuzm5doAP5pMkFwXISZu+Bo0aA44dqmrWZ8p9Pnp7VqEkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779173419; c=relaxed/simple;
	bh=/aAtNd92HSvlGNF2Iu71s6fUTHakYBZTfAY2SFGPFic=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nFF0Q93LdBLF4na1lpCxpFqpf95q8bKmN+3QRsFmKZ8eL8av5r+6Sr71hXPVdYJsFioaJSHfw9JfWtlrUIYyrcOIzN2Q/n5+4JRWij45/2bTtSHQFIcd10NvHO50g42uhh6hJn0KPenepWibgTDKxKXcH3IcwbDdrVv3A0XqHrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iVGBpMGI; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82fa860e71eso1629690b3a.0
        for <live-patching@vger.kernel.org>; Mon, 18 May 2026 23:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779173413; x=1779778213; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8nS32RcdRO5dIlP7VR/Ox3AfIUmVu4CADSkolb/TDMM=;
        b=iVGBpMGIxAKXHvXp9McbtmNJtq+FjHGUPboS3BlWiRWW8kEas542+srkkrV7SckNmq
         /8UWcYfLsdPezarURqiRrt+Glrt23BcfFwccNidtmU8tCQVSWQjPF2dGLcgqvectq0e6
         KiPGdzPwF4Fs2sN+lGPP0MksJGvKoBhzW8zvEiXQZBOBPdsQ0YXlD+Fh32E3CZW24R2o
         BM8Le3V9lbEk4nwsD3McM5Fy1Me9LZ+t11r8omPrv398DAdmMaIL+mrVQWRSirLq5uTZ
         0F2HbTfHo8Hg2ArTWRQ7mRiuJtHdhC8C5Ja3waucGQzlIOLkrVj9jrS+9Hpfx1Yg2p2V
         bHVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779173413; x=1779778213;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8nS32RcdRO5dIlP7VR/Ox3AfIUmVu4CADSkolb/TDMM=;
        b=Z6h1yINNbwkJpUpdNOzz/KwxbLv5BsfBLvOM81bho6yAyc9g1e5SrXwU2oZCLLU5MF
         QZhq/xxEA7VVlrdzK2ohjXdutn91oIN2V1Qt41kGM+n47pldEECtsP7C2yJvODb8L8E6
         560rzF55dmMI6TB/lg/OfKuqMUi/fl4wIMsbo9UUhC1HMUkhSxMDgCJmtKhY0LJN5F1c
         6BqF1B/D97PqxWd20ZA0W3XZiYQIZidR968rI5uKSh+EbjYnhTYh9y5jQuyooacQHLst
         v0cQFy9lFiXQNHLTqQNbxIgxmdBZq48VXqD0f6OmwJQjFc9ukJ61A3xtTaRPzPGKCACp
         66XA==
X-Forwarded-Encrypted: i=1; AFNElJ+9vv0Xd/SjiGdKS5UVhjR6eiTOLPQMq+eMaKPiPBc+ocXZxVajzcQ8VknPWEU2B/bSiBJEbVyD2/aPoBOQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yx81SbXBZecv9myr80gX5NyhE5e1LMAq8qfYGh3R92H1EooHW8b
	fNeYDY+TyoUgdqeueO7uhJK+SyGv67F3ExeLIDFwTMEYEyGRjR0XFhj7DnREA6Y1C6/QVny+9TJ
	6nUOwVyCQRxJbKvHNMVAopH9c0g==
X-Received: from pfbcw11.prod.google.com ([2002:a05:6a00:450b:b0:83f:8b6a:7319])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:438f:b0:81e:ef16:b288 with SMTP id d2e1a72fcca58-83f33b65ba5mr17978907b3a.22.1779173412846;
 Mon, 18 May 2026 23:50:12 -0700 (PDT)
Date: Tue, 19 May 2026 06:49:45 +0000
In-Reply-To: <20260519064950.493949-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260519064950.493949-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519064950.493949-5-dylanbhatch@google.com>
Subject: [PATCH v6 4/9] arm64, crypto/lib: Annotate leaf functions with CFI info.
From: Dylan Hatch <dylanbhatch@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <ibhagatgnu@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Jens Remus <jremus@linux.ibm.com>
Cc: Dylan Hatch <dylanbhatch@google.com>, Prasanna Kumar T S M <ptsm@linux.microsoft.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>, joe.lawrence@redhat.com, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	Randy Dunlap <rdunlap@infradead.org>, Mostafa Saleh <smostafa@google.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com];
	RCPT_COUNT_TWELVE(0.00)[24];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-2858-lists,live-patching=lfdr.de];
	TAGGED_RCPT(0.00)[live-patching];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 98AD957879B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

DWARF CFI (Call Frame Information) specifies how to recover return
address and callee-saved registers for annotated functions. These
annotations are generated by the compiler, but for assembly, they must
be annotated by hand.

Add simple CFI annotations to assembly leaf functions so that the LR can
be recovered by the unwinder when an exception is taken from one of them.

Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 arch/arm64/crypto/aes-ce-ccm-core.S    | 12 +++----
 arch/arm64/crypto/aes-neonbs-core.S    | 40 +++++++++++------------
 arch/arm64/crypto/ghash-ce-core.S      | 20 ++++++------
 arch/arm64/crypto/sm4-ce-ccm-core.S    | 16 +++++-----
 arch/arm64/crypto/sm4-ce-cipher-core.S |  4 +--
 arch/arm64/crypto/sm4-ce-core.S        | 44 +++++++++++++-------------
 arch/arm64/crypto/sm4-ce-gcm-core.S    | 16 +++++-----
 arch/arm64/crypto/sm4-neon-core.S      | 12 +++----
 arch/arm64/include/asm/linkage.h       | 30 ++++++++++++++++++
 arch/arm64/lib/clear_page.S            |  4 +--
 arch/arm64/lib/clear_user.S            |  4 +--
 arch/arm64/lib/copy_from_user.S        |  4 +--
 arch/arm64/lib/copy_page.S             |  4 +--
 arch/arm64/lib/copy_to_user.S          |  4 +--
 arch/arm64/lib/memchr.S                |  4 +--
 arch/arm64/lib/memcmp.S                |  4 +--
 arch/arm64/lib/memcpy.S                |  8 ++---
 arch/arm64/lib/memset.S                |  8 ++---
 arch/arm64/lib/mte.S                   | 28 ++++++++--------
 arch/arm64/lib/strchr.S                |  4 +--
 arch/arm64/lib/strcmp.S                |  4 +--
 arch/arm64/lib/strlen.S                |  4 +--
 arch/arm64/lib/strncmp.S               |  4 +--
 arch/arm64/lib/strnlen.S               |  4 +--
 arch/arm64/lib/tishift.S               | 12 +++----
 25 files changed, 164 insertions(+), 134 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-core.S b/arch/arm64/crypto/aes-ce-ccm-core.S
index f2624238fd95..519309c886b9 100644
--- a/arch/arm64/crypto/aes-ce-ccm-core.S
+++ b/arch/arm64/crypto/aes-ce-ccm-core.S
@@ -80,7 +80,7 @@ CPU_LE(	rev	x8, x8			)
 	ret
 	.endm
 
-SYM_FUNC_START_LOCAL(ce_aes_ccm_crypt_tail)
+SYM_LEAF_FUNC_START_LOCAL(ce_aes_ccm_crypt_tail)
 	eor	v0.16b, v0.16b, v5.16b		/* final round mac */
 	eor	v1.16b, v1.16b, v5.16b		/* final round enc */
 
@@ -113,7 +113,7 @@ SYM_INNER_LABEL(ce_aes_ccm_final, SYM_L_LOCAL)
 	eor	v0.16b, v0.16b, v1.16b		/* en-/decrypt the mac */
 0:	st1	{v0.16b}, [x5]			/* store result */
 	ret
-SYM_FUNC_END(ce_aes_ccm_crypt_tail)
+SYM_LEAF_FUNC_END(ce_aes_ccm_crypt_tail)
 
 	/*
 	 * void ce_aes_ccm_encrypt(u8 out[], u8 const in[], u32 cbytes,
@@ -123,15 +123,15 @@ SYM_FUNC_END(ce_aes_ccm_crypt_tail)
 	 * 			   u8 const rk[], u32 rounds, u8 mac[],
 	 * 			   u8 ctr[], u8 const final_iv[]);
 	 */
-SYM_FUNC_START(ce_aes_ccm_encrypt)
+SYM_LEAF_FUNC_START(ce_aes_ccm_encrypt)
 	movi	v22.16b, #255
 	aes_ccm_do_crypt	1
-SYM_FUNC_END(ce_aes_ccm_encrypt)
+SYM_LEAF_FUNC_END(ce_aes_ccm_encrypt)
 
-SYM_FUNC_START(ce_aes_ccm_decrypt)
+SYM_LEAF_FUNC_START(ce_aes_ccm_decrypt)
 	movi	v22.16b, #0
 	aes_ccm_do_crypt	0
-SYM_FUNC_END(ce_aes_ccm_decrypt)
+SYM_LEAF_FUNC_END(ce_aes_ccm_decrypt)
 
 	.section ".rodata", "a"
 	.align	6
diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
index baf450717b24..34b5c3c63c22 100644
--- a/arch/arm64/crypto/aes-neonbs-core.S
+++ b/arch/arm64/crypto/aes-neonbs-core.S
@@ -381,7 +381,7 @@ ISRM0:	.octa		0x0306090c00070a0d01040b0e0205080f
 	/*
 	 * void aesbs_convert_key(u8 out[], u32 const rk[], int rounds)
 	 */
-SYM_FUNC_START(aesbs_convert_key)
+SYM_LEAF_FUNC_START(aesbs_convert_key)
 	ld1		{v7.4s}, [x1], #16		// load round 0 key
 	ld1		{v17.4s}, [x1], #16		// load round 1 key
 
@@ -426,10 +426,10 @@ SYM_FUNC_START(aesbs_convert_key)
 	eor		v17.16b, v17.16b, v7.16b
 	str		q17, [x0]
 	ret
-SYM_FUNC_END(aesbs_convert_key)
+SYM_LEAF_FUNC_END(aesbs_convert_key)
 
 	.align		4
-SYM_FUNC_START_LOCAL(aesbs_encrypt8)
+SYM_LEAF_FUNC_START_LOCAL(aesbs_encrypt8)
 	ldr		q9, [bskey], #16		// round 0 key
 	ldr		q8, M0SR
 	ldr		q24, SR
@@ -489,10 +489,10 @@ SYM_FUNC_START_LOCAL(aesbs_encrypt8)
 	eor		v2.16b, v2.16b, v12.16b
 	eor		v5.16b, v5.16b, v12.16b
 	ret
-SYM_FUNC_END(aesbs_encrypt8)
+SYM_LEAF_FUNC_END(aesbs_encrypt8)
 
 	.align		4
-SYM_FUNC_START_LOCAL(aesbs_decrypt8)
+SYM_LEAF_FUNC_START_LOCAL(aesbs_decrypt8)
 	lsl		x9, rounds, #7
 	add		bskey, bskey, x9
 
@@ -554,7 +554,7 @@ SYM_FUNC_START_LOCAL(aesbs_decrypt8)
 	eor		v3.16b, v3.16b, v12.16b
 	eor		v5.16b, v5.16b, v12.16b
 	ret
-SYM_FUNC_END(aesbs_decrypt8)
+SYM_LEAF_FUNC_END(aesbs_decrypt8)
 
 	/*
 	 * aesbs_ecb_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
@@ -621,21 +621,21 @@ SYM_FUNC_END(aesbs_decrypt8)
 	.endm
 
 	.align		4
-SYM_TYPED_FUNC_START(aesbs_ecb_encrypt)
+SYM_TYPED_LEAF_FUNC_START(aesbs_ecb_encrypt)
 	__ecb_crypt	aesbs_encrypt8, v0, v1, v4, v6, v3, v7, v2, v5
-SYM_FUNC_END(aesbs_ecb_encrypt)
+SYM_LEAF_FUNC_END(aesbs_ecb_encrypt)
 
 	.align		4
-SYM_TYPED_FUNC_START(aesbs_ecb_decrypt)
+SYM_TYPED_LEAF_FUNC_START(aesbs_ecb_decrypt)
 	__ecb_crypt	aesbs_decrypt8, v0, v1, v6, v4, v2, v7, v3, v5
-SYM_FUNC_END(aesbs_ecb_decrypt)
+SYM_LEAF_FUNC_END(aesbs_ecb_decrypt)
 
 	/*
 	 * aesbs_cbc_decrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
 	 *		     int blocks, u8 iv[])
 	 */
 	.align		4
-SYM_FUNC_START(aesbs_cbc_decrypt)
+SYM_LEAF_FUNC_START(aesbs_cbc_decrypt)
 	frame_push	6
 
 	mov		x19, x0
@@ -719,7 +719,7 @@ SYM_FUNC_START(aesbs_cbc_decrypt)
 
 2:	frame_pop
 	ret
-SYM_FUNC_END(aesbs_cbc_decrypt)
+SYM_LEAF_FUNC_END(aesbs_cbc_decrypt)
 
 	.macro		next_tweak, out, in, const, tmp
 	sshr		\tmp\().2d,  \in\().2d,   #63
@@ -735,7 +735,7 @@ SYM_FUNC_END(aesbs_cbc_decrypt)
 	 * aesbs_xts_decrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
 	 *		     int blocks, u8 iv[])
 	 */
-SYM_FUNC_START_LOCAL(__xts_crypt8)
+SYM_LEAF_FUNC_START_LOCAL(__xts_crypt8)
 	movi		v18.2s, #0x1
 	movi		v19.2s, #0x87
 	uzp1		v18.4s, v18.4s, v19.4s
@@ -766,7 +766,7 @@ SYM_FUNC_START_LOCAL(__xts_crypt8)
 	mov		bskey, x2
 	mov		rounds, x3
 	br		x16
-SYM_FUNC_END(__xts_crypt8)
+SYM_LEAF_FUNC_END(__xts_crypt8)
 
 	.macro		__xts_crypt, do8, o0, o1, o2, o3, o4, o5, o6, o7
 	frame_push	0, 32
@@ -800,13 +800,13 @@ SYM_FUNC_END(__xts_crypt8)
 	ret
 	.endm
 
-SYM_TYPED_FUNC_START(aesbs_xts_encrypt)
+SYM_TYPED_LEAF_FUNC_START(aesbs_xts_encrypt)
 	__xts_crypt	aesbs_encrypt8, v0, v1, v4, v6, v3, v7, v2, v5
-SYM_FUNC_END(aesbs_xts_encrypt)
+SYM_LEAF_FUNC_END(aesbs_xts_encrypt)
 
-SYM_TYPED_FUNC_START(aesbs_xts_decrypt)
+SYM_TYPED_LEAF_FUNC_START(aesbs_xts_decrypt)
 	__xts_crypt	aesbs_decrypt8, v0, v1, v6, v4, v2, v7, v3, v5
-SYM_FUNC_END(aesbs_xts_decrypt)
+SYM_LEAF_FUNC_END(aesbs_xts_decrypt)
 
 	.macro		next_ctr, v
 	mov		\v\().d[1], x8
@@ -820,7 +820,7 @@ SYM_FUNC_END(aesbs_xts_decrypt)
 	 * aesbs_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[],
 	 *		     int rounds, int blocks, u8 iv[])
 	 */
-SYM_FUNC_START(aesbs_ctr_encrypt)
+SYM_LEAF_FUNC_START(aesbs_ctr_encrypt)
 	frame_push	0
 	ldp		x7, x8, [x5]
 	ld1		{v0.16b}, [x5]
@@ -863,4 +863,4 @@ CPU_LE(	rev		x8, x8		)
 	st1		{v0.16b}, [x5]
 	frame_pop
 	ret
-SYM_FUNC_END(aesbs_ctr_encrypt)
+SYM_LEAF_FUNC_END(aesbs_ctr_encrypt)
diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index 33772d8fe6b5..3471430c2a53 100644
--- a/arch/arm64/crypto/ghash-ce-core.S
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -66,7 +66,7 @@
 	 * void pmull_ghash_update_p64(int blocks, u64 dg[], const char *src,
 	 *			       u64 const h[4][2], const char *head)
 	 */
-SYM_FUNC_START(pmull_ghash_update_p64)
+SYM_LEAF_FUNC_START(pmull_ghash_update_p64)
 	ld1		{SHASH.2d}, [x3]
 	ld1		{XL.2d}, [x1]
 
@@ -173,7 +173,7 @@ CPU_LE(	rev64		T1.16b, T1.16b	)
 
 5:	st1		{XL.2d}, [x1]
 	ret
-SYM_FUNC_END(pmull_ghash_update_p64)
+SYM_LEAF_FUNC_END(pmull_ghash_update_p64)
 
 	KS0		.req	v8
 	KS1		.req	v9
@@ -417,9 +417,9 @@ CPU_LE(	rev		w8, w8		)
 	 *			  u64 const h[4][2], u64 dg[], u8 ctr[],
 	 *			  u32 const rk[], int rounds, u8 tag[])
 	 */
-SYM_FUNC_START(pmull_gcm_encrypt)
+SYM_LEAF_FUNC_START(pmull_gcm_encrypt)
 	pmull_gcm_do_crypt	1
-SYM_FUNC_END(pmull_gcm_encrypt)
+SYM_LEAF_FUNC_END(pmull_gcm_encrypt)
 
 	/*
 	 * int pmull_gcm_decrypt(int bytes, u8 dst[], const u8 src[],
@@ -427,11 +427,11 @@ SYM_FUNC_END(pmull_gcm_encrypt)
 	 *			 u32 const rk[], int rounds, const u8 l[],
 	 *			 const u8 tag[], u64 authsize)
 	 */
-SYM_FUNC_START(pmull_gcm_decrypt)
+SYM_LEAF_FUNC_START(pmull_gcm_decrypt)
 	pmull_gcm_do_crypt	0
-SYM_FUNC_END(pmull_gcm_decrypt)
+SYM_LEAF_FUNC_END(pmull_gcm_decrypt)
 
-SYM_FUNC_START_LOCAL(pmull_gcm_ghash_4x)
+SYM_LEAF_FUNC_START_LOCAL(pmull_gcm_ghash_4x)
 	movi		MASK.16b, #0xe1
 	shl		MASK.2d, MASK.2d, #57
 
@@ -512,9 +512,9 @@ SYM_FUNC_START_LOCAL(pmull_gcm_ghash_4x)
 	eor		XL.16b, XL.16b, T2.16b
 
 	ret
-SYM_FUNC_END(pmull_gcm_ghash_4x)
+SYM_LEAF_FUNC_END(pmull_gcm_ghash_4x)
 
-SYM_FUNC_START_LOCAL(pmull_gcm_enc_4x)
+SYM_LEAF_FUNC_START_LOCAL(pmull_gcm_enc_4x)
 	ld1		{KS0.16b}, [x5]			// load upper counter
 	sub		w10, w8, #4
 	sub		w11, w8, #3
@@ -577,7 +577,7 @@ SYM_FUNC_START_LOCAL(pmull_gcm_enc_4x)
 	eor		INP3.16b, INP3.16b, KS3.16b
 
 	ret
-SYM_FUNC_END(pmull_gcm_enc_4x)
+SYM_LEAF_FUNC_END(pmull_gcm_enc_4x)
 
 	.section	".rodata", "a"
 	.align		6
diff --git a/arch/arm64/crypto/sm4-ce-ccm-core.S b/arch/arm64/crypto/sm4-ce-ccm-core.S
index fa85856f33ce..20a8853609e0 100644
--- a/arch/arm64/crypto/sm4-ce-ccm-core.S
+++ b/arch/arm64/crypto/sm4-ce-ccm-core.S
@@ -37,7 +37,7 @@
 
 
 .align 3
-SYM_FUNC_START(sm4_ce_cbcmac_update)
+SYM_LEAF_FUNC_START(sm4_ce_cbcmac_update)
 	/* input:
 	 *   x0: round key array, CTX
 	 *   x1: mac
@@ -81,10 +81,10 @@ SYM_FUNC_START(sm4_ce_cbcmac_update)
 .Lcbcmac_end:
 	st1		{RMAC.16b}, [x1]
 	ret
-SYM_FUNC_END(sm4_ce_cbcmac_update)
+SYM_LEAF_FUNC_END(sm4_ce_cbcmac_update)
 
 .align 3
-SYM_FUNC_START(sm4_ce_ccm_final)
+SYM_LEAF_FUNC_START(sm4_ce_ccm_final)
 	/* input:
 	 *   x0: round key array, CTX
 	 *   x1: ctr0 (big endian, 128 bit)
@@ -102,10 +102,10 @@ SYM_FUNC_START(sm4_ce_ccm_final)
 	st1		{RMAC.16b}, [x2]
 
 	ret
-SYM_FUNC_END(sm4_ce_ccm_final)
+SYM_LEAF_FUNC_END(sm4_ce_ccm_final)
 
 .align 3
-SYM_TYPED_FUNC_START(sm4_ce_ccm_enc)
+SYM_TYPED_LEAF_FUNC_START(sm4_ce_ccm_enc)
 	/* input:
 	 *   x0: round key array, CTX
 	 *   x1: dst
@@ -214,10 +214,10 @@ SYM_TYPED_FUNC_START(sm4_ce_ccm_enc)
 
 .Lccm_enc_ret:
 	ret
-SYM_FUNC_END(sm4_ce_ccm_enc)
+SYM_LEAF_FUNC_END(sm4_ce_ccm_enc)
 
 .align 3
-SYM_TYPED_FUNC_START(sm4_ce_ccm_dec)
+SYM_TYPED_LEAF_FUNC_START(sm4_ce_ccm_dec)
 	/* input:
 	 *   x0: round key array, CTX
 	 *   x1: dst
@@ -326,4 +326,4 @@ SYM_TYPED_FUNC_START(sm4_ce_ccm_dec)
 
 .Lccm_dec_ret:
 	ret
-SYM_FUNC_END(sm4_ce_ccm_dec)
+SYM_LEAF_FUNC_END(sm4_ce_ccm_dec)
diff --git a/arch/arm64/crypto/sm4-ce-cipher-core.S b/arch/arm64/crypto/sm4-ce-cipher-core.S
index 4ac6cfbc5797..7aea346cb14c 100644
--- a/arch/arm64/crypto/sm4-ce-cipher-core.S
+++ b/arch/arm64/crypto/sm4-ce-cipher-core.S
@@ -15,7 +15,7 @@
 	 * void sm4_ce_do_crypt(const u32 *rk, u32 *out, const u32 *in);
 	 */
 	.text
-SYM_FUNC_START(sm4_ce_do_crypt)
+SYM_LEAF_FUNC_START(sm4_ce_do_crypt)
 	ld1		{v8.4s}, [x2]
 	ld1		{v0.4s-v3.4s}, [x0], #64
 CPU_LE(	rev32		v8.16b, v8.16b		)
@@ -33,4 +33,4 @@ CPU_LE(	rev32		v8.16b, v8.16b		)
 CPU_LE(	rev32		v8.16b, v8.16b		)
 	st1		{v8.4s}, [x1]
 	ret
-SYM_FUNC_END(sm4_ce_do_crypt)
+SYM_LEAF_FUNC_END(sm4_ce_do_crypt)
diff --git a/arch/arm64/crypto/sm4-ce-core.S b/arch/arm64/crypto/sm4-ce-core.S
index 1f3625c2c67e..6af5b10859b8 100644
--- a/arch/arm64/crypto/sm4-ce-core.S
+++ b/arch/arm64/crypto/sm4-ce-core.S
@@ -40,7 +40,7 @@
 
 
 .align 3
-SYM_FUNC_START(sm4_ce_expand_key)
+SYM_LEAF_FUNC_START(sm4_ce_expand_key)
 	/* input:
 	 *   x0: 128-bit key
 	 *   x1: rkey_enc
@@ -86,10 +86,10 @@ SYM_FUNC_START(sm4_ce_expand_key)
 	st1		{v20.16b-v23.16b}, [x2]
 
 	ret;
-SYM_FUNC_END(sm4_ce_expand_key)
+SYM_LEAF_FUNC_END(sm4_ce_expand_key)
 
 .align 3
-SYM_FUNC_START(sm4_ce_crypt_block)
+SYM_LEAF_FUNC_START(sm4_ce_crypt_block)
 	/* input:
 	 *   x0: round key array, CTX
 	 *   x1: dst
@@ -102,10 +102,10 @@ SYM_FUNC_START(sm4_ce_crypt_block)
 	st1		{v0.16b}, [x1];
 
 	ret;
-SYM_FUNC_END(sm4_ce_crypt_block)
+SYM_LEAF_FUNC_END(sm4_ce_crypt_block)
 
 .align 3
-SYM_FUNC_START(sm4_ce_crypt)
+SYM_LEAF_FUNC_START(sm4_ce_crypt)
 	/* input:
 	 *   x0: round key array, CTX
 	 *   x1: dst
@@ -153,10 +153,10 @@ SYM_FUNC_START(sm4_ce_crypt)
 
 .Lcrypt_end:
 	ret;
-SYM_FUNC_END(sm4_ce_crypt)
+SYM_LEAF_FUNC_END(sm4_ce_crypt)
 
 .align 3
-SYM_FUNC_START(sm4_ce_cbc_enc)
+SYM_LEAF_FUNC_START(sm4_ce_cbc_enc)
 	/* input:
 	 *   x0: round key array, CTX
 	 *   x1: dst
@@ -208,10 +208,10 @@ SYM_FUNC_START(sm4_ce_cbc_enc)
 	st1		{RIV.16b}, [x3]
 
 	ret
-SYM_FUNC_END(sm4_ce_cbc_enc)
+SYM_LEAF_FUNC_END(sm4_ce_cbc_enc)
 
 .align 3
-SYM_FUNC_START(sm4_ce_cbc_dec)
+SYM_LEAF_FUNC_START(sm4_ce_cbc_dec)
 	/* input:
 	 *   x0: round key array, CTX
 	 *   x1: dst
@@ -306,10 +306,10 @@ SYM_FUNC_START(sm4_ce_cbc_dec)
 	st1		{RIV.16b}, [x3]
 
 	ret
-SYM_FUNC_END(sm4_ce_cbc_dec)
+SYM_LEAF_FUNC_END(sm4_ce_cbc_dec)
 
 .align 3
-SYM_FUNC_START(sm4_ce_cbc_cts_enc)
+SYM_LEAF_FUNC_START(sm4_ce_cbc_cts_enc)
 	/* input:
 	 *   x0: round key array, CTX
 	 *   x1: dst
@@ -354,10 +354,10 @@ SYM_FUNC_START(sm4_ce_cbc_cts_enc)
 	st1		{v1.16b}, [x1]
 
 	ret
-SYM_FUNC_END(sm4_ce_cbc_cts_enc)
+SYM_LEAF_FUNC_END(sm4_ce_cbc_cts_enc)
 
 .align 3
-SYM_FUNC_START(sm4_ce_cbc_cts_dec)
+SYM_LEAF_FUNC_START(sm4_ce_cbc_cts_dec)
 	/* input:
 	 *   x0: round key array, CTX
 	 *   x1: dst
@@ -400,10 +400,10 @@ SYM_FUNC_START(sm4_ce_cbc_cts_dec)
 	st1		{v0.16b}, [x1]
 
 	ret
-SYM_FUNC_END(sm4_ce_cbc_cts_dec)
+SYM_LEAF_FUNC_END(sm4_ce_cbc_cts_dec)
 
 .align 3
-SYM_FUNC_START(sm4_ce_ctr_enc)
+SYM_LEAF_FUNC_START(sm4_ce_ctr_enc)
 	/* input:
 	 *   x0: round key array, CTX
 	 *   x1: dst
@@ -506,7 +506,7 @@ SYM_FUNC_START(sm4_ce_ctr_enc)
 	stp		x7, x8, [x3]
 
 	ret
-SYM_FUNC_END(sm4_ce_ctr_enc)
+SYM_LEAF_FUNC_END(sm4_ce_ctr_enc)
 
 
 #define tweak_next(vt, vin, RTMP)					\
@@ -517,7 +517,7 @@ SYM_FUNC_END(sm4_ce_ctr_enc)
 		eor		vt.16b, vt.16b, RTMP.16b;
 
 .align 3
-SYM_FUNC_START(sm4_ce_xts_enc)
+SYM_LEAF_FUNC_START(sm4_ce_xts_enc)
 	/* input:
 	 *   x0: round key array, CTX
 	 *   x1: dst
@@ -681,10 +681,10 @@ SYM_FUNC_START(sm4_ce_xts_enc)
 
 .Lxts_enc_ret:
 	ret
-SYM_FUNC_END(sm4_ce_xts_enc)
+SYM_LEAF_FUNC_END(sm4_ce_xts_enc)
 
 .align 3
-SYM_FUNC_START(sm4_ce_xts_dec)
+SYM_LEAF_FUNC_START(sm4_ce_xts_dec)
 	/* input:
 	 *   x0: round key array, CTX
 	 *   x1: dst
@@ -848,10 +848,10 @@ SYM_FUNC_START(sm4_ce_xts_dec)
 
 .Lxts_dec_ret:
 	ret
-SYM_FUNC_END(sm4_ce_xts_dec)
+SYM_LEAF_FUNC_END(sm4_ce_xts_dec)
 
 .align 3
-SYM_FUNC_START(sm4_ce_mac_update)
+SYM_LEAF_FUNC_START(sm4_ce_mac_update)
 	/* input:
 	 *   x0: round key array, CTX
 	 *   x1: digest
@@ -917,7 +917,7 @@ SYM_FUNC_START(sm4_ce_mac_update)
 .Lmac_ret:
 	st1		{RMAC.16b}, [x1]
 	ret
-SYM_FUNC_END(sm4_ce_mac_update)
+SYM_LEAF_FUNC_END(sm4_ce_mac_update)
 
 
 	.section	".rodata", "a"
diff --git a/arch/arm64/crypto/sm4-ce-gcm-core.S b/arch/arm64/crypto/sm4-ce-gcm-core.S
index 347f25d75727..dac6db8160f2 100644
--- a/arch/arm64/crypto/sm4-ce-gcm-core.S
+++ b/arch/arm64/crypto/sm4-ce-gcm-core.S
@@ -259,7 +259,7 @@
 #define	RH4	v19
 
 .align 3
-SYM_FUNC_START(sm4_ce_pmull_ghash_setup)
+SYM_LEAF_FUNC_START(sm4_ce_pmull_ghash_setup)
 	/* input:
 	 *   x0: round key array, CTX
 	 *   x1: ghash table
@@ -293,10 +293,10 @@ SYM_FUNC_START(sm4_ce_pmull_ghash_setup)
 	st1		{RH1.16b-RH4.16b}, [x1]
 
 	ret
-SYM_FUNC_END(sm4_ce_pmull_ghash_setup)
+SYM_LEAF_FUNC_END(sm4_ce_pmull_ghash_setup)
 
 .align 3
-SYM_FUNC_START(pmull_ghash_update)
+SYM_LEAF_FUNC_START(pmull_ghash_update)
 	/* input:
 	 *   x0: ghash table
 	 *   x1: ghash result
@@ -368,10 +368,10 @@ SYM_FUNC_START(pmull_ghash_update)
 	st1		{RHASH.2d}, [x1]
 
 	ret
-SYM_FUNC_END(pmull_ghash_update)
+SYM_LEAF_FUNC_END(pmull_ghash_update)
 
 .align 3
-SYM_TYPED_FUNC_START(sm4_ce_pmull_gcm_enc)
+SYM_TYPED_LEAF_FUNC_START(sm4_ce_pmull_gcm_enc)
 	/* input:
 	 *   x0: round key array, CTX
 	 *   x1: dst
@@ -534,7 +534,7 @@ SYM_TYPED_FUNC_START(sm4_ce_pmull_gcm_enc)
 	st1		{RHASH.2d}, [x5]
 
 	ret
-SYM_FUNC_END(sm4_ce_pmull_gcm_enc)
+SYM_LEAF_FUNC_END(sm4_ce_pmull_gcm_enc)
 
 #undef	RR1
 #undef	RR3
@@ -582,7 +582,7 @@ SYM_FUNC_END(sm4_ce_pmull_gcm_enc)
 #define	RH3	v20
 
 .align 3
-SYM_TYPED_FUNC_START(sm4_ce_pmull_gcm_dec)
+SYM_TYPED_LEAF_FUNC_START(sm4_ce_pmull_gcm_dec)
 	/* input:
 	 *   x0: round key array, CTX
 	 *   x1: dst
@@ -726,7 +726,7 @@ SYM_TYPED_FUNC_START(sm4_ce_pmull_gcm_dec)
 	st1		{RHASH.2d}, [x5]
 
 	ret
-SYM_FUNC_END(sm4_ce_pmull_gcm_dec)
+SYM_LEAF_FUNC_END(sm4_ce_pmull_gcm_dec)
 
 	.section	".rodata", "a"
 	.align 4
diff --git a/arch/arm64/crypto/sm4-neon-core.S b/arch/arm64/crypto/sm4-neon-core.S
index 734dc7193610..d1fe37fce13a 100644
--- a/arch/arm64/crypto/sm4-neon-core.S
+++ b/arch/arm64/crypto/sm4-neon-core.S
@@ -257,7 +257,7 @@
 
 
 .align 3
-SYM_FUNC_START(sm4_neon_crypt)
+SYM_LEAF_FUNC_START(sm4_neon_crypt)
 	/* input:
 	 *   x0: round key array, CTX
 	 *   x1: dst
@@ -318,10 +318,10 @@ SYM_FUNC_START(sm4_neon_crypt)
 
 .Lcrypt_end:
 	ret
-SYM_FUNC_END(sm4_neon_crypt)
+SYM_LEAF_FUNC_END(sm4_neon_crypt)
 
 .align 3
-SYM_FUNC_START(sm4_neon_cbc_dec)
+SYM_LEAF_FUNC_START(sm4_neon_cbc_dec)
 	/* input:
 	 *   x0: round key array, CTX
 	 *   x1: dst
@@ -435,10 +435,10 @@ SYM_FUNC_START(sm4_neon_cbc_dec)
 	st1		{RIV.16b}, [x3]
 
 	ret
-SYM_FUNC_END(sm4_neon_cbc_dec)
+SYM_LEAF_FUNC_END(sm4_neon_cbc_dec)
 
 .align 3
-SYM_FUNC_START(sm4_neon_ctr_crypt)
+SYM_LEAF_FUNC_START(sm4_neon_ctr_crypt)
 	/* input:
 	 *   x0: round key array, CTX
 	 *   x1: dst
@@ -563,4 +563,4 @@ SYM_FUNC_START(sm4_neon_ctr_crypt)
 	stp		x7, x8, [x3]
 
 	ret
-SYM_FUNC_END(sm4_neon_ctr_crypt)
+SYM_LEAF_FUNC_END(sm4_neon_ctr_crypt)
diff --git a/arch/arm64/include/asm/linkage.h b/arch/arm64/include/asm/linkage.h
index 40bd17add539..6b8cb36a3343 100644
--- a/arch/arm64/include/asm/linkage.h
+++ b/arch/arm64/include/asm/linkage.h
@@ -3,6 +3,12 @@
 
 #ifdef __ASSEMBLER__
 #include <asm/assembler.h>
+
+/*
+ * Do not generate .eh_frame.  Only generate .debug_frame and optionally
+ * .sframe (via assembler option --gsframe[-N]).
+ */
+	.cfi_sections .debug_frame
 #endif
 
 #define __ALIGN		.balign CONFIG_FUNCTION_ALIGNMENT
@@ -43,4 +49,28 @@
 	SYM_TYPED_START(name, SYM_L_GLOBAL, SYM_A_ALIGN)	\
 	bti c ;
 
+
+/*
+ * SYM_[TYPED_]LEAF_FUNC_[START|END] macros add CFI minimal CFI directives
+ * allowing .sframe data to be generated for functions which do not modify the
+ * LR (x30). Unwind data will not be correct if these macros are used on
+ * non-leaf functions, as additional CFI directives would be necessary in such
+ * cases.
+ */
+#define SYM_LEAF_FUNC_START(name)			\
+	.cfi_startproc ;				\
+	SYM_FUNC_START(name)
+
+#define SYM_LEAF_FUNC_END(name)				\
+	.cfi_endproc ;					\
+	SYM_FUNC_END(name)
+
+#define SYM_LEAF_FUNC_START_LOCAL(name)			\
+	.cfi_startproc ;				\
+	SYM_FUNC_START_LOCAL(name)
+
+#define SYM_TYPED_LEAF_FUNC_START(name)			\
+	.cfi_startproc ;				\
+	SYM_TYPED_FUNC_START(name)
+
 #endif
diff --git a/arch/arm64/lib/clear_page.S b/arch/arm64/lib/clear_page.S
index bd6f7d5eb6eb..fceb875c3570 100644
--- a/arch/arm64/lib/clear_page.S
+++ b/arch/arm64/lib/clear_page.S
@@ -14,7 +14,7 @@
  * Parameters:
  *	x0 - dest
  */
-SYM_FUNC_START(__pi_clear_page)
+SYM_LEAF_FUNC_START(__pi_clear_page)
 #ifdef CONFIG_AS_HAS_MOPS
 	.arch_extension mops
 alternative_if_not ARM64_HAS_MOPS
@@ -48,6 +48,6 @@ alternative_else_nop_endif
 	tst	x0, #(PAGE_SIZE - 1)
 	b.ne	2b
 	ret
-SYM_FUNC_END(__pi_clear_page)
+SYM_LEAF_FUNC_END(__pi_clear_page)
 SYM_FUNC_ALIAS(clear_page, __pi_clear_page)
 EXPORT_SYMBOL(clear_page)
diff --git a/arch/arm64/lib/clear_user.S b/arch/arm64/lib/clear_user.S
index de9a303b6ad0..cf07c010ca92 100644
--- a/arch/arm64/lib/clear_user.S
+++ b/arch/arm64/lib/clear_user.S
@@ -17,7 +17,7 @@
  * Alignment fixed up by hardware.
  */
 
-SYM_FUNC_START(__arch_clear_user)
+SYM_LEAF_FUNC_START(__arch_clear_user)
 	add	x2, x0, x1
 
 #ifdef CONFIG_AS_HAS_MOPS
@@ -68,5 +68,5 @@ USER(7f, sttrb	wzr, [x2, #-1])
 8:	add	x0, x0, #4	// ...or the second word of the 4-7 byte case
 9:	sub	x0, x2, x0
 	ret
-SYM_FUNC_END(__arch_clear_user)
+SYM_LEAF_FUNC_END(__arch_clear_user)
 EXPORT_SYMBOL(__arch_clear_user)
diff --git a/arch/arm64/lib/copy_from_user.S b/arch/arm64/lib/copy_from_user.S
index 400057d607ec..e9bb9c2dd8e1 100644
--- a/arch/arm64/lib/copy_from_user.S
+++ b/arch/arm64/lib/copy_from_user.S
@@ -61,7 +61,7 @@
 
 end	.req	x5
 srcin	.req	x15
-SYM_FUNC_START(__arch_copy_from_user)
+SYM_LEAF_FUNC_START(__arch_copy_from_user)
 	add	end, x0, x2
 	mov	srcin, x1
 #include "copy_template.S"
@@ -79,5 +79,5 @@ USER(9998f, ldtrb tmp1w, [srcin])
 	strb	tmp1w, [dst], #1
 9998:	sub	x0, end, dst			// bytes not copied
 	ret
-SYM_FUNC_END(__arch_copy_from_user)
+SYM_LEAF_FUNC_END(__arch_copy_from_user)
 EXPORT_SYMBOL(__arch_copy_from_user)
diff --git a/arch/arm64/lib/copy_page.S b/arch/arm64/lib/copy_page.S
index e6374e7e5511..b6048d648306 100644
--- a/arch/arm64/lib/copy_page.S
+++ b/arch/arm64/lib/copy_page.S
@@ -17,7 +17,7 @@
  *	x0 - dest
  *	x1 - src
  */
-SYM_FUNC_START(__pi_copy_page)
+SYM_LEAF_FUNC_START(__pi_copy_page)
 #ifdef CONFIG_AS_HAS_MOPS
 	.arch_extension mops
 alternative_if_not ARM64_HAS_MOPS
@@ -77,6 +77,6 @@ alternative_else_nop_endif
 	stnp	x16, x17, [x0, #112 - 256]
 
 	ret
-SYM_FUNC_END(__pi_copy_page)
+SYM_LEAF_FUNC_END(__pi_copy_page)
 SYM_FUNC_ALIAS(copy_page, __pi_copy_page)
 EXPORT_SYMBOL(copy_page)
diff --git a/arch/arm64/lib/copy_to_user.S b/arch/arm64/lib/copy_to_user.S
index 819f2e3fc7a9..aea10a5b3cba 100644
--- a/arch/arm64/lib/copy_to_user.S
+++ b/arch/arm64/lib/copy_to_user.S
@@ -60,7 +60,7 @@
 
 end	.req	x5
 srcin	.req	x15
-SYM_FUNC_START(__arch_copy_to_user)
+SYM_LEAF_FUNC_START(__arch_copy_to_user)
 	add	end, x0, x2
 	mov	srcin, x1
 #include "copy_template.S"
@@ -79,5 +79,5 @@ USER(9998f, sttrb tmp1w, [dst])
 	add	dst, dst, #1
 9998:	sub	x0, end, dst			// bytes not copied
 	ret
-SYM_FUNC_END(__arch_copy_to_user)
+SYM_LEAF_FUNC_END(__arch_copy_to_user)
 EXPORT_SYMBOL(__arch_copy_to_user)
diff --git a/arch/arm64/lib/memchr.S b/arch/arm64/lib/memchr.S
index 37a9f2a4f7f4..909599bba5bf 100644
--- a/arch/arm64/lib/memchr.S
+++ b/arch/arm64/lib/memchr.S
@@ -38,7 +38,7 @@
 
 	.p2align 4
 	nop
-SYM_FUNC_START(__pi_memchr)
+SYM_LEAF_FUNC_START(__pi_memchr)
 	and	chrin, chrin, #0xff
 	lsr	wordcnt, cntin, #3
 	cbz	wordcnt, L(byte_loop)
@@ -71,6 +71,6 @@ CPU_LE(	rev	tmp, tmp)
 L(not_found):
 	mov	result, #0
 	ret
-SYM_FUNC_END(__pi_memchr)
+SYM_LEAF_FUNC_END(__pi_memchr)
 SYM_FUNC_ALIAS_WEAK(memchr, __pi_memchr)
 EXPORT_SYMBOL_NOKASAN(memchr)
diff --git a/arch/arm64/lib/memcmp.S b/arch/arm64/lib/memcmp.S
index a5ccf2c55f91..91ee3a00e664 100644
--- a/arch/arm64/lib/memcmp.S
+++ b/arch/arm64/lib/memcmp.S
@@ -32,7 +32,7 @@
 #define tmp1		x7
 #define tmp2		x8
 
-SYM_FUNC_START(__pi_memcmp)
+SYM_LEAF_FUNC_START(__pi_memcmp)
 	subs	limit, limit, 8
 	b.lo	L(less8)
 
@@ -134,6 +134,6 @@ L(byte_loop):
 	b.eq	L(byte_loop)
 	sub	result, data1w, data2w
 	ret
-SYM_FUNC_END(__pi_memcmp)
+SYM_LEAF_FUNC_END(__pi_memcmp)
 SYM_FUNC_ALIAS_WEAK(memcmp, __pi_memcmp)
 EXPORT_SYMBOL_NOKASAN(memcmp)
diff --git a/arch/arm64/lib/memcpy.S b/arch/arm64/lib/memcpy.S
index 9b99106fb95f..90caf402ea7d 100644
--- a/arch/arm64/lib/memcpy.S
+++ b/arch/arm64/lib/memcpy.S
@@ -57,7 +57,7 @@
    The loop tail is handled by always copying 64 bytes from the end.
 */
 
-SYM_FUNC_START_LOCAL(__pi_memcpy_generic)
+SYM_LEAF_FUNC_START_LOCAL(__pi_memcpy_generic)
 	add	srcend, src, count
 	add	dstend, dstin, count
 	cmp	count, 128
@@ -238,11 +238,11 @@ L(copy64_from_start):
 	stp	B_l, B_h, [dstin, 16]
 	stp	C_l, C_h, [dstin]
 	ret
-SYM_FUNC_END(__pi_memcpy_generic)
+SYM_LEAF_FUNC_END(__pi_memcpy_generic)
 
 #ifdef CONFIG_AS_HAS_MOPS
 	.arch_extension mops
-SYM_FUNC_START(__pi_memcpy)
+SYM_LEAF_FUNC_START(__pi_memcpy)
 alternative_if_not ARM64_HAS_MOPS
 	b	__pi_memcpy_generic
 alternative_else_nop_endif
@@ -252,7 +252,7 @@ alternative_else_nop_endif
 	cpym	[dst]!, [src]!, count!
 	cpye	[dst]!, [src]!, count!
 	ret
-SYM_FUNC_END(__pi_memcpy)
+SYM_LEAF_FUNC_END(__pi_memcpy)
 #else
 SYM_FUNC_ALIAS(__pi_memcpy, __pi_memcpy_generic)
 #endif
diff --git a/arch/arm64/lib/memset.S b/arch/arm64/lib/memset.S
index 97157da65ec6..8ee307f5891b 100644
--- a/arch/arm64/lib/memset.S
+++ b/arch/arm64/lib/memset.S
@@ -43,7 +43,7 @@ dst		.req	x8
 tmp3w		.req	w9
 tmp3		.req	x9
 
-SYM_FUNC_START_LOCAL(__pi_memset_generic)
+SYM_LEAF_FUNC_START_LOCAL(__pi_memset_generic)
 	mov	dst, dstin	/* Preserve return value.  */
 	and	A_lw, val, #255
 	orr	A_lw, A_lw, A_lw, lsl #8
@@ -202,11 +202,11 @@ SYM_FUNC_START_LOCAL(__pi_memset_generic)
 	ands	count, count, zva_bits_x
 	b.ne	.Ltail_maybe_long
 	ret
-SYM_FUNC_END(__pi_memset_generic)
+SYM_LEAF_FUNC_END(__pi_memset_generic)
 
 #ifdef CONFIG_AS_HAS_MOPS
 	.arch_extension mops
-SYM_FUNC_START(__pi_memset)
+SYM_LEAF_FUNC_START(__pi_memset)
 alternative_if_not ARM64_HAS_MOPS
 	b	__pi_memset_generic
 alternative_else_nop_endif
@@ -216,7 +216,7 @@ alternative_else_nop_endif
 	setm	[dst]!, count!, val_x
 	sete	[dst]!, count!, val_x
 	ret
-SYM_FUNC_END(__pi_memset)
+SYM_LEAF_FUNC_END(__pi_memset)
 #else
 SYM_FUNC_ALIAS(__pi_memset, __pi_memset_generic)
 #endif
diff --git a/arch/arm64/lib/mte.S b/arch/arm64/lib/mte.S
index 5018ac03b6bf..442202cd02a3 100644
--- a/arch/arm64/lib/mte.S
+++ b/arch/arm64/lib/mte.S
@@ -27,14 +27,14 @@
  * Clear the tags in a page
  *   x0 - address of the page to be cleared
  */
-SYM_FUNC_START(mte_clear_page_tags)
+SYM_LEAF_FUNC_START(mte_clear_page_tags)
 	multitag_transfer_size x1, x2
 1:	stgm	xzr, [x0]
 	add	x0, x0, x1
 	tst	x0, #(PAGE_SIZE - 1)
 	b.ne	1b
 	ret
-SYM_FUNC_END(mte_clear_page_tags)
+SYM_LEAF_FUNC_END(mte_clear_page_tags)
 
 /*
  * Zero the page and tags at the same time
@@ -42,7 +42,7 @@ SYM_FUNC_END(mte_clear_page_tags)
  * Parameters:
  *	x0 - address to the beginning of the page
  */
-SYM_FUNC_START(mte_zero_clear_page_tags)
+SYM_LEAF_FUNC_START(mte_zero_clear_page_tags)
 	and	x0, x0, #(1 << MTE_TAG_SHIFT) - 1	// clear the tag
 	mrs	x1, dczid_el0
 	tbnz	x1, #4, 2f	// Branch if DC GZVA is prohibited
@@ -60,14 +60,14 @@ SYM_FUNC_START(mte_zero_clear_page_tags)
 	tst	x0, #(PAGE_SIZE - 1)
 	b.ne	2b
 	ret
-SYM_FUNC_END(mte_zero_clear_page_tags)
+SYM_LEAF_FUNC_END(mte_zero_clear_page_tags)
 
 /*
  * Copy the tags from the source page to the destination one
  *   x0 - address of the destination page
  *   x1 - address of the source page
  */
-SYM_FUNC_START(mte_copy_page_tags)
+SYM_LEAF_FUNC_START(mte_copy_page_tags)
 	mov	x2, x0
 	mov	x3, x1
 	multitag_transfer_size x5, x6
@@ -78,7 +78,7 @@ SYM_FUNC_START(mte_copy_page_tags)
 	tst	x2, #(PAGE_SIZE - 1)
 	b.ne	1b
 	ret
-SYM_FUNC_END(mte_copy_page_tags)
+SYM_LEAF_FUNC_END(mte_copy_page_tags)
 
 /*
  * Read tags from a user buffer (one tag per byte) and set the corresponding
@@ -89,7 +89,7 @@ SYM_FUNC_END(mte_copy_page_tags)
  * Returns:
  *   x0 - number of tags read/set
  */
-SYM_FUNC_START(mte_copy_tags_from_user)
+SYM_LEAF_FUNC_START(mte_copy_tags_from_user)
 	mov	x3, x1
 	cbz	x2, 2f
 1:
@@ -103,7 +103,7 @@ USER(2f, ldtrb	w4, [x1])
 	// exception handling and function return
 2:	sub	x0, x1, x3		// update the number of tags set
 	ret
-SYM_FUNC_END(mte_copy_tags_from_user)
+SYM_LEAF_FUNC_END(mte_copy_tags_from_user)
 
 /*
  * Get the tags from a kernel address range and write the tag values to the
@@ -114,7 +114,7 @@ SYM_FUNC_END(mte_copy_tags_from_user)
  * Returns:
  *   x0 - number of tags read/set
  */
-SYM_FUNC_START(mte_copy_tags_to_user)
+SYM_LEAF_FUNC_START(mte_copy_tags_to_user)
 	mov	x3, x0
 	cbz	x2, 2f
 1:
@@ -129,14 +129,14 @@ USER(2f, sttrb	w4, [x0])
 	// exception handling and function return
 2:	sub	x0, x0, x3		// update the number of tags copied
 	ret
-SYM_FUNC_END(mte_copy_tags_to_user)
+SYM_LEAF_FUNC_END(mte_copy_tags_to_user)
 
 /*
  * Save the tags in a page
  *   x0 - page address
  *   x1 - tag storage, MTE_PAGE_TAG_STORAGE bytes
  */
-SYM_FUNC_START(mte_save_page_tags)
+SYM_LEAF_FUNC_START(mte_save_page_tags)
 	multitag_transfer_size x7, x5
 1:
 	mov	x2, #0
@@ -153,14 +153,14 @@ SYM_FUNC_START(mte_save_page_tags)
 	b.ne	1b
 
 	ret
-SYM_FUNC_END(mte_save_page_tags)
+SYM_LEAF_FUNC_END(mte_save_page_tags)
 
 /*
  * Restore the tags in a page
  *   x0 - page address
  *   x1 - tag storage, MTE_PAGE_TAG_STORAGE bytes
  */
-SYM_FUNC_START(mte_restore_page_tags)
+SYM_LEAF_FUNC_START(mte_restore_page_tags)
 	multitag_transfer_size x7, x5
 1:
 	ldr	x2, [x1], #8
@@ -174,4 +174,4 @@ SYM_FUNC_START(mte_restore_page_tags)
 	b.ne	1b
 
 	ret
-SYM_FUNC_END(mte_restore_page_tags)
+SYM_LEAF_FUNC_END(mte_restore_page_tags)
diff --git a/arch/arm64/lib/strchr.S b/arch/arm64/lib/strchr.S
index 94ee67a6b212..455582efd07a 100644
--- a/arch/arm64/lib/strchr.S
+++ b/arch/arm64/lib/strchr.S
@@ -18,7 +18,7 @@
  * Returns:
  *	x0 - address of first occurrence of 'c' or 0
  */
-SYM_FUNC_START(__pi_strchr)
+SYM_LEAF_FUNC_START(__pi_strchr)
 	and	w1, w1, #0xff
 1:	ldrb	w2, [x0], #1
 	cmp	w2, w1
@@ -28,7 +28,7 @@ SYM_FUNC_START(__pi_strchr)
 	cmp	w2, w1
 	csel	x0, x0, xzr, eq
 	ret
-SYM_FUNC_END(__pi_strchr)
+SYM_LEAF_FUNC_END(__pi_strchr)
 
 SYM_FUNC_ALIAS_WEAK(strchr, __pi_strchr)
 EXPORT_SYMBOL_NOKASAN(strchr)
diff --git a/arch/arm64/lib/strcmp.S b/arch/arm64/lib/strcmp.S
index 9b89b4533607..d0ce2040a32b 100644
--- a/arch/arm64/lib/strcmp.S
+++ b/arch/arm64/lib/strcmp.S
@@ -53,7 +53,7 @@
    NUL too in big-endian, byte-reverse the data before the NUL check.  */
 
 
-SYM_FUNC_START(__pi_strcmp)
+SYM_LEAF_FUNC_START(__pi_strcmp)
 	sub	off2, src2, src1
 	mov	zeroones, REP8_01
 	and	tmp, src1, 7
@@ -185,6 +185,6 @@ L(tail):
 L(done):
 	sub	result, data1, data2
 	ret
-SYM_FUNC_END(__pi_strcmp)
+SYM_LEAF_FUNC_END(__pi_strcmp)
 SYM_FUNC_ALIAS_WEAK(strcmp, __pi_strcmp)
 EXPORT_SYMBOL_NOKASAN(strcmp)
diff --git a/arch/arm64/lib/strlen.S b/arch/arm64/lib/strlen.S
index 4919fe81ae54..a5d4151548b5 100644
--- a/arch/arm64/lib/strlen.S
+++ b/arch/arm64/lib/strlen.S
@@ -79,7 +79,7 @@
 	   whether the first fetch, which may be misaligned, crosses a page
 	   boundary.  */
 
-SYM_FUNC_START(__pi_strlen)
+SYM_LEAF_FUNC_START(__pi_strlen)
 	and	tmp1, srcin, MIN_PAGE_SIZE - 1
 	mov	zeroones, REP8_01
 	cmp	tmp1, MIN_PAGE_SIZE - 16
@@ -208,6 +208,6 @@ L(page_cross):
 	csel	data1, data1, tmp4, eq
 	csel	data2, data2, tmp2, eq
 	b	L(page_cross_entry)
-SYM_FUNC_END(__pi_strlen)
+SYM_LEAF_FUNC_END(__pi_strlen)
 SYM_FUNC_ALIAS_WEAK(strlen, __pi_strlen)
 EXPORT_SYMBOL_NOKASAN(strlen)
diff --git a/arch/arm64/lib/strncmp.S b/arch/arm64/lib/strncmp.S
index fe7bbc0b42a7..8fd5c5d7dc2a 100644
--- a/arch/arm64/lib/strncmp.S
+++ b/arch/arm64/lib/strncmp.S
@@ -58,7 +58,7 @@
 #define LS_BK lsl
 #endif
 
-SYM_FUNC_START(__pi_strncmp)
+SYM_LEAF_FUNC_START(__pi_strncmp)
 	cbz	limit, L(ret0)
 	eor	tmp1, src1, src2
 	mov	zeroones, #REP8_01
@@ -305,6 +305,6 @@ L(syndrome_check):
 L(ret0):
 	mov	result, #0
 	ret
-SYM_FUNC_END(__pi_strncmp)
+SYM_LEAF_FUNC_END(__pi_strncmp)
 SYM_FUNC_ALIAS_WEAK(strncmp, __pi_strncmp)
 EXPORT_SYMBOL_NOKASAN(strncmp)
diff --git a/arch/arm64/lib/strnlen.S b/arch/arm64/lib/strnlen.S
index d5ac0e10a01d..9f3f02e3f7e2 100644
--- a/arch/arm64/lib/strnlen.S
+++ b/arch/arm64/lib/strnlen.S
@@ -47,7 +47,7 @@ limit_wd	.req	x14
 #define REP8_7f 0x7f7f7f7f7f7f7f7f
 #define REP8_80 0x8080808080808080
 
-SYM_FUNC_START(__pi_strnlen)
+SYM_LEAF_FUNC_START(__pi_strnlen)
 	cbz	limit, .Lhit_limit
 	mov	zeroones, #REP8_01
 	bic	src, srcin, #15
@@ -156,7 +156,7 @@ CPU_LE( lsr	tmp2, tmp2, tmp4 )	/* Shift (tmp1 & 63).  */
 .Lhit_limit:
 	mov	len, limit
 	ret
-SYM_FUNC_END(__pi_strnlen)
+SYM_LEAF_FUNC_END(__pi_strnlen)
 
 SYM_FUNC_ALIAS_WEAK(strnlen, __pi_strnlen)
 EXPORT_SYMBOL_NOKASAN(strnlen)
diff --git a/arch/arm64/lib/tishift.S b/arch/arm64/lib/tishift.S
index a88613834fb0..b12d7f6a6003 100644
--- a/arch/arm64/lib/tishift.S
+++ b/arch/arm64/lib/tishift.S
@@ -7,7 +7,7 @@
 
 #include <asm/assembler.h>
 
-SYM_FUNC_START(__ashlti3)
+SYM_LEAF_FUNC_START(__ashlti3)
 	cbz	x2, 1f
 	mov	x3, #64
 	sub	x3, x3, x2
@@ -26,10 +26,10 @@ SYM_FUNC_START(__ashlti3)
 	lsl	x1, x0, x1
 	mov	x0, x2
 	ret
-SYM_FUNC_END(__ashlti3)
+SYM_LEAF_FUNC_END(__ashlti3)
 EXPORT_SYMBOL(__ashlti3)
 
-SYM_FUNC_START(__ashrti3)
+SYM_LEAF_FUNC_START(__ashrti3)
 	cbz	x2, 1f
 	mov	x3, #64
 	sub	x3, x3, x2
@@ -48,10 +48,10 @@ SYM_FUNC_START(__ashrti3)
 	asr	x0, x1, x0
 	mov	x1, x2
 	ret
-SYM_FUNC_END(__ashrti3)
+SYM_LEAF_FUNC_END(__ashrti3)
 EXPORT_SYMBOL(__ashrti3)
 
-SYM_FUNC_START(__lshrti3)
+SYM_LEAF_FUNC_START(__lshrti3)
 	cbz	x2, 1f
 	mov	x3, #64
 	sub	x3, x3, x2
@@ -70,5 +70,5 @@ SYM_FUNC_START(__lshrti3)
 	lsr	x0, x1, x0
 	mov	x1, x2
 	ret
-SYM_FUNC_END(__lshrti3)
+SYM_LEAF_FUNC_END(__lshrti3)
 EXPORT_SYMBOL(__lshrti3)
-- 
2.54.0.563.g4f69b47b94-goog


