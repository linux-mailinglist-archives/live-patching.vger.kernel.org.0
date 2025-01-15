Return-Path: <live-patching+bounces-992-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B1F9A11BF4
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 09:29:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D97A167449
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 08:29:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1417428EC68;
	Wed, 15 Jan 2025 08:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PJcg60+/";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PJcg60+/"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401922500B0;
	Wed, 15 Jan 2025 08:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929665; cv=none; b=GfsQMEoYsgB6nM5mZmac0l6yjhtCt+Z5rzJEI9pof2Z8s8cUVuRsh6CK/qRZFKwucZsVJqaezqU8YzbHSWYrBO4zRgc04vnBY+nYoNOFF5ruRppvDuxMTlRTqipjR0sE26EiRWQ95IL+boefMpQJjBlt61brfx0ivNl+iE89Sfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929665; c=relaxed/simple;
	bh=lfpH+SYQPvS8eYAQu04yBbzDPitKpt3QeMnR9mGQzog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPVJYqzy744bCv9iEFi79toBEP4oQ7TKejT95InzrN7IT63Fb12OmdKW2KvNmi56TA7XEep5qzWec7IVTiQUdPUpmxRXa2z2UaL36wyN8DajY9Y6Pv8A9OzNCW1wSw6rZXPBsrq0xNJMY3rpvA5cfsecVMD3z3MPrIvhy8BkE1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PJcg60+/; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PJcg60+/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from pathway.suse.cz (unknown [10.100.201.202])
	by smtp-out2.suse.de (Postfix) with ESMTP id 4B6C81F44E;
	Wed, 15 Jan 2025 08:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929660; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pbWoPeMJynLa3RnHI5QerS0wmhJTAad8HekLmHmbViA=;
	b=PJcg60+/e7TR+QFKe4NCltQr/V/efw3hrNLou0On2UEkY8FqibVtFeElNyoM8HS3zq3kg7
	AHBE56iMz3IJWUqKeTswM2hk0aqjMJ/3kV9BXvxz8mnopl5g1jHQsR4uJ32pcCZM2tA3Yl
	FZ6WVwWrpAUaxfNqKBafn1BzUKRcgyE=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929660; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pbWoPeMJynLa3RnHI5QerS0wmhJTAad8HekLmHmbViA=;
	b=PJcg60+/e7TR+QFKe4NCltQr/V/efw3hrNLou0On2UEkY8FqibVtFeElNyoM8HS3zq3kg7
	AHBE56iMz3IJWUqKeTswM2hk0aqjMJ/3kV9BXvxz8mnopl5g1jHQsR4uJ32pcCZM2tA3Yl
	FZ6WVwWrpAUaxfNqKBafn1BzUKRcgyE=
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v1 17/19] samples/livepatch: Replace sample module with obsolete per-object callbacks
Date: Wed, 15 Jan 2025 09:24:29 +0100
Message-ID: <20250115082431.5550-18-pmladek@suse.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250115082431.5550-1-pmladek@suse.com>
References: <20250115082431.5550-1-pmladek@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_ZERO(0.00)[0];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLj3e56pwiuh8u4wxetmhsq5s5)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pathway.suse.cz:helo,suse.com:email,suse.com:mid]
X-Spam-Score: -6.80
X-Spam-Flag: NO

The per-object callbacks have been deprecated in favor of per-state
callbacks and are scheduled for removal.

Remove the sample modules with the obsolete per-object callbacks.
Instead add new sample modules based on the new selftests for
per-state callbacks.

The test modules are just renamed to follow the naming scheme of
the existing sample modules. Also only one version of the test
module and one version of the livepatch module is built.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 samples/livepatch/Makefile                    |   5 +-
 .../livepatch/livepatch-callbacks-busymod.c   |  60 ---
 samples/livepatch/livepatch-callbacks-demo.c  | 196 ---------
 samples/livepatch/livepatch-callbacks-mod.c   |  41 --
 samples/livepatch/livepatch-speaker-fix.c     | 376 ++++++++++++++++++
 samples/livepatch/livepatch-speaker-mod.c     | 203 ++++++++++
 samples/livepatch/livepatch-speaker.h         |  15 +
 7 files changed, 596 insertions(+), 300 deletions(-)
 delete mode 100644 samples/livepatch/livepatch-callbacks-busymod.c
 delete mode 100644 samples/livepatch/livepatch-callbacks-demo.c
 delete mode 100644 samples/livepatch/livepatch-callbacks-mod.c
 create mode 100644 samples/livepatch/livepatch-speaker-fix.c
 create mode 100644 samples/livepatch/livepatch-speaker-mod.c
 create mode 100644 samples/livepatch/livepatch-speaker.h

diff --git a/samples/livepatch/Makefile b/samples/livepatch/Makefile
index 9f853eeb6140..b3e2bc965a0c 100644
--- a/samples/livepatch/Makefile
+++ b/samples/livepatch/Makefile
@@ -3,6 +3,5 @@ obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-sample.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-shadow-mod.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-shadow-fix1.o
 obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-shadow-fix2.o
-obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-demo.o
-obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-mod.o
-obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-callbacks-busymod.o
+obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-speaker-mod.o
+obj-$(CONFIG_SAMPLE_LIVEPATCH) += livepatch-speaker-fix.o
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
diff --git a/samples/livepatch/livepatch-speaker-fix.c b/samples/livepatch/livepatch-speaker-fix.c
new file mode 100644
index 000000000000..bfeb6db42e33
--- /dev/null
+++ b/samples/livepatch/livepatch-speaker-fix.c
@@ -0,0 +1,376 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2024 SUSE
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+#include <linux/init.h>
+
+#include "livepatch-speaker.h"
+
+/**
+ * test_klp_speaker_livepatch - test livepatch for testing various livepatching
+ *	features.
+ *
+ * The livepatch modifies the behavior of a virtual speaker provided by
+ * the module test_klp_speaker. It can do:
+ *
+ *    - Improve the speaker's greeting from "Hello, World!" to
+ *	"Ladies and gentleman, ..."
+ *
+ *    - Support more speaker modules, see __lp_speaker_welcome().
+ *
+ *    - Livepatch block_doors_func() which can block the transition.
+ *
+ *    - Support testing of more shadow variables and state callbacks. see
+ *	"applause", and "applause2" module parameters.
+ *
+ *    - Allow to enable the atomic replace via "replace" parameter.
+ */
+
+#define APPLAUSE_NUM 2
+#define APPLAUSE_START_ID 10
+#define APPLAUSE_STR_SIZE 16
+#define APPLAUSE_IDX_STR_SIZE 8
+
+/* associate the shadow variable with NULL address */;
+static void *shadow_object = NULL;
+
+static bool add_applause[APPLAUSE_NUM];
+module_param_named(applause, add_applause[0], bool, 0400);
+MODULE_PARM_DESC(applause, "Use shadow variable to add applause (default=false)");
+module_param_named(applause2, add_applause[1], bool, 0400);
+MODULE_PARM_DESC(applause2, "Use shadow variable to add 2nd applause (default=false)");
+
+static int pre_patch_ret;
+module_param(pre_patch_ret, int, 0400);
+MODULE_PARM_DESC(pre_patch_ret, "Allow to force failure for the pre_patch callback (default=0)");
+
+static bool replace;
+module_param(replace, bool, 0400);
+MODULE_PARM_DESC(replace, "Enable the atomic replace feature when loading the livepatch. (default=false)");
+
+/* Conversion between the index to the @add_applause table and state ID. */
+#define __idx_to_state_id(idx) (idx + APPLAUSE_START_ID)
+#define __state_id_to_idx(state_id) (state_id - APPLAUSE_START_ID)
+
+static void __lp_speaker_welcome(const char *caller_func,
+				 const char *speaker_id,
+				 const char *context)
+{
+	char entire_applause[APPLAUSE_NUM * APPLAUSE_STR_SIZE + 1] = "";
+	int idx, ret;
+	int len = 0;
+
+	for (idx = 0; idx < APPLAUSE_NUM ; idx++) {
+		const char *applause;
+
+		applause = (char *)klp_shadow_get(shadow_object,
+						  __idx_to_state_id(idx));
+
+		if (applause) {
+			ret = strscpy(entire_applause + len, applause,
+				       sizeof(entire_applause) - len);
+			if (ret < 0) {
+				pr_warn("Too small buffer for entire_applause. Truncating...\n");
+				len = sizeof(entire_applause) - 1;
+				break;
+			}
+			len += ret;
+		}
+	}
+
+	if (len) {
+		ret = strscpy(entire_applause + len, " ",
+			       sizeof(entire_applause) - len);
+		if (ret < 0) {
+			pr_warn("Too small buffer for entire_applause. Truncating...\n");
+			len = sizeof(entire_applause) - 1;
+		} else {
+			len += ret;
+		}
+	}
+
+	pr_info("%s%s: %sLadies and gentleman, ...%s\n",
+		caller_func, speaker_id, entire_applause, context);
+}
+
+static void lp_speaker_welcome(const char *context)
+{
+	__lp_speaker_welcome(__func__, "", context);
+}
+
+static char *state_id_to_idx_str(char *buf, size_t size,
+				   unsigned long state_id)
+{
+	int idx;
+
+	idx = __state_id_to_idx(state_id);
+
+	if (idx < 0 || idx >= APPLAUSE_NUM) {
+		pr_err("%s: Applause table index out of scope: %d\n", __func__, idx);
+		return "";
+	}
+
+	if (idx == 0)
+		return "";
+
+	snprintf(buf, size, "%d", idx + 1);
+	return buf;
+}
+
+static int allocate_applause(unsigned long id)
+{
+	char idx_str[APPLAUSE_IDX_STR_SIZE];
+	char *applause;
+
+	/*
+	 * Attach the shadow variable to some well known address it stays
+	 * even when the livepatch gets replaced with a newer version.
+	 *
+	 * Make sure that the shadow variable does not exist yet.
+	 */
+	applause = (char *)klp_shadow_alloc(shadow_object, id,
+					   APPLAUSE_STR_SIZE, GFP_KERNEL,
+					   NULL, NULL);
+
+	if (!applause) {
+		pr_err("%s: failed to allocated shadow variable for storing an applause description\n",
+		       __func__);
+		return -ENOMEM;
+	}
+
+	snprintf(applause, APPLAUSE_STR_SIZE, "[%s]",
+		 state_id_to_idx_str(idx_str, sizeof(idx_str), id));
+
+	return 0;
+}
+
+static void set_applause(unsigned long id)
+{
+	char idx_str[APPLAUSE_IDX_STR_SIZE];
+	char *applause;
+
+	applause = (char *)klp_shadow_get(shadow_object, id);
+	if (!applause) {
+		pr_err("%s: failed to get shadow variable with the applause description: %lu\n",
+		       __func__, id);
+		return;
+	}
+
+	snprintf(applause, APPLAUSE_STR_SIZE, "[APPLAUSE%s]",
+		 state_id_to_idx_str(idx_str, sizeof(idx_str), id));
+}
+
+static void unset_applause(unsigned long id)
+{
+	char idx_str[APPLAUSE_IDX_STR_SIZE];
+	char *applause;
+
+	applause = (char *)klp_shadow_get(shadow_object, id);
+	if (!applause) {
+		pr_err("%s: failed to get shadow variable with the applause description: %lu\n",
+		       __func__, id);
+		return;
+	}
+
+	snprintf(applause, APPLAUSE_STR_SIZE, "[%s]",
+		 state_id_to_idx_str(idx_str, sizeof(idx_str), id));
+}
+
+static void check_applause(unsigned long id)
+{
+	char *applause;
+
+	applause = (char *)klp_shadow_get(shadow_object, id);
+	if (!applause) {
+		pr_err("%s: failed to get shadow variable with the applause description: %lu\n",
+		       __func__, id);
+		return;
+	}
+}
+
+/* Executed before patching when the state is being enabled. */
+static int applause_pre_patch_callback(struct klp_patch *patch, struct klp_state *state)
+{
+	pr_info("%s: state %lu\n", __func__, state->id);
+
+	if (pre_patch_ret) {
+		pr_err("%s: forcing err: %pe\n", __func__, ERR_PTR(pre_patch_ret));
+		return pre_patch_ret;
+	}
+
+	return allocate_applause(state->id);
+}
+
+/* Executed after patching when the state being enabled. */
+static void applause_post_patch_callback(struct klp_patch *patch, struct klp_state *state)
+{
+	pr_info("%s: state %lu\n", __func__, state->id);
+	set_applause(state->id);
+}
+
+/* Executed before unpatching when the state is being disabled. */
+static void applause_pre_unpatch_callback(struct klp_patch *patch, struct klp_state *state)
+{
+	pr_info("%s: state %lu\n", __func__, state->id);
+	unset_applause(state->id);
+}
+
+/* Executed after unpatching when the state is being disabled. */
+static void applause_post_unpatch_callback(struct klp_patch *patch, struct klp_state *state)
+{
+	/*
+	 * Just check that the shadow variable still exist. It will be
+	 * freed automatically because state->is_shadow is set.
+	 */
+	pr_info("%s: state %lu (nope)\n", __func__, state->id);
+	check_applause(state->id);
+}
+
+/*
+ * The shadow_dtor callback is not really needed. The space for the string
+ * has been allocated as part of struct klp_shadow. The callback is added
+ * just to check that the shadow variable is freed automatically because of
+ * state->is_shadow is set.
+ */
+static void applause_shadow_dtor(void *obj, void *shadow_data)
+{
+	char *applause = (char *)shadow_data;
+
+	/*
+	 * It would be better to print the related state->id. And it would be
+	 * easy to get the pointer to struct klp_shadow via the @shadow_data
+	 * pointer. But struct klp_state is not defined in a public header.
+	 */
+	pr_info("%s: freeing applause %s (nope)\n",
+		__func__, applause);
+}
+
+static void __lp_block_doors_func(struct work_struct *work, const char *caller_func,
+		       const char *speaker_id)
+{
+	struct hall *hall = container_of(work, struct hall, block_doors_work);
+
+	pr_info("%s: Going to block doors%s (fixed).\n", caller_func, speaker_id);
+	hall->do_block_doors();
+}
+
+/*
+ * Prevent tail call optimizations to make sure that this function
+ * appears in the backtrace and can block the disable transition.
+ */
+__attribute__((__optimize__("no-optimize-sibling-calls")))
+static void lp_block_doors_func(struct work_struct *work)
+{
+	__lp_block_doors_func(work, __func__, "");
+}
+
+static struct klp_func livepatch_speaker_mod_funcs[] = {
+	{
+		.old_name = "speaker_welcome",
+		.new_func = lp_speaker_welcome,
+	},
+	{
+		.old_name = "block_doors_func",
+		.new_func = lp_block_doors_func,
+	},
+	{ }
+};
+
+static struct klp_object objs[] = {
+	{
+		.name = "livepatch_speaker_mod",
+		.funcs = livepatch_speaker_mod_funcs,
+	},
+	{ }
+};
+
+static struct klp_patch patch = {
+	.mod = THIS_MODULE,
+	.objs = objs,
+};
+
+
+/*
+ * The array with states is dynamically allocated depending on which states
+ * are enabled on the command line.
+ */
+static struct klp_state *applause_states;
+
+static int applause_init(void)
+{
+	int idx, idx_allowed, id, enabled_cnt;
+
+	enabled_cnt = 0;
+
+	for (idx = 0, id = APPLAUSE_START_ID, enabled_cnt = 0;
+	     idx < APPLAUSE_NUM;
+	     idx++, id++) {
+		if (add_applause[idx])
+			enabled_cnt++;
+	}
+
+	if (enabled_cnt) {
+		/* Allocate one more state as the trailing entry. */
+		applause_states =
+			kzalloc(sizeof(applause_states[0]) * (enabled_cnt + 1),	GFP_KERNEL);
+		if (!applause_states)
+			return -ENOMEM;
+
+		patch.states = applause_states;
+
+		for (idx = 0, idx_allowed = 0;
+		     idx < APPLAUSE_NUM;
+		     idx++) {
+			struct klp_state *state;
+
+			if (!add_applause[idx])
+				continue;
+
+			if (idx_allowed >= enabled_cnt) {
+				pr_warn("Too many enabled applause states\n");
+				continue;
+			}
+
+			state = &applause_states[idx_allowed++];
+
+			state->id = __idx_to_state_id(idx);
+			state->is_shadow = true;
+			state->callbacks.pre_patch = applause_pre_patch_callback;
+			state->callbacks.post_patch = applause_post_patch_callback;
+			state->callbacks.pre_unpatch = applause_pre_unpatch_callback;
+			state->callbacks.post_unpatch = applause_post_unpatch_callback;
+			state->callbacks.shadow_dtor = applause_shadow_dtor;
+		}
+	}
+
+	return 0;
+}
+
+static int livepatch_speaker_fix_init(void)
+{
+	int err;
+
+	err = applause_init();
+	if (err)
+		return err;
+
+	if (replace)
+		patch.replace = true;
+
+	return klp_enable_patch(&patch);
+}
+
+static void livepatch_speaker_fix_exit(void)
+{
+	kfree(applause_states);
+}
+
+module_init(livepatch_speaker_fix_init);
+module_exit(livepatch_speaker_fix_exit);
+MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
+MODULE_DESCRIPTION("Livepatch sample: livepatch speaker module fix");
diff --git a/samples/livepatch/livepatch-speaker-mod.c b/samples/livepatch/livepatch-speaker-mod.c
new file mode 100644
index 000000000000..2a3ff5a26a59
--- /dev/null
+++ b/samples/livepatch/livepatch-speaker-mod.c
@@ -0,0 +1,203 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2024 SUSE
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/printk.h>
+#include <linux/delay.h>
+#include <linux/sysfs.h>
+#include <linux/completion.h>
+
+#include "livepatch-speaker.h"
+
+
+#ifndef SPEAKER_ID
+#define SPEAKER_ID ""
+#endif
+
+/**
+ * test_klp_speaker - test module for testing misc livepatching features
+ *
+ * The module provides a virtual speaker who can do:
+ *
+ *    - Start a show with a greeting, see speaker_welcome().
+ *
+ *    - Log the greeting by reading the "welcome" module parameter, see
+ *	welcome_get().
+ *
+ *    - Reuse the module source for more speakers, see SPEAKER_ID.
+ *
+ *    - Add "block_doors" parameter which could block the livepatch transition.
+ *	The stalled function is offloaded to a workqueue so that it does not
+ *	block the module load. The transition can be unblocked by setting
+ *	the parameter value back to "0" via the sysfs interface.
+ */
+
+noinline
+static void speaker_welcome(const char *context)
+{
+	pr_info("%s%s: Hello, World!%s\n", __func__, SPEAKER_ID, context);
+}
+
+static int welcome_get(char *buffer, const struct kernel_param *kp)
+{
+	speaker_welcome("");
+
+	return 0;
+}
+
+static const struct kernel_param_ops welcome_ops = {
+	.get	= welcome_get,
+};
+
+module_param_cb(welcome, &welcome_ops, NULL, 0400);
+MODULE_PARM_DESC(welcome, "Print speaker's welcome message into the kernel log when reading the value.");
+
+static DECLARE_COMPLETION(started_blocking_doors);
+static bool block_doors;
+static bool show_over;
+
+noinline
+static void do_block_doors(void)
+{
+	pr_info("%s: Started blocking doors.\n", __func__);
+	complete(&started_blocking_doors);
+
+	while (READ_ONCE(block_doors) && !READ_ONCE(show_over)) {
+		/*
+		 * Busy-wait until the parameter "block_doors" is cleared or
+		 * until the module gets unloaded.
+		 */
+		msleep(20);
+	}
+
+	if (!block_doors) {
+		pr_info("%s: Stopped blocking doors.\n", __func__);
+		/*
+		 * Show how the livepatched message looks in the process which
+		 * blocked the transition.
+		 */
+		speaker_welcome(" <--- from blocked doors");
+	}
+}
+
+static struct hall hall = {
+	.do_block_doors = do_block_doors,
+};
+
+/*
+ * Prevent tail call optimizations to make sure that this function
+ * appears in the backtrace and blocks the transition.
+ */
+__attribute__((__optimize__("no-optimize-sibling-calls")))
+static void block_doors_func(struct work_struct *work)
+{
+	struct hall *hall = container_of(work, struct hall, block_doors_work);
+
+	pr_info("%s: Going to block doors%s.\n", __func__, SPEAKER_ID);
+	hall->do_block_doors();
+}
+
+/*
+ * The work must be initialized when "bool" parameter is proceed
+ * during the module load. Which is done before calling the module init
+ * callback.
+ *
+ * Also it must be initialized even when the parameter was not used because
+ * the work must be flushed in the module exit callback.
+ */
+static void block_doors_work_init(struct hall *hall)
+{
+	static bool block_doors_work_initialized;
+
+	if (block_doors_work_initialized)
+		return;
+
+	INIT_WORK(&hall->block_doors_work, block_doors_func);
+	block_doors_work_initialized = true;
+}
+
+static int block_doors_get(char *buffer, const struct kernel_param *kp)
+{
+	if (block_doors)
+		pr_info("The doors are blocked.\n");
+	else
+		pr_info("The doors are not blocked.\n");
+
+	return 0;
+}
+
+static int block_doors_set(const char *val, const struct kernel_param *kp)
+{
+	bool block;
+	int ret;
+
+	ret = kstrtobool(val, &block);
+	if (ret)
+		return ret;
+
+	if (block == block_doors) {
+		if (block) {
+			pr_err("%s: The doors are already blocked.\n", __func__);
+			return -EBUSY;
+		}
+
+		pr_err("%s: The doors are not being blocked.\n", __func__);
+		return -EINVAL;
+	}
+
+	/*
+	 * Update the global value before scheduling the work so that it
+	 * stays blocked.
+	 */
+	block_doors = block;
+	if (block) {
+		init_completion(&started_blocking_doors);
+		block_doors_work_init(&hall);
+
+		schedule_work(&hall.block_doors_work);
+
+		/*
+		 * To synchronize kernel messages, hold this callback from
+		 * exiting until the work function's entry message has got
+		 * printed.
+		 */
+		wait_for_completion(&started_blocking_doors);
+	} else {
+		flush_work(&hall.block_doors_work);
+	}
+
+	return 0;
+}
+
+static const struct kernel_param_ops block_doors_ops = {
+	.set	= block_doors_set,
+	.get	= block_doors_get,
+};
+
+module_param_cb(block_doors, &block_doors_ops, NULL, 0600);
+MODULE_PARM_DESC(block_doors, "Block doors so that the audience could not enter. It blocks the livepatch transition. (default=false)");
+
+static int livepatch_speaker_mod_init(void)
+{
+	pr_info("%s\n", __func__);
+
+	block_doors_work_init(&hall);
+
+	return 0;
+}
+
+static void livepatch_speaker_mod_exit(void)
+{
+	pr_info("%s\n", __func__);
+
+	/* Make sure that do_block_doors() is not running. */
+	WRITE_ONCE(show_over, true);
+	flush_work(&hall.block_doors_work);
+}
+
+module_init(livepatch_speaker_mod_init);
+module_exit(livepatch_speaker_mod_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Livepatch sample: test functions");
diff --git a/samples/livepatch/livepatch-speaker.h b/samples/livepatch/livepatch-speaker.h
new file mode 100644
index 000000000000..a0e65c27ea56
--- /dev/null
+++ b/samples/livepatch/livepatch-speaker.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LIVEPATCH_SPEAKER_H_
+#define _LIVEPATCH_SPEAKER_H_
+
+#include <linux/workqueue.h>
+
+typedef void (*do_block_doors_t)(void);
+
+struct hall {
+	struct work_struct block_doors_work;
+	do_block_doors_t do_block_doors;
+};
+
+#endif //  _LIVEPATCH_SPEAKER_H_
-- 
2.47.1


