Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7A2140D5D
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbgAQPEw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:04:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:46352 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729126AbgAQPEA (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:04:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8698EBBB1;
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
Subject: [POC 12/23] livepatch: Automatically remove livepatch module when the object is freed
Date:   Fri, 17 Jan 2020 16:03:12 +0100
Message-Id: <20200117150323.21801-13-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Make it easy to deal with the split livepatch modules. Remove the livepatch
modules that livepatched modules when they are no longer used.

It must be done from workqueue context to avoid deadlocks.

It must not be done when klp_add_module() fails because is called from
the livepatch module init callback. The module will not load at
all in this case.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/livepatch.h |  4 ++++
 kernel/livepatch/core.c   | 19 ++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index e021e512b207..4afb7f3a5a36 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -115,6 +115,8 @@ struct klp_callbacks {
  * @dynamic:    temporary object for nop functions; dynamically allocated
  * @patched:	the object's funcs have been added to the klp_ops list
  * @forced:	was involved in a forced transition
+ * @add_err:	failed to add the object when loading the livepatch module
+ * @remove_work: remove module from workqueue-context
  */
 struct klp_object {
 	/* external */
@@ -131,6 +133,8 @@ struct klp_object {
 	bool dynamic;
 	bool patched;
 	bool forced;
+	bool add_err;
+	struct work_struct remove_work;
 };
 
 /**
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 2f15ff360676..6c51b194da57 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -556,8 +556,14 @@ static void klp_kobj_release_object(struct kobject *kobj)
 		return;
 	}
 
-	if (klp_is_module(obj) && !obj->forced)
+	if (obj->forced || !klp_is_module(obj))
+		return;
+
+	/* Must not explicitely remove module when adding failed. */
+	if (obj->add_err)
 		module_put(obj->mod);
+	else
+		schedule_work(&obj->remove_work);
 }
 
 static struct kobj_type klp_ktype_object = {
@@ -677,6 +683,14 @@ static void klp_free_patch_finish(struct klp_patch *patch)
 		module_put(patch->obj->mod);
 }
 
+static void klp_remove_module_work_fn(struct work_struct *work)
+{
+	struct klp_object *obj =
+		container_of(work, struct klp_object, remove_work);
+
+	module_put_and_delete(obj->mod);
+}
+
 /*
  * The livepatch might be freed from sysfs interface created by the patch.
  * This work allows to wait until the interface is destroyed in a separate
@@ -835,6 +849,8 @@ static int klp_init_object_early(struct klp_patch *patch,
 	kobject_init(&obj->kobj, &klp_ktype_object);
 	list_add_tail(&obj->node, &patch->obj_list);
 	obj->forced = false;
+	obj->add_err = false;
+	INIT_WORK(&obj->remove_work, klp_remove_module_work_fn);
 
 	klp_for_each_func_static(obj, func) {
 		klp_init_func_early(obj, func);
@@ -1063,6 +1079,7 @@ int klp_add_object(struct klp_object *obj)
 	return 0;
 
 err_free:
+	obj->add_err = true;
 	klp_free_object(obj, false);
 err:
 	/*
-- 
2.16.4

