Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55D541C9B7
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 18:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345577AbhI2QKD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 12:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244553AbhI2QJ5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 12:09:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE7FC0613E7;
        Wed, 29 Sep 2021 09:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=RtE+h02GAjMERG5ZHjDmVUOX9CyLA6Vahb+Yc8HRw8w=; b=B0459cRNxFb5kKN3t0Gw58/3+G
        uL2mqbWaGCCLdxVJRnO5MJmvm9TNKCiDGaZ0RzN5L4ElR28LnNA4N++uvbMipzv5kshRqUlaSBG03
        zUvm4McIipzHS6qcj8nnan46zTVaIQiXC9M80JN+tXion+nRI5FshkPQIyxWjUUIRaapq/mVJi4hb
        4Z+RT/uDTcpoaEzNcnnp9nTN1C36+gDMadvBb9eaQ7hizCcijkU/dFHmrvpsJYx+W34pJT2CjNyla
        E3PrzQUauY41ryUB19pqihwhBeyJp4c3GVAYtgqU0lzDcVY+3t+K14HVzCC5fN6Y2FxNNOddrpqGF
        2V+8FOSQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVbxk-00Bz4S-AU; Wed, 29 Sep 2021 15:57:54 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D4A4E302A1F;
        Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 4F60D2C905DA8; Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Message-ID: <20210929152429.125997206@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 29 Sep 2021 17:17:33 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: [RFC][PATCH v2 10/11] livepatch: Remove klp_synchronize_transition()
References: <20210929151723.162004989@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The whole premise is broken, any trace usage outside of RCU is a BUG
and should be fixed. Notable all code prior (and a fair bit after)
ct_user_exit() is noinstr and explicitly doesn't allow any tracing.

Use regular RCU, which has the benefit of actually respecting
NOHZ_FULL.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/livepatch/transition.c |   32 +++-----------------------------
 1 file changed, 3 insertions(+), 29 deletions(-)

--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -42,28 +42,6 @@ static void klp_transition_work_fn(struc
 static DECLARE_DELAYED_WORK(klp_transition_work, klp_transition_work_fn);
 
 /*
- * This function is just a stub to implement a hard force
- * of synchronize_rcu(). This requires synchronizing
- * tasks even in userspace and idle.
- */
-static void klp_sync(struct work_struct *work)
-{
-}
-
-/*
- * We allow to patch also functions where RCU is not watching,
- * e.g. before ct_user_exit(). We can not rely on the RCU infrastructure
- * to do the synchronization. Instead hard force the sched synchronization.
- *
- * This approach allows to use RCU functions for manipulating func_stack
- * safely.
- */
-static void klp_synchronize_transition(void)
-{
-	schedule_on_each_cpu(klp_sync);
-}
-
-/*
  * The transition to the target patch state is complete.  Clean up the data
  * structures.
  */
@@ -96,7 +74,7 @@ static void klp_complete_transition(void
 		 * func->transition gets cleared, the handler may choose a
 		 * removed function.
 		 */
-		klp_synchronize_transition();
+		synchronize_rcu();
 	}
 
 	klp_for_each_object(klp_transition_patch, obj)
@@ -105,7 +83,7 @@ static void klp_complete_transition(void
 
 	/* Prevent klp_ftrace_handler() from seeing KLP_UNDEFINED state */
 	if (klp_target_state == KLP_PATCHED)
-		klp_synchronize_transition();
+		synchronize_rcu();
 
 	read_lock(&tasklist_lock);
 	for_each_process_thread(g, task) {
@@ -168,10 +146,6 @@ noinstr void __klp_update_patch_state(st
  */
 void klp_update_patch_state(struct task_struct *task)
 {
-	/*
-	 * A variant of synchronize_rcu() is used to allow patching functions
-	 * where RCU is not watching, see klp_synchronize_transition().
-	 */
 	preempt_disable_notrace();
 
 	/*
@@ -626,7 +600,7 @@ void klp_reverse_transition(void)
 		clear_tsk_thread_flag(idle_task(cpu), TIF_PATCH_PENDING);
 
 	/* Let any remaining calls to klp_update_patch_state() complete */
-	klp_synchronize_transition();
+	synchronize_rcu();
 
 	klp_start_transition();
 }


