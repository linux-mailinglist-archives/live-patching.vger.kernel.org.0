Return-Path: <live-patching+bounces-2060-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eP6gOGiNl2lv0QIAu9opvQ
	(envelope-from <live-patching+bounces-2060-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 23:23:36 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 74736163236
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 23:23:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6EF393014C44
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 22:23:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C4BE32B9A8;
	Thu, 19 Feb 2026 22:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="td0wGaHb"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294FF32B9A4
	for <live-patching@vger.kernel.org>; Thu, 19 Feb 2026 22:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771539813; cv=none; b=DMhMkGYOCuwlVdydhssDjVmOgOMOugjBflCBeudbBFLxhME6wgsCJXNSRHoUkhEMent4TZh8jhtfqBV55NKgh6OQPTQq60UpQkZSWns1J5+tSFSvjhFvb6oQ6gYULwd02ta1WXMD9647WtbA3h/u+laj7C99ugV0c98i5YNVipM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771539813; c=relaxed/simple;
	bh=uWXxklnO+VVahMoKuUdDwiXwS1bQ/dagbHRiBYbDM+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c23lMTksy4i+WNuGhz/3gRnO/5zh4+qjhrLL8J589FJzhx3ceU6RH2bNMYNTSzjdkmCRi5OONGb5K6qpAZzECNi4w0YBYdjRq2wVfnZ7vKCWsHxE7pNbXQ8xXETe+44y58Ob6HXd2/pmONQBNNe3m/DNKT1TVTZ00F6MnVN21y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=td0wGaHb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C77C4CEF7;
	Thu, 19 Feb 2026 22:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771539812;
	bh=uWXxklnO+VVahMoKuUdDwiXwS1bQ/dagbHRiBYbDM+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=td0wGaHbKDU2jY52QIignWPUP6tT01rqiEddY9W1yizI7nPyOoPMCzcPbJB94M5Z3
	 rbiOE69C7S45Xs45ZqoJz4Gw9YgXKRSztM7KbMZ/BhmZibhD2lBu4fHz4zR2g9d3xz
	 oSVbq//HA/1NUHLsHnz8QWTI7cfqj38VEpnsb0jfN196vWdc6U9ttxrJepHm/5rj60
	 6Ou1coqySq6SivoekAzHMqru5h7G71Tvr7V3TfbPozlLOG2XFl6w6/oe0CLwsH66an
	 8bIQy0ctP0AG8WQ+oYT1tpU5ql/zAJCzi5tOz6nNIii0bVSFYsrgAs981s+dwirj+o
	 ApqhdyIhCMxYg==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH v2 7/8] objtool/klp: Correlate locals to globals
Date: Thu, 19 Feb 2026 14:22:38 -0800
Message-ID: <20260219222239.3650400-8-song@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260219222239.3650400-1-song@kernel.org>
References: <20260219222239.3650400-1-song@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2060-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 74736163236
X-Rspamd-Action: no action

Allow correlating original locals to patched globals, and vice versa.
This is needed when:

1. User adds/removes "static" for a function.
2. CONFIG_LTO_CLANG_THIN promotes local functions and objects to global
   and add .llvm.<hash> suffix.

Given this is a less common scenario, show warnings when this is needed.

Signed-off-by: Song Liu <song@kernel.org>
---
 tools/objtool/klp-diff.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 147e7e7176fb..07fcaca46160 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -519,6 +519,37 @@ static int correlate_symbols(struct elfs *e)
 		}
 	}
 
+	/* Correlate original locals with patched globals */
+	for_each_sym(e->orig, sym1) {
+		if (sym1->twin || dont_correlate(sym1) || !is_local_sym(sym1))
+			continue;
+		sym2 = find_global_symbol_by_name(e->patched, sym1->name);
+		if (!sym2 && find_global_symbol_by_demangled_name(e->patched, sym1, &sym2))
+			return -1;
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
+		sym1 = find_global_symbol_by_name(e->orig, sym2->name);
+		if (!sym1 && find_global_symbol_by_demangled_name(e->patched, sym2, &sym1))
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


