Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9ED46F9C8
	for <lists+live-patching@lfdr.de>; Fri, 10 Dec 2021 05:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhLJER1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 Dec 2021 23:17:27 -0500
Received: from linux.microsoft.com ([13.77.154.182]:35644 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbhLJER0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 Dec 2021 23:17:26 -0500
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9D14020B7179;
        Thu,  9 Dec 2021 20:13:51 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9D14020B7179
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1639109632;
        bh=2+9DWElxFs0oeoukK3yGHPhLFd0ho+qne9SrdFClZa0=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=m45rWvuNhtfDvkGtS91DT5soxAnSy5X+dx426kjPW0TfiKtrKUol2vq8lVxck7G+e
         PgeFA+Gvm45k3U6Ea5TC7lqvv/azWkdD4T9MHVsdcsT1zGexLplDhj25fsmOm3GHN7
         RIkxs47zkKiEmiLBwmt5Msm6AVIUD/2XOVfqlwFc=
Subject: Re: [PATCH v11 1/5] arm64: Call stack_backtrace() only from within
 walk_stackframe()
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <8b861784d85a21a9bf08598938c11aff1b1249b9>
 <20211123193723.12112-1-madvenka@linux.microsoft.com>
 <20211123193723.12112-2-madvenka@linux.microsoft.com>
 <YaY9zLNumYZ1lLkc@FVFF77S0Q05N>
 <f2dfa6cd-7a23-e1b7-09d5-737d4a95b90c@linux.microsoft.com>
 <YaZtUmBn1NUkY876@FVFF77S0Q05N>
 <1dffea0a-fd99-ccd6-625f-c5e573186741@linux.microsoft.com>
Message-ID: <ed143443-a406-a83e-bf7c-18083b98e503@linux.microsoft.com>
Date:   Thu, 9 Dec 2021 22:13:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1dffea0a-fd99-ccd6-625f-c5e573186741@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hey Mark,

Do you have any comments on the rest of the series? I am working on the next version of the patchset.
If you have any other comments, I will wait.

Thanks.

Madhavan

On 11/30/21 2:29 PM, Madhavan T. Venkataraman wrote:
> 
> 
> On 11/30/21 12:29 PM, Mark Rutland wrote:
>> On Tue, Nov 30, 2021 at 11:13:28AM -0600, Madhavan T. Venkataraman wrote:
>>> On 11/30/21 9:05 AM, Mark Rutland wrote:
>>>> On Tue, Nov 23, 2021 at 01:37:19PM -0600, madvenka@linux.microsoft.com wrote:
>>>>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>>>>
>>>>> Currently, arch_stack_walk() calls start_backtrace() and walk_stackframe()
>>>>> separately. There is no need to do that. Instead, call start_backtrace()
>>>>> from within walk_stackframe(). In other words, walk_stackframe() is the only
>>>>> unwind function a consumer needs to call.
>>
>>>>> @@ -143,15 +140,19 @@ static int notrace unwind_frame(struct task_struct *tsk,
>>>>>  NOKPROBE_SYMBOL(unwind_frame);
>>>>>  
>>>>>  static void notrace walk_stackframe(struct task_struct *tsk,
>>>>> -				    struct stackframe *frame,
>>>>> +				    unsigned long fp, unsigned long pc,
>>>>>  				    bool (*fn)(void *, unsigned long), void *data)
>>>>>  {
>>>>> +	struct stackframe frame;
>>>>> +
>>>>> +	start_backtrace(&frame, fp, pc);
>>>>> +
>>>>>  	while (1) {
>>>>>  		int ret;
>>>>>  
>>>>> -		if (!fn(data, frame->pc))
>>>>> +		if (!fn(data, frame.pc))
>>>>>  			break;
>>>>> -		ret = unwind_frame(tsk, frame);
>>>>> +		ret = unwind_frame(tsk, &frame);
>>>>>  		if (ret < 0)
>>>>>  			break;
>>>>>  	}
>>>>> @@ -195,17 +196,19 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
>>>>>  			      void *cookie, struct task_struct *task,
>>>>>  			      struct pt_regs *regs)
>>>>>  {
>>>>> -	struct stackframe frame;
>>>>> -
>>>>> -	if (regs)
>>>>> -		start_backtrace(&frame, regs->regs[29], regs->pc);
>>>>> -	else if (task == current)
>>>>> -		start_backtrace(&frame,
>>>>> -				(unsigned long)__builtin_frame_address(1),
>>>>> -				(unsigned long)__builtin_return_address(0));
>>>>> -	else
>>>>> -		start_backtrace(&frame, thread_saved_fp(task),
>>>>> -				thread_saved_pc(task));
>>>>> -
>>>>> -	walk_stackframe(task, &frame, consume_entry, cookie);
>>>>> +	unsigned long fp, pc;
>>>>> +
>>>>> +	if (regs) {
>>>>> +		fp = regs->regs[29];
>>>>> +		pc = regs->pc;
>>>>> +	} else if (task == current) {
>>>>> +		/* Skip arch_stack_walk() in the stack trace. */
>>>>> +		fp = (unsigned long)__builtin_frame_address(1);
>>>>> +		pc = (unsigned long)__builtin_return_address(0);
>>>>> +	} else {
>>>>> +		/* Caller guarantees that the task is not running. */
>>>>> +		fp = thread_saved_fp(task);
>>>>> +		pc = thread_saved_pc(task);
>>>>> +	}
>>>>> +	walk_stackframe(task, fp, pc, consume_entry, cookie);
>>>>
>>>> I'd prefer to leave this as-is. The new and old structure are largely
>>>> equivalent, so we haven't made this any simpler, but we have added more
>>>> arguments to walk_stackframe().
>>>>
>>>
>>> This is just to simplify things when we eventually add arch_stack_walk_reliable().
>>> That is all. All of the unwinding is done by a single unwinding function and
>>> there are two consumers of that unwinding function - arch_stack_walk() and
>>> arch_stack_walk_reliable().
>>
>> I understand the theory, but I don't think that moving the start_backtrace()
>> call actually simplifies this in a meaningful way, and I think it'll make it
>> harder for us to make more meaningful simplifications later on.
>>
>> As of patch 4 of this series, we'll have:
>>
>> | noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
>> | 				      void *cookie, struct task_struct *task,
>> | 				      struct pt_regs *regs)
>> | {
>> | 	unsigned long fp, pc;
>> | 
>> | 	if (regs) {
>> | 		fp = regs->regs[29];
>> | 		pc = regs->pc;
>> | 	} else if (task == current) {
>> | 		/* Skip arch_stack_walk() in the stack trace. */
>> | 		fp = (unsigned long)__builtin_frame_address(1);
>> | 		pc = (unsigned long)__builtin_return_address(0);
>> | 	} else {
>> | 		/* Caller guarantees that the task is not running. */
>> | 		fp = thread_saved_fp(task);
>> | 		pc = thread_saved_pc(task);
>> | 	}
>> | 	walk_stackframe(task, fp, pc, consume_entry, cookie);
>> | }
>> | 
>> | noinline int notrace arch_stack_walk_reliable(stack_trace_consume_fn consume_fn,
>> |                                              void *cookie,
>> |                                              struct task_struct *task)
>> | {
>> | 	unsigned long fp, pc;
>> | 
>> | 	if (task == current) {
>> | 		/* Skip arch_stack_walk_reliable() in the stack trace. */
>> | 		fp = (unsigned long)__builtin_frame_address(1);
>> | 		pc = (unsigned long)__builtin_return_address(0);
>> | 	} else {
>> | 		/* Caller guarantees that the task is not running. */
>> | 		fp = thread_saved_fp(task);
>> | 		pc = thread_saved_pc(task);
>> | 	}
>> | 	if (unwind(task, fp, pc, consume_fn, cookie))
>> | 		return 0;
>> | 	return -EINVAL;
>> | }
>>
>> Which I do not think is substantially simpler than the naive extrapolation from
>> what we currently have, e.g.
>>
>> | noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
>> | 				      void *cookie, struct task_struct *task,
>> | 				      struct pt_regs *regs)
>> | {
>> |	struct stackframe frame;
>> | 
>> | 	if (regs) {
>> |		unwind_init(&frame, regs->regs[29], regs->pc)
>> | 	} else if (task == current) {
>> |		unwind_init(&frame, __builtin_frame_address(1),
>> |			    __builtin_return_address(0));
>> | 	} else {
>> |		unwind_init(&frame, thread_saved_fp(task),
>> |			    thread_saved_pc(task);
>> | 	}
>> | 	walk_stackframe(task, &frame, consume_entry, cookie);
>> | }
>> | 
>> | noinline int notrace arch_stack_walk_reliable(stack_trace_consume_fn consume_fn,
>> |                                              void *cookie,
>> |                                              struct task_struct *task)
>> | {
>> |	struct stackframe frame;
>> | 
>> | 	if (task == current) {
>> |		unwind_init(&frame, __builtin_frame_address(1),
>> |			    __builtin_return_address(0));
>> | 	} else {
>> |		unwind_init(&frame, thread_saved_fp(task),
>> |			    thread_saved_pc(task);
>> | 	}
>> | 	if (unwind(task, &frame, consume_fn, cookie))
>> | 		return 0;
>> | 	return -EINVAL;
>> | }
>>
>> Further, I think we can factor this in a different way to reduce the
>> duplication:
>>
>> | /*
>> |  * TODO: document requirements here
>> |  */
>> | static inline void unwind_init_from_current_regs(struct stackframe *frame,
>> | 						 struct pt_regs *regs)
>> | {
>> | 	unwind_init(frame, regs->regs[29], regs->pc);
>> | }
>> | 
>> | /*
>> |  * TODO: document requirements here
>> |  */
>> | static inline void unwind_init_from_blocked_task(struct stackframe *frame,
>> | 						 struct task_struct *tsk)
>> | {
>> | 	unwind_init(&frame, thread_saved_fp(task),
>> | 		    thread_saved_pc(task));
>> | }
>> | 
>> | /*
>> |  * TODO: document requirements here
>> |  *
>> |  * Note: this is always inlined, and we expect our caller to be a noinline
>> |  * function, such that this starts from our caller's caller.
>> |  */
>> | static __always_inline void unwind_init_from_caller(struct stackframe *frame)
>> | {
>> | 	unwind_init(frame, __builtin_frame_address(1),
>> | 		    __builtin_return_address(0));
>> | }
>> |
>> | noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
>> | 				      void *cookie, struct task_struct *task,
>> | 				      struct pt_regs *regs)
>> | {
>> |	struct stackframe frame;
>> | 
>> | 	if (regs)
>> |		unwind_init_current_regs(&frame, regs);
>> |	else if (task == current)
>> |		unwind_init_from_caller(&frame);
>> |	else
>> |		unwind_init_blocked_task(&frame, task);
>> |
>> |	unwind(task, &frame, consume_entry, cookie);
>> | }
>> |
>> | noinline int notrace arch_stack_walk_reliable(stack_trace_consume_fn consume_fn,
>> |                                              void *cookie,
>> |                                              struct task_struct *task)
>> | {
>> |	struct stackframe frame;
>> | 
>> | 	if (task == current)
>> |		unwind_init_from_caller(&frame);
>> | 	else
>> |		unwind_init_from_blocked_task(&frame, task);
>> |
>> | 	if (unwind(task, &frame, consume_fn, cookie))
>> | 		return 0;
>> | 	return -EINVAL;
>> | }
>>
>> ... which minimizes the duplication and allows us to add specialized
>> initialization for each case if necessary, which I believe we will need in
>> future to make unwinding across exception boundaries (such as when starting
>> with regs) more useful.
>>
>> Thanks,
>> Mark.
>>
> 
> OK. I don't mind doing it this way.
> 
> Thanks.
> 
> Madhavan
> 
