Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1EF57FFD6
	for <lists+live-patching@lfdr.de>; Mon, 25 Jul 2022 15:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbiGYNc1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 25 Jul 2022 09:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234946AbiGYNc0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 25 Jul 2022 09:32:26 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BBFDE96;
        Mon, 25 Jul 2022 06:32:24 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 6B7F61FB52;
        Mon, 25 Jul 2022 13:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1658755943; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t9LEZiaIxr7qWut5KwVWqnFFQS4Gg1WXbelNaKHOXxs=;
        b=ZawmajlquknUUrsNaNFuwHIe/SAjv+wxqrOqyi2DXAo1rlqiTjetta3AbZl0nNBVHRZwgT
        0hzfjG5w1QGJ43WbAPCdIOCiVlxnEfms76oYWwAz/GQ3zoYbE4+RvTXe7eeo9gToJjI1oV
        eONWmLAqsWsWHuvU5u1dCRkiz/g8FrA=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 4198F2C153;
        Mon, 25 Jul 2022 13:32:22 +0000 (UTC)
Date:   Mon, 25 Jul 2022 15:32:22 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Rik van Riel <riel@surriel.com>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        kernel-team@fb.com, Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH v2] livepatch: fix race between fork and
 klp_reverse_transition
Message-ID: <Yt6bZo5ztnVSjLLC@alley>
References: <20220720121023.043738bb@imladris.surriel.com>
 <YtrCqMLUqJlcoqIo@alley>
 <20220722150106.683f3704@imladris.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722150106.683f3704@imladris.surriel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2022-07-22 15:01:06, Rik van Riel wrote:
> v2: a better approach, suggested by Petr (thank you)
> ---8<---
> 
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
> 
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

It should fix these races as well. Both task->patch_state and
TIF_PATCH_PENDING flag are almost always modified under tasklist_lock.

One exception is klp_update_patch_state(current) but it could not
race because klp_copy_process() is called under spinlock.
So that "current" can't sleep and can't get migrated in the middle of
klp_copy_process().

Another exception is klp_check_and_switch_task() that is called
under p->pi_lock. It prevents rescheduling and the task will be
migrated only when sleeping. As a result "current" again
can't get migrated inside klp_copy_process().

Finally, the state of "idle" tasks (idle_task(cpu)) is updated
without tasklist_lock. But they are not forked so that we are
on safe side.


> Signed-off-by: Rik van Riel <riel@surriel.com>
> Reported-by: Breno Leitao <leitao@debian.org>

We should update the commit message and mention also the other
two locations where the state is manipulated without tasklist_lock.
I am sorry that I did not mention it on Friday.

Also we should remove "I have not figured yet whether". The patch
should fix these races as well.

With the above changes:

Reviewed-by: Petr Mladek <pmladek@suse.com>


Best Regards,
Petr
