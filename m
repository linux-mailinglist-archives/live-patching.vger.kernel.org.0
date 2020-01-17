Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6626A140D47
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgAQPD7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:03:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:46104 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729064AbgAQPD6 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:03:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2879BAD00;
        Fri, 17 Jan 2020 15:03:56 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 04/23] livepatch: Prevent loading livepatch sub-module unintentionally.
Date:   Fri, 17 Jan 2020 16:03:04 +0100
Message-Id: <20200117150323.21801-5-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Livepatch is split into several modules. The main module is for livepatching
vmlinux. The rest is for livepatching other modules.

Only the livepatch module for vmlinux can be loaded by users. Others are
loaded automatically when the related module is or gets loaded.

Users might try to load any livepatch module. It must be allowed
only when the related livepatch module for vmlinux and the livepatched
module are loaded.

Also it is important to check that obj->name is listed in patch->obj_names.
Otherwise this module would not be loaded automatically. And it would
lead into inconsistent behavier. Anyway, the missing name means a mistake
somewhere and must be reported.

klp_add_object() is taking over the job done by klp_module_coming().
The error message is taken from there so that selftests do not need
to get updated.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/livepatch/core.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 1 deletion(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index ec7ffc7db3a7..e2c7dc6c2d5f 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -88,6 +88,18 @@ static struct klp_object *klp_find_object(struct klp_patch *patch,
 	return NULL;
 }
 
+static struct klp_patch *klp_find_patch(const char *patch_name)
+{
+	struct klp_patch *patch;
+
+	klp_for_each_patch(patch) {
+		if (!strcmp(patch->obj->patch_name, patch_name))
+			return patch;
+	}
+
+	return NULL;
+}
+
 struct klp_find_arg {
 	const char *objname;
 	const char *name;
@@ -920,15 +932,79 @@ static int klp_check_object(struct klp_object *obj, bool is_module)
 	return klp_check_module_name(obj, is_module);
 }
 
+static bool klp_is_object_name_supported(struct klp_patch *patch,
+					 const char *name)
+{
+	int i;
+
+	for (i = 0; patch->obj_names[i]; i++) {
+		if (!strcmp(name, patch->obj_names[i]))
+			return true;
+	}
+
+	return false;
+}
+
+/* Must be called under klp_mutex */
+static bool klp_is_object_compatible(struct klp_patch *patch,
+				     struct klp_object *obj)
+{
+	struct module *patched_mod;
+
+	if (!klp_is_object_name_supported(patch, obj->name)) {
+		pr_err("Livepatch (%s) is not supposed to livepatch the module: %s\n",
+		       obj->patch_name, obj->name);
+		return false;
+	}
+
+	mutex_lock(&module_mutex);
+	patched_mod = find_module(obj->name);
+	mutex_unlock(&module_mutex);
+
+	if (!patched_mod) {
+		pr_err("Livepatched module is not loaded: %s\n", obj->name);
+		return false;
+	}
+
+	return true;
+}
+
 int klp_add_object(struct klp_object *obj)
 {
+	struct klp_patch *patch;
 	int ret;
 
 	ret = klp_check_object(obj, true);
 	if (ret)
 		return ret;
 
+	mutex_lock(&klp_mutex);
+
+	patch = klp_find_patch(obj->patch_name);
+	if (!patch) {
+		pr_err("Can't load livepatch (%s) for module when the livepatch (%s) for vmcore is not loaded\n",
+		       obj->mod->name, obj->patch_name);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (!klp_is_object_compatible(patch, obj)) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	mutex_unlock(&klp_mutex);
 	return 0;
+
+err:
+	/*
+	 * If a patch is unsuccessfully applied, return
+	 * error to the module loader.
+	 */
+	pr_warn("patch '%s' failed for module '%s', refusing to load module '%s'\n",
+		patch->obj->patch_name, obj->name, obj->name);
+	mutex_unlock(&klp_mutex);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(klp_add_object);
 
@@ -1033,7 +1109,7 @@ int klp_enable_patch(struct klp_patch *patch)
 {
 	int ret;
 
-	if (!patch || !patch->obj)
+	if (!patch || !patch->obj || !patch->obj_names)
 		return -EINVAL;
 
 	ret = klp_check_object(patch->obj, false);
-- 
2.16.4

