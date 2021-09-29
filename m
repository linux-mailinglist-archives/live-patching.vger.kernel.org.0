Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD5D41CCC8
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 21:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344377AbhI2TrW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 15:47:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244887AbhI2TrV (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 15:47:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 754AA613DA;
        Wed, 29 Sep 2021 19:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632944740;
        bh=SSBizUwzU7P1hfnNjMjgmannJ7niY7VHv9x1ZCMas4k=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=tpxxHwv9+B6xIRrrjrAA+VD6FGEUE+E/hPXl0STStgtE+sqgCeJSK14WYNeaHKS9I
         9mpg92OrfybCRFoiqbm+c7AY7jKAzBfdaa7AWCTaNMNcd9YlTkt4c6+hl+X2uOPhFb
         ifijczsbJ4tnHu2EcwGAlFPXhdCBUmTOwHdDqV298HapBXB0W9lPw7gwx4plz9yadt
         VmcImQYaNfxUgtAEsQX84CO/KUT3MlbfajqTtahgWHt2p1RG5MFhPKmGHKv0+XQpW4
         lTwJC4ttuTOhXJ3TXcdLriNH4CwjpHBZUFrB0uv7rTOxBJ+73Dnb5JSHIGaRSOd8GB
         b0imnaJ1WSSwg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 4A3A55C1309; Wed, 29 Sep 2021 12:45:40 -0700 (PDT)
Date:   Wed, 29 Sep 2021 12:45:40 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, rostedt@goodmis.org, x86@kernel.org
Subject: Re: [RFC][PATCH v2 08/11] context_tracking,rcu: Replace RCU dynticks
 counter with context_tracking
Message-ID: <20210929194540.GZ880162@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20210929151723.162004989@infradead.org>
 <20210929152429.007420590@infradead.org>
 <20210929183701.GY880162@paulmck-ThinkPad-P17-Gen-1>
 <20210929191326.GZ4323@worktop.programming.kicks-ass.net>
 <20210929192431.GG5106@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929192431.GG5106@worktop.programming.kicks-ass.net>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 29, 2021 at 09:24:31PM +0200, Peter Zijlstra wrote:
> On Wed, Sep 29, 2021 at 09:13:26PM +0200, Peter Zijlstra wrote:
> > On Wed, Sep 29, 2021 at 11:37:01AM -0700, Paul E. McKenney wrote:
> > 
> > > And what happens to all of this in !CONFIG_CONTEXT_TRACKING kernels?
> > > Of course, RCU needs it unconditionally.  (There appear to be at least
> > > parts of it that are unconditionally available, but I figured that I
> > > should ask.  Especially given the !CONFIG_CONTEXT_TRACKING definition
> > > of the __context_tracking_cpu_seq() function.)
> > 
> > For !CONFIG_CONTEXT_TRACKING it goes *poof*.
> > 
> > Since the thing was called dynticks, I presumed it was actually dynticks
> > only, silly me (also, I didn't see any obvious !context_tracking usage
> > of it, i'll go audit it more carefully.
> 
> Oh argh, it does idle too... damn. And I don't suppose having 2 counters
> is going to be nice :/
> 
> I'll go back to thinking about this.

Glad I could help?  For some definition of "help"?  ;-)

							Thanx, Paul
