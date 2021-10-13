Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4136742B9F3
	for <lists+live-patching@lfdr.de>; Wed, 13 Oct 2021 10:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238847AbhJMINW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 13 Oct 2021 04:13:22 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:46211 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238736AbhJMINV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 13 Oct 2021 04:13:21 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=31;SR=0;TI=SMTPD_---0UrfoBuS_1634112670;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UrfoBuS_1634112670)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Oct 2021 16:11:12 +0800
Subject: Re: [RESEND PATCH v2 1/2] ftrace: disable preemption between
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
References: <b1d7fe43-ce84-0ed7-32f7-ea1d12d0b716@linux.alibaba.com>
 <75ee86ac-02f2-d687-ab1e-9c8c33032495@linux.alibaba.com>
 <alpine.LSU.2.21.2110130948120.5647@pobox.suse.cz>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <d5fbd49a-55c5-a9f5-6600-707c8d749312@linux.alibaba.com>
Date:   Wed, 13 Oct 2021 16:11:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.2110130948120.5647@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2021/10/13 下午3:55, Miroslav Benes wrote:
>> diff --git a/include/linux/trace_recursion.h b/include/linux/trace_recursion.h
>> index a9f9c57..101e1fb 100644
>> --- a/include/linux/trace_recursion.h
>> +++ b/include/linux/trace_recursion.h
>> @@ -208,13 +208,29 @@ static __always_inline void trace_clear_recursion(int bit)
>>   * Use this for ftrace callbacks. This will detect if the function
>>   * tracing recursed in the same context (normal vs interrupt),
>>   *
>> + * The ftrace_test_recursion_trylock() will disable preemption,
>> + * which is required for the variant of synchronize_rcu() that is
>> + * used to allow patching functions where RCU is not watching.
>> + * See klp_synchronize_transition() for more details.
>> + *
> 
> I think that you misunderstood. Steven proposed to put the comment before 
> ftrace_test_recursion_trylock() call site in klp_ftrace_handler().

Oh, I see... thanks for pointing out :-)

> 
>>   * Returns: -1 if a recursion happened.
[snip]
>>  }
> 
> Side note... the comment will eventually conflict with peterz's 
> https://lore.kernel.org/all/20210929152429.125997206@infradead.org/.

Steven, would you like to share your opinion on this patch?

If klp_synchronize_transition() will be removed anyway, the comments
will be meaningless and we can just drop it :-P

Regards,
Michael Wang


> 
> Miroslav
> 
