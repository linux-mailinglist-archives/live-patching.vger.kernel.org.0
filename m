Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57484138ED
	for <lists+live-patching@lfdr.de>; Tue, 21 Sep 2021 19:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhIURpA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Sep 2021 13:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbhIURo7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Sep 2021 13:44:59 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6F8C061574;
        Tue, 21 Sep 2021 10:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=a2OzgtMmGpk6woPpOvOOcLPpmrGPO53fLZOixEExQ+g=; b=I5os7sMIFl2i1UmHdrajeHi+xW
        XBO+ZEeHOom+1PPrXwszjpQUos2Xo1bBktJ7J9wIemW/1cndJLEVJ42gtPV6bHSNdte43CCGb/kiW
        n9NUP+xXpfoax7cTGABhNvqvlP+QTeVjhx7lOS88wul5r5BV/PURM4ZLFGX8OiKjABWEyPew0xPYz
        FO2cnYum4z+o1FOMjtktnuc2mJq2kI4P25hcTRBWsID8yyZxPZuFTjfArxok1oZ0/+Egf3gC/vV3r
        qFr0It7LM56SV0FSgkCOPja53jcUaFu3zFvaUeNMZnvetFfWsU7OqnWIHHHopqxoAegc3HVMjmh2K
        B43mzaVg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mSjna-004o6w-5i; Tue, 21 Sep 2021 17:43:18 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BDB89300252;
        Tue, 21 Sep 2021 19:43:16 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A7DF720303903; Tue, 21 Sep 2021 19:43:16 +0200 (CEST)
Date:   Tue, 21 Sep 2021 19:43:16 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Vasily Gorbik <gor@linux.ibm.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] livepatch: Fix idle cpu's tasks transition
Message-ID: <YUoZtF1qPyTx07pU@hirez.programming.kicks-ass.net>
References: <patch.git-94c1daf66a9c.your-ad-here.call-01631714463-ext-3692@work.hours>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patch.git-94c1daf66a9c.your-ad-here.call-01631714463-ext-3692@work.hours>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 15, 2021 at 04:18:01PM +0200, Vasily Gorbik wrote:

> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index 291b857a6e20..2846a879f2dc 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -278,6 +278,8 @@ static int klp_check_stack(struct task_struct *task, char *err_buf)
>   * Try to safely switch a task to the target patch state.  If it's currently
>   * running, or it's sleeping on a to-be-patched or to-be-unpatched function, or
>   * if the stack is unreliable, return false.
> + *
> + * Idle tasks are switched in the main loop when running.
>   */
>  static bool klp_try_switch_task(struct task_struct *task)
>  {
> @@ -308,6 +310,12 @@ static bool klp_try_switch_task(struct task_struct *task)
>  	rq = task_rq_lock(task, &flags);
>  
>  	if (task_running(rq, task) && task != current) {
> +		/*
> +		 * Idle task might stay running for a long time. Switch them
> +		 * in the main loop.
> +		 */
> +		if (is_idle_task(task))
> +			resched_curr(rq);
>  		snprintf(err_buf, STACK_ERR_BUF_SIZE,
>  			 "%s: %s:%d is running\n", __func__, task->comm,
>  			 task->pid);

So 'recently' we grew try_invoke_on_locked_down_task() (yes, that's a
crap name), and I'm thinking this code is very similar to that. So
perhaps we re-use that.

Perhaps have func() > 0 imply resched.

I'll have a play...
