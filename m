Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0AAD35A47C
	for <lists+live-patching@lfdr.de>; Fri,  9 Apr 2021 19:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhDIRQl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Apr 2021 13:16:41 -0400
Received: from linux.microsoft.com ([13.77.154.182]:51908 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbhDIRQl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Apr 2021 13:16:41 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9C0EC20B5680;
        Fri,  9 Apr 2021 10:16:27 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9C0EC20B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617988588;
        bh=h9fMPaa5KBNO9xHno0s8hjp9DHusfWBXY0tJ7kmUvbg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=GohQZhpvy8G4bRIKWR7/1WECQjA6l2yFSHfAVB6ofH5YRhVnBWYBJTc1altN46rP3
         /9ZoL9evDCK045GA0nktNs3PNzeTDKedJep8iRsAHFW/iuQw0oBGyNfQJkTjFByGzh
         yBTcrGTG4Y4h5qwf4tUiNvlca7rkQ0tpTJGTwEn8=
Subject: Re: [RFC PATCH v2 0/4] arm64: Implement stack trace reliability
 checks
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210409120859.GA51636@C02TD0UTHF1T.local>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <cb594cb0-f2e7-887e-e454-03971cfcbc53@linux.microsoft.com>
Date:   Fri, 9 Apr 2021 12:16:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210409120859.GA51636@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/9/21 7:09 AM, Mark Rutland wrote:
> Hi Madhavan,
> 
> I've noted some concerns below. At a high-level, I'm not keen on the
> blacklisting approach, and I think there's some other preparatory work
> that would be more valuable in the short term.
> 

Some kind of blacklisting has to be done whichever way you do it.

> On Mon, Apr 05, 2021 at 03:43:09PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> There are a number of places in kernel code where the stack trace is not
>> reliable. Enhance the unwinder to check for those cases and mark the
>> stack trace as unreliable. Once all of the checks are in place, the unwinder
>> can provide a reliable stack trace. But before this can be used for livepatch,
>> some other entity needs to guarantee that the frame pointers are all set up
>> correctly in kernel functions. objtool is currently being worked on to
>> fill that gap.
>>
>> Except for the return address check, all the other checks involve checking
>> the return PC of every frame against certain kernel functions. To do this,
>> implement some infrastructure code:
>>
>> 	- Define a special_functions[] array and populate the array with
>> 	  the special functions
> 
> I'm not too keen on having to manually collate this within the unwinder,
> as it's very painful from a maintenance perspective. I'd much rather we
> could associate this information with the implementations of these
> functions, so that they're more likely to stay in sync.
> 
> Further, I believe all the special cases are assembly functions, and
> most of those are already in special sections to begin with. I reckon
> it'd be simpler and more robust to reject unwinding based on the
> section. If we need to unwind across specific functions in those
> sections, we could opt-in with some metadata. So e.g. we could reject
> all functions in ".entry.text", special casing the EL0 entry functions
> if necessary.
> 

Yes. I have already agreed that using sections is the way to go. I am working
on that now.

> As I mentioned before, I'm currently reworking the entry assembly to
> make this simpler to do. I'd prefer to not make invasive changes in that
> area until that's sorted.
> 

I don't plan to make any invasive changes. But a couple of cosmetic changes may be
necessary. I don't know yet. But I will keep in mind that you don't want
any invasive changes there.

> I think there's a lot more code that we cannot unwind, e.g. KVM
> exception code, or almost anything marked with SYM_CODE_END().
> 

As Mark Brown suggested, I will take a look at all code that is marked as
SYM_CODE. His idea of placing all SYM_CODE in a separate section and blacklisting
that to begin with and refining things as we go along appears to me to be
a reasonable approach.

>> 	- Using kallsyms_lookup(), lookup the symbol table entries for the
>> 	  functions and record their address ranges
>>
>> 	- Define an is_reliable_function(pc) to match a return PC against
>> 	  the special functions.
>>
>> The unwinder calls is_reliable_function(pc) for every return PC and marks
>> the stack trace as reliable or unreliable accordingly.
>>
>> Return address check
>> ====================
>>
>> Check the return PC of every stack frame to make sure that it is a valid
>> kernel text address (and not some generated code, for example).
>>
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
>>
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
> This doesn't match my understanding of the reliable stacktrace
> requirements, but I might have misunderstood what you're saying here.
> 
> IIUC what you're describing here is:
> 
> 1) A calls B
> 2) B is traced
> 3) tracer replaces B with TARGET
> 4) tracer returns to TARGET
> 
> ... and if a stacktrace is taken at step 3 (before the return address is
> patched), the trace will show B rather than TARGET.
> 
> My understanding is that this is legitimate behaviour.
> 

My understanding is as follows (correct me if I am wrong):

- Before B is traced, the situation is "A calls B".

- A trace is placed on B to redirect execution to TARGET. Semantically, it
  becomes "A calls TARGET" beyond that point and B is irrelevant.

- But temporarily, the stack trace will show A -> B.

>> To detect stack traces from a tracer function, add the following to
>> special_functions[]:
>>
>> 	- ftrace_call + 4
>>
>> ftrace_call is the label at which the tracer function is patched in. So,
>> ftrace_call + 4 is its return address. This is what will show up in a
>> stack trace taken from the tracer function.
>>
>> When Function Graph Tracing is on, ftrace_graph_caller is patched in
>> at the label ftrace_graph_call. If a tracer function called before it has
>> redirected execution as mentioned above, the stack traces taken from within
>> ftrace_graph_caller will also be unreliable for the same reason as mentioned
>> above. So, add ftrace_graph_caller to special_functions[] as well.
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
> The reason we cannot unwind the trampolines in the usual way is because
> they are not AAPCS compliant functions. We don't discard the original
> return address, but it's not in the usual location.  With care, we could
> write a special case unwinder for them. Note that we also cannot unwind
> from any PLT on the way to the trampolines, so we'd also need to
> identify those.  Luckily we're in charge of creating those, and (for
> now) we only need to care about the module PLTs.
> 
> The bigger problem is return_to_handler, since there's a transient
> period when C code removes the return address from the graph return
> stack before passing this to assembly in a register, and so we can't
> reliably find the correct return address during this period. With care
> we could special case unwinding immediately before/after this.
> 

This is what I meant when I said "as the original return address may not be available in
that context" because the original address is popped off the return address stack
by the ftrace code called from the trampoline.

> If we could find a way to restructure return_to_handler such that we can
> reliably find the correct return address, that would be a useful
> improvement today, and would mean that we don't have to blacklist it for
> reliable stacktrace.
> 

Agreed. But until then it needs to be blacklisted. Rather than wait for that restructuring
to be done, we could initially blacklist it and remove the blacklist if and when the
restructuring is done.

Thanks.

Madhavan
