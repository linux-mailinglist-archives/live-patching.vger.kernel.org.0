Return-Path: <live-patching+bounces-36-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EBF117E7DFD
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 18:06:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D98B1F20C98
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 17:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C97D1DFD8;
	Fri, 10 Nov 2023 17:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aZ+6ilVb"
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADF91DDFA
	for <live-patching@vger.kernel.org>; Fri, 10 Nov 2023 17:05:59 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BD8431C4;
	Fri, 10 Nov 2023 09:05:53 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 851891F8BD;
	Fri, 10 Nov 2023 17:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1699635951; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NklZN6fzMlsGpMkP/ig8LeO2pM2n3MLcogCKsVFNavQ=;
	b=aZ+6ilVbrGm4mcmrlji8QszOhAyZojpL4nl/76v1owYcLHKU12Qjc2dU5lF8rrpsroZwnJ
	8N4ve6KkwEZdRljZzIRuFL3S99pRXrgPrJpKnRvPOn2+TxIm9I/wEfKNUNJ3T7Oh3PVu9v
	+kssCrY/NJ73+CUiXYcC88cjwitLnXw=
Received: from alley.suse.cz (pmladek.udp.ovpn2.prg.suse.de [10.100.201.202])
	by relay2.suse.de (Postfix) with ESMTP id 7EE462D35B;
	Fri, 10 Nov 2023 17:05:50 +0000 (UTC)
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [POC 5/7] livepatch: Convert klp module callbacks tests into livepatch module tests
Date: Fri, 10 Nov 2023 18:04:26 +0100
Message-Id: <20231110170428.6664-6-pmladek@suse.com>
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

The original livepatch callbacks has been obsoleted by the livepatch
state callbacks.

The important difference is that the original callbacks were associated
with the livepatched object. The state callbacks are associated with
the livepatch states which are associated with the livepatch.

As a result, some per-object callbacks functionality could not be
preserved with the new per-state callbacks. Namely, it is not
possible to change a state when a livepatched module is loaded
or unloaded. This usecase it considered rare and not worth
the complexity.

Instead, the callback self-tests are transformed into testing
the new state callbacks. Some tests do not use the callbacks
any longer. But they still test some basic scenarios which
is not tested by other tests.

Many features are added to the test_klp_speaker module:

  - The parameter "welcome" allows to call the livepatched
    function speaker_welcome.

  - The parameter "waiting_welcome" allows to a trigger
    a workqueue work which might busy wait in a livepatched
    function and block the transition.

    It requires storing pointer to speaker_wait_and_welcome()
    so that the original one could be called from the livepatch.

    Alternative solution would be to livepatch
    speaker_wait_and_welcome() but it would require passing
    pointer to the completion structure from the livepatched module.

    Another tricky part is the initialization of the work structure.
    It must be initialized in the module init() callback so that it can
    be flushed in the exit() callback even when it was not used. But
    it must be initialized also in waiting_welcome_set() because
    the module parameter callbacks are proceed before calling
    the module init() callback.

  - The same sources are used to build two target modules.
    The livepatched functions have versioned names. It makes it easier
    to distinguish messages printed by this functions and the livepatched
    variants.

    It is solved by using macro for definition of the functions.

Many features are added also into the livepatch module:

   - The parameter "add_applause" allows to add "[APPLAUSE " string
     into the message printed by speaker_welcome(). The string
     is stored in a shadow variable which is:

       - associated with a state.
       - allocated and initialized to "[] " in setup() state callback.
       - set to "[APPLAUSE ]" in enable() state callback.
       - set back to "[] " in disable() state callback.
       - freed in release() state callback.

     Allows testing state callbacks. It even allows to distinguish
     the state after setup() and enable() callbacks.

   - The parameter "setup_ret" allow to force a negative return
     value to the callback allocation the shadow variable.

   - The parameter "noreplace" allows to disable patch.replace
     parameter and install the livepatch in parallel with
     others.

   - The same sources are used for building two livepatches.
     It allows writing tests with more livepatches.

     The livepatched functions are versioned. Both livepatches
     can livepatch both speaker test modules.

     But they use the same shadow variable for storing
     the "add_applause" feature. It allows testing passing
     the states and shadow variables with atomic replace.

     But obviously, "add_applause" parameter could no be
     used for both livepatches when they are loaded in parallel
     using the "noreplace" parameter.

Finally, remove the obsolete and unused "callback" test modules
and livepatches.

TODO:

   - Debug why "waiting_welcome" does not block the transition.
     The livepatched function is not on the stack from unknown
     reasons. See the comments in test-module.h for more details.

   - Better organize the tests. test-module.sh combines
     tests of various aspects which might better be suited
     somewhere else.

     As a first step, test-callbacks.sh has been renamed
     to test-modules.sh. But there still might be a better name.

   - Split this huge patch. Add the various features and tests
     in more steps.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 lib/livepatch/Makefile                        |   6 +-
 lib/livepatch/test_klp_callbacks_busy.c       |  70 ---
 lib/livepatch/test_klp_callbacks_demo.c       | 121 ----
 lib/livepatch/test_klp_callbacks_demo2.c      |  93 ---
 lib/livepatch/test_klp_callbacks_mod.c        |  24 -
 lib/livepatch/test_klp_speaker.c              | 153 ++++-
 lib/livepatch/test_klp_speaker_livepatch.c    | 209 ++++++-
 tools/testing/selftests/livepatch/Makefile    |   2 +-
 .../testing/selftests/livepatch/functions.sh  |  29 +
 .../selftests/livepatch/test-callbacks.sh     | 553 ------------------
 .../selftests/livepatch/test-modules.sh       | 539 +++++++++++++++++
 11 files changed, 929 insertions(+), 870 deletions(-)
 delete mode 100644 lib/livepatch/test_klp_callbacks_busy.c
 delete mode 100644 lib/livepatch/test_klp_callbacks_demo.c
 delete mode 100644 lib/livepatch/test_klp_callbacks_demo2.c
 delete mode 100644 lib/livepatch/test_klp_callbacks_mod.c
 delete mode 100755 tools/testing/selftests/livepatch/test-callbacks.sh
 create mode 100755 tools/testing/selftests/livepatch/test-modules.sh

diff --git a/lib/livepatch/Makefile b/lib/livepatch/Makefile
index a8a5f6597633..e85e0c0f3875 100644
--- a/lib/livepatch/Makefile
+++ b/lib/livepatch/Makefile
@@ -3,14 +3,12 @@
 # Makefile for livepatch test code.
 
 obj-$(CONFIG_TEST_LIVEPATCH) += test_klp_atomic_replace.o \
-				test_klp_callbacks_demo.o \
-				test_klp_callbacks_demo2.o \
-				test_klp_callbacks_busy.o \
-				test_klp_callbacks_mod.o \
 				test_klp_livepatch.o \
 				test_klp_shadow_vars.o \
 				test_klp_speaker.o \
+				test_klp_speaker2.o \
 				test_klp_speaker_livepatch.o \
+				test_klp_speaker_livepatch2.o \
 				test_klp_state.o \
 				test_klp_state2.o \
 				test_klp_state3.o
diff --git a/lib/livepatch/test_klp_callbacks_busy.c b/lib/livepatch/test_klp_callbacks_busy.c
deleted file mode 100644
index 133929e0ce8f..000000000000
--- a/lib/livepatch/test_klp_callbacks_busy.c
+++ /dev/null
@@ -1,70 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-// Copyright (C) 2018 Joe Lawrence <joe.lawrence@redhat.com>
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/workqueue.h>
-#include <linux/delay.h>
-
-/* load/run-time control from sysfs writer  */
-static bool block_transition;
-module_param(block_transition, bool, 0644);
-MODULE_PARM_DESC(block_transition, "block_transition (default=false)");
-
-static void busymod_work_func(struct work_struct *work);
-static DECLARE_WORK(work, busymod_work_func);
-static DECLARE_COMPLETION(busymod_work_started);
-
-static void busymod_work_func(struct work_struct *work)
-{
-	pr_info("%s enter\n", __func__);
-	complete(&busymod_work_started);
-
-	while (READ_ONCE(block_transition)) {
-		/*
-		 * Busy-wait until the sysfs writer has acknowledged a
-		 * blocked transition and clears the flag.
-		 */
-		msleep(20);
-	}
-
-	pr_info("%s exit\n", __func__);
-}
-
-static int test_klp_callbacks_busy_init(void)
-{
-	pr_info("%s\n", __func__);
-	schedule_work(&work);
-
-	/*
-	 * To synchronize kernel messages, hold the init function from
-	 * exiting until the work function's entry message has printed.
-	 */
-	wait_for_completion(&busymod_work_started);
-
-	if (!block_transition) {
-		/*
-		 * Serialize output: print all messages from the work
-		 * function before returning from init().
-		 */
-		flush_work(&work);
-	}
-
-	return 0;
-}
-
-static void test_klp_callbacks_busy_exit(void)
-{
-	WRITE_ONCE(block_transition, false);
-	flush_work(&work);
-	pr_info("%s\n", __func__);
-}
-
-module_init(test_klp_callbacks_busy_init);
-module_exit(test_klp_callbacks_busy_exit);
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Joe Lawrence <joe.lawrence@redhat.com>");
-MODULE_DESCRIPTION("Livepatch test: busy target module");
diff --git a/lib/livepatch/test_klp_callbacks_demo.c b/lib/livepatch/test_klp_callbacks_demo.c
deleted file mode 100644
index 3fd8fe1cd1cc..000000000000
--- a/lib/livepatch/test_klp_callbacks_demo.c
+++ /dev/null
@@ -1,121 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-// Copyright (C) 2018 Joe Lawrence <joe.lawrence@redhat.com>
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
-	{}
-};
-
-static struct klp_func busymod_funcs[] = {
-	{
-		.old_name = "busymod_work_func",
-		.new_func = patched_work_func,
-	}, {}
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
-		.name = "test_klp_callbacks_mod",
-		.funcs = no_funcs,
-		.callbacks = {
-			.pre_patch = pre_patch_callback,
-			.post_patch = post_patch_callback,
-			.pre_unpatch = pre_unpatch_callback,
-			.post_unpatch = post_unpatch_callback,
-		},
-	},	{
-		.name = "test_klp_callbacks_busy",
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
-MODULE_AUTHOR("Joe Lawrence <joe.lawrence@redhat.com>");
-MODULE_DESCRIPTION("Livepatch test: livepatch demo");
diff --git a/lib/livepatch/test_klp_callbacks_demo2.c b/lib/livepatch/test_klp_callbacks_demo2.c
deleted file mode 100644
index 5417573e80af..000000000000
--- a/lib/livepatch/test_klp_callbacks_demo2.c
+++ /dev/null
@@ -1,93 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-// Copyright (C) 2018 Joe Lawrence <joe.lawrence@redhat.com>
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/livepatch.h>
-
-static int replace;
-module_param(replace, int, 0644);
-MODULE_PARM_DESC(replace, "replace (default=0)");
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
-	return 0;
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
-static struct klp_func no_funcs[] = {
-	{ }
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
-static struct klp_patch patch = {
-	.mod = THIS_MODULE,
-	.objs = objs,
-	/* set .replace in the init function below for demo purposes */
-};
-
-static int test_klp_callbacks_demo2_init(void)
-{
-	patch.replace = replace;
-	return klp_enable_patch(&patch);
-}
-
-static void test_klp_callbacks_demo2_exit(void)
-{
-}
-
-module_init(test_klp_callbacks_demo2_init);
-module_exit(test_klp_callbacks_demo2_exit);
-MODULE_LICENSE("GPL");
-MODULE_INFO(livepatch, "Y");
-MODULE_AUTHOR("Joe Lawrence <joe.lawrence@redhat.com>");
-MODULE_DESCRIPTION("Livepatch test: livepatch demo2");
diff --git a/lib/livepatch/test_klp_callbacks_mod.c b/lib/livepatch/test_klp_callbacks_mod.c
deleted file mode 100644
index 8fbe645b1c2c..000000000000
--- a/lib/livepatch/test_klp_callbacks_mod.c
+++ /dev/null
@@ -1,24 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-// Copyright (C) 2018 Joe Lawrence <joe.lawrence@redhat.com>
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-
-static int test_klp_callbacks_mod_init(void)
-{
-	pr_info("%s\n", __func__);
-	return 0;
-}
-
-static void test_klp_callbacks_mod_exit(void)
-{
-	pr_info("%s\n", __func__);
-}
-
-module_init(test_klp_callbacks_mod_init);
-module_exit(test_klp_callbacks_mod_exit);
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Joe Lawrence <joe.lawrence@redhat.com>");
-MODULE_DESCRIPTION("Livepatch test: target module");
diff --git a/lib/livepatch/test_klp_speaker.c b/lib/livepatch/test_klp_speaker.c
index d2d31072639a..d8e42267f5cd 100644
--- a/lib/livepatch/test_klp_speaker.c
+++ b/lib/livepatch/test_klp_speaker.c
@@ -9,23 +9,174 @@
 
 #include <linux/module.h>
 #include <linux/printk.h>
+#include <linux/delay.h>
+#include <linux/sysfs.h>
+
+#include "test_klp_speaker.h"
 
 noinline
-void speaker_welcome(void)
+void _VER_NAME(speaker_welcome)(void)
 {
 	pr_info("%s: Hello, World!\n", __func__);
 }
 
+static int welcome_get(char *buffer, const struct kernel_param *kp)
+{
+	_VER_NAME(speaker_welcome)();
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
+noinline
+void speaker_wait_and_welcome(struct speaker *speaker)
+{
+	pr_info("%s: Speaker started waiting.\n", __func__);
+	complete(&speaker->started_waiting);
+	speaker->started_waiting_param = true;
+
+	while (READ_ONCE(speaker->is_waiting)) {
+		/*
+		 * Busy-wait until the sysfs writer has acknowledged a
+		 * blocked transition and clears the flag.
+		 */
+		msleep(20);
+	}
+
+	speaker->welcome();
+}
+
+noinline
+void _VER_NAME(call_speaker)(struct speaker *speaker)
+{
+	pr_info("%s: Calling speaker.\n", __func__);
+	speaker->wait_and_welcome(speaker);
+}
+
+static struct speaker test_klp_speaker = {
+	.call = _VER_NAME(call_speaker),
+	.welcome = _VER_NAME(speaker_welcome),
+	.wait_and_welcome = speaker_wait_and_welcome,
+};
+
+static void speaker_func(struct work_struct *work)
+{
+	struct speaker *speaker = container_of(work, struct speaker, work);
+
+	speaker->call(speaker);
+}
+
+/*
+ * The work must be initialized when "waiting_welcome" parameter is proceed
+ * during the module load. Which is done before calling the module init
+ * callback.
+ *
+ * Also it must be initialized also when the parameter was not used because
+ * the work must be flushed in the module exit callback.
+ */
+static void speaker_work_init(struct speaker *speaker)
+{
+	static bool speaker_work_initialized;
+
+	if (speaker_work_initialized)
+		return;
+
+	INIT_WORK(&speaker->work, speaker_func);
+	speaker_work_initialized = true;
+}
+
+static int waiting_welcome_get(char *buffer, const struct kernel_param *kp)
+{
+	if (test_klp_speaker.is_waiting)
+		pr_info("Speaker is waiting.\n");
+	else
+		pr_info("Speaker is not waiting.\n");
+
+	return 0;
+}
+
+static int waiting_welcome_set(const char *val, const struct kernel_param *kp)
+{
+	bool wait;
+	int ret;
+
+	ret = kstrtobool(val, &wait);
+	if (ret)
+		return ret;
+
+	if (wait) {
+		if (test_klp_speaker.is_waiting) {
+			pr_err("%s: Speaker is already waiting.\n", __func__);
+			return -EBUSY;
+		}
+
+		test_klp_speaker.started_waiting_param = false;
+		init_completion(&test_klp_speaker.started_waiting);
+		speaker_work_init(&test_klp_speaker);
+
+		WRITE_ONCE(test_klp_speaker.is_waiting, true);
+		schedule_work(&test_klp_speaker.work);
+
+		/*
+		 * To synchronize kernel messages, hold this callback from
+		 * exiting until the work function's entry message has printed.
+		 */
+		wait_for_completion(&test_klp_speaker.started_waiting);
+	} else {
+		if (!test_klp_speaker.is_waiting) {
+			pr_err("%s: Speaker has not been waiting.\n", __func__);
+			return -EINVAL;
+		}
+
+		WRITE_ONCE(test_klp_speaker.is_waiting, false);
+		flush_work(&test_klp_speaker.work);
+	}
+
+	return 0;
+}
+
+static const struct kernel_param_ops waiting_welcome_ops = {
+	.set	= waiting_welcome_set,
+	.get	= waiting_welcome_get,
+};
+
+module_param_cb(waiting_welcome, &waiting_welcome_ops, NULL, 0600);
+MODULE_PARM_DESC(waiting_welcome, "Speaker will start waiting when set and will say welcome message when cleared.");
+
+static int started_waiting_get(char *buffer, const struct kernel_param *kp)
+{
+	return sysfs_emit(buffer, test_klp_speaker.started_waiting_param ? "1" : "0");
+}
+
+static const struct kernel_param_ops started_waiting_ops = {
+	.get	= started_waiting_get,
+};
+
+module_param_cb(started_waiting, &started_waiting_ops, NULL, 0400);
+MODULE_PARM_DESC(started_waiting, "Read only parameter to check whether the asynchronously started speaker already started waiting.");
+
 static int test_klp_speaker_init(void)
 {
 	pr_info("%s\n", __func__);
 
+	speaker_work_init(&test_klp_speaker);
+
 	return 0;
 }
 
 static void test_klp_speaker_exit(void)
 {
 	pr_info("%s\n", __func__);
+
+	/* Make sure that wait_funtion() is not running. */
+	WRITE_ONCE(test_klp_speaker.is_waiting, false);
+	flush_work(&test_klp_speaker.work);
 }
 
 module_init(test_klp_speaker_init);
diff --git a/lib/livepatch/test_klp_speaker_livepatch.c b/lib/livepatch/test_klp_speaker_livepatch.c
index 0317a4937b78..54bd32ee24ea 100644
--- a/lib/livepatch/test_klp_speaker_livepatch.c
+++ b/lib/livepatch/test_klp_speaker_livepatch.c
@@ -7,18 +7,182 @@
 #include <linux/livepatch.h>
 #include <linux/init.h>
 
+#include "test_klp_speaker.h"
 
-void livepatch_speaker_welcome(void)
-{
-	pr_info("%s: Ladies and gentleman, ...\n", __func__);
+#define APPLAUSE_ID 1
+#define APPLAUSE_SIZE 64
+
+/* associate the shadow variable with NULL address */;
+void *shadow_object = NULL;
+
+/* load/run-time control from sysfs writer  */
+static bool add_applause;
+module_param(add_applause, bool, 0600);
+MODULE_PARM_DESC(add_applause, "Use shadow variable to add applause (default=false)");
+
+/* load/run-time control from sysfs writer  */
+static int setup_ret;
+module_param(setup_ret, int, 0644);
+MODULE_PARM_DESC(setup_ret, "Allow to force failure for the setup callback (default=0)");
+
+/* load/run-time control from sysfs writer  */
+static bool noreplace;
+module_param(noreplace, bool, 0600);
+MODULE_PARM_DESC(noreplace, "Allow to install the livepatch together with other livepatches. (default=false)");
+
+#define LIVEPATCH_SPEAKER_WELCOME_FN(fn_name)					\
+noinline									\
+void fn_name(void)								\
+{										\
+	const char *applause;							\
+										\
+	applause = (char *)klp_shadow_get(shadow_object, APPLAUSE_ID);		\
+										\
+	if (!applause)								\
+		applause = "";							\
+										\
+	pr_info("%s: %sLadies and gentleman, ...\n", __func__, applause);	\
 }
 
+LIVEPATCH_SPEAKER_WELCOME_FN(livepatch_speaker_welcome)
+LIVEPATCH_SPEAKER_WELCOME_FN(livepatch_speaker_welcome2)
+
+static int allocate_applause(void)
+{
+	char *applause;
+
+	/*
+	 * Attach the shadow variable to some well known address it stays
+	 * even when the livepatch gets replaced with a newer version.
+	 *
+	 * Make sure that the shadow variable does not exist yet.
+	 */
+	applause = (char *)klp_shadow_alloc(shadow_object, APPLAUSE_ID,
+					   APPLAUSE_SIZE, GFP_KERNEL,
+					   NULL, NULL);
+
+	if (!applause) {
+		pr_err("%s: failed to allocated shadow variable for storing an applause description\n",
+		       __func__);
+		return -ENOMEM;
+	}
+
+	/*
+	 * Fill the shadow target with an empty brackets before all processes
+	 * get livepatched.
+	 */
+	strscpy(applause, "[] ", APPLAUSE_SIZE);
+
+	return 0;
+}
+
+static void set_applause(void)
+{
+	char *applause;
+
+	applause = (char *)klp_shadow_get(shadow_object, APPLAUSE_ID);
+	if (!applause) {
+		pr_err("%s: failed to get shadow variable with the applause description: %d\n",
+		       __func__, APPLAUSE_ID);
+		return;
+	}
+
+	strscpy(applause, "[APPLAUSE] ", APPLAUSE_SIZE);
+}
+
+static void unset_applause(void)
+{
+	char *applause;
+
+	applause = (char *)klp_shadow_get(shadow_object, APPLAUSE_ID);
+	if (!applause) {
+		pr_err("%s: failed to get shadow variable with the applause description: %d\n",
+		       __func__, APPLAUSE_ID);
+		return;
+	}
+
+	applause[0] = '\0';
+}
+
+static void free_applause(void)
+{
+	char *applause;
+
+	applause = (char *)klp_shadow_get(shadow_object, APPLAUSE_ID);
+	if (!applause) {
+		pr_err("%s: failed to get shadow variable with the applause description: %d\n",
+		       __func__, APPLAUSE_ID);
+		return;
+	}
+
+	klp_shadow_free(shadow_object, APPLAUSE_ID, NULL);
+}
+
+/* Executed before patching when the state is new. */
+static int setup_applause_callback(struct klp_patch *patch, struct klp_state *state)
+{
+	pr_info("%s: state %lu\n", __func__, state->id);
+
+	if (setup_ret) {
+		pr_err("%s: forcing err: %pe\n", __func__, ERR_PTR(setup_ret));
+		return setup_ret;
+	}
+
+	return allocate_applause();
+}
+
+/* Executed after patching when the state is new. */
+static void enable_applause_callback(struct klp_patch *patch, struct klp_state *state)
+{
+	pr_info("%s: state %lu\n", __func__, state->id);
+	set_applause();
+}
+
+/* Executed before unpatching when the state is obsoleted. */
+static void disable_applause_callback(struct klp_patch *patch, struct klp_state *state)
+{
+	pr_info("%s: state %lu\n", __func__, state->id);
+	unset_applause();
+}
+
+/* Executed after unpatching when the state is obsoleted. */
+static void release_applause_callback(struct klp_patch *patch, struct klp_state *state)
+{
+	pr_info("%s: state %lu\n", __func__, state->id);
+	free_applause();
+}
+
+#define LIVEPATCH_CALL_SPEAKER_FN(fn_name)			\
+void fn_name(struct speaker *speaker)		\
+{								\
+	pr_info("%s: Calling speaker (fixed).\n", __func__);	\
+	speaker->wait_and_welcome(speaker);			\
+}
+
+LIVEPATCH_CALL_SPEAKER_FN(livepatch_call_speaker)
+LIVEPATCH_CALL_SPEAKER_FN(livepatch_call_speaker2)
 
 static struct klp_func test_klp_speaker_funcs[] = {
 	{
 		.old_name = "speaker_welcome",
 		.new_func = livepatch_speaker_welcome,
 	},
+	{
+		.old_name = "call_speaker",
+		.new_func = livepatch_call_speaker,
+	},
+	{ }
+};
+
+static struct klp_func test_klp_speaker2_funcs[] = {
+	{
+		.old_name = "speaker_welcome2",
+		.new_func = livepatch_speaker_welcome2,
+	},
+	{
+		.old_name = "call_speaker2",
+		.new_func = livepatch_call_speaker2,
+	},
 	{ }
 };
 
@@ -27,16 +191,55 @@ static struct klp_object objs[] = {
 		.name = "test_klp_speaker",
 		.funcs = test_klp_speaker_funcs,
 	},
+	{
+		.name = "test_klp_speaker2",
+		.funcs = test_klp_speaker2_funcs,
+	},
 	{ }
 };
 
+static struct klp_state states[] = {
+	{
+		.id = APPLAUSE_ID,
+		.is_shadow = true,
+		.callbacks = {
+			.setup = setup_applause_callback,
+			.enable = enable_applause_callback,
+			.disable = disable_applause_callback,
+			.release = release_applause_callback,
+		},
+	},
+	{ }
+};
+
+/*
+ * Use the atomic replace by default so that the APPLAUSE state
+ * is correctly transferred when another version of the speaker
+ * livepatch gets loaded.
+ *
+ * Can be overridden by "noreplace=1" parameter. But it can't
+ * be used together with the "add_applause=1" parameter when
+ * another speaker livepatch is already loaded with
+ * the "add_applause=1" parameter.
+ */
 static struct klp_patch patch = {
 	.mod = THIS_MODULE,
 	.objs = objs,
+	.replace = true,
 };
 
 static int test_klp_speaker_livepatch_init(void)
 {
+	if (add_applause)
+		patch.states = states;
+
+	if (noreplace) {
+		if (add_applause)
+			pr_warn("The speaker livepatch can't be loaded when both \"add_applause\" and \"noreplace\" are used and another speaker livepatch is already loaded with \"add_aplause\"\n");
+
+		patch.replace = false;
+	}
+
 	return klp_enable_patch(&patch);
 }
 
diff --git a/tools/testing/selftests/livepatch/Makefile b/tools/testing/selftests/livepatch/Makefile
index 02fadc9d55e0..18c52b9e8f46 100644
--- a/tools/testing/selftests/livepatch/Makefile
+++ b/tools/testing/selftests/livepatch/Makefile
@@ -3,7 +3,7 @@
 TEST_PROGS_EXTENDED := functions.sh
 TEST_PROGS := \
 	test-livepatch.sh \
-	test-callbacks.sh \
+	test-modules.sh \
 	test-shadow-vars.sh \
 	test-state.sh \
 	test-ftrace.sh \
diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index c8416c54b463..a962119f053e 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -277,6 +277,20 @@ function set_pre_patch_ret {
 		die "failed to set pre_patch_ret parameter for $mod module"
 }
 
+# read_module_param(modname, param)
+#	modname - module name which provides the given parameter
+#	param - parameter name to be read
+function read_module_param {
+	local mod="$1"; shift
+	local param="$1"
+
+	log "% cat /sys/module/$mod/parameters/$param"
+	ret=$(cat /sys/module/$mod/parameters/$param 2>&1)
+	if [[ "$ret" != "" ]]; then
+		die "$ret"
+	fi
+}
+
 function start_test {
 	local test="$1"
 
@@ -336,9 +350,24 @@ function check_sysfs_value() {
 	local rel_path="$1"; shift
 	local expected_value="$1"; shift
 
+#	echo "mod=$mod"
+#	echo "rel_path=$rel_path"
+#	echo "expected_value=$expected_value"
 	local path="$KLP_SYSFS_DIR/$mod/$rel_path"
 	local value=`cat $path`
 	if test "$value" != "$expected_value" ; then
 		die "Unexpected value in $path: $expected_value vs. $value"
 	fi
 }
+
+# check_object_patched(livepatch_module, objname, expected_value)
+#	livepatch_module - livepatch module creating the sysfs interface
+#	objname - livepatched object to be checked
+#	expected_value - expected value read from the file
+function check_object_patched() {
+	local livepatch_module="$1"; shift
+	local objname="$1"; shift
+	local expected_value="$1"; shift
+
+	check_sysfs_value "$livepatch_module" "$objname/patched" "$expected_value"
+}
diff --git a/tools/testing/selftests/livepatch/test-callbacks.sh b/tools/testing/selftests/livepatch/test-callbacks.sh
deleted file mode 100755
index 90b26dbb2626..000000000000
--- a/tools/testing/selftests/livepatch/test-callbacks.sh
+++ /dev/null
@@ -1,553 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (C) 2018 Joe Lawrence <joe.lawrence@redhat.com>
-
-. $(dirname $0)/functions.sh
-
-MOD_LIVEPATCH=test_klp_callbacks_demo
-MOD_LIVEPATCH2=test_klp_callbacks_demo2
-MOD_TARGET=test_klp_callbacks_mod
-MOD_TARGET_BUSY=test_klp_callbacks_busy
-
-setup_config
-
-
-# Test a combination of loading a kernel module and a livepatch that
-# patches a function in the first module.  Load the target module
-# before the livepatch module.  Unload them in the same order.
-#
-# - On livepatch enable, before the livepatch transition starts,
-#   pre-patch callbacks are executed for vmlinux and $MOD_TARGET (those
-#   klp_objects currently loaded).  After klp_objects are patched
-#   according to the klp_patch, their post-patch callbacks run and the
-#   transition completes.
-#
-# - Similarly, on livepatch disable, pre-patch callbacks run before the
-#   unpatching transition starts.  klp_objects are reverted, post-patch
-#   callbacks execute and the transition completes.
-
-start_test "target module before livepatch"
-
-load_mod $MOD_TARGET
-load_lp $MOD_LIVEPATCH
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH
-unload_mod $MOD_TARGET
-
-check_result "% modprobe $MOD_TARGET
-$MOD_TARGET: ${MOD_TARGET}_init
-% modprobe $MOD_LIVEPATCH
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-$MOD_LIVEPATCH: pre_patch_callback: vmlinux
-$MOD_LIVEPATCH: pre_patch_callback: $MOD_TARGET -> [MODULE_STATE_LIVE] Normal state
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-$MOD_LIVEPATCH: post_patch_callback: vmlinux
-$MOD_LIVEPATCH: post_patch_callback: $MOD_TARGET -> [MODULE_STATE_LIVE] Normal state
-livepatch: '$MOD_LIVEPATCH': patching complete
-% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
-livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-$MOD_LIVEPATCH: pre_unpatch_callback: vmlinux
-$MOD_LIVEPATCH: pre_unpatch_callback: $MOD_TARGET -> [MODULE_STATE_LIVE] Normal state
-livepatch: '$MOD_LIVEPATCH': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-$MOD_LIVEPATCH: post_unpatch_callback: vmlinux
-$MOD_LIVEPATCH: post_unpatch_callback: $MOD_TARGET -> [MODULE_STATE_LIVE] Normal state
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH
-% rmmod $MOD_TARGET
-$MOD_TARGET: ${MOD_TARGET}_exit"
-
-
-# This test is similar to the previous test, but (un)load the livepatch
-# module before the target kernel module.  This tests the livepatch
-# core's module_coming handler.
-#
-# - On livepatch enable, only pre/post-patch callbacks are executed for
-#   currently loaded klp_objects, in this case, vmlinux.
-#
-# - When a targeted module is subsequently loaded, only its
-#   pre/post-patch callbacks are executed.
-#
-# - On livepatch disable, all currently loaded klp_objects' (vmlinux and
-#   $MOD_TARGET) pre/post-unpatch callbacks are executed.
-
-start_test "module_coming notifier"
-
-load_lp $MOD_LIVEPATCH
-load_mod $MOD_TARGET
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH
-unload_mod $MOD_TARGET
-
-check_result "% modprobe $MOD_LIVEPATCH
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-$MOD_LIVEPATCH: pre_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-$MOD_LIVEPATCH: post_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': patching complete
-% modprobe $MOD_TARGET
-livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET'
-$MOD_LIVEPATCH: pre_patch_callback: $MOD_TARGET -> [MODULE_STATE_COMING] Full formed, running module_init
-$MOD_LIVEPATCH: post_patch_callback: $MOD_TARGET -> [MODULE_STATE_COMING] Full formed, running module_init
-$MOD_TARGET: ${MOD_TARGET}_init
-% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
-livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-$MOD_LIVEPATCH: pre_unpatch_callback: vmlinux
-$MOD_LIVEPATCH: pre_unpatch_callback: $MOD_TARGET -> [MODULE_STATE_LIVE] Normal state
-livepatch: '$MOD_LIVEPATCH': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-$MOD_LIVEPATCH: post_unpatch_callback: vmlinux
-$MOD_LIVEPATCH: post_unpatch_callback: $MOD_TARGET -> [MODULE_STATE_LIVE] Normal state
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH
-% rmmod $MOD_TARGET
-$MOD_TARGET: ${MOD_TARGET}_exit"
-
-
-# Test loading the livepatch after a targeted kernel module, then unload
-# the kernel module before disabling the livepatch.  This tests the
-# livepatch core's module_going handler.
-#
-# - First load a target module, then the livepatch.
-#
-# - When a target module is unloaded, the livepatch is only reverted
-#   from that klp_object ($MOD_TARGET).  As such, only its pre and
-#   post-unpatch callbacks are executed when this occurs.
-#
-# - When the livepatch is disabled, pre and post-unpatch callbacks are
-#   run for the remaining klp_object, vmlinux.
-
-start_test "module_going notifier"
-
-load_mod $MOD_TARGET
-load_lp $MOD_LIVEPATCH
-unload_mod $MOD_TARGET
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH
-
-check_result "% modprobe $MOD_TARGET
-$MOD_TARGET: ${MOD_TARGET}_init
-% modprobe $MOD_LIVEPATCH
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-$MOD_LIVEPATCH: pre_patch_callback: vmlinux
-$MOD_LIVEPATCH: pre_patch_callback: $MOD_TARGET -> [MODULE_STATE_LIVE] Normal state
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-$MOD_LIVEPATCH: post_patch_callback: vmlinux
-$MOD_LIVEPATCH: post_patch_callback: $MOD_TARGET -> [MODULE_STATE_LIVE] Normal state
-livepatch: '$MOD_LIVEPATCH': patching complete
-% rmmod $MOD_TARGET
-$MOD_TARGET: ${MOD_TARGET}_exit
-$MOD_LIVEPATCH: pre_unpatch_callback: $MOD_TARGET -> [MODULE_STATE_GOING] Going away
-livepatch: reverting patch '$MOD_LIVEPATCH' on unloading module '$MOD_TARGET'
-$MOD_LIVEPATCH: post_unpatch_callback: $MOD_TARGET -> [MODULE_STATE_GOING] Going away
-% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
-livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-$MOD_LIVEPATCH: pre_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-$MOD_LIVEPATCH: post_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH"
-
-
-# This test is similar to the previous test, however the livepatch is
-# loaded first.  This tests the livepatch core's module_coming and
-# module_going handlers.
-#
-# - First load the livepatch.
-#
-# - When a targeted kernel module is subsequently loaded, only its
-#   pre/post-patch callbacks are executed.
-#
-# - When the target module is unloaded, the livepatch is only reverted
-#   from the $MOD_TARGET klp_object.  As such, only pre and
-#   post-unpatch callbacks are executed when this occurs.
-
-start_test "module_coming and module_going notifiers"
-
-load_lp $MOD_LIVEPATCH
-load_mod $MOD_TARGET
-unload_mod $MOD_TARGET
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH
-
-check_result "% modprobe $MOD_LIVEPATCH
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-$MOD_LIVEPATCH: pre_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-$MOD_LIVEPATCH: post_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': patching complete
-% modprobe $MOD_TARGET
-livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET'
-$MOD_LIVEPATCH: pre_patch_callback: $MOD_TARGET -> [MODULE_STATE_COMING] Full formed, running module_init
-$MOD_LIVEPATCH: post_patch_callback: $MOD_TARGET -> [MODULE_STATE_COMING] Full formed, running module_init
-$MOD_TARGET: ${MOD_TARGET}_init
-% rmmod $MOD_TARGET
-$MOD_TARGET: ${MOD_TARGET}_exit
-$MOD_LIVEPATCH: pre_unpatch_callback: $MOD_TARGET -> [MODULE_STATE_GOING] Going away
-livepatch: reverting patch '$MOD_LIVEPATCH' on unloading module '$MOD_TARGET'
-$MOD_LIVEPATCH: post_unpatch_callback: $MOD_TARGET -> [MODULE_STATE_GOING] Going away
-% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
-livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-$MOD_LIVEPATCH: pre_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-$MOD_LIVEPATCH: post_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH"
-
-
-# A simple test of loading a livepatch without one of its patch target
-# klp_objects ever loaded ($MOD_TARGET).
-#
-# - Load the livepatch.
-#
-# - As expected, only pre/post-(un)patch handlers are executed for
-#   vmlinux.
-
-start_test "target module not present"
-
-load_lp $MOD_LIVEPATCH
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH
-
-check_result "% modprobe $MOD_LIVEPATCH
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-$MOD_LIVEPATCH: pre_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-$MOD_LIVEPATCH: post_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': patching complete
-% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
-livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-$MOD_LIVEPATCH: pre_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-$MOD_LIVEPATCH: post_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH"
-
-
-# Test a scenario where a vmlinux pre-patch callback returns a non-zero
-# status (ie, failure).
-#
-# - First load a target module.
-#
-# - Load the livepatch module, setting its 'pre_patch_ret' value to -19
-#   (-ENODEV).  When its vmlinux pre-patch callback executes, this
-#   status code will propagate back to the module-loading subsystem.
-#   The result is that the insmod command refuses to load the livepatch
-#   module.
-
-start_test "pre-patch callback -ENODEV"
-
-load_mod $MOD_TARGET
-load_failing_mod $MOD_LIVEPATCH pre_patch_ret=-19
-unload_mod $MOD_TARGET
-
-check_result "% modprobe $MOD_TARGET
-$MOD_TARGET: ${MOD_TARGET}_init
-% modprobe $MOD_LIVEPATCH pre_patch_ret=-19
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-test_klp_callbacks_demo: pre_patch_callback: vmlinux
-livepatch: pre-patch callback failed for object 'vmlinux'
-livepatch: failed to enable patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': canceling patching transition, going to unpatch
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-modprobe: ERROR: could not insert '$MOD_LIVEPATCH': No such device
-% rmmod $MOD_TARGET
-$MOD_TARGET: ${MOD_TARGET}_exit"
-
-
-# Similar to the previous test, setup a livepatch such that its vmlinux
-# pre-patch callback returns success.  However, when a targeted kernel
-# module is later loaded, have the livepatch return a failing status
-# code.
-#
-# - Load the livepatch, vmlinux pre-patch callback succeeds.
-#
-# - Set a trap so subsequent pre-patch callbacks to this livepatch will
-#   return -ENODEV.
-#
-# - The livepatch pre-patch callback for subsequently loaded target
-#   modules will return failure, so the module loader refuses to load
-#   the kernel module.  No post-patch or pre/post-unpatch callbacks are
-#   executed for this klp_object.
-#
-# - Pre/post-unpatch callbacks are run for the vmlinux klp_object.
-
-start_test "module_coming + pre-patch callback -ENODEV"
-
-load_lp $MOD_LIVEPATCH
-set_pre_patch_ret $MOD_LIVEPATCH -19
-load_failing_mod $MOD_TARGET
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH
-
-check_result "% modprobe $MOD_LIVEPATCH
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-$MOD_LIVEPATCH: pre_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-$MOD_LIVEPATCH: post_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': patching complete
-% echo -19 > /sys/module/$MOD_LIVEPATCH/parameters/pre_patch_ret
-% modprobe $MOD_TARGET
-livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET'
-$MOD_LIVEPATCH: pre_patch_callback: $MOD_TARGET -> [MODULE_STATE_COMING] Full formed, running module_init
-livepatch: pre-patch callback failed for object '$MOD_TARGET'
-livepatch: patch '$MOD_LIVEPATCH' failed for module '$MOD_TARGET', refusing to load module '$MOD_TARGET'
-modprobe: ERROR: could not insert '$MOD_TARGET': No such device
-% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
-livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-$MOD_LIVEPATCH: pre_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-$MOD_LIVEPATCH: post_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH"
-
-
-# Test loading multiple targeted kernel modules.  This test-case is
-# mainly for comparing with the next test-case.
-#
-# - Load a target "busy" kernel module which kicks off a worker function
-#   that immediately exits.
-#
-# - Proceed with loading the livepatch and another ordinary target
-#   module.  Post-patch callbacks are executed and the transition
-#   completes quickly.
-
-start_test "multiple target modules"
-
-load_mod $MOD_TARGET_BUSY block_transition=N
-load_lp $MOD_LIVEPATCH
-load_mod $MOD_TARGET
-unload_mod $MOD_TARGET
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH
-unload_mod $MOD_TARGET_BUSY
-
-check_result "% modprobe $MOD_TARGET_BUSY block_transition=N
-$MOD_TARGET_BUSY: ${MOD_TARGET_BUSY}_init
-$MOD_TARGET_BUSY: busymod_work_func enter
-$MOD_TARGET_BUSY: busymod_work_func exit
-% modprobe $MOD_LIVEPATCH
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-$MOD_LIVEPATCH: pre_patch_callback: vmlinux
-$MOD_LIVEPATCH: pre_patch_callback: $MOD_TARGET_BUSY -> [MODULE_STATE_LIVE] Normal state
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-$MOD_LIVEPATCH: post_patch_callback: vmlinux
-$MOD_LIVEPATCH: post_patch_callback: $MOD_TARGET_BUSY -> [MODULE_STATE_LIVE] Normal state
-livepatch: '$MOD_LIVEPATCH': patching complete
-% modprobe $MOD_TARGET
-livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET'
-$MOD_LIVEPATCH: pre_patch_callback: $MOD_TARGET -> [MODULE_STATE_COMING] Full formed, running module_init
-$MOD_LIVEPATCH: post_patch_callback: $MOD_TARGET -> [MODULE_STATE_COMING] Full formed, running module_init
-$MOD_TARGET: ${MOD_TARGET}_init
-% rmmod $MOD_TARGET
-$MOD_TARGET: ${MOD_TARGET}_exit
-$MOD_LIVEPATCH: pre_unpatch_callback: $MOD_TARGET -> [MODULE_STATE_GOING] Going away
-livepatch: reverting patch '$MOD_LIVEPATCH' on unloading module '$MOD_TARGET'
-$MOD_LIVEPATCH: post_unpatch_callback: $MOD_TARGET -> [MODULE_STATE_GOING] Going away
-% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
-livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-$MOD_LIVEPATCH: pre_unpatch_callback: vmlinux
-$MOD_LIVEPATCH: pre_unpatch_callback: $MOD_TARGET_BUSY -> [MODULE_STATE_LIVE] Normal state
-livepatch: '$MOD_LIVEPATCH': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-$MOD_LIVEPATCH: post_unpatch_callback: vmlinux
-$MOD_LIVEPATCH: post_unpatch_callback: $MOD_TARGET_BUSY -> [MODULE_STATE_LIVE] Normal state
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH
-% rmmod $MOD_TARGET_BUSY
-$MOD_TARGET_BUSY: ${MOD_TARGET_BUSY}_exit"
-
-
-# A similar test as the previous one, but force the "busy" kernel module
-# to block the livepatch transition.
-#
-# The livepatching core will refuse to patch a task that is currently
-# executing a to-be-patched function -- the consistency model stalls the
-# current patch transition until this safety-check is met.  Test a
-# scenario where one of a livepatch's target klp_objects sits on such a
-# function for a long time.  Meanwhile, load and unload other target
-# kernel modules while the livepatch transition is in progress.
-#
-# - Load the "busy" kernel module, this time make its work function loop
-#
-# - Meanwhile, the livepatch is loaded.  Notice that the patch
-#   transition does not complete as the targeted "busy" module is
-#   sitting on a to-be-patched function.
-#
-# - Load a second target module (this one is an ordinary idle kernel
-#   module).  Note that *no* post-patch callbacks will be executed while
-#   the livepatch is still in transition.
-#
-# - Request an unload of the simple kernel module.  The patch is still
-#   transitioning, so its pre-unpatch callbacks are skipped.
-#
-# - Finally the livepatch is disabled.  Since none of the patch's
-#   klp_object's post-patch callbacks executed, the remaining
-#   klp_object's pre-unpatch callbacks are skipped.
-
-start_test "busy target module"
-
-load_mod $MOD_TARGET_BUSY block_transition=Y
-load_lp_nowait $MOD_LIVEPATCH
-
-# Wait until the livepatch reports in-transition state, i.e. that it's
-# stalled on $MOD_TARGET_BUSY::busymod_work_func()
-loop_until 'grep -q '^1$' /sys/kernel/livepatch/$MOD_LIVEPATCH/transition' ||
-	die "failed to stall transition"
-
-load_mod $MOD_TARGET
-unload_mod $MOD_TARGET
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH
-unload_mod $MOD_TARGET_BUSY
-
-check_result "% modprobe $MOD_TARGET_BUSY block_transition=Y
-$MOD_TARGET_BUSY: ${MOD_TARGET_BUSY}_init
-$MOD_TARGET_BUSY: busymod_work_func enter
-% modprobe $MOD_LIVEPATCH
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-$MOD_LIVEPATCH: pre_patch_callback: vmlinux
-$MOD_LIVEPATCH: pre_patch_callback: $MOD_TARGET_BUSY -> [MODULE_STATE_LIVE] Normal state
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-% modprobe $MOD_TARGET
-livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET'
-$MOD_LIVEPATCH: pre_patch_callback: $MOD_TARGET -> [MODULE_STATE_COMING] Full formed, running module_init
-$MOD_TARGET: ${MOD_TARGET}_init
-% rmmod $MOD_TARGET
-$MOD_TARGET: ${MOD_TARGET}_exit
-livepatch: reverting patch '$MOD_LIVEPATCH' on unloading module '$MOD_TARGET'
-$MOD_LIVEPATCH: post_unpatch_callback: $MOD_TARGET -> [MODULE_STATE_GOING] Going away
-% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
-livepatch: '$MOD_LIVEPATCH': reversing transition from patching to unpatching
-livepatch: '$MOD_LIVEPATCH': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-$MOD_LIVEPATCH: post_unpatch_callback: vmlinux
-$MOD_LIVEPATCH: post_unpatch_callback: $MOD_TARGET_BUSY -> [MODULE_STATE_LIVE] Normal state
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH
-% rmmod $MOD_TARGET_BUSY
-$MOD_TARGET_BUSY: busymod_work_func exit
-$MOD_TARGET_BUSY: ${MOD_TARGET_BUSY}_exit"
-
-
-# Test loading multiple livepatches.  This test-case is mainly for comparing
-# with the next test-case.
-#
-# - Load and unload two livepatches, pre and post (un)patch callbacks
-#   execute as each patch progresses through its (un)patching
-#   transition.
-
-start_test "multiple livepatches"
-
-load_lp $MOD_LIVEPATCH
-load_lp $MOD_LIVEPATCH2
-disable_lp $MOD_LIVEPATCH2
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH2
-unload_lp $MOD_LIVEPATCH
-
-check_result "% modprobe $MOD_LIVEPATCH
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-$MOD_LIVEPATCH: pre_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-$MOD_LIVEPATCH: post_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': patching complete
-% modprobe $MOD_LIVEPATCH2
-livepatch: enabling patch '$MOD_LIVEPATCH2'
-livepatch: '$MOD_LIVEPATCH2': initializing patching transition
-$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': starting patching transition
-livepatch: '$MOD_LIVEPATCH2': completing patching transition
-$MOD_LIVEPATCH2: post_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': patching complete
-% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH2/enabled
-livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
-$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
-$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': unpatching complete
-% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
-livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-$MOD_LIVEPATCH: pre_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-$MOD_LIVEPATCH: post_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH2
-% rmmod $MOD_LIVEPATCH"
-
-
-# Load multiple livepatches, but the second as an 'atomic-replace'
-# patch.  When the latter loads, the original livepatch should be
-# disabled and *none* of its pre/post-unpatch callbacks executed.  On
-# the other hand, when the atomic-replace livepatch is disabled, its
-# pre/post-unpatch callbacks *should* be executed.
-#
-# - Load and unload two livepatches, the second of which has its
-#   .replace flag set true.
-#
-# - Pre and post patch callbacks are executed for both livepatches.
-#
-# - Once the atomic replace module is loaded, only its pre and post
-#   unpatch callbacks are executed.
-
-start_test "atomic replace"
-
-load_lp $MOD_LIVEPATCH
-load_lp $MOD_LIVEPATCH2 replace=1
-disable_lp $MOD_LIVEPATCH2
-unload_lp $MOD_LIVEPATCH2
-unload_lp $MOD_LIVEPATCH
-
-check_result "% modprobe $MOD_LIVEPATCH
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-$MOD_LIVEPATCH: pre_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-$MOD_LIVEPATCH: post_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': patching complete
-% modprobe $MOD_LIVEPATCH2 replace=1
-livepatch: enabling patch '$MOD_LIVEPATCH2'
-livepatch: '$MOD_LIVEPATCH2': initializing patching transition
-$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': starting patching transition
-livepatch: '$MOD_LIVEPATCH2': completing patching transition
-$MOD_LIVEPATCH2: post_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': patching complete
-% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH2/enabled
-livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
-$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
-$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': unpatching complete
-% rmmod $MOD_LIVEPATCH2
-% rmmod $MOD_LIVEPATCH"
-
-
-exit 0
diff --git a/tools/testing/selftests/livepatch/test-modules.sh b/tools/testing/selftests/livepatch/test-modules.sh
new file mode 100755
index 000000000000..1f7b502db173
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test-modules.sh
@@ -0,0 +1,539 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2018 Joe Lawrence <joe.lawrence@redhat.com>
+
+. $(dirname $0)/functions.sh
+
+MOD_LIVEPATCH=test_klp_speaker_livepatch
+MOD_LIVEPATCH2=test_klp_speaker_livepatch2
+MOD_TARGET=test_klp_speaker
+MOD_TARGET2=test_klp_speaker2
+
+setup_config
+
+# Test basic livepatch enable/disable functionality when livepatching
+# modules.
+#
+# Load the target module before the livepatch module. Unload them
+# in the reverse order.
+#
+# The expected state is checked by reading "welcome" parameter
+# of the target module. The livepatched variant should be printed
+# when both the target and livepatch modules are loaded.
+
+start_test "module enable/disable livepatch"
+
+load_mod $MOD_TARGET
+read_module_param $MOD_TARGET welcome
+
+load_lp $MOD_LIVEPATCH
+read_module_param $MOD_TARGET welcome
+
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
+read_module_param $MOD_TARGET welcome
+
+unload_mod $MOD_TARGET
+
+check_result "% modprobe $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_init
+% cat /sys/module/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% modprobe $MOD_LIVEPATCH
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% cat /sys/module/$MOD_TARGET/parameters/welcome
+$MOD_LIVEPATCH: livepatch_speaker_welcome: Ladies and gentleman, ...
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH
+% cat /sys/module/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% rmmod $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_exit"
+
+
+# Test the module coming hook in the module loader.
+#
+# Load the livepatch before the target module. Unload them in
+# the same order.
+#
+# The livepatch hook in the module loader should print a message
+# about applying the livepatch to the target module.
+#
+# The expected state is checked by reading "welcome" parameter
+# of the target module. The livepatched variant should be printed
+# when both the target and livepatch modules are loaded.
+
+start_test "module coming hook"
+
+load_lp $MOD_LIVEPATCH
+load_mod $MOD_TARGET
+read_module_param $MOD_TARGET welcome
+
+disable_lp $MOD_LIVEPATCH
+read_module_param $MOD_TARGET welcome
+
+unload_lp $MOD_LIVEPATCH
+unload_mod $MOD_TARGET
+
+check_result "% modprobe $MOD_LIVEPATCH
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% modprobe $MOD_TARGET
+livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET'
+$MOD_TARGET: ${MOD_TARGET}_init
+% cat /sys/module/$MOD_TARGET/parameters/welcome
+$MOD_LIVEPATCH: livepatch_speaker_welcome: Ladies and gentleman, ...
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% cat /sys/module/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% rmmod $MOD_LIVEPATCH
+% rmmod $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_exit"
+
+
+# Test the module going hook in the module loader.
+#
+# The livepatch hook in the module loader should print a message
+# about reverting the livepatch to the target module.
+#
+# The expected state is checked by reading "welcome" parameter
+# of the target module. The livepatched variant should be printed
+# when both the target and livepatch modules are loaded.
+
+start_test "module going hook"
+
+load_mod $MOD_TARGET
+read_module_param $MOD_TARGET welcome
+
+load_lp $MOD_LIVEPATCH
+read_module_param $MOD_TARGET welcome
+check_object_patched $MOD_LIVEPATCH $MOD_TARGET "1"
+
+unload_mod $MOD_TARGET
+check_object_patched $MOD_LIVEPATCH $MOD_TARGET "0"
+
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
+
+check_result "% modprobe $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_init
+% cat /sys/module/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% modprobe $MOD_LIVEPATCH
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% cat /sys/module/$MOD_TARGET/parameters/welcome
+$MOD_LIVEPATCH: livepatch_speaker_welcome: Ladies and gentleman, ...
+% rmmod $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_exit
+livepatch: reverting patch '$MOD_LIVEPATCH' on unloading module '$MOD_TARGET'
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH"
+
+# Test the module coming and going hooks in the module loader.
+#
+# Load the livepatch before the target module. Unload them in the reverse order.
+#
+# Both livepatch hooks in the module loader should print a message
+# about applying resp. reverting the livepatch to the target module.
+#
+# The expected state is checked by reading "welcome" parameter
+# of the target module. The livepatched variant should be printed
+# when both the target and livepatch modules are loaded.
+
+start_test "module coming and going hooks"
+
+load_lp $MOD_LIVEPATCH
+load_mod $MOD_TARGET
+read_module_param $MOD_TARGET welcome
+
+unload_mod $MOD_TARGET
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
+
+check_result "% modprobe $MOD_LIVEPATCH
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% modprobe $MOD_TARGET
+livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET'
+$MOD_TARGET: ${MOD_TARGET}_init
+% cat /sys/module/$MOD_TARGET/parameters/welcome
+$MOD_LIVEPATCH: livepatch_speaker_welcome: Ladies and gentleman, ...
+% rmmod $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_exit
+livepatch: reverting patch '$MOD_LIVEPATCH' on unloading module '$MOD_TARGET'
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH"
+
+
+# Use shadow variables, state, and callbacks to add "[APPLAUSE] "
+# into the message printed by "welcome" parameter.
+
+start_test "livepatch state callbacks"
+
+load_mod $MOD_TARGET
+read_module_param $MOD_TARGET welcome
+
+load_lp $MOD_LIVEPATCH add_applause=1
+read_module_param $MOD_TARGET welcome
+
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
+read_module_param $MOD_TARGET welcome
+
+unload_mod $MOD_TARGET
+
+check_result "% modprobe $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_init
+% cat /sys/module/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% modprobe $MOD_LIVEPATCH add_applause=1
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+$MOD_LIVEPATCH: setup_applause_callback: state 1
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+$MOD_LIVEPATCH: enable_applause_callback: state 1
+livepatch: '$MOD_LIVEPATCH': patching complete
+% cat /sys/module/$MOD_TARGET/parameters/welcome
+$MOD_LIVEPATCH: livepatch_speaker_welcome: [APPLAUSE] Ladies and gentleman, ...
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+$MOD_LIVEPATCH: disable_applause_callback: state 1
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+$MOD_LIVEPATCH: release_applause_callback: state 1
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH
+% cat /sys/module/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% rmmod $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_exit"
+
+# Use shadow variables, state, and callbacks to add "[APPLAUSE] "
+# into the message printed by "welcome" parameter.
+#
+# BUT make the "setup" callback fail.
+#
+# The livepatch should not get loaded. The test module should
+# should stay unpatched which is checked by reading the "welcome"
+# parameter.
+
+start_test "failing livepatch setup callback with -ENODEV"
+
+load_mod $MOD_TARGET
+read_module_param $MOD_TARGET welcome
+
+load_failing_mod $MOD_LIVEPATCH add_applause=1 setup_ret=-19
+read_module_param $MOD_TARGET welcome
+
+unload_mod $MOD_TARGET
+
+check_result "% modprobe $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_init
+% cat /sys/module/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% modprobe $MOD_LIVEPATCH add_applause=1 setup_ret=-19
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+$MOD_LIVEPATCH: setup_applause_callback: state 1
+$MOD_LIVEPATCH: setup_applause_callback: forcing err: -ENODEV
+livepatch: failed to enable patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': canceling patching transition, going to unpatch
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+modprobe: ERROR: could not insert '$MOD_LIVEPATCH': No such device
+% cat /sys/module/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% rmmod $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_exit"
+
+# Test loading multiple targeted kernel modules.  This test-case is
+# mainly for comparing with the next test-case.
+#
+# The livepatch gets loaded between two target modules. It adds
+# a livepatch state, callbacks, and shadow variable which would
+# add "[APPLAUSE] " into the message printed when reading
+# the "welcome" parameters of the two target modules.
+#
+# All four state callbacks should get called. And the message
+# "[APPLAUSE] Ladies and gentleman, ..." should be printed when
+# reading the "welcome" parameter while the livepatch is enabled.
+
+start_test "multiple target modules"
+
+load_mod $MOD_TARGET
+read_module_param $MOD_TARGET welcome
+
+load_lp $MOD_LIVEPATCH add_applause=1
+read_module_param $MOD_TARGET welcome
+
+load_mod $MOD_TARGET2
+read_module_param $MOD_TARGET2 welcome
+
+unload_mod $MOD_TARGET2
+disable_lp $MOD_LIVEPATCH
+read_module_param $MOD_TARGET welcome
+
+unload_lp $MOD_LIVEPATCH
+unload_mod $MOD_TARGET
+
+check_result "% modprobe $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_init
+% cat /sys/module/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% modprobe $MOD_LIVEPATCH add_applause=1
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+$MOD_LIVEPATCH: setup_applause_callback: state 1
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+$MOD_LIVEPATCH: enable_applause_callback: state 1
+livepatch: '$MOD_LIVEPATCH': patching complete
+% cat /sys/module/$MOD_TARGET/parameters/welcome
+$MOD_LIVEPATCH: livepatch_speaker_welcome: [APPLAUSE] Ladies and gentleman, ...
+% modprobe $MOD_TARGET2
+livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET2'
+$MOD_TARGET2: ${MOD_TARGET}_init
+% cat /sys/module/$MOD_TARGET2/parameters/welcome
+$MOD_LIVEPATCH: livepatch_speaker_welcome2: [APPLAUSE] Ladies and gentleman, ...
+% rmmod $MOD_TARGET2
+$MOD_TARGET2: ${MOD_TARGET}_exit
+livepatch: reverting patch '$MOD_LIVEPATCH' on unloading module '$MOD_TARGET2'
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+$MOD_LIVEPATCH: disable_applause_callback: state 1
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+$MOD_LIVEPATCH: release_applause_callback: state 1
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% cat /sys/module/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% rmmod $MOD_LIVEPATCH
+% rmmod $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_exit"
+
+# Test loading multiple livepatches.  This test-case is mainly for comparing
+# with the next test-case.
+#
+# The patching and unpatching transition should be done for both livepatches.
+
+start_test "multiple livepatches in parallel"
+
+load_lp $MOD_LIVEPATCH
+load_lp $MOD_LIVEPATCH2 noreplace=1
+disable_lp $MOD_LIVEPATCH2
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH2
+unload_lp $MOD_LIVEPATCH
+
+check_result "% modprobe $MOD_LIVEPATCH
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% modprobe $MOD_LIVEPATCH2 noreplace=1
+livepatch: enabling patch '$MOD_LIVEPATCH2'
+livepatch: '$MOD_LIVEPATCH2': initializing patching transition
+livepatch: '$MOD_LIVEPATCH2': starting patching transition
+livepatch: '$MOD_LIVEPATCH2': completing patching transition
+livepatch: '$MOD_LIVEPATCH2': patching complete
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH2/enabled
+livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH2': unpatching complete
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH2
+% rmmod $MOD_LIVEPATCH"
+
+
+# Load multiple livepatches, but the second as an 'atomic-replace'
+# patch.
+#
+# The 2nd livepatch will replace the 1st one. As a result, the 1s patch
+# can be removed wihtout the unpatch transition.
+
+start_test "atomic replace"
+
+load_lp $MOD_LIVEPATCH
+load_lp $MOD_LIVEPATCH2
+disable_lp $MOD_LIVEPATCH2
+unload_lp $MOD_LIVEPATCH2
+unload_lp $MOD_LIVEPATCH
+
+check_result "% modprobe $MOD_LIVEPATCH
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% modprobe $MOD_LIVEPATCH2
+livepatch: enabling patch '$MOD_LIVEPATCH2'
+livepatch: '$MOD_LIVEPATCH2': initializing patching transition
+livepatch: '$MOD_LIVEPATCH2': starting patching transition
+livepatch: '$MOD_LIVEPATCH2': completing patching transition
+livepatch: '$MOD_LIVEPATCH2': patching complete
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH2/enabled
+livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH2': unpatching complete
+% rmmod $MOD_LIVEPATCH2
+% rmmod $MOD_LIVEPATCH"
+
+exit 0
+
+# FIXME:
+#
+#    The test below does not work and I do not know why.
+#
+#    It seems that the livepatched function call_speaker()
+#    is not on the stack of the workqueue worker which
+#    is processing the speaker work.
+#
+#    Even though, there is a worker which is waiting in
+#    speaker_wait_and_welcome(). But the stack looks like:
+#
+#      [<0>] msleep+0x36/0x40
+#      [<0>] speaker_wait_and_welcome+0x40/0x60 [test_klp_speaker]
+#      [<0>] process_scheduled_works+0x2b4/0x530
+#      [<0>] worker_thread+0x174/0x340
+#      [<0>] kthread+0x100/0x130
+#      [<0>] ret_from_fork+0x2d/0x50
+#      [<0>] ret_from_fork_asm+0x1b/0x30
+#
+#    Note that I have got the same stack by adding show_stack()
+#    directly into speaker_wait_and_welcome() function.
+#
+#    Also note that the speaker must be waiting when the livepatch
+#    gets loaded. The speaker work  is queued when
+#    the "waiting_speaker=1" parameter is proceed. And
+#    waiting_welcome_set() waits until the worker started waiting.
+#
+#    And the function is supposed to be on the stack. It is called
+#    via the speaker->call() callback. And it is marked as noinline.
+#
+#    Note that "call_speaker() did not appear on the stack even
+#    when I tried to call it directly from speaker_func().
+#
+#    BTW: speaker_func() is not on the stack either. And it can't
+#         be inlined because it is callback for the workqueue work.
+#
+######################################################################
+#
+# A similar test as the previous one, but force the "busy" kernel module
+# to block the livepatch transition.
+#
+# The livepatching core will refuse to patch a task that is currently
+# executing a to-be-patched function -- the consistency model stalls the
+# current patch transition until this safety-check is met.  Test a
+# scenario where one of a livepatch's target klp_objects sits on such a
+# function for a long time.  Meanwhile, load and unload other target
+# kernel modules while the livepatch transition is in progress.
+#
+# Note:
+#
+#   - The started patching transion never finishes. Only "setup"
+#     callback is called.
+#
+#   - When reading the "welcome" parameter, the livepatched message
+#     is printed because it is a new process. But [APPLAUSE] is not
+#     printed because the "enable" callback has not been called.
+#
+#   - When the livepatch gets disabled, the current transiton gets
+#     reverted instead of starting a new disable transition. Only
+#     the "remove" callback is called.
+start_test "busy target module"
+
+load_mod $MOD_TARGET waiting_welcome=1
+# Wait until the asynchronous speaker started waiting.
+loop_until 'grep -q '^1$' /sys/module/$MOD_TARGET/parameters/started_waiting' ||
+	die "failed to stall transition"
+read_module_param $MOD_TARGET welcome
+
+load_lp_nowait $MOD_LIVEPATCH add_applause=1
+# Wait until the livepatch reports in-transition state, i.e. that it's
+# stalled because of the process with the waiting speaker
+loop_until 'grep -q '^1$' /sys/kernel/livepatch/$MOD_LIVEPATCH/transition' ||
+	die "failed to stall transition"
+read_module_param $MOD_TARGET welcome
+
+load_mod $MOD_TARGET2
+read_module_param $MOD_TARGET2 welcome
+
+unload_mod $MOD_TARGET2
+disable_lp $MOD_LIVEPATCH
+read_module_param $MOD_TARGET welcome
+
+unload_lp $MOD_LIVEPATCH
+unload_mod $MOD_TARGET
+
+check_result "% modprobe $MOD_TARGET waiting_welcome=1
+$MOD_TARGET: call_speaker: Calling speaker.
+$MOD_TARGET: speaker_wait_and_welcome: Speaker started waiting.
+$MOD_TARGET: ${MOD_TARGET}_init
+% cat /sys/module/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% modprobe $MOD_LIVEPATCH add_applause=1
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+$MOD_LIVEPATCH: setup_applause_callback: state 1
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+% cat /sys/module/$MOD_TARGET/parameters/welcome
+$MOD_LIVEPATCH: livepatch_speaker_welcome: [] Ladies and gentleman, ...
+% modprobe $MOD_TARGET2
+livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET2'
+$MOD_TARGET2: ${MOD_TARGET}_init
+% cat /sys/module/$MOD_TARGET2/parameters/welcome
+$MOD_LIVEPATCH: livepatch_speaker_welcome2: [] Ladies and gentleman, ...
+% rmmod $MOD_TARGET2
+$MOD_TARGET2: ${MOD_TARGET}_exit
+livepatch: reverting patch '$MOD_LIVEPATCH' on unloading module '$MOD_TARGET2'
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': reversing transition from patching to unpatching
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+$MOD_LIVEPATCH: release_applause_callback: state 1
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% cat /sys/module/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% rmmod $MOD_LIVEPATCH
+% rmmod $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_exit
+$MOD_TARGET: speaker_welcome: Hello, World!"
+
-- 
2.35.3


