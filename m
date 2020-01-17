Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93868140D60
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgAQPE4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:04:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:46214 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729015AbgAQPEA (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:04:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D3646BB99;
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
Subject: [POC 08/23] livepatch: Automatically load livepatch module when the patch module is loaded
Date:   Fri, 17 Jan 2020 16:03:08 +0100
Message-Id: <20200117150323.21801-9-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The klp_module_coming() callback is called from the module loader when
any module is being loaded. It allows to load the related livepatch modules
in MODULE_COMMING state before mod->init() is called. It prevents the module
from loading when the livepatching fails from any reason.

klp_module_coming() originally did several tasks: livepatch-specific
reallocations, registered ftrace handlers, and called object callbacks
when any defined.

All the mentioned tasks were moved into by klp_add_object() that is
called in mod->init() of livepatch modules that are livepatching
other modules.

Instead, klp_module_coming() has to load the needed livepatch module(s).
This functionality is already used in the kernel.

It is solved by two tricks:

1. The list is searched repeatedly from the beginning. The already
   loaded objects are skipped. One object is handled in each
   iteration.

   This solves the problem when a livepatch is removed or added
   in the meantime. Especially, it prevents a crash when
   the given struct klp_patch disappeared from the list in
   the meantime.

   The object will get removed automatically when the livepatch
   gets removed.

   There might be an attempt to load the module twice: via
   the coming notifier and via klp_enable_livepatch(). It is
   already handled in the module loader code. Both call will
   either succeed or fail the same way.

2. There might be a false error when the livepatch gets removed
   in the meantime. It is solved by double checking the existence.

   It does not solve the situation when the livepatch is removed
   and loaded again in the meantime. It will be solved by a separate
   patch. Anyway, it is not much realistic scenario.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/livepatch/core.c                            | 81 ++++++++++++++++++++--
 .../testing/selftests/livepatch/test-callbacks.sh  |  1 +
 2 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index bb851f916182..34e3ee2be7ef 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -8,6 +8,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/kmod.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/mutex.h>
@@ -100,6 +101,24 @@ static struct klp_patch *klp_find_patch(const char *patch_name)
 	return NULL;
 }
 
+/*
+ * Search whether livepatch for a module is loaded.
+ * Do not use for "vmlinux" that is always loaded.
+ * Must be called under klp_mutex.
+ */
+static bool klp_is_object_loaded(struct klp_patch *patch,
+				 char *object_name)
+{
+	struct klp_object *obj;
+
+	klp_for_each_object(patch, obj) {
+		if (obj->name && !strcmp(object_name, obj->name))
+			return true;
+	}
+
+	return false;
+}
+
 struct klp_find_arg {
 	const char *objname;
 	const char *name;
@@ -1082,6 +1101,19 @@ static int __klp_disable_patch(struct klp_patch *patch)
 	return 0;
 }
 
+static int klp_try_load_object(const char *patch_name, const char *obj_name)
+{
+	int ret;
+
+	ret = request_module("%s__%s", patch_name, obj_name);
+	if (ret) {
+		pr_info("Module load failed: %s__%s\n", patch_name, obj_name);
+		return ret;
+	}
+
+	return 0;
+}
+
 static int __klp_enable_patch(struct klp_patch *patch)
 {
 	struct klp_object *obj;
@@ -1290,19 +1322,58 @@ static void klp_cleanup_module_patches_limited(struct module *mod,
 
 int klp_module_coming(struct module *mod)
 {
+	char patch_name[MODULE_NAME_LEN];
+	struct klp_patch *patch;
+	int ret = 0;
+
 	if (WARN_ON(mod->state != MODULE_STATE_COMING))
 		return -EINVAL;
 
 	mutex_lock(&klp_mutex);
+restart:
+	klp_for_each_patch(patch) {
+		if (!klp_is_object_name_supported(patch, mod->name))
+			continue;
+
+		if (klp_is_object_loaded(patch, mod->name))
+			continue;
+
+		strncpy(patch_name, patch->obj->patch_name, sizeof(patch_name));
+		mutex_unlock(&klp_mutex);
+
+		ret = klp_try_load_object(patch_name, mod->name);
+		/*
+		 * The load might have failed because the patch has
+		 * been removed in the meantime. In this case, the
+		 * error might be ignored.
+		 *
+		 * FIXME: It is not fully proof. The patch might have be
+		 * unloaded and loaded again in the mean time.
+		 */
+		mutex_lock(&klp_mutex);
+		if (ret) {
+			patch = klp_find_patch(patch_name);
+			if (patch)
+				goto err;
+			ret = 0;
+		}
+
+		/*
+		 * The list of patches might have been manipulated
+		 * in the meantime.
+		 */
+		goto restart;
+	}
+
 	/*
-	 * Each module has to know that klp_module_coming()
-	 * has been called. We never know what module will
-	 * get patched by a new patch.
+	 * All enabled livepatches are loaded now. From this point, any newly
+	 * enabled livepatch is responsible for loading the related livepatch
+	 * module in klp_enable_patch().
 	 */
 	mod->klp_alive = true;
+err:
 	mutex_unlock(&klp_mutex);
-
-	return 0;
+	return ret;
 }
 
 void klp_module_going(struct module *mod)
diff --git a/tools/testing/selftests/livepatch/test-callbacks.sh b/tools/testing/selftests/livepatch/test-callbacks.sh
index ccaed35d0901..39a4f35e5f8e 100755
--- a/tools/testing/selftests/livepatch/test-callbacks.sh
+++ b/tools/testing/selftests/livepatch/test-callbacks.sh
@@ -330,6 +330,7 @@ livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET'
 $MOD_LIVEPATCH: pre_patch_callback: $MOD_TARGET -> [MODULE_STATE_COMING] Full formed, running module_init
 livepatch: pre-patch callback failed for object '$MOD_TARGET'
 livepatch: patch '$MOD_LIVEPATCH' failed for module '$MOD_TARGET', refusing to load module '$MOD_TARGET'
+livepatch: Module load failed: ${MOD_LIVEPATCH}__${MOD_TARGET}
 modprobe: ERROR: could not insert '$MOD_TARGET': No such device
 % echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
 livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-- 
2.16.4

