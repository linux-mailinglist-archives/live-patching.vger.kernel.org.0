Return-Path: <live-patching+bounces-1386-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43432AB1DFB
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:22:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A48AA077F3
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33D80278170;
	Fri,  9 May 2025 20:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="an0/2ltE"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F3A276024;
	Fri,  9 May 2025 20:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821884; cv=none; b=u32Dfk4jGUyoDb/x5f3Sl0mdN6eFD6AbSIBnmLNib6VOnxYeOGIx1+RXFhkMiYy4AUat86H0p1YfxXQAHEDJqWNC9oRpBsuG3g9N7BVQsotDHqLkw0itflgssjofp9VQj6ftSkE7SsVpHMjBPftcTcJs3Lx6S+TCWKQXHeA8ZxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821884; c=relaxed/simple;
	bh=nG0D1Th2MfRsPa/QSsPxSzVCpK+SaAFbpW1WnLuhvFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulCEgOsTyAkazBkPheD+UpgvFL300lw0F7KD2vnTj4qYZ2SGyDlkHK/adPR86S6We28o+fe3+8iqmjgtA5zfHzpCJWkWCWnU4+PWrhrg79DR8WuC8POLi5Z037P3V4vS8VD/492Dtd4eiOu/geeuSl52H6qsJ9rXCFXTzAlWRWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=an0/2ltE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CAF6C4CEE9;
	Fri,  9 May 2025 20:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821883;
	bh=nG0D1Th2MfRsPa/QSsPxSzVCpK+SaAFbpW1WnLuhvFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=an0/2ltEMaxftommRLf1wOOrhLwoqcPyXA1fOgV7HMYo6xQU1YbrR24U9/6+g46xT
	 ewWdvQwOo4DsURWQdhv/N3g6T8uaf3s1G19yAJG/ODSlT4DAwz5e0kvWm2rdWhF4Yu
	 ctjyz4dzMo4PQFdKQBkCSi/G8jrxT8thNUoWDZcEhAs+cyl0gh3nTb+UmUSRXvrUea
	 gSo7wgMAIpsB0No8KqRAIw5QNU3LQKGLY3guWOijVk3dJqwfMOwVKklzKc0PKM/zdI
	 ZPlPO3oS2Qf3kmKLUUBRlgeEkJszVgQsBCWhoZJyknIGVh/xkRJDluzVQN5l6aZH7e
	 JKnbFJXNDqnHg==
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
Subject: [PATCH v2 27/62] objtool: Mark .cold subfunctions
Date: Fri,  9 May 2025 13:16:51 -0700
Message-ID: <d67ebbcb2d1da07b08ba3e2d43339b857a874b40.1746821544.git.jpoimboe@kernel.org>
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

Introduce a flag to identify .cold subfunctions so they can be detected
easier and faster.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c               | 14 ++++++--------
 tools/objtool/elf.c                 | 19 ++++++++++---------
 tools/objtool/include/objtool/elf.h |  1 +
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index d53438865d68..043c36b70f26 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1581,7 +1581,9 @@ static int add_jump_destinations(struct objtool_file *file)
 		/*
 		 * Cross-function jump.
 		 */
-		if (func && insn_func(jump_dest) && func != insn_func(jump_dest)) {
+
+		if (func && insn_func(jump_dest) && !func->cold &&
+		    insn_func(jump_dest)->cold) {
 
 			/*
 			 * For GCC 8+, create parent/child links for any cold
@@ -1598,11 +1600,8 @@ static int add_jump_destinations(struct objtool_file *file)
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
@@ -4066,9 +4065,8 @@ static bool ignore_unreachable_insn(struct objtool_file *file, struct instructio
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
index d36c0d42fd7b..59568381486c 100644
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
index 0914dadece0b..f41496b0ad8f 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -71,6 +71,7 @@ struct symbol {
 	u8 local_label       : 1;
 	u8 frame_pointer     : 1;
 	u8 ignore	     : 1;
+	u8 cold		     : 1;
 	struct list_head pv_target;
 	struct reloc *relocs;
 	struct section *group_sec;
-- 
2.49.0


