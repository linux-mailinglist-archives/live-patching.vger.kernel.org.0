Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3074463C9A
	for <lists+live-patching@lfdr.de>; Tue, 30 Nov 2021 18:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244687AbhK3RQu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Nov 2021 12:16:50 -0500
Received: from linux.microsoft.com ([13.77.154.182]:33404 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbhK3RQt (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Nov 2021 12:16:49 -0500
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 839B520DED70;
        Tue, 30 Nov 2021 09:13:29 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 839B520DED70
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1638292410;
        bh=bNRrX7iFkfr7lAD0nb68h7Qbf3fFMMOsYNE3J+6JtDM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=FachemGxIEV87ScrWY+JRI/bYrBnDJV6QBPusSUMqSbWZYyL0Qw/pEPlfjQWOTnLu
         s1hfZpTWIBkjpPgBnmw26qzn/aSqyTj/HY1aPiQk1vAwRhYc/4hj6GOqH5In7qchSx
         4xh52yQvivgI0O0Btj76zFNB/HotC0w4jy3t5OsI=
Subject: Re: [PATCH v11 1/5] arm64: Call stack_backtrace() only from within
 walk_stackframe()
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
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <f2dfa6cd-7a23-e1b7-09d5-737d4a95b90c@linux.microsoft.com>
Date:   Tue, 30 Nov 2021 11:13:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YaY9zLNumYZ1lLkc@FVFF77S0Q05N>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 11/30/21 9:05 AM, Mark Rutland wrote:
> On Tue, Nov 23, 2021 at 01:37:19PM -0600, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> Currently, arch_stack_walk() calls start_backtrace() and walk_stackframe()
>> separately. There is no need to do that. Instead, call start_backtrace()
>> from within walk_stackframe(). In other words, walk_stackframe() is the only
>> unwind function a consumer needs to call.
>>
>> Currently, the only consumer is arch_stack_walk(). In the future,
>> arch_stack_walk_reliable() will be another consumer.
>>
>> Currently, there is a check for a NULL task in unwind_frame(). It is not
>> needed since all current consumers pass a non-NULL task.
> 
> Can you split the NULL check change into a preparatory patch? That change is
> fine in isolation (and easier to review/ack), and it's nicer for future
> bisection to not group that with unrelated changes.
> 

Will do this in the next version.

>> Use struct stackframe only within the unwind functions.
>>
>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>> ---
>>  arch/arm64/kernel/stacktrace.c | 41 ++++++++++++++++++----------------
>>  1 file changed, 22 insertions(+), 19 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
>> index 0fb58fed54cb..7217c4f63ef7 100644
>> --- a/arch/arm64/kernel/stacktrace.c
>> +++ b/arch/arm64/kernel/stacktrace.c
>> @@ -69,9 +69,6 @@ static int notrace unwind_frame(struct task_struct *tsk,
>>  	unsigned long fp = frame->fp;
>>  	struct stack_info info;
>>  
>> -	if (!tsk)
>> -		tsk = current;
>> -
>>  	/* Final frame; nothing to unwind */
>>  	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
>>  		return -ENOENT;
>> @@ -143,15 +140,19 @@ static int notrace unwind_frame(struct task_struct *tsk,
>>  NOKPROBE_SYMBOL(unwind_frame);
>>  
>>  static void notrace walk_stackframe(struct task_struct *tsk,
>> -				    struct stackframe *frame,
>> +				    unsigned long fp, unsigned long pc,
>>  				    bool (*fn)(void *, unsigned long), void *data)
>>  {
>> +	struct stackframe frame;
>> +
>> +	start_backtrace(&frame, fp, pc);
>> +
>>  	while (1) {
>>  		int ret;
>>  
>> -		if (!fn(data, frame->pc))
>> +		if (!fn(data, frame.pc))
>>  			break;
>> -		ret = unwind_frame(tsk, frame);
>> +		ret = unwind_frame(tsk, &frame);
>>  		if (ret < 0)
>>  			break;
>>  	}
>> @@ -195,17 +196,19 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
>>  			      void *cookie, struct task_struct *task,
>>  			      struct pt_regs *regs)
>>  {
>> -	struct stackframe frame;
>> -
>> -	if (regs)
>> -		start_backtrace(&frame, regs->regs[29], regs->pc);
>> -	else if (task == current)
>> -		start_backtrace(&frame,
>> -				(unsigned long)__builtin_frame_address(1),
>> -				(unsigned long)__builtin_return_address(0));
>> -	else
>> -		start_backtrace(&frame, thread_saved_fp(task),
>> -				thread_saved_pc(task));
>> -
>> -	walk_stackframe(task, &frame, consume_entry, cookie);
>> +	unsigned long fp, pc;
>> +
>> +	if (regs) {
>> +		fp = regs->regs[29];
>> +		pc = regs->pc;
>> +	} else if (task == current) {
>> +		/* Skip arch_stack_walk() in the stack trace. */
>> +		fp = (unsigned long)__builtin_frame_address(1);
>> +		pc = (unsigned long)__builtin_return_address(0);
>> +	} else {
>> +		/* Caller guarantees that the task is not running. */
>> +		fp = thread_saved_fp(task);
>> +		pc = thread_saved_pc(task);
>> +	}
>> +	walk_stackframe(task, fp, pc, consume_entry, cookie);
> 
> I'd prefer to leave this as-is. The new and old structure are largely
> equivalent, so we haven't made this any simpler, but we have added more
> arguments to walk_stackframe().
> 

This is just to simplify things when we eventually add arch_stack_walk_reliable().
That is all. All of the unwinding is done by a single unwinding function and
there are two consumers of that unwinding function - arch_stack_walk() and
arch_stack_walk_reliable().


> One thing I *would* like to do is move tsk into strcut stackframe, so we only
> need to pass that around, which'll make it easier to refactor the core unwind
> logic.
> 

Will do this in the next version.

Thanks,

Madhavan
