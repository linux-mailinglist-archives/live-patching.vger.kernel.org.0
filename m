Return-Path: <live-patching+bounces-2507-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UCtgEKHl6mmFFQAAu9opvQ
	(envelope-from <live-patching+bounces-2507-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 05:38:09 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AC58B4597CA
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 05:38:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9F3E2300D168
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 03:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7296A2561A2;
	Fri, 24 Apr 2026 03:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BA/NVsu6"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50083230BDB;
	Fri, 24 Apr 2026 03:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777001885; cv=none; b=XKY67Gcr3Ww0BGkx7Z+KGga7sOG/yRQnq1LXF/qT/pkBkfCPCYScKXRoZ7UmWPgUERoAvXmFW4u9YwSzCTFeGytxProoc1rdSEZK0QXE5vuUzkhaHSMgbrD6hiybHoMvJ7LKg1OvgNDe5lIJsELVijPK3Tvfn+cLIdzNJQ3jEDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777001885; c=relaxed/simple;
	bh=JaS1suSxn9kwCD7e71FTwBaqV03J95bPMMk46vwDglk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L9sCDVCfsWFEoZ/9qrUgnGbcOogSu3ldNL1cBLkHqRaZGsgPt+wFklr9WiyuENbtzhgTfq/pVXpdihNOZC7HeYwtIknQDFvHMaT6givuhvxI95ynk+pDfBuYp0z0F5cbhNfNRTADb3h+luzoqOViCCuLowGVOxPf+bvlMbDADvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BA/NVsu6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22F7C19425;
	Fri, 24 Apr 2026 03:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777001884;
	bh=JaS1suSxn9kwCD7e71FTwBaqV03J95bPMMk46vwDglk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BA/NVsu6IPoy0C5TIVzNAuR39HhknER7Xhf11KvpykmSuTiOOSDMzMK0ZZqkEtQfm
	 0W35yGCA5/d7p82NG9TpirUWbYl2MBM492eKo38EMP/Vzn9qSbPKDPAkWOFcIqqCgN
	 XUTDd9wsc1/wU2FsrKNiHFtPF6iyH6PT4p45BI7gClUjl6b/Lkn5FX9lTa9wXl6DZj
	 TYm5dsvzYS3Z8xrF9LhI1J0c3P2q9+VUHDm2qGeLqdbGYGt5/8ft4FwlCOu5USywPr
	 7+eLjhliCjTeNmoWWphQKV9acjdiCBDRgrm/gaGj3u3EDEiFgLprRc39caz8FBGC3N
	 9KSegPShEPogA==
Date: Thu, 23 Apr 2026 20:38:02 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>, 
	Song Liu <song@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 45/48] x86/Kconfig: Enable CONFIG_PREFIX_SYMBOLS for
 FineIBT
Message-ID: <c7vi7gpfrybjmngjoqu2jmirh6jp53bpw5edeoeupz5gwhw6gx@fvcn6l6vgl47>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <70107aab81b01f8a2360f052ff550a9e97c30f79.1776916871.git.jpoimboe@kernel.org>
 <20260423084758.GY3126523@noisy.programming.kicks-ass.net>
 <n6xqf563o4moyl3sqp37ymakjhyvbxfinghi5k5lygeocak6ns@ugrn3b7csjot>
 <20260423151925.GG1064669@noisy.programming.kicks-ass.net>
 <gpq7mfal5gydlrqsm5mza5hzx5aa2rq7yk6olozlzotdnl7e24@ljzzzwwsputr>
 <d5ex4fawfive7trcvhsptu2dwr5l5yru5q6bsx5zh3sqlle26u@navby7ru5z6t>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d5ex4fawfive7trcvhsptu2dwr5l5yru5q6bsx5zh3sqlle26u@navby7ru5z6t>
X-Rspamd-Queue-Id: AC58B4597CA
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
	TAGGED_FROM(0.00)[bounces-2507-lists,live-patching=lfdr.de];
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

On Thu, Apr 23, 2026 at 04:30:47PM -0700, Josh Poimboeuf wrote:
> On Thu, Apr 23, 2026 at 09:23:12AM -0700, Josh Poimboeuf wrote:
> > On Thu, Apr 23, 2026 at 05:19:25PM +0200, Peter Zijlstra wrote:
> > > On Thu, Apr 23, 2026 at 08:16:08AM -0700, Josh Poimboeuf wrote:
> > > > On Thu, Apr 23, 2026 at 10:47:58AM +0200, Peter Zijlstra wrote:
> > > > > On Wed, Apr 22, 2026 at 09:04:13PM -0700, Josh Poimboeuf wrote:
> > > > > > PREFIX_SYMBOLS has a !CFI dependency because the compiler already
> > > > > > generates __cfi_ prefix symbols for kCFI builds, so objtool-generated
> > > > > > __pfx_ symbols were considered redundant.
> > > > > > 
> > > > > > However, the __cfi_ symbols only cover the 5-byte kCFI type hash.  With
> > > > > > FUNCTION_CALL_PADDING, there are also 11 bytes of NOP padding between
> > > > > > the hash and the function entry which have no symbol to claim them.
> > > > > 
> > > > > If you force the function alignment to 64 bytes, the prefix will also be
> > > > > 64bytes, rather than the normal 16.
> > > > 
> > > > Sorry, how do you get 64 here?
> > > 
> > > DEBUG_FORCE_FUNCTION_ALIGNMENT_64B=y
> > 
> > Ok, so in that case it would be 5-byte cfi symbol and 59-byte NOP gap.
> > Or a 64-byte pfx for the !CFI case.
> > 
> > > > > > The NOPs can be rewritten with call depth tracking thunks at runtime.
> > > > > > Without a symbol, unwinders and other tools that symbolize code
> > > > > > locations misattribute those bytes.
> > > > > > 
> > > > > > Remove the !CFI guard so objtool creates __pfx_ symbols for all
> > > > > > CALL_PADDING configs, covering the full padding area regardless of
> > > > > > whether there's also a __cfi_ symbol.
> > > > > 
> > > > > Egads, that a ton of symbols :/ Does it not make sense to 'fix' up the
> > > > > __cfi_ symbols to cover the whole prefix?
> > > > 
> > > > Yeah, I suppose that would be better, via objtool I presume.
> > > 
> > > Yup.

I discovered it's not just FineIBT, it's basically any CALL_PADDING+CFI,
like so:

From: Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH] objtool: Grow __cfi_* symbols for all kCFI+CALL_PADDING

For all CONFIG_CFI+CONFIG_CALL_PADDING configs, the __cfi_ symbols only
cover the 5-byte kCFI type hash.  After that there also N bytes of NOP
padding between the hash and the function entry which aren't associated
with any symbol.

The NOPs can be replaced with actual code at runtime.  Without a symbol,
unwinders and tooling have no way of knowing where those bytes belong.

Grow the existing __cfi_* symbols to fill that gap.

Also, CONFIG_PREFIX_SYMBOLS has no reason to exist: CONFIG_CALL_PADDING
is what causes the compiler to emit NOP padding before function entry
(via -fpatchable-function-entry), so it's the right condition for
creating prefix symbols.

Remove CONFIG_PREFIX_SYMBOLS, as it's no longer needed.  Simplify the
LONGEST_SYM_KUNIT_TEST dependency accordingly.

Update the --cfi and --prefix usage strings to reflect their current
scope.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/Kconfig                    |  4 ----
 lib/Kconfig.debug                   |  2 +-
 scripts/Makefile.lib                |  5 ++++-
 tools/objtool/builtin-check.c       |  9 +++++++--
 tools/objtool/check.c               | 13 ++++++++++++-
 tools/objtool/elf.c                 | 20 ++++++++++++++++++++
 tools/objtool/include/objtool/elf.h |  1 +
 7 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f3f7cb01d69d..3eb3c48d764a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2437,10 +2437,6 @@ config CALL_THUNKS
 	def_bool n
 	select CALL_PADDING
 
-config PREFIX_SYMBOLS
-	def_bool y
-	depends on CALL_PADDING && !CFI
-
 menuconfig CPU_MITIGATIONS
 	bool "Mitigations for CPU vulnerabilities"
 	default y
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 77c3774c1c49..8b41720069b3 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -3059,7 +3059,7 @@ config FORTIFY_KUNIT_TEST
 config LONGEST_SYM_KUNIT_TEST
 	tristate "Test the longest symbol possible" if !KUNIT_ALL_TESTS
 	depends on KUNIT && KPROBES
-	depends on !PREFIX_SYMBOLS && !CFI && !GCOV_KERNEL
+	depends on !CALL_PADDING && !GCOV_KERNEL
 	default KUNIT_ALL_TESTS
 	help
 	  Tests the longest symbol possible
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 0718e39cedda..562d89f051f0 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -187,7 +187,10 @@ objtool-args-$(CONFIG_HAVE_JUMP_LABEL_HACK)		+= --hacks=jump_label
 objtool-args-$(CONFIG_HAVE_NOINSTR_HACK)		+= --hacks=noinstr
 objtool-args-$(CONFIG_MITIGATION_CALL_DEPTH_TRACKING)	+= --hacks=skylake
 objtool-args-$(CONFIG_X86_KERNEL_IBT)			+= --ibt
-objtool-args-$(CONFIG_FINEIBT)				+= --cfi
+objtool-args-$(CONFIG_CALL_PADDING)			+= --prefix=$(CONFIG_FUNCTION_PADDING_BYTES)
+ifdef CONFIG_CFI
+objtool-args-$(CONFIG_CALL_PADDING)			+= --cfi
+endif
 objtool-args-$(CONFIG_FTRACE_MCOUNT_USE_OBJTOOL)	+= --mcount
 ifdef CONFIG_FTRACE_MCOUNT_USE_OBJTOOL
 objtool-args-$(CONFIG_HAVE_OBJTOOL_NOP_MCOUNT)		+= --mnop
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index ec7f10a5ef19..254ceb6b0e2c 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -73,7 +73,6 @@ static int parse_hacks(const struct option *opt, const char *str, int unset)
 
 static const struct option check_options[] = {
 	OPT_GROUP("Actions:"),
-	OPT_BOOLEAN(0,		 "cfi", &opts.cfi, "annotate kernel control flow integrity (kCFI) function preambles"),
 	OPT_STRING_OPTARG('d',	 "disas", &opts.disas, "function-pattern", "disassemble functions", "*"),
 	OPT_CALLBACK_OPTARG('h', "hacks", NULL, NULL, "jump_label,noinstr,skylake", "patch toolchain bugs/limitations", parse_hacks),
 	OPT_BOOLEAN('i',	 "ibt", &opts.ibt, "validate and annotate IBT"),
@@ -84,7 +83,7 @@ static const struct option check_options[] = {
 	OPT_BOOLEAN('r',	 "retpoline", &opts.retpoline, "validate and annotate retpoline usage"),
 	OPT_BOOLEAN(0,		 "rethunk", &opts.rethunk, "validate and annotate rethunk usage"),
 	OPT_BOOLEAN(0,		 "unret", &opts.unret, "validate entry unret placement"),
-	OPT_INTEGER(0,		 "prefix", &opts.prefix, "generate prefix symbols"),
+	OPT_INTEGER(0,		 "prefix", &opts.prefix, "generate or grow prefix symbols for N-byte function padding"),
 	OPT_BOOLEAN('l',	 "sls", &opts.sls, "validate straight-line-speculation mitigations"),
 	OPT_BOOLEAN('s',	 "stackval", &opts.stackval, "validate frame pointer rules"),
 	OPT_BOOLEAN('t',	 "static-call", &opts.static_call, "annotate static calls"),
@@ -92,6 +91,7 @@ static const struct option check_options[] = {
 	OPT_CALLBACK_OPTARG(0,	 "dump", NULL, NULL, "orc", "dump metadata", parse_dump),
 
 	OPT_GROUP("Options:"),
+	OPT_BOOLEAN(0,		 "cfi", &opts.cfi, "annotate and grow kCFI preamble symbols (use with --prefix)"),
 	OPT_BOOLEAN(0,		 "backtrace", &opts.backtrace, "unwind on error"),
 	OPT_BOOLEAN(0,		 "backup", &opts.backup, "create backup (.orig) file on warning/error"),
 	OPT_BOOLEAN(0,		 "dry-run", &opts.dryrun, "don't write modifications"),
@@ -163,6 +163,11 @@ static bool opts_valid(void)
 		return false;
 	}
 
+	if (opts.cfi && !opts.prefix) {
+		ERROR("--cfi requires --prefix");
+		return false;
+	}
+
 	if (opts.disas			||
 	    opts.hack_jump_label	||
 	    opts.hack_noinstr		||
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 410061aeed26..fb24fd284e09 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -923,6 +923,17 @@ static int create_cfi_sections(struct objtool_file *file)
 			return -1;
 
 		idx++;
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
 	}
 
 	return 0;
@@ -4927,7 +4938,7 @@ int check(struct objtool_file *file)
 			goto out;
 	}
 
-	if (opts.prefix) {
+	if (opts.prefix && !opts.cfi) {
 		ret = create_prefix_symbols(file);
 		if (ret)
 			goto out;
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 2ca1151de815..ede87dd9644c 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -983,6 +983,26 @@ struct symbol *elf_create_symbol(struct elf *elf, const char *name,
 	return sym;
 }
 
+int elf_write_symbol(struct elf *elf, struct symbol *sym)
+{
+	struct section *symtab, *symtab_shndx;
+
+	symtab = find_section_by_name(elf, ".symtab");
+	if (!symtab) {
+		ERROR("no .symtab");
+		return -1;
+	}
+
+	symtab_shndx = find_section_by_name(elf, ".symtab_shndx");
+
+	if (elf_update_symbol(elf, symtab, symtab_shndx, sym))
+		return -1;
+
+	mark_sec_changed(elf, symtab, true);
+
+	return 0;
+}
+
 struct symbol *elf_create_section_symbol(struct elf *elf, struct section *sec)
 {
 	struct symbol *sym = calloc(1, sizeof(*sym));
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 0fd1a9b563e9..4c8a67a68063 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -199,6 +199,7 @@ struct reloc *elf_init_reloc_data_sym(struct elf *elf, struct section *sec,
 				      struct symbol *sym,
 				      s64 addend);
 
+int elf_write_symbol(struct elf *elf, struct symbol *sym);
 int elf_write_insn(struct elf *elf, struct section *sec, unsigned long offset,
 		   unsigned int len, const char *insn);
 
-- 
2.53.0


