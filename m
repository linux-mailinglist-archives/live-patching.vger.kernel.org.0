Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C60E490AD3
	for <lists+live-patching@lfdr.de>; Mon, 17 Jan 2022 15:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbiAQO4Z (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 17 Jan 2022 09:56:25 -0500
Received: from linux.microsoft.com ([13.77.154.182]:59386 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234410AbiAQO4Z (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 17 Jan 2022 09:56:25 -0500
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id DC45720B8951;
        Mon, 17 Jan 2022 06:56:23 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DC45720B8951
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1642431384;
        bh=ILihjnGde4pJNx3Q1FL6fERdblHJd3ysQhJRb4J/Hek=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=TF3T6v1xkeePSAdGSQT6o7vZ8yAAIIt7Zfew7fqFnyLJlwB6qNjEIIm9c2AOZAtGD
         O+2s4Vtns6wnMAHkD2W1U4nurVuWx2zHqR+5ETFzHEdaJDxsbXRLTgFjoZcZ7nmVoY
         GlJQdPu+Ro5AzEG5Ab/kCD3Kjzxug53Vy2kdaZHA=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v13 00/11] arm64: Reorganize the unwinder and implement stack trace reliability checks
Date:   Mon, 17 Jan 2022 08:55:57 -0600
Message-Id: <20220117145608.6781-1-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

I have rebased this patch series on top of Linus' tree as of Jan 15, 2022.
The base commit is provided at the end of this email.

Remove NULL task check
======================

Currently, there is a check for a NULL task in unwind_frame(). It is not
needed since all current consumers pass a non-NULL task.

Rename unwinder functions
=========================

Rename unwinder functions to unwind*() similar to other architectures
for naming consistency.

	start_backtrace() ==> unwind_init()
	unwind_frame()    ==> unwind_next()
	walk_stackframe() ==> unwind()

Rename struct stackframe
========================

Rename "struct stackframe" to "struct unwind_state" for better naming
and consistency.

Split unwind_init()
===================

Unwind initialization has 3 cases. Accordingly, define 3 separate init
functions as follows:

	- unwind_init_from_regs()
	- unwind_init_from_current()
	- unwind_init_from_task()

This makes it easier to understand and add specialized code to each case
in the future.

Copy task argument
==================

Copy the task argument passed to arch_stack_walk() to unwind_state so that
it can be passed to unwind functions via unwind_state rather than as a
separate argument. The task is a fundamental part of the unwind state.

Use stack_trace_consume_fn
==========================

stack_trace_consume_fn is a typedef already defined. unwind() does not
use this for its consume_entry() argument. Fix this. Also, rename the
arguments to unwind() for better naming consistency.

Redefine the unwinder loop
==========================

Redefine the unwinder loop and make it simple and somewhat similar to other
architectures. Define the following:

	while (unwind_continue(&state, consume_entry, cookie))
		unwind_next(&state);

unwind_continue()
	This new function implements checks to determine whether the
	unwind should continue or terminate.

Reliability checks
==================

There are some kernel features and conditions that make a stack trace
unreliable. Callers may require the unwinder to detect these cases.
E.g., livepatch.

Introduce a new function called unwind_check_reliability() that will detect
these cases and set a boolean "reliable" in the stackframe. Call
unwind_check_reliability() for every frame.

Introduce the first reliability check in unwind_check_reliability() - If
a return PC is not a valid kernel text address, consider the stack
trace unreliable. It could be some generated code.

Other reliability checks will be added in the future.

Make unwind() return a boolean to indicate reliability of the stack trace.

SYM_CODE check
==============

This is the second reliability check implemented.

SYM_CODE functions do not follow normal calling conventions. They cannot
be unwound reliably using the frame pointer. Collect the address ranges
of these functions in a special section called "sym_code_functions".

In unwind_check_reliability(), check the return PC against these ranges. If
a match is found, then mark the stack trace unreliable.

Last stack frame
================

If a SYM_CODE function occurs in the very last frame in the stack trace,
then the stack trace is not considered unreliable. This is because there
is no more unwinding to do. Examples:

	- EL0 exception stack traces end in the top level EL0 exception
	  handlers.

	- All kernel thread stack traces end in ret_from_fork().

arch_stack_walk_reliable()
==========================

Introduce arch_stack_walk_reliable() for ARM64. This works like
arch_stack_walk() except that it returns an error if the stack trace is
found to be unreliable.

Until all of the reliability checks are in place in
unwind_check_reliability(), arch_stack_walk_reliable() may not be used by
livepatch. But it may be used by debug and test code.

HAVE_RELIABLE_STACKTRACE
========================

Select this config for arm64. However, make it conditional on
STACK_VALIDATION. When objtool is enhanced to implement stack
validation for arm64, STACK_VALIDATION will be defined.

---
Changelog:
v13:
	From Mark Brown:

	- Reviewed-by for the following:

	[PATCH v12 03/10] arm64: Rename stackframe to unwind_state
	[PATCH v11 05/10] arm64: Copy unwind arguments to unwind_state
	[PATCH v11 07/10] arm64: Introduce stack trace reliability checks
	                  in the unwinder
	[PATCH v11 5/5] arm64: Create a list of SYM_CODE functions, check
	                return PC against list

	From Mark Rutland:

	- Reviewed-by for the following:

	[PATCH v12 01/10] arm64: Remove NULL task check from unwind_frame()
	[PATCH v12 02/10] arm64: Rename unwinder functions
	[PATCH v12 03/10] arm64: Rename stackframe to unwind_state

	- For each of the 3 cases of unwind initialization, have a separate
	  init function. Call the common init from each of these init
	  functions rather than call it separately.

	- Only copy the task argument to arch_stack_walk() into
	  unwind state. Pass the rest of the arguments as arguments to
	  unwind functions.

v12:
	From Mark Brown:

	- Reviewed-by for the following:

	[PATCH v11 1/5] arm64: Call stack_backtrace() only from within
	                walk_stackframe()
	[PATCH v11 2/5] arm64: Rename unwinder functions
	[PATCH v11 3/5] arm64: Make the unwind loop in unwind() similar to
	                other architectures
	[PATCH v11 5/5] arm64: Create a list of SYM_CODE functions, check
	                return PC against list

	- Add an extra patch at the end to select HAVE_RELIABLE_STACKTRACE
	  just as a place holder for the review. I have added it and made
	  it conditional on STACK_VALIDATION which has not yet been
	  implemented.

	- Mark had a concern about the code for the check for the final
	  frame being repeated in two places. I have now added a new
	  field called "final_fp" in struct stackframe which I compute
	  once in stacktrace initialization. I have added an explicit
	  comment that the stacktrace must terminate at the final_fp.

	- Place the implementation of arch_stack_walk_reliable() in a
	  separate patch after all the reliability checks have been
	  implemented.

	From Mark Rutland:

	- Place the removal of the NULL task check in unwind_frame() in
	  a separate patch.

	- Add a task field to struct stackframe so the task pointer can be
	  passed around via the frame instead of as a separate argument. I have
	  taken this a step further by copying all of the arguments to
	  arch_stack_walk() into struct stackframe so that only that
	  struct needs to be passed to unwind functions.

	- Rename start_backtrace() to unwind_init() instead of unwind_start().

	- Acked-by for the following:

	[PATCH v11 2/5] arm64: Rename unwinder functions

	- Rename "struct stackframe" to "struct unwind_state".

	- Define separate inline functions for initializing the starting
	  FP and PC from regs, or caller, or blocked task. Don't merge
	  unwind_init() into unwind().

v11:
	From Mark Rutland:

	- Peter Zijlstra has submitted patches that make ARCH_STACKWALK
	  independent of STACKTRACE. Mark Rutland extracted some of the
	  patches from my v10 series and added his own patches and comments,
	  rebased it on top of Peter's changes and submitted the series.
	  
	  So, I have rebased the rest of the patches from v10 on top of
	  Mark Rutland's changes.

	- Split the renaming of the unwinder functions and annotating them
	  with notrace and NOKPROBE_SYMBOL(). Also, there is currently no
	  need to annotate unwind_start() as its caller is already annotated
	  properly. So, I am removing the annotation patch from the series.
	  This can be done separately later if deemed necessary. Similarly,
	  I have removed the annotations from unwind_check_reliability() and
	  unwind_continue().

	From Nobuta Keiya:

	- unwind_start() should check for final frame and not mark the
	  final frame unreliable.

v9, v10:
	- v9 had a threading problem. So, I resent it as v10.

	From me:

	- Removed the word "RFC" from the subject line as I believe this
	  is mature enough to be a regular patch.

	From Mark Brown, Mark Rutland:

	- Split the patches into smaller, self-contained ones.

	- Always enable STACKTRACE so that arch_stack_walk() is always
	  defined.

	From Mark Rutland:

	- Update callchain_trace() take the return value of
	  perf_callchain_store() into acount.

	- Restore get_wchan() behavior to the original code.

	- Simplify an if statement in dump_backtrace().

	From Mark Brown:

	- Do not abort the stack trace on the first unreliable frame.

	
v8:
	- Synced to v5.14-rc5.

	From Mark Rutland:

	- Make the unwinder loop similar to other architectures.

	- Keep details to within the unwinder functions and return a simple
	  boolean to the caller.

	- Convert some of the current code that contains unwinder logic to
	  simply use arch_stack_walk(). I have converted all of them.

	- Do not copy sym_code_functions[]. Just place it in rodata for now.

	- Have the main loop check for termination conditions rather than
	  having unwind_frame() check for them. In other words, let
	  unwind_frame() assume that the fp is valid.

	- Replace the big comment for SYM_CODE functions with a shorter
	  comment.

		/*
		 * As SYM_CODE functions don't follow the usual calling
		 * conventions, we assume by default that any SYM_CODE function
		 * cannot be unwound reliably.
		 *
		 * Note that this includes:
		 *
		 * - Exception handlers and entry assembly
		 * - Trampoline assembly (e.g., ftrace, kprobes)
		 * - Hypervisor-related assembly
		 * - Hibernation-related assembly
		 * - CPU start-stop, suspend-resume assembly
		 * - Kernel relocation assembly
		 */

v7:
	The Mailer screwed up the threading on this. So, I have resent this
	same series as version 8 with proper threading to avoid confusion.
v6:
	From Mark Rutland:

	- The per-frame reliability concept and flag are acceptable. But more
	  work is needed to make the per-frame checks more accurate and more
	  complete. E.g., some code reorg is being worked on that will help.

	  I have now removed the frame->reliable flag and deleted the whole
	  concept of per-frame status. This is orthogonal to this patch series.
	  Instead, I have improved the unwinder to return proper return codes
	  so a caller can take appropriate action without needing per-frame
	  status.

	- Remove the mention of PLTs and update the comment.

	  I have replaced the comment above the call to __kernel_text_address()
	  with the comment suggested by Mark Rutland.

	Other comments:

	- Other comments on the per-frame stuff are not relevant because
	  that approach is not there anymore.

v5:
	From Keiya Nobuta:
	
	- The term blacklist(ed) is not to be used anymore. I have changed it
	  to unreliable. So, the function unwinder_blacklisted() has been
	  changed to unwinder_is_unreliable().

	From Mark Brown:

	- Add a comment for the "reliable" flag in struct stackframe. The
	  reliability attribute is not complete until all the checks are
	  in place. Added a comment above struct stackframe.

	- Include some of the comments in the cover letter in the actual
	  code so that we can compare it with the reliable stack trace
	  requirements document for completeness. I have added a comment:

	  	- above unwinder_is_unreliable() that lists the requirements
		  that are addressed by the function.

		- above the __kernel_text_address() call about all the cases
		  the call covers.

v4:
	From Mark Brown:

	- I was checking the return PC with __kernel_text_address() before
	  the Function Graph trace handling. Mark Brown felt that all the
	  reliability checks should be performed on the original return PC
	  once that is obtained. So, I have moved all the reliability checks
	  to after the Function Graph Trace handling code in the unwinder.
	  Basically, the unwinder should perform PC translations first (for
	  rhe return trampoline for Function Graph Tracing, Kretprobes, etc).
	  Then, the reliability checks should be applied to the resulting
	  PC.

	- Mark said to improve the naming of the new functions so they don't
	  collide with existing ones. I have used a prefix "unwinder_" for
	  all the new functions.

	From Josh Poimboeuf:

	- In the error scenarios in the unwinder, the reliable flag in the
	  stack frame should be set. Implemented this.

	- Some of the other comments are not relevant to the new code as
	  I have taken a different approach in the new code. That is why
	  I have not made those changes. E.g., Ard wanted me to add the
	  "const" keyword to the global section array. That array does not
	  exist in v4. Similarly, Mark Brown said to use ARRAY_SIZE() for
	  the same array in a for loop.

	Other changes:

	- Add a new definition for SYM_CODE_END() that adds the address
	  range of the function to a special section called
	  "sym_code_functions".

	- Include the new section under initdata in vmlinux.lds.S.

	- Define an early_initcall() to copy the contents of the
	  "sym_code_functions" section to an array by the same name.

	- Define a function unwinder_blacklisted() that compares a return
	  PC against sym_code_sections[]. If there is a match, mark the
	  stack trace unreliable. Call this from unwind_frame().

v3:
	- Implemented a sym_code_ranges[] array to contains sections bounds
	  for text sections that contain SYM_CODE_*() functions. The unwinder
	  checks each return PC against the sections. If it falls in any of
	  the sections, the stack trace is marked unreliable.

	- Moved SYM_CODE functions from .text and .init.text into a new
	  text section called ".code.text". Added this section to
	  vmlinux.lds.S and sym_code_ranges[].

	- Fixed the logic in the unwinder that handles Function Graph
	  Tracer return trampoline.

	- Removed all the previous code that handles:
		- ftrace entry code for traced function
		- special_functions[] array that lists individual functions
		- kretprobe_trampoline() special case

v2
	- Removed the terminating entry { 0, 0 } in special_functions[]
	  and replaced it with the idiom { /* sentinel */ }.

	- Change the ftrace trampoline entry ftrace_graph_call in
	  special_functions[] to ftrace_call + 4 and added explanatory
	  comments.

	- Unnested #ifdefs in special_functions[] for FTRACE.

v1
	- Define a bool field in struct stackframe. This will indicate if
	  a stack trace is reliable.

	- Implement a special_functions[] array that will be populated
	  with special functions in which the stack trace is considered
	  unreliable.
	
	- Using kallsyms_lookup(), get the address ranges for the special
	  functions and record them.

	- Implement an is_reliable_function(pc). This function will check
	  if a given return PC falls in any of the special functions. If
	  it does, the stack trace is unreliable.

	- Implement check_reliability() function that will check if a
	  stack frame is reliable. Call is_reliable_function() from
	  check_reliability().

	- Before a return PC is checked against special_funtions[], it
	  must be validates as a proper kernel text address. Call
	  __kernel_text_address() from check_reliability().

	- Finally, call check_reliability() from unwind_frame() for
	  each stack frame.

	- Add EL1 exception handlers to special_functions[].

		el1_sync();
		el1_irq();
		el1_error();
		el1_sync_invalid();
		el1_irq_invalid();
		el1_fiq_invalid();
		el1_error_invalid();

	- The above functions are currently defined as LOCAL symbols.
	  Make them global so that they can be referenced from the
	  unwinder code.

	- Add FTRACE trampolines to special_functions[]:

		ftrace_graph_call()
		ftrace_graph_caller()
		return_to_handler()

	- Add the kretprobe trampoline to special functions[]:

		kretprobe_trampoline()

Previous versions and discussion
================================

v12: https://lore.kernel.org/linux-arm-kernel/20220103165212.9303-1-madvenka@linux.microsoft.com/T/#m21e86eecb9b8f0831196568f0bf62c3b56f65bf0
v11: https://lore.kernel.org/linux-arm-kernel/20211123193723.12112-1-madvenka@linux.microsoft.com/T/#t
v10: https://lore.kernel.org/linux-arm-kernel/4b3d5552-590c-e6a0-866b-9bc51da7bebf@linux.microsoft.com/T/#t
v9: Mailer screwed up the threading. Sent the same as v10 with proper threading.
v8: https://lore.kernel.org/linux-arm-kernel/20210812190603.25326-1-madvenka@linux.microsoft.com/
v7: Mailer screwed up the threading. Sent the same as v8 with proper threading.
v6: https://lore.kernel.org/linux-arm-kernel/20210630223356.58714-1-madvenka@linux.microsoft.com/
v5: https://lore.kernel.org/linux-arm-kernel/20210526214917.20099-1-madvenka@linux.microsoft.com/
v4: https://lore.kernel.org/linux-arm-kernel/20210516040018.128105-1-madvenka@linux.microsoft.com/
v3: https://lore.kernel.org/linux-arm-kernel/20210503173615.21576-1-madvenka@linux.microsoft.com/
v2: https://lore.kernel.org/linux-arm-kernel/20210405204313.21346-1-madvenka@linux.microsoft.com/
v1: https://lore.kernel.org/linux-arm-kernel/20210330190955.13707-1-madvenka@linux.microsoft.com/

Madhavan T. Venkataraman (11):
  arm64: Remove NULL task check from unwind_frame()
  arm64: Rename unwinder functions
  arm64: Rename stackframe to unwind_state
  arm64: Split unwind_init()
  arm64: Copy the task argument to unwind_state
  arm64: Use stack_trace_consume_fn and rename args to unwind()
  arm64: Make the unwind loop in unwind() similar to other architectures
  arm64: Introduce stack trace reliability checks in the unwinder
  arm64: Create a list of SYM_CODE functions, check return PC against
    list
  arm64: Introduce arch_stack_walk_reliable()
  arm64: Select HAVE_RELIABLE_STACKTRACE

 arch/arm64/Kconfig                  |   1 +
 arch/arm64/include/asm/linkage.h    |  12 ++
 arch/arm64/include/asm/sections.h   |   1 +
 arch/arm64/include/asm/stacktrace.h |  14 +-
 arch/arm64/kernel/stacktrace.c      | 287 +++++++++++++++++++++-------
 arch/arm64/kernel/vmlinux.lds.S     |  10 +
 6 files changed, 258 insertions(+), 67 deletions(-)


base-commit: a33f5c380c4bd3fa5278d690421b72052456d9fe
-- 
2.25.1

