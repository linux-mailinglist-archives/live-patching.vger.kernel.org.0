Return-Path: <live-patching+bounces-981-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8D19A11BD8
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 09:26:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12E4C3A0370
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 08:26:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 862FB1E7C0C;
	Wed, 15 Jan 2025 08:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sHRDrnIp";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="r1LytqUN"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F66C3DAC14;
	Wed, 15 Jan 2025 08:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929549; cv=none; b=J3AztSKreRcH+iLF0loP12EDHcKJ/Yc/ds3q6BQwQYC4llSINkQFqCS+02XkFkZ0ijOYaLv8dOX2PJmRGphnLNs2EV5KEJmlymCaePtlDzZaE70Nf6bcFoplEjs/b+1N++5A7rTJjb17rz17c6SEZ4DV9zp2wLYG7TyK91r3LwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929549; c=relaxed/simple;
	bh=4QTo2NDNuzr4RK3YrSrJ5nmfkJJ89UojGACdDI+ySmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evt5Varkncyqxh+WtIiZRDeQrK0ogZsWrSlUgOlZBfdOtoI1/TY5ZCyE68wb4zZO5P4/Mskchizu2LlhCIY1umJCg6mj++7EFKUbhYZicfMPJhrtpjSPrdiiW4+YnHPaxKwVTXP9bV/d98FKk1ca9Ok/NsTEmRJG/xzIPyQ/zXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sHRDrnIp; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=r1LytqUN; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from pathway.suse.cz (unknown [10.100.201.202])
	by smtp-out2.suse.de (Postfix) with ESMTP id 461141F37C;
	Wed, 15 Jan 2025 08:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929545; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CA5Xr0nkZJTn3RPFgpmmPMXzJcaQLfN9rFU4vnHY6N0=;
	b=sHRDrnIpqDwEMCqnbhmGaBRVarwk3Tj/2jY30pZlDGZKp/C/BOLod0YX589fXFmsCuKwEX
	hPCUi12hpC2jhiI4cC0O9ONpkFPqY28EkMnx/FPL9q3HJpNstV1Q7PxTs0YPbwWij6Gjq/
	2dcaaQ5gtw908vcF7YpaHiDS/SyIdgQ=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929544; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CA5Xr0nkZJTn3RPFgpmmPMXzJcaQLfN9rFU4vnHY6N0=;
	b=r1LytqUNQERO956ZGUUJsfG//pN/oLS7UDFgf/7c3RqLt4m2P5Ow8TcYtXnmug7YcS/++n
	fjHaB7oQJeK5+zBXzFILSxi2LvbK8n6L5DrTXxELJvlqZHBx4BHKHUuckp5cWgxtbRIYar
	F/QBQy2tNGbeV6xXjLa7OuWHq6astLY=
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v1 06/19] selftests/livepatch: Remove callbacks from sysfs interface testing
Date: Wed, 15 Jan 2025 09:24:18 +0100
Message-ID: <20250115082431.5550-7-pmladek@suse.com>
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
	RCPT_COUNT_SEVEN(0.00)[7];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,pathway.suse.cz:helo]
X-Spam-Score: -6.80
X-Spam-Flag: NO

This commit removes the use of callbacks in the sysfs interface testing.
The callbacks are not necessary for this testing and create unnecessary
noise.

This commit replaces the test modules that use the obsolete per-object
callbacks with a simple test module in a "Hello World" style and a
corresponding livepatch.

These new modules will be extended in the future to include an optional
integration of livepatch states, per-state callbacks, and shadow variables.
They will be used for testing all the new features.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 .../testing/selftests/livepatch/test-sysfs.sh | 48 ++++++---------
 .../selftests/livepatch/test_modules/Makefile |  2 +
 .../livepatch/test_modules/test_klp_speaker.c | 38 ++++++++++++
 .../test_modules/test_klp_speaker_livepatch.c | 61 +++++++++++++++++++
 4 files changed, 121 insertions(+), 28 deletions(-)
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_speaker.c
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c

diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index 2c91428d2997..c565e6005710 100755
--- a/tools/testing/selftests/livepatch/test-sysfs.sh
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -43,8 +43,8 @@ livepatch: '$MOD_LIVEPATCH': unpatching complete
 
 start_test "sysfs test object/patched"
 
-MOD_LIVEPATCH=test_klp_callbacks_demo
-MOD_TARGET=test_klp_callbacks_mod
+MOD_LIVEPATCH=test_klp_speaker_livepatch
+MOD_TARGET=test_klp_speaker
 load_lp $MOD_LIVEPATCH
 
 # check the "patch" file changes as target module loads/unloads
@@ -57,32 +57,24 @@ check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "0"
 disable_lp $MOD_LIVEPATCH
 unload_lp $MOD_LIVEPATCH
 
-check_result "% insmod test_modules/test_klp_callbacks_demo.ko
-livepatch: enabling patch 'test_klp_callbacks_demo'
-livepatch: 'test_klp_callbacks_demo': initializing patching transition
-test_klp_callbacks_demo: pre_patch_callback: vmlinux
-livepatch: 'test_klp_callbacks_demo': starting patching transition
-livepatch: 'test_klp_callbacks_demo': completing patching transition
-test_klp_callbacks_demo: post_patch_callback: vmlinux
-livepatch: 'test_klp_callbacks_demo': patching complete
-% insmod test_modules/test_klp_callbacks_mod.ko
-livepatch: applying patch 'test_klp_callbacks_demo' to loading module 'test_klp_callbacks_mod'
-test_klp_callbacks_demo: pre_patch_callback: test_klp_callbacks_mod -> [MODULE_STATE_COMING] Full formed, running module_init
-test_klp_callbacks_demo: post_patch_callback: test_klp_callbacks_mod -> [MODULE_STATE_COMING] Full formed, running module_init
-test_klp_callbacks_mod: test_klp_callbacks_mod_init
-% rmmod test_klp_callbacks_mod
-test_klp_callbacks_mod: test_klp_callbacks_mod_exit
-test_klp_callbacks_demo: pre_unpatch_callback: test_klp_callbacks_mod -> [MODULE_STATE_GOING] Going away
-livepatch: reverting patch 'test_klp_callbacks_demo' on unloading module 'test_klp_callbacks_mod'
-test_klp_callbacks_demo: post_unpatch_callback: test_klp_callbacks_mod -> [MODULE_STATE_GOING] Going away
-% echo 0 > $SYSFS_KLP_DIR/test_klp_callbacks_demo/enabled
-livepatch: 'test_klp_callbacks_demo': initializing unpatching transition
-test_klp_callbacks_demo: pre_unpatch_callback: vmlinux
-livepatch: 'test_klp_callbacks_demo': starting unpatching transition
-livepatch: 'test_klp_callbacks_demo': completing unpatching transition
-test_klp_callbacks_demo: post_unpatch_callback: vmlinux
-livepatch: 'test_klp_callbacks_demo': unpatching complete
-% rmmod test_klp_callbacks_demo"
+check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% insmod test_modules/$MOD_TARGET.ko
+livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET'
+$MOD_TARGET: ${MOD_TARGET}_init
+% rmmod $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_exit
+livepatch: reverting patch '$MOD_LIVEPATCH' on unloading module '$MOD_TARGET'
+% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH"
 
 start_test "sysfs test replace enabled"
 
diff --git a/tools/testing/selftests/livepatch/test_modules/Makefile b/tools/testing/selftests/livepatch/test_modules/Makefile
index 939230e571f5..0978c489a67a 100644
--- a/tools/testing/selftests/livepatch/test_modules/Makefile
+++ b/tools/testing/selftests/livepatch/test_modules/Makefile
@@ -9,6 +9,8 @@ obj-m += test_klp_atomic_replace.o \
 	test_klp_kprobe.o \
 	test_klp_livepatch.o \
 	test_klp_shadow_vars.o \
+	test_klp_speaker.o \
+	test_klp_speaker_livepatch.o \
 	test_klp_state.o \
 	test_klp_state2.o \
 	test_klp_state3.o \
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker.c b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker.c
new file mode 100644
index 000000000000..b1fb135820b0
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2024 SUSE
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/printk.h>
+
+/**
+ * test_klp_speaker - test module for testing misc livepatching features
+ *
+ * The module provides a virtual speaker who can do:
+ *
+ *    - Start a show with a greeting, see speaker_welcome().
+ */
+
+noinline
+static void __always_used speaker_welcome(void)
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
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
new file mode 100644
index 000000000000..26a8dd15f723
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
@@ -0,0 +1,61 @@
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
+/**
+ * test_klp_speaker_livepatch - test livepatch for testing various livepatching
+ *	features.
+ *
+ * The livepatch modifies the behavior of a virtual speaker provided by
+ * the module test_klp_speaker. It can do:
+ *
+ *    - Improve the speaker's greeting from "Hello, World!" to
+ *	"Ladies and gentleman, ..."
+ */
+
+static void lp_speaker_welcome(void)
+{
+	pr_info("%s: Ladies and gentleman, ...\n", __func__);
+}
+
+static struct klp_func test_klp_speaker_funcs[] = {
+	{
+		.old_name = "speaker_welcome",
+		.new_func = lp_speaker_welcome,
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
+MODULE_DESCRIPTION("Livepatch test: livepatch test_klp_speaker test module");
-- 
2.47.1


