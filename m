Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA3F55B061
	for <lists+live-patching@lfdr.de>; Sun, 26 Jun 2022 10:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiFZIrB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 26 Jun 2022 04:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiFZIrB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 26 Jun 2022 04:47:01 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 877FC2AE6;
        Sun, 26 Jun 2022 01:46:59 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 67358D6E;
        Sun, 26 Jun 2022 01:46:59 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.71.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F3CD3F792;
        Sun, 26 Jun 2022 01:46:57 -0700 (PDT)
Date:   Sun, 26 Jun 2022 09:46:53 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v15 5/6] arm64: Create a list of SYM_CODE functions,
 check return PC against list
Message-ID: <Yrgc/Z7uG29XihFg@FVFF77S0Q05N>
References: <ff68fb850d42e1adaa6a0a6c9c258acabb898b24>
 <20220617210717.27126-1-madvenka@linux.microsoft.com>
 <20220617210717.27126-6-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617210717.27126-6-madvenka@linux.microsoft.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jun 17, 2022 at 04:07:16PM -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> SYM_CODE functions don't follow the usual calling conventions. Check if the
> return PC in a stack frame falls in any of these. If it does, consider the
> stack trace unreliable.
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
> Include the "sym_code_functions" section under read-only data in
> vmlinux.lds.S.
> 
> Initialization
> ==============
> 
> Define an early_initcall() to create a sym_code_functions[] array from
> the linker data.
> 
> Unwinder check
> ==============
> 
> Add a reliability check in unwind_check_reliability() that compares a
> return PC with sym_code_functions[]. If there is a match, then return
> failure.
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/linkage.h  | 11 +++++++
>  arch/arm64/include/asm/sections.h |  1 +
>  arch/arm64/kernel/stacktrace.c    | 55 +++++++++++++++++++++++++++++++
>  arch/arm64/kernel/vmlinux.lds.S   | 10 ++++++
>  4 files changed, 77 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/linkage.h b/arch/arm64/include/asm/linkage.h
> index 43f8c25b3fda..d4058de4af78 100644
> --- a/arch/arm64/include/asm/linkage.h
> +++ b/arch/arm64/include/asm/linkage.h
> @@ -39,4 +39,15 @@
>  	SYM_START(name, SYM_L_WEAK, SYM_A_NONE)		\
>  	bti c ;
>  
> +/*
> + * Record the address range of each SYM_CODE function in a struct code_range
> + * in a special section.
> + */
> +#define SYM_CODE_END(name)				\
> +	SYM_END(name, SYM_T_NONE)			;\
> +99:	.pushsection "sym_code_functions", "aw"		;\
> +	.quad	name					;\
> +	.quad	99b					;\
> +	.popsection
> +
>  #endif
> diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
> index 40971ac1303f..50cfd1083563 100644
> --- a/arch/arm64/include/asm/sections.h
> +++ b/arch/arm64/include/asm/sections.h
> @@ -22,6 +22,7 @@ extern char __irqentry_text_start[], __irqentry_text_end[];
>  extern char __mmuoff_data_start[], __mmuoff_data_end[];
>  extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
>  extern char __relocate_new_kernel_start[], __relocate_new_kernel_end[];
> +extern char __sym_code_functions_start[], __sym_code_functions_end[];
>  
>  static inline size_t entry_tramp_text_size(void)
>  {
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index 5ef2ce217324..eda8581f7dbe 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -62,6 +62,31 @@ struct unwind_state {
>  	bool reliable;
>  };
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
> +	size_t size = (unsigned long)__sym_code_functions_end -
> +		      (unsigned long)__sym_code_functions_start;
> +
> +	sym_code_functions = (struct code_range *)__sym_code_functions_start;
> +	/*
> +	 * Order it so that sym_code_functions is not visible before
> +	 * num_sym_code_functions.
> +	 */
> +	smp_mb();
> +	num_sym_code_functions = size / sizeof(struct code_range);
> +
> +	return 0;
> +}
> +early_initcall(init_sym_code_functions);

There's no reason to need an initcall for this; we can iterate over this
directly using __sym_code_functions_start and __sym_code_functions_end, like we
do for exception tables today.

For example:

static inline bool pc_is_sym_code(unsigned long pc)
{
	extern struct code_range *__sym_code_functions_start;
	extern struct code_range *__sym_code_functions_end;

	struct code_range *r;

	for (r = __sym_code_functions_start; r < __sym_code_functions_end; r++) {
		if (pc >= r->start && pc < r->end)
			return true;
	}

	return false;
}

Thanks,
Mark.

> +
>  static void unwind_init_common(struct unwind_state *state,
>  			       struct task_struct *task)
>  {
> @@ -251,6 +276,10 @@ NOKPROBE_SYMBOL(unwind_next);
>   */
>  static void unwind_check_reliability(struct unwind_state *state)
>  {
> +	const struct code_range *range;
> +	unsigned long pc;
> +	int i;
> +
>  	if (state->fp == state->final_fp) {
>  		/* Final frame; no more unwind, no need to check reliability */
>  		return;
> @@ -263,6 +292,32 @@ static void unwind_check_reliability(struct unwind_state *state)
>  	 */
>  	if (!__kernel_text_address(state->pc))
>  		state->reliable = false;
> +
> +	/*
> +	 * Check the return PC against sym_code_functions[]. If there is a
> +	 * match, then the consider the stack frame unreliable.
> +	 *
> +	 * As SYM_CODE functions don't follow the usual calling conventions,
> +	 * we assume by default that any SYM_CODE function cannot be unwound
> +	 * reliably.
> +	 *
> +	 * Note that this includes:
> +	 *
> +	 * - Exception handlers and entry assembly
> +	 * - Trampoline assembly (e.g., ftrace, kprobes)
> +	 * - Hypervisor-related assembly
> +	 * - Hibernation-related assembly
> +	 * - CPU start-stop, suspend-resume assembly
> +	 * - Kernel relocation assembly
> +	 */
> +	pc = state->pc;
> +	for (i = 0; i < num_sym_code_functions; i++) {
> +		range = &sym_code_functions[i];
> +		if (pc >= range->start && pc < range->end) {
> +			state->reliable = false;
> +			return;
> +		}
> +	}
>  }
>  
>  static bool notrace unwind(struct unwind_state *state,
> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> index 2d4a8f995175..414dbc82d0a6 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -120,6 +120,14 @@ jiffies = jiffies_64;
>  #define TRAMP_TEXT
>  #endif
>  
> +#define SYM_CODE_FUNCTIONS				\
> +	. = ALIGN(16);					\
> +	.symcode : AT(ADDR(.symcode) - LOAD_OFFSET) {	\
> +		__sym_code_functions_start = .;		\
> +		KEEP(*(sym_code_functions))		\
> +		__sym_code_functions_end = .;		\
> +	}
> +
>  /*
>   * The size of the PE/COFF section that covers the kernel image, which
>   * runs from _stext to _edata, must be a round multiple of the PE/COFF
> @@ -212,6 +220,8 @@ SECTIONS
>  	swapper_pg_dir = .;
>  	. += PAGE_SIZE;
>  
> +	SYM_CODE_FUNCTIONS
> +
>  	. = ALIGN(SEGMENT_ALIGN);
>  	__init_begin = .;
>  	__inittext_begin = .;
> -- 
> 2.25.1
> 
