Return-Path: <live-patching+bounces-2142-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +EIAKbMOqmngKQEAu9opvQ
	(envelope-from <live-patching+bounces-2142-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 00:16:03 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 60DA8219372
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 00:16:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 131F2301F18C
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 23:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ED4F366043;
	Thu,  5 Mar 2026 23:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LP6w92C0"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF9D283FC3
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 23:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772752560; cv=none; b=tVy0N44rY/0B+uVwZJhxF36UxwoFCLIHRK4zbKW0BKzFoVHmProGVUVSvfRwb9KDKxjA7yogyFIowZ+eOt1GhfVV+601uj3qyUmP4n5Yfj8Ft4OAdGVeErNmEEb++nehaZmhQQmSzIjJy1VupQr2TsMpvpewByJ9cdxdTAqDWZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772752560; c=relaxed/simple;
	bh=ynT0kDA++/nCkpGy8G4VQIWFqUxBAoRN5dDcDvOKw50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8wArcFm9K3jrpwnN2SnFKKVYyACmT4UauSizZAhc2lJKXC/op5evxksQn0sF4GVyw9YP5QFktTMJwtnKUaXGnQYTOd0wEGLOARvDUcp9yAyh3bYW6Dzb9GV2P/AGoeQlCSToPfjFTqlZzdIWuJxuDlqLJdk89+gCe0hw1hVkMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LP6w92C0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59BEC116C6;
	Thu,  5 Mar 2026 23:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772752559;
	bh=ynT0kDA++/nCkpGy8G4VQIWFqUxBAoRN5dDcDvOKw50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LP6w92C0/mvLtRnuYNwKpWmjwNYAs8JkckdnB/xYpdU+R7Pagr3LZTRAz+i2Q9WdQ
	 2mjv2Sc+wMSguzM0HhSKi/C3oATiS0lMZFXQSaDQ0o6S7i+YmdnPwRBX3ccWam8YYZ
	 k1rfwFcawHjgWqUGL/IWrBtYPlkAFWRUbvLlei6c0y2i/izcbsRixQq/jKPif4dphz
	 RgYcuoMPOhjoT+kF6tA4weXwn7HEhCk9ljD1FFVN6wUPk7/gF5bwMsgZEwlYIk/coa
	 mxwJNOygSI71m1zL+Zhq28rnPpOWTdCkPO298OvYd43/cnCvSWGnGH76J/vTntJ0Jh
	 W/DEL/n6HvDjQ==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH v4 5/7] objtool/klp: Remove .llvm suffix in demangle_name()
Date: Thu,  5 Mar 2026 15:15:29 -0800
Message-ID: <20260305231531.3847295-6-song@kernel.org>
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
X-Rspamd-Queue-Id: 60DA8219372
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
	TAGGED_FROM(0.00)[bounces-2142-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Remove .llvm suffix, so that we can correlate foo.llvm.<hash 1> and
foo.llvm.<hash 2>.

Signed-off-by: Song Liu <song@kernel.org>
---
 tools/objtool/elf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 78db51ebbed4..51e6267cdf8d 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -455,6 +455,11 @@ static int read_sections(struct elf *elf)
 static ssize_t demangled_name_len(const char *name)
 {
 	ssize_t idx;
+	const char *p;
+
+	p = strstr(name, ".llvm.");
+	if (p)
+		return p - name;
 
 	if (!strstarts(name, "__UNIQUE_ID_") && !strchr(name, '.'))
 		return strlen(name);
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
2.52.0


