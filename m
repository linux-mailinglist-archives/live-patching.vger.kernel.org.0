Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D79142B271
	for <lists+live-patching@lfdr.de>; Wed, 13 Oct 2021 03:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235881AbhJMBzL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 12 Oct 2021 21:55:11 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:55501 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231543AbhJMBzK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 12 Oct 2021 21:55:10 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=31;SR=0;TI=SMTPD_---0UrdeUV._1634089981;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UrdeUV._1634089981)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Oct 2021 09:53:02 +0800
Subject: Re: [PATCH 1/2] ftrace: disable preemption on the testing of
 recursion
To:     Steven Rostedt <rostedt@goodmis.org>,
        Miroslav Benes <mbenes@suse.cz>
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
 <20211012082920.1f8d6557@gandalf.local.home>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <6ca59cdd-e378-b8c6-7ac6-472568f1af97@linux.alibaba.com>
Date:   Wed, 13 Oct 2021 09:52:16 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211012082920.1f8d6557@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2021/10/12 下午8:29, Steven Rostedt wrote:
> On Tue, 12 Oct 2021 14:24:43 +0200 (CEST)
> Miroslav Benes <mbenes@suse.cz> wrote:
> 
>>> +++ b/kernel/livepatch/patch.c
>>> @@ -52,11 +52,6 @@ static void notrace klp_ftrace_handler(unsigned long ip,
>>>  	bit = ftrace_test_recursion_trylock(ip, parent_ip);
>>>  	if (WARN_ON_ONCE(bit < 0))
>>>  		return;
>>> -	/*
>>> -	 * A variant of synchronize_rcu() is used to allow patching functions
>>> -	 * where RCU is not watching, see klp_synchronize_transition().
>>> -	 */
>>> -	preempt_disable_notrace();
>>>
>>>  	func = list_first_or_null_rcu(&ops->func_stack, struct klp_func,
>>>  				      stack_node);
>>> @@ -120,7 +115,6 @@ static void notrace klp_ftrace_handler(unsigned long ip,
>>>  	klp_arch_set_pc(fregs, (unsigned long)func->new_func);
>>>
>>>  unlock:
>>> -	preempt_enable_notrace();
>>>  	ftrace_test_recursion_unlock(bit);
>>>  }  
>>
>> I don't like this change much. We have preempt_disable there not because 
>> of ftrace_test_recursion, but because of RCU. ftrace_test_recursion was 
>> added later. Yes, it would work with the change, but it would also hide 
>> things which should not be hidden in my opinion.
> 
> Agreed, but I believe the change is fine, but requires a nice comment to
> explain what you said above.
> 
> Thus, before the "ftrace_test_recursion_trylock()" we need:
> 
> 	/*
> 	 * The ftrace_test_recursion_trylock() will disable preemption,
> 	 * which is required for the variant of synchronize_rcu() that is
> 	 * used to allow patching functions where RCU is not watching.
> 	 * See klp_synchronize_transition() for more details.
> 	 */

Will be in v2 too :-)

Regards,
Michael Wang

> 
> -- Steve
> 
