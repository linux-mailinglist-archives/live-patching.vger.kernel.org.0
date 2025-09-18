Return-Path: <live-patching+bounces-1721-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F697B860A4
	for <lists+live-patching@lfdr.de>; Thu, 18 Sep 2025 18:30:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9B3C3A6EBE
	for <lists+live-patching@lfdr.de>; Thu, 18 Sep 2025 16:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 737A53161B3;
	Thu, 18 Sep 2025 16:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dIrF/Rw4"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C593161BE;
	Thu, 18 Sep 2025 16:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758213006; cv=none; b=gVk8RhsUyfuqotcO+Pv2zZYKDNpX+32Yaj4rfiV9VEOTexzZMG9ME4Az7qCBXwitKLQL/6fTP+5TLnl8oSIZwI56I8E6xge3rzDsT1lq2hTKNzyRvEQjZAPt8l7SJQJMi9Tvy/JqpB1v/VW/pLSnBsh4H+mK1IfjEuzMTinsSvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758213006; c=relaxed/simple;
	bh=ubValm7rlzgMmdLrVcbkXXNld9bScKMloRgBAxkvVfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A6mHs0KP8cbogH7jWFBd/2mSLuMx6xLZnBykQsgX9wDH53A8uoNXMFrSSd/GtRG8ozcAwvLlcaTlFsZd2zyWWStie6sS5km9ePQ+ewh8q37/81fv/mzgI5NBxTT43S58nI8vWF7JDFWZr1zly2KMJU9xdOAOEdTwaLiQMyNn+ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dIrF/Rw4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3EBC4CEE7;
	Thu, 18 Sep 2025 16:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758213005;
	bh=ubValm7rlzgMmdLrVcbkXXNld9bScKMloRgBAxkvVfw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dIrF/Rw4RHpHXta/5DmoQqnBMRyzvXmWxjpDpZBdT0+MxbTGyTd/h3TAoA1TPA2VK
	 ygmHFkyg6e3+7C1j481HOx0cyUHLOZK19bHeZI6wVS9MRJ8GMbYqMy6HRzt0/q2koW
	 7mDHmd1FASRPZbfnKdFb96JEHNwF6oBUwcSDdWFzuK3qt3ZFkzXFc6gYkzU01S9Hmy
	 Wqqr19fZhtgVtMoN4Dh/FMFujxcoDtokwL56CXamWKzoXjOR2Wp+5ik0+pYObLveKX
	 Izdl/MzIZKOzS7PdjJ9+f8N/NmynihqwtzdTy65KUVzWbQDpT4FfdW56ME1kOt9lVj
	 KKOV462/e75Ng==
Date: Thu, 18 Sep 2025 09:30:03 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>, 
	Miroslav Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>, 
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, 
	Jiri Kosina <jikos@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>, 
	Weinan Liu <wnliu@google.com>, Fazla Mehrab <a.mehrab@bytedance.com>, 
	Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Dylan Hatch <dylanbhatch@google.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v4.1 12/63] interval_tree: Fix ITSTATIC usage for
 *_subtree_search()
Message-ID: <hvdg4xdlxlfp4vvrvnz2pgsn3wx7ru5fh7awwkj6625bwaarwg@tabcrhouzben>
References: <cover.1758067942.git.jpoimboe@kernel.org>
 <1e0b4913420f199b3c6d2c536b849e5d79911d21.1758067942.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1e0b4913420f199b3c6d2c536b849e5d79911d21.1758067942.git.jpoimboe@kernel.org>

For consistency with the other function templates, change
_subtree_search_*() to use the user-supplied ITSTATIC rather than the
hard-coded 'static'.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
v4.1: Fixed a couple more INTERVAL_TREE_DEFINE usages.

 drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h | 4 ++++
 include/linux/interval_tree.h                          | 4 ++++
 include/linux/interval_tree_generic.h                  | 2 +-
 include/linux/mm.h                                     | 2 ++
 lib/interval_tree.c                                    | 1 +
 tools/include/linux/interval_tree_generic.h            | 2 +-
 6 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h b/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h
index 1d7fc3226bcad..cfb42a8f5768b 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h
+++ b/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h
@@ -53,6 +53,10 @@ extern void
 usnic_uiom_interval_tree_remove(struct usnic_uiom_interval_node *node,
 					struct rb_root_cached *root);
 extern struct usnic_uiom_interval_node *
+usnic_uiom_interval_tree_subtree_search(struct usnic_uiom_interval_node *node,
+					unsigned long start,
+					unsigned long last);
+extern struct usnic_uiom_interval_node *
 usnic_uiom_interval_tree_iter_first(struct rb_root_cached *root,
 					unsigned long start,
 					unsigned long last);
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
diff --git a/lib/interval_tree.c b/lib/interval_tree.c
index 324766e9bf637..9ceb084b6b4ef 100644
--- a/lib/interval_tree.c
+++ b/lib/interval_tree.c
@@ -13,6 +13,7 @@ INTERVAL_TREE_DEFINE(struct interval_tree_node, rb,
 
 EXPORT_SYMBOL_GPL(interval_tree_insert);
 EXPORT_SYMBOL_GPL(interval_tree_remove);
+EXPORT_SYMBOL_GPL(interval_tree_subtree_search);
 EXPORT_SYMBOL_GPL(interval_tree_iter_first);
 EXPORT_SYMBOL_GPL(interval_tree_iter_next);
 
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


