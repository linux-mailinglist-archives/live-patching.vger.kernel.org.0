Return-Path: <live-patching+bounces-1691-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AE0BB80E2A
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:13:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 069BD5444A9
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 994E633AE8F;
	Wed, 17 Sep 2025 16:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZMsgYhIC"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F573397DE;
	Wed, 17 Sep 2025 16:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125082; cv=none; b=sXYzSfAwMGHR7P3EvHlhItwrrTp2wsLsDIhCMKHhTcjyFuza+bgA2kKeTHpWwLT1U1bdVIuiSkw8oW81C9+dSPDVk0RUQOA4JwDfBQzJ1HtM2QC7yDcfXywp+6Nf1LVBqvallxjd7KSexSJ/qVWyN0cHZYHMJouXB9LciX7tKRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125082; c=relaxed/simple;
	bh=8NB37iyrPJ3HNhpUBA1Q2gElLVcU8HDTweQJhiItM1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0nwDai2gF65vkYcI6dzTzAU3mT6AVa6gkWyVauYC2WohkeFVnKcNiCIHkMHmUGSseWt9RMmPYXsA4zThegA/tHZZsB9aQZOwZ1tuv7qMVZCVRCBsvrwxMNE+51F+0pe+8fz5tuZ0nC0vdY+5c66fFKCmN6ZRqa1rbgxKlVPKpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZMsgYhIC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5857AC4CEF7;
	Wed, 17 Sep 2025 16:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125081;
	bh=8NB37iyrPJ3HNhpUBA1Q2gElLVcU8HDTweQJhiItM1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMsgYhICL0189w09DH9TpXlKSA+7Qq10T7IQrKMqsLKBQ15xs+hjA37BNyjtjUWJ1
	 GH9l8R+e8og95mjnYoY5PG1OhhjCxTtNleFeKaxon1nEFOSWSvT7Y7NF1SrdJe+O2e
	 DuugK28zqCDcxVovFWT3Ik3jAA94uU/TpGV9CencdpH39lXv06jcvqBer5Jx0RqsLe
	 jOmrJAJdU8aVDV+3XkTqpvekCBW8NWw0PVAKY9BkE1Qk8UeaJGHeWUpmHmOdw1RLEj
	 F78NmQv47Rc/9EqfUBI3Y2GVb11Tu/nA3nhOCB8bxrQ56il5uruFrZkpijHZiB11nO
	 SY10OZBSuCAoA==
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
	Dylan Hatch <dylanbhatch@google.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v4 36/63] objtool: Reindent check_options[]
Date: Wed, 17 Sep 2025 09:03:44 -0700
Message-ID: <94535b3e5d3e2cf59db5a95761f7492e502fb33c.1758067943.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <cover.1758067942.git.jpoimboe@kernel.org>
References: <cover.1758067942.git.jpoimboe@kernel.org>
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
 tools/objtool/builtin-check.c | 54 +++++++++++++++++------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index dcf618f47fcc5..e7a8f58f5630c 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -73,36 +73,36 @@ static int parse_hacks(const struct option *opt, const char *str, int unset)
 
 static const struct option check_options[] = {
 	OPT_GROUP("Actions:"),
+	OPT_BOOLEAN(0,		 "cfi", &opts.cfi, "annotate kernel control flow integrity (kCFI) function preambles"),
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
-	OPT_BOOLEAN(0  , "noabs", &opts.noabs, "reject absolute references in allocatable sections"),
-	OPT_CALLBACK_OPTARG(0, "dump", NULL, NULL, "orc", "dump metadata", parse_dump),
+	OPT_BOOLEAN('i',	 "ibt", &opts.ibt, "validate and annotate IBT"),
+	OPT_BOOLEAN('m',	 "mcount", &opts.mcount, "annotate mcount/fentry calls for ftrace"),
+	OPT_BOOLEAN(0,		 "noabs", &opts.noabs, "reject absolute references in allocatable sections"),
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
2.50.0


