Return-Path: <live-patching+bounces-1318-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E79D7A6DBFE
	for <lists+live-patching@lfdr.de>; Mon, 24 Mar 2025 14:49:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B71316AD76
	for <lists+live-patching@lfdr.de>; Mon, 24 Mar 2025 13:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F7B1EDA31;
	Mon, 24 Mar 2025 13:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r7Vg8ZP+"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE67AFC0A;
	Mon, 24 Mar 2025 13:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742824160; cv=none; b=oJFpvY8vSwsyNfknbP9y7UsNt0paajG3aRDYLJ1wE/+y37e8UdISsrguO2mBC0cDaZexqzLvoqFKsb4UODDQfdKItKbi/ccKZzhKEXv1mGnS+aMxOx0nvkNuawRcnXXrDI7xx+blOJLekf9zjLKdZzyqNpOcCLXArC9ppkCEJKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742824160; c=relaxed/simple;
	bh=1d98LpnuRQzscRcy1wKUMiTv9IxQT2cYRvWeQYcatNE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=lQY6eiTnowU7nM6gjGjCQ2KBMshDgU5NMr0vuP+EBGEohlw69XVwKywZsAVEnNoQZW/i0QF9AR8nOZjndF5FZCJjoRqaVYcLa87cQ75zvp4RuNcoSxlXlbfEjP9brBZDE2RVNtdPoAm/7Z1sep5A8RZ6Z/R36B76kF/AxPAkbmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=r7Vg8ZP+; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=4aiGzvplkYDrIq2JaDrvyRz6Tq58zzawWVzsjC0w1dY=; b=r7Vg8ZP+LtdAp4GiZ/APeBC4gH
	GfRJ2mjcxKyeh6D1X/HbQ/qqAV9y9/sGSRZyUJL6CVQlPTt9/6fUCUuUGyKxnRT7eVV1vrT7yh6nO
	6mcCcWTNWLmFmWgEsBXHhhyJASgceADSftPYoNihZbZq7XcxE44x24N4xv1ZZ0zYEnd9pKYIJYUCg
	AZNdGYCWekjb1NXneDgg6m1x3oVkSbaSmJpEuUkw4wH+6RVyPIpCkCNnbaPh4A89ZZswXNe/9Gs/R
	spGb+aFnoNBss0msqdz3gBIEY8n5nPlu0ROVUn2g41fAOTW4whZzpt7gxDpgVK+aF2Op8x16R46ph
	S0hVh7SQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1twiAv-00000000kUw-2VGC;
	Mon, 24 Mar 2025 13:49:09 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 29C1F3004AF; Mon, 24 Mar 2025 14:49:09 +0100 (CET)
Date: Mon, 24 Mar 2025 14:49:09 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: mingo@kernel.com, peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, jpoimboe@kernel.org, jikos@kernel.org,
	mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com,
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [RFC][PATCH] sched,livepatch: Untangle cond_resched() and
 live-patching
Message-ID: <20250324134909.GA14718@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


With the goal of deprecating / removing VOLUNTARY preempt, live-patch
needs to stop relying on cond_resched() to make forward progress.

Instead, rely on schedule() with TASK_FREEZABLE set. Just like
live-patching, the freezer needs to be able to stop tasks in a safe /
known state.

Compile tested only.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/livepatch_sched.h | 15 +++++--------
 include/linux/sched.h           |  6 -----
 kernel/livepatch/transition.c   | 30 ++++++-------------------
 kernel/sched/core.c             | 50 +++++++----------------------------------
 4 files changed, 21 insertions(+), 80 deletions(-)

diff --git a/include/linux/livepatch_sched.h b/include/linux/livepatch_sched.h
index 013794fb5da0..7e8171226dd7 100644
--- a/include/linux/livepatch_sched.h
+++ b/include/linux/livepatch_sched.h
@@ -3,27 +3,24 @@
 #define _LINUX_LIVEPATCH_SCHED_H_
 
 #include <linux/jump_label.h>
-#include <linux/static_call_types.h>
+#include <linux/sched.h>
+
 
 #ifdef CONFIG_LIVEPATCH
 
 void __klp_sched_try_switch(void);
 
-#if !defined(CONFIG_PREEMPT_DYNAMIC) || !defined(CONFIG_HAVE_PREEMPT_DYNAMIC_CALL)
-
 DECLARE_STATIC_KEY_FALSE(klp_sched_try_switch_key);
 
-static __always_inline void klp_sched_try_switch(void)
+static __always_inline void klp_sched_try_switch(struct task_struct *curr)
 {
-	if (static_branch_unlikely(&klp_sched_try_switch_key))
+	if (static_branch_unlikely(&klp_sched_try_switch_key) &&
+	    READ_ONCE(curr->__state) & TASK_FREEZABLE)
 		__klp_sched_try_switch();
 }
 
-#endif /* !CONFIG_PREEMPT_DYNAMIC || !CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
-
 #else /* !CONFIG_LIVEPATCH */
-static inline void klp_sched_try_switch(void) {}
-static inline void __klp_sched_try_switch(void) {}
+static inline void klp_sched_try_switch(struct task_struct *curr) {}
 #endif /* CONFIG_LIVEPATCH */
 
 #endif /* _LINUX_LIVEPATCH_SCHED_H_ */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6e5c38718ff5..b988e1ae9bd9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -44,7 +44,6 @@
 #include <linux/seqlock_types.h>
 #include <linux/kcsan.h>
 #include <linux/rv.h>
-#include <linux/livepatch_sched.h>
 #include <linux/uidgid_types.h>
 #include <asm/kmap_size.h>
 
@@ -2069,9 +2068,6 @@ extern int __cond_resched(void);
 
 #if defined(CONFIG_PREEMPT_DYNAMIC) && defined(CONFIG_HAVE_PREEMPT_DYNAMIC_CALL)
 
-void sched_dynamic_klp_enable(void);
-void sched_dynamic_klp_disable(void);
-
 DECLARE_STATIC_CALL(cond_resched, __cond_resched);
 
 static __always_inline int _cond_resched(void)
@@ -2092,7 +2088,6 @@ static __always_inline int _cond_resched(void)
 
 static inline int _cond_resched(void)
 {
-	klp_sched_try_switch();
 	return __cond_resched();
 }
 
@@ -2102,7 +2097,6 @@ static inline int _cond_resched(void)
 
 static inline int _cond_resched(void)
 {
-	klp_sched_try_switch();
 	return 0;
 }
 
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index ba069459c101..2676c43642ff 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -29,22 +29,13 @@ static unsigned int klp_signals_cnt;
 
 /*
  * When a livepatch is in progress, enable klp stack checking in
- * cond_resched().  This helps CPU-bound kthreads get patched.
+ * schedule().  This helps CPU-bound kthreads get patched.
  */
-#if defined(CONFIG_PREEMPT_DYNAMIC) && defined(CONFIG_HAVE_PREEMPT_DYNAMIC_CALL)
-
-#define klp_cond_resched_enable() sched_dynamic_klp_enable()
-#define klp_cond_resched_disable() sched_dynamic_klp_disable()
-
-#else /* !CONFIG_PREEMPT_DYNAMIC || !CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
 
 DEFINE_STATIC_KEY_FALSE(klp_sched_try_switch_key);
-EXPORT_SYMBOL(klp_sched_try_switch_key);
 
-#define klp_cond_resched_enable() static_branch_enable(&klp_sched_try_switch_key)
-#define klp_cond_resched_disable() static_branch_disable(&klp_sched_try_switch_key)
-
-#endif /* CONFIG_PREEMPT_DYNAMIC && CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
+#define klp_resched_enable() static_branch_enable(&klp_sched_try_switch_key)
+#define klp_resched_disable() static_branch_disable(&klp_sched_try_switch_key)
 
 /*
  * This work can be performed periodically to finish patching or unpatching any
@@ -365,9 +356,6 @@ static bool klp_try_switch_task(struct task_struct *task)
 
 void __klp_sched_try_switch(void)
 {
-	if (likely(!klp_patch_pending(current)))
-		return;
-
 	/*
 	 * This function is called from cond_resched() which is called in many
 	 * places throughout the kernel.  Using the klp_mutex here might
@@ -377,14 +365,14 @@ void __klp_sched_try_switch(void)
 	 * klp_try_switch_task().  Thanks to task_call_func() they won't be
 	 * able to switch this task while it's running.
 	 */
-	preempt_disable();
+	lockdep_assert_preemption_disabled();
 
 	/*
 	 * Make sure current didn't get patched between the above check and
 	 * preempt_disable().
 	 */
 	if (unlikely(!klp_patch_pending(current)))
-		goto out;
+		return;
 
 	/*
 	 * Enforce the order of the TIF_PATCH_PENDING read above and the
@@ -395,11 +383,7 @@ void __klp_sched_try_switch(void)
 	smp_rmb();
 
 	klp_try_switch_task(current);
-
-out:
-	preempt_enable();
 }
-EXPORT_SYMBOL(__klp_sched_try_switch);
 
 /*
  * Sends a fake signal to all non-kthread tasks with TIF_PATCH_PENDING set.
@@ -508,7 +492,7 @@ void klp_try_complete_transition(void)
 	}
 
 	/* Done!  Now cleanup the data structures. */
-	klp_cond_resched_disable();
+	klp_resched_disable();
 	patch = klp_transition_patch;
 	klp_complete_transition();
 
@@ -560,7 +544,7 @@ void klp_start_transition(void)
 			set_tsk_thread_flag(task, TIF_PATCH_PENDING);
 	}
 
-	klp_cond_resched_enable();
+	klp_resched_enable();
 
 	klp_signals_cnt = 0;
 }
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4d617946d6e8..e6bfcdfb631e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -66,6 +66,7 @@
 #include <linux/vtime.h>
 #include <linux/wait_api.h>
 #include <linux/workqueue_api.h>
+#include <linux/livepatch_sched.h>
 
 #ifdef CONFIG_PREEMPT_DYNAMIC
 # ifdef CONFIG_GENERIC_ENTRY
@@ -6654,6 +6655,8 @@ static void __sched notrace __schedule(int sched_mode)
 	if (sched_feat(HRTICK) || sched_feat(HRTICK_DL))
 		hrtick_clear(rq);
 
+	klp_sched_try_switch(prev);
+
 	local_irq_disable();
 	rcu_note_context_switch(preempt);
 
@@ -7322,7 +7325,6 @@ EXPORT_STATIC_CALL_TRAMP(might_resched);
 static DEFINE_STATIC_KEY_FALSE(sk_dynamic_cond_resched);
 int __sched dynamic_cond_resched(void)
 {
-	klp_sched_try_switch();
 	if (!static_branch_unlikely(&sk_dynamic_cond_resched))
 		return 0;
 	return __cond_resched();
@@ -7494,7 +7496,6 @@ int sched_dynamic_mode(const char *str)
 #endif
 
 static DEFINE_MUTEX(sched_dynamic_mutex);
-static bool klp_override;
 
 static void __sched_dynamic_update(int mode)
 {
@@ -7502,8 +7503,7 @@ static void __sched_dynamic_update(int mode)
 	 * Avoid {NONE,VOLUNTARY} -> FULL transitions from ever ending up in
 	 * the ZERO state, which is invalid.
 	 */
-	if (!klp_override)
-		preempt_dynamic_enable(cond_resched);
+	preempt_dynamic_enable(cond_resched);
 	preempt_dynamic_enable(might_resched);
 	preempt_dynamic_enable(preempt_schedule);
 	preempt_dynamic_enable(preempt_schedule_notrace);
@@ -7512,8 +7512,7 @@ static void __sched_dynamic_update(int mode)
 
 	switch (mode) {
 	case preempt_dynamic_none:
-		if (!klp_override)
-			preempt_dynamic_enable(cond_resched);
+		preempt_dynamic_enable(cond_resched);
 		preempt_dynamic_disable(might_resched);
 		preempt_dynamic_disable(preempt_schedule);
 		preempt_dynamic_disable(preempt_schedule_notrace);
@@ -7524,8 +7523,7 @@ static void __sched_dynamic_update(int mode)
 		break;
 
 	case preempt_dynamic_voluntary:
-		if (!klp_override)
-			preempt_dynamic_enable(cond_resched);
+		preempt_dynamic_enable(cond_resched);
 		preempt_dynamic_enable(might_resched);
 		preempt_dynamic_disable(preempt_schedule);
 		preempt_dynamic_disable(preempt_schedule_notrace);
@@ -7536,8 +7534,7 @@ static void __sched_dynamic_update(int mode)
 		break;
 
 	case preempt_dynamic_full:
-		if (!klp_override)
-			preempt_dynamic_disable(cond_resched);
+		preempt_dynamic_disable(cond_resched);
 		preempt_dynamic_disable(might_resched);
 		preempt_dynamic_enable(preempt_schedule);
 		preempt_dynamic_enable(preempt_schedule_notrace);
@@ -7548,8 +7545,7 @@ static void __sched_dynamic_update(int mode)
 		break;
 
 	case preempt_dynamic_lazy:
-		if (!klp_override)
-			preempt_dynamic_disable(cond_resched);
+		preempt_dynamic_disable(cond_resched);
 		preempt_dynamic_disable(might_resched);
 		preempt_dynamic_enable(preempt_schedule);
 		preempt_dynamic_enable(preempt_schedule_notrace);
@@ -7570,36 +7566,6 @@ void sched_dynamic_update(int mode)
 	mutex_unlock(&sched_dynamic_mutex);
 }
 
-#ifdef CONFIG_HAVE_PREEMPT_DYNAMIC_CALL
-
-static int klp_cond_resched(void)
-{
-	__klp_sched_try_switch();
-	return __cond_resched();
-}
-
-void sched_dynamic_klp_enable(void)
-{
-	mutex_lock(&sched_dynamic_mutex);
-
-	klp_override = true;
-	static_call_update(cond_resched, klp_cond_resched);
-
-	mutex_unlock(&sched_dynamic_mutex);
-}
-
-void sched_dynamic_klp_disable(void)
-{
-	mutex_lock(&sched_dynamic_mutex);
-
-	klp_override = false;
-	__sched_dynamic_update(preempt_dynamic_mode);
-
-	mutex_unlock(&sched_dynamic_mutex);
-}
-
-#endif /* CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
-
 static int __init setup_preempt_mode(char *str)
 {
 	int mode = sched_dynamic_mode(str);

