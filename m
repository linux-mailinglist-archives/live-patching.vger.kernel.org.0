Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6183B3D5AB5
	for <lists+live-patching@lfdr.de>; Mon, 26 Jul 2021 15:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhGZNJb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 26 Jul 2021 09:09:31 -0400
Received: from linux.microsoft.com ([13.77.154.182]:41272 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbhGZNJb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 26 Jul 2021 09:09:31 -0400
Received: from [192.168.254.32] (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id DF34220B7178;
        Mon, 26 Jul 2021 06:49:58 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DF34220B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1627307399;
        bh=N7/Q0Kqpc0DSEIHSSePpKgu3MrRMWelMadpwePVXtMU=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=cwUl0uwgvtWjY+pzabqCW4TDKdqSGBdsmoz1GXOi1y3LxWpRdmZ0Q/01kBH/CoX6z
         Sc2um0Ul0dbq6/ZAMX9zhykvwI7JAXkJO9SX5hVGpJlI3qPe3eFGWPkFjqS4BAXg7A
         EfbuoRlw8c6B+9mn0I01Ggmv5lCrsuLDwLslIKE8=
Subject: Re: [RFC PATCH v6 0/3] arm64: Implement stack trace reliability
 checks
To:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <3f2aab69a35c243c5e97f47c4ad84046355f5b90>
 <20210630223356.58714-1-madvenka@linux.microsoft.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <2810b68b-a6ec-86f9-6915-bda958b39d3a@linux.microsoft.com>
Date:   Mon, 26 Jul 2021 08:49:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210630223356.58714-1-madvenka@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Mark Brown, Mark Rutland,

Could you please review this version of reliable stack trace?

Thanks.

Madhavan

On 6/30/21 5:33 PM, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Unwinder return value
> =====================
> 
> Currently, the unwinder returns a tri-state return value:
> 
> 	0		means "continue with the unwind"
> 	-ENOENT		means "successful termination of the stack trace"
> 	-EINVAL		means "fatal error, abort the stack trace"
> 
> This is confusing. To fix this, define an enumeration of different return
> codes to make it clear.
> 
> enum {
> 	UNWIND_CONTINUE,		/* No errors encountered */
> 	UNWIND_ABORT,			/* Fatal errors encountered */
> 	UNWIND_FINISH,			/* End of stack reached successfully */
> };
> 
> Reliability checks
> ==================
> 
> There are a number of places in kernel code where the stack trace is not
> reliable. Enhance the unwinder to check for those cases.
> 
> Return address check
> --------------------
> 
> Check the return PC of every stack frame to make sure that it is a valid
> kernel text address (and not some generated code, for example).
> 
> Low-level function check
> ------------------------
> 
> Low-level assembly functions are, by nature, unreliable from an unwinder
> perspective. The unwinder must check for them in a stacktrace. See the
> "Assembly Functions" section below.
> 
> Other checks
> ------------
> 
> Other checks may be added in the future. Once all of the checks are in place,
> the unwinder can provide a reliable stack trace. But before this can be used
> for livepatch, some other entity needs to validate the frame pointer in kernel
> functions. objtool is currently being worked on to address that need.
> 
> Return code
> -----------
> 
> If a reliability check fails, it is a non-fatal error. The unwinder needs to
> return an appropriate code so the caller knows that some non-fatal error has
> occurred. Add another code to the enumeration:
> 
> enum {
> 	UNWIND_CONTINUE,		/* No errors encountered */
> 	UNWIND_CONTINUE_WITH_RISK,	/* Non-fatal errors encountered */
> 	UNWIND_ABORT,			/* Fatal errors encountered */
> 	UNWIND_FINISH,			/* End of stack reached successfully */
> };
> 
> When the unwinder returns UNWIND_CONTINUE_WITH_RISK:
> 
> 	- Debug-type callers can choose to continue the unwind
> 
> 	- Livepatch-type callers will stop unwinding
> 
> So, arch_stack_walk_reliable() (implemented in the future) will look like
> this:
> 
> /*
>  * Walk the stack like arch_stack_walk() but stop the walk as soon as
>  * some unreliability is detected in the stack.
>  */
> int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
> 			      void *cookie, struct task_struct *task)
> {
> 	struct stackframe frame;
> 	enum unwind_rc rc;
> 
> 	if (task == current) {
> 		rc = start_backtrace(&frame,
> 				(unsigned long)__builtin_frame_address(0),
> 				(unsigned long)arch_stack_walk_reliable);
> 	} else {
> 		/*
> 		 * The task must not be running anywhere for the duration of
> 		 * arch_stack_walk_reliable(). The caller must guarantee
> 		 * this.
> 		 */
> 		rc = start_backtrace(&frame,
> 				     thread_saved_fp(task),
> 				     thread_saved_pc(task));
> 	}
> 
> 	while (rc == UNWIND_CONTINUE) {
> 		if (!consume_entry(cookie, frame.pc))
> 			return -EINVAL;
> 		rc = unwind_frame(task, &frame);
> 	}
> 
> 	return rc == UNWIND_FINISH ? 0 : -EINVAL;
> }
> 
> Assembly functions
> ==================
> 
> There are a number of assembly functions in arm64. Except for a couple of
> them, these functions do not have a frame pointer prolog or epilog. Also,
> many of them manipulate low-level state such as registers. These functions
> are, by definition, unreliable from a stack unwinding perspective. That is,
> when these functions occur in a stack trace, the unwinder would not be able
> to unwind through them reliably.
> 
> Assembly functions are defined as SYM_FUNC_*() functions or SYM_CODE_*()
> functions. objtool peforms static analysis of SYM_FUNC functions. It ignores
> SYM_CODE functions because they have low level code that is difficult to
> analyze. When objtool becomes ready eventually, SYM_FUNC functions will
> be analyzed and "fixed" as necessary. So, they are not "interesting" for
> the reliable unwinder.
> 
> That leaves SYM_CODE functions. It is for the unwinder to deal with these
> for reliable stack trace. The unwinder needs to do the following:
> 
> 	- Recognize SYM_CODE functions in a stack trace.
> 
> 	- If a particular SYM_CODE function can be unwinded through using
> 	  some special logic, then do it. E.g., the return trampoline for
> 	  Function Graph Tracing.
> 
> 	- Otherwise, return UNWIND_CONTINUE_WITH_RISK.
> 
> Current approach
> ================
> 
> Define an ARM64 version of SYM_CODE_END() like this:
> 
> #define SYM_CODE_END(name)				\
> 	SYM_END(name, SYM_T_NONE)			;\
> 	99:						;\
> 	.pushsection "sym_code_functions", "aw"		;\
> 	.quad	name					;\
> 	.quad	99b					;\
> 	.popsection
> 
> The above macro does the usual SYM_END(). In addition, it records the
> function's address range in a special section called "sym_code_functions".
> This way, all SYM_CODE functions get recorded in the section automatically.
> 
> Implement an early_initcall() called init_sym_code_functions() that allocates
> an array called sym_code_functions[] and copies the function ranges from the
> section to the array.
> 
> Add a reliability check in unwind_check_frame() that compares a return
> PC with sym_code_functions[]. If there is a match, then return
> UNWIND_CONTINUE_WITH_RISK.
> 
> Call unwinder_is_unreliable() on every return PC from unwind_frame(). If there
> is a match, then return UNWIND_CONTINUE_WITH_RISK.
> 
> Last stack frame
> ================
> 
> If a SYM_CODE function occurs in the very last frame in the stack trace,
> then the stack trace is not considered unreliable. This is because there
> is no more unwinding to do. Examples:
> 
> 	- EL0 exception stack traces end in the top level EL0 exception
> 	  handlers.
> 
> 	- All kernel thread stack traces end in ret_from_fork().
> 
> Special SYM_CODE functions
> ==========================
> 
> The return trampolines of the Function Graph Tracer and Kretprobe can
> be recognized by the unwinder. If the return PCs can be translated to the
> original PCs, then, the unwinder should perform that translation before
> checking for reliability. The final PC that we end up with after all the
> translations is the one we need to check for reliability.
> 
> Accordingly, I have moved the reliability checks to after the logic that
> handles the Function Graph Tracer.
> 
> So, the approach is - all SYM_CODE functions are unreliable. If a SYM_CODE
> function is "fixed" to make it reliable, then it should become a SYM_FUNC
> function. Or, if the unwinder has special logic to unwind through a SYM_CODE
> function, then that can be done.
> 
> Special cases
> =============
> 
> Some special cases need to be mentioned:
> 
> 	- EL1 interrupt and exception handlers end up in sym_code_ranges[].
> 	  So, all EL1 interrupt and exception stack traces will be considered
> 	  unreliable. This the correct behavior as interrupts and exceptions
> 	  can happen on any instruction including ones in the frame pointer
> 	  prolog and epilog. Unless objtool generates metadata so the unwinder
> 	  can unwind through these special cases, such stack traces will be
> 	  considered unreliable.
> 
> 	- A task can get preempted at the end of an interrupt. Stack traces
> 	  of preempted tasks will show the interrupt frame in the stack trace
> 	  and will be considered unreliable.
> 
> 	- Breakpoints are exceptions. So, all stack traces in the break point
> 	  handler (including probes) will be considered unreliable.
> 
> 	- All of the ftrace trampolines end up in sym_code_functions[]. All
> 	  stack traces taken from tracer functions will be considered
> 	  unreliable.
> ---
> Changelog:
> 
> v6:
> 	From Mark Rutland:
> 
> 	- The per-frame reliability concept and flag are acceptable. But more
> 	  work is needed to make the per-frame checks more accurate and more
> 	  complete. E.g., some code reorg is being worked on that will help.
> 
> 	  I have now removed the frame->reliable flag and deleted the whole
> 	  concept of per-frame status. This is orthogonal to this patch series.
> 	  Instead, I have improved the unwinder to return proper return codes
> 	  so a caller can take appropriate action without needing per-frame
> 	  status.
> 
> 	- Remove the mention of PLTs and update the comment.
> 
> 	  I have replaced the comment above the call to __kernel_text_address()
> 	  with the comment suggested by Mark Rutland.
> 
> 	Other comments:
> 
> 	- Other comments on the per-frame stuff are not relevant because
> 	  that approach is not there anymore.
> 
> v5:
> 	From Keiya Nobuta:
> 	
> 	- The term blacklist(ed) is not to be used anymore. I have changed it
> 	  to unreliable. So, the function unwinder_blacklisted() has been
> 	  changed to unwinder_is_unreliable().
> 
> 	From Mark Brown:
> 
> 	- Add a comment for the "reliable" flag in struct stackframe. The
> 	  reliability attribute is not complete until all the checks are
> 	  in place. Added a comment above struct stackframe.
> 
> 	- Include some of the comments in the cover letter in the actual
> 	  code so that we can compare it with the reliable stack trace
> 	  requirements document for completeness. I have added a comment:
> 
> 	  	- above unwinder_is_unreliable() that lists the requirements
> 		  that are addressed by the function.
> 
> 		- above the __kernel_text_address() call about all the cases
> 		  the call covers.
> 
> v4:
> 	From Mark Brown:
> 
> 	- I was checking the return PC with __kernel_text_address() before
> 	  the Function Graph trace handling. Mark Brown felt that all the
> 	  reliability checks should be performed on the original return PC
> 	  once that is obtained. So, I have moved all the reliability checks
> 	  to after the Function Graph Trace handling code in the unwinder.
> 	  Basically, the unwinder should perform PC translations first (for
> 	  rhe return trampoline for Function Graph Tracing, Kretprobes, etc).
> 	  Then, the reliability checks should be applied to the resulting
> 	  PC.
> 
> 	- Mark said to improve the naming of the new functions so they don't
> 	  collide with existing ones. I have used a prefix "unwinder_" for
> 	  all the new functions.
> 
> 	From Josh Poimboeuf:
> 
> 	- In the error scenarios in the unwinder, the reliable flag in the
> 	  stack frame should be set. Implemented this.
> 
> 	- Some of the other comments are not relevant to the new code as
> 	  I have taken a different approach in the new code. That is why
> 	  I have not made those changes. E.g., Ard wanted me to add the
> 	  "const" keyword to the global section array. That array does not
> 	  exist in v4. Similarly, Mark Brown said to use ARRAY_SIZE() for
> 	  the same array in a for loop.
> 
> 	Other changes:
> 
> 	- Add a new definition for SYM_CODE_END() that adds the address
> 	  range of the function to a special section called
> 	  "sym_code_functions".
> 
> 	- Include the new section under initdata in vmlinux.lds.S.
> 
> 	- Define an early_initcall() to copy the contents of the
> 	  "sym_code_functions" section to an array by the same name.
> 
> 	- Define a function unwinder_blacklisted() that compares a return
> 	  PC against sym_code_sections[]. If there is a match, mark the
> 	  stack trace unreliable. Call this from unwind_frame().
> 
> v3:
> 	- Implemented a sym_code_ranges[] array to contains sections bounds
> 	  for text sections that contain SYM_CODE_*() functions. The unwinder
> 	  checks each return PC against the sections. If it falls in any of
> 	  the sections, the stack trace is marked unreliable.
> 
> 	- Moved SYM_CODE functions from .text and .init.text into a new
> 	  text section called ".code.text". Added this section to
> 	  vmlinux.lds.S and sym_code_ranges[].
> 
> 	- Fixed the logic in the unwinder that handles Function Graph
> 	  Tracer return trampoline.
> 
> 	- Removed all the previous code that handles:
> 		- ftrace entry code for traced function
> 		- special_functions[] array that lists individual functions
> 		- kretprobe_trampoline() special case
> 
> v2
> 	- Removed the terminating entry { 0, 0 } in special_functions[]
> 	  and replaced it with the idiom { /* sentinel */ }.
> 
> 	- Change the ftrace trampoline entry ftrace_graph_call in
> 	  special_functions[] to ftrace_call + 4 and added explanatory
> 	  comments.
> 
> 	- Unnested #ifdefs in special_functions[] for FTRACE.
> 
> v1
> 	- Define a bool field in struct stackframe. This will indicate if
> 	  a stack trace is reliable.
> 
> 	- Implement a special_functions[] array that will be populated
> 	  with special functions in which the stack trace is considered
> 	  unreliable.
> 	
> 	- Using kallsyms_lookup(), get the address ranges for the special
> 	  functions and record them.
> 
> 	- Implement an is_reliable_function(pc). This function will check
> 	  if a given return PC falls in any of the special functions. If
> 	  it does, the stack trace is unreliable.
> 
> 	- Implement check_reliability() function that will check if a
> 	  stack frame is reliable. Call is_reliable_function() from
> 	  check_reliability().
> 
> 	- Before a return PC is checked against special_funtions[], it
> 	  must be validates as a proper kernel text address. Call
> 	  __kernel_text_address() from check_reliability().
> 
> 	- Finally, call check_reliability() from unwind_frame() for
> 	  each stack frame.
> 
> 	- Add EL1 exception handlers to special_functions[].
> 
> 		el1_sync();
> 		el1_irq();
> 		el1_error();
> 		el1_sync_invalid();
> 		el1_irq_invalid();
> 		el1_fiq_invalid();
> 		el1_error_invalid();
> 
> 	- The above functions are currently defined as LOCAL symbols.
> 	  Make them global so that they can be referenced from the
> 	  unwinder code.
> 
> 	- Add FTRACE trampolines to special_functions[]:
> 
> 		ftrace_graph_call()
> 		ftrace_graph_caller()
> 		return_to_handler()
> 
> 	- Add the kretprobe trampoline to special functions[]:
> 
> 		kretprobe_trampoline()
> 
> Previous versions and discussion
> ================================
> 
> v5: https://lore.kernel.org/linux-arm-kernel/20210526214917.20099-1-madvenka@linux.microsoft.com/
> v4: https://lore.kernel.org/linux-arm-kernel/20210516040018.128105-1-madvenka@linux.microsoft.com/
> v3: https://lore.kernel.org/linux-arm-kernel/20210503173615.21576-1-madvenka@linux.microsoft.com/
> v2: https://lore.kernel.org/linux-arm-kernel/20210405204313.21346-1-madvenka@linux.microsoft.com/
> v1: https://lore.kernel.org/linux-arm-kernel/20210330190955.13707-1-madvenka@linux.microsoft.com/
> Madhavan T. Venkataraman (3):
>   arm64: Improve the unwinder return value
>   arm64: Introduce stack trace reliability checks in the unwinder
>   arm64: Create a list of SYM_CODE functions, check return PC against
>     list
> 
>  arch/arm64/include/asm/linkage.h    |  12 ++
>  arch/arm64/include/asm/sections.h   |   1 +
>  arch/arm64/include/asm/stacktrace.h |  16 ++-
>  arch/arm64/kernel/perf_callchain.c  |   5 +-
>  arch/arm64/kernel/process.c         |   8 +-
>  arch/arm64/kernel/return_address.c  |  10 +-
>  arch/arm64/kernel/stacktrace.c      | 180 ++++++++++++++++++++++++----
>  arch/arm64/kernel/time.c            |   9 +-
>  arch/arm64/kernel/vmlinux.lds.S     |   7 ++
>  9 files changed, 213 insertions(+), 35 deletions(-)
> 
> 
> base-commit: bf05bf16c76bb44ab5156223e1e58e26dfe30a88
> 
