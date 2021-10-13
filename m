Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4417142B9B8
	for <lists+live-patching@lfdr.de>; Wed, 13 Oct 2021 09:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbhJMH5Y (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 13 Oct 2021 03:57:24 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:54944 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbhJMH5X (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 13 Oct 2021 03:57:23 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 99BD022296;
        Wed, 13 Oct 2021 07:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1634111719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i7IGip/6gbVvmHRaMhrhBlPAbqtmi4yf9VEPWWlaFeE=;
        b=Ej27NFvhi/+3F1LnXiuEvJ3SmzHirAxauJBsGjgulCIyOssPQw6F6KwTNa9IaM5Au65bVy
        pwr2XAZtxLt0rxZlJr0A7utwkQQTqhil/0XYYwHKx8ILmEECDzgVsKv24qdJ71W4uV3deH
        oxQvor4tfFIz/5mrWPBwtKjE3PhLc20=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1634111719;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i7IGip/6gbVvmHRaMhrhBlPAbqtmi4yf9VEPWWlaFeE=;
        b=+w9Az0Z3KJ2VxO6gzBE7ap3QeAyDlZfweavR7c1nDpq45ogh1GvakBs8gocNDgbltKk/J+
        vJikc3lgCt4lGSCQ==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 5FC20A3B88;
        Wed, 13 Oct 2021 07:55:18 +0000 (UTC)
Date:   Wed, 13 Oct 2021 09:55:18 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     =?ISO-2022-JP?Q?=1B$B2&lV=1B=28J?= <yun.wang@linux.alibaba.com>
cc:     Guo Ren <guoren@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>, linux-csky@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        live-patching@vger.kernel.org
Subject: Re: [RESEND PATCH v2 1/2] ftrace: disable preemption between
 ftrace_test_recursion_trylock/unlock()
In-Reply-To: <75ee86ac-02f2-d687-ab1e-9c8c33032495@linux.alibaba.com>
Message-ID: <alpine.LSU.2.21.2110130948120.5647@pobox.suse.cz>
References: <b1d7fe43-ce84-0ed7-32f7-ea1d12d0b716@linux.alibaba.com> <75ee86ac-02f2-d687-ab1e-9c8c33032495@linux.alibaba.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> diff --git a/include/linux/trace_recursion.h b/include/linux/trace_recursion.h
> index a9f9c57..101e1fb 100644
> --- a/include/linux/trace_recursion.h
> +++ b/include/linux/trace_recursion.h
> @@ -208,13 +208,29 @@ static __always_inline void trace_clear_recursion(int bit)
>   * Use this for ftrace callbacks. This will detect if the function
>   * tracing recursed in the same context (normal vs interrupt),
>   *
> + * The ftrace_test_recursion_trylock() will disable preemption,
> + * which is required for the variant of synchronize_rcu() that is
> + * used to allow patching functions where RCU is not watching.
> + * See klp_synchronize_transition() for more details.
> + *

I think that you misunderstood. Steven proposed to put the comment before 
ftrace_test_recursion_trylock() call site in klp_ftrace_handler().

>   * Returns: -1 if a recursion happened.
>   *           >= 0 if no recursion
>   */
>  static __always_inline int ftrace_test_recursion_trylock(unsigned long ip,
>  							 unsigned long parent_ip)
>  {
> -	return trace_test_and_set_recursion(ip, parent_ip, TRACE_FTRACE_START, TRACE_FTRACE_MAX);
> +	int bit;
> +
> +	bit = trace_test_and_set_recursion(ip, parent_ip, TRACE_FTRACE_START, TRACE_FTRACE_MAX);
> +	/*
> +	 * The zero bit indicate we are nested
> +	 * in another trylock(), which means the
> +	 * preemption already disabled.
> +	 */
> +	if (bit > 0)
> +		preempt_disable_notrace();
> +
> +	return bit;
>  }

[...]

> diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
> index e8029ae..6e66ccd 100644
> --- a/kernel/livepatch/patch.c
> +++ b/kernel/livepatch/patch.c
> @@ -52,11 +52,6 @@ static void notrace klp_ftrace_handler(unsigned long ip,

Here

>  	bit = ftrace_test_recursion_trylock(ip, parent_ip);
>  	if (WARN_ON_ONCE(bit < 0))
>  		return;
> -	/*
> -	 * A variant of synchronize_rcu() is used to allow patching functions
> -	 * where RCU is not watching, see klp_synchronize_transition().
> -	 */
> -	preempt_disable_notrace();
> 
>  	func = list_first_or_null_rcu(&ops->func_stack, struct klp_func,
>  				      stack_node);
> @@ -120,7 +115,6 @@ static void notrace klp_ftrace_handler(unsigned long ip,
>  	klp_arch_set_pc(fregs, (unsigned long)func->new_func);
> 
>  unlock:
> -	preempt_enable_notrace();
>  	ftrace_test_recursion_unlock(bit);
>  }

Side note... the comment will eventually conflict with peterz's 
https://lore.kernel.org/all/20210929152429.125997206@infradead.org/.

Miroslav
