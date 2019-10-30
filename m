Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7539E9F5F
	for <lists+live-patching@lfdr.de>; Wed, 30 Oct 2019 16:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfJ3Pna (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 30 Oct 2019 11:43:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:35754 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727485AbfJ3Pna (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 30 Oct 2019 11:43:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BDAECB479;
        Wed, 30 Oct 2019 15:43:26 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH v4 5/5] livepatch: Selftests of the API for tracking system state changes
Date:   Wed, 30 Oct 2019 16:43:13 +0100
Message-Id: <20191030154313.13263-6-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191030154313.13263-1-pmladek@suse.com>
References: <20191030154313.13263-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Four selftests for the new API.

Signed-off-by: Petr Mladek <pmladek@suse.com>
Acked-by: Miroslav Benes <mbenes@suse.cz>
---
 lib/livepatch/Makefile                          |   5 +-
 lib/livepatch/test_klp_state.c                  | 162 ++++++++++++++++++++
 lib/livepatch/test_klp_state2.c                 | 191 ++++++++++++++++++++++++
 lib/livepatch/test_klp_state3.c                 |   5 +
 tools/testing/selftests/livepatch/Makefile      |   3 +-
 tools/testing/selftests/livepatch/test-state.sh | 180 ++++++++++++++++++++++
 6 files changed, 544 insertions(+), 2 deletions(-)
 create mode 100644 lib/livepatch/test_klp_state.c
 create mode 100644 lib/livepatch/test_klp_state2.c
 create mode 100644 lib/livepatch/test_klp_state3.c
 create mode 100755 tools/testing/selftests/livepatch/test-state.sh

diff --git a/lib/livepatch/Makefile b/lib/livepatch/Makefile
index 26900ddaef82..295b94bff370 100644
--- a/lib/livepatch/Makefile
+++ b/lib/livepatch/Makefile
@@ -8,7 +8,10 @@ obj-$(CONFIG_TEST_LIVEPATCH) += test_klp_atomic_replace.o \
 				test_klp_callbacks_busy.o \
 				test_klp_callbacks_mod.o \
 				test_klp_livepatch.o \
-				test_klp_shadow_vars.o
+				test_klp_shadow_vars.o \
+				test_klp_state.o \
+				test_klp_state2.o \
+				test_klp_state3.o
 
 # Target modules to be livepatched require CC_FLAGS_FTRACE
 CFLAGS_test_klp_callbacks_busy.o	+= $(CC_FLAGS_FTRACE)
diff --git a/lib/livepatch/test_klp_state.c b/lib/livepatch/test_klp_state.c
new file mode 100644
index 000000000000..57a4253acb01
--- /dev/null
+++ b/lib/livepatch/test_klp_state.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2019 SUSE
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/printk.h>
+#include <linux/livepatch.h>
+
+#define CONSOLE_LOGLEVEL_STATE 1
+/* Version 1 does not support migration. */
+#define CONSOLE_LOGLEVEL_STATE_VERSION 1
+
+static const char *const module_state[] = {
+	[MODULE_STATE_LIVE]	= "[MODULE_STATE_LIVE] Normal state",
+	[MODULE_STATE_COMING]	= "[MODULE_STATE_COMING] Full formed, running module_init",
+	[MODULE_STATE_GOING]	= "[MODULE_STATE_GOING] Going away",
+	[MODULE_STATE_UNFORMED]	= "[MODULE_STATE_UNFORMED] Still setting it up",
+};
+
+static void callback_info(const char *callback, struct klp_object *obj)
+{
+	if (obj->mod)
+		pr_info("%s: %s -> %s\n", callback, obj->mod->name,
+			module_state[obj->mod->state]);
+	else
+		pr_info("%s: vmlinux\n", callback);
+}
+
+static struct klp_patch patch;
+
+static int allocate_loglevel_state(void)
+{
+	struct klp_state *loglevel_state;
+
+	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
+	if (!loglevel_state)
+		return -EINVAL;
+
+	loglevel_state->data = kzalloc(sizeof(console_loglevel), GFP_KERNEL);
+	if (!loglevel_state->data)
+		return -ENOMEM;
+
+	pr_info("%s: allocating space to store console_loglevel\n",
+		__func__);
+	return 0;
+}
+
+static void fix_console_loglevel(void)
+{
+	struct klp_state *loglevel_state;
+
+	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
+	if (!loglevel_state)
+		return;
+
+	pr_info("%s: fixing console_loglevel\n", __func__);
+	*(int *)loglevel_state->data = console_loglevel;
+	console_loglevel = CONSOLE_LOGLEVEL_MOTORMOUTH;
+}
+
+static void restore_console_loglevel(void)
+{
+	struct klp_state *loglevel_state;
+
+	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
+	if (!loglevel_state)
+		return;
+
+	pr_info("%s: restoring console_loglevel\n", __func__);
+	console_loglevel = *(int *)loglevel_state->data;
+}
+
+static void free_loglevel_state(void)
+{
+	struct klp_state *loglevel_state;
+
+	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
+	if (!loglevel_state)
+		return;
+
+	pr_info("%s: freeing space for the stored console_loglevel\n",
+		__func__);
+	kfree(loglevel_state->data);
+}
+
+/* Executed on object patching (ie, patch enablement) */
+static int pre_patch_callback(struct klp_object *obj)
+{
+	callback_info(__func__, obj);
+	return allocate_loglevel_state();
+}
+
+/* Executed on object unpatching (ie, patch disablement) */
+static void post_patch_callback(struct klp_object *obj)
+{
+	callback_info(__func__, obj);
+	fix_console_loglevel();
+}
+
+/* Executed on object unpatching (ie, patch disablement) */
+static void pre_unpatch_callback(struct klp_object *obj)
+{
+	callback_info(__func__, obj);
+	restore_console_loglevel();
+}
+
+/* Executed on object unpatching (ie, patch disablement) */
+static void post_unpatch_callback(struct klp_object *obj)
+{
+	callback_info(__func__, obj);
+	free_loglevel_state();
+}
+
+static struct klp_func no_funcs[] = {
+	{}
+};
+
+static struct klp_object objs[] = {
+	{
+		.name = NULL,	/* vmlinux */
+		.funcs = no_funcs,
+		.callbacks = {
+			.pre_patch = pre_patch_callback,
+			.post_patch = post_patch_callback,
+			.pre_unpatch = pre_unpatch_callback,
+			.post_unpatch = post_unpatch_callback,
+		},
+	}, { }
+};
+
+static struct klp_state states[] = {
+	{
+		.id = CONSOLE_LOGLEVEL_STATE,
+		.version = CONSOLE_LOGLEVEL_STATE_VERSION,
+	}, { }
+};
+
+static struct klp_patch patch = {
+	.mod = THIS_MODULE,
+	.objs = objs,
+	.states = states,
+	.replace = true,
+};
+
+static int test_klp_callbacks_demo_init(void)
+{
+	return klp_enable_patch(&patch);
+}
+
+static void test_klp_callbacks_demo_exit(void)
+{
+}
+
+module_init(test_klp_callbacks_demo_init);
+module_exit(test_klp_callbacks_demo_exit);
+MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
+MODULE_AUTHOR("Petr Mladek <pmladek@suse.com>");
+MODULE_DESCRIPTION("Livepatch test: system state modification");
diff --git a/lib/livepatch/test_klp_state2.c b/lib/livepatch/test_klp_state2.c
new file mode 100644
index 000000000000..c978ea4d5e67
--- /dev/null
+++ b/lib/livepatch/test_klp_state2.c
@@ -0,0 +1,191 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2019 SUSE
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/printk.h>
+#include <linux/livepatch.h>
+
+#define CONSOLE_LOGLEVEL_STATE 1
+/* Version 2 supports migration. */
+#define CONSOLE_LOGLEVEL_STATE_VERSION 2
+
+static const char *const module_state[] = {
+	[MODULE_STATE_LIVE]	= "[MODULE_STATE_LIVE] Normal state",
+	[MODULE_STATE_COMING]	= "[MODULE_STATE_COMING] Full formed, running module_init",
+	[MODULE_STATE_GOING]	= "[MODULE_STATE_GOING] Going away",
+	[MODULE_STATE_UNFORMED]	= "[MODULE_STATE_UNFORMED] Still setting it up",
+};
+
+static void callback_info(const char *callback, struct klp_object *obj)
+{
+	if (obj->mod)
+		pr_info("%s: %s -> %s\n", callback, obj->mod->name,
+			module_state[obj->mod->state]);
+	else
+		pr_info("%s: vmlinux\n", callback);
+}
+
+static struct klp_patch patch;
+
+static int allocate_loglevel_state(void)
+{
+	struct klp_state *loglevel_state, *prev_loglevel_state;
+
+	prev_loglevel_state = klp_get_prev_state(CONSOLE_LOGLEVEL_STATE);
+	if (prev_loglevel_state) {
+		pr_info("%s: space to store console_loglevel already allocated\n",
+		__func__);
+		return 0;
+	}
+
+	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
+	if (!loglevel_state)
+		return -EINVAL;
+
+	loglevel_state->data = kzalloc(sizeof(console_loglevel), GFP_KERNEL);
+	if (!loglevel_state->data)
+		return -ENOMEM;
+
+	pr_info("%s: allocating space to store console_loglevel\n",
+		__func__);
+	return 0;
+}
+
+static void fix_console_loglevel(void)
+{
+	struct klp_state *loglevel_state, *prev_loglevel_state;
+
+	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
+	if (!loglevel_state)
+		return;
+
+	prev_loglevel_state = klp_get_prev_state(CONSOLE_LOGLEVEL_STATE);
+	if (prev_loglevel_state) {
+		pr_info("%s: taking over the console_loglevel change\n",
+		__func__);
+		loglevel_state->data = prev_loglevel_state->data;
+		return;
+	}
+
+	pr_info("%s: fixing console_loglevel\n", __func__);
+	*(int *)loglevel_state->data = console_loglevel;
+	console_loglevel = CONSOLE_LOGLEVEL_MOTORMOUTH;
+}
+
+static void restore_console_loglevel(void)
+{
+	struct klp_state *loglevel_state, *prev_loglevel_state;
+
+	prev_loglevel_state = klp_get_prev_state(CONSOLE_LOGLEVEL_STATE);
+	if (prev_loglevel_state) {
+		pr_info("%s: passing the console_loglevel change back to the old livepatch\n",
+		__func__);
+		return;
+	}
+
+	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
+	if (!loglevel_state)
+		return;
+
+	pr_info("%s: restoring console_loglevel\n", __func__);
+	console_loglevel = *(int *)loglevel_state->data;
+}
+
+static void free_loglevel_state(void)
+{
+	struct klp_state *loglevel_state, *prev_loglevel_state;
+
+	prev_loglevel_state = klp_get_prev_state(CONSOLE_LOGLEVEL_STATE);
+	if (prev_loglevel_state) {
+		pr_info("%s: keeping space to store console_loglevel\n",
+		__func__);
+		return;
+	}
+
+	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
+	if (!loglevel_state)
+		return;
+
+	pr_info("%s: freeing space for the stored console_loglevel\n",
+		__func__);
+	kfree(loglevel_state->data);
+}
+
+/* Executed on object patching (ie, patch enablement) */
+static int pre_patch_callback(struct klp_object *obj)
+{
+	callback_info(__func__, obj);
+	return allocate_loglevel_state();
+}
+
+/* Executed on object unpatching (ie, patch disablement) */
+static void post_patch_callback(struct klp_object *obj)
+{
+	callback_info(__func__, obj);
+	fix_console_loglevel();
+}
+
+/* Executed on object unpatching (ie, patch disablement) */
+static void pre_unpatch_callback(struct klp_object *obj)
+{
+	callback_info(__func__, obj);
+	restore_console_loglevel();
+}
+
+/* Executed on object unpatching (ie, patch disablement) */
+static void post_unpatch_callback(struct klp_object *obj)
+{
+	callback_info(__func__, obj);
+	free_loglevel_state();
+}
+
+static struct klp_func no_funcs[] = {
+	{}
+};
+
+static struct klp_object objs[] = {
+	{
+		.name = NULL,	/* vmlinux */
+		.funcs = no_funcs,
+		.callbacks = {
+			.pre_patch = pre_patch_callback,
+			.post_patch = post_patch_callback,
+			.pre_unpatch = pre_unpatch_callback,
+			.post_unpatch = post_unpatch_callback,
+		},
+	}, { }
+};
+
+static struct klp_state states[] = {
+	{
+		.id = CONSOLE_LOGLEVEL_STATE,
+		.version = CONSOLE_LOGLEVEL_STATE_VERSION,
+	}, { }
+};
+
+static struct klp_patch patch = {
+	.mod = THIS_MODULE,
+	.objs = objs,
+	.states = states,
+	.replace = true,
+};
+
+static int test_klp_callbacks_demo_init(void)
+{
+	return klp_enable_patch(&patch);
+}
+
+static void test_klp_callbacks_demo_exit(void)
+{
+}
+
+module_init(test_klp_callbacks_demo_init);
+module_exit(test_klp_callbacks_demo_exit);
+MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
+MODULE_AUTHOR("Petr Mladek <pmladek@suse.com>");
+MODULE_DESCRIPTION("Livepatch test: system state modification");
diff --git a/lib/livepatch/test_klp_state3.c b/lib/livepatch/test_klp_state3.c
new file mode 100644
index 000000000000..9226579d10c5
--- /dev/null
+++ b/lib/livepatch/test_klp_state3.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2019 SUSE
+
+/* The console loglevel fix is the same in the next cumulative patch. */
+#include "test_klp_state2.c"
diff --git a/tools/testing/selftests/livepatch/Makefile b/tools/testing/selftests/livepatch/Makefile
index fd405402c3ff..1cf40a9e7185 100644
--- a/tools/testing/selftests/livepatch/Makefile
+++ b/tools/testing/selftests/livepatch/Makefile
@@ -4,6 +4,7 @@ TEST_PROGS_EXTENDED := functions.sh
 TEST_PROGS := \
 	test-livepatch.sh \
 	test-callbacks.sh \
-	test-shadow-vars.sh
+	test-shadow-vars.sh \
+	test-state.sh
 
 include ../lib.mk
diff --git a/tools/testing/selftests/livepatch/test-state.sh b/tools/testing/selftests/livepatch/test-state.sh
new file mode 100755
index 000000000000..dc2908c22c26
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test-state.sh
@@ -0,0 +1,180 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019 SUSE
+
+. $(dirname $0)/functions.sh
+
+MOD_LIVEPATCH=test_klp_state
+MOD_LIVEPATCH2=test_klp_state2
+MOD_LIVEPATCH3=test_klp_state3
+
+set_dynamic_debug
+
+
+# TEST: Loading and removing a module that modifies the system state
+
+echo -n "TEST: system state modification ... "
+dmesg -C
+
+load_lp $MOD_LIVEPATCH
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
+
+check_result "% modprobe $MOD_LIVEPATCH
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+$MOD_LIVEPATCH: pre_patch_callback: vmlinux
+$MOD_LIVEPATCH: allocate_loglevel_state: allocating space to store console_loglevel
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+$MOD_LIVEPATCH: post_patch_callback: vmlinux
+$MOD_LIVEPATCH: fix_console_loglevel: fixing console_loglevel
+livepatch: '$MOD_LIVEPATCH': patching complete
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+$MOD_LIVEPATCH: pre_unpatch_callback: vmlinux
+$MOD_LIVEPATCH: restore_console_loglevel: restoring console_loglevel
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+$MOD_LIVEPATCH: post_unpatch_callback: vmlinux
+$MOD_LIVEPATCH: free_loglevel_state: freeing space for the stored console_loglevel
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH"
+
+
+# TEST: Take over system state change by a cumulative patch
+
+echo -n "TEST: taking over system state modification ... "
+dmesg -C
+
+load_lp $MOD_LIVEPATCH
+load_lp $MOD_LIVEPATCH2
+unload_lp $MOD_LIVEPATCH
+disable_lp $MOD_LIVEPATCH2
+unload_lp $MOD_LIVEPATCH2
+
+check_result "% modprobe $MOD_LIVEPATCH
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+$MOD_LIVEPATCH: pre_patch_callback: vmlinux
+$MOD_LIVEPATCH: allocate_loglevel_state: allocating space to store console_loglevel
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+$MOD_LIVEPATCH: post_patch_callback: vmlinux
+$MOD_LIVEPATCH: fix_console_loglevel: fixing console_loglevel
+livepatch: '$MOD_LIVEPATCH': patching complete
+% modprobe $MOD_LIVEPATCH2
+livepatch: enabling patch '$MOD_LIVEPATCH2'
+livepatch: '$MOD_LIVEPATCH2': initializing patching transition
+$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
+$MOD_LIVEPATCH2: allocate_loglevel_state: space to store console_loglevel already allocated
+livepatch: '$MOD_LIVEPATCH2': starting patching transition
+livepatch: '$MOD_LIVEPATCH2': completing patching transition
+$MOD_LIVEPATCH2: post_patch_callback: vmlinux
+$MOD_LIVEPATCH2: fix_console_loglevel: taking over the console_loglevel change
+livepatch: '$MOD_LIVEPATCH2': patching complete
+% rmmod $MOD_LIVEPATCH
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH2/enabled
+livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
+$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
+$MOD_LIVEPATCH2: restore_console_loglevel: restoring console_loglevel
+livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
+$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
+$MOD_LIVEPATCH2: free_loglevel_state: freeing space for the stored console_loglevel
+livepatch: '$MOD_LIVEPATCH2': unpatching complete
+% rmmod $MOD_LIVEPATCH2"
+
+
+# TEST: Take over system state change by a cumulative patch
+
+echo -n "TEST: compatible cumulative livepatches ... "
+dmesg -C
+
+load_lp $MOD_LIVEPATCH2
+load_lp $MOD_LIVEPATCH3
+unload_lp $MOD_LIVEPATCH2
+load_lp $MOD_LIVEPATCH2
+disable_lp $MOD_LIVEPATCH2
+unload_lp $MOD_LIVEPATCH2
+unload_lp $MOD_LIVEPATCH3
+
+check_result "% modprobe $MOD_LIVEPATCH2
+livepatch: enabling patch '$MOD_LIVEPATCH2'
+livepatch: '$MOD_LIVEPATCH2': initializing patching transition
+$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
+$MOD_LIVEPATCH2: allocate_loglevel_state: allocating space to store console_loglevel
+livepatch: '$MOD_LIVEPATCH2': starting patching transition
+livepatch: '$MOD_LIVEPATCH2': completing patching transition
+$MOD_LIVEPATCH2: post_patch_callback: vmlinux
+$MOD_LIVEPATCH2: fix_console_loglevel: fixing console_loglevel
+livepatch: '$MOD_LIVEPATCH2': patching complete
+% modprobe $MOD_LIVEPATCH3
+livepatch: enabling patch '$MOD_LIVEPATCH3'
+livepatch: '$MOD_LIVEPATCH3': initializing patching transition
+$MOD_LIVEPATCH3: pre_patch_callback: vmlinux
+$MOD_LIVEPATCH3: allocate_loglevel_state: space to store console_loglevel already allocated
+livepatch: '$MOD_LIVEPATCH3': starting patching transition
+livepatch: '$MOD_LIVEPATCH3': completing patching transition
+$MOD_LIVEPATCH3: post_patch_callback: vmlinux
+$MOD_LIVEPATCH3: fix_console_loglevel: taking over the console_loglevel change
+livepatch: '$MOD_LIVEPATCH3': patching complete
+% rmmod $MOD_LIVEPATCH2
+% modprobe $MOD_LIVEPATCH2
+livepatch: enabling patch '$MOD_LIVEPATCH2'
+livepatch: '$MOD_LIVEPATCH2': initializing patching transition
+$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
+$MOD_LIVEPATCH2: allocate_loglevel_state: space to store console_loglevel already allocated
+livepatch: '$MOD_LIVEPATCH2': starting patching transition
+livepatch: '$MOD_LIVEPATCH2': completing patching transition
+$MOD_LIVEPATCH2: post_patch_callback: vmlinux
+$MOD_LIVEPATCH2: fix_console_loglevel: taking over the console_loglevel change
+livepatch: '$MOD_LIVEPATCH2': patching complete
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH2/enabled
+livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
+$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
+$MOD_LIVEPATCH2: restore_console_loglevel: restoring console_loglevel
+livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
+$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
+$MOD_LIVEPATCH2: free_loglevel_state: freeing space for the stored console_loglevel
+livepatch: '$MOD_LIVEPATCH2': unpatching complete
+% rmmod $MOD_LIVEPATCH2
+% rmmod $MOD_LIVEPATCH3"
+
+
+# TEST: Failure caused by incompatible cumulative livepatches
+
+echo -n "TEST: incompatible cumulative livepatches ... "
+dmesg -C
+
+load_lp $MOD_LIVEPATCH2
+load_failing_mod $MOD_LIVEPATCH
+disable_lp $MOD_LIVEPATCH2
+unload_lp $MOD_LIVEPATCH2
+
+check_result "% modprobe $MOD_LIVEPATCH2
+livepatch: enabling patch '$MOD_LIVEPATCH2'
+livepatch: '$MOD_LIVEPATCH2': initializing patching transition
+$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
+$MOD_LIVEPATCH2: allocate_loglevel_state: allocating space to store console_loglevel
+livepatch: '$MOD_LIVEPATCH2': starting patching transition
+livepatch: '$MOD_LIVEPATCH2': completing patching transition
+$MOD_LIVEPATCH2: post_patch_callback: vmlinux
+$MOD_LIVEPATCH2: fix_console_loglevel: fixing console_loglevel
+livepatch: '$MOD_LIVEPATCH2': patching complete
+% modprobe $MOD_LIVEPATCH
+livepatch: Livepatch patch ($MOD_LIVEPATCH) is not compatible with the already installed livepatches.
+modprobe: ERROR: could not insert '$MOD_LIVEPATCH': Invalid argument
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH2/enabled
+livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
+$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
+$MOD_LIVEPATCH2: restore_console_loglevel: restoring console_loglevel
+livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
+$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
+$MOD_LIVEPATCH2: free_loglevel_state: freeing space for the stored console_loglevel
+livepatch: '$MOD_LIVEPATCH2': unpatching complete
+% rmmod $MOD_LIVEPATCH2"
+
+exit 0
-- 
2.16.4

