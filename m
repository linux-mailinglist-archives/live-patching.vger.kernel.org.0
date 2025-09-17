Return-Path: <live-patching+bounces-1690-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDFC5B80DDD
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:10:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91E40585AC4
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D2753362B3;
	Wed, 17 Sep 2025 16:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F7ktqvg2"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E2F3362A8;
	Wed, 17 Sep 2025 16:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125081; cv=none; b=sMKRrjnKk39nX5GseT5hYqbfigEuhFKo6NYxTVmEGaZ1i8EgzXi7PX/Tjybip9FwXW6ixY7ka9meTFckWqIVW4bASmzuTwYB1HI9mGqj3XV5cu4mybypJx6OlTK3bgJxOx04AXRCz13SweIQw8mlW07avMAxRRu2QREMW62DrwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125081; c=relaxed/simple;
	bh=XRDK3eaJ/HMijyZKn27Lt+tT8Bbc0CemYWBU1r/NQmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTpoHBH3GERWP8vGHPJkO+ev/TvKCEHHOVoQs25Wwrpv7bPiq74mprftjTYI3CZlx0gqUsi4hE0WcTdUcKQefB+pVvkfGst47XKHGQNrpqFC+Ugqoo8bzdPrLRiAd9mLf1/sYJPYbZq5gOJjMnAxyqj6PWVIcUPgw2kElDRWVAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F7ktqvg2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBF2C4CEF9;
	Wed, 17 Sep 2025 16:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125081;
	bh=XRDK3eaJ/HMijyZKn27Lt+tT8Bbc0CemYWBU1r/NQmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7ktqvg2OsO97DLDOI4r+MZSsNgdU4aGcEzkUy0yO+1h/dQDil/S+5wDs2tS+HoAf
	 kWzJRKrrPgdmNneLw4srAp09r+Uy58lrJASykMKt+Ukkm8AEXBXjA3OlJkbwunQoqh
	 3FjHkQ/7vfY/50KMRgwnYOxgmwjn7WBXrj0GO6IsKueZnLtIodKryQXSXYzorexoM8
	 Zlr2Cfupydk3TMTFUwcSQvby4I2r+Z838cOPFJR0WAoKvkxNPOMJyY6geWaoXt/uC3
	 uycwWQZZoOVQ+xK9FCx6I2mRRbhHVVTGDuT47wkJN4cAoopTafteDkcmJBDMtRhKxN
	 9mHYFnxzMmSBA==
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
Subject: [PATCH v4 35/63] objtool: Resurrect --backup option
Date: Wed, 17 Sep 2025 09:03:43 -0700
Message-ID: <50fba34637c946def2db104d007dcd10ba16b477.1758067943.git.jpoimboe@kernel.org>
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

The --backup option was removed with the following commit:

  aa8b3e64fd39 ("objtool: Create backup on error and print args")

... which tied the backup functionality to --verbose, and only for
warnings/errors.

It's a bit inelegant and out of scope to tie that to --verbose.

Bring back the old --backup option, but with the new behavior: only on
warnings/errors, and print the args to make it easier to recreate.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/builtin-check.c           | 25 +++++++++++--------------
 tools/objtool/check.c                   |  4 +++-
 tools/objtool/include/objtool/builtin.h |  3 ++-
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 8e2047026cc51..dcf618f47fcc5 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -92,6 +92,7 @@ static const struct option check_options[] = {
 
 	OPT_GROUP("Options:"),
 	OPT_BOOLEAN(0,   "backtrace", &opts.backtrace, "unwind on error"),
+	OPT_BOOLEAN(0,   "backup", &opts.backup, "create backup (.orig) file on warning/error"),
 	OPT_BOOLEAN(0,   "dry-run", &opts.dryrun, "don't write modifications"),
 	OPT_BOOLEAN(0,   "link", &opts.link, "object is a linked object"),
 	OPT_BOOLEAN(0,   "module", &opts.module, "object is part of a kernel module"),
@@ -246,12 +247,9 @@ static void save_argv(int argc, const char **argv)
 	};
 }
 
-void print_args(void)
+int make_backup(void)
 {
-	char *backup = NULL;
-
-	if (opts.output || opts.dryrun)
-		goto print;
+	char *backup;
 
 	/*
 	 * Make a backup before kbuild deletes the file so the error
@@ -260,33 +258,32 @@ void print_args(void)
 	backup = malloc(strlen(objname) + strlen(ORIG_SUFFIX) + 1);
 	if (!backup) {
 		ERROR_GLIBC("malloc");
-		goto print;
+		return 1;
 	}
 
 	strcpy(backup, objname);
 	strcat(backup, ORIG_SUFFIX);
-	if (copy_file(objname, backup)) {
-		backup = NULL;
-		goto print;
-	}
+	if (copy_file(objname, backup))
+		return 1;
 
-print:
 	/*
-	 * Print the cmdline args to make it easier to recreate.  If '--output'
-	 * wasn't used, add it to the printed args with the backup as input.
+	 * Print the cmdline args to make it easier to recreate.
 	 */
+
 	fprintf(stderr, "%s", orig_argv[0]);
 
 	for (int i = 1; i < orig_argc; i++) {
 		char *arg = orig_argv[i];
 
-		if (backup && !strcmp(arg, objname))
+		/* Modify the printed args to use the backup */
+		if (!opts.output && !strcmp(arg, objname))
 			fprintf(stderr, " %s -o %s", backup, objname);
 		else
 			fprintf(stderr, " %s", arg);
 	}
 
 	fprintf(stderr, "\n");
+	return 0;
 }
 
 int objtool_run(int argc, const char **argv)
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index f75de86c60f5f..2af4cafb683fa 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4833,9 +4833,11 @@ int check(struct objtool_file *file)
 	if (opts.verbose) {
 		if (opts.werror && warnings)
 			WARN("%d warning(s) upgraded to errors", warnings);
-		print_args();
 		disas_warned_funcs(file);
 	}
 
+	if (opts.backup && make_backup())
+		return 1;
+
 	return ret;
 }
diff --git a/tools/objtool/include/objtool/builtin.h b/tools/objtool/include/objtool/builtin.h
index ab22673862e1b..7d559a2c13b7b 100644
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -30,6 +30,7 @@ struct opts {
 
 	/* options: */
 	bool backtrace;
+	bool backup;
 	bool dryrun;
 	bool link;
 	bool mnop;
@@ -48,6 +49,6 @@ int cmd_parse_options(int argc, const char **argv, const char * const usage[]);
 
 int objtool_run(int argc, const char **argv);
 
-void print_args(void);
+int make_backup(void);
 
 #endif /* _BUILTIN_H */
-- 
2.50.0


