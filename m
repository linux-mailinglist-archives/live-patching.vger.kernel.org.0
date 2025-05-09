Return-Path: <live-patching+bounces-1393-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EC73AB1E16
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:25:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C86FF1C474F3
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:24:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E1182980C4;
	Fri,  9 May 2025 20:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V49WQpCB"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457432980BD;
	Fri,  9 May 2025 20:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821889; cv=none; b=EnjM2eMnhbHniKztaidN6na7nygGljeL2f7LM97/GWnYYnN8F8hEPO97/ENOcY1RHm9Ga8t+uG3NzbhIRaze+KJf3KAHOqEFMfqFURXmKpxObJJqRKaCECrkmw3UcbmrwvVgrJgJHO5vBSH7w/7lO2YJv17P7AwOh1zIVFp9DlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821889; c=relaxed/simple;
	bh=yhDQuxZsGgEz3jd505z5DoGpxMcvXqzEzc+Mv/9M55M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpcHke22DWcMYCqooSwwBuvfJ/o0iPsagbrc4Xvqm56JlSq/b/aC1KtxBJY/CzjEUoP2E2ypyw/nDdUXy0ifvTK3pefWfAJ++hlmcJZY5UebdZcX30WjpQzmZKTD6lD5nyAoMV9AOkjNGDpdojIKNt5UAIEbNZJ2Z025KNmdswE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V49WQpCB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A55BC4CEE9;
	Fri,  9 May 2025 20:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821888;
	bh=yhDQuxZsGgEz3jd505z5DoGpxMcvXqzEzc+Mv/9M55M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V49WQpCBUroaTOex1hnPzBrvXd9OkT3sltzE8d4/7Fg4c5/UTspYm0BRkDYNr1rAe
	 dyQKNh3YgPaDSmRqK+yloh1YQh7l1DujhDVjOhqChamG/EWyNx9kfMVmkJOmKd5f0b
	 Z3pF0EISM/Pm+u8tjQZVpB+/GsbX9F7VQyEgmqxf/0EXSmhGuH8eidMAB2DvPq38GX
	 mSV1q1/ikihRrGO5ug4apEz8m26ydqCZrMVfAzh1CF7BxePZ9wMli8TkyvAen/Qr57
	 uVk4sAV5FBfRN87C15F2GrGdY5vP3NQXGt8sHvWQbb4TfPrfOMx7aI6OhFrNmv5VG6
	 uACCvaEbsXYJQ==
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
	Puranjay Mohan <puranjay@kernel.org>
Subject: [PATCH v2 34/62] objtool: Reindent check_options[]
Date: Fri,  9 May 2025 13:16:58 -0700
Message-ID: <0f8de2dcf0379ff2dacb927df15e84b8784e9e8e.1746821544.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746821544.git.jpoimboe@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
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
 tools/objtool/builtin-check.c | 50 +++++++++++++++++------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 43139143edf8..56388bb98785 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -73,34 +73,34 @@ static int parse_hacks(const struct option *opt, const char *str, int unset)
 
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


