Return-Path: <live-patching+bounces-1562-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C5EBAAEAB44
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:02:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB58E7B0D5B
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E044F2741CF;
	Thu, 26 Jun 2025 23:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lQuxekRM"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97CA2741BD;
	Thu, 26 Jun 2025 23:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982194; cv=none; b=L4SVas3369D5i0yp+PdV0LUcZhnXzym0pepuYPR8EvuPlI/BA7pA9tamzs/CW5YqzKBgqSORoxmbz3NBgAotP182F7UM+iASfc5TrlAYZ1G13mDKaFbNRu6zKYZI4CrD7meh+T4nM7OHWVUs2wcbPuvRgY9QJuRe1cBDUI5tvqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982194; c=relaxed/simple;
	bh=P5rJMf7MJH0iZc9LhFqWVZDsQVVzXo7UwffRmxW3vRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLvcReLlCLjF7t7p26hxMBhymPEnif7guTZQQf6w1bIWQcfvN8tInqdkJ8GHtrhxuC72WwpyLkPdBQSjLaSCBKaeom2GEOu9dfR+NkqMkkIVzQbTyBcgFXkSh0TDSvVyV+Y98TKhCnjbOqwjY8k5hJ4AU2NsVwAgnUPeEXiszx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lQuxekRM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11778C4CEEF;
	Thu, 26 Jun 2025 23:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982194;
	bh=P5rJMf7MJH0iZc9LhFqWVZDsQVVzXo7UwffRmxW3vRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQuxekRMHtyaIhLbm05upv18OEdecneyRcqrGy7s0l+tjNwDvLt5sFUrR70fEvNMz
	 gcHXRbPyeJRYB7vTmfGMKBjMaIU/v5a4fCzxFuK1CkXqvDL6IBTDOoSQG21m9XF8S5
	 UCaHbkc2YK1C8c1nP0NYonntIA+80aX3KAH1pSiJTC1dLqj63LNaH4AT6ndPq8gsK4
	 05BGy2DeSpWdTj/349fx9CHmKa7DnUxTe4AW6UoqYGeupfICYj3gIA4O2QPzfRcWCG
	 vMzxrqE6kRD28Nr0zvUH+PP/kaU/3b7Ph97HkvMNOKBxzRrVxUZPu+iIJ5Bdm9U7Fe
	 LaEj3zGxDjItQ==
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
Subject: [PATCH v3 33/64] objtool: Resurrect --backup option
Date: Thu, 26 Jun 2025 16:55:20 -0700
Message-ID: <a38a84c7202384d3842af3fab9d03f6f889a6121.1750980517.git.jpoimboe@kernel.org>
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
index 43139143edf8..a8c349f2273d 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -91,6 +91,7 @@ static const struct option check_options[] = {
 
 	OPT_GROUP("Options:"),
 	OPT_BOOLEAN(0,   "backtrace", &opts.backtrace, "unwind on error"),
+	OPT_BOOLEAN(0,   "backup", &opts.backup, "create backup (.orig) file on warning/error"),
 	OPT_BOOLEAN(0,   "dry-run", &opts.dryrun, "don't write modifications"),
 	OPT_BOOLEAN(0,   "link", &opts.link, "object is a linked object"),
 	OPT_BOOLEAN(0,   "module", &opts.module, "object is part of a kernel module"),
@@ -244,12 +245,9 @@ static void save_argv(int argc, const char **argv)
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
@@ -258,33 +256,32 @@ void print_args(void)
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
index 87d2ba7739d5..46ace2c80317 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4745,9 +4745,11 @@ int check(struct objtool_file *file)
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
index 6b08666fa69d..de6c08f8e060 100644
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -29,6 +29,7 @@ struct opts {
 
 	/* options: */
 	bool backtrace;
+	bool backup;
 	bool dryrun;
 	bool link;
 	bool mnop;
@@ -47,6 +48,6 @@ int cmd_parse_options(int argc, const char **argv, const char * const usage[]);
 
 int objtool_run(int argc, const char **argv);
 
-void print_args(void);
+int make_backup(void);
 
 #endif /* _BUILTIN_H */
-- 
2.49.0


