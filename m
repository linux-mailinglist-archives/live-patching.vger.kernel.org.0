Return-Path: <live-patching+bounces-34-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DA257E7DFB
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 18:05:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3B23280F3A
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 17:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 520801DFD8;
	Fri, 10 Nov 2023 17:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="p00s/Bci"
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC35163B4
	for <live-patching@vger.kernel.org>; Fri, 10 Nov 2023 17:05:31 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A82442C3F;
	Fri, 10 Nov 2023 09:05:29 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 0CAEA1F8BD;
	Fri, 10 Nov 2023 17:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1699635928; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NtDSSLcV0byG9cvqCWu07Juf5CWHCIaEaSsBJ4qrCCs=;
	b=p00s/BciTlpwzMJpTTzS7kl5BUhFnhhbNVBw/IB99avja8qAt03zggWx589bLweml9t+Ig
	7kzHuIdwzyiYGFrJDNbnEDYIkpqMbCUIgzqndfRMVozdKAjFTy9vVFJAANr960c/HY2K6x
	UFL+AJudn1jve4UVPVbPVUlozCC6jzo=
Received: from alley.suse.cz (pmladek.udp.ovpn2.prg.suse.de [10.100.201.202])
	by relay2.suse.de (Postfix) with ESMTP id 99A2F2C4C5;
	Fri, 10 Nov 2023 17:05:27 +0000 (UTC)
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [POC 3/7] livepatch: Use per-state callbacks in state API tests
Date: Fri, 10 Nov 2023 18:04:24 +0100
Message-Id: <20231110170428.6664-4-pmladek@suse.com>
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

Recent changes in the livepatch core have allowed to connect states,
shadow variables, and callbacks. Use these new features in
the state tests.

Use the shadow variable API to store the original loglevel. It is
better suited for this purpose than directly accessing the .data
pointer in state klp_state.

Another big advantage is that the shadow variable is preserved
when the current patch is replaced by a new version. As a result,
there is not need to copy the pointer.

Finally, the lifetime of the shadow variable is connected with
the lifetime of the state. It is freed automatically when
it is not longer supported.

This results into the following changes in the code:

  + Rename CONSOLE_LOGLEVEL_STATE -> CONSOLE_LOGLEVEL_FIX_ID
    because it will be used also the for shadow variable

  + Remove the extra code for module coming and going states
    because the new callback are per-state.

  + Remove callbacks needed to transfer the pointer between
    states.

  + Keep the versioning of the state to prevent downgrade.
    The problem is artificial because no callbacks are
    needed to transfer or free the shadow variable anymore.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 lib/livepatch/test_klp_state.c                | 113 +++++------
 lib/livepatch/test_klp_state2.c               | 190 +-----------------
 .../testing/selftests/livepatch/test-state.sh |  44 ++--
 3 files changed, 76 insertions(+), 271 deletions(-)

diff --git a/lib/livepatch/test_klp_state.c b/lib/livepatch/test_klp_state.c
index 57a4253acb01..b3d1ee48dfcc 100644
--- a/lib/livepatch/test_klp_state.c
+++ b/lib/livepatch/test_klp_state.c
@@ -9,108 +9,109 @@
 #include <linux/printk.h>
 #include <linux/livepatch.h>
 
-#define CONSOLE_LOGLEVEL_STATE 1
-/* Version 1 does not support migration. */
-#define CONSOLE_LOGLEVEL_STATE_VERSION 1
+#define CONSOLE_LOGLEVEL_FIX_ID 1
 
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
+/*
+ * Version of the state which defines compatibility of livepaches.
+ * The value is artificial. It set just for testing the compatibility
+ * checks. In reality, all versions are compatible because all
+ * the callbacks do nothing and the shadow variable clean up
+ * is done by the core.
+ */
+#ifndef CONSOLE_LOGLEVEL_FIX_VERSION
+#define CONSOLE_LOGLEVEL_FIX_VERSION 1
+#endif
 
 static struct klp_patch patch;
 
 static int allocate_loglevel_state(void)
 {
-	struct klp_state *loglevel_state;
+	int *shadow_console_loglevel;
 
-	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
-	if (!loglevel_state)
-		return -EINVAL;
+	/* Make sure that the shadow variable does not exist yet. */
+	shadow_console_loglevel =
+		klp_shadow_alloc(&console_loglevel, CONSOLE_LOGLEVEL_FIX_ID,
+				 sizeof(*shadow_console_loglevel), GFP_KERNEL,
+				 NULL, NULL);
 
-	loglevel_state->data = kzalloc(sizeof(console_loglevel), GFP_KERNEL);
-	if (!loglevel_state->data)
+	if (!shadow_console_loglevel) {
+		pr_err("%s: failed to allocated shadow variable for storing original loglevel\n",
+		       __func__);
 		return -ENOMEM;
+	}
 
 	pr_info("%s: allocating space to store console_loglevel\n",
 		__func__);
+
 	return 0;
 }
 
 static void fix_console_loglevel(void)
 {
-	struct klp_state *loglevel_state;
+	int *shadow_console_loglevel;
 
-	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
-	if (!loglevel_state)
+	shadow_console_loglevel =
+		(int *)klp_shadow_get(&console_loglevel, CONSOLE_LOGLEVEL_FIX_ID);
+	if (!shadow_console_loglevel)
 		return;
 
 	pr_info("%s: fixing console_loglevel\n", __func__);
-	*(int *)loglevel_state->data = console_loglevel;
+	*shadow_console_loglevel = console_loglevel;
 	console_loglevel = CONSOLE_LOGLEVEL_MOTORMOUTH;
 }
 
 static void restore_console_loglevel(void)
 {
-	struct klp_state *loglevel_state;
+	int *shadow_console_loglevel;
 
-	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
-	if (!loglevel_state)
+	shadow_console_loglevel =
+		(int *)klp_shadow_get(&console_loglevel, CONSOLE_LOGLEVEL_FIX_ID);
+	if (!shadow_console_loglevel)
 		return;
 
 	pr_info("%s: restoring console_loglevel\n", __func__);
-	console_loglevel = *(int *)loglevel_state->data;
+	console_loglevel = *shadow_console_loglevel;
 }
 
 static void free_loglevel_state(void)
 {
-	struct klp_state *loglevel_state;
+	int *shadow_console_loglevel;
 
-	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
-	if (!loglevel_state)
+	shadow_console_loglevel =
+		(int *)klp_shadow_get(&console_loglevel, CONSOLE_LOGLEVEL_FIX_ID);
+	if (!shadow_console_loglevel)
 		return;
 
 	pr_info("%s: freeing space for the stored console_loglevel\n",
 		__func__);
-	kfree(loglevel_state->data);
+	klp_shadow_free(&console_loglevel, CONSOLE_LOGLEVEL_FIX_ID, NULL);
 }
 
-/* Executed on object patching (ie, patch enablement) */
-static int pre_patch_callback(struct klp_object *obj)
+/* Executed before patching when the state is new. */
+static int setup_state_callback(struct klp_patch *patch, struct klp_state *state)
 {
-	callback_info(__func__, obj);
+	pr_info("%s: state %lu\n", __func__, state->id);
 	return allocate_loglevel_state();
 }
 
-/* Executed on object unpatching (ie, patch disablement) */
-static void post_patch_callback(struct klp_object *obj)
+/* Executed after patching when the state is new. */
+static void enable_state_callback(struct klp_patch *patch, struct klp_state *state)
 {
-	callback_info(__func__, obj);
+	pr_info("%s: state %lu\n", __func__, state->id);
 	fix_console_loglevel();
 }
 
-/* Executed on object unpatching (ie, patch disablement) */
-static void pre_unpatch_callback(struct klp_object *obj)
+/* Executed before unpatching when the state is obsoleted. */
+static void disable_state_callback(struct klp_patch *patch, struct klp_state *state)
 {
-	callback_info(__func__, obj);
+	pr_info("%s: state %lu\n", __func__, state->id);
 	restore_console_loglevel();
 }
 
-/* Executed on object unpatching (ie, patch disablement) */
-static void post_unpatch_callback(struct klp_object *obj)
+/* Executed after unpatching when the state is obsoleted. */
+static void release_state_callback(struct klp_patch *patch, struct klp_state *state)
 {
-	callback_info(__func__, obj);
+	pr_info("%s: state %lu\n", __func__, state->id);
 	free_loglevel_state();
 }
 
@@ -122,19 +123,19 @@ static struct klp_object objs[] = {
 	{
 		.name = NULL,	/* vmlinux */
 		.funcs = no_funcs,
-		.callbacks = {
-			.pre_patch = pre_patch_callback,
-			.post_patch = post_patch_callback,
-			.pre_unpatch = pre_unpatch_callback,
-			.post_unpatch = post_unpatch_callback,
-		},
 	}, { }
 };
 
 static struct klp_state states[] = {
 	{
-		.id = CONSOLE_LOGLEVEL_STATE,
-		.version = CONSOLE_LOGLEVEL_STATE_VERSION,
+		.id = CONSOLE_LOGLEVEL_FIX_ID,
+		.version = CONSOLE_LOGLEVEL_FIX_VERSION,
+		.callbacks = {
+			.setup = setup_state_callback,
+			.enable = enable_state_callback,
+			.disable = disable_state_callback,
+			.release = release_state_callback,
+		},
 	}, { }
 };
 
diff --git a/lib/livepatch/test_klp_state2.c b/lib/livepatch/test_klp_state2.c
index c978ea4d5e67..128855764bf8 100644
--- a/lib/livepatch/test_klp_state2.c
+++ b/lib/livepatch/test_klp_state2.c
@@ -1,191 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (C) 2019 SUSE
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#define CONSOLE_LOGLEVEL_FIX_VERSION 2
 
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/printk.h>
-#include <linux/livepatch.h>
-
-#define CONSOLE_LOGLEVEL_STATE 1
-/* Version 2 supports migration. */
-#define CONSOLE_LOGLEVEL_STATE_VERSION 2
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
-static struct klp_patch patch;
-
-static int allocate_loglevel_state(void)
-{
-	struct klp_state *loglevel_state, *prev_loglevel_state;
-
-	prev_loglevel_state = klp_get_prev_state(CONSOLE_LOGLEVEL_STATE);
-	if (prev_loglevel_state) {
-		pr_info("%s: space to store console_loglevel already allocated\n",
-		__func__);
-		return 0;
-	}
-
-	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
-	if (!loglevel_state)
-		return -EINVAL;
-
-	loglevel_state->data = kzalloc(sizeof(console_loglevel), GFP_KERNEL);
-	if (!loglevel_state->data)
-		return -ENOMEM;
-
-	pr_info("%s: allocating space to store console_loglevel\n",
-		__func__);
-	return 0;
-}
-
-static void fix_console_loglevel(void)
-{
-	struct klp_state *loglevel_state, *prev_loglevel_state;
-
-	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
-	if (!loglevel_state)
-		return;
-
-	prev_loglevel_state = klp_get_prev_state(CONSOLE_LOGLEVEL_STATE);
-	if (prev_loglevel_state) {
-		pr_info("%s: taking over the console_loglevel change\n",
-		__func__);
-		loglevel_state->data = prev_loglevel_state->data;
-		return;
-	}
-
-	pr_info("%s: fixing console_loglevel\n", __func__);
-	*(int *)loglevel_state->data = console_loglevel;
-	console_loglevel = CONSOLE_LOGLEVEL_MOTORMOUTH;
-}
-
-static void restore_console_loglevel(void)
-{
-	struct klp_state *loglevel_state, *prev_loglevel_state;
-
-	prev_loglevel_state = klp_get_prev_state(CONSOLE_LOGLEVEL_STATE);
-	if (prev_loglevel_state) {
-		pr_info("%s: passing the console_loglevel change back to the old livepatch\n",
-		__func__);
-		return;
-	}
-
-	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
-	if (!loglevel_state)
-		return;
-
-	pr_info("%s: restoring console_loglevel\n", __func__);
-	console_loglevel = *(int *)loglevel_state->data;
-}
-
-static void free_loglevel_state(void)
-{
-	struct klp_state *loglevel_state, *prev_loglevel_state;
-
-	prev_loglevel_state = klp_get_prev_state(CONSOLE_LOGLEVEL_STATE);
-	if (prev_loglevel_state) {
-		pr_info("%s: keeping space to store console_loglevel\n",
-		__func__);
-		return;
-	}
-
-	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
-	if (!loglevel_state)
-		return;
-
-	pr_info("%s: freeing space for the stored console_loglevel\n",
-		__func__);
-	kfree(loglevel_state->data);
-}
-
-/* Executed on object patching (ie, patch enablement) */
-static int pre_patch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
-	return allocate_loglevel_state();
-}
-
-/* Executed on object unpatching (ie, patch disablement) */
-static void post_patch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
-	fix_console_loglevel();
-}
-
-/* Executed on object unpatching (ie, patch disablement) */
-static void pre_unpatch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
-	restore_console_loglevel();
-}
-
-/* Executed on object unpatching (ie, patch disablement) */
-static void post_unpatch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
-	free_loglevel_state();
-}
-
-static struct klp_func no_funcs[] = {
-	{}
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
-	}, { }
-};
-
-static struct klp_state states[] = {
-	{
-		.id = CONSOLE_LOGLEVEL_STATE,
-		.version = CONSOLE_LOGLEVEL_STATE_VERSION,
-	}, { }
-};
-
-static struct klp_patch patch = {
-	.mod = THIS_MODULE,
-	.objs = objs,
-	.states = states,
-	.replace = true,
-};
-
-static int test_klp_callbacks_demo_init(void)
-{
-	return klp_enable_patch(&patch);
-}
-
-static void test_klp_callbacks_demo_exit(void)
-{
-}
-
-module_init(test_klp_callbacks_demo_init);
-module_exit(test_klp_callbacks_demo_exit);
-MODULE_LICENSE("GPL");
-MODULE_INFO(livepatch, "Y");
-MODULE_AUTHOR("Petr Mladek <pmladek@suse.com>");
-MODULE_DESCRIPTION("Livepatch test: system state modification");
+/* The console loglevel fix is the same in the next cumulative patch. */
+#include "test_klp_state.c"
diff --git a/tools/testing/selftests/livepatch/test-state.sh b/tools/testing/selftests/livepatch/test-state.sh
index 38656721c958..a3c933ea96fc 100755
--- a/tools/testing/selftests/livepatch/test-state.sh
+++ b/tools/testing/selftests/livepatch/test-state.sh
@@ -22,20 +22,20 @@ unload_lp $MOD_LIVEPATCH
 check_result "% modprobe $MOD_LIVEPATCH
 livepatch: enabling patch '$MOD_LIVEPATCH'
 livepatch: '$MOD_LIVEPATCH': initializing patching transition
-$MOD_LIVEPATCH: pre_patch_callback: vmlinux
+$MOD_LIVEPATCH: setup_state_callback: state 1
 $MOD_LIVEPATCH: allocate_loglevel_state: allocating space to store console_loglevel
 livepatch: '$MOD_LIVEPATCH': starting patching transition
 livepatch: '$MOD_LIVEPATCH': completing patching transition
-$MOD_LIVEPATCH: post_patch_callback: vmlinux
+$MOD_LIVEPATCH: enable_state_callback: state 1
 $MOD_LIVEPATCH: fix_console_loglevel: fixing console_loglevel
 livepatch: '$MOD_LIVEPATCH': patching complete
 % echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
 livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-$MOD_LIVEPATCH: pre_unpatch_callback: vmlinux
+$MOD_LIVEPATCH: disable_state_callback: state 1
 $MOD_LIVEPATCH: restore_console_loglevel: restoring console_loglevel
 livepatch: '$MOD_LIVEPATCH': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-$MOD_LIVEPATCH: post_unpatch_callback: vmlinux
+$MOD_LIVEPATCH: release_state_callback: state 1
 $MOD_LIVEPATCH: free_loglevel_state: freeing space for the stored console_loglevel
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
@@ -54,31 +54,27 @@ unload_lp $MOD_LIVEPATCH2
 check_result "% modprobe $MOD_LIVEPATCH
 livepatch: enabling patch '$MOD_LIVEPATCH'
 livepatch: '$MOD_LIVEPATCH': initializing patching transition
-$MOD_LIVEPATCH: pre_patch_callback: vmlinux
+$MOD_LIVEPATCH: setup_state_callback: state 1
 $MOD_LIVEPATCH: allocate_loglevel_state: allocating space to store console_loglevel
 livepatch: '$MOD_LIVEPATCH': starting patching transition
 livepatch: '$MOD_LIVEPATCH': completing patching transition
-$MOD_LIVEPATCH: post_patch_callback: vmlinux
+$MOD_LIVEPATCH: enable_state_callback: state 1
 $MOD_LIVEPATCH: fix_console_loglevel: fixing console_loglevel
 livepatch: '$MOD_LIVEPATCH': patching complete
 % modprobe $MOD_LIVEPATCH2
 livepatch: enabling patch '$MOD_LIVEPATCH2'
 livepatch: '$MOD_LIVEPATCH2': initializing patching transition
-$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
-$MOD_LIVEPATCH2: allocate_loglevel_state: space to store console_loglevel already allocated
 livepatch: '$MOD_LIVEPATCH2': starting patching transition
 livepatch: '$MOD_LIVEPATCH2': completing patching transition
-$MOD_LIVEPATCH2: post_patch_callback: vmlinux
-$MOD_LIVEPATCH2: fix_console_loglevel: taking over the console_loglevel change
 livepatch: '$MOD_LIVEPATCH2': patching complete
 % rmmod $MOD_LIVEPATCH
 % echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH2/enabled
 livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
-$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
+$MOD_LIVEPATCH2: disable_state_callback: state 1
 $MOD_LIVEPATCH2: restore_console_loglevel: restoring console_loglevel
 livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
-$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
+$MOD_LIVEPATCH2: release_state_callback: state 1
 $MOD_LIVEPATCH2: free_loglevel_state: freeing space for the stored console_loglevel
 livepatch: '$MOD_LIVEPATCH2': unpatching complete
 % rmmod $MOD_LIVEPATCH2"
@@ -99,41 +95,33 @@ unload_lp $MOD_LIVEPATCH3
 check_result "% modprobe $MOD_LIVEPATCH2
 livepatch: enabling patch '$MOD_LIVEPATCH2'
 livepatch: '$MOD_LIVEPATCH2': initializing patching transition
-$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
+$MOD_LIVEPATCH2: setup_state_callback: state 1
 $MOD_LIVEPATCH2: allocate_loglevel_state: allocating space to store console_loglevel
 livepatch: '$MOD_LIVEPATCH2': starting patching transition
 livepatch: '$MOD_LIVEPATCH2': completing patching transition
-$MOD_LIVEPATCH2: post_patch_callback: vmlinux
+$MOD_LIVEPATCH2: enable_state_callback: state 1
 $MOD_LIVEPATCH2: fix_console_loglevel: fixing console_loglevel
 livepatch: '$MOD_LIVEPATCH2': patching complete
 % modprobe $MOD_LIVEPATCH3
 livepatch: enabling patch '$MOD_LIVEPATCH3'
 livepatch: '$MOD_LIVEPATCH3': initializing patching transition
-$MOD_LIVEPATCH3: pre_patch_callback: vmlinux
-$MOD_LIVEPATCH3: allocate_loglevel_state: space to store console_loglevel already allocated
 livepatch: '$MOD_LIVEPATCH3': starting patching transition
 livepatch: '$MOD_LIVEPATCH3': completing patching transition
-$MOD_LIVEPATCH3: post_patch_callback: vmlinux
-$MOD_LIVEPATCH3: fix_console_loglevel: taking over the console_loglevel change
 livepatch: '$MOD_LIVEPATCH3': patching complete
 % rmmod $MOD_LIVEPATCH2
 % modprobe $MOD_LIVEPATCH2
 livepatch: enabling patch '$MOD_LIVEPATCH2'
 livepatch: '$MOD_LIVEPATCH2': initializing patching transition
-$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
-$MOD_LIVEPATCH2: allocate_loglevel_state: space to store console_loglevel already allocated
 livepatch: '$MOD_LIVEPATCH2': starting patching transition
 livepatch: '$MOD_LIVEPATCH2': completing patching transition
-$MOD_LIVEPATCH2: post_patch_callback: vmlinux
-$MOD_LIVEPATCH2: fix_console_loglevel: taking over the console_loglevel change
 livepatch: '$MOD_LIVEPATCH2': patching complete
 % echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH2/enabled
 livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
-$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
+$MOD_LIVEPATCH2: disable_state_callback: state 1
 $MOD_LIVEPATCH2: restore_console_loglevel: restoring console_loglevel
 livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
-$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
+$MOD_LIVEPATCH2: release_state_callback: state 1
 $MOD_LIVEPATCH2: free_loglevel_state: freeing space for the stored console_loglevel
 livepatch: '$MOD_LIVEPATCH2': unpatching complete
 % rmmod $MOD_LIVEPATCH2
@@ -152,11 +140,11 @@ unload_lp $MOD_LIVEPATCH2
 check_result "% modprobe $MOD_LIVEPATCH2
 livepatch: enabling patch '$MOD_LIVEPATCH2'
 livepatch: '$MOD_LIVEPATCH2': initializing patching transition
-$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
+$MOD_LIVEPATCH2: setup_state_callback: state 1
 $MOD_LIVEPATCH2: allocate_loglevel_state: allocating space to store console_loglevel
 livepatch: '$MOD_LIVEPATCH2': starting patching transition
 livepatch: '$MOD_LIVEPATCH2': completing patching transition
-$MOD_LIVEPATCH2: post_patch_callback: vmlinux
+$MOD_LIVEPATCH2: enable_state_callback: state 1
 $MOD_LIVEPATCH2: fix_console_loglevel: fixing console_loglevel
 livepatch: '$MOD_LIVEPATCH2': patching complete
 % modprobe $MOD_LIVEPATCH
@@ -164,11 +152,11 @@ livepatch: Livepatch patch ($MOD_LIVEPATCH) is not compatible with the already i
 modprobe: ERROR: could not insert '$MOD_LIVEPATCH': Invalid argument
 % echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH2/enabled
 livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
-$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
+$MOD_LIVEPATCH2: disable_state_callback: state 1
 $MOD_LIVEPATCH2: restore_console_loglevel: restoring console_loglevel
 livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
-$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
+$MOD_LIVEPATCH2: release_state_callback: state 1
 $MOD_LIVEPATCH2: free_loglevel_state: freeing space for the stored console_loglevel
 livepatch: '$MOD_LIVEPATCH2': unpatching complete
 % rmmod $MOD_LIVEPATCH2"
-- 
2.35.3


