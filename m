Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1297A406E99
	for <lists+live-patching@lfdr.de>; Fri, 10 Sep 2021 18:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbhIJQE3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 10 Sep 2021 12:04:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31059 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234521AbhIJQE2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 10 Sep 2021 12:04:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631289797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UtzAchFt0Lhk/coSSurUDkWQxyxTsyejteYjq47a0/U=;
        b=PSmkx9+lGEkLtWsyyxQeBMKt1l05ckUirzTwQejj/tsT5yIckCCAZ3QXIdKQSAXAhqp5If
        P/OvjwDBoJ8zA5NcgZdDstFBa+iumOgjavrC4Q2/VdetrMi9lGvnttxXsN06q1t1evvMr1
        UfEHNgpChxC/mJVEkxm8n9Drchi+Lj8=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-gWxIQZPMPmSziU3xMfIfiQ-1; Fri, 10 Sep 2021 12:03:14 -0400
X-MC-Unique: gWxIQZPMPmSziU3xMfIfiQ-1
Received: by mail-qv1-f70.google.com with SMTP id dv7-20020ad44ee7000000b0036fa79fd337so19119248qvb.6
        for <live-patching@vger.kernel.org>; Fri, 10 Sep 2021 09:03:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UtzAchFt0Lhk/coSSurUDkWQxyxTsyejteYjq47a0/U=;
        b=F4tkGbjr1DA9PdRy/UYKk9+Gwok3TR3k2Qg2jgcZHTwQYoy+SgXp2UMep0StQaaATk
         lmUxYJVS2z5BaaF8I0rWlJYnT9o5OpH9d6k4oRSs/F5vuTSfhBUf+hDEdFwfbYosv/Hg
         Rx/ukTzbL6QkuX6XLLgC0xxVtF37rfTBfhgAjofxYkXxDbp4pbw4/sr6yM9H4lFe+7c8
         jE+UDzhO7uioUCJ/zl6ZW3Mzr92FaEczDLHuP6kC2ryyD9h0d/y118vtP9y/pNdeDROr
         pLnF9/oxI1AuyNA2Z6W38B/F72mvBU80dDOgS+T6AwzOioCXTyT6WF8p227qcpfYyvcf
         MWOw==
X-Gm-Message-State: AOAM533SSsPodmibAQSe1EyU0QUImwkCyB6eP6aksLPBtNiKRmMN/QqJ
        3swe4UOWDbpkL2V3YYVk/SpbYAgxQepptPaXwIgtwhvszXK/ubRjTQGxgulkZytRFRXi8cJK+ka
        HcEgebK6iv/DM6ziXQnFZqYb5Pw==
X-Received: by 2002:ad4:54e4:: with SMTP id k4mr9320539qvx.54.1631289792973;
        Fri, 10 Sep 2021 09:03:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6SZlgo7LHBrrx9oMOb7QAMtI6UI2XIgb6J+qceJloTj2GEpX7MffeBJ9UcNo1Vzg3eAAEUg==
X-Received: by 2002:ad4:54e4:: with SMTP id k4mr9320506qvx.54.1631289792746;
        Fri, 10 Sep 2021 09:03:12 -0700 (PDT)
Received: from treble ([2600:1700:6e32:6c00::d])
        by smtp.gmail.com with ESMTPSA id x27sm3573915qtm.23.2021.09.10.09.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 09:03:12 -0700 (PDT)
Date:   Fri, 10 Sep 2021 09:03:03 -0700
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Vasily Gorbik <gor@linux.ibm.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: Fix idle cpu's tasks transition
Message-ID: <20210910160303.alfgjy25y5wfskwz@treble>
References: <patch.git-a4aad6b1540d.your-ad-here.call-01631177886-ext-3083@work.hours>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <patch.git-a4aad6b1540d.your-ad-here.call-01631177886-ext-3083@work.hours>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Sep 09, 2021 at 11:16:01AM +0200, Vasily Gorbik wrote:
> On an idle system with large amount of cpus it might happen that
> klp_update_patch_state() is not reached in do_idle() for a long periods
> of time. With debug messages enabled log is filled with:
> [  499.442643] livepatch: klp_try_switch_task: swapper/63:0 is running
> 
> without any signs of progress. Ending up with "failed to complete
> transition".
> 
> On s390 LPAR with 128 cpus not a single transition is able to complete
> and livepatch kselftests fail. Tests on idling x86 kvm instance with 128
> cpus demonstrate similar symptoms with and without CONFIG_NO_HZ.
> 
> To deal with that, since runqueue is already locked in
> klp_try_switch_task() identify idling cpus and trigger rescheduling
> potentially waking them up and making sure idle tasks break out of
> do_idle() inner loop and reach klp_update_patch_state(). This helps to
> speed up transition time while avoiding unnecessary extra system load.
> 
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

Looks ok to me, but we should get an ack from Ingo or Peter since
livepatch would be calling another private scheduler interface.

> ---
> Previous discussion and RFC PATCH:
> lkml.kernel.org/r/patch.git-b76842ceb035.your-ad-here.call-01625661932-ext-1304@work.hours
> 
>  kernel/livepatch/transition.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index 3a4beb9395c4..c5832b2dd081 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -308,6 +308,8 @@ static bool klp_try_switch_task(struct task_struct *task)
>  	rq = task_rq_lock(task, &flags);
>  
>  	if (task_running(rq, task) && task != current) {
> +		if (is_idle_task(task))
> +			resched_curr(rq);
>  		snprintf(err_buf, STACK_ERR_BUF_SIZE,
>  			 "%s: %s:%d is running\n", __func__, task->comm,
>  			 task->pid);
> -- 
> 2.25.4
> 

-- 
Josh

