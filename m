Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E86D3E323A
	for <lists+live-patching@lfdr.de>; Sat,  7 Aug 2021 01:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhHFX7U (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 6 Aug 2021 19:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhHFX7U (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 Aug 2021 19:59:20 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25DDC0613CF;
        Fri,  6 Aug 2021 16:59:02 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id k2so9168064plk.13;
        Fri, 06 Aug 2021 16:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MFcpdksmO/jlYYdvb2rl+zm6YLAzt31WealFmRADfcI=;
        b=LzHoz1WBSw98VA6YamFlirg4iypXLZPOjYRyLi+fa8cQvf/7Lldw8HcolLai7aolsJ
         1Qa67RmzrjwGpO0SmIWrS1Werdzb+2xmDGv//KgiFy3K9aNSSbgfzJvREEC98L92n7iY
         p17SLlKIEAo+wwKORMKRU0vT+Fn1gcxkeonqlVs2AeCziptSVnOVl/Nh+4LJxQrhL3Ok
         L0rmLklYkiYHCop5JCiyD5rer91zAx+GIFdwze1ZwehQbJlZ+kIH7wjtYZEf/b4TsOt8
         0wbjwxZ2m+MmdfupmqSUSMf8BI5BPxMy1stBLtFUVmJjG+E/kDyyFOWsSQSnNMOYnZUr
         RMKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MFcpdksmO/jlYYdvb2rl+zm6YLAzt31WealFmRADfcI=;
        b=bxtDqfaXTgu2lAvhLFJdvQ/xTV23j0axrBMc4Rn6ib0foiH31Zy3J50maKqF+Kwhg1
         f/tzf1h5ZZWyKAfkwr2KfphYcMlwSNi0xUB1jCm1nOckwKqFYEozNMcaV9l1nVmTi2CU
         nTidQtLfqeRrKxumfFnGnKcvsRVkN1boqtHMZhMFUhC7MyLbr4cLC5g5whx/r54YIkwl
         4I/uBykpPvM+ge/rHcub8VcR1b3gNImKVmpf4OrZ3vxmyOfSN3KTkxfcJ5gOmI9Hnl4k
         cjyrWJ2+UE56qRcAtzLnesayP4zNl+uOiiCgy0U2DIpJ3d3RaHktwp7a0jllUHL+XNcH
         K3AA==
X-Gm-Message-State: AOAM531LehLzpBFmNymWQQRJmpyfOe/j3g75s1iX3jtaOhpC7dlqiTDM
        Bb1rLcJSbnfGnT1TyTTk27E=
X-Google-Smtp-Source: ABdhPJzSA6uIj12lIZQGj9w5x6HWUu7xNt+wALajH8N2m3E4FORUJ3cg8CAvFzHEQ7Zzguu2riZD9A==
X-Received: by 2002:a17:902:e04e:b029:12c:def4:56a3 with SMTP id x14-20020a170902e04eb029012cdef456a3mr9874185plx.76.1628294342188;
        Fri, 06 Aug 2021 16:59:02 -0700 (PDT)
Received: from xray-cmxmeta-1a-i-575ab9cd.us-east-1.amazon.com ([205.251.233.176])
        by smtp.googlemail.com with ESMTPSA id e8sm2420058pjg.4.2021.08.06.16.59.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 06 Aug 2021 16:59:01 -0700 (PDT)
Message-ID: <5b4f3fdddd418a39d4054981df03333b46d8ae2c.camel@gmail.com>
Subject: Re: [RFC PATCH] livepatch: Kick idle cpu's tasks to perform
 transition
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     Vasily Gorbik <gor@linux.ibm.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 06 Aug 2021 16:59:00 -0700
In-Reply-To: <patch.git-b76842ceb035.your-ad-here.call-01625661932-ext-1304@work.hours>
References: <patch.git-b76842ceb035.your-ad-here.call-01625661932-ext-1304@work.hours>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 2021-07-07 at 14:49 +0200, Vasily Gorbik wrote:
> On an idle system with large amount of cpus it might happen that
> klp_update_patch_state() is not reached in do_idle() for a long
> periods
> of time. With debug messages enabled log is filled with:
> [  499.442643] livepatch: klp_try_switch_task: swapper/63:0 is
> running
> 
> without any signs of progress. Ending up with "failed to complete
> transition".
> 
> On s390 LPAR with 128 cpus not a single transition is able to
> complete
> and livepatch kselftests fail.

This also speeds up completion of the transition on high cpu count arm
instances.

Interested in seeing the correct way to address this.

Suraj.

> 
> To deal with that, make sure we break out of do_idle() inner loop to
> reach klp_update_patch_state() by marking idle tasks as NEED_RESCHED
> as well as kick cpus out of idle state.
> 
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> ---
>  kernel/livepatch/transition.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/livepatch/transition.c
> b/kernel/livepatch/transition.c
> index 3a4beb9395c4..793eba46e970 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -415,8 +415,11 @@ void klp_try_complete_transition(void)
>  	for_each_possible_cpu(cpu) {
>  		task = idle_task(cpu);
>  		if (cpu_online(cpu)) {
> -			if (!klp_try_switch_task(task))
> +			if (!klp_try_switch_task(task)) {
>  				complete = false;
> +				set_tsk_need_resched(task);
> +				kick_process(task);
> +			}
>  		} else if (task->patch_state != klp_target_state) {
>  			/* offline idle tasks can be switched
> immediately */
>  			clear_tsk_thread_flag(task, TIF_PATCH_PENDING);

