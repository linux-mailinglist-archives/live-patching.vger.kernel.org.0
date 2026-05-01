Return-Path: <live-patching+bounces-2667-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uMrKGysq9GlT+wEAu9opvQ
	(envelope-from <live-patching+bounces-2667-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:20:59 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C9CF14AA438
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:20:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 60B6D3054C27
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E128837AA8A;
	Fri,  1 May 2026 04:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MH1rJOw0"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAF031E83A;
	Fri,  1 May 2026 04:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608554; cv=none; b=lGSSYXve+4DzUpBlNR3DZLZzhb+YAo1oBwiLjQhaEgaOj2JU4a2abD/zzGXu0baDe5f7+Z3c6YdpqTcfTd9YaUuCYTB0tyywLYAd26rMOFcGq2IDxEgZPcZIUpa0DuzSa7GNRw9FxMZ+PVGQh93LY5oZ/myHWGAaZMd13c0IWvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608554; c=relaxed/simple;
	bh=Io0p+N+f7/re/QtdLy2xkr+VYDcZLNkvDOWreGLhkck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spHQUyYnK8AGLfpxz0G5pO5NLaTlpED+Ysx+gFT/cbsNP9XlZ0nkxOcuQnFfe8XSOwsYLellokAmbxsJ9OKCxNTLgXW4JdNfBWJXBBOmovTwNe2y8eDjifUr/GiJDklawM2/4cPixEgYYhCtiD96IwxSNQjx6+ZSTgZH1LoxTlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MH1rJOw0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACDCC2BCB9;
	Fri,  1 May 2026 04:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608554;
	bh=Io0p+N+f7/re/QtdLy2xkr+VYDcZLNkvDOWreGLhkck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MH1rJOw0MABgA36SshYNl3q+A/faPnfJM3FoRoxQrernF4pDEkm4V115WnM1NzPxe
	 yuoOncjfhOJv6DJmDOf5LWh+6auEGht+YhTEqkzikW3ky2ZTNMCxY2yTpQ6nhGZj3o
	 mqFC07f2y5nL+a8t4dVP370SDgtv5t80FRhDN9LD8goSPkl+c5osx9BIJ/dsDqa9Vy
	 s27BZctC7FPeKJ8tPzz22heY1vyL4/zuoISz5MeE8RLWtTv3wnpZMmxE/j2Yzoc0IB
	 Jf6IvRDYrZiuEeFqmREvAhEg/cPm/i660B+VBUTi1FEK/z2J9LMuGFfk88piGZwe2w
	 HkjfID710DsYQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 50/53] objtool: Grow __cfi_* prefix symbols for all CFI+CALL_PADDING
Date: Thu, 30 Apr 2026 21:08:38 -0700
Message-ID: <089348f37d6d4a32827e8d94d9dbe10c9985789a.1777575752.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C9CF14AA438
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2667-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,infradead.org:email]

For all CONFIG_CFI+CONFIG_CALL_PADDING configs, for C functions, the
__cfi_ symbols only cover the 5-byte kCFI type hash.  After that there
also N bytes of NOP padding between the hash and the function entry
which aren't associated with any symbol.

The NOPs can be replaced with actual code at runtime.  Without a symbol,
unwinders and tooling have no way of knowing where those bytes belong.

Grow the existing __cfi_* symbols to fill that gap.

Note that assembly functions with SYM_TYPED_FUNC_START() aren't affected
by this issue, their __cfi_ symbols also cover the padding.

Also, CONFIG_PREFIX_SYMBOLS has no reason to exist: CONFIG_CALL_PADDING
is what causes the compiler to emit NOP padding before function entry
(via -fpatchable-function-entry), so it's the right condition for
creating prefix symbols.

Remove CONFIG_PREFIX_SYMBOLS, as it's no longer needed.  Simplify the
LONGEST_SYM_KUNIT_TEST dependency accordingly.  Rework objtool's
arguments a bit to handle the variety of prefix/cfi-related cases.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/Kconfig                        |  4 --
 lib/Kconfig.debug                       |  2 +-
 scripts/Makefile.lib                    |  7 +++-
 tools/objtool/builtin-check.c           | 15 +++++++-
 tools/objtool/check.c                   | 49 ++++++++++++++++++++-----
 tools/objtool/elf.c                     | 20 ++++++++++
 tools/objtool/include/objtool/builtin.h |  7 ++--
 tools/objtool/include/objtool/elf.h     |  1 +
 8 files changed, 84 insertions(+), 21 deletions(-)

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
index 8ff5adcfe1e0..4f7496b3268d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -3070,7 +3070,7 @@ config FORTIFY_KUNIT_TEST
 config LONGEST_SYM_KUNIT_TEST
 	tristate "Test the longest symbol possible" if !KUNIT_ALL_TESTS
 	depends on KUNIT && KPROBES
-	depends on !PREFIX_SYMBOLS && !CFI && !GCOV_KERNEL
+	depends on !CALL_PADDING && !CFI && !GCOV_KERNEL
 	default KUNIT_ALL_TESTS
 	help
 	  Tests the longest symbol possible
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 0718e39cedda..7e216d82e988 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -187,7 +187,11 @@ objtool-args-$(CONFIG_HAVE_JUMP_LABEL_HACK)		+= --hacks=jump_label
 objtool-args-$(CONFIG_HAVE_NOINSTR_HACK)		+= --hacks=noinstr
 objtool-args-$(CONFIG_MITIGATION_CALL_DEPTH_TRACKING)	+= --hacks=skylake
 objtool-args-$(CONFIG_X86_KERNEL_IBT)			+= --ibt
-objtool-args-$(CONFIG_FINEIBT)				+= --cfi
+objtool-args-$(CONFIG_CALL_PADDING)			+= --prefix=$(CONFIG_FUNCTION_PADDING_BYTES)
+ifdef CONFIG_CALL_PADDING
+objtool-args-$(CONFIG_CFI)				+= --cfi
+objtool-args-$(CONFIG_FINEIBT)				+= --fineibt
+endif
 objtool-args-$(CONFIG_FTRACE_MCOUNT_USE_OBJTOOL)	+= --mcount
 ifdef CONFIG_FTRACE_MCOUNT_USE_OBJTOOL
 objtool-args-$(CONFIG_HAVE_OBJTOOL_NOP_MCOUNT)		+= --mnop
@@ -200,7 +204,6 @@ objtool-args-$(CONFIG_STACK_VALIDATION)			+= --stackval
 objtool-args-$(CONFIG_HAVE_STATIC_CALL_INLINE)		+= --static-call
 objtool-args-$(CONFIG_HAVE_UACCESS_VALIDATION)		+= --uaccess
 objtool-args-$(or $(CONFIG_GCOV_KERNEL),$(CONFIG_KCOV))	+= --no-unreachable
-objtool-args-$(CONFIG_PREFIX_SYMBOLS)			+= --prefix=$(CONFIG_FUNCTION_PADDING_BYTES)
 objtool-args-$(CONFIG_OBJTOOL_WERROR)			+= --werror
 
 objtool-args = $(objtool-args-y)					\
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index ec7f10a5ef19..118c3de2f293 100644
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
@@ -92,6 +91,8 @@ static const struct option check_options[] = {
 	OPT_CALLBACK_OPTARG(0,	 "dump", NULL, NULL, "orc", "dump metadata", parse_dump),
 
 	OPT_GROUP("Options:"),
+	OPT_BOOLEAN(0,		 "cfi", &opts.cfi, "grow kCFI preamble symbols (use with --prefix)"),
+	OPT_BOOLEAN(0,		 "fineibt", &opts.fineibt, "create .cfi_sites section for FineIBT"),
 	OPT_BOOLEAN(0,		 "backtrace", &opts.backtrace, "unwind on error"),
 	OPT_BOOLEAN(0,		 "backup", &opts.backup, "create backup (.orig) file on warning/error"),
 	OPT_BOOLEAN(0,		 "dry-run", &opts.dryrun, "don't write modifications"),
@@ -163,6 +164,16 @@ static bool opts_valid(void)
 		return false;
 	}
 
+	if (opts.cfi && !opts.prefix) {
+		ERROR("--cfi requires --prefix");
+		return false;
+	}
+
+	if (opts.fineibt && !opts.cfi) {
+		ERROR("--fineibt requires --cfi");
+		return false;
+	}
+
 	if (opts.disas			||
 	    opts.hack_jump_label	||
 	    opts.hack_noinstr		||
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 410061aeed26..0d9b859b006e 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -881,6 +881,31 @@ static int create_ibt_endbr_seal_sections(struct objtool_file *file)
 	return 0;
 }
 
+/*
+* Grow __cfi_ symbols to fill the NOP gap between the 'mov <hash>, %rax' and
+* the start of the function.
+*/
+static int grow_cfi_symbols(struct objtool_file *file)
+{
+	struct symbol *sym;
+
+	for_each_sym(file->elf, sym) {
+		if (!is_func_sym(sym) || !strstarts(sym->name, "__cfi_") ||
+		    sym->len != 5)
+			continue;
+
+		if (!find_func_by_offset(sym->sec, sym->offset + sym->len + opts.prefix))
+			continue;
+
+		sym->len += opts.prefix;
+		sym->sym.st_size = sym->len;
+		if (elf_write_symbol(file->elf, sym))
+			return -1;
+	}
+
+	return 0;
+}
+
 static int create_cfi_sections(struct objtool_file *file)
 {
 	struct section *sec;
@@ -4903,12 +4928,6 @@ int check(struct objtool_file *file)
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
@@ -4928,9 +4947,21 @@ int check(struct objtool_file *file)
 	}
 
 	if (opts.prefix) {
-		ret = create_prefix_symbols(file);
-		if (ret)
-			goto out;
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
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index d9cee8d5d9e8..33c95a74a51b 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -997,6 +997,26 @@ struct symbol *elf_create_symbol(struct elf *elf, const char *name,
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
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index e452784df702..305183f30a33 100644
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


