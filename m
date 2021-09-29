Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B2C41CC65
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 21:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346485AbhI2TN0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 15:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346519AbhI2TNV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 15:13:21 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2834C061764;
        Wed, 29 Sep 2021 12:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VB8BEkWYk8ipFDdF2QL3GxbUNqMFCHrHcxXp4+kJ8gc=; b=UVKcdtzsXUv2MstXbvKPcOGKJQ
        0H44svCOKks+sKDJ9L9dO30Fe2ILlQxucStp9wUuOjPV+n7BkUGNjikmV0B4LqMbIZzwGXHWziHZ8
        OCHHUSN8WFY1ZD/z07smErug4PT8cksxGEaQjtrWjWYTHQFpb+gy0Ux2YkWRCDCu14KhCd2//nn+m
        mj73PdcQ4LKh86QbkzgOmTghHKvK4Ej9c8KgDTRWEQh18RDXD8afRy6g45xMaOlIMafuL002Kx755
        ZIUd8TV8AXGTx6q86SxyHYbBG1YfPqpI99LPaXifwxSluEHLPOnyN6X5O8+xLVh/dvwNaG2tF05dz
        zycFYneQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVez6-006mGU-6n; Wed, 29 Sep 2021 19:11:16 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id AA389981431; Wed, 29 Sep 2021 21:11:15 +0200 (CEST)
Date:   Wed, 29 Sep 2021 21:11:15 +0200
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
Message-ID: <20210929191115.GY4323@worktop.programming.kicks-ass.net>
References: <20210929151723.162004989@infradead.org>
 <20210929152429.007420590@infradead.org>
 <20210929183701.GY880162@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929183701.GY880162@paulmck-ThinkPad-P17-Gen-1>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 29, 2021 at 11:37:01AM -0700, Paul E. McKenney wrote:

> > +void context_tracking_idle(void)
> > +{
> > +	atomic_add_return(CT_SEQ, &raw_cpu_ptr(&context_tracking)->seq);
> 
> This is presumably a momentary idle.

> >  notrace void rcu_momentary_dyntick_idle(void)
> >  {
> > -	int seq;
> > -
> >  	raw_cpu_write(rcu_data.rcu_need_heavy_qs, false);
> > -	seq = rcu_dynticks_inc(2);
> > -	/* It is illegal to call this from idle state. */
> > -	WARN_ON_ONCE(!(seq & 0x1));
> > +	context_tracking_idle();
> >  	rcu_preempt_deferred_qs(current);
> >  }

It's whatever that is. It increments the actual sequence count without
modifying the state.
