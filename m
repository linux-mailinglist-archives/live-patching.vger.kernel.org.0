Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6892842B25B
	for <lists+live-patching@lfdr.de>; Wed, 13 Oct 2021 03:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbhJMBsm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 12 Oct 2021 21:48:42 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:36741 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230402AbhJMBsk (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 12 Oct 2021 21:48:40 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=31;SR=0;TI=SMTPD_---0UrdGZLQ_1634089590;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UrdGZLQ_1634089590)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Oct 2021 09:46:32 +0800
Subject: Re: [PATCH 2/2] ftrace: prevent preemption in
 perf_ftrace_function_call()
To:     Peter Zijlstra <peterz@infradead.org>
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
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>, linux-csky@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        live-patching@vger.kernel.org
References: <8c7de46d-9869-aa5e-2bb9-5dbc2eda395e@linux.alibaba.com>
 <7ec34e08-a357-58d6-2ce4-c7472d8b0381@linux.alibaba.com>
 <YWVvfBybqjKuifum@hirez.programming.kicks-ass.net>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <1193d016-ec4d-2b29-4d33-5a04ca85c14d@linux.alibaba.com>
Date:   Wed, 13 Oct 2021 09:45:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YWVvfBybqjKuifum@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2021/10/12 下午7:20, Peter Zijlstra wrote:
> On Tue, Oct 12, 2021 at 01:40:31PM +0800, 王贇 wrote:
> 
>> diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
>> index 6aed10e..33c2f76 100644
>> --- a/kernel/trace/trace_event_perf.c
>> +++ b/kernel/trace/trace_event_perf.c
>> @@ -441,12 +441,19 @@ void perf_trace_buf_update(void *record, u16 type)
>>  	if (!rcu_is_watching())
>>  		return;
>>
>> +	/*
>> +	 * Prevent CPU changing from now on. rcu must
>> +	 * be in watching if the task was migrated and
>> +	 * scheduled.
>> +	 */
>> +	preempt_disable_notrace();
>> +
>>  	if ((unsigned long)ops->private != smp_processor_id())
>> -		return;
>> +		goto out;
>>
>>  	bit = ftrace_test_recursion_trylock(ip, parent_ip);
>>  	if (bit < 0)
>> -		return;
>> +		goto out;
>>
>>  	event = container_of(ops, struct perf_event, ftrace_ops);
>>
> 
> This seems rather daft, wouldn't it be easier to just put that check
> under the recursion thing?

In case if the condition matched, extra lock/unlock will be introduced,
but I guess that's acceptable since this seems unlikely to happen :-P

Will move the check in v2.

Regards,
Michael Wang

> 
