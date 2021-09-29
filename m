Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C21141C9B0
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 18:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345396AbhI2QKA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 12:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344837AbhI2QJ4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 12:09:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F656C02B8D7;
        Wed, 29 Sep 2021 09:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=FbbZUCoSvaK9CHkcqYEzTQMUQ5TWtKp3m/wyYJdW9to=; b=WT8TgLrQRWGDW4Q7wIy1/L1HD4
        gr2HMqgY10dcqY+klOhtQ4pt61dA1u/NJe4xem+eDlQAarQVKfvGu6RFaA5JJNd7YOFsfwEa1ISme
        zWh/xnM42F9ope+mcRmIpD4w59b0/RuWIEpsEWHBx94zUccVey2Tkrlo9QbpuhX93sIBaReO+Bede
        oqwz1pdlS+cd6Z4ryUsEUWGHkpUJsIl69P5VyGbnfHrGuL7lFC53snx9y6/eCA5lvNQYzpZZdc6PU
        6XlfxkdtKPhMVRvznUJkcuPXTBBC5/ODNR9p3PteROAR4ryqaaQKQ2flKd0hC2TndC/S+HOntQSmr
        vUbQimeQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVbxj-00Bz4R-CQ; Wed, 29 Sep 2021 15:57:54 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CF5D2302A10;
        Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 393A32C905DA0; Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Message-ID: <20210929152428.887923187@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 29 Sep 2021 17:17:29 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: [RFC][PATCH v2 06/11] context_tracking: Prefix user_{enter,exit}*()
References: <20210929151723.162004989@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Put a ct_ prefix on a bunch of context_tracking functions for better
namespacing / greppability.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/Kconfig                            |    6 +++---
 arch/arm64/kernel/entry-common.c        |    4 ++--
 arch/mips/kernel/ptrace.c               |    6 +++---
 arch/mips/kernel/signal.c               |    4 ++--
 arch/powerpc/include/asm/interrupt.h    |    2 +-
 arch/powerpc/kernel/interrupt.c         |   10 +++++-----
 arch/sparc/kernel/ptrace_64.c           |    6 +++---
 arch/sparc/kernel/signal_64.c           |    4 ++--
 include/linux/context_tracking.h        |   16 ++++++++--------
 include/linux/context_tracking_state.h  |    2 +-
 include/trace/events/context_tracking.h |    8 ++++----
 kernel/context_tracking.c               |    6 +++---
 kernel/entry/common.c                   |    4 ++--
 kernel/livepatch/transition.c           |    2 +-
 kernel/sched/core.c                     |    4 ++--
 kernel/trace/ftrace.c                   |    4 ++--
 16 files changed, 44 insertions(+), 44 deletions(-)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -760,7 +760,7 @@ config HAVE_CONTEXT_TRACKING
 	help
 	  Provide kernel/user boundaries probes necessary for subsystems
 	  that need it, such as userspace RCU extended quiescent state.
-	  Syscalls need to be wrapped inside user_exit()-user_enter(), either
+	  Syscalls need to be wrapped inside ct_user_exit()-ct_user_enter(), either
 	  optimized behind static key or through the slow path using TIF_NOHZ
 	  flag. Exceptions handlers must be wrapped as well. Irqs are already
 	  protected inside rcu_irq_enter/rcu_irq_exit() but preemption or signal
@@ -774,7 +774,7 @@ config HAVE_CONTEXT_TRACKING_OFFSTACK
 	  preempt_schedule_irq() can't be called in a preemptible section
 	  while context tracking is CONTEXT_USER. This feature reflects a sane
 	  entry implementation where the following requirements are met on
-	  critical entry code, ie: before user_exit() or after user_enter():
+	  critical entry code, ie: before ct_user_exit() or after ct_user_enter():
 
 	  - Critical entry code isn't preemptible (or better yet:
 	    not interruptible).
@@ -787,7 +787,7 @@ config HAVE_TIF_NOHZ
 	bool
 	help
 	  Arch relies on TIF_NOHZ and syscall slow path to implement context
-	  tracking calls to user_enter()/user_exit().
+	  tracking calls to ct_user_enter()/ct_user_exit().
 
 config HAVE_VIRT_CPU_ACCOUNTING
 	bool
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -100,7 +100,7 @@ static __always_inline void __enter_from
 {
 	lockdep_hardirqs_off(CALLER_ADDR0);
 	CT_WARN_ON(ct_state() != CONTEXT_USER);
-	user_exit_irqoff();
+	ct_user_exit_irqoff();
 	trace_hardirqs_off_finish();
 }
 
@@ -118,7 +118,7 @@ static __always_inline void __exit_to_us
 {
 	trace_hardirqs_on_prepare();
 	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
-	user_enter_irqoff();
+	ct_user_enter_irqoff();
 	lockdep_hardirqs_on(CALLER_ADDR0);
 }
 
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -1312,7 +1312,7 @@ long arch_ptrace(struct task_struct *chi
  */
 asmlinkage long syscall_trace_enter(struct pt_regs *regs, long syscall)
 {
-	user_exit();
+	ct_user_exit();
 
 	current_thread_info()->syscall = syscall;
 
@@ -1368,7 +1368,7 @@ asmlinkage void syscall_trace_leave(stru
 	 * or do_notify_resume(), in which case we can be in RCU
 	 * user mode.
 	 */
-	user_exit();
+	ct_user_exit();
 
 	audit_syscall_exit(regs);
 
@@ -1378,5 +1378,5 @@ asmlinkage void syscall_trace_leave(stru
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		tracehook_report_syscall_exit(regs, 0);
 
-	user_enter();
+	ct_user_enter();
 }
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -897,7 +897,7 @@ asmlinkage void do_notify_resume(struct
 {
 	local_irq_enable();
 
-	user_exit();
+	ct_user_exit();
 
 	if (thread_info_flags & _TIF_UPROBE)
 		uprobe_notify_resume(regs);
@@ -911,7 +911,7 @@ asmlinkage void do_notify_resume(struct
 		rseq_handle_notify_resume(NULL, regs);
 	}
 
-	user_enter();
+	ct_user_enter();
 }
 
 #if defined(CONFIG_SMP) && defined(CONFIG_MIPS_FP_SUPPORT)
--- a/arch/powerpc/include/asm/interrupt.h
+++ b/arch/powerpc/include/asm/interrupt.h
@@ -154,7 +154,7 @@ static inline void interrupt_enter_prepa
 
 	if (user_mode(regs)) {
 		CT_WARN_ON(ct_state() != CONTEXT_USER);
-		user_exit_irqoff();
+		ct_user_exit_irqoff();
 
 		account_cpu_user_entry();
 		account_stolen_time();
--- a/arch/powerpc/kernel/interrupt.c
+++ b/arch/powerpc/kernel/interrupt.c
@@ -91,7 +91,7 @@ notrace long system_call_exception(long
 	trace_hardirqs_off(); /* finish reconciling */
 
 	CT_WARN_ON(ct_state() == CONTEXT_KERNEL);
-	user_exit_irqoff();
+	ct_user_exit_irqoff();
 
 	BUG_ON(regs_is_unrecoverable(regs));
 	BUG_ON(!(regs->msr & MSR_PR));
@@ -388,9 +388,9 @@ interrupt_exit_user_prepare_main(unsigne
 
 	check_return_regs_valid(regs);
 
-	user_enter_irqoff();
+	ct_user_enter_irqoff();
 	if (!prep_irq_for_enabled_exit(true)) {
-		user_exit_irqoff();
+		ct_user_exit_irqoff();
 		local_irq_enable();
 		local_irq_disable();
 		goto again;
@@ -489,7 +489,7 @@ notrace unsigned long syscall_exit_resta
 #endif
 
 	trace_hardirqs_off();
-	user_exit_irqoff();
+	ct_user_exit_irqoff();
 	account_cpu_user_entry();
 
 	BUG_ON(!user_mode(regs));
@@ -638,7 +638,7 @@ notrace unsigned long interrupt_exit_use
 #endif
 
 	trace_hardirqs_off();
-	user_exit_irqoff();
+	ct_user_exit_irqoff();
 	account_cpu_user_entry();
 
 	BUG_ON(!user_mode(regs));
--- a/arch/sparc/kernel/ptrace_64.c
+++ b/arch/sparc/kernel/ptrace_64.c
@@ -1092,7 +1092,7 @@ asmlinkage int syscall_trace_enter(struc
 	secure_computing_strict(regs->u_regs[UREG_G1]);
 
 	if (test_thread_flag(TIF_NOHZ))
-		user_exit();
+		ct_user_exit();
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		ret = tracehook_report_syscall_entry(regs);
@@ -1110,7 +1110,7 @@ asmlinkage int syscall_trace_enter(struc
 asmlinkage void syscall_trace_leave(struct pt_regs *regs)
 {
 	if (test_thread_flag(TIF_NOHZ))
-		user_exit();
+		ct_user_exit();
 
 	audit_syscall_exit(regs);
 
@@ -1121,7 +1121,7 @@ asmlinkage void syscall_trace_leave(stru
 		tracehook_report_syscall_exit(regs, 0);
 
 	if (test_thread_flag(TIF_NOHZ))
-		user_enter();
+		ct_user_enter();
 }
 
 /**
--- a/arch/sparc/kernel/signal_64.c
+++ b/arch/sparc/kernel/signal_64.c
@@ -546,14 +546,14 @@ static void do_signal(struct pt_regs *re
 
 void do_notify_resume(struct pt_regs *regs, unsigned long orig_i0, unsigned long thread_info_flags)
 {
-	user_exit();
+	ct_user_exit();
 	if (thread_info_flags & _TIF_UPROBE)
 		uprobe_notify_resume(regs);
 	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 		do_signal(regs, orig_i0);
 	if (thread_info_flags & _TIF_NOTIFY_RESUME)
 		tracehook_notify_resume(regs);
-	user_enter();
+	ct_user_enter();
 }
 
 /*
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -22,26 +22,26 @@ extern void context_tracking_exit(enum c
 extern void context_tracking_user_enter(void);
 extern void context_tracking_user_exit(void);
 
-static inline void user_enter(void)
+static inline void ct_user_enter(void)
 {
 	if (context_tracking_enabled())
 		context_tracking_enter(CONTEXT_USER);
 
 }
-static inline void user_exit(void)
+static inline void ct_user_exit(void)
 {
 	if (context_tracking_enabled())
 		context_tracking_exit(CONTEXT_USER);
 }
 
 /* Called with interrupts disabled.  */
-static __always_inline void user_enter_irqoff(void)
+static __always_inline void ct_user_enter_irqoff(void)
 {
 	if (context_tracking_enabled())
 		__context_tracking_enter(CONTEXT_USER);
 
 }
-static __always_inline void user_exit_irqoff(void)
+static __always_inline void ct_user_exit_irqoff(void)
 {
 	if (context_tracking_enabled())
 		__context_tracking_exit(CONTEXT_USER);
@@ -98,10 +98,10 @@ static __always_inline enum ctx_state ct
 		this_cpu_read(context_tracking.state) : CONTEXT_DISABLED;
 }
 #else
-static inline void user_enter(void) { }
-static inline void user_exit(void) { }
-static inline void user_enter_irqoff(void) { }
-static inline void user_exit_irqoff(void) { }
+static inline void ct_user_enter(void) { }
+static inline void ct_user_exit(void) { }
+static inline void ct_user_enter_irqoff(void) { }
+static inline void ct_user_exit_irqoff(void) { }
 static inline enum ctx_state exception_enter(void) { return 0; }
 static inline void exception_exit(enum ctx_state prev_ctx) { }
 static inline enum ctx_state ct_state(void) { return CONTEXT_DISABLED; }
--- a/include/linux/context_tracking_state.h
+++ b/include/linux/context_tracking_state.h
@@ -9,7 +9,7 @@ struct context_tracking {
 	/*
 	 * When active is false, probes are unset in order
 	 * to minimize overhead: TIF flags are cleared
-	 * and calls to user_enter/exit are ignored. This
+	 * and calls to ct_user_enter/exit are ignored. This
 	 * may be further optimized using static keys.
 	 */
 	bool active;
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -73,7 +73,7 @@ void noinstr __context_tracking_enter(en
 			 * At this stage, only low level arch entry code remains and
 			 * then we'll run in userspace. We can assume there won't be
 			 * any RCU read-side critical section until the next call to
-			 * user_exit() or rcu_irq_enter(). Let's remove RCU's dependency
+			 * ct_user_exit() or rcu_irq_enter(). Let's remove RCU's dependency
 			 * on the tick.
 			 */
 			if (state == CONTEXT_USER) {
@@ -127,7 +127,7 @@ EXPORT_SYMBOL_GPL(context_tracking_enter
 
 void context_tracking_user_enter(void)
 {
-	user_enter();
+	ct_user_enter();
 }
 NOKPROBE_SYMBOL(context_tracking_user_enter);
 
@@ -184,7 +184,7 @@ EXPORT_SYMBOL_GPL(context_tracking_exit)
 
 void context_tracking_user_exit(void)
 {
-	user_exit();
+	ct_user_exit();
 }
 NOKPROBE_SYMBOL(context_tracking_user_exit);
 
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -19,7 +19,7 @@ static __always_inline void __enter_from
 	lockdep_hardirqs_off(CALLER_ADDR0);
 
 	CT_WARN_ON(ct_state() != CONTEXT_USER);
-	user_exit_irqoff();
+	ct_user_exit_irqoff();
 
 	instrumentation_begin();
 	trace_hardirqs_off_finish();
@@ -127,7 +127,7 @@ static __always_inline void __exit_to_us
 	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
 	instrumentation_end();
 
-	user_enter_irqoff();
+	ct_user_enter_irqoff();
 	arch_exit_to_user_mode();
 	lockdep_hardirqs_on(CALLER_ADDR0);
 }
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -51,7 +51,7 @@ static void klp_sync(struct work_struct
 
 /*
  * We allow to patch also functions where RCU is not watching,
- * e.g. before user_exit(). We can not rely on the RCU infrastructure
+ * e.g. before ct_user_exit(). We can not rely on the RCU infrastructure
  * to do the synchronization. Instead hard force the sched synchronization.
  *
  * This approach allows to use RCU functions for manipulating func_stack
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6444,7 +6444,7 @@ EXPORT_STATIC_CALL_TRAMP(preempt_schedul
  * recursion and tracing preempt enabling caused by the tracing
  * infrastructure itself. But as tracing can happen in areas coming
  * from userspace or just about to enter userspace, a preempt enable
- * can occur before user_exit() is called. This will cause the scheduler
+ * can occur before ct_user_exit() is called. This will cause the scheduler
  * to be called when the system is still in usermode.
  *
  * To prevent this, the preempt_enable_notrace will use this function
@@ -6475,7 +6475,7 @@ asmlinkage __visible void __sched notrac
 		preempt_disable_notrace();
 		preempt_latency_start(1);
 		/*
-		 * Needs preempt disabled in case user_exit() is traced
+		 * Needs preempt disabled in case ct_user_exit() is traced
 		 * and the tracer calls preempt_enable_notrace() causing
 		 * an infinite recursion.
 		 */
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2996,7 +2996,7 @@ int ftrace_shutdown(struct ftrace_ops *o
 		 * We need to do a hard force of sched synchronization.
 		 * This is because we use preempt_disable() to do RCU, but
 		 * the function tracers can be called where RCU is not watching
-		 * (like before user_exit()). We can not rely on the RCU
+		 * (like before ct_user_exit()). We can not rely on the RCU
 		 * infrastructure to do the synchronization, thus we must do it
 		 * ourselves.
 		 */
@@ -5981,7 +5981,7 @@ ftrace_graph_release(struct inode *inode
 		 * We need to do a hard force of sched synchronization.
 		 * This is because we use preempt_disable() to do RCU, but
 		 * the function tracers can be called where RCU is not watching
-		 * (like before user_exit()). We can not rely on the RCU
+		 * (like before ct_user_exit()). We can not rely on the RCU
 		 * infrastructure to do the synchronization, thus we must do it
 		 * ourselves.
 		 */


