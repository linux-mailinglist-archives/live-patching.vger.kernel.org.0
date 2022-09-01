Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84DA5A9955
	for <lists+live-patching@lfdr.de>; Thu,  1 Sep 2022 15:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbiIANqB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Sep 2022 09:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbiIANqA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Sep 2022 09:46:00 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2E137FB5;
        Thu,  1 Sep 2022 06:45:55 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D5E0C200CC;
        Thu,  1 Sep 2022 13:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662039953; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nSURrOH9P4YKwSraTwcmaGMvcKZkEZ2JggeQckqz4vc=;
        b=jUj8VftaV4I60v+w4bt57eftu/3LKADNVK7bgIaQUP0VcsPpFyjdW/ZORs6+Lti3oNbZxR
        G5sDJ04mWSSel6T9mlxg1VTdnlz1uSLkwuCBcdR/WWL+hcZjKOzNXOM4O9iJJES9Zu5yGq
        wdhSUiQ0XWYd7x9Vv570C2ARzbjEpdo=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id B4DFD2C142;
        Thu,  1 Sep 2022 13:45:53 +0000 (UTC)
Date:   Thu, 1 Sep 2022 15:45:50 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Rik van Riel <riel@surriel.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, kernel-team@fb.com,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v5]  livepatch: fix race between fork and KLP transition
Message-ID: <YxC3jqHIHheHCaG0@alley>
References: <20220808150019.03d6a67b@imladris.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220808150019.03d6a67b@imladris.surriel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2022-08-08 15:00:19, Rik van Riel wrote:
> The KLP transition code depends on the TIF_PATCH_PENDING and
> the task->patch_state to stay in sync. On a normal (forward)
> transition, TIF_PATCH_PENDING will be set on every task in
> the system, while on a reverse transition (after a failed
> forward one) first TIF_PATCH_PENDING will be cleared from
> every task, followed by it being set on tasks that need to
> be transitioned back to the original code.
> 
> However, the fork code copies over the TIF_PATCH_PENDING flag
> from the parent to the child early on, in dup_task_struct and
> setup_thread_stack. Much later, klp_copy_process will set
> child->patch_state to match that of the parent.
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
> Set, or clear, the TIF_PATCH_PENDING flag in the child task
> depending on whether or not it is needed at the time
> klp_copy_process is called, at a point in copy_process where the
> tasklist_lock is held exclusively, preventing races with the KLP
> code.
> 
> The KLP code does have a few places where the state is changed
> without the tasklist_lock held, but those should not cause
> problems because klp_update_patch_state(current) cannot be
> called while the current task is in the middle of fork,
> klp_check_and_switch_task() which is called under the pi_lock,
> which prevents rescheduling, and manipulation of the patch
> state of idle tasks, which do not fork.
> 
> This should prevent this warning from triggering again in the
> future, and close the race for both normal and reverse transitions.
> 
> Signed-off-by: Rik van Riel <riel@surriel.com>
> Reported-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Fixes: d83a7cb375ee ("livepatch: change to a per-task consistency model")
> Cc: stable@kernel.org

The patch has been pushed to livepatching/livepaching.git,
branch for-6.1/fixes.

Best Regards,
Petr
