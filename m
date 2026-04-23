Return-Path: <live-patching+bounces-2469-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2NmoGHCc6Wm3ewIAu9opvQ
	(envelope-from <live-patching+bounces-2469-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:13:36 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 012A444CCCC
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:13:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B469130022DD
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:08:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 590743DDDC9;
	Thu, 23 Apr 2026 04:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kvRe+Iz9"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3B33DD514;
	Thu, 23 Apr 2026 04:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917086; cv=none; b=EFgMU8Obci7pq3+MmuuyvUM9mudQ0cEqf9nA9PrMBqEXxtm96Zg6SJGN4Gp39E/BjI+U2cTK/NJK79iKcUr74RsuxfHQd5nqQoPzMCoBm7eHR3ig2n8yXk8ixRJCHCF4W7M8Plk6LLBKglYb+qRB2DUs9a7pr4Ltz9fl9FAZRZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917086; c=relaxed/simple;
	bh=7M7eH1eisSgyr1bdBueJqCoMzPzFDdbSQZ9d31WFrcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTxq/eqHzHaTPQv6cP3GWMr0NxNt27DvPGu2hyDidVY/16usVvsomAyoQaGI3aZhB2vOvdzKhP/w/EQwlVi9AOxKdYK3BZ64XrlkxSjW8mhGWWmVbozBoMHR6nCUJXKJlJyZWx3x03Nu0U1jrGxNYt05T8RaoScx9DwhXsluB3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kvRe+Iz9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7BFC2BCB6;
	Thu, 23 Apr 2026 04:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917086;
	bh=7M7eH1eisSgyr1bdBueJqCoMzPzFDdbSQZ9d31WFrcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kvRe+Iz9Lj0dZn6eucl1aO9jT7WYsMSt8UxH+Ra9bwTzUzHQX30biVETvxZcM13yq
	 GTZvhYsqENeQnlIfuYIYNzHWj4lQnU8Eegwa+IrabDcd2OvcLNiAao+6HupS4K8OoA
	 eZhdLuLVOYuINoSChDOF3Xs1kePBzDSe36ofDuo0cFKquzPC4BVQ0A6Jto00YWqkGr
	 vnUa6MQgHli1HYMFLPIXsEm7q4ZYrE06GaO4WlO7KvlM5FGC7AlqsNyxjMfzUSrM1r
	 3/yHCm2QpCD+Amd7MfVSE+zz2TJhquW1wVM5rBwR70CdzeG0ixEBMsu/A3Ce0r1bA4
	 /WXVaxczQgkAg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 42/48] objtool/klp: Add correlation debugging output
Date: Wed, 22 Apr 2026 21:04:10 -0700
Message-ID: <44757e0c259e4651275e24b49dc9f7220ecfe16b.1776916871.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2469-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 012A444CCCC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add debugging messages to show how duplicate symbols get correlated, and
split the --debug feature into --debug-correlate and --debug-clone.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/include/objtool/warn.h | 16 +++++++----
 tools/objtool/klp-diff.c             | 42 ++++++++++++++++++++++------
 tools/objtool/objtool.c              |  3 --
 3 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/tools/objtool/include/objtool/warn.h b/tools/objtool/include/objtool/warn.h
index 595ee8009667..a9936d60980c 100644
--- a/tools/objtool/include/objtool/warn.h
+++ b/tools/objtool/include/objtool/warn.h
@@ -109,7 +109,7 @@ static inline char *offstr(struct section *sec, unsigned long offset)
 #define ERROR_FUNC(sec, offset, format, ...) __WARN_FUNC(ERROR_STR, sec, offset, format, ##__VA_ARGS__)
 #define ERROR_INSN(insn, format, ...) ERROR_FUNC(insn->sec, insn->offset, format, ##__VA_ARGS__)
 
-extern bool debug;
+extern bool debug, debug_correlate, debug_clone;
 extern int indent;
 
 static inline void unindent(int *unused) { indent--; }
@@ -148,15 +148,21 @@ static inline void unindent(int *unused) { indent--; }
 		      (unsigned long long)checksum);			\
 })
 
-#define __dbg_indent(format, ...)					\
+#define dbg_correlate(args...)						\
 ({									\
-	if (unlikely(debug))						\
+	if (unlikely(debug_correlate))					\
+		__dbg(args);						\
+})
+
+#define __dbg_clone(format, ...)					\
+({									\
+	if (unlikely(debug_clone))					\
 		__dbg("%*s" format, indent * 8, "", ##__VA_ARGS__);	\
 })
 
-#define dbg_indent(args...)						\
+#define dbg_clone(args...)						\
 	int __cleanup(unindent) __dummy_##__COUNTER__;			\
-	__dbg_indent(args);						\
+	__dbg_clone(args);						\
 	indent++
 
 #endif /* _WARN_H */
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 6d7fbb16e59c..acb76aefd04f 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -33,6 +33,9 @@ struct export {
 	char *mod, *sym;
 };
 
+bool debug, debug_correlate, debug_clone;
+int indent;
+
 static const char * const klp_diff_usage[] = {
 	"objtool klp diff [<options>] <in1.o> <in2.o> <out.o>",
 	NULL,
@@ -40,7 +43,9 @@ static const char * const klp_diff_usage[] = {
 
 static const struct option klp_diff_options[] = {
 	OPT_GROUP("Options:"),
-	OPT_BOOLEAN('d', "debug", &debug, "enable debug output"),
+	OPT_BOOLEAN('d', "debug", &debug, "enable all debug output"),
+	OPT_BOOLEAN(0, "debug-correlate", &debug_correlate, "enable correlation debug output"),
+	OPT_BOOLEAN(0, "debug-clone", &debug_clone, "enable cloning debug output"),
 	OPT_END(),
 };
 
@@ -543,6 +548,14 @@ static struct symbol *find_twin(struct elfs *e, struct symbol *sym1)
 	else if (csum_orig == 1 && csum_patched == 1)
 		match = csum_last;
 
+	if (!match)
+		return NULL;
+
+	if (name_orig != 1 || name_patched != 1)
+		dbg_correlate("find_twin(): %s%s -> %s%s",
+			      sym1->name, is_func_sym(sym1) ? "()" : "",
+			      match->name, is_func_sym(match) ? "()" : "");
+
 	return match;
 }
 
@@ -638,10 +651,14 @@ static struct symbol *find_twin_suffixed(struct elf *elf, struct symbol *sym1)
 		match = sym2;
 	}
 
-	if (count == 1)
-		return match;
+	if (count != 1)
+		return NULL;
 
-	return NULL;
+	dbg_correlate("find_suffixed_twin(): %s%s -> %s%s",
+		      sym1->name, is_func_sym(sym1) ? "()" : "",
+		      match->name, is_func_sym(match) ? "()" : "");
+
+	return match;
 }
 
 /*
@@ -688,6 +705,10 @@ static struct symbol *find_twin_positional(struct elfs *e, struct symbol *sym1)
 	if (idx_orig != idx_patched)
 		return NULL;
 
+	dbg_correlate("find_twin_positional(): %s%s -> %s%s",
+	    sym1->name, is_func_sym(sym1) ? "()" : "",
+	    match->name, is_func_sym(match) ? "()" : "");
+
 	return match;
 }
 
@@ -944,7 +965,7 @@ static struct symbol *clone_symbol(struct elfs *e, struct symbol *patched_sym,
 	if (patched_sym->clone)
 		return patched_sym->clone;
 
-	dbg_indent("%s%s", patched_sym->name, data_too ? " [+DATA]" : "");
+	dbg_clone("%s%s", patched_sym->name, data_too ? " [+DATA]" : "");
 
 	/* Make sure the prefix gets cloned first */
 	if (is_func_sym(patched_sym) && data_too) {
@@ -1324,7 +1345,7 @@ static int clone_reloc_klp(struct elfs *e, struct reloc *patched_reloc,
 
 	klp_sym = find_symbol_by_name(e->out, sym_name);
 	if (!klp_sym) {
-		__dbg_indent("%s", sym_name);
+		__dbg_clone("%s", sym_name);
 
 		/* STB_WEAK: avoid modpost undefined symbol warnings */
 		klp_sym = elf_create_symbol(e->out, sym_name, NULL,
@@ -1375,7 +1396,7 @@ static int clone_reloc_klp(struct elfs *e, struct reloc *patched_reloc,
 }
 
 #define dbg_clone_reloc(sec, offset, patched_sym, addend, export, klp)			\
-	dbg_indent("%s+0x%lx: %s%s0x%lx [%s%s%s%s%s%s]",				\
+	dbg_clone("%s+0x%lx: %s%s0x%lx [%s%s%s%s%s%s]",				\
 		   sec->name, offset, patched_sym->name,				\
 		   addend >= 0 ? "+" : "-", labs(addend),				\
 		   sym_type(patched_sym),						\
@@ -1437,7 +1458,7 @@ static int clone_reloc(struct elfs *e, struct reloc *patched_reloc,
 	if (is_string_sec(patched_sym->sec)) {
 		const char *str = patched_sym->sec->data->d_buf + addend;
 
-		__dbg_indent("\"%s\"", escape_str(str));
+		__dbg_clone("\"%s\"", escape_str(str));
 
 		addend = elf_add_string(e->out, out_sym->sec, str);
 		if (addend == -1)
@@ -2077,6 +2098,11 @@ int cmd_klp_diff(int argc, const char **argv)
 	if (argc != 3)
 		usage_with_options(klp_diff_usage, klp_diff_options);
 
+	if (debug) {
+		debug_correlate = true;
+		debug_clone = true;
+	}
+
 	objname = argv[0];
 
 	e.orig = elf_open_read(argv[0], O_RDONLY);
diff --git a/tools/objtool/objtool.c b/tools/objtool/objtool.c
index 1c3622117c33..a4e139dee7e9 100644
--- a/tools/objtool/objtool.c
+++ b/tools/objtool/objtool.c
@@ -16,9 +16,6 @@
 #include <objtool/objtool.h>
 #include <objtool/warn.h>
 
-bool debug;
-int indent;
-
 static struct objtool_file file;
 
 struct objtool_file *objtool_open_read(const char *filename)
-- 
2.53.0


