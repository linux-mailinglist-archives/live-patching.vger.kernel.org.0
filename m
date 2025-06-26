Return-Path: <live-patching+bounces-1557-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C12A0AEAB41
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:01:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C3CF1C24D3C
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4657272815;
	Thu, 26 Jun 2025 23:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jytjy89x"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D77B27280F;
	Thu, 26 Jun 2025 23:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982190; cv=none; b=QC/UrhwkmcoLWVV6CWZUNnstSl/DGQgJIFZ5/1wf8ffketFsct4RlBNB4vIgp9KPmcP9aQeTExuBkzfhNoupFqvgnmcNEBt5NZqSSLKsnwy47B13VIcZzkdKaJX5sFazm3/RvgHY7AVUA1t19S+9Ery/7Nh4CV2Ph7EjcUysaVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982190; c=relaxed/simple;
	bh=0d7llqv3k52MPtqjIHzAdwvGvN3FdzhXn6Gr8nGOrsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qo6vEUAsW8rAbgdHn9Bqxiw4iWWXaQY71PwJiA4WujUEl8+FljS7tPkdOTlZuEjTqsN7eOZg0fwTonCa30446xYW3yGFTh0+EyHq42ED8vhuox6zOxDjSu9lCZVChCYyHbH8r6mdx7Hd8SlyiRXByYbiUarkhb3omIw9B29Eh/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jytjy89x; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2163C4CEF0;
	Thu, 26 Jun 2025 23:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982190;
	bh=0d7llqv3k52MPtqjIHzAdwvGvN3FdzhXn6Gr8nGOrsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jytjy89xZ4HJ5WNvTZVxSz0o8ZGnE4U7t2TwLkvBL933BkzqhIRdvKYMr56/hURA5
	 G3SuMqfDPLKT6jRu7Cf1/+tbJcM5oZpXxRDeIPP9u8JzNTLBSoiJHp7AoKECRd5fvQ
	 gGKauWLiZlDEP7NgDSJgrJbs9CfGUUf3ZJaYsBrkGVZ3j1L/wRW9gGlhmHZRSLuSce
	 5m9hGbzaQDRW6N1mQJx0+abn+X63qYumBkNZmzrFEv77FS+ffzE5D/DjEUMjFeHUF4
	 ije6hyn3C3n38GuaW7VCEnAgd8S7x/nfxgDYzOjxmJJQNXBATqTtTKIkuv39xK+6ZL
	 bGRx+TGezWoEw==
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
	Dylan Hatch <dylanbhatch@google.com>
Subject: [PATCH v3 27/64] objtool: Mark .cold subfunctions
Date: Thu, 26 Jun 2025 16:55:14 -0700
Message-ID: <dbba3d7d7bcf13f496f3ce6319fe5e55572b2225.1750980517.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750980516.git.jpoimboe@kernel.org>
References: <cover.1750980516.git.jpoimboe@kernel.org>
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
index b5b324bcc9fa..f76de990183d 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1574,7 +1574,9 @@ static int add_jump_destinations(struct objtool_file *file)
 		/*
 		 * Cross-function jump.
 		 */
-		if (func && insn_func(jump_dest) && func != insn_func(jump_dest)) {
+
+		if (func && insn_func(jump_dest) && !func->cold &&
+		    insn_func(jump_dest)->cold) {
 
 			/*
 			 * For GCC 8+, create parent/child links for any cold
@@ -1591,11 +1593,8 @@ static int add_jump_destinations(struct objtool_file *file)
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
@@ -4029,9 +4028,8 @@ static bool ignore_unreachable_insn(struct objtool_file *file, struct instructio
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


