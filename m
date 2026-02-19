Return-Path: <live-patching+bounces-2057-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oMEoJVCNl2lv0QIAu9opvQ
	(envelope-from <live-patching+bounces-2057-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 23:23:12 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DD2B163218
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 23:23:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 540F53015893
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 22:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B07ED32B9A0;
	Thu, 19 Feb 2026 22:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KUj3MkEk"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3FC32ABD0
	for <live-patching@vger.kernel.org>; Thu, 19 Feb 2026 22:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771539789; cv=none; b=ME4x2auAFJEDPN/fIqWLnjRiGk3J+1JY8EoS5VO6yYDB56p/zbDBv97UhxafcH9cRLAWeep8Se+Ni4hwx0Y8DCx20j8I+qLdGUUkz5UtOsAOmYww7tyVwyIKH4fQ94dEB5iMtLurXPBd2UYLttATwCGeaMiaWdClYtoHestVP50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771539789; c=relaxed/simple;
	bh=TLhRd3kSS4Cp7cPZphm+Lh5Lq6UmY3aYlOZ/EPRQil4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVdHdIvXXMkwihDPNMDO2F50VboGW247bumR74UPXvbxHs2woQBhmFoUHI9GXjb/rcMN5UXUbyykVe7Jv3X+ZvVdjea2Ma/XtzjwxKL6GOwNqwaS/Q9bl/RavVpzTs5QGeZ28k6bssVuCjHb5WEEvuradg3kAf99l2yZfMMwwyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KUj3MkEk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B2DC4CEF7;
	Thu, 19 Feb 2026 22:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771539789;
	bh=TLhRd3kSS4Cp7cPZphm+Lh5Lq6UmY3aYlOZ/EPRQil4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUj3MkEkOMEJXi9GJTISnJNfJ+qFlbl3d71g9nKGlXy6Pv7ob+VoEivFDACSym8uV
	 psHdGFyZUNvGzF+Q56+apkHyiE+/KsdWkxVrKT7fQFVH/7MgwyyX0/1K9AGqutYZk4
	 9nk54sIcWB6P7+hKvpLFYFBe5zX2wnDb9SeWbEZWhzinffXpzX011Q9lfJ8uXQvB4j
	 vap0v2/7mOny6H2IUfXcCzJo2dp2hQ+QgpacU5WVfm7DzklC7k3JSV+p5u8vOlDJ9t
	 Jt8Vd5bWRHNe/qACxFO9yc5SoBbPVYVAjLX32MxmptlnpV5o5WYOrKyhDfusrH26T4
	 apcaH3kLXQCVA==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH v2 4/8] objtool/klp: Also demangle global objects
Date: Thu, 19 Feb 2026 14:22:35 -0800
Message-ID: <20260219222239.3650400-5-song@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-2057-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: 4DD2B163218
X-Rspamd-Action: no action

With CONFIG_LTO_CLANG_THIN, it is possible to have global __UNIQUE_ID,
such as:

   FUNC    GLOBAL HIDDEN  19745 __UNIQUE_ID_quirk_amd_nb_node_458

Also demangle global objects.

Signed-off-by: Song Liu <song@kernel.org>
---
 tools/objtool/elf.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index c784a0484270..d66452d66fb4 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -488,9 +488,6 @@ static const char *demangle_name(struct symbol *sym)
 	char *str;
 	ssize_t len;
 
-	if (!is_local_sym(sym))
-		return sym->name;
-
 	if (!is_func_sym(sym) && !is_object_sym(sym))
 		return sym->name;
 
-- 
2.47.3


