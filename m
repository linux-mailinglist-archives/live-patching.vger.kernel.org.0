Return-Path: <live-patching+bounces-987-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27533A11BE6
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 09:28:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D05A3A56DD
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 08:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDB583DAC11;
	Wed, 15 Jan 2025 08:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="T00rhEBV";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="T00rhEBV"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A6B1E7C00;
	Wed, 15 Jan 2025 08:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929611; cv=none; b=oFKMeSQ/j0aSy39dk9MaBPQ4M9bhsezH6yiN8LikKO8b1Hd8W5uWRHfUbCYGo4yslbTpktjCyFxY47pkm8LyK2FiuWn5oOPSng6ES0WWlLFWM5P45p5Pud18xbVjmTK66M7SJwsmokeWxS+s/P2JCMktNwkqj5kIFd/HYKOzbc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929611; c=relaxed/simple;
	bh=JtNRq7HUV9zN9pWi4dZyJa4fNvTW21iqVkOmg4Hs5BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYkiisNGbbirzCCPZ3yIhW4Tg2AqCRH4nu3/U1dyb0dH5Ahz7SQQ6Vb0oaTbsBuBwIqiZQBYXsX3aB2en+GaZAzTUnkSBEU3fKULad7L77Oq9t4B3r111F7B+7wVcc6juUOjJZveEsjsLHs2urNupVh04jtF/U+YavxT/OD17YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=T00rhEBV; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=T00rhEBV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from pathway.suse.cz (unknown [10.100.201.202])
	by smtp-out2.suse.de (Postfix) with ESMTP id A35ED1F37C;
	Wed, 15 Jan 2025 08:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W50AFJVu3Hn9GCC6l0ptb8I+fT5fKa3wfP2A9cKgsYw=;
	b=T00rhEBV5q5/B8LI7i2pfQZOmej14e4nbK8j7IAc03QvGUoeF+9dCtpDjyILxE+XUJFhmL
	B07WiIasZuo/t4Je4a0pE+bBcsNnLDFEBg7WdtOkxVBAjGCsEu7EEwk3zNiJ4SA5mI7gkw
	O3pXh2qbeHLMtT2SQaKt4Y/u7CG02F4=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W50AFJVu3Hn9GCC6l0ptb8I+fT5fKa3wfP2A9cKgsYw=;
	b=T00rhEBV5q5/B8LI7i2pfQZOmej14e4nbK8j7IAc03QvGUoeF+9dCtpDjyILxE+XUJFhmL
	B07WiIasZuo/t4Je4a0pE+bBcsNnLDFEBg7WdtOkxVBAjGCsEu7EEwk3zNiJ4SA5mI7gkw
	O3pXh2qbeHLMtT2SQaKt4Y/u7CG02F4=
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v1 12/19] selftests/livepatch: Convert selftest with blocked transition
Date: Wed, 15 Jan 2025 09:24:24 +0100
Message-ID: <20250115082431.5550-13-pmladek@suse.com>
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
callbacks and will be removed soon.

For the conversion of the self-test of the callbacks with a blocked
transition, use the new module with a virtual speaker.

Implementation Details:

  + The implementation of the blocked function is inspired by the
    module "test_klp_callbacks_busy". Specifically, the blocked function
    is called in a workqueue, synchronization is done using a completion,
    and the replacement of the blocked function is not fully functional[*].

  + The blocked function is queued and called only if the parameter
    "block_doors" is set.

Important Note on Sibling Call Optimization:

Sibling call optimization must be disabled for functions designed to block
transitions. Otherwise, they won't appear on the stack, leading to test
failure. These functions can be livepatched because they are called with
the call instruction. But when an optimized version just jumps to a nested
then the jump instruction obviously doesn't store any return address
on the stack.

[*] The livepatch variant of the blocked function is never called
    because the transition is reverted. It is going to change in a followup
    patch.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 .../selftests/livepatch/test-callbacks.sh     | 73 -------------------
 .../livepatch/test-state-callbacks.sh         | 56 ++++++++++++++
 .../livepatch/test_modules/test_klp_speaker.c | 61 ++++++++++++++++
 .../test_modules/test_klp_speaker_livepatch.c | 28 +++++++
 4 files changed, 145 insertions(+), 73 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test-callbacks.sh b/tools/testing/selftests/livepatch/test-callbacks.sh
index 1ecd8f08a613..858e8f0b14d5 100755
--- a/tools/testing/selftests/livepatch/test-callbacks.sh
+++ b/tools/testing/selftests/livepatch/test-callbacks.sh
@@ -11,79 +11,6 @@ MOD_TARGET_BUSY=test_klp_callbacks_busy
 
 setup_config
 
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
-loop_until 'grep -q '^1$' $SYSFS_KLP_DIR/$MOD_LIVEPATCH/transition' ||
-	die "failed to stall transition"
-
-load_mod $MOD_TARGET
-unload_mod $MOD_TARGET
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH
-unload_mod $MOD_TARGET_BUSY
-
-check_result "% insmod test_modules/$MOD_TARGET_BUSY.ko block_transition=Y
-$MOD_TARGET_BUSY: ${MOD_TARGET_BUSY}_init
-$MOD_TARGET_BUSY: busymod_work_func enter
-% insmod test_modules/$MOD_LIVEPATCH.ko
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-$MOD_LIVEPATCH: pre_patch_callback: vmlinux
-$MOD_LIVEPATCH: pre_patch_callback: $MOD_TARGET_BUSY -> [MODULE_STATE_LIVE] Normal state
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-% insmod test_modules/$MOD_TARGET.ko
-livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET'
-$MOD_LIVEPATCH: pre_patch_callback: $MOD_TARGET -> [MODULE_STATE_COMING] Full formed, running module_init
-$MOD_TARGET: ${MOD_TARGET}_init
-% rmmod $MOD_TARGET
-$MOD_TARGET: ${MOD_TARGET}_exit
-livepatch: reverting patch '$MOD_LIVEPATCH' on unloading module '$MOD_TARGET'
-$MOD_LIVEPATCH: post_unpatch_callback: $MOD_TARGET -> [MODULE_STATE_GOING] Going away
-% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
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
 # Test loading multiple livepatches.  This test-case is mainly for comparing
 # with the next test-case.
 #
diff --git a/tools/testing/selftests/livepatch/test-state-callbacks.sh b/tools/testing/selftests/livepatch/test-state-callbacks.sh
index 28ef88a2dfc3..043e2062d71c 100755
--- a/tools/testing/selftests/livepatch/test-state-callbacks.sh
+++ b/tools/testing/selftests/livepatch/test-state-callbacks.sh
@@ -90,4 +90,60 @@ $MOD_TARGET: speaker_welcome: Hello, World!
 % rmmod $MOD_TARGET
 $MOD_TARGET: ${MOD_TARGET}_exit"
 
+# Test state callbacks handling with blocked and reverted transitons.
+#
+# The started patching transion never finishes. Only "pre_patch"
+# callback is called.
+#
+# When reading the "welcome" parameter, the livepatched message
+# is printed because it is a new process. But [APPLAUSE] is not
+# printed because the "post_patch" callback has not been called.
+#
+# When the livepatch gets disabled, the current transiton gets
+# reverted instead of starting a new disable transition. Only
+# the "post_unpatch" callback is called.
+start_test "blocked transition"
+
+load_mod $MOD_TARGET block_doors=1
+read_module_param $MOD_TARGET welcome
+
+load_lp_nowait $MOD_LIVEPATCH applause=1
+# Wait until the livepatch reports in-transition state, i.e. that it's
+# stalled because of the process with the waiting speaker
+loop_until 'grep -q '^1$' $SYSFS_KLP_DIR/$MOD_LIVEPATCH/transition' ||
+	die "failed to stall transition"
+read_module_param $MOD_TARGET welcome
+
+disable_lp $MOD_LIVEPATCH
+read_module_param $MOD_TARGET welcome
+
+unload_lp $MOD_LIVEPATCH
+unload_mod $MOD_TARGET
+
+check_result "% insmod test_modules/$MOD_TARGET.ko block_doors=1
+$MOD_TARGET: ${MOD_TARGET}_init
+$MOD_TARGET: block_doors_func: Going to block doors.
+$MOD_TARGET: do_block_doors: Started blocking doors.
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% insmod test_modules/$MOD_LIVEPATCH.ko applause=1
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+$MOD_LIVEPATCH: applause_pre_patch_callback: state 10
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_LIVEPATCH: lp_speaker_welcome: [] Ladies and gentleman, ...
+% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': reversing transition from patching to unpatching
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+$MOD_LIVEPATCH: applause_post_unpatch_callback: state 10 (nope)
+$MOD_LIVEPATCH: applause_shadow_dtor: freeing applause [] (nope)
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% rmmod $MOD_LIVEPATCH
+% rmmod $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_exit"
+
 exit 0
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker.c b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker.c
index 92c577addb8e..6dcf15b4154b 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker.c
@@ -5,6 +5,9 @@
 
 #include <linux/module.h>
 #include <linux/printk.h>
+#include <linux/delay.h>
+#include <linux/sysfs.h>
+#include <linux/completion.h>
 
 #ifndef SPEAKER_ID
 #define SPEAKER_ID ""
@@ -21,6 +24,10 @@
  *	welcome_get().
  *
  *    - Reuse the module source for more speakers, see SPEAKER_ID.
+ *
+ *    - Add "block_doors" parameter which could block the livepatch transition.
+ *	The stalled function is offloaded to a workqueue so that it does not
+ *	block the module load.
  */
 
 noinline
@@ -43,16 +50,70 @@ static const struct kernel_param_ops welcome_ops = {
 module_param_cb(welcome, &welcome_ops, NULL, 0400);
 MODULE_PARM_DESC(welcome, "Print speaker's welcome message into the kernel log when reading the value.");
 
+static DECLARE_COMPLETION(started_blocking_doors);
+struct work_struct block_doors_work;
+static bool block_doors;
+static bool show_over;
+
+noinline
+static void do_block_doors(void)
+{
+	pr_info("%s: Started blocking doors.\n", __func__);
+	complete(&started_blocking_doors);
+
+	while (!READ_ONCE(show_over)) {
+		/* Busy-wait until the module gets unloaded. */
+		msleep(20);
+	}
+}
+
+/*
+ * Prevent tail call optimizations to make sure that this function
+ * appears in the backtrace and blocks the transition.
+ */
+__attribute__((__optimize__("no-optimize-sibling-calls")))
+static void block_doors_func(struct work_struct *work)
+{
+	pr_info("%s: Going to block doors%s.\n", __func__, SPEAKER_ID);
+	do_block_doors();
+}
+
+static void block_doors_set(void)
+{
+	init_completion(&started_blocking_doors);
+	INIT_WORK(&block_doors_work, block_doors_func);
+
+	schedule_work(&block_doors_work);
+
+	/*
+	 * To synchronize kernel messages, hold this callback from
+	 * exiting until the work function's entry message has got printed.
+	 */
+	wait_for_completion(&started_blocking_doors);
+
+}
+
+module_param(block_doors, bool, 0400);
+MODULE_PARM_DESC(block_doors, "Block doors so that the audience could not enter. It blocks the livepatch transition. (default=false)");
+
 static int test_klp_speaker_init(void)
 {
 	pr_info("%s\n", __func__);
 
+	if (block_doors)
+		block_doors_set();
+
 	return 0;
 }
 
 static void test_klp_speaker_exit(void)
 {
 	pr_info("%s\n", __func__);
+
+	if (block_doors) {
+		WRITE_ONCE(show_over, true);
+		flush_work(&block_doors_work);
+	}
 }
 
 module_init(test_klp_speaker_init);
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
index c46c98a3c1e6..76402947c789 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
@@ -19,6 +19,8 @@
  *	"Ladies and gentleman, ..."
  *
  *    - Support more speaker modules, see __lp_speaker_welcome().
+ *
+ *    - Livepatch block_doors_func() which can block the transition.
  */
 
 #define APPLAUSE_ID 10
@@ -180,11 +182,33 @@ static void applause_shadow_dtor(void *obj, void *shadow_data)
 		__func__, applause);
 }
 
+static void __lp_block_doors_func(struct work_struct *work, const char *caller_func,
+		       const char *speaker_id)
+{
+	/* Just print the message. Never really used. */
+	pr_info("%s: Going to block doors%s (this should never happen).\n",
+		caller_func, speaker_id);
+}
+
+static void lp_block_doors_func(struct work_struct *work)
+{
+	__lp_block_doors_func(work, __func__, "");
+}
+
+static void lp_block_doors_func2(struct work_struct *work)
+{
+	__lp_block_doors_func(work, __func__, "(2)");
+}
+
 static struct klp_func test_klp_speaker_funcs[] = {
 	{
 		.old_name = "speaker_welcome",
 		.new_func = lp_speaker_welcome,
 	},
+	{
+		.old_name = "block_doors_func",
+		.new_func = lp_block_doors_func,
+	},
 	{ }
 };
 
@@ -193,6 +217,10 @@ static struct klp_func test_klp_speaker2_funcs[] = {
 		.old_name = "speaker_welcome",
 		.new_func = lp_speaker2_welcome,
 	},
+	{
+		.old_name = "block_doors_func",
+		.new_func = lp_block_doors_func2,
+	},
 	{ }
 };
 
-- 
2.47.1


