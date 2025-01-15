Return-Path: <live-patching+bounces-991-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C3FBA11BF0
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 09:29:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BB5D1881D20
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 08:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF711E7C3C;
	Wed, 15 Jan 2025 08:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UC9YqqrG";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="U52GS/lg"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D3B1E7C36;
	Wed, 15 Jan 2025 08:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929653; cv=none; b=OOHZvpqftzx9F6H224U3MbhmEo6As17M7lB/CzkWofVkkKRPPSCXzIY8ILtcHsMQy2DN2ZWm3rvbkcUzsGzdc6u8BRYoB+88KKtkLeZTFOJOMgEyBLaRxSESJ7GcnptTUqc4zg26BAQZaZfKGBIIeSZABqsvZrQkuspa/vNy7vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929653; c=relaxed/simple;
	bh=QZwxEBVrvHuhiAeBqHJiRKnif9EV/1w7tMlon0+lqTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7WGPkycv/5YPC711bGm1sXZcZNS/OF4hxi7yp7kInC5N5hgtZqGmcUuiVv9H1i7dcY2ZKMrSV9XyMe9FfZsJ4coiHAS38NH4IJBaGtmszk8eFcx+W4S3+AFH1GLeBmqy0aKMwVLPZlGJCjGajEd63ivjkt69Cf5KJ7ryYefyQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UC9YqqrG; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=U52GS/lg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from pathway.suse.cz (unknown [10.100.201.202])
	by smtp-out2.suse.de (Postfix) with ESMTP id 0909B1F37C;
	Wed, 15 Jan 2025 08:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929650; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zp+2FY8wvNTBgSoSA3n3MGUZ2OF/XudmpdMQ+3KJdpk=;
	b=UC9YqqrGohDY2DBx1isZ6wc5QSrhEbTN9bKKLqOzaw0OaGBOpWgqJWCtYPyI6DVpen5PIw
	lXnoYSKFm/+BJeoSQFJxl/anEfZ2uPZ4N1kmXcX4H/qLK2do9qc2KbCsub3so/wNzNlAAK
	sgzxHJiZWLbzQrLH+0y6AnUQ3qk+HyM=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929649; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zp+2FY8wvNTBgSoSA3n3MGUZ2OF/XudmpdMQ+3KJdpk=;
	b=U52GS/lg6Fv7IFy2q5x9pnbp+NpFJytPVoXNLPsMUW4oh7IwKqRGbkBz9fYK/EpoW5M3l1
	TERnGEB1uDJMUq06tFElyK9hQfN6ipaXP5CV/OHzXForgOPQ716uK1kdKYx3UvpByEVSTK
	uPaTaO096G74YVonzNtbzEZJb1e/JBo=
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v1 16/19] selftests/livepatch: Remove obsolete test modules for per-object callbacks
Date: Wed, 15 Jan 2025 09:24:28 +0100
Message-ID: <20250115082431.5550-17-pmladek@suse.com>
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
callbacks and are scheduled for removal. This commit removes
the corresponding test modules that are no longer needed.

These test modules have been superseded by new tests that exercise
the per-state callback functionality.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 .../selftests/livepatch/test_modules/Makefile |   4 -
 .../test_modules/test_klp_callbacks_busy.c    |  70 ----------
 .../test_modules/test_klp_callbacks_demo.c    | 121 ------------------
 .../test_modules/test_klp_callbacks_demo2.c   |  93 --------------
 .../test_modules/test_klp_callbacks_mod.c     |  24 ----
 5 files changed, 312 deletions(-)
 delete mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_busy.c
 delete mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo.c
 delete mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo2.c
 delete mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_mod.c

diff --git a/tools/testing/selftests/livepatch/test_modules/Makefile b/tools/testing/selftests/livepatch/test_modules/Makefile
index f1e7b9d64c8e..18b0c23ef656 100644
--- a/tools/testing/selftests/livepatch/test_modules/Makefile
+++ b/tools/testing/selftests/livepatch/test_modules/Makefile
@@ -2,10 +2,6 @@ TESTMODS_DIR := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
 KDIR ?= /lib/modules/$(shell uname -r)/build
 
 obj-m += test_klp_atomic_replace.o \
-	test_klp_callbacks_busy.o \
-	test_klp_callbacks_demo.o \
-	test_klp_callbacks_demo2.o \
-	test_klp_callbacks_mod.o \
 	test_klp_kprobe.o \
 	test_klp_livepatch.o \
 	test_klp_shadow_vars.o \
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_busy.c b/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_busy.c
deleted file mode 100644
index 133929e0ce8f..000000000000
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_busy.c
+++ /dev/null
@@ -1,70 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-// Copyright (C) 2018 Joe Lawrence <joe.lawrence@redhat.com>
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/workqueue.h>
-#include <linux/delay.h>
-
-/* load/run-time control from sysfs writer  */
-static bool block_transition;
-module_param(block_transition, bool, 0644);
-MODULE_PARM_DESC(block_transition, "block_transition (default=false)");
-
-static void busymod_work_func(struct work_struct *work);
-static DECLARE_WORK(work, busymod_work_func);
-static DECLARE_COMPLETION(busymod_work_started);
-
-static void busymod_work_func(struct work_struct *work)
-{
-	pr_info("%s enter\n", __func__);
-	complete(&busymod_work_started);
-
-	while (READ_ONCE(block_transition)) {
-		/*
-		 * Busy-wait until the sysfs writer has acknowledged a
-		 * blocked transition and clears the flag.
-		 */
-		msleep(20);
-	}
-
-	pr_info("%s exit\n", __func__);
-}
-
-static int test_klp_callbacks_busy_init(void)
-{
-	pr_info("%s\n", __func__);
-	schedule_work(&work);
-
-	/*
-	 * To synchronize kernel messages, hold the init function from
-	 * exiting until the work function's entry message has printed.
-	 */
-	wait_for_completion(&busymod_work_started);
-
-	if (!block_transition) {
-		/*
-		 * Serialize output: print all messages from the work
-		 * function before returning from init().
-		 */
-		flush_work(&work);
-	}
-
-	return 0;
-}
-
-static void test_klp_callbacks_busy_exit(void)
-{
-	WRITE_ONCE(block_transition, false);
-	flush_work(&work);
-	pr_info("%s\n", __func__);
-}
-
-module_init(test_klp_callbacks_busy_init);
-module_exit(test_klp_callbacks_busy_exit);
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Joe Lawrence <joe.lawrence@redhat.com>");
-MODULE_DESCRIPTION("Livepatch test: busy target module");
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo.c b/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo.c
deleted file mode 100644
index 3fd8fe1cd1cc..000000000000
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo.c
+++ /dev/null
@@ -1,121 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-// Copyright (C) 2018 Joe Lawrence <joe.lawrence@redhat.com>
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/livepatch.h>
-
-static int pre_patch_ret;
-module_param(pre_patch_ret, int, 0644);
-MODULE_PARM_DESC(pre_patch_ret, "pre_patch_ret (default=0)");
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
-/* Executed on object patching (ie, patch enablement) */
-static int pre_patch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
-	return pre_patch_ret;
-}
-
-/* Executed on object unpatching (ie, patch disablement) */
-static void post_patch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
-}
-
-/* Executed on object unpatching (ie, patch disablement) */
-static void pre_unpatch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
-}
-
-/* Executed on object unpatching (ie, patch disablement) */
-static void post_unpatch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
-}
-
-static void patched_work_func(struct work_struct *work)
-{
-	pr_info("%s\n", __func__);
-}
-
-static struct klp_func no_funcs[] = {
-	{}
-};
-
-static struct klp_func busymod_funcs[] = {
-	{
-		.old_name = "busymod_work_func",
-		.new_func = patched_work_func,
-	}, {}
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
-	},	{
-		.name = "test_klp_callbacks_mod",
-		.funcs = no_funcs,
-		.callbacks = {
-			.pre_patch = pre_patch_callback,
-			.post_patch = post_patch_callback,
-			.pre_unpatch = pre_unpatch_callback,
-			.post_unpatch = post_unpatch_callback,
-		},
-	},	{
-		.name = "test_klp_callbacks_busy",
-		.funcs = busymod_funcs,
-		.callbacks = {
-			.pre_patch = pre_patch_callback,
-			.post_patch = post_patch_callback,
-			.pre_unpatch = pre_unpatch_callback,
-			.post_unpatch = post_unpatch_callback,
-		},
-	}, { }
-};
-
-static struct klp_patch patch = {
-	.mod = THIS_MODULE,
-	.objs = objs,
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
-MODULE_AUTHOR("Joe Lawrence <joe.lawrence@redhat.com>");
-MODULE_DESCRIPTION("Livepatch test: livepatch demo");
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo2.c b/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo2.c
deleted file mode 100644
index 5417573e80af..000000000000
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_demo2.c
+++ /dev/null
@@ -1,93 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-// Copyright (C) 2018 Joe Lawrence <joe.lawrence@redhat.com>
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/livepatch.h>
-
-static int replace;
-module_param(replace, int, 0644);
-MODULE_PARM_DESC(replace, "replace (default=0)");
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
-/* Executed on object patching (ie, patch enablement) */
-static int pre_patch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
-	return 0;
-}
-
-/* Executed on object unpatching (ie, patch disablement) */
-static void post_patch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
-}
-
-/* Executed on object unpatching (ie, patch disablement) */
-static void pre_unpatch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
-}
-
-/* Executed on object unpatching (ie, patch disablement) */
-static void post_unpatch_callback(struct klp_object *obj)
-{
-	callback_info(__func__, obj);
-}
-
-static struct klp_func no_funcs[] = {
-	{ }
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
-static struct klp_patch patch = {
-	.mod = THIS_MODULE,
-	.objs = objs,
-	/* set .replace in the init function below for demo purposes */
-};
-
-static int test_klp_callbacks_demo2_init(void)
-{
-	patch.replace = replace;
-	return klp_enable_patch(&patch);
-}
-
-static void test_klp_callbacks_demo2_exit(void)
-{
-}
-
-module_init(test_klp_callbacks_demo2_init);
-module_exit(test_klp_callbacks_demo2_exit);
-MODULE_LICENSE("GPL");
-MODULE_INFO(livepatch, "Y");
-MODULE_AUTHOR("Joe Lawrence <joe.lawrence@redhat.com>");
-MODULE_DESCRIPTION("Livepatch test: livepatch demo2");
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_mod.c b/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_mod.c
deleted file mode 100644
index 8fbe645b1c2c..000000000000
--- a/tools/testing/selftests/livepatch/test_modules/test_klp_callbacks_mod.c
+++ /dev/null
@@ -1,24 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-// Copyright (C) 2018 Joe Lawrence <joe.lawrence@redhat.com>
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-
-static int test_klp_callbacks_mod_init(void)
-{
-	pr_info("%s\n", __func__);
-	return 0;
-}
-
-static void test_klp_callbacks_mod_exit(void)
-{
-	pr_info("%s\n", __func__);
-}
-
-module_init(test_klp_callbacks_mod_init);
-module_exit(test_klp_callbacks_mod_exit);
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Joe Lawrence <joe.lawrence@redhat.com>");
-MODULE_DESCRIPTION("Livepatch test: target module");
-- 
2.47.1


