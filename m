Return-Path: <live-patching+bounces-1487-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43025ACF3FC
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 18:18:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 80AEF7A7FBD
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 16:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79ED61E9B3D;
	Thu,  5 Jun 2025 16:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sm/wmBJw"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5168B8633A;
	Thu,  5 Jun 2025 16:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749140304; cv=none; b=h/qbcTAPCz8Dk6JgodYQKkMscPJS/QwXcIz4Tpc1d1ZTQxGWO0q652zWfoh0s3l+b8iWD2yFxWRTWD4VTZQWcX4erLJhldV1QBjdF2HzyNPlfbsBEU7UL2YKr71HvJjhk1NRBGEJLANVHD2oLVCCPQiJVpFanrhKSt/rdMmXPBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749140304; c=relaxed/simple;
	bh=SRKj8gYVohfXeCHPGriNj7MeCPVRvg8AiepK3gbSMRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hWPHyoYwOVNK5Mm+jEWutT/f7kzN9BvlXEd5svdS/tcKxp3gmhvz8bIuaiHyp0XNLrQCUfx5/0Bmoqqzgg51Rque/XvRlZ9huJZHSYg3lGhmNRqSm1krjs4ziNSq6dLKjxr6kDnN89ifPDCLm3oVTry/6W+/PGJs3WYxriGqLr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sm/wmBJw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1700C4CEE7;
	Thu,  5 Jun 2025 16:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749140303;
	bh=SRKj8gYVohfXeCHPGriNj7MeCPVRvg8AiepK3gbSMRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sm/wmBJw3RuKfYPSEfe2Dd9VFc1uunkVVEzXNRt+QQ2OE3J8L/RUUz2n5o80e0NcZ
	 78LdUbf+b3YFzrrZEJ/FTgfEjDwGL/ePUXcH44VpADrR0THZEIPLtBSrmvG1MgCD/F
	 Bz8q0NEbexo/eE6rhB0KRhwW4xfgN3wDv31R9jimP1lR85ua2r/ut+L83sI6BdA+AQ
	 BiNS4EyT5eWA2/icLSd9qsyRDyA2xk0q2nDFzp/W21eK0gFZv+exaZPnaFlNbm2lBC
	 g0CaNg+7QuMsPS0osk3gokZDVagGRk2WSR8CNsr3wqjo0LF1YwrLY2fc4s6BVJCWu5
	 cfvUbFLQ1qYzg==
Date: Thu, 5 Jun 2025 09:18:21 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 32/62] objtool: Suppress section skipping warnings
 with --dryrun
Message-ID: <czxofor57wifcgpb4uhxeiqmffueslu7zmbhbknlbfbx3uvyea@t57nbpp3tgkq>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <7eccdb0b09eff581377e5efab8377b6a37596992.1746821544.git.jpoimboe@kernel.org>
 <20250526105240.GN24938@noisy.programming.kicks-ass.net>
 <20250528103453.GF31726@noisy.programming.kicks-ass.net>
 <ycpdd352wztjux4wgduvwb7jgvt6djcb57gdepzai2gv5zkl3e@3igne4ssrjdm>
 <20250605073246.GM39944@noisy.programming.kicks-ass.net>
 <20250605145224.GE35970@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250605145224.GE35970@noisy.programming.kicks-ass.net>

On Thu, Jun 05, 2025 at 04:52:24PM +0200, Peter Zijlstra wrote:
> On Thu, Jun 05, 2025 at 09:32:46AM +0200, Peter Zijlstra wrote:
> 
> > > But also, feel free to resurrect --backup, or you can yell at me to do
> > > it as the backup code changed a bit.
> > 
> > I have the patch somewhere, failed to send it out. I'll try and dig it
> > out later today.
> 
> This is what I had. Wasn't sure we wanted to make -v imply --backup ?

Yeah, I suppose --verbose shouldn't be doing unrequested changes.

Regardless I want to keep the feature where print_args() modifies the
args to use the backup as input as that's very convenient.  We can just
tie that (and the printing of the args itself) to --backup.

> I'm used to stealing the objtool arguments from V=1 builds. I suppose
> the print_args thing is easier, might get used to it eventually.
> 
> 
> diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
> index 80239843e9f0..7d8f99cf9b0b 100644
> --- a/tools/objtool/builtin-check.c
> +++ b/tools/objtool/builtin-check.c
> @@ -101,6 +101,7 @@ static const struct option check_options[] = {
>  	OPT_BOOLEAN(0,   "stats", &opts.stats, "print statistics"),
>  	OPT_BOOLEAN('v', "verbose", &opts.verbose, "verbose warnings"),
>  	OPT_BOOLEAN(0,   "Werror", &opts.werror, "return error on warnings"),
> +	OPT_BOOLEAN(0,   "backup", &opts.backup, "create a backup (.orig) file on error"),

It should also work on warnings (non-werror) as well.

Something like so?

diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 80239843e9f0..d73ae71861fc 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -91,6 +91,7 @@ static const struct option check_options[] = {
 
 	OPT_GROUP("Options:"),
 	OPT_BOOLEAN(0,   "backtrace", &opts.backtrace, "unwind on error"),
+	OPT_BOOLEAN(0,   "backup", &opts.backup, "create a backup (.orig) file on warning"),
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
index 3a411064fa34..848dead666ae 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4798,9 +4798,11 @@ int check(struct objtool_file *file)
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

