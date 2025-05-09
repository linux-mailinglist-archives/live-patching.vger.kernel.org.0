Return-Path: <live-patching+bounces-1394-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE9A7AB1E17
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:25:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5FD61889A6B
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 244D8298242;
	Fri,  9 May 2025 20:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WzmGTsuN"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FF12980D2;
	Fri,  9 May 2025 20:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821890; cv=none; b=iecswA9xnx7XwL5v3bFAW37jbU6ob0ckJYbGggvBPeMlS4/+aOAgN+aBvcSzcYv/J2oSfusdmRQkmLmCPzAvvmow4urMNM/cdwfCIOY18QN7IlLxgYVCWKs5N/jBQDHWjLGc+DfcSdJIrOCXq02KsmOUB6q8GwY9+NT5E1/n64E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821890; c=relaxed/simple;
	bh=E1XeSlz6tc3UGYZyk27xZHj95Gq3nCNWZZlCdtYtLZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQiVco20HDYH0cpbRCh1xdeYYXpmik/tQQa7G5RXnK6enlHtCT9qqh3Op6cfkWhVpAQxseGlpgxt/t6BzGaiAZKEhIoNJUdG3rQBKWjieBEVW1MeBhpW5XWS89drBBFwSU0mdLxzl2667z00C0rw2EmkHHOrvaHE5zevX8sNHDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WzmGTsuN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49DAC4CEF0;
	Fri,  9 May 2025 20:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821889;
	bh=E1XeSlz6tc3UGYZyk27xZHj95Gq3nCNWZZlCdtYtLZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzmGTsuNZJiVtxxlbm2fn6dhE3vK15ii8Wn0LIDc5wK6puRqoghJNhFt0MTj8yhlw
	 DJOwpU012BnISTH8rcwYo3yV1EuEOVBw1NAXrAcGhGdkp7fmUuu7ZkP63pCCI412At
	 UG6h+zCG+RRoty2inglJ0JFiZL2Z/zZ1zUBaTi27iWT/TXKn+tD2W4HfvSvJAP+Uyy
	 rEKbG5xa8LAO7POJQb4XJL5uMr4QBcw0eVwXbc6Hn+fN9upvkDAnovvCDuao3KS9/j
	 f3erN2MFWiDmIyvSid/M1ErOsyBZXPK0vVyP0gfVTVqvs2uYdnGogrzFmbf6UK3N3q
	 JwK+NmuIOLBbA==
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
	Puranjay Mohan <puranjay@kernel.org>
Subject: [PATCH v2 35/62] objtool: Refactor add_jump_destinations()
Date: Fri,  9 May 2025 13:16:59 -0700
Message-ID: <70bf4b499941a6b19c5f750f5c36afcd6ffd216f.1746821544.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746821544.git.jpoimboe@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
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
 tools/objtool/check.c               | 227 +++++++++++++---------------
 tools/objtool/include/objtool/elf.h |   4 +-
 2 files changed, 104 insertions(+), 127 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 66cbeebd16ea..e4ca5edf73ad 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1439,9 +1439,14 @@ static void add_return_call(struct objtool_file *file, struct instruction *insn,
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
@@ -1449,52 +1454,32 @@ static bool is_first_func_insn(struct objtool_file *file,
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
 	int ret;
 
 	for_each_insn(file, insn) {
 		struct symbol *func = insn_func(insn);
+		struct instruction *dest_insn;
+		struct section *dest_sec;
+		struct symbol *dest_sym;
+		unsigned long dest_off;
+		bool dest_undef = false;
+
+		if (!is_static_jump(insn))
+			continue;
 
 		if (insn->jump_dest) {
 			/*
@@ -1503,129 +1488,121 @@ static int add_jump_destinations(struct objtool_file *file)
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
+		} else if (is_undef_sym(reloc->sym)) {
+			dest_sym = reloc->sym;
+			dest_undef = true;
+		} else {
 			dest_sec = reloc->sym->sec;
-			dest_off = arch_insn_adjusted_addend(insn, reloc);
-		} else if (reloc->sym->retpoline_thunk) {
+			dest_off = reloc->sym->sym.st_value +
+				   arch_insn_adjusted_addend(insn, reloc);
+		}
+
+		if (!dest_undef) {
+			dest_insn = find_insn(file, dest_sec, dest_off);
+			if (!dest_insn) {
+				struct symbol *sym = find_symbol_by_offset(dest_sec, dest_off);
+
+				/*
+				 * retbleed_untrain_ret() jumps to
+				 * __x86_return_thunk(), but objtool can't find
+				 * the thunk's starting RET instruction,
+				 * because the RET is also in the middle of
+				 * another instruction.  Objtool only knows
+				 * about the outer instruction.
+				 */
+				if (sym && sym->embedded_insn) {
+					add_return_call(file, insn, false);
+					continue;
+				}
+
+				/*
+				 * GCOV/KCOV dead code can jump to the end of
+				 * the function/section.
+				 */
+				if (file->ignore_unreachables && func &&
+				    dest_sec == insn->sec &&
+				    dest_off == func->offset + func->len)
+					continue;
+
+				ERROR_INSN(insn, "can't find jump dest instruction at %s+0x%lx",
+					  dest_sec->name, dest_off);
+				return -1;
+			}
+
+			dest_sym = dest_insn->sym;
+			if (!dest_sym)
+				goto set_jump_dest;
+		}
+
+		if (dest_sym->retpoline_thunk) {
 			ret = add_retpoline_call(file, insn);
 			if (ret)
 				return ret;
 			continue;
-		} else if (reloc->sym->return_thunk) {
+		}
+
+		if (dest_sym->return_thunk) {
 			add_return_call(file, insn, true);
 			continue;
-		} else if (func) {
-			/*
-			 * External sibling call or internal sibling call with
-			 * STT_FUNC reloc.
-			 */
-			ret = add_call_dest(file, insn, reloc->sym, true);
-			if (ret)
-				return ret;
-			continue;
-		} else if (reloc->sym->sec->idx) {
-			dest_sec = reloc->sym->sec;
-			dest_off = reloc->sym->sym.st_value +
-				   arch_dest_reloc_offset(reloc_addend(reloc));
-		} else {
-			/* non-func asm code jumping to another file */
-			continue;
 		}
 
-		jump_dest = find_insn(file, dest_sec, dest_off);
-		if (!jump_dest) {
-			struct symbol *sym = find_symbol_by_offset(dest_sec, dest_off);
-
-			/*
-			 * This is a special case for retbleed_untrain_ret().
-			 * It jumps to __x86_return_thunk(), but objtool
-			 * can't find the thunk's starting RET
-			 * instruction, because the RET is also in the
-			 * middle of another instruction.  Objtool only
-			 * knows about the outer instruction.
-			 */
-			if (sym && sym->embedded_insn) {
-				add_return_call(file, insn, false);
-				continue;
-			}
-
-			/*
-			 * GCOV/KCOV dead code can jump to the end of the
-			 * function/section.
-			 */
-			if (file->ignore_unreachables && func &&
-			    dest_sec == insn->sec &&
-			    dest_off == func->offset + func->len)
-				continue;
-
-			ERROR_INSN(insn, "can't find jump dest instruction at %s+0x%lx",
-				   dest_sec->name, dest_off);
-			return -1;
-		}
-
-		/*
-		 * An intra-TU jump in retpoline.o might not have a relocation
-		 * for its jump dest, in which case the above
-		 * add_{retpoline,return}_call() didn't happen.
-		 */
-		if (jump_dest->sym && jump_dest->offset == jump_dest->sym->offset) {
-			if (jump_dest->sym->retpoline_thunk) {
-				ret = add_retpoline_call(file, insn);
+		if (dest_undef) {
+			/* External symbol */
+			if (func) {
+				/* External sibling call */
+				ret = add_call_dest(file, insn, dest_sym, true);
 				if (ret)
 					return ret;
 				continue;
 			}
-			if (jump_dest->sym->return_thunk) {
-				add_return_call(file, insn, true);
-				continue;
-			}
+
+			/* Non-func asm code jumping to external symbol */
+			continue;
 		}
 
+		if (!insn->sym || insn->sym == dest_insn->sym)
+			goto set_jump_dest;
+
 		/*
-		 * Cross-function jump.
+		 * Internal cross-function jump.
 		 */
 
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
 		}
 
-		if (jump_is_sibling_call(file, insn, jump_dest)) {
-			/*
-			 * Internal sibling call without reloc or with
-			 * STT_SECTION reloc.
-			 */
-			ret = add_call_dest(file, insn, insn_func(jump_dest), true);
+		if (is_first_func_insn(file, dest_insn)) {
+			/* Internal sibling call */
+			ret = add_call_dest(file, insn, dest_sym, true);
 			if (ret)
 				return ret;
 			continue;
 		}
 
-		insn->jump_dest = jump_dest;
+set_jump_dest:
+		insn->jump_dest = dest_insn;
 	}
 
 	return 0;
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 842faec1b9a9..74c7b84b5310 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -180,9 +180,9 @@ static inline unsigned int elf_text_rela_type(struct elf *elf)
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
2.49.0


