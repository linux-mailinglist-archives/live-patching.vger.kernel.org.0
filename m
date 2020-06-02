Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7527A1EB2EE
	for <lists+live-patching@lfdr.de>; Tue,  2 Jun 2020 03:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgFBBWn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 1 Jun 2020 21:22:43 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5325 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725832AbgFBBWm (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 1 Jun 2020 21:22:42 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4E8A139E2513CCB8B04F;
        Tue,  2 Jun 2020 09:22:40 +0800 (CST)
Received: from [127.0.0.1] (10.166.213.10) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Tue, 2 Jun 2020
 09:22:33 +0800
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
From:   "Wangshaobo (bobo)" <bobo.shaobowang@huawei.com>
Message-ID: <a5e0f476-02b5-cc44-8d4e-d33ff2138143@huawei.com>
Date:   Tue, 2 Jun 2020 09:22:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20200601180538.o5agg5trbdssqken@treble>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.166.213.10]
X-CFilter-Loop: Reflected
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


在 2020/6/2 2:05, Josh Poimboeuf 写道:
> On Sat, May 30, 2020 at 10:21:19AM +0800, Wangshaobo (bobo) wrote:
>> 1) when a user mode task just fork start excuting ret_from_fork() till
>> schedule_tail, unwind_next_frame found
>>
>> orc->sp_reg is ORC_REG_UNDEFINED but orc->end not equals zero, this time
>> arch_stack_walk_reliable()
>>
>> terminates it's backtracing loop for unwind_done() return true. then 'if
>> (!(task->flags & (PF_KTHREAD | PF_IDLE)))'
>>
>> in arch_stack_walk_reliable() true and return -EINVAL after.
>>
>> * The stack trace looks like that:
>>
>> ret_from_fork
>>
>>        -=> UNWIND_HINT_EMPTY
>>
>>        -=> schedule_tail             /* schedule out */
>>
>>        ...
>>
>>        -=> UNWIND_HINT_REGS      /*  UNDO */
> Yes, makes sense.
>
>> 2) when using call_usermodehelper_exec_async() to create a user mode task,
>> ret_from_fork() still not exec whereas
>>
>> the task has been scheduled in __schedule(), at this time, orc->sp_reg is
>> ORC_REG_UNDEFINED but orc->end equals zero,
>>
>> unwind_error() return true and also terminates arch_stack_walk_reliable()'s
>> backtracing loop, end up return from
>>
>> 'if (unwind_error())' branch.
>>
>> * The stack trace looks like that:
>>
>> -=> call_usermodehelper_exec
>>
>>                   -=> do_exec
>>
>>                             -=> search_binary_handler
>>
>>                                        -=> load_elf_binary
>>
>>                                                  -=> elf_map
>>
>>                                                           -=> vm_mmap_pgoff
>>
>> -=> down_write_killable
>>
>> -=> _cond_resched
>>
>>               -=> __schedule           /* scheduled to work */
>>
>> -=> ret_from_fork       /* UNDO */
> I don't quite follow the stacktrace, but it sounds like the issue is the
> same as the first one you originally reported:

yes, true, same as the first one,  the only difference what i want to 
say is the task has been scheduled but the first one is not.

>> 1) The task was not actually scheduled to excute, at this time
>> UNWIND_HINT_EMPTY in ret_from_fork() has not reset unwind_hint, it's
>> sp_reg and end field remain default value and end up throwing an error
>> in unwind_next_frame() when called by arch_stack_walk_reliable();
> Or am I misunderstanding?
>
> And to reiterate, these are not "livepatch failures", right?  Livepatch
> doesn't fail when stack_trace_save_tsk_reliable() returns an error.  It
> recovers gracefully and tries again later.

yes, you are right,  "livepatch failures" only indicates serveral retry 
failures, we found if frequent fork() happend in current

system, it is easier to cause retry but still always end up success.

so i think this question is related to ORC unwinder, could i ask if you 
have strategy or plan to avoid this problem ?

thanks,

Wang ShaoBo


