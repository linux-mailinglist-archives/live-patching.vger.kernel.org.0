Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83D03B46C8
	for <lists+live-patching@lfdr.de>; Fri, 25 Jun 2021 17:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhFYPmU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 25 Jun 2021 11:42:20 -0400
Received: from linux.microsoft.com ([13.77.154.182]:57740 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhFYPmT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 25 Jun 2021 11:42:19 -0400
Received: from [192.168.254.32] (unknown [47.187.214.213])
        by linux.microsoft.com (Postfix) with ESMTPSA id 04A4520B6AEE;
        Fri, 25 Jun 2021 08:39:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 04A4520B6AEE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1624635598;
        bh=Y3MPpZKtv1ipxwuJAGpm6jZtoc/HHzFRO8RXYkmPXUE=;
        h=From:Subject:To:Cc:References:Date:In-Reply-To:From;
        b=dm5UQHUsLdzrzZLstgnq8fr1wp0xc+OmmRs7iInjHqf/lX2OwqYGBrTuaq465RNR7
         AXerbkOlqMB79WC5yWxH87e5YifqcF5x4aeitz3NRk8gyYyKlfTFMc3u9inAhpQhwV
         8oMeUMC+eXR19PigHuAU55J3hTpDkCzxJV2WvsRw=
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Subject: Re: [RFC PATCH v5 1/2] arm64: Introduce stack trace reliability
 checks in the unwinder
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ea0ef9ed6eb34618bcf468fbbf8bdba99e15df7d>
 <20210526214917.20099-1-madvenka@linux.microsoft.com>
 <20210526214917.20099-2-madvenka@linux.microsoft.com>
 <20210624144021.GA17937@C02TD0UTHF1T.local>
Message-ID: <da0a2d95-a8cd-7b39-7bba-41cfa8782eaa@linux.microsoft.com>
Date:   Fri, 25 Jun 2021 10:39:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210624144021.GA17937@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 6/24/21 9:40 AM, Mark Rutland wrote:
> Hi Madhavan,
> 
> On Wed, May 26, 2021 at 04:49:16PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> The unwinder should check for the presence of various features and
>> conditions that can render the stack trace unreliable and mark the
>> the stack trace as unreliable for the benefit of the caller.
>>
>> Introduce the first reliability check - If a return PC is not a valid
>> kernel text address, consider the stack trace unreliable. It could be
>> some generated code.
>>
>> Other reliability checks will be added in the future.
>>
>> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> 
> At a high-level, I'm on-board with keeping track of this per unwind
> step, but if we do that then I want to be abel to use this during
> regular unwinds (e.g. so that we can have a backtrace idicate when a
> step is not reliable, like x86 does with '?'), and to do that we need to
> be a little more accurate.
> 

The only consumer of frame->reliable is livepatch. So, in retrospect, my
original per-frame reliability flag was an overkill. I was just trying to
provide extra per-frame debug information which is not really a requirement
for livepatch.

So, let us separate the two. I will rename frame->reliable to frame->livepatch_safe.
This will apply to the whole stacktrace and not to every frame.

Pass a livepatch_safe flag to start_backtrace(). This will be the initial value
of frame->livepatch_safe. So, if the caller knows that the starting frame is
unreliable, he can pass "false" to start_backtrace().

Whenever a reliability check fails, frame->livepatch_safe = false. After that
point, it will remain false till the end of the stacktrace. This keeps it simple.

Also, once livepatch_safe is set to false, further reliability checks will not
be performed (what would be the point?).

Finally, it might be a good idea to perform reliability checks even in
start_backtrace() so we don't assume that the starting frame is reliable even
if the caller passes livepatch_safe=true. What do you think?

> I think we first need to do some more preparatory work for that, but
> regardless, I have some comments below.
> 

I agree that some more work is required to provide per-frame debug information
and tracking. That can be done later. It is not a requirement for livepatch.

>> ---
>>  arch/arm64/include/asm/stacktrace.h |  9 +++++++
>>  arch/arm64/kernel/stacktrace.c      | 38 +++++++++++++++++++++++++----
>>  2 files changed, 42 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
>> index eb29b1fe8255..4c822ef7f588 100644
>> --- a/arch/arm64/include/asm/stacktrace.h
>> +++ b/arch/arm64/include/asm/stacktrace.h
>> @@ -49,6 +49,13 @@ struct stack_info {
>>   *
>>   * @graph:       When FUNCTION_GRAPH_TRACER is selected, holds the index of a
>>   *               replacement lr value in the ftrace graph stack.
>> + *
>> + * @reliable:	Is this stack frame reliable? There are several checks that
>> + *              need to be performed in unwind_frame() before a stack frame
>> + *              is truly reliable. Until all the checks are present, this flag
>> + *              is just a place holder. Once all the checks are implemented,
>> + *              this comment will be updated and the flag can be used by the
>> + *              caller of unwind_frame().
> 
> I'd prefer that we state the high-level semantic first, then drill down
> into detail, e.g.
> 
> | @reliable: Indicates whether this frame is beleived to be a reliable
> |            unwinding from the parent stackframe. This may be set
> |            regardless of whether the parent stackframe was reliable.
> |            
> |            This is set only if all the following are true:
> | 
> |            * @pc is a valid text address.
> | 
> |            Note: this is currently incomplete.
> 

I will change the name of the flag. I will change the comment accordingly.

>>   */
>>  struct stackframe {
>>  	unsigned long fp;
>> @@ -59,6 +66,7 @@ struct stackframe {
>>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>>  	int graph;
>>  #endif
>> +	bool reliable;
>>  };
>>  
>>  extern int unwind_frame(struct task_struct *tsk, struct stackframe *frame);
>> @@ -169,6 +177,7 @@ static inline void start_backtrace(struct stackframe *frame,
>>  	bitmap_zero(frame->stacks_done, __NR_STACK_TYPES);
>>  	frame->prev_fp = 0;
>>  	frame->prev_type = STACK_TYPE_UNKNOWN;
>> +	frame->reliable = true;
>>  }
> 
> I think we need more data than this to be accurate.
> 
> Consider arch_stack_walk() starting from a pt_regs -- the initial state
> (the PC from the regs) is accurate, but the first unwind from that will
> not be, and we don't account for that at all.
> 
> I think we need to capture an unwind type in struct stackframe, which we
> can pass into start_backtrace(), e.g.
> 

> | enum unwind_type {
> |         /*
> |          * The next frame is indicated by the frame pointer.
> |          * The next unwind may or may not be reliable.
> |          */
> |         UNWIND_TYPE_FP,
> | 
> |         /*
> |          * The next frame is indicated by the LR in pt_regs.
> |          * The next unwind is not reliable.
> |          */
> |         UNWIND_TYPE_REGS_LR,
> | 
> |         /*
> |          * We do not know how to unwind to the next frame.
> |          * The next unwind is not reliable.
> |          */
> |         UNWIND_TYPE_UNKNOWN
> | };
> 
> That should be simple enough to set up around start_backtrace(), but
> we'll need further rework to make that simple at exception boundaries.
> With the entry rework I have queued for v5.14, we're *almost* down to a
> single asm<->c transition point for all vectors, and I'm hoping to
> factor the remainder out to C for v5.15, whereupon we can annotate that
> BL with some metadata for unwinding (with something similar to x86's
> UNWIND_HINT, but retained for runtime).
> 

I understood UNWIND_TYPE_FP and UNWIND_TYPE_REGS_LR. When would UNWIND_TYPE_UNKNOWN
be passed to start_backtrace? Could you elaborate?

Regardless, the above comment applies only to per-frame tracking when it is eventually
implemented. For livepatch, it is not needed. At exception boundaries, if stack metadata
is available, then use that to unwind safely. Else, livepatch_safe = false. The latter
is what is being done in my patch series. So, we can go with that until stack metadata
becomes available.

For the UNWIND_TYPE_REGS_LR and UNWIND_TYPE_UNKNOWN cases, the caller will
pass livepatch_safe=false to start_backtrace(). For UNWIND_TYPE_FP, the caller will
pass livepatch_safe=true. So, only UNWIND_TYPE_FP matters for livepatch.

>>  
>>  #endif	/* __ASM_STACKTRACE_H */
>> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
>> index d55bdfb7789c..9061375c8785 100644
>> --- a/arch/arm64/kernel/stacktrace.c
>> +++ b/arch/arm64/kernel/stacktrace.c
>> @@ -44,21 +44,29 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>>  	unsigned long fp = frame->fp;
>>  	struct stack_info info;
>>  
>> +	frame->reliable = true;
> 
> I'd prefer to do this the other way around, e.g. here do:
> 
> |        /*
> |         * Assume that an unwind step is unreliable until it has passed
> |         * all relevant checks.
> |         */
> |        frame->reliable = false;
> 
> ... then only set this to true once we're certain the step is reliable.
> 
> That requires fewer changes below, and would also be more robust as if
> we forget to update this we'd accidentally mark an entry as unreliable
> rather than accidentally marking it as reliable.
> 

For livepatch_safe, the initial statement setting it to true at the
beginning of unwind_frame() goes away. But whenever a reliability check fails,
livepatch_safe has to be set to false.

>> +
>>  	/* Terminal record; nothing to unwind */
>>  	if (!fp)
>>  		return -ENOENT;
>>  
>> -	if (fp & 0xf)
>> +	if (fp & 0xf) {
>> +		frame->reliable = false;
>>  		return -EINVAL;
>> +	}
>>  
>>  	if (!tsk)
>>  		tsk = current;
>>  
>> -	if (!on_accessible_stack(tsk, fp, &info))
>> +	if (!on_accessible_stack(tsk, fp, &info)) {
>> +		frame->reliable = false;
>>  		return -EINVAL;
>> +	}
>>  
>> -	if (test_bit(info.type, frame->stacks_done))
>> +	if (test_bit(info.type, frame->stacks_done)) {
>> +		frame->reliable = false;
>>  		return -EINVAL;
>> +	}
>>  
>>  	/*
>>  	 * As stacks grow downward, any valid record on the same stack must be
>> @@ -74,8 +82,10 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>>  	 * stack.
>>  	 */
>>  	if (info.type == frame->prev_type) {
>> -		if (fp <= frame->prev_fp)
>> +		if (fp <= frame->prev_fp) {
>> +			frame->reliable = false;
>>  			return -EINVAL;
>> +		}
>>  	} else {
>>  		set_bit(frame->prev_type, frame->stacks_done);
>>  	}
>> @@ -100,14 +110,32 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>>  		 * So replace it to an original value.
>>  		 */
>>  		ret_stack = ftrace_graph_get_ret_stack(tsk, frame->graph++);
>> -		if (WARN_ON_ONCE(!ret_stack))
>> +		if (WARN_ON_ONCE(!ret_stack)) {
>> +			frame->reliable = false;
>>  			return -EINVAL;
>> +		}
>>  		frame->pc = ret_stack->ret;
>>  	}
>>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>>  
>>  	frame->pc = ptrauth_strip_insn_pac(frame->pc);
>>  
>> +	/*
>> +	 * Check the return PC for conditions that make unwinding unreliable.
>> +	 * In each case, mark the stack trace as such.
>> +	 */
>> +
>> +	/*
>> +	 * Make sure that the return address is a proper kernel text address.
>> +	 * A NULL or invalid return address could mean:
>> +	 *
>> +	 *	- generated code such as eBPF and optprobe trampolines
>> +	 *	- Foreign code (e.g. EFI runtime services)
>> +	 *	- Procedure Linkage Table (PLT) entries and veneer functions
>> +	 */
>> +	if (!__kernel_text_address(frame->pc))
>> +		frame->reliable = false;
> 
> I don't think we should mention PLTs here. They appear in regular kernel
> text, and on arm64 they are generally not problematic for unwinding. The
> case in which they are problematic are where they interpose an
> trampoline call that isn't following the AAPCS (e.g. ftrace calls from a
> module, or calls to __hwasan_tag_mismatch generally), and we'll have to
> catch those explciitly (or forbid RELIABLE_STACKTRACE with HWASAN).
> 

I will remove the mention of PLTs.

>>From a backtrace perspective, the PC itself *is* reliable, but the next
> unwind from this frame will not be, so I'd like to mark this as
> reliable and the next unwind as unreliable. We can do that with the
> UNWIND_TYPE_UNKNOWN suggestion above.
> 

In the livepatch_safe approach, it can be set to false as soon as the unwinder
realizes that there is unreliability, even if the unreliability is in the next
frame. Actually, this would avoid one extra unwind step for livepatch.

> For the comment here, how about:
> 
> |	/*
> |	 * If the PC is not a known kernel text address, then we cannot
> |	 * be sure that a subsequent unwind will be reliable, as we
> |	 * don't know that the code follows our unwind requirements.
> |	 */
> |	if (!__kernel_text_address(frame-pc))
> |		frame->unwind = UNWIND_TYPE_UNKNOWN;
> 

OK. I can change the comment.

Thanks!

Madhavan
