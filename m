Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201413F668A
	for <lists+live-patching@lfdr.de>; Tue, 24 Aug 2021 19:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236428AbhHXRZQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 Aug 2021 13:25:16 -0400
Received: from linux.microsoft.com ([13.77.154.182]:36172 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240628AbhHXRWP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 Aug 2021 13:22:15 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id B0A1820B85E3;
        Tue, 24 Aug 2021 10:21:29 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B0A1820B85E3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1629825690;
        bh=RRN2ko3aY/Z+MpcLlyShhWXoe5opoMHFLg6JUtwv+Ns=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=UbQ/FNKoO25TcND4jyhL5Ejew/19xwqCUehfiEDfZVrZdzHYNeH5Km4NSq9Sw18e4
         TAxy0iXiXahA2/XXnQA+BfDxgDbjlapCFxOhsNR0Ve3vXrS28MLmOgd8Y5q5RBBWuI
         skWwTwyMyxZXvcG1g/Kisi4w0vAiLdsfJbutvKLs=
Subject: Re: [RFC PATCH v8 1/4] arm64: Make all stack walking functions use
 arch_stack_walk()
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <b45aac2843f16ca759e065ea547ab0afff8c0f01>
 <20210812190603.25326-1-madvenka@linux.microsoft.com>
 <20210812190603.25326-2-madvenka@linux.microsoft.com>
 <20210824131344.GE96738@C02TD0UTHF1T.local>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <da2bb980-09c3-5a39-73cd-ca4de4c38d51@linux.microsoft.com>
Date:   Tue, 24 Aug 2021 12:21:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210824131344.GE96738@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Thanks for the review. Responses inline...

On 8/24/21 8:13 AM, Mark Rutland wrote:
> On Thu, Aug 12, 2021 at 02:06:00PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Currently, there are multiple functions in ARM64 code that walk the
>> stack using start_backtrace() and unwind_frame(). Convert all of
>> them to use arch_stack_walk(). This makes maintenance easier.
> 
> It would be good to split this into a series of patches as Mark Brown
> suggested in v7.
> 

Will do.

>> Here is the list of functions:
>>
>> 	perf_callchain_kernel()
>> 	get_wchan()
>> 	return_address()
>> 	dump_backtrace()
>> 	profile_pc()
> 
> Note that arch_stack_walk() depends on CONFIG_STACKTRACE (which is not in
> defconfig), so we'll need to reorganise things such that it's always defined,
> or factor out the core of that function and add a wrapper such that we
> can always use it.
> 

I will include CONFIG_STACKTRACE in defconfig, if that is OK with you and
Mark Brown.

>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>> ---
>>  arch/arm64/include/asm/stacktrace.h |  3 ---
>>  arch/arm64/kernel/perf_callchain.c  |  5 +---
>>  arch/arm64/kernel/process.c         | 39 ++++++++++++++++++-----------
>>  arch/arm64/kernel/return_address.c  |  6 +----
>>  arch/arm64/kernel/stacktrace.c      | 38 +++-------------------------
>>  arch/arm64/kernel/time.c            | 22 +++++++++-------
>>  6 files changed, 43 insertions(+), 70 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
>> index 8aebc00c1718..e43dea1c6b41 100644
>> --- a/arch/arm64/include/asm/stacktrace.h
>> +++ b/arch/arm64/include/asm/stacktrace.h
>> @@ -61,9 +61,6 @@ struct stackframe {
>>  #endif
>>  };
>>  
>> -extern int unwind_frame(struct task_struct *tsk, struct stackframe *frame);
>> -extern void walk_stackframe(struct task_struct *tsk, struct stackframe *frame,
>> -			    bool (*fn)(void *, unsigned long), void *data);
>>  extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
>>  			   const char *loglvl);
>>  
>> diff --git a/arch/arm64/kernel/perf_callchain.c b/arch/arm64/kernel/perf_callchain.c
>> index 4a72c2727309..2f289013c9c9 100644
>> --- a/arch/arm64/kernel/perf_callchain.c
>> +++ b/arch/arm64/kernel/perf_callchain.c
>> @@ -147,15 +147,12 @@ static bool callchain_trace(void *data, unsigned long pc)
>>  void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
>>  			   struct pt_regs *regs)
>>  {
>> -	struct stackframe frame;
>> -
>>  	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
>>  		/* We don't support guest os callchain now */
>>  		return;
>>  	}
>>  
>> -	start_backtrace(&frame, regs->regs[29], regs->pc);
>> -	walk_stackframe(current, &frame, callchain_trace, entry);
>> +	arch_stack_walk(callchain_trace, entry, current, regs);
>>  }
> 
> We can also update callchain_trace take the return value of
> perf_callchain_store into acount, e.g.
> 
> | static bool callchain_trace(void *data, unsigned long pc) 
> | {
> | 	struct perf_callchain_entry_ctx *entry = data;
> | 	return perf_callchain_store(entry, pc) == 0;
> | }
> 

OK.

>>  
>>  unsigned long perf_instruction_pointer(struct pt_regs *regs)
>> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
>> index c8989b999250..52c12fd26407 100644
>> --- a/arch/arm64/kernel/process.c
>> +++ b/arch/arm64/kernel/process.c
>> @@ -544,11 +544,28 @@ __notrace_funcgraph struct task_struct *__switch_to(struct task_struct *prev,
>>  	return last;
>>  }
>>  
>> +struct wchan_info {
>> +	unsigned long	pc;
>> +	int		count;
>> +};
>> +
>> +static bool get_wchan_cb(void *arg, unsigned long pc)
>> +{
>> +	struct wchan_info *wchan_info = arg;
>> +
>> +	if (!in_sched_functions(pc)) {
>> +		wchan_info->pc = pc;
>> +		return false;
>> +	}
>> +	wchan_info->count--;
>> +	return !!wchan_info->count;
>> +}
> 
> This will terminate one entry earlier than the old logic since we used
> to use a post-increment (testing the prior value), and now we're
> effectively using a pre-decrement (testing the new value).
> 
> I don't think that matters all that much in practice, but it might be
> best to keep the original logic, e.g. initialize `count` to 0 and here
> do:
> 
> 	return wchan_info->count++ < 16;
> 

The reason I did it this way is that with the old logic the actual limit
implemented is 17 instead of 16. That seemed odd. But I could do it the
way you have suggested.


>> +
>>  unsigned long get_wchan(struct task_struct *p)
>>  {
>> -	struct stackframe frame;
>> -	unsigned long stack_page, ret = 0;
>> -	int count = 0;
>> +	unsigned long stack_page;
>> +	struct wchan_info wchan_info;
>> +
>>  	if (!p || p == current || task_is_running(p))
>>  		return 0;
>>  
>> @@ -556,20 +573,12 @@ unsigned long get_wchan(struct task_struct *p)
>>  	if (!stack_page)
>>  		return 0;
>>  
>> -	start_backtrace(&frame, thread_saved_fp(p), thread_saved_pc(p));
>> +	wchan_info.pc = 0;
>> +	wchan_info.count = 16;
>> +	arch_stack_walk(get_wchan_cb, &wchan_info, p, NULL);
>>  
>> -	do {
>> -		if (unwind_frame(p, &frame))
>> -			goto out;
>> -		if (!in_sched_functions(frame.pc)) {
>> -			ret = frame.pc;
>> -			goto out;
>> -		}
>> -	} while (count++ < 16);
>> -
>> -out:
>>  	put_task_stack(p);
>> -	return ret;
>> +	return wchan_info.pc;
>>  }
> 
> Other than the comment above, this looks good to me.
> 

OK.

>>  unsigned long arch_align_stack(unsigned long sp)
>> diff --git a/arch/arm64/kernel/return_address.c b/arch/arm64/kernel/return_address.c
>> index a6d18755652f..92a0f4d434e4 100644
>> --- a/arch/arm64/kernel/return_address.c
>> +++ b/arch/arm64/kernel/return_address.c
>> @@ -35,15 +35,11 @@ NOKPROBE_SYMBOL(save_return_addr);
>>  void *return_address(unsigned int level)
>>  {
>>  	struct return_address_data data;
>> -	struct stackframe frame;
>>  
>>  	data.level = level + 2;
>>  	data.addr = NULL;
>>  
>> -	start_backtrace(&frame,
>> -			(unsigned long)__builtin_frame_address(0),
>> -			(unsigned long)return_address);
>> -	walk_stackframe(current, &frame, save_return_addr, &data);
>> +	arch_stack_walk(save_return_addr, &data, current, NULL);
>>  
>>  	if (!data.level)
>>  		return data.addr;
> 
> Nor that arch_stack_walk() will start with it's caller, so
> return_address() will be included in the trace where it wasn't
> previously, which implies we need to skip an additional level.
> 

You are correct. I will fix this. Thanks for catching this.

> That said, I'm not entirely sure why we need to skip 2 levels today; it
> might be worth checking that's correct.
> 

AFAICT, return_address() acts like builtin_return_address(). That is, it
returns the address of the caller. If func() calls return_address(),
func() wants its caller's address. So, return_address() and func() need to
be skipped.

I will change it to skip 3 levels instead of 2.


> We should also mark return_address() as noinline to avoid surprises with
> LTO.
> 

Will do.

>> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
>> index 8982a2b78acf..1800310f92be 100644
>> --- a/arch/arm64/kernel/stacktrace.c
>> +++ b/arch/arm64/kernel/stacktrace.c
>> @@ -151,23 +151,21 @@ void notrace walk_stackframe(struct task_struct *tsk, struct stackframe *frame,
>>  }
>>  NOKPROBE_SYMBOL(walk_stackframe);
>>  
>> -static void dump_backtrace_entry(unsigned long where, const char *loglvl)
>> +static bool dump_backtrace_entry(void *arg, unsigned long where)
>>  {
>> +	char *loglvl = arg;
>>  	printk("%s %pSb\n", loglvl, (void *)where);
>> +	return true;
>>  }
>>  
>>  void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
>>  		    const char *loglvl)
>>  {
>> -	struct stackframe frame;
>> -	int skip = 0;
>> -
>>  	pr_debug("%s(regs = %p tsk = %p)\n", __func__, regs, tsk);
>>  
>>  	if (regs) {
>>  		if (user_mode(regs))
>>  			return;
>> -		skip = 1;
>>  	}
> 
> We can simplifiy this to:
> 
> 	if (regs && user_mode(regs))
> 		return;
> 

OK.

>>  
>>  	if (!tsk)
>> @@ -176,36 +174,8 @@ void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
>>  	if (!try_get_task_stack(tsk))
>>  		return;
>>  
>> -	if (tsk == current) {
>> -		start_backtrace(&frame,
>> -				(unsigned long)__builtin_frame_address(0),
>> -				(unsigned long)dump_backtrace);
>> -	} else {
>> -		/*
>> -		 * task blocked in __switch_to
>> -		 */
>> -		start_backtrace(&frame,
>> -				thread_saved_fp(tsk),
>> -				thread_saved_pc(tsk));
>> -	}
>> -
>>  	printk("%sCall trace:\n", loglvl);
>> -	do {
>> -		/* skip until specified stack frame */
>> -		if (!skip) {
>> -			dump_backtrace_entry(frame.pc, loglvl);
>> -		} else if (frame.fp == regs->regs[29]) {
>> -			skip = 0;
>> -			/*
>> -			 * Mostly, this is the case where this function is
>> -			 * called in panic/abort. As exception handler's
>> -			 * stack frame does not contain the corresponding pc
>> -			 * at which an exception has taken place, use regs->pc
>> -			 * instead.
>> -			 */
>> -			dump_backtrace_entry(regs->pc, loglvl);
>> -		}
>> -	} while (!unwind_frame(tsk, &frame));
>> +	arch_stack_walk(dump_backtrace_entry, (void *)loglvl, tsk, regs);
> 
> It turns out we currently need this skipping to get the balance the
> ftrace call stack, and arch_stack_walk() doesn't currently do the right
> thing when starting from regs. That balancing isn't quite right, and
> will be wrong in some case when unwinding across exception boundaries;
> we could implement HAVE_FUNCTION_GRAPH_RET_ADDR_PTR using the FP to
> solve that.
> 

I am not sure that I completely understand. So, I will study this and get back
to you with any questions.

>>  
>>  	put_task_stack(tsk);
>>  }
>> diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
>> index eebbc8d7123e..671b3038a772 100644
>> --- a/arch/arm64/kernel/time.c
>> +++ b/arch/arm64/kernel/time.c
>> @@ -32,22 +32,26 @@
>>  #include <asm/stacktrace.h>
>>  #include <asm/paravirt.h>
>>  
>> +static bool profile_pc_cb(void *arg, unsigned long pc)
>> +{
>> +	unsigned long *prof_pc = arg;
>> +
>> +	if (in_lock_functions(pc))
>> +		return true;
>> +	*prof_pc = pc;
>> +	return false;
>> +}
>> +
>>  unsigned long profile_pc(struct pt_regs *regs)
>>  {
>> -	struct stackframe frame;
>> +	unsigned long prof_pc = 0;
>>  
>>  	if (!in_lock_functions(regs->pc))
>>  		return regs->pc;
>>  
>> -	start_backtrace(&frame, regs->regs[29], regs->pc);
>> -
>> -	do {
>> -		int ret = unwind_frame(NULL, &frame);
>> -		if (ret < 0)
>> -			return 0;
>> -	} while (in_lock_functions(frame.pc));
>> +	arch_stack_walk(profile_pc_cb, &prof_pc, current, regs);
>>  
>> -	return frame.pc;
>> +	return prof_pc;
>>  }
>>  EXPORT_SYMBOL(profile_pc);
> 
> Mdoulo the problem above w.r.t. unwinding from regs, this looks good.
> 

Great. Thanks.

Madhavan
