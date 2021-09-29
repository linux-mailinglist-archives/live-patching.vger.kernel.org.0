Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D4541C8F1
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 17:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345706AbhI2QAU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 12:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344259AbhI2P7n (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 11:59:43 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68525C06161C;
        Wed, 29 Sep 2021 08:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=7hFoPhVK9o3al4yWkllM1E7fyT6IYmRYSVXt8hFIWh0=; b=gGwoAh8fwgIFZWtGZACw3tSM3p
        09TnSYx06e2qFU34QZ/Hlq0XFLOZzxt+VqEEIqflLZYbQgmxQrt1yZBb9HX6z4i+fx9UNR2Cb8Z5I
        uMwcyRRDkPqpqzDgYKmN3dee17ZpXroxgEnrwNEm5E41w7E07yjkL8VDPJKg2CDBuDRBqRECZRgdG
        aIIhW0QOTcjHSttt8T1oRPg1eNzklnII/165PorWpjef2bgDDjDdWuaXdDL7LPEi4KoAKWDWXZKW6
        ZzVH3gcwQ3nRMB3AAiu0Ch8xDnECUl/QPXlZ8F8S3ffxvNYdXmahSIbGbwwfZ0xDG9vljdIGZE1wZ
        +ThNM4LQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVbxj-006jos-Bf; Wed, 29 Sep 2021 15:57:39 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CF607302A12;
        Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 416562C905DA2; Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Message-ID: <20210929152429.007420590@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 29 Sep 2021 17:17:31 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: [RFC][PATCH v2 08/11] context_tracking,rcu: Replace RCU dynticks counter with context_tracking
References: <20210929151723.162004989@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

XXX I'm pretty sure I broke task-trace-rcu.
XXX trace_rcu_*() now gets an unconditional 0

Other than that, it seems like a fairly straight-forward replacement
of the RCU count with the context_tracking count.

Using context-tracking for this avoids having two (expensive) atomic
ops on the entry paths where one will do.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/context_tracking.h |    6 ++
 kernel/context_tracking.c        |   14 +++++
 kernel/rcu/tree.c                |  101 +++++----------------------------------
 kernel/rcu/tree.h                |    1 
 4 files changed, 33 insertions(+), 89 deletions(-)

--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -50,6 +50,9 @@ extern void context_tracking_user_exit(v
 
 extern bool context_tracking_set_cpu_work(unsigned int cpu, unsigned int work);
 
+extern void context_tracking_idle(void);
+extern void context_tracking_online(void);
+
 static inline void ct_user_enter(void)
 {
 	if (context_tracking_enabled())
@@ -162,6 +165,9 @@ static __always_inline unsigned int __co
 	return 0;
 }
 
+static inline void context_tracking_idle(void) { }
+static inline void context_tracking_online(void) { }
+
 #endif /* !CONFIG_CONTEXT_TRACKING */
 
 static __always_inline bool context_tracking_cpu_in_user(unsigned int cpu)
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -281,6 +281,20 @@ void noinstr __context_tracking_nmi_exit
 		ct_seq_nmi_exit(raw_cpu_ptr(&context_tracking));
 }
 
+void context_tracking_online(void)
+{
+	struct context_tracking *ct = raw_cpu_ptr(&context_tracking);
+	unsigned int seq = atomic_read(&ct->seq);
+
+	if (__context_tracking_seq_in_user(seq))
+		atomic_add_return(CT_SEQ - CT_SEQ_USER, &ct->seq);
+}
+
+void context_tracking_idle(void)
+{
+	atomic_add_return(CT_SEQ, &raw_cpu_ptr(&context_tracking)->seq);
+}
+
 void __init context_tracking_cpu_set(int cpu)
 {
 	static __initdata bool initialized = false;
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -62,6 +62,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/kasan.h>
+#include <linux/context_tracking.h>
 #include "../time/tick-internal.h"
 
 #include "tree.h"
@@ -77,7 +78,6 @@
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_data, rcu_data) = {
 	.dynticks_nesting = 1,
 	.dynticks_nmi_nesting = DYNTICK_IRQ_NONIDLE,
-	.dynticks = ATOMIC_INIT(1),
 #ifdef CONFIG_RCU_NOCB_CPU
 	.cblist.flags = SEGCBLIST_SOFTIRQ_ONLY,
 #endif
@@ -252,56 +252,6 @@ void rcu_softirq_qs(void)
 }
 
 /*
- * Increment the current CPU's rcu_data structure's ->dynticks field
- * with ordering.  Return the new value.
- */
-static noinline noinstr unsigned long rcu_dynticks_inc(int incby)
-{
-	return arch_atomic_add_return(incby, this_cpu_ptr(&rcu_data.dynticks));
-}
-
-/*
- * Record entry into an extended quiescent state.  This is only to be
- * called when not already in an extended quiescent state, that is,
- * RCU is watching prior to the call to this function and is no longer
- * watching upon return.
- */
-static noinstr void rcu_dynticks_eqs_enter(void)
-{
-	int seq;
-
-	/*
-	 * CPUs seeing atomic_add_return() must see prior RCU read-side
-	 * critical sections, and we also must force ordering with the
-	 * next idle sojourn.
-	 */
-	rcu_dynticks_task_trace_enter();  // Before ->dynticks update!
-	seq = rcu_dynticks_inc(1);
-	// RCU is no longer watching.  Better be in extended quiescent state!
-	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && (seq & 0x1));
-}
-
-/*
- * Record exit from an extended quiescent state.  This is only to be
- * called from an extended quiescent state, that is, RCU is not watching
- * prior to the call to this function and is watching upon return.
- */
-static noinstr void rcu_dynticks_eqs_exit(void)
-{
-	int seq;
-
-	/*
-	 * CPUs seeing atomic_add_return() must see prior idle sojourns,
-	 * and we also must force ordering with the next RCU read-side
-	 * critical section.
-	 */
-	seq = rcu_dynticks_inc(1);
-	// RCU is now watching.  Better not be in an extended quiescent state!
-	rcu_dynticks_task_trace_exit();  // After ->dynticks update!
-	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !(seq & 0x1));
-}
-
-/*
  * Reset the current CPU's ->dynticks counter to indicate that the
  * newly onlined CPU is no longer in an extended quiescent state.
  * This will either leave the counter unchanged, or increment it
@@ -313,11 +263,7 @@ static noinstr void rcu_dynticks_eqs_exi
  */
 static void rcu_dynticks_eqs_online(void)
 {
-	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
-
-	if (atomic_read(&rdp->dynticks) & 0x1)
-		return;
-	rcu_dynticks_inc(1);
+	context_tracking_online();
 }
 
 /*
@@ -327,7 +273,7 @@ static void rcu_dynticks_eqs_online(void
  */
 static __always_inline bool rcu_dynticks_curr_cpu_in_eqs(void)
 {
-	return !(atomic_read(this_cpu_ptr(&rcu_data.dynticks)) & 0x1);
+	return context_tracking_cpu_in_user(smp_processor_id());
 }
 
 /*
@@ -337,7 +283,7 @@ static __always_inline bool rcu_dynticks
 static int rcu_dynticks_snap(struct rcu_data *rdp)
 {
 	smp_mb();  // Fundamental RCU ordering guarantee.
-	return atomic_read_acquire(&rdp->dynticks);
+	return __context_tracking_cpu_seq(rdp->cpu);
 }
 
 /*
@@ -346,7 +292,7 @@ static int rcu_dynticks_snap(struct rcu_
  */
 static bool rcu_dynticks_in_eqs(int snap)
 {
-	return !(snap & 0x1);
+	return __context_tracking_seq_in_user(snap);
 }
 
 /* Return true if the specified CPU is currently idle from an RCU viewpoint.  */
@@ -377,7 +323,7 @@ bool rcu_dynticks_zero_in_eqs(int cpu, i
 	int snap;
 
 	// If not quiescent, force back to earlier extended quiescent state.
-	snap = atomic_read(&rdp->dynticks) & ~0x1;
+	snap = __context_tracking_cpu_seq(rdp->cpu) & ~0x7;
 
 	smp_rmb(); // Order ->dynticks and *vp reads.
 	if (READ_ONCE(*vp))
@@ -385,7 +331,7 @@ bool rcu_dynticks_zero_in_eqs(int cpu, i
 	smp_rmb(); // Order *vp read and ->dynticks re-read.
 
 	// If still in the same extended quiescent state, we are good!
-	return snap == atomic_read(&rdp->dynticks);
+	return snap == __context_tracking_cpu_seq(rdp->cpu);
 }
 
 /*
@@ -401,12 +347,8 @@ bool rcu_dynticks_zero_in_eqs(int cpu, i
  */
 notrace void rcu_momentary_dyntick_idle(void)
 {
-	int seq;
-
 	raw_cpu_write(rcu_data.rcu_need_heavy_qs, false);
-	seq = rcu_dynticks_inc(2);
-	/* It is illegal to call this from idle state. */
-	WARN_ON_ONCE(!(seq & 0x1));
+	context_tracking_idle();
 	rcu_preempt_deferred_qs(current);
 }
 EXPORT_SYMBOL_GPL(rcu_momentary_dyntick_idle);
@@ -622,18 +564,15 @@ static noinstr void rcu_eqs_enter(bool u
 
 	lockdep_assert_irqs_disabled();
 	instrumentation_begin();
-	trace_rcu_dyntick(TPS("Start"), rdp->dynticks_nesting, 0, atomic_read(&rdp->dynticks));
+	trace_rcu_dyntick(TPS("Start"), rdp->dynticks_nesting, 0, 0);
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
 	rcu_prepare_for_idle();
 	rcu_preempt_deferred_qs(current);
 
-	// instrumentation for the noinstr rcu_dynticks_eqs_enter()
-	instrument_atomic_write(&rdp->dynticks, sizeof(rdp->dynticks));
 
 	instrumentation_end();
 	WRITE_ONCE(rdp->dynticks_nesting, 0); /* Avoid irq-access tearing. */
 	// RCU is watching here ...
-	rcu_dynticks_eqs_enter();
 	// ... but is no longer watching here.
 	rcu_dynticks_task_enter();
 }
@@ -756,8 +695,7 @@ noinstr void rcu_nmi_exit(void)
 	 * leave it in non-RCU-idle state.
 	 */
 	if (rdp->dynticks_nmi_nesting != 1) {
-		trace_rcu_dyntick(TPS("--="), rdp->dynticks_nmi_nesting, rdp->dynticks_nmi_nesting - 2,
-				  atomic_read(&rdp->dynticks));
+		trace_rcu_dyntick(TPS("--="), rdp->dynticks_nmi_nesting, rdp->dynticks_nmi_nesting - 2, 0);
 		WRITE_ONCE(rdp->dynticks_nmi_nesting, /* No store tearing. */
 			   rdp->dynticks_nmi_nesting - 2);
 		instrumentation_end();
@@ -765,18 +703,15 @@ noinstr void rcu_nmi_exit(void)
 	}
 
 	/* This NMI interrupted an RCU-idle CPU, restore RCU-idleness. */
-	trace_rcu_dyntick(TPS("Startirq"), rdp->dynticks_nmi_nesting, 0, atomic_read(&rdp->dynticks));
+	trace_rcu_dyntick(TPS("Startirq"), rdp->dynticks_nmi_nesting, 0, 0);
 	WRITE_ONCE(rdp->dynticks_nmi_nesting, 0); /* Avoid store tearing. */
 
 	if (!in_nmi())
 		rcu_prepare_for_idle();
 
-	// instrumentation for the noinstr rcu_dynticks_eqs_enter()
-	instrument_atomic_write(&rdp->dynticks, sizeof(rdp->dynticks));
 	instrumentation_end();
 
 	// RCU is watching here ...
-	rcu_dynticks_eqs_enter();
 	// ... but is no longer watching here.
 
 	if (!in_nmi())
@@ -865,15 +800,11 @@ static void noinstr rcu_eqs_exit(bool us
 	}
 	rcu_dynticks_task_exit();
 	// RCU is not watching here ...
-	rcu_dynticks_eqs_exit();
 	// ... but is watching here.
 	instrumentation_begin();
 
-	// instrumentation for the noinstr rcu_dynticks_eqs_exit()
-	instrument_atomic_write(&rdp->dynticks, sizeof(rdp->dynticks));
-
 	rcu_cleanup_after_idle();
-	trace_rcu_dyntick(TPS("End"), rdp->dynticks_nesting, 1, atomic_read(&rdp->dynticks));
+	trace_rcu_dyntick(TPS("End"), rdp->dynticks_nesting, 1, 0);
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !user && !is_idle_task(current));
 	WRITE_ONCE(rdp->dynticks_nesting, 1);
 	WARN_ON_ONCE(rdp->dynticks_nmi_nesting);
@@ -1011,7 +942,6 @@ noinstr void rcu_nmi_enter(void)
 			rcu_dynticks_task_exit();
 
 		// RCU is not watching here ...
-		rcu_dynticks_eqs_exit();
 		// ... but is watching here.
 
 		if (!in_nmi()) {
@@ -1021,11 +951,6 @@ noinstr void rcu_nmi_enter(void)
 		}
 
 		instrumentation_begin();
-		// instrumentation for the noinstr rcu_dynticks_curr_cpu_in_eqs()
-		instrument_atomic_read(&rdp->dynticks, sizeof(rdp->dynticks));
-		// instrumentation for the noinstr rcu_dynticks_eqs_exit()
-		instrument_atomic_write(&rdp->dynticks, sizeof(rdp->dynticks));
-
 		incby = 1;
 	} else if (!in_nmi()) {
 		instrumentation_begin();
@@ -1036,7 +961,7 @@ noinstr void rcu_nmi_enter(void)
 
 	trace_rcu_dyntick(incby == 1 ? TPS("Endirq") : TPS("++="),
 			  rdp->dynticks_nmi_nesting,
-			  rdp->dynticks_nmi_nesting + incby, atomic_read(&rdp->dynticks));
+			  rdp->dynticks_nmi_nesting + incby, 0);
 	instrumentation_end();
 	WRITE_ONCE(rdp->dynticks_nmi_nesting, /* Prevent store tearing. */
 		   rdp->dynticks_nmi_nesting + incby);
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -184,7 +184,6 @@ struct rcu_data {
 	int dynticks_snap;		/* Per-GP tracking for dynticks. */
 	long dynticks_nesting;		/* Track process nesting level. */
 	long dynticks_nmi_nesting;	/* Track irq/NMI nesting level. */
-	atomic_t dynticks;		/* Even value for idle, else odd. */
 	bool rcu_need_heavy_qs;		/* GP old, so heavy quiescent state! */
 	bool rcu_urgent_qs;		/* GP old need light quiescent state. */
 	bool rcu_forced_tick;		/* Forced tick to provide QS. */


