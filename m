Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838F341475B
	for <lists+live-patching@lfdr.de>; Wed, 22 Sep 2021 13:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhIVLNB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Sep 2021 07:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbhIVLNA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Sep 2021 07:13:00 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0730CC061756;
        Wed, 22 Sep 2021 04:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=SvSU7b9tUT6uTyU/Zk7s1QnrnWFQeYoGhiD90JnN0AI=; b=rhWKGWYfFMCNhp1dvsllFtrh1N
        S+aI1cE+elDNzQfKXNa+ARjqZS25FDrhF9jesyt3RccNywbsSzzNpmuQlaOdzKPDBo5gGJeBORcvU
        6qny2upFscUK4pgGmVieGZnKwU9ICCQaNvV8m2aax2lrtG/meoSkebn5gVlap0BNsaGKjPcqkHtLB
        q5AYEY+lhZTKfET6bbiYWXW5QtEougZlGlGE4Ci/0YeFpqNYvEIzR5/AE2aQLVhzWGQPHov9Ln517
        dHS44HSMScmu1I17E5Kb28HnpXlEuxmInDUD8vOy+i+1skUR5rzgMxTBBWXz5WD3hpygR4zUvUgOj
        JTwAOtrA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mT09p-004yYY-0G; Wed, 22 Sep 2021 11:11:21 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3EE06300EC9;
        Wed, 22 Sep 2021 13:11:19 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 94A52206A3E4F; Wed, 22 Sep 2021 13:11:18 +0200 (CEST)
Message-ID: <20210922110836.304335737@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 22 Sep 2021 13:05:13 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org
Subject: [RFC][PATCH 7/7] livepatch,context_tracking: Avoid disturbing NOHZ_FULL tasks
References: <20210922110506.703075504@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

When a task is stuck in NOHZ_FULL usermode, we can simply mark the
livepatch state complete.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/livepatch/transition.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -270,13 +270,24 @@ static int klp_check_task(struct task_st
 {
 	int ret;
 
-	if (task_curr(task))
+	if (task_curr(task)) {
+		if (context_tracking_state_cpu(task_cpu(task)) == CONTEXT_USER) {
+			/*
+			 * If we observe the CPU being in USER context, they
+			 * must issue an smp_mb() before doing much kernel
+			 * space and as such will observe the patched state,
+			 * mark it clean.
+			 */
+			goto complete;
+		}
 		return -EBUSY;
+	}
 
 	ret = klp_check_stack(task, arg);
 	if (ret)
 		return ret;
 
+complete:
 	clear_tsk_thread_flag(task, TIF_PATCH_PENDING);
 	task->patch_state = klp_target_state;
 	return 0;


