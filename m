Return-Path: <live-patching+bounces-2663-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kNEQJB0q9GlT+wEAu9opvQ
	(envelope-from <live-patching+bounces-2663-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:20:45 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E3EC04AA423
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:20:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6C2FD305616C
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CD36374E71;
	Fri,  1 May 2026 04:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EGiVhj3d"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2F9369236;
	Fri,  1 May 2026 04:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608553; cv=none; b=M9D8+3PGj+lrOLgzg9rLy+XKQbqHm6OpeRzlp10RDcNcUoqcFi8W8sVY8gSo1O1RYhjbMUqV9QmBpWfgz093p5yTlApgIY+iCpCr+6UmaxpO1ufnY+NiMGiKnirOiZT0V443PSrf1wK/fWGUCfRLgLl6Lr328VnIZYPQFw6KAS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608553; c=relaxed/simple;
	bh=lo6GpX+iMG++Wc5TUiO8JZExXrF1M4ogiT6wLx59wQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaC1skYh7TqrJMulGPdsweRursqWIh+Qx2obXgsky6yJJC0RXzQQ7lN31ixLImOoVw5GHUQEkUH9fitDVKEA4KQufRBGW1G6sX/MPRd9jaEzuUj5OIpsX5i4GQDe8dxMncxAPT1oLt6oXlKrNBM2lFWbqvzTPCyXYUkhKN1mGKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EGiVhj3d; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB7EC2BCB9;
	Fri,  1 May 2026 04:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608552;
	bh=lo6GpX+iMG++Wc5TUiO8JZExXrF1M4ogiT6wLx59wQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGiVhj3de0xs4C0owfrNxXgvbMZa7GdTt8zaxYAo0Lm3Hbu+4aU2LBPKzsHTWadi7
	 O+509MvTvAtVxKCAO9YNrVI3LKZKnnSuB2A+U2cI0uq65yP8j18uhtkfk/ji4mQxh6
	 gPp+hNXfgn3LOZcJauIdf6ZDeqNfokYxQK77V9pIHMMA/K7BNcc8mb1fT9TC2dGUYN
	 pvqKjurIp0GSFzAw0YhkGt595YE6sWrSC/9Mxoc8su/XAhEnEGaqPtumk/ZrZoGEX3
	 FUV005dP3zIeOP7ICb9+vTfDCNwL+eTHHh8PdjKojUe6af3GH0BxMxwjyrN87RucTC
	 ZlwiepMIWmkFQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 47/53] objtool/klp: Add correlation debugging output
Date: Thu, 30 Apr 2026 21:08:35 -0700
Message-ID: <492432266706503947483b831a17a1c118dc5007.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: E3EC04AA423
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
	TAGGED_FROM(0.00)[bounces-2663-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

Add debugging messages to show how duplicate symbols get correlated, and
split the --debug feature into --debug-correlate and --debug-clone.

Acked-by: Song Liu <song@kernel.org>
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
index a9c993298b82..ed3bf1c55001 100644
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
 
@@ -583,6 +588,14 @@ static struct symbol *find_twin(struct elfs *e, struct symbol *sym1)
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
 
@@ -686,10 +699,14 @@ static struct symbol *find_twin_suffixed(struct elf *elf, struct symbol *sym1)
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
@@ -742,6 +759,10 @@ static struct symbol *find_twin_positional(struct elfs *e, struct symbol *sym1)
 	if (idx_orig != idx_patched)
 		return NULL;
 
+	dbg_correlate("find_twin_positional(): %s%s -> %s%s",
+	    sym1->name, is_func_sym(sym1) ? "()" : "",
+	    match->name, is_func_sym(match) ? "()" : "");
+
 	return match;
 }
 
@@ -998,7 +1019,7 @@ static struct symbol *clone_symbol(struct elfs *e, struct symbol *patched_sym,
 	if (patched_sym->clone)
 		return patched_sym->clone;
 
-	dbg_indent("%s%s", patched_sym->name, data_too ? " [+DATA]" : "");
+	dbg_clone("%s%s", patched_sym->name, data_too ? " [+DATA]" : "");
 
 	/* Make sure the prefix gets cloned first */
 	if (is_func_sym(patched_sym) && data_too) {
@@ -1375,7 +1396,7 @@ static int clone_reloc_klp(struct elfs *e, struct reloc *patched_reloc,
 
 	klp_sym = find_symbol_by_name(e->out, sym_name);
 	if (!klp_sym) {
-		__dbg_indent("%s", sym_name);
+		__dbg_clone("%s", sym_name);
 
 		/* STB_WEAK: avoid modpost undefined symbol warnings */
 		klp_sym = elf_create_symbol(e->out, sym_name, NULL,
@@ -1426,7 +1447,7 @@ static int clone_reloc_klp(struct elfs *e, struct reloc *patched_reloc,
 }
 
 #define dbg_clone_reloc(sec, offset, patched_sym, addend, export, klp)			\
-	dbg_indent("%s+0x%lx: %s%s0x%lx [%s%s%s%s%s%s]",				\
+	dbg_clone("%s+0x%lx: %s%s0x%lx [%s%s%s%s%s%s]",					\
 		   sec->name, offset, patched_sym->name,				\
 		   addend >= 0 ? "+" : "-", labs(addend),				\
 		   sym_type(patched_sym),						\
@@ -1481,7 +1502,7 @@ static int clone_reloc(struct elfs *e, struct reloc *patched_reloc,
 	if (is_string_sec(patched_sym->sec)) {
 		const char *str = patched_sym->sec->data->d_buf + addend;
 
-		__dbg_indent("\"%s\"", escape_str(str));
+		__dbg_clone("\"%s\"", escape_str(str));
 
 		addend = elf_add_string(e->out, out_sym->sec, str);
 		if (addend == -1)
@@ -2121,6 +2142,11 @@ int cmd_klp_diff(int argc, const char **argv)
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


