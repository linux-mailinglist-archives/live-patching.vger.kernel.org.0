Return-Path: <live-patching+bounces-2013-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sCVqFZYojmkMAQEAu9opvQ
	(envelope-from <live-patching+bounces-2013-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 12 Feb 2026 20:23:02 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F348F130AE0
	for <lists+live-patching@lfdr.de>; Thu, 12 Feb 2026 20:23:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 480CD30175E1
	for <lists+live-patching@lfdr.de>; Thu, 12 Feb 2026 19:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E16A2C028B;
	Thu, 12 Feb 2026 19:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GcIWRLgq"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3F629BDAE
	for <live-patching@vger.kernel.org>; Thu, 12 Feb 2026 19:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770924177; cv=none; b=TBnwCWT+BJGkCU64xIwI+PecKyfhXx8W6KZKrHuuIGCUqcXRF6qSu4ZQWWtMzj7VwEj6U+N2AapQ440xcLePWSwQK6W0n7gGbm0LTSa0Jlw2FdFFLS3g6OR7eclxAZs1LRx8EBsHfMRmeZ/RMtR4oNffumMKTj5xVbPxy8fjCoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770924177; c=relaxed/simple;
	bh=6hTarSX08qp0an0EjII3f+4fy7Fiejol7qicmJxqryY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCpeJVKP2qo2wH75ztCh5ZuXT8eEbp5dREM9dg7h18kAvPxcElznCR5eWBgskeiJtjLUfzOKeYiKRzS7CtZ6Vb75TPavK2cscYFSzr57aXzlcmYg9Jl2XGn0bKrLX7bTJvX3eayxxBVrMZC6dVT+qN152azb+pZrOBEeAU4ocN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GcIWRLgq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2562FC16AAE;
	Thu, 12 Feb 2026 19:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770924177;
	bh=6hTarSX08qp0an0EjII3f+4fy7Fiejol7qicmJxqryY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GcIWRLgqj4KkknP1p4rL25W2HOuVgvLDU25YUK3wdKEgIlY6Otvh7KFzxUbhfh733
	 kIKmdva2bWZfxiU03oKL0Afqc+l5uVKiYgsTZxcF+lmO+TeGXZnGbwqBV8GETkKRDO
	 pX6s1flAomtmbdo+d4mSNavrtgA+nlqo6pRPsx22m+4mVcGSbkI3YHBxW/kKYoBTEU
	 Jg7y1jz9BxeiAvXlI1LqTUyF3IMlDvCnJzkqNT0BMz0xcNCncdOORgTPBJrnzHkDde
	 hPdduSuNYbnXjlHLmHzPTBIyBKfo1Fwmnr4fB5ubo91NCedKmG0FQ+AQhiscvcq+ZY
	 iHkRYuNGmPmTA==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH 7/8] objtool/klp: Correlate locals to globals
Date: Thu, 12 Feb 2026 11:22:00 -0800
Message-ID: <20260212192201.3593879-8-song@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212192201.3593879-1-song@kernel.org>
References: <20260212192201.3593879-1-song@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2013-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F348F130AE0
X-Rspamd-Action: no action

Allow correlating original locals to patched globals, and vice versa.
This is needed when:

1. User adds/removes "static" for a function.
2. CONFIG_LTO_CLANG_THIN promotes local functions and objects to global
   and add .llvm.<hash> suffix.

Given this is a less common scenario, show warnings when this is needed.

Signed-off-by: Song Liu <song@kernel.org>
---
 tools/objtool/klp-diff.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index cd82f674862a..f7a31ea2cbe7 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -483,6 +483,40 @@ static int correlate_symbols(struct elfs *e)
 		}
 	}
 
+	/* Correlate original locals with patched globals */
+	for_each_sym(e->orig, sym1) {
+		if (sym1->twin || dont_correlate(sym1) || !is_local_sym(sym1))
+			continue;
+		sym2 = find_global_symbol_by_name(e->patched, sym1->name);
+		if (!sym2) {
+			sym2 = find_global_symbol_by_demangled_name(e->patched,
+								    sym1->demangled_name);
+		}
+		if (sym2 && !sym2->twin) {
+			sym1->twin = sym2;
+			sym2->twin = sym1;
+			WARN("correlate LOCAL %s (origial) to GLOBAL %s (patched)",
+			     sym1->name, sym2->name);
+		}
+	}
+
+	/* Correlate original globals with patched locals */
+	for_each_sym(e->patched, sym2) {
+		if (sym2->twin || dont_correlate(sym2) || !is_local_sym(sym2))
+			continue;
+		sym1 = find_global_symbol_by_name(e->orig, sym2->name);
+		if (!sym1) {
+			sym1 = find_global_symbol_by_demangled_name(e->orig,
+								    sym2->demangled_name);
+		}
+		if (sym1 && !sym1->twin) {
+			sym2->twin = sym1;
+			sym1->twin = sym2;
+			WARN("correlate GLOBAL %s (origial) to LOCAL %s (patched)",
+			     sym1->name, sym2->name);
+		}
+	}
+
 	for_each_sym(e->orig, sym1) {
 		if (sym1->twin || dont_correlate(sym1))
 			continue;
-- 
2.47.3


