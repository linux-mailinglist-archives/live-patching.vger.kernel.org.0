Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8152C4150DD
	for <lists+live-patching@lfdr.de>; Wed, 22 Sep 2021 21:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237319AbhIVUBJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Sep 2021 16:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237330AbhIVUBJ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Sep 2021 16:01:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2F2C611C4;
        Wed, 22 Sep 2021 19:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632340778;
        bh=Eh2FuMEpUKm0E5dWN1BAfSCOnndQsAw1GzXJgxqOJXY=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=vLqAo//7RpyDObnSx5dS7v6aR8G7rg8UqkfYdX7J2kzTGwGTtK0fcfCGV/3nmbAUs
         x7AJ4vdO9GOnwEtU3Qx1ED6hO10QBq/ikWthg2F5XAHpgZs9mIYynWQzFxAIPjcMia
         mFgQDNTARFupG0JUtEgoY/ytojgtaAtlwaZdYFkfeqtrNBlA7hFcTJf11Sdgo87lM/
         KSefMNYtcS6JAZdt2pA60A0KBSyImJnS90QEMA+RE17YACpHmhdx568+JkvHq2nat9
         9gatIhHVehXSm/9Zbx7IyEcn5pg+mN06vqTuN5REeEEhTYAI/58c9YUR2JQzwBiECt
         Iu+OmkZaOMP4Q==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 6BC325C0A54; Wed, 22 Sep 2021 12:59:38 -0700 (PDT)
Date:   Wed, 22 Sep 2021 12:59:38 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org
Subject: Re: [RFC][PATCH 6/7] context_tracking: Provide SMP ordering using RCU
Message-ID: <20210922195938.GD880162@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20210922110506.703075504@infradead.org>
 <20210922110836.244770922@infradead.org>
 <20210922151721.GZ880162@paulmck-ThinkPad-P17-Gen-1>
 <YUuFF8+H2PE9m4wy@hirez.programming.kicks-ass.net>
 <YUuIb12XCQlBfIQW@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUuIb12XCQlBfIQW@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 22, 2021 at 09:47:59PM +0200, Peter Zijlstra wrote:
> On Wed, Sep 22, 2021 at 09:33:43PM +0200, Peter Zijlstra wrote:
> 
> > Anyway, lemme see if I get your proposal; lets say the counter starts at
> > 0 and is in kernel space.
> > 
> >  0x00(0) - kernel
> >  0x02(2) - user
> >  0x04(0) - kernel
> > 
> > So far so simple, then NMI on top of that goes:
> > 
> >  0x00(0) - kernel
> >  0x03(3) - kernel + nmi
> >  0x04(0) - kernel
> >  0x06(2) - user
> >  0x09(1) - user + nmi
> >  0x0a(2) - user
> > 
> > Which then gives us:
> > 
> >  (0) := kernel
> >  (1) := nmi-from-user
> >  (2) := user
> >  (3) := nmi-from-kernel
> > 
> > Which should work I suppose. But like I said above, I'd be happier if
> > this counter would live in context_tracking rather than RCU.
> 
> Furthermore, if we have this counter, the we can also do things like:
> 
>   seq = context_tracking_seq_cpu(that_cpu);
>   if ((seq & 3) != USER)
>     // nohz_fail, do something
>   set_tsk_thread_flag(curr_task(that_cpu), TIF_DO_SOME_WORK);
>   if (seq == context_tracking_seq_cpu(that_cpu))
>     // success!!
> 
> To remotely set pending state. Allowing yet more NOHZ_FULL fixes, like,
> for example, eliding the text_poke IPIs.

Nice!

There have been several instances where I thought that the extra state
would help RCU, but each time there turned out to be a simpler way to
get things done.  Or that it eventually turned out that RCU didn't need
to care about the difference between idle and nohz_full userspace.

							Thanx, Paul
