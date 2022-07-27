Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A5B581CA7
	for <lists+live-patching@lfdr.de>; Wed, 27 Jul 2022 02:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiG0AKs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 26 Jul 2022 20:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiG0AKr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 26 Jul 2022 20:10:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB62B6147;
        Tue, 26 Jul 2022 17:10:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8524460F0A;
        Wed, 27 Jul 2022 00:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826A8C433C1;
        Wed, 27 Jul 2022 00:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658880642;
        bh=DccIhri+UWz0V27fSCjeICJ7Lf2QQ0rDDGyKMMX5HCQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OJmf+TkdfZku5jpbWVXhliIiAGk3Vblm829Fz78xH6KqgYaBLQFZdDrHI0pXrwoYf
         fkOlJwesBynUuYOQejQMc2DUAOBAvutqO7tYCIav5zPxtwCIMCtlnyUsO0YbkoT64u
         o95xm8TDccRQHzUtsrt6rMU55bSODj0vcqhVuNn6hdDQ9FshgTeRwr9U2pc9uX4Ikk
         qZiq93SLH4tH2sVMjdYwp80PAAvUsWLH4ujgwmb++Nz8bMqtaVTRsnvYzhUbQ3oyj+
         Nl/h0Y+DhoBInJbKoIn4fXiaBDnsTLQP98aGHJSpa8dnZEfOYxjTa36j4REHHTZvWd
         /IhpwXqvu57pQ==
Date:   Tue, 26 Jul 2022 17:10:40 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Rik van Riel <riel@surriel.com>
Cc:     Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, kernel-team@fb.com,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH v3] livepatch: fix race between fork and
 klp_reverse_transition
Message-ID: <20220727001040.vlqnnb4a3um46746@treble>
References: <20220720121023.043738bb@imladris.surriel.com>
 <YtrCqMLUqJlcoqIo@alley>
 <20220722150106.683f3704@imladris.surriel.com>
 <Yt6bZo5ztnVSjLLC@alley>
 <20220725094919.52bcde19@imladris.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220725094919.52bcde19@imladris.surriel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Jul 25, 2022 at 09:49:19AM -0400, Rik van Riel wrote:
> When a KLP fails to apply, klp_reverse_transition will clear the
> TIF_PATCH_PENDING flag on all tasks, except for newly created tasks
> which are not on the task list yet.

This paragraph and $SUBJECT both talk about a reverse transition.  Isn't
it also possible to race on a normal (forward) transition?

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

Use imperative language, i.e. no "This patch".  See
Documentation/process/submitting-patches.rst
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
> future.
> 

Fixes: d83a7cb375ee ("livepatch: change to a per-task consistency model")

> Signed-off-by: Rik van Riel <riel@surriel.com>
> Reported-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Petr Mladek <pmladek@suse.com>

With the above minor things fixed:

Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>

-- 
Josh
