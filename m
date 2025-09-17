Return-Path: <live-patching+bounces-1692-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 46AE2B80DF1
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:10:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2CF5F4E3626
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:10:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34B3333B466;
	Wed, 17 Sep 2025 16:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GL9H9KCR"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFDA33AEB3;
	Wed, 17 Sep 2025 16:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125083; cv=none; b=Sg6snkBiIt2PEWGQ7Q24DycVxcJJbeHmdr4hqKpIIYH+A+zhIHHLcohzCCPkMCip2bbJA/noDCfJDSYI5tMpGWehGQ73Xn33xFCubuEocSe4HNFN6Sz/SVlGR+ISGxsdw6e2PlcGy3RSBodjnEGBcIMezd4kv+8p65o4OmrtwGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125083; c=relaxed/simple;
	bh=5sxwp6pz0sqV2FceeQTLeP8f4KdG9o47+fTpKfSzIBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnCRdKXxYsuHrqE5KQIteG7HVu3OTi+rBVGv32j/02jkETsKKwzz4ypVBdSZKsH2CJQcJLVZGu/kgDSqas4fr5zPojq4kQRnTwE4Fd6UYghGH/v/4etUopRJQQSdj0S2g9K/lFfojJHGxlhlQvg9sfJ8iyPjkfSvzIfxYldVlwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GL9H9KCR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA1BC4CEFD;
	Wed, 17 Sep 2025 16:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125082;
	bh=5sxwp6pz0sqV2FceeQTLeP8f4KdG9o47+fTpKfSzIBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GL9H9KCRaPqdYaae4KQrOZqYgc9NHb0qm2ZQwUv9wUHGEBt3oC2bnVvNUT6MWbapx
	 PAe8iHFc6CLnwLVM6Vc3HywMpn4hKvuzayplPta6L59Kmw0yy31gafp/ZA4ZQjVwTh
	 dcwjQ8HWtRTRdgG/rL5v6lNirqcgrjHnr+olo3CU5Ug0q1dlQNqRovxUJ4fgpHZ6QI
	 2GZl8NzJcewuGkldkHBYmxfkA0XomWXuuUzp7gGgwztUY3JofzWrY1Y68CLPzGafFK
	 E3mL3JKLQlgoduv7HA9F7Ool8IdsfdGBjtbXBrd3sHHyB/TPRyIVmi1WXcIAtJYZSB
	 XRH9U3+EF0/XA==
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
Subject: [PATCH v4 37/63] objtool: Refactor add_jump_destinations()
Date: Wed, 17 Sep 2025 09:03:45 -0700
Message-ID: <e8a19eb65fd70069ead9654bf8e2df9f60340338.1758067943.git.jpoimboe@kernel.org>
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

The add_jump_destinations() logic is a bit weird and convoluted after
being incrementally tweaked over the years.  Refactor it to hopefully be
more logical and straightforward.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c               | 222 +++++++++++++---------------
 tools/objtool/include/objtool/elf.h |   4 +-
 2 files changed, 106 insertions(+), 120 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 2af4cafb683fa..6d21b83b9377a 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1423,9 +1423,14 @@ static void add_return_call(struct objtool_file *file, struct instruction *insn,
 }
 
 static bool is_first_func_insn(struct objtool_file *file,
-			       struct instruction *insn, struct symbol *sym)
+			       struct instruction *insn)
 {
-	if (insn->offset == sym->offset)
+	struct symbol *func = insn_func(insn);
+
+	if (!func)
+		return false;
+
+	if (insn->offset == func->offset)
 		return true;
 
 	/* Allow direct CALL/JMP past ENDBR */
@@ -1433,51 +1438,30 @@ static bool is_first_func_insn(struct objtool_file *file,
 		struct instruction *prev = prev_insn_same_sym(file, insn);
 
 		if (prev && prev->type == INSN_ENDBR &&
-		    insn->offset == sym->offset + prev->len)
+		    insn->offset == func->offset + prev->len)
 			return true;
 	}
 
 	return false;
 }
 
-/*
- * A sibling call is a tail-call to another symbol -- to differentiate from a
- * recursive tail-call which is to the same symbol.
- */
-static bool jump_is_sibling_call(struct objtool_file *file,
-				 struct instruction *from, struct instruction *to)
-{
-	struct symbol *fs = from->sym;
-	struct symbol *ts = to->sym;
-
-	/* Not a sibling call if from/to a symbol hole */
-	if (!fs || !ts)
-		return false;
-
-	/* Not a sibling call if not targeting the start of a symbol. */
-	if (!is_first_func_insn(file, to, ts))
-		return false;
-
-	/* Disallow sibling calls into STT_NOTYPE */
-	if (is_notype_sym(ts))
-		return false;
-
-	/* Must not be self to be a sibling */
-	return fs->pfunc != ts->pfunc;
-}
-
 /*
  * Find the destination instructions for all jumps.
  */
 static int add_jump_destinations(struct objtool_file *file)
 {
-	struct instruction *insn, *jump_dest;
+	struct instruction *insn;
 	struct reloc *reloc;
-	struct section *dest_sec;
-	unsigned long dest_off;
 
 	for_each_insn(file, insn) {
 		struct symbol *func = insn_func(insn);
+		struct instruction *dest_insn;
+		struct section *dest_sec;
+		struct symbol *dest_sym;
+		unsigned long dest_off;
+
+		if (!is_static_jump(insn))
+			continue;
 
 		if (insn->jump_dest) {
 			/*
@@ -1486,51 +1470,53 @@ static int add_jump_destinations(struct objtool_file *file)
 			 */
 			continue;
 		}
-		if (!is_static_jump(insn))
-			continue;
 
 		reloc = insn_reloc(file, insn);
 		if (!reloc) {
 			dest_sec = insn->sec;
 			dest_off = arch_jump_destination(insn);
-		} else if (is_sec_sym(reloc->sym)) {
-			dest_sec = reloc->sym->sec;
-			dest_off = arch_insn_adjusted_addend(insn, reloc);
-		} else if (reloc->sym->retpoline_thunk) {
-			if (add_retpoline_call(file, insn))
-				return -1;
-			continue;
-		} else if (reloc->sym->return_thunk) {
-			add_return_call(file, insn, true);
-			continue;
-		} else if (func) {
-			/*
-			 * External sibling call or internal sibling call with
-			 * STT_FUNC reloc.
-			 */
-			if (add_call_dest(file, insn, reloc->sym, true))
-				return -1;
-			continue;
-		} else if (reloc->sym->sec->idx) {
-			dest_sec = reloc->sym->sec;
-			dest_off = reloc->sym->sym.st_value +
-				   arch_insn_adjusted_addend(insn, reloc);
+			dest_sym = dest_sec->sym;
 		} else {
-			/* non-func asm code jumping to another file */
-			continue;
+			dest_sym = reloc->sym;
+			if (is_undef_sym(dest_sym)) {
+				if (dest_sym->retpoline_thunk) {
+					if (add_retpoline_call(file, insn))
+						return -1;
+					continue;
+				}
+
+				if (dest_sym->return_thunk) {
+					add_return_call(file, insn, true);
+					continue;
+				}
+
+				/* External symbol */
+				if (func) {
+					/* External sibling call */
+					if (add_call_dest(file, insn, dest_sym, true))
+						return -1;
+					continue;
+				}
+
+				/* Non-func asm code jumping to external symbol */
+				continue;
+			}
+
+			dest_sec = dest_sym->sec;
+			dest_off = dest_sym->offset + arch_insn_adjusted_addend(insn, reloc);
 		}
 
-		jump_dest = find_insn(file, dest_sec, dest_off);
-		if (!jump_dest) {
+		dest_insn = find_insn(file, dest_sec, dest_off);
+		if (!dest_insn) {
 			struct symbol *sym = find_symbol_by_offset(dest_sec, dest_off);
 
 			/*
-			 * This is a special case for retbleed_untrain_ret().
-			 * It jumps to __x86_return_thunk(), but objtool
-			 * can't find the thunk's starting RET
-			 * instruction, because the RET is also in the
-			 * middle of another instruction.  Objtool only
-			 * knows about the outer instruction.
+			 * retbleed_untrain_ret() jumps to
+			 * __x86_return_thunk(), but objtool can't find
+			 * the thunk's starting RET instruction,
+			 * because the RET is also in the middle of
+			 * another instruction.  Objtool only knows
+			 * about the outer instruction.
 			 */
 			if (sym && sym->embedded_insn) {
 				add_return_call(file, insn, false);
@@ -1538,73 +1524,73 @@ static int add_jump_destinations(struct objtool_file *file)
 			}
 
 			/*
-			 * GCOV/KCOV dead code can jump to the end of the
-			 * function/section.
+			 * GCOV/KCOV dead code can jump to the end of
+			 * the function/section.
 			 */
 			if (file->ignore_unreachables && func &&
 			    dest_sec == insn->sec &&
 			    dest_off == func->offset + func->len)
 				continue;
 
-			ERROR_INSN(insn, "can't find jump dest instruction at %s+0x%lx",
-				   dest_sec->name, dest_off);
+			ERROR_INSN(insn, "can't find jump dest instruction at %s",
+				   offstr(dest_sec, dest_off));
 			return -1;
 		}
 
-		/*
-		 * An intra-TU jump in retpoline.o might not have a relocation
-		 * for its jump dest, in which case the above
-		 * add_{retpoline,return}_call() didn't happen.
-		 */
-		if (jump_dest->sym && jump_dest->offset == jump_dest->sym->offset) {
-			if (jump_dest->sym->retpoline_thunk) {
-				if (add_retpoline_call(file, insn))
-					return -1;
-				continue;
-			}
-			if (jump_dest->sym->return_thunk) {
-				add_return_call(file, insn, true);
-				continue;
-			}
+		if (!dest_sym || is_sec_sym(dest_sym)) {
+			dest_sym = dest_insn->sym;
+			if (!dest_sym)
+				goto set_jump_dest;
 		}
 
-		/*
-		 * Cross-function jump.
-		 */
-
-		if (func && insn_func(jump_dest) && !func->cold &&
-		    insn_func(jump_dest)->cold) {
-
-			/*
-			 * For GCC 8+, create parent/child links for any cold
-			 * subfunctions.  This is _mostly_ redundant with a
-			 * similar initialization in read_symbols().
-			 *
-			 * If a function has aliases, we want the *first* such
-			 * function in the symbol table to be the subfunction's
-			 * parent.  In that case we overwrite the
-			 * initialization done in read_symbols().
-			 *
-			 * However this code can't completely replace the
-			 * read_symbols() code because this doesn't detect the
-			 * case where the parent function's only reference to a
-			 * subfunction is through a jump table.
-			 */
-			func->cfunc = insn_func(jump_dest);
-			insn_func(jump_dest)->pfunc = func;
-		}
-
-		if (jump_is_sibling_call(file, insn, jump_dest)) {
-			/*
-			 * Internal sibling call without reloc or with
-			 * STT_SECTION reloc.
-			 */
-			if (add_call_dest(file, insn, insn_func(jump_dest), true))
+		if (dest_sym->retpoline_thunk && dest_insn->offset == dest_sym->offset) {
+			if (add_retpoline_call(file, insn))
 				return -1;
 			continue;
 		}
 
-		insn->jump_dest = jump_dest;
+		if (dest_sym->return_thunk && dest_insn->offset == dest_sym->offset) {
+			add_return_call(file, insn, true);
+			continue;
+		}
+
+		if (!insn->sym || insn->sym == dest_insn->sym)
+			goto set_jump_dest;
+
+		/*
+		 * Internal cross-function jump.
+		 */
+
+		/*
+		 * For GCC 8+, create parent/child links for any cold
+		 * subfunctions.  This is _mostly_ redundant with a
+		 * similar initialization in read_symbols().
+		 *
+		 * If a function has aliases, we want the *first* such
+		 * function in the symbol table to be the subfunction's
+		 * parent.  In that case we overwrite the
+		 * initialization done in read_symbols().
+		 *
+		 * However this code can't completely replace the
+		 * read_symbols() code because this doesn't detect the
+		 * case where the parent function's only reference to a
+		 * subfunction is through a jump table.
+		 */
+		if (func && dest_sym->cold) {
+			func->cfunc = dest_sym;
+			dest_sym->pfunc = func;
+			goto set_jump_dest;
+		}
+
+		if (is_first_func_insn(file, dest_insn)) {
+			/* Internal sibling call */
+			if (add_call_dest(file, insn, dest_sym, true))
+				return -1;
+			continue;
+		}
+
+set_jump_dest:
+		insn->jump_dest = dest_insn;
 	}
 
 	return 0;
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 79edf82e76ddf..07fc41f574b90 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -181,9 +181,9 @@ static inline unsigned int elf_text_rela_type(struct elf *elf)
 	return elf_addr_size(elf) == 4 ? R_TEXT32 : R_TEXT64;
 }
 
-static inline bool sym_has_sec(struct symbol *sym)
+static inline bool is_undef_sym(struct symbol *sym)
 {
-	return sym->sec->idx;
+	return !sym->sec->idx;
 }
 
 static inline bool is_null_sym(struct symbol *sym)
-- 
2.50.0


