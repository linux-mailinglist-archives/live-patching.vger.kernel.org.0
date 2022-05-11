Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53769522F51
	for <lists+live-patching@lfdr.de>; Wed, 11 May 2022 11:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbiEKJYi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 11 May 2022 05:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiEKJYh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 11 May 2022 05:24:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C787A456;
        Wed, 11 May 2022 02:24:35 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D5ED41F8D3;
        Wed, 11 May 2022 09:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652261073; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nN072XjvLtJhbhtDvTS9a15agLhgCefyfNf1N5AcBXs=;
        b=uJ2FMBtequR4/wjREO5p/fnprXFSlkerpk1Fvx7S/H/qf9TOYAY5LrYhCDCJTeg2TXlXNO
        2GtHqKnX89iUoYuy5S6gxJqS68eOg+bPBWy9C2rdnB01ACkKGGWfrrRqDYhbZ4c1yjqI/H
        4nG/BhZLKtkzC1L424qbgvsPMRGDrQ0=
Received: from suse.cz (pathway.suse.cz [10.100.12.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id BABAB2C142;
        Wed, 11 May 2022 09:24:33 +0000 (UTC)
Date:   Wed, 11 May 2022 11:24:33 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Song Liu <songliubraving@fb.com>, Rik van Riel <riel@fb.com>,
        "song@kernel.org" <song@kernel.org>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Message-ID: <20220511092433.GA26047@pathway.suse.cz>
References: <3a9bfb4a52b715bd8739d8834409c9549ec7f22f.camel@fb.com>
 <YnqIcw+dYsWz/w7g@alley>
 <6bf85ff908377508a5f5bcc7c4e75d598b96f388.camel@fb.com>
 <20220510165244.ikfh64ertnvodxb4@treble>
 <1bd15361edfd4db9fc9271d35e7bbe5edad1b87a.camel@fb.com>
 <20220510184213.l3gjweeleyg7obca@treble>
 <47440502-930F-4CBD-B859-3AC9BBFF8FC6@fb.com>
 <20220510230402.e5ymkwt45sg7bd35@treble>
 <D298A3F1-43A5-4FD5-B198-906364BF4B79@fb.com>
 <20220511003331.clfvwfgpmbr5yx6n@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511003331.clfvwfgpmbr5yx6n@treble>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2022-05-10 17:33:31, Josh Poimboeuf wrote:
> On Tue, May 10, 2022 at 11:57:04PM +0000, Song Liu wrote:
> > > If it's a real bug, we should fix it everywhere, not just for Facebook.
> > > Otherwise CONFIG_PREEMPT and/or non-x86 arches become second-class
> > > citizens.
> > 
> > I think "is it a real bug?" is the top question for me. So maybe we 
> > should take a step back.
> > 
> > The behavior we see is: A busy kernel thread blocks klp transition 
> > for more than a minute. But the transition eventually succeeded after 
> > < 10 retries on most systems. The kernel thread is well-behaved, as 
> > it calls cond_resched() at a reasonable frequency, so this is not a 
> > deadlock. 
> > 
> > If I understand Petr correctly, this behavior is expected, and thus 
> > is not a bug or issue for the livepatch subsystem. This is different
> > to our original expectation, but if this is what we agree on, we 
> > will look into ways to incorporate long wait time for patch 
> > transition in our automations. 
> 
> That's how we've traditionally looked at it, though apparently Red Hat
> and SUSE have implemented different ideas of what a long wait time is.
> 
> In practice, one minute has always been enough for all of kpatch's users
> -- AFAIK, everybody except SUSE -- up until now.

I am actually surprised that nobody met the problem yet. There are
"only" 60 attempts to transition the pending tasks.

Well, the problem is mainly with kthreads. User space processes are
migrated also on the kernel boundary. And the fake signal is likely
pretty effective here. And it probably is not that common that
a kthread would occupy a single CPU all the time.


> Though, these options might be considered workarounds, as it's
> theoretically possible for a kthread to be CPU-bound indefinitely,
> beyond any arbitrarily chosen timeout.  But maybe that's not realistic
> beyond a certain timeout value of X and we don't care?  I dunno.

I agree that it might happen theoretically. And it would be great
to be prepared for this. My only concern is the complexity and risk.
We should know that it is worth it.


> As I have been trying to say, that won't work for PREEMPT+!ORC, because,
> when the kthread gets preempted, the stack trace will be attempted from
> an IRQ and will be reported as unreliable.

This limits the range of possible solutions quite a lot. But it is
how it is.

> Ideally we'd have the ORC unwinder for all arches, that would make this
> much easier.  But we're not there yet.

The alternative solution is that the process has to migrate itself
on some safe location.

One crazy idea. It still might be possible to find the called
functions on the stack even when it is not reliable. Then it
might be possible to add another ftrace handler on
these found functions. This other ftrace handler might migrate
the task when it calls this function again.

It assumes that the task will call the same functions again
and again. Also it might require that the tasks checks its
own stack from the ftrace handler. I am not sure if this
is possible.

There might be other variants of this approach.

Best Regards,
Petr
