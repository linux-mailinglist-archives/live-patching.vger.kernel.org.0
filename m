Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9995244BA90
	for <lists+live-patching@lfdr.de>; Wed, 10 Nov 2021 04:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbhKJDQm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 9 Nov 2021 22:16:42 -0500
Received: from linux.microsoft.com ([13.77.154.182]:46456 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhKJDQl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 9 Nov 2021 22:16:41 -0500
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2DE1F20C3535;
        Tue,  9 Nov 2021 19:13:54 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2DE1F20C3535
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636514034;
        bh=JYjxViWkrGsEDHLHlUlTuhozjv8AcwtqMtnbcBM6dOI=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=WT85f9ixWA4Hah3zzTkyHEz0QcK2br5nEir/6JXZ32/8NSNqBjxL6FGqGPXiLJ1iP
         uGl9naxjuTBPxKLLGlPz4SZ/FfiirbauPgXK9tzHsjw+yQ58IbwVeZkTXPUpwjnlyX
         HU1yH71Ln30Q4SrGxIV9JLynwCdITGjrrGN39SWM=
Subject: Re: [PATCH v10 10/11] arm64: Introduce stack trace reliability checks
 in the unwinder
To:     "nobuta.keiya@fujitsu.com" <nobuta.keiya@fujitsu.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "sjitindarsingh@gmail.com" <sjitindarsingh@gmail.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-11-madvenka@linux.microsoft.com>
 <TY2PR01MB5257314F9E704259AB3F61F5858B9@TY2PR01MB5257.jpnprd01.prod.outlook.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <89ec9563-1484-af7d-6d9f-7ba8e01d5a27@linux.microsoft.com>
Date:   Tue, 9 Nov 2021 21:13:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <TY2PR01MB5257314F9E704259AB3F61F5858B9@TY2PR01MB5257.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Nobuta,

Sorry for the delay in responding to your comment.
I will fix the issue you have raised in the next version.

Thanks. Again, sorry for the late response.

Madhavan

On 11/4/21 7:39 AM, nobuta.keiya@fujitsu.com wrote:
> Hi Madhavan,
> 
>> -----Original Message-----
>> From: madvenka@linux.microsoft.com <madvenka@linux.microsoft.com>
>> Sent: Friday, October 15, 2021 11:59 AM
>> To: mark.rutland@arm.com; broonie@kernel.org; jpoimboe@redhat.com; ardb@kernel.org; Nobuta, Keiya/信田 圭哉
>> <nobuta.keiya@fujitsu.com>; sjitindarsingh@gmail.com; catalin.marinas@arm.com; will@kernel.org; jmorris@namei.org;
>> linux-arm-kernel@lists.infradead.org; live-patching@vger.kernel.org; linux-kernel@vger.kernel.org;
>> madvenka@linux.microsoft.com
>> Subject: [PATCH v10 10/11] arm64: Introduce stack trace reliability checks in the unwinder
>>
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> There are some kernel features and conditions that make a stack trace unreliable. Callers may require the unwinder to detect
>> these cases.
>> E.g., livepatch.
>>
>> Introduce a new function called unwind_check_reliability() that will detect these cases and set a flag in the stack frame. Call
>> unwind_check_reliability() for every frame, that is, in unwind_start() and unwind_next().
>>
>> Introduce the first reliability check in unwind_check_reliability() - If a return PC is not a valid kernel text address, consider the
>> stack trace unreliable. It could be some generated code. Other reliability checks will be added in the future.
>>
>> Let unwind() return a boolean to indicate if the stack trace is reliable.
>>
>> Introduce arch_stack_walk_reliable() for ARM64. This works like
>> arch_stack_walk() except that it returns -EINVAL if the stack trace is not reliable.
>>
>> Until all the reliability checks are in place, arch_stack_walk_reliable() may not be used by livepatch. But it may be used by
>> debug and test code.
>>
>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>> ---
>>  arch/arm64/include/asm/stacktrace.h |  3 ++
>>  arch/arm64/kernel/stacktrace.c      | 48 ++++++++++++++++++++++++++++-
>>  2 files changed, 50 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
>> index ba2180c7d5cd..ce0710fa3037 100644
>> --- a/arch/arm64/include/asm/stacktrace.h
>> +++ b/arch/arm64/include/asm/stacktrace.h
>> @@ -51,6 +51,8 @@ struct stack_info {
>>   *               replacement lr value in the ftrace graph stack.
>>   *
>>   * @failed:      Unwind failed.
>> + *
>> + * @reliable:    Stack trace is reliable.
>>   */
>>  struct stackframe {
>>  	unsigned long fp;
>> @@ -62,6 +64,7 @@ struct stackframe {
>>  	int graph;
>>  #endif
>>  	bool failed;
>> +	bool reliable;
>>  };
>>
>>  extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk, diff --git a/arch/arm64/kernel/stacktrace.c
>> b/arch/arm64/kernel/stacktrace.c index 8e9e6f38c975..142f08ae515f 100644
>> --- a/arch/arm64/kernel/stacktrace.c
>> +++ b/arch/arm64/kernel/stacktrace.c
>> @@ -18,6 +18,22 @@
>>  #include <asm/stack_pointer.h>
>>  #include <asm/stacktrace.h>
>>
>> +/*
>> + * Check the stack frame for conditions that make further unwinding unreliable.
>> + */
>> +static void notrace unwind_check_reliability(struct stackframe *frame)
>> +{
>> +	/*
>> +	 * If the PC is not a known kernel text address, then we cannot
>> +	 * be sure that a subsequent unwind will be reliable, as we
>> +	 * don't know that the code follows our unwind requirements.
>> +	 */
>> +	if (!__kernel_text_address(frame->pc))
>> +		frame->reliable = false;
>> +}
>> +
>> +NOKPROBE_SYMBOL(unwind_check_reliability);
>> +
>>  /*
>>   * AArch64 PCS assigns the frame pointer to x29.
>>   *
>> @@ -55,6 +71,8 @@ static void notrace unwind_start(struct stackframe *frame, unsigned long fp,
>>  	frame->prev_fp = 0;
>>  	frame->prev_type = STACK_TYPE_UNKNOWN;
>>  	frame->failed = false;
>> +	frame->reliable = true;
>> +	unwind_check_reliability(frame);
>>  }
>>
>>  NOKPROBE_SYMBOL(unwind_start);
>> @@ -138,6 +156,7 @@ static void notrace unwind_next(struct task_struct *tsk,  #endif /*
>> CONFIG_FUNCTION_GRAPH_TRACER */
>>
>>  	frame->pc = ptrauth_strip_insn_pac(frame->pc);
>> +	unwind_check_reliability(frame);
>>  }
> 
> Isn't it necessary to check "final frame" before unwind_check_reliability()?
> The frame at this point is unwound frame, so may be last frame. 
> 
> Or if move unwind_check_reliability() into unwind(), I think unwind() can
> be twins as below:
> 
> ~~~~~~~~
> unwind(...) {
> 	<...>
> 	for (unwind_start(...); unwind_continue(...); unwind_next(...))
> 		unwind_check_reliability(&frame);
> }
> 
> unwind_reliable(...) {
> 	<...>
> 	for (unwind_start(...); unwind_continue(...); unwind_next(...)) {
> 		unwind_check_reliability(&frame);
> 		if (!frame.reliable)
> 			break;
> 	}
> 
> 	return (frame.reliable && !frame.failed);
> }
> ~~~~~~~~
> 
> 
> 
> Thanks,
> Keiya
> 
> 
>>
>>  NOKPROBE_SYMBOL(unwind_next);
>> @@ -167,7 +186,7 @@ static bool notrace unwind_continue(struct task_struct *task,
>>
>>  NOKPROBE_SYMBOL(unwind_continue);
>>
>> -static void notrace unwind(struct task_struct *tsk,
>> +static bool notrace unwind(struct task_struct *tsk,
>>  			   unsigned long fp, unsigned long pc,
>>  			   bool (*fn)(void *, unsigned long),
>>  			   void *data)
>> @@ -177,6 +196,7 @@ static void notrace unwind(struct task_struct *tsk,
>>  	unwind_start(&frame, fp, pc);
>>  	while (unwind_continue(tsk, &frame, fn, data))
>>  		unwind_next(tsk, &frame);
>> +	return frame.reliable;
>>  }
>>
>>  NOKPROBE_SYMBOL(unwind);
>> @@ -238,4 +258,30 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
>>
>>  }
>>
>> +/*
>> + * arch_stack_walk_reliable() may not be used for livepatch until all
>> +of
>> + * the reliability checks are in place in unwind_consume(). However,
>> + * debug and test code can choose to use it even if all the checks are
>> +not
>> + * in place.
>> + */
>> +noinline int notrace arch_stack_walk_reliable(stack_trace_consume_fn consume_fn,
>> +					      void *cookie,
>> +					      struct task_struct *task)
>> +{
>> +	unsigned long fp, pc;
>> +
>> +	if (task == current) {
>> +		/* Skip arch_stack_walk_reliable() in the stack trace. */
>> +		fp = (unsigned long)__builtin_frame_address(1);
>> +		pc = (unsigned long)__builtin_return_address(0);
>> +	} else {
>> +		/* Caller guarantees that the task is not running. */
>> +		fp = thread_saved_fp(task);
>> +		pc = thread_saved_pc(task);
>> +	}
>> +	if (unwind(task, fp, pc, consume_fn, cookie))
>> +		return 0;
>> +	return -EINVAL;
>> +}
>> +
>>  #endif
>> --
>> 2.25.1
> 
