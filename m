Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4960D6A14A1
	for <lists+live-patching@lfdr.de>; Fri, 24 Feb 2023 02:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjBXBe3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Feb 2023 20:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjBXBe0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Feb 2023 20:34:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E9546081;
        Thu, 23 Feb 2023 17:34:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76579B81BE0;
        Fri, 24 Feb 2023 01:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941C2C4339B;
        Fri, 24 Feb 2023 01:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677202445;
        bh=sfc8vPmzmDYQ6qFv+VN2JCiBx6bhKzkHEHef6QEkz64=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EZU2b2pz9Oc0cigv6ehCuuC0JAKmID4XXo3ak/2BtGXozYfZqzIgHUmHTaCeP3C96
         MfHRQPJ7LtLHmfdtA8RWqDKwCmlbqlPi/lo2NK6WyUEcdg3nUcoZeaqgF/8Wdo4Msu
         cfVnTHY2sN3S9Yabk1chSUIyF50+EUw5dKuLLlDyWJ6acozg7rVvbnFNWj2TTfWkGY
         DnDBPhadaR2L7zl5Znima9KFO9vtFDupPJWoCU8uVT8f0YXM2fLo6vj4ATSiSAU7AK
         kHJPXzqaYUgzeAAhiQZQ0b/f+Fk57kMcs03OKiGPsXWPKq77sizsw2ANvMJhTLfItn
         dPT0k4XCPMFSQ==
Date:   Thu, 23 Feb 2023 17:34:02 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <sforshee@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH v2 2/3] livepatch,sched: Add livepatch task switching to
 cond_resched()
Message-ID: <20230224013402.hpq5ka4exetrdh4t@treble>
References: <cover.1676672328.git.jpoimboe@kernel.org>
 <9f09bff809fc026618108e8bbaac67ef2f8e6d3d.1676672328.git.jpoimboe@kernel.org>
 <Y/YgARbqsyvzebAl@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/YgARbqsyvzebAl@alley>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Feb 22, 2023 at 03:00:33PM +0100, Petr Mladek wrote:
> > +	/* All patching has stopped, now start the reverse transition. */
> > +	klp_transition_patch->enabled = !klp_transition_patch->enabled;
> > +	klp_target_state = !klp_target_state;
> 
> I have double checked the synchronization and we need here:
> 
> 	/*
> 	 * Make sure klp_update_patch_state() and __klp_sched_try_switch()
> 	 * see the updated klp_target_state before TIF_PATCH_PENDING
> 	 * is set again in klp_start_transition().
> 	 */
> 	smp_wmb();
> 
> The same is achieved by smp_wmb() in klp_init_transition().
> 
> Note that the extra barrier was missing here because klp_target_state
> was set before klp_synchronize_transition(). It was fine because
> klp_update_patch_state() was called on locations where a transition
> in any direction was always safe.
> 
> Just for record. We need to modify @klp_target_state after
> klp_synchronize_transition() now. The value is used by
> __klp_sched_try_switch() to decide when the transition
> is safe. It defines what functions must not be on the stack.

Yes, makes sense.  And we need a corresponding smp_rmb() in
__klp_sched_try_switch() before the call to klp_try_switch_task(),
right?

Something like this on top?  Also updated a few more comments.

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 201f0c0482fb..3f79265dd6e5 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -33,6 +33,7 @@
  *
  * - klp_ftrace_handler()
  * - klp_update_patch_state()
+ * - __klp_sched_try_switch()
  */
 DEFINE_MUTEX(klp_mutex);
 
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index b9e006632124..218ef4a5d575 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -192,8 +192,8 @@ void klp_update_patch_state(struct task_struct *task)
 	 * barrier (smp_rmb) for two cases:
 	 *
 	 * 1) Enforce the order of the TIF_PATCH_PENDING read and the
-	 *    klp_target_state read.  The corresponding write barrier is in
-	 *    klp_init_transition().
+	 *    klp_target_state read.  The corresponding write barriers are in
+	 *    klp_init_transition() and klp_reverse_transition().
 	 *
 	 * 2) Enforce the order of the TIF_PATCH_PENDING read and a future read
 	 *    of func->transition, if klp_ftrace_handler() is called later on
@@ -381,6 +381,14 @@ void __klp_sched_try_switch(void)
 	if (unlikely(!klp_patch_pending(current)))
 		goto out;
 
+	/*
+	 * Enforce the order of the TIF_PATCH_PENDING read above and the
+	 * klp_target_state read in klp_try_switch_task().  The corresponding
+	 * write barriers are in klp_init_transition() and
+	 * klp_reverse_transition().
+	 */
+	smp_rmb();
+
 	klp_try_switch_task(current);
 
 out:
@@ -604,8 +612,9 @@ void klp_init_transition(struct klp_patch *patch, int state)
 	 * see a func in transition with a task->patch_state of KLP_UNDEFINED.
 	 *
 	 * Also enforce the order of the klp_target_state write and future
-	 * TIF_PATCH_PENDING writes to ensure klp_update_patch_state() doesn't
-	 * set a task->patch_state to KLP_UNDEFINED.
+	 * TIF_PATCH_PENDING writes to ensure klp_update_patch_state() and
+	 * __klp_sched_try_switch() don't set a task->patch_state to
+	 * KLP_UNDEFINED.
 	 */
 	smp_wmb();
 
@@ -661,9 +670,19 @@ void klp_reverse_transition(void)
 	 */
 	klp_synchronize_transition();
 
-	/* All patching has stopped, now start the reverse transition. */
+	/* All patching has stopped, now start the reverse transition: */
+
 	klp_transition_patch->enabled = !klp_transition_patch->enabled;
 	klp_target_state = !klp_target_state;
+
+	/*
+	 * Enforce the order of the klp_target_state write and the
+	 * TIF_PATCH_PENDING writes in klp_start_transition() to ensure
+	 * klp_update_patch_state() and __klp_sched_try_switch() don't set
+	 * task->patch_state to the wrong value.
+	 */
+	smp_wmb();
+
 	klp_start_transition();
 }
 
