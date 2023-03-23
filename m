Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1656C6D48
	for <lists+live-patching@lfdr.de>; Thu, 23 Mar 2023 17:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjCWQWP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Mar 2023 12:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCWQWP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Mar 2023 12:22:15 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E58FF08
        for <live-patching@vger.kernel.org>; Thu, 23 Mar 2023 09:22:13 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 98758337DC;
        Thu, 23 Mar 2023 16:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679588532; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TEGa3imml5QmHNxKxB7n+2ORz/ZeiBWkWM9BJpnvHZ4=;
        b=XaAim/LNOjaSLm+PCsMUyTek97bpaVCJxthseNXIFe7A03bzw5cQXxAzlJmYiT6SVN5DLs
        QMsqo/jsINaXZhWLrqKBtNfzdDBP7uSfXhbYGgiGQNoegFTxzEZrbwOtZ6YEkXErBVlhgm
        ncomfIPFPuYifrI0BabZ2W8C6zv8Yg4=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 70A762C141;
        Thu, 23 Mar 2023 16:22:12 +0000 (UTC)
Date:   Thu, 23 Mar 2023 17:22:09 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>, live-patching@vger.kernel.org
Subject: Re: question re klp_transition_work kickoff timeout
Message-ID: <ZBx8sRTmpljI/i6Z@alley>
References: <c84a0b0c-4232-451e-be0b-a6c29d69c1a8@p183>
 <ZBx5pvZXLv/ikl/f@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBx5pvZXLv/ikl/f@alley>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2023-03-23 17:09:13, Petr Mladek wrote:
> On Wed 2023-03-22 18:41:40, Alexey Dobriyan wrote:
> > Hi, Josh.
> > 
> > I've been profiling how much time livepatching takes and I have a question
> > regarding these lines:
> > 
> > 	void klp_try_complete_transition(void)
> > 	{
> > 		...
> > 		if (!complete) {
> > 			schedule_delayed_work(&klp_transition_work, round_jiffies_relative(HZ));
> > 			return;
> > 		}
> > 
> > 	}
> > 
> > The problem here is that if the system is idle, then the previous loop
> > checking idle tasks will reliably sets "complete = false" and then
> > patching wastes time waiting for next second so that klp_transition_work
> > will repeat the same code without reentering itself.
> > 
> > I've created trivial patch which changes 2 functions and it takes
> > ~1.3 seconds to complete transition:
> > 
> > 	[   33.829506] livepatch: 'main': starting patching transition
> > 	[   35.190721] livepatch: 'main': patching complete
> > 
> > I don't know what's the correct timeout to retry transition work
> > but it can be made near-instant:
> > 
> > 	[  100.930758] livepatch: 'main': starting patching transition
> > 	[  100.956190] livepatch: 'main': patching complete
> > 
> > 
> > 	Alexey (CloudLinux)
> > 
> > 
> > --- a/kernel/livepatch/transition.c
> > +++ b/kernel/livepatch/transition.c
> > @@ -435,8 +435,7 @@ void klp_try_complete_transition(void)
> >  		 * later and/or wait for other methods like kernel exit
> >  		 * switching.
> >  		 */
> > -		schedule_delayed_work(&klp_transition_work,
> > -				      round_jiffies_relative(HZ));
> > +		schedule_delayed_work(&klp_transition_work, msecs_to_jiffies(1));
> 
> Note that this affects all iterations, not only the first one. In
> practice, it might schedule another klp_transition_work() almost
> immediately. Servers typically use HZ = 250 and 1ms is less than 1 jiffy.
> 
> Now, klp_try_complete_transition() takes tasklist_lock and blocks
> forking and exiting. It sounds scary to do this so frequently.
> Is am actually surprised that nobody reported any problems
> even with the 1sec period.
> 
> Please, stop these micro-optimizations!
> 
> Livepatching is about security and reliability. It is not about speed!
> 
> The fact that the transition is so lazy is a great feature.
> Livepatching should make the system more safe without breaking it.
> It is great that it could run in background and do not limit
> the normal workload too much.

By other words. It might be interesting to find a way how to migrate
the idle tasks during the first klp_try_complete_transition() call.
As a result the 2nd call would not be needed and it would make
livepatching even more lightweight.

But just increasing the frequency of klp_try_complete_transition()
is not the way to go.

Best Regards,
Petr
