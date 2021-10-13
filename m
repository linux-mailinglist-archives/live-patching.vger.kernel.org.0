Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5E042B27F
	for <lists+live-patching@lfdr.de>; Wed, 13 Oct 2021 04:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhJMCHC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 12 Oct 2021 22:07:02 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:59482 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230398AbhJMCHC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 12 Oct 2021 22:07:02 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=31;SR=0;TI=SMTPD_---0UrdlKN._1634090692;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UrdlKN._1634090692)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Oct 2021 10:04:54 +0800
Subject: Re: [PATCH 1/2] ftrace: disable preemption on the testing of
 recursion
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Guo Ren <guoren@kernel.org>, Ingo Molnar <mingo@redhat.com>,
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
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>, linux-csky@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        live-patching@vger.kernel.org
References: <8c7de46d-9869-aa5e-2bb9-5dbc2eda395e@linux.alibaba.com>
 <a8756482-024c-c858-b3d1-1ffa9a5eb3f7@linux.alibaba.com>
 <20211012084331.06b8dd23@gandalf.local.home>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <1eab20c1-d69b-f94b-92ff-4329d0aff6a2@linux.alibaba.com>
Date:   Wed, 13 Oct 2021 10:04:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211012084331.06b8dd23@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2021/10/12 下午8:43, Steven Rostedt wrote:
> On Tue, 12 Oct 2021 13:40:08 +0800
> 王贇 <yun.wang@linux.alibaba.com> wrote:
> 
>> --- a/include/linux/trace_recursion.h
>> +++ b/include/linux/trace_recursion.h
>> @@ -214,7 +214,14 @@ static __always_inline void trace_clear_recursion(int bit)
>>  static __always_inline int ftrace_test_recursion_trylock(unsigned long ip,
>>  							 unsigned long parent_ip)
>>  {
>> -	return trace_test_and_set_recursion(ip, parent_ip, TRACE_FTRACE_START, TRACE_FTRACE_MAX);
>> +	int bit;
>> +
>> +	preempt_disable_notrace();
> 
> The recursion test does not require preemption disabled, it uses the task
> struct, not per_cpu variables, so you should not disable it before the test.
> 
> 	bit = trace_test_and_set_recursion(ip, parent_ip, TRACE_FTRACE_START, TRACE_FTRACE_MAX);
> 	if (bit >= 0)
> 		preempt_disable_notrace();
> 
> And if the bit is zero, it means a recursion check was already done by
> another caller (ftrace handler does the check, followed by calling perf),
> and you really don't even need to disable preemption in that case.
> 
> 	if (bit > 0)
> 		preempt_disable_notrace();
> 
> And on the unlock, have:
> 
>  static __always_inline void ftrace_test_recursion_unlock(int bit)
>  {
> 	if (bit)
> 		preempt_enable_notrace();
>  	trace_clear_recursion(bit);
>  }
> 
> But maybe that's over optimizing ;-)

I see, while the user can still check smp_processor_id() after trylock
return bit 0...

I guess Peter's point at very beginning is to prevent such cases, since
kernel for production will not have preemption debug on, and such issue
won't get report but could cause trouble which really hard to trace down
, way to eliminate such issue once for all sounds attractive, isn't it?

Regards,
Michael Wang

> 
> -- Steve
> 
> 
>> +	bit = trace_test_and_set_recursion(ip, parent_ip, TRACE_FTRACE_START, TRACE_FTRACE_MAX);
>> +	if (bit < 0)
>> +		preempt_enable_notrace();
>> +
>> +	return bit;
>>  }
