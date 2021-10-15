Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D25D42E71F
	for <lists+live-patching@lfdr.de>; Fri, 15 Oct 2021 05:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbhJODPV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Oct 2021 23:15:21 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:34772 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229526AbhJODPV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Oct 2021 23:15:21 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=31;SR=0;TI=SMTPD_---0Us2T5JW_1634267588;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0Us2T5JW_1634267588)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 15 Oct 2021 11:13:09 +0800
Subject: Re: [PATCH v3 1/2] ftrace: disable preemption between
 ftrace_test_recursion_trylock/unlock()
To:     Petr Mladek <pmladek@suse.com>
Cc:     Guo Ren <guoren@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
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
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>, linux-csky@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        live-patching@vger.kernel.org
References: <609b565a-ed6e-a1da-f025-166691b5d994@linux.alibaba.com>
 <7e4738b5-21d4-c4d0-3136-a096bbb5cd2c@linux.alibaba.com>
 <YWhJP41cNwDphYsv@alley>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <5e907ed3-806b-b0e5-518d-d2f3b265377f@linux.alibaba.com>
Date:   Fri, 15 Oct 2021 11:13:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YWhJP41cNwDphYsv@alley>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2021/10/14 下午11:14, Petr Mladek wrote:
[snip]
>> -	return trace_test_and_set_recursion(ip, parent_ip, TRACE_FTRACE_START, TRACE_FTRACE_MAX);
>> +	int bit;
>> +
>> +	bit = trace_test_and_set_recursion(ip, parent_ip, TRACE_FTRACE_START, TRACE_FTRACE_MAX);
>> +	/*
>> +	 * The zero bit indicate we are nested
>> +	 * in another trylock(), which means the
>> +	 * preemption already disabled.
>> +	 */
>> +	if (bit > 0)
>> +		preempt_disable_notrace();
> 
> Is this safe? The preemption is disabled only when
> trace_test_and_set_recursion() was called by ftrace_test_recursion_trylock().
> 
> We must either always disable the preemtion when bit >= 0.
> Or we have to disable the preemtion already in
> trace_test_and_set_recursion().

Internal calling of trace_test_and_set_recursion() will disable preemption
on succeed, it should be safe.

We can also consider move the logical into trace_test_and_set_recursion()
and trace_clear_recursion(), but I'm not very sure about that... ftrace
internally already make sure preemption disabled, what uncovered is those
users who call API trylock/unlock, isn't it?

> 
> 
> Finally, the comment confused me a lot. The difference between nesting and
> recursion is far from clear. And the code is tricky liky like hell :-)
> I propose to add some comments, see below for a proposal.
The comments do confusing, I'll make it something like:

The zero bit indicate trace recursion happened, whatever
the recursively call was made by ftrace handler or ftrace
itself, the preemption already disabled.

Will this one looks better to you?

> 
>> +
>> +	return bit;
>>  }
>>  /**
>> @@ -222,9 +233,13 @@ static __always_inline int ftrace_test_recursion_trylock(unsigned long ip,
>>   * @bit: The return of a successful ftrace_test_recursion_trylock()
>>   *
>>   * This is used at the end of a ftrace callback.
>> + *
>> + * Preemption will be enabled (if it was previously enabled).
>>   */
>>  static __always_inline void ftrace_test_recursion_unlock(int bit)
>>  {
>> +	if (bit)
> 
> This is not symetric with trylock(). It should be:
> 
> 	if (bit > 0)
> 
> Anyway, trace_clear_recursion() quiently ignores bit != 0

Yes, bit == 0 should not happen in here.

> 
> 
>> +		preempt_enable_notrace();
>>  	trace_clear_recursion(bit);
>>  }
> 
> 
> Below is my proposed patch that tries to better explain the recursion
> check:
> 
> From 20d69f11e2683262fa0043b803999061cbac543f Mon Sep 17 00:00:00 2001
> From: Petr Mladek <pmladek@suse.com>
> Date: Thu, 14 Oct 2021 16:57:39 +0200
> Subject: [PATCH] trace: Better describe the recursion check return values
> 
> The trace recursion check might be called recursively by different
> layers of the tracing code. It is safe recursion and the check
> is even optimized for this case.
> 
> The problematic recursion is when the traced function is called
> by the tracing code. This is properly detected.
> 
> Try to explain this difference a better way.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> ---
>  include/linux/trace_recursion.h | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/trace_recursion.h b/include/linux/trace_recursion.h
> index a9f9c5714e65..b5efb804efdf 100644
> --- a/include/linux/trace_recursion.h
> +++ b/include/linux/trace_recursion.h
> @@ -159,13 +159,27 @@ extern void ftrace_record_recursion(unsigned long ip, unsigned long parent_ip);
>  # define do_ftrace_record_recursion(ip, pip)	do { } while (0)
>  #endif
>  
> +/*
> + * trace_test_and_set_recursion() is called on several layers
> + * of the ftrace code when handling the same ftrace entry.
> + * These calls might be nested/recursive.
> + *
> + * It uses TRACE_LIST_*BITs to distinguish between this
> + * internal recursion and recursion caused by calling
> + * the traced function by the ftrace code.
> + *
> + * Returns: > 0 when no recursion
> + *          0 when called recursively internally (safe)

The 0 can also happened when ftrace handler recursively called trylock()
under the same context, or not?

Regards,
Michael Wang

> + *	    -1 when the traced function was called recursively from
> + *             the ftrace handler (unsafe)
> + */
>  static __always_inline int trace_test_and_set_recursion(unsigned long ip, unsigned long pip,
>  							int start, int max)
>  {
>  	unsigned int val = READ_ONCE(current->trace_recursion);
>  	int bit;
>  
> -	/* A previous recursion check was made */
> +	/* Called recursively internally by different ftrace code layers? */
>  	if ((val & TRACE_CONTEXT_MASK) > max)
>  		return 0;

>  
> 
