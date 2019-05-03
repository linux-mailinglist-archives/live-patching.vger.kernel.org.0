Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFB212F0E
	for <lists+live-patching@lfdr.de>; Fri,  3 May 2019 15:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfECN0l (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 May 2019 09:26:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:59776 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726679AbfECN0k (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 May 2019 09:26:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8B3E9AE8B;
        Fri,  3 May 2019 13:26:38 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        "Tobin C . Harding" <tobin@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH 1/2] livepatch: Remove custom kobject state handling
Date:   Fri,  3 May 2019 15:26:24 +0200
Message-Id: <20190503132625.23442-2-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190503132625.23442-1-pmladek@suse.com>
References: <20190503132625.23442-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

kobject_init() always succeeds and sets the reference count to 1.
It allows to always free the structures via kobject_put() and
the related release callback.

Note that the custom kobject state handling was used only
because we did not know that kobject_put() can and actually
should get called even when kobject_init_and_add() fails.

The patch should not change the existing behavior.

Suggested-by: "Tobin C. Harding" <tobin@kernel.org>
Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/livepatch.h |  3 ---
 kernel/livepatch/core.c   | 56 ++++++++++++++---------------------------------
 2 files changed, 17 insertions(+), 42 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 53551f470722..a14bab1a0a3e 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -86,7 +86,6 @@ struct klp_func {
 	struct list_head node;
 	struct list_head stack_node;
 	unsigned long old_size, new_size;
-	bool kobj_added;
 	bool nop;
 	bool patched;
 	bool transition;
@@ -141,7 +140,6 @@ struct klp_object {
 	struct list_head func_list;
 	struct list_head node;
 	struct module *mod;
-	bool kobj_added;
 	bool dynamic;
 	bool patched;
 };
@@ -170,7 +168,6 @@ struct klp_patch {
 	struct list_head list;
 	struct kobject kobj;
 	struct list_head obj_list;
-	bool kobj_added;
 	bool enabled;
 	bool forced;
 	struct work_struct free_work;
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index eb0ee10a1981..1ff91f7cbafb 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -426,6 +426,9 @@ static void klp_free_object_dynamic(struct klp_object *obj)
 	kfree(obj);
 }
 
+static struct kobj_type klp_ktype_object;
+static struct kobj_type klp_ktype_func;
+
 static struct klp_object *klp_alloc_object_dynamic(const char *name)
 {
 	struct klp_object *obj;
@@ -443,6 +446,7 @@ static struct klp_object *klp_alloc_object_dynamic(const char *name)
 	}
 
 	INIT_LIST_HEAD(&obj->func_list);
+	kobject_init(&obj->kobj, &klp_ktype_object);
 	obj->dynamic = true;
 
 	return obj;
@@ -471,6 +475,7 @@ static struct klp_func *klp_alloc_func_nop(struct klp_func *old_func,
 		}
 	}
 
+	kobject_init(&func->kobj, &klp_ktype_func);
 	/*
 	 * func->new_func is same as func->old_func. These addresses are
 	 * set when the object is loaded, see klp_init_object_loaded().
@@ -588,13 +593,7 @@ static void __klp_free_funcs(struct klp_object *obj, bool nops_only)
 			continue;
 
 		list_del(&func->node);
-
-		/* Might be called from klp_init_patch() error path. */
-		if (func->kobj_added) {
-			kobject_put(&func->kobj);
-		} else if (func->nop) {
-			klp_free_func_nop(func);
-		}
+		kobject_put(&func->kobj);
 	}
 }
 
@@ -624,13 +623,7 @@ static void __klp_free_objects(struct klp_patch *patch, bool nops_only)
 			continue;
 
 		list_del(&obj->node);
-
-		/* Might be called from klp_init_patch() error path. */
-		if (obj->kobj_added) {
-			kobject_put(&obj->kobj);
-		} else if (obj->dynamic) {
-			klp_free_object_dynamic(obj);
-		}
+		kobject_put(&obj->kobj);
 	}
 }
 
@@ -675,10 +668,8 @@ static void klp_free_patch_finish(struct klp_patch *patch)
 	 * this is called when the patch gets disabled and it
 	 * cannot get enabled again.
 	 */
-	if (patch->kobj_added) {
-		kobject_put(&patch->kobj);
-		wait_for_completion(&patch->finish);
-	}
+	kobject_put(&patch->kobj);
+	wait_for_completion(&patch->finish);
 
 	/* Put the module after the last access to struct klp_patch. */
 	if (!patch->forced)
@@ -700,8 +691,6 @@ static void klp_free_patch_work_fn(struct work_struct *work)
 
 static int klp_init_func(struct klp_object *obj, struct klp_func *func)
 {
-	int ret;
-
 	if (!func->old_name)
 		return -EINVAL;
 
@@ -724,13 +713,9 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
 	 * object. If the user selects 0 for old_sympos, then 1 will be used
 	 * since a unique symbol will be the first occurrence.
 	 */
-	ret = kobject_init_and_add(&func->kobj, &klp_ktype_func,
-				   &obj->kobj, "%s,%lu", func->old_name,
-				   func->old_sympos ? func->old_sympos : 1);
-	if (!ret)
-		func->kobj_added = true;
-
-	return ret;
+	return kobject_add(&func->kobj, &obj->kobj, "%s,%lu",
+			   func->old_name,
+			   func->old_sympos ? func->old_sympos : 1);
 }
 
 /* Arches may override this to finish any remaining arch-specific tasks */
@@ -801,11 +786,9 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
 	klp_find_object_module(obj);
 
 	name = klp_is_module(obj) ? obj->name : "vmlinux";
-	ret = kobject_init_and_add(&obj->kobj, &klp_ktype_object,
-				   &patch->kobj, "%s", name);
+	ret = kobject_add(&obj->kobj, &patch->kobj, "%s", name);
 	if (ret)
 		return ret;
-	obj->kobj_added = true;
 
 	klp_for_each_func(obj, func) {
 		ret = klp_init_func(obj, func);
@@ -829,7 +812,7 @@ static int klp_init_patch_early(struct klp_patch *patch)
 
 	INIT_LIST_HEAD(&patch->list);
 	INIT_LIST_HEAD(&patch->obj_list);
-	patch->kobj_added = false;
+	kobject_init(&patch->kobj, &klp_ktype_patch);
 	patch->enabled = false;
 	patch->forced = false;
 	INIT_WORK(&patch->free_work, klp_free_patch_work_fn);
@@ -840,11 +823,11 @@ static int klp_init_patch_early(struct klp_patch *patch)
 			return -EINVAL;
 
 		INIT_LIST_HEAD(&obj->func_list);
-		obj->kobj_added = false;
+		kobject_init(&obj->kobj, &klp_ktype_object);
 		list_add_tail(&obj->node, &patch->obj_list);
 
 		klp_for_each_func_static(obj, func) {
-			func->kobj_added = false;
+			kobject_init(&func->kobj, &klp_ktype_func);
 			list_add_tail(&func->node, &obj->func_list);
 		}
 	}
@@ -860,11 +843,9 @@ static int klp_init_patch(struct klp_patch *patch)
 	struct klp_object *obj;
 	int ret;
 
-	ret = kobject_init_and_add(&patch->kobj, &klp_ktype_patch,
-				   klp_root_kobj, "%s", patch->mod->name);
+	ret = kobject_add(&patch->kobj, klp_root_kobj, "%s", patch->mod->name);
 	if (ret)
 		return ret;
-	patch->kobj_added = true;
 
 	if (patch->replace) {
 		ret = klp_add_nops(patch);
@@ -926,9 +907,6 @@ static int __klp_enable_patch(struct klp_patch *patch)
 	if (WARN_ON(patch->enabled))
 		return -EINVAL;
 
-	if (!patch->kobj_added)
-		return -EINVAL;
-
 	pr_notice("enabling patch '%s'\n", patch->mod->name);
 
 	klp_init_transition(patch, KLP_PATCHED);
-- 
2.16.4

