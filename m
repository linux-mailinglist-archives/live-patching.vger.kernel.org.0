Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E76B415082
	for <lists+live-patching@lfdr.de>; Wed, 22 Sep 2021 21:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhIVTh0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Sep 2021 15:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhIVTh0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Sep 2021 15:37:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB09C061574;
        Wed, 22 Sep 2021 12:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hMcHH+z4ars0kJ4QsbziSiMf1OGVJzE0QZQzRM/1V9g=; b=TOPhfEgE9dWGaYyKI6u59I6xDT
        SqSWpoJ9B3oVGxSWdeeCksCJat8/ay93JYU4kDCqivP6YbvBCQnuBDJKs+ksgu8mw/HQTn4tSnqLJ
        oiLGAdFv9DCw7rbBQXRezxPMSOFMjxp2i6hIzXTDtM9TVfxC8i3jNZ+kFD3n6aUYG85WGgNVKgBN9
        90C9XcFnCtRyBo/5u2Rgn60quz2DWkMGjaaiovxiy5tO+prsV3vLk3kCJA7x5g7l/bJSqO8Ufkh7X
        H/Je5hi99GpbUx5J8zCRmZ5s8BsgCqxfC66HWBmR54k+ua6inlqOhfTt2TrvPH3mAzQmLOJkaZBtB
        u+mU77/w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mT801-0054jV-GQ; Wed, 22 Sep 2021 19:33:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B553F300250;
        Wed, 22 Sep 2021 21:33:43 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9CF6B2019DA07; Wed, 22 Sep 2021 21:33:43 +0200 (CEST)
Date:   Wed, 22 Sep 2021 21:33:43 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org
Subject: Re: [RFC][PATCH 6/7] context_tracking: Provide SMP ordering using RCU
Message-ID: <YUuFF8+H2PE9m4wy@hirez.programming.kicks-ass.net>
References: <20210922110506.703075504@infradead.org>
 <20210922110836.244770922@infradead.org>
 <20210922151721.GZ880162@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922151721.GZ880162@paulmck-ThinkPad-P17-Gen-1>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 22, 2021 at 08:17:21AM -0700, Paul E. McKenney wrote:
> On Wed, Sep 22, 2021 at 01:05:12PM +0200, Peter Zijlstra wrote:
> > Use rcu_user_{enter,exit}() calls to provide SMP ordering on context
> > tracking state stores:
> > 
> > __context_tracking_exit()
> >   __this_cpu_write(context_tracking.state, CONTEXT_KERNEL)
> >   rcu_user_exit()
> >     rcu_eqs_exit()
> >       rcu_dynticks_eqs_eit()
> >         rcu_dynticks_inc()
> >           atomic_add_return() /* smp_mb */
> > 
> > __context_tracking_enter()
> >   rcu_user_enter()
> >     rcu_eqs_enter()
> >       rcu_dynticks_eqs_enter()
> >         rcu_dynticks_inc()
> > 	  atomic_add_return() /* smp_mb */
> >   __this_cpu_write(context_tracking.state, state)
> > 
> > This separates USER/KERNEL state with an smp_mb() on each side,
> > therefore, a user of context_tracking_state_cpu() can say the CPU must
> > pass through an smp_mb() before changing.
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> 
> For the transformation to negative errno return value and name change
> from an RCU perspective:
> 
> Acked-by: Paul E. McKenney <paulmck@kernel.org>

Thanks!

> For the sampling of nohz_full userspace state:
> 
> Another approach is for the rcu_data structure's ->dynticks variable to
> use the lower two bits to differentiate between idle, nohz_full userspace
> and kernel.  In theory, inlining should make this zero cost for idle
> transition, and should allow you to safely sample nohz_full userspace
> state with a load and a couple of memory barriers instead of an IPI.

That's what I do now, it's like:

  <user code>

  state = KERNEL
  smp_mb()

  <kernel code>

  smp_mb()
  state = USER

  <user core>

vs

  <patch kernel code>
  smp_mb()
  if (state == USER)
    // then we're guaranteed any subsequent kernel code execution
    // will see the modified kernel code

more-or-less

> To make this work nicely, the low-order bits have to be 00 for kernel,
> and (say) 01 for idle and 10 for nohz_full userspace.  11 would be an
> error.
> 
> The trick would be for rcu_user_enter() and rcu_user_exit() to atomically
> increment ->dynticks by 2, for rcu_nmi_exit() to increment by 1 and
> rcu_nmi_enter() to increment by 3.  The state sampling would need to
> change accordingly.
> 
> Does this make sense, or am I missing something?

Why doesn't the proposed patch work? Also, ISTR sampling of remote
context state coming up before. And as is, it's a weird mix between
context_tracking and rcu.

AFAICT there is very little useful in context_tracking as is, but it's
also very weird to have to ask RCU about this. Is there any way to slice
this this code differently? Perhaps move some of the state RCU now keeps
into context_tracking ?

Anyway, lemme see if I get your proposal; lets say the counter starts at
0 and is in kernel space.

 0x00(0) - kernel
 0x02(2) - user
 0x04(0) - kernel

So far so simple, then NMI on top of that goes:

 0x00(0) - kernel
 0x03(3) - kernel + nmi
 0x04(0) - kernel
 0x06(2) - user
 0x09(1) - user + nmi
 0x0a(2) - user

Which then gives us:

 (0) := kernel
 (1) := nmi-from-user
 (2) := user
 (3) := nmi-from-kernel

Which should work I suppose. But like I said above, I'd be happier if
this counter would live in context_tracking rather than RCU.
