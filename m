Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667F2520F3C
	for <lists+live-patching@lfdr.de>; Tue, 10 May 2022 09:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237574AbiEJIA6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 May 2022 04:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237543AbiEJIA5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 May 2022 04:00:57 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8AE1E251D;
        Tue, 10 May 2022 00:56:51 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D240F21B2F;
        Tue, 10 May 2022 07:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652169409; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ZUtK17hBNi/Td6QjHwkqgCi5bgm/d69DDW/g/56M8s=;
        b=Vz2UetjMX1QNQkhz/4lkCD4aJvTxtPPvFqqVkjpDar6JysSHDsVhT+r5olJ2KnUmt/iv/w
        4l6bjj1ncF7O39Y9TNILbvo9iUBkARApAyGxeXQhwFjPDmsE9SblErbd8a7hDeJoffNvug
        U7qB1rd6+qUR+Q708VLARz5TRFOyk5c=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id ABC412C141;
        Tue, 10 May 2022 07:56:49 +0000 (UTC)
Date:   Tue, 10 May 2022 09:56:49 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Message-ID: <YnoawYtoCSvrK7lb@alley>
References: <20220507174628.2086373-1-song@kernel.org>
 <YnkuFrm1YR46OFx/@alley>
 <9C7DF147-5112-42E7-9F7C-7159EFDFB766@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9C7DF147-5112-42E7-9F7C-7159EFDFB766@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2022-05-09 16:22:11, Song Liu wrote:
> 
> 
> > On May 9, 2022, at 8:07 AM, Petr Mladek <pmladek@suse.com> wrote:
> > 
> > On Sat 2022-05-07 10:46:28, Song Liu wrote:
> >> Busy kernel threads may block the transition of livepatch. Call
> >> klp_try_switch_task from __cond_resched to make the transition easier.
> > 
> > Do you have some numbers how this speeds up the transition
> > and how it slows down the scheduler, please?
> 
> We don’t have number on how much this would slow down the scheduler. 
> For the transition, we see cases where the transition cannot finish
> with in 60 seconds (how much "kpatch load" waits by default). 

60s might be too low limit, see below.

> > cond_resched() is typically called in cycles with many interactions
> > where the task might spend a lot of time. There are two possibilities.
> > cond_resched() is called in:
> > 
> >   + livepatched function
> > 
> >     In this case, klp_try_switch_task(current) will always fail.
> >     And it will non-necessarily slow down every iteration by
> >     checking the very same stack.
> > 
> > 
> >   + non-livepatched function
> > 
> >     In this case, the transition will succeed on the first attempt.
> >     OK, but it would succeed also without that patch. The task would
> >     most likely sleep in this cond_resched() so that it might
> >     be successfully transitioned on the next occasion.
> 
> We are in the non-live patched case. But the transition didn’t happen
> in time, because the kernel thread doesn’t go to sleep. While there is
> clearly something weird with this thread, we think live patch should 
> work because the thread does call cond_resched from time to time. 

I guess that it goes to sleep. Otherwise it would trigger soft lockup
report if you have the watchdog enabled.

IMHO, the problem is that klp_transition_work_fn() tries the
transition "only" once per second, see

void klp_try_complete_transition(void)
{
[...]
		schedule_delayed_work(&klp_transition_work,
				      round_jiffies_relative(HZ));
[...]
}

It means that there are "only" 60 attempts to migrate the busy process.
It fails when the process is in the running state or sleeping in a
livepatched function. There is a _non-zero_ chance of a bad luck.

It would be great to measure how long it will take to complete
the transition if you remove the limit 60s.


Anyway, the limit 60s looks like a bad idea to me. It is too low.
For example, we do not use any limit at all in SUSE products.
And the only report was that some thread from a 3rd party
module could not be migrated. It was stuck with a livepatched
function on the stack. The kthread had really problematic
design. I am afraid that even this patch would not help
in that case.


Now, back to the limit. There are basically two problems when
the transition takes too long:

    + It blocks another transition. But the frequency of new
      livepatches it typically counted in days or even weeks.


    + It means that a process is running the buggy/vulnerable
      code longer time. But few hours should be acceptable
      given how long it takes to prepare the livepatch.

      Also it looks better to have 99.9% of processes running
      the fixed code that revert the fix just because a single
      process needs longer time to get transitioned.


I could imagine that there really is a process that is almost
impossible to livepatch. It might get worse on NO_HZ system.
The question is it happens in the real life.

I would personally start with prolonging or removing the limit.

Best Regards,
Petr
