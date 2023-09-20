Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0836A7A8655
	for <lists+live-patching@lfdr.de>; Wed, 20 Sep 2023 16:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbjITOQm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 20 Sep 2023 10:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbjITOQl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 20 Sep 2023 10:16:41 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B492ECA
        for <live-patching@vger.kernel.org>; Wed, 20 Sep 2023 07:16:32 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 645631FF2C;
        Wed, 20 Sep 2023 14:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1695219391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r92pwsodrWk5oBqS0cdXZqSV+7pX7kIETuIqrWvBLxw=;
        b=mmU68D+oiMP6qLaksJbVOllJtvqq3pC6gnjPZrXOrfE1pwxFiR5I04VDxOur1T2CQDwUge
        qALZqqcIWoAGIFzbq2D/px5SX0jXeHt7kGfZHgIn3e7nleqc04SrXlC2xr3KWvRcqTB2BF
        oJbg+r9VMCXwSy1GVHr/ioG3gI2kCJU=
Received: from suse.cz (pmladek.tcp.ovpn2.prg.suse.de [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A3EF32C142;
        Wed, 20 Sep 2023 14:16:30 +0000 (UTC)
Date:   Wed, 20 Sep 2023 16:16:30 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, live-patching@vger.kernel.org,
        Ryan Sullivan <rysulliv@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: Re: Recent Power changes and stack_trace_save_tsk_reliable?
Message-ID: <ZQr-vmBBQ66TRobQ@alley>
References: <ZO4K6hflM/arMjse@redhat.com>
 <87o7ipxtdc.fsf@mail.lhotse>
 <87il8xxcg7.fsf@mail.lhotse>
 <cca0770c-1510-3a02-d0ba-82ee5a0ae4f2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cca0770c-1510-3a02-d0ba-82ee5a0ae4f2@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2023-08-30 17:47:35, Joe Lawrence wrote:
> On 8/30/23 02:37, Michael Ellerman wrote:
> > Michael Ellerman <mpe@ellerman.id.au> writes:
> >> Joe Lawrence <joe.lawrence@redhat.com> writes:
> >>> Hi ppc-dev list,
> >>>
> >>> We noticed that our kpatch integration tests started failing on ppc64le
> >>> when targeting the upstream v6.4 kernel, and then confirmed that the
> >>> in-tree livepatching kselftests similarly fail, too.  From the kselftest
> >>> results, it appears that livepatch transitions are no longer completing.
> >>
> >> Hi Joe,
> >>
> >> Thanks for the report.
> >>
> >> I thought I was running the livepatch tests, but looks like somewhere
> >> along the line my kernel .config lost CONFIG_TEST_LIVEPATCH=m, so I have
> >> been running the test but it just skips. :/
> >>
> 
> That config option is easy to drop if you use `make localmodconfig` to
> try and expedite the builds :D  Been there, done that too many times.
> 
> >> I can reproduce the failure, and will see if I can bisect it more
> >> successfully.
> > 
> > It's caused by:
> > 
> >   eed7c420aac7 ("powerpc: copy_thread differentiate kthreads and user mode threads")
> > 
> > Which is obvious in hindsight :)
> > 
> > The diff below fixes it for me, can you test that on your setup?
> > 
> 
> Thanks for the fast triage of this one.  The proposed fix works well on
> our setup.  I have yet to try the kpatch integration tests with this,
> but I can verify that all of the kernel livepatching kselftests now
> happily run.

Have this been somehow handled, please? I do not see the proposed
change in linux-next as of now.

> > A proper fix will need to be a bit bigger because the comments in there
> > are all slightly wrong now since the above commit.
> > 
> > Possibly we can also rework that code more substantially now that
> > copy_thread() is more careful about setting things up, but that would be
> > a follow-up.
> > 
> > diff --git a/arch/powerpc/kernel/stacktrace.c b/arch/powerpc/kernel/stacktrace.c
> > index 5de8597eaab8..d0b3509f13ee 100644
> > --- a/arch/powerpc/kernel/stacktrace.c
> > +++ b/arch/powerpc/kernel/stacktrace.c
> > @@ -73,7 +73,7 @@ int __no_sanitize_address arch_stack_walk_reliable(stack_trace_consume_fn consum
> >  	bool firstframe;
> >  
> >  	stack_end = stack_page + THREAD_SIZE;
> > -	if (!is_idle_task(task)) {
> > +	if (!(task->flags & PF_KTHREAD)) {
> >  		/*
> >  		 * For user tasks, this is the SP value loaded on
> >  		 * kernel entry, see "PACAKSAVE(r13)" in _switch() and

If I read the change in the commit eed7c420aac7fde ("powerpc: copy_thread
differentiate kthreads and user mode threads") correctly then the
above fix is correct.

It is probably just enough to update the comment about that
STACK_FRAME_MIN_SIZE is used by all kthreads.

Best Regards,
Petr
