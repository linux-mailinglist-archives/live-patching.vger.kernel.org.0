Return-Path: <live-patching+bounces-37-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D79A67E7DFE
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 18:06:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BF2E280F1E
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 17:06:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 794DB1DFE5;
	Fri, 10 Nov 2023 17:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="lN0j7vPd"
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63391DDFA
	for <live-patching@vger.kernel.org>; Fri, 10 Nov 2023 17:06:08 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FBE431C5;
	Fri, 10 Nov 2023 09:06:04 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id EBDF1219B2;
	Fri, 10 Nov 2023 17:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1699635962; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F3XpT26i+blZpynYH3Yln/cBgtmR5OHvdHE7ZoPL7YU=;
	b=lN0j7vPd3dCFf9osuPXOqBOvN6CWwOxCOIsEK+CEMuls7Cw90Vg5fUCJU9PSoodU1KgXQH
	ymaHs6HgJFvIuH9t9iUjqWB3rcFCRDBvVfMkXwBODuXQxbPOoAgX+PI9uoiXCwvJaG3haz
	ckGetlS8jcA8uBd5Xcs0f2dRW1e4IdM=
Received: from alley.suse.cz (pmladek.udp.ovpn2.prg.suse.de [10.100.201.202])
	by relay2.suse.de (Postfix) with ESMTP id 817EC2C188;
	Fri, 10 Nov 2023 17:06:02 +0000 (UTC)
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [POC 6/7] livepatch: Remove the obsolete per-object callbacks
Date: Fri, 10 Nov 2023 18:04:27 +0100
Message-Id: <20231110170428.6664-7-pmladek@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231110170428.6664-1-pmladek@suse.com>
References: <20231110170428.6664-1-pmladek@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All selftests have been migrated to the new per-state callbacks.
And the obsoleted per-object callbacks can be safely removed.

FIXME:

This patch is removing the sample module and documentation
without any replacement. They obviously have to be converted
for the state-callbacks.

It has been postponed until the approach has been approved
in the POC stage.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 Documentation/livepatch/callbacks.rst         | 133 ------------
 Documentation/livepatch/index.rst             |   1 -
 include/linux/livepatch.h                     |  25 ---
 kernel/livepatch/core.c                       |  29 ---
 kernel/livepatch/core.h                       |  33 ---
 kernel/livepatch/transition.c                 |   9 -
 samples/livepatch/Makefile                    |   3 -
 .../livepatch/livepatch-callbacks-busymod.c   |  60 ------
 samples/livepatch/livepatch-callbacks-demo.c  | 196 ------------------
 samples/livepatch/livepatch-callbacks-mod.c   |  41 ----
 10 files changed, 530 deletions(-)
 delete mode 100644 Documentation/livepatch/callbacks.rst
 delete mode 100644 samples/livepatch/livepatch-callbacks-busymod.c
 delete mode 100644 samples/livepatch/livepatch-callbacks-demo.c
 delete mode 100644 samples/livepatch/livepatch-callbacks-mod.c

diff --git a/Documentation/livepatch/callbacks.rst b/Documentation/livepatch/callbacks.rst
deleted file mode 100644
index 470944aa8658..000000000000
--- a/Documentation/livepatch/callbacks.rst
+++ /dev/null
@@ -1,133 +0,0 @@
-======================
-(Un)patching Callbacks
-======================
-
-Livepatch (un)patch-callbacks provide a mechanism for livepatch modules
-to execute callback functions when a kernel object is (un)patched.  They
-can be considered a **power feature** that **extends livepatching abilities**
-to include:
-
-  - Safe updates to global data
-
-  - "Patches" to init and probe functions
-
-  - Patching otherwise unpatchable code (i.e. assembly)
-
-In most cases, (un)patch callbacks will need to be used in conjunction
-with memory barriers and kernel synchronization primitives, like
-mutexes/spinlocks, or even stop_machine(), to avoid concurrency issues.
-
-1. Motivation
-=============
-
-Callbacks differ from existing kernel facilities:
-
-  - Module init/exit code doesn't run when disabling and re-enabling a
-    patch.
-
-  - A module notifier can't stop a to-be-patched module from loading.
-
-Callbacks are part of the klp_object structure and their implementation
-is specific to that klp_object.  Other livepatch objects may or may not
-be patched, irrespective of the target klp_object's current state.
-
-2. Callback types
-=================
-
-Callbacks can be registered for the following livepatch actions:
-
-  * Pre-patch
-                 - before a klp_object is patched
-
-  * Post-patch
-                 - after a klp_object has been patched and is active
-                   across all tasks
-
-  * Pre-unpatch
-                 - before a klp_object is unpatched (ie, patched code is
-                   active), used to clean up post-patch callback
-                   resources
-
-  * Post-unpatch
-                 - after a klp_object has been patched, all code has
-                   been restored and no tasks are running patched code,
-                   used to cleanup pre-patch callback resources
-
-3. How it works
-===============
-
-Each callback is optional, omitting one does not preclude specifying any
-other.  However, the livepatching core executes the handlers in
-symmetry: pre-patch callbacks have a post-unpatch counterpart and
-post-patch callbacks have a pre-unpatch counterpart.  An unpatch
-callback will only be executed if its corresponding patch callback was
-executed.  Typical use cases pair a patch handler that acquires and
-configures resources with an unpatch handler tears down and releases
-those same resources.
-
-A callback is only executed if its host klp_object is loaded.  For
-in-kernel vmlinux targets, this means that callbacks will always execute
-when a livepatch is enabled/disabled.  For patch target kernel modules,
-callbacks will only execute if the target module is loaded.  When a
-module target is (un)loaded, its callbacks will execute only if the
-livepatch module is enabled.
-
-The pre-patch callback, if specified, is expected to return a status
-code (0 for success, -ERRNO on error).  An error status code indicates
-to the livepatching core that patching of the current klp_object is not
-safe and to stop the current patching request.  (When no pre-patch
-callback is provided, the transition is assumed to be safe.)  If a
-pre-patch callback returns failure, the kernel's module loader will:
-
-  - Refuse to load a livepatch, if the livepatch is loaded after
-    targeted code.
-
-    or:
-
-  - Refuse to load a module, if the livepatch was already successfully
-    loaded.
-
-No post-patch, pre-unpatch, or post-unpatch callbacks will be executed
-for a given klp_object if the object failed to patch, due to a failed
-pre_patch callback or for any other reason.
-
-If a patch transition is reversed, no pre-unpatch handlers will be run
-(this follows the previously mentioned symmetry -- pre-unpatch callbacks
-will only occur if their corresponding post-patch callback executed).
-
-If the object did successfully patch, but the patch transition never
-started for some reason (e.g., if another object failed to patch),
-only the post-unpatch callback will be called.
-
-4. Use cases
-============
-
-Sample livepatch modules demonstrating the callback API can be found in
-samples/livepatch/ directory.  These samples were modified for use in
-kselftests and can be found in the lib/livepatch directory.
-
-Global data update
-------------------
-
-A pre-patch callback can be useful to update a global variable.  For
-example, 75ff39ccc1bd ("tcp: make challenge acks less predictable")
-changes a global sysctl, as well as patches the tcp_send_challenge_ack()
-function.
-
-In this case, if we're being super paranoid, it might make sense to
-patch the data *after* patching is complete with a post-patch callback,
-so that tcp_send_challenge_ack() could first be changed to read
-sysctl_tcp_challenge_ack_limit with READ_ONCE.
-
-__init and probe function patches support
------------------------------------------
-
-Although __init and probe functions are not directly livepatch-able, it
-may be possible to implement similar updates via pre/post-patch
-callbacks.
-
-The commit ``48900cb6af42 ("virtio-net: drop NETIF_F_FRAGLIST")`` change the way that
-virtnet_probe() initialized its driver's net_device features.  A
-pre/post-patch callback could iterate over all such devices, making a
-similar change to their hw_features value.  (Client functions of the
-value may need to be updated accordingly.)
diff --git a/Documentation/livepatch/index.rst b/Documentation/livepatch/index.rst
index cebf1c71d4a5..997b5ddf4779 100644
--- a/Documentation/livepatch/index.rst
+++ b/Documentation/livepatch/index.rst
@@ -8,7 +8,6 @@ Kernel Livepatching
     :maxdepth: 1
 
     livepatch
-    callbacks
     cumulative-patches
     module-elf-format
     shadow-vars
diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 189ec7c6a89f..3807c7bb0281 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -77,30 +77,6 @@ struct klp_func {
 	bool transition;
 };
 
-struct klp_object;
-
-/**
- * struct klp_callbacks - pre/post live-(un)patch callback structure
- * @pre_patch:		executed before code patching
- * @post_patch:		executed after code patching
- * @pre_unpatch:	executed before code unpatching
- * @post_unpatch:	executed after code unpatching
- * @post_unpatch_enabled:	flag indicating if post-unpatch callback
- * 				should run
- *
- * All callbacks are optional.  Only the pre-patch callback, if provided,
- * will be unconditionally executed.  If the parent klp_object fails to
- * patch for any reason, including a non-zero error status returned from
- * the pre-patch callback, no further callbacks will be executed.
- */
-struct klp_callbacks {
-	int (*pre_patch)(struct klp_object *obj);
-	void (*post_patch)(struct klp_object *obj);
-	void (*pre_unpatch)(struct klp_object *obj);
-	void (*post_unpatch)(struct klp_object *obj);
-	bool post_unpatch_enabled;
-};
-
 /**
  * struct klp_object - kernel object structure for live patching
  * @name:	module name (or NULL for vmlinux)
@@ -118,7 +94,6 @@ struct klp_object {
 	/* external */
 	const char *name;
 	struct klp_func *funcs;
-	struct klp_callbacks callbacks;
 
 	/* internal */
 	struct kobject kobj;
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index a4a3fe7907ad..d982365777f1 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -965,8 +965,6 @@ static int klp_init_patch(struct klp_patch *patch)
 
 static int __klp_disable_patch(struct klp_patch *patch)
 {
-	struct klp_object *obj;
-
 	if (WARN_ON(!patch->enabled))
 		return -EINVAL;
 
@@ -977,10 +975,6 @@ static int __klp_disable_patch(struct klp_patch *patch)
 
 	klp_disable_states(patch);
 
-	klp_for_each_object(patch, obj)
-		if (obj->patched)
-			klp_pre_unpatch_callback(obj);
-
 	/*
 	 * Enforce the order of the func->transition writes in
 	 * klp_init_transition() and the TIF_PATCH_PENDING writes in
@@ -1032,13 +1026,6 @@ static int __klp_enable_patch(struct klp_patch *patch)
 		if (!klp_is_object_loaded(obj))
 			continue;
 
-		ret = klp_pre_patch_callback(obj);
-		if (ret) {
-			pr_warn("pre-patch callback failed for object '%s'\n",
-				klp_is_module(obj) ? obj->name : "vmlinux");
-			goto err_states;
-		}
-
 		ret = klp_patch_object(obj);
 		if (ret) {
 			pr_warn("failed to patch object '%s'\n",
@@ -1214,14 +1201,10 @@ static void klp_cleanup_module_patches_limited(struct module *mod,
 			if (!klp_is_module(obj) || strcmp(obj->name, mod->name))
 				continue;
 
-			if (patch != klp_transition_patch)
-				klp_pre_unpatch_callback(obj);
-
 			pr_notice("reverting patch '%s' on unloading module '%s'\n",
 				  patch->mod->name, obj->mod->name);
 			klp_unpatch_object(obj);
 
-			klp_post_unpatch_callback(obj);
 			klp_clear_object_relocs(patch, obj);
 			klp_free_object_loaded(obj);
 			break;
@@ -1268,25 +1251,13 @@ int klp_module_coming(struct module *mod)
 			pr_notice("applying patch '%s' to loading module '%s'\n",
 				  patch->mod->name, obj->mod->name);
 
-			ret = klp_pre_patch_callback(obj);
-			if (ret) {
-				pr_warn("pre-patch callback failed for object '%s'\n",
-					obj->name);
-				goto err;
-			}
-
 			ret = klp_patch_object(obj);
 			if (ret) {
 				pr_warn("failed to apply patch '%s' to module '%s' (%d)\n",
 					patch->mod->name, obj->mod->name, ret);
-
-				klp_post_unpatch_callback(obj);
 				goto err;
 			}
 
-			if (patch != klp_transition_patch)
-				klp_post_patch_callback(obj);
-
 			break;
 		}
 	}
diff --git a/kernel/livepatch/core.h b/kernel/livepatch/core.h
index 38209c7361b6..02b8364f6779 100644
--- a/kernel/livepatch/core.h
+++ b/kernel/livepatch/core.h
@@ -23,37 +23,4 @@ static inline bool klp_is_object_loaded(struct klp_object *obj)
 	return !obj->name || obj->mod;
 }
 
-static inline int klp_pre_patch_callback(struct klp_object *obj)
-{
-	int ret = 0;
-
-	if (obj->callbacks.pre_patch)
-		ret = (*obj->callbacks.pre_patch)(obj);
-
-	obj->callbacks.post_unpatch_enabled = !ret;
-
-	return ret;
-}
-
-static inline void klp_post_patch_callback(struct klp_object *obj)
-{
-	if (obj->callbacks.post_patch)
-		(*obj->callbacks.post_patch)(obj);
-}
-
-static inline void klp_pre_unpatch_callback(struct klp_object *obj)
-{
-	if (obj->callbacks.pre_unpatch)
-		(*obj->callbacks.pre_unpatch)(obj);
-}
-
-static inline void klp_post_unpatch_callback(struct klp_object *obj)
-{
-	if (obj->callbacks.post_unpatch_enabled &&
-	    obj->callbacks.post_unpatch)
-		(*obj->callbacks.post_unpatch)(obj);
-
-	obj->callbacks.post_unpatch_enabled = false;
-}
-
 #endif /* _LIVEPATCH_CORE_H */
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index cfa1ab10feb7..1826e08a31dd 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -148,15 +148,6 @@ static void klp_complete_transition(void)
 		klp_release_states(klp_transition_patch);
 	}
 
-	klp_for_each_object(klp_transition_patch, obj) {
-		if (!klp_is_object_loaded(obj))
-			continue;
-		if (klp_target_state == KLP_PATCHED)
-			klp_post_patch_callback(obj);
-		else if (klp_target_state == KLP_UNPATCHED)
-			klp_post_unpatch_callback(obj);
-	}
-
 	pr_notice("'%s': %s complete\n", klp_transition_patch->mod->name,
 		  klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
 
diff --git a/samples/livepatch/Makefile b/samples/livepatch/Makefile
index 9f853eeb6140..5ad205c61a67 100644
--- a/samples/livepatch/Makefile
+++ b/samples/livepatch/Makefile
@@ -3,6 +3,3 @@ obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-sample.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-shadow-mod.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-shadow-fix1.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-shadow-fix2.o
-obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-demo.o
-obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-mod.o
-obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-busymod.o
diff --git a/samples/livepatch/livepatch-callbacks-busymod.c b/samples/livepatch/livepatch-callbacks-busymod.c
deleted file mode 100644
index 378e2d40271a..000000000000
--- a/samples/livepatch/livepatch-callbacks-busymod.c
+++ /dev/null
@@ -1,60 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Copyright (C) 2017 Joe Lawrence <joe.lawrence@redhat.com>
- */
-
-/*
- * livepatch-callbacks-busymod.c - (un)patching callbacks demo support module
- *
- *
- * Purpose
- * -------
- *
- * Simple module to demonstrate livepatch (un)patching callbacks.
- *
- *
- * Usage
- * -----
- *
- * This module is not intended to be standalone.  See the "Usage"
- * section of livepatch-callbacks-mod.c.
- */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/workqueue.h>
-#include <linux/delay.h>
-
-static int sleep_secs;
-module_param(sleep_secs, int, 0644);
-MODULE_PARM_DESC(sleep_secs, "sleep_secs (default=0)");
-
-static void busymod_work_func(struct work_struct *work);
-static DECLARE_DELAYED_WORK(work, busymod_work_func);
-
-static void busymod_work_func(struct work_struct *work)
-{
-	pr_info("%s, sleeping %d seconds ...\n", __func__, sleep_secs);
-	msleep(sleep_secs * 1000);
-	pr_info("%s exit\n", __func__);
-}
-
-static int livepatch_callbacks_mod_init(void)
-{
-	pr_info("%s\n", __func__);
-	schedule_delayed_work(&work,
-		msecs_to_jiffies(1000 * 0));
-	return 0;
-}
-
-static void livepatch_callbacks_mod_exit(void)
-{
-	cancel_delayed_work_sync(&work);
-	pr_info("%s\n", __func__);
-}
-
-module_init(livepatch_callbacks_mod_init);
-module_exit(livepatch_callbacks_mod_exit);
-MODULE_LICENSE("GPL");
diff --git a/samples/livepatch/livepatch-callbacks-demo.c b/samples/livepatch/livepatch-callbacks-demo.c
deleted file mode 100644
index 11c3f4357812..000000000000
--- a/samples/livepatch/livepatch-callbacks-demo.c
+++ /dev/null
@@ -1,196 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Copyright (C) 2017 Joe Lawrence <joe.lawrence@redhat.com>
- */
-
-/*
- * livepatch-callbacks-demo.c - (un)patching callbacks livepatch demo
- *
- *
- * Purpose
- * -------
- *
- * Demonstration of registering livepatch (un)patching callbacks.
- *
- *
- * Usage
- * -----
- *
- * Step 1 - load the simple module
- *
- *   insmod samples/livepatch/livepatch-callbacks-mod.ko
- *
- *
- * Step 2 - load the demonstration livepatch (with callbacks)
- *
- *   insmod samples/livepatch/livepatch-callbacks-demo.ko
- *
- *
- * Step 3 - cleanup
- *
- *   echo 0 > /sys/kernel/livepatch/livepatch_callbacks_demo/enabled
- *   rmmod livepatch_callbacks_demo
- *   rmmod livepatch_callbacks_mod
- *
- * Watch dmesg output to see livepatch enablement, callback execution
- * and patching operations for both vmlinux and module targets.
- *
- * NOTE: swap the insmod order of livepatch-callbacks-mod.ko and
- *       livepatch-callbacks-demo.ko to observe what happens when a
- *       target module is loaded after a livepatch with callbacks.
- *
- * NOTE: 'pre_patch_ret' is a module parameter that sets the pre-patch
- *       callback return status.  Try setting up a non-zero status
- *       such as -19 (-ENODEV):
- *
- *       # Load demo livepatch, vmlinux is patched
- *       insmod samples/livepatch/livepatch-callbacks-demo.ko
- *
- *       # Setup next pre-patch callback to return -ENODEV
- *       echo -19 > /sys/module/livepatch_callbacks_demo/parameters/pre_patch_ret
- *
- *       # Module loader refuses to load the target module
- *       insmod samples/livepatch/livepatch-callbacks-mod.ko
- *       insmod: ERROR: could not insert module samples/livepatch/livepatch-callbacks-mod.ko: No such device
- *
- * NOTE: There is a second target module,
- *       livepatch-callbacks-busymod.ko, available for experimenting
- *       with livepatch (un)patch callbacks.  This module contains
- *       a 'sleep_secs' parameter that parks the module on one of the
- *       functions that the livepatch demo module wants to patch.
- *       Modifying this value and tweaking the order of module loads can
- *       effectively demonstrate stalled patch transitions:
- *
- *       # Load a target module, let it park on 'busymod_work_func' for
- *       # thirty seconds
- *       insmod samples/livepatch/livepatch-callbacks-busymod.ko sleep_secs=30
- *
- *       # Meanwhile load the livepatch
- *       insmod samples/livepatch/livepatch-callbacks-demo.ko
- *
- *       # ... then load and unload another target module while the
- *       # transition is in progress
- *       insmod samples/livepatch/livepatch-callbacks-mod.ko
- *       rmmod samples/livepatch/livepatch-callbacks-mod.ko
- *
- *       # Finally cleanup
- *       echo 0 > /sys/kernel/livepatch/livepatch_callbacks_demo/enabled
- *       rmmod samples/livepatch/livepatch-callbacks-demo.ko
- */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/livepatch.h>
-
-static int pre_patch_ret;
-module_param(pre_patch_ret, int, 0644);
-MODULE_PARM_DESC(pre_patch_ret, "pre_patch_ret (default=0)");
-
-static const char *const module_state[] = {
-	[MODULE_STATE_LIVE]	= "[MODULE_STATE_LIVE] Normal state",
-	[MODULE_STATE_COMING]	= "[MODULE_STATE_COMING] Full formed, running module_init",
-	[MODULE_STATE_GOING]	= "[MODULE_STATE_GOING] Going away",
-	[MODULE_STATE_UNFORMED]	= "[MODULE_STATE_UNFORMED] Still setting it up",
-};
-
-static void callback_info(const char *callback, struct klp_object *obj)
-{
-	if (obj->mod)
-		pr_info("%s: %s -> %s\n", callback, obj->mod->name,
-			module_state[obj->mod->state]);
-	else
-		pr_info("%s: vmlinux\n", callback);
-}
-
-/* Executed on object patching (ie, patch enablement) */
-static int pre_patch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
-	return pre_patch_ret;
-}
-
-/* Executed on object unpatching (ie, patch disablement) */
-static void post_patch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
-}
-
-/* Executed on object unpatching (ie, patch disablement) */
-static void pre_unpatch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
-}
-
-/* Executed on object unpatching (ie, patch disablement) */
-static void post_unpatch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
-}
-
-static void patched_work_func(struct work_struct *work)
-{
-	pr_info("%s\n", __func__);
-}
-
-static struct klp_func no_funcs[] = {
-	{ }
-};
-
-static struct klp_func busymod_funcs[] = {
-	{
-		.old_name = "busymod_work_func",
-		.new_func = patched_work_func,
-	}, { }
-};
-
-static struct klp_object objs[] = {
-	{
-		.name = NULL,	/* vmlinux */
-		.funcs = no_funcs,
-		.callbacks = {
-			.pre_patch = pre_patch_callback,
-			.post_patch = post_patch_callback,
-			.pre_unpatch = pre_unpatch_callback,
-			.post_unpatch = post_unpatch_callback,
-		},
-	},	{
-		.name = "livepatch_callbacks_mod",
-		.funcs = no_funcs,
-		.callbacks = {
-			.pre_patch = pre_patch_callback,
-			.post_patch = post_patch_callback,
-			.pre_unpatch = pre_unpatch_callback,
-			.post_unpatch = post_unpatch_callback,
-		},
-	},	{
-		.name = "livepatch_callbacks_busymod",
-		.funcs = busymod_funcs,
-		.callbacks = {
-			.pre_patch = pre_patch_callback,
-			.post_patch = post_patch_callback,
-			.pre_unpatch = pre_unpatch_callback,
-			.post_unpatch = post_unpatch_callback,
-		},
-	}, { }
-};
-
-static struct klp_patch patch = {
-	.mod = THIS_MODULE,
-	.objs = objs,
-};
-
-static int livepatch_callbacks_demo_init(void)
-{
-	return klp_enable_patch(&patch);
-}
-
-static void livepatch_callbacks_demo_exit(void)
-{
-}
-
-module_init(livepatch_callbacks_demo_init);
-module_exit(livepatch_callbacks_demo_exit);
-MODULE_LICENSE("GPL");
-MODULE_INFO(livepatch, "Y");
diff --git a/samples/livepatch/livepatch-callbacks-mod.c b/samples/livepatch/livepatch-callbacks-mod.c
deleted file mode 100644
index 2a074f422a51..000000000000
--- a/samples/livepatch/livepatch-callbacks-mod.c
+++ /dev/null
@@ -1,41 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Copyright (C) 2017 Joe Lawrence <joe.lawrence@redhat.com>
- */
-
-/*
- * livepatch-callbacks-mod.c - (un)patching callbacks demo support module
- *
- *
- * Purpose
- * -------
- *
- * Simple module to demonstrate livepatch (un)patching callbacks.
- *
- *
- * Usage
- * -----
- *
- * This module is not intended to be standalone.  See the "Usage"
- * section of livepatch-callbacks-demo.c.
- */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-
-static int livepatch_callbacks_mod_init(void)
-{
-	pr_info("%s\n", __func__);
-	return 0;
-}
-
-static void livepatch_callbacks_mod_exit(void)
-{
-	pr_info("%s\n", __func__);
-}
-
-module_init(livepatch_callbacks_mod_init);
-module_exit(livepatch_callbacks_mod_exit);
-MODULE_LICENSE("GPL");
-- 
2.35.3


