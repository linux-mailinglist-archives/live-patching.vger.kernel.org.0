Return-Path: <live-patching+bounces-984-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C7BEA11BDF
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 09:27:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DDA53A2095
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 08:27:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77CE2284A50;
	Wed, 15 Jan 2025 08:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Y8d5/w2p";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Y8d5/w2p"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8B21E7C39;
	Wed, 15 Jan 2025 08:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929580; cv=none; b=GbG4siS2pWQxeJCE9a4+gEAByCP5XE993wuPHK18mPdtPX/QjtVAySeP2vsrs1IWKPwwrrF7rAa9eHhesTeDxAbYETMt+dr4anfb7FKqLtEp8aGbD7/ArTABjt23O0+gxj5bZw7PLnHxXxHXIkUYkmbPYB0UBm8HFabZeRA8Z/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929580; c=relaxed/simple;
	bh=+/aYqB9X4ddkL4ahwzObcMp1VvHynzmc+CCb68tKSo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJmuvUs1Pp3279vDrqqYedu5z0Qk/dW0yS1gmYweCM3mfA/txaAPT25eE1sBU6bJRmTsvDMxIezTrYRdyZ1/lKE+LNIx6cbPm+xEhv+Kp9qfl4x0MMGzl8vw32BDQHWT7ALz9XW+WvY0n/qN8lX6RU31EwPlRXB/zvFDLY5vGBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Y8d5/w2p; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Y8d5/w2p; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from pathway.suse.cz (unknown [10.100.201.202])
	by smtp-out2.suse.de (Postfix) with ESMTP id 8ABE31F37C;
	Wed, 15 Jan 2025 08:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929576; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j+QghZn9w2cXkVEJZDAG7GtuKZuu/WCV7cLR1e9WOpw=;
	b=Y8d5/w2ppdqQapggmNC2IljxnmJ2FgjmXkXyQC3hxWGbRNPj1xamTCv+nl1Jsrhm3kp2j5
	6CuZA/h2000rMgC003lObtc7UbNn1/N6DJfBbn5+qLaPhpQNmHl4Za6AUsgEXPfOb1uKlo
	08h+/2OwCvLRzcPbIDYup42iHNC0ttY=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929576; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j+QghZn9w2cXkVEJZDAG7GtuKZuu/WCV7cLR1e9WOpw=;
	b=Y8d5/w2ppdqQapggmNC2IljxnmJ2FgjmXkXyQC3hxWGbRNPj1xamTCv+nl1Jsrhm3kp2j5
	6CuZA/h2000rMgC003lObtc7UbNn1/N6DJfBbn5+qLaPhpQNmHl4Za6AUsgEXPfOb1uKlo
	08h+/2OwCvLRzcPbIDYup42iHNC0ttY=
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v1 09/19] selftests/livepatch: Convert testing of multiple target modules
Date: Wed, 15 Jan 2025 09:24:21 +0100
Message-ID: <20250115082431.5550-10-pmladek@suse.com>
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
X-Spam-Score: -6.80
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,pathway.suse.cz:helo]
X-Spam-Flag: NO
X-Spam-Level: 

The per-object callbacks have been replaced by per-state callbacks and
will be removed soon.

A selftest previously loaded two livepatched modules to ensure that
the per-object callbacks were called for both.

Although per-state callbacks are only invoked when the live patch is
enabled or disabled, it is still important to verify that multiple objects
can be live-patched.

Convert the test into a generic one by reusing the speaker test module
to create the second target module.

In the second variant, speaker_welcome() will only print "(2)" after
the function name to distinguish it, while keeping the real function name
the same to maintain simplicity.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 .../selftests/livepatch/test-callbacks.sh     | 59 ----------------
 .../testing/selftests/livepatch/test-order.sh | 69 +++++++++++++++++++
 .../selftests/livepatch/test_modules/Makefile |  1 +
 .../livepatch/test_modules/test_klp_speaker.c |  8 ++-
 .../test_modules/test_klp_speaker2.c          |  8 +++
 .../test_modules/test_klp_speaker_livepatch.c | 26 ++++++-
 6 files changed, 110 insertions(+), 61 deletions(-)
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_speaker2.c

diff --git a/tools/testing/selftests/livepatch/test-callbacks.sh b/tools/testing/selftests/livepatch/test-callbacks.sh
index 614ed0aa2e40..a9bb90920c0a 100755
--- a/tools/testing/selftests/livepatch/test-callbacks.sh
+++ b/tools/testing/selftests/livepatch/test-callbacks.sh
@@ -93,65 +93,6 @@ $MOD_LIVEPATCH: post_unpatch_callback: vmlinux
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 
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
-check_result "% insmod test_modules/$MOD_TARGET_BUSY.ko block_transition=N
-$MOD_TARGET_BUSY: ${MOD_TARGET_BUSY}_init
-$MOD_TARGET_BUSY: busymod_work_func enter
-$MOD_TARGET_BUSY: busymod_work_func exit
-% insmod test_modules/$MOD_LIVEPATCH.ko
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-$MOD_LIVEPATCH: pre_patch_callback: vmlinux
-$MOD_LIVEPATCH: pre_patch_callback: $MOD_TARGET_BUSY -> [MODULE_STATE_LIVE] Normal state
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-$MOD_LIVEPATCH: post_patch_callback: vmlinux
-$MOD_LIVEPATCH: post_patch_callback: $MOD_TARGET_BUSY -> [MODULE_STATE_LIVE] Normal state
-livepatch: '$MOD_LIVEPATCH': patching complete
-% insmod test_modules/$MOD_TARGET.ko
-livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET'
-$MOD_LIVEPATCH: pre_patch_callback: $MOD_TARGET -> [MODULE_STATE_COMING] Full formed, running module_init
-$MOD_LIVEPATCH: post_patch_callback: $MOD_TARGET -> [MODULE_STATE_COMING] Full formed, running module_init
-$MOD_TARGET: ${MOD_TARGET}_init
-% rmmod $MOD_TARGET
-$MOD_TARGET: ${MOD_TARGET}_exit
-$MOD_LIVEPATCH: pre_unpatch_callback: $MOD_TARGET -> [MODULE_STATE_GOING] Going away
-livepatch: reverting patch '$MOD_LIVEPATCH' on unloading module '$MOD_TARGET'
-$MOD_LIVEPATCH: post_unpatch_callback: $MOD_TARGET -> [MODULE_STATE_GOING] Going away
-% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
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
 # A similar test as the previous one, but force the "busy" kernel module
 # to block the livepatch transition.
 #
diff --git a/tools/testing/selftests/livepatch/test-order.sh b/tools/testing/selftests/livepatch/test-order.sh
index 869b06605597..189132b01bac 100755
--- a/tools/testing/selftests/livepatch/test-order.sh
+++ b/tools/testing/selftests/livepatch/test-order.sh
@@ -7,6 +7,7 @@
 
 MOD_LIVEPATCH=test_klp_speaker_livepatch
 MOD_TARGET=test_klp_speaker
+MOD_TARGET2=test_klp_speaker2
 
 setup_config
 
@@ -224,3 +225,71 @@ livepatch: '$MOD_LIVEPATCH': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
+
+# Test loading multiple targeted kernel modules.
+#
+# Load the first target module before the livepatch and the second one later.
+# Disable and unload them in the opposite order.
+#
+# The module loader hooks should print a message about applying/reverting
+# the livepatch for the 2nd module when it is being loaded/unloaded.
+#
+# The expected state is double-checked by reading "welcome" parameter
+# of both target modules. The livepatched variant should be printed
+# when both the target and livepatch modules are loaded.
+
+start_test "multiple target modules"
+
+load_mod $MOD_TARGET
+read_module_param $MOD_TARGET welcome
+
+load_lp $MOD_LIVEPATCH
+read_module_param $MOD_TARGET welcome
+check_object_patched $MOD_LIVEPATCH $MOD_TARGET "1"
+check_object_patched $MOD_LIVEPATCH $MOD_TARGET2 "0"
+
+load_mod $MOD_TARGET2
+read_module_param $MOD_TARGET2 welcome
+check_object_patched $MOD_LIVEPATCH $MOD_TARGET "1"
+check_object_patched $MOD_LIVEPATCH $MOD_TARGET2 "1"
+
+unload_mod $MOD_TARGET2
+check_object_patched $MOD_LIVEPATCH $MOD_TARGET "1"
+check_object_patched $MOD_LIVEPATCH $MOD_TARGET2 "0"
+
+disable_lp $MOD_LIVEPATCH
+read_module_param $MOD_TARGET welcome
+
+unload_lp $MOD_LIVEPATCH
+unload_mod $MOD_TARGET
+
+check_result "% insmod test_modules/$MOD_TARGET.ko
+$MOD_TARGET: ${MOD_TARGET}_init
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% insmod test_modules/$MOD_LIVEPATCH.ko
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_LIVEPATCH: lp_speaker_welcome: Ladies and gentleman, ...
+% insmod test_modules/$MOD_TARGET2.ko
+livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET2'
+$MOD_TARGET2: ${MOD_TARGET}_init
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET2/parameters/welcome
+$MOD_LIVEPATCH: lp_speaker2_welcome(2): Ladies and gentleman, ...
+% rmmod $MOD_TARGET2
+$MOD_TARGET2: ${MOD_TARGET}_exit
+livepatch: reverting patch '$MOD_LIVEPATCH' on unloading module '$MOD_TARGET2'
+% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% rmmod $MOD_LIVEPATCH
+% rmmod $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_exit"
diff --git a/tools/testing/selftests/livepatch/test_modules/Makefile b/tools/testing/selftests/livepatch/test_modules/Makefile
index 0978c489a67a..72a817d1ddd9 100644
--- a/tools/testing/selftests/livepatch/test_modules/Makefile
+++ b/tools/testing/selftests/livepatch/test_modules/Makefile
@@ -10,6 +10,7 @@ obj-m += test_klp_atomic_replace.o \
 	test_klp_livepatch.o \
 	test_klp_shadow_vars.o \
 	test_klp_speaker.o \
+	test_klp_speaker2.o \
 	test_klp_speaker_livepatch.o \
 	test_klp_state.o \
 	test_klp_state2.o \
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker.c b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker.c
index 22f6e5fcb009..92c577addb8e 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker.c
@@ -6,6 +6,10 @@
 #include <linux/module.h>
 #include <linux/printk.h>
 
+#ifndef SPEAKER_ID
+#define SPEAKER_ID ""
+#endif
+
 /**
  * test_klp_speaker - test module for testing misc livepatching features
  *
@@ -15,12 +19,14 @@
  *
  *    - Log the greeting by reading the "welcome" module parameter, see
  *	welcome_get().
+ *
+ *    - Reuse the module source for more speakers, see SPEAKER_ID.
  */
 
 noinline
 static void speaker_welcome(void)
 {
-	pr_info("%s: Hello, World!\n", __func__);
+	pr_info("%s%s: Hello, World!\n", __func__, SPEAKER_ID);
 }
 
 static int welcome_get(char *buffer, const struct kernel_param *kp)
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker2.c b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker2.c
new file mode 100644
index 000000000000..d38ab51414bf
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker2.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2023 SUSE
+
+/* Use versioned function name for livepatched functions */
+#define SPEAKER_ID "(2)"
+
+/* Same module with the same features. */
+#include "test_klp_speaker.c"
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
index 26a8dd15f723..8d7e74a69a5d 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
@@ -17,11 +17,23 @@
  *
  *    - Improve the speaker's greeting from "Hello, World!" to
  *	"Ladies and gentleman, ..."
+ *
+ *    - Support more speaker modules, see __lp_speaker_welcome().
  */
 
+static void __lp_speaker_welcome(const char *caller_func, const char *speaker_id)
+{
+	pr_info("%s%s: Ladies and gentleman, ...\n", caller_func, speaker_id);
+}
+
 static void lp_speaker_welcome(void)
 {
-	pr_info("%s: Ladies and gentleman, ...\n", __func__);
+	__lp_speaker_welcome(__func__, "");
+}
+
+static void lp_speaker2_welcome(void)
+{
+	__lp_speaker_welcome(__func__, "(2)");
 }
 
 static struct klp_func test_klp_speaker_funcs[] = {
@@ -32,11 +44,23 @@ static struct klp_func test_klp_speaker_funcs[] = {
 	{ }
 };
 
+static struct klp_func test_klp_speaker2_funcs[] = {
+	{
+		.old_name = "speaker_welcome",
+		.new_func = lp_speaker2_welcome,
+	},
+	{ }
+};
+
 static struct klp_object objs[] = {
 	{
 		.name = "test_klp_speaker",
 		.funcs = test_klp_speaker_funcs,
 	},
+	{
+		.name = "test_klp_speaker2",
+		.funcs = test_klp_speaker2_funcs,
+	},
 	{ }
 };
 
-- 
2.47.1


