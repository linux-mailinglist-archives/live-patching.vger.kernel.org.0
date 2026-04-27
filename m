Return-Path: <live-patching+bounces-2561-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eLNcO5Ga72kbDQEAu9opvQ
	(envelope-from <live-patching+bounces-2561-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 19:19:13 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 665424772F1
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 19:19:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B6593303AF07
	for <lists+live-patching@lfdr.de>; Mon, 27 Apr 2026 17:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E1E63E314F;
	Mon, 27 Apr 2026 17:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rrAU2jZI"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF21729405;
	Mon, 27 Apr 2026 17:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777310275; cv=none; b=HKWAOlFQUHNy/+j3qF62ILnlxoElTMv9BXqWiviwGeyquuzNqC/ody2+9DfWCC4M/2Bxcl/Sz/hjnM6l+nfCj+pGP7ZH3w33kpmeViR54cHGhQHt+DAHoFCSctX9qcMIx/R1GT3SqS3nq6EEUcbkDBC8bGt+q7GMQ0xkDZ1ReTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777310275; c=relaxed/simple;
	bh=h40/rGikwG595E0hdHAoigh/5Gw/dIpr4/k2O1pz7cM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jVYe1U8j3ru/g0USe5MF6/ow2hmYFsDxUPWyhgujLqxLhSaBSYhUeSOuuWuRhriYFRGcE8pa4E+j2Tfse91898W+LRFRXXoa7SQCbCQEVaoui33Kk3d6YwbCRf9wuMKfrUoEZQVuLX/yNDCuc/zWMh1cbu4WX0kMZz5uIqOFmKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rrAU2jZI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02A1C19425;
	Mon, 27 Apr 2026 17:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777310274;
	bh=h40/rGikwG595E0hdHAoigh/5Gw/dIpr4/k2O1pz7cM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rrAU2jZIIrkDZ6SY7Hl0tex1GOHEos7rQS8YtnZ9G6rHWIK1ZZNkmw+3+DqFGSQ6s
	 z1TkQBlVHbXjx/JZNMxBl9+tKy7noobjqZJRoOikYW7tyRL416WM9bQX0uuddt26Au
	 Hq1fIl6ot848RZdg8pjQ1QUbcEwLVlDDkxCDgb3A6wx7Qm+fX91a1ypxUVYb2jS1X0
	 eoDNfvK94xx3/Upc7EREq38KW7aEQFmhWqQjTg4BccecPPksLU+2WUhwr5G++dXges
	 zydknDvdCfSLlxTKC972I1Aq1ym3QaYJjrptSCuxzaPHs0wcCMliXDYBB1eOL4Q+O3
	 oXKGJNPq5ZjkQ==
Date: Mon, 27 Apr 2026 10:17:52 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>, 
	Song Liu <song@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 45/48] x86/Kconfig: Enable CONFIG_PREFIX_SYMBOLS for
 FineIBT
Message-ID: <zuiurmehirj3w6c35xbnzbzqe3gvlkh2vihbkzehtxqox4jjqt@w66zy657x35t>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <70107aab81b01f8a2360f052ff550a9e97c30f79.1776916871.git.jpoimboe@kernel.org>
 <20260423084758.GY3126523@noisy.programming.kicks-ass.net>
 <n6xqf563o4moyl3sqp37ymakjhyvbxfinghi5k5lygeocak6ns@ugrn3b7csjot>
 <20260423151925.GG1064669@noisy.programming.kicks-ass.net>
 <gpq7mfal5gydlrqsm5mza5hzx5aa2rq7yk6olozlzotdnl7e24@ljzzzwwsputr>
 <d5ex4fawfive7trcvhsptu2dwr5l5yru5q6bsx5zh3sqlle26u@navby7ru5z6t>
 <c7vi7gpfrybjmngjoqu2jmirh6jp53bpw5edeoeupz5gwhw6gx@fvcn6l6vgl47>
 <20260424094530.GD3126523@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260424094530.GD3126523@noisy.programming.kicks-ass.net>
X-Rspamd-Queue-Id: 665424772F1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2561-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

On Fri, Apr 24, 2026 at 11:45:30AM +0200, Peter Zijlstra wrote:
> On Thu, Apr 23, 2026 at 08:38:02PM -0700, Josh Poimboeuf wrote:
> 
> > I discovered it's not just FineIBT, it's basically any CALL_PADDING+CFI,
> > like so:
> 
> Indeed. This looks good, thanks!

That was unncessarily creating .cfi_sites for the CFI+CALL_THUNKS case,
folding in the below:

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index d8ce7ad8c2c9..7f803796d20c 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -200,8 +200,9 @@ objtool-cmds-$(CONFIG_HAVE_UACCESS_VALIDATION)		+= --uaccess
 objtool-cmds-y						+= $(OBJTOOL_ARGS)
 
 # objtool options
-ifdef CONFIG_CFI
-objtool-opts-$(CONFIG_CALL_PADDING)			+= --cfi
+ifdef CONFIG_CALL_PADDING
+objtool-opts-$(CONFIG_CFI)				+= --cfi
+objtool-opts-$(CONFIG_FINEIBT)				+= --fineibt
 endif
 ifdef CONFIG_FTRACE_MCOUNT_USE_OBJTOOL
 objtool-opts-$(CONFIG_HAVE_OBJTOOL_NOP_MCOUNT)		+= --mnop
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 790de0cb445d..bd84f5b7c9ee 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -91,7 +91,8 @@ static const struct option check_options[] = {
 	OPT_CALLBACK_OPTARG(0,	 "dump", NULL, NULL, "orc", "dump metadata", parse_dump),
 
 	OPT_GROUP("Options:"),
-	OPT_BOOLEAN(0,		 "cfi", &opts.cfi, "annotate and grow kCFI preamble symbols (use with --prefix)"),
+	OPT_BOOLEAN(0,		 "cfi", &opts.cfi, "grow kCFI preamble symbols (use with --prefix)"),
+	OPT_BOOLEAN(0,		 "fineibt", &opts.fineibt, "create .cfi_sites section for FineIBT"),
 	OPT_BOOLEAN(0,		 "backtrace", &opts.backtrace, "unwind on error"),
 	OPT_BOOLEAN(0,		 "backup", &opts.backup, "create backup (.orig) file on warning/error"),
 	OPT_BOOLEAN(0,		 "dry-run", &opts.dryrun, "don't write modifications"),
@@ -163,6 +164,11 @@ static bool opts_valid(void)
 		return false;
 	}
 
+	if (opts.fineibt && !opts.cfi) {
+		ERROR("--fineibt requires --cfi");
+		return false;
+	}
+
 	if (opts.disas			||
 	    opts.hack_jump_label	||
 	    opts.hack_noinstr		||
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 11dad0d0b6ae..ac0a48145bf7 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -912,6 +912,29 @@ static int create_ibt_endbr_seal_sections(struct objtool_file *file)
 	return 0;
 }
 
+static int grow_cfi_symbols(struct objtool_file *file)
+{
+	struct symbol *sym;
+
+	for_each_sym(file->elf, sym) {
+		if (!is_func_sym(sym) || !strstarts(sym->name, "__cfi_"))
+			continue;
+
+		/*
+		 * Grow the __cfi_ symbol to fill the NOP gap between the
+		 * 'mov <hash>, %rax' and the start of the function.
+		 */
+		if (sym->len == 5) {
+			sym->len += opts.prefix;
+			sym->sym.st_size = sym->len;
+			if (elf_write_symbol(file->elf, sym))
+				return -1;
+		}
+	}
+
+	return 0;
+}
+
 static int create_cfi_sections(struct objtool_file *file)
 {
 	struct section *sec;
@@ -954,17 +977,6 @@ static int create_cfi_sections(struct objtool_file *file)
 			return -1;
 
 		idx++;
-
-		/*
-		 * Grow the __cfi_ symbol to fill the NOP gap between the
-		 * 'mov <hash>, %rax' and the start of the function.
-		 */
-		if (sym->len == 5) {
-			sym->len += opts.prefix;
-			sym->sym.st_size = sym->len;
-			if (elf_write_symbol(file->elf, sym))
-				return -1;
-		}
 	}
 
 	return 0;
@@ -4885,12 +4897,6 @@ int check(struct objtool_file *file)
 			goto out;
 	}
 
-	if (opts.cfi) {
-		ret = create_cfi_sections(file);
-		if (ret)
-			goto out;
-	}
-
 	if (opts.rethunk) {
 		ret = create_return_sites_sections(file);
 		if (ret)
@@ -4909,10 +4915,22 @@ int check(struct objtool_file *file)
 			goto out;
 	}
 
-	if (opts.prefix && !opts.cfi) {
-		ret = create_prefix_symbols(file);
-		if (ret)
-			goto out;
+	if (opts.prefix) {
+		if (!opts.cfi) {
+			ret = create_prefix_symbols(file);
+			if (ret)
+				goto out;
+		} else {
+			ret = grow_cfi_symbols(file);
+			if (ret)
+				goto out;
+
+			if (opts.fineibt) {
+				ret = create_cfi_sections(file);
+				if (ret)
+					goto out;
+			}
+		}
 	}
 
 	if (opts.ibt) {
diff --git a/tools/objtool/include/objtool/builtin.h b/tools/objtool/include/objtool/builtin.h
index b9e229ed4dc0..e844e9c82b7b 100644
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -9,8 +9,8 @@
 
 struct opts {
 	/* actions: */
-	bool cfi;
 	bool checksum;
+	const char *disas;
 	bool dump_orc;
 	bool hack_jump_label;
 	bool hack_noinstr;
@@ -20,6 +20,7 @@ struct opts {
 	bool noabs;
 	bool noinstr;
 	bool orc;
+	int prefix;
 	bool retpoline;
 	bool rethunk;
 	bool unret;
@@ -27,14 +28,14 @@ struct opts {
 	bool stackval;
 	bool static_call;
 	bool uaccess;
-	int prefix;
-	const char *disas;
 
 	/* options: */
 	bool backtrace;
 	bool backup;
+	bool cfi;
 	const char *debug_checksum;
 	bool dryrun;
+	bool fineibt;
 	bool link;
 	bool mnop;
 	bool module;

