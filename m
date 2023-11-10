Return-Path: <live-patching+bounces-35-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B97B67E7DFC
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 18:05:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA62E1C2097C
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 17:05:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E49B01BDCF;
	Fri, 10 Nov 2023 17:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PDrSH6j6"
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956B61DFDF
	for <live-patching@vger.kernel.org>; Fri, 10 Nov 2023 17:05:42 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B997F431C6;
	Fri, 10 Nov 2023 09:05:40 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id 76A36219A8;
	Fri, 10 Nov 2023 17:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1699635939; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NCeADohju+t4A5792an+kfuP3X1RplnDdJoa+c7b8Kw=;
	b=PDrSH6j6XXpWzPvje0K6HX8bDL/aDEJ7Qe83QB0uCPUJHLKm/fwpsmRjqyCV4Wqpq+1ySc
	nM0JWU3HXgLwIDCCDblmSfYtzGXpqcsvu8oPFgxvw45UlGUv8V27GU1KZ9fYfigI2NPtSJ
	V33tetz+dwj0Idx/9yt0Uj+RR9nFcFs=
Received: from alley.suse.cz (pmladek.udp.ovpn2.prg.suse.de [10.100.201.202])
	by relay2.suse.de (Postfix) with ESMTP id 1A5262C2A9;
	Fri, 10 Nov 2023 17:05:39 +0000 (UTC)
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [POC 4/7] livepatch: Do not use callbacks when testing sysfs interface
Date: Fri, 10 Nov 2023 18:04:25 +0100
Message-Id: <20231110170428.6664-5-pmladek@suse.com>
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

The per-object callbacks have been obsoleted by per-state callbacks.
As a result, the callbacks test modules have been obsoleted
by updated klp state tests.

The callbacks test modules are re-used in the sysfs selftests.
It would be possible to replace them by klp state test modules
but the newly generated logs are hard to review because
there is a lot of noise caused by the callbacks.

Instead, introduce a simple test module in a "Hello World"
style and corresponding livepatch. The expected log can be
reviewed easily.

The test module might be later extended to provide more functionality
which might be used in more tests. It would allow to create tests
focusing on some particular feature with an easier output.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 lib/livepatch/Makefile                        |  2 +
 lib/livepatch/test_klp_speaker.c              | 34 +++++++++++++
 lib/livepatch/test_klp_speaker_livepatch.c    | 50 +++++++++++++++++++
 .../testing/selftests/livepatch/test-sysfs.sh | 48 ++++++++----------
 4 files changed, 106 insertions(+), 28 deletions(-)
 create mode 100644 lib/livepatch/test_klp_speaker.c
 create mode 100644 lib/livepatch/test_klp_speaker_livepatch.c

diff --git a/lib/livepatch/Makefile b/lib/livepatch/Makefile
index dcc912b3478f..a8a5f6597633 100644
--- a/lib/livepatch/Makefile
+++ b/lib/livepatch/Makefile
@@ -9,6 +9,8 @@ obj-$(CONFIG_TEST_LIVEPATCH) += test_klp_atomic_replace.o \
 				test_klp_callbacks_mod.o \
 				test_klp_livepatch.o \
 				test_klp_shadow_vars.o \
+				test_klp_speaker.o \
+				test_klp_speaker_livepatch.o \
 				test_klp_state.o \
 				test_klp_state2.o \
 				test_klp_state3.o
diff --git a/lib/livepatch/test_klp_speaker.c b/lib/livepatch/test_klp_speaker.c
new file mode 100644
index 000000000000..d2d31072639a
--- /dev/null
+++ b/lib/livepatch/test_klp_speaker.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2023 SUSE
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#ifndef _VER_NAME
+#define _VER_NAME(name) name
+#endif
+
+#include <linux/module.h>
+#include <linux/printk.h>
+
+noinline
+void speaker_welcome(void)
+{
+	pr_info("%s: Hello, World!\n", __func__);
+}
+
+static int test_klp_speaker_init(void)
+{
+	pr_info("%s\n", __func__);
+
+	return 0;
+}
+
+static void test_klp_speaker_exit(void)
+{
+	pr_info("%s\n", __func__);
+}
+
+module_init(test_klp_speaker_init);
+module_exit(test_klp_speaker_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Livepatch test: test functions");
diff --git a/lib/livepatch/test_klp_speaker_livepatch.c b/lib/livepatch/test_klp_speaker_livepatch.c
new file mode 100644
index 000000000000..0317a4937b78
--- /dev/null
+++ b/lib/livepatch/test_klp_speaker_livepatch.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+#include <linux/init.h>
+
+
+void livepatch_speaker_welcome(void)
+{
+	pr_info("%s: Ladies and gentleman, ...\n", __func__);
+}
+
+
+static struct klp_func test_klp_speaker_funcs[] = {
+	{
+		.old_name = "speaker_welcome",
+		.new_func = livepatch_speaker_welcome,
+	},
+	{ }
+};
+
+static struct klp_object objs[] = {
+	{
+		.name = "test_klp_speaker",
+		.funcs = test_klp_speaker_funcs,
+	},
+	{ }
+};
+
+static struct klp_patch patch = {
+	.mod = THIS_MODULE,
+	.objs = objs,
+};
+
+static int test_klp_speaker_livepatch_init(void)
+{
+	return klp_enable_patch(&patch);
+}
+
+static void test_klp_speaker_livepatch_exit(void)
+{
+}
+
+module_init(test_klp_speaker_livepatch_init);
+module_exit(test_klp_speaker_livepatch_exit);
+MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index 7f76f280189a..424b6af32c99 100755
--- a/tools/testing/selftests/livepatch/test-sysfs.sh
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -42,8 +42,8 @@ livepatch: '$MOD_LIVEPATCH': unpatching complete
 
 start_test "sysfs test object/patched"
 
-MOD_LIVEPATCH=test_klp_callbacks_demo
-MOD_TARGET=test_klp_callbacks_mod
+MOD_LIVEPATCH=test_klp_speaker_livepatch
+MOD_TARGET=test_klp_speaker
 load_lp $MOD_LIVEPATCH
 
 # check the "patch" file changes as target module loads/unloads
@@ -56,31 +56,23 @@ check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "0"
 disable_lp $MOD_LIVEPATCH
 unload_lp $MOD_LIVEPATCH
 
-check_result "% modprobe test_klp_callbacks_demo
-livepatch: enabling patch 'test_klp_callbacks_demo'
-livepatch: 'test_klp_callbacks_demo': initializing patching transition
-test_klp_callbacks_demo: pre_patch_callback: vmlinux
-livepatch: 'test_klp_callbacks_demo': starting patching transition
-livepatch: 'test_klp_callbacks_demo': completing patching transition
-test_klp_callbacks_demo: post_patch_callback: vmlinux
-livepatch: 'test_klp_callbacks_demo': patching complete
-% modprobe test_klp_callbacks_mod
-livepatch: applying patch 'test_klp_callbacks_demo' to loading module 'test_klp_callbacks_mod'
-test_klp_callbacks_demo: pre_patch_callback: test_klp_callbacks_mod -> [MODULE_STATE_COMING] Full formed, running module_init
-test_klp_callbacks_demo: post_patch_callback: test_klp_callbacks_mod -> [MODULE_STATE_COMING] Full formed, running module_init
-test_klp_callbacks_mod: test_klp_callbacks_mod_init
-% rmmod test_klp_callbacks_mod
-test_klp_callbacks_mod: test_klp_callbacks_mod_exit
-test_klp_callbacks_demo: pre_unpatch_callback: test_klp_callbacks_mod -> [MODULE_STATE_GOING] Going away
-livepatch: reverting patch 'test_klp_callbacks_demo' on unloading module 'test_klp_callbacks_mod'
-test_klp_callbacks_demo: post_unpatch_callback: test_klp_callbacks_mod -> [MODULE_STATE_GOING] Going away
-% echo 0 > /sys/kernel/livepatch/test_klp_callbacks_demo/enabled
-livepatch: 'test_klp_callbacks_demo': initializing unpatching transition
-test_klp_callbacks_demo: pre_unpatch_callback: vmlinux
-livepatch: 'test_klp_callbacks_demo': starting unpatching transition
-livepatch: 'test_klp_callbacks_demo': completing unpatching transition
-test_klp_callbacks_demo: post_unpatch_callback: vmlinux
-livepatch: 'test_klp_callbacks_demo': unpatching complete
-% rmmod test_klp_callbacks_demo"
+check_result "% modprobe $MOD_LIVEPATCH
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% modprobe $MOD_TARGET
+livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET'
+$MOD_TARGET: ${MOD_TARGET}_init
+% rmmod $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_exit
+livepatch: reverting patch '$MOD_LIVEPATCH' on unloading module '$MOD_TARGET'
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH"
 
 exit 0
-- 
2.35.3


