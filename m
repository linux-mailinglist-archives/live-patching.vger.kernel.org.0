Return-Path: <live-patching+bounces-2464-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4MIzJMae6WkAfQIAu9opvQ
	(envelope-from <live-patching+bounces-2464-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:23:34 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 339E744CEA6
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:23:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D8D3C320AA35
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CFC53DC4C1;
	Thu, 23 Apr 2026 04:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YrIxR+og"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1783DC4B2;
	Thu, 23 Apr 2026 04:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917083; cv=none; b=pNLUY16PSJ3sF0VUJ22vfLIGy6JGWLirwfvvfpzLe4DV+fFRY+g5yJP/5onajijuCo5GYu3ybjjwnTvT3oCdpj5qT3ApZqiMFV9am6byBvoNifM+N32j50fYDyhP8WmLY0uoJcWEbvJKHb8CcVh96ApgX46fZQ80uVxEUr7BIKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917083; c=relaxed/simple;
	bh=Z/dFkGhk1xaKXkKBuoSU1geqYdPfgu4flSFr4FFNNM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRws19a3tHLjSu1C/zV3dljxGmstP4UIjVsiRgAbJcctLtqQUgfLuibj9M/4pMS7RKSZe+7w3PBS4gyJp+5Krg+v6hkK4tIwtddcMbtTwkBzO3My1TKYPmEgSi/1SoGZ+UOZ9AGq6x9L126HDXlzMCSWyF5zCJhpwFJlrY3QEnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YrIxR+og; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80641C2BCB5;
	Thu, 23 Apr 2026 04:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917082;
	bh=Z/dFkGhk1xaKXkKBuoSU1geqYdPfgu4flSFr4FFNNM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YrIxR+ogEYi571zaFj8Q7Vy4BaDx3CE/g4KPnqr9uzqxmMshzq/XtgrxBxQRuij7b
	 0tDJVeYe7mianxVcbuI2fyc7cuC71JfD0flaaTha2Hj8kKHOqgt7ANVg/5CK1xqnX2
	 boZS41iqwqYpY9WF4n96Fx7TT9ZUzUCtlqIZ2xyX0LhMHliWlG/n8UU7a+95DktJBq
	 lMnIUFPxSH5mEVdx8OdSVJ6JjWbFxNgeah1B0J5BH26BCJyHq7fXHlKTgX71zaaOjQ
	 si0Mdq/9OlxqOJj33whH7vDX89M+FfEKd1xLCVSKH7qrJceJ6Ql9mL9SAMQ4tfpOl7
	 GOZJSV6gKJz3A==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 37/48] objtool/klp: Remove "objtool --checksum"
Date: Wed, 22 Apr 2026 21:04:05 -0700
Message-ID: <d11a2f7a57690fc4b6a8a02414d07b41dbebeb2b.1776916871.git.jpoimboe@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2464-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 339E744CEA6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The checksum functionality has been moved to "objtool klp checksum"
which is now used by klp-build.  Remove the now-dead --checksum and
--debug-checksum options from the default objtool command.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build   |  3 +++
 tools/objtool/builtin-check.c | 17 +----------------
 tools/objtool/check.c         | 10 ----------
 3 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index d29ef3022556..eda690b297cc 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -277,6 +277,9 @@ validate_config() {
 		[[ "$CONFIG_AS_VERSION" -lt 200000 ]] &&	\
 		die "Clang assembler version < 20 not supported"
 
+	"$SRC/tools/objtool/objtool" klp 2>&1 | command grep -q "not implemented" && \
+		die "objtool not built with KLP support; install xxhash-devel/libxxhash-dev (version >= 0.8) and recompile"
+
 	return 0
 }
 
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index b780df513715..ec7f10a5ef19 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -73,7 +73,6 @@ static int parse_hacks(const struct option *opt, const char *str, int unset)
 
 static const struct option check_options[] = {
 	OPT_GROUP("Actions:"),
-	OPT_BOOLEAN(0,		 "checksum", &opts.checksum, "generate per-function checksums"),
 	OPT_BOOLEAN(0,		 "cfi", &opts.cfi, "annotate kernel control flow integrity (kCFI) function preambles"),
 	OPT_STRING_OPTARG('d',	 "disas", &opts.disas, "function-pattern", "disassemble functions", "*"),
 	OPT_CALLBACK_OPTARG('h', "hacks", NULL, NULL, "jump_label,noinstr,skylake", "patch toolchain bugs/limitations", parse_hacks),
@@ -95,7 +94,6 @@ static const struct option check_options[] = {
 	OPT_GROUP("Options:"),
 	OPT_BOOLEAN(0,		 "backtrace", &opts.backtrace, "unwind on error"),
 	OPT_BOOLEAN(0,		 "backup", &opts.backup, "create backup (.orig) file on warning/error"),
-	OPT_STRING(0,		 "debug-checksum", &opts.debug_checksum,  "funcs", "enable checksum debug output"),
 	OPT_BOOLEAN(0,		 "dry-run", &opts.dryrun, "don't write modifications"),
 	OPT_BOOLEAN(0,		 "link", &opts.link, "object is a linked object"),
 	OPT_BOOLEAN(0,		 "module", &opts.module, "object is part of a kernel module"),
@@ -165,20 +163,7 @@ static bool opts_valid(void)
 		return false;
 	}
 
-#ifndef BUILD_KLP
-	if (opts.checksum) {
-		ERROR("--checksum not supported; install xxhash-devel/libxxhash-dev (version >= 0.8) and recompile");
-		return false;
-	}
-#endif
-
-	if (opts.debug_checksum && !opts.checksum) {
-		ERROR("--debug-checksum requires --checksum");
-		return false;
-	}
-
-	if (opts.checksum		||
-	    opts.disas			||
+	if (opts.disas			||
 	    opts.hack_jump_label	||
 	    opts.hack_noinstr		||
 	    opts.ibt			||
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 3e5d335d0e29..ae047be919c5 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -18,7 +18,6 @@
 #include <objtool/special.h>
 #include <objtool/trace.h>
 #include <objtool/warn.h>
-#include <objtool/checksum.h>
 #include <objtool/util.h>
 
 #include <linux/objtool_types.h>
@@ -4946,15 +4945,6 @@ int check(struct objtool_file *file)
 	if (opts.noabs)
 		warnings += check_abs_references(file);
 
-	if (opts.checksum) {
-		ret = calculate_checksums(file);
-		if (ret)
-			goto out;
-		ret = create_sym_checksum_section(file);
-		if (ret)
-			goto out;
-	}
-
 	if (opts.orc && nr_insns) {
 		ret = orc_create(file);
 		if (ret)
-- 
2.53.0


