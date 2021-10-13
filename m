Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E253A42B2BD
	for <lists+live-patching@lfdr.de>; Wed, 13 Oct 2021 04:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236762AbhJMCig (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 12 Oct 2021 22:38:36 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:48027 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235912AbhJMCig (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 12 Oct 2021 22:38:36 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=31;SR=0;TI=SMTPD_---0Urdkedq_1634092576;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0Urdkedq_1634092576)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Oct 2021 10:36:18 +0800
Subject: Re: [PATCH 1/2] ftrace: disable preemption on the testing of
 recursion
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
 <alpine.LSU.2.21.2110121421260.3394@pobox.suse.cz>
 <74090798-7d93-0713-982c-6f0247118d20@linux.alibaba.com>
 <20211012222758.1a029157@oasis.local.home>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <4b4be164-0095-90bc-a193-faa7100558d2@linux.alibaba.com>
Date:   Wed, 13 Oct 2021 10:36:16 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211012222758.1a029157@oasis.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2021/10/13 上午10:27, Steven Rostedt wrote:
> On Wed, 13 Oct 2021 09:50:17 +0800
> 王贇 <yun.wang@linux.alibaba.com> wrote:
> 
>>>> -	preempt_enable_notrace();
>>>>  	ftrace_test_recursion_unlock(bit);
>>>>  }  
>>>
>>> I don't like this change much. We have preempt_disable there not because 
>>> of ftrace_test_recursion, but because of RCU. ftrace_test_recursion was 
>>> added later. Yes, it would work with the change, but it would also hide 
>>> things which should not be hidden in my opinion.  
>>
>> Not very sure about the backgroup stories, but just found this in
>> 'Documentation/trace/ftrace-uses.rst':
>>
>>   Note, on success,
>>   ftrace_test_recursion_trylock() will disable preemption, and the
>>   ftrace_test_recursion_unlock() will enable it again (if it was previously
>>   enabled).
> 
> Right that part is to be fixed by what you are adding here.
> 
> The point that Miroslav is complaining about is that the preemption
> disabling is special in this case, and not just from the recursion
> point of view, which is why the comment is still required.

My bad... the title do confusing people, will rewrite it.

Regards,
Michael Wang

> 
> -- Steve
> 
> 
>>
>> Seems like this lock pair was supposed to take care the preemtion itself?
