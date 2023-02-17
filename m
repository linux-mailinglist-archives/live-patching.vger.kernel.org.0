Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2147069B578
	for <lists+live-patching@lfdr.de>; Fri, 17 Feb 2023 23:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjBQWYA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Feb 2023 17:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjBQWXE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Feb 2023 17:23:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C9E5D3ED;
        Fri, 17 Feb 2023 14:23:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24F09B82E60;
        Fri, 17 Feb 2023 22:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585ADC433AA;
        Fri, 17 Feb 2023 22:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676672579;
        bh=frILY3UK6CEIkeNVu4J9ZM0FyGlw0e5p8pr6LM4L8HQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GbX8duAXVXhM9FXOSJEecIPBcSioMYZ7uogUH9EnFvIRXZWyHUONEY1oJ1hNunUqn
         QoOXyet8BR5TUmQ5ubbbnRblo+qgHScZ5lVgvgIqnSEZP57zwmr8Q9NTHQdtUMlWci
         pjdXYZXRnV1Q3v+Tz90AZ8CK1cg9mo5t7w/XVlIPt9HCwZ0ihbbXD6DRR5CGX2FZwX
         mmcY6Dp9qrIJCsGdbctVafWxlhJ76lxWxH3QxgG5hpAXvxneFSc7gggQ0Od1UPVN1e
         ihfUymM4Z1WtmcpWMr7SNHZFUYwveDMy76g2RjYOEe08PrwiJbFvIZh3apf1k/jiUG
         8anXXEzYvMtAA==
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Seth Forshee <sforshee@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@surriel.com>
Subject: [PATCH v2 2/3] livepatch,sched: Add livepatch task switching to cond_resched()
Date:   Fri, 17 Feb 2023 14:22:55 -0800
Message-Id: <9f09bff809fc026618108e8bbaac67ef2f8e6d3d.1676672328.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1676672328.git.jpoimboe@kernel.org>
References: <cover.1676672328.git.jpoimboe@kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

There have been reports [1][2] of live patches failing to complete
within a reasonable amount of time due to CPU-bound kthreads.

Fix it by patching tasks in cond_resched().

There are four different flavors of cond_resched(), depending on the
kernel configuration.  Hook into all of them.

A more elegant solution might be to use a preempt notifier.  However,
non-ORC unwinders can't unwind a preempted task reliably.

[1] https://lore.kernel.org/lkml/20220507174628.2086373-1-song@kernel.org/
[2] https://lkml.kernel.org/lkml/20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org

Tested-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/livepatch.h       |  1 +
 include/linux/livepatch_sched.h | 29 ++++++++++++
 include/linux/sched.h           | 20 ++++++---
 kernel/livepatch/transition.c   | 78 ++++++++++++++++++++++++++++-----
 kernel/sched/core.c             | 64 +++++++++++++++++++++++----
 5 files changed, 168 insertions(+), 24 deletions(-)
 create mode 100644 include/linux/livepatch_sched.h

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 293e29960c6e..9b9b38e89563 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -13,6 +13,7 @@
 #include <linux/ftrace.h>
 #include <linux/completion.h>
 #include <linux/list.h>
+#include <linux/livepatch_sched.h>
 
 #if IS_ENABLED(CONFIG_LIVEPATCH)
 
diff --git a/include/linux/livepatch_sched.h b/include/linux/livepatch_sched.h
new file mode 100644
index 000000000000..013794fb5da0
--- /dev/null
+++ b/include/linux/livepatch_sched.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _LINUX_LIVEPATCH_SCHED_H_
+#define _LINUX_LIVEPATCH_SCHED_H_
+
+#include <linux/jump_label.h>
+#include <linux/static_call_types.h>
+
+#ifdef CONFIG_LIVEPATCH
+
+void __klp_sched_try_switch(void);
+
+#if !defined(CONFIG_PREEMPT_DYNAMIC) || !defined(CONFIG_HAVE_PREEMPT_DYNAMIC_CALL)
+
+DECLARE_STATIC_KEY_FALSE(klp_sched_try_switch_key);
+
+static __always_inline void klp_sched_try_switch(void)
+{
+	if (static_branch_unlikely(&klp_sched_try_switch_key))
+		__klp_sched_try_switch();
+}
+
+#endif /* !CONFIG_PREEMPT_DYNAMIC || !CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
+
+#else /* !CONFIG_LIVEPATCH */
+static inline void klp_sched_try_switch(void) {}
+static inline void __klp_sched_try_switch(void) {}
+#endif /* CONFIG_LIVEPATCH */
+
+#endif /* _LINUX_LIVEPATCH_SCHED_H_ */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 853d08f7562b..bd1e6f02facb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -36,6 +36,7 @@
 #include <linux/seqlock.h>
 #include <linux/kcsan.h>
 #include <linux/rv.h>
+#include <linux/livepatch_sched.h>
 #include <asm/kmap_size.h>
 
 /* task_struct member predeclarations (sorted alphabetically): */
@@ -2064,6 +2065,9 @@ extern int __cond_resched(void);
 
 #if defined(CONFIG_PREEMPT_DYNAMIC) && defined(CONFIG_HAVE_PREEMPT_DYNAMIC_CALL)
 
+void sched_dynamic_klp_enable(void);
+void sched_dynamic_klp_disable(void);
+
 DECLARE_STATIC_CALL(cond_resched, __cond_resched);
 
 static __always_inline int _cond_resched(void)
@@ -2072,6 +2076,7 @@ static __always_inline int _cond_resched(void)
 }
 
 #elif defined(CONFIG_PREEMPT_DYNAMIC) && defined(CONFIG_HAVE_PREEMPT_DYNAMIC_KEY)
+
 extern int dynamic_cond_resched(void);
 
 static __always_inline int _cond_resched(void)
@@ -2079,20 +2084,25 @@ static __always_inline int _cond_resched(void)
 	return dynamic_cond_resched();
 }
 
-#else
+#else /* !CONFIG_PREEMPTION */
 
 static inline int _cond_resched(void)
 {
+	klp_sched_try_switch();
 	return __cond_resched();
 }
 
-#endif /* CONFIG_PREEMPT_DYNAMIC */
+#endif /* PREEMPT_DYNAMIC && CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
 
-#else
+#else /* CONFIG_PREEMPTION && !CONFIG_PREEMPT_DYNAMIC */
 
-static inline int _cond_resched(void) { return 0; }
+static inline int _cond_resched(void)
+{
+	klp_sched_try_switch();
+	return 0;
+}
 
-#endif /* !defined(CONFIG_PREEMPTION) || defined(CONFIG_PREEMPT_DYNAMIC) */
+#endif /* !CONFIG_PREEMPTION || CONFIG_PREEMPT_DYNAMIC */
 
 #define cond_resched() ({			\
 	__might_resched(__FILE__, __LINE__, 0);	\
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 4d1f443778f7..b9e006632124 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -9,6 +9,7 @@
 
 #include <linux/cpu.h>
 #include <linux/stacktrace.h>
+#include <linux/static_call.h>
 #include "core.h"
 #include "patch.h"
 #include "transition.h"
@@ -24,6 +25,25 @@ static int klp_target_state = KLP_UNDEFINED;
 
 static unsigned int klp_signals_cnt;
 
+/*
+ * When a livepatch is in progress, enable klp stack checking in
+ * cond_resched().  This helps CPU-bound kthreads get patched.
+ */
+#if defined(CONFIG_PREEMPT_DYNAMIC) && defined(CONFIG_HAVE_PREEMPT_DYNAMIC_CALL)
+
+#define klp_cond_resched_enable() sched_dynamic_klp_enable()
+#define klp_cond_resched_disable() sched_dynamic_klp_disable()
+
+#else /* !CONFIG_PREEMPT_DYNAMIC || !CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
+
+DEFINE_STATIC_KEY_FALSE(klp_sched_try_switch_key);
+EXPORT_SYMBOL(klp_sched_try_switch_key);
+
+#define klp_cond_resched_enable() static_branch_enable(&klp_sched_try_switch_key)
+#define klp_cond_resched_disable() static_branch_disable(&klp_sched_try_switch_key)
+
+#endif /* CONFIG_PREEMPT_DYNAMIC && CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
+
 /*
  * This work can be performed periodically to finish patching or unpatching any
  * "straggler" tasks which failed to transition in the first attempt.
@@ -338,6 +358,36 @@ static bool klp_try_switch_task(struct task_struct *task)
 	return !ret;
 }
 
+void __klp_sched_try_switch(void)
+{
+	if (likely(!klp_patch_pending(current)))
+		return;
+
+	/*
+	 * This function is called from cond_resched() which is called in many
+	 * places throughout the kernel.  Using the klp_mutex here might
+	 * deadlock.
+	 *
+	 * Instead, disable preemption to prevent racing with other callers of
+	 * klp_try_switch_task().  Thanks to task_call_func() they won't be
+	 * able to switch this task while it's running.
+	 */
+	preempt_disable();
+
+	/*
+	 * Make sure current didn't get patched between the above check and
+	 * preempt_disable().
+	 */
+	if (unlikely(!klp_patch_pending(current)))
+		goto out;
+
+	klp_try_switch_task(current);
+
+out:
+	preempt_enable();
+}
+EXPORT_SYMBOL(__klp_sched_try_switch);
+
 /*
  * Sends a fake signal to all non-kthread tasks with TIF_PATCH_PENDING set.
  * Kthreads with TIF_PATCH_PENDING set are woken up.
@@ -444,7 +494,8 @@ void klp_try_complete_transition(void)
 		return;
 	}
 
-	/* we're done, now cleanup the data structures */
+	/* Done!  Now cleanup the data structures. */
+	klp_cond_resched_disable();
 	patch = klp_transition_patch;
 	klp_complete_transition();
 
@@ -496,6 +547,8 @@ void klp_start_transition(void)
 			set_tsk_thread_flag(task, TIF_PATCH_PENDING);
 	}
 
+	klp_cond_resched_enable();
+
 	klp_signals_cnt = 0;
 }
 
@@ -588,14 +641,10 @@ void klp_reverse_transition(void)
 		 klp_target_state == KLP_PATCHED ? "patching to unpatching" :
 						   "unpatching to patching");
 
-	klp_transition_patch->enabled = !klp_transition_patch->enabled;
-
-	klp_target_state = !klp_target_state;
-
 	/*
 	 * Clear all TIF_PATCH_PENDING flags to prevent races caused by
-	 * klp_update_patch_state() running in parallel with
-	 * klp_start_transition().
+	 * klp_update_patch_state() or __klp_sched_try_switch() running in
+	 * parallel with the reverse transition.
 	 */
 	read_lock(&tasklist_lock);
 	for_each_process_thread(g, task)
@@ -605,9 +654,16 @@ void klp_reverse_transition(void)
 	for_each_possible_cpu(cpu)
 		clear_tsk_thread_flag(idle_task(cpu), TIF_PATCH_PENDING);
 
-	/* Let any remaining calls to klp_update_patch_state() complete */
+	/*
+	 * Make sure all existing invocations of klp_update_patch_state() and
+	 * __klp_sched_try_switch() see the cleared TIF_PATCH_PENDING before
+	 * starting the reverse transition.
+	 */
 	klp_synchronize_transition();
 
+	/* All patching has stopped, now start the reverse transition. */
+	klp_transition_patch->enabled = !klp_transition_patch->enabled;
+	klp_target_state = !klp_target_state;
 	klp_start_transition();
 }
 
@@ -621,9 +677,9 @@ void klp_copy_process(struct task_struct *child)
 	 * the task flag up to date with the parent here.
 	 *
 	 * The operation is serialized against all klp_*_transition()
-	 * operations by the tasklist_lock. The only exception is
-	 * klp_update_patch_state(current), but we cannot race with
-	 * that because we are current.
+	 * operations by the tasklist_lock. The only exceptions are
+	 * klp_update_patch_state(current) and __klp_sched_try_switch(), but we
+	 * cannot race with them because we are current.
 	 */
 	if (test_tsk_thread_flag(current, TIF_PATCH_PENDING))
 		set_tsk_thread_flag(child, TIF_PATCH_PENDING);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e838feb6adc5..895d2a1fdcb3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8487,6 +8487,7 @@ EXPORT_STATIC_CALL_TRAMP(might_resched);
 static DEFINE_STATIC_KEY_FALSE(sk_dynamic_cond_resched);
 int __sched dynamic_cond_resched(void)
 {
+	klp_sched_try_switch();
 	if (!static_branch_unlikely(&sk_dynamic_cond_resched))
 		return 0;
 	return __cond_resched();
@@ -8635,13 +8636,17 @@ int sched_dynamic_mode(const char *str)
 #error "Unsupported PREEMPT_DYNAMIC mechanism"
 #endif
 
-void sched_dynamic_update(int mode)
+DEFINE_MUTEX(sched_dynamic_mutex);
+static bool klp_override;
+
+static void __sched_dynamic_update(int mode)
 {
 	/*
 	 * Avoid {NONE,VOLUNTARY} -> FULL transitions from ever ending up in
 	 * the ZERO state, which is invalid.
 	 */
-	preempt_dynamic_enable(cond_resched);
+	if (!klp_override)
+		preempt_dynamic_enable(cond_resched);
 	preempt_dynamic_enable(might_resched);
 	preempt_dynamic_enable(preempt_schedule);
 	preempt_dynamic_enable(preempt_schedule_notrace);
@@ -8649,36 +8654,79 @@ void sched_dynamic_update(int mode)
 
 	switch (mode) {
 	case preempt_dynamic_none:
-		preempt_dynamic_enable(cond_resched);
+		if (!klp_override)
+			preempt_dynamic_enable(cond_resched);
 		preempt_dynamic_disable(might_resched);
 		preempt_dynamic_disable(preempt_schedule);
 		preempt_dynamic_disable(preempt_schedule_notrace);
 		preempt_dynamic_disable(irqentry_exit_cond_resched);
-		pr_info("Dynamic Preempt: none\n");
+		if (mode != preempt_dynamic_mode)
+			pr_info("Dynamic Preempt: none\n");
 		break;
 
 	case preempt_dynamic_voluntary:
-		preempt_dynamic_enable(cond_resched);
+		if (!klp_override)
+			preempt_dynamic_enable(cond_resched);
 		preempt_dynamic_enable(might_resched);
 		preempt_dynamic_disable(preempt_schedule);
 		preempt_dynamic_disable(preempt_schedule_notrace);
 		preempt_dynamic_disable(irqentry_exit_cond_resched);
-		pr_info("Dynamic Preempt: voluntary\n");
+		if (mode != preempt_dynamic_mode)
+			pr_info("Dynamic Preempt: voluntary\n");
 		break;
 
 	case preempt_dynamic_full:
-		preempt_dynamic_disable(cond_resched);
+		if (!klp_override)
+			preempt_dynamic_disable(cond_resched);
 		preempt_dynamic_disable(might_resched);
 		preempt_dynamic_enable(preempt_schedule);
 		preempt_dynamic_enable(preempt_schedule_notrace);
 		preempt_dynamic_enable(irqentry_exit_cond_resched);
-		pr_info("Dynamic Preempt: full\n");
+		if (mode != preempt_dynamic_mode)
+			pr_info("Dynamic Preempt: full\n");
 		break;
 	}
 
 	preempt_dynamic_mode = mode;
 }
 
+void sched_dynamic_update(int mode)
+{
+	mutex_lock(&sched_dynamic_mutex);
+	__sched_dynamic_update(mode);
+	mutex_unlock(&sched_dynamic_mutex);
+}
+
+#ifdef CONFIG_HAVE_PREEMPT_DYNAMIC_CALL
+
+static int klp_cond_resched(void)
+{
+	__klp_sched_try_switch();
+	return __cond_resched();
+}
+
+void sched_dynamic_klp_enable(void)
+{
+	mutex_lock(&sched_dynamic_mutex);
+
+	klp_override = true;
+	static_call_update(cond_resched, klp_cond_resched);
+
+	mutex_unlock(&sched_dynamic_mutex);
+}
+
+void sched_dynamic_klp_disable(void)
+{
+	mutex_lock(&sched_dynamic_mutex);
+
+	klp_override = false;
+	__sched_dynamic_update(preempt_dynamic_mode);
+
+	mutex_unlock(&sched_dynamic_mutex);
+}
+
+#endif /* CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
+
 static int __init setup_preempt_mode(char *str)
 {
 	int mode = sched_dynamic_mode(str);
-- 
2.39.1

