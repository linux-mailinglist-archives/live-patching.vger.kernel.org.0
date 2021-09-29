Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7E841C9B2
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 18:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345009AbhI2QKA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 12:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344873AbhI2QJ5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 12:09:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335BEC02B8D8;
        Wed, 29 Sep 2021 09:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=Hm6Wj353GW6Ayitly3CGGSyK7HP/6LOhbdZWRM1eepk=; b=XE4p3xpUD8DP9kgUr4ZX4QXgXP
        iIxDf8vuhZcCXuseJBWbuaQe1yIqmeLbwotwIhSepd07BoXzmVIPQ5QW5bHFnujHPEj7wD9s9ef6R
        TpcVukGNmZfdFoPDn2e89vDvJxrneTPxXuTGvzyDGaNDLLMTekUDIkNmXWUfAUBmsx2Juqe0nImxc
        /+gkRdLZBEeJ0GEm0DmFNOVW0qHvZWKARdlyARoC0kbDIlZUyGPNkfQhF15tfN+DOsxy/WcgQnkko
        vdhTlbBidHlcvivpoGuY2eZwC/GfDfWHnc5lfTm8ZVnaO9De1zQHfNuD37w1jqmjIQqkqceSzS6dP
        kqYHFCrA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVbxi-00Bz4N-Uc; Wed, 29 Sep 2021 15:57:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3AA51300780;
        Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 1F1142C78F4F9; Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Message-ID: <20210929152428.649944917@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 29 Sep 2021 17:17:25 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: [PATCH v2 02/11] sched,rcu: Rework try_invoke_on_locked_down_task()
References: <20210929151723.162004989@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Give try_invoke_on_locked_down_task() a saner name and have it return
an int so that the caller might distinguish between different reasons
of failure.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
---
 include/linux/wait.h    |    3 ++-
 kernel/rcu/tasks.h      |   12 ++++++------
 kernel/rcu/tree_stall.h |    8 ++++----
 kernel/sched/core.c     |    6 +++---
 4 files changed, 15 insertions(+), 14 deletions(-)

--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -1160,6 +1160,7 @@ int autoremove_wake_function(struct wait
 		(wait)->flags = 0;						\
 	} while (0)
 
-bool try_invoke_on_locked_down_task(struct task_struct *p, bool (*func)(struct task_struct *t, void *arg), void *arg);
+typedef int (*task_call_f)(struct task_struct *p, void *arg);
+extern int task_call_func(struct task_struct *p, task_call_f func, void *arg);
 
 #endif /* _LINUX_WAIT_H */
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -928,7 +928,7 @@ static void trc_read_check_handler(void
 }
 
 /* Callback function for scheduler to check locked-down task.  */
-static bool trc_inspect_reader(struct task_struct *t, void *arg)
+static int trc_inspect_reader(struct task_struct *t, void *arg)
 {
 	int cpu = task_cpu(t);
 	bool in_qs = false;
@@ -939,7 +939,7 @@ static bool trc_inspect_reader(struct ta
 
 		// If no chance of heavyweight readers, do it the hard way.
 		if (!ofl && !IS_ENABLED(CONFIG_TASKS_TRACE_RCU_READ_MB))
-			return false;
+			return -EINVAL;
 
 		// If heavyweight readers are enabled on the remote task,
 		// we can inspect its state despite its currently running.
@@ -947,7 +947,7 @@ static bool trc_inspect_reader(struct ta
 		n_heavy_reader_attempts++;
 		if (!ofl && // Check for "running" idle tasks on offline CPUs.
 		    !rcu_dynticks_zero_in_eqs(cpu, &t->trc_reader_nesting))
-			return false; // No quiescent state, do it the hard way.
+			return -EINVAL; // No quiescent state, do it the hard way.
 		n_heavy_reader_updates++;
 		if (ofl)
 			n_heavy_reader_ofl_updates++;
@@ -962,7 +962,7 @@ static bool trc_inspect_reader(struct ta
 	t->trc_reader_checked = true;
 
 	if (in_qs)
-		return true;  // Already in quiescent state, done!!!
+		return 0;  // Already in quiescent state, done!!!
 
 	// The task is in a read-side critical section, so set up its
 	// state so that it will awaken the grace-period kthread upon exit
@@ -970,7 +970,7 @@ static bool trc_inspect_reader(struct ta
 	atomic_inc(&trc_n_readers_need_end); // One more to wait on.
 	WARN_ON_ONCE(READ_ONCE(t->trc_reader_special.b.need_qs));
 	WRITE_ONCE(t->trc_reader_special.b.need_qs, true);
-	return true;
+	return 0;
 }
 
 /* Attempt to extract the state for the specified task. */
@@ -992,7 +992,7 @@ static void trc_wait_for_one_reader(stru
 
 	// Attempt to nail down the task for inspection.
 	get_task_struct(t);
-	if (try_invoke_on_locked_down_task(t, trc_inspect_reader, NULL)) {
+	if (!task_call_func(t, trc_inspect_reader, NULL)) {
 		put_task_struct(t);
 		return;
 	}
--- a/kernel/rcu/tree_stall.h
+++ b/kernel/rcu/tree_stall.h
@@ -240,16 +240,16 @@ struct rcu_stall_chk_rdr {
  * Report out the state of a not-running task that is stalling the
  * current RCU grace period.
  */
-static bool check_slow_task(struct task_struct *t, void *arg)
+static int check_slow_task(struct task_struct *t, void *arg)
 {
 	struct rcu_stall_chk_rdr *rscrp = arg;
 
 	if (task_curr(t))
-		return false; // It is running, so decline to inspect it.
+		return -EBUSY; // It is running, so decline to inspect it.
 	rscrp->nesting = t->rcu_read_lock_nesting;
 	rscrp->rs = t->rcu_read_unlock_special;
 	rscrp->on_blkd_list = !list_empty(&t->rcu_node_entry);
-	return true;
+	return 0;
 }
 
 /*
@@ -283,7 +283,7 @@ static int rcu_print_task_stall(struct r
 	raw_spin_unlock_irqrestore_rcu_node(rnp, flags);
 	while (i) {
 		t = ts[--i];
-		if (!try_invoke_on_locked_down_task(t, check_slow_task, &rscr))
+		if (task_call_func(t, check_slow_task, &rscr))
 			pr_cont(" P%d", t->pid);
 		else
 			pr_cont(" P%d/%d:%c%c%c%c",
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4106,7 +4106,7 @@ try_to_wake_up(struct task_struct *p, un
 }
 
 /**
- * try_invoke_on_locked_down_task - Invoke a function on task in fixed state
+ * task_call_func - Invoke a function on task in fixed state
  * @p: Process for which the function is to be invoked, can be @current.
  * @func: Function to invoke.
  * @arg: Argument to function.
@@ -4119,12 +4119,12 @@ try_to_wake_up(struct task_struct *p, un
  * Returns:
  *   Whatever @func returns
  */
-bool try_invoke_on_locked_down_task(struct task_struct *p, bool (*func)(struct task_struct *t, void *arg), void *arg)
+int task_call_func(struct task_struct *p, task_call_f func, void *arg)
 {
 	struct rq *rq = NULL;
 	unsigned int state;
 	struct rq_flags rf;
-	bool ret = false;
+	int ret;
 
 	raw_spin_lock_irqsave(&p->pi_lock, rf.flags);
 


