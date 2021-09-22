Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D1F41479D
	for <lists+live-patching@lfdr.de>; Wed, 22 Sep 2021 13:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbhIVLSA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Sep 2021 07:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235796AbhIVLRp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Sep 2021 07:17:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36878C061768;
        Wed, 22 Sep 2021 04:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=75EGrJG7Ua+Es0fAsznLyLh2q7TOBPNVYsy60bS6edw=; b=HmNq4mJXWJ8ia0wswSKalCB3Cy
        lauZf2Z2y1kHDJk8DS8NEmTdVc8634MBLYBDRWO3aelKuYLbcsZsSThsz49/ymU0QjxdegnJdZQjO
        z6dFXxbOWe7YmAzToSu6vDico8+rTe10KhZXXo5HoM/9CeYueJI17KxYs84ny0fAIJUgBQa2WeXIe
        EzNg0fTP69B84k4tNIaDvNS0AkuwFC+hyZpaF/h3pzMCnLYvdiwsKjZFhFgQd99Xj6woC3bxFppGW
        NbkYCxakBemze0aDh0Gokrd0E8CbpFf8h9gFkL+z1AH2KKnjEb7oNLkD6CK0VMtqtMFrpUv43Yo00
        7cmJkLuw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mT09o-004isD-UR; Wed, 22 Sep 2021 11:11:37 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3EDA8300E56;
        Wed, 22 Sep 2021 13:11:19 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 8B846203C6486; Wed, 22 Sep 2021 13:11:18 +0200 (CEST)
Message-ID: <20210922110836.185239814@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 22 Sep 2021 13:05:11 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org
Subject: [RFC][PATCH 5/7] sched,livepatch: Use wake_up_if_idle()
References: <20210922110506.703075504@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Make sure to prod idle CPUs so they call klp_update_patch_state().

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/livepatch/transition.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -287,21 +287,21 @@ static int klp_check_task(struct task_st
  * running, or it's sleeping on a to-be-patched or to-be-unpatched function, or
  * if the stack is unreliable, return false.
  */
-static bool klp_try_switch_task(struct task_struct *task)
+static int klp_try_switch_task(struct task_struct *task)
 {
 	const char *old_name;
 	int ret;
 
 	/* check if this task has already switched over */
 	if (task->patch_state == klp_target_state)
-		return true;
+		return 0;
 
 	/*
 	 * For arches which don't have reliable stack traces, we have to rely
 	 * on other methods (e.g., switching tasks at kernel exit).
 	 */
 	if (!klp_have_reliable_stack())
-		return false;
+		return -EINVAL;
 
 	/*
 	 * Now try to check the stack for any to-be-patched or to-be-unpatched
@@ -324,7 +324,7 @@ static bool klp_try_switch_task(struct t
 		break;
 	}
 
-	return !ret;
+	return ret;
 }
 
 /*
@@ -394,7 +394,7 @@ void klp_try_complete_transition(void)
 	 */
 	read_lock(&tasklist_lock);
 	for_each_process_thread(g, task)
-		if (!klp_try_switch_task(task))
+		if (klp_try_switch_task(task))
 			complete = false;
 	read_unlock(&tasklist_lock);
 
@@ -405,8 +405,10 @@ void klp_try_complete_transition(void)
 	for_each_possible_cpu(cpu) {
 		task = idle_task(cpu);
 		if (cpu_online(cpu)) {
-			if (!klp_try_switch_task(task))
-				complete = false;
+			int ret = klp_try_switch_task(task);
+			if (ret == -EBUSY)
+				wake_up_if_idle(cpu);
+			complete = !ret;
 		} else if (task->patch_state != klp_target_state) {
 			/* offline idle tasks can be switched immediately */
 			clear_tsk_thread_flag(task, TIF_PATCH_PENDING);


