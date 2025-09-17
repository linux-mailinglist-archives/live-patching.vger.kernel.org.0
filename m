Return-Path: <live-patching+bounces-1685-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 73268B80DBE
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:09:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 347B73B6CD3
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4654B321286;
	Wed, 17 Sep 2025 16:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gn/WNrRf"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2B730102E;
	Wed, 17 Sep 2025 16:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125078; cv=none; b=U4okN4p6PcQnFva9XjzS+fZJ8Zd0x+axuN7fdh0M0DvQWCKbqKpD0EiQcy5lef1ww+6ne0JhgZqMPj2ryTQZGPIg/8LYFlAywABQZoBd5wxLB/hgkZZMufioIx//lQ4p7NsZDmiCdDl9LChk5M1lLi+yY2rkYQXH8lCY00uc9Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125078; c=relaxed/simple;
	bh=xQSTYeUn09ONDQZwxseqBe/+XJmhnM0UXq9tE3g7xzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkqFsDOi9mEvclLNycnggqWt72iA/XSkaTlGOf7AJgKDQLnZDciajhckB0el1mztWtEQBlOdlKKOknhCo53joD/De+sj78GYDeub/gcnFcCThd4hplkG5JrDuSMxJOTJSXKC43xylUNNQKvNuvanCKwkuf3h7phFhmfsPsW6dL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gn/WNrRf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17251C4CEE7;
	Wed, 17 Sep 2025 16:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125077;
	bh=xQSTYeUn09ONDQZwxseqBe/+XJmhnM0UXq9tE3g7xzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gn/WNrRfu80BPuclEpQZjKGa7C9GVLWlpIMdoGoQQjisEke7NcvZJilpZuItbViWm
	 v/OlcKh5ffr0ixVF68GU5NgdVkpwjqvSVjJOq3pKILKqhe06L5HTToU1i13u6b68Vr
	 eprtGfEherQbtFrFfKt4PrVQ9iYllxlX8cLrVF/wX9jCN4F/a4U/vr+Nl4ktPSFnoh
	 xRK1XUKU3ajVh3vSEFO1SmkYNeasPIk5DTK3nAnyxa1/ydn2VvGPudfPnKST5J7dtW
	 Ll2PvHvnRAXdbO14UG3PvW1sLecbRx1s+KXk+rSBzDYd/0uuv++QDB5LvKSNrpZipa
	 b57xLDpqqnOYw==
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
Subject: [PATCH v4 30/63] objtool: Fix weak symbol hole detection for .cold functions
Date: Wed, 17 Sep 2025 09:03:38 -0700
Message-ID: <3e334a278c98c24cf40ccef7ca931cca8b2108f0.1758067943.git.jpoimboe@kernel.org>
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

When ignore_unreachable_insn() looks for weak function holes which jump
to their .cold functions, it assumes the parent function comes before
the corresponding .cold function in the symbol table.  That's not
necessarily the case with -ffunction-sections.

Mark all the holes beforehand (including .cold functions) so the
ordering of the discovery doesn't matter.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c                 | 84 ++++++++++++++-------------
 tools/objtool/include/objtool/check.h |  3 +-
 2 files changed, 45 insertions(+), 42 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index b548bc8146ce8..57e3b0cde19f2 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2517,6 +2517,44 @@ static void mark_rodata(struct objtool_file *file)
 	file->rodata = found;
 }
 
+static void mark_holes(struct objtool_file *file)
+{
+	struct instruction *insn;
+	bool in_hole = false;
+
+	if (!opts.link)
+		return;
+
+	/*
+	 * Whole archive runs might encounter dead code from weak symbols.
+	 * This is where the linker will have dropped the weak symbol in
+	 * favour of a regular symbol, but leaves the code in place.
+	 */
+	for_each_insn(file, insn) {
+		if (insn->sym || !find_symbol_hole_containing(insn->sec, insn->offset)) {
+			in_hole = false;
+			continue;
+		}
+
+		/* Skip function padding and pfx code */
+		if (!in_hole && insn->type == INSN_NOP)
+			continue;
+
+		in_hole = true;
+		insn->hole = 1;
+
+		/*
+		 * If this hole jumps to a .cold function, mark it ignore.
+		 */
+		if (insn->jump_dest) {
+			struct symbol *dest_func = insn_func(insn->jump_dest);
+
+			if (dest_func && dest_func->cold)
+				dest_func->ignore = true;
+		}
+	}
+}
+
 static int decode_sections(struct objtool_file *file)
 {
 	mark_rodata(file);
@@ -2569,6 +2607,9 @@ static int decode_sections(struct objtool_file *file)
 	if (read_unwind_hints(file))
 		return -1;
 
+	/* Must be after add_jump_destinations() */
+	mark_holes(file);
+
 	/*
 	 * Must be after add_call_destinations() such that it can override
 	 * dead_end_function() marks.
@@ -4030,7 +4071,8 @@ static bool ignore_unreachable_insn(struct objtool_file *file, struct instructio
 	struct instruction *prev_insn;
 	int i;
 
-	if (insn->type == INSN_NOP || insn->type == INSN_TRAP || (func && func->ignore))
+	if (insn->type == INSN_NOP || insn->type == INSN_TRAP ||
+	    insn->hole || (func && func->ignore))
 		return true;
 
 	/*
@@ -4041,46 +4083,6 @@ static bool ignore_unreachable_insn(struct objtool_file *file, struct instructio
 	    !strcmp(insn->sec->name, ".altinstr_aux"))
 		return true;
 
-	/*
-	 * Whole archive runs might encounter dead code from weak symbols.
-	 * This is where the linker will have dropped the weak symbol in
-	 * favour of a regular symbol, but leaves the code in place.
-	 *
-	 * In this case we'll find a piece of code (whole function) that is not
-	 * covered by a !section symbol. Ignore them.
-	 */
-	if (opts.link && !func) {
-		int size = find_symbol_hole_containing(insn->sec, insn->offset);
-		unsigned long end = insn->offset + size;
-
-		if (!size) /* not a hole */
-			return false;
-
-		if (size < 0) /* hole until the end */
-			return true;
-
-		sec_for_each_insn_continue(file, insn) {
-			/*
-			 * If we reach a visited instruction at or before the
-			 * end of the hole, ignore the unreachable.
-			 */
-			if (insn->visited)
-				return true;
-
-			if (insn->offset >= end)
-				break;
-
-			/*
-			 * If this hole jumps to a .cold function, mark it ignore too.
-			 */
-			if (insn->jump_dest && insn_func(insn->jump_dest) &&
-			    insn_func(insn->jump_dest)->cold)
-				insn_func(insn->jump_dest)->ignore = true;
-		}
-
-		return false;
-	}
-
 	if (!func)
 		return false;
 
diff --git a/tools/objtool/include/objtool/check.h b/tools/objtool/include/objtool/check.h
index 00fb745e72339..0f4e7ac929ef0 100644
--- a/tools/objtool/include/objtool/check.h
+++ b/tools/objtool/include/objtool/check.h
@@ -64,7 +64,8 @@ struct instruction {
 	    noendbr		: 1,
 	    unret		: 1,
 	    visited		: 4,
-	    no_reloc		: 1;
+	    no_reloc		: 1,
+	    hole		: 1;
 		/* 10 bit hole */
 
 	struct alt_group *alt_group;
-- 
2.50.0


