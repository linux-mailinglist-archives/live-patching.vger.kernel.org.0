Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3045D35364E
	for <lists+live-patching@lfdr.de>; Sun,  4 Apr 2021 05:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236655AbhDDDqI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 3 Apr 2021 23:46:08 -0400
Received: from linux.microsoft.com ([13.77.154.182]:38950 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236641AbhDDDqH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 3 Apr 2021 23:46:07 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 6AC8B20ABC5B;
        Sat,  3 Apr 2021 20:46:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6AC8B20ABC5B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617507964;
        bh=RThup4qT9O8evxOI3uZmifnqnOBzkc3TrNrG8Z4PG74=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=jJLAhj33zDCZfRRa3K5Z54mnr7I2XvdlBOKWVV56rx23IW24HNwiK1W6kY/3p+Gqy
         4M0vHD2QUPTfLouMp/qVBaI5aNAvi1kWYrSHYMcr4OpIvEdvPexwIagV7lPDtB3WIo
         a9fmlOhqMAfef5J49ZgZ3fFaBykr5ntt82dCV10U=
Subject: Re: [RFC PATCH v2 1/1] arm64: Implement stack trace termination
 record
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     mark.rutland@arm.com, broonie@kernel.org, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <659f3d5cc025896ba4c49aea431aa8b1abc2b741>
 <20210402032404.47239-1-madvenka@linux.microsoft.com>
 <20210402032404.47239-2-madvenka@linux.microsoft.com>
 <20210403155948.ubbgtwmlsdyar7yp@treble>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <171fef08-17d3-2c2e-dad8-6caf4c0c7f15@linux.microsoft.com>
Date:   Sat, 3 Apr 2021 22:46:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210403155948.ubbgtwmlsdyar7yp@treble>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/3/21 10:59 AM, Josh Poimboeuf wrote:
> On Thu, Apr 01, 2021 at 10:24:04PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>> @@ -447,9 +464,9 @@ SYM_FUNC_START_LOCAL(__primary_switched)
>>  #endif
>>  	bl	switch_to_vhe			// Prefer VHE if possible
>>  	add	sp, sp, #16
>> -	mov	x29, #0
>> -	mov	x30, #0
>> -	b	start_kernel
>> +	setup_final_frame
>> +	bl	start_kernel
>> +	nop
>>  SYM_FUNC_END(__primary_switched)
>>  
>>  	.pushsection ".rodata", "a"
>> @@ -606,14 +623,14 @@ SYM_FUNC_START_LOCAL(__secondary_switched)
>>  	cbz	x2, __secondary_too_slow
>>  	msr	sp_el0, x2
>>  	scs_load x2, x3
>> -	mov	x29, #0
>> -	mov	x30, #0
>> +	setup_final_frame
>>  
>>  #ifdef CONFIG_ARM64_PTR_AUTH
>>  	ptrauth_keys_init_cpu x2, x3, x4, x5
>>  #endif
>>  
>> -	b	secondary_start_kernel
>> +	bl	secondary_start_kernel
>> +	nop
>>  SYM_FUNC_END(__secondary_switched)
> 
> I'm somewhat arm-ignorant, so take the following comments with a grain
> of salt.
> 
> 
> I don't think changing these to 'bl' is necessary, unless you wanted
> __primary_switched() and __secondary_switched() to show up in the
> stacktrace for some reason?  If so, that seems like a separate patch.
> 

The problem is with __secondary_switched. If you trace the code back to where
a secondary CPU is started, I don't see any calls anywhere. There are only
branches if I am not mistaken. So, the return address register never gets
set up with a proper address. The stack trace shows some hexadecimal value
instead of a symbol name.

On ARM64, the call instruction is actually a branch instruction IIUC. The
only extra thing it does is to load the link register (return address register)
with the return address. That is all.

Instead of the link register pointing to some arbitrary code in startup that
did not call start_kernel() or secondary_start_kernel(), I wanted to set it
up as shown above.

> 
> Also, why are nops added after the calls?  My guess would be because,
> since these are basically tail calls to "noreturn" functions, the stack
> dump code would otherwise show the wrong function, i.e. whatever
> function happens to be after the 'bl'.
> 

That is correct. The stack trace shows something arbitrary.

> We had the same issue for x86.  It can be fixed by using '%pB' instead
> of '%pS' when printing the address in dump_backtrace_entry().  See
> sprint_backtrace() for more details.
> 
> BTW I think the same issue exists for GCC-generated code.  The following
> shows several such cases:
> 
>   objdump -dr vmlinux |awk '/bl   / {bl=1;l=$0;next} bl == 1 && /^$/ {print l; print} // {bl=0}'
> 
> 
> However, looking at how arm64 unwinds through exceptions in kernel
> space, using '%pB' might have side effects when the exception LR
> (elr_el1) points to the beginning of a function.  Then '%pB' would show
> the end of the previous function, instead of the function which was
> interrupted.
> 
> So you may need to rethink how to unwind through in-kernel exceptions.
> 
> Basically, when printing a stack return address, you want to use '%pB'
> for a call return address and '%pS' for an interrupted address.
> 
> On x86, with the frame pointer unwinder, we encode the frame pointer by
> setting a bit in %rbp which tells the unwinder that it's a special
> pt_regs frame.  Then instead of treating it like a normal call frame,
> the stack dump code prints the registers, and the return address
> (regs->ip) gets printed with '%pS'.
> 

Yes. But there are objections to that kind of encoding.

Having the nop above does not do any harm. It just adds 4 bytes to the function text.
I would rather keep this simple right now because this is only for getting a sensible
stack trace for idle tasks.

Is there any other problem that you can see?

>>  SYM_FUNC_START_LOCAL(__secondary_too_slow)
>> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
>> index 325c83b1a24d..906baa232a89 100644
>> --- a/arch/arm64/kernel/process.c
>> +++ b/arch/arm64/kernel/process.c
>> @@ -437,6 +437,11 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
>>  	}
>>  	p->thread.cpu_context.pc = (unsigned long)ret_from_fork;
>>  	p->thread.cpu_context.sp = (unsigned long)childregs;
>> +	/*
>> +	 * For the benefit of the unwinder, set up childregs->stackframe
>> +	 * as the final frame for the new task.
>> +	 */
>> +	p->thread.cpu_context.fp = (unsigned long)childregs->stackframe;
>>  
>>  	ptrace_hw_copy_thread(p);
>>  
>> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
>> index ad20981dfda4..72f5af8c69dc 100644
>> --- a/arch/arm64/kernel/stacktrace.c
>> +++ b/arch/arm64/kernel/stacktrace.c
>> @@ -44,16 +44,16 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>>  	unsigned long fp = frame->fp;
>>  	struct stack_info info;
>>  
>> -	/* Terminal record; nothing to unwind */
>> -	if (!fp)
>> +	if (!tsk)
>> +		tsk = current;
>> +
>> +	/* Final frame; nothing to unwind */
>> +	if (fp == (unsigned long) task_pt_regs(tsk)->stackframe)
>>  		return -ENOENT;
> 
> As far as I can tell, the regs stackframe value is initialized to zero
> during syscall entry, so isn't this basically just 'if (fp == 0)'?
> 
> Shouldn't it instead be comparing with the _address_ of the stackframe
> field to make sure it reached the end?
> 

pt_regs->stackframe is an array of two u64 elements- one for FP and one for
PC. So, I am comparing the address and not the value of FP.

        u64 stackframe[2];

Madhavan
