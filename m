Return-Path: <live-patching+bounces-2087-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ADPOOvmZn2mucwQAu9opvQ
	(envelope-from <live-patching+bounces-2087-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 01:55:21 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 85EB319FA83
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 01:55:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 41DAC3037D5A
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 00:55:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0765731984E;
	Thu, 26 Feb 2026 00:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LH88JAnB"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85064A21
	for <live-patching@vger.kernel.org>; Thu, 26 Feb 2026 00:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772067318; cv=none; b=BxpizUnTTq0EdcQ8mhzqwJOXF/7Xo3qiwSwmNmhZ8qNDWXPWXZrbeV1/pY7l62W2yYZM2KZ+O6Z0bjz4Lcc7b+YmOPVP5o7ps2lTQmuyiMrq0XtQNwKhHJgCk0dhCV75Itn9jvDDsmooBxkYy0Knzy2E15Bsk+hIUGHL1fKlZAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772067318; c=relaxed/simple;
	bh=Hcrwx/LU0/giVJamR3ZOtIWy+ComgossEN4UDTBsnLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGJ5BZrzI0JuZjgXtb2JrWTXzPr6sEHuWmSlhdVmBfw1EbqzT+sDj1nwYG8kHjkfVuw30SPuEcezpL0k60qMfWLjIm/+AAJI7VDnz8f3dzK2gVV55TrRAIGBckHhEXYIH530tiMktVIrChHH3mFhniy+g0dbxaJmdYsx+U1qsqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LH88JAnB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CB3C116D0;
	Thu, 26 Feb 2026 00:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772067318;
	bh=Hcrwx/LU0/giVJamR3ZOtIWy+ComgossEN4UDTBsnLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LH88JAnB16MHX7b1+EzfKmQreuUsMVAydeTq4vmkOUmUCzoHMRDG4nZKV9dJ1pfgJ
	 EDR7HB1WKuRWN1066RadodmkteW7xrNcKXDh4iJjrAo9hQkJuHM/8q6ZPqRl+L99oB
	 qTL/bjEmBJ/5yEacSmT7kaLI2yDd75V/rpmSMjgSvV3vpkPJWdvEX8wQ7r4FOA2UP1
	 EnLk6430TzF5duua1pp1Sxz13MUZuhNINmVMwLOyh323HENQ9hnY1bjMZdtmwwlsdG
	 2DiFbS77KBgyDdzr0zSRxyC7MiLCmS9AbGcHnO8dBsDFr7f13xACAA9nasRdiJUVsH
	 VfVl0A8GP/vdw==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH v3 7/8] objtool/klp: Correlate locals to globals
Date: Wed, 25 Feb 2026 16:54:35 -0800
Message-ID: <20260226005436.379303-8-song@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260226005436.379303-1-song@kernel.org>
References: <20260226005436.379303-1-song@kernel.org>
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
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2087-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 85EB319FA83
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
index 92043da0ed0b..5cda965807a5 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -517,6 +517,40 @@ static int correlate_symbols(struct elfs *e)
 		}
 	}
 
+	/* Correlate original locals with patched globals */
+	for_each_sym(e->orig, sym1) {
+		if (sym1->twin || dont_correlate(sym1) || !is_local_sym(sym1))
+			continue;
+
+		sym2 = find_global_symbol_by_name(e->patched, sym1->name);
+		if (!sym2 && find_global_symbol_by_demangled_name(e->patched, sym1, &sym2))
+			return -1;
+
+		if (sym2 && !sym2->twin) {
+			sym1->twin = sym2;
+			sym2->twin = sym1;
+			WARN("correlate LOCAL %s (original) to GLOBAL %s (patched)",
+			     sym1->name, sym2->name);
+		}
+	}
+
+	/* Correlate original globals with patched locals */
+	for_each_sym(e->patched, sym2) {
+		if (sym2->twin || dont_correlate(sym2) || !is_local_sym(sym2))
+			continue;
+
+		sym1 = find_global_symbol_by_name(e->orig, sym2->name);
+		if (!sym1 && find_global_symbol_by_demangled_name(e->orig, sym2, &sym1))
+			return -1;
+
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


