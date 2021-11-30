Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D52463962
	for <lists+live-patching@lfdr.de>; Tue, 30 Nov 2021 16:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237919AbhK3PLZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Nov 2021 10:11:25 -0500
Received: from foss.arm.com ([217.140.110.172]:40988 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245394AbhK3PJW (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Nov 2021 10:09:22 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E1E9B1063;
        Tue, 30 Nov 2021 07:06:00 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AFFC83F5A1;
        Tue, 30 Nov 2021 07:05:58 -0800 (PST)
Date:   Tue, 30 Nov 2021 15:05:48 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 1/5] arm64: Call stack_backtrace() only from within
 walk_stackframe()
Message-ID: <YaY9zLNumYZ1lLkc@FVFF77S0Q05N>
References: <8b861784d85a21a9bf08598938c11aff1b1249b9>
 <20211123193723.12112-1-madvenka@linux.microsoft.com>
 <20211123193723.12112-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123193723.12112-2-madvenka@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Nov 23, 2021 at 01:37:19PM -0600, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Currently, arch_stack_walk() calls start_backtrace() and walk_stackframe()
> separately. There is no need to do that. Instead, call start_backtrace()
> from within walk_stackframe(). In other words, walk_stackframe() is the only
> unwind function a consumer needs to call.
> 
> Currently, the only consumer is arch_stack_walk(). In the future,
> arch_stack_walk_reliable() will be another consumer.
> 
> Currently, there is a check for a NULL task in unwind_frame(). It is not
> needed since all current consumers pass a non-NULL task.

Can you split the NULL check change into a preparatory patch? That change is
fine in isolation (and easier to review/ack), and it's nicer for future
bisection to not group that with unrelated changes.

> Use struct stackframe only within the unwind functions.
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  arch/arm64/kernel/stacktrace.c | 41 ++++++++++++++++++----------------
>  1 file changed, 22 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index 0fb58fed54cb..7217c4f63ef7 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -69,9 +69,6 @@ static int notrace unwind_frame(struct task_struct *tsk,
>  	unsigned long fp = frame->fp;
>  	struct stack_info info;
>  
> -	if (!tsk)
> -		tsk = current;
> -
>  	/* Final frame; nothing to unwind */
>  	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
>  		return -ENOENT;
> @@ -143,15 +140,19 @@ static int notrace unwind_frame(struct task_struct *tsk,
>  NOKPROBE_SYMBOL(unwind_frame);
>  
>  static void notrace walk_stackframe(struct task_struct *tsk,
> -				    struct stackframe *frame,
> +				    unsigned long fp, unsigned long pc,
>  				    bool (*fn)(void *, unsigned long), void *data)
>  {
> +	struct stackframe frame;
> +
> +	start_backtrace(&frame, fp, pc);
> +
>  	while (1) {
>  		int ret;
>  
> -		if (!fn(data, frame->pc))
> +		if (!fn(data, frame.pc))
>  			break;
> -		ret = unwind_frame(tsk, frame);
> +		ret = unwind_frame(tsk, &frame);
>  		if (ret < 0)
>  			break;
>  	}
> @@ -195,17 +196,19 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
>  			      void *cookie, struct task_struct *task,
>  			      struct pt_regs *regs)
>  {
> -	struct stackframe frame;
> -
> -	if (regs)
> -		start_backtrace(&frame, regs->regs[29], regs->pc);
> -	else if (task == current)
> -		start_backtrace(&frame,
> -				(unsigned long)__builtin_frame_address(1),
> -				(unsigned long)__builtin_return_address(0));
> -	else
> -		start_backtrace(&frame, thread_saved_fp(task),
> -				thread_saved_pc(task));
> -
> -	walk_stackframe(task, &frame, consume_entry, cookie);
> +	unsigned long fp, pc;
> +
> +	if (regs) {
> +		fp = regs->regs[29];
> +		pc = regs->pc;
> +	} else if (task == current) {
> +		/* Skip arch_stack_walk() in the stack trace. */
> +		fp = (unsigned long)__builtin_frame_address(1);
> +		pc = (unsigned long)__builtin_return_address(0);
> +	} else {
> +		/* Caller guarantees that the task is not running. */
> +		fp = thread_saved_fp(task);
> +		pc = thread_saved_pc(task);
> +	}
> +	walk_stackframe(task, fp, pc, consume_entry, cookie);

I'd prefer to leave this as-is. The new and old structure are largely
equivalent, so we haven't made this any simpler, but we have added more
arguments to walk_stackframe().

One thing I *would* like to do is move tsk into strcut stackframe, so we only
need to pass that around, which'll make it easier to refactor the core unwind
logic.

Thanks,
Mark.
