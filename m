Return-Path: <live-patching+bounces-986-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 555DDA11BE4
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 09:27:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F6E71638E5
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 08:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 003D93DABF0;
	Wed, 15 Jan 2025 08:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nXYCZBPH";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nXYCZBPH"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14BA2361C9;
	Wed, 15 Jan 2025 08:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929600; cv=none; b=n0XKA2ru63OyCM8kj0hyhPr8MPorLKLt7uPvUP6ppLQNm508Agh88/6VjO9d1PFwyFl3E6eH8JTlO4h2bd7arJ2C1HwYVVlqjsDx53mxL0fCGaSQ7GLkGO2gDIgOjTgIag44NgvN1zNHNgBNywbh5aenKL7uBfdQUEBCR3mcLDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929600; c=relaxed/simple;
	bh=8EztCbiXjD5rt90xhxh7pNclvHzSNkSJNMC7FiRFOa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QzIEWA2bLypiO18cf4pbZofRgf0uMAnHVMiQkkdAmEjL1LrhNFB8H4CUx2m7vih4429F8RRCmLZi7pfUx6KMhTLSoz+IsDfIFPJHZ8G7ahLtB9hax8dD4sxRS2sRQdxrF7xMWSc7Q7pUY3Hj94OCfMCX7Q6zn5Pqfie5z8bnunA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nXYCZBPH; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nXYCZBPH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from pathway.suse.cz (unknown [10.100.201.202])
	by smtp-out2.suse.de (Postfix) with ESMTP id 44D9B1F37C;
	Wed, 15 Jan 2025 08:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929597; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=flHQHyHm/pIfyGnps+uCicYHUheiiEiLwAMJXGi+ajM=;
	b=nXYCZBPHjQonabD42MUoq5Q+CqLBqo3so+W0Vc8HJmucAbTLVSB+5vSANPjsDnFndH6M7v
	p7AcbM7b6d/XW5pNv5jdr7XnKN0LgDvUiLoHlfIY1XNuZrAVJc+uwtNoacHcDcClxFnpcs
	q2H3trv3EPfrsnuueuap4Zf9EiffptU=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929597; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=flHQHyHm/pIfyGnps+uCicYHUheiiEiLwAMJXGi+ajM=;
	b=nXYCZBPHjQonabD42MUoq5Q+CqLBqo3so+W0Vc8HJmucAbTLVSB+5vSANPjsDnFndH6M7v
	p7AcbM7b6d/XW5pNv5jdr7XnKN0LgDvUiLoHlfIY1XNuZrAVJc+uwtNoacHcDcClxFnpcs
	q2H3trv3EPfrsnuueuap4Zf9EiffptU=
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v1 11/19] selftests/livepatch: Convert selftests for failing pre_patch callback
Date: Wed, 15 Jan 2025 09:24:23 +0100
Message-ID: <20250115082431.5550-12-pmladek@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,pathway.suse.cz:helo]
X-Spam-Score: -6.80
X-Spam-Flag: NO

The per-object callbacks have been deprecated in favor of per-state
callbacks and will be removed soon. The behavior of these two types
of callbacks is completely different.

Per-object callbacks are triggered when the livepatching of the related
object is enabled or disabled. Per-state callbacks, on the other hand,
are triggered when the state is being added or removed.

In other words, it does not matter whether the livepatched object is loaded
before or after the livepatch. Therefore, it makes sense to preserve only
one variant of the self-test for the failing pre_patch callback.

Use the new speaker module for testing. Simply add a new parameter,
"pre_patch_ret", similar to the one in the "test_klp_callbacks_demo"
livepatch module.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 .../selftests/livepatch/test-callbacks.sh     | 82 -------------------
 .../livepatch/test-state-callbacks.sh         | 35 ++++++++
 .../test_modules/test_klp_speaker_livepatch.c | 10 +++
 3 files changed, 45 insertions(+), 82 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test-callbacks.sh b/tools/testing/selftests/livepatch/test-callbacks.sh
index a9bb90920c0a..1ecd8f08a613 100755
--- a/tools/testing/selftests/livepatch/test-callbacks.sh
+++ b/tools/testing/selftests/livepatch/test-callbacks.sh
@@ -11,88 +11,6 @@ MOD_TARGET_BUSY=test_klp_callbacks_busy
 
 setup_config
 
-# Test a scenario where a vmlinux pre-patch callback returns a non-zero
-# status (ie, failure).
-#
-# - First load a target module.
-#
-# - Load the livepatch module, setting its 'pre_patch_ret' value to -19
-#   (-ENODEV).  When its vmlinux pre-patch callback executes, this
-#   status code will propagate back to the module-loading subsystem.
-#   The result is that the insmod command refuses to load the livepatch
-#   module.
-
-start_test "pre-patch callback -ENODEV"
-
-load_mod $MOD_TARGET
-load_failing_mod $MOD_LIVEPATCH pre_patch_ret=-19
-unload_mod $MOD_TARGET
-
-check_result "% insmod test_modules/$MOD_TARGET.ko
-$MOD_TARGET: ${MOD_TARGET}_init
-% insmod test_modules/$MOD_LIVEPATCH.ko pre_patch_ret=-19
-livepatch: enabling patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': initializing patching transition
-test_klp_callbacks_demo: pre_patch_callback: vmlinux
-livepatch: pre-patch callback failed for object 'vmlinux'
-livepatch: failed to enable patch '$MOD_LIVEPATCH'
-livepatch: '$MOD_LIVEPATCH': canceling patching transition, going to unpatch
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-insmod: ERROR: could not insert module test_modules/$MOD_LIVEPATCH.ko: No such device
-% rmmod $MOD_TARGET
-$MOD_TARGET: ${MOD_TARGET}_exit"
-
-
-# Similar to the previous test, setup a livepatch such that its vmlinux
-# pre-patch callback returns success.  However, when a targeted kernel
-# module is later loaded, have the livepatch return a failing status
-# code.
-#
-# - Load the livepatch, vmlinux pre-patch callback succeeds.
-#
-# - Set a trap so subsequent pre-patch callbacks to this livepatch will
-#   return -ENODEV.
-#
-# - The livepatch pre-patch callback for subsequently loaded target
-#   modules will return failure, so the module loader refuses to load
-#   the kernel module.  No post-patch or pre/post-unpatch callbacks are
-#   executed for this klp_object.
-#
-# - Pre/post-unpatch callbacks are run for the vmlinux klp_object.
-
-start_test "module_coming + pre-patch callback -ENODEV"
-
-load_lp $MOD_LIVEPATCH
-set_pre_patch_ret $MOD_LIVEPATCH -19
-load_failing_mod $MOD_TARGET
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
-% echo -19 > $SYSFS_MODULE_DIR/$MOD_LIVEPATCH/parameters/pre_patch_ret
-% insmod test_modules/$MOD_TARGET.ko
-livepatch: applying patch '$MOD_LIVEPATCH' to loading module '$MOD_TARGET'
-$MOD_LIVEPATCH: pre_patch_callback: $MOD_TARGET -> [MODULE_STATE_COMING] Full formed, running module_init
-livepatch: pre-patch callback failed for object '$MOD_TARGET'
-livepatch: patch '$MOD_LIVEPATCH' failed for module '$MOD_TARGET', refusing to load module '$MOD_TARGET'
-insmod: ERROR: could not insert module test_modules/$MOD_TARGET.ko: No such device
-% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
-livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-$MOD_LIVEPATCH: pre_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-$MOD_LIVEPATCH: post_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH"
-
 # A similar test as the previous one, but force the "busy" kernel module
 # to block the livepatch transition.
 #
diff --git a/tools/testing/selftests/livepatch/test-state-callbacks.sh b/tools/testing/selftests/livepatch/test-state-callbacks.sh
index 1183b9d15782..28ef88a2dfc3 100755
--- a/tools/testing/selftests/livepatch/test-state-callbacks.sh
+++ b/tools/testing/selftests/livepatch/test-state-callbacks.sh
@@ -55,4 +55,39 @@ $MOD_TARGET: speaker_welcome: Hello, World!
 % rmmod $MOD_TARGET
 $MOD_TARGET: ${MOD_TARGET}_exit"
 
+# Test failure of the "pre_patch" state callback.
+#
+# The livepatch should not get loaded. The test module should
+# should stay unpatched which is checked by reading the "welcome"
+# parameter.
+
+start_test "failing pre_patch callback with -ENODEV"
+
+load_mod $MOD_TARGET
+read_module_param $MOD_TARGET welcome
+
+load_failing_mod $MOD_LIVEPATCH applause=1 pre_patch_ret=-19
+read_module_param $MOD_TARGET welcome
+
+unload_mod $MOD_TARGET
+
+check_result "% insmod test_modules/$MOD_TARGET.ko
+$MOD_TARGET: ${MOD_TARGET}_init
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% insmod test_modules/$MOD_LIVEPATCH.ko applause=1 pre_patch_ret=-19
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+$MOD_LIVEPATCH: applause_pre_patch_callback: state 10
+$MOD_LIVEPATCH: applause_pre_patch_callback: forcing err: -ENODEV
+livepatch: failed to enable patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': canceling patching transition, going to unpatch
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+insmod: ERROR: could not insert module test_modules/$MOD_LIVEPATCH.ko: No such device
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% rmmod $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_exit"
+
 exit 0
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
index ab409df0b0e3..c46c98a3c1e6 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
@@ -31,6 +31,10 @@ static bool add_applause;
 module_param_named(applause, add_applause, bool, 0400);
 MODULE_PARM_DESC(applause, "Use shadow variable to add applause (default=false)");
 
+static int pre_patch_ret;
+module_param(pre_patch_ret, int, 0400);
+MODULE_PARM_DESC(pre_patch_ret, "Allow to force failure for the pre_patch callback (default=0)");
+
 static void __lp_speaker_welcome(const char *caller_func, const char *speaker_id)
 {
 	char entire_applause[APPLAUSE_STR_SIZE + 1] = "";
@@ -123,6 +127,12 @@ static void check_applause(unsigned long id)
 static int applause_pre_patch_callback(struct klp_patch *patch, struct klp_state *state)
 {
 	pr_info("%s: state %lu\n", __func__, state->id);
+
+	if (pre_patch_ret) {
+		pr_err("%s: forcing err: %pe\n", __func__, ERR_PTR(pre_patch_ret));
+		return pre_patch_ret;
+	}
+
 	return allocate_applause(state->id);
 }
 
-- 
2.47.1


