Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4941E1EEF02
	for <lists+live-patching@lfdr.de>; Fri,  5 Jun 2020 03:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgFEB05 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 4 Jun 2020 21:26:57 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5854 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725863AbgFEB05 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 4 Jun 2020 21:26:57 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E8A6B1303D2CBD83AA15;
        Fri,  5 Jun 2020 09:26:54 +0800 (CST)
Received: from [127.0.0.1] (10.166.213.10) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Fri, 5 Jun 2020
 09:26:44 +0800
Subject: Re: Question: livepatch failed for new fork() task stack unreliable
To:     Josh Poimboeuf <jpoimboe@redhat.com>
CC:     <huawei.libin@huawei.com>, <xiexiuqi@huawei.com>,
        <cj.chengjian@huawei.com>, <mingo@redhat.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <live-patching@vger.kernel.org>,
        <mbenes@suse.cz>, <devel@etsukata.com>, <viro@zeniv.linux.org.uk>,
        <esyr@redhat.com>
References: <20200529101059.39885-1-bobo.shaobowang@huawei.com>
 <20200529174433.wpkknhypx2bmjika@treble>
 <a9ed9157-f3cf-7d2c-7a8e-56150a2a114e@huawei.com>
 <20200601180538.o5agg5trbdssqken@treble>
 <a5e0f476-02b5-cc44-8d4e-d33ff2138143@huawei.com>
 <20200602131450.oydrydelpdaval4h@treble>
 <1353648b-f3f7-5b8d-f0bb-28bdb1a66f0f@huawei.com>
 <20200603153358.2ezz2pgxxxld7mj7@treble>
 <2225bc83-95f2-bf3d-7651-fdd10a3ddd00@huawei.com>
 <20200604024051.6ovbr6tbrowwg6jr@treble>
From:   "Wangshaobo (bobo)" <bobo.shaobowang@huawei.com>
Message-ID: <c3a81224-bea1-116b-7528-f03f90be5264@huawei.com>
Date:   Fri, 5 Jun 2020 09:26:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20200604024051.6ovbr6tbrowwg6jr@treble>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.166.213.10]
X-CFilter-Loop: Reflected
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


在 2020/6/4 10:40, Josh Poimboeuf 写道:
> On Thu, Jun 04, 2020 at 09:24:55AM +0800, Wangshaobo (bobo) wrote:
>> 在 2020/6/3 23:33, Josh Poimboeuf 写道:
>>> On Wed, Jun 03, 2020 at 10:06:07PM +0800, Wangshaobo (bobo) wrote:
>>> To be honest, I don't remember what I meant by sibling calls.  They
>>> don't even leave anything on the stack.
>>>
>>> For noreturns, the code might be laid out like this:
>>>
>>> func1:
>>> 	...
>>> 	call noreturn_foo
>>> func2:
>>>
>>> func2 is immediately after the call to noreturn_foo.  So the return
>>> address on the stack will actually be 'func2'.  We want to retrieve the
>>> ORC data for the call instruction (inside func1), instead of the
>>> instruction at the beginning of func2.
>>>
>>> I should probably update that comment.
>> So, I want to ask is there any side effects if i modify like this ? this
>> modification is based on
>>
>> your fix. It looks like ok with proper test.
>>
>> diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
>> index e9cc182aa97e..ecce5051e8fd 100644
>> --- a/arch/x86/kernel/unwind_orc.c
>> +++ b/arch/x86/kernel/unwind_orc.c
>> @@ -620,6 +620,7 @@ void __unwind_start(struct unwind_state *state, struct
>> task_struct *task,
>>                  state->sp = task->thread.sp;
>>                  state->bp = READ_ONCE_NOCHECK(frame->bp);
>>                  state->ip = READ_ONCE_NOCHECK(frame->ret_addr);
>> +              state->signal = ((void *)state->ip == ret_from_fork);
>>          }
>>
>> diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
>> index 7f969b2d240f..d7396431261a 100644
>> --- a/arch/x86/kernel/unwind_orc.c
>> +++ b/arch/x86/kernel/unwind_orc.c
>> @@ -540,7 +540,7 @@ bool unwind_next_frame(struct unwind_state *state)
>>           state->sp = sp;
>>           state->regs = NULL;
>>           state->prev_regs = NULL;
>> -        state->signal = ((void *)state->ip == ret_from_fork);
>> +        state->signal = false;
>>           break;
> Yes that's correct.

Hi, josh

Could i ask when are you free to send the patch, all the tests are 
passed by.

thanks for your help.

Wang ShaoBo

>

