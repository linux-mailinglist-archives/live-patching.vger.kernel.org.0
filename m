Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248613B31A0
	for <lists+live-patching@lfdr.de>; Thu, 24 Jun 2021 16:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhFXOmz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 24 Jun 2021 10:42:55 -0400
Received: from foss.arm.com ([217.140.110.172]:59460 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232273AbhFXOmu (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 24 Jun 2021 10:42:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B995ED1;
        Thu, 24 Jun 2021 07:40:31 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.9.157])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C66D43F718;
        Thu, 24 Jun 2021 07:40:28 -0700 (PDT)
Date:   Thu, 24 Jun 2021 15:40:21 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v5 1/2] arm64: Introduce stack trace reliability
 checks in the unwinder
Message-ID: <20210624144021.GA17937@C02TD0UTHF1T.local>
References: <ea0ef9ed6eb34618bcf468fbbf8bdba99e15df7d>
 <20210526214917.20099-1-madvenka@linux.microsoft.com>
 <20210526214917.20099-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526214917.20099-2-madvenka@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Madhavan,

On Wed, May 26, 2021 at 04:49:16PM -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> The unwinder should check for the presence of various features and
> conditions that can render the stack trace unreliable and mark the
> the stack trace as unreliable for the benefit of the caller.
> 
> Introduce the first reliability check - If a return PC is not a valid
> kernel text address, consider the stack trace unreliable. It could be
> some generated code.
> 
> Other reliability checks will be added in the future.
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>

At a high-level, I'm on-board with keeping track of this per unwind
step, but if we do that then I want to be abel to use this during
regular unwinds (e.g. so that we can have a backtrace idicate when a
step is not reliable, like x86 does with '?'), and to do that we need to
be a little more accurate.

I think we first need to do some more preparatory work for that, but
regardless, I have some comments below.

> ---
>  arch/arm64/include/asm/stacktrace.h |  9 +++++++
>  arch/arm64/kernel/stacktrace.c      | 38 +++++++++++++++++++++++++----
>  2 files changed, 42 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
> index eb29b1fe8255..4c822ef7f588 100644
> --- a/arch/arm64/include/asm/stacktrace.h
> +++ b/arch/arm64/include/asm/stacktrace.h
> @@ -49,6 +49,13 @@ struct stack_info {
>   *
>   * @graph:       When FUNCTION_GRAPH_TRACER is selected, holds the index of a
>   *               replacement lr value in the ftrace graph stack.
> + *
> + * @reliable:	Is this stack frame reliable? There are several checks that
> + *              need to be performed in unwind_frame() before a stack frame
> + *              is truly reliable. Until all the checks are present, this flag
> + *              is just a place holder. Once all the checks are implemented,
> + *              this comment will be updated and the flag can be used by the
> + *              caller of unwind_frame().

I'd prefer that we state the high-level semantic first, then drill down
into detail, e.g.

| @reliable: Indicates whether this frame is beleived to be a reliable
|            unwinding from the parent stackframe. This may be set
|            regardless of whether the parent stackframe was reliable.
|            
|            This is set only if all the following are true:
| 
|            * @pc is a valid text address.
| 
|            Note: this is currently incomplete.

>   */
>  struct stackframe {
>  	unsigned long fp;
> @@ -59,6 +66,7 @@ struct stackframe {
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  	int graph;
>  #endif
> +	bool reliable;
>  };
>  
>  extern int unwind_frame(struct task_struct *tsk, struct stackframe *frame);
> @@ -169,6 +177,7 @@ static inline void start_backtrace(struct stackframe *frame,
>  	bitmap_zero(frame->stacks_done, __NR_STACK_TYPES);
>  	frame->prev_fp = 0;
>  	frame->prev_type = STACK_TYPE_UNKNOWN;
> +	frame->reliable = true;
>  }

I think we need more data than this to be accurate.

Consider arch_stack_walk() starting from a pt_regs -- the initial state
(the PC from the regs) is accurate, but the first unwind from that will
not be, and we don't account for that at all.

I think we need to capture an unwind type in struct stackframe, which we
can pass into start_backtrace(), e.g.

| enum unwind_type {
|         /*
|          * The next frame is indicated by the frame pointer.
|          * The next unwind may or may not be reliable.
|          */
|         UNWIND_TYPE_FP,
| 
|         /*
|          * The next frame is indicated by the LR in pt_regs.
|          * The next unwind is not reliable.
|          */
|         UNWIND_TYPE_REGS_LR,
| 
|         /*
|          * We do not know how to unwind to the next frame.
|          * The next unwind is not reliable.
|          */
|         UNWIND_TYPE_UNKNOWN
| };

That should be simple enough to set up around start_backtrace(), but
we'll need further rework to make that simple at exception boundaries.
With the entry rework I have queued for v5.14, we're *almost* down to a
single asm<->c transition point for all vectors, and I'm hoping to
factor the remainder out to C for v5.15, whereupon we can annotate that
BL with some metadata for unwinding (with something similar to x86's
UNWIND_HINT, but retained for runtime).

>  
>  #endif	/* __ASM_STACKTRACE_H */
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index d55bdfb7789c..9061375c8785 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -44,21 +44,29 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>  	unsigned long fp = frame->fp;
>  	struct stack_info info;
>  
> +	frame->reliable = true;

I'd prefer to do this the other way around, e.g. here do:

|        /*
|         * Assume that an unwind step is unreliable until it has passed
|         * all relevant checks.
|         */
|        frame->reliable = false;

... then only set this to true once we're certain the step is reliable.

That requires fewer changes below, and would also be more robust as if
we forget to update this we'd accidentally mark an entry as unreliable
rather than accidentally marking it as reliable.

> +
>  	/* Terminal record; nothing to unwind */
>  	if (!fp)
>  		return -ENOENT;
>  
> -	if (fp & 0xf)
> +	if (fp & 0xf) {
> +		frame->reliable = false;
>  		return -EINVAL;
> +	}
>  
>  	if (!tsk)
>  		tsk = current;
>  
> -	if (!on_accessible_stack(tsk, fp, &info))
> +	if (!on_accessible_stack(tsk, fp, &info)) {
> +		frame->reliable = false;
>  		return -EINVAL;
> +	}
>  
> -	if (test_bit(info.type, frame->stacks_done))
> +	if (test_bit(info.type, frame->stacks_done)) {
> +		frame->reliable = false;
>  		return -EINVAL;
> +	}
>  
>  	/*
>  	 * As stacks grow downward, any valid record on the same stack must be
> @@ -74,8 +82,10 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>  	 * stack.
>  	 */
>  	if (info.type == frame->prev_type) {
> -		if (fp <= frame->prev_fp)
> +		if (fp <= frame->prev_fp) {
> +			frame->reliable = false;
>  			return -EINVAL;
> +		}
>  	} else {
>  		set_bit(frame->prev_type, frame->stacks_done);
>  	}
> @@ -100,14 +110,32 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>  		 * So replace it to an original value.
>  		 */
>  		ret_stack = ftrace_graph_get_ret_stack(tsk, frame->graph++);
> -		if (WARN_ON_ONCE(!ret_stack))
> +		if (WARN_ON_ONCE(!ret_stack)) {
> +			frame->reliable = false;
>  			return -EINVAL;
> +		}
>  		frame->pc = ret_stack->ret;
>  	}
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>  
>  	frame->pc = ptrauth_strip_insn_pac(frame->pc);
>  
> +	/*
> +	 * Check the return PC for conditions that make unwinding unreliable.
> +	 * In each case, mark the stack trace as such.
> +	 */
> +
> +	/*
> +	 * Make sure that the return address is a proper kernel text address.
> +	 * A NULL or invalid return address could mean:
> +	 *
> +	 *	- generated code such as eBPF and optprobe trampolines
> +	 *	- Foreign code (e.g. EFI runtime services)
> +	 *	- Procedure Linkage Table (PLT) entries and veneer functions
> +	 */
> +	if (!__kernel_text_address(frame->pc))
> +		frame->reliable = false;

I don't think we should mention PLTs here. They appear in regular kernel
text, and on arm64 they are generally not problematic for unwinding. The
case in which they are problematic are where they interpose an
trampoline call that isn't following the AAPCS (e.g. ftrace calls from a
module, or calls to __hwasan_tag_mismatch generally), and we'll have to
catch those explciitly (or forbid RELIABLE_STACKTRACE with HWASAN).

From a backtrace perspective, the PC itself *is* reliable, but the next
unwind from this frame will not be, so I'd like to mark this as
reliable and the next unwind as unreliable. We can do that with the
UNWIND_TYPE_UNKNOWN suggestion above.

For the comment here, how about:

|	/*
|	 * If the PC is not a known kernel text address, then we cannot
|	 * be sure that a subsequent unwind will be reliable, as we
|	 * don't know that the code follows our unwind requirements.
|	 */
|	if (!__kernel_text_address(frame-pc))
|		frame->unwind = UNWIND_TYPE_UNKNOWN;

Thanks,
Mark.

>  	return 0;
>  }
>  NOKPROBE_SYMBOL(unwind_frame);
> -- 
> 2.25.1
> 
