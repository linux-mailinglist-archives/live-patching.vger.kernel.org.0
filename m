Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620E757E3CB
	for <lists+live-patching@lfdr.de>; Fri, 22 Jul 2022 17:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbiGVPaz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 22 Jul 2022 11:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbiGVPay (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 22 Jul 2022 11:30:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E51861137;
        Fri, 22 Jul 2022 08:30:53 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 3B6AF38191;
        Fri, 22 Jul 2022 15:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1658503852; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PY0km1b0c4QCpa5lX65f+GqyyO69GGtiugaAUPVq0/8=;
        b=TvL/mQHkAM+yTOvUaVY1orKzq7Tv1pgSyGAtnqEvKAqcKMBM/zZUHOu2kIAlkDhuoxdica
        F4HXvtxEKIKF34FkPRF6rsCNsNpxz2qdqnvC5wY6btIfCqMcy8en+fwgY9vlcqJUeUUdo3
        pNV5J2eFg0x7TARJJ1BIurqykaBmA3k=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 11D822C15A;
        Fri, 22 Jul 2022 15:30:51 +0000 (UTC)
Date:   Fri, 22 Jul 2022 17:30:48 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Rik van Riel <riel@surriel.com>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        kernel-team@fb.com, Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH,RFC] livepatch: fix race between fork and
 klp_reverse_transition
Message-ID: <YtrCqMLUqJlcoqIo@alley>
References: <20220720121023.043738bb@imladris.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720121023.043738bb@imladris.surriel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-07-20 12:10:23, Rik van Riel wrote:
> When a KLP fails to apply, klp_reverse_transition will clear the
> TIF_PATCH_PENDING flag on all tasks, except for newly created tasks
> which are not on the task list yet.
> 
> Meanwhile, fork will copy over the TIF_PATCH_PENDING flag from the
> parent to the child early on, in dup_task_struct -> setup_thread_stack.
> 
> Much later, klp_copy_process will set child->patch_state to match
> that of the parent.
> 
> However, the parent's patch_state may have been changed by KLP loading
> or unloading since it was initially copied over into the child.
> 
> This results in the KLP code occasionally hitting this warning in
> klp_complete_transition:
> 
>         for_each_process_thread(g, task) {
>                 WARN_ON_ONCE(test_tsk_thread_flag(task, TIF_PATCH_PENDING));
>                 task->patch_state = KLP_UNDEFINED;
>         }

I see.

> This patch will set, or clear, the TIF_PATCH_PENDING flag in the child
> process depending on whether or not it is needed at the time
> klp_copy_process is called, at a point in copy_process where the
> tasklist_lock is held exclusively, preventing races with the KLP
> code.
> 
> This should prevent this warning from triggering again in the
> future.
> 
> I have not yet figured out whether this would also help with races in
> the other direction, where the child process fails to have TIF_PATCH_PENDING
> set and somehow misses a transition, or whether the retries in
> klp_try_complete_transition would catch that task and help it transition
> later.
> 
> Signed-off-by: Rik van Riel <riel@surriel.com>
> Reported-by: Breno Leitao <leitao@debian.org>
> ---
>  kernel/livepatch/transition.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index 5d03a2ad1066..7a90ad5e9224 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -612,7 +612,15 @@ void klp_copy_process(struct task_struct *child)
>  {
>  	child->patch_state = current->patch_state;
>  
> -	/* TIF_PATCH_PENDING gets copied in setup_thread_stack() */
> +	/*
> +	 * The parent process may have gone through a KLP transition since
> +	 * the thread flag was copied in setup_thread_stack earlier. Set
> +	 * the flag according to whether this task needs a KLP transition.
> +	 */
> +	if (child->patch_state != klp_target_state)
> +		set_tsk_thread_flag(child, TIF_PATCH_PENDING);
> +	else
> +		clear_tsk_thread_flag(child, TIF_PATCH_PENDING);
>  }

I am afraid that it is more complicated.

If the parent process might have gone through a KLP transition
then also the transition might have finished and klp_target_state might be
KLP_UNDEFINED. We must not set TIF_PATCH_PENDING in this case.

Now, we might race with klp_complete_transition() at any stage. It
might be before or after setting task->patch_state = KLP_UNDEFINED.
And it might be before or after setting klp_target_state =
KLP_UNDEFINED.

The great thing is that we could not race with
klp_update_patch_state() that would be migrating current because
we are current.

So, the easiest solution would be to copy the flag from current
once again here:


/* Called from copy_process() during fork */
void klp_copy_process(struct task_struct *child)
{
	/*
	 * The parent process may have gone through a KLP transition since
	 * the thread flag was copied in setup_thread_stack earlier.
	 * Copy also the flag once again here.
	 *
	 * The operation is serialized against all klp_*_transition()
	 * operations by tasklist_lock. The only exception is
	 * klp_update_patch_state(current). But it could not race
	 * because we are current.
	 */
	if (test_tsk_thread_flag(current, TIF_PATCH_PENDING))
		set_tsk_thread_flag(child, TIF_PATCH_PENDING);
	else
		clear_tsk_thread_flag(child, TIF_PATCH_PENDING);

	child->patch_state = current->patch_state;
}


I hope that I did not miss anything. It is Friday.

Best Regards,
Petr
