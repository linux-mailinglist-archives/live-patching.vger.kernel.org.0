Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8009A698A80
	for <lists+live-patching@lfdr.de>; Thu, 16 Feb 2023 03:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjBPC0g (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Feb 2023 21:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBPC0f (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Feb 2023 21:26:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB0A2A17F;
        Wed, 15 Feb 2023 18:26:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 507E461E1D;
        Thu, 16 Feb 2023 02:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDA3C433D2;
        Thu, 16 Feb 2023 02:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676514393;
        bh=+1YgH0xe/A2Be/JRKsegZL1u9xW7M8fr+U7CjP8kcnE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p5vu/bydpgc5fAjGag4PVvXBMRbaLA3+xas/NcqmGtL5rHT0URl6/1kkFf1Scs6YH
         ePWpkHM+DhAYAAtFkj4fc4SnbffGMw7dfWuUPXmwOZD41GawM3vzriUZOS1S0UIdKn
         ZGPWu6X7kwyhqgsbkuHSn6aWN2plhao3m2HNbgPe0CfvkwmhwWrWxnU9s8K0UIePrl
         jY+9OI7xbsGIQSsq+WJcdywce1UhOT0iVqK3c69fbEqN8qydYYxO2sYNCBnIateTSh
         r6T097bvogzFx0IQsglYstF7c7PPs3V4VT1Fv48W+wSycw4TEzvKOtZHitv/z/yKDA
         Qp30YNHgD2Shw==
Date:   Wed, 15 Feb 2023 18:26:30 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <sforshee@digitalocean.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/3] livepatch,sched: Add livepatch task switching to
 cond_resched()
Message-ID: <20230216022630.h6mfl5cdqt5vbjno@treble>
References: <cover.1675969869.git.jpoimboe@kernel.org>
 <58cd637f7557e829142a2eb255daa91fa57e6321.1675969869.git.jpoimboe@kernel.org>
 <Y+zefMw6wqaXHZSz@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y+zefMw6wqaXHZSz@alley>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Feb 15, 2023 at 02:30:36PM +0100, Petr Mladek wrote:
> >  static inline int _cond_resched(void)
> >  {
> > +	klp_sched_try_switch();
> >  	return __cond_resched();
> 
> My only concern is if it might cause any performance problems.
> 
> On one hand, cond_resched() is used in code paths that are slow
> on its own. Also it will do nothing most of the time.
> 
> On the other hand, cond_resched() is typically used in cycles.
> One cycle might be fast. The code might be slow because there
> are too many cycles. Repeating the same failing test might
> prolong the time significantly.

Yes, but it should hopefully be very rare to patch a function in the
call stack of a kthread loop.  In general it's a good idea for the patch
author to avoid that.

> An idea is to try the switch only when it was not done during
> a real schedule. Something like:
> 
> static inline int _cond_resched(void)
> {
> 	int scheduled;
> 
> 	scheduled = __cond_resched();
> 	if (scheduled)
> 		klp_sched_try_switch();
> 
> 	return scheduled();
> }
> 
> But it would make it less reliable/predictable. Also it won't work
> in configurations when cond_resched() is always a nop.
> 
> I am probably too careful. We might keep it simple until any real
> life problems are reported.

If we can get away with it, I much prefer the simple unconditional
klp_sched_try_switch() because of the predictability and quickness with
which the kthread gets patched.

> > --- a/kernel/livepatch/transition.c
> > +++ b/kernel/livepatch/transition.c
> > @@ -76,6 +96,8 @@ static void klp_complete_transition(void)
> >  		 klp_transition_patch->mod->name,
> >  		 klp_target_state == KLP_PATCHED ? "patching" : "unpatching");
> >  
> > +	klp_cond_resched_disable();
> > +
> 
> Nit: Strictly speaking, this is not needed when klp_complete_transition()
>      is called from klp_cancel_transition(). In this case,
>      klp_cond_resched_enable() was not called. So it might be moved into
>      klp_try_complete_transition().

Argh, I always forget about that pesky klp_cancel_transition().

> More important thing, thinking loudly:
> 
> We need to make sure that no task is in the middle
> klp_cond_resched_disable() when we modify anything that is used there.
> 
> We seem to be on the safe side in klp_complete_transition(). We are
> here only when all tasks have TIF_PATCH_PENDING cleared. In this case,
> __klp_sched_try_switch() just returns. Also it calls
> klp_synchronize_transition() so that all tasks finish the critical part
> in __klp_sched_try_switch() before any new transition starts.
> 
> But it is not the case in klp_reverse_transition(). It modifies
> klp_target_state() when __klp_sched_try_switch might be in the middle
> of klp_check_stack() and it might give wrong result.
> 
> klp_reverse_transition() already solves similar race with
> klp_update_patch_state() by clearing all TIF_PATCH_PENDING flags
> and calling klp_synchronize_transition(). We just need to do
> it earlier. Something like:

Yes!  Thanks, I can always count on you to find the race conditions ;-)

This highlights the similarities between klp_target_state(current) and
__klp_sched_try_switch(), they both access TIF_PATCH_PENDING
out-of-band.

Also, I'll update the comment in klp_copy_process(). It should be safe
for with __klp_sched_try_switch() for the same reason as
klp_update_patch_state(current): they all only work on 'current'.

-- 
Josh
