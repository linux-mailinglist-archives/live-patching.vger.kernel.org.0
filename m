Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5FA35364A
	for <lists+live-patching@lfdr.de>; Sun,  4 Apr 2021 05:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236655AbhDDD3U (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 3 Apr 2021 23:29:20 -0400
Received: from linux.microsoft.com ([13.77.154.182]:36926 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236641AbhDDD3R (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 3 Apr 2021 23:29:17 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 677A120B5680;
        Sat,  3 Apr 2021 20:29:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 677A120B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617506954;
        bh=hkiYySmua8du5lI66r57EfP7MXX3NiBlWY0LoK0BTPA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=sPmPADKjprydzEbnJ0CErtpKC8QLg+rkHgR5PPrdRndzoMPu4FPTtS0GcsqOR2oFR
         mjSTukdWIMt5/ohnyhlQHlekFiYOIBTE5tVYNoFAQt3fD9WeljxQkqFoSyVOdFNKS3
         dWFcRx27hJHMGqjTywZ3yI28p16YtPGxrAqwM7KY=
Subject: Re: [RFC PATCH v1 0/4] arm64: Implement stack trace reliability
 checks
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     mark.rutland@arm.com, broonie@kernel.org, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>
References: <77bd5edeea72d44533c769b1e8c0fea7a9d7eb3a>
 <20210330190955.13707-1-madvenka@linux.microsoft.com>
 <20210403170159.gegqjrsrg7jshlne@treble>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <bd13a433-c060-c501-8e76-5e856d77a225@linux.microsoft.com>
Date:   Sat, 3 Apr 2021 22:29:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210403170159.gegqjrsrg7jshlne@treble>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/3/21 12:01 PM, Josh Poimboeuf wrote:
> On Tue, Mar 30, 2021 at 02:09:51PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> There are a number of places in kernel code where the stack trace is not
>> reliable. Enhance the unwinder to check for those cases and mark the
>> stack trace as unreliable. Once all of the checks are in place, the unwinder
>> can be used for livepatching.
> 
> This assumes all such places are known.  That's a big assumption, as
> 
> a) hand-written asm code may inadvertantly skip frame pointer setup;
> 
> b) for inline asm which calls a function, the compiler may blindly
>    insert it into a function before the frame pointer setup.
> 
> That's where objtool stack validation would come in.
>    

Yes. I meant that the reliable stack trace in the kernel is necessary. I did
not imply that it was sufficient. Clearly, it is not sufficient. It relies
on the frame pointer being setup correctly for all functions. That has to be
guaranteed by another entity such as objtool.

So, I will improve the wording and make it clear in the next version.

>> Detect EL1 exception frame
>> ==========================
>>
>> EL1 exceptions can happen on any instruction including instructions in
>> the frame pointer prolog or epilog. Depending on where exactly they happen,
>> they could render the stack trace unreliable.
>>
>> Add all of the EL1 exception handlers to special_functions[].
>>
>> 	- el1_sync()
>> 	- el1_irq()
>> 	- el1_error()
>> 	- el1_sync_invalid()
>> 	- el1_irq_invalid()
>> 	- el1_fiq_invalid()
>> 	- el1_error_invalid()
> 
> A possibly more robust alternative would be to somehow mark el1
> exception frames so the unwinder can detect them more generally.
> 
> For example, as described in my previous email, encode the frame pointer
> so the unwinder can detect el1 frames automatically.
> 

Encoding the frame pointer by setting the LSB (like X86) was my first solution.
Mark Rutland NAKed it. His objection was that it would confuse the debuggers
which are expecting the last 4 bits of the frame pointer to be 0. I agree with
this objection.

My problem with the encoding was also that it is not possible to know if the
LSB was set because of encoding or because of stack corruption.

My second attempt was to encode the frame pointer indirectly. That is, make
pt_regs->stackframe the exception frame and use other fields in the pt_regs
(including a frame type encoding field) for verification.

Mark Rutland NAKed it. His objection (if I am rephrasing it correctly) was that
garbage on the stack may accidentally match the values the unwinder checks in
the pt_regs (however unlikely that match might be).

The consensus was that the return PC must be checked against special functions
to recognize those special cases as the special functions are only invoked in
those special contexts and nowhere else.

As an aside, Mark Brown suggested (if I recall correctly) that the exception
functions could be placed in a special exception section so the unwinder can
check a return PC against the section bounds instead of individual functions.
I did consider implementing this. But I needed a way to address FTRACE
trampolines and KPROBE trampolines as well. So, I did not do that.


>> Detect ftrace frame
>> ===================
>>
>> When FTRACE executes at the beginning of a traced function, it creates two
>> frames and calls the tracer function:
>>
>> 	- One frame for the traced function
>>
>> 	- One frame for the caller of the traced function
>>
>> That gives a sensible stack trace while executing in the tracer function.
>> When FTRACE returns to the traced function, the frames are popped and
>> everything is back to normal.
>>
>> However, in cases like live patch, the tracer function redirects execution
>> to a different function. When FTRACE returns, control will go to that target
>> function. A stack trace taken in the tracer function will not show the target
>> function. The target function is the real function that we want to track.
>> So, the stack trace is unreliable.
> 
> I don't think this is a real problem.  Livepatch only checks the stacks
> of blocked tasks (and the task calling into livepatch).  So the
> reliability of unwinding from the livepatch tracer function itself
> (klp_ftrace_handler) isn't a concern since it doesn't sleep.
> 

My thinking was - arch_stack_walk_reliable() should provide a reliable stack trace
and not assume anything about its consumers. It should not assume that livepatch is
the only consumer although it might be. 

Theoretically, there can be a tracer function that calls some kernel function F() that
can go to sleep. Is this not allowed?

Or, F() could call arch_stack_walk_reliable() on the current task for debugging
or tracing purposes. It should still work correctly.

>> To detect FTRACE in a stack trace, add the following to special_functions[]:
>>
>> 	- ftrace_graph_call()
>> 	- ftrace_graph_caller()
>>
>> Please see the diff for a comment that explains why ftrace_graph_call()
>> must be checked.
>>
>> Also, the Function Graph Tracer modifies the return address of a traced
>> function to a return trampoline (return_to_handler()) to gather tracing
>> data on function return. Stack traces taken from the traced function and
>> functions it calls will not show the original caller of the traced function.
>> The unwinder handles this case by getting the original caller from FTRACE.
>>
>> However, stack traces taken from the trampoline itself and functions it calls
>> are unreliable as the original return address may not be available in
>> that context. This is because the trampoline calls FTRACE to gather trace
>> data as well as to obtain the actual return address and FTRACE discards the
>> record of the original return address along the way.
> 
> Again, this shouldn't be a concern because livepatch won't be unwinding
> from a function_graph trampoline unless it got preempted somehow (and
> then the el1 frame would get detected anyway).
> 

Please see previous answer.

>> Add return_to_handler() to special_functions[].
>>
>> Check for kretprobe
>> ===================
>>
>> For functions with a kretprobe set up, probe code executes on entry
>> to the function and replaces the return address in the stack frame with a
>> kretprobe trampoline. Whenever the function returns, control is
>> transferred to the trampoline. The trampoline eventually returns to the
>> original return address.
>>
>> A stack trace taken while executing in the function (or in functions that
>> get called from the function) will not show the original return address.
>> Similarly, a stack trace taken while executing in the trampoline itself
>> (and functions that get called from the trampoline) will not show the
>> original return address. This means that the caller of the probed function
>> will not show. This makes the stack trace unreliable.
>>
>> Add the kretprobe trampoline to special_functions[].
>>
>> FYI, each task contains a task->kretprobe_instances list that can
>> theoretically be consulted to find the orginal return address. But I am
>> not entirely sure how to safely traverse that list for stack traces
>> not on the current process. So, I have taken the easy way out.
> 
> For kretprobes, unwinding from the trampoline or kretprobe handler
> shouldn't be a reliability concern for live patching, for similar
> reasons as above.
> 

Please see previous answer.

> Otherwise, when unwinding from a blocked task which has
> 'kretprobe_trampoline' on the stack, the unwinder needs a way to get the
> original return address.  Masami has been working on an interface to
> make that possible for x86.  I assume something similar could be done
> for arm64.
> 

OK. Until that is available, this case needs to be addressed.

Madhavan
