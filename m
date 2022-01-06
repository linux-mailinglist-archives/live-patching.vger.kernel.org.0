Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8090F486766
	for <lists+live-patching@lfdr.de>; Thu,  6 Jan 2022 17:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240899AbiAFQK1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 Jan 2022 11:10:27 -0500
Received: from foss.arm.com ([217.140.110.172]:56048 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240960AbiAFQK1 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 Jan 2022 11:10:27 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B7A313D5;
        Thu,  6 Jan 2022 08:10:26 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.10.56])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 930153F5A1;
        Thu,  6 Jan 2022 08:10:24 -0800 (PST)
Date:   Thu, 6 Jan 2022 16:10:20 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 02/10] arm64: Rename unwinder functions
Message-ID: <YdcUbJoz9LwDboGJ@FVFF77S0Q05N>
References: <0d0eb36f348fb5a6af6eb592c0525f6e94007328>
 <20220103165212.9303-1-madvenka@linux.microsoft.com>
 <20220103165212.9303-3-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103165212.9303-3-madvenka@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Jan 03, 2022 at 10:52:04AM -0600, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Rename unwinder functions for consistency and better naming.
> 
> 	- Rename start_backtrace() to unwind_init().
> 	- Rename unwind_frame() to unwind_next().
> 	- Rename walk_stackframe() to unwind().
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Acked-by: Mark Rutland <mark.rutland@arm.com>

For consistency, to replace my prior Acked-by:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/kernel/stacktrace.c | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index 5f5bb35b7b41..b980d96dccfc 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -33,8 +33,8 @@
>   */
>  
>  
> -static void start_backtrace(struct stackframe *frame, unsigned long fp,
> -			    unsigned long pc)
> +static void unwind_init(struct stackframe *frame, unsigned long fp,
> +			unsigned long pc)
>  {
>  	frame->fp = fp;
>  	frame->pc = pc;
> @@ -45,7 +45,7 @@ static void start_backtrace(struct stackframe *frame, unsigned long fp,
>  	/*
>  	 * Prime the first unwind.
>  	 *
> -	 * In unwind_frame() we'll check that the FP points to a valid stack,
> +	 * In unwind_next() we'll check that the FP points to a valid stack,
>  	 * which can't be STACK_TYPE_UNKNOWN, and the first unwind will be
>  	 * treated as a transition to whichever stack that happens to be. The
>  	 * prev_fp value won't be used, but we set it to 0 such that it is
> @@ -63,8 +63,8 @@ static void start_backtrace(struct stackframe *frame, unsigned long fp,
>   * records (e.g. a cycle), determined based on the location and fp value of A
>   * and the location (but not the fp value) of B.
>   */
> -static int notrace unwind_frame(struct task_struct *tsk,
> -				struct stackframe *frame)
> +static int notrace unwind_next(struct task_struct *tsk,
> +			       struct stackframe *frame)
>  {
>  	unsigned long fp = frame->fp;
>  	struct stack_info info;
> @@ -104,7 +104,7 @@ static int notrace unwind_frame(struct task_struct *tsk,
>  
>  	/*
>  	 * Record this frame record's values and location. The prev_fp and
> -	 * prev_type are only meaningful to the next unwind_frame() invocation.
> +	 * prev_type are only meaningful to the next unwind_next() invocation.
>  	 */
>  	frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp));
>  	frame->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp + 8));
> @@ -137,23 +137,23 @@ static int notrace unwind_frame(struct task_struct *tsk,
>  
>  	return 0;
>  }
> -NOKPROBE_SYMBOL(unwind_frame);
> +NOKPROBE_SYMBOL(unwind_next);
>  
> -static void notrace walk_stackframe(struct task_struct *tsk,
> -				    struct stackframe *frame,
> -				    bool (*fn)(void *, unsigned long), void *data)
> +static void notrace unwind(struct task_struct *tsk,
> +			   struct stackframe *frame,
> +			   bool (*fn)(void *, unsigned long), void *data)
>  {
>  	while (1) {
>  		int ret;
>  
>  		if (!fn(data, frame->pc))
>  			break;
> -		ret = unwind_frame(tsk, frame);
> +		ret = unwind_next(tsk, frame);
>  		if (ret < 0)
>  			break;
>  	}
>  }
> -NOKPROBE_SYMBOL(walk_stackframe);
> +NOKPROBE_SYMBOL(unwind);
>  
>  static bool dump_backtrace_entry(void *arg, unsigned long where)
>  {
> @@ -195,14 +195,14 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
>  	struct stackframe frame;
>  
>  	if (regs)
> -		start_backtrace(&frame, regs->regs[29], regs->pc);
> +		unwind_init(&frame, regs->regs[29], regs->pc);
>  	else if (task == current)
> -		start_backtrace(&frame,
> +		unwind_init(&frame,
>  				(unsigned long)__builtin_frame_address(1),
>  				(unsigned long)__builtin_return_address(0));
>  	else
> -		start_backtrace(&frame, thread_saved_fp(task),
> +		unwind_init(&frame, thread_saved_fp(task),
>  				thread_saved_pc(task));
>  
> -	walk_stackframe(task, &frame, consume_entry, cookie);
> +	unwind(task, &frame, consume_entry, cookie);
>  }
> -- 
> 2.25.1
> 
