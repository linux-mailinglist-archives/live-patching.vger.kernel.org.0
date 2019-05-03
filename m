Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8748912F10
	for <lists+live-patching@lfdr.de>; Fri,  3 May 2019 15:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbfECN0m (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 May 2019 09:26:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:59790 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727800AbfECN0m (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 May 2019 09:26:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CE623AE84;
        Fri,  3 May 2019 13:26:39 +0000 (UTC)
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
Subject: [PATCH 2/2] livepatch: Remove duplicated code for early initialization
Date:   Fri,  3 May 2019 15:26:25 +0200
Message-Id: <20190503132625.23442-3-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190503132625.23442-1-pmladek@suse.com>
References: <20190503132625.23442-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

kobject_init() call added one more operation that has to be
done when doing the early initialization of both static and
dynamic livepatch structures.

It would have been easier when the early initialization code
was not duplicated. Let's deduplicate it for future generations
of livepatching hackers.

The patch does not change the existing behavior.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/livepatch/core.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 1ff91f7cbafb..0ec6ce8691b8 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -426,10 +426,13 @@ static void klp_free_object_dynamic(struct klp_object *obj)
 	kfree(obj);
 }
 
-static struct kobj_type klp_ktype_object;
-static struct kobj_type klp_ktype_func;
+static void klp_init_func_early(struct klp_object *obj,
+				struct klp_func *func);
+static void klp_init_object_early(struct klp_patch *patch,
+				  struct klp_object *obj);
 
-static struct klp_object *klp_alloc_object_dynamic(const char *name)
+static struct klp_object *klp_alloc_object_dynamic(const char *name,
+						   struct klp_patch *patch)
 {
 	struct klp_object *obj;
 
@@ -445,8 +448,7 @@ static struct klp_object *klp_alloc_object_dynamic(const char *name)
 		}
 	}
 
-	INIT_LIST_HEAD(&obj->func_list);
-	kobject_init(&obj->kobj, &klp_ktype_object);
+	klp_init_object_early(patch, obj);
 	obj->dynamic = true;
 
 	return obj;
@@ -475,7 +477,7 @@ static struct klp_func *klp_alloc_func_nop(struct klp_func *old_func,
 		}
 	}
 
-	kobject_init(&func->kobj, &klp_ktype_func);
+	klp_init_func_early(obj, func);
 	/*
 	 * func->new_func is same as func->old_func. These addresses are
 	 * set when the object is loaded, see klp_init_object_loaded().
@@ -495,11 +497,9 @@ static int klp_add_object_nops(struct klp_patch *patch,
 	obj = klp_find_object(patch, old_obj);
 
 	if (!obj) {
-		obj = klp_alloc_object_dynamic(old_obj->name);
+		obj = klp_alloc_object_dynamic(old_obj->name, patch);
 		if (!obj)
 			return -ENOMEM;
-
-		list_add_tail(&obj->node, &patch->obj_list);
 	}
 
 	klp_for_each_func(old_obj, old_func) {
@@ -510,8 +510,6 @@ static int klp_add_object_nops(struct klp_patch *patch,
 		func = klp_alloc_func_nop(old_func, obj);
 		if (!func)
 			return -ENOMEM;
-
-		list_add_tail(&func->node, &obj->func_list);
 	}
 
 	return 0;
@@ -802,6 +800,21 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
 	return ret;
 }
 
+static void klp_init_func_early(struct klp_object *obj,
+				struct klp_func *func)
+{
+	kobject_init(&func->kobj, &klp_ktype_func);
+	list_add_tail(&func->node, &obj->func_list);
+}
+
+static void klp_init_object_early(struct klp_patch *patch,
+				  struct klp_object *obj)
+{
+	INIT_LIST_HEAD(&obj->func_list);
+	kobject_init(&obj->kobj, &klp_ktype_object);
+	list_add_tail(&obj->node, &patch->obj_list);
+}
+
 static int klp_init_patch_early(struct klp_patch *patch)
 {
 	struct klp_object *obj;
@@ -822,13 +835,10 @@ static int klp_init_patch_early(struct klp_patch *patch)
 		if (!obj->funcs)
 			return -EINVAL;
 
-		INIT_LIST_HEAD(&obj->func_list);
-		kobject_init(&obj->kobj, &klp_ktype_object);
-		list_add_tail(&obj->node, &patch->obj_list);
+		klp_init_object_early(patch, obj);
 
 		klp_for_each_func_static(obj, func) {
-			kobject_init(&func->kobj, &klp_ktype_func);
-			list_add_tail(&func->node, &obj->func_list);
+			klp_init_func_early(obj, func);
 		}
 	}
 
-- 
2.16.4

