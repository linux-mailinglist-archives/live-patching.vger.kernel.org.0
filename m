Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012AD4150C4
	for <lists+live-patching@lfdr.de>; Wed, 22 Sep 2021 21:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237260AbhIVTzV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Sep 2021 15:55:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235975AbhIVTzU (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Sep 2021 15:55:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 515AD61050;
        Wed, 22 Sep 2021 19:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632340430;
        bh=VII5+fZH888Mt498iOJoyPjMe70GGnKReQSGkvsggMM=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=QGyEmVPxS+Bt6haiWNy6QZuSsCPU0Sh3jujW9IrvdWFC6aVbo13/r/1tL8fjrKrGB
         CFgwldsfjyDGSiK9ffkDXmVlKYjqj6auHxBWocW02VLt5gYmgVSlTFUD2IydsrBrPP
         WBmUnbhrVz+irdc+u+NIDEjFaoIsujGmIKqrgrQ+gUJ76w/juK+QyLlP2owpasv5Nt
         1y3ImM1crWQscQ4Rjp6pBCdvG5wAN7irWH9bvzvVjfXcaOsYwGPju4k3rAXBNtgGGv
         8goSOH88T2SMmTJ47iY91ArB6RImAu6ujBxXbErRQ8l0RMGUs7OjbkQE1J+2kIphHX
         NGjGqoGNf7XlA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 1CCD25C0A54; Wed, 22 Sep 2021 12:53:50 -0700 (PDT)
Date:   Wed, 22 Sep 2021 12:53:50 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org
Subject: Re: [RFC][PATCH 6/7] context_tracking: Provide SMP ordering using RCU
Message-ID: <20210922195350.GC880162@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20210922110506.703075504@infradead.org>
 <20210922110836.244770922@infradead.org>
 <20210922151721.GZ880162@paulmck-ThinkPad-P17-Gen-1>
 <YUuFF8+H2PE9m4wy@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUuFF8+H2PE9m4wy@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 22, 2021 at 09:33:43PM +0200, Peter Zijlstra wrote:
> On Wed, Sep 22, 2021 at 08:17:21AM -0700, Paul E. McKenney wrote:
> > On Wed, Sep 22, 2021 at 01:05:12PM +0200, Peter Zijlstra wrote:
> > > Use rcu_user_{enter,exit}() calls to provide SMP ordering on context
> > > tracking state stores:
> > > 
> > > __context_tracking_exit()
> > >   __this_cpu_write(context_tracking.state, CONTEXT_KERNEL)
> > >   rcu_user_exit()
> > >     rcu_eqs_exit()
> > >       rcu_dynticks_eqs_eit()
> > >         rcu_dynticks_inc()
> > >           atomic_add_return() /* smp_mb */
> > > 
> > > __context_tracking_enter()
> > >   rcu_user_enter()
> > >     rcu_eqs_enter()
> > >       rcu_dynticks_eqs_enter()
> > >         rcu_dynticks_inc()
> > > 	  atomic_add_return() /* smp_mb */
> > >   __this_cpu_write(context_tracking.state, state)
> > > 
> > > This separates USER/KERNEL state with an smp_mb() on each side,
> > > therefore, a user of context_tracking_state_cpu() can say the CPU must
> > > pass through an smp_mb() before changing.
> > > 
> > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > 
> > For the transformation to negative errno return value and name change
> > from an RCU perspective:
> > 
> > Acked-by: Paul E. McKenney <paulmck@kernel.org>
> 
> Thanks!
> 
> > For the sampling of nohz_full userspace state:
> > 
> > Another approach is for the rcu_data structure's ->dynticks variable to
> > use the lower two bits to differentiate between idle, nohz_full userspace
> > and kernel.  In theory, inlining should make this zero cost for idle
> > transition, and should allow you to safely sample nohz_full userspace
> > state with a load and a couple of memory barriers instead of an IPI.
> 
> That's what I do now, it's like:
> 
>   <user code>
> 
>   state = KERNEL
>   smp_mb()
> 
>   <kernel code>
> 
>   smp_mb()
>   state = USER
> 
>   <user core>
> 
> vs
> 
>   <patch kernel code>
>   smp_mb()
>   if (state == USER)
>     // then we're guaranteed any subsequent kernel code execution
>     // will see the modified kernel code
> 
> more-or-less

OK.

> > To make this work nicely, the low-order bits have to be 00 for kernel,
> > and (say) 01 for idle and 10 for nohz_full userspace.  11 would be an
> > error.
> > 
> > The trick would be for rcu_user_enter() and rcu_user_exit() to atomically
> > increment ->dynticks by 2, for rcu_nmi_exit() to increment by 1 and
> > rcu_nmi_enter() to increment by 3.  The state sampling would need to
> > change accordingly.
> > 
> > Does this make sense, or am I missing something?
> 
> Why doesn't the proposed patch work? Also, ISTR sampling of remote
> context state coming up before. And as is, it's a weird mix between
> context_tracking and rcu.

I wasn't saying that the patch doesn't work.  But doesn't it add an IPI?
Or was I looking at it too early this morning?

As to RCU's ->dynticks and context-tracking state, something about RCU
being there first by many years.  ;-)  Plus, does context-tracking
track idleness within the kernel?  RCU needs that as well.

> AFAICT there is very little useful in context_tracking as is, but it's
> also very weird to have to ask RCU about this. Is there any way to slice
> this this code differently? Perhaps move some of the state RCU now keeps
> into context_tracking ?
> 
> Anyway, lemme see if I get your proposal; lets say the counter starts at
> 0 and is in kernel space.
> 
>  0x00(0) - kernel
>  0x02(2) - user
>  0x04(0) - kernel
> 
> So far so simple, then NMI on top of that goes:
> 
>  0x00(0) - kernel
>  0x03(3) - kernel + nmi

This would stay 0x00 because the NMI is interrupting kernel code.  The
check of rcu_dynticks_curr_cpu_in_eqs() avoids this additional increment.

>  0x04(0) - kernel

And same here, still zero.

>  0x06(2) - user

And now 0x02.

>  0x09(1) - user + nmi

This would be 0x04, back in the kernel.  Which is the area of concern,
because the amount to increment depends on the counter value, requiring
an additional arithmetic operation on the from-idle fastpath.  Probably
not visible even in microbenchmarks, but still a potential issue.

>  0x0a(2) - user

Now 0x06, back in nohz_full userspace.

> Which then gives us:
> 
>  (0) := kernel
>  (1) := nmi-from-user
>  (2) := user
>  (3) := nmi-from-kernel

You need to know NMI as a separate state?

> Which should work I suppose. But like I said above, I'd be happier if
> this counter would live in context_tracking rather than RCU.

This would be the first non-RCU user of the counter.  The various
rcu_*_{enter,exit}() functions are still required, though, in order
to handle things like deferred wakeups.  Plus RCU makes heavy use
of that counter.  So it is not clear that moving the counter to the
context-tracking subsystem really buys you anything.

But it would be good to avoid maintaining duplicate information,
that is assuming that the information really is duplicate...

							Thanx, Paul
