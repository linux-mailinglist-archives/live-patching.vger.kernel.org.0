Return-Path: <live-patching+bounces-2460-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cKPmN5Gd6WkAfQIAu9opvQ
	(envelope-from <live-patching+bounces-2460-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:18:25 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 434BF44CE1D
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:18:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7EDE130E5A7A
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 757D73DB639;
	Thu, 23 Apr 2026 04:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yj8xm7qf"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5079B3CD8BE;
	Thu, 23 Apr 2026 04:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917080; cv=none; b=r2Axg0Iv3ZUVFj11QXMtTpzbha56OmaaKvMV7FRpvO4V3KzU6n9inbMyuf24q31R62q+T1ue7XhkdV3x9rdmQmKnd3l2emAv+wDy1KzsDatxran0WxizQYXWOwQXHRrmoNETzeWaJQyCbPV/ynpTNd9PHJigr8IW3be7ukisEa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917080; c=relaxed/simple;
	bh=QpN3wZEF3XEi04wYPc8WrluAdlGjdrfTiO9Mcvdilu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gE617/OPrUGnljpvMIm0lE7LjNsfLziq1jn6YzSswDfLXoZfKmXO4S/WkoJ/Rnn+Du7GToVbXd8Apl3vVOJoDaBdv6WkIvEaEbdm5QOziTaFqgBy8wbdc/8GfQlVafgJwItOSPyIozs9ZohEP2y1FHZDNUIs8L/2l3rPcKBg/aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yj8xm7qf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC620C2BCB8;
	Thu, 23 Apr 2026 04:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917080;
	bh=QpN3wZEF3XEi04wYPc8WrluAdlGjdrfTiO9Mcvdilu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yj8xm7qf9s682URxqg+h2lbJviHosIXvBNvCFb5joxskXGd5Ym29EobPFazH6PbC/
	 KsoagM5k1DkT78WWkp6u4siJ/nx3f+LptAMGMwnoNfLnfX0xUiGSIyv6uBD7JW/x4+
	 DbbRsD4QXAOLcO2Q0EBsbyKSYf6r+ZgrATmmCuVmJ65YU7yNSTHWI9ch2Y4lkPB4PC
	 Ph/rRgsyoFkKf39qw22A+Ib7qFMWTS6ojOj6BkhwMjmzveApZ29YjjnLV+0HY3/1yl
	 YhMF/9F2JOkJ2QYCsa0cYwVLKyyJu7Ys3vKqDEn/zIi3p8NdsVty1QyWnB/c3WzAMc
	 DpJGYVAvEAK6g==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 33/48] objtool/klp: Extricate checksum calculation from validate_branch()
Date: Wed, 22 Apr 2026 21:04:01 -0700
Message-ID: <ab7a6a65b9139aee9f52829048be928ca0c062b8.1776916871.git.jpoimboe@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2460-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 434BF44CE1D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

In preparation for porting the checksum code to other arches, make its
functionality independent from the CFG reverse engineering code.

Move it into a standalone calculate_checksums() function which iterates
all functions and instructions directly, rather than being called inline
from do_validate_branch().

Since checksum_update_insn() is no longer called during CFG traversal,
it needs to manually iterate the alternatives.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c                    | 106 +++++++++++++++++------
 tools/objtool/include/objtool/checksum.h |   6 +-
 2 files changed, 80 insertions(+), 32 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 4ed27c53c718..c8208caa4b2c 100644
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
 static void enable_debug_checksum_cb(struct symbol *sym, void *d)
 {
 	bool *found = d;
@@ -3705,8 +3711,10 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
 				 struct instruction *insn)
 {
 	struct reloc *reloc = insn_reloc(file, insn);
+	struct alternative *alt;
 	unsigned long offset;
 	struct symbol *sym;
+	static bool in_alt;
 
 	if (insn->fake)
 		return;
@@ -3719,7 +3727,7 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
 		if (call_dest)
 			checksum_update(func, insn, call_dest->demangled_name,
 					strlen(call_dest->demangled_name));
-		return;
+		goto alts;
 	}
 
 	sym = reloc->sym;
@@ -3730,21 +3738,78 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
 
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
@@ -4026,9 +4091,6 @@ static int do_validate_branch(struct objtool_file *file, struct symbol *func,
 		insn->trace = 0;
 		next_insn = next_insn_to_validate(file, insn);
 
-		if (opts.checksum && func && insn->sec)
-			checksum_update_insn(file, func, insn);
-
 		if (func && insn_func(insn) && func != insn_func(insn)->pfunc) {
 			/* Ignore KCFI type preambles, which always fall through */
 			if (is_prefix_func(func))
@@ -4094,9 +4156,6 @@ static int validate_unwind_hint(struct objtool_file *file,
 		struct symbol *func = insn_func(insn);
 		int ret;
 
-		if (opts.checksum)
-			checksum_init(func);
-
 		ret = validate_branch(file, func, insn, *state);
 		if (ret)
 			BT_INSN(insn, "<=== (hint)");
@@ -4539,9 +4598,6 @@ static int validate_symbol(struct objtool_file *file, struct section *sec,
 
 	func = insn_func(insn);
 
-	if (opts.checksum)
-		checksum_init(func);
-
 	if (opts.trace && !fnmatch(opts.trace, sym->name, 0)) {
 		trace_enable();
 		TRACE("%s: validation begin\n", sym->name);
@@ -4554,9 +4610,6 @@ static int validate_symbol(struct objtool_file *file, struct section *sec,
 	TRACE("%s: validation %s\n\n", sym->name, ret ? "failed" : "end");
 	trace_disable();
 
-	if (opts.checksum)
-		checksum_finish(func);
-
 	return ret;
 }
 
@@ -5011,10 +5064,6 @@ int check(struct objtool_file *file)
 	cfi_hash_add(&init_cfi);
 	cfi_hash_add(&func_cfi);
 
-	ret = checksum_debug_init(file);
-	if (ret)
-		goto out;
-
 	ret = decode_sections(file);
 	if (ret)
 		goto out;
@@ -5105,6 +5154,9 @@ int check(struct objtool_file *file)
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


