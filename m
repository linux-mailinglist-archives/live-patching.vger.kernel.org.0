Return-Path: <live-patching+bounces-1564-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A391AEAB46
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:02:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 192BA7B3384
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 927B7274661;
	Thu, 26 Jun 2025 23:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gpZCisip"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE9327464A;
	Thu, 26 Jun 2025 23:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982195; cv=none; b=sGU6bjcVSFRrh4Hfv9hJpS8sO72oi6s/itZMqoCvzGAERhOzQi2d4sTfxYYlu5ghGmWMBymoCxylTVAkKZMDEFraJYsxG9auuX5BkMYzE+XW4oAFkQoi+hDiDr6ixNJF86r1ANUb7Nce2ZqMGxL0VG82wuOvvu0sFgvWGLzJ/MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982195; c=relaxed/simple;
	bh=Ic6+bMmtv5ROHic7Z6jGxH1WIexazHtXrB0jcb/MbH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8M0o9Hng1Fp/J4yHXqmrhWwqymwyBstu5i1H4Ce2+0/4bQqbNR+E5ozY8L100s2JgiTaU7QbdIOJS8gDxwFTRYtHAp3izoXFnc1O09NAyTSpJw4onjT4WfLXPzDEGj7kn8WqUhv5F4k+3ZKmduqR4CdTHqu/zw0Y+jrpbDTftU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gpZCisip; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0722C4CEEB;
	Thu, 26 Jun 2025 23:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982195;
	bh=Ic6+bMmtv5ROHic7Z6jGxH1WIexazHtXrB0jcb/MbH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gpZCisipr4ay+IWjgtgqBN2ZeczdoAmdBGXfprtLuvlTRtygti5Jicqqq6vNYBJaf
	 SbYn59iQG5OQLXH/akxSpWNkYY3r9W8r+qQPHAb+e2dNPMKetjQ5Rxw91P013C6mgF
	 cI5/gzWWu4W9FEKtb1tRflQWiLEPmJkuSNaMT7TW/63l4HEQsA32heOp7CObAGQYQ2
	 fPViZ5/1TtkbAwvOZ5FmMl3TfM+MelsLwwpK64O8Y7v971OrBvIHNFRNH6LYYDU1aT
	 RDVytqAWKXtd7Od4vrAXIUvWURDj730BaTqq7qcdp4xlDEMFBZzY1fSTeFNnF5GJHH
	 IM8+mzQ5jcVSw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org,
	Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>
Subject: [PATCH v3 34/64] objtool: Reindent check_options[]
Date: Thu, 26 Jun 2025 16:55:21 -0700
Message-ID: <bf399762027642d6b4a54741c6904e0cb5dd8ad0.1750980517.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750980516.git.jpoimboe@kernel.org>
References: <cover.1750980516.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bring the cmdline check_options[] array back into vertical alignment for
better readability.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/builtin-check.c | 52 +++++++++++++++++------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index a8c349f2273d..86b1a05c9353 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -73,35 +73,35 @@ static int parse_hacks(const struct option *opt, const char *str, int unset)
 
 static const struct option check_options[] = {
 	OPT_GROUP("Actions:"),
+	OPT_BOOLEAN(0  ,	 "cfi", &opts.cfi, "annotate kernel control flow integrity (kCFI) function preambles"),
 	OPT_CALLBACK_OPTARG('h', "hacks", NULL, NULL, "jump_label,noinstr,skylake", "patch toolchain bugs/limitations", parse_hacks),
-	OPT_BOOLEAN('i', "ibt", &opts.ibt, "validate and annotate IBT"),
-	OPT_BOOLEAN('m', "mcount", &opts.mcount, "annotate mcount/fentry calls for ftrace"),
-	OPT_BOOLEAN('n', "noinstr", &opts.noinstr, "validate noinstr rules"),
-	OPT_BOOLEAN(0,   "orc", &opts.orc, "generate ORC metadata"),
-	OPT_BOOLEAN('r', "retpoline", &opts.retpoline, "validate and annotate retpoline usage"),
-	OPT_BOOLEAN(0,   "rethunk", &opts.rethunk, "validate and annotate rethunk usage"),
-	OPT_BOOLEAN(0,   "unret", &opts.unret, "validate entry unret placement"),
-	OPT_INTEGER(0,   "prefix", &opts.prefix, "generate prefix symbols"),
-	OPT_BOOLEAN('l', "sls", &opts.sls, "validate straight-line-speculation mitigations"),
-	OPT_BOOLEAN('s', "stackval", &opts.stackval, "validate frame pointer rules"),
-	OPT_BOOLEAN('t', "static-call", &opts.static_call, "annotate static calls"),
-	OPT_BOOLEAN('u', "uaccess", &opts.uaccess, "validate uaccess rules for SMAP"),
-	OPT_BOOLEAN(0  , "cfi", &opts.cfi, "annotate kernel control flow integrity (kCFI) function preambles"),
-	OPT_CALLBACK_OPTARG(0, "dump", NULL, NULL, "orc", "dump metadata", parse_dump),
+	OPT_BOOLEAN('i',	 "ibt", &opts.ibt, "validate and annotate IBT"),
+	OPT_BOOLEAN('m',	 "mcount", &opts.mcount, "annotate mcount/fentry calls for ftrace"),
+	OPT_BOOLEAN('n',	 "noinstr", &opts.noinstr, "validate noinstr rules"),
+	OPT_BOOLEAN(0,		 "orc", &opts.orc, "generate ORC metadata"),
+	OPT_BOOLEAN('r',	 "retpoline", &opts.retpoline, "validate and annotate retpoline usage"),
+	OPT_BOOLEAN(0,		 "rethunk", &opts.rethunk, "validate and annotate rethunk usage"),
+	OPT_BOOLEAN(0,		 "unret", &opts.unret, "validate entry unret placement"),
+	OPT_INTEGER(0,		 "prefix", &opts.prefix, "generate prefix symbols"),
+	OPT_BOOLEAN('l',	 "sls", &opts.sls, "validate straight-line-speculation mitigations"),
+	OPT_BOOLEAN('s',	 "stackval", &opts.stackval, "validate frame pointer rules"),
+	OPT_BOOLEAN('t',	 "static-call", &opts.static_call, "annotate static calls"),
+	OPT_BOOLEAN('u',	 "uaccess", &opts.uaccess, "validate uaccess rules for SMAP"),
+	OPT_CALLBACK_OPTARG(0,	 "dump", NULL, NULL, "orc", "dump metadata", parse_dump),
 
 	OPT_GROUP("Options:"),
-	OPT_BOOLEAN(0,   "backtrace", &opts.backtrace, "unwind on error"),
-	OPT_BOOLEAN(0,   "backup", &opts.backup, "create backup (.orig) file on warning/error"),
-	OPT_BOOLEAN(0,   "dry-run", &opts.dryrun, "don't write modifications"),
-	OPT_BOOLEAN(0,   "link", &opts.link, "object is a linked object"),
-	OPT_BOOLEAN(0,   "module", &opts.module, "object is part of a kernel module"),
-	OPT_BOOLEAN(0,   "mnop", &opts.mnop, "nop out mcount call sites"),
-	OPT_BOOLEAN(0,   "no-unreachable", &opts.no_unreachable, "skip 'unreachable instruction' warnings"),
-	OPT_STRING('o',  "output", &opts.output, "file", "output file name"),
-	OPT_BOOLEAN(0,   "sec-address", &opts.sec_address, "print section addresses in warnings"),
-	OPT_BOOLEAN(0,   "stats", &opts.stats, "print statistics"),
-	OPT_BOOLEAN('v', "verbose", &opts.verbose, "verbose warnings"),
-	OPT_BOOLEAN(0,   "werror", &opts.werror, "return error on warnings"),
+	OPT_BOOLEAN(0,		 "backtrace", &opts.backtrace, "unwind on error"),
+	OPT_BOOLEAN(0,		 "backup", &opts.backup, "create backup (.orig) file on warning/error"),
+	OPT_BOOLEAN(0,		 "dry-run", &opts.dryrun, "don't write modifications"),
+	OPT_BOOLEAN(0,		 "link", &opts.link, "object is a linked object"),
+	OPT_BOOLEAN(0,		 "module", &opts.module, "object is part of a kernel module"),
+	OPT_BOOLEAN(0,		 "mnop", &opts.mnop, "nop out mcount call sites"),
+	OPT_BOOLEAN(0,		 "no-unreachable", &opts.no_unreachable, "skip 'unreachable instruction' warnings"),
+	OPT_STRING('o',		 "output", &opts.output, "file", "output file name"),
+	OPT_BOOLEAN(0,		 "sec-address", &opts.sec_address, "print section addresses in warnings"),
+	OPT_BOOLEAN(0,		 "stats", &opts.stats, "print statistics"),
+	OPT_BOOLEAN('v',	 "verbose", &opts.verbose, "verbose warnings"),
+	OPT_BOOLEAN(0,		 "werror", &opts.werror, "return error on warnings"),
 
 	OPT_END(),
 };
-- 
2.49.0


