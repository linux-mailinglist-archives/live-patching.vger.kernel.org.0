Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B1D520109
	for <lists+live-patching@lfdr.de>; Mon,  9 May 2022 17:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236294AbiEIP0r (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 9 May 2022 11:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238402AbiEIP0V (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 9 May 2022 11:26:21 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06941B0939;
        Mon,  9 May 2022 08:22:26 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 868521F953;
        Mon,  9 May 2022 15:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652109745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pP5QztUyCubNx+tH5klGWqVF3NAEvm+IujQ+PSfJajo=;
        b=vCyjAv6DNlOTZIXy6j6NDzuIzyMShgX8w+GIQoJ/KdU+qZykbVHYFmDS8Z/qI+ykS1dslq
        Szd5WmsGK7b5y0I1T7Pr5P40URHM8a7+j4JzHpOrni0QvghKflsRH88UR1CI5BFuzDiKha
        rZ6wofRkb2JbudfXiirCkRWjbWcwQdM=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 625D22C141;
        Mon,  9 May 2022 15:22:25 +0000 (UTC)
Date:   Mon, 9 May 2022 17:22:25 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Rik van Riel <riel@fb.com>
Cc:     "peterz@infradead.org" <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "song@kernel.org" <song@kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        Kernel Team <Kernel-team@fb.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Message-ID: <YnkxsaOWrxrSQ4D8@alley>
References: <20220507174628.2086373-1-song@kernel.org>
 <20220509070437.GC76023@worktop.programming.kicks-ass.net>
 <9FA1822F-76EE-4174-86DD-B20F1F8CE7FC@fb.com>
 <20220509093830.GH76023@worktop.programming.kicks-ass.net>
 <0f6a45f80d01e9a5054c7973090a479707bda52f.camel@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f6a45f80d01e9a5054c7973090a479707bda52f.camel@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2022-05-09 14:13:17, Rik van Riel wrote:
> On Mon, 2022-05-09 at 11:38 +0200, Peter Zijlstra wrote:
> > On Mon, May 09, 2022 at 08:06:22AM +0000, Song Liu wrote:
> > > 
> > > 
> > > > On May 9, 2022, at 12:04 AM, Peter Zijlstra
> > > > <peterz@infradead.org> wrote:
> > > > 
> > > > On Sat, May 07, 2022 at 10:46:28AM -0700, Song Liu wrote:
> > > > > Busy kernel threads may block the transition of livepatch. Call
> > > > > klp_try_switch_task from __cond_resched to make the transition
> > > > > easier.
> > > > 
> > > > What will a PREEMPT=y kernel do? How is it not a problem there,
> > > > and if
> > > > it is, this will not help that.
> > 
> > Not really. There is no difference between an explicit preemption
> > point
> > (cond_resched) or an involuntary preemption point (PREEMPT=y).
> > 
> > So unless you can *exactly* say why it isn't a problem on PREEMPT=y,
> > none of this makes any sense.
> 
> I suspect it is a problem on PREEMPT=y too, but is there some sort
> of fairly light weight (in terms of stuff we need to add to the kernel)
> solution that could solve both?
> 
> Do we have some real time per-CPU kernel threads we could just
> issue a NOOP call to, which would preempt long-running kernel
> threads (like a kworker with oodles of work to do)?
> 
> Could the stopper workqueue be a suitable tool for this job?

An interesting solution would be to queue irq_work in CPU that
is occupied by the long-running kernel task.

It might be queued from klp_try_complete_transition() that
is called from the regular klp_transition_work_fn().

Then the task might try to migrate itself from the irq_work.
But the problem is that stack_trace_save_tsk_reliable() probably
will not be able to store a reliable backtrace for the interrupted
task.

So, we might really need to stop the task (CPU). But there still
might be problem if stack_trace_save_tsk_reliable() will consider
the stack as reliable.

Best Regards,
Petr
