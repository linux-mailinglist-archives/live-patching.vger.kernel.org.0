Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8009543D020
	for <lists+live-patching@lfdr.de>; Wed, 27 Oct 2021 19:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236886AbhJ0Rz4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 27 Oct 2021 13:55:56 -0400
Received: from foss.arm.com ([217.140.110.172]:46012 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231252AbhJ0Rz4 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 27 Oct 2021 13:55:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED5E21FB;
        Wed, 27 Oct 2021 10:53:29 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.72.240])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2D85F3F70D;
        Wed, 27 Oct 2021 10:53:28 -0700 (PDT)
Date:   Wed, 27 Oct 2021 18:53:25 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 08/11] arm64: Rename unwinder functions, prevent them
 from being traced and kprobed
Message-ID: <20211027175325.GC58503@C02TD0UTHF1T.local>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-9-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015025847.17694-9-madvenka@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Oct 14, 2021 at 09:58:44PM -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Rename unwinder functions for consistency and better naming.
> 
> 	- Rename start_backtrace() to unwind_start().
> 	- Rename unwind_frame() to unwind_next().
> 	- Rename walk_stackframe() to unwind().

This looks good to me.

Could we split this from the krpbes/tracing changes? I think this stands
on it's own, and (as below) the kprobes/tracing changes need some more
explanation, and would make sense as a separate patch.

> Prevent the following unwinder functions from being traced:
> 
> 	- unwind_start()
> 	- unwind_next()
> 
> 	unwind() is already prevented from being traced.

This could do with an explanation in the commis message as to why we
need to do this. If this is fixing a latent issue, it should be in a
preparatory patch that we can backport.

I dug into this a bit, and from taking a look, we prohibited ftrace in commit:

  0c32706dac1b0a72 ("arm64: stacktrace: avoid tracing arch_stack_walk()")

... which is just one special case of graph return stack unbalancing,
and should be addressed by using HAVE_FUNCTION_GRAPH_RET_ADDR_PTR, so
with the patch making us use HAVE_FUNCTION_GRAPH_RET_ADDR_PTR, that's
no longer necessary.

So we no longer seem to have a specific reason to prohibit ftrace
here.

> Prevent the following unwinder functions from being kprobed:
> 
> 	- unwind_start()
> 
> 	unwind_next() and unwind() are already prevented from being kprobed.

Likewise, I think this needs some explanation. From diggin, we
prohibited kprobes in commit:

  ee07b93e7721ccd5 ("arm64: unwind: Prohibit probing on return_address()")

... and the commit message says we need to do this because this is
(transitively) called by trace_hardirqs_off(), which is kprobes
blacklisted, but doesn't explain the actual problem this results in.

AFAICT x86 directly uses __builtin_return_address() here, but that won't
recover rewritten addresses, which seems like a bug (or at least a
limitation) on x86, assuming I've read that correctly.

Thanks,
Mark.

> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  arch/arm64/kernel/stacktrace.c | 34 +++++++++++++++++++---------------
>  1 file changed, 19 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index 7d32cee9ef4b..f4f3575f71fd 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -33,8 +33,8 @@
>   */
>  
>  
> -static void start_backtrace(struct stackframe *frame, unsigned long fp,
> -			    unsigned long pc)
> +static void notrace unwind_start(struct stackframe *frame, unsigned long fp,
> +				 unsigned long pc)
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
> @@ -56,6 +56,8 @@ static void start_backtrace(struct stackframe *frame, unsigned long fp,
>  	frame->prev_type = STACK_TYPE_UNKNOWN;
>  }
>  
> +NOKPROBE_SYMBOL(unwind_start);
> +
>  /*
>   * Unwind from one frame record (A) to the next frame record (B).
>   *
> @@ -63,8 +65,8 @@ static void start_backtrace(struct stackframe *frame, unsigned long fp,
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
> @@ -104,7 +106,7 @@ static int notrace unwind_frame(struct task_struct *tsk,
>  
>  	/*
>  	 * Record this frame record's values and location. The prev_fp and
> -	 * prev_type are only meaningful to the next unwind_frame() invocation.
> +	 * prev_type are only meaningful to the next unwind_next() invocation.
>  	 */
>  	frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp));
>  	frame->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp + 8));
> @@ -132,28 +134,30 @@ static int notrace unwind_frame(struct task_struct *tsk,
>  
>  	return 0;
>  }
> -NOKPROBE_SYMBOL(unwind_frame);
>  
> -static void notrace walk_stackframe(struct task_struct *tsk,
> -				    unsigned long fp, unsigned long pc,
> -				    bool (*fn)(void *, unsigned long),
> -				    void *data)
> +NOKPROBE_SYMBOL(unwind_next);
> +
> +static void notrace unwind(struct task_struct *tsk,
> +			   unsigned long fp, unsigned long pc,
> +			   bool (*fn)(void *, unsigned long),
> +			   void *data)
>  {
>  	struct stackframe frame;
>  
> -	start_backtrace(&frame, fp, pc);
> +	unwind_start(&frame, fp, pc);
>  
>  	while (1) {
>  		int ret;
>  
>  		if (!fn(data, frame.pc))
>  			break;
> -		ret = unwind_frame(tsk, &frame);
> +		ret = unwind_next(tsk, &frame);
>  		if (ret < 0)
>  			break;
>  	}
>  }
> -NOKPROBE_SYMBOL(walk_stackframe);
> +
> +NOKPROBE_SYMBOL(unwind);
>  
>  static bool dump_backtrace_entry(void *arg, unsigned long where)
>  {
> @@ -208,7 +212,7 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
>  		fp = thread_saved_fp(task);
>  		pc = thread_saved_pc(task);
>  	}
> -	walk_stackframe(task, fp, pc, consume_entry, cookie);
> +	unwind(task, fp, pc, consume_entry, cookie);
>  
>  }
>  
> -- 
> 2.25.1
> 
