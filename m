Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B743DA5F4
	for <lists+live-patching@lfdr.de>; Thu, 29 Jul 2021 16:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238831AbhG2OKM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 29 Jul 2021 10:10:12 -0400
Received: from linux.microsoft.com ([13.77.154.182]:38242 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238177AbhG2OG7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 29 Jul 2021 10:06:59 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4124020B36E0;
        Thu, 29 Jul 2021 07:06:27 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4124020B36E0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1627567588;
        bh=++/ELKG567mTAjm67Tosk2XZo0ouQr0TXCnZl8RpgT8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=lc/8I52I0QXsJ55fU2lUEzC87aN3iWQtL3xoV1ZgDRqjhJxb38HaI1i6UztjDLXQT
         Ec9OMxguvSadZhdkzC5bblEBCZNRoj6oMeD7rVBz1OaRMQdtR1224ZEZs9Xb/ktMcA
         DCHYtlFCPGB8RTlTrPRXotzN1Q8NebOCeGDFJQNI=
Subject: Re: [RFC PATCH v6 3/3] arm64: Create a list of SYM_CODE functions,
 check return PC against list
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <3f2aab69a35c243c5e97f47c4ad84046355f5b90>
 <20210630223356.58714-1-madvenka@linux.microsoft.com>
 <20210630223356.58714-4-madvenka@linux.microsoft.com>
 <20210728172523.GB47345@C02TD0UTHF1T.local>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <f9931a57-7a81-867b-fa2a-499d441c5acd@linux.microsoft.com>
Date:   Thu, 29 Jul 2021 09:06:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210728172523.GB47345@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Responses inline...

On 7/28/21 12:25 PM, Mark Rutland wrote:
> On Wed, Jun 30, 2021 at 05:33:56PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>> ... <snip> ...
>> +static struct code_range	*sym_code_functions;
>> +static int			num_sym_code_functions;
>> +
>> +int __init init_sym_code_functions(void)
>> +{
>> +	size_t size;
>> +
>> +	size = (unsigned long)__sym_code_functions_end -
>> +	       (unsigned long)__sym_code_functions_start;
>> +
>> +	sym_code_functions = kmalloc(size, GFP_KERNEL);
>> +	if (!sym_code_functions)
>> +		return -ENOMEM;
>> +
>> +	memcpy(sym_code_functions, __sym_code_functions_start, size);
>> +	/* Update num_sym_code_functions after copying sym_code_functions. */
>> +	smp_mb();
>> +	num_sym_code_functions = size / sizeof(struct code_range);
>> +
>> +	return 0;
>> +}
>> +early_initcall(init_sym_code_functions);
> 
> What's the point of copying this, given we don't even sort it?
> 
> If we need to keep it around, it would be nicer to leave it where the
> linker put it, but make it rodata or ro_after_init.
> 

I was planning to sort it for performance. I have a comment to that effect.
But I can remove the copy and retain the info in linker data.

>> +
>>  /*
>>   * Check the stack frame for conditions that make unwinding unreliable.
>>   */
>>  enum unwind_rc unwind_check_frame(struct stackframe *frame)
>>  {
>> +	const struct code_range *range;
>> +	unsigned long pc;
>> +	int i;
>> +
>>  	/*
>>  	 * If the PC is not a known kernel text address, then we cannot
>>  	 * be sure that a subsequent unwind will be reliable, as we
>> @@ -30,6 +62,86 @@ enum unwind_rc unwind_check_frame(struct stackframe *frame)
>>  	 */
>>  	if (!__kernel_text_address(frame->pc))
>>  		return UNWIND_CONTINUE_WITH_RISK;
> 
> As per patch 1, I'd prefer we had something like an
> unwind_is_unreliable() helper, which can return a boolean in this case.
> 

I will look into this.

>> +
>> +	/*
>> +	 * If the final frame has been reached, there is no more unwinding
>> +	 * to do. There is no need to check if the return PC is considered
>> +	 * unreliable by the unwinder.
>> +	 */
>> +	if (!frame->fp)
>> +		return UNWIND_CONTINUE;
> 
> As mentioned on patch 1, I'd rather the main unwind loop checked for the
> final frame specifically before trying to unwind. With that in mind, we
> should never try to unwind to a NULL fp.
> 

OK.

>> +
>> +	/*
>> +	 * Check the return PC against sym_code_functions[]. If there is a
>> +	 * match, then the consider the stack frame unreliable. These functions
>> +	 * contain low-level code where the frame pointer and/or the return
>> +	 * address register cannot be relied upon. This addresses the following
>> +	 * situations:
>> +	 *
>> +	 *  - Exception handlers and entry assembly
>> +	 *  - Trampoline assembly (e.g., ftrace, kprobes)
>> +	 *  - Hypervisor-related assembly
>> +	 *  - Hibernation-related assembly
>> +	 *  - CPU start-stop, suspend-resume assembly
>> +	 *  - Kernel relocation assembly
>> +	 *
>> +	 * Some special cases covered by sym_code_functions[] deserve a mention
>> +	 * here:
>> +	 *
>> +	 *  - All EL1 interrupt and exception stack traces will be considered
>> +	 *    unreliable. This is the correct behavior as interrupts and
>> +	 *    exceptions can happen on any instruction including ones in the
>> +	 *    frame pointer prolog and epilog. Unless stack metadata is
>> +	 *    available so the unwinder can unwind through these special
>> +	 *    cases, such stack traces will be considered unreliable.
> 
> As mentioned previously, we *can* reliably unwind precisely one step
> across an exception boundary, as we can be certain of the PC value at
> the time the exception was taken, but past this we can't be certain
> whether the LR is legitimate.
> 
> I'd like that we capture that precisely in the unwinder, and I'm
> currently reworking the entry assembly to make that possible.
> 
>> +	 *
>> +	 *  - A task can get preempted at the end of an interrupt. Stack
>> +	 *    traces of preempted tasks will show the interrupt frame in the
>> +	 *    stack trace and will be considered unreliable.
>> +	 *
>> +	 *  - Breakpoints are exceptions. So, all stack traces in the break
>> +	 *    point handler (including probes) will be considered unreliable.
>> +	 *
>> +	 *  - All of the ftrace entry trampolines are considered unreliable.
>> +	 *    So, all stack traces taken from tracer functions will be
>> +	 *    considered unreliable.
>> +	 *
>> +	 *  - The Function Graph Tracer return trampoline (return_to_handler)
>> +	 *    and the Kretprobe return trampoline (kretprobe_trampoline) are
>> +	 *    also considered unreliable.
> 
> We should be able to unwind these reliably if we specifically identify
> them. I think we need a two-step check here; we should assume that
> SYM_CODE() is unreliable by default, but in specific cases we should
> unwind that reliably.
> 
>> +	 * Some of the special cases above can be unwound through using
>> +	 * special logic in unwind_frame().
>> +	 *
>> +	 *  - return_to_handler() is handled by the unwinder by attempting
>> +	 *    to retrieve the original return address from the per-task
>> +	 *    return address stack.
>> +	 *
>> +	 *  - kretprobe_trampoline() can be handled in a similar fashion by
>> +	 *    attempting to retrieve the original return address from the
>> +	 *    per-task kretprobe instance list.
> 
> We don't do this today,
> 
>> +	 *
>> +	 *  - I reckon optprobes can be handled in a similar fashion in the
>> +	 *    future?
>> +	 *
>> +	 *  - Stack traces taken from the FTrace tracer functions can be
>> +	 *    handled as well. ftrace_call is an inner label defined in the
>> +	 *    Ftrace entry trampoline. This is the location where the call
>> +	 *    to a tracer function is patched. So, if the return PC equals
>> +	 *    ftrace_call+4, it is reliable. At that point, proper stack
>> +	 *    frames have already been set up for the traced function and
>> +	 *    its caller.
>> +	 *
>> +	 * NOTE:
>> +	 *   If sym_code_functions[] were sorted, a binary search could be
>> +	 *   done to make this more performant.
>> +	 */
> 
> Since some of the above is speculative (e.g. the bit about optprobes),
> and as code will change over time, I think we should have a much terser
> comment, e.g.
> 
> 	/*
> 	 * As SYM_CODE functions don't follow the usual calling
> 	 * conventions, we assume by default that any SYM_CODE function
> 	 * cannot be unwound reliably.
> 	 *
> 	 * Note that this includes exception entry/return sequences and
> 	 * trampoline for ftrace and kprobes.
> 	 */
> 
> ... and then if/when we try to unwind a specific SYM_CODE function
> reliably, we add the comment for that specifically.
> 

Just to confirm, are you suggesting that I remove the entire large comment
detailing the various cases and replace the whole thing with the terse comment?
I did the large comment because of Mark Brown's input that we must be verbose
about all the cases so that it is clear in the future what the different
cases are and how we handle them in this code. As the code evolves, the comments
would evolve.

I can replace the comment if you want. Please confirm.

Thanks.

Madhavan
