Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BACB43AA83
	for <lists+live-patching@lfdr.de>; Tue, 26 Oct 2021 04:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbhJZCzM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 25 Oct 2021 22:55:12 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:34834 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233160AbhJZCzM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 25 Oct 2021 22:55:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=31;SR=0;TI=SMTPD_---0Utj7nbU_1635216761;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0Utj7nbU_1635216761)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 26 Oct 2021 10:52:42 +0800
Subject: Re: [PATCH v4 0/2] fix & prevent the missing preemption disabling
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
References: <32a36348-69ee-6464-390c-3a8d6e9d2b53@linux.alibaba.com>
 <71c21f78-9c44-fdb2-f8e2-d8544b3421bd@linux.alibaba.com>
 <20211025224233.61b8e088@rorschach.local.home>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <de35eedf-8558-233d-ca59-7c636bbb2da3@linux.alibaba.com>
Date:   Tue, 26 Oct 2021 10:52:41 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211025224233.61b8e088@rorschach.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2021/10/26 上午10:42, Steven Rostedt wrote:
> On Tue, 26 Oct 2021 10:09:12 +0800
> 王贇 <yun.wang@linux.alibaba.com> wrote:
> 
>> Just a ping, to see if there are any more comments :-P
> 
> I guess you missed what went into mainline (and your name found a bug
> in my perl script for importing patches ;-)
> 
>   https://lore.kernel.org/all/20211019091344.65629198@gandalf.local.home/

Cool~ Missing some chinese font maybe, that's fine :-)

> 
> Which means patch 1 needs to change:
>> +	/*
>> +	 * Disable preemption to fulfill the promise.
>> +	 *
>> +	 * Don't worry about the bit 0 cases, they indicate
>> +	 * the disabling behaviour has already been done by
>> +	 * internal call previously.
>> +	 */
>> +	preempt_disable_notrace();
>> +
>>  	return bit + 1;
>>  }
>>
>> +/*
>> + * Preemption will be enabled (if it was previously enabled).
>> + */
>>  static __always_inline void trace_clear_recursion(int bit)
>>  {
>>  	if (!bit)
>>  		return;
>>
>> +	if (bit > 0)
>> +		preempt_enable_notrace();
>> +
> 
> Where this wont work anymore.
> 
> Need to preempt disable and enable always.

Yup, will rebase on the latest changes~

Regards,
Michael Wang

> 
> -- Steve
> 
> 
>>  	barrier();
>>  	bit--;
>>  	trace_recursion_clear(bit);
>> @@ -209,7 +227,7 @@ static __always_inline void trace_clear_recursion(int bit)
>>   * tracing recursed in the same context (normal vs interrupt),
>>   *
