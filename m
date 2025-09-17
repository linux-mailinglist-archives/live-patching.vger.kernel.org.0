Return-Path: <live-patching+bounces-1684-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15E2BB80DFA
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:11:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 008E9543DAE
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:09:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FFB1321263;
	Wed, 17 Sep 2025 16:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C0fNLhy8"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D9D3002A1;
	Wed, 17 Sep 2025 16:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125077; cv=none; b=e5Nl591saESTt0jJORWWAZBuhtKNHMA1LcnEv51HhqH+zJ2C51yCYbdMoSByUKEhnWVy7Efqj5uMJIlWyU/B3HCvsWQIxjM+0kl1MR2P5huErRjdeb/r5/DAtM0gqNogHvyN2k5n7zWcUM/bFHk0dYHngvl113wAjNGriTRf7kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125077; c=relaxed/simple;
	bh=8IBcIu0hAuxL0M+p+j4ZNveueE6OaVmfEaVArLMztpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3CkzDyvQBsgjFkB5WeWOuLQgasuKO3V+2oq7ZaDQybcraEiAF7ou799ZGopQWJokCCZuGAtLIyLJuUtGzqF5Xx2iBb2Wb5ZEoya07hIxh+nIHKuPPu6Nf2vsBMnC/Uh2ViFsjl3lC7uVrV0P+d4z11VVZyBZK3NZGh4W7S/F6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C0fNLhy8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63933C4CEFB;
	Wed, 17 Sep 2025 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125076;
	bh=8IBcIu0hAuxL0M+p+j4ZNveueE6OaVmfEaVArLMztpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0fNLhy8JCXVGSwdzWNcXPkt0oOx3RyonFokZ/CipqMI2wD4MxiHyk/k5vVGO3wSn
	 JN8gljufeQ+8k3ULOPzVugEv/u6RQs80J965Qzj0Mwke3fxoUUhmiIqOvCpKArbTaE
	 PR++BQKGTmtX8Yz36NdUOUJqGNNNPDuLwrvZpdf4jWfIKx8gugSc75ak3rIGV96/M4
	 XPyZQgT/L4AppZUZBRjF712FeQpr0W4F4n0+Vr3wwKkDcZj5AtXhPhROjKIhILwl7h
	 QIxyITiP3q7UuT8rt2HZFdHYkpBRLlXMR4FAyPCSf8whB3eGhoCCX1O/hkFccKuFDw
	 xUb1CgqJeRlww==
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
Subject: [PATCH v4 29/63] objtool: Mark .cold subfunctions
Date: Wed, 17 Sep 2025 09:03:37 -0700
Message-ID: <40d9bc230e6c78d25d03f5258a89b72504171095.1758067943.git.jpoimboe@kernel.org>
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

Introduce a flag to identify .cold subfunctions so they can be detected
easier and faster.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c               | 14 ++++++--------
 tools/objtool/elf.c                 | 19 ++++++++++---------
 tools/objtool/include/objtool/elf.h |  1 +
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 165ea9b0fdca5..b548bc8146ce8 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1575,7 +1575,9 @@ static int add_jump_destinations(struct objtool_file *file)
 		/*
 		 * Cross-function jump.
 		 */
-		if (func && insn_func(jump_dest) && func != insn_func(jump_dest)) {
+
+		if (func && insn_func(jump_dest) && !func->cold &&
+		    insn_func(jump_dest)->cold) {
 
 			/*
 			 * For GCC 8+, create parent/child links for any cold
@@ -1592,11 +1594,8 @@ static int add_jump_destinations(struct objtool_file *file)
 			 * case where the parent function's only reference to a
 			 * subfunction is through a jump table.
 			 */
-			if (!strstr(func->name, ".cold") &&
-			    strstr(insn_func(jump_dest)->name, ".cold")) {
-				func->cfunc = insn_func(jump_dest);
-				insn_func(jump_dest)->pfunc = func;
-			}
+			func->cfunc = insn_func(jump_dest);
+			insn_func(jump_dest)->pfunc = func;
 		}
 
 		if (jump_is_sibling_call(file, insn, jump_dest)) {
@@ -4075,9 +4074,8 @@ static bool ignore_unreachable_insn(struct objtool_file *file, struct instructio
 			 * If this hole jumps to a .cold function, mark it ignore too.
 			 */
 			if (insn->jump_dest && insn_func(insn->jump_dest) &&
-			    strstr(insn_func(insn->jump_dest)->name, ".cold")) {
+			    insn_func(insn->jump_dest)->cold)
 				insn_func(insn->jump_dest)->ignore = true;
-			}
 		}
 
 		return false;
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index d36c0d42fd7ba..59568381486c9 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -441,6 +441,10 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 	list_add(&sym->list, entry);
 	elf_hash_add(symbol, &sym->hash, sym->idx);
 	elf_hash_add(symbol_name, &sym->name_hash, str_hash(sym->name));
+
+	if (is_func_sym(sym) && strstr(sym->name, ".cold"))
+		sym->cold = 1;
+	sym->pfunc = sym->cfunc = sym;
 }
 
 static int read_symbols(struct elf *elf)
@@ -527,18 +531,15 @@ static int read_symbols(struct elf *elf)
 		sec_for_each_sym(sec, sym) {
 			char *pname;
 			size_t pnamelen;
-			if (!is_func_sym(sym))
+
+			if (!sym->cold)
 				continue;
 
-			if (sym->pfunc == NULL)
-				sym->pfunc = sym;
-
-			if (sym->cfunc == NULL)
-				sym->cfunc = sym;
-
 			coldstr = strstr(sym->name, ".cold");
-			if (!coldstr)
-				continue;
+			if (!coldstr) {
+				ERROR("%s(): cold subfunction without \".cold\"?", sym->name);
+				return -1;
+			}
 
 			pnamelen = coldstr - sym->name;
 			pname = strndup(sym->name, pnamelen);
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index f2dbcaa42a9c9..dbadcc88a3b26 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -72,6 +72,7 @@ struct symbol {
 	u8 frame_pointer     : 1;
 	u8 ignore	     : 1;
 	u8 nocfi             : 1;
+	u8 cold		     : 1;
 	struct list_head pv_target;
 	struct reloc *relocs;
 	struct section *group_sec;
-- 
2.50.0


