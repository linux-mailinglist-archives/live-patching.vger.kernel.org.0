Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABBA41C8E8
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 17:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345484AbhI2P7s (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 11:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344379AbhI2P7p (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 11:59:45 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF77CC061760;
        Wed, 29 Sep 2021 08:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=n8kw0x6YcHBRBPkZKXL7aUNU+yEqKch2rt4IGGCpX+c=; b=bcJIdGogrpD5Jr3uZrjqJD0R5v
        C21QcYXTbJLy0DH99+3bLb8F8Hk3xOHFWiO3jcjrroOX3k8+QtIdBEDXl/QWdYK66MTjn49GljaCo
        5iUQIx/Krb4J/IjtK/sP6sCfy4VpA0BlYtX4aK50GKs/jautDLgjBw3JgsUP3RyvI3DtGKoywhlVn
        ADaqLqI+nsN3aTJgV4NvaK6Ub02Mg12EUymmGCfCX4UHeUlo8bDklYmGGi/UMaSbJqLQ1sxLfogkx
        YIuBVyjlUfC7/pj0YxwikRaTg8SxN+YfU22i7r+r23sMJlnioG7eurDnDMnv5UrY+EdCtmiVsmHKG
        UGfry4jg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVbxk-006jov-9W; Wed, 29 Sep 2021 15:57:40 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CF5AF302A0E;
        Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 3BF792C90588D; Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Message-ID: <20210929152428.947246287@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 29 Sep 2021 17:17:30 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: [RFC][PATCH v2 07/11] context_tracking: Add an atomic sequence/state count
References: <20210929151723.162004989@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Similar to dynticks RCU, add a sequence count that tracks
USER/GUEST,NMI state. Unlike RCU, use a few more state bits.

It would be possible to, like dyntics RCU, fold the USER and NMI bits,
for now don't bother and keep them explicit (doing this woulnd't be
terribly difficult, it would require __context_tracking_nmi_{enter,exit}()
to conditionally update the state).

Additionally, use bit0 to indicate there's additional work to be done
on leaving the 'USER' state.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/context_tracking.h       |   60 +++++++++++++++++++++
 include/linux/context_tracking_state.h |    3 +
 kernel/context_tracking.c              |   93 +++++++++++++++++++++++++++++++++
 kernel/entry/common.c                  |    2 
 4 files changed, 158 insertions(+)

--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -9,19 +9,47 @@
 
 #include <asm/ptrace.h>
 
+enum ct_work {
+	CT_WORK_n = 0,
+};
+
+/*
+ * context_tracking::seq
+ *
+ * bit0 - work
+ * bit1 - nmi
+ * bit2 - user
+ *
+ */
+enum ct_seq_state {
+	CT_SEQ_WORK = 0x01,
+	CT_SEQ_NMI  = 0x02,
+	CT_SEQ_USER = 0x04,
+	CT_SEQ      = 0x08,
+};
+
+static __always_inline bool __context_tracking_seq_in_user(unsigned int seq)
+{
+	return (seq & (CT_SEQ_USER | CT_SEQ_NMI)) == CT_SEQ_USER;
+}
 
 #ifdef CONFIG_CONTEXT_TRACKING
+
 extern void context_tracking_cpu_set(int cpu);
 
 /* Called with interrupts disabled.  */
 extern void __context_tracking_enter(enum ctx_state state);
 extern void __context_tracking_exit(enum ctx_state state);
+extern void __context_tracking_nmi_enter(void);
+extern void __context_tracking_nmi_exit(void);
 
 extern void context_tracking_enter(enum ctx_state state);
 extern void context_tracking_exit(enum ctx_state state);
 extern void context_tracking_user_enter(void);
 extern void context_tracking_user_exit(void);
 
+extern bool context_tracking_set_cpu_work(unsigned int cpu, unsigned int work);
+
 static inline void ct_user_enter(void)
 {
 	if (context_tracking_enabled())
@@ -47,6 +75,17 @@ static __always_inline void ct_user_exit
 		__context_tracking_exit(CONTEXT_USER);
 }
 
+static __always_inline void ct_nmi_enter_irqoff(void)
+{
+	if (context_tracking_enabled())
+		__context_tracking_nmi_enter();
+}
+static __always_inline void ct_nmi_exit_irqoff(void)
+{
+	if (context_tracking_enabled())
+		__context_tracking_nmi_exit();
+}
+
 static inline enum ctx_state exception_enter(void)
 {
 	enum ctx_state prev_ctx;
@@ -97,19 +136,40 @@ static __always_inline enum ctx_state ct
 	return context_tracking_enabled() ?
 		this_cpu_read(context_tracking.state) : CONTEXT_DISABLED;
 }
+
+static __always_inline unsigned int __context_tracking_cpu_seq(unsigned int cpu)
+{
+	return arch_atomic_read(per_cpu_ptr(&context_tracking.seq, cpu));
+}
+
 #else
 static inline void ct_user_enter(void) { }
 static inline void ct_user_exit(void) { }
 static inline void ct_user_enter_irqoff(void) { }
 static inline void ct_user_exit_irqoff(void) { }
+static inline void ct_nmi_enter_irqoff(void) { }
+static inline void ct_nmi_exit_irqoff(void) { }
 static inline enum ctx_state exception_enter(void) { return 0; }
 static inline void exception_exit(enum ctx_state prev_ctx) { }
 static inline enum ctx_state ct_state(void) { return CONTEXT_DISABLED; }
 static inline bool context_tracking_guest_enter(void) { return false; }
 static inline void context_tracking_guest_exit(void) { }
 
+static inline bool context_tracking_set_cpu_work(unsigned int cpu, unsigned int work) { return false; }
+
+static __always_inline unsigned int __context_tracking_cpu_seq(unsigned int cpu)
+{
+	return 0;
+}
+
 #endif /* !CONFIG_CONTEXT_TRACKING */
 
+static __always_inline bool context_tracking_cpu_in_user(unsigned int cpu)
+{
+	unsigned int seq = __context_tracking_cpu_seq(cpu);
+	return __context_tracking_seq_in_user(seq);
+}
+
 #define CT_WARN_ON(cond) WARN_ON(context_tracking_enabled() && (cond))
 
 #ifdef CONFIG_CONTEXT_TRACKING_FORCE
--- a/include/linux/context_tracking_state.h
+++ b/include/linux/context_tracking_state.h
@@ -4,6 +4,7 @@
 
 #include <linux/percpu.h>
 #include <linux/static_key.h>
+#include <linux/types.h>
 
 struct context_tracking {
 	/*
@@ -13,6 +14,8 @@ struct context_tracking {
 	 * may be further optimized using static keys.
 	 */
 	bool active;
+	atomic_t seq;
+	atomic_t work;
 	int recursion;
 	enum ctx_state {
 		CONTEXT_DISABLED = -1,	/* returned by ct_state() if unknown */
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -50,6 +50,85 @@ static __always_inline void context_trac
 	__this_cpu_dec(context_tracking.recursion);
 }
 
+/* CT_WORK_n, must be noinstr, non-blocking, NMI safe and deal with spurious calls */
+static noinstr void ct_exit_user_work(struct context_tracking *ct)
+{
+	unsigned int work = arch_atomic_read(&ct->work);
+
+#if 0
+	if (work & CT_WORK_n) {
+		/* NMI happens here and must still do/finish CT_WORK_n */
+		do_work_n();
+
+		smp_mb__before_atomic();
+		arch_atomic_andnot(CT_WORK_n, &ct->work);
+	}
+#endif
+
+	smp_mb__before_atomic();
+	arch_atomic_andnot(CT_SEQ_WORK, &ct->seq);
+}
+
+/* all CPU local */
+
+static __always_inline unsigned int ct_seq_nmi_enter(struct context_tracking *ct)
+{
+	unsigned int seq = arch_atomic_add_return(CT_SEQ_NMI, &ct->seq);
+	if (seq & CT_SEQ_WORK) /* NMI-enter is USER-exit */
+		ct_exit_user_work(ct);
+	return seq;
+}
+
+static __always_inline unsigned int ct_seq_nmi_exit(struct context_tracking *ct)
+{
+	arch_atomic_set(&ct->work, 0);
+	return arch_atomic_add_return(CT_SEQ - CT_SEQ_NMI, &ct->seq);
+}
+
+static __always_inline unsigned int ct_seq_user_enter(struct context_tracking *ct)
+{
+	arch_atomic_set(&ct->work, 0);
+	return arch_atomic_add_return(CT_SEQ_USER, &ct->seq);
+}
+
+static __always_inline unsigned int ct_seq_user_exit(struct context_tracking *ct)
+{
+	unsigned int seq = arch_atomic_add_return(CT_SEQ - CT_SEQ_USER, &ct->seq);
+	if (seq & CT_SEQ_WORK)
+		ct_exit_user_work(ct);
+	return seq;
+}
+
+/* remote */
+
+/*
+ * When returns true: guaratees that CPu will call @work
+ */
+static bool ct_seq_set_user_work(struct context_tracking *ct, unsigned int work)
+{
+	unsigned int seq;
+	bool ret = false;
+
+	if (!context_tracking_enabled() || !ct->active)
+		return false;
+
+	preempt_disable();
+	seq = atomic_read(&ct->seq);
+	if (__context_tracking_seq_in_user(seq)) {
+		/* ctrl-dep */
+		atomic_or(work, &ct->work);
+		ret = atomic_try_cmpxchg(&ct->seq, &seq, seq|CT_SEQ_WORK);
+	}
+	preempt_enable();
+
+	return ret;
+}
+
+bool context_tracking_set_cpu_work(unsigned int cpu, unsigned int work)
+{
+	return ct_seq_set_user_work(per_cpu_ptr(&context_tracking, cpu), work);
+}
+
 /**
  * context_tracking_enter - Inform the context tracking that the CPU is going
  *                          enter user or guest space mode.
@@ -83,6 +162,7 @@ void noinstr __context_tracking_enter(en
 				instrumentation_end();
 			}
 			rcu_user_enter();
+			ct_seq_user_enter(raw_cpu_ptr(&context_tracking));
 		}
 		/*
 		 * Even if context tracking is disabled on this CPU, because it's outside
@@ -154,6 +234,7 @@ void noinstr __context_tracking_exit(enu
 			 * We are going to run code that may use RCU. Inform
 			 * RCU core about that (ie: we may need the tick again).
 			 */
+			ct_seq_user_exit(raw_cpu_ptr(&context_tracking));
 			rcu_user_exit();
 			if (state == CONTEXT_USER) {
 				instrumentation_begin();
@@ -188,6 +269,18 @@ void context_tracking_user_exit(void)
 }
 NOKPROBE_SYMBOL(context_tracking_user_exit);
 
+void noinstr __context_tracking_nmi_enter(void)
+{
+	if (__this_cpu_read(context_tracking.active))
+		ct_seq_nmi_enter(raw_cpu_ptr(&context_tracking));
+}
+
+void noinstr __context_tracking_nmi_exit(void)
+{
+	if (__this_cpu_read(context_tracking.active))
+		ct_seq_nmi_exit(raw_cpu_ptr(&context_tracking));
+}
+
 void __init context_tracking_cpu_set(int cpu)
 {
 	static __initdata bool initialized = false;
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -451,6 +451,7 @@ irqentry_state_t noinstr irqentry_nmi_en
 	__nmi_enter();
 	lockdep_hardirqs_off(CALLER_ADDR0);
 	lockdep_hardirq_enter();
+	ct_nmi_enter_irqoff();
 	rcu_nmi_enter();
 
 	instrumentation_begin();
@@ -472,6 +473,7 @@ void noinstr irqentry_nmi_exit(struct pt
 	instrumentation_end();
 
 	rcu_nmi_exit();
+	ct_nmi_exit_irqoff();
 	lockdep_hardirq_exit();
 	if (irq_state.lockdep)
 		lockdep_hardirqs_on(CALLER_ADDR0);


