Return-Path: <live-patching+bounces-2502-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uEBLNKur6mlc1wIAu9opvQ
	(envelope-from <live-patching+bounces-2502-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 01:30:51 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 41B9D458588
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 01:30:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B1DBD301178D
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 23:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 762B535839C;
	Thu, 23 Apr 2026 23:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Azk6Gkon"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539FB282F16;
	Thu, 23 Apr 2026 23:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776987048; cv=none; b=K2oIc7zme1ZvitmCBfByx8y6dvcMFmERvmFyKivG+pOd8U0jljrTRCgKKy76c+uFW0AfNJmqQCfOcyaFyfiJTbncHOo7j6m9lK9DcBPDOdkmHuWoJj30oIpQDK5Q0lCFtyuURWhSMWDm9AfDMaxEqOW56UjQYMvmlQzRqg9Pfns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776987048; c=relaxed/simple;
	bh=CJScKsiW3Uupfdl+NIuGJpv25DDnR/ay6Nm3VKzEN60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BqAKUC/ePVClLeJpgLTgIuqkxAxj/bsxymWaStNXK1Fq3eG7Vr57+oiZFLcMWYGRpWLZin4MkUzAaiX2XLDhlhyB/9JDaqzC/L2G8+KzynzV+ypFNWTIzKMW344VUVAsETDZXCUuCwPPKR5l89YWr+Nn8SOR8y54DpB8JUHRgoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Azk6Gkon; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D6EC2BCAF;
	Thu, 23 Apr 2026 23:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776987047;
	bh=CJScKsiW3Uupfdl+NIuGJpv25DDnR/ay6Nm3VKzEN60=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Azk6Gkon+9Ye0U/4qUtUC8AkwfjVuenFmGbN3FbMc1itHlERt5A89FZnXeCXsCAm+
	 +eG+ACSsNWG/lneXnjeek3/yblOsLjGxguMMTQ3laUTcowt51nAVtjn0j7bCvMVntz
	 R/ugAaITaj75QjjIad3wj3vmielzQEZSBUBlSCjhIcHZt88jXpBgqbH7oZId0EPykT
	 CY5HQLKMQQ17pa8ALIRCPAk/d5yAU34/CckmzH/H6d6sTCfC62wWndIK7SzLtePD68
	 5+INjPR4T+kpcoJdBBoLbfePVjGxnB3wtxuVwu76uw2aVKYKje/nBBxummGj52O7hK
	 EU9J/Iv1xyWSQ==
Date: Thu, 23 Apr 2026 16:30:45 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>, 
	Song Liu <song@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 45/48] x86/Kconfig: Enable CONFIG_PREFIX_SYMBOLS for
 FineIBT
Message-ID: <d5ex4fawfive7trcvhsptu2dwr5l5yru5q6bsx5zh3sqlle26u@navby7ru5z6t>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <70107aab81b01f8a2360f052ff550a9e97c30f79.1776916871.git.jpoimboe@kernel.org>
 <20260423084758.GY3126523@noisy.programming.kicks-ass.net>
 <n6xqf563o4moyl3sqp37ymakjhyvbxfinghi5k5lygeocak6ns@ugrn3b7csjot>
 <20260423151925.GG1064669@noisy.programming.kicks-ass.net>
 <gpq7mfal5gydlrqsm5mza5hzx5aa2rq7yk6olozlzotdnl7e24@ljzzzwwsputr>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <gpq7mfal5gydlrqsm5mza5hzx5aa2rq7yk6olozlzotdnl7e24@ljzzzwwsputr>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2502-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
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
X-Rspamd-Queue-Id: 41B9D458588
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 23, 2026 at 09:23:12AM -0700, Josh Poimboeuf wrote:
> On Thu, Apr 23, 2026 at 05:19:25PM +0200, Peter Zijlstra wrote:
> > On Thu, Apr 23, 2026 at 08:16:08AM -0700, Josh Poimboeuf wrote:
> > > On Thu, Apr 23, 2026 at 10:47:58AM +0200, Peter Zijlstra wrote:
> > > > On Wed, Apr 22, 2026 at 09:04:13PM -0700, Josh Poimboeuf wrote:
> > > > > PREFIX_SYMBOLS has a !CFI dependency because the compiler already
> > > > > generates __cfi_ prefix symbols for kCFI builds, so objtool-generated
> > > > > __pfx_ symbols were considered redundant.
> > > > > 
> > > > > However, the __cfi_ symbols only cover the 5-byte kCFI type hash.  With
> > > > > FUNCTION_CALL_PADDING, there are also 11 bytes of NOP padding between
> > > > > the hash and the function entry which have no symbol to claim them.
> > > > 
> > > > If you force the function alignment to 64 bytes, the prefix will also be
> > > > 64bytes, rather than the normal 16.
> > > 
> > > Sorry, how do you get 64 here?
> > 
> > DEBUG_FORCE_FUNCTION_ALIGNMENT_64B=y
> 
> Ok, so in that case it would be 5-byte cfi symbol and 59-byte NOP gap.
> Or a 64-byte pfx for the !CFI case.
> 
> > > > > The NOPs can be rewritten with call depth tracking thunks at runtime.
> > > > > Without a symbol, unwinders and other tools that symbolize code
> > > > > locations misattribute those bytes.
> > > > > 
> > > > > Remove the !CFI guard so objtool creates __pfx_ symbols for all
> > > > > CALL_PADDING configs, covering the full padding area regardless of
> > > > > whether there's also a __cfi_ symbol.
> > > > 
> > > > Egads, that a ton of symbols :/ Does it not make sense to 'fix' up the
> > > > __cfi_ symbols to cover the whole prefix?
> > > 
> > > Yeah, I suppose that would be better, via objtool I presume.
> > 
> > Yup.

From: Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH] objtool: Grow __cfi_* symbols for FineIBT

For FineIBT, the __cfi_ symbols only cover the 5-byte kCFI type hash.
After that there also N bytes of NOP padding between the hash and the
function entry which aren't associated with any symbol.

The NOPs can be replaced with actual code at runtime.  Without a symbol,
unwinders, objtool, and other tools have no way of knowing where those
bytes belong.

Grow the existing __cfi_* symbols to fill that gap.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/Makefile.lib                |  2 +-
 tools/objtool/check.c               | 13 ++++++++++++-
 tools/objtool/elf.c                 | 20 ++++++++++++++++++++
 tools/objtool/include/objtool/elf.h |  1 +
 4 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 0718e39cedda..baaf9f6c6bb5 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -187,7 +187,7 @@ objtool-args-$(CONFIG_HAVE_JUMP_LABEL_HACK)		+= --hacks=jump_label
 objtool-args-$(CONFIG_HAVE_NOINSTR_HACK)		+= --hacks=noinstr
 objtool-args-$(CONFIG_MITIGATION_CALL_DEPTH_TRACKING)	+= --hacks=skylake
 objtool-args-$(CONFIG_X86_KERNEL_IBT)			+= --ibt
-objtool-args-$(CONFIG_FINEIBT)				+= --cfi
+objtool-args-$(CONFIG_FINEIBT)				+= --cfi --prefix=$(CONFIG_FUNCTION_PADDING_BYTES)
 objtool-args-$(CONFIG_FTRACE_MCOUNT_USE_OBJTOOL)	+= --mcount
 ifdef CONFIG_FTRACE_MCOUNT_USE_OBJTOOL
 objtool-args-$(CONFIG_HAVE_OBJTOOL_NOP_MCOUNT)		+= --mnop
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


