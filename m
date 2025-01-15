Return-Path: <live-patching+bounces-983-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B38ADA11BDD
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 09:27:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C4903A64AF
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 08:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B087B2063C3;
	Wed, 15 Jan 2025 08:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="uowOYmLi";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="uowOYmLi"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0484E1E7C39;
	Wed, 15 Jan 2025 08:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929570; cv=none; b=mgvPSovbabqxOvDJnFslquuEPjzzAhKfrNdTDq1W4HfW8elCu2LYb8lWNwT7LAybLqoGyigsWbNEmY7oph/68HZtzHV0MjrWyXDf5PzgCf5ta4+LwOpWQoeJprXXEAqoQmPdSxAyztmViRpu0sNJ66jT6Dv692frbF5pLMzn4wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929570; c=relaxed/simple;
	bh=2hjfF4ZlMCaHDECZuvvP5iA4W5UvoVBGOLluMbhrEtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YG3xHQHuSqkeM+IJklev7BU8VDMVXu8to7e2ImZJ4rWRdX74wqu5HXqHpyoeKdMs3r4fSqgR0CJW8CAl9U2XXXOoO13gpx+JjierzHNHaWrN4pSijtg07CRwaJo+Z0TgKL8D+Jeqbk4oa2eCHCFUCvsg7eLxk4CNlfGNqanuaPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=uowOYmLi; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=uowOYmLi; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from pathway.suse.cz (unknown [10.100.201.202])
	by smtp-out2.suse.de (Postfix) with ESMTP id 27FFB1F44E;
	Wed, 15 Jan 2025 08:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5gn6HjAcu1K9VBprx1QIrdqZVEUn+IY95Z03PvVK05E=;
	b=uowOYmLiuIQ51dYTnx/YxsaIAD+dLdcdt9o4aSu3zSg2gizlwi0/4gTaN4HIJ0+hKBYmb0
	lM0fIAp/tgHD/7pXFL31blwQaNck8KX1AyXQo313CFgBSx5IQQF9avIHJzltaZsmu3qfHL
	Yc65za3+94/XQaWrG+de8NdorwiFzN4=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5gn6HjAcu1K9VBprx1QIrdqZVEUn+IY95Z03PvVK05E=;
	b=uowOYmLiuIQ51dYTnx/YxsaIAD+dLdcdt9o4aSu3zSg2gizlwi0/4gTaN4HIJ0+hKBYmb0
	lM0fIAp/tgHD/7pXFL31blwQaNck8KX1AyXQo313CFgBSx5IQQF9avIHJzltaZsmu3qfHL
	Yc65za3+94/XQaWrG+de8NdorwiFzN4=
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v1 08/19] selftests/livepatch: Move basic tests for livepatching modules
Date: Wed, 15 Jan 2025 09:24:20 +0100
Message-ID: <20250115082431.5550-9-pmladek@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[pathway.suse.cz:helo,suse.com:mid,suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

The per-object callbacks have been replaced by per-state callbacks and
will be removed soon.

There are self-tests that attempt to load a live patch with per-object
callbacks and the live-patched module (object) in all possible order
variations.

These order variations are less relevant with per-state callbacks because
they are only invoked when the live patch is enabled or disabled.

However, it is still important to check all possible order variations
to ensure the module is live-patched correctly. The expected state is
validated using two approaches.

First, the "patched" sysfs attribute is checked the same way is in
the sysfs tests.

Second, a new "welcome" parameter has been added to the speaker test
module. By reading this parameter's state, the live-patched function can
be invoked.

Instead of displaying the parameter value via the sysfs interface, the
.read() callback writes a welcome message to the kernel log. This message
is compared with the expected value at the end of the test. This approach
ensures that the self-test attempts to unload the test modules even if
something goes wrong.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 tools/testing/selftests/livepatch/Makefile    |   1 +
 .../testing/selftests/livepatch/functions.sh  |  29 +++
 .../selftests/livepatch/test-callbacks.sh     | 226 ------------------
 .../testing/selftests/livepatch/test-order.sh | 226 ++++++++++++++++++
 .../livepatch/test_modules/test_klp_speaker.c |  19 +-
 5 files changed, 274 insertions(+), 227 deletions(-)
 create mode 100755 tools/testing/selftests/livepatch/test-order.sh

diff --git a/tools/testing/selftests/livepatch/Makefile b/tools/testing/selftests/livepatch/Makefile
index a080eb54a215..971d0c6f8059 100644
--- a/tools/testing/selftests/livepatch/Makefile
+++ b/tools/testing/selftests/livepatch/Makefile
@@ -5,6 +5,7 @@ TEST_GEN_MODS_DIR := test_modules
 TEST_PROGS_EXTENDED := functions.sh
 TEST_PROGS := \
 	test-livepatch.sh \
+	test-order.sh \
 	test-callbacks.sh \
 	test-shadow-vars.sh \
 	test-state.sh \
diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 3f86b89e6ea7..bc1e100e47a7 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -279,6 +279,23 @@ function set_pre_patch_ret {
 		die "failed to set pre_patch_ret parameter for $mod module"
 }
 
+# read_module_param(modname, param)
+#	modname - module name which provides the given parameter
+#	param - parameter name to be read
+function read_module_param {
+	local mod="$1"; shift
+	local param="$1"
+
+	log "% cat $SYSFS_MODULE_DIR/$mod/parameters/$param"
+	val=$(cat $SYSFS_MODULE_DIR/$mod/parameters/$param 2>&1)
+	# Log only non-empty values. Some test modules write a message
+	# to the log on its own when reading the parameter, for example,
+	# the "welcome" parameter of the "test_klp_speaker" module.
+	if [[ "$val" != "" ]]; then
+		log "$mod:$param: $ret"
+	fi
+}
+
 function start_test {
 	local test="$1"
 
@@ -353,3 +370,15 @@ function check_sysfs_value() {
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
index a65fd860662e..614ed0aa2e40 100755
--- a/tools/testing/selftests/livepatch/test-callbacks.sh
+++ b/tools/testing/selftests/livepatch/test-callbacks.sh
@@ -11,232 +11,6 @@ MOD_TARGET_BUSY=test_klp_callbacks_busy
 
 setup_config
 
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
-check_result "% insmod test_modules/$MOD_TARGET.ko
-$MOD_TARGET: ${MOD_TARGET}_init
-% insmod test_modules/$MOD_LIVEPATCH.ko
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-$MOD_LIVEPATCH: pre_patch_callback: vmlinux
-$MOD_LIVEPATCH: pre_patch_callback: $MOD_TARGET -> [MODULE_STATE_LIVE] Normal state
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-$MOD_LIVEPATCH: post_patch_callback: vmlinux
-$MOD_LIVEPATCH: post_patch_callback: $MOD_TARGET -> [MODULE_STATE_LIVE] Normal state
-livepatch: '$MOD_LIVEPATCH': patching complete
-% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
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
-check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-$MOD_LIVEPATCH: pre_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-$MOD_LIVEPATCH: post_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': patching complete
-% insmod test_modules/$MOD_TARGET.ko
-livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET'
-$MOD_LIVEPATCH: pre_patch_callback: $MOD_TARGET -> [MODULE_STATE_COMING] Full formed, running module_init
-$MOD_LIVEPATCH: post_patch_callback: $MOD_TARGET -> [MODULE_STATE_COMING] Full formed, running module_init
-$MOD_TARGET: ${MOD_TARGET}_init
-% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
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
-check_result "% insmod test_modules/$MOD_TARGET.ko
-$MOD_TARGET: ${MOD_TARGET}_init
-% insmod test_modules/$MOD_LIVEPATCH.ko
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
-% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
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
-check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-$MOD_LIVEPATCH: pre_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-$MOD_LIVEPATCH: post_patch_callback: vmlinux
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
-check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-$MOD_LIVEPATCH: pre_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': starting patching transition
-livepatch: '$MOD_LIVEPATCH': completing patching transition
-$MOD_LIVEPATCH: post_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': patching complete
-% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
-livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-$MOD_LIVEPATCH: pre_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-$MOD_LIVEPATCH: post_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH"
-
-
 # Test a scenario where a vmlinux pre-patch callback returns a non-zero
 # status (ie, failure).
 #
diff --git a/tools/testing/selftests/livepatch/test-order.sh b/tools/testing/selftests/livepatch/test-order.sh
new file mode 100755
index 000000000000..869b06605597
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test-order.sh
@@ -0,0 +1,226 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2018 Joe Lawrence <joe.lawrence@redhat.com>
+# Copyright (C) 2024 SUSE
+
+. $(dirname $0)/functions.sh
+
+MOD_LIVEPATCH=test_klp_speaker_livepatch
+MOD_TARGET=test_klp_speaker
+
+setup_config
+
+# Test basic livepatch enable/disable functionality when livepatching
+# modules.
+#
+# Loading the livepatch module without the target module being loaded.
+#
+# The transition should succeed. It is basically just a reference for
+# for the following tests.
+
+start_test "module not present"
+
+load_lp $MOD_LIVEPATCH
+check_object_patched $MOD_LIVEPATCH $MOD_TARGET "0"
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
+
+check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH"
+
+# Load the target module before the livepatch module. Unload them
+# in the reverse order.
+#
+# The expected state is double-checked by reading "welcome" parameter
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
+check_object_patched $MOD_LIVEPATCH $MOD_TARGET "1"
+
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
+read_module_param $MOD_TARGET welcome
+
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
+% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% rmmod $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_exit"
+
+# Test the module coming hook in the module loader.
+#
+# Load the livepatch before the target module. Unload them in
+# the same order.
+#
+# The livepatch hook in the module loader should print a message
+# about applying the livepatch to the target module.
+#
+# The expected state is double-checked by reading "welcome" parameter
+# of the target module. The livepatched variant should be printed
+# when both the target and livepatch modules are loaded.
+
+start_test "module coming hook"
+
+load_lp $MOD_LIVEPATCH
+check_object_patched $MOD_LIVEPATCH $MOD_TARGET "0"
+
+load_mod $MOD_TARGET
+read_module_param $MOD_TARGET welcome
+check_object_patched $MOD_LIVEPATCH $MOD_TARGET "1"
+
+disable_lp $MOD_LIVEPATCH
+read_module_param $MOD_TARGET welcome
+
+unload_lp $MOD_LIVEPATCH
+unload_mod $MOD_TARGET
+
+check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% insmod test_modules/$MOD_TARGET.ko
+livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET'
+$MOD_TARGET: ${MOD_TARGET}_init
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_LIVEPATCH: lp_speaker_welcome: Ladies and gentleman, ...
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
+
+# Test the module going hook in the module loader.
+#
+# The livepatch hook in the module loader should print a message
+# about reverting the livepatch to the target module.
+#
+# The expected state is double-checked by reading "welcome" parameter
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
+% rmmod $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_exit
+livepatch: reverting patch '$MOD_LIVEPATCH' on unloading module '$MOD_TARGET'
+% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
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
+# The expected state is double-checked by reading "welcome" parameter
+# of the target module. The livepatched variant should be printed
+# when both the target and livepatch modules are loaded.
+
+start_test "module coming and going hooks"
+
+load_lp $MOD_LIVEPATCH
+check_object_patched $MOD_LIVEPATCH $MOD_TARGET "0"
+
+load_mod $MOD_TARGET
+read_module_param $MOD_TARGET welcome
+check_object_patched $MOD_LIVEPATCH $MOD_TARGET "1"
+
+unload_mod $MOD_TARGET
+check_object_patched $MOD_LIVEPATCH $MOD_TARGET "0"
+
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
+
+check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% insmod test_modules/$MOD_TARGET.ko
+livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET'
+$MOD_TARGET: ${MOD_TARGET}_init
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_LIVEPATCH: lp_speaker_welcome: Ladies and gentleman, ...
+% rmmod $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_exit
+livepatch: reverting patch '$MOD_LIVEPATCH' on unloading module '$MOD_TARGET'
+% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH"
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker.c b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker.c
index b1fb135820b0..22f6e5fcb009 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker.c
@@ -12,14 +12,31 @@
  * The module provides a virtual speaker who can do:
  *
  *    - Start a show with a greeting, see speaker_welcome().
+ *
+ *    - Log the greeting by reading the "welcome" module parameter, see
+ *	welcome_get().
  */
 
 noinline
-static void __always_used speaker_welcome(void)
+static void speaker_welcome(void)
 {
 	pr_info("%s: Hello, World!\n", __func__);
 }
 
+static int welcome_get(char *buffer, const struct kernel_param *kp)
+{
+	speaker_welcome();
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
 static int test_klp_speaker_init(void)
 {
 	pr_info("%s\n", __func__);
-- 
2.47.1


