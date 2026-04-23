Return-Path: <live-patching+bounces-2462-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mCn4J+ac6Wm3ewIAu9opvQ
	(envelope-from <live-patching+bounces-2462-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:15:34 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E695C44CD6A
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:15:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A9D75301A2F6
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F7F3DBD65;
	Thu, 23 Apr 2026 04:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YQ7kORIx"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40093DBD5A;
	Thu, 23 Apr 2026 04:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917081; cv=none; b=pqHoDT0qFfiFGk2jFkMmtFM50qgSIsfIXPo5t4Wxg420ZMqHhxcT5DI7jPWbESu5opP3k8Bnt4d9HuFyGqjF7NBCVZV1DA60mVdHHnpjuooEPAMfqGLJAgU1Wh58RA2D/DBAe3KNUvYpEUBJHZR7jSAMNJdBi6asIJBIZv/17Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917081; c=relaxed/simple;
	bh=nXjO5KQLtOifVVfeV6Y4aDKneTABOfZLjYSzsIkufG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lB/5Au6f2MYqkv+msDe3+g0g7JlxzZulCpuQ60ocrh4ONSPpkcXv9ZybwZLsKlCTqowsrh7VoTnJS/iiBH5NBm/GpIbG2PhxTylVLNLGKuEKpZ+Ar1LDoEWRZVRUHIY1VoxiR1UTd5Imu2WzOV5kTV+IF3VcDuD/wEk8j1OPcbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YQ7kORIx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080BAC2BCB5;
	Thu, 23 Apr 2026 04:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917081;
	bh=nXjO5KQLtOifVVfeV6Y4aDKneTABOfZLjYSzsIkufG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQ7kORIxhrANejo4a9cmGDtLmNSVm5X0uTBTwkPxFqRlCN+rDT9Qv3hsN0LEk99G5
	 ShULYYqsx5SQPKna+bw0IGPaGLBGosKmgdh1X0TbsyxRqRbMN9ToPwem3/tscHohrR
	 +rcNXwKhput22FoMTrfAhdXTKvWTAPIJT8CeBXNIpShXL0+dPl+99yvucnspmfohBF
	 H9VCck/dFesDnC78IFSYqBGczSEfGgUHMqky3iPVsFjG/BhRkrhmTRG/dEpLmlK6se
	 gsZcKeqHz203CtlzL2Fpb9F1Lq/wsLZlqQTpxOYiN4tdEGEEjlflBQf887py8/hp7P
	 kG6colNIbXyyQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 35/48] objtool/klp: Add "objtool klp checksum" subcommand
Date: Wed, 22 Apr 2026 21:04:03 -0700
Message-ID: <29304d60b4b4949720e3e5a5e6f26196bc29fa07.1776916871.git.jpoimboe@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2462-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E695C44CD6A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Move the checksum functionality out of the main objtool command into a
new "objtool klp checksum" subcommand.

This has the benefit of making the code (and the patch generation
process itself) more modular.

For bisectability, both "objtool --checksum" and "objtool klp checksum"
work for now.  The former will be removed after klp-build has been
converted to use the new subcommand.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/Build                      |   2 +-
 tools/objtool/builtin-klp.c              |   1 +
 tools/objtool/check.c                    | 209 +-----------------
 tools/objtool/include/objtool/check.h    |   6 +
 tools/objtool/include/objtool/checksum.h |   4 +
 tools/objtool/include/objtool/klp.h      |   1 +
 tools/objtool/klp-checksum.c             | 257 +++++++++++++++++++++++
 tools/objtool/klp-diff.c                 |   2 +-
 8 files changed, 273 insertions(+), 209 deletions(-)
 create mode 100644 tools/objtool/klp-checksum.c

diff --git a/tools/objtool/Build b/tools/objtool/Build
index 600da051af12..93a37b0dfd31 100644
--- a/tools/objtool/Build
+++ b/tools/objtool/Build
@@ -12,7 +12,7 @@ objtool-$(BUILD_DISAS) += disas.o
 objtool-$(BUILD_DISAS) += trace.o
 
 objtool-$(BUILD_ORC) += orc_gen.o orc_dump.o
-objtool-$(BUILD_KLP) += builtin-klp.o klp-diff.o klp-post-link.o
+objtool-$(BUILD_KLP) += builtin-klp.o klp-checksum.o klp-diff.o klp-post-link.o
 
 objtool-y += libstring.o
 objtool-y += libctype.o
diff --git a/tools/objtool/builtin-klp.c b/tools/objtool/builtin-klp.c
index 56d5a5b92f72..58c3b9bda3eb 100644
--- a/tools/objtool/builtin-klp.c
+++ b/tools/objtool/builtin-klp.c
@@ -13,6 +13,7 @@ struct subcmd {
 };
 
 static struct subcmd subcmds[] = {
+	{ "checksum",		"Generate per-function checksums",			cmd_klp_checksum, },
 	{ "diff",		"Generate binary diff of two object files",		cmd_klp_diff, },
 	{ "post-link",		"Finalize klp symbols/relocs after module linking",	cmd_klp_post_link, },
 };
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 17cb9265973d..3e5d335d0e29 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -64,8 +64,8 @@ struct instruction *next_insn_same_sec(struct objtool_file *file,
 	return insn;
 }
 
-static struct instruction *next_insn_same_func(struct objtool_file *file,
-					       struct instruction *insn)
+struct instruction *next_insn_same_func(struct objtool_file *file,
+				       struct instruction *insn)
 {
 	struct instruction *next = next_insn_same_sec(file, insn);
 	struct symbol *func = insn_func(insn);
@@ -113,10 +113,6 @@ static struct instruction *prev_insn_same_sym(struct objtool_file *file,
 		for_each_sec(file->elf, __sec)				\
 			sec_for_each_insn(file, __sec, insn)
 
-#define func_for_each_insn(file, func, insn)				\
-	for (insn = find_insn(file, func->sec, func->offset);		\
-	     insn;							\
-	     insn = next_insn_same_func(file, insn))
 
 #define sym_for_each_insn(file, sym, insn)				\
 	for (insn = find_insn(file, sym->sec, sym->offset);		\
@@ -1023,56 +1019,6 @@ static int create_direct_call_sections(struct objtool_file *file)
 	return 0;
 }
 
-#ifdef BUILD_KLP
-static int create_sym_checksum_section(struct objtool_file *file)
-{
-	struct section *sec;
-	struct symbol *sym;
-	unsigned int idx = 0;
-	struct sym_checksum *checksum;
-	size_t entsize = sizeof(struct sym_checksum);
-
-	sec = find_section_by_name(file->elf, ".discard.sym_checksum");
-	if (sec) {
-		if (!opts.dryrun)
-			WARN("file already has .discard.sym_checksum section, skipping");
-
-		return 0;
-	}
-
-	for_each_sym(file->elf, sym)
-		if (sym->csum.checksum)
-			idx++;
-
-	sec = elf_create_section_pair(file->elf, ".discard.sym_checksum", entsize,
-				      idx, idx);
-	if (!sec)
-		return -1;
-
-	idx = 0;
-	for_each_sym(file->elf, sym) {
-		if (!sym->csum.checksum)
-			continue;
-
-		if (!elf_init_reloc(file->elf, sec->rsec, idx, idx * entsize,
-				    sym, 0, R_TEXT64))
-			return -1;
-
-		checksum = (struct sym_checksum *)sec->data->d_buf + idx;
-		checksum->addr = 0; /* reloc */
-		checksum->checksum = sym->csum.checksum;
-
-		mark_sec_changed(file->elf, sec, true);
-
-		idx++;
-	}
-
-	return 0;
-}
-#else
-static int create_sym_checksum_section(struct objtool_file *file) { return -EINVAL; }
-#endif
-
 /*
  * Warnings shouldn't be reported for ignored functions.
  */
@@ -3672,157 +3618,6 @@ static bool skip_alt_group(struct instruction *insn)
 	return alt_insn->type == INSN_CLAC || alt_insn->type == INSN_STAC;
 }
 
-#ifdef BUILD_KLP
-static void enable_debug_checksum_cb(struct symbol *sym, void *d)
-{
-	bool *found = d;
-
-	if (!is_func_sym(sym))
-		return;
-
-	sym->debug_checksum = 1;
-	*found = true;
-}
-
-static int checksum_debug_init(struct objtool_file *file)
-{
-	char *dup, *s;
-
-	if (!opts.debug_checksum)
-		return 0;
-
-	dup = strdup(opts.debug_checksum);
-	if (!dup) {
-		ERROR_GLIBC("strdup");
-		return -1;
-	}
-
-	s = dup;
-	while (*s) {
-		bool found = false;
-		char *comma;
-
-		comma = strchr(s, ',');
-		if (comma)
-			*comma = '\0';
-
-		iterate_sym_by_name(file->elf, s, enable_debug_checksum_cb, &found);
-		if (!found)
-			WARN("--debug-checksum: can't find '%s'", s);
-
-		if (!comma)
-			break;
-
-		s = comma + 1;
-	}
-
-	free(dup);
-	return 0;
-}
-
-static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
-				 struct instruction *insn)
-{
-	struct reloc *reloc = insn_reloc(file, insn);
-	struct alternative *alt;
-	unsigned long offset;
-	struct symbol *sym;
-	static bool in_alt;
-
-	if (insn->fake)
-		return;
-
-	checksum_update(func, insn, insn->sec->data->d_buf + insn->offset, insn->len);
-
-	if (!reloc) {
-		struct symbol *call_dest = insn_call_dest(insn);
-
-		if (call_dest)
-			checksum_update(func, insn, call_dest->demangled_name,
-					strlen(call_dest->demangled_name));
-		goto alts;
-	}
-
-	sym = reloc->sym;
-	offset = arch_insn_adjusted_addend(insn, reloc);
-
-	if (is_string_sec(sym->sec)) {
-		char *str;
-
-		str = sym->sec->data->d_buf + sym->offset + offset;
-		checksum_update(func, insn, str, strlen(str));
-		goto alts;
-	}
-
-	if (is_sec_sym(sym)) {
-		sym = find_symbol_containing(reloc->sym->sec, offset);
-		if (!sym)
-			goto alts;
-
-		offset -= sym->offset;
-	}
-
-	checksum_update(func, insn, sym->demangled_name, strlen(sym->demangled_name));
-	checksum_update(func, insn, &offset, sizeof(offset));
-
-alts:
-	for (alt = insn->alts; alt; alt = alt->next) {
-		struct alt_group *alt_group = alt->insn->alt_group;
-
-		/* Prevent __ex_table recursion, e.g. LOAD_SEGMENT() */
-		if (in_alt)
-			break;
-		in_alt = true;
-
-		checksum_update(func, insn, &alt->type, sizeof(alt->type));
-
-		if (alt_group && alt_group->orig_group) {
-			struct instruction *alt_insn;
-
-			checksum_update(func, insn, &alt_group->feature, sizeof(alt_group->feature));
-
-			for (alt_insn = alt->insn; alt_insn; alt_insn = next_insn_same_sec(file, alt_insn)) {
-				checksum_update_insn(file, func, alt_insn);
-				if (!alt_group->last_insn || alt_insn == alt_group->last_insn)
-					break;
-			}
-		} else {
-			checksum_update_insn(file, func, alt->insn);
-		}
-
-		in_alt = false;
-	}
-}
-
-static int calculate_checksums(struct objtool_file *file)
-{
-	struct instruction *insn;
-	struct symbol *func;
-
-	if (checksum_debug_init(file))
-		return -1;
-
-	for_each_sym(file->elf, func) {
-		/*
-		 * Skip cold subfunctions and aliases: they share the
-		 * parent's checksum via func_for_each_insn() which
-		 * follows func->cfunc into the cold subfunction.
-		 */
-		if (!is_func_sym(func) || is_cold_func(func) ||
-		    is_alias_sym(func) || !func->len)
-			continue;
-
-		checksum_init(func);
-
-		func_for_each_insn(file, func, insn)
-			checksum_update_insn(file, func, insn);
-
-		checksum_finish(func);
-	}
-	return 0;
-}
-#endif /* BUILD_KLP */
-
 static int validate_branch(struct objtool_file *file, struct symbol *func,
 			   struct instruction *insn, struct insn_state state);
 static int do_validate_branch(struct objtool_file *file, struct symbol *func,
diff --git a/tools/objtool/include/objtool/check.h b/tools/objtool/include/objtool/check.h
index 6489e52ea2f2..eea64728d39b 100644
--- a/tools/objtool/include/objtool/check.h
+++ b/tools/objtool/include/objtool/check.h
@@ -144,6 +144,12 @@ struct instruction *find_insn(struct objtool_file *file,
 			      struct section *sec, unsigned long offset);
 
 struct instruction *next_insn_same_sec(struct objtool_file *file, struct instruction *insn);
+struct instruction *next_insn_same_func(struct objtool_file *file, struct instruction *insn);
+
+#define func_for_each_insn(file, func, insn)				\
+	for (insn = find_insn(file, func->sec, func->offset);		\
+	     insn;							\
+	     insn = next_insn_same_func(file, insn))
 
 #define sec_for_each_insn(file, _sec, insn)				\
 	for (insn = find_insn(file, _sec, 0);				\
diff --git a/tools/objtool/include/objtool/checksum.h b/tools/objtool/include/objtool/checksum.h
index 3f25df90305d..be4eb7dfe6f2 100644
--- a/tools/objtool/include/objtool/checksum.h
+++ b/tools/objtool/include/objtool/checksum.h
@@ -31,9 +31,13 @@ static inline void checksum_finish(struct symbol *func)
 	}
 }
 
+int calculate_checksums(struct objtool_file *file);
+int create_sym_checksum_section(struct objtool_file *file);
+
 #else /* !BUILD_KLP */
 
 static inline int calculate_checksums(struct objtool_file *file) { return -ENOSYS; }
+static inline int create_sym_checksum_section(struct objtool_file *file) { return -EINVAL; }
 
 #endif /* !BUILD_KLP */
 
diff --git a/tools/objtool/include/objtool/klp.h b/tools/objtool/include/objtool/klp.h
index e32e5e8bc631..6f60cf05db86 100644
--- a/tools/objtool/include/objtool/klp.h
+++ b/tools/objtool/include/objtool/klp.h
@@ -29,6 +29,7 @@ struct klp_reloc {
 	u32 type;
 };
 
+int cmd_klp_checksum(int argc, const char **argv);
 int cmd_klp_diff(int argc, const char **argv);
 int cmd_klp_post_link(int argc, const char **argv);
 
diff --git a/tools/objtool/klp-checksum.c b/tools/objtool/klp-checksum.c
new file mode 100644
index 000000000000..4edd29028bff
--- /dev/null
+++ b/tools/objtool/klp-checksum.c
@@ -0,0 +1,257 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <string.h>
+#include <subcmd/parse-options.h>
+
+#include <objtool/arch.h>
+#include <objtool/builtin.h>
+#include <objtool/check.h>
+#include <objtool/elf.h>
+#include <objtool/klp.h>
+#include <objtool/objtool.h>
+#include <objtool/warn.h>
+#include <objtool/checksum.h>
+
+static void enable_debug_checksum_cb(struct symbol *sym, void *d)
+{
+	bool *found = d;
+
+	if (!is_func_sym(sym))
+		return;
+
+	sym->debug_checksum = 1;
+	*found = true;
+}
+
+static int checksum_debug_init(struct objtool_file *file)
+{
+	char *dup, *s;
+
+	if (!opts.debug_checksum)
+		return 0;
+
+	dup = strdup(opts.debug_checksum);
+	if (!dup) {
+		ERROR_GLIBC("strdup");
+		return -1;
+	}
+
+	s = dup;
+	while (*s) {
+		bool found = false;
+		char *comma;
+
+		comma = strchr(s, ',');
+		if (comma)
+			*comma = '\0';
+
+		iterate_sym_by_name(file->elf, s, enable_debug_checksum_cb, &found);
+		if (!found)
+			WARN("--debug-checksum: can't find '%s'", s);
+
+		if (!comma)
+			break;
+
+		s = comma + 1;
+	}
+
+	free(dup);
+	return 0;
+}
+
+static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
+				 struct instruction *insn)
+{
+	struct reloc *reloc = insn_reloc(file, insn);
+	struct alternative *alt;
+	unsigned long offset;
+	struct symbol *sym;
+	static bool in_alt;
+
+	if (insn->fake)
+		return;
+
+	checksum_update(func, insn, insn->sec->data->d_buf + insn->offset, insn->len);
+
+	if (!reloc) {
+		struct symbol *call_dest = insn_call_dest(insn);
+
+		if (call_dest)
+			checksum_update(func, insn, call_dest->demangled_name,
+					strlen(call_dest->demangled_name));
+		goto alts;
+	}
+
+	sym = reloc->sym;
+	offset = arch_insn_adjusted_addend(insn, reloc);
+
+	if (is_string_sec(sym->sec)) {
+		char *str;
+
+		str = sym->sec->data->d_buf + sym->offset + offset;
+		checksum_update(func, insn, str, strlen(str));
+		goto alts;
+	}
+
+	if (is_sec_sym(sym)) {
+		sym = find_symbol_containing(reloc->sym->sec, offset);
+		if (!sym)
+			goto alts;
+
+		offset -= sym->offset;
+	}
+
+	checksum_update(func, insn, sym->demangled_name, strlen(sym->demangled_name));
+	checksum_update(func, insn, &offset, sizeof(offset));
+
+alts:
+	for (alt = insn->alts; alt; alt = alt->next) {
+		struct alt_group *alt_group = alt->insn->alt_group;
+
+		/* Prevent __ex_table recursion, e.g. LOAD_SEGMENT() */
+		if (in_alt)
+			break;
+		in_alt = true;
+
+		checksum_update(func, insn, &alt->type, sizeof(alt->type));
+
+		if (alt_group && alt_group->orig_group) {
+			struct instruction *alt_insn;
+
+			checksum_update(func, insn, &alt_group->feature, sizeof(alt_group->feature));
+
+			for (alt_insn = alt->insn; alt_insn; alt_insn = next_insn_same_sec(file, alt_insn)) {
+				checksum_update_insn(file, func, alt_insn);
+				if (!alt_group->last_insn || alt_insn == alt_group->last_insn)
+					break;
+			}
+		} else {
+			checksum_update_insn(file, func, alt->insn);
+		}
+
+		in_alt = false;
+	}
+}
+
+int calculate_checksums(struct objtool_file *file)
+{
+	struct instruction *insn;
+	struct symbol *func;
+
+	if (checksum_debug_init(file))
+		return -1;
+
+	for_each_sym(file->elf, func) {
+		/*
+		 * Skip cold subfunctions and aliases: they share the
+		 * parent's checksum via func_for_each_insn() which
+		 * follows func->cfunc into the cold subfunction.
+		 */
+		if (!is_func_sym(func) || is_cold_func(func) ||
+		    is_alias_sym(func) || !func->len)
+			continue;
+
+		checksum_init(func);
+
+		func_for_each_insn(file, func, insn)
+			checksum_update_insn(file, func, insn);
+
+		checksum_finish(func);
+	}
+	return 0;
+}
+
+int create_sym_checksum_section(struct objtool_file *file)
+{
+	struct section *sec;
+	struct symbol *sym;
+	unsigned int idx = 0;
+	struct sym_checksum *checksum;
+	size_t entsize = sizeof(struct sym_checksum);
+
+	sec = find_section_by_name(file->elf, ".discard.sym_checksum");
+	if (sec) {
+		if (!opts.dryrun)
+			WARN("file already has .discard.sym_checksum section, skipping");
+
+		return 0;
+	}
+
+	for_each_sym(file->elf, sym)
+		if (sym->csum.checksum)
+			idx++;
+
+	sec = elf_create_section_pair(file->elf, ".discard.sym_checksum", entsize,
+				      idx, idx);
+	if (!sec)
+		return -1;
+
+	idx = 0;
+	for_each_sym(file->elf, sym) {
+		if (!sym->csum.checksum)
+			continue;
+
+		if (!elf_init_reloc(file->elf, sec->rsec, idx, idx * entsize,
+				    sym, 0, R_TEXT64))
+			return -1;
+
+		checksum = (struct sym_checksum *)sec->data->d_buf + idx;
+		checksum->addr = 0; /* reloc */
+		checksum->checksum = sym->csum.checksum;
+
+		mark_sec_changed(file->elf, sec, true);
+
+		idx++;
+	}
+
+	return 0;
+}
+
+static const char * const klp_checksum_usage[] = {
+	"objtool klp checksum [<options>] file.o",
+	NULL,
+};
+
+int cmd_klp_checksum(int argc, const char **argv)
+{
+	struct objtool_file *file;
+	int ret;
+
+	const struct option options[] = {
+		OPT_STRING(0,	"debug-checksum", &opts.debug_checksum,	"funcs", "enable checksum debug output"),
+		OPT_BOOLEAN(0,	"dry-run", &opts.dryrun, "don't write modifications"),
+		OPT_END(),
+	};
+
+	argc = parse_options(argc, argv, options, klp_checksum_usage, 0);
+	if (argc != 1)
+		usage_with_options(klp_checksum_usage, options);
+
+	opts.checksum = true;
+
+	objname = argv[0];
+
+	file = objtool_open_read(objname);
+	if (!file)
+		return 1;
+
+	ret = decode_file(file);
+	if (ret)
+		goto out;
+
+	ret = calculate_checksums(file);
+	if (ret)
+		goto out;
+
+	ret = create_sym_checksum_section(file);
+
+out:
+	free_insns(file);
+
+	if (ret)
+		return ret;
+
+	if (!opts.dryrun && file->elf->changed && elf_write(file->elf))
+		return 1;
+
+	return elf_close(file->elf);
+}
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 266f0d2ba4fe..c903aa65d4b6 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -171,7 +171,7 @@ static int read_sym_checksums(struct elf *elf)
 
 	sec = find_section_by_name(elf, ".discard.sym_checksum");
 	if (!sec) {
-		ERROR("'%s' missing .discard.sym_checksum section, file not processed by 'objtool --checksum'?",
+		ERROR("'%s' missing .discard.sym_checksum section, file not processed by 'objtool klp checksum'?",
 		      elf->name);
 		return -1;
 	}
-- 
2.53.0


