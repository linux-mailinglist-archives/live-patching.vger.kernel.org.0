Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32F9414758
	for <lists+live-patching@lfdr.de>; Wed, 22 Sep 2021 13:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235340AbhIVLNB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Sep 2021 07:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235303AbhIVLNA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Sep 2021 07:13:00 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A400C061757;
        Wed, 22 Sep 2021 04:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=qNA3H7BdPTTgZjI5KuMBnDmufUgkuTSS/0So5BCWOhk=; b=IaeG55HoXLNVd8K8K29soS3Grh
        XNnzOi0GtICQkeGRBKKt6V9RwfrLWKOkNgLFcQn07HnypJUEs8TJZc2xPiMz6ZUXm9LY/6dWPTW+b
        bIlj+Xxo7buvCPfZcp+4NKbpAUVI8M3WYqjfxHq35FBOcEjvobhioW9MrnmafymXQXVXota/Lq+56
        Sm6GuIXfhlyOOoDdjeMtHA7ICPrzoeK6Qq0HJeWe2zclPKXfphMqprZrhcIbtxwXZ4VfD6VWxDLiJ
        Cj7b5kOxPlIMI0BvxloXEwMCCX8Nrejt2OGrluxXmloTh/kBlP3F+cFAgMdZvx0AGdnDsfRUAvzPf
        OfAk8Mnw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mT09o-004yYR-7L; Wed, 22 Sep 2021 11:11:20 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B5956300C9D;
        Wed, 22 Sep 2021 13:11:18 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 890F4206A3E2D; Wed, 22 Sep 2021 13:11:18 +0200 (CEST)
Message-ID: <20210922110836.125579666@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 22 Sep 2021 13:05:10 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org
Subject: [RFC][PATCH 4/7] sched: Simplify wake_up_*idle*()
References: <20210922110506.703075504@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Simplify and make wake_up_if_idle() more robust, also don't iterate
the whole machine with preempt_disable() in it's caller:
wake_up_all_idle_cpus().

This prepares for another wake_up_if_idle() user that needs a full
do_idle() cycle.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/sched/core.c |   14 +++++---------
 kernel/smp.c        |    6 +++---
 2 files changed, 8 insertions(+), 12 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3691,15 +3691,11 @@ void wake_up_if_idle(int cpu)
 	if (!is_idle_task(rcu_dereference(rq->curr)))
 		goto out;
 
-	if (set_nr_if_polling(rq->idle)) {
-		trace_sched_wake_idle_without_ipi(cpu);
-	} else {
-		rq_lock_irqsave(rq, &rf);
-		if (is_idle_task(rq->curr))
-			smp_send_reschedule(cpu);
-		/* Else CPU is not idle, do nothing here: */
-		rq_unlock_irqrestore(rq, &rf);
-	}
+	rq_lock_irqsave(rq, &rf);
+	if (is_idle_task(rq->curr))
+		resched_curr(rq);
+	/* Else CPU is not idle, do nothing here: */
+	rq_unlock_irqrestore(rq, &rf);
 
 out:
 	rcu_read_unlock();
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -1170,14 +1170,14 @@ void wake_up_all_idle_cpus(void)
 {
 	int cpu;
 
-	preempt_disable();
+	cpus_read_lock();
 	for_each_online_cpu(cpu) {
-		if (cpu == smp_processor_id())
+		if (cpu == raw_smp_processor_id())
 			continue;
 
 		wake_up_if_idle(cpu);
 	}
-	preempt_enable();
+	cpus_read_unlock();
 }
 EXPORT_SYMBOL_GPL(wake_up_all_idle_cpus);
 


