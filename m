Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7365C43AF71
	for <lists+live-patching@lfdr.de>; Tue, 26 Oct 2021 11:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbhJZJum (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 26 Oct 2021 05:50:42 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:46166 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234310AbhJZJul (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 26 Oct 2021 05:50:41 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=30;SR=0;TI=SMTPD_---0Utm5zog_1635241690;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0Utm5zog_1635241690)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 26 Oct 2021 17:48:12 +0800
Subject: Re: [PATCH v5 1/2] ftrace: disable preemption when recursion locked
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
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>, linux-csky@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        live-patching@vger.kernel.org
References: <3ca92dc9-ea04-ddc2-71cd-524bfa5a5721@linux.alibaba.com>
 <333cecfe-3045-8e0a-0c08-64ff590845ab@linux.alibaba.com>
 <alpine.LSU.2.21.2110261128120.28494@pobox.suse.cz>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <18ba2a71-e12d-33f7-63fe-2857b2db022c@linux.alibaba.com>
Date:   Tue, 26 Oct 2021 17:48:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.2110261128120.28494@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi, Miroslav

On 2021/10/26 下午5:35, Miroslav Benes wrote:
> Hi,
> 
>> diff --git a/include/linux/trace_recursion.h b/include/linux/trace_recursion.h
>> index abe1a50..2bc1522 100644
>> --- a/include/linux/trace_recursion.h
>> +++ b/include/linux/trace_recursion.h
>> @@ -135,6 +135,9 @@ static __always_inline int trace_get_context_bit(void)
>>  # define do_ftrace_record_recursion(ip, pip)	do { } while (0)
>>  #endif
>>
>> +/*
>> + * Preemption is promised to be disabled when return bit > 0.
>> + */
>>  static __always_inline int trace_test_and_set_recursion(unsigned long ip, unsigned long pip,
>>  							int start)
>>  {
>> @@ -162,11 +165,17 @@ static __always_inline int trace_test_and_set_recursion(unsigned long ip, unsign
>>  	current->trace_recursion = val;
>>  	barrier();
>>
>> +	preempt_disable_notrace();
>> +
>>  	return bit;
>>  }
>>
>> +/*
>> + * Preemption will be enabled (if it was previously enabled).
>> + */
>>  static __always_inline void trace_clear_recursion(int bit)
>>  {
>> +	preempt_enable_notrace();
>>  	barrier();
>>  	trace_recursion_clear(bit);
>>  }
> 
> The two comments should be updated too since Steven removed the "bit == 0" 
> trick.

Could you please give more hint on how will it be correct?

I get the point that bit will no longer be 0, there are only -1 or > 0 now
so trace_test_and_set_recursion() will disable preemption on bit > 0 and
trace_clear_recursion() will enabled it since it should only be called when
bit > 0 (I remember we could use a WARN_ON here now :-P).

> 
>> @@ -178,7 +187,7 @@ static __always_inline void trace_clear_recursion(int bit)
>>   * tracing recursed in the same context (normal vs interrupt),
>>   *
>>   * Returns: -1 if a recursion happened.
>> - *           >= 0 if no recursion
>> + *           > 0 if no recursion.
>>   */
>>  static __always_inline int ftrace_test_recursion_trylock(unsigned long ip,
>>  							 unsigned long parent_ip)
> 
> And this change would not be correct now.

I thought it will no longer return 0 so I change it to > 0, isn't that correct?

Regards,
Michael Wang

> 
> Regards
> Miroslav
> 
