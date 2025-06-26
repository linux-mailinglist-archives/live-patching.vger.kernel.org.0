Return-Path: <live-patching+bounces-1558-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C7D2AEAB3B
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:01:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 413BC7AF5DB
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FB59272E6A;
	Thu, 26 Jun 2025 23:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P7vioqL1"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3603D26D4EB;
	Thu, 26 Jun 2025 23:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982191; cv=none; b=qOVcKwJpM8USK2H3+JIJUZMsXT7jP9VkAzqkYvUJj0LUzZSCHg5xsRKk98ibPCP8bQJczaWYupmI1Y4kZ7RX2xwNVcB4ssqLZLaDcAjS3fVzHsI1rl+U+LOXChdxnCGT38SG0+CtFCmi7GQEQW1QRdomQ0gDkXHS/Zitc6RC4ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982191; c=relaxed/simple;
	bh=bO4smP/xzMcrDqmmuOTvfRIDsIpGarNjCmew7NQRdnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVqbw0w170MQiceDYnkKdL7mcg8fGlef6luHVww2tF6fiW1ZJF8wT9BC0ERFBqA53ZkWHNpVKkMDC9DnmFFKuGnDkf0lBqOrJWIxYOXSZ8Pe1e9sUqejoohAUH6lYdluUQvgDsb/CeWFiVaQ1vgp+bf3K/XVdLdEuYPmd95JAQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P7vioqL1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88460C4CEF1;
	Thu, 26 Jun 2025 23:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982191;
	bh=bO4smP/xzMcrDqmmuOTvfRIDsIpGarNjCmew7NQRdnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P7vioqL1cx3mIXpMFsu/D15WqKe3DHAD2CSPppI5Lt/U9SV40HDc8GaUkhndzf2am
	 njn/Ui65cM7444e21sNdhqarAvgogQH7LtNTm1cfZ1Y9CJZJKXQMrALqnDmh3H+lS7
	 F3h1apyJpEWYJzQSoWfA9iIiw7DZkGEa47MENvuzE2L2tfDB9qliEsmNJ4CtDdkixL
	 6k3mzxk6mZDBbOrC49FEAmd3c2EnI58Sf1xxct6vr9D4FLR75HYLR3HOC0re6vCqqT
	 YpJtVGpYl5BMBCpCpiXSJJY0yUhI1u5mOZVscguf14+hiA+RJi18Ke8kGPNJB7hKj8
	 V1/ctffMaTACA==
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
Subject: [PATCH v3 28/64] objtool: Fix weak symbol hole detection for .cold functions
Date: Thu, 26 Jun 2025 16:55:15 -0700
Message-ID: <9019e977fb7fb682f63cfb17954f0617a36cbd57.1750980517.git.jpoimboe@kernel.org>
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
index f76de990183d..80bafcdb42af 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2504,6 +2504,44 @@ static void mark_rodata(struct objtool_file *file)
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
@@ -2556,6 +2594,9 @@ static int decode_sections(struct objtool_file *file)
 	if (read_unwind_hints(file))
 		return -1;
 
+	/* Must be after add_jump_destinations() */
+	mark_holes(file);
+
 	/*
 	 * Must be after add_call_destinations() such that it can override
 	 * dead_end_function() marks.
@@ -3984,7 +4025,8 @@ static bool ignore_unreachable_insn(struct objtool_file *file, struct instructio
 	struct instruction *prev_insn;
 	int i;
 
-	if (insn->type == INSN_NOP || insn->type == INSN_TRAP || (func && func->ignore))
+	if (insn->type == INSN_NOP || insn->type == INSN_TRAP ||
+	    insn->hole || (func && func->ignore))
 		return true;
 
 	/*
@@ -3995,46 +4037,6 @@ static bool ignore_unreachable_insn(struct objtool_file *file, struct instructio
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
index 00fb745e7233..0f4e7ac929ef 100644
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
2.49.0


