Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E115D413C36
	for <lists+live-patching@lfdr.de>; Tue, 21 Sep 2021 23:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbhIUVSu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Sep 2021 17:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbhIUVSu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Sep 2021 17:18:50 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C765C061574;
        Tue, 21 Sep 2021 14:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yQhIdAmJSx1dqatvz04cwJ8WL0F8XAnlHKdZajRA/10=; b=Gz9vzl3E2I3wt8s0h/gmPx6eF9
        p5f9S7hhdmgnbrXBl60RIwmbYJGDvn/XX1w+vtXYRotqkhi358I4j1N6v2aqoUt7il+RO7byT9kAC
        Az/TZ/XjaKXKPYoymV6XrzIsqJ9EMTTJn3b8B1wi0voyn0GZ7x8oTO1MCoGxxa3iihCZyThA6wEiQ
        rscJkoYyKPIAtiI4ZHTaU6T0nCdtrX1oDvdTXiGh2albn9lMBx1ZpWiCa6tdFhBBFDG/dA+qImJhv
        /FT90lXYAJy2wz7bKbo5vmdeQakDqs0OOv0B9xVWjYOCy2thr5eJ7Kpk7fVLKySmmsAJrLVoPW4sB
        0C2Rmc0A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mSn8Y-004qO5-Nh; Tue, 21 Sep 2021 21:17:10 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 31856981483; Tue, 21 Sep 2021 23:17:09 +0200 (CEST)
Date:   Tue, 21 Sep 2021 23:17:09 +0200
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
Message-ID: <20210921211709.GE5106@worktop.programming.kicks-ass.net>
References: <patch.git-94c1daf66a9c.your-ad-here.call-01631714463-ext-3692@work.hours>
 <YUoZtF1qPyTx07pU@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUoZtF1qPyTx07pU@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Sep 21, 2021 at 07:43:16PM +0200, Peter Zijlstra wrote:
> On Wed, Sep 15, 2021 at 04:18:01PM +0200, Vasily Gorbik wrote:
> 
> > diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> > index 291b857a6e20..2846a879f2dc 100644
> > --- a/kernel/livepatch/transition.c
> > +++ b/kernel/livepatch/transition.c
> > @@ -278,6 +278,8 @@ static int klp_check_stack(struct task_struct *task, char *err_buf)
> >   * Try to safely switch a task to the target patch state.  If it's currently
> >   * running, or it's sleeping on a to-be-patched or to-be-unpatched function, or
> >   * if the stack is unreliable, return false.
> > + *
> > + * Idle tasks are switched in the main loop when running.
> >   */
> >  static bool klp_try_switch_task(struct task_struct *task)
> >  {
> > @@ -308,6 +310,12 @@ static bool klp_try_switch_task(struct task_struct *task)
> >  	rq = task_rq_lock(task, &flags);
> >  
> >  	if (task_running(rq, task) && task != current) {
> > +		/*
> > +		 * Idle task might stay running for a long time. Switch them
> > +		 * in the main loop.
> > +		 */
> > +		if (is_idle_task(task))
> > +			resched_curr(rq);
> >  		snprintf(err_buf, STACK_ERR_BUF_SIZE,
> >  			 "%s: %s:%d is running\n", __func__, task->comm,
> >  			 task->pid);
> 
> So 'recently' we grew try_invoke_on_locked_down_task() (yes, that's a
> crap name), and I'm thinking this code is very similar to that. So
> perhaps we re-use that.
> 
> Perhaps have func() > 0 imply resched.
> 
> I'll have a play...

https://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git/log/?h=sched/livepatch

I'll write proper changelogs and post tomorrow,... (and fix robot fail,
if any).

(also, notes to later self:

 - task_try_func() might need to re-check on_rq after acquiring rq_lock
 - klp_send_signal() might want wake_up_process()/TASK_NORMAL due to TASK_IDLE
)
