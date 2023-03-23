Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B92526C6CF2
	for <lists+live-patching@lfdr.de>; Thu, 23 Mar 2023 17:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjCWQJX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Mar 2023 12:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjCWQJW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Mar 2023 12:09:22 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46422305EC
        for <live-patching@vger.kernel.org>; Thu, 23 Mar 2023 09:09:15 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 732E1337DB;
        Thu, 23 Mar 2023 16:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679587753; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=boL+SJne8q8SuTJQFSEiXvr9PJm3NE+cqxCZhlhZ1OY=;
        b=WSpkmpMRIMEf/QmmPX0L2EEtTqQhGlJVVfKguc4ZQRdsbxPns8JQUK8GT/wUeIC1DRVvDy
        IgUQ+3UdLO7vNqHaEYfBWnp71L0yBJa9Nlcj/YFGqwGWp6FzJQU/2FJCfxg/+Q/1HyzW80
        yWCe0QJeS1gRurIweS6E34wE1cMk1y4=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 4B07B2C141;
        Thu, 23 Mar 2023 16:09:13 +0000 (UTC)
Date:   Thu, 23 Mar 2023 17:09:10 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>, live-patching@vger.kernel.org
Subject: Re: question re klp_transition_work kickoff timeout
Message-ID: <ZBx5pvZXLv/ikl/f@alley>
References: <c84a0b0c-4232-451e-be0b-a6c29d69c1a8@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c84a0b0c-4232-451e-be0b-a6c29d69c1a8@p183>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2023-03-22 18:41:40, Alexey Dobriyan wrote:
> Hi, Josh.
> 
> I've been profiling how much time livepatching takes and I have a question
> regarding these lines:
> 
> 	void klp_try_complete_transition(void)
> 	{
> 		...
> 		if (!complete) {
> 			schedule_delayed_work(&klp_transition_work, round_jiffies_relative(HZ));
> 			return;
> 		}
> 
> 	}
> 
> The problem here is that if the system is idle, then the previous loop
> checking idle tasks will reliably sets "complete = false" and then
> patching wastes time waiting for next second so that klp_transition_work
> will repeat the same code without reentering itself.
> 
> I've created trivial patch which changes 2 functions and it takes
> ~1.3 seconds to complete transition:
> 
> 	[   33.829506] livepatch: 'main': starting patching transition
> 	[   35.190721] livepatch: 'main': patching complete
> 
> I don't know what's the correct timeout to retry transition work
> but it can be made near-instant:
> 
> 	[  100.930758] livepatch: 'main': starting patching transition
> 	[  100.956190] livepatch: 'main': patching complete
> 
> 
> 	Alexey (CloudLinux)
> 
> 
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -435,8 +435,7 @@ void klp_try_complete_transition(void)
>  		 * later and/or wait for other methods like kernel exit
>  		 * switching.
>  		 */
> -		schedule_delayed_work(&klp_transition_work,
> -				      round_jiffies_relative(HZ));
> +		schedule_delayed_work(&klp_transition_work, msecs_to_jiffies(1));

Note that this affects all iterations, not only the first one. In
practice, it might schedule another klp_transition_work() almost
immediately. Servers typically use HZ = 250 and 1ms is less than 1 jiffy.

Now, klp_try_complete_transition() takes tasklist_lock and blocks
forking and exiting. It sounds scary to do this so frequently.
Is am actually surprised that nobody reported any problems
even with the 1sec period.

Please, stop these micro-optimizations!

Livepatching is about security and reliability. It is not about speed!

The fact that the transition is so lazy is a great feature.
Livepatching should make the system more safe without breaking it.
It is great that it could run in background and do not limit
the normal workload too much.

Best Regards,
Petr
