Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE811119F
	for <lists+live-patching@lfdr.de>; Thu,  2 May 2019 04:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfEBCkA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 May 2019 22:40:00 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:48095 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726152AbfEBCj7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 May 2019 22:39:59 -0400
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 May 2019 22:39:59 EDT
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 20B3E666;
        Wed,  1 May 2019 22:32:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 01 May 2019 22:32:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=bo5P5XWl/L0WIe9t4t9/24QFK0rBaVtbdxN5eo93780=; b=7NCfzxYx
        eoa8OOokjkpsHISVvye8Z341gFH7dIdSoL6qYhpBfvoKM7tCwCAH4IL2US5E0ArW
        r1PtGLiTKdvJDLo2c3qg7fuVH8j8VqSz1MDE4xIyfEZOnh0tQD6Rd4q/0Gn6wiTN
        tRs7wbSTA0/i7TYQW/MinUOVOugcovywHcVVJssm3jtQ3UkWgVlY6w5GW7LwntK1
        AX8Z+zYcXCNTGA4oYGmrekD/rF98KYsninqomnIF/3vS5StjIOEa4Bbpv3u+NAGz
        VVmbSoD9nCyd8La1XO3lskP2p1dBOGt1nELnOhjQZMfUYPUdMW1Ka8zkvATHCU63
        7PXVC5oNePazrQ==
X-ME-Sender: <xms:0lbKXKM4l1-_zgM4XqV30BXq1ENFwjJpOhPgSwiP_PEpqCF5OD7jXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieekgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfvohgsihhn
    ucevrdcujfgrrhguihhnghdfuceothhosghinheskhgvrhhnvghlrdhorhhgqeenucfkph
    epuddvuddrgeegrddvtdegrddvfeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehtohgs
    ihhnsehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:0lbKXGhrzQuOavmeR0ZS0sSsc5WUs85mDuHIbwH1tcFpUnZD07vx3A>
    <xmx:0lbKXHuZhVc4PKTq1V2sUmNHsZet52bjv_Hix5bp1FVCR9fqFcpZwA>
    <xmx:0lbKXMSv37oF9iy0rlITxL4TR2HU4YMCRImidcNqrovk0a1jxNBjoQ>
    <xmx:0lbKXKI_oJVSlRfi47cazNGVz0-SqdFILe-KMDMRxkMPqSycHVj7BA>
Received: from eros.localdomain (ppp121-44-204-235.bras1.syd2.internode.on.net [121.44.204.235])
        by mail.messagingengine.com (Postfix) with ESMTPA id 35858E4067;
        Wed,  1 May 2019 22:32:46 -0400 (EDT)
From:   "Tobin C. Harding" <tobin@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 5/5] livepatch: Do not manually track kobject initialization
Date:   Thu,  2 May 2019 12:31:42 +1000
Message-Id: <20190502023142.20139-6-tobin@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502023142.20139-1-tobin@kernel.org>
References: <20190502023142.20139-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Currently we use custom logic to track kobject initialization.  Recently
a predicate function was added to the kobject API so we now no longer
need to do this.

Use kobject API to check for initialized state of kobjects instead of
using custom logic to track state.

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 include/linux/livepatch.h |  6 ------
 kernel/livepatch/core.c   | 18 +++++-------------
 2 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 53551f470722..955d46f37b72 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -47,7 +47,6 @@
  * @stack_node:	list node for klp_ops func_stack list
  * @old_size:	size of the old function
  * @new_size:	size of the new function
- * @kobj_added: @kobj has been added and needs freeing
  * @nop:        temporary patch to use the original code again; dyn. allocated
  * @patched:	the func has been added to the klp_ops list
  * @transition:	the func is currently being applied or reverted
@@ -86,7 +85,6 @@ struct klp_func {
 	struct list_head node;
 	struct list_head stack_node;
 	unsigned long old_size, new_size;
-	bool kobj_added;
 	bool nop;
 	bool patched;
 	bool transition;
@@ -126,7 +124,6 @@ struct klp_callbacks {
  * @node:	list node for klp_patch obj_list
  * @mod:	kernel module associated with the patched object
  *		(NULL for vmlinux)
- * @kobj_added: @kobj has been added and needs freeing
  * @dynamic:    temporary object for nop functions; dynamically allocated
  * @patched:	the object's funcs have been added to the klp_ops list
  */
@@ -141,7 +138,6 @@ struct klp_object {
 	struct list_head func_list;
 	struct list_head node;
 	struct module *mod;
-	bool kobj_added;
 	bool dynamic;
 	bool patched;
 };
@@ -154,7 +150,6 @@ struct klp_object {
  * @list:	list node for global list of actively used patches
  * @kobj:	kobject for sysfs resources
  * @obj_list:	dynamic list of the object entries
- * @kobj_added: @kobj has been added and needs freeing
  * @enabled:	the patch is enabled (but operation may be incomplete)
  * @forced:	was involved in a forced transition
  * @free_work:	patch cleanup from workqueue-context
@@ -170,7 +165,6 @@ struct klp_patch {
 	struct list_head list;
 	struct kobject kobj;
 	struct list_head obj_list;
-	bool kobj_added;
 	bool enabled;
 	bool forced;
 	struct work_struct free_work;
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 98295de2172b..0b94aa5b38c9 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -590,7 +590,7 @@ static void __klp_free_funcs(struct klp_object *obj, bool nops_only)
 		list_del(&func->node);
 
 		/* Might be called from klp_init_patch() error path. */
-		if (func->kobj_added) {
+		if (kobject_is_initialized(&func->kobj)) {
 			kobject_put(&func->kobj);
 		} else if (func->nop) {
 			klp_free_func_nop(func);
@@ -626,7 +626,7 @@ static void __klp_free_objects(struct klp_patch *patch, bool nops_only)
 		list_del(&obj->node);
 
 		/* Might be called from klp_init_patch() error path. */
-		if (obj->kobj_added) {
+		if (kobject_is_initialized(&obj->kobj)) {
 			kobject_put(&obj->kobj);
 		} else if (obj->dynamic) {
 			klp_free_object_dynamic(obj);
@@ -675,7 +675,7 @@ static void klp_free_patch_finish(struct klp_patch *patch)
 	 * this is called when the patch gets disabled and it
 	 * cannot get enabled again.
 	 */
-	if (patch->kobj_added) {
+	if (kobject_is_initialized(&patch->kobj)) {
 		kobject_put(&patch->kobj);
 		wait_for_completion(&patch->finish);
 	}
@@ -729,8 +729,6 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
 				   func->old_sympos ? func->old_sympos : 1);
 	if (ret)
 		kobject_put(&func->kobj);
-	else
-		func->kobj_added = true;
 
 	return ret;
 }
@@ -809,7 +807,6 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
 		kobject_put(&obj->kobj);
 		return ret;
 	}
-	obj->kobj_added = true;
 
 	klp_for_each_func(obj, func) {
 		ret = klp_init_func(obj, func);
@@ -833,7 +830,6 @@ static int klp_init_patch_early(struct klp_patch *patch)
 
 	INIT_LIST_HEAD(&patch->list);
 	INIT_LIST_HEAD(&patch->obj_list);
-	patch->kobj_added = false;
 	patch->enabled = false;
 	patch->forced = false;
 	INIT_WORK(&patch->free_work, klp_free_patch_work_fn);
@@ -844,13 +840,10 @@ static int klp_init_patch_early(struct klp_patch *patch)
 			return -EINVAL;
 
 		INIT_LIST_HEAD(&obj->func_list);
-		obj->kobj_added = false;
 		list_add_tail(&obj->node, &patch->obj_list);
 
-		klp_for_each_func_static(obj, func) {
-			func->kobj_added = false;
+		klp_for_each_func_static(obj, func)
 			list_add_tail(&func->node, &obj->func_list);
-		}
 	}
 
 	if (!try_module_get(patch->mod))
@@ -870,7 +863,6 @@ static int klp_init_patch(struct klp_patch *patch)
 		kobject_put(&patch->kobj);
 		return ret;
 	}
-	patch->kobj_added = true;
 
 	if (patch->replace) {
 		ret = klp_add_nops(patch);
@@ -932,7 +924,7 @@ static int __klp_enable_patch(struct klp_patch *patch)
 	if (WARN_ON(patch->enabled))
 		return -EINVAL;
 
-	if (!patch->kobj_added)
+	if (kobject_is_initialized(&patch->kobj))
 		return -EINVAL;
 
 	pr_notice("enabling patch '%s'\n", patch->mod->name);
-- 
2.21.0

