Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003C1345BFC
	for <lists+live-patching@lfdr.de>; Tue, 23 Mar 2021 11:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhCWKfP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Mar 2021 06:35:15 -0400
Received: from foss.arm.com ([217.140.110.172]:43622 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230105AbhCWKe7 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Mar 2021 06:34:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0FB981042;
        Tue, 23 Mar 2021 03:34:59 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D4F203F719;
        Tue, 23 Mar 2021 03:34:56 -0700 (PDT)
Date:   Tue, 23 Mar 2021 10:34:53 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/8] arm64: Implement frame types
Message-ID: <20210323103453.GB95840@C02TD0UTHF1T.local>
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-3-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315165800.5948-3-madvenka@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Mar 15, 2021 at 11:57:54AM -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Apart from the task pt_regs, pt_regs is also created on the stack for other
> other cases:
> 
> 	- EL1 exception. A pt_regs is created on the stack to save register
> 	  state. In addition, pt_regs->stackframe is set up for the
> 	  interrupted kernel function so that the function shows up in the
> 	  EL1 exception stack trace.
> 
> 	- When a traced function calls the ftrace infrastructure at the
> 	  beginning of the function, ftrace creates a pt_regs on the stack
> 	  at that point to save register state. In addition, it sets up
> 	  pt_regs->stackframe for the traced function so that the traced
> 	  function shows up in the stack trace taken from anywhere in the
> 	  ftrace code after that point. When the ftrace code returns to the
> 	  traced function, the pt_regs is removed from the stack.
> 
> To summarize, pt_regs->stackframe is used (or will be used) as a marker
> frame in stack traces. To enable the unwinder to detect these frames, tag
> each pt_regs->stackframe with a type. To record the type, use the unused2
> field in struct pt_regs and rename it to frame_type. The types are:
> 
> TASK_FRAME
> 	Terminating frame for a normal stack trace.
> EL0_FRAME
> 	Terminating frame for an EL0 exception.
> EL1_FRAME
> 	EL1 exception frame.
> FTRACE_FRAME
> 	FTRACE frame.
> 
> These frame types will be used by the unwinder later to validate frames.

I don't think that we need a marker in the pt_regs:

* For kernel tasks and user tasks we just need the terminal frame record
  to be at a known location. We don't need the pt_regs to determine
  this.

* For EL1<->EL1 exception boundaries, we already chain the frame records
  together, and we can identify the entry functions to see that there's
  an exception boundary. We don't need the pt_regs to determine this.

* For ftrace using patchable-function-entry, we can identify the
  trampoline function. I'm also hoping to move away from pt_regs to an
  ftrace_regs here, and I'd like to avoid more strongly coupling this to
  pt_regs.

  Maybe I'm missing something you need for this last case?

> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  arch/arm64/include/asm/ptrace.h | 15 +++++++++++++--
>  arch/arm64/kernel/asm-offsets.c |  1 +
>  arch/arm64/kernel/entry.S       |  4 ++++
>  arch/arm64/kernel/head.S        |  2 ++
>  arch/arm64/kernel/process.c     |  1 +
>  5 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
> index e58bca832dff..a75211ce009a 100644
> --- a/arch/arm64/include/asm/ptrace.h
> +++ b/arch/arm64/include/asm/ptrace.h
> @@ -117,6 +117,17 @@
>   */
>  #define NO_SYSCALL (-1)
>  
> +/*
> + * pt_regs->stackframe is a marker frame that is used in different
> + * situations. These are the different types of frames. Use patterns
> + * for the frame types instead of (0, 1, 2, 3, ..) so that it is less
> + * likely to find them on the stack.
> + */
> +#define TASK_FRAME	0xDEADBEE0	/* Task stack termination frame */
> +#define EL0_FRAME	0xDEADBEE1	/* EL0 exception frame */
> +#define EL1_FRAME	0xDEADBEE2	/* EL1 exception frame */
> +#define FTRACE_FRAME	0xDEADBEE3	/* FTrace frame */

This sounds like we're using this as a heuristic, which I don't think we
should do. I'd strongly prefr to avoid magic valuess here, and if we
cannot be 100% certain of the stack contents, this is not reliable
anyway.

Thanks,
Mark.

>  #ifndef __ASSEMBLY__
>  #include <linux/bug.h>
>  #include <linux/types.h>
> @@ -187,11 +198,11 @@ struct pt_regs {
>  	};
>  	u64 orig_x0;
>  #ifdef __AARCH64EB__
> -	u32 unused2;
> +	u32 frame_type;
>  	s32 syscallno;
>  #else
>  	s32 syscallno;
> -	u32 unused2;
> +	u32 frame_type;
>  #endif
>  	u64 sdei_ttbr1;
>  	/* Only valid when ARM64_HAS_IRQ_PRIO_MASKING is enabled. */
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index a36e2fc330d4..43f97dbc7dfc 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -75,6 +75,7 @@ int main(void)
>    DEFINE(S_SDEI_TTBR1,		offsetof(struct pt_regs, sdei_ttbr1));
>    DEFINE(S_PMR_SAVE,		offsetof(struct pt_regs, pmr_save));
>    DEFINE(S_STACKFRAME,		offsetof(struct pt_regs, stackframe));
> +  DEFINE(S_FRAME_TYPE,		offsetof(struct pt_regs, frame_type));
>    DEFINE(PT_REGS_SIZE,		sizeof(struct pt_regs));
>    BLANK();
>  #ifdef CONFIG_COMPAT
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index e2dc2e998934..ecc3507d9cdd 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -269,8 +269,12 @@ alternative_else_nop_endif
>  	 */
>  	.if \el == 0
>  	stp	xzr, xzr, [sp, #S_STACKFRAME]
> +	ldr	w17, =EL0_FRAME
> +	str	w17, [sp, #S_FRAME_TYPE]
>  	.else
>  	stp	x29, x22, [sp, #S_STACKFRAME]
> +	ldr	w17, =EL1_FRAME
> +	str	w17, [sp, #S_FRAME_TYPE]
>  	.endif
>  	add	x29, sp, #S_STACKFRAME
>  
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 2769b20934d4..d2ee78f8f97f 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -410,6 +410,8 @@ SYM_FUNC_END(__create_page_tables)
>  	 */
>  	.macro setup_last_frame
>  	sub	sp, sp, #PT_REGS_SIZE
> +	ldr	w17, =TASK_FRAME
> +	str	w17, [sp, #S_FRAME_TYPE]
>  	stp	xzr, xzr, [sp, #S_STACKFRAME]
>  	add	x29, sp, #S_STACKFRAME
>  	ldr	x30, =ret_from_fork
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 7ffa689e8b60..5c152fd60503 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -442,6 +442,7 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
>  	 * as the last frame for the new task.
>  	 */
>  	p->thread.cpu_context.fp = (unsigned long)childregs->stackframe;
> +	childregs->frame_type = TASK_FRAME;
>  
>  	ptrace_hw_copy_thread(p);
>  
> -- 
> 2.25.1
> 
