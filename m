Return-Path: <live-patching+bounces-1671-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 550F2B80D9D
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:08:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B6D117D051
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDCB72FD7CF;
	Wed, 17 Sep 2025 16:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QG8X1ZJL"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56A42FD7B9;
	Wed, 17 Sep 2025 16:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125067; cv=none; b=HSFcgcu2+6PoqJyqcTaOSyxhEyT6OnLn6GdTtH/SS25HqUMSuNhFy0QIHGc7fHNp2OIzsvoaox66YvTZpvEOoAUyhnfwTGB/qZRmN+l+ygHSIZUMLcMHgjFizRNJTDJDdXupXiAPRaaudVnj2ok+N8oFaEf8HEyPOUglkbPOLB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125067; c=relaxed/simple;
	bh=uX5qpGmDW2s3UF1Pu23fMvFwgCrqobor12praWk0sJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvAS/XJHt1sraI2qNVnJN+IlL6tdW9thhdtoAQ4IUFjwyu6r8UHgtfTA+KqfluGFWfm21x714hfJwMqkjGkn0Gj5jwNzOHnqwcplQXdLCYCCyrcxMVVP23TGyuUfE9nu/mm3d1pkyTLurEgmtFYu704pkqDYoibVR7l96FQuxOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QG8X1ZJL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1393FC4CEF9;
	Wed, 17 Sep 2025 16:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125067;
	bh=uX5qpGmDW2s3UF1Pu23fMvFwgCrqobor12praWk0sJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QG8X1ZJLrdG/m7SkDLiiXA6EY3sgSaNpTP10OgbjcxolO3shVEpeKrvooW0K5lhCM
	 3j91OoiTcr81dsxe8xITRnW89P7MvH2qrKpx8Vs/AuTq4Hjb37d/1+dPTh1MQJ3KQD
	 lSGoLIREPAfsl7gFRwrkx3DArnDfZFRodazhUQKGG00VxW4NvnqV2z9ZIVvrVk+xPs
	 AzsDZqBvKXQSMox7ciRHA+DmlhIKD2TDwMUvPtsOYyG59NQbOo7f2N/RfAW/CT/4Ck
	 xspvLhsYN2Ea6fxyedr3y7F047lWNpoiVfZ6YChirIYdPOHMNhLaV15xScAD0LRf5A
	 Tb38FFcaXc/9A==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org,
	Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v4 16/63] objtool: Remove error handling boilerplate
Date: Wed, 17 Sep 2025 09:03:24 -0700
Message-ID: <d210a1a75a284b460f2269fccbecfe10f68bc569.1758067942.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <cover.1758067942.git.jpoimboe@kernel.org>
References: <cover.1758067942.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Up to a certain point in objtool's execution, all errors are fatal and
return -1.  When propagating such errors, just return -1 directly
instead of trying to propagate the original return code.  This helps
make the code more compact and the behavior more explicit.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c   | 151 +++++++++++++++-------------------------
 tools/objtool/special.c |   9 +--
 2 files changed, 59 insertions(+), 101 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 6d6323508e4b8..dbdbbddd01ecb 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -430,7 +430,6 @@ static int decode_instructions(struct objtool_file *file)
 	struct symbol *func;
 	unsigned long offset;
 	struct instruction *insn;
-	int ret;
 
 	for_each_sec(file, sec) {
 		struct instruction *insns = NULL;
@@ -479,11 +478,8 @@ static int decode_instructions(struct objtool_file *file)
 			insn->offset = offset;
 			insn->prev_len = prev_len;
 
-			ret = arch_decode_instruction(file, sec, offset,
-						      sec->sh.sh_size - offset,
-						      insn);
-			if (ret)
-				return ret;
+			if (arch_decode_instruction(file, sec, offset, sec->sh.sh_size - offset, insn))
+				return -1;
 
 			prev_len = insn->len;
 
@@ -599,7 +595,7 @@ static int init_pv_ops(struct objtool_file *file)
 	};
 	const char *pv_ops;
 	struct symbol *sym;
-	int idx, nr, ret;
+	int idx, nr;
 
 	if (!opts.noinstr)
 		return 0;
@@ -621,9 +617,8 @@ static int init_pv_ops(struct objtool_file *file)
 		INIT_LIST_HEAD(&file->pv_ops[idx].targets);
 
 	for (idx = 0; (pv_ops = pv_ops_tables[idx]); idx++) {
-		ret = add_pv_ops(file, pv_ops);
-		if (ret)
-			return ret;
+		if (add_pv_ops(file, pv_ops))
+			return -1;
 	}
 
 	return 0;
@@ -1484,7 +1479,6 @@ static int add_jump_destinations(struct objtool_file *file)
 	struct reloc *reloc;
 	struct section *dest_sec;
 	unsigned long dest_off;
-	int ret;
 
 	for_each_insn(file, insn) {
 		struct symbol *func = insn_func(insn);
@@ -1507,9 +1501,8 @@ static int add_jump_destinations(struct objtool_file *file)
 			dest_sec = reloc->sym->sec;
 			dest_off = arch_dest_reloc_offset(reloc_addend(reloc));
 		} else if (reloc->sym->retpoline_thunk) {
-			ret = add_retpoline_call(file, insn);
-			if (ret)
-				return ret;
+			if (add_retpoline_call(file, insn))
+				return -1;
 			continue;
 		} else if (reloc->sym->return_thunk) {
 			add_return_call(file, insn, true);
@@ -1519,9 +1512,8 @@ static int add_jump_destinations(struct objtool_file *file)
 			 * External sibling call or internal sibling call with
 			 * STT_FUNC reloc.
 			 */
-			ret = add_call_dest(file, insn, reloc->sym, true);
-			if (ret)
-				return ret;
+			if (add_call_dest(file, insn, reloc->sym, true))
+				return -1;
 			continue;
 		} else if (reloc->sym->sec->idx) {
 			dest_sec = reloc->sym->sec;
@@ -1570,9 +1562,8 @@ static int add_jump_destinations(struct objtool_file *file)
 		 */
 		if (jump_dest->sym && jump_dest->offset == jump_dest->sym->offset) {
 			if (jump_dest->sym->retpoline_thunk) {
-				ret = add_retpoline_call(file, insn);
-				if (ret)
-					return ret;
+				if (add_retpoline_call(file, insn))
+					return -1;
 				continue;
 			}
 			if (jump_dest->sym->return_thunk) {
@@ -1613,9 +1604,8 @@ static int add_jump_destinations(struct objtool_file *file)
 			 * Internal sibling call without reloc or with
 			 * STT_SECTION reloc.
 			 */
-			ret = add_call_dest(file, insn, insn_func(jump_dest), true);
-			if (ret)
-				return ret;
+			if (add_call_dest(file, insn, insn_func(jump_dest), true))
+				return -1;
 			continue;
 		}
 
@@ -1645,7 +1635,6 @@ static int add_call_destinations(struct objtool_file *file)
 	unsigned long dest_off;
 	struct symbol *dest;
 	struct reloc *reloc;
-	int ret;
 
 	for_each_insn(file, insn) {
 		struct symbol *func = insn_func(insn);
@@ -1657,9 +1646,8 @@ static int add_call_destinations(struct objtool_file *file)
 			dest_off = arch_jump_destination(insn);
 			dest = find_call_destination(insn->sec, dest_off);
 
-			ret = add_call_dest(file, insn, dest, false);
-			if (ret)
-				return ret;
+			if (add_call_dest(file, insn, dest, false))
+				return -1;
 
 			if (func && func->ignore)
 				continue;
@@ -1683,19 +1671,16 @@ static int add_call_destinations(struct objtool_file *file)
 				return -1;
 			}
 
-			ret = add_call_dest(file, insn, dest, false);
-			if (ret)
-				return ret;
+			if (add_call_dest(file, insn, dest, false))
+				return -1;
 
 		} else if (reloc->sym->retpoline_thunk) {
-			ret = add_retpoline_call(file, insn);
-			if (ret)
-				return ret;
+			if (add_retpoline_call(file, insn))
+				return -1;
 
 		} else {
-			ret = add_call_dest(file, insn, reloc->sym, false);
-			if (ret)
-				return ret;
+			if (add_call_dest(file, insn, reloc->sym, false))
+				return -1;
 		}
 	}
 
@@ -1912,7 +1897,6 @@ static int add_special_section_alts(struct objtool_file *file)
 	struct instruction *orig_insn, *new_insn;
 	struct special_alt *special_alt, *tmp;
 	struct alternative *alt;
-	int ret;
 
 	if (special_get_alts(file->elf, &special_alts))
 		return -1;
@@ -1944,16 +1928,12 @@ static int add_special_section_alts(struct objtool_file *file)
 				continue;
 			}
 
-			ret = handle_group_alt(file, special_alt, orig_insn,
-					       &new_insn);
-			if (ret)
-				return ret;
+			if (handle_group_alt(file, special_alt, orig_insn, &new_insn))
+				return -1;
 
 		} else if (special_alt->jump_or_nop) {
-			ret = handle_jump_alt(file, special_alt, orig_insn,
-					      &new_insn);
-			if (ret)
-				return ret;
+			if (handle_jump_alt(file, special_alt, orig_insn, &new_insn))
+				return -1;
 		}
 
 		alt = calloc(1, sizeof(*alt));
@@ -2141,15 +2121,13 @@ static int add_func_jump_tables(struct objtool_file *file,
 				  struct symbol *func)
 {
 	struct instruction *insn;
-	int ret;
 
 	func_for_each_insn(file, func, insn) {
 		if (!insn_jump_table(insn))
 			continue;
 
-		ret = add_jump_table(file, insn);
-		if (ret)
-			return ret;
+		if (add_jump_table(file, insn))
+			return -1;
 	}
 
 	return 0;
@@ -2163,7 +2141,6 @@ static int add_func_jump_tables(struct objtool_file *file,
 static int add_jump_table_alts(struct objtool_file *file)
 {
 	struct symbol *func;
-	int ret;
 
 	if (!file->rodata)
 		return 0;
@@ -2173,9 +2150,8 @@ static int add_jump_table_alts(struct objtool_file *file)
 			continue;
 
 		mark_func_jump_tables(file, func);
-		ret = add_func_jump_tables(file, func);
-		if (ret)
-			return ret;
+		if (add_func_jump_tables(file, func))
+			return -1;
 	}
 
 	return 0;
@@ -2299,7 +2275,7 @@ static int read_annotate(struct objtool_file *file,
 	struct instruction *insn;
 	struct reloc *reloc;
 	uint64_t offset;
-	int type, ret;
+	int type;
 
 	sec = find_section_by_name(file->elf, ".discard.annotate_insn");
 	if (!sec)
@@ -2329,9 +2305,8 @@ static int read_annotate(struct objtool_file *file,
 			return -1;
 		}
 
-		ret = func(file, type, insn);
-		if (ret < 0)
-			return ret;
+		if (func(file, type, insn))
+			return -1;
 	}
 
 	return 0;
@@ -2540,76 +2515,62 @@ static void mark_rodata(struct objtool_file *file)
 
 static int decode_sections(struct objtool_file *file)
 {
-	int ret;
-
 	mark_rodata(file);
 
-	ret = init_pv_ops(file);
-	if (ret)
-		return ret;
+	if (init_pv_ops(file))
+		return -1;
 
 	/*
 	 * Must be before add_{jump_call}_destination.
 	 */
-	ret = classify_symbols(file);
-	if (ret)
-		return ret;
+	if (classify_symbols(file))
+		return -1;
 
-	ret = decode_instructions(file);
-	if (ret)
-		return ret;
+	if (decode_instructions(file))
+		return -1;
 
-	ret = add_ignores(file);
-	if (ret)
-		return ret;
+	if (add_ignores(file))
+		return -1;
 
 	add_uaccess_safe(file);
 
-	ret = read_annotate(file, __annotate_early);
-	if (ret)
-		return ret;
+	if (read_annotate(file, __annotate_early))
+		return -1;
 
 	/*
 	 * Must be before add_jump_destinations(), which depends on 'func'
 	 * being set for alternatives, to enable proper sibling call detection.
 	 */
 	if (opts.stackval || opts.orc || opts.uaccess || opts.noinstr) {
-		ret = add_special_section_alts(file);
-		if (ret)
-			return ret;
+		if (add_special_section_alts(file))
+			return -1;
 	}
 
-	ret = add_jump_destinations(file);
-	if (ret)
-		return ret;
+	if (add_jump_destinations(file))
+		return -1;
 
 	/*
 	 * Must be before add_call_destination(); it changes INSN_CALL to
 	 * INSN_JUMP.
 	 */
-	ret = read_annotate(file, __annotate_ifc);
-	if (ret)
-		return ret;
+	if (read_annotate(file, __annotate_ifc))
+		return -1;
 
-	ret = add_call_destinations(file);
-	if (ret)
-		return ret;
+	if (add_call_destinations(file))
+		return -1;
 
-	ret = add_jump_table_alts(file);
-	if (ret)
-		return ret;
+	if (add_jump_table_alts(file))
+		return -1;
 
-	ret = read_unwind_hints(file);
-	if (ret)
-		return ret;
+	if (read_unwind_hints(file))
+		return -1;
 
 	/*
 	 * Must be after add_call_destinations() such that it can override
 	 * dead_end_function() marks.
 	 */
-	ret = read_annotate(file, __annotate_late);
-	if (ret)
-		return ret;
+	if (read_annotate(file, __annotate_late))
+		return -1;
 
 	return 0;
 }
diff --git a/tools/objtool/special.c b/tools/objtool/special.c
index c80fed8a840ee..c0beefb93b62e 100644
--- a/tools/objtool/special.c
+++ b/tools/objtool/special.c
@@ -133,7 +133,7 @@ int special_get_alts(struct elf *elf, struct list_head *alts)
 	struct section *sec;
 	unsigned int nr_entries;
 	struct special_alt *alt;
-	int idx, ret;
+	int idx;
 
 	INIT_LIST_HEAD(alts);
 
@@ -157,11 +157,8 @@ int special_get_alts(struct elf *elf, struct list_head *alts)
 			}
 			memset(alt, 0, sizeof(*alt));
 
-			ret = get_alt_entry(elf, entry, sec, idx, alt);
-			if (ret > 0)
-				continue;
-			if (ret < 0)
-				return ret;
+			if (get_alt_entry(elf, entry, sec, idx, alt))
+				return -1;
 
 			list_add_tail(&alt->list, alts);
 		}
-- 
2.50.0


