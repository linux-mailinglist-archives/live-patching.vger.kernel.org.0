Return-Path: <live-patching+bounces-549-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA4E969287
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:03:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D33A1F23492
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 687D11D3195;
	Tue,  3 Sep 2024 04:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PXoDzT2z"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425791D2F52;
	Tue,  3 Sep 2024 04:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336037; cv=none; b=M4BskPwOHQvEsFfi3+djGaqY2YVwKviWYcCoSdgUiGekx9/Foj9OpyLefezjtOvNeVy+JLJ6PBTFcY9LobvgUUllDo3DGyiBCgsCHWdI6nNGfB10Mh+3CVgrkew9drZdZXLjMrnTcXcipf6H3v4BhKOh9UGYM9nh5vopCT7bmXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336037; c=relaxed/simple;
	bh=VgC2+j0s9bIMK+3nuQz/1Q1o5SD9/C5KSNwbSBE0sEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f67M0jmXkpKpCkw7Er2e/dkAKo2OHN7F3ZxcqEALj1MKXw/Ikv0j/UAhfgFBdwN+yvmQp+rRSKLxBMDQXHxRrTg31wf8TX6CfuB4ghfx5PeghjqGYDpAw133Ju3LR/GFyFTAkyD/KXBC+Ns/YQ1KSJ6boHhrHkbalyefdUj8wjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PXoDzT2z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E72BC4CEC9;
	Tue,  3 Sep 2024 04:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336036;
	bh=VgC2+j0s9bIMK+3nuQz/1Q1o5SD9/C5KSNwbSBE0sEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXoDzT2zkdmushDDgZReQT6xPHxRasR8St4zk0vucHQ+XRZDd3DAaAJY2Ky6Ac69n
	 2XnXTb7nnVKipAqEYu7PhDKfe0brC5Ae2SmhuTSvtUacfF2IHhBuRsT8Dhn/3uaM64
	 lf5DzsVRvqJNumVIUmH90x26XDAcO6uZ+NF26hGJ77vaVhYxKAbsqnAafvNJzdpjQ8
	 cOzaww1pE1MEjxiPiiSKum7SZRz4eTgqSbKqyzS387/KocH9GoxZc6bnTPQEXM9BSz
	 lzXh/MSv0vD6/JST6IH9NWm64dONtwjUGSsHisCHxyK1k3YBT69+ImdlqTT8/ob+pa
	 w9yP6QNZqWFBw==
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
Subject: [RFC 15/31] objtool: Interval tree cleanups
Date: Mon,  2 Sep 2024 20:59:58 -0700
Message-ID: <74b0bbc42dcbd778f14946ab600670f7d14c6c6f.1725334260.git.jpoimboe@kernel.org>
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

Change some comments and variable names to improve readability of the
interval tree code.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 50 ++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 12dbcf425321..fc76692ced2c 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -103,7 +103,7 @@ INTERVAL_TREE_DEFINE(struct symbol, node, unsigned long, __subtree_last,
 	     _iter; _iter = __sym_iter_next(_iter, (_start), (_end)))
 
 struct symbol_hole {
-	unsigned long key;
+	unsigned long offset;
 	const struct symbol *sym;
 };
 
@@ -115,10 +115,10 @@ static int symbol_hole_by_offset(const void *key, const struct rb_node *node)
 	const struct symbol *s = rb_entry(node, struct symbol, node);
 	struct symbol_hole *sh = (void *)key;
 
-	if (sh->key < s->offset)
+	if (sh->offset < s->offset)
 		return -1;
 
-	if (sh->key >= s->offset + s->len) {
+	if (sh->offset >= s->offset + s->len) {
 		if (s->type != STT_SECTION)
 			sh->sym = s;
 		return 1;
@@ -167,11 +167,11 @@ static struct symbol *find_symbol_by_index(struct elf *elf, unsigned int idx)
 struct symbol *find_symbol_by_offset(struct section *sec, unsigned long offset)
 {
 	struct rb_root_cached *tree = (struct rb_root_cached *)&sec->symbol_tree;
-	struct symbol *iter;
+	struct symbol *sym;
 
-	__sym_for_each(iter, tree, offset, offset) {
-		if (iter->offset == offset && !is_section_symbol(iter))
-			return iter;
+	__sym_for_each(sym, tree, offset, offset) {
+		if (sym->offset == offset && !is_section_symbol(sym))
+			return sym;
 	}
 
 	return NULL;
@@ -180,11 +180,11 @@ struct symbol *find_symbol_by_offset(struct section *sec, unsigned long offset)
 struct symbol *find_func_by_offset(struct section *sec, unsigned long offset)
 {
 	struct rb_root_cached *tree = (struct rb_root_cached *)&sec->symbol_tree;
-	struct symbol *iter;
+	struct symbol *sym;
 
-	__sym_for_each(iter, tree, offset, offset) {
-		if (iter->offset == offset && is_function_symbol(iter))
-			return iter;
+	__sym_for_each(sym, tree, offset, offset) {
+		if (sym->offset == offset && is_function_symbol(sym))
+			return sym;
 	}
 
 	return NULL;
@@ -209,26 +209,24 @@ struct symbol *find_symbol_containing(const struct section *sec, unsigned long o
 int find_symbol_hole_containing(const struct section *sec, unsigned long offset)
 {
 	struct symbol_hole hole = {
-		.key = offset,
+		.offset = offset,
 		.sym = NULL,
 	};
 	struct rb_node *n;
 	struct symbol *s;
 
-	/*
-	 * Find the rightmost symbol for which @offset is after it.
-	 */
+	/* Find the last symbol before @offset */
 	n = rb_find(&hole, &sec->symbol_tree.rb_root, symbol_hole_by_offset);
 
-	/* found a symbol that contains @offset */
+	/* found a symbol containing @offset */
 	if (n)
 		return 0; /* not a hole */
 
-	/* didn't find a symbol for which @offset is after it */
+	/* no symbol before @offset */
 	if (!hole.sym)
 		return 0; /* not a hole */
 
-	/* @offset >= sym->offset + sym->len, find symbol after it */
+	/* find first symbol after @offset */
 	n = rb_next(&hole.sym->node);
 	if (!n)
 		return -1; /* until end of address space */
@@ -241,11 +239,11 @@ int find_symbol_hole_containing(const struct section *sec, unsigned long offset)
 struct symbol *find_func_containing(struct section *sec, unsigned long offset)
 {
 	struct rb_root_cached *tree = (struct rb_root_cached *)&sec->symbol_tree;
-	struct symbol *iter;
+	struct symbol *sym;
 
-	__sym_for_each(iter, tree, offset, offset) {
-		if (is_function_symbol(iter))
-			return iter;
+	__sym_for_each(sym, tree, offset, offset) {
+		if (is_function_symbol(sym))
+			return sym;
 	}
 
 	return NULL;
@@ -393,7 +391,7 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 {
 	struct list_head *entry;
 	struct rb_node *pnode;
-	struct symbol *iter;
+	struct symbol *s;
 
 	INIT_LIST_HEAD(&sym->pv_target);
 	sym->alias = sym;
@@ -407,9 +405,9 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
 	sym->offset = sym->sym.st_value;
 	sym->len = sym->sym.st_size;
 
-	__sym_for_each(iter, &sym->sec->symbol_tree, sym->offset, sym->offset) {
-		if (iter->offset == sym->offset && iter->type == sym->type)
-			iter->alias = sym;
+	__sym_for_each(s, &sym->sec->symbol_tree, sym->offset, sym->offset) {
+		if (s->offset == sym->offset && s->type == sym->type)
+			s->alias = sym;
 	}
 
 	__sym_insert(sym, &sym->sec->symbol_tree);
-- 
2.45.2


