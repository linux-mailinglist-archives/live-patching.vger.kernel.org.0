Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 201A6140D5F
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbgAQPE4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:04:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:46254 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729096AbgAQPEA (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:04:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4AF15BB9F;
        Fri, 17 Jan 2020 15:03:58 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 09/23] livepatch: Handle race when livepatches are reloaded during a module load
Date:   Fri, 17 Jan 2020 16:03:09 +0100
Message-Id: <20200117150323.21801-10-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

klp_module_coming() might fail to load a livepatch module when
the related livepatch gets reloaded in the meantime.

Detect this situation by adding a timestamp into struct klp_patch.
local_clock is enough because klp_mutex must be released and taken
several times during this scenario.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/livepatch.h | 2 ++
 kernel/livepatch/core.c   | 9 +++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index a4567c17a9f2..feb33f023f9f 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -155,6 +155,7 @@ struct klp_state {
  * @obj_list:	dynamic list of the object entries
  * @enabled:	the patch is enabled (but operation may be incomplete)
  * @forced:	was involved in a forced transition
+ * ts:		timestamp when the livepatch has been loaded
  * @free_work:	patch cleanup from workqueue-context
  * @finish:	for waiting till it is safe to remove the patch module
  */
@@ -171,6 +172,7 @@ struct klp_patch {
 	struct list_head obj_list;
 	bool enabled;
 	bool forced;
+	u64 ts;
 	struct work_struct free_work;
 	struct completion finish;
 };
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 34e3ee2be7ef..8e693c58b736 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -20,6 +20,7 @@
 #include <linux/moduleloader.h>
 #include <linux/completion.h>
 #include <linux/memory.h>
+#include <linux/sched/clock.h>
 #include <asm/cacheflush.h>
 #include "core.h"
 #include "patch.h"
@@ -854,6 +855,7 @@ static int klp_init_patch_early(struct klp_patch *patch)
 	kobject_init(&patch->kobj, &klp_ktype_patch);
 	patch->enabled = false;
 	patch->forced = false;
+	patch->ts = local_clock();
 	INIT_WORK(&patch->free_work, klp_free_patch_work_fn);
 	init_completion(&patch->finish);
 
@@ -1324,6 +1326,7 @@ int klp_module_coming(struct module *mod)
 {
 	char patch_name[MODULE_NAME_LEN];
 	struct klp_patch *patch;
+	u64 patch_ts;
 	int ret = 0;
 
 	if (WARN_ON(mod->state != MODULE_STATE_COMING))
@@ -1339,6 +1342,7 @@ int klp_module_coming(struct module *mod)
 			continue;
 
 		strncpy(patch_name, patch->obj->patch_name, sizeof(patch_name));
+		patch_ts = patch->ts;
 		mutex_unlock(&klp_mutex);
 
 		ret = klp_try_load_object(patch_name, mod->name);
@@ -1346,14 +1350,11 @@ int klp_module_coming(struct module *mod)
 		 * The load might have failed because the patch has
 		 * been removed in the meantime. In this case, the
 		 * error might be ignored.
-		 *
-		 * FIXME: It is not fully proof. The patch might have be
-		 * unloaded and loaded again in the mean time.
 		 */
 		mutex_lock(&klp_mutex);
 		if (ret) {
 			patch = klp_find_patch(patch_name);
-			if (patch)
+			if (patch && patch->ts == patch_ts)
 				goto err;
 			ret = 0;
 		}
-- 
2.16.4

