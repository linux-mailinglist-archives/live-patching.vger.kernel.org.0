Return-Path: <live-patching+bounces-2082-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ePGhEt6Zn2mucwQAu9opvQ
	(envelope-from <live-patching+bounces-2082-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 01:54:54 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 08DD619FA58
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 01:54:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 75BFC302DAA5
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 00:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B22D7081F;
	Thu, 26 Feb 2026 00:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z7i8MVvI"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CFE4A21
	for <live-patching@vger.kernel.org>; Thu, 26 Feb 2026 00:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772067292; cv=none; b=I0EplMLDP7/cCBLYogeubJjub2pAZMFipu9wK9SgJupmTtKq6SWRsKma2AkawrfGZUfR/nlM929oyC3Y3nY6f41V4cA6Ll/byXzmfFdNz0VvE9l0tY5oZDqJddfzsspl+TsA+bUYrExIPkBKJ90e7YaZrNDmRpOjiZdeI31D20Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772067292; c=relaxed/simple;
	bh=Sikm3tBdRebSPK/JmcCZImuhJKkS3pnJEMKEf+9Njs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFm7d1jMSumWA2hybUPAVEzbWE9CggoaHv0ftLySTDxQ5aJdJnIq/5MeeNOhFGbhXkwsKL3QXhNxJc+PFaTrEEj243wY1NxlwTkUsz9dz1k/0wcWDxrU29hcw6TDwLh7/SUzBOToWT9q0nOYBfvckhASwACebVK9bjs3O58mmtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z7i8MVvI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7170C116D0;
	Thu, 26 Feb 2026 00:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772067292;
	bh=Sikm3tBdRebSPK/JmcCZImuhJKkS3pnJEMKEf+9Njs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7i8MVvImXPmeiBtVJstDzA3KPAb/c3BhVj3emNlnBifYgWV26PGWo5x6BpKB56lv
	 8pwJPylpDOzA8EKVlAd/qk1xJhIsocwquHjGfyY7T+Tk8Hsaft9apg3JPVfFaoCyth
	 rNe+Cwj2+Zl6Q/JZf9aD5CWgRwMUBLCxRWLvLzLRC20wID7e9aKIgPyau/PK8weN2F
	 XZl2Uhhpaj71eRZG2cKX7m5nN0XaXJ73eFWQUZBsofOggShaTHnA/Cc9fwX+wuja2p
	 O2OmWT01cpdG2HlujHsgS8sPAkW+jI5cKrkBe1NRhdrGJQcOl2YNtN3EWJVoAozib3
	 SQESpsuSJKvxw==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH v3 2/8] objtool/klp: Remove trailing '_' in demangle_name()
Date: Wed, 25 Feb 2026 16:54:30 -0800
Message-ID: <20260226005436.379303-3-song@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2082-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 08DD619FA58
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


