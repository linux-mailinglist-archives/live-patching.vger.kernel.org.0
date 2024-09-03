Return-Path: <live-patching+bounces-547-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91BF5969284
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:02:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1205BB21677
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:02:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A961D1F45;
	Tue,  3 Sep 2024 04:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N+VCAIIA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889661D1746;
	Tue,  3 Sep 2024 04:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336036; cv=none; b=cQt9+3skACJySizmB84P3OZQ1ag5IH+NQ1WV4tv6aB1fTtIgNgUmyQH96QBhrPx68CITj3wqC6mVXN9Y/8ZqpADBSMpp7LhQnVDMO9o6jUxx5jqWJFmHILOmnE762mP2UUq5CLwVEolEcmQI709xBy0yO8QOY0Lp3vVR9z+6fxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336036; c=relaxed/simple;
	bh=vtgBTd6vd/L2FWYI0DggGWm8tym7W/zSfl9sqau4xmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jP0v3qxLNuk9o4CZrzXvTYdB/6kBanoXKUmOKzQmPwlz7vgUmZo5ydgLaIHERinrXfIhaUQUWNOiucLakpl1k3IZg6JZPu/FxrWGJp+szXh4TVNXZiJOo08RU1cSnbGDIpl2oVKyb+PF4cM0r6JGtLjIH4COELS8CSCZ1ONDnkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N+VCAIIA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9698C4CEDD;
	Tue,  3 Sep 2024 04:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336036;
	bh=vtgBTd6vd/L2FWYI0DggGWm8tym7W/zSfl9sqau4xmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+VCAIIAoMVWD+yTyCkDyZ3+nb7cVSghlmDVqbcYNurS5qGuguq+jwhtOHvCftrRY
	 FyEGrGN47ecW1XXQbyDJZvJtX1sAbK9u0xmS6JncXbX8LYF1jVRkBFlEEfWsvTS3VE
	 PADL1VkwjmpgXsAN7+G1onViFB8C29idwlRD869qfSEjA/iZQ1bnlqIjj+7r/FO3No
	 M3dJQat/b21noJYdUnoaUBaGxzNOBy95fRQHN7J4tXZg8jBb9xFiNR5V3n0ztHToHK
	 03LVcBt4MMr9goITh3dZseyg4RMfIPSkM0UUCN5DY92NRKZQyty0jBy2tMVWyoHRiX
	 vAr9qHJesMAfA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: [RFC 14/31] objtool: Refactor add_jump_destinations()
Date: Mon,  2 Sep 2024 20:59:57 -0700
Message-ID: <408f39264cbe936b397b59c0a28dc34b92c15703.1725334260.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The logic is a bit weird - simplify it.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 239 ++++++++++++++++++++----------------------
 1 file changed, 114 insertions(+), 125 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 9212b5edffc8..6490bc939892 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1479,9 +1479,14 @@ static void add_return_call(struct objtool_file *file, struct instruction *insn,
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
@@ -1489,50 +1494,30 @@ static bool is_first_func_insn(struct objtool_file *file,
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
-	if (is_notype_symbol(ts))
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
+		struct instruction *dest_insn;
+		struct section *dest_sec = NULL;
+		struct symbol *dest_sym = NULL;
+		unsigned long dest_off;
+
+		if (!is_static_jump(insn))
+			continue;
+
 		if (insn->jump_dest) {
 			/*
 			 * handle_group_alt() may have previously set
@@ -1540,114 +1525,118 @@ static int add_jump_destinations(struct objtool_file *file)
 			 */
 			continue;
 		}
-		if (!is_static_jump(insn))
-			continue;
 
 		reloc = insn_reloc(file, insn);
 		if (!reloc) {
 			dest_sec = insn->sec;
 			dest_off = arch_jump_destination(insn);
-		} else if (is_section_symbol(reloc->sym)) {
-			dest_sec = reloc->sym->sec;
-			dest_off = arch_dest_reloc_offset(reloc_addend(reloc));
-		} else if (reloc->sym->retpoline_thunk) {
-			add_retpoline_call(file, insn);
-			continue;
-		} else if (reloc->sym->return_thunk) {
-			add_return_call(file, insn, true);
-			continue;
-		} else if (insn_func(insn)) {
-			/*
-			 * External sibling call or internal sibling call with
-			 * STT_FUNC reloc.
-			 */
-			add_call_dest(file, insn, reloc->sym, true);
-			continue;
-		} else if (reloc->sym->sec->idx) {
+		} else if (sym_has_section(reloc->sym)) {
 			dest_sec = reloc->sym->sec;
 			dest_off = reloc->sym->sym.st_value +
 				   arch_dest_reloc_offset(reloc_addend(reloc));
 		} else {
-			/* non-func asm code jumping to another file */
+			/* External symbol (UNDEF) */
+			dest_sec = NULL;
+			dest_sym = reloc->sym;
+		}
+
+		if (!dest_sym) {
+			dest_insn = find_insn(file, dest_sec, dest_off);
+
+			if (!dest_insn) {
+				struct symbol *sym = find_symbol_by_offset(dest_sec, dest_off);
+
+				/*
+				 * This is a special case for retbleed_untrain_ret().
+				 * It jumps to __x86_return_thunk(), but objtool
+				 * can't find the thunk's starting RET
+				 * instruction, because the RET is also in the
+				 * middle of another instruction.  Objtool only
+				 * knows about the outer instruction.
+				 */
+				if (sym && sym->embedded_insn) {
+					add_return_call(file, insn, false);
+					continue;
+				}
+
+				WARN_INSN(insn, "can't find jump dest instruction at %s+0x%lx",
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
+			add_retpoline_call(file, insn);
 			continue;
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
-			WARN_INSN(insn, "can't find jump dest instruction at %s+0x%lx",
-				  dest_sec->name, dest_off);
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
-				add_retpoline_call(file, insn);
-				continue;
-			}
-			if (jump_dest->sym->return_thunk) {
-				add_return_call(file, insn, true);
-				continue;
-			}
-		}
-
-		/*
-		 * Cross-function jump.
-		 */
-		if (insn_func(insn) && insn_func(jump_dest) &&
-		    insn_func(insn) != insn_func(jump_dest)) {
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
-			if (!strstr(insn_func(insn)->name, ".cold") &&
-			    strstr(insn_func(jump_dest)->name, ".cold")) {
-				insn_func(insn)->cfunc = insn_func(jump_dest);
-				insn_func(jump_dest)->pfunc = insn_func(insn);
-			}
-		}
-
-		if (jump_is_sibling_call(file, insn, jump_dest)) {
-			/*
-			 * Internal sibling call without reloc or with
-			 * STT_SECTION reloc.
-			 */
-			add_call_dest(file, insn, insn_func(jump_dest), true);
+		if (dest_sym->return_thunk) {
+			add_return_call(file, insn, true);
 			continue;
 		}
 
-		insn->jump_dest = jump_dest;
+		if (!dest_sec) {
+			/* External symbol */
+			if (insn_func(insn)) {
+				/* External sibling call */
+				add_call_dest(file, insn, dest_sym, true);
+				continue;
+			}
+
+			/* Non-func asm code jumping to external symbol */
+			continue;
+		}
+
+		if (!insn_func(insn) && insn_func(dest_insn)) {
+			/*
+			 * Switching from non-func asm to func - force
+			 * validate_branch() to stop.
+			 */
+			continue;
+		}
+
+		if (!insn_func(insn) || !insn_func(dest_insn) ||
+		    insn_func(insn) == insn_func(dest_insn))
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
+		if (!strstr(insn_func(insn)->name, ".cold") &&
+		    strstr(insn_func(dest_insn)->name, ".cold")) {
+			insn_func(insn)->cfunc = insn_func(dest_insn);
+			insn_func(dest_insn)->pfunc = insn_func(insn);
+			goto set_jump_dest;
+		}
+
+		if (is_first_func_insn(file, dest_insn)) {
+			/* Internal sibling call */
+			add_call_dest(file, insn, insn_func(dest_insn), true);
+			continue;
+		}
+
+set_jump_dest:
+		insn->jump_dest = dest_insn;
 	}
 
 	return 0;
-- 
2.45.2


