Return-Path: <live-patching+bounces-978-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5551CA11BCC
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 09:25:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 673061889DB7
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 08:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F2C236EC0;
	Wed, 15 Jan 2025 08:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="mN7gNJ5P";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="mN7gNJ5P"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AB3232431;
	Wed, 15 Jan 2025 08:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929517; cv=none; b=CeVUcR+JRibFtQU9HcLDBRtU6IXCxcbAt15r7lsdErImgJPYhvP0i1XJtLSk32PNpsd8OMl/hwGBKTVieWhBrQPtxRAfyfoJ0m4JkGCd3T05BMx5U8iZNVkzf9YhKGvX7wRHWpz6n2pHPAu0o1hD2bvfkP2JTTokL4z8DZCTsMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929517; c=relaxed/simple;
	bh=6RA7ifO54vBRTchXDOxnLKUjVrZPFSSi4DysCXRmpVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6hxuFtObvHBMd6AWGx9e8NgpWOrUqfedMJPQR3xMJJthqHRu6KWtbpCt9OuCfjifjSas3qyjwOCIXDA+nd7YCz+XHlIsM4uK2B/iRrXrm/pD6JbJQgmyI41r1uGheMf6SgCFb7h48kqpvH7ijvLk6WYxkI0jtCEbBUeEIS8fB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=mN7gNJ5P; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=mN7gNJ5P; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from pathway.suse.cz (unknown [10.100.201.202])
	by smtp-out2.suse.de (Postfix) with ESMTP id 31A571F37C;
	Wed, 15 Jan 2025 08:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VtXHzF/JauImxPB2XYc0T0rWqBsnE1lPlsFPvdiPWgo=;
	b=mN7gNJ5P8O7Ud5lOBF6XSR9Q4MYUDOhCqoHbUsnRqPtupJPqLTmGgYVo/gq6t4L474h1Ub
	QWYLxkMTa/qKm9Msvd8NFbBflhjgnBNkjDusTwxNs0x+Z/PXWe+ba7kjrmENOLlB7gyvmU
	viBZXnzSP5rsJ/1GJ70gYJRB5rZbPxM=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VtXHzF/JauImxPB2XYc0T0rWqBsnE1lPlsFPvdiPWgo=;
	b=mN7gNJ5P8O7Ud5lOBF6XSR9Q4MYUDOhCqoHbUsnRqPtupJPqLTmGgYVo/gq6t4L474h1Ub
	QWYLxkMTa/qKm9Msvd8NFbBflhjgnBNkjDusTwxNs0x+Z/PXWe+ba7kjrmENOLlB7gyvmU
	viBZXnzSP5rsJ/1GJ70gYJRB5rZbPxM=
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v1 03/19] selftests/livepatch: Use per-state callbacks in state API tests
Date: Wed, 15 Jan 2025 09:24:15 +0100
Message-ID: <20250115082431.5550-4-pmladek@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid]
X-Spam-Score: -6.80
X-Spam-Flag: NO

Recent updates to the live patch core have enabled the integration
of states, shadow variables, and callbacks. Utilize these new features
in the state tests.

Use the shadow variable API to store the original log level, as
it is better suited for this purpose than directly accessing
the .data pointer in klp_state.

A key advantage is that the shadow variable is preserved when
the current patch is replaced by a new version, eliminating
the need to copy the pointer.

Additionally, the lifetime of the shadow variable is now tied to
the lifetime of the state and will be automatically freed when
it is no longer supported.

This results into the following changes in the code:

  + Rename CONSOLE_LOGLEVEL_STATE -> CONSOLE_LOGLEVEL_FIX_ID because
    it will be used also the for shadow variable

  + Remove the extra code for module coming and going states because
    the new callbacks are per-state.

  + Remove obsolete callbacks which used to be needed to transfer
    the shadow state data pointer.

  + The post_unpatch_callback() is retained solely for testing purposes.
    Its primary function is to print a message confirming that it has been
    called. The shadow variable is automatically freed by the core kernel
    code when the state is no longer supported by any live patch.

  + The shadow_console_loglevel_dtor() function is added solely for testing
    purposes. It simply prints a message to confirm that it has been
    called. Since the shadow variable is straightforward, its memory is
    automatically freed along with the associated struct klp_shadow.

The versioning of the state still prevents downgrades, but this issue
is now largely mitigated because callbacks are no longer required to
transfer or free shadow variables. The versioning is going to be removed
in a followup commit.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 .../testing/selftests/livepatch/test-state.sh |  52 ++---
 .../livepatch/test_modules/test_klp_state.c   | 138 +++++++------
 .../livepatch/test_modules/test_klp_state2.c  | 190 +-----------------
 3 files changed, 95 insertions(+), 285 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test-state.sh b/tools/testing/selftests/livepatch/test-state.sh
index 04b66380f8a0..2f4a5109fdf5 100755
--- a/tools/testing/selftests/livepatch/test-state.sh
+++ b/tools/testing/selftests/livepatch/test-state.sh
@@ -22,21 +22,21 @@ unload_lp $MOD_LIVEPATCH
 check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
 livepatch: enabling patch '$MOD_LIVEPATCH'
 livepatch: '$MOD_LIVEPATCH': initializing patching transition
-$MOD_LIVEPATCH: pre_patch_callback: vmlinux
+$MOD_LIVEPATCH: pre_patch_callback: state 1
 $MOD_LIVEPATCH: allocate_loglevel_state: allocating space to store console_loglevel
 livepatch: '$MOD_LIVEPATCH': starting patching transition
 livepatch: '$MOD_LIVEPATCH': completing patching transition
-$MOD_LIVEPATCH: post_patch_callback: vmlinux
+$MOD_LIVEPATCH: post_patch_callback: state 1
 $MOD_LIVEPATCH: fix_console_loglevel: fixing console_loglevel
 livepatch: '$MOD_LIVEPATCH': patching complete
 % echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
 livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-$MOD_LIVEPATCH: pre_unpatch_callback: vmlinux
+$MOD_LIVEPATCH: pre_unpatch_callback: state 1
 $MOD_LIVEPATCH: restore_console_loglevel: restoring console_loglevel
 livepatch: '$MOD_LIVEPATCH': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-$MOD_LIVEPATCH: post_unpatch_callback: vmlinux
-$MOD_LIVEPATCH: free_loglevel_state: freeing space for the stored console_loglevel
+$MOD_LIVEPATCH: post_unpatch_callback: state 1 (nope)
+$MOD_LIVEPATCH: shadow_conosle_loglevel_dtor: freeing space for the stored console_loglevel
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 
@@ -54,32 +54,28 @@ unload_lp $MOD_LIVEPATCH2
 check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
 livepatch: enabling patch '$MOD_LIVEPATCH'
 livepatch: '$MOD_LIVEPATCH': initializing patching transition
-$MOD_LIVEPATCH: pre_patch_callback: vmlinux
+$MOD_LIVEPATCH: pre_patch_callback: state 1
 $MOD_LIVEPATCH: allocate_loglevel_state: allocating space to store console_loglevel
 livepatch: '$MOD_LIVEPATCH': starting patching transition
 livepatch: '$MOD_LIVEPATCH': completing patching transition
-$MOD_LIVEPATCH: post_patch_callback: vmlinux
+$MOD_LIVEPATCH: post_patch_callback: state 1
 $MOD_LIVEPATCH: fix_console_loglevel: fixing console_loglevel
 livepatch: '$MOD_LIVEPATCH': patching complete
 % insmod test_modules/$MOD_LIVEPATCH2.ko
 livepatch: enabling patch '$MOD_LIVEPATCH2'
 livepatch: '$MOD_LIVEPATCH2': initializing patching transition
-$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
-$MOD_LIVEPATCH2: allocate_loglevel_state: space to store console_loglevel already allocated
 livepatch: '$MOD_LIVEPATCH2': starting patching transition
 livepatch: '$MOD_LIVEPATCH2': completing patching transition
-$MOD_LIVEPATCH2: post_patch_callback: vmlinux
-$MOD_LIVEPATCH2: fix_console_loglevel: taking over the console_loglevel change
 livepatch: '$MOD_LIVEPATCH2': patching complete
 % rmmod $MOD_LIVEPATCH
 % echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH2/enabled
 livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
-$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
+$MOD_LIVEPATCH2: pre_unpatch_callback: state 1
 $MOD_LIVEPATCH2: restore_console_loglevel: restoring console_loglevel
 livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
-$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
-$MOD_LIVEPATCH2: free_loglevel_state: freeing space for the stored console_loglevel
+$MOD_LIVEPATCH2: post_unpatch_callback: state 1 (nope)
+$MOD_LIVEPATCH2: shadow_conosle_loglevel_dtor: freeing space for the stored console_loglevel
 livepatch: '$MOD_LIVEPATCH2': unpatching complete
 % rmmod $MOD_LIVEPATCH2"
 
@@ -99,42 +95,34 @@ unload_lp $MOD_LIVEPATCH3
 check_result "% insmod test_modules/$MOD_LIVEPATCH2.ko
 livepatch: enabling patch '$MOD_LIVEPATCH2'
 livepatch: '$MOD_LIVEPATCH2': initializing patching transition
-$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
+$MOD_LIVEPATCH2: pre_patch_callback: state 1
 $MOD_LIVEPATCH2: allocate_loglevel_state: allocating space to store console_loglevel
 livepatch: '$MOD_LIVEPATCH2': starting patching transition
 livepatch: '$MOD_LIVEPATCH2': completing patching transition
-$MOD_LIVEPATCH2: post_patch_callback: vmlinux
+$MOD_LIVEPATCH2: post_patch_callback: state 1
 $MOD_LIVEPATCH2: fix_console_loglevel: fixing console_loglevel
 livepatch: '$MOD_LIVEPATCH2': patching complete
 % insmod test_modules/$MOD_LIVEPATCH3.ko
 livepatch: enabling patch '$MOD_LIVEPATCH3'
 livepatch: '$MOD_LIVEPATCH3': initializing patching transition
-$MOD_LIVEPATCH3: pre_patch_callback: vmlinux
-$MOD_LIVEPATCH3: allocate_loglevel_state: space to store console_loglevel already allocated
 livepatch: '$MOD_LIVEPATCH3': starting patching transition
 livepatch: '$MOD_LIVEPATCH3': completing patching transition
-$MOD_LIVEPATCH3: post_patch_callback: vmlinux
-$MOD_LIVEPATCH3: fix_console_loglevel: taking over the console_loglevel change
 livepatch: '$MOD_LIVEPATCH3': patching complete
 % rmmod $MOD_LIVEPATCH2
 % insmod test_modules/$MOD_LIVEPATCH2.ko
 livepatch: enabling patch '$MOD_LIVEPATCH2'
 livepatch: '$MOD_LIVEPATCH2': initializing patching transition
-$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
-$MOD_LIVEPATCH2: allocate_loglevel_state: space to store console_loglevel already allocated
 livepatch: '$MOD_LIVEPATCH2': starting patching transition
 livepatch: '$MOD_LIVEPATCH2': completing patching transition
-$MOD_LIVEPATCH2: post_patch_callback: vmlinux
-$MOD_LIVEPATCH2: fix_console_loglevel: taking over the console_loglevel change
 livepatch: '$MOD_LIVEPATCH2': patching complete
 % echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH2/enabled
 livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
-$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
+$MOD_LIVEPATCH2: pre_unpatch_callback: state 1
 $MOD_LIVEPATCH2: restore_console_loglevel: restoring console_loglevel
 livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
-$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
-$MOD_LIVEPATCH2: free_loglevel_state: freeing space for the stored console_loglevel
+$MOD_LIVEPATCH2: post_unpatch_callback: state 1 (nope)
+$MOD_LIVEPATCH2: shadow_conosle_loglevel_dtor: freeing space for the stored console_loglevel
 livepatch: '$MOD_LIVEPATCH2': unpatching complete
 % rmmod $MOD_LIVEPATCH2
 % rmmod $MOD_LIVEPATCH3"
@@ -152,11 +140,11 @@ unload_lp $MOD_LIVEPATCH2
 check_result "% insmod test_modules/$MOD_LIVEPATCH2.ko
 livepatch: enabling patch '$MOD_LIVEPATCH2'
 livepatch: '$MOD_LIVEPATCH2': initializing patching transition
-$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
+$MOD_LIVEPATCH2: pre_patch_callback: state 1
 $MOD_LIVEPATCH2: allocate_loglevel_state: allocating space to store console_loglevel
 livepatch: '$MOD_LIVEPATCH2': starting patching transition
 livepatch: '$MOD_LIVEPATCH2': completing patching transition
-$MOD_LIVEPATCH2: post_patch_callback: vmlinux
+$MOD_LIVEPATCH2: post_patch_callback: state 1
 $MOD_LIVEPATCH2: fix_console_loglevel: fixing console_loglevel
 livepatch: '$MOD_LIVEPATCH2': patching complete
 % insmod test_modules/$MOD_LIVEPATCH.ko
@@ -164,12 +152,12 @@ livepatch: Livepatch patch ($MOD_LIVEPATCH) is not compatible with the already i
 insmod: ERROR: could not insert module test_modules/$MOD_LIVEPATCH.ko: Invalid parameters
 % echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH2/enabled
 livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
-$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
+$MOD_LIVEPATCH2: pre_unpatch_callback: state 1
 $MOD_LIVEPATCH2: restore_console_loglevel: restoring console_loglevel
 livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
 livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
-$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
-$MOD_LIVEPATCH2: free_loglevel_state: freeing space for the stored console_loglevel
+$MOD_LIVEPATCH2: post_unpatch_callback: state 1 (nope)
+$MOD_LIVEPATCH2: shadow_conosle_loglevel_dtor: freeing space for the stored console_loglevel
 livepatch: '$MOD_LIVEPATCH2': unpatching complete
 % rmmod $MOD_LIVEPATCH2"
 
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_state.c b/tools/testing/selftests/livepatch/test_modules/test_klp_state.c
index 57a4253acb01..7f601898ef7c 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_state.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_state.c
@@ -9,109 +9,113 @@
 #include <linux/printk.h>
 #include <linux/livepatch.h>
 
-#define CONSOLE_LOGLEVEL_STATE 1
-/* Version 1 does not support migration. */
-#define CONSOLE_LOGLEVEL_STATE_VERSION 1
+#define CONSOLE_LOGLEVEL_FIX_ID 1
 
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
+/*
+ * Version of the state which defines compatibility of livepaches.
+ * The value is artificial. It set just for testing the compatibility
+ * checks. In reality, all versions are compatible because all
+ * the callbacks do nothing and the shadow variable clean up
+ * is done by the core.
+ */
+#ifndef CONSOLE_LOGLEVEL_FIX_VERSION
+#define CONSOLE_LOGLEVEL_FIX_VERSION 1
+#endif
 
 static struct klp_patch patch;
 
 static int allocate_loglevel_state(void)
 {
-	struct klp_state *loglevel_state;
+	int *shadow_console_loglevel;
 
-	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
-	if (!loglevel_state)
-		return -EINVAL;
+	/* Make sure that the shadow variable does not exist yet. */
+	shadow_console_loglevel =
+		klp_shadow_alloc(&console_loglevel, CONSOLE_LOGLEVEL_FIX_ID,
+				 sizeof(*shadow_console_loglevel), GFP_KERNEL,
+				 NULL, NULL);
 
-	loglevel_state->data = kzalloc(sizeof(console_loglevel), GFP_KERNEL);
-	if (!loglevel_state->data)
+	if (!shadow_console_loglevel) {
+		pr_err("%s: failed to allocate shadow variable for the original loglevel\n",
+		       __func__);
 		return -ENOMEM;
+	}
 
 	pr_info("%s: allocating space to store console_loglevel\n",
 		__func__);
+
 	return 0;
 }
 
 static void fix_console_loglevel(void)
 {
-	struct klp_state *loglevel_state;
+	int *shadow_console_loglevel;
 
-	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
-	if (!loglevel_state)
+	shadow_console_loglevel =
+		(int *)klp_shadow_get(&console_loglevel, CONSOLE_LOGLEVEL_FIX_ID);
+	if (!shadow_console_loglevel)
 		return;
 
 	pr_info("%s: fixing console_loglevel\n", __func__);
-	*(int *)loglevel_state->data = console_loglevel;
+	*shadow_console_loglevel = console_loglevel;
 	console_loglevel = CONSOLE_LOGLEVEL_MOTORMOUTH;
 }
 
 static void restore_console_loglevel(void)
 {
-	struct klp_state *loglevel_state;
+	int *shadow_console_loglevel;
 
-	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
-	if (!loglevel_state)
+	shadow_console_loglevel =
+		(int *)klp_shadow_get(&console_loglevel, CONSOLE_LOGLEVEL_FIX_ID);
+	if (!shadow_console_loglevel)
 		return;
 
 	pr_info("%s: restoring console_loglevel\n", __func__);
-	console_loglevel = *(int *)loglevel_state->data;
+	console_loglevel = *shadow_console_loglevel;
 }
 
-static void free_loglevel_state(void)
+/* Executed before patching, when the state is being enabled. */
+static int pre_patch_callback(struct klp_patch *patch, struct klp_state *state)
 {
-	struct klp_state *loglevel_state;
-
-	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
-	if (!loglevel_state)
-		return;
-
-	pr_info("%s: freeing space for the stored console_loglevel\n",
-		__func__);
-	kfree(loglevel_state->data);
-}
-
-/* Executed on object patching (ie, patch enablement) */
-static int pre_patch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
+	pr_info("%s: state %lu\n", __func__, state->id);
 	return allocate_loglevel_state();
 }
 
-/* Executed on object unpatching (ie, patch disablement) */
-static void post_patch_callback(struct klp_object *obj)
+/* Executed after patching, when the state being enabled. */
+static void post_patch_callback(struct klp_patch *patch, struct klp_state *state)
 {
-	callback_info(__func__, obj);
+	pr_info("%s: state %lu\n", __func__, state->id);
 	fix_console_loglevel();
 }
 
-/* Executed on object unpatching (ie, patch disablement) */
-static void pre_unpatch_callback(struct klp_object *obj)
+/* Executed before unpatching, when the state is being disabled. */
+static void pre_unpatch_callback(struct klp_patch *patch, struct klp_state *state)
 {
-	callback_info(__func__, obj);
+	pr_info("%s: state %lu\n", __func__, state->id);
 	restore_console_loglevel();
 }
 
-/* Executed on object unpatching (ie, patch disablement) */
-static void post_unpatch_callback(struct klp_object *obj)
+/*
+ * Executed after unpatching, when the state is being disabled.
+ *
+ * The callback is not really needed. It is added just to check that
+ * the optional callback is called at the right time.
+ *
+ * The shadow variable will be freed automatically because state->is_shadow
+ * is set.
+ */
+static void post_unpatch_callback(struct klp_patch *patch, struct klp_state *state)
 {
-	callback_info(__func__, obj);
-	free_loglevel_state();
+	pr_info("%s: state %lu (nope)\n", __func__, state->id);
+}
+
+/*
+ * The shadow_dtor callback is not really needed. It is added just to show that
+ * it is called automatically when disabling a klp_state with .is_shadow set.
+ */
+static void shadow_conosle_loglevel_dtor(void *obj, void *shadow_data)
+{
+	pr_info("%s: freeing space for the stored console_loglevel\n",
+		__func__);
 }
 
 static struct klp_func no_funcs[] = {
@@ -122,19 +126,21 @@ static struct klp_object objs[] = {
 	{
 		.name = NULL,	/* vmlinux */
 		.funcs = no_funcs,
-		.callbacks = {
-			.pre_patch = pre_patch_callback,
-			.post_patch = post_patch_callback,
-			.pre_unpatch = pre_unpatch_callback,
-			.post_unpatch = post_unpatch_callback,
-		},
 	}, { }
 };
 
 static struct klp_state states[] = {
 	{
-		.id = CONSOLE_LOGLEVEL_STATE,
-		.version = CONSOLE_LOGLEVEL_STATE_VERSION,
+		.id = CONSOLE_LOGLEVEL_FIX_ID,
+		.version = CONSOLE_LOGLEVEL_FIX_VERSION,
+		.is_shadow = true,
+		.callbacks = {
+			.pre_patch = pre_patch_callback,
+			.post_patch = post_patch_callback,
+			.pre_unpatch = pre_unpatch_callback,
+			.post_unpatch = post_unpatch_callback,
+			.shadow_dtor = shadow_conosle_loglevel_dtor,
+		},
 	}, { }
 };
 
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_state2.c b/tools/testing/selftests/livepatch/test_modules/test_klp_state2.c
index c978ea4d5e67..128855764bf8 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_state2.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_state2.c
@@ -1,191 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (C) 2019 SUSE
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#define CONSOLE_LOGLEVEL_FIX_VERSION 2
 
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/printk.h>
-#include <linux/livepatch.h>
-
-#define CONSOLE_LOGLEVEL_STATE 1
-/* Version 2 supports migration. */
-#define CONSOLE_LOGLEVEL_STATE_VERSION 2
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
-static struct klp_patch patch;
-
-static int allocate_loglevel_state(void)
-{
-	struct klp_state *loglevel_state, *prev_loglevel_state;
-
-	prev_loglevel_state = klp_get_prev_state(CONSOLE_LOGLEVEL_STATE);
-	if (prev_loglevel_state) {
-		pr_info("%s: space to store console_loglevel already allocated\n",
-		__func__);
-		return 0;
-	}
-
-	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
-	if (!loglevel_state)
-		return -EINVAL;
-
-	loglevel_state->data = kzalloc(sizeof(console_loglevel), GFP_KERNEL);
-	if (!loglevel_state->data)
-		return -ENOMEM;
-
-	pr_info("%s: allocating space to store console_loglevel\n",
-		__func__);
-	return 0;
-}
-
-static void fix_console_loglevel(void)
-{
-	struct klp_state *loglevel_state, *prev_loglevel_state;
-
-	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
-	if (!loglevel_state)
-		return;
-
-	prev_loglevel_state = klp_get_prev_state(CONSOLE_LOGLEVEL_STATE);
-	if (prev_loglevel_state) {
-		pr_info("%s: taking over the console_loglevel change\n",
-		__func__);
-		loglevel_state->data = prev_loglevel_state->data;
-		return;
-	}
-
-	pr_info("%s: fixing console_loglevel\n", __func__);
-	*(int *)loglevel_state->data = console_loglevel;
-	console_loglevel = CONSOLE_LOGLEVEL_MOTORMOUTH;
-}
-
-static void restore_console_loglevel(void)
-{
-	struct klp_state *loglevel_state, *prev_loglevel_state;
-
-	prev_loglevel_state = klp_get_prev_state(CONSOLE_LOGLEVEL_STATE);
-	if (prev_loglevel_state) {
-		pr_info("%s: passing the console_loglevel change back to the old livepatch\n",
-		__func__);
-		return;
-	}
-
-	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
-	if (!loglevel_state)
-		return;
-
-	pr_info("%s: restoring console_loglevel\n", __func__);
-	console_loglevel = *(int *)loglevel_state->data;
-}
-
-static void free_loglevel_state(void)
-{
-	struct klp_state *loglevel_state, *prev_loglevel_state;
-
-	prev_loglevel_state = klp_get_prev_state(CONSOLE_LOGLEVEL_STATE);
-	if (prev_loglevel_state) {
-		pr_info("%s: keeping space to store console_loglevel\n",
-		__func__);
-		return;
-	}
-
-	loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
-	if (!loglevel_state)
-		return;
-
-	pr_info("%s: freeing space for the stored console_loglevel\n",
-		__func__);
-	kfree(loglevel_state->data);
-}
-
-/* Executed on object patching (ie, patch enablement) */
-static int pre_patch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
-	return allocate_loglevel_state();
-}
-
-/* Executed on object unpatching (ie, patch disablement) */
-static void post_patch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
-	fix_console_loglevel();
-}
-
-/* Executed on object unpatching (ie, patch disablement) */
-static void pre_unpatch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
-	restore_console_loglevel();
-}
-
-/* Executed on object unpatching (ie, patch disablement) */
-static void post_unpatch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
-	free_loglevel_state();
-}
-
-static struct klp_func no_funcs[] = {
-	{}
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
-static struct klp_state states[] = {
-	{
-		.id = CONSOLE_LOGLEVEL_STATE,
-		.version = CONSOLE_LOGLEVEL_STATE_VERSION,
-	}, { }
-};
-
-static struct klp_patch patch = {
-	.mod = THIS_MODULE,
-	.objs = objs,
-	.states = states,
-	.replace = true,
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
-MODULE_AUTHOR("Petr Mladek <pmladek@suse.com>");
-MODULE_DESCRIPTION("Livepatch test: system state modification");
+/* The console loglevel fix is the same in the next cumulative patch. */
+#include "test_klp_state.c"
-- 
2.47.1


