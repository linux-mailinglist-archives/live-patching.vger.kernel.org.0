Return-Path: <live-patching+bounces-1971-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CMhPNZprgmkpUAMAu9opvQ
	(envelope-from <live-patching+bounces-1971-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 03 Feb 2026 22:41:46 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 26E61DEE83
	for <lists+live-patching@lfdr.de>; Tue, 03 Feb 2026 22:41:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1A092304481A
	for <lists+live-patching@lfdr.de>; Tue,  3 Feb 2026 21:40:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE35033985A;
	Tue,  3 Feb 2026 21:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rzb7MZe6"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2BB29E0F7
	for <live-patching@vger.kernel.org>; Tue,  3 Feb 2026 21:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770154817; cv=none; b=akgiJH0yzZ+RevUxjy5Hat3mDiRnTNy99s7uWDjhIjVviNIJ4qbe82j4/0PGQwEzYvOGcvxr1ZDubWKdLeXFxy9eONOV7g/S8NQFd9zL6Q72Q+aqQGwPAkXlrqbOwEiP5a4hXqTAp47VmLf6aX7R+sqiAr6gef1kUs2cINRtrO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770154817; c=relaxed/simple;
	bh=w5RUbG9/MDGV5oJnQRtCup6lKvjxLYkeFu4HQSk2qzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AiMpQJafCvkZoKu8DoJiOB99oVZUePxEa1iaR6SWuv9sjUa/er02FXD0XvkGwBDuPFn23UWC8gEYLHkwRDO3dvJfRS0/1Y/YEUTLHpD13Ol/z5tW3KhBdMmBHRSf9Qr5QyifEOpzuqkOElYpfA0SLT9+OjTv18rbm0LC+KRRRws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rzb7MZe6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA395C116D0;
	Tue,  3 Feb 2026 21:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770154817;
	bh=w5RUbG9/MDGV5oJnQRtCup6lKvjxLYkeFu4HQSk2qzQ=;
	h=From:To:Cc:Subject:Date:From;
	b=Rzb7MZe6+sEdoGssF+/youGvrXENSitTNFZyhH8LZgvlL2ByEpI30eZk2Qz+J47tA
	 rQdBHwP0BmJiPOj316oo4/9hcRr5NHEhtzdcuAzZTli6BKscQOXQiOPoseAmNCoabQ
	 gEQfyAgV9wpPKL3hg5cUGyGtoxl7zTfoqK5J46dv7KSUzo3DOrg8UtcPmJPMRKa6Ly
	 Iq6o7oaq65kbHnpnxTqJ/wV3CSnBFNOcH++AxpbSXo2h4yjn+Smn0ARs9yMpG+gDuE
	 RFRRN0B5i3NLi1Kbsgjrd5dpAnOoIcEoDo3+pK+5kybhsGaxUuxkK9t42GmVjwYNhX
	 KMZooh658VYMA==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	kernel-team@meta.com,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	Song Liu <song@kernel.org>
Subject: [PATCH] klp-build: Update demangle_name for LTO
Date: Tue,  3 Feb 2026 13:40:06 -0800
Message-ID: <20260203214006.741364-1-song@kernel.org>
X-Mailer: git-send-email 2.47.3
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1971-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 26E61DEE83
X-Rspamd-Action: no action

With CONFIG_LTO_CLANG_THIN, __UNIQUE_ID_* can be global. Therefore, it
is necessary to demangle global symbols.

Also, LTO may generate symbols like:

__UNIQUE_ID_addressable___UNIQUE_ID_pci_invalid_bar_694_695

Remove trailing '_' together with numbers and '.' so that both numbers
added to the end of the symbol are removed. For example, the above s
ymbol will be demangled as

__UNIQUE_ID_addressable___UNIQUE_ID_pci_invalid_bar

Signed-off-by: Song Liu <song@kernel.org>
---
 tools/objtool/elf.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 2c02c7b49265..b4a7ea4720e1 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -445,9 +445,6 @@ static const char *demangle_name(struct symbol *sym)
 {
 	char *str;
 
-	if (!is_local_sym(sym))
-		return sym->name;
-
 	if (!is_func_sym(sym) && !is_object_sym(sym))
 		return sym->name;
 
@@ -463,7 +460,13 @@ static const char *demangle_name(struct symbol *sym)
 	for (int i = strlen(str) - 1; i >= 0; i--) {
 		char c = str[i];
 
-		if (!isdigit(c) && c != '.') {
+		/*
+		 * With CONFIG_LTO_CLANG_THIN, the UNIQUE_ID field could
+		 * be like:
+		 *   __UNIQUE_ID_addressable___UNIQUE_ID_<name>_628_629
+		 * Remove all the trailing number, '.', and '_'.
+		 */
+		if (!isdigit(c) && c != '.' && c != '_') {
 			str[i + 1] = '\0';
 			break;
 		}
-- 
2.47.3


