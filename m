Return-Path: <live-patching+bounces-989-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25D75A11BED
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 09:28:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E7247A4B8F
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 08:28:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE92A1EEA50;
	Wed, 15 Jan 2025 08:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sO2E1yEf";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sO2E1yEf"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1F41EEA59;
	Wed, 15 Jan 2025 08:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929632; cv=none; b=NIMEdgxkf8S++lIh17XDRlYPLfyYiMBOmqdzcffpwphbe/ZSqe3g5m+6aAyjqffirHIJkydsLj8DGjzbdvAU/d2/WSq2w9D425qqDOfpjjEvEkmsut/oSMZ8ZQptp71eXeuwfXA4W90rurPyeYiK4yhCHDU2pak+v5g0fkPpSy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929632; c=relaxed/simple;
	bh=ZnwXCbN2B+C/1eXrZT8o+dAhWgFXxhdxpZAVumcmq4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=At7Wqf1w6GQ5ck6gjM+2+26GevwWYthqLiek3OyMDeiApG+lf8Sf9SLLWy6S//JpAUZgOPnez4+TJEtvd0f6CjDPQh+b59zz/wYvDGYYAi/LwnZVtjpcjN84/lpIPkN6hnhqPfAWKERLZju0CbQYdJD+kXaeXnAWRT8gvri8Bks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sO2E1yEf; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sO2E1yEf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from pathway.suse.cz (unknown [10.100.201.202])
	by smtp-out2.suse.de (Postfix) with ESMTP id 66DB21F37C;
	Wed, 15 Jan 2025 08:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929628; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0WcazxsZBOMrDAe/tESlkLiJZ4upXAw/WWHlFWaCO78=;
	b=sO2E1yEfIpoFfddrzIArVv+dVcsNumCaNtveMyf/t5I8jNq4LySELKtDBP+YyB6Tp0pS34
	RvzT8cbCs55XYv7FrikvEZ4BgoGYd68Tqmm1GXsqeEDJ/7SbV9DbTf7aaCo7fjv45WPK6V
	JitsGc7KoW6lNZdXEvu4cC/CuzVGwpc=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929628; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0WcazxsZBOMrDAe/tESlkLiJZ4upXAw/WWHlFWaCO78=;
	b=sO2E1yEfIpoFfddrzIArVv+dVcsNumCaNtveMyf/t5I8jNq4LySELKtDBP+YyB6Tp0pS34
	RvzT8cbCs55XYv7FrikvEZ4BgoGYd68Tqmm1GXsqeEDJ/7SbV9DbTf7aaCo7fjv45WPK6V
	JitsGc7KoW6lNZdXEvu4cC/CuzVGwpc=
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v1 14/19] selftests/livepatch: Convert selftests for testing callbacks with more livepatches
Date: Wed, 15 Jan 2025 09:24:26 +0100
Message-ID: <20250115082431.5550-15-pmladek@suse.com>
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

This patch converts selftests for the obsolete per-object callbacks and
more livepatches.

The new tests for the per-state callbacks use the new speaker test module.
The second livepatch simply reuses the sources from the existing one.

For greater variability, the livepatch is extended to support more shadow
variables. The second shadow variable can be enabled using
the "add_applause2" module parameter. It appears in the speaker's welcome
message as follows:

  + not patched system:		 "Hello, World!"
  + transition (unpatched task): "[2] Hello, World!"
  + transition (patched task):   "[2] Ladies and gentleman, ..."
  + patched system:		 "[APPLAUSE2] Ladies and gentleman, ..."

For backward compatibility, the first shadow variable is enabled using
the non-versioned parameter "add_applause" and appears as the non-versioned
"[APPLAUSE]" string.

Both shadow variables can be enabled together. They will appear next to
each other in the speaker's welcome message. For example,
on the patched system:

    "[APPLAUSE][APPLAUSE2] Ladies and gentlemen, ..."

Finally, the livepatch will get installed in parallel with other
livepatches by default. The atomic replace feature can be enabled by
a new module parameter "replace".

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 .../selftests/livepatch/test-callbacks.sh     | 113 ------------
 .../livepatch/test-state-callbacks.sh         | 161 ++++++++++++++++
 .../selftests/livepatch/test_modules/Makefile |   1 +
 .../test_modules/test_klp_speaker_livepatch.c | 173 +++++++++++++++---
 .../test_klp_speaker_livepatch2.c             |   5 +
 5 files changed, 312 insertions(+), 141 deletions(-)
 delete mode 100755 tools/testing/selftests/livepatch/test-callbacks.sh
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch2.c

diff --git a/tools/testing/selftests/livepatch/test-callbacks.sh b/tools/testing/selftests/livepatch/test-callbacks.sh
deleted file mode 100755
index 858e8f0b14d5..000000000000
--- a/tools/testing/selftests/livepatch/test-callbacks.sh
+++ /dev/null
@@ -1,113 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (C) 2018 Joe Lawrence <joe.lawrence@redhat.com>
-
-. $(dirname $0)/functions.sh
-
-MOD_LIVEPATCH=test_klp_callbacks_demo
-MOD_LIVEPATCH2=test_klp_callbacks_demo2
-MOD_TARGET=test_klp_callbacks_mod
-MOD_TARGET_BUSY=test_klp_callbacks_busy
-
-setup_config
-
-# Test loading multiple livepatches.  This test-case is mainly for comparing
-# with the next test-case.
-#
-# - Load and unload two livepatches, pre and post (un)patch callbacks
-#   execute as each patch progresses through its (un)patching
-#   transition.
-
-start_test "multiple livepatches"
-
-load_lp $MOD_LIVEPATCH
-load_lp $MOD_LIVEPATCH2
-disable_lp $MOD_LIVEPATCH2
-disable_lp $MOD_LIVEPATCH
-unload_lp $MOD_LIVEPATCH2
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
-% insmod test_modules/$MOD_LIVEPATCH2.ko
-livepatch: enabling patch '$MOD_LIVEPATCH2'
-livepatch: '$MOD_LIVEPATCH2': initializing patching transition
-$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': starting patching transition
-livepatch: '$MOD_LIVEPATCH2': completing patching transition
-$MOD_LIVEPATCH2: post_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': patching complete
-% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH2/enabled
-livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
-$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
-$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': unpatching complete
-% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH/enabled
-livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
-$MOD_LIVEPATCH: pre_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH': completing unpatching transition
-$MOD_LIVEPATCH: post_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH': unpatching complete
-% rmmod $MOD_LIVEPATCH2
-% rmmod $MOD_LIVEPATCH"
-
-
-# Load multiple livepatches, but the second as an 'atomic-replace'
-# patch.  When the latter loads, the original livepatch should be
-# disabled and *none* of its pre/post-unpatch callbacks executed.  On
-# the other hand, when the atomic-replace livepatch is disabled, its
-# pre/post-unpatch callbacks *should* be executed.
-#
-# - Load and unload two livepatches, the second of which has its
-#   .replace flag set true.
-#
-# - Pre and post patch callbacks are executed for both livepatches.
-#
-# - Once the atomic replace module is loaded, only its pre and post
-#   unpatch callbacks are executed.
-
-start_test "atomic replace"
-
-load_lp $MOD_LIVEPATCH
-load_lp $MOD_LIVEPATCH2 replace=1
-disable_lp $MOD_LIVEPATCH2
-unload_lp $MOD_LIVEPATCH2
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
-% insmod test_modules/$MOD_LIVEPATCH2.ko replace=1
-livepatch: enabling patch '$MOD_LIVEPATCH2'
-livepatch: '$MOD_LIVEPATCH2': initializing patching transition
-$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': starting patching transition
-livepatch: '$MOD_LIVEPATCH2': completing patching transition
-$MOD_LIVEPATCH2: post_patch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': patching complete
-% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH2/enabled
-livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
-$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
-livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
-$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
-livepatch: '$MOD_LIVEPATCH2': unpatching complete
-% rmmod $MOD_LIVEPATCH2
-% rmmod $MOD_LIVEPATCH"
-
-
-exit 0
diff --git a/tools/testing/selftests/livepatch/test-state-callbacks.sh b/tools/testing/selftests/livepatch/test-state-callbacks.sh
index 7d8c872eccfe..5349beae2735 100755
--- a/tools/testing/selftests/livepatch/test-state-callbacks.sh
+++ b/tools/testing/selftests/livepatch/test-state-callbacks.sh
@@ -6,6 +6,7 @@
 . $(dirname $0)/functions.sh
 
 MOD_LIVEPATCH=test_klp_speaker_livepatch
+MOD_LIVEPATCH2=test_klp_speaker_livepatch2
 MOD_TARGET=test_klp_speaker
 
 setup_config
@@ -287,4 +288,164 @@ $MOD_TARGET: speaker_welcome: Hello, World!
 % rmmod $MOD_TARGET
 $MOD_TARGET: ${MOD_TARGET}_exit"
 
+# Test loading multiple livepatches in parallel.
+#
+# Both livepatches fix the speaker's welcome message. The first one
+# also adds the base "[APPLAUSE]". The second one adds an extra "[APPLAUSE2]",
+# aka from another level of the concert hall.
+#
+# The per-state callbacks are called when the state is introduced or
+# or removed.
+#
+# The [APPLAUSE] and [APPLAUSE2] strings should appear in the speaker's
+# welcome message when the respective livepatches are enabled.
+start_test "multiple livepatches in parallel"
+
+load_mod $MOD_TARGET
+read_module_param $MOD_TARGET welcome
+
+load_lp $MOD_LIVEPATCH applause=1
+read_module_param $MOD_TARGET welcome
+
+load_lp $MOD_LIVEPATCH2 applause2=1
+read_module_param $MOD_TARGET welcome
+
+disable_lp $MOD_LIVEPATCH2
+unload_lp $MOD_LIVEPATCH2
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
+% insmod test_modules/$MOD_LIVEPATCH2.ko applause2=1
+livepatch: enabling patch '$MOD_LIVEPATCH2'
+livepatch: '$MOD_LIVEPATCH2': initializing patching transition
+$MOD_LIVEPATCH2: applause_pre_patch_callback: state 11
+livepatch: '$MOD_LIVEPATCH2': starting patching transition
+livepatch: '$MOD_LIVEPATCH2': completing patching transition
+$MOD_LIVEPATCH2: applause_post_patch_callback: state 11
+livepatch: '$MOD_LIVEPATCH2': patching complete
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_LIVEPATCH2: lp_speaker_welcome: [APPLAUSE][APPLAUSE2] Ladies and gentleman, ...
+% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH2/enabled
+livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
+$MOD_LIVEPATCH2: applause_pre_unpatch_callback: state 11
+livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
+$MOD_LIVEPATCH2: applause_post_unpatch_callback: state 11 (nope)
+$MOD_LIVEPATCH2: applause_shadow_dtor: freeing applause [2] (nope)
+livepatch: '$MOD_LIVEPATCH2': unpatching complete
+% rmmod $MOD_LIVEPATCH2
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
+# Test loading multiple livepatches using the atomic replace.
+#
+# Both livepatches fix the speaker's welcome message. The first one
+# also adds the base "[APPLAUSE]". The second one also enables
+# "[APPLAUSE2]", aka from another level of the concert hall.
+#
+# In compare with the previous selftest, the 2nd livepatch has
+# to enable both "add_applause" and "add_applause2" module parameters.
+# By other words, the second livepatch has to support both states.
+# Otherwise, the base "[APPLAUSE]" would get disabled.
+#
+# The first livepatch is replaced. It does not need to be explicitly
+# disabled.
+#
+# The per-state callbacks are called when the state is introduced or
+# or removed.
+#
+# The [APPLAUSE] and [APPLAUSE2] strings should appear in the speaker's
+# welcome message when the respective livepatches are enabled.
+start_test "atomic replace"
+
+load_mod $MOD_TARGET
+read_module_param $MOD_TARGET welcome
+
+load_lp $MOD_LIVEPATCH applause=1
+read_module_param $MOD_TARGET welcome
+
+load_lp $MOD_LIVEPATCH2 replace=1 applause=1 applause2=1
+unload_lp $MOD_LIVEPATCH
+read_module_param $MOD_TARGET welcome
+
+disable_lp $MOD_LIVEPATCH2
+unload_lp $MOD_LIVEPATCH2
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
+% insmod test_modules/$MOD_LIVEPATCH2.ko replace=1 applause=1 applause2=1
+livepatch: enabling patch '$MOD_LIVEPATCH2'
+livepatch: '$MOD_LIVEPATCH2': initializing patching transition
+$MOD_LIVEPATCH2: applause_pre_patch_callback: state 11
+livepatch: '$MOD_LIVEPATCH2': starting patching transition
+livepatch: '$MOD_LIVEPATCH2': completing patching transition
+$MOD_LIVEPATCH2: applause_post_patch_callback: state 11
+livepatch: '$MOD_LIVEPATCH2': patching complete
+% rmmod $MOD_LIVEPATCH
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_LIVEPATCH2: lp_speaker_welcome: [APPLAUSE][APPLAUSE2] Ladies and gentleman, ...
+% echo 0 > $SYSFS_KLP_DIR/$MOD_LIVEPATCH2/enabled
+livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
+$MOD_LIVEPATCH2: applause_pre_unpatch_callback: state 10
+$MOD_LIVEPATCH2: applause_pre_unpatch_callback: state 11
+livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
+$MOD_LIVEPATCH2: applause_post_unpatch_callback: state 10 (nope)
+$MOD_LIVEPATCH2: applause_shadow_dtor: freeing applause [] (nope)
+$MOD_LIVEPATCH2: applause_post_unpatch_callback: state 11 (nope)
+$MOD_LIVEPATCH2: applause_shadow_dtor: freeing applause [2] (nope)
+livepatch: '$MOD_LIVEPATCH2': unpatching complete
+% rmmod $MOD_LIVEPATCH2
+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!
+% rmmod $MOD_TARGET
+$MOD_TARGET: ${MOD_TARGET}_exit"
+
 exit 0
diff --git a/tools/testing/selftests/livepatch/test_modules/Makefile b/tools/testing/selftests/livepatch/test_modules/Makefile
index 72a817d1ddd9..f1e7b9d64c8e 100644
--- a/tools/testing/selftests/livepatch/test_modules/Makefile
+++ b/tools/testing/selftests/livepatch/test_modules/Makefile
@@ -12,6 +12,7 @@ obj-m += test_klp_atomic_replace.o \
 	test_klp_speaker.o \
 	test_klp_speaker2.o \
 	test_klp_speaker_livepatch.o \
+	test_klp_speaker_livepatch2.o \
 	test_klp_state.o \
 	test_klp_state2.o \
 	test_klp_state3.o \
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
index 6b82c5636845..cdc7010f0e93 100644
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch.c
@@ -23,32 +23,75 @@
  *    - Support more speaker modules, see __lp_speaker_welcome().
  *
  *    - Livepatch block_doors_func() which can block the transition.
+ *
+ *    - Support testing of more shadow variables and state callbacks. see
+ *	"applause", and "applause2" module parameters.
+ *
+ *    - Allow to enable the atomic replace via "replace" parameter.
  */
 
-#define APPLAUSE_ID 10
+#define APPLAUSE_NUM 2
+#define APPLAUSE_START_ID 10
 #define APPLAUSE_STR_SIZE 16
+#define APPLAUSE_IDX_STR_SIZE 8
 
 /* associate the shadow variable with NULL address */;
 static void *shadow_object = NULL;
 
-static bool add_applause;
-module_param_named(applause, add_applause, bool, 0400);
+static bool add_applause[APPLAUSE_NUM];
+module_param_named(applause, add_applause[0], bool, 0400);
 MODULE_PARM_DESC(applause, "Use shadow variable to add applause (default=false)");
+module_param_named(applause2, add_applause[1], bool, 0400);
+MODULE_PARM_DESC(applause2, "Use shadow variable to add 2nd applause (default=false)");
 
 static int pre_patch_ret;
 module_param(pre_patch_ret, int, 0400);
 MODULE_PARM_DESC(pre_patch_ret, "Allow to force failure for the pre_patch callback (default=0)");
 
+static bool replace;
+module_param(replace, bool, 0400);
+MODULE_PARM_DESC(replace, "Enable the atomic replace feature when loading the livepatch. (default=false)");
+
+/* Conversion between the index to the @add_applause table and state ID. */
+#define __idx_to_state_id(idx) (idx + APPLAUSE_START_ID)
+#define __state_id_to_idx(state_id) (state_id - APPLAUSE_START_ID)
+
 static void __lp_speaker_welcome(const char *caller_func,
 				 const char *speaker_id,
 				 const char *context)
 {
-	char entire_applause[APPLAUSE_STR_SIZE + 1] = "";
-	const char *applause;
+	char entire_applause[APPLAUSE_NUM * APPLAUSE_STR_SIZE + 1] = "";
+	int idx, ret;
+	int len = 0;
 
-	applause = (char *)klp_shadow_get(shadow_object, APPLAUSE_ID);
-	if (applause)
-		snprintf(entire_applause, sizeof(entire_applause), "%s ", applause);
+	for (idx = 0; idx < APPLAUSE_NUM ; idx++) {
+		const char *applause;
+
+		applause = (char *)klp_shadow_get(shadow_object,
+						  __idx_to_state_id(idx));
+
+		if (applause) {
+			ret = strscpy(entire_applause + len, applause,
+				       sizeof(entire_applause) - len);
+			if (ret < 0) {
+				pr_warn("Too small buffer for entire_applause. Truncating...\n");
+				len = sizeof(entire_applause) - 1;
+				break;
+			}
+			len += ret;
+		}
+	}
+
+	if (len) {
+		ret = strscpy(entire_applause + len, " ",
+			       sizeof(entire_applause) - len);
+		if (ret < 0) {
+			pr_warn("Too small buffer for entire_applause. Truncating...\n");
+			len = sizeof(entire_applause) - 1;
+		} else {
+			len += ret;
+		}
+	}
 
 	pr_info("%s%s: %sLadies and gentleman, ...%s\n",
 		caller_func, speaker_id, entire_applause, context);
@@ -64,8 +107,28 @@ static void lp_speaker2_welcome(const char *context)
 	__lp_speaker_welcome(__func__, "(2)", context);
 }
 
+static char *state_id_to_idx_str(char *buf, size_t size,
+				   unsigned long state_id)
+{
+	int idx;
+
+	idx = __state_id_to_idx(state_id);
+
+	if (idx < 0 || idx >= APPLAUSE_NUM) {
+		pr_err("%s: Applause table index out of scope: %d\n", __func__, idx);
+		return "";
+	}
+
+	if (idx == 0)
+		return "";
+
+	snprintf(buf, size, "%d", idx + 1);
+	return buf;
+}
+
 static int allocate_applause(unsigned long id)
 {
+	char idx_str[APPLAUSE_IDX_STR_SIZE];
 	char *applause;
 
 	/*
@@ -84,13 +147,15 @@ static int allocate_applause(unsigned long id)
 		return -ENOMEM;
 	}
 
-	strscpy(applause, "[]", APPLAUSE_STR_SIZE);
+	snprintf(applause, APPLAUSE_STR_SIZE, "[%s]",
+		 state_id_to_idx_str(idx_str, sizeof(idx_str), id));
 
 	return 0;
 }
 
 static void set_applause(unsigned long id)
 {
+	char idx_str[APPLAUSE_IDX_STR_SIZE];
 	char *applause;
 
 	applause = (char *)klp_shadow_get(shadow_object, id);
@@ -100,11 +165,13 @@ static void set_applause(unsigned long id)
 		return;
 	}
 
-	strscpy(applause, "[APPLAUSE]", APPLAUSE_STR_SIZE);
+	snprintf(applause, APPLAUSE_STR_SIZE, "[APPLAUSE%s]",
+		 state_id_to_idx_str(idx_str, sizeof(idx_str), id));
 }
 
 static void unset_applause(unsigned long id)
 {
+	char idx_str[APPLAUSE_IDX_STR_SIZE];
 	char *applause;
 
 	applause = (char *)klp_shadow_get(shadow_object, id);
@@ -114,7 +181,8 @@ static void unset_applause(unsigned long id)
 		return;
 	}
 
-	strscpy(applause, "[]", APPLAUSE_STR_SIZE);
+	snprintf(applause, APPLAUSE_STR_SIZE, "[%s]",
+		 state_id_to_idx_str(idx_str, sizeof(idx_str), id));
 }
 
 static void check_applause(unsigned long id)
@@ -251,36 +319,85 @@ static struct klp_object objs[] = {
 	{ }
 };
 
-static struct klp_state states[] = {
-	{
-		.id = APPLAUSE_ID,
-		.is_shadow = true,
-		.callbacks = {
-			.pre_patch = applause_pre_patch_callback,
-			.post_patch = applause_post_patch_callback,
-			.pre_unpatch = applause_pre_unpatch_callback,
-			.post_unpatch = applause_post_unpatch_callback,
-			.shadow_dtor = applause_shadow_dtor,
-		},
-	},
-	{}
-};
-
 static struct klp_patch patch = {
 	.mod = THIS_MODULE,
 	.objs = objs,
 };
 
+
+/*
+ * The array with states is dynamically allocated depending on which states
+ * are enabled on the command line.
+ */
+static struct klp_state *applause_states;
+
+static int applause_init(void)
+{
+	int idx, idx_allowed, id, enabled_cnt;
+
+	enabled_cnt = 0;
+
+	for (idx = 0, id = APPLAUSE_START_ID, enabled_cnt = 0;
+	     idx < APPLAUSE_NUM;
+	     idx++, id++) {
+		if (add_applause[idx])
+			enabled_cnt++;
+	}
+
+	if (enabled_cnt) {
+		/* Allocate one more state as the trailing entry. */
+		applause_states =
+			kzalloc(sizeof(applause_states[0]) * (enabled_cnt + 1),	GFP_KERNEL);
+		if (!applause_states)
+			return -ENOMEM;
+
+		patch.states = applause_states;
+
+		for (idx = 0, idx_allowed = 0;
+		     idx < APPLAUSE_NUM;
+		     idx++) {
+			struct klp_state *state;
+
+			if (!add_applause[idx])
+				continue;
+
+			if (idx_allowed >= enabled_cnt) {
+				pr_warn("Too many enabled applause states\n");
+				continue;
+			}
+
+			state = &applause_states[idx_allowed++];
+
+			state->id = __idx_to_state_id(idx);
+			state->is_shadow = true;
+			state->callbacks.pre_patch = applause_pre_patch_callback;
+			state->callbacks.post_patch = applause_post_patch_callback;
+			state->callbacks.pre_unpatch = applause_pre_unpatch_callback;
+			state->callbacks.post_unpatch = applause_post_unpatch_callback;
+			state->callbacks.shadow_dtor = applause_shadow_dtor;
+		}
+	}
+
+	return 0;
+}
+
 static int test_klp_speaker_livepatch_init(void)
 {
-	if (add_applause)
-		patch.states = states;
+	int err;
+
+	err = applause_init();
+	if (err)
+		return err;
+
+	if (replace)
+		patch.replace = true;
 
 	return klp_enable_patch(&patch);
 }
 
 static void test_klp_speaker_livepatch_exit(void)
 {
+	kfree(applause_states);
 }
 
 module_init(test_klp_speaker_livepatch_init);
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch2.c b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch2.c
new file mode 100644
index 000000000000..c011d2ee8301
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_speaker_livepatch2.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2024 SUSE
+
+/* Same livepatch with the same features. */
+#include "test_klp_speaker_livepatch.c"
-- 
2.47.1


