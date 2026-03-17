Return-Path: <live-patching+bounces-2225-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WMpoEFvbuWlHOgIAu9opvQ
	(envelope-from <live-patching+bounces-2225-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 23:53:15 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BADC32B33C9
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 23:53:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4979730A2FF4
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 22:51:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D7B93F880D;
	Tue, 17 Mar 2026 22:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H25Tzxbc"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4D93F880A;
	Tue, 17 Mar 2026 22:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773787895; cv=none; b=dfMsMV+G1UEb+gQYVpKhduki/s9co9JknLrSu+/oWTiM7+cE1XnEReXWhrnEiG8rOBXve9lXtHRdOXcyrd4i2L3X/7Rjkwk2+Ojobb30IoZw/pv0ZYVUnB5eSeWf7yPoQYiA7Z4WhQ3ijc6t7844XXG8MQg7U+bSwkj47Bu2xnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773787895; c=relaxed/simple;
	bh=TUaxduyimKBy3VNMssZhboEIRmy6Myd8d1LMjCjwrEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Et7I/GcjdznP2IZRZUwj7Dftwz/o5X3RIcCgcGLnH5NaPsFoKTDJSlpkZW2E/XSkP3RkuKcfWivJ1R9/Ky47i+ef5LFq6V/XA/tFBe/jlo9KctkYSUHFZ99spbnAJY9OtH1oOwi+dOXm15FJSIToUXS+BKJPkUyPOHIPLdihyqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H25Tzxbc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D88C4AF0D;
	Tue, 17 Mar 2026 22:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773787895;
	bh=TUaxduyimKBy3VNMssZhboEIRmy6Myd8d1LMjCjwrEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H25Tzxbcj2msmLBn45caCXnQrfG0h5THrjah7LuGH/RigZ62FA6ZRLfHZatejHhnW
	 3ePSGRyBhccA7SVXuomFM4uRyiyeio9tK/5fNn70V68Or0gYagpHoseu8E6sgd/tcI
	 rdrh4T7NERJ83IeyBlxHAbkFuN2DWs2q11f5s3J2qxpkZIvKAWZCfmJKV8Ooekwe/H
	 bpok87dt3Ii5gFBviWjBoThvChQ7I2TcYaKRhl7Wd3pzJpTmH75AgaeLDi7YX73JGJ
	 5VZz7j1JzzhwNgOUG/r33yri9wUuJUoLgFDMJhNls/w/lNRaPUFcp9eBu87115d07d
	 i1ChgY7HZiAGA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 05/12] objtool: Extricate checksum calculation from validate_branch()
Date: Tue, 17 Mar 2026 15:51:05 -0700
Message-ID: <fe1ee04d49913643d0e653ecb19731a361b863e5.1773787568.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773787568.git.jpoimboe@kernel.org>
References: <cover.1773787568.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2225-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BADC32B33C9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

In preparation for porting the checksum code to other arches, make its
functionality independent from the CFG reverse engineering code.

Now that it's no longer called by validate_insn(),
checksum_update_insn() has to manually iterate the alternatives.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c                    | 71 +++++++++++++++++-------
 tools/objtool/include/objtool/checksum.h |  6 +-
 2 files changed, 53 insertions(+), 24 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 2301fb7ff3c8..d428d63b29c6 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2633,8 +2633,7 @@ static bool validate_branch_enabled(void)
 {
 	return opts.stackval ||
 	       opts.orc ||
-	       opts.uaccess ||
-	       opts.checksum;
+	       opts.uaccess;
 }
 
 static int decode_sections(struct objtool_file *file)
@@ -3663,6 +3662,7 @@ static bool skip_alt_group(struct instruction *insn)
 	return alt_insn->type == INSN_CLAC || alt_insn->type == INSN_STAC;
 }
 
+#ifdef BUILD_KLP
 static int checksum_debug_init(struct objtool_file *file)
 {
 	char *dup, *s;
@@ -3705,9 +3705,30 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
 				 struct instruction *insn)
 {
 	struct reloc *reloc = insn_reloc(file, insn);
+	struct alternative *alt;
 	unsigned long offset;
 	struct symbol *sym;
 
+	for (alt = insn->alts; alt; alt = alt->next) {
+		struct alt_group *alt_group = alt->insn->alt_group;
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
+				if (alt_insn == alt_group->last_insn)
+					break;
+			}
+		} else {
+			checksum_update(func, insn, &alt->insn->offset, sizeof(alt->insn->offset));
+		}
+	}
+
 	if (insn->fake)
 		return;
 
@@ -3716,9 +3737,11 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
 	if (!reloc) {
 		struct symbol *call_dest = insn_call_dest(insn);
 
-		if (call_dest)
+		if (call_dest) {
+			/* intra-TU call without reloc */
 			checksum_update(func, insn, call_dest->demangled_name,
 					strlen(call_dest->demangled_name));
+		}
 		return;
 	}
 
@@ -3745,6 +3768,29 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
 	checksum_update(func, insn, &offset, sizeof(offset));
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
+		if (!is_func_sym(func))
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
@@ -4026,9 +4072,6 @@ static int do_validate_branch(struct objtool_file *file, struct symbol *func,
 		insn->trace = 0;
 		next_insn = next_insn_to_validate(file, insn);
 
-		if (opts.checksum && func && insn->sec)
-			checksum_update_insn(file, func, insn);
-
 		if (func && insn_func(insn) && func != insn_func(insn)->pfunc) {
 			/* Ignore KCFI type preambles, which always fall through */
 			if (is_prefix_func(func))
@@ -4094,9 +4137,6 @@ static int validate_unwind_hint(struct objtool_file *file,
 		struct symbol *func = insn_func(insn);
 		int ret;
 
-		if (opts.checksum)
-			checksum_init(func);
-
 		ret = validate_branch(file, func, insn, *state);
 		if (ret)
 			BT_INSN(insn, "<=== (hint)");
@@ -4539,9 +4579,6 @@ static int validate_symbol(struct objtool_file *file, struct section *sec,
 
 	func = insn_func(insn);
 
-	if (opts.checksum)
-		checksum_init(func);
-
 	if (opts.trace && !fnmatch(opts.trace, sym->name, 0)) {
 		trace_enable();
 		TRACE("%s: validation begin\n", sym->name);
@@ -4554,9 +4591,6 @@ static int validate_symbol(struct objtool_file *file, struct section *sec,
 	TRACE("%s: validation %s\n\n", sym->name, ret ? "failed" : "end");
 	trace_disable();
 
-	if (opts.checksum)
-		checksum_finish(func);
-
 	return ret;
 }
 
@@ -5011,10 +5045,6 @@ int check(struct objtool_file *file)
 	cfi_hash_add(&init_cfi);
 	cfi_hash_add(&func_cfi);
 
-	ret = checksum_debug_init(file);
-	if (ret)
-		goto out;
-
 	ret = decode_sections(file);
 	if (ret)
 		goto out;
@@ -5105,6 +5135,9 @@ int check(struct objtool_file *file)
 		warnings += check_abs_references(file);
 
 	if (opts.checksum) {
+		ret = calculate_checksums(file);
+		if (ret)
+			goto out;
 		ret = create_sym_checksum_section(file);
 		if (ret)
 			goto out;
diff --git a/tools/objtool/include/objtool/checksum.h b/tools/objtool/include/objtool/checksum.h
index 7fe21608722a..36a17688c716 100644
--- a/tools/objtool/include/objtool/checksum.h
+++ b/tools/objtool/include/objtool/checksum.h
@@ -32,11 +32,7 @@ static inline void checksum_finish(struct symbol *func)
 
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


