Return-Path: <live-patching+bounces-985-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AF60A11BE2
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 09:27:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BC17188AE27
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 08:27:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E63E828EC97;
	Wed, 15 Jan 2025 08:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="p9mRXbJn";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QV3q+il8"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FEF28EC73;
	Wed, 15 Jan 2025 08:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929590; cv=none; b=VTYZiaWueHihioMxE7fw7/Df0SGirfVvw7HiKjLMR9GMxX8154FcPhHxc3Z57PTUWDCa444pi6g7Y9h40AmOkoUpztGNjRe0zVN5wJ4+pmWGwTWdNAg6tJeVLYShrbVcVsJDgmYAkYBbNySuUvcD9zIQyJFZVJnDMs2i7KE0FU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929590; c=relaxed/simple;
	bh=7b28B89R36COwwi44/BDi79HbmJz3oqSYlM02v32eVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEsJbyw4ElL6pJigASb+hYxbZ8rqmlLGfXXoep705ypMtuaqLxUJU7jL9sJG7YiuTw4drO2MyxS3O4sFQ+a5kKHMpteuC6NGs32OCUyCYuvgW8we0shUleMh3Cc2dlLHnr5pOhnL7Lw1uMAp7LaXomXWzB9G8dUx1aZgoizdfxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=p9mRXbJn; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QV3q+il8; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from pathway.suse.cz (unknown [10.100.201.202])
	by smtp-out2.suse.de (Postfix) with ESMTP id D1D1C1F44E;
	Wed, 15 Jan 2025 08:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GjAwr2Ln79XWN9PYgoGLfYjOgXDJ+K4XlFe1vR6AFts=;
	b=p9mRXbJnc5sfftg/7IEDkal54/P3BMcc2r4TclKo2b+aph/y8O4fk+Yn7FInhcc4zdK3mm
	8s/3tlig+1ijOBOrfeLk3ZIia7oIhEGqlcncIKWs9u27rQ3YqliOzZ+o9NmoagEmAgrGDo
	jXeyCeogvWGU9sHchjvpqYXmRCyIRrk=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929586; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GjAwr2Ln79XWN9PYgoGLfYjOgXDJ+K4XlFe1vR6AFts=;
	b=QV3q+il8QYWxuXUKwQWiKcbgLvXRwF2pl9meD7wO135JIn2mUHP7n0rV0ZLlU/q5WgYVyT
	fg+ITcjH4zSdwZQMLt+o+ydxNT3y1D/ykyk4s7yBi/G9eo2HlMKbcYC7PYjjJGLlcGyJ7U
	0GP/Gv2m6xb4RmVrFPH8SwgsLK/+Hng=
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v1 10/19] selftests/livepatch: Create a simple selftest for state callbacks
Date: Wed, 15 Jan 2025 09:24:22 +0100
Message-ID: <20250115082431.5550-11-pmladek@suse.com>
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

The per-object callbacks have been deprecated in favor of per-state
callbacks and will be removed soon. The behavior of these two types
of callbacks is completely different.

Per-object callbacks are triggered when the livepatching of
the related object is enabled or disabled. When using the atomic
replace feature, only the callbacks from the new livepatch are called.

Per-state callbacks, on the other hand, are triggered when the state
is being added or removed. When using the atomic replace feature,
the callbacks that remove the state are called from the old livepatch
that is being replaced.

For testing purposes, the state represents a part of an audience in
the livepatch for the speaker module. The audience applauds when
the speaker delivers the welcome message.

All four callbacks are used as follows:

  + pre_patch() allocates a shadow variable with a string and fills
		it with "[]".
  + post_patch() fills the string with "[APPLAUSE]".
  + pre_unpatch() reverts the string back to "[]".
  + post_unpatch() releases the shadow variable.

The welcome message printed by the livepatched function allows us to
distinguish between the transition and the completed transition.
Specifically, the speaker's welcome message appears as:

  + Not patched system:		 "Hello, World!"
  + Transition (unpatched task): "[] Hello, World!"
  + Transition (patched task):	 "[] Ladies and gentlemen, ..."
  + Patched system:		 "[APPLAUSE] Ladies and gentlemen, ..."

Create an initial self-test that uses a single livepatch and
a single state. This serves as a base for more complex self-tests.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 tools/testing/selftests/livepatch/Makefile    |   1 +
 .../livepatch/test-state-callbacks.sh         |  58 +++++++
 .../test_modules/test_klp_speaker_livepatch.c | 154 +++++++++++++++++-
 3 files changed, 212 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/livepatch/test-state-callbacks.sh

diff --git a/tools/testing/selftests/livepatch/Makefile b/tools/testing/selftests/livepatch/Makefile
index 971d0c6f8059..ae00e98ba79f 100644
--- a/tools/testing/selftests/livepatch/Makefile
+++ b/tools/testing/selftests/livepatch/Makefile
@@ -9,6 +9,7 @@ TEST_PROGS := \
 	test-callbacks.sh \
 	test-shadow-vars.sh \
 	test-state.sh \
+	test-state-callbacks.sh \
 	test-ftrace.sh \
 	test-sysfs.sh \
 	test-syscall.sh \
diff --git a/tools/testing/selftests/livepatch/test-state-callbacks.sh b/tools/testing/selftests/livepatch/test-state-callbacks.sh
new file mode 100755
index 000000000000..1183b9d15782
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test-state-callbacks.sh
@@ -0,0 +1,58 @@
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
+# Use shadow variables, state, and callbacks to add "[APPLAUSE] "
+# into the message printed by "welcome" parameter.
+
+start_test "livepatch state callbacks"
+
+load_mod $MOD_TARGET
+read_module_param $MOD_TARGET welcome
+
+load_lp $MOD_LIVEPATCH applause=1
+read_module_param $MOD_TARGET welcome
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
+% insmod test_modules/$MOD_LIVEPATCH.ko applause=1
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+$MOD_LIVEPATCH: applause_pre_patch_callback: state 10
+livepatch: '$MOD_LIVEPATCH': starting patching transition
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
+% rmmod $MOD_LIVEPATCH
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% rmmod $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_exit"
+
+exit 0
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
index 8d7e74a69a5d..ab409df0b0e3 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
@@ -21,9 +21,27 @@
  *    - Support more speaker modules, see __lp_speaker_welcome().
  */
 
+#define APPLAUSE_ID 10
+#define APPLAUSE_STR_SIZE 16
+
+/* associate the shadow variable with NULL address */;
+static void *shadow_object = NULL;
+
+static bool add_applause;
+module_param_named(applause, add_applause, bool, 0400);
+MODULE_PARM_DESC(applause, "Use shadow variable to add applause (default=false)");
+
 static void __lp_speaker_welcome(const char *caller_func, const char *speaker_id)
 {
-	pr_info("%s%s: Ladies and gentleman, ...\n", caller_func, speaker_id);
+	char entire_applause[APPLAUSE_STR_SIZE + 1] = "";
+	const char *applause;
+
+	applause = (char *)klp_shadow_get(shadow_object, APPLAUSE_ID);
+	if (applause)
+		snprintf(entire_applause, sizeof(entire_applause), "%s ", applause);
+
+	pr_info("%s%s: %sLadies and gentleman, ...\n", caller_func, speaker_id,
+		entire_applause);
 }
 
 static void lp_speaker_welcome(void)
@@ -36,6 +54,122 @@ static void lp_speaker2_welcome(void)
 	__lp_speaker_welcome(__func__, "(2)");
 }
 
+static int allocate_applause(unsigned long id)
+{
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
+	strscpy(applause, "[]", APPLAUSE_STR_SIZE);
+
+	return 0;
+}
+
+static void set_applause(unsigned long id)
+{
+	char *applause;
+
+	applause = (char *)klp_shadow_get(shadow_object, id);
+	if (!applause) {
+		pr_err("%s: failed to get shadow variable with the applause description: %lu\n",
+		       __func__, id);
+		return;
+	}
+
+	strscpy(applause, "[APPLAUSE]", APPLAUSE_STR_SIZE);
+}
+
+static void unset_applause(unsigned long id)
+{
+	char *applause;
+
+	applause = (char *)klp_shadow_get(shadow_object, id);
+	if (!applause) {
+		pr_err("%s: failed to get shadow variable with the applause description: %lu\n",
+		       __func__, id);
+		return;
+	}
+
+	strscpy(applause, "[]", APPLAUSE_STR_SIZE);
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
 static struct klp_func test_klp_speaker_funcs[] = {
 	{
 		.old_name = "speaker_welcome",
@@ -64,6 +198,21 @@ static struct klp_object objs[] = {
 	{ }
 };
 
+static struct klp_state states[] = {
+	{
+		.id = APPLAUSE_ID,
+		.is_shadow = true,
+		.callbacks = {
+			.pre_patch = applause_pre_patch_callback,
+			.post_patch = applause_post_patch_callback,
+			.pre_unpatch = applause_pre_unpatch_callback,
+			.post_unpatch = applause_post_unpatch_callback,
+			.shadow_dtor = applause_shadow_dtor,
+		},
+	},
+	{}
+};
+
 static struct klp_patch patch = {
 	.mod = THIS_MODULE,
 	.objs = objs,
@@ -71,6 +220,9 @@ static struct klp_patch patch = {
 
 static int test_klp_speaker_livepatch_init(void)
 {
+	if (add_applause)
+		patch.states = states;
+
 	return klp_enable_patch(&patch);
 }
 
-- 
2.47.1


