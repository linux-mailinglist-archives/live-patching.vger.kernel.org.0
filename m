Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBC0E140D5A
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbgAQPEn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:04:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:46312 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729117AbgAQPEB (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:04:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1E0A8BBA3;
        Fri, 17 Jan 2020 15:03:59 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 11/23] livepatch: Safely detect forced transition when removing split livepatch modules
Date:   Fri, 17 Jan 2020 16:03:11 +0100
Message-Id: <20200117150323.21801-12-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The information about forced livepatch transition is currently stored
in struct klp_patch. But there is not any obvious safe way how to
access it when the split livepatch modules are removed.

module_put() for the livepatch module must be called only when neither
the code nor the data are accessed. The best location is
klp_kobj_release_object(). It can be called asynchronously when
the kobject hierarchy is already destroyed and struct klp_patch might
already be gone.

Solve this by moving the "force" flag into struct klp_object.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/livepatch.h     |  4 ++--
 kernel/livepatch/core.c       | 11 ++++++++---
 kernel/livepatch/transition.c |  8 ++++++--
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index feb33f023f9f..e021e512b207 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -114,6 +114,7 @@ struct klp_callbacks {
  * @node:	list node for klp_patch obj_list
  * @dynamic:    temporary object for nop functions; dynamically allocated
  * @patched:	the object's funcs have been added to the klp_ops list
+ * @forced:	was involved in a forced transition
  */
 struct klp_object {
 	/* external */
@@ -129,6 +130,7 @@ struct klp_object {
 	struct list_head node;
 	bool dynamic;
 	bool patched;
+	bool forced;
 };
 
 /**
@@ -154,7 +156,6 @@ struct klp_state {
  * @kobj:	kobject for sysfs resources
  * @obj_list:	dynamic list of the object entries
  * @enabled:	the patch is enabled (but operation may be incomplete)
- * @forced:	was involved in a forced transition
  * ts:		timestamp when the livepatch has been loaded
  * @free_work:	patch cleanup from workqueue-context
  * @finish:	for waiting till it is safe to remove the patch module
@@ -171,7 +172,6 @@ struct klp_patch {
 	struct kobject kobj;
 	struct list_head obj_list;
 	bool enabled;
-	bool forced;
 	u64 ts;
 	struct work_struct free_work;
 	struct completion finish;
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 19ca8baa2f16..2f15ff360676 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -551,8 +551,13 @@ static void klp_kobj_release_object(struct kobject *kobj)
 
 	obj = container_of(kobj, struct klp_object, kobj);
 
-	if (obj->dynamic)
+	if (obj->dynamic) {
 		klp_free_object_dynamic(obj);
+		return;
+	}
+
+	if (klp_is_module(obj) && !obj->forced)
+		module_put(obj->mod);
 }
 
 static struct kobj_type klp_ktype_object = {
@@ -668,7 +673,7 @@ static void klp_free_patch_finish(struct klp_patch *patch)
 	wait_for_completion(&patch->finish);
 
 	/* Put the module after the last access to struct klp_patch. */
-	if (!patch->forced)
+	if (!patch->obj->forced)
 		module_put(patch->obj->mod);
 }
 
@@ -829,6 +834,7 @@ static int klp_init_object_early(struct klp_patch *patch,
 	INIT_LIST_HEAD(&obj->func_list);
 	kobject_init(&obj->kobj, &klp_ktype_object);
 	list_add_tail(&obj->node, &patch->obj_list);
+	obj->forced = false;
 
 	klp_for_each_func_static(obj, func) {
 		klp_init_func_early(obj, func);
@@ -854,7 +860,6 @@ static int klp_init_patch_early(struct klp_patch *patch)
 	INIT_LIST_HEAD(&patch->obj_list);
 	kobject_init(&patch->kobj, &klp_ktype_patch);
 	patch->enabled = false;
-	patch->forced = false;
 	patch->ts = local_clock();
 	INIT_WORK(&patch->free_work, klp_free_patch_work_fn);
 	init_completion(&patch->finish);
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 78e3280560cd..e99c27a5ddbf 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -626,6 +626,7 @@ void klp_copy_process(struct task_struct *child)
 void klp_force_transition(void)
 {
 	struct klp_patch *patch;
+	struct klp_object *obj;
 	struct task_struct *g, *task;
 	unsigned int cpu;
 
@@ -639,6 +640,9 @@ void klp_force_transition(void)
 	for_each_possible_cpu(cpu)
 		klp_update_patch_state(idle_task(cpu));
 
-	klp_for_each_patch(patch)
-		patch->forced = true;
+	klp_for_each_patch(patch) {
+		klp_for_each_object(patch, obj) {
+			obj->forced = true;
+		}
+	}
 }
-- 
2.16.4

