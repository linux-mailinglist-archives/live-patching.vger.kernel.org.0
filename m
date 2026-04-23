Return-Path: <live-patching+bounces-2429-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YIwNOECd6WkAfQIAu9opvQ
	(envelope-from <live-patching+bounces-2429-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:17:04 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7964344CDD4
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:17:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E582C3046069
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C985335F8B9;
	Thu, 23 Apr 2026 04:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cthaEmPR"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A397932ED24;
	Thu, 23 Apr 2026 04:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917064; cv=none; b=HPgAjMbvJc5twfOZA8nOdJa/AgixcwsKXurltL5Cw3Ri9ez/Om1g+bUNKtUnjwbZgRk7ZIe/MYeiPcUh/FwklLCzxEFCiYZ+VUD3JZvPFa1nxzI3VaRfpZqSqgZGUmmDB0GG8y3+Y83cwZc0ILYgczvDcG/nSHaZ/gXThNkhzMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917064; c=relaxed/simple;
	bh=m63KetNM8hjihetR3hWKARSwXrlz8FMc6/yAkKODq4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3iIBQZDgzMCNXGrgHMttWD2rkyvTeHg9dnr0jrbjDmYGdChnP24sov0khbTDv5kFRx9UQvj/C6iUI8Ayz2DwKTmrnFNxTEQyvuz/Mjk5ftpj/bmqaw7LESfSiLdoQXETlouvStyE+PKk/Pz36SE8aOxVIoQq10iiXOCNMWBAgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cthaEmPR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D2FC2BCB7;
	Thu, 23 Apr 2026 04:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917064;
	bh=m63KetNM8hjihetR3hWKARSwXrlz8FMc6/yAkKODq4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cthaEmPR59tv0x35YlMswmRUajeUCH/x2qQ9kOU63AJLsjCm5/7kA8rYVCWR8jZiI
	 3lh9+bEkSzNGAVRHo/ucOfg9Qb7JQY8Y0cn/7vV3fk/jUYm81brakJbHnTHIbP5o9s
	 DAx5mfIA6/3m48Bht9DS9WTIYtzmINDnomcvsZP8KfG8XHdhs0qq0OpFPSur+KnOJP
	 kf1dpZ4g8PKOIcOY07FRXA8BlprdZm7oHdfTTaQ0fcj4qbYzI2G06hFl3ZKtV3m9bH
	 NNp6pfQPYXP2I2v8X0zDELifwKP9pdbIhDgCnpSh03DrC/GwYjLuoZ1FnWSpujMmPM
	 n0DbyUOBxpwag==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 02/48] objtool/klp: Fix .data..once static local non-correlation
Date: Wed, 22 Apr 2026 21:03:30 -0700
Message-ID: <f34990d29dd7642ada7843613c96c563043c28a5.1776916871.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
	TAGGED_FROM(0.00)[bounces-2429-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
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
X-Rspamd-Queue-Id: 7964344CDD4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

While there was once a section named .data.once, it has since been
renamed to .data..once with commit dbefa1f31a91 ("Rename .data.once to
.data..once to fix resetting WARN*_ONCE").  Fix it.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index b1b068e9b4c7..cb26c1c92a74 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -257,7 +257,8 @@ static bool is_uncorrelated_static_local(struct symbol *sym)
 	if (!is_object_sym(sym) || !is_local_sym(sym))
 		return false;
 
-	if (!strcmp(sym->sec->name, ".data.once"))
+	/* WARN_ONCE, etc */
+	if (!strcmp(sym->sec->name, ".data..once"))
 		return true;
 
 	dot = strchr(sym->name, '.');
-- 
2.53.0


