Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B75F569111F
	for <lists+live-patching@lfdr.de>; Thu,  9 Feb 2023 20:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjBITSa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 Feb 2023 14:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjBITS2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 Feb 2023 14:18:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37BC4740B;
        Thu,  9 Feb 2023 11:18:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62C32B822DD;
        Thu,  9 Feb 2023 19:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C18BC433A1;
        Thu,  9 Feb 2023 19:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675970304;
        bh=o8e86Gia9Kjg1hPpDyFE9nyrHV0UHPjzeybmAA0GzcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=svNJRaRpYd1UGnt0oC85+oWqbza9F2b2trGpQdXIslSjOWQlnE04Q4xjsl9h+H9qa
         KM2AyGTPz1YeFAtbu48UguGDvnV5dZsBwOVw/fwBXueFRaIe444GCjgK12ypjkDw4G
         zAN0q4FziMg0fIoC9BqEcHn2pQ9Kjy1XK5MuhTO3rE4TiVkAi1DiTIJf4MSmtEvCfI
         duT9Ow0acOC8FpTOxuL/ShvIGUoipkZ7BDj7m9b8Eq2YoNKN0E0Ni9XCqGW1MEjKCo
         AXGiH6x0f7GwAPPFDMWE0DRVaiR6TbMTSMAENXG7CrWoAAGr+nuKqLhJ24JjEEUJle
         e35d9GYRpZ8mg==
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Seth Forshee <sforshee@digitalocean.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 2/3] livepatch,sched: Add livepatch task switching to cond_resched()
Date:   Thu,  9 Feb 2023 11:17:48 -0800
Message-Id: <58cd637f7557e829142a2eb255daa91fa57e6321.1675969869.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675969869.git.jpoimboe@kernel.org>
References: <cover.1675969869.git.jpoimboe@kernel.org>
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

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/livepatch.h       |  1 +
 include/linux/livepatch_sched.h | 29 +++++++++++++++
 include/linux/sched.h           | 20 ++++++++---
 kernel/livepatch/transition.c   | 54 ++++++++++++++++++++++++++++
 kernel/sched/core.c             | 64 ++++++++++++++++++++++++++++-----
 5 files changed, 155 insertions(+), 13 deletions(-)
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
index 4df2b3e76b30..2bc5e925a6d8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -36,6 +36,7 @@
 #include <linux/seqlock.h>
 #include <linux/kcsan.h>
 #include <linux/rv.h>
+#include <linux/livepatch_sched.h>
 #include <asm/kmap_size.h>
 
 /* task_struct member predeclarations (sorted alphabetically): */
@@ -2070,6 +2071,9 @@ extern int __cond_resched(void);
 
 #if defined(CONFIG_PREEMPT_DYNAMIC) && defined(CONFIG_HAVE_PREEMPT_DYNAMIC_CALL)
 
+void sched_dynamic_klp_enable(void);
+void sched_dynamic_klp_disable(void);
+
 DECLARE_STATIC_CALL(cond_resched, __cond_resched);
 
 static __always_inline int _cond_resched(void)
@@ -2078,6 +2082,7 @@ static __always_inline int _cond_resched(void)
 }
 
 #elif defined(CONFIG_PREEMPT_DYNAMIC) && defined(CONFIG_HAVE_PREEMPT_DYNAMIC_KEY)
+
 extern int dynamic_cond_resched(void);
 
 static __always_inline int _cond_resched(void)
@@ -2085,20 +2090,25 @@ static __always_inline int _cond_resched(void)
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
index 4d1f443778f7..e629966c6fbe 100644
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
@@ -76,6 +96,8 @@ static void klp_complete_transition(void)
 		 klp_transition_patch->mod->name,
 		 klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
 
+	klp_cond_resched_disable();
+
 	if (klp_transition_patch->replace && klp_target_state == KLP_PATCHED) {
 		klp_unpatch_replaced_patches(klp_transition_patch);
 		klp_discard_nops(klp_transition_patch);
@@ -338,6 +360,36 @@ static bool klp_try_switch_task(struct task_struct *task)
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
@@ -496,6 +548,8 @@ void klp_start_transition(void)
 			set_tsk_thread_flag(task, TIF_PATCH_PENDING);
 	}
 
+	klp_cond_resched_enable();
+
 	klp_signals_cnt = 0;
 }
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3a0ef2fefbd5..ed5bf5ec0477 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8500,6 +8500,7 @@ EXPORT_STATIC_CALL_TRAMP(might_resched);
 static DEFINE_STATIC_KEY_FALSE(sk_dynamic_cond_resched);
 int __sched dynamic_cond_resched(void)
 {
+	klp_sched_try_switch();
 	if (!static_branch_unlikely(&sk_dynamic_cond_resched))
 		return 0;
 	return __cond_resched();
@@ -8648,13 +8649,17 @@ int sched_dynamic_mode(const char *str)
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
@@ -8662,36 +8667,79 @@ void sched_dynamic_update(int mode)
 
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
2.39.0

