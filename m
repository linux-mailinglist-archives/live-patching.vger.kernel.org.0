Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492FA6A1FD6
	for <lists+live-patching@lfdr.de>; Fri, 24 Feb 2023 17:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjBXQmU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 24 Feb 2023 11:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjBXQmT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 24 Feb 2023 11:42:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03EE67E38;
        Fri, 24 Feb 2023 08:42:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B59561941;
        Fri, 24 Feb 2023 16:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED8EC433EF;
        Fri, 24 Feb 2023 16:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677256937;
        bh=s6C+TdkeqntvqIk6zgLKE/tjpWY4dsk2LVht4gGZ1vQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GPWNKOaBs+MjXnAqPCn7s3y7HINni6vYtWlKWINPIHK2U+Pgj04csam5gj/ZQGR1A
         EFxRfdm+ViHnqomMbDBkdo/DSV6h91VsxTvUeiaB9YDdl/5cL5Ha2apr8rBGKOKiLF
         Y4q+vox1FsmncQ1al5g10F73e/YkcScD8tS/06+QYYZs/XffFqMugDfaFRfzyWdbGs
         hAlmwlDuOedn8ywq0xf9RNwTu2CPBQJkfUzv3QLklZ4b1o6yZ3b1oaRUagiECvmGk8
         ZJYo958BJWOz45NoBpJcR5nTaTEXI+IzXDZjFellzGfFUTzsxE6rHCV44h7afbyEnu
         1+pf499ikxeSA==
Date:   Fri, 24 Feb 2023 08:42:15 -0800
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
Message-ID: <20230224164215.ubnftmmhqqkh5zps@treble>
References: <cover.1676672328.git.jpoimboe@kernel.org>
 <9f09bff809fc026618108e8bbaac67ef2f8e6d3d.1676672328.git.jpoimboe@kernel.org>
 <Y/YgARbqsyvzebAl@alley>
 <20230224013402.hpq5ka4exetrdh4t@treble>
 <Y/jfUlPm7uCWvHPl@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/jfUlPm7uCWvHPl@alley>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Feb 24, 2023 at 05:01:22PM +0100, Petr Mladek wrote:
> > @@ -381,6 +381,14 @@ void __klp_sched_try_switch(void)
> >  	if (unlikely(!klp_patch_pending(current)))
> >  		goto out;
> >  
> > +	/*
> > +	 * Enforce the order of the TIF_PATCH_PENDING read above and the
> > +	 * klp_target_state read in klp_try_switch_task().  The corresponding
> > +	 * write barriers are in klp_init_transition() and
> > +	 * klp_reverse_transition().
> > +	 */
> > +	smp_rmb();
> 
> This barrier has basically the same purpose as the implicit read
> barrier in klp_update_patch_state().
> 
> The comment in klp_update_patch_state() says that the read barrier
> actually has two purposes. The 1st one is easy. It is the one
> described above.
> 
> It took me quite some time to understand the 2nd purpose again.
> The original comment was:
> 
> 	 * 2) Enforce the order of the TIF_PATCH_PENDING read and a future read
> 	 *    of func->transition, if klp_ftrace_handler() is called later on
> 	 *    the same CPU.  See __klp_disable_patch().
> 
> I think that a better description would be:
> 
> 	 * 2) Make sure that this CPU sees func->transition enabled when
> 	 *    it sees the TIF_PATCH_PENDING enabled. This is important when
> 	 *    the current task is transitioning itself and then calls
> 	 *    klp_ftrace_handler() later. It ensures that the ftrace handler
> 	 *    would check the state change that we did here.
> 	 *    The corresponding write barrier is in __klp_enable_patch()
> 	 *    and __klp_disable_patch().
> 
> Note that the previous comment wasn't correct. IMHO, the related write
> barrier is needed in both __klp_enable_patch() and __klp_disable_patch().

That 2nd comment also confused me.  Yours is definitely better!

> > @@ -661,9 +670,19 @@ void klp_reverse_transition(void)
> >  	 */
> >  	klp_synchronize_transition();
> >  
> > -	/* All patching has stopped, now start the reverse transition. */
> > +	/* All patching has stopped, now start the reverse transition: */
> > +
> 
> Is the extra empty line intended?

Due to the additional comment and whitespace added below, I added
whitespace here to try to imply that the comment doesn't only apply to
the following two lines, but also the code after it.  I'm open to
suggestions :-)

> >  	klp_transition_patch->enabled = !klp_transition_patch->enabled;
> >  	klp_target_state = !klp_target_state;
> > +
> > +	/*
> > +	 * Enforce the order of the klp_target_state write and the
> > +	 * TIF_PATCH_PENDING writes in klp_start_transition() to ensure
> > +	 * klp_update_patch_state() and __klp_sched_try_switch() don't set
> > +	 * task->patch_state to the wrong value.
> > +	 */
> > +	smp_wmb();
> > +
> >  	klp_start_transition();
> >  }
> 
> This made me to revisit all the barriers in the livepatch code.
> The good thing is that it seems that all the barriers are correct,
> including the new ones proposed in this patchset.

That's good news :-)

> But some comments are a bit misleading. I would like to update
> them a bit. I have started working on it but it goes slowly.
> I often get lost...
> 
> I am not sure about the ordering. I do not want to block this patchset
> by the clean up of the comments. The currently proposed ones are
> good enough. Feel free to send v3.
> 
> Or would you prefer to wait for my clean up of the comments?

Sounds good, I'll send v3 soon and you can base your updates on top.

-- 
Josh
