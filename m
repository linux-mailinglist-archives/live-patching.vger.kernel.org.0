Return-Path: <live-patching+bounces-2058-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QJrcDFiNl2lv0QIAu9opvQ
	(envelope-from <live-patching+bounces-2058-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 23:23:20 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C1B0E16321F
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 23:23:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2FA6C300AC86
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 22:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1852732B99B;
	Thu, 19 Feb 2026 22:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pailzwFX"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0CB2EC54C
	for <live-patching@vger.kernel.org>; Thu, 19 Feb 2026 22:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771539796; cv=none; b=t9Ba+P1D4OGBMUSjYphadTCHknEsnmBhI/mh2s6X8lRT61hvUWBys+pjXwvGDhMqnWBSBePqQ16KI9vh3W9wiBaViePFD5nZo3OidKC6UKUflpO/2ilzgC+xLrZtB55d08dPzCYpVqVCjd8N3b71pwDaRqI5Bv2tJ4YyqYccSSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771539796; c=relaxed/simple;
	bh=eKr5J9budkSlw7R2Xgj4GlPzCqaaiSuLkblPDVyEOjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UyP5dlHkAOMgTPxENCKNW8YD/Ao1BHF+Arz8OfAXWHr/B/dkWQi1nvFi59XAzsqOmh3Ek03+Dl5t+3UQmzUvkFcKK8/Mx7jWTTEeCFCTUKjKSf0reqDwJrlksS97UbZPbycuOoVGljpas+X9VBcPFKVpW7nkMZ6PCzGMjgQH2nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pailzwFX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCF6C4CEF7;
	Thu, 19 Feb 2026 22:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771539795;
	bh=eKr5J9budkSlw7R2Xgj4GlPzCqaaiSuLkblPDVyEOjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pailzwFXb/R69sUAio8RSkLNriy5CmQOB9isCJudkIHdWC491MQRHeovgurV8dRE1
	 0wi1hyUcm14nxkaLF/ybSOFTZXAsIofDVbGU6Acb45Nhsq9IShJ9ZvHJrdm3+jMGnp
	 //AZC2FZ1i8STVGjLa/63tLPn//WMEe0EpKXY3vkpiteQ6tUm1L2oD1GP2KxWmxHhe
	 pTzZvTRjPMvZCc8pigvIbU49UDil6XomDibrDp/0G4qOlkYncsU8b6UFJBz7CQn73F
	 yHhQrn2eQox/ounu3PLTOxeO89hMSnv6JS5LIsWRaiXTESyshIIT9yHXcJI6BizE43
	 IMtT0TS1I+wIg==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH v2 5/8] objtool/klp: Remove .llvm suffix in demangle_name()
Date: Thu, 19 Feb 2026 14:22:36 -0800
Message-ID: <20260219222239.3650400-6-song@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2058-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C1B0E16321F
X-Rspamd-Action: no action

Remove .llvm suffix, so that we can correlate foo.llvm.<hash 1> and
foo.llvm.<hash 2>.

Signed-off-by: Song Liu <song@kernel.org>
---
 tools/objtool/elf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index d66452d66fb4..efb13ec0a89d 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -455,10 +455,15 @@ static int read_sections(struct elf *elf)
 static ssize_t demangled_name_len(const char *name)
 {
 	ssize_t len;
+	const char *p;
 
 	if (!strstarts(name, "__UNIQUE_ID_") && !strchr(name, '.'))
 		return strlen(name);
 
+	p = strstr(name, ".llvm.");
+	if (p)
+		return p - name;
+
 	for (len = strlen(name) - 1; len >= 0; len--) {
 		char c = name[len];
 
@@ -482,6 +487,9 @@ static ssize_t demangled_name_len(const char *name)
  *   __UNIQUE_ID_addressable___UNIQUE_ID_pci_invalid_bar_694_695
  *
  * to remove both trailing numbers, also remove trailing '_'.
+ *
+ * For symbols with llvm suffix, i.e., foo.llvm.<hash>, remove the
+ * .llvm.<hash> part.
  */
 static const char *demangle_name(struct symbol *sym)
 {
-- 
2.47.3


