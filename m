Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133B551F8F3
	for <lists+live-patching@lfdr.de>; Mon,  9 May 2022 12:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbiEIJxR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 9 May 2022 05:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbiEIJnc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 9 May 2022 05:43:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0C81E05B8;
        Mon,  9 May 2022 02:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=nLK8eWwMwyEnxqoOkhtH1DIuNWfIgfaMc34pifqEJGk=; b=SYBIrc5uYnZo9IAFVdZI26vEhj
        Kar5mCVfxlcJW9ri5PuY0ZWsst8r8Fc3J1GnveaY0SUfAL1tzxXgfCCM6IVxpFGf3wnyvvY/T/SeL
        xT6pCazVk/b+9d+o65UNUTJW90J2j32kRubdkxOt14L4e+q1ckFMWNohWSjyGUAF5/rFDSdv8XevD
        gmD73r+JVQ3es/L7AtVBGiUf+gIDqQJCf0Gk/61hmDxgmraf2NdYMcdC4k6Rpf1iPoafiaVtf7DY1
        EJSrEavNG1PW5KRGndOZB2IESYSNUbmr5JnaV9O4YSyXD/klu1A6R46uHqb8Yb+lhjS0tbo9PjeDw
        G/FFTMwQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nnzqb-003JrU-On; Mon, 09 May 2022 09:38:33 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id A07D9980E93; Mon,  9 May 2022 11:38:30 +0200 (CEST)
Date:   Mon, 9 May 2022 11:38:30 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Message-ID: <20220509093830.GH76023@worktop.programming.kicks-ass.net>
References: <20220507174628.2086373-1-song@kernel.org>
 <20220509070437.GC76023@worktop.programming.kicks-ass.net>
 <9FA1822F-76EE-4174-86DD-B20F1F8CE7FC@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9FA1822F-76EE-4174-86DD-B20F1F8CE7FC@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, May 09, 2022 at 08:06:22AM +0000, Song Liu wrote:
> 
> 
> > On May 9, 2022, at 12:04 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > On Sat, May 07, 2022 at 10:46:28AM -0700, Song Liu wrote:
> >> Busy kernel threads may block the transition of livepatch. Call
> >> klp_try_switch_task from __cond_resched to make the transition easier.
> > 
> > What will a PREEMPT=y kernel do? How is it not a problem there, and if
> > it is, this will not help that.
> > 
> > That is; I don't think this can be right.
> 
> I guess on PREEMPT=y kernel, we can simply preempt the long running 
> kernel thread and check the transition? 

This is not a guessing game.

> In this case (PREEMPT=n), we see a long running kernel thread could not
> finish the transition. It calls cond_resched() and gets rescheduled 
> (moves among different cores). However, it never finishes the transition,
> because live patch doesn’t get a chance to check the stack. 
> 
> Does this answer the question?

Not really. There is no difference between an explicit preemption point
(cond_resched) or an involuntary preemption point (PREEMPT=y).

So unless you can *exactly* say why it isn't a problem on PREEMPT=y,
none of this makes any sense.
