Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0537C140D63
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgAQPFG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:05:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:46202 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729080AbgAQPD7 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:03:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 72B9DBB97;
        Fri, 17 Jan 2020 15:03:57 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 07/23] livepatch: Remove obsolete functionality from klp_module_coming()
Date:   Fri, 17 Jan 2020 16:03:07 +0100
Message-Id: <20200117150323.21801-8-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

klp_module_coming() could not operate on the livepatch structures.
Instead it has to load the livepatch module that will call
klp_add_object().

The functionality has been migrated to klp_add_object() in
the previous commits and the code can be finally removed.

The only exception is mod->klp_alive flag. It will still be needed
to decide who is responsible for loading/removing the eventual
livepatch modules.

It is done this way to make the changes manageable and easier
to review.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/livepatch/core.c | 59 -------------------------------------------------
 1 file changed, 59 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index c21bd9ec2012..bb851f916182 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1290,10 +1290,6 @@ static void klp_cleanup_module_patches_limited(struct module *mod,
 
 int klp_module_coming(struct module *mod)
 {
-	int ret;
-	struct klp_patch *patch;
-	struct klp_object *obj;
-
 	if (WARN_ON(mod->state != MODULE_STATE_COMING))
 		return -EINVAL;
 
@@ -1304,64 +1300,9 @@ int klp_module_coming(struct module *mod)
 	 * get patched by a new patch.
 	 */
 	mod->klp_alive = true;
-
-	klp_for_each_patch(patch) {
-		klp_for_each_object(patch, obj) {
-			if (!klp_is_module(obj) || strcmp(obj->name, mod->name))
-				continue;
-
-			obj->mod = mod;
-
-			ret = klp_init_object_loaded(obj);
-			if (ret) {
-				pr_warn("failed to initialize patch '%s' for module '%s' (%d)\n",
-					patch->obj->patch_name, obj->name, ret);
-				goto err;
-			}
-
-			pr_notice("applying patch '%s' to loading module '%s'\n",
-				  patch->obj->patch_name, obj->name);
-
-			ret = klp_pre_patch_callback(obj);
-			if (ret) {
-				pr_warn("pre-patch callback failed for object '%s'\n",
-					obj->name);
-				goto err;
-			}
-
-			ret = klp_patch_object(obj);
-			if (ret) {
-				pr_warn("failed to apply patch '%s' to module '%s' (%d)\n",
-					patch->obj->patch_name, obj->name, ret);
-
-				klp_post_unpatch_callback(obj);
-				goto err;
-			}
-
-			if (patch != klp_transition_patch)
-				klp_post_patch_callback(obj);
-
-			break;
-		}
-	}
-
 	mutex_unlock(&klp_mutex);
 
 	return 0;
-
-err:
-	/*
-	 * If a patch is unsuccessfully applied, return
-	 * error to the module loader.
-	 */
-	pr_warn("patch '%s' failed for module '%s', refusing to load module '%s'\n",
-		patch->obj->patch_name, obj->name, obj->name);
-	mod->klp_alive = false;
-	obj->mod = NULL;
-	klp_cleanup_module_patches_limited(mod, patch);
-	mutex_unlock(&klp_mutex);
-
-	return ret;
 }
 
 void klp_module_going(struct module *mod)
-- 
2.16.4

