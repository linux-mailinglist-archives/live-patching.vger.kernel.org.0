Return-Path: <live-patching+bounces-1667-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 41CBFB80D6D
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:06:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57E201C22C6C
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:06:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C3A62FC00A;
	Wed, 17 Sep 2025 16:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DFS8Xcrh"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BB12FC001;
	Wed, 17 Sep 2025 16:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125065; cv=none; b=CH5uuL8rvIh/hDPTud11YmeGEskyCl7h48JIRvrmahIV9G7w9fV/scm9Xp9uyr+2PnA8dtchipnx6j/ws8GY6Vk7Kw812yiZlq31WxwjSxSIU/RuD+BnPO4pRYdjXHorQE2F69mhd1Gzo1Zvmj0o+WyWV/iYdD8IoElI6ckI3+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125065; c=relaxed/simple;
	bh=byXAD7C89VjEx4gCCjvR8LWFLvWHrVOZg21KTSNPZLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8VyuC1OuoQDfISkAfzIKiZjbZq+CZ7+KIan27by0TV9vzv+Ix3VieYA+5nx+XjFO/8t8IFkk3nZmduuZ7s35W38iGNdAoWammVVmIQb4mcmeZdE/dS6rlGg6dkhvt9D95eVOX4wtUcgo5LszrXl0OBZnOy++nv2Q3eFvqpW/SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DFS8Xcrh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C06CC4AF0C;
	Wed, 17 Sep 2025 16:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125064;
	bh=byXAD7C89VjEx4gCCjvR8LWFLvWHrVOZg21KTSNPZLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFS8Xcrh5CJVG37wg/ATZ04FVjX7u+ODZjadFg4EtSXwIOztAIbAQSIUk4z1Z/LOU
	 lFyqH3i9O8JXq15C1mDtD4mCjD6wW5zCzfcTqkb7N9idIvVYSnWFTZma8RCm2H0v7N
	 h40wLYWbTuJclMa8YRa9uJWj0TxgOc2GzMN8lvuepn1y/zLHZ5USlZ3Evq3rDSqOGb
	 dT5aZp2EHWuba/z4Pzn8MPMnqKg3u+u6NIB4u4tEaVJmbIVfOivTvMirhx5lDepwLj
	 iJnv/WJ20OPkPPk2ZM9AUXJ2IDpXfy5ptw5nlQuj4067pIAA0sf74w5SpTKR2WMOye
	 SGLkg8xDuh5rA==
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
Subject: [PATCH v4 12/63] interval_tree: Fix ITSTATIC usage for *_subtree_search()
Date: Wed, 17 Sep 2025 09:03:20 -0700
Message-ID: <1e0b4913420f199b3c6d2c536b849e5d79911d21.1758067942.git.jpoimboe@kernel.org>
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

For consistency with the other function templates, change
_subtree_search_*() to use the user-supplied ITSTATIC rather than the
hard-coded 'static'.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/interval_tree.h               | 4 ++++
 include/linux/interval_tree_generic.h       | 2 +-
 include/linux/mm.h                          | 2 ++
 tools/include/linux/interval_tree_generic.h | 2 +-
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/interval_tree.h b/include/linux/interval_tree.h
index 2b8026a399064..9d5791e9f737a 100644
--- a/include/linux/interval_tree.h
+++ b/include/linux/interval_tree.h
@@ -19,6 +19,10 @@ extern void
 interval_tree_remove(struct interval_tree_node *node,
 		     struct rb_root_cached *root);
 
+extern struct interval_tree_node *
+interval_tree_subtree_search(struct interval_tree_node *node,
+			     unsigned long start, unsigned long last);
+
 extern struct interval_tree_node *
 interval_tree_iter_first(struct rb_root_cached *root,
 			 unsigned long start, unsigned long last);
diff --git a/include/linux/interval_tree_generic.h b/include/linux/interval_tree_generic.h
index 1b400f26f63d6..c5a2fed49eb0d 100644
--- a/include/linux/interval_tree_generic.h
+++ b/include/linux/interval_tree_generic.h
@@ -77,7 +77,7 @@ ITSTATIC void ITPREFIX ## _remove(ITSTRUCT *node,			      \
  *   Cond2: start <= ITLAST(node)					      \
  */									      \
 									      \
-static ITSTRUCT *							      \
+ITSTATIC ITSTRUCT *							      \
 ITPREFIX ## _subtree_search(ITSTRUCT *node, ITTYPE start, ITTYPE last)	      \
 {									      \
 	while (true) {							      \
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec75..69baa9a1e2cb4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3265,6 +3265,8 @@ void vma_interval_tree_insert_after(struct vm_area_struct *node,
 				    struct rb_root_cached *root);
 void vma_interval_tree_remove(struct vm_area_struct *node,
 			      struct rb_root_cached *root);
+struct vm_area_struct *vma_interval_tree_subtree_search(struct vm_area_struct *node,
+				unsigned long start, unsigned long last);
 struct vm_area_struct *vma_interval_tree_iter_first(struct rb_root_cached *root,
 				unsigned long start, unsigned long last);
 struct vm_area_struct *vma_interval_tree_iter_next(struct vm_area_struct *node,
diff --git a/tools/include/linux/interval_tree_generic.h b/tools/include/linux/interval_tree_generic.h
index 1b400f26f63d6..c5a2fed49eb0d 100644
--- a/tools/include/linux/interval_tree_generic.h
+++ b/tools/include/linux/interval_tree_generic.h
@@ -77,7 +77,7 @@ ITSTATIC void ITPREFIX ## _remove(ITSTRUCT *node,			      \
  *   Cond2: start <= ITLAST(node)					      \
  */									      \
 									      \
-static ITSTRUCT *							      \
+ITSTATIC ITSTRUCT *							      \
 ITPREFIX ## _subtree_search(ITSTRUCT *node, ITTYPE start, ITTYPE last)	      \
 {									      \
 	while (true) {							      \
-- 
2.50.0


