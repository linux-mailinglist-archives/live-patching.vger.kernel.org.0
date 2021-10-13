Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5575D42CA2B
	for <lists+live-patching@lfdr.de>; Wed, 13 Oct 2021 21:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhJMTjX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 13 Oct 2021 15:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231654AbhJMTjW (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 13 Oct 2021 15:39:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4272061165;
        Wed, 13 Oct 2021 19:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634153839;
        bh=ifrxkWVMul5hUh9VojQ3Svlaor+10MLDookWG/BdTkw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GbWkfwLW/uKn2DMVou9PyNh0zbv687yV6FWEXMG7oEEQw5e6dUIe6s5a6v74VFaMA
         bqBN/+9RU1POJI+KiurGQOjMv2e9r0GAi+JJJ2x3tf41oozeXOOMEh5jIKnU4Ruyet
         8Ha4RQSBnmTW9+bkPbVKdWkpiWS7rGdL6kEcUcVoFqSBqfGD3RxD1OeROdGXTzOVM/
         S8m42D8NwJk/J9lAF1l38e7oI4xJ2KOw9rTD/wa+rXd+DqutxDy0WQwwFOe/OKTdB3
         hsTKygW+JhRMijL7itUEFZo353mJIIc/kJe/aixSqkDeCousx/NymurL79q7167NGY
         ne8adtUg8JFyQ==
Received: by mail-wr1-f44.google.com with SMTP id r18so11941584wrg.6;
        Wed, 13 Oct 2021 12:37:19 -0700 (PDT)
X-Gm-Message-State: AOAM530tnUEYrQ3V8zYNNCZicgKulv3d5Y49oFAsVI70KZLCuoXhadLc
        k+ybqhOr09BkPV2gE6xYiLLsxiWk9KjABBsIb34=
X-Google-Smtp-Source: ABdhPJwO4LhGFCjaFymEgvNcqwRGFlPpa7P9EPTliagCrXYJ1aU7rN8dJMKaJf0KEPyxtdqyii2IRAewdr9K1x8LuM0=
X-Received: by 2002:adf:f481:: with SMTP id l1mr1159174wro.411.1634153837697;
 Wed, 13 Oct 2021 12:37:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210929151723.162004989@infradead.org> <20210929152428.828064133@infradead.org>
In-Reply-To: <20210929152428.828064133@infradead.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 13 Oct 2021 21:37:01 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0N-ZuSEZyw5ub1vr3VP2Bdoa2Wq=No1gad+SyqquQXfw@mail.gmail.com>
Message-ID: <CAK8P3a0N-ZuSEZyw5ub1vr3VP2Bdoa2Wq=No1gad+SyqquQXfw@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] sched,livepatch: Use wake_up_if_idle()
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Vasily Gorbik <gor@linux.ibm.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        joe.lawrence@redhat.com,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <hca@linux.ibm.com>, svens@linux.ibm.com,
        sumanthk@linux.ibm.com, live-patching@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 29, 2021 at 6:10 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
> Make sure to prod idle CPUs so they call klp_update_patch_state().
>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  kernel/livepatch/transition.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -413,8 +413,11 @@ void klp_try_complete_transition(void)
>         for_each_possible_cpu(cpu) {
>                 task = idle_task(cpu);
>                 if (cpu_online(cpu)) {
> -                       if (!klp_try_switch_task(task))
> +                       if (!klp_try_switch_task(task)) {
>                                 complete = false;
> +                               /* Make idle task go through the main loop. */
> +                               wake_up_if_idle(cpu);
> +                       }

This caused a build regression on non-SMP kernels:

x86_64-linux-ld: kernel/livepatch/transition.o: in function
`klp_try_complete_transition':
transition.c:(.text+0x106e): undefined reference to `wake_up_if_idle'

Maybe add a IS_ENABLED(CONFIG_SMP) check to one of the if() conditions?

        Arnd
