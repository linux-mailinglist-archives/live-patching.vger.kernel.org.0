Return-Path: <live-patching+bounces-2007-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +OZbOHIojmkMAQEAu9opvQ
	(envelope-from <live-patching+bounces-2007-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 12 Feb 2026 20:22:26 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B2BF130AA6
	for <lists+live-patching@lfdr.de>; Thu, 12 Feb 2026 20:22:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1A5FA306642D
	for <lists+live-patching@lfdr.de>; Thu, 12 Feb 2026 19:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A74E521FF3F;
	Thu, 12 Feb 2026 19:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MHFceIFc"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849E828E0
	for <live-patching@vger.kernel.org>; Thu, 12 Feb 2026 19:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770924144; cv=none; b=EmbiB5yBw4GajcsXYR2698Ns2kIzrbE/BphMQbtLm4J+WYtHK3uK/rmjDs6OzYycvbHK03CAOt1SSGtwHbODAxTW1pyJ7nO4Uwzzc7SQGmdkVPSTT68MkIGzGFYGFdqRxf6LlZuNXX6oR+xx6xelsP8a2bLB3lLEcTUrukiQ7zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770924144; c=relaxed/simple;
	bh=NF985SuSmn9wmB4vLhm1ef1RmrUrWhw45OEe/IaMNFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkF3pLZ2TDBT3YHMy5cOWZP+hWC2gkW9opStDkGKDH46Q/FutrKkvi2KQpcgcLZfi0jBqkiAbL8Q+vZ6iiqU7xNEQ1D44PFOu4gybsEWTXZhnYZld8lZObZ3MaK+QJbY659YKiEciQtuRxMGlLXh8Jhyc25QZNgdW8rryZhb6l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MHFceIFc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CDCC4CEF7;
	Thu, 12 Feb 2026 19:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770924144;
	bh=NF985SuSmn9wmB4vLhm1ef1RmrUrWhw45OEe/IaMNFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHFceIFcpxuudh6jo/Aypyt1mtxwzhW1nhOcT317us1DZEjrsqR7ZNAyJ71jHL9+U
	 5+QgDxzexpv7jaEJJIWD0IApSpWYurl1hcx6OeESFH8Bs1QN+SYumzJIwrFudelnTa
	 HeHv+OCHCpTYNAiP/nAR0AqGZ8HlQl4bmQQWa9hveX/oN22RG4fcnURb6/F7aE7AZn
	 tFlcCd08S9tkhKf5Bq9k1e/8zXrs1XnlME94/Mgkuq5xTppvRsOMDqJ4Iq2w/XWCaL
	 GC5yUMye9mo9vZOZyOln9+kKDiwzpH8HrQXTHbyt2Nhj5Hf8qcJM2TJiDrQGGWAwl5
	 SYkNcJnvgLHnA==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH 1/8] objtool/klp: Remove redundent strcmp in correlate_symbols
Date: Thu, 12 Feb 2026 11:21:54 -0800
Message-ID: <20260212192201.3593879-2-song@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2007-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5B2BF130AA6
X-Rspamd-Action: no action

find_global_symbol_by_name() already compares names of the two symbols,
so there is no need to compare them again.

Signed-off-by: Song Liu <song@kernel.org>
---
 tools/objtool/klp-diff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index a3198a63c2f0..57606bc3390a 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -454,7 +454,7 @@ static int correlate_symbols(struct elfs *e)
 
 		sym2 = find_global_symbol_by_name(e->patched, sym1->name);
 
-		if (sym2 && !sym2->twin && !strcmp(sym1->name, sym2->name)) {
+		if (sym2 && !sym2->twin) {
 			sym1->twin = sym2;
 			sym2->twin = sym1;
 		}
-- 
2.47.3


