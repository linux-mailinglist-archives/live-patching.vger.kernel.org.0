Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE8B432249
	for <lists+live-patching@lfdr.de>; Mon, 18 Oct 2021 17:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhJRPMM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Oct 2021 11:12:12 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60590 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233530AbhJRPLr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Oct 2021 11:11:47 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D76F821976;
        Mon, 18 Oct 2021 15:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634569774; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nd3ueXGeszg+Oz2rg7bdH1H47hd7UcRyoGzyxgvuWbE=;
        b=k+XvgY66O97wrAhATaukyluGJ8nlI2mMVYR2Ljp+nN4lHstmnFKhBHA64Hiql9QhfyHFDN
        vQU7Fo+uY3SMhJOZFTk0+XH+JTiiGsSo3m1ngcUgbmFuE2AcfDj56F+TeSOrWwVmeLeplp
        mYBb43DaiD+hJ6LDJCsDVAayPvTe1IY=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C8905A3B87;
        Mon, 18 Oct 2021 15:09:32 +0000 (UTC)
Date:   Mon, 18 Oct 2021 17:09:29 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>, linux-csky@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, live-patching@vger.kernel.org,
        =?utf-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH] tracing: Have all levels of checks prevent recursion
Message-ID: <YW2OKQQmNOVvVdFm@alley>
References: <20211015110035.14813389@gandalf.local.home>
 <YW1KKCFallDG+E01@alley>
 <20211018095027.52a23ff0@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018095027.52a23ff0@gandalf.local.home>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2021-10-18 09:50:27, Steven Rostedt wrote:
> On Mon, 18 Oct 2021 12:19:20 +0200
> Petr Mladek <pmladek@suse.com> wrote:
> 
> > On Fri 2021-10-15 11:00:35, Steven Rostedt wrote:
> > > From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> > > 
> > > While writing an email explaining the "bit = 0" logic for a discussion on
> > > making ftrace_test_recursion_trylock() disable preemption, I discovered a
> > > path that makes the "not do the logic if bit is zero" unsafe.
> > > 
> > > Since we want to encourage architectures to implement all ftrace features,
> > > having them slow down due to this extra logic may encourage the
> > > maintainers to update to the latest ftrace features. And because this
> > > logic is only safe for them, remove it completely.
> > > 
> > >  [*] There is on layer of recursion that is allowed, and that is to allow
> > >      for the transition between interrupt context (normal -> softirq ->
> > >      irq -> NMI), because a trace may occur before the context update is
> > >      visible to the trace recursion logic.
> > > 
> > > diff --git a/include/linux/trace_recursion.h b/include/linux/trace_recursion.h
> > > index a9f9c5714e65..168fdf07419a 100644
> > > --- a/include/linux/trace_recursion.h
> > > +++ b/include/linux/trace_recursion.h
> > > @@ -165,40 +147,29 @@ static __always_inline int trace_test_and_set_recursion(unsigned long ip, unsign
> > >  	unsigned int val = READ_ONCE(current->trace_recursion);
> > >  	int bit;
> > >  
> > > -	/* A previous recursion check was made */
> > > -	if ((val & TRACE_CONTEXT_MASK) > max)
> > > -		return 0;  
> > 
> > @max parameter is no longer used.
> 
> Thanks for noticing!
> 
> > 
> > > -
> > >  	bit = trace_get_context_bit() + start;
> > >  	if (unlikely(val & (1 << bit))) {
> > >  		/*
> > >  		 * It could be that preempt_count has not been updated during
> > >  		 * a switch between contexts. Allow for a single recursion.
> > >  		 */
> > > -		bit = TRACE_TRANSITION_BIT;
> > > +		bit = TRACE_CTX_TRANSITION + start;  
> > 
> > I just want to be sure that I understand it correctly.
> > 
> > The transition bit is the same for all contexts. It will allow one
> > recursion only in one context.
> 
> Right.
> 
> > 
> > IMHO, the same problem (not-yet-updated preempt_count) might happen
> > in any transition between contexts: normal -> soft IRQ -> IRQ -> NMI.
> 
> Yes, and then we will drop the event if it happens twice, otherwise, we
> will need to have a 4 layer transition bit mask, and allow 4 recursions,
> which is more than I want to allow.

Fair enough. I am still not sure if we want to allow the recursion
at all, see below.

> 
> > 
> > Well, I am not sure what exacly it means "preempt_count has not been
> > updated during a switch between contexts."
> > 
> >    Is it that a function in the interrupt entry code is traced before
> >    preempt_count is updated?
> >
> >    Or that an interrupt entry is interrupted by a higher level
> >    interrupt, e.g. IRQ entry code interrupted by NMI?
> 
> Both actually ;-)

I see. But only one is a problem. See below.


> There are places that can trigger a trace between the time the interrupt is
> triggered, and the time the preempt_count updates the interrupt context it
> is in.

By other words, these locations trace a function that is called
between entering the context and updating preempt_count.


> Thus the tracer will still think it is in the previous context. But
> that is OK, unless, that interrupt happened while the previous context was
> in the middle of tracing:

My understanding is that this is _not_ OK. Peter Zijlstra fixed the
generic entry and no function should be traced there.

The problem is that some architectures still allow to trace some code
in this entry context code. And this is why you currently tolerate
one level of recursion here. Do I get it correctly?

But wait. If you tolerate the recursion, you actually tolerate
tracing the code between entering context and setting preempt count.
It is in your example:


> trace() {
>   context = get_context(preempt_count);
>   test_and_set_bit(context)
>       <<--- interrupt --->>>
>       trace() {
>           context = get_context(preempt_count);
>           test_and_set_bit(context); <-- detects recursion!
>       }
>       update_preempt_count(irq_context);
> 
> By allowing a single recursion, it still does the above trace.

This happens only when the nested trace() is tracing something in
the IRQ entry before update_preempt_count(irq_context).

My understanding is that Peter Zijlstra do _not_ want to allow
the nested trace because this code should not get traced.

The outer trace() will work even if we reject the inner trace().

Let me show that interrupting context entry is fine:

<<--- normal context -->>
trace()
  context = get_context(preempt_count);  // normal context
  test_and_set_bit(context)

       <<--- interrupt --->>>
       interrupt_entry()

	  // tracing is _not_ allowed here
	  update_preempt_count(irq_context);
	  // tracing should work after this point

	  interrupt_handler();
		trace()
		context = get_context(preempt_count); // IRQ context
		test_and_set_bit(context); // Passes; it sees IRQ context
		// trace code is allowed

	<<-- back to normal context -->

// outer trace code is allowed. It sees normal context.

Best Regards,
Petr
