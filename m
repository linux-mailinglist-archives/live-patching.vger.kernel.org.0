Return-Path: <live-patching+bounces-2619-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eK4fLVYn9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2619-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:08:54 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FBEE4AA0A3
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:08:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C5B58302C745
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16ED82D9EE4;
	Fri,  1 May 2026 04:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PZJNIoAO"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79B22BF3F4;
	Fri,  1 May 2026 04:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608531; cv=none; b=TN9Z2WGUERxwMDQXyuoI2+I9xl/rRGwsRNeXbjsGeI9xD+H03M+vskUs2xr6IKDDfzejkk5JdRTWbULJzQVpkDqdvgnU/XNCH+pfXm/1DJvOK1layTkjezsqqUotp4ptRPXrsDKssEQwZSfV1+1zVeuKjLQ5l/6440OIMlX9cME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608531; c=relaxed/simple;
	bh=JlUvFHpCA3SGzTQKdf6SJ+DOcUBCUPFgx5KEWx/vo+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CasJv49G1cmO0VG6IrBLNg0geCzQzEn7HyMoFsR76jPw+G0jz+dPrKuAd2P3ponD/PLdlEhDxJDs9sYvoR7sKWVldRrwWF1PyZQZFTWMNUkioHxUb45QVc/V/KjZTm02Zml9z1H9ZE8PHqt1MiWwGMbuXI31DnftzxKj2QneWxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PZJNIoAO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B61EC2BCB9;
	Fri,  1 May 2026 04:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608530;
	bh=JlUvFHpCA3SGzTQKdf6SJ+DOcUBCUPFgx5KEWx/vo+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZJNIoAOT4WPQ7ghmRUgmoQmJ+naVWxq9ntdWI+E1ekkZaRQscPoF8haN6uifXEbr
	 zF7W+cVHv0ZPAJ4DkABtFV+ooNx08qO0PvsYdq50QhkkQAsIUOqDKvtxIFUdJhQx35
	 8qAye3DHHsv3Z2CihkWuxTjFO75MReK0GIsG15DFLgTT7DTNOT5pGmzEnTU/EuDmIs
	 cujd0Nb7Ahw07FNLMCKHaxsFPf9sStxlT0/oYZl0lqMwupUYy0WKYsECJycAHfHq38
	 5bgmEdnS+zq+AxXhIKMIecYoekWzH57QY7CQSuvomDNChA7+AhLYEY2at4FMeuy4rZ
	 QyEUOVbgB+14w==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 01/53] objtool/klp: Fix is_uncorrelated_static_local() for Clang
Date: Thu, 30 Apr 2026 21:07:49 -0700
Message-ID: <f5defbd99651373cb36cdcd2f13f1e0af2f36ea8.1777575752.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1FBEE4AA0A3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2619-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email]

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
Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
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


