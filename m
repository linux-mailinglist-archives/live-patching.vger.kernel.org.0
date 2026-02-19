Return-Path: <live-patching+bounces-2055-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mIObNEWNl2lv0QIAu9opvQ
	(envelope-from <live-patching+bounces-2055-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 23:23:01 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F1DF163209
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 23:23:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D27C23008254
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 22:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BB4032ABD0;
	Thu, 19 Feb 2026 22:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TlajFdQZ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097DE2EC54C
	for <live-patching@vger.kernel.org>; Thu, 19 Feb 2026 22:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771539778; cv=none; b=mQvGMff3I0tW3fz3RV8GjQAFs0ExLC6Ykyd/WZ60V1y+1pzB39K3sUX//ACOqRUswoNGovWLtbLt8Sb/RpDmbAxRtMbidbEXw5QwiGPjtJ48zLQSkV75L2RBEW+ph2NwXSTJ8uZoQHAFz+VnBT1V/tgW5IqQEPZdl2E9qQV484c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771539778; c=relaxed/simple;
	bh=Sikm3tBdRebSPK/JmcCZImuhJKkS3pnJEMKEf+9Njs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfCqHQK2MgULoEo8C8YX1XVVmnxrHLRTSQvven8VAo54cmWnRzI5DgYuoiHwy6Exw2ecjKp0zEPeB3s35OpHEYFWIZN/Zh5kk3M2hvT1loao+/XvS7UYJ11k2QnzNAhhpWOBo/vcjQA6dmmUkx9m6KXlBSXWsq0zAC84e/qXqEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TlajFdQZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC323C116C6;
	Thu, 19 Feb 2026 22:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771539777;
	bh=Sikm3tBdRebSPK/JmcCZImuhJKkS3pnJEMKEf+9Njs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlajFdQZiS5wEcMsmntMYtB5AX8F7ICfhCcl2n01IlTlUm1Z2dnviTkxfNM8mWozB
	 QJAfxHIa+QlIHFtcsOlwo1lqgYNGnARDDaab+ML3J0BvlJBouWb00bnIU2GaV3my9N
	 lR9h6nR8gfoE8kgvoNIfCzWCtmzO0qW+yk7AIWVm+W6fqpNKNkG0Ys9OECbZ7pbTeB
	 Qg4Q0qjTNR1+7Ug3QcAJWHF6QJ16pFwk/ewF3dyuR5HF0P8DrTMZWXS/H01ZbpQAJZ
	 mxD4fTNl6V0NmHfoIYoEHG8rUO4gNIwZiFMy6AhR5yhUK8XA+AUpBGSlLq3BiIPUeb
	 AGALgCuk3kWog==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH v2 2/8] objtool/klp: Remove trailing '_' in demangle_name()
Date: Thu, 19 Feb 2026 14:22:33 -0800
Message-ID: <20260219222239.3650400-3-song@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2055-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: 6F1DF163209
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


