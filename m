Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76CBF42D5E8
	for <lists+live-patching@lfdr.de>; Thu, 14 Oct 2021 11:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbhJNJY4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Oct 2021 05:24:56 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:39240 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229967AbhJNJYz (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Oct 2021 05:24:55 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=31;SR=0;TI=SMTPD_---0UrnMW2X_1634203363;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UrnMW2X_1634203363)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 14 Oct 2021 17:22:45 +0800
Subject: Re: [PATCH v3 1/2] ftrace: disable preemption between
 ftrace_test_recursion_trylock/unlock()
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Guo Ren <guoren@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
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
References: <609b565a-ed6e-a1da-f025-166691b5d994@linux.alibaba.com>
 <7e4738b5-21d4-c4d0-3136-a096bbb5cd2c@linux.alibaba.com>
 <alpine.LSU.2.21.2110141108150.23710@pobox.suse.cz>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <d293a0d2-9864-3f92-a333-e29d919d5a02@linux.alibaba.com>
Date:   Thu, 14 Oct 2021 17:22:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.2110141108150.23710@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2021/10/14 下午5:13, Miroslav Benes wrote:
>> diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
>> index e8029ae..b8d75fb 100644
>> --- a/kernel/livepatch/patch.c
>> +++ b/kernel/livepatch/patch.c
>> @@ -49,14 +49,16 @@ static void notrace klp_ftrace_handler(unsigned long ip,
>>
>>  	ops = container_of(fops, struct klp_ops, fops);
>>
>> +	/*
>> +	 *
> 
> This empty line is not useful.
> 
>> +	 * The ftrace_test_recursion_trylock() will disable preemption,
>> +	 * which is required for the variant of synchronize_rcu() that is
>> +	 * used to allow patching functions where RCU is not watching.
>> +	 * See klp_synchronize_transition() for more details.
>> +	 */
>>  	bit = ftrace_test_recursion_trylock(ip, parent_ip);
>>  	if (WARN_ON_ONCE(bit < 0))
>>  		return;
>> -	/*
>> -	 * A variant of synchronize_rcu() is used to allow patching functions
>> -	 * where RCU is not watching, see klp_synchronize_transition().
>> -	 */
>> -	preempt_disable_notrace();
>>
>>  	func = list_first_or_null_rcu(&ops->func_stack, struct klp_func,
>>  				      stack_node);
>> @@ -120,7 +122,6 @@ static void notrace klp_ftrace_handler(unsigned long ip,
>>  	klp_arch_set_pc(fregs, (unsigned long)func->new_func);
>>
>>  unlock:
>> -	preempt_enable_notrace();
>>  	ftrace_test_recursion_unlock(bit);
>>  }
> 
> Acked-by: Miroslav Benes <mbenes@suse.cz>
> 
> for the livepatch part of the patch.
> 
> I would also ask you not to submit new versions so often, so that the 
> other reviewers have time to actually review the patch set.
> 
> Quoting from Documentation/process/submitting-patches.rst:
> 
> "Wait for a minimum of one week before resubmitting or pinging reviewers - 
> possibly longer during busy times like merge windows."

Thanks for the Ack and suggestion, will take care from now on :-)

Regards,
Michael Wang

> 
> Thanks
> 
> Miroslav
> 
