Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE923EA59C
	for <lists+live-patching@lfdr.de>; Thu, 12 Aug 2021 15:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbhHLNZT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 12 Aug 2021 09:25:19 -0400
Received: from linux.microsoft.com ([13.77.154.182]:40392 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhHLNZR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 12 Aug 2021 09:25:17 -0400
Received: from x64host.home (unknown [47.187.212.181])
        by linux.microsoft.com (Postfix) with ESMTPSA id 68C1C20C13EE;
        Thu, 12 Aug 2021 06:24:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 68C1C20C13EE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1628774692;
        bh=AhpJbfCHq7quQfrrfHF+/RHTsokKRBXijLxNhxF+Mg8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=sXDBBLz5xmQkklEM96oAEvPbSGHobWcHf307JTFmOrW61EwjEp3ytnm1i0dHEkSdW
         Lf+8df8UnZVGUmdJNv1ttWkU/SPl9iIXJ2Yd2N+sGXS5lPZQjB5JaKybABIg7Mw3AM
         xWHHbUiLqtPmPT7pMeoEwoC4DkzDx41a3xw/Dv1c=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v7 0/4] arm64: Reorganize the unwinder and implement stack trace reliability checks
Date:   Thu, 12 Aug 2021 08:24:31 -0500
Message-Id: <20210812132435.6143-1-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <3f2aab69a35c243c5e97f47c4ad84046355f5b90>
References: <3f2aab69a35c243c5e97f47c4ad84046355f5b90>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Make all stack walking functions use arch_stack_walk()
======================================================

Currently, there are multiple functions in ARM64 code that walk the
stack using start_backtrace() and unwind_frame(). Convert all of
them to use arch_stack_walk(). This makes maintenance easier.

Reorganize the unwinder code for better consistency and maintenance
===================================================================

Rename unwinder functions to unwind_*() similar to other architectures
for naming consistency.

Annotate all of the unwind_*() functions with notrace so they cannot be
ftraced and NOKPROBE_SYMBOL() so they cannot be kprobed. Ftrace and Kprobe
code can call the unwinder.

Redefine the unwinder loop and make it similar to other architectures.
Define the following:

	unwind_start(&frame, task, fp, pc);
	while (unwind_consume(&frame, consume_entry, cookie))
		unwind_next(&frame);
	return !unwind_failed(&frame);

unwind_start()
	Same as the original start_backtrace().

unwind_consume()
	This new function does two things:

	- Calls consume_entry() to consume the return PC.

	- Implements checks to determine whether the unwind should continue
	  or terminate.

unwind_next()
	Same as the original unwind_frame() except:

	- the stack trace termination check has been moved from here to
	  unwind_consume(). So, unwind_next() assumes that the fp is valid.

	- unwind_frame() used to return an error value. This function only
	  sets internal state and does not return anything. The state is
	  retrieved via a helper. See next.

unwind_failed()
	Return a boolean to indicate whether the stack trace completed
	successfully or failed. arch_stack_walk() ignores the return
	value. But arch_stack_walk_reliable() in the future will look
	at the return value.

Unwind status
	Introduce a new flag called "failed" in struct stackframe. Set this
	flag when an error is encountered. If this flag is set, terminate
	the unwind. Also, let the unwinder return the status to the caller.

Reliability checks
==================

There are some kernel features and conditions that make a stack trace
unreliable. Callers may require the unwinder to detect these cases.
E.g., livepatch.

Introduce a new function called unwind_is_reliable() that will detect
these cases and return a boolean.

Introduce a new argument to unwind() called "need_reliable" so a caller
can tell unwind() that it requires a reliable stack trace. For such a
caller, any unreliability in the stack trace must be treated as a fatal
error and the unwind must be aborted.

Call unwind_is_reliable() from unwind_consume() like this:

	if (frame->need_reliable && !unwind_is_reliable(frame)) {
		frame->failed = true;
		return false;
	}

arch_stack_walk() passes "false" for need_reliable because its callers
don't care about reliability. arch_stack_walk() is used for debug and
test purposes.

Introduce arch_stack_walk_reliable() for ARM64. This works like
arch_stack_walk() except for two things:

	- It passes "true" for need_reliable.

	- It returns -EINVAL if unwind() aborts.

Introduce the first reliability check in unwind_is_reliable() - If
a return PC is not a valid kernel text address, consider the stack
trace unreliable. It could be some generated code.

Other reliability checks will be added in the future. Until all of the
checks are in place, arch_stack_walk_reliable() may not be used by
livepatch. But it may be used by debug and test code.

SYM_CODE check
==============

SYM_CODE functions do not follow normal calling conventions. They cannot
be unwound reliably using the frame pointer. Collect the address ranges
of these functions in a special section called "sym_code_functions".

In unwind_is_reliable(), check the return PC against these ranges. If a
match is found, then consider the stack trace unreliable. This is the
second reliability check introduced by this work.

Last stack frame
----------------

If a SYM_CODE function occurs in the very last frame in the stack trace,
then the stack trace is not considered unreliable. This is because there
is no more unwinding to do. Examples:

	- EL0 exception stack traces end in the top level EL0 exception
	  handlers.

	- All kernel thread stack traces end in ret_from_fork().
---
Changelog:

v7:
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

v6: https://lore.kernel.org/linux-arm-kernel/20210630223356.58714-1-madvenka@linux.microsoft.com/
v5: https://lore.kernel.org/linux-arm-kernel/20210526214917.20099-1-madvenka@linux.microsoft.com/
v4: https://lore.kernel.org/linux-arm-kernel/20210516040018.128105-1-madvenka@linux.microsoft.com/
v3: https://lore.kernel.org/linux-arm-kernel/20210503173615.21576-1-madvenka@linux.microsoft.com/
v2: https://lore.kernel.org/linux-arm-kernel/20210405204313.21346-1-madvenka@linux.microsoft.com/
v1: https://lore.kernel.org/linux-arm-kernel/20210330190955.13707-1-madvenka@linux.microsoft.com/
Madhavan T. Venkataraman (4):
  arm64: Make all stack walking functions use arch_stack_walk()
  arm64: Reorganize the unwinder code for better consistency and
    maintenance
  arm64: Introduce stack trace reliability checks in the unwinder
  arm64: Create a list of SYM_CODE functions, check return PC against
    list

 arch/arm64/include/asm/linkage.h    |  12 ++
 arch/arm64/include/asm/sections.h   |   1 +
 arch/arm64/include/asm/stacktrace.h |  16 +-
 arch/arm64/kernel/perf_callchain.c  |   5 +-
 arch/arm64/kernel/process.c         |  39 ++--
 arch/arm64/kernel/return_address.c  |   6 +-
 arch/arm64/kernel/stacktrace.c      | 291 ++++++++++++++++++++--------
 arch/arm64/kernel/time.c            |  22 ++-
 arch/arm64/kernel/vmlinux.lds.S     |  10 +
 9 files changed, 277 insertions(+), 125 deletions(-)


base-commit: 36a21d51725af2ce0700c6ebcb6b9594aac658a6
-- 
2.25.1

