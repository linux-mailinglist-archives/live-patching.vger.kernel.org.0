Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7072A140D53
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbgAQPEc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:04:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:46416 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729130AbgAQPEC (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:04:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 040D5BBB2;
        Fri, 17 Jan 2020 15:04:00 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 13/23] livepatch: Remove livepatch module when the livepatched module is unloaded
Date:   Fri, 17 Jan 2020 16:03:13 +0100
Message-Id: <20200117150323.21801-14-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

klp_module_going() does very similar things as before splitting
the livepatches. Especially, it unpatches the related code, calls
the callbacks, unlinks the structures from the linked lists.

It does not have to clean up the structure because the entire livepatch
module is going to be freed and removed.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/livepatch/core.c | 84 ++++++++++++++++++-------------------------------
 1 file changed, 31 insertions(+), 53 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 6c51b194da57..73462b66f63f 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -599,21 +599,6 @@ static void __klp_free_funcs(struct klp_object *obj, bool nops_only)
 	}
 }
 
-/* Clean up when a patched object is unloaded */
-static void klp_free_object_loaded(struct klp_object *obj)
-{
-	struct klp_func *func;
-
-	obj->mod = NULL;
-
-	klp_for_each_func(obj, func) {
-		func->old_func = NULL;
-
-		if (func->nop)
-			func->new_func = NULL;
-	}
-}
-
 static void klp_free_object(struct klp_object *obj, bool nops_only)
 {
 	__klp_free_funcs(obj, nops_only);
@@ -909,6 +894,24 @@ static int klp_init_patch(struct klp_patch *patch)
 	return 0;
 }
 
+static void klp_remove_object(struct klp_object *obj)
+{
+	struct klp_patch *patch =
+		container_of(obj->kobj.parent, struct klp_patch, kobj);
+
+	if (patch != klp_transition_patch)
+		klp_pre_unpatch_callback(obj);
+
+	pr_notice("reverting patch '%s' on unloading module '%s'\n",
+		  patch->obj->patch_name, obj->name);
+
+	klp_unpatch_object(obj);
+
+	klp_post_unpatch_callback(obj);
+
+	klp_free_object(obj, false);
+}
+
 static int klp_check_module_name(struct klp_object *obj, bool is_module)
 {
 	char mod_name[MODULE_NAME_LEN];
@@ -1313,40 +1316,6 @@ void klp_discard_nops(struct klp_patch *new_patch)
 	klp_free_objects_dynamic(klp_transition_patch);
 }
 
-/*
- * Remove parts of patches that touch a given kernel module. The list of
- * patches processed might be limited. When limit is NULL, all patches
- * will be handled.
- */
-static void klp_cleanup_module_patches_limited(struct module *mod,
-					       struct klp_patch *limit)
-{
-	struct klp_patch *patch;
-	struct klp_object *obj;
-
-	klp_for_each_patch(patch) {
-		if (patch == limit)
-			break;
-
-		klp_for_each_object(patch, obj) {
-			if (!klp_is_module(obj) || strcmp(obj->name, mod->name))
-				continue;
-
-			if (patch != klp_transition_patch)
-				klp_pre_unpatch_callback(obj);
-
-			pr_notice("reverting patch '%s' on unloading module '%s'\n",
-				  patch->obj->patch_name, obj->name);
-			klp_unpatch_object(obj);
-
-			klp_post_unpatch_callback(obj);
-
-			klp_free_object_loaded(obj);
-			break;
-		}
-	}
-}
-
 int klp_module_coming(struct module *mod)
 {
 	char patch_name[MODULE_NAME_LEN];
@@ -1404,19 +1373,28 @@ int klp_module_coming(struct module *mod)
 
 void klp_module_going(struct module *mod)
 {
+	struct klp_patch *patch;
+	struct klp_object *obj, *tmp_obj;
+
 	if (WARN_ON(mod->state != MODULE_STATE_GOING &&
 		    mod->state != MODULE_STATE_COMING))
 		return;
 
 	mutex_lock(&klp_mutex);
 	/*
-	 * Each module has to know that klp_module_going()
-	 * has been called. We never know what module will
-	 * get patched by a new patch.
+	 * All already enabled livepatches for this module as going to be
+	 * removed now. From this point, klp_enable_patch() must not load
+	 * any new livepatch modules for this module.
 	 */
 	mod->klp_alive = false;
 
-	klp_cleanup_module_patches_limited(mod, NULL);
+	klp_for_each_patch(patch) {
+		klp_for_each_object_safe(patch, obj, tmp_obj) {
+			if (obj->name && !strcmp(obj->name, mod->name)) {
+				klp_remove_object(obj);
+			}
+		}
+	}
 
 	mutex_unlock(&klp_mutex);
 }
-- 
2.16.4

