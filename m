Return-Path: <live-patching+bounces-1358-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EE83AB1252
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 13:37:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9101A1C41E11
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 11:37:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 564E922F16E;
	Fri,  9 May 2025 11:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="1Fb1GzcD";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="O0YlHRfD"
X-Original-To: live-patching@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38B828F95E;
	Fri,  9 May 2025 11:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746790638; cv=none; b=METX9uGfioF2Cwmur1rKPRGTmUdls9SWgj3eb8eGUMrXhNbfapkiDqKgiZ1rNEcenk1x3FxPOJfi/bhBOrGU8thnS/sMGzivzrNJt5lTKCfmSvdHt0u38ZVPcWXDOoy3ruRcXN6ebglYDEPc1C+dxXqmYLB5TZLs1LogdYkmbGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746790638; c=relaxed/simple;
	bh=BMMKmsh7jALcR9d8p8pcOqhFrG9V0KdUnyt27YcWkZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NuHYrbbuTv2G+hztolHa39M3K57HlckVt/+R8dYTzNTPQKL4LCxwCkTV/Y5ptZQWO0pomtzgxN8fQMbUZ//JwDcemiptrCB8gJVDARkXd25r7VpdGzatNeb8fSXU3ZteFWRyuMZCpQYZGcHT1QVthS6wfrxzGZlqgfXgBax7uhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=1Fb1GzcD; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=O0YlHRfD; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Fri, 9 May 2025 13:36:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1746790627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yvtS7kd50QsaqELn/OuDxgR43pdbT8W33w5y3DGqq7Y=;
	b=1Fb1GzcDZId7FE75wc/vg9ARviSgbywT0LZwIKUKk8GsWuBqRznMD5bgSK9KPJ/uVjjnmJ
	+h7e5bgDpI/xnAEBHaIosjj3QecjQkdao2oSrd7U/A7SpZv7N+1p8yRlJJ9a6qrNZtQ3zZ
	3MzzyA+VRuMbPPAZv7RDbEZBYG/zU0bBB616zETOksqsAMEvwOVSapUw4M97ZWsa3m9zh6
	6+bo0lgOUf79M0mlTT8iD3epRCL1rsVnQgz26+FDCHtwCoZpH8rNHWc4bBLX2Ol8tqU46Y
	rCigUcfbeunXLBoK6Wqps3gSnTHkiIeG6u5lVAd2k9aE0OMTnVXuAWbjvaLpLw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1746790627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yvtS7kd50QsaqELn/OuDxgR43pdbT8W33w5y3DGqq7Y=;
	b=O0YlHRfDgQvzS3KYU1OSvvJ8dRJJ4a3nb4znxs06f5B/yNdYl/ZEEsLhNO4ObYhL+gcDGs
	EyxyYfe5EAGeHbCg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>, mingo@kernel.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, jpoimboe@kernel.org,
	jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
	joe.lawrence@redhat.com, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2] sched,livepatch: Untangle cond_resched() and live-patching
Message-ID: <20250509113659.wkP_HJ5z@linutronix.de>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Peter Zijlstra <peterz@infradead.org>

With the goal of deprecating / removing VOLUNTARY preempt, live-patch
needs to stop relying on cond_resched() to make forward progress.

Instead, rely on schedule() with TASK_FREEZABLE set. Just like
live-patching, the freezer needs to be able to stop tasks in a safe /
known state.

Compile tested only.

[bigeasy: use likely() in __klp_sched_try_switch() and update comments]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v1=E2=80=A6v2: https://lore.kernel.org/all/20250324134909.GA14718@noisy.pro=
gramming.kicks-ass.net/
  - Updated comments in __klp_sched_try_switch()
  - Replaced unlikely with likely in __klp_sched_try_switch()
  - Dropped RFC

 include/linux/livepatch_sched.h | 14 ++++-----
 include/linux/sched.h           |  6 ----
 kernel/livepatch/transition.c   | 52 ++++++++++-----------------------
 kernel/sched/core.c             | 50 +++++--------------------------
 4 files changed, 29 insertions(+), 93 deletions(-)

diff --git a/include/linux/livepatch_sched.h b/include/linux/livepatch_sche=
d.h
index 013794fb5da08..065c185f27638 100644
--- a/include/linux/livepatch_sched.h
+++ b/include/linux/livepatch_sched.h
@@ -3,27 +3,23 @@
 #define _LINUX_LIVEPATCH_SCHED_H_
=20
 #include <linux/jump_label.h>
-#include <linux/static_call_types.h>
+#include <linux/sched.h>
=20
 #ifdef CONFIG_LIVEPATCH
=20
 void __klp_sched_try_switch(void);
=20
-#if !defined(CONFIG_PREEMPT_DYNAMIC) || !defined(CONFIG_HAVE_PREEMPT_DYNAM=
IC_CALL)
-
 DECLARE_STATIC_KEY_FALSE(klp_sched_try_switch_key);
=20
-static __always_inline void klp_sched_try_switch(void)
+static __always_inline void klp_sched_try_switch(struct task_struct *curr)
 {
-	if (static_branch_unlikely(&klp_sched_try_switch_key))
+	if (static_branch_unlikely(&klp_sched_try_switch_key) &&
+	    READ_ONCE(curr->__state) & TASK_FREEZABLE)
 		__klp_sched_try_switch();
 }
=20
-#endif /* !CONFIG_PREEMPT_DYNAMIC || !CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
-
 #else /* !CONFIG_LIVEPATCH */
-static inline void klp_sched_try_switch(void) {}
-static inline void __klp_sched_try_switch(void) {}
+static inline void klp_sched_try_switch(struct task_struct *curr) {}
 #endif /* CONFIG_LIVEPATCH */
=20
 #endif /* _LINUX_LIVEPATCH_SCHED_H_ */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f96ac19828934..b98195991031c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -44,7 +44,6 @@
 #include <linux/seqlock_types.h>
 #include <linux/kcsan.h>
 #include <linux/rv.h>
-#include <linux/livepatch_sched.h>
 #include <linux/uidgid_types.h>
 #include <linux/tracepoint-defs.h>
 #include <asm/kmap_size.h>
@@ -2089,9 +2088,6 @@ extern int __cond_resched(void);
=20
 #if defined(CONFIG_PREEMPT_DYNAMIC) && defined(CONFIG_HAVE_PREEMPT_DYNAMIC=
_CALL)
=20
-void sched_dynamic_klp_enable(void);
-void sched_dynamic_klp_disable(void);
-
 DECLARE_STATIC_CALL(cond_resched, __cond_resched);
=20
 static __always_inline int _cond_resched(void)
@@ -2112,7 +2108,6 @@ static __always_inline int _cond_resched(void)
=20
 static inline int _cond_resched(void)
 {
-	klp_sched_try_switch();
 	return __cond_resched();
 }
=20
@@ -2122,7 +2117,6 @@ static inline int _cond_resched(void)
=20
 static inline int _cond_resched(void)
 {
-	klp_sched_try_switch();
 	return 0;
 }
=20
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index ba069459c1017..25b9372a4b66f 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -29,22 +29,13 @@ static unsigned int klp_signals_cnt;
=20
 /*
  * When a livepatch is in progress, enable klp stack checking in
- * cond_resched().  This helps CPU-bound kthreads get patched.
+ * schedule().  This helps CPU-bound kthreads get patched.
  */
-#if defined(CONFIG_PREEMPT_DYNAMIC) && defined(CONFIG_HAVE_PREEMPT_DYNAMIC=
_CALL)
-
-#define klp_cond_resched_enable() sched_dynamic_klp_enable()
-#define klp_cond_resched_disable() sched_dynamic_klp_disable()
-
-#else /* !CONFIG_PREEMPT_DYNAMIC || !CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
=20
 DEFINE_STATIC_KEY_FALSE(klp_sched_try_switch_key);
-EXPORT_SYMBOL(klp_sched_try_switch_key);
=20
-#define klp_cond_resched_enable() static_branch_enable(&klp_sched_try_swit=
ch_key)
-#define klp_cond_resched_disable() static_branch_disable(&klp_sched_try_sw=
itch_key)
-
-#endif /* CONFIG_PREEMPT_DYNAMIC && CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
+#define klp_resched_enable() static_branch_enable(&klp_sched_try_switch_ke=
y)
+#define klp_resched_disable() static_branch_disable(&klp_sched_try_switch_=
key)
=20
 /*
  * This work can be performed periodically to finish patching or unpatchin=
g any
@@ -365,27 +356,20 @@ static bool klp_try_switch_task(struct task_struct *t=
ask)
=20
 void __klp_sched_try_switch(void)
 {
+	/*
+	 * This function is called from __schedule() while a context switch is
+	 * about to happen. Preemption is already disabled and klp_mutex
+	 * can't be acquired.
+	 * Disabled preemption is used to prevent racing with other callers of
+	 * klp_try_switch_task(). Thanks to task_call_func() they won't be
+	 * able to switch to this task while it's running.
+	 */
+	lockdep_assert_preemption_disabled();
+
+	/* Make sure current didn't get patched */
 	if (likely(!klp_patch_pending(current)))
 		return;
=20
-	/*
-	 * This function is called from cond_resched() which is called in many
-	 * places throughout the kernel.  Using the klp_mutex here might
-	 * deadlock.
-	 *
-	 * Instead, disable preemption to prevent racing with other callers of
-	 * klp_try_switch_task().  Thanks to task_call_func() they won't be
-	 * able to switch this task while it's running.
-	 */
-	preempt_disable();
-
-	/*
-	 * Make sure current didn't get patched between the above check and
-	 * preempt_disable().
-	 */
-	if (unlikely(!klp_patch_pending(current)))
-		goto out;
-
 	/*
 	 * Enforce the order of the TIF_PATCH_PENDING read above and the
 	 * klp_target_state read in klp_try_switch_task().  The corresponding
@@ -395,11 +379,7 @@ void __klp_sched_try_switch(void)
 	smp_rmb();
=20
 	klp_try_switch_task(current);
-
-out:
-	preempt_enable();
 }
-EXPORT_SYMBOL(__klp_sched_try_switch);
=20
 /*
  * Sends a fake signal to all non-kthread tasks with TIF_PATCH_PENDING set.
@@ -508,7 +488,7 @@ void klp_try_complete_transition(void)
 	}
=20
 	/* Done!  Now cleanup the data structures. */
-	klp_cond_resched_disable();
+	klp_resched_disable();
 	patch =3D klp_transition_patch;
 	klp_complete_transition();
=20
@@ -560,7 +540,7 @@ void klp_start_transition(void)
 			set_tsk_thread_flag(task, TIF_PATCH_PENDING);
 	}
=20
-	klp_cond_resched_enable();
+	klp_resched_enable();
=20
 	klp_signals_cnt =3D 0;
 }
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c81cf642dba05..2a973d0e414a3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -66,6 +66,7 @@
 #include <linux/vtime.h>
 #include <linux/wait_api.h>
 #include <linux/workqueue_api.h>
+#include <linux/livepatch_sched.h>
=20
 #ifdef CONFIG_PREEMPT_DYNAMIC
 # ifdef CONFIG_GENERIC_ENTRY
@@ -6668,6 +6669,8 @@ static void __sched notrace __schedule(int sched_mode)
 	if (sched_feat(HRTICK) || sched_feat(HRTICK_DL))
 		hrtick_clear(rq);
=20
+	klp_sched_try_switch(prev);
+
 	local_irq_disable();
 	rcu_note_context_switch(preempt);
=20
@@ -7328,7 +7331,6 @@ EXPORT_STATIC_CALL_TRAMP(might_resched);
 static DEFINE_STATIC_KEY_FALSE(sk_dynamic_cond_resched);
 int __sched dynamic_cond_resched(void)
 {
-	klp_sched_try_switch();
 	if (!static_branch_unlikely(&sk_dynamic_cond_resched))
 		return 0;
 	return __cond_resched();
@@ -7500,7 +7502,6 @@ int sched_dynamic_mode(const char *str)
 #endif
=20
 static DEFINE_MUTEX(sched_dynamic_mutex);
-static bool klp_override;
=20
 static void __sched_dynamic_update(int mode)
 {
@@ -7508,8 +7509,7 @@ static void __sched_dynamic_update(int mode)
 	 * Avoid {NONE,VOLUNTARY} -> FULL transitions from ever ending up in
 	 * the ZERO state, which is invalid.
 	 */
-	if (!klp_override)
-		preempt_dynamic_enable(cond_resched);
+	preempt_dynamic_enable(cond_resched);
 	preempt_dynamic_enable(might_resched);
 	preempt_dynamic_enable(preempt_schedule);
 	preempt_dynamic_enable(preempt_schedule_notrace);
@@ -7518,8 +7518,7 @@ static void __sched_dynamic_update(int mode)
=20
 	switch (mode) {
 	case preempt_dynamic_none:
-		if (!klp_override)
-			preempt_dynamic_enable(cond_resched);
+		preempt_dynamic_enable(cond_resched);
 		preempt_dynamic_disable(might_resched);
 		preempt_dynamic_disable(preempt_schedule);
 		preempt_dynamic_disable(preempt_schedule_notrace);
@@ -7530,8 +7529,7 @@ static void __sched_dynamic_update(int mode)
 		break;
=20
 	case preempt_dynamic_voluntary:
-		if (!klp_override)
-			preempt_dynamic_enable(cond_resched);
+		preempt_dynamic_enable(cond_resched);
 		preempt_dynamic_enable(might_resched);
 		preempt_dynamic_disable(preempt_schedule);
 		preempt_dynamic_disable(preempt_schedule_notrace);
@@ -7542,8 +7540,7 @@ static void __sched_dynamic_update(int mode)
 		break;
=20
 	case preempt_dynamic_full:
-		if (!klp_override)
-			preempt_dynamic_disable(cond_resched);
+		preempt_dynamic_disable(cond_resched);
 		preempt_dynamic_disable(might_resched);
 		preempt_dynamic_enable(preempt_schedule);
 		preempt_dynamic_enable(preempt_schedule_notrace);
@@ -7554,8 +7551,7 @@ static void __sched_dynamic_update(int mode)
 		break;
=20
 	case preempt_dynamic_lazy:
-		if (!klp_override)
-			preempt_dynamic_disable(cond_resched);
+		preempt_dynamic_disable(cond_resched);
 		preempt_dynamic_disable(might_resched);
 		preempt_dynamic_enable(preempt_schedule);
 		preempt_dynamic_enable(preempt_schedule_notrace);
@@ -7576,36 +7572,6 @@ void sched_dynamic_update(int mode)
 	mutex_unlock(&sched_dynamic_mutex);
 }
=20
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
-	klp_override =3D true;
-	static_call_update(cond_resched, klp_cond_resched);
-
-	mutex_unlock(&sched_dynamic_mutex);
-}
-
-void sched_dynamic_klp_disable(void)
-{
-	mutex_lock(&sched_dynamic_mutex);
-
-	klp_override =3D false;
-	__sched_dynamic_update(preempt_dynamic_mode);
-
-	mutex_unlock(&sched_dynamic_mutex);
-}
-
-#endif /* CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
-
 static int __init setup_preempt_mode(char *str)
 {
 	int mode =3D sched_dynamic_mode(str);
--=20
2.49.0


