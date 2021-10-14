Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D70142D75B
	for <lists+live-patching@lfdr.de>; Thu, 14 Oct 2021 12:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhJNKrw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Oct 2021 06:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhJNKrv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Oct 2021 06:47:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548F0C061570;
        Thu, 14 Oct 2021 03:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fB1kvwE0qM4yzrXOfI44LBD6xG3DWIa3nthsA9IpR10=; b=jXapiBFTysoJhTJtvGjKgh4Asf
        xw2iBqCtedUllZzkSuBjUppeAfRHLdYsq1ZYXNggFDvf4hQs7j8Acd7m6SC3q4GNX220mIX2w20YN
        1OzAHcF1r2Uzanr6bWy+BgOKpUime+px3jQ8sDM8V7HUkk54G94LHA/n5jsAGzHUAmabhdEKvVgzy
        7Ax8gsN9AMwzxW0hOlVOrpeKa6Di89UHFGibqQ2W8mqHPenK6SHaDudZ405NGXmUENR9cewSHLqnF
        6hZsESHKTJVIi8cd8sXLq2HEMBiKqCH3ScHYJAgzRKnaKVimZktnUZgsApm0ddNys0pVz1S77y4re
        /cujEGNg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mayC4-008GQC-6F; Thu, 14 Oct 2021 10:42:56 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id EB3B830030B;
        Thu, 14 Oct 2021 12:42:35 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C142120A958AA; Thu, 14 Oct 2021 12:42:35 +0200 (CEST)
Date:   Thu, 14 Oct 2021 12:42:35 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        joe.lawrence@redhat.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <hca@linux.ibm.com>, svens@linux.ibm.com,
        sumanthk@linux.ibm.com, live-patching@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v2 05/11] sched,livepatch: Use wake_up_if_idle()
Message-ID: <YWgJmz7QPOY3AW7M@hirez.programming.kicks-ass.net>
References: <20210929151723.162004989@infradead.org>
 <20210929152428.828064133@infradead.org>
 <CAK8P3a0N-ZuSEZyw5ub1vr3VP2Bdoa2Wq=No1gad+SyqquQXfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0N-ZuSEZyw5ub1vr3VP2Bdoa2Wq=No1gad+SyqquQXfw@mail.gmail.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Oct 13, 2021 at 09:37:01PM +0200, Arnd Bergmann wrote:
> On Wed, Sep 29, 2021 at 6:10 PM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > Make sure to prod idle CPUs so they call klp_update_patch_state().
> >
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  kernel/livepatch/transition.c |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > --- a/kernel/livepatch/transition.c
> > +++ b/kernel/livepatch/transition.c
> > @@ -413,8 +413,11 @@ void klp_try_complete_transition(void)
> >         for_each_possible_cpu(cpu) {
> >                 task = idle_task(cpu);
> >                 if (cpu_online(cpu)) {
> > -                       if (!klp_try_switch_task(task))
> > +                       if (!klp_try_switch_task(task)) {
> >                                 complete = false;
> > +                               /* Make idle task go through the main loop. */
> > +                               wake_up_if_idle(cpu);
> > +                       }
> 
> This caused a build regression on non-SMP kernels:

:-(

> x86_64-linux-ld: kernel/livepatch/transition.o: in function
> `klp_try_complete_transition':
> transition.c:(.text+0x106e): undefined reference to `wake_up_if_idle'
> 
> Maybe add a IS_ENABLED(CONFIG_SMP) check to one of the if() conditions?

I'll just add a stub for that function I think. Let me rebase the thing
before I push more crap ontop..
