Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3302743BF3A
	for <lists+live-patching@lfdr.de>; Wed, 27 Oct 2021 03:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237692AbhJ0B5y (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 26 Oct 2021 21:57:54 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:31072 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236313AbhJ0B5x (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 26 Oct 2021 21:57:53 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=30;SR=0;TI=SMTPD_---0UtpFhNO_1635299711;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UtpFhNO_1635299711)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Oct 2021 09:55:13 +0800
Subject: Re: [PATCH v5 1/2] ftrace: disable preemption when recursion locked
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Miroslav Benes <mbenes@suse.cz>, Guo Ren <guoren@kernel.org>,
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
 <18ba2a71-e12d-33f7-63fe-2857b2db022c@linux.alibaba.com>
 <20211026080117.366137a5@gandalf.local.home>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <3d897161-7b74-944a-f2a0-07311436fbd9@linux.alibaba.com>
Date:   Wed, 27 Oct 2021 09:54:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211026080117.366137a5@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2021/10/26 下午8:01, Steven Rostedt wrote:
> On Tue, 26 Oct 2021 17:48:10 +0800
> 王贇 <yun.wang@linux.alibaba.com> wrote:
> 
>>> The two comments should be updated too since Steven removed the "bit == 0" 
>>> trick.  
>>
>> Could you please give more hint on how will it be correct?
>>
>> I get the point that bit will no longer be 0, there are only -1 or > 0 now
>> so trace_test_and_set_recursion() will disable preemption on bit > 0 and
>> trace_clear_recursion() will enabled it since it should only be called when
>> bit > 0 (I remember we could use a WARN_ON here now :-P).
>>
>>>   
>>>> @@ -178,7 +187,7 @@ static __always_inline void trace_clear_recursion(int bit)
>>>>   * tracing recursed in the same context (normal vs interrupt),
>>>>   *
>>>>   * Returns: -1 if a recursion happened.
>>>> - *           >= 0 if no recursion
>>>> + *           > 0 if no recursion.
>>>>   */
>>>>  static __always_inline int ftrace_test_recursion_trylock(unsigned long ip,
>>>>  							 unsigned long parent_ip)  
>>>
>>> And this change would not be correct now.  
>>
>> I thought it will no longer return 0 so I change it to > 0, isn't that correct?
> 
> No it is not. I removed the bit + 1 return value, which means it returns the
> actual bit now. Which is 0 or more.

Ah, the return is bit not val, I must be drunk...

My apologize for the stupid comments... I'll send a v6 for this patch
only to fix that, please let me know if this is not a good way to fix
few lines of comments.

Regards,
Michael Wang

> 
> -- Steve
> 
