Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61A40E9F66
	for <lists+live-patching@lfdr.de>; Wed, 30 Oct 2019 16:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfJ3PnY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 30 Oct 2019 11:43:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:35640 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726242AbfJ3PnX (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 30 Oct 2019 11:43:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2E57FB46D;
        Wed, 30 Oct 2019 15:43:22 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH v4 1/5] livepatch: Keep replaced patches until post_patch callback is called
Date:   Wed, 30 Oct 2019 16:43:09 +0100
Message-Id: <20191030154313.13263-2-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191030154313.13263-1-pmladek@suse.com>
References: <20191030154313.13263-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Pre/post (un)patch callbacks might manipulate the system state. Cumulative
livepatches might need to take over the changes made by the replaced
ones. For this they might need to access some data stored or referenced
by the old livepatches.

Therefore the replaced livepatches have to stay around until post_patch()
callback is called. It is achieved by calling the free functions later.
It is the same location where disabled livepatches have already been
freed.

Signed-off-by: Petr Mladek <pmladek@suse.com>
Acked-by: Miroslav Benes <mbenes@suse.cz>
---
 kernel/livepatch/core.c       | 36 ++++++++++++++++++++++++++----------
 kernel/livepatch/core.h       |  5 +++--
 kernel/livepatch/transition.c | 12 ++++++------
 3 files changed, 35 insertions(+), 18 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index ab4a4606d19b..1e1d87ead55c 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -632,7 +632,7 @@ static void klp_free_objects_dynamic(struct klp_patch *patch)
  * The operation must be completed by calling klp_free_patch_finish()
  * outside klp_mutex.
  */
-void klp_free_patch_start(struct klp_patch *patch)
+static void klp_free_patch_start(struct klp_patch *patch)
 {
 	if (!list_empty(&patch->list))
 		list_del(&patch->list);
@@ -677,6 +677,23 @@ static void klp_free_patch_work_fn(struct work_struct *work)
 	klp_free_patch_finish(patch);
 }
 
+void klp_free_patch_async(struct klp_patch *patch)
+{
+	klp_free_patch_start(patch);
+	schedule_work(&patch->free_work);
+}
+
+void klp_free_replaced_patches_async(struct klp_patch *new_patch)
+{
+	struct klp_patch *old_patch, *tmp_patch;
+
+	klp_for_each_patch_safe(old_patch, tmp_patch) {
+		if (old_patch == new_patch)
+			return;
+		klp_free_patch_async(old_patch);
+	}
+}
+
 static int klp_init_func(struct klp_object *obj, struct klp_func *func)
 {
 	if (!func->old_name)
@@ -1022,12 +1039,13 @@ int klp_enable_patch(struct klp_patch *patch)
 EXPORT_SYMBOL_GPL(klp_enable_patch);
 
 /*
- * This function removes replaced patches.
+ * This function unpatches objects from the replaced livepatches.
  *
  * We could be pretty aggressive here. It is called in the situation where
- * these structures are no longer accessible. All functions are redirected
- * by the klp_transition_patch. They use either a new code or they are in
- * the original code because of the special nop function patches.
+ * these structures are no longer accessed from the ftrace handler.
+ * All functions are redirected by the klp_transition_patch. They
+ * use either a new code or they are in the original code because
+ * of the special nop function patches.
  *
  * The only exception is when the transition was forced. In this case,
  * klp_ftrace_handler() might still see the replaced patch on the stack.
@@ -1035,18 +1053,16 @@ EXPORT_SYMBOL_GPL(klp_enable_patch);
  * thanks to RCU. We only have to keep the patches on the system. Also
  * this is handled transparently by patch->module_put.
  */
-void klp_discard_replaced_patches(struct klp_patch *new_patch)
+void klp_unpatch_replaced_patches(struct klp_patch *new_patch)
 {
-	struct klp_patch *old_patch, *tmp_patch;
+	struct klp_patch *old_patch;
 
-	klp_for_each_patch_safe(old_patch, tmp_patch) {
+	klp_for_each_patch(old_patch) {
 		if (old_patch == new_patch)
 			return;
 
 		old_patch->enabled = false;
 		klp_unpatch_objects(old_patch);
-		klp_free_patch_start(old_patch);
-		schedule_work(&old_patch->free_work);
 	}
 }
 
diff --git a/kernel/livepatch/core.h b/kernel/livepatch/core.h
index ec43a40b853f..38209c7361b6 100644
--- a/kernel/livepatch/core.h
+++ b/kernel/livepatch/core.h
@@ -13,8 +13,9 @@ extern struct list_head klp_patches;
 #define klp_for_each_patch(patch)	\
 	list_for_each_entry(patch, &klp_patches, list)
 
-void klp_free_patch_start(struct klp_patch *patch);
-void klp_discard_replaced_patches(struct klp_patch *new_patch);
+void klp_free_patch_async(struct klp_patch *patch);
+void klp_free_replaced_patches_async(struct klp_patch *new_patch);
+void klp_unpatch_replaced_patches(struct klp_patch *new_patch);
 void klp_discard_nops(struct klp_patch *new_patch);
 
 static inline bool klp_is_object_loaded(struct klp_object *obj)
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index cdf318d86dd6..f6310f848f34 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -78,7 +78,7 @@ static void klp_complete_transition(void)
 		 klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
 
 	if (klp_transition_patch->replace && klp_target_state == KLP_PATCHED) {
-		klp_discard_replaced_patches(klp_transition_patch);
+		klp_unpatch_replaced_patches(klp_transition_patch);
 		klp_discard_nops(klp_transition_patch);
 	}
 
@@ -446,14 +446,14 @@ void klp_try_complete_transition(void)
 	klp_complete_transition();
 
 	/*
-	 * It would make more sense to free the patch in
+	 * It would make more sense to free the unused patches in
 	 * klp_complete_transition() but it is called also
 	 * from klp_cancel_transition().
 	 */
-	if (!patch->enabled) {
-		klp_free_patch_start(patch);
-		schedule_work(&patch->free_work);
-	}
+	if (!patch->enabled)
+		klp_free_patch_async(patch);
+	else if (patch->replace)
+		klp_free_replaced_patches_async(patch);
 }
 
 /*
-- 
2.16.4

