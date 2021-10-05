Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1907422A1D
	for <lists+live-patching@lfdr.de>; Tue,  5 Oct 2021 16:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbhJEOIj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 5 Oct 2021 10:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236255AbhJEOIQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 5 Oct 2021 10:08:16 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510BFC0613BA;
        Tue,  5 Oct 2021 07:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=e7v7PgfqKA1O480Vt1LMStZzMGGiTJbUW/3KjDTXWqM=; b=fcNQPCe35aWXS6SbfEGP9yj71a
        hYik+IgGGs2MJkrDVTal+MkJK+h0lPJlYrkQUlUFnMEAicKK5In2IMGs2fBNyvypEgNfrJnuzlyl5
        LVRT/NmAUiT75ankqPn2Je78zQHN6oGmZxi2uK4rBK1RywdjBMo9MNxN7IS7KrKlH7QV3dZ7gd5iF
        wxYSDA1LRLmit8o9G25aWJzpwRhEtU74NEkts2c7YII6J8uTLr28EAuHNvHdT7nKYYL024Oz/bKiP
        56zFQFhZZb8TVek/18pPmthSHwDnLhgEcfE+QE4COD4n+xgRnHT9bKkkqMXaCiBS1on6f9k917Ysh
        0nnDkqiA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mXl2v-0083k9-5v; Tue, 05 Oct 2021 14:03:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 61D4530026F;
        Tue,  5 Oct 2021 16:03:43 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 45912200B5F47; Tue,  5 Oct 2021 16:03:43 +0200 (CEST)
Date:   Tue, 5 Oct 2021 16:03:43 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, mingo@kernel.org, linux-kernel@vger.kernel.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: Re: [PATCH v2 03/11] sched,livepatch: Use task_call_func()
Message-ID: <YVxbP5fFLY10mqhy@hirez.programming.kicks-ass.net>
References: <20210929151723.162004989@infradead.org>
 <20210929152428.709906138@infradead.org>
 <YVw5qO0rLA/GduFm@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVw5qO0rLA/GduFm@alley>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Oct 05, 2021 at 01:40:24PM +0200, Petr Mladek wrote:
> On Wed 2021-09-29 17:17:26, Peter Zijlstra wrote:
> > Instead of frobbing around with scheduler internals, use the shiny new
> > task_call_func() interface.
> > 
> > --- a/kernel/livepatch/transition.c
> > +++ b/kernel/livepatch/transition.c
> > @@ -274,6 +266,22 @@ static int klp_check_stack(struct task_s
> >  	return 0;
> >  }
> >  
> > +static int klp_check_and_switch_task(struct task_struct *task, void *arg)
> > +{
> > +	int ret;
> > +
> > +	if (task_curr(task))
> 
> This must be
> 
> 	if (task_curr(task) && task != current)
> 
> , otherwise the task is not able to migrate itself. The condition was
> lost when reshuffling the original code, see below.

Urgh, yeah, I misread that and figued task_curr() should already capture
current, but the extra clause excludes current :/

> JFYI, I have missed it during review. I am actually surprised that the
> process could check its own stack reliably. But it seems to work.

Ah, unwinding yourself is actually the only sane option ;-)

> > -	rq = task_rq_lock(task, &flags);
> > +	ret = task_call_func(task, klp_check_and_switch_task, &old_name);
> 
> It looks correct. JFYI, this is why:
> 
> The logic seems to be exactly the same, except for the one fallout
> mentioned above. So the only problem might be races.
> 
> The only important thing is that the task must not be running on any CPU
> when klp_check_stack(task, arg) is called. By other word, the stack
> must stay the same when being checked.
> 
> The original code prevented races by taking task_rq_lock().
> And task_call_func() is slightly more relaxed but it looks safe enough:
> 
>   + it still takes rq lock when the task is in runnable state.
>   + it always takes p->pi_lock that prevents moving the task
>     into runnable state by try_to_wake_up().

Correct, the new task_call_func() is trying hard to not take rq->lock,
but should be effectively identical to task_rq_lock().

> With the added (task != current) check:

Done

> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Tested-by: Petr Mladek <pmladek@suse.com>

Thanks!
