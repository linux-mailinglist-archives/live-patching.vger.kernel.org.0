Return-Path: <live-patching+bounces-38-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6A637E7DFF
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 18:06:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FEB7280F53
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 17:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ECE81DFF6;
	Fri, 10 Nov 2023 17:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fBvf7d41"
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8AC1DDFA
	for <live-patching@vger.kernel.org>; Fri, 10 Nov 2023 17:06:18 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12C4431C8;
	Fri, 10 Nov 2023 09:06:15 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 585DA219A8;
	Fri, 10 Nov 2023 17:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1699635974; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=giYunGuYrxM57Pa0IasakG1uBcbk7GI9phg0VBSv0W0=;
	b=fBvf7d41y32jA5uc4u/PcT+qkob4AqRSjqcNB8fa0TIPyczwhPZ27qpLUBPAgNSswTVt+b
	JLRGtWp6l4Ci3pqnNSCQuPJD3+0nHSZPcvZSeOiv0vRxV5e5AnMnC2j3qtbUfWVkAI2SsQ
	/+J5xvP/vRNacRwnNux7lwS7pcS87UU=
Received: from alley.suse.cz (pmladek.udp.ovpn2.prg.suse.de [10.100.201.202])
	by relay2.suse.de (Postfix) with ESMTP id EB6342CA2E;
	Fri, 10 Nov 2023 17:06:13 +0000 (UTC)
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [POC 7/7] livepatching: Remove per-state version
Date: Fri, 10 Nov 2023 18:04:28 +0100
Message-Id: <20231110170428.6664-8-pmladek@suse.com>
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

The livepatch state API was added to help with maintaining:

   + changes done by livepatch callbasks
   + lifetime of shadow variables

The original API was hard to use. Both objectives are better handled
by the new per-state callbacks. They are called when the state is
introduced or removed. There is also support for automatically freeing
obsolete shadow variables.

The new callbacks changed the view of compatibility.  The livepatch
can be replaced to any older one as long the current livepatch is
able to disable the obsolete state.

As a result, the new patch does not need to support the currently
used states. The current patch will be able to disable them.

The remaining question is what to do with the per-state version.
It was supposed to allow doing more modifications on an existing
state. The experience shows that it is not needed in practice.

Well, it still might make sense to prevent downgrade when the state
could not be disabled easily or when the author does not want to
deal with it.

Replace the per-state version with per-state block_disable flag.
It allows to handle several scenarios:

  + prevent disabling the livepatch when it does not support
    a particular state disablement.

  + prevent replacing the livepatch when the state is not supported
    by the new patch and the current patch does not support
    a particular state disablement.

  + allow to replace the livepatch with a new one which would
    support the particular state disablement.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/livepatch.h                     |   7 +-
 kernel/livepatch/core.c                       |  17 ++-
 kernel/livepatch/state.c                      |  27 +++--
 kernel/livepatch/state.h                      |   1 +
 lib/livepatch/test_klp_state.c                | 101 +++++++++++++-----
 lib/livepatch/test_klp_state2.c               |   2 -
 lib/livepatch/test_klp_state3.c               |   2 +-
 .../testing/selftests/livepatch/functions.sh  |  17 +++
 .../testing/selftests/livepatch/test-state.sh |  40 ++++---
 9 files changed, 158 insertions(+), 56 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 3807c7bb0281..c7c2c013b380 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -140,16 +140,16 @@ struct klp_state_callbacks {
 /**
  * struct klp_state - state of the system modified by the livepatch
  * @id:		system state identifier (non-zero)
- * @version:	version of the change
  * @callbacks:	optional callbacks used when introducing or removing the state
+ * @block_disable: the state disablement is not supported
  * @is_shadow:  the state handles lifetime of a shadow variable
  *		with the same @id
  * @data:	custom data
  */
 struct klp_state {
 	unsigned long id;
-	unsigned int version;
 	struct klp_state_callbacks callbacks;
+	bool block_disable;
 	bool is_shadow;
 	void *data;
 };
@@ -159,7 +159,9 @@ struct klp_state {
  * @mod:	reference to the live patch module
  * @objs:	object entries for kernel objects to be patched
  * @states:	system states that can get modified
+ * version:	livepatch version (optional)
  * @replace:	replace all actively used patches
+ *
  * @list:	list node for global list of actively used patches
  * @kobj:	kobject for sysfs resources
  * @obj_list:	dynamic list of the object entries
@@ -173,6 +175,7 @@ struct klp_patch {
 	struct module *mod;
 	struct klp_object *objs;
 	struct klp_state *states;
+	unsigned int version;
 	bool replace;
 
 	/* internal */
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index d982365777f1..81fbe0778742 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -373,6 +373,13 @@ static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
 		goto out;
 	}
 
+	if (patch->enabled && klp_patch_disable_blocked(patch)) {
+		pr_err("The livepatch '%s' does not support disable\n",
+		       patch->mod->name);
+		ret = -EINVAL;
+		goto out;
+	}
+
 	/*
 	 * Allow to reverse a pending transition in both ways. It might be
 	 * necessary to complete the transition without forcing and breaking
@@ -1097,10 +1104,10 @@ int klp_enable_patch(struct klp_patch *patch)
 
 	if (!klp_is_patch_compatible(patch)) {
 		pr_err("Livepatch patch (%s) is not compatible with the already installed livepatches.\n",
-			patch->mod->name);
+		       patch->mod->name);
 		mutex_unlock(&klp_mutex);
 		return -EINVAL;
-	}
+       }
 
 	if (!try_module_get(patch->mod)) {
 		mutex_unlock(&klp_mutex);
@@ -1111,17 +1118,17 @@ int klp_enable_patch(struct klp_patch *patch)
 
 	ret = klp_init_patch(patch);
 	if (ret)
-		goto err;
+		goto unlock_free;
 
 	ret = __klp_enable_patch(patch);
 	if (ret)
-		goto err;
+		goto unlock_free;
 
 	mutex_unlock(&klp_mutex);
 
 	return 0;
 
-err:
+unlock_free:
 	klp_free_patch_start(patch);
 
 	mutex_unlock(&klp_mutex);
diff --git a/kernel/livepatch/state.c b/kernel/livepatch/state.c
index 4ec65afe3a43..0647cc688f38 100644
--- a/kernel/livepatch/state.c
+++ b/kernel/livepatch/state.c
@@ -91,23 +91,26 @@ static bool klp_is_state_compatible(struct klp_patch *patch,
 
 	state = klp_get_state(patch, old_state->id);
 
-	/* A cumulative livepatch must handle all already modified states. */
-	if (!state)
-		return !patch->replace;
+	if (!state && old_state->block_disable)
+		return false;
 
-	return state->version >= old_state->version;
+	return true;
 }
 
 /*
  * Check that the new livepatch will not break the existing system states.
- * Cumulative patches must handle all already modified states.
- * Non-cumulative patches can touch already modified states.
+ * The patch could replace existing patches only when the obsolete
+ * states can be disabled.
  */
 bool klp_is_patch_compatible(struct klp_patch *patch)
 {
 	struct klp_patch *old_patch;
 	struct klp_state *old_state;
 
+	/* Non-cumulative patches are always compatible. */
+	if (!patch->replace)
+		return true;
+
 	klp_for_each_patch(old_patch) {
 		klp_for_each_state(old_patch, old_state) {
 			if (!klp_is_state_compatible(patch, old_state))
@@ -118,6 +121,18 @@ bool klp_is_patch_compatible(struct klp_patch *patch)
 	return true;
 }
 
+bool klp_patch_disable_blocked(struct klp_patch *patch)
+{
+	struct klp_state *state;
+
+	klp_for_each_state(patch, state) {
+		if (state->block_disable)
+			return true;
+	}
+
+	return false;
+}
+
 bool is_state_in_other_patches(struct klp_patch *patch, struct klp_state *state)
 {
 	struct klp_patch *old_patch;
diff --git a/kernel/livepatch/state.h b/kernel/livepatch/state.h
index e9940e7f00dd..74cd9d8f63c5 100644
--- a/kernel/livepatch/state.h
+++ b/kernel/livepatch/state.h
@@ -5,6 +5,7 @@
 #include <linux/livepatch.h>
 
 bool klp_is_patch_compatible(struct klp_patch *patch);
+bool klp_patch_disable_blocked(struct klp_patch *patch);
 int klp_setup_states(struct klp_patch *patch);
 void klp_enable_states(struct klp_patch *patch);
 void klp_disable_states(struct klp_patch *patch);
diff --git a/lib/livepatch/test_klp_state.c b/lib/livepatch/test_klp_state.c
index b3d1ee48dfcc..ec9bf4f37b26 100644
--- a/lib/livepatch/test_klp_state.c
+++ b/lib/livepatch/test_klp_state.c
@@ -11,17 +11,6 @@
 
 #define CONSOLE_LOGLEVEL_FIX_ID 1
 
-/*
- * Version of the state which defines compatibility of livepaches.
- * The value is artificial. It set just for testing the compatibility
- * checks. In reality, all versions are compatible because all
- * the callbacks do nothing and the shadow variable clean up
- * is done by the core.
- */
-#ifndef CONSOLE_LOGLEVEL_FIX_VERSION
-#define CONSOLE_LOGLEVEL_FIX_VERSION 1
-#endif
-
 static struct klp_patch patch;
 
 static int allocate_loglevel_state(void)
@@ -115,6 +104,80 @@ static void release_state_callback(struct klp_patch *patch, struct klp_state *st
 	free_loglevel_state();
 }
 
+static struct klp_state states[] = {
+	{
+		.id = CONSOLE_LOGLEVEL_FIX_ID,
+		.callbacks = {
+			.setup = setup_state_callback,
+			.enable = enable_state_callback,
+			.disable = disable_state_callback,
+			.release = release_state_callback,
+		},
+	}, { }
+};
+
+static int block_state_disable_get(char *buffer, const struct kernel_param *kp)
+{
+	pr_info("%s: Disable transition is %s by state: %lu\n",
+		__func__,
+		states[0].block_disable ? "not supported" : "supported",
+		states[0].id);
+
+	return 0;
+}
+
+static int block_state_disable_set(const char *val, const struct kernel_param *kp)
+{
+	bool block;
+	int ret;
+
+	ret = kstrtobool(val, &block);
+	if (ret)
+		return ret;
+
+	states[0].block_disable = block;
+
+	return 0;
+}
+
+static const struct kernel_param_ops block_state_disable_ops = {
+	.get	= block_state_disable_get,
+	.set	= block_state_disable_set,
+};
+
+module_param_cb(block_state_disable, &block_state_disable_ops, NULL, 0600);
+MODULE_PARM_DESC(block_state_disable, "Set to 1 to pretend that the state does not support disable operation (default = 0).");
+
+bool no_state;
+
+static int no_state_get(char *buffer, const struct kernel_param *kp)
+{
+	return sysfs_emit("%s", no_state ? "1" : "0");
+}
+
+static int no_state_set(const char *val, const struct kernel_param *kp)
+{
+	bool no;
+	int ret;
+
+	ret = kstrtobool(val, &no);
+	if (ret)
+		return ret;
+
+	no_state = no;
+
+	return 0;
+}
+
+static const struct kernel_param_ops no_state_ops = {
+	.get	= no_state_get,
+	.set	= no_state_set,
+};
+
+module_param_cb(no_state, &no_state_ops, NULL, 0400);
+MODULE_PARM_DESC(no_state, "Set to 1 when the livepatch should not support the state. (default = 0).");
+
+
 static struct klp_func no_funcs[] = {
 	{}
 };
@@ -126,19 +189,6 @@ static struct klp_object objs[] = {
 	}, { }
 };
 
-static struct klp_state states[] = {
-	{
-		.id = CONSOLE_LOGLEVEL_FIX_ID,
-		.version = CONSOLE_LOGLEVEL_FIX_VERSION,
-		.callbacks = {
-			.setup = setup_state_callback,
-			.enable = enable_state_callback,
-			.disable = disable_state_callback,
-			.release = release_state_callback,
-		},
-	}, { }
-};
-
 static struct klp_patch patch = {
 	.mod = THIS_MODULE,
 	.objs = objs,
@@ -148,6 +198,9 @@ static struct klp_patch patch = {
 
 static int test_klp_callbacks_demo_init(void)
 {
+	if (no_state)
+		patch.states = NULL;
+
 	return klp_enable_patch(&patch);
 }
 
diff --git a/lib/livepatch/test_klp_state2.c b/lib/livepatch/test_klp_state2.c
index 128855764bf8..b8fe1ca2d802 100644
--- a/lib/livepatch/test_klp_state2.c
+++ b/lib/livepatch/test_klp_state2.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (C) 2019 SUSE
 
-#define CONSOLE_LOGLEVEL_FIX_VERSION 2
-
 /* The console loglevel fix is the same in the next cumulative patch. */
 #include "test_klp_state.c"
diff --git a/lib/livepatch/test_klp_state3.c b/lib/livepatch/test_klp_state3.c
index 9226579d10c5..b8fe1ca2d802 100644
--- a/lib/livepatch/test_klp_state3.c
+++ b/lib/livepatch/test_klp_state3.c
@@ -2,4 +2,4 @@
 // Copyright (C) 2019 SUSE
 
 /* The console loglevel fix is the same in the next cumulative patch. */
-#include "test_klp_state2.c"
+#include "test_klp_state.c"
diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index a962119f053e..5e2569bff126 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -277,6 +277,23 @@ function set_pre_patch_ret {
 		die "failed to set pre_patch_ret parameter for $mod module"
 }
 
+# set_module_param(modname, param, val)
+#	modname - module name to set
+#	param - name of the parameter to set
+#       val - value to set
+function set_module_param {
+	local mod="$1"; shift
+	local param="$1"; shift
+	local val="$1"
+
+	log "% echo $val > /sys/module/$mod/parameters/$param"
+	echo "$val" > "/sys/module/$mod/parameters/$param"
+
+	# Wait for sysfs value to hold ...
+	loop_until '[[ $(cat "/sys/module/$mod/parameters/$param") == "$val" ]]' ||
+		die "failed to set parameter $param for $mod module to the value $val"
+}
+
 # read_module_param(modname, param)
 #	modname - module name which provides the given parameter
 #	param - parameter name to be read
diff --git a/tools/testing/selftests/livepatch/test-state.sh b/tools/testing/selftests/livepatch/test-state.sh
index a3c933ea96fc..72387b5775c6 100755
--- a/tools/testing/selftests/livepatch/test-state.sh
+++ b/tools/testing/selftests/livepatch/test-state.sh
@@ -132,12 +132,14 @@ livepatch: '$MOD_LIVEPATCH2': unpatching complete
 
 start_test "incompatible cumulative livepatches"
 
-load_lp $MOD_LIVEPATCH2
-load_failing_mod $MOD_LIVEPATCH
-disable_lp $MOD_LIVEPATCH2
-unload_lp $MOD_LIVEPATCH2
+load_lp $MOD_LIVEPATCH2 block_state_disable=1
+load_failing_mod $MOD_LIVEPATCH no_state=1
+# load the livepatch again with default features (state and disable supported)
+load_lp $MOD_LIVEPATCH
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
 
-check_result "% modprobe $MOD_LIVEPATCH2
+check_result "% modprobe $MOD_LIVEPATCH2 block_state_disable=1
 livepatch: enabling patch '$MOD_LIVEPATCH2'
 livepatch: '$MOD_LIVEPATCH2': initializing patching transition
 $MOD_LIVEPATCH2: setup_state_callback: state 1
@@ -147,18 +149,24 @@ livepatch: '$MOD_LIVEPATCH2': completing patching transition
 $MOD_LIVEPATCH2: enable_state_callback: state 1
 $MOD_LIVEPATCH2: fix_console_loglevel: fixing console_loglevel
 livepatch: '$MOD_LIVEPATCH2': patching complete
-% modprobe $MOD_LIVEPATCH
+% modprobe $MOD_LIVEPATCH no_state=1
 livepatch: Livepatch patch ($MOD_LIVEPATCH) is not compatible with the already installed livepatches.
 modprobe: ERROR: could not insert '$MOD_LIVEPATCH': Invalid argument
-% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH2/enabled
-livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
-$MOD_LIVEPATCH2: disable_state_callback: state 1
-$MOD_LIVEPATCH2: restore_console_loglevel: restoring console_loglevel
-livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
-$MOD_LIVEPATCH2: release_state_callback: state 1
-$MOD_LIVEPATCH2: free_loglevel_state: freeing space for the stored console_loglevel
-livepatch: '$MOD_LIVEPATCH2': unpatching complete
-% rmmod $MOD_LIVEPATCH2"
+% modprobe $MOD_LIVEPATCH
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+$MOD_LIVEPATCH: disable_state_callback: state 1
+$MOD_LIVEPATCH: restore_console_loglevel: restoring console_loglevel
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+$MOD_LIVEPATCH: release_state_callback: state 1
+$MOD_LIVEPATCH: free_loglevel_state: freeing space for the stored console_loglevel
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH"
 
 exit 0
-- 
2.35.3


