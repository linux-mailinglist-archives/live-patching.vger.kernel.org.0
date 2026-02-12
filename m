Return-Path: <live-patching+bounces-2008-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OKyECnkojmkMAQEAu9opvQ
	(envelope-from <live-patching+bounces-2008-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 12 Feb 2026 20:22:33 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FEE3130AAD
	for <lists+live-patching@lfdr.de>; Thu, 12 Feb 2026 20:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0F33B3066421
	for <lists+live-patching@lfdr.de>; Thu, 12 Feb 2026 19:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84F3626E70E;
	Thu, 12 Feb 2026 19:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UVWKyYzQ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F9C28E0
	for <live-patching@vger.kernel.org>; Thu, 12 Feb 2026 19:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770924150; cv=none; b=A7/6cnnLMOg8g0CPP1bvzicYXDSetMfiHcSwkjBcG0IUosdYulNR4JOipDhcaQXdGKl6ouD/5WR8z1jL5vZmNIT1rnhUwnO73NfAgRI03U9lmDcIR7mu7yTeD8njmQuyOJTXB/0X748zg+g5/HgcYtIdJrFnM3tK4Z0kvzc4Lgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770924150; c=relaxed/simple;
	bh=Sikm3tBdRebSPK/JmcCZImuhJKkS3pnJEMKEf+9Njs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pREiGxfXZ4iVHLzvBkfAzZ07LPdlPbwsjZzXBK19bpcdxSYnCF/MjvGudOudtrJmsDiRM8bN+3RhxmisYm8DhguKP90qxH9l8IiJiV5qkCb6Amv8ZulDNnF1t3xIluqs2QzAMarRMUWT4QQ+ABAyqEC8SduQMPE9mSRnrO2MuTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UVWKyYzQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BD1C4CEF7;
	Thu, 12 Feb 2026 19:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770924150;
	bh=Sikm3tBdRebSPK/JmcCZImuhJKkS3pnJEMKEf+9Njs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UVWKyYzQ5ECn6fg3iwg191mJUbp77UJeSREAz8S2ZNO4HXbCA31VU2qS4JAmaoGFZ
	 kOflZqSlwRHytzC8z9+IGNv/CFrqbwpUHMI/F7fMEBXoaUcODYDJKb2j/aAk5666vp
	 3WaYKg/PszwVo+GH5tAt9atLJgDKaVo9L77iDvBHqC6TUKO1gKQQajil5Hngdtv4EC
	 XtwpX0kHHYE4hBGjsupU7QLdrQY6avj7PJ+ffQ1E+8dF+8rM0/UlqS3IYE7/zo0+s0
	 x+9dRYTD0Mrk82YCtojjhfngpU/QOQ1DGovK6WLMle/J95ZRKX5DCFNHqWxVsRb5as
	 PbiS7xAjjNiTA==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH 2/8] objtool/klp: Remove trailing '_' in demangle_name()
Date: Thu, 12 Feb 2026 11:21:55 -0800
Message-ID: <20260212192201.3593879-3-song@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2008-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6FEE3130AAD
X-Rspamd-Action: no action

With CONFIG_LTO_CLANG_THIN, it is possible to have nested __UNIQUE_ID_,
such as:

  __UNIQUE_ID_addressable___UNIQUE_ID_pci_invalid_bar_694_695

To remove both trailing numbers, also remove trailing '_'.

Also add comments to demangle_name().

Signed-off-by: Song Liu <song@kernel.org>
---
 tools/objtool/elf.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 2c02c7b49265..0d93e8496e8d 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -441,6 +441,19 @@ static int read_sections(struct elf *elf)
 	return 0;
 }
 
+/*
+ * Remove number suffix of a symbol.
+ *
+ * Specifically, remove trailing numbers for "__UNIQUE_ID_" symbols and
+ * symbols with '.'.
+ *
+ * With CONFIG_LTO_CLANG_THIN, it is possible to have nested __UNIQUE_ID_,
+ * such as
+ *
+ *   __UNIQUE_ID_addressable___UNIQUE_ID_pci_invalid_bar_694_695
+ *
+ * to remove both trailing numbers, also remove trailing '_'.
+ */
 static const char *demangle_name(struct symbol *sym)
 {
 	char *str;
@@ -463,7 +476,7 @@ static const char *demangle_name(struct symbol *sym)
 	for (int i = strlen(str) - 1; i >= 0; i--) {
 		char c = str[i];
 
-		if (!isdigit(c) && c != '.') {
+		if (!isdigit(c) && c != '.' && c != '_') {
 			str[i + 1] = '\0';
 			break;
 		}
-- 
2.47.3


