Return-Path: <live-patching+bounces-1666-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C958EB80D67
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:06:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D29F1C20A57
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DD7A2FB975;
	Wed, 17 Sep 2025 16:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rb2Q2JX6"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D392FB967;
	Wed, 17 Sep 2025 16:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125064; cv=none; b=aOtmkVcaMAz81uYxxxf/6xQxbh/n4rH7ErWXSjbUf5Xeun7YXT98exkXTG953KXMxD75gEx3DJhPVNw9GmmDv6VlzVxQZyC0T8GtjLBcB2OtDmA2aX5B/cVA9P6rJeZdJhDyWEFwsAvbO8H0NrSrgT4y1wYiQEnq0Bavsa/hL9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125064; c=relaxed/simple;
	bh=fdFBK3Bqt4kG/fMkIPaLswtKtwEuXDZRuj9hIgerOzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5PG+cXYJ/+zjn9ER8BaoKWLXw9VjVDFIkKIgQogD+R6XPiJc7NEazwTP8gVURTE8QJ0q845eM5oocq9D0P50QpIv+yl3u7z1h9oqlz+M3cJV3agTFntB/orVsZpfm6FGTYX8FdV15insQuH35mFlBmWzem/zZGoSEjj5MFNms0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rb2Q2JX6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EDFC4CEE7;
	Wed, 17 Sep 2025 16:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125064;
	bh=fdFBK3Bqt4kG/fMkIPaLswtKtwEuXDZRuj9hIgerOzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rb2Q2JX6TMhEDqos/fdKBkxNxZhj170NSeu+NMKHjJpJRWm8JhiNwURGm8cgbdYxR
	 7QR9mIxH16crgXejoOeGOBEJy+wu4RBytNa43FX0mWfcVL4LeNbLL3YJCIp/Fo7oSZ
	 wnOEAVoTixgJSHZs+D7BH0LQTl/p36+X4fZTicxjY/HPungfziMacBrE9QsQptWbDF
	 +tYFuE8Hj/2oPJ2xOrSc0tuZbkSYcYKmOKkox9DBWEJwcPZIOazWRKYfKlTxGMLIau
	 x0yxoivvuKgzVU02Mg7FidFYK19U+xaYRR/R3wPqGLhv1Y5XTxvAtH39c9dLaKEEPC
	 IiHrAP5QgbHLw==
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
Subject: [PATCH v4 11/63] interval_tree: Sync interval_tree_generic.h with tools
Date: Wed, 17 Sep 2025 09:03:19 -0700
Message-ID: <d73c40a8c06e86e7ee1321a273d9cfa053623ed9.1758067942.git.jpoimboe@kernel.org>
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

The following commit made an improvement to interval_tree_generic.h, but
didn't sync it to the tools copy:

  19811285784f ("lib/interval_tree: skip the check before go to the right subtree")

Sync it, and add it to objtool's sync-check.sh so they are more likely
to stay in sync going forward.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/include/linux/interval_tree_generic.h | 8 ++------
 tools/objtool/sync-check.sh                 | 1 +
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/tools/include/linux/interval_tree_generic.h b/tools/include/linux/interval_tree_generic.h
index aaa8a0767aa3a..1b400f26f63d6 100644
--- a/tools/include/linux/interval_tree_generic.h
+++ b/tools/include/linux/interval_tree_generic.h
@@ -104,12 +104,8 @@ ITPREFIX ## _subtree_search(ITSTRUCT *node, ITTYPE start, ITTYPE last)	      \
 		if (ITSTART(node) <= last) {		/* Cond1 */	      \
 			if (start <= ITLAST(node))	/* Cond2 */	      \
 				return node;	/* node is leftmost match */  \
-			if (node->ITRB.rb_right) {			      \
-				node = rb_entry(node->ITRB.rb_right,	      \
-						ITSTRUCT, ITRB);	      \
-				if (start <= node->ITSUBTREE)		      \
-					continue;			      \
-			}						      \
+			node = rb_entry(node->ITRB.rb_right, ITSTRUCT, ITRB); \
+			continue;					      \
 		}							      \
 		return NULL;	/* No match */				      \
 	}								      \
diff --git a/tools/objtool/sync-check.sh b/tools/objtool/sync-check.sh
index 81d120d054425..86d64e3ac6f73 100755
--- a/tools/objtool/sync-check.sh
+++ b/tools/objtool/sync-check.sh
@@ -16,6 +16,7 @@ arch/x86/include/asm/orc_types.h
 arch/x86/include/asm/emulate_prefix.h
 arch/x86/lib/x86-opcode-map.txt
 arch/x86/tools/gen-insn-attr-x86.awk
+include/linux/interval_tree_generic.h
 include/linux/static_call_types.h
 "
 
-- 
2.50.0


