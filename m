Return-Path: <live-patching+bounces-1486-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86878ACF258
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 16:52:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C8561618DA
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 14:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E8AC17FAC2;
	Thu,  5 Jun 2025 14:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jrdv1awi"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D62F15746F;
	Thu,  5 Jun 2025 14:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749135159; cv=none; b=bXfn7Otx0ULeDsJQkrPR0XPP/Lpko2B18vkopI4VZw4TtxTo0Eg6EfNYaHRZ+eW6azFRAts1TyAp3o6yBEaEW092UXXsg6HMnrlj/VKWXQOQfRjQrOW3cVSe7kB/vIR5VrN4yPXN+MyMgNE8pmoI/mYMUW7xJje7eYbpKMPWdnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749135159; c=relaxed/simple;
	bh=wayIl4wmNDj1d9bhCMlvwZSoiA+VMr2flEQT0BpqHB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mW7C/lF+BoHewsC+FJSeWZFkLGJWviPw99aDOuQkPBmXeFXnbJYR0QsrdylQqP7uglQCnC8SlthEqRz03D3x6THNG6MbBxjlar/24lX1ZRiZWUIm5wH6DjqHAJ0MBgqAv59cK3VJwpMc5nB9o5API2ij9ybf7quRTUTx5J1hSMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jrdv1awi; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iR8UuHFYy7CvKHN3eUB5kYDHYIukekw7Is23zJCqzRQ=; b=jrdv1awi310rJSQKvOHJBSXrYW
	XFDPs16zYuknImMAqPEPO5fsCkq5NMijUXxGtnmsbJFXdhq8h/cgi11hlzuRNfRQyra36sy0KyVlU
	lmObjGt3cD5FRAHPima6M4vLn2QDGf3EJzGdmv4RxQD9ctaRCm2tRqzoSs/c9tPJIxOg4j43EgLaC
	L7YQgDF2yqs99w64A+G9CXpPgNlpMhX9hySMPUfKKfznyiS6fGrjf1LkuFg2Jzs93XerNE5MyBeur
	FxYkW6IwXxFYQQSiSv4ZhzChakALQ9Vid9Jt7o7BwXbTRQvxAK//rrSA/FgGunCF1HuR5Eq5xE/FA
	j3MC85Dg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uNBxB-00000001Aws-0oph;
	Thu, 05 Jun 2025 14:52:26 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 66B483005AF; Thu,  5 Jun 2025 16:52:24 +0200 (CEST)
Date: Thu, 5 Jun 2025 16:52:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 32/62] objtool: Suppress section skipping warnings
 with --dryrun
Message-ID: <20250605145224.GE35970@noisy.programming.kicks-ass.net>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <7eccdb0b09eff581377e5efab8377b6a37596992.1746821544.git.jpoimboe@kernel.org>
 <20250526105240.GN24938@noisy.programming.kicks-ass.net>
 <20250528103453.GF31726@noisy.programming.kicks-ass.net>
 <ycpdd352wztjux4wgduvwb7jgvt6djcb57gdepzai2gv5zkl3e@3igne4ssrjdm>
 <20250605073246.GM39944@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605073246.GM39944@noisy.programming.kicks-ass.net>

On Thu, Jun 05, 2025 at 09:32:46AM +0200, Peter Zijlstra wrote:

> > But also, feel free to resurrect --backup, or you can yell at me to do
> > it as the backup code changed a bit.
> 
> I have the patch somewhere, failed to send it out. I'll try and dig it
> out later today.

This is what I had. Wasn't sure we wanted to make -v imply --backup ?

I'm used to stealing the objtool arguments from V=1 builds. I suppose
the print_args thing is easier, might get used to it eventually.


diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 80239843e9f0..7d8f99cf9b0b 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -101,6 +101,7 @@ static const struct option check_options[] = {
 	OPT_BOOLEAN(0,   "stats", &opts.stats, "print statistics"),
 	OPT_BOOLEAN('v', "verbose", &opts.verbose, "verbose warnings"),
 	OPT_BOOLEAN(0,   "Werror", &opts.werror, "return error on warnings"),
+	OPT_BOOLEAN(0,   "backup", &opts.backup, "create a backup (.orig) file on error"),
 
 	OPT_END(),
 };
@@ -244,13 +245,10 @@ static void save_argv(int argc, const char **argv)
 	};
 }
 
-void print_args(void)
+static void make_backup(void)
 {
 	char *backup = NULL;
 
-	if (opts.output || opts.dryrun)
-		goto print;
-
 	/*
 	 * Make a backup before kbuild deletes the file so the error
 	 * can be recreated without recompiling or relinking.
@@ -258,17 +256,19 @@ void print_args(void)
 	backup = malloc(strlen(objname) + strlen(ORIG_SUFFIX) + 1);
 	if (!backup) {
 		ERROR_GLIBC("malloc");
-		goto print;
+		return;
 	}
 
 	strcpy(backup, objname);
 	strcat(backup, ORIG_SUFFIX);
 	if (copy_file(objname, backup)) {
 		backup = NULL;
-		goto print;
+		return;
 	}
+}
 
-print:
+void print_args(void)
+{
 	/*
 	 * Print the cmdline args to make it easier to recreate.  If '--output'
 	 * wasn't used, add it to the printed args with the backup as input.
@@ -278,10 +278,7 @@ void print_args(void)
 	for (int i = 1; i < orig_argc; i++) {
 		char *arg = orig_argv[i];
 
-		if (backup && !strcmp(arg, objname))
-			fprintf(stderr, " %s -o %s", backup, objname);
-		else
-			fprintf(stderr, " %s", arg);
+		fprintf(stderr, " %s", arg);
 	}
 
 	fprintf(stderr, "\n");
@@ -324,8 +321,11 @@ int objtool_run(int argc, const char **argv)
 	}
 
 	ret = check(file);
-	if (ret)
+	if (ret) {
+		if (opts.backup)
+			make_backup();
 		return ret;
+	}
 
 	if (!opts.dryrun && file->elf->changed && elf_write(file->elf))
 		return 1;
diff --git a/tools/objtool/include/objtool/builtin.h b/tools/objtool/include/objtool/builtin.h
index 6b08666fa69d..97c36fb1fe9a 100644
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -39,6 +39,7 @@ struct opts {
 	bool stats;
 	bool verbose;
 	bool werror;
+	bool backup;
 };
 
 extern struct opts opts;

