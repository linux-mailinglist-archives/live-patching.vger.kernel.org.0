Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BA741C9B6
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 18:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345560AbhI2QKC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 12:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344482AbhI2QJ5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 12:09:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724F3C0613E6;
        Wed, 29 Sep 2021 09:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=qNA3H7BdPTTgZjI5KuMBnDmufUgkuTSS/0So5BCWOhk=; b=dKon8KzNoGMamPvUQhqqBVG/N0
        ICJd3/cadNps/+J4jfL3B798dylBuuNtc39L1QBN5SBEKyhXhpIT8WSa0uDepa72SD3H+UDKdrbRT
        uy8mVjpvvDotJ8CFRNCbyvE2W7xbAmfskcy7I9lEj1dpG8SzTLrXPZndJ6O6OYEuXu57w98dBzeTZ
        O5+9iaS6LDthTo07Ic41l6wZgiEPcZyLmyt99s6yFRpskKB/glylaHZSlso0PgywRkCQ295R0cNq6
        8nMNvoI6g2pDe8JB/lDrc9fBn0HQwbc8OpEExG28+84Q5gzT5Mq/kXH4ElkqQ0/EcRryy33FLWCZ1
        +9hePxKw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVbxi-00Bz4P-Un; Wed, 29 Sep 2021 15:57:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 48B3B300EE4;
        Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 289C52C78F4FC; Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Message-ID: <20210929152428.769328779@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 29 Sep 2021 17:17:27 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: [PATCH v2 04/11] sched: Simplify wake_up_*idle*()
References: <20210929151723.162004989@infradead.org>
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
 


