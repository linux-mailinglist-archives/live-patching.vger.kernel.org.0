Return-Path: <live-patching+bounces-2660-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YHmvIf4p9GlA+wEAu9opvQ
	(envelope-from <live-patching+bounces-2660-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:20:14 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E0ED44AA3F3
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:20:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 084FE304C12B
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 983B7370D69;
	Fri,  1 May 2026 04:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="An+7uNDJ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747723612E2;
	Fri,  1 May 2026 04:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608550; cv=none; b=hbykSWWD8/rr7y9f4mdvUL7yNv71SJQW3UQGl+/88n23SFm1hVeojQiDAKylbowVHMAIt2Ifyzkwr72MvcqcWbETTYGf26mXNC+X6zmsqvZIis1EiZYtWawec2KeZqUualtjN1aBTCz8SlC3i4xn8OZ48BnW8SOeCGmMMWjD7CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608550; c=relaxed/simple;
	bh=4N7t6lLPbZ7r+YTwJIsIBMNFNEnAzrAQ250jpr6o898=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxQf2N4fXhCeVQfnb3Xstf9s/prjTTMmI8F+BlEILCxwnjkv46+I9XwGGbC4RcgMlBIHD6tyOhK0K1P2XiKZJYxjSbZsO9tvdkGzyXm90pjfsK5IepnuQpldO0v1/Bqsx5hYgOkVSRFQDfGeBjT4bR4s1o9uPGVE4LGVDDcbnnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=An+7uNDJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E79C2BCB8;
	Fri,  1 May 2026 04:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608550;
	bh=4N7t6lLPbZ7r+YTwJIsIBMNFNEnAzrAQ250jpr6o898=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=An+7uNDJmwufwqi3pgpGyCP2eCJ+gu2Bg/xYhmwbDUSnH9SkrZ7v9InWuo9wOb4u4
	 Us5BykwpFbYo1W3PifRsN9U2W7zcSf5zeQNNWLOIK/I8+oU/GFgct3tDgxv0XZPwVJ
	 PbKev/jcyqHsZBFa9DKf0OCB62u4I9z0rDyXIFZpoAm9D10qURCWCmMZoVNIGt0GMP
	 kwUpK66DorTS5yehZQGJIdoPakq/1Z62EejBtrpQf5Dn858EC+v5HyDy0Uc2vJf3PY
	 G2onw1SGrKtgaX0SfcoICkHypG5BYoKrZ/CVRhzvV+5X2FZnfgWBJVlNEGbrmcY22n
	 Hs1vuLWZLhUKQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 43/53] objtool/klp: Remove "objtool --checksum"
Date: Thu, 30 Apr 2026 21:08:31 -0700
Message-ID: <9bf05c10e47f711dc2f3b00d728b725618cec5d0.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: E0ED44AA3F3
X-Rspamd-Action: no action
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
	TAGGED_FROM(0.00)[bounces-2660-lists,live-patching=lfdr.de];
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

The checksum functionality has been moved to "objtool klp checksum"
which is now used by klp-build.  Remove the now-dead --checksum and
--debug-checksum options from the default objtool command.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build   |  5 ++++-
 tools/objtool/builtin-check.c | 17 +----------------
 tools/objtool/check.c         | 10 ----------
 3 files changed, 5 insertions(+), 27 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 8a4b268261a6..f8a80ad0f829 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -275,6 +275,9 @@ validate_config() {
 		[[ "$CONFIG_AS_VERSION" -lt 200000 ]] &&	\
 		die "Clang assembler version < 20 not supported"
 
+	"$OBJTOOL" klp 2>&1 | command grep -q "not implemented" && \
+		die "objtool not built with KLP support; install xxhash-devel/libxxhash-dev (version >= 0.8) and recompile"
+
 	return 0
 }
 
@@ -653,7 +656,7 @@ generate_checksums() {
 
 		mkdir -p "$(dirname "$dest")"
 		cp -f "$file" "$dest"
-		"$SRC/tools/objtool/objtool" klp checksum "$dest"
+		"$OBJTOOL" klp checksum "$dest"
 	done
 
 	touch "$dest_dir/.complete"
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


