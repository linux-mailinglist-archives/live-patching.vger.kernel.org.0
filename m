Return-Path: <live-patching+bounces-988-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 90F0EA11BE9
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 09:28:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF789188AC23
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 08:28:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A28BD1EEA3A;
	Wed, 15 Jan 2025 08:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RqES1h53";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RqES1h53"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EFE1EEA36;
	Wed, 15 Jan 2025 08:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929622; cv=none; b=uQlmCG8vKpgJrVxUMBDuHJCsUaYC3vvyb+zqnJNnPZcBrTBtMOJZJd3wWv099uCcik7XqJNnO+RTkeGkqxzCCfRek9AbgBDEs9pj+k6cKyw+Krz1O7SyzbbW1oXlvP95Wso/C8BGZXzIN8JIEDz9fPq/S6yWYeySdvg2y9N2aoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929622; c=relaxed/simple;
	bh=NavPbJFBvMcgks94+1CtvgczTKwXetkubAWbpquSb2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRLozz81Qg5QMNY3rESxeM+74+e3+UsUDaRxNh7/Y8M4fcxIhtWl5O47fuIj/1holi5pi0cxQv3JzKaMeWxi+Sy/goz+5TS9VOKQTroJ6PF6V6/NiD75MAfMxxTdNjsokktD9oik26G7JMWMDa4AYFRT9utjltflyQn3Ai/cLz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RqES1h53; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RqES1h53; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from pathway.suse.cz (unknown [10.100.201.202])
	by smtp-out2.suse.de (Postfix) with ESMTP id 087B11F37C;
	Wed, 15 Jan 2025 08:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929618; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sAvpVG8P2b4EE+5j8jySKGjcMWTuEFrQjkKGnJ4bzxI=;
	b=RqES1h53EHkCsWTYHCwmum5ptaOsxLGJ36MaMuX9UmCMk497hn+OB38j4T9QAHA7A42zRk
	YM5QBdkQau/9Pewp0fy9vDg1hfekAFcCbIcTwUcHs2VJ7NOIPDFGzv/YaUkBKdWBjsNgjh
	qSuPUdY4lNx6qjADtQ6UQmXrKLLxii8=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929618; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sAvpVG8P2b4EE+5j8jySKGjcMWTuEFrQjkKGnJ4bzxI=;
	b=RqES1h53EHkCsWTYHCwmum5ptaOsxLGJ36MaMuX9UmCMk497hn+OB38j4T9QAHA7A42zRk
	YM5QBdkQau/9Pewp0fy9vDg1hfekAFcCbIcTwUcHs2VJ7NOIPDFGzv/YaUkBKdWBjsNgjh
	qSuPUdY4lNx6qjADtQ6UQmXrKLLxii8=
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v1 13/19] selftests/livepatch: Add more tests for state callbacks with blocked transitions
Date: Wed, 15 Jan 2025 09:24:25 +0100
Message-ID: <20250115082431.5550-14-pmladek@suse.com>
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

This commit adds two new self tests to the livepatch state callback
testing, specifically focusing on scenarios with blocked transitions.
Previously, only the transition reversion scenario was tested.

New Test Scenarios:

  + Transition Unblocking: Verifies the behavior when a blocked transition
    is unblocked.

  + Disable Operation Blocking: Tests the scenario where a function blocks
    the disable operation.

Implementation Details:

  + To ensure the blocking function remains fully functional within the
    livepatch, its pointer is bundled with the associated struct work.

  + The 'block_doors' parameter now controls both enabling and disabling
    the blocking function. This necessitates a specific initialization of
    the work struct to guarantee it's flushed in the module's .exit()
    callbacks. Note that if 'block_doors' is defined on the command line,
    its .set() callback is called before the module's .init() callback.

  + The livepatched speaker_welcome() function is also called from
    the blocking function, enabling verification of separate process
    transitions.

  + A suffix is added to the welcome message when printed via the blocked
    process (controlled by 'block_doors') for better process
    differentiation.

Important Note on Sibling Call Optimization:

Sibling call optimization must be disabled for functions designed to block
transitions. Otherwise, they won't appear on the stack, leading to test
failure. These functions can be livepatched because they are called with
the call instruction. But when an optimized version just jumps to a nested
then the jump instruction obviously doesn't store any return address
on the stack.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 .../testing/selftests/livepatch/functions.sh  |  28 +++-
 .../livepatch/test-state-callbacks.sh         | 143 +++++++++++++++++-
 .../livepatch/test_modules/test_klp_speaker.c | 125 ++++++++++++---
 .../livepatch/test_modules/test_klp_speaker.h |  15 ++
 .../test_modules/test_klp_speaker_livepatch.c |  35 +++--
 5 files changed, 310 insertions(+), 36 deletions(-)
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_speaker.h

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index bc1e100e47a7..e10a55427b71 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -250,13 +250,22 @@ function unload_lp() {
 	unload_mod "$1"
 }
 
-# disable_lp(modname) - disable a livepatch
-#	modname - module name to unload
-function disable_lp() {
+# disable_lp_nowait(modname) - disable a livepatch but do not wait
+#			       until the transition finishes
+#	modname - module name of the livepatch to disable
+function disable_lp_nowait() {
 	local mod="$1"
 
 	log "% echo 0 > $SYSFS_KLP_DIR/$mod/enabled"
 	echo 0 > "$SYSFS_KLP_DIR/$mod/enabled"
+}
+
+# disable_lp(modname) - disable a livepatch
+#	modname - module name of the livepatch to disable
+function disable_lp() {
+	local mod="$1"; shift
+
+	disable_lp_nowait "$mod" "$@"
 
 	# Wait until the transition finishes and the livepatch gets
 	# removed from sysfs...
@@ -279,6 +288,19 @@ function set_pre_patch_ret {
 		die "failed to set pre_patch_ret parameter for $mod module"
 }
 
+# write_module_param(modname, param, val)
+#	modname - module name which provides the given parameter
+#	param - parameter name to be written
+#	val = value to be written
+function write_module_param {
+	local mod="$1"; shift
+	local param="$1"; shift
+	local val="$1"
+
+	log "% echo $val > $SYSFS_MODULE_DIR/$mod/parameters/$param"
+	echo "$val" > $SYSFS_MODULE_DIR/"$mod"/parameters/"$param"
+}
+
 # read_module_param(modname, param)
 #	modname - module name which provides the given parameter
 #	param - parameter name to be read
diff --git a/tools/testing/selftests/livepatch/test-state-callbacks.sh b/tools/testing/selftests/livepatch/test-state-callbacks.sh
index 043e2062d71c..7d8c872eccfe 100755
--- a/tools/testing/selftests/livepatch/test-state-callbacks.sh
+++ b/tools/testing/selftests/livepatch/test-state-callbacks.sh
@@ -121,9 +121,9 @@ unload_lp $MOD_LIVEPATCH
 unload_mod $MOD_TARGET
 
 check_result "% insmod test_modules/$MOD_TARGET.ko block_doors=1
-$MOD_TARGET: ${MOD_TARGET}_init
 $MOD_TARGET: block_doors_func: Going to block doors.
 $MOD_TARGET: do_block_doors: Started blocking doors.
+$MOD_TARGET: ${MOD_TARGET}_init
 % cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
 $MOD_TARGET: speaker_welcome: Hello, World!
 % insmod test_modules/$MOD_LIVEPATCH.ko applause=1
@@ -146,4 +146,145 @@ $MOD_TARGET: speaker_welcome: Hello, World!
 % rmmod $MOD_TARGET
 $MOD_TARGET: ${MOD_TARGET}_exit"
 
+# Test state callbacks handling with blocked and later unblocked
+# transiton.
+#
+# Load the test module with the blocked operation. Then load the livepatch
+# and the transition should get stuck. Then unblock the operation
+# so that the transition could finish. Finally, disable the livepatch
+# and unload the modules as usual.
+#
+# Note that every process is transitioned separately. This is visible
+# on the difference between the welcome message printed when reading
+# the "welcome" parameter and the same message printed by the unblocked
+# do_block_doors() function.
+
+start_test "(un)blocked transition"
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
+# Unblock the doors (livepatch transtition)
+write_module_param "$MOD_TARGET" block_doors 0
+# Wait until the livepatch reports that the transition has finished
+loop_until 'grep -q '^0$' $SYSFS_KLP_DIR/$MOD_LIVEPATCH/transition' ||
+	die "failed to finish transition"
+read_module_param $MOD_TARGET welcome
+
+disable_lp $MOD_LIVEPATCH
+read_module_param $MOD_TARGET welcome
+
+unload_lp $MOD_LIVEPATCH
+unload_mod $MOD_TARGET
+
+check_result "% insmod test_modules/$MOD_TARGET.ko block_doors=1
+$MOD_TARGET: block_doors_func: Going to block doors.
+$MOD_TARGET: do_block_doors: Started blocking doors.
+$MOD_TARGET: ${MOD_TARGET}_init
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% insmod test_modules/$MOD_LIVEPATCH.ko applause=1
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+$MOD_LIVEPATCH: applause_pre_patch_callback: state 10
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_LIVEPATCH: lp_speaker_welcome: [] Ladies and gentleman, ...
+% echo 0 > $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/block_doors
+$MOD_TARGET: do_block_doors: Stopped blocking doors.
+$MOD_TARGET: speaker_welcome: Hello, World! <--- from blocked doors
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+$MOD_LIVEPATCH: applause_post_patch_callback: state 10
+livepatch: '$MOD_LIVEPATCH': patching complete
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_LIVEPATCH: lp_speaker_welcome: [APPLAUSE] Ladies and gentleman, ...
+% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+$MOD_LIVEPATCH: applause_pre_unpatch_callback: state 10
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
+# Test state callbacks handling with blocked disable transition.
+#
+# Load the livepatch first. Then load the test module with the blocking
+# operation and disable the livepatch. The transition should get stuck.
+# Finally, get rid of the blocked function so that the transition could
+# finish and the livepatch could get unloaded.
+#
+# Note that every process is transitioned separately. This is visible
+# on the difference between the welcome message printed when reading
+# the "welcome" parameter and the same message printed by the unblocked
+# do_block_doors() function.
+start_test "blocked disable transition"
+
+load_lp $MOD_LIVEPATCH applause=1
+load_mod $MOD_TARGET block_doors=1
+read_module_param $MOD_TARGET welcome
+
+disable_lp_nowait $MOD_LIVEPATCH
+# Wait until the livepatch reports in-transition state, i.e. that it's
+# stalled because of the process with the waiting speaker
+loop_until 'grep -q '^1$' $SYSFS_KLP_DIR/$MOD_LIVEPATCH/transition' ||
+	die "failed to stall transition"
+read_module_param $MOD_TARGET welcome
+
+# Unblock the doors (livepatch transtition)
+write_module_param "$MOD_TARGET" block_doors 0
+# Wait until the livepatch reports that the transition has finished
+loop_until 'test ! -f $SYSFS_KLP_DIR/$MOD_LIVEPATCH/transition' ||
+	die "failed to finish transition"
+read_module_param $MOD_TARGET welcome
+
+unload_lp $MOD_LIVEPATCH
+unload_mod $MOD_TARGET
+
+check_result "% insmod test_modules/$MOD_LIVEPATCH.ko applause=1
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+$MOD_LIVEPATCH: applause_pre_patch_callback: state 10
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+$MOD_LIVEPATCH: applause_post_patch_callback: state 10
+livepatch: '$MOD_LIVEPATCH': patching complete
+% insmod test_modules/$MOD_TARGET.ko block_doors=1
+livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET'
+$MOD_LIVEPATCH: lp_block_doors_func: Going to block doors (fixed).
+$MOD_TARGET: do_block_doors: Started blocking doors.
+$MOD_TARGET: ${MOD_TARGET}_init
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_LIVEPATCH: lp_speaker_welcome: [APPLAUSE] Ladies and gentleman, ...
+% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+$MOD_LIVEPATCH: applause_pre_unpatch_callback: state 10
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% echo 0 > $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/block_doors
+$MOD_TARGET: do_block_doors: Stopped blocking doors.
+$MOD_LIVEPATCH: lp_speaker_welcome: [] Ladies and gentleman, ... <--- from blocked doors
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
index 6dcf15b4154b..b1eebceb5964 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker.c
@@ -9,6 +9,9 @@
 #include <linux/sysfs.h>
 #include <linux/completion.h>
 
+#include "test_klp_speaker.h"
+
+
 #ifndef SPEAKER_ID
 #define SPEAKER_ID ""
 #endif
@@ -27,18 +30,19 @@
  *
  *    - Add "block_doors" parameter which could block the livepatch transition.
  *	The stalled function is offloaded to a workqueue so that it does not
- *	block the module load.
+ *	block the module load. The transition can be unblocked by setting
+ *	the parameter value back to "0" via the sysfs interface.
  */
 
 noinline
-static void speaker_welcome(void)
+static void speaker_welcome(const char *context)
 {
-	pr_info("%s%s: Hello, World!\n", __func__, SPEAKER_ID);
+	pr_info("%s%s: Hello, World!%s\n", __func__, SPEAKER_ID, context);
 }
 
 static int welcome_get(char *buffer, const struct kernel_param *kp)
 {
-	speaker_welcome();
+	speaker_welcome("");
 
 	return 0;
 }
@@ -51,7 +55,6 @@ module_param_cb(welcome, &welcome_ops, NULL, 0400);
 MODULE_PARM_DESC(welcome, "Print speaker's welcome message into the kernel log when reading the value.");
 
 static DECLARE_COMPLETION(started_blocking_doors);
-struct work_struct block_doors_work;
 static bool block_doors;
 static bool show_over;
 
@@ -61,12 +64,28 @@ static void do_block_doors(void)
 	pr_info("%s: Started blocking doors.\n", __func__);
 	complete(&started_blocking_doors);
 
-	while (!READ_ONCE(show_over)) {
-		/* Busy-wait until the module gets unloaded. */
+	while (READ_ONCE(block_doors) && !READ_ONCE(show_over)) {
+		/*
+		 * Busy-wait until the parameter "block_doors" is cleared or
+		 * until the module gets unloaded.
+		 */
 		msleep(20);
 	}
+
+	if (!block_doors) {
+		pr_info("%s: Stopped blocking doors.\n", __func__);
+		/*
+		 * Show how the livepatched message looks in the process which
+		 * blocked the transition.
+		 */
+		speaker_welcome(" <--- from blocked doors");
+	}
 }
 
+static struct hall hall = {
+	.do_block_doors = do_block_doors,
+};
+
 /*
  * Prevent tail call optimizations to make sure that this function
  * appears in the backtrace and blocks the transition.
@@ -74,34 +93,97 @@ static void do_block_doors(void)
 __attribute__((__optimize__("no-optimize-sibling-calls")))
 static void block_doors_func(struct work_struct *work)
 {
+	struct hall *hall = container_of(work, struct hall, block_doors_work);
+
 	pr_info("%s: Going to block doors%s.\n", __func__, SPEAKER_ID);
-	do_block_doors();
+	hall->do_block_doors();
 }
 
-static void block_doors_set(void)
+/*
+ * The work must be initialized when "bool" parameter is proceed
+ * during the module load. Which is done before calling the module init
+ * callback.
+ *
+ * Also it must be initialized even when the parameter was not used because
+ * the work must be flushed in the module exit callback.
+ */
+static void block_doors_work_init(struct hall *hall)
 {
-	init_completion(&started_blocking_doors);
-	INIT_WORK(&block_doors_work, block_doors_func);
+	static bool block_doors_work_initialized;
 
-	schedule_work(&block_doors_work);
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
 
 	/*
-	 * To synchronize kernel messages, hold this callback from
-	 * exiting until the work function's entry message has got printed.
+	 * Update the global value before scheduling the work so that it
+	 * stays blocked.
 	 */
-	wait_for_completion(&started_blocking_doors);
+	block_doors = block;
+	if (block) {
+		init_completion(&started_blocking_doors);
+		block_doors_work_init(&hall);
 
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
 }
 
-module_param(block_doors, bool, 0400);
+static const struct kernel_param_ops block_doors_ops = {
+	.set	= block_doors_set,
+	.get	= block_doors_get,
+};
+
+module_param_cb(block_doors, &block_doors_ops, NULL, 0600);
 MODULE_PARM_DESC(block_doors, "Block doors so that the audience could not enter. It blocks the livepatch transition. (default=false)");
 
 static int test_klp_speaker_init(void)
 {
 	pr_info("%s\n", __func__);
 
-	if (block_doors)
-		block_doors_set();
+	block_doors_work_init(&hall);
 
 	return 0;
 }
@@ -110,10 +192,9 @@ static void test_klp_speaker_exit(void)
 {
 	pr_info("%s\n", __func__);
 
-	if (block_doors) {
-		WRITE_ONCE(show_over, true);
-		flush_work(&block_doors_work);
-	}
+	/* Make sure that do_block_doors() is not running. */
+	WRITE_ONCE(show_over, true);
+	flush_work(&hall.block_doors_work);
 }
 
 module_init(test_klp_speaker_init);
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker.h b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker.h
new file mode 100644
index 000000000000..89309a3acfde
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _TEST_KLP_SPEAKER_H_
+#define _TEST_KLP_SPEAKER_H_
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
+#endif //  _TEST_KLP_SPEAKER_H_
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
index 76402947c789..6b82c5636845 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
@@ -8,6 +8,8 @@
 #include <linux/livepatch.h>
 #include <linux/init.h>
 
+#include "test_klp_speaker.h"
+
 /**
  * test_klp_speaker_livepatch - test livepatch for testing various livepatching
  *	features.
@@ -37,7 +39,9 @@ static int pre_patch_ret;
 module_param(pre_patch_ret, int, 0400);
 MODULE_PARM_DESC(pre_patch_ret, "Allow to force failure for the pre_patch callback (default=0)");
 
-static void __lp_speaker_welcome(const char *caller_func, const char *speaker_id)
+static void __lp_speaker_welcome(const char *caller_func,
+				 const char *speaker_id,
+				 const char *context)
 {
 	char entire_applause[APPLAUSE_STR_SIZE + 1] = "";
 	const char *applause;
@@ -46,18 +50,18 @@ static void __lp_speaker_welcome(const char *caller_func, const char *speaker_id
 	if (applause)
 		snprintf(entire_applause, sizeof(entire_applause), "%s ", applause);
 
-	pr_info("%s%s: %sLadies and gentleman, ...\n", caller_func, speaker_id,
-		entire_applause);
+	pr_info("%s%s: %sLadies and gentleman, ...%s\n",
+		caller_func, speaker_id, entire_applause, context);
 }
 
-static void lp_speaker_welcome(void)
+static void lp_speaker_welcome(const char *context)
 {
-	__lp_speaker_welcome(__func__, "");
+	__lp_speaker_welcome(__func__, "", context);
 }
 
-static void lp_speaker2_welcome(void)
+static void lp_speaker2_welcome(const char *context)
 {
-	__lp_speaker_welcome(__func__, "(2)");
+	__lp_speaker_welcome(__func__, "(2)", context);
 }
 
 static int allocate_applause(unsigned long id)
@@ -185,16 +189,27 @@ static void applause_shadow_dtor(void *obj, void *shadow_data)
 static void __lp_block_doors_func(struct work_struct *work, const char *caller_func,
 		       const char *speaker_id)
 {
-	/* Just print the message. Never really used. */
-	pr_info("%s: Going to block doors%s (this should never happen).\n",
-		caller_func, speaker_id);
+	struct hall *hall = container_of(work, struct hall, block_doors_work);
+
+	pr_info("%s: Going to block doors%s (fixed).\n", caller_func, speaker_id);
+	hall->do_block_doors();
 }
 
+/*
+ * Prevent tail call optimizations to make sure that this function
+ * appears in the backtrace and can block the disable transition.
+ */
+__attribute__((__optimize__("no-optimize-sibling-calls")))
 static void lp_block_doors_func(struct work_struct *work)
 {
 	__lp_block_doors_func(work, __func__, "");
 }
 
+/*
+ * Prevent tail call optimizations to make sure that this function
+ * appears in the backtrace and can block the disable transition.
+ */
+__attribute__((__optimize__("no-optimize-sibling-calls")))
 static void lp_block_doors_func2(struct work_struct *work)
 {
 	__lp_block_doors_func(work, __func__, "(2)");
-- 
2.47.1


