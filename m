Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890A241C9B5
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 18:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344948AbhI2QKC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 12:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344300AbhI2QJ5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 12:09:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71140C0613E5;
        Wed, 29 Sep 2021 09:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=q4wHgwdGzswZxmjd3vOyE/F61GL8wKtFuPXp5kD6iok=; b=XUYV1dJsNtbveMP0cZsMg9rqnZ
        YE6OKB9bAhV5NlocwYYoMCCUT8WRM10W1UMsKaF4sD9Lj4wY19Kv9Ok4x5/XfyP2oHWvpg0z2CJkB
        WQpAMurEigAEYlnmVzFKym3/HPDyJgb6zTQwEaFeWzYWa3qal8/kvV8mqtSnlxUMB2EyACtZvpazQ
        3z2dGuls5cE+pe6IwaQ9LZ8ukzlTHkZwi8yoFnRshnVOragHb/brikCijhAN25HtTLVQ+r1Q4/7es
        wMg+FARy1Rv+tInjIFIwSOivMRrQxCfENqNyr+sYts6Njh7CqxwWIGhY8JtL6T8TFHs98dND5wZzr
        zPDetu6g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVbxi-00Bz4O-UH; Wed, 29 Sep 2021 15:57:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 38AD3300328;
        Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 1C8132083A880; Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Message-ID: <20210929152428.589323576@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 29 Sep 2021 17:17:24 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: [PATCH v2 01/11] sched: Improve try_invoke_on_locked_down_task()
References: <20210929151723.162004989@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Clarify and tighten try_invoke_on_locked_down_task().

Basically the function calls @func under task_rq_lock(), except it
avoids taking rq->lock when possible.

This makes calling @func unconditional (the function will get renamed
in a later patch to remove the try).

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/sched/core.c |   63 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 24 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4111,41 +4111,56 @@ try_to_wake_up(struct task_struct *p, un
  * @func: Function to invoke.
  * @arg: Argument to function.
  *
- * If the specified task can be quickly locked into a definite state
- * (either sleeping or on a given runqueue), arrange to keep it in that
- * state while invoking @func(@arg).  This function can use ->on_rq and
- * task_curr() to work out what the state is, if required.  Given that
- * @func can be invoked with a runqueue lock held, it had better be quite
- * lightweight.
+ * Fix the task in it's current state by avoiding wakeups and or rq operations
+ * and call @func(@arg) on it.  This function can use ->on_rq and task_curr()
+ * to work out what the state is, if required.  Given that @func can be invoked
+ * with a runqueue lock held, it had better be quite lightweight.
  *
  * Returns:
- *	@false if the task slipped out from under the locks.
- *	@true if the task was locked onto a runqueue or is sleeping.
- *		However, @func can override this by returning @false.
+ *   Whatever @func returns
  */
 bool try_invoke_on_locked_down_task(struct task_struct *p, bool (*func)(struct task_struct *t, void *arg), void *arg)
 {
+	struct rq *rq = NULL;
+	unsigned int state;
 	struct rq_flags rf;
 	bool ret = false;
-	struct rq *rq;
 
 	raw_spin_lock_irqsave(&p->pi_lock, rf.flags);
-	if (p->on_rq) {
+
+	state = READ_ONCE(p->__state);
+
+	/*
+	 * Ensure we load p->on_rq after p->__state, otherwise it would be
+	 * possible to, falsely, observe p->on_rq == 0.
+	 *
+	 * See try_to_wake_up() for a longer comment.
+	 */
+	smp_rmb();
+
+	/*
+	 * Since pi->lock blocks try_to_wake_up(), we don't need rq->lock when
+	 * the task is blocked. Make sure to check @state since ttwu() can drop
+	 * locks at the end, see ttwu_queue_wakelist().
+	 */
+	if (state == TASK_RUNNING || state == TASK_WAKING || p->on_rq)
 		rq = __task_rq_lock(p, &rf);
-		if (task_rq(p) == rq)
-			ret = func(p, arg);
+
+	/*
+	 * At this point the task is pinned; either:
+	 *  - blocked and we're holding off wakeups	 (pi->lock)
+	 *  - woken, and we're holding off enqueue	 (rq->lock)
+	 *  - queued, and we're holding off schedule	 (rq->lock)
+	 *  - running, and we're holding off de-schedule (rq->lock)
+	 *
+	 * The called function (@func) can use: task_curr(), p->on_rq and
+	 * p->__state to differentiate between these states.
+	 */
+	ret = func(p, arg);
+
+	if (rq)
 		rq_unlock(rq, &rf);
-	} else {
-		switch (READ_ONCE(p->__state)) {
-		case TASK_RUNNING:
-		case TASK_WAKING:
-			break;
-		default:
-			smp_rmb(); // See smp_rmb() comment in try_to_wake_up().
-			if (!p->on_rq)
-				ret = func(p, arg);
-		}
-	}
+
 	raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
 	return ret;
 }


