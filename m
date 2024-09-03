Return-Path: <live-patching+bounces-561-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B8D59692A0
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:05:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F83A1C227EE
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:05:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E4781DAC4A;
	Tue,  3 Sep 2024 04:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rAdGF1dJ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2231D6DD4;
	Tue,  3 Sep 2024 04:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336043; cv=none; b=fGN2/kUwTwugriaGHbZ1BjbmX40N52UoL0G05dGMGeU+H4CeTxZ4BO2GhyCcIloXmQoRQmO9ghwe81DsV02JgNTFL5zVKU9qcePyB/EfUfz+1Kl/hUZXlktDEefQxhFa8S8L+DFYCcb6yBKiNABqdLKx6qFXu3kew4DR9GCdBbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336043; c=relaxed/simple;
	bh=MTklontumUzZpdX06cPRFX4LLGHwOyI3SJ4gnMlG+5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqwzY9xM7rafhHguzCaXBP4toq0YjqJaiP9uEZLx/o3peBda8mLwJQt8IOsbJO8F81+PANKNq2T7xDkStt8DonOwe1dkns65Hgie/R8TDUYEJiesyAFB0a76Y6dsb9kEZqdwFigcbVb4MsWY9BrJ3QLr108WENgbXRpvCUZ7HFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rAdGF1dJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95CAC4CED0;
	Tue,  3 Sep 2024 04:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336043;
	bh=MTklontumUzZpdX06cPRFX4LLGHwOyI3SJ4gnMlG+5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rAdGF1dJMDPP8zNlF+p8n1XV4xPxBRGG/Bv+Jb2iJvdB2xHaW56BCDxCYbIi7wPkB
	 Zpdso/ZPTLOygEdTCJ0rYCQLE3bsbIj1G/V+e9CKbRgmH6OTf6gArRvo2pIKeRsfst
	 +sLQyLP3qW6Wfm7ueZsVuLtwCDYSz8ykT/ZZ0r2Mm7qQ9joroZ3bnmuTUg+b1cUCb1
	 pQmObfe8HyBxpZisGhJYtpgRWE+21KPuEZe9elZpOpfdCJ8dbHGDeoK8ui1lWd5Uly
	 O78nrLS+ktGnjWK2S6oIZRSfBC9r8s3o0S+Ck5O9hdoruGb/wNStbZKK1j9Yh6ei6q
	 VvXfGR1o+DDqw==
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
Subject: [RFC 27/31] objtool: Fix weak symbol detection
Date: Mon,  2 Sep 2024 21:00:10 -0700
Message-ID: <bcedaf8559e7e276e4d9ba511dab038ed70ebd6c.1725334260.git.jpoimboe@kernel.org>
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

find_symbol_hole_containing() fails to find a symbol hole (aka stripped
weak symbol) if its section has no symbols before the hole.  This breaks
weak symbol detection if -ffunction-sections is enabled.

Fix it by allowing the interval tree to contain section symbols, which
are always at offset zero for a given section.

Fixes a bunch of (-ffunction-sections) warnings like:

  vmlinux.o: warning: objtool: .text.__x64_sys_io_setup+0x10: unreachable instruction
  vmlinux.o: warning: objtool: .text.__x64_sys_io_setup+0x14: unreachable instruction
  vmlinux.o: warning: objtool: .text.__x64_sys_io_setup+0x19: unreachable instruction
  vmlinux.o: warning: objtool: .text.__x64_sys_io_setup+0x20: unreachable instruction

Fixes: 4adb23686795 ("objtool: Ignore extra-symbol code")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 471df0336aa7..3109277804cc 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -110,7 +110,7 @@ struct symbol_hole {
 };
 
 /*
- * Find !section symbol where @offset is after it.
+ * Find the last symbol before @offset.
  */
 static int symbol_hole_by_offset(const void *key, const struct rb_node *node)
 {
@@ -121,8 +121,7 @@ static int symbol_hole_by_offset(const void *key, const struct rb_node *node)
 		return -1;
 
 	if (sh->offset >= s->offset + s->len) {
-		if (s->type != STT_SECTION)
-			sh->sym = s;
+		sh->sym = s;
 		return 1;
 	}
 
@@ -416,7 +415,8 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 	sym->len = sym->sym.st_size;
 
 	__sym_for_each(s, &sym->sec->symbol_tree, sym->offset, sym->offset) {
-		if (s->offset == sym->offset && s->type == sym->type)
+		if (s->type == sym->type && s->offset == sym->offset &&
+		    s->len == sym->len)
 			s->alias = sym;
 	}
 
@@ -433,9 +433,13 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 	/*
 	 * Don't store empty STT_NOTYPE symbols in the rbtree.  They
 	 * can exist within a function, confusing the sorting.
+	 *
+	 * TODO: is this still true?
 	 */
-	if (!sym->len)
+#if 0
+	if (sym->type == STT_NOTYPE && !sym->len)
 		__sym_remove(sym, &sym->sec->symbol_tree);
+#endif
 }
 
 static void read_symbols(struct elf *elf)
-- 
2.45.2


