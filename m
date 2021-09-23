Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B24415F58
	for <lists+live-patching@lfdr.de>; Thu, 23 Sep 2021 15:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241199AbhIWNTD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Sep 2021 09:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241192AbhIWNTD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Sep 2021 09:19:03 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5011FC061574;
        Thu, 23 Sep 2021 06:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tmDonrWu05hjIRPkXFF1Mu4Nt+eEVaV44JNRiKNgNao=; b=H0DIJd9AONr/Qm3wvoF0U10Sc5
        XFgyAlroSRTOuwagOj4JGeafBvbwpoXPZsRd2FbKAPO8IT7ZwbXEXu4KGzb9syWVpD8+pQrR7XIUr
        FES2cyryRjQicYQhJAjv7vI6rKwbRPPBImdlrHMHx5Tzds17FIkajXf0bjcYu5AmIs84znUDAu54F
        cH5Ee2yaOG9mILq9zqN28EJRyHp46PF5hdCTEqWQtrVU4KwuOXMexevjt6hkTrFVoDlC3BrAqG9B+
        VO+2Xht0n5n0EHA8KtBFUB3cdN30c5XIds0QCp1lTwcZ7NNEMJEYNe2Q88A8hkCuWDcg1C9MqWD9A
        7NsLjYPg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mTObH-005EcR-K7; Thu, 23 Sep 2021 13:17:20 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 20BF5300252;
        Thu, 23 Sep 2021 15:17:17 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D0B5220251DC2; Thu, 23 Sep 2021 15:17:17 +0200 (CEST)
Date:   Thu, 23 Sep 2021 15:17:17 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, mingo@kernel.org, linux-kernel@vger.kernel.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org
Subject: Re: [RFC][PATCH 3/7] sched,livepatch: Use task_try_func()
Message-ID: <YUx+XcYQlQ4SqEj8@hirez.programming.kicks-ass.net>
References: <20210922110506.703075504@infradead.org>
 <20210922110836.065940560@infradead.org>
 <YUxtbCthpr+l9XM0@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUxtbCthpr+l9XM0@alley>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Sep 23, 2021 at 02:05:00PM +0200, Petr Mladek wrote:
> On Wed 2021-09-22 13:05:09, Peter Zijlstra wrote:

> > +static int klp_check_task(struct task_struct *task, void *arg)
> 
> Please, call this klp_check_and_switch_task() to make it clear
> that it actually does the switch.

Sure.


> > +	ret = task_try_func(task, klp_check_task, &old_name);
> > +	switch (ret) {
> > +	case -EBUSY:
> > +		pr_debug("%s: %s:%d is running\n",
> > +			 __func__, task->comm, task->pid);
> > +		break;
> > +	case -EINVAL:
> > +		pr_debug("%s: %s:%d has an unreliable stack\n",
> > +			 __func__, task->comm, task->pid);
> > +		break;
> > +	case -EADDRINUSE:
> > +		pr_debug("%s: %s:%d is sleeping on function %s\n",
> > +			 __func__, task->comm, task->pid, old_name);
> > +		break;
> 
> I would prefer to be on the safe side and catch error codes that might
> eventually appear in the future.
> 
> 	case 0:
> 		/* success */
> 		break;

	case -EAGAIN:
		/* task_try_func() raced */
		break;

> 	default:
> 		pr_debug("%s: Unknown error code (%d) when trying to switch %s:%d\n",
> 			 __func__, ret, task->comm, task->pid);
> 
> >  	}

Done.
