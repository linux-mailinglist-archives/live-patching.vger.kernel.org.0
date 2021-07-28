Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F043D9440
	for <lists+live-patching@lfdr.de>; Wed, 28 Jul 2021 19:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhG1RZb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 28 Jul 2021 13:25:31 -0400
Received: from foss.arm.com ([217.140.110.172]:33956 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230434AbhG1RZa (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 28 Jul 2021 13:25:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 03C156D;
        Wed, 28 Jul 2021 10:25:28 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.11.234])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C59933F66F;
        Wed, 28 Jul 2021 10:25:25 -0700 (PDT)
Date:   Wed, 28 Jul 2021 18:25:23 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v6 3/3] arm64: Create a list of SYM_CODE functions,
 check return PC against list
Message-ID: <20210728172523.GB47345@C02TD0UTHF1T.local>
References: <3f2aab69a35c243c5e97f47c4ad84046355f5b90>
 <20210630223356.58714-1-madvenka@linux.microsoft.com>
 <20210630223356.58714-4-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630223356.58714-4-madvenka@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jun 30, 2021 at 05:33:56PM -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> The unwinder should check if the return PC falls in any function that
> is considered unreliable from an unwinding perspective. If it does,
> return UNWIND_CONTINUE_WITH_RISK.
> 
> Function types
> ==============
> 
> The compiler generates code for C functions and assigns the type STT_FUNC
> to them.
> 
> Assembly functions are manually assigned a type:
> 
> 	- STT_FUNC for functions defined with SYM_FUNC*() macros
> 
> 	- STT_NONE for functions defined with SYM_CODE*() macros
> 
> In the future, STT_FUNC functions will be analyzed by objtool and "fixed"
> as necessary. So, they are not "interesting" to the reliable unwinder in
> the kernel.
> 
> That leaves SYM_CODE*() functions. These contain low-level code that is
> difficult or impossible for objtool to analyze. So, objtool ignores them
> leaving them to the reliable unwinder. These functions must be considered
> unreliable from an unwinding perspective.
> 
> Define a special section for unreliable functions
> =================================================
> 
> Define a SYM_CODE_END() macro for arm64 that adds the function address
> range to a new section called "sym_code_functions".
> 
> Linker file
> ===========
> 
> Include the "sym_code_functions" section under initdata in vmlinux.lds.S.
> 
> Initialization
> ==============
> 
> Define an early_initcall() to copy the function address ranges from the
> "sym_code_functions" section to an array by the same name.
> 
> Unwinder check
> ==============
> 
> Add a reliability check in unwind_check_frame() that compares a return
> PC with sym_code_functions[]. If there is a match, then return
> UNWIND_CONTINUE_WITH_RISK.
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  arch/arm64/include/asm/linkage.h  |  12 ++++
>  arch/arm64/include/asm/sections.h |   1 +
>  arch/arm64/kernel/stacktrace.c    | 112 ++++++++++++++++++++++++++++++
>  arch/arm64/kernel/vmlinux.lds.S   |   7 ++
>  4 files changed, 132 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/linkage.h b/arch/arm64/include/asm/linkage.h
> index ba89a9af820a..3b5f1fd332b0 100644
> --- a/arch/arm64/include/asm/linkage.h
> +++ b/arch/arm64/include/asm/linkage.h
> @@ -60,4 +60,16 @@
>  		SYM_FUNC_END(x);		\
>  		SYM_FUNC_END_ALIAS(__pi_##x)
>  
> +/*
> + * Record the address range of each SYM_CODE function in a struct code_range
> + * in a special section.
> + */
> +#define SYM_CODE_END(name)				\
> +	SYM_END(name, SYM_T_NONE)			;\
> +	99:						;\
> +	.pushsection "sym_code_functions", "aw"		;\
> +	.quad	name					;\
> +	.quad	99b					;\
> +	.popsection
> +
>  #endif
> diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
> index 2f36b16a5b5d..29cb566f65ec 100644
> --- a/arch/arm64/include/asm/sections.h
> +++ b/arch/arm64/include/asm/sections.h
> @@ -20,5 +20,6 @@ extern char __exittext_begin[], __exittext_end[];
>  extern char __irqentry_text_start[], __irqentry_text_end[];
>  extern char __mmuoff_data_start[], __mmuoff_data_end[];
>  extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
> +extern char __sym_code_functions_start[], __sym_code_functions_end[];
>  
>  #endif /* __ASM_SECTIONS_H */
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index ba7b97b119e4..5d5728c3088e 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -18,11 +18,43 @@
>  #include <asm/stack_pointer.h>
>  #include <asm/stacktrace.h>
>  
> +struct code_range {
> +	unsigned long	start;
> +	unsigned long	end;
> +};
> +
> +static struct code_range	*sym_code_functions;
> +static int			num_sym_code_functions;
> +
> +int __init init_sym_code_functions(void)
> +{
> +	size_t size;
> +
> +	size = (unsigned long)__sym_code_functions_end -
> +	       (unsigned long)__sym_code_functions_start;
> +
> +	sym_code_functions = kmalloc(size, GFP_KERNEL);
> +	if (!sym_code_functions)
> +		return -ENOMEM;
> +
> +	memcpy(sym_code_functions, __sym_code_functions_start, size);
> +	/* Update num_sym_code_functions after copying sym_code_functions. */
> +	smp_mb();
> +	num_sym_code_functions = size / sizeof(struct code_range);
> +
> +	return 0;
> +}
> +early_initcall(init_sym_code_functions);

What's the point of copying this, given we don't even sort it?

If we need to keep it around, it would be nicer to leave it where the
linker put it, but make it rodata or ro_after_init.

> +
>  /*
>   * Check the stack frame for conditions that make unwinding unreliable.
>   */
>  enum unwind_rc unwind_check_frame(struct stackframe *frame)
>  {
> +	const struct code_range *range;
> +	unsigned long pc;
> +	int i;
> +
>  	/*
>  	 * If the PC is not a known kernel text address, then we cannot
>  	 * be sure that a subsequent unwind will be reliable, as we
> @@ -30,6 +62,86 @@ enum unwind_rc unwind_check_frame(struct stackframe *frame)
>  	 */
>  	if (!__kernel_text_address(frame->pc))
>  		return UNWIND_CONTINUE_WITH_RISK;

As per patch 1, I'd prefer we had something like an
unwind_is_unreliable() helper, which can return a boolean in this case.

> +
> +	/*
> +	 * If the final frame has been reached, there is no more unwinding
> +	 * to do. There is no need to check if the return PC is considered
> +	 * unreliable by the unwinder.
> +	 */
> +	if (!frame->fp)
> +		return UNWIND_CONTINUE;

As mentioned on patch 1, I'd rather the main unwind loop checked for the
final frame specifically before trying to unwind. With that in mind, we
should never try to unwind to a NULL fp.

> +
> +	/*
> +	 * Check the return PC against sym_code_functions[]. If there is a
> +	 * match, then the consider the stack frame unreliable. These functions
> +	 * contain low-level code where the frame pointer and/or the return
> +	 * address register cannot be relied upon. This addresses the following
> +	 * situations:
> +	 *
> +	 *  - Exception handlers and entry assembly
> +	 *  - Trampoline assembly (e.g., ftrace, kprobes)
> +	 *  - Hypervisor-related assembly
> +	 *  - Hibernation-related assembly
> +	 *  - CPU start-stop, suspend-resume assembly
> +	 *  - Kernel relocation assembly
> +	 *
> +	 * Some special cases covered by sym_code_functions[] deserve a mention
> +	 * here:
> +	 *
> +	 *  - All EL1 interrupt and exception stack traces will be considered
> +	 *    unreliable. This is the correct behavior as interrupts and
> +	 *    exceptions can happen on any instruction including ones in the
> +	 *    frame pointer prolog and epilog. Unless stack metadata is
> +	 *    available so the unwinder can unwind through these special
> +	 *    cases, such stack traces will be considered unreliable.

As mentioned previously, we *can* reliably unwind precisely one step
across an exception boundary, as we can be certain of the PC value at
the time the exception was taken, but past this we can't be certain
whether the LR is legitimate.

I'd like that we capture that precisely in the unwinder, and I'm
currently reworking the entry assembly to make that possible.

> +	 *
> +	 *  - A task can get preempted at the end of an interrupt. Stack
> +	 *    traces of preempted tasks will show the interrupt frame in the
> +	 *    stack trace and will be considered unreliable.
> +	 *
> +	 *  - Breakpoints are exceptions. So, all stack traces in the break
> +	 *    point handler (including probes) will be considered unreliable.
> +	 *
> +	 *  - All of the ftrace entry trampolines are considered unreliable.
> +	 *    So, all stack traces taken from tracer functions will be
> +	 *    considered unreliable.
> +	 *
> +	 *  - The Function Graph Tracer return trampoline (return_to_handler)
> +	 *    and the Kretprobe return trampoline (kretprobe_trampoline) are
> +	 *    also considered unreliable.

We should be able to unwind these reliably if we specifically identify
them. I think we need a two-step check here; we should assume that
SYM_CODE() is unreliable by default, but in specific cases we should
unwind that reliably.

> +	 * Some of the special cases above can be unwound through using
> +	 * special logic in unwind_frame().
> +	 *
> +	 *  - return_to_handler() is handled by the unwinder by attempting
> +	 *    to retrieve the original return address from the per-task
> +	 *    return address stack.
> +	 *
> +	 *  - kretprobe_trampoline() can be handled in a similar fashion by
> +	 *    attempting to retrieve the original return address from the
> +	 *    per-task kretprobe instance list.

We don't do this today,

> +	 *
> +	 *  - I reckon optprobes can be handled in a similar fashion in the
> +	 *    future?
> +	 *
> +	 *  - Stack traces taken from the FTrace tracer functions can be
> +	 *    handled as well. ftrace_call is an inner label defined in the
> +	 *    Ftrace entry trampoline. This is the location where the call
> +	 *    to a tracer function is patched. So, if the return PC equals
> +	 *    ftrace_call+4, it is reliable. At that point, proper stack
> +	 *    frames have already been set up for the traced function and
> +	 *    its caller.
> +	 *
> +	 * NOTE:
> +	 *   If sym_code_functions[] were sorted, a binary search could be
> +	 *   done to make this more performant.
> +	 */

Since some of the above is speculative (e.g. the bit about optprobes),
and as code will change over time, I think we should have a much terser
comment, e.g.

	/*
	 * As SYM_CODE functions don't follow the usual calling
	 * conventions, we assume by default that any SYM_CODE function
	 * cannot be unwound reliably.
	 *
	 * Note that this includes exception entry/return sequences and
	 * trampoline for ftrace and kprobes.
	 */

... and then if/when we try to unwind a specific SYM_CODE function
reliably, we add the comment for that specifically.

Thanks,
Mark.

> +	pc = frame->pc;
> +	for (i = 0; i < num_sym_code_functions; i++) {
> +		range = &sym_code_functions[i];
> +		if (pc >= range->start && pc < range->end)
> +			return UNWIND_CONTINUE_WITH_RISK;
> +	}
>  	return UNWIND_CONTINUE;
>  }
>  
> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> index 7eea7888bb02..ee203f7ca084 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -103,6 +103,12 @@ jiffies = jiffies_64;
>  #define TRAMP_TEXT
>  #endif
>  
> +#define SYM_CODE_FUNCTIONS				\
> +	. = ALIGN(16);					\
> +	__sym_code_functions_start = .;			\
> +	KEEP(*(sym_code_functions))			\
> +	__sym_code_functions_end = .;
> +
>  /*
>   * The size of the PE/COFF section that covers the kernel image, which
>   * runs from _stext to _edata, must be a round multiple of the PE/COFF
> @@ -218,6 +224,7 @@ SECTIONS
>  		CON_INITCALL
>  		INIT_RAM_FS
>  		*(.init.altinstructions .init.bss)	/* from the EFI stub */
> +               SYM_CODE_FUNCTIONS
>  	}
>  	.exit.data : {
>  		EXIT_DATA
> -- 
> 2.25.1
> 
