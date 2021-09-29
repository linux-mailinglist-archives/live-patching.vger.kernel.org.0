Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E45B41CC96
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 21:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346487AbhI2T2u (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 15:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346463AbhI2T2s (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 15:28:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F696C061765;
        Wed, 29 Sep 2021 12:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WLQ1UteiuDxr5zMvOLEeFqf+m7DpN8OCufh9KBGNF3k=; b=lkXSqcXkuHl1H/ITAFrfgQe1P8
        axZYThYtS+M8ROnfB/Nham1m61DeilgiEyW0VRh/9/h+bify1RjSZmIYYhZuOiqHeCPRSF8QiYtqC
        ABtb7GXWx1Gq7wilJuEwvkuml4wpD6XlalwaPTCdr82OehK7VReeLI9zwxcjprgH73HfWUU/WO9HL
        D37GTgtHrbODZgH2+YX74FJhvvUCV5Va9i3a2tzZ9r8w2kIW9hUDHTS402U9eABPbyCm7Xw2U9XE0
        5Hxkk2Te5j52vz6eos4q3IaHDfWaiDnyIaW/lTaA2J8FlDf9jcpLldEFHVWKYc4mNAiw+65Eui2sU
        RG3aV7kw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVfBw-00CA3k-2n; Wed, 29 Sep 2021 19:24:38 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id A298C981431; Wed, 29 Sep 2021 21:24:31 +0200 (CEST)
Date:   Wed, 29 Sep 2021 21:24:31 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, rostedt@goodmis.org, x86@kernel.org
Subject: Re: [RFC][PATCH v2 08/11] context_tracking,rcu: Replace RCU dynticks
 counter with context_tracking
Message-ID: <20210929192431.GG5106@worktop.programming.kicks-ass.net>
References: <20210929151723.162004989@infradead.org>
 <20210929152429.007420590@infradead.org>
 <20210929183701.GY880162@paulmck-ThinkPad-P17-Gen-1>
 <20210929191326.GZ4323@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929191326.GZ4323@worktop.programming.kicks-ass.net>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 29, 2021 at 09:13:26PM +0200, Peter Zijlstra wrote:
> On Wed, Sep 29, 2021 at 11:37:01AM -0700, Paul E. McKenney wrote:
> 
> > And what happens to all of this in !CONFIG_CONTEXT_TRACKING kernels?
> > Of course, RCU needs it unconditionally.  (There appear to be at least
> > parts of it that are unconditionally available, but I figured that I
> > should ask.  Especially given the !CONFIG_CONTEXT_TRACKING definition
> > of the __context_tracking_cpu_seq() function.)
> 
> For !CONFIG_CONTEXT_TRACKING it goes *poof*.
> 
> Since the thing was called dynticks, I presumed it was actually dynticks
> only, silly me (also, I didn't see any obvious !context_tracking usage
> of it, i'll go audit it more carefully.

Oh argh, it does idle too... damn. And I don't suppose having 2 counters
is going to be nice :/

I'll go back to thinking about this.
