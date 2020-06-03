Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178DC1ED1A9
	for <lists+live-patching@lfdr.de>; Wed,  3 Jun 2020 16:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbgFCOGY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 3 Jun 2020 10:06:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33584 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725833AbgFCOGY (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 3 Jun 2020 10:06:24 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id ADD0EDE030222471F283;
        Wed,  3 Jun 2020 22:06:19 +0800 (CST)
Received: from [127.0.0.1] (10.166.213.10) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Wed, 3 Jun 2020
 22:06:09 +0800
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
From:   "Wangshaobo (bobo)" <bobo.shaobowang@huawei.com>
Message-ID: <1353648b-f3f7-5b8d-f0bb-28bdb1a66f0f@huawei.com>
Date:   Wed, 3 Jun 2020 22:06:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20200602131450.oydrydelpdaval4h@treble>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.166.213.10]
X-CFilter-Loop: Reflected
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


在 2020/6/2 21:14, Josh Poimboeuf 写道:
> On Tue, Jun 02, 2020 at 09:22:30AM +0800, Wangshaobo (bobo) wrote:
>> so i think this question is related to ORC unwinder, could i ask if you have
>> strategy or plan to avoid this problem ?
> I suspect something like this would fix it (untested):
>
> diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
> index 6ad43fc44556..8cf95ded1410 100644
> --- a/arch/x86/kernel/stacktrace.c
> +++ b/arch/x86/kernel/stacktrace.c
> @@ -50,7 +50,7 @@ int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
>   		if (regs) {
>   			/* Success path for user tasks */
>   			if (user_mode(regs))
> -				return 0;
> +				break;
>   
>   			/*
>   			 * Kernel mode registers on the stack indicate an
> @@ -81,10 +81,6 @@ int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
>   	if (unwind_error(&state))
>   		return -EINVAL;
>   
> -	/* Success path for non-user tasks, i.e. kthreads and idle tasks */
> -	if (!(task->flags & (PF_KTHREAD | PF_IDLE)))
> -		return -EINVAL;
> -
>   	return 0;
>   }
>   
> diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
> index 7f969b2d240f..d7396431261a 100644
> --- a/arch/x86/kernel/unwind_orc.c
> +++ b/arch/x86/kernel/unwind_orc.c
> @@ -540,7 +540,7 @@ bool unwind_next_frame(struct unwind_state *state)
>   		state->sp = sp;
>   		state->regs = NULL;
>   		state->prev_regs = NULL;
> -		state->signal = false;
> +		state->signal = ((void *)state->ip == ret_from_fork);
>   		break;
>   
>   	case ORC_TYPE_REGS:

what a awesome job, thanks a lot, Josh

Today I test your fix, but arch_stack_walk_reliable() still return 
failed sometimes, I

found one of three scenarios mentioned failed:


1. user task (just fork) but not been scheduled

     test FAILED

     it is because unwind_next_frame() get the first frame, this time 
state->signal is false, and then return

     failed in the same place for ret_from_fork has not executed at all.


2. user task (just fork) start excuting ret_from_fork() till 
schedule_tail but not UNWIND_HINT_REGS

     test condition :loop fork() in current  system

     result : SUCCESS,

     it looks like this modification works for my perspective :

	-	/* Success path for non-user tasks, i.e. kthreads and idle tasks */
	-	if (!(task->flags & (PF_KTHREAD | PF_IDLE)))
	-		return -EINVAL;
   but is this possible to miss one invalid judgement condition ? (1)

3. call_usermodehelper_exec_async

     test condition :loop call call_usermodehelper() in a module selfmade.

     result : SUCCESS,

    it looks state->signal==true works when unwind_next_frame() gets the 
end ret_from_fork() frame,

    but i don't know how does it work, i am confused by this sentences, 
how does the comment means sibling calls and

     calls to noreturn functions? (2)

             /*
              * Find the orc_entry associated with the text address.
              *
              * Decrement call return addresses by one so they work for 
sibling
              * calls and calls to noreturn functions.
              */
             orc = orc_find(state->signal ? state->ip : state->ip - 1);
             if (!orc) {


So i slightly modify your code, i move  state->signal = ((void 
*)state->ip == ret_from_fork) to unwind_start()

and render unwind_next_frame() remain the same as before:

diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index e9cc182aa97e..ecce5051e8fd 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -620,6 +620,7 @@ void __unwind_start(struct unwind_state *state, 
struct task_struct *task,
                 state->sp = task->thread.sp;
                 state->bp = READ_ONCE_NOCHECK(frame->bp);
                 state->ip = READ_ONCE_NOCHECK(frame->ret_addr);
+              state->signal = ((void *)state->ip == ret_from_fork);
         }

diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 7f969b2d240f..d7396431261a 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -540,7 +540,7 @@ bool unwind_next_frame(struct unwind_state *state)
  		state->sp = sp;
  		state->regs = NULL;
  		state->prev_regs = NULL;
-		state->signal = ((void *)state->ip == ret_from_fork);
+		state->signal = false;
  		break;


After modification all the three scenarios are captured and no longer 
return failed,  but i don't know

how does it affect the scenarios 3, because current frame->ret_addr(the 
first frame) is not ret_from_fork,

it should return failed as scenarios1, but it didn't , i really want to 
know the reason. (3)


thanks again

Wang ShaoBo


