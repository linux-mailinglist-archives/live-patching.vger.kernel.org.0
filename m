Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0FCB140D52
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgAQPE2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:04:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:46518 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729152AbgAQPED (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:04:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AA406BBB4;
        Fri, 17 Jan 2020 15:04:01 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 17/23] livepatch: Load livepatches for modules when loading  the main livepatch
Date:   Fri, 17 Jan 2020 16:03:17 +0100
Message-Id: <20200117150323.21801-18-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The livepatch modules have been split per-object. The livepatch module for
"vmlinux" must always exist. It includes struct klp_patch and defines
the sysfs interface. It must be loaded first and removed last.

The related livepatch modules that are livepatching already loaded modules
must be loaded before the main livepatch gets enabled.

It might be possible to check if a livepatch module exists for each
loaded module by calling "modprobe -qR". But it would be a nightmare
to avoid races.

Instead, names of all livepatched modules are statically defined
in patch->obj_names array. klp_loaded_objects_livepatches()
iterates over this list and loads the needed modules one
by one. It must be called with klp_mutex released. It is
safe becase:

  1. The livepatch itself could not be removed until it returns
     from mod->init(). Note that it is not visible in sysfs
     interface at the moment.

  2. Any operation with other livepatches is prevented using
     klp_loading_livepatch variable. The affected operations
     are klp_enable_livepatch() and enabled_store().

  3. Modules loaded and removed in parallel are properly handled
     by klp_module_coming() and klp_module_going() callbacks.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/livepatch/core.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 79 insertions(+), 1 deletion(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 06676ec63ba7..6d4ec7642908 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -45,6 +45,7 @@ DEFINE_MUTEX(klp_mutex);
 LIST_HEAD(klp_patches);
 
 static struct kobject *klp_root_kobj;
+static struct klp_patch *klp_loading_patch;
 
 static bool klp_is_module(struct klp_object *obj)
 {
@@ -332,6 +333,16 @@ static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
 		goto out;
 	}
 
+	/*
+	 * Do not manipulate other livepatches when a new one is being
+	 * loaded to make our live easier. The patch that is being londed
+	 * is not visible in sysfs at this point.
+	 */
+	if (klp_loading_patch) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	/*
 	 * Allow to reverse a pending transition in both ways. It might be
 	 * necessary to complete the transition without forcing and breaking
@@ -1052,6 +1063,9 @@ int klp_add_object(struct klp_object *obj)
 	if (ret)
 		goto err;
 
+	if (!patch->enabled)
+		goto out;
+
 	ret = klp_init_object(patch, obj);
 	if (ret) {
 		pr_warn("failed to initialize patch '%s' for module '%s' (%d)\n",
@@ -1081,6 +1095,7 @@ int klp_add_object(struct klp_object *obj)
 	if (patch != klp_transition_patch)
 		klp_post_patch_callback(obj);
 
+out:
 	mutex_unlock(&klp_mutex);
 	return 0;
 
@@ -1147,12 +1162,43 @@ static int klp_try_load_object(const char *patch_name, const char *obj_name)
 	return 0;
 }
 
+/*
+ * This function is guarded by klp_loading_patch instead of klp_mutex to avoid
+ * deadlocks. It loads other livepatch modules via modprobe called in userspace.
+ * The other modules need to take klp-mutex as well.
+ */
+static int klp_load_objects_livepatches(struct klp_patch *patch)
+{
+	int i, ret;
+
+	for (i = 0; patch->obj_names[i]; i++) {
+		char *obj_name = patch->obj_names[i];
+		struct module *patched_mod;
+		bool obj_alive;
+
+		mutex_lock(&module_mutex);
+		patched_mod = find_module(obj_name);
+		obj_alive = patched_mod ? patched_mod->klp_alive : false;
+		mutex_unlock(&module_mutex);
+
+		/* Load livepatch module only for loaded objects. */
+		if (!obj_alive)
+			continue;
+
+		ret = klp_try_load_object(patch->obj->patch_name, obj_name);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int __klp_enable_patch(struct klp_patch *patch)
 {
 	struct klp_object *obj;
 	int ret;
 
-	if (klp_transition_patch)
+	if (klp_transition_patch || klp_loading_patch)
 		return -EBUSY;
 
 	if (WARN_ON(patch->enabled))
@@ -1199,6 +1245,21 @@ static int __klp_enable_patch(struct klp_patch *patch)
 	return ret;
 }
 
+static int klp_check_patches_in_progress(void)
+{
+	struct klp_patch *patch;
+
+	if (klp_loading_patch)
+		patch = klp_loading_patch;
+	else if (klp_transition_patch)
+		patch = klp_transition_patch;
+	else
+		return 0;
+
+	pr_err("Already enabling livepatch: %s\n", patch->obj->mod->name);
+	return -EBUSY;
+}
+
 /**
  * klp_enable_patch() - enable the livepatch
  * @patch:	patch to be enabled
@@ -1233,6 +1294,12 @@ int klp_enable_patch(struct klp_patch *patch)
 
 	mutex_lock(&klp_mutex);
 
+	ret = klp_check_patches_in_progress();
+	if (ret) {
+		mutex_unlock(&klp_mutex);
+		return ret;
+	}
+
 	if (!klp_is_patch_compatible(patch)) {
 		pr_err("Livepatch patch (%s) is not compatible with the already installed livepatches.\n",
 			patch->obj->mod->name);
@@ -1246,6 +1313,17 @@ int klp_enable_patch(struct klp_patch *patch)
 		return ret;
 	}
 
+	klp_loading_patch = patch;
+	mutex_unlock(&klp_mutex);
+
+	ret = klp_load_objects_livepatches(patch);
+
+	mutex_lock(&klp_mutex);
+	klp_loading_patch = NULL;
+
+	if (ret)
+		goto err;
+
 	ret = klp_init_patch(patch);
 	if (ret)
 		goto err;
-- 
2.16.4

