Return-Path: <live-patching+bounces-2656-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WN7COCAp9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2656-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:16:32 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 988C64AA2E5
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:16:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A09783064355
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C63B336A01A;
	Fri,  1 May 2026 04:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOKQivFY"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DCD369236;
	Fri,  1 May 2026 04:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608548; cv=none; b=opWK8FxkLuMISMGPo/vcUC1+WPN3010ZpA+LLbnNk1cSrbXUt//UDdRaJtfrgVTJqCv4S8Til49UROGJVfatp0U3H9YGZLU+diexoPW3ZtoTODje0ie8WvXDyD5myS7YOs31dmlNSkjlix6UAW2NpXnUXFQHA2kidotirFRqc+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608548; c=relaxed/simple;
	bh=x+o7MttE8HaIrZqO53iTQAE6hE+z2eW5kHbKMjGZdRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PU3hSVpWR8xeVmAIccdkoYDEO57AYGPcLL8wmpILn1K/i4LLApGVwJgdj/3chRh/+vi4jkN8faR3fzixR/5/LWYxjDsc9KfpH9Q4VdMoqubx7aJcWzi39ewiDDIyS6HcXNJRj/UcplPlfvWJSzKRmLqt6+DWWhhpZK9RqG+vD/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KOKQivFY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E211C2BCF4;
	Fri,  1 May 2026 04:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608548;
	bh=x+o7MttE8HaIrZqO53iTQAE6hE+z2eW5kHbKMjGZdRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KOKQivFYgaP8IShYRAbdczxLswCtBIr6d1BZhwSdP8jrRmiNEnxVzvORttcigUgR6
	 +zAzanQSTm8vLJDOEtXzp2lgMAtPGPLoGSdTftwRHGHx+L8Rd+h1ANRZkq7Ru797AT
	 25uZmFqPsU2D2O5qGbopG4ZMQAg4lk+4v9qs0nJpthKkchQP3skdyZ+8n7wo3tUseC
	 TWRgtGt7mPQ7V1nS8bXUBeEZnFq0Q+/J1Vt045rZgG+xEFChBdoee/+lAam/Oj54ed
	 xD9L/6/pUdk8UmJYimiQAN//CW29mDHu2L7ll7Vz8cqTdVUvUtZVgDYTA3eynFMKcu
	 Vao3skvZUy7lQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 39/53] objtool/klp: Extricate checksum calculation from validate_branch()
Date: Thu, 30 Apr 2026 21:08:27 -0700
Message-ID: <a455b47ef57dcc3506cd97e3c2027ac744941cf1.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: 988C64AA2E5
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2656-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

In preparation for porting the checksum code to other arches, make its
functionality independent from the CFG reverse engineering code.

Move it into a standalone calculate_checksums() function which iterates
all functions and instructions directly, rather than being called inline
from do_validate_branch().

Since checksum_update_insn() is no longer called during CFG traversal,
it needs to manually iterate the alternatives.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c                    | 106 +++++++++++++++++------
 tools/objtool/include/objtool/checksum.h |   6 +-
 2 files changed, 80 insertions(+), 32 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 93a054adf209..f019e1f06780 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1350,10 +1350,7 @@ static struct reloc *insn_reloc(struct objtool_file *file, struct instruction *i
 {
 	struct reloc *reloc;
 
-	if (insn->no_reloc)
-		return NULL;
-
-	if (!file)
+	if (!file || insn->no_reloc || insn->fake)
 		return NULL;
 
 	reloc = find_reloc_by_dest_range(file->elf, insn->sec,
@@ -2622,9 +2619,17 @@ static void mark_holes(struct objtool_file *file)
 
 static bool validate_branch_enabled(void)
 {
-	return opts.stackval ||
-	       opts.orc ||
-	       opts.uaccess ||
+	return opts.stackval	||
+	       opts.orc		||
+	       opts.uaccess;
+}
+
+static bool alts_needed(void)
+{
+	return validate_branch_enabled()	||
+	       opts.noinstr			||
+	       opts.hack_jump_label		||
+	       opts.disas			||
 	       opts.checksum;
 }
 
@@ -2658,7 +2663,7 @@ static int decode_sections(struct objtool_file *file)
 	 * Must be before add_jump_destinations(), which depends on 'func'
 	 * being set for alternatives, to enable proper sibling call detection.
 	 */
-	if (validate_branch_enabled() || opts.noinstr || opts.hack_jump_label || opts.disas) {
+	if (alts_needed()) {
 		if (add_special_section_alts(file))
 			return -1;
 	}
@@ -3654,6 +3659,7 @@ static bool skip_alt_group(struct instruction *insn)
 	return alt_insn->type == INSN_CLAC || alt_insn->type == INSN_STAC;
 }
 
+#ifdef BUILD_KLP
 static int checksum_debug_init(struct objtool_file *file)
 {
 	char *dup, *s;
@@ -3701,8 +3707,10 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
 				 struct instruction *insn)
 {
 	struct reloc *reloc = insn_reloc(file, insn);
+	struct alternative *alt;
 	unsigned long offset;
 	struct symbol *sym;
+	static bool in_alt;
 
 	if (insn->fake)
 		return;
@@ -3715,7 +3723,7 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
 		if (call_dest)
 			checksum_update(func, insn, call_dest->demangled_name,
 					strlen(call_dest->demangled_name));
-		return;
+		goto alts;
 	}
 
 	sym = reloc->sym;
@@ -3726,21 +3734,78 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
 
 		str = sym->sec->data->d_buf + sym->offset + offset;
 		checksum_update(func, insn, str, strlen(str));
-		return;
+		goto alts;
 	}
 
 	if (is_sec_sym(sym)) {
 		sym = find_symbol_containing(reloc->sym->sec, offset);
 		if (!sym)
-			return;
+			goto alts;
 
 		offset -= sym->offset;
 	}
 
 	checksum_update(func, insn, sym->demangled_name, strlen(sym->demangled_name));
 	checksum_update(func, insn, &offset, sizeof(offset));
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
 }
 
+static int calculate_checksums(struct objtool_file *file)
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
+#endif /* BUILD_KLP */
+
 static int validate_branch(struct objtool_file *file, struct symbol *func,
 			   struct instruction *insn, struct insn_state state);
 static int do_validate_branch(struct objtool_file *file, struct symbol *func,
@@ -4022,9 +4087,6 @@ static int do_validate_branch(struct objtool_file *file, struct symbol *func,
 		insn->trace = 0;
 		next_insn = next_insn_to_validate(file, insn);
 
-		if (opts.checksum && func && insn->sec)
-			checksum_update_insn(file, func, insn);
-
 		if (func && insn_func(insn) && func != insn_func(insn)->pfunc) {
 			/* Ignore KCFI type preambles, which always fall through */
 			if (is_prefix_func(func))
@@ -4090,9 +4152,6 @@ static int validate_unwind_hint(struct objtool_file *file,
 		struct symbol *func = insn_func(insn);
 		int ret;
 
-		if (opts.checksum)
-			checksum_init(func);
-
 		ret = validate_branch(file, func, insn, *state);
 		if (ret)
 			BT_INSN(insn, "<=== (hint)");
@@ -4535,9 +4594,6 @@ static int validate_symbol(struct objtool_file *file, struct section *sec,
 
 	func = insn_func(insn);
 
-	if (opts.checksum)
-		checksum_init(func);
-
 	if (opts.trace && !fnmatch(opts.trace, sym->name, 0)) {
 		trace_enable();
 		TRACE("%s: validation begin\n", sym->name);
@@ -4550,9 +4606,6 @@ static int validate_symbol(struct objtool_file *file, struct section *sec,
 	TRACE("%s: validation %s\n\n", sym->name, ret ? "failed" : "end");
 	trace_disable();
 
-	if (opts.checksum)
-		checksum_finish(func);
-
 	return ret;
 }
 
@@ -5007,10 +5060,6 @@ int check(struct objtool_file *file)
 	cfi_hash_add(&init_cfi);
 	cfi_hash_add(&func_cfi);
 
-	ret = checksum_debug_init(file);
-	if (ret)
-		goto out;
-
 	ret = decode_sections(file);
 	if (ret)
 		goto out;
@@ -5101,6 +5150,9 @@ int check(struct objtool_file *file)
 		warnings += check_abs_references(file);
 
 	if (opts.checksum) {
+		ret = calculate_checksums(file);
+		if (ret)
+			goto out;
 		ret = create_sym_checksum_section(file);
 		if (ret)
 			goto out;
diff --git a/tools/objtool/include/objtool/checksum.h b/tools/objtool/include/objtool/checksum.h
index 0bd16fe9168b..3f25df90305d 100644
--- a/tools/objtool/include/objtool/checksum.h
+++ b/tools/objtool/include/objtool/checksum.h
@@ -33,11 +33,7 @@ static inline void checksum_finish(struct symbol *func)
 
 #else /* !BUILD_KLP */
 
-static inline void checksum_init(struct symbol *func) {}
-static inline void checksum_update(struct symbol *func,
-				   struct instruction *insn,
-				   const void *data, size_t size) {}
-static inline void checksum_finish(struct symbol *func) {}
+static inline int calculate_checksums(struct objtool_file *file) { return -ENOSYS; }
 
 #endif /* !BUILD_KLP */
 
-- 
2.53.0


