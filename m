Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08386345E6D
	for <lists+live-patching@lfdr.de>; Tue, 23 Mar 2021 13:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhCWMqa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Mar 2021 08:46:30 -0400
Received: from linux.microsoft.com ([13.77.154.182]:52134 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbhCWMqM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Mar 2021 08:46:12 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7E03120B5680;
        Tue, 23 Mar 2021 05:46:11 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7E03120B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1616503572;
        bh=BjaskfB3mog2dIv3d/6+BWZqZJ1t60DxYRK088zLIAQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=oiJ0jDNm8ycFpmXTEru+daEKi1aMPin2FEmqGk+o1kmU0EkRVYffgsbN/5VvE3k7S
         Z9PGAZwC0UgvF4LV/QscA2FQgpBbKjoOPAlJJcXR9aPwJV2dAjgYQ1UzCIUn8F8Hg1
         u92FwyXR1WGQnmOeZKUklNQIk49DmcMJbgp6lgcI=
Subject: Re: [RFC PATCH v2 4/8] arm64: Detect an EL1 exception frame and mark
 a stack trace unreliable
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-5-madvenka@linux.microsoft.com>
 <20210323104251.GD95840@C02TD0UTHF1T.local>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <c4a36a6f-c84f-1ad9-cd03-974f6a39c37b@linux.microsoft.com>
Date:   Tue, 23 Mar 2021 07:46:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210323104251.GD95840@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 3/23/21 5:42 AM, Mark Rutland wrote:
> On Mon, Mar 15, 2021 at 11:57:56AM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> EL1 exceptions can happen on any instruction including instructions in
>> the frame pointer prolog or epilog. Depending on where exactly they happen,
>> they could render the stack trace unreliable.
>>
>> If an EL1 exception frame is found on the stack, mark the stack trace as
>> unreliable.
>>
>> Now, the EL1 exception frame is not at any well-known offset on the stack.
>> It can be anywhere on the stack. In order to properly detect an EL1
>> exception frame the following checks must be done:
>>
>> 	- The frame type must be EL1_FRAME.
>>
>> 	- When the register state is saved in the EL1 pt_regs, the frame
>> 	  pointer x29 is saved in pt_regs->regs[29] and the return PC
>> 	  is saved in pt_regs->pc. These must match with the current
>> 	  frame.
> 
> Before you can do this, you need to reliably identify that you have a
> pt_regs on the stack, but this patch uses a heuristic, which is not
> reliable.
> 
> However, instead you can identify whether you're trying to unwind
> through one of the EL1 entry functions, which tells you the same thing
> without even having to look at the pt_regs.
> 
> We can do that based on the entry functions all being in .entry.text,
> which we could further sub-divide to split the EL0 and EL1 entry
> functions.
> 

Yes. I will check the entry functions. But I still think that we should
not rely on just one check. The additional checks will make it robust.
So, I suggest that the return address be checked first. If that passes,
then we can be reasonably sure that there are pt_regs. Then, check
the other things in pt_regs.

>>
>> Interrupts encountered in kernel code are also EL1 exceptions. At the end
>> of an interrupt, the interrupt handler checks if the current task must be
>> preempted for any reason. If so, it calls the preemption code which takes
>> the task off the CPU. A stack trace taken on the task after the preemption
>> will show the EL1 frame and will be considered unreliable. This is correct
>> behavior as preemption can happen practically at any point in code
>> including the frame pointer prolog and epilog.
>>
>> Breakpoints encountered in kernel code are also EL1 exceptions. The probing
>> infrastructure uses breakpoints for executing probe code. While in the probe
>> code, the stack trace will show an EL1 frame and will be considered
>> unreliable. This is also correct behavior.
>>
>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
>> ---
>>  arch/arm64/include/asm/stacktrace.h |  2 +
>>  arch/arm64/kernel/stacktrace.c      | 57 +++++++++++++++++++++++++++++
>>  2 files changed, 59 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
>> index eb29b1fe8255..684f65808394 100644
>> --- a/arch/arm64/include/asm/stacktrace.h
>> +++ b/arch/arm64/include/asm/stacktrace.h
>> @@ -59,6 +59,7 @@ struct stackframe {
>>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>>  	int graph;
>>  #endif
>> +	bool reliable;
>>  };
>>  
>>  extern int unwind_frame(struct task_struct *tsk, struct stackframe *frame);
>> @@ -169,6 +170,7 @@ static inline void start_backtrace(struct stackframe *frame,
>>  	bitmap_zero(frame->stacks_done, __NR_STACK_TYPES);
>>  	frame->prev_fp = 0;
>>  	frame->prev_type = STACK_TYPE_UNKNOWN;
>> +	frame->reliable = true;
>>  }
>>  
>>  #endif	/* __ASM_STACKTRACE_H */
>> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
>> index 504cd161339d..6ae103326f7b 100644
>> --- a/arch/arm64/kernel/stacktrace.c
>> +++ b/arch/arm64/kernel/stacktrace.c
>> @@ -18,6 +18,58 @@
>>  #include <asm/stack_pointer.h>
>>  #include <asm/stacktrace.h>
>>  
>> +static void check_if_reliable(unsigned long fp, struct stackframe *frame,
>> +			      struct stack_info *info)
>> +{
>> +	struct pt_regs *regs;
>> +	unsigned long regs_start, regs_end;
>> +
>> +	/*
>> +	 * If the stack trace has already been marked unreliable, just
>> +	 * return.
>> +	 */
>> +	if (!frame->reliable)
>> +		return;
>> +
>> +	/*
>> +	 * Assume that this is an intermediate marker frame inside a pt_regs
>> +	 * structure created on the stack and get the pt_regs pointer. Other
>> +	 * checks will be done below to make sure that this is a marker
>> +	 * frame.
>> +	 */
> 
> Sorry, but NAK to this approach specifically. This isn't reliable (since
> it can be influenced by arbitrary data on the stack), and it's far more
> complicated than identifying the entry functions specifically.
> 

As I mentioned above, I agree that we should check the return address. But
just as a precaution, I think we should double check the pt_regs.

Is that OK with you? It does not take away anything or increase the risk in
anyway. I think it makes it more robust.

Thanks.

Madhavan
