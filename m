Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3F341CC24
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 20:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346078AbhI2S4l (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 14:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346351AbhI2S4k (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 14:56:40 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA41C06161C;
        Wed, 29 Sep 2021 11:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qiQL1a+4A5/lJgEPv30uUP5q8YSf2KgFRHmRv85d4Ss=; b=AcShQt+/cbF6F6AEdaSSWYIjoD
        EDx7cgjvwGfOJTEjdPOAZBzRpdZH5chzRG7fHjenpeMG0zoqnmtrQCFgpQrgrZ9r++JBZRkO2A6wS
        6U5NgltQn4zozEZWbi0z57BQfsd1tdpOyhImK8nH+LVcg3hMwaXQo0b/fA3YZYCO9ybAIZdAKJIvZ
        LLWOMiv3wXpEdWJuNv8SpW3Igv8tiSySZ/M4mwQlcr3D3esdxhLj+IZvdb50AP1uKhSqtmxgsbJfd
        c8bgUbbofLhHo76J9vA5xeEW9lDotD1JAORwUIA/s8nzzhsGwqu36ZmahyeltVhHT18IYVO/Mp4s0
        44haf3rA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVeiz-006lzX-M4; Wed, 29 Sep 2021 18:54:37 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1AE7A980FC7; Wed, 29 Sep 2021 20:54:36 +0200 (CEST)
Date:   Wed, 29 Sep 2021 20:54:35 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: Re: [RFC][PATCH v2 08/11] context_tracking,rcu: Replace RCU dynticks
 counter with context_tracking
Message-ID: <20210929185435.GW4323@worktop.programming.kicks-ass.net>
References: <20210929151723.162004989@infradead.org>
 <20210929152429.007420590@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929152429.007420590@infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 29, 2021 at 05:17:31PM +0200, Peter Zijlstra wrote:
> XXX I'm pretty sure I broke task-trace-rcu.

> -static noinstr void rcu_dynticks_eqs_enter(void)
> -{
> -	int seq;
> -
> -	/*
> -	 * CPUs seeing atomic_add_return() must see prior RCU read-side
> -	 * critical sections, and we also must force ordering with the
> -	 * next idle sojourn.
> -	 */
> -	rcu_dynticks_task_trace_enter();  // Before ->dynticks update!
> -	seq = rcu_dynticks_inc(1);
> -	// RCU is no longer watching.  Better be in extended quiescent state!
> -	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && (seq & 0x1));
> -}

> -static noinstr void rcu_dynticks_eqs_exit(void)
> -{
> -	int seq;
> -
> -	/*
> -	 * CPUs seeing atomic_add_return() must see prior idle sojourns,
> -	 * and we also must force ordering with the next RCU read-side
> -	 * critical section.
> -	 */
> -	seq = rcu_dynticks_inc(1);
> -	// RCU is now watching.  Better not be in an extended quiescent state!
> -	rcu_dynticks_task_trace_exit();  // After ->dynticks update!
> -	WARN_ON_ONCE(IS_ENABLED(CONFIG_RCU_EQS_DEBUG) && !(seq & 0x1));
> -}

So specifically rcu_dynticks_task_trace_{enter,exit}() are now orphaned.
After this patch, nothing calls them.

However, looking at this again, we've got:

  __context_tracking_enter()
    rcu_user_enter()
      rcu_eqs_enter()
        rcu_dynticks_eqs_enter()
	  rcu_dynticks_task_trace_enter()
	  rcu_dynticks_inc();
	rcu_dynticks_task_enter();

    ct_seq_user_enter()
      atomic_add_return()

and on the other end:

  __context_tracking_exit()
    ct_seq_user_exit()
      atomic_add_return()

    rcu_user_exit()
      rcu_esq_exit()
        rcu_dynticks_task_exit()
	rcu_dynticks_eqs_exit()
	  rcu_dynticks_inc()
	  rcu_dynticks_task_trace_exit()

And since we want to replace dynticks_inc() with ct_seq_*() the
rcu_dynticks_task_{enter,exit}() ought to be pulled before that..

Instead I orphaned rcu_dynticks_task_trace_{enter,exit}() which should
more or less stay where they are.

I seems to have confused the two :/

