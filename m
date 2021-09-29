Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0A241C8E2
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 17:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345467AbhI2P7r (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 11:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344253AbhI2P7n (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 11:59:43 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41EFC061767;
        Wed, 29 Sep 2021 08:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=N/yAsJuX0k0YvZzhJq4c+PbXSV2Vvfw5OLKfxe9q9sU=; b=LP7QP7GF0oH0ZnPicHN4sHpvz/
        BjJFsaay5ZlhiGi/x8IZLAOoYHZY7K6KAGTCxYcNoSFIBMDnzaGFwwmunBLu9UxD1sFdwWBNLXTBU
        SFzoiF+ycfFnrVaFi+N2Sl8nKSTm8c+yXEYGtPAMPkXFT178x+8wKHtuwki5d8Am6iWykqHm6rWKQ
        DxY+p0lxA/hxn2fu1GZNEFaPnlw6OXx6+OdqXbvnQMKgSGoXlPHS3CJOWttCMkJyvfv0hfThtSmqd
        9b1mcXQaFZbVAv45ArdXQnEA9p9EZ3Ae7k16MMZuhEdEWLOCm5Oxlbte5f05UszK0h9GdANmaM67l
        dHubP3Bw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVbxj-006jor-AY; Wed, 29 Sep 2021 15:57:39 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D0329302A1E;
        Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 4510C2C905DA4; Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Message-ID: <20210929152429.067060646@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 29 Sep 2021 17:17:32 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: [RFC][PATCH v2 09/11] context_tracking,livepatch: Dont disturb NOHZ_FULL
References: <20210929151723.162004989@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Using the new context_tracking infrastructure, avoid disturbing
userspace tasks when context tracking is enabled.

When context_tracking_set_cpu_work() returns true, we have the
guarantee that klp_update_patch_state() is called from noinstr code
before it runs normal kernel code. This covers
syscall/exceptions/interrupts and NMI entry.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/context_tracking.h |    2 +-
 include/linux/livepatch.h        |    2 ++
 kernel/context_tracking.c        |   11 +++++------
 kernel/livepatch/transition.c    |   29 ++++++++++++++++++++++++++---
 4 files changed, 34 insertions(+), 10 deletions(-)

--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -10,7 +10,7 @@
 #include <asm/ptrace.h>
 
 enum ct_work {
-	CT_WORK_n = 0,
+	CT_WORK_KLP = 1,
 };
 
 /*
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -201,6 +201,7 @@ void klp_module_going(struct module *mod
 
 void klp_copy_process(struct task_struct *child);
 void klp_update_patch_state(struct task_struct *task);
+void __klp_update_patch_state(struct task_struct *task);
 
 static inline bool klp_patch_pending(struct task_struct *task)
 {
@@ -242,6 +243,7 @@ static inline int klp_module_coming(stru
 static inline void klp_module_going(struct module *mod) {}
 static inline bool klp_patch_pending(struct task_struct *task) { return false; }
 static inline void klp_update_patch_state(struct task_struct *task) {}
+static inline void __klp_update_patch_state(struct task_struct *task) {}
 static inline void klp_copy_process(struct task_struct *child) {}
 
 static inline
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -21,6 +21,7 @@
 #include <linux/hardirq.h>
 #include <linux/export.h>
 #include <linux/kprobes.h>
+#include <linux/livepatch.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/context_tracking.h>
@@ -55,15 +56,13 @@ static noinstr void ct_exit_user_work(struct
 {
 	unsigned int work = arch_atomic_read(&ct->work);
 
-#if 0
-	if (work & CT_WORK_n) {
+	if (work & CT_WORK_KLP) {
 		/* NMI happens here and must still do/finish CT_WORK_n */
-		do_work_n();
+		__klp_update_patch_state(current);
 
 		smp_mb__before_atomic();
-		arch_atomic_andnot(CT_WORK_n, &ct->work);
+		arch_atomic_andnot(CT_WORK_KLP, &ct->work);
 	}
-#endif
 
 	smp_mb__before_atomic();
 	arch_atomic_andnot(CT_SEQ_WORK, &ct->seq);
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -10,6 +10,7 @@
 #include <linux/cpu.h>
 #include <linux/stacktrace.h>
 #include <linux/tracehook.h>
+#include <linux/context_tracking.h>
 #include "core.h"
 #include "patch.h"
 #include "transition.h"
@@ -153,6 +154,11 @@ void klp_cancel_transition(void)
 	klp_complete_transition();
 }
 
+noinstr void __klp_update_patch_state(struct task_struct *task)
+{
+	task->patch_state = READ_ONCE(klp_target_state);
+}
+
 /*
  * Switch the patched state of the task to the set of functions in the target
  * patch state.
@@ -180,8 +186,10 @@ void klp_update_patch_state(struct task_
 	 *    of func->transition, if klp_ftrace_handler() is called later on
 	 *    the same CPU.  See __klp_disable_patch().
 	 */
-	if (test_and_clear_tsk_thread_flag(task, TIF_PATCH_PENDING))
+	if (test_tsk_thread_flag(task, TIF_PATCH_PENDING)) {
 		task->patch_state = READ_ONCE(klp_target_state);
+		clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
+	}
 
 	preempt_enable_notrace();
 }
@@ -270,15 +278,30 @@ static int klp_check_and_switch_task(str
 {
 	int ret;
 
-	if (task_curr(task))
+	if (task_curr(task)) {
+		/*
+		 * This only succeeds when the task is in NOHZ_FULL user
+		 * mode, the true return value guarantees any kernel entry
+		 * will call klp_update_patch_state().
+		 *
+		 * XXX: ideally we'd simply return 0 here and leave
+		 * TIF_PATCH_PENDING alone, to be fixed up by
+		 * klp_update_patch_state(), except livepatching goes wobbly
+		 * with 'pending' TIF bits on.
+		 */
+		if (context_tracking_set_cpu_work(task_cpu(task), CT_WORK_KLP))
+			goto clear;
+
 		return -EBUSY;
+	}
 
 	ret = klp_check_stack(task, arg);
 	if (ret)
 		return ret;
 
-	clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
 	task->patch_state = klp_target_state;
+clear:
+	clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
 	return 0;
 }
 


