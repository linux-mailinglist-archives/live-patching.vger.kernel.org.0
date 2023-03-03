Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15F56A98F5
	for <lists+live-patching@lfdr.de>; Fri,  3 Mar 2023 15:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjCCOAT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 Mar 2023 09:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCCOAS (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 Mar 2023 09:00:18 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F3819F05;
        Fri,  3 Mar 2023 06:00:17 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 233E022C28;
        Fri,  3 Mar 2023 14:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1677852016; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TSPgcgYep19sTblrzTc534Psr8I1LCQa3PoV9+gaqwY=;
        b=Js6lzoGRnwnC26dHJ38ZpYrqKV6zGXVayz47S60UXFrJiVG0Z1bubyjVPR2nJTdFDBzpN4
        +Q0olmSqlXkKafI729qXr06A82ygwBMoP/mFTnYOLy8+e+CqXy+JsqBSmEfNWnRVvUNp0p
        IFpl9OsqFmeM4yi1Ut03xJaLQ7Ik848=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id AA6F02C141;
        Fri,  3 Mar 2023 14:00:13 +0000 (UTC)
Date:   Fri, 3 Mar 2023 15:00:13 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <sforshee@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH v3 2/3] livepatch,sched: Add livepatch task switching to
 cond_resched()
Message-ID: <ZAH9baGIOVL4/OHM@alley>
References: <cover.1677257135.git.jpoimboe@kernel.org>
 <4ae981466b7814ec221014fc2554b2f86f3fb70b.1677257135.git.jpoimboe@kernel.org>
 <Y/zSgw5LOpbp7e/A@alley>
 <20230228165608.kumgxziaietsjaz3@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228165608.kumgxziaietsjaz3@treble>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2023-02-28 08:56:08, Josh Poimboeuf wrote:
> On Mon, Feb 27, 2023 at 04:55:47PM +0100, Petr Mladek wrote:
> > On Fri 2023-02-24 08:50:00, Josh Poimboeuf wrote:
> > > There have been reports [1][2] of live patches failing to complete
> > > within a reasonable amount of time due to CPU-bound kthreads.
> > > 
> > > Fix it by patching tasks in cond_resched().
> > > 
> > > There are four different flavors of cond_resched(), depending on the
> > > kernel configuration.  Hook into all of them.
> > > 
> > > A more elegant solution might be to use a preempt notifier.  However,
> > > non-ORC unwinders can't unwind a preempted task reliably.
> > > 
> > > [1] https://lore.kernel.org/lkml/20220507174628.2086373-1-song@kernel.org/
> > > [2] https://lkml.kernel.org/lkml/20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org
> > > 
> > > Tested-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
> > > Reviewed-by: Petr Mladek <pmladek@suse.com>
> > > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > 
> > Just for record, I have double checked the changes against v2
> > and everything looks good to me.
> 
> Whoops, so I found another little surprise:
> 
> static int klp_check_stack(struct task_struct *task, const char **oldname)
> {
>         static unsigned long entries[MAX_STACK_ENTRIES];
> 	^^^^^^
> 
> That entries array is shared between the klp_mutex owner and all
> cond_resched() callers.

Huh, great catch!

> MAX_STACK_ENTRIES is 100, which seems excessive.  If we halved that, the
> array would be "only" 400 bytes, which is *almost* reasonable to
> allocate on the stack?

It is just for the stack in the process context. Right?

I think that I have never seen a stack with over 50 entries. And in
the worst case, a bigger amount of entries would "just" result in
a non-reliable stack which might be acceptable.

It looks acceptable to me.

> Alternatively we could have a percpu entries array... :-/

That said, percpu entries would be fine as well. It sounds like
a good price for the livepatching feature. I think that livepatching
is used on big systems anyway.

I slightly prefer the per-cpu solution.

Best Regards,
Petr
