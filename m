Return-Path: <live-patching+bounces-979-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F31D4A11BCE
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 09:25:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92EEF3A8ADB
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 08:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0F002451C1;
	Wed, 15 Jan 2025 08:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="O79/huLa";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="O79/huLa"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9678728EC74;
	Wed, 15 Jan 2025 08:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929527; cv=none; b=VwBhi6tA8EHXwqHmJ2wonNBZCFSSg6VQa4YSxH8dKn/may8Y//vkJLbEyNBcupf0rLLEcKHMWT6xZAzblb+IItPO3ArB1De1EQP4/0+RF1oO0xy4kw7vht39kf3H8Td7BH6XYhwT39Ii/QwPdKC5XISszksR99Dh/euP21+pbZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929527; c=relaxed/simple;
	bh=1HGuldc+pCW/eL6dRJsdJOXJWJZNn7nZgbUYrVGF2Mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JaiOQSKOK7jhKS1mpbZmUCmv0xOo4LmpzvK9aR1T3MPHy3kMyRYhmXlvG3f1kF3+TaywE68agTvMmfv7E1g0fTPH058frGZ6oF+yIkjuPuCxQjXehxfUXen5aArBzer8ULDKptOKxWVDuzC1T1JEheyHemGmPCqZQg31JiDWB7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=O79/huLa; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=O79/huLa; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from pathway.suse.cz (unknown [10.100.201.202])
	by smtp-out2.suse.de (Postfix) with ESMTP id 95C4A1F37C;
	Wed, 15 Jan 2025 08:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929523; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zMrg5sxdQn73Xwu6biv4RUUUbw+oEczuALNIQtPy9BM=;
	b=O79/huLayu4JjIgw4KHr6leCcN7h2mLQ8NFfPtyuEfwtDps2QL5hKK+rHeaB2T4G/uRzk9
	kIGzqEraoZ0QhqKQkR3EXFphCPd6q/p7Q5H1LciSXr2OvZKm0qopuGReoSaCK4bSmbu4dP
	882a/GG2O1hNmtMO1Rsyi52YOlE/2co=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929523; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zMrg5sxdQn73Xwu6biv4RUUUbw+oEczuALNIQtPy9BM=;
	b=O79/huLayu4JjIgw4KHr6leCcN7h2mLQ8NFfPtyuEfwtDps2QL5hKK+rHeaB2T4G/uRzk9
	kIGzqEraoZ0QhqKQkR3EXFphCPd6q/p7Q5H1LciSXr2OvZKm0qopuGReoSaCK4bSmbu4dP
	882a/GG2O1hNmtMO1Rsyi52YOlE/2co=
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v1 04/19] livepatch: Add "block_disable" flag to per-state API and remove versioning
Date: Wed, 15 Jan 2025 09:24:16 +0100
Message-ID: <20250115082431.5550-5-pmladek@suse.com>
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
	RCPT_COUNT_SEVEN(0.00)[7];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

This commit enhances the livepatch state API with a new flag,
"block_disable", and removes the previously introduced per-state
versioning mechanism.

The "block_disable" flag addresses scenarios where reverting certain system
changes introduced by a livepatch is undesirable due to complexity, risk,
or other factors. When set, this flag prevents:

  - Disabling the livepatch entirely.

  - Replacing the livepatch with an older version that doesn't support the
    blocked state.

This ensures that critical system modifications remain in effect, even when
updating or reverting livepatches.

The per-state versioning mechanism, intended to facilitate modifications
to existing states, has proven unnecessary in practice and is therefore
removed. Alternative approaches, such as introducing new states, can
achieve the same results if needed.

These changes introduce a new approach to compatibility between
livepatches. It is no longer defined by versioning, which lacked specific
semantics. Instead, compatibility is determined by whether a livepatch can
disable the system state changes caused by the use of callbacks and shadow
variables.

Consequently, compatibility is now only checked for livepatches using
atomic replacement. This is because only these livepatches can disable
an existing state when enabled.

The related self-test has been updated to reflect these changes. It
utilizes three livepatches built from the same source, with new
command-line options to specify whether a livepatch supports and
can disable a given state change.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/livepatch.h                     |  4 +-
 kernel/livepatch/core.c                       |  7 ++++
 kernel/livepatch/state.c                      | 35 ++++++++++++----
 kernel/livepatch/state.h                      |  1 +
 .../testing/selftests/livepatch/test-state.sh | 40 ++++++++++++-------
 .../livepatch/test_modules/test_klp_state.c   | 27 +++++++------
 .../livepatch/test_modules/test_klp_state2.c  |  2 -
 .../livepatch/test_modules/test_klp_state3.c  |  2 +-
 8 files changed, 78 insertions(+), 40 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index c624f1105663..56e71d488e71 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -171,16 +171,16 @@ struct klp_state_callbacks {
 /**
  * struct klp_state - state of the system modified by the livepatch
  * @id:		system state identifier (non-zero)
- * @version:	version of the change
  * @callbacks:	optional callbacks used when enabling or disabling the state
+ * @block_disable: the state disablement is not supported
  * @is_shadow:	the state handles lifetime of a shadow variable with
  *		the same @id
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
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 527fdb0a6b0a..4d244eef0e53 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -374,6 +374,13 @@ static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
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
diff --git a/kernel/livepatch/state.c b/kernel/livepatch/state.c
index 16ad695b1e88..a9af511e5d9e 100644
--- a/kernel/livepatch/state.c
+++ b/kernel/livepatch/state.c
@@ -83,7 +83,12 @@ struct klp_state *klp_get_prev_state(unsigned long id)
 }
 EXPORT_SYMBOL_GPL(klp_get_prev_state);
 
-/* Check if the patch is able to deal with the existing system state. */
+/*
+ * Check if the new patch is able to deal with the existing system state.
+ * Used only for livepatches with the atomic replace enabled. The patch either
+ * has to support the existing state or the existing patch must be able
+ * to disable it.
+ */
 static bool klp_is_state_compatible(struct klp_patch *patch,
 				    struct klp_state *old_state)
 {
@@ -91,23 +96,25 @@ static bool klp_is_state_compatible(struct klp_patch *patch,
 
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
- * Check that the new livepatch will not break the existing system states.
- * Cumulative patches must handle all already modified states.
- * Non-cumulative patches can touch already modified states.
+ * Check if the new livepatch could atomically replace existing ones.
+ * It must either support the existing states. Or the existing livepatches
+ * must be able to disable the obsolete states.
  */
 bool klp_is_patch_compatible(struct klp_patch *patch)
 {
 	struct klp_patch *old_patch;
 	struct klp_state *old_state;
 
+	if (!patch->replace)
+		return true;
+
 	klp_for_each_patch(old_patch) {
 		klp_for_each_state(old_patch, old_state) {
 			if (!klp_is_state_compatible(patch, old_state))
@@ -118,6 +125,18 @@ bool klp_is_patch_compatible(struct klp_patch *patch)
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
 static bool is_state_in_other_patches(struct klp_patch *patch,
 				      struct klp_state *state)
 {
diff --git a/kernel/livepatch/state.h b/kernel/livepatch/state.h
index 65c0c2cde04c..0620fd692820 100644
--- a/kernel/livepatch/state.h
+++ b/kernel/livepatch/state.h
@@ -5,6 +5,7 @@
 #include <linux/livepatch.h>
 
 bool klp_is_patch_compatible(struct klp_patch *patch);
+bool klp_patch_disable_blocked(struct klp_patch *patch);
 int klp_states_pre_patch(struct klp_patch *patch);
 void klp_states_post_patch(struct klp_patch *patch);
 void klp_states_pre_unpatch(struct klp_patch *patch);
diff --git a/tools/testing/selftests/livepatch/test-state.sh b/tools/testing/selftests/livepatch/test-state.sh
index 2f4a5109fdf5..72e9b4f0b629 100755
--- a/tools/testing/selftests/livepatch/test-state.sh
+++ b/tools/testing/selftests/livepatch/test-state.sh
@@ -132,12 +132,15 @@ livepatch: '$MOD_LIVEPATCH2': unpatching complete
 
 start_test "incompatible cumulative livepatches"
 
-load_lp $MOD_LIVEPATCH2
-load_failing_mod $MOD_LIVEPATCH
-disable_lp $MOD_LIVEPATCH2
+load_lp $MOD_LIVEPATCH2 state_block_disable=1
+load_failing_mod $MOD_LIVEPATCH no_state=1
+# load the livepatch again with default features (state and disable supported)
+load_lp $MOD_LIVEPATCH
 unload_lp $MOD_LIVEPATCH2
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
 
-check_result "% insmod test_modules/$MOD_LIVEPATCH2.ko
+check_result "% insmod test_modules/$MOD_LIVEPATCH2.ko state_block_disable=1
 livepatch: enabling patch '$MOD_LIVEPATCH2'
 livepatch: '$MOD_LIVEPATCH2': initializing patching transition
 $MOD_LIVEPATCH2: pre_patch_callback: state 1
@@ -147,18 +150,25 @@ livepatch: '$MOD_LIVEPATCH2': completing patching transition
 $MOD_LIVEPATCH2: post_patch_callback: state 1
 $MOD_LIVEPATCH2: fix_console_loglevel: fixing console_loglevel
 livepatch: '$MOD_LIVEPATCH2': patching complete
-% insmod test_modules/$MOD_LIVEPATCH.ko
+% insmod test_modules/$MOD_LIVEPATCH.ko no_state=1
 livepatch: Livepatch patch ($MOD_LIVEPATCH) is not compatible with the already installed livepatches.
 insmod: ERROR: could not insert module test_modules/$MOD_LIVEPATCH.ko: Invalid parameters
-% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH2/enabled
-livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
-$MOD_LIVEPATCH2: pre_unpatch_callback: state 1
-$MOD_LIVEPATCH2: restore_console_loglevel: restoring console_loglevel
-livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
-$MOD_LIVEPATCH2: post_unpatch_callback: state 1 (nope)
-$MOD_LIVEPATCH2: shadow_conosle_loglevel_dtor: freeing space for the stored console_loglevel
-livepatch: '$MOD_LIVEPATCH2': unpatching complete
-% rmmod $MOD_LIVEPATCH2"
+% insmod test_modules/$MOD_LIVEPATCH.ko
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% rmmod $MOD_LIVEPATCH2
+% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+$MOD_LIVEPATCH: pre_unpatch_callback: state 1
+$MOD_LIVEPATCH: restore_console_loglevel: restoring console_loglevel
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+$MOD_LIVEPATCH: post_unpatch_callback: state 1 (nope)
+$MOD_LIVEPATCH: shadow_conosle_loglevel_dtor: freeing space for the stored console_loglevel
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH"
 
 exit 0
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_state.c b/tools/testing/selftests/livepatch/test_modules/test_klp_state.c
index 7f601898ef7c..518229815449 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_state.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_state.c
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
@@ -132,7 +121,6 @@ static struct klp_object objs[] = {
 static struct klp_state states[] = {
 	{
 		.id = CONSOLE_LOGLEVEL_FIX_ID,
-		.version = CONSOLE_LOGLEVEL_FIX_VERSION,
 		.is_shadow = true,
 		.callbacks = {
 			.pre_patch = pre_patch_callback,
@@ -151,8 +139,23 @@ static struct klp_patch patch = {
 	.replace = true,
 };
 
+static bool state_block_disable;
+
+module_param(state_block_disable, bool, 0600);
+MODULE_PARM_DESC(state_block_disable, "Set to 1 to pretend that the livepatch is not capable of disabling the state (default = 0).");
+
+static bool no_state;
+
+module_param(no_state, bool, 0600);
+MODULE_PARM_DESC(no_state, "Set to 1 when the livepatch should not support the state (default = 0).");
+
 static int test_klp_callbacks_demo_init(void)
 {
+	states[0].block_disable = state_block_disable;
+
+	if (no_state)
+		patch.states = NULL;
+
 	return klp_enable_patch(&patch);
 }
 
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_state2.c b/tools/testing/selftests/livepatch/test_modules/test_klp_state2.c
index 128855764bf8..b8fe1ca2d802 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_state2.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_state2.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (C) 2019 SUSE
 
-#define CONSOLE_LOGLEVEL_FIX_VERSION 2
-
 /* The console loglevel fix is the same in the next cumulative patch. */
 #include "test_klp_state.c"
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_state3.c b/tools/testing/selftests/livepatch/test_modules/test_klp_state3.c
index 9226579d10c5..b8fe1ca2d802 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_state3.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_state3.c
@@ -2,4 +2,4 @@
 // Copyright (C) 2019 SUSE
 
 /* The console loglevel fix is the same in the next cumulative patch. */
-#include "test_klp_state2.c"
+#include "test_klp_state.c"
-- 
2.47.1


