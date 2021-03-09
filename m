Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FDD333104
	for <lists+live-patching@lfdr.de>; Tue,  9 Mar 2021 22:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbhCIVhc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 9 Mar 2021 16:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbhCIVg7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 9 Mar 2021 16:36:59 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D250C06174A;
        Tue,  9 Mar 2021 13:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=GQaav7q/hcpIkgbXD6dyks8sGrzhXivAUSZ+R3xxWzs=; b=KjG9YkfpPkfy2NMrNsVvZvh7DL
        PJ1Au9SjZIhUdN2n0hJGRtS/hku15ADinslh+5yDNbTvmUY9HZHbh86zgjR1DeW2noo0xFhfOb/O/
        2hspEu1vwJRDj3D2O8CCHL87XKJ35NAAaj+msVWnO1AfXLz+l9pq9Wl6t4ASUkhvuc0iea8TZ7/3N
        jLIxKOzwp3Jzrt8x9WzTI4JMtzhLMtbqRBW+lorZ9AoHduOSFQCFYiXEs/afPelaZtZYyNEyVKgSf
        mvfJNuIVhHOTirlRWznjpBoeOSqblmW8Rge++lChOHnKcVkRQ+KFA9eWaSRY1WpAXaDw3v/DXMO14
        nhDAP9+Q==;
Received: from merlin.infradead.org ([2001:8b0:10b:1234::107])
        by desiato.infradead.org with esmtps (Exim 4.94 #2 (Red Hat Linux))
        id 1lJk2D-005TYi-AI; Tue, 09 Mar 2021 21:36:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=GQaav7q/hcpIkgbXD6dyks8sGrzhXivAUSZ+R3xxWzs=; b=Iz8HW/laqU9E2f/soy51xGtgnn
        lBNIER11ZMvCYXKVp1TKZXg7alj+68Y9B0QXHK6ZJhyNIGaafslCKTozm51NElb+NXt7DjxpDlK8y
        1Y30lwy/NOkcmOToTjUTXjWEjVpQZE89mP39FXFGylaCTZrw9vmfWIPChqSzXITtkAbze0+DwC8RR
        stMSlk7AiGmxuSN41cUeM2tGUwCf91nsRNs4uw2KvigMM1i3aNjocbcAaIMqQ5rxbs6nrOElPoy4w
        bpwfPGSGuqtx6Onj39XSOrD66rqfsByASvwWWd9sWersSFklgHh9EI2+630MzSHi2sQVxBY3bpNJK
        /DBZHoQg==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lJk1n-000ifz-HK; Tue, 09 Mar 2021 21:36:34 +0000
Subject: Re: [PATCH] stacktrace: Move documentation for
 arch_stack_walk_reliable() to header
To:     Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, x86@kernel.org,
        linux-s390@vger.kernel.org, live-patching@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Miroslav Benes <mbenes@suse.cz>
References: <20210309194125.652-1-broonie@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <55c3a5a6-6f14-52f3-61c4-f4d8c8c0b64c@infradead.org>
Date:   Tue, 9 Mar 2021 13:36:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210309194125.652-1-broonie@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 3/9/21 11:41 AM, Mark Brown wrote:
> Currently arch_stack_wallk_reliable() is documented with an identical
> comment in both x86 and S/390 implementations which is a bit redundant.
> Move this to the header and convert to kerneldoc while we're at it.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Joe Lawrence <joe.lawrence@redhat.com>
> Cc: x86@kernel.org
> Cc: linux-s390@vger.kernel.org
> Cc: live-patching@vger.kernel.org
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Acked-by: Vasily Gorbik <gor@linux.ibm.com>
> Reviewed-by: Miroslav Benes <mbenes@suse.cz>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Looks good. Thanks.

> ---
>  arch/s390/kernel/stacktrace.c |  6 ------
>  arch/x86/kernel/stacktrace.c  |  6 ------
>  include/linux/stacktrace.h    | 19 +++++++++++++++++++
>  3 files changed, 19 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/s390/kernel/stacktrace.c b/arch/s390/kernel/stacktrace.c
> index 7f1266c24f6b..101477b3e263 100644
> --- a/arch/s390/kernel/stacktrace.c
> +++ b/arch/s390/kernel/stacktrace.c
> @@ -24,12 +24,6 @@ void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
>  	}
>  }
>  
> -/*
> - * This function returns an error if it detects any unreliable features of the
> - * stack.  Otherwise it guarantees that the stack trace is reliable.
> - *
> - * If the task is not 'current', the caller *must* ensure the task is inactive.
> - */
>  int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
>  			     void *cookie, struct task_struct *task)
>  {
> diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
> index 8627fda8d993..15b058eefc4e 100644
> --- a/arch/x86/kernel/stacktrace.c
> +++ b/arch/x86/kernel/stacktrace.c
> @@ -29,12 +29,6 @@ void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
>  	}
>  }
>  
> -/*
> - * This function returns an error if it detects any unreliable features of the
> - * stack.  Otherwise it guarantees that the stack trace is reliable.
> - *
> - * If the task is not 'current', the caller *must* ensure the task is inactive.
> - */
>  int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
>  			     void *cookie, struct task_struct *task)
>  {
> diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
> index 50e2df30b0aa..9edecb494e9e 100644
> --- a/include/linux/stacktrace.h
> +++ b/include/linux/stacktrace.h
> @@ -52,8 +52,27 @@ typedef bool (*stack_trace_consume_fn)(void *cookie, unsigned long addr);
>   */
>  void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
>  		     struct task_struct *task, struct pt_regs *regs);
> +
> +/**
> + * arch_stack_walk_reliable - Architecture specific function to walk the
> + *			      stack reliably
> + *
> + * @consume_entry:	Callback which is invoked by the architecture code for
> + *			each entry.
> + * @cookie:		Caller supplied pointer which is handed back to
> + *			@consume_entry
> + * @task:		Pointer to a task struct, can be NULL
> + *
> + * This function returns an error if it detects any unreliable
> + * features of the stack. Otherwise it guarantees that the stack
> + * trace is reliable.
> + *
> + * If the task is not 'current', the caller *must* ensure the task is
> + * inactive and its stack is pinned.
> + */
>  int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry, void *cookie,
>  			     struct task_struct *task);
> +
>  void arch_stack_walk_user(stack_trace_consume_fn consume_entry, void *cookie,
>  			  const struct pt_regs *regs);
>  
> 


-- 
~Randy

