Return-Path: <live-patching+bounces-2110-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cFkeDlP5qGlzzwAAu9opvQ
	(envelope-from <live-patching+bounces-2110-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 04:32:35 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A5A2C20A8A2
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 04:32:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8FB213056170
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 03:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9098A277037;
	Thu,  5 Mar 2026 03:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bG6B1eBa"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E38726E71F;
	Thu,  5 Mar 2026 03:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772681506; cv=none; b=k8wUxH5vpHep64HvKIx6vegfdjdES8wJEmg7Rxkijq0zxkYnwsanqqLM5/Tl2qQI0jSGXoAq0DZNdMflW/K2ErqtIyFdcbL2HiCQy2MJJ4OJoYGdgF1f/m2wTFMcFmlGyGPkVqvhN0J3mrvreJqeqJvILAwBHMOL6VT9JxYx8+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772681506; c=relaxed/simple;
	bh=uw8loNTdetJKJb0ecjjs3Ff+STe7ASk8f759M6OLnzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xk/8aeHA7De0TiGYfIfX4LrNOgKyE7lJBf6OveNNbTgoaDeHCWL+WKP5d2HCPR/lFVbIXGcxAo/IEIZufMtlWAmLCtVV1Kbd3LKjARFCYbVX7cEa6UR+12s5PE8Kx8uCbuqDGBCeklen94a2wmlj1Kr+Z57Grj5ae0stx2+cLmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bG6B1eBa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A26C2BC9E;
	Thu,  5 Mar 2026 03:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772681506;
	bh=uw8loNTdetJKJb0ecjjs3Ff+STe7ASk8f759M6OLnzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bG6B1eBayupZYr06CVbq6jITb5ZWNrMTkugVPMLEV56qbUM/nzPPBUKnVBwneACmN
	 sJsv9K8425eeguY7bLhGYQq7MNpbnfFYMGVs86/pvokhgK3v2xo16VRGq2rBg2YvfQ
	 7W5/8MFGo9qXmyxBQfqVdSzEvJ/VFSvDLU5MMZKJsV7+sLgQ19hql7ZYX0Bc95mxgj
	 iIv7trv1roF1PTRKIOkb7jpcICna2KJd55vzsNjOuHQlqxrPZnzdNE6IbBYrqgOWHG
	 3LppCxN2krnh+IixH2pX66qufhL1YhpYDXImJw5UX6INk1XJYxbtUlEbNhW89iZtQQ
	 NeoOOrNFBP/Iw==
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
Subject: [PATCH 02/14] objtool: Fix ERROR_INSN() error message
Date: Wed,  4 Mar 2026 19:31:21 -0800
Message-ID: <c4fe793bb3d23fac2c636b2511059af1158410e2.1772681234.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: A5A2C20A8A2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2110-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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

Confusingly, ERROR_INSN() shows "warning:" instead of "error:".  Fix that.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/include/objtool/warn.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/include/objtool/warn.h b/tools/objtool/include/objtool/warn.h
index 2b27b54096b8..fa8b7d292e83 100644
--- a/tools/objtool/include/objtool/warn.h
+++ b/tools/objtool/include/objtool/warn.h
@@ -107,7 +107,7 @@ static inline char *offstr(struct section *sec, unsigned long offset)
 #define ERROR_ELF(format, ...) __WARN_ELF(ERROR_STR, format, ##__VA_ARGS__)
 #define ERROR_GLIBC(format, ...) __WARN_GLIBC(ERROR_STR, format, ##__VA_ARGS__)
 #define ERROR_FUNC(sec, offset, format, ...) __WARN_FUNC(ERROR_STR, sec, offset, format, ##__VA_ARGS__)
-#define ERROR_INSN(insn, format, ...) WARN_FUNC(insn->sec, insn->offset, format, ##__VA_ARGS__)
+#define ERROR_INSN(insn, format, ...) ERROR_FUNC(insn->sec, insn->offset, format, ##__VA_ARGS__)
 
 extern bool debug;
 extern int indent;
-- 
2.53.0


