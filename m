Return-Path: <live-patching+bounces-2428-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QLH5Ckya6Wm0egIAu9opvQ
	(envelope-from <live-patching+bounces-2428-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:04:28 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9413744CAB0
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:04:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AD3DA300337B
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67A4135DA6F;
	Thu, 23 Apr 2026 04:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOJpFITE"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4394A3563E8;
	Thu, 23 Apr 2026 04:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917064; cv=none; b=tVoPmm8w7gTzhuh5w7nSdjh/2H1N9DTFMsTXnxETM85v1XyvRIiGFGbiMZTAHnk7T3LaeeWI/kPhSkB+49R5f5FN1SipY+gQGQCjB54cLtr5pbrjdNZWk5cVRcUVKcfCwyOH1wIhkr4EgmQ2uEVRmNSK2kastJLxQwUmU7vKBvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917064; c=relaxed/simple;
	bh=CRPOSrWb90t9017QEk/rI+Ud/vacLDUdl92sc+smDow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VM4TXj2mjRiGTBPdTHxPzYAHr5yod8ORpE6LyrrvCC2DWPoVUYnonPylOq+4dasmM2VwXw1IG/fkgxFZw1XiP8OIhRx883rNhwOgIXaLuKB26aUaKLZgqWZHnBlha/BxVowmCH+ANFAejSC8VZ0IR9gh1zVYNGmfh274o6RDxKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KOJpFITE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C6DC2BCB6;
	Thu, 23 Apr 2026 04:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917064;
	bh=CRPOSrWb90t9017QEk/rI+Ud/vacLDUdl92sc+smDow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KOJpFITEx+22jPK0Q6qFGsyxJks6JqIr7Uw2sL/XzxnakRE05XXt1qWPihgg9miZL
	 LMBXuk2r+EAmYACPa7RfVDYfbAh83CJXc5Zwd7iecbIv2RUVNHzCRu1mh7U/SoOpeo
	 yB7QLMPP8XgvCoMBiNgXxjOhqhY+CakoNIyAa2ZFHNHPAC7MZ2axw0k/xX4XBwLnur
	 WBCm2LnJvSAP5VbNYc687vRD9Necr0Clu9c9RN69U8IH9oWY0Ibxvt6gL8806f6NiP
	 dEOhxemJJywKSCj73EBuWTXd8BFRqR10rlDWLZ3J1pIaKXa3mokb+3FHpaw2kVBh/Q
	 JjgCSx+8sKaaQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 01/48] objtool/klp: Fix is_uncorrelated_static_local() for Clang
Date: Wed, 22 Apr 2026 21:03:29 -0700
Message-ID: <f2a97da92796708f77c6fb3e07816f84874b79a4.1776916871.git.jpoimboe@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2428-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9413744CAB0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Joe Lawrence <joe.lawrence@redhat.com>

For naming function-local static locals, GCC uses <var>.<id>, e.g.
__already_done.15, while Clang uses <func>.<var> with optional .<id>,
e.g. create_worker.__already_done.111

The existing is_uncorrelated_static_local() check only matches the GCC
convention where the variable name is a prefix.  Handle both cases by
checking for a prefix match (GCC) and by checking after the first dot
separator (Clang).

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 0b0d1503851f..b1b068e9b4c7 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -242,16 +242,17 @@ static struct symbol *next_file_symbol(struct elf *elf, struct symbol *sym)
 static bool is_uncorrelated_static_local(struct symbol *sym)
 {
 	static const char * const vars[] = {
-		"__already_done.",
-		"__func__.",
-		"__key.",
-		"__warned.",
-		"_entry.",
-		"_entry_ptr.",
-		"_rs.",
-		"descriptor.",
-		"CSWTCH.",
+		"__already_done",
+		"__func__",
+		"__key",
+		"__warned",
+		"_entry",
+		"_entry_ptr",
+		"_rs",
+		"descriptor",
+		"CSWTCH",
 	};
+	const char *dot;
 
 	if (!is_object_sym(sym) || !is_local_sym(sym))
 		return false;
@@ -259,8 +260,20 @@ static bool is_uncorrelated_static_local(struct symbol *sym)
 	if (!strcmp(sym->sec->name, ".data.once"))
 		return true;
 
+	dot = strchr(sym->name, '.');
+	if (!dot)
+		return false;
+
 	for (int i = 0; i < ARRAY_SIZE(vars); i++) {
-		if (strstarts(sym->name, vars[i]))
+		size_t len = strlen(vars[i]);
+
+		/* GCC: <var>.<id> */
+		if (strstarts(sym->name, vars[i]) && (sym->name[len] == '.'))
+			return true;
+
+		/* Clang: <func>.<var>[.<id>] */
+		if (strstarts(dot + 1, vars[i]) &&
+		    (dot[1 + len] == '.' || dot[1 + len] == '\0'))
 			return true;
 	}
 
-- 
2.53.0


