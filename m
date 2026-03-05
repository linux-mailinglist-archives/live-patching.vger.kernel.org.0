Return-Path: <live-patching+bounces-2144-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cAmiFrwOqmngKQEAu9opvQ
	(envelope-from <live-patching+bounces-2144-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 00:16:12 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EEB36219388
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 00:16:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E08383020A7F
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 23:16:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F14CD366076;
	Thu,  5 Mar 2026 23:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MNTm6yPl"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8A3366043
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 23:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772752569; cv=none; b=HRBGidDh/E7MhJS/3pWoY8wfhnVnfPXdto3vM8Wr30O8p42UKX3TeO+mZVgYmJ91K98luGgqWnQzVNMdXKACMIA3xsyirCxNB23Y5px3d4WZrQgqSJpxSPpda2hEZQDDhfIVMy5Vnfgraqe+d0oUUWY4Xed/5SDawBFVKYMGaIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772752569; c=relaxed/simple;
	bh=1ysnruUa51wk3rZeJVmElciC2jYxJgWADhgwfOKFx4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cfen+amt5I4/NNQT1lPO16Dk5qhrecnVlJIcMJdbeweLE9fRTYIBqLnGb7MookkP/6+Q2bXC1OcnxaamyXFfudnftDaFz9+1Hkw1GW0EvPkXisX/ADpoQ9sgTANCHA6kd292iD+39e+7g/yROE6nCjtvj8L9XlHMELdG3HgPM1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MNTm6yPl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4E6C116C6;
	Thu,  5 Mar 2026 23:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772752569;
	bh=1ysnruUa51wk3rZeJVmElciC2jYxJgWADhgwfOKFx4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNTm6yPlqG6qxd2HdjQHNyUoL0kTo6fxNvhEbmyg5+iduLrBfowx2QbkNX/R6LYNx
	 McptjFniFD5qd5rXgoTgijUZSWoO9CgzdSlWpJ9uzCkRdEqwJ/INvGvB13LYKL0ysV
	 sTCucXtrrQfYOqFO3hm5bXmG/MxB17atACDaGK6a0ZbTDe/k1QF/IgF/WBr00hARCQ
	 kf+DzIHrGHoAtzRKcveQB8IsLz1pHgNmVtxVbBHxUgy/Zl0nT5qzlukWLr9Cks6yiG
	 tXSP2Q7JojIHuTeg0nviD99yfmZRsW3NoExnfV8FOgsv46j2ikpProFdLquoyInU4h
	 P9aYDELyk0z0A==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH v4 7/7] objtool/klp: Correlate locals to globals
Date: Thu,  5 Mar 2026 15:15:31 -0800
Message-ID: <20260305231531.3847295-8-song@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260305231531.3847295-1-song@kernel.org>
References: <20260305231531.3847295-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EEB36219388
X-Rspamd-Server: lfdr
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
	TAGGED_FROM(0.00)[bounces-2144-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

Allow correlating original locals to patched globals, and vice versa.
This is needed when:

1. User adds/removes "static" for a function.
2. CONFIG_LTO_CLANG_THIN promotes local functions and objects to global
   and add .llvm.<hash> suffix.

Signed-off-by: Song Liu <song@kernel.org>
---
 tools/objtool/klp-diff.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 92043da0ed0b..7bdb2a417096 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -517,6 +517,36 @@ static int correlate_symbols(struct elfs *e)
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
+		}
+	}
+
 	for_each_sym(e->orig, sym1) {
 		if (sym1->twin || dont_correlate(sym1))
 			continue;
-- 
2.52.0


