Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EFC414757
	for <lists+live-patching@lfdr.de>; Wed, 22 Sep 2021 13:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbhIVLNA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Sep 2021 07:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235137AbhIVLM7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Sep 2021 07:12:59 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AB3C061574;
        Wed, 22 Sep 2021 04:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=RQiyN9kAniq28Mhpucr7JvSPt4kFBzsJijKC5Qn3EE8=; b=WGhvPiU6/TPZ57jc5FI7bcvaK6
        mr+GVsT4uCgp/rCzjI0A/vMwJURcsLWPqGw66eW5QZ5eJ7vCcNMk4+Qw1HJI0oO5TNvgPPR/qTQ9k
        MJHZFZ1CmxP3TUV6ObeBkWRsCKfo/OvMxYrKq4UcnHnMTPIpnuLfxmizJGxij2NAkdXq4aWriJlTp
        JvFUGKFTAmo5k23jYAeV+03Ylqq1wlulvjPW5a+ttE45qS8LUCxVS5QYhJ0u7k2tBPqktIbBiafgU
        GQpDYTD6vaLFg6qJtoZoVT5hnbp0Rs5AoYiz6fiG/Iz2BR3qSEZPeKSu0q+XDV6nAx/h5T2rzX6pg
        nOqJHM5A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mT09o-004yYQ-7L; Wed, 22 Sep 2021 11:11:20 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id AECDB3000A9;
        Wed, 22 Sep 2021 13:11:18 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 7EF8C203038FF; Wed, 22 Sep 2021 13:11:18 +0200 (CEST)
Message-ID: <20210922110836.005204425@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 22 Sep 2021 13:05:08 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org
Subject: [RFC][PATCH 2/7] sched: Fix task_try_func()
References: <20210922110506.703075504@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Clarify and fix task_try_func(). Move the smp_rmb() up to avoid
re-loading p->on_rq in the false case, but add a p->on_rq reload after
acquiring rq->lock, after all, it could have gotten dequeued while
waiting for the lock.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/sched/core.c |   37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4005,7 +4005,7 @@ try_to_wake_up(struct task_struct *p, un
 	 * Pairs with the LOCK+smp_mb__after_spinlock() on rq->lock in
 	 * __schedule().  See the comment for smp_mb__after_spinlock().
 	 *
-	 * A similar smb_rmb() lives in try_invoke_on_locked_down_task().
+	 * A similar smb_rmb() lives in task_try_func().
 	 */
 	smp_rmb();
 	if (READ_ONCE(p->on_rq) && ttwu_runnable(p, wake_flags))
@@ -4124,25 +4124,48 @@ try_to_wake_up(struct task_struct *p, un
  */
 int task_try_func(struct task_struct *p, task_try_f func, void *arg)
 {
+	unsigned int state;
 	struct rq_flags rf;
-	int ret = -EAGAIN; /* raced, try again later */
 	struct rq *rq;
+	int ret = -EAGAIN; /* raced, try again later */
 
 	raw_spin_lock_irqsave(&p->pi_lock, rf.flags);
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
 	if (p->on_rq) {
 		rq = __task_rq_lock(p, &rf);
-		if (task_rq(p) == rq)
+
+		/* re-check p->on_rq now that we hold rq->lock */
+		if (p->on_rq && task_rq(p) == rq)
 			ret = func(p, arg);
+
 		rq_unlock(rq, &rf);
+
 	} else {
-		switch (READ_ONCE(p->__state)) {
+
+		switch (state) {
 		case TASK_RUNNING:
 		case TASK_WAKING:
+			/*
+			 * We raced against wakeup, try again later.
+			 */
 			break;
+
 		default:
-			smp_rmb(); // See smp_rmb() comment in try_to_wake_up().
-			if (!p->on_rq)
-				ret = func(p, arg);
+			/*
+			 * Since we hold ->pi_lock, we serialize against
+			 * try_to_wake_up() and any blocked state must remain.
+			 */
+			ret = func(p, arg);
 		}
 	}
 	raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);


