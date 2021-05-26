Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A9839224E
	for <lists+live-patching@lfdr.de>; Wed, 26 May 2021 23:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234114AbhEZVu7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 26 May 2021 17:50:59 -0400
Received: from linux.microsoft.com ([13.77.154.182]:49968 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbhEZVu6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 26 May 2021 17:50:58 -0400
Received: from x64host.home (unknown [47.187.214.213])
        by linux.microsoft.com (Postfix) with ESMTPSA id DB6BF20B7188;
        Wed, 26 May 2021 14:49:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DB6BF20B7188
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1622065766;
        bh=bM9GQ0Sg+lSJ4odzywaAEY1X2gyc4nUR4J150ur5T9A=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=LRoaQ/ULTOti9AGGEAq7dj7F2rs6DAB/7JSGEJkvJPAsYYJJ+DlS04GPwakuUIsEL
         jwMKNXPUe5q2FdoAhwF08DfOlPAF/BFWf/Sr7fh7qaddWBDWz8o57qGM+30SB7RuH8
         lDCdcKgX6HBkF9kFZhZ02/y3tqcsUIiJ6WEVZtd0=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com, catalin.marinas@arm.com,
        will@kernel.org, jmorris@namei.org, pasha.tatashin@soleen.com,
        jthierry@redhat.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v5 0/2] arm64: Implement stack trace reliability checks
Date:   Wed, 26 May 2021 16:49:15 -0500
Message-Id: <20210526214917.20099-1-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ea0ef9ed6eb34618bcf468fbbf8bdba99e15df7d>
References: <ea0ef9ed6eb34618bcf468fbbf8bdba99e15df7d>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

There are a number of places in kernel code where the stack trace is not
reliable. Enhance the unwinder to check for those cases and mark the
stack trace as unreliable. Once all of the checks are in place, the unwinder
can provide a reliable stack trace. But before this can be used for livepatch,
some other entity needs to guarantee that the frame pointers are all set up
correctly in kernel functions. objtool is currently being worked on to
address that need.

Return address check
====================

Check the return PC of every stack frame to make sure that it is a valid
kernel text address (and not some generated code, for example). If it is
not a valid kernel text address, mark the stack trace as unreliable.

Assembly functions
==================

There are a number of assembly functions in arm64. Except for a couple of
them, these functions do not have a frame pointer prolog or epilog. Also,
many of them manipulate low-level state such as registers. These functions
are, by definition, unreliable from a stack unwinding perspective. That is,
when these functions occur in a stack trace, the unwinder would not be able
to unwind through them reliably.

Assembly functions are defined as SYM_FUNC_*() functions or SYM_CODE_*()
functions. objtool peforms static analysis of SYM_FUNC functions. It ignores
SYM_CODE functions because they have low level code that is difficult to
analyze. When objtool becomes ready eventually, SYM_FUNC functions will
be analyzed and "fixed" as necessary. So, they are not "interesting" for
the reliable unwinder.

That leaves SYM_CODE functions. It is for the unwinder to deal with these
for reliable stack trace. The unwinder needs to do the following:

	- Recognize SYM_CODE functions in a stack trace.

	- If a particular SYM_CODE function can be unwinded through using
	  some special logic, then do it. E.g., the return trampoline for
	  Function Graph Tracing.

	- Otherwise, mark the stack trace unreliable.

Previous approach
=================

Previously, I considered a per-section approach. The following sections
mostly contain SYM_CODE functions:

	.entry.text
	.idmap.text
	.hyp.idmap.text
	.hyp.text
	.hibernate_exit.text
	.entry.tramp.text

So, consider the whole sections unreliable. I created an array of code ranges,
one for each section. The unwinder then checks each return PC against these
sections. If there is a match, the stack trace is unreliable.

Although this approach is reasonable, there are two problems:

	1. There are SYM_FUNC functions in these sections. They also
	   "become" unreliable in this approach. I think that we should
	   be able to specify which functions are reliable and which
	   ones are not in any section.

	2. There are a few SYM_CODE functions in .text and .init.text.
	   These sections contain tons of functions that are reliable.
	   So, I considered moving the SYM_CODE functions into a separate
	   section called ".code.text". I am not convinced that this
	   approach is fine:

	   	- We should be able to place functions in .text and
		  .init.text, if we wanted to.

		- Moving the hypervisor related functions caused reloc
		  issues.

		- Moving things around just to satisfy the unwinder did not
		  seem right.

Current approach
================

In this version, I have taken a simpler approach to solve the issues
mentioned before.

Define an ARM64 version of SYM_CODE_END() like this:

#define SYM_CODE_END(name)				\
	SYM_END(name, SYM_T_NONE)			;\
	99:						;\
	.pushsection "sym_code_functions", "aw"		;\
	.quad	name					;\
	.quad	99b					;\
	.popsection

	NOTE:	I use the numeric label 99 as the end address of a function.
		It does not conflict with anything right now. Please let me
		know if this is OK. I can add a comment that the label 99
		is reserved and should not be used by assembly code.

The above macro does the usual SYM_END(). In addition, it records the
function's address range in a special section called "sym_code_functions".
This way, all SYM_CODE functions get recorded in the section automatically.

Implement an early_initcall() called init_sym_code_functions() that allocates
an array called sym_code_functions[] and copies the function ranges from the
section to the array.

Implement an unwinder_is_unreliable() function that compares a return PC to
the ranges. If there is a match, return true. Else, return false.

Call unwinder_is_unreliable() on every return PC from unwind_frame(). If there
is a match, then mark the stack trace as unreliable.

Last stack frame
================

If a SYM_CODE function occurs in the very last frame in the stack trace,
then the stack trace is not considered unreliable. This is because there
is no more unwinding to do. Examples:

	- EL0 exception stack traces end in the top level EL0 exception
	  handlers.

	- All kernel thread stack traces end in ret_from_fork().

Special SYM_CODE functions
==========================

The return trampolines of the Function Graph Tracer and Kretprobe can
be recognized by the unwinder. If the return PCs can be translated to the
original PCs, then, the unwinder should perform that translation before
checking for reliability. The final PC that we end up with after all the
translations is the one we need to check for reliability.

Accordingly, I have moved the reliability checks to after the logic that
handles the Function Graph Tracer.

So, the approach is - all SYM_CODE functions are unreliable. If a SYM_CODE
function is "fixed" to make it reliable, then it should become a SYM_FUNC
function. Or, if the unwinder has special logic to unwind through a SYM_CODE
function, then that can be done.

Previously, I had some extra code to handle the Function Graph Trace
return trampoline case. I have removed it. Special casing is orthogonal to
this work and can be done separately.

Documentation
=============

Documentation/livepatch/reliable-stacktrace.rst written by Mark Rutland
gives a list of requirements for a reliable unwinder. I have added sufficient
comments in the code so that it is easy to map the requirements to the
code in the unwinder. I have also moved some comments from the previous
cover letter to the code.

Performance
===========

Currently, unwinder_is_unreliable() does a linear search through
sym_code_functions[]. If reviewers prefer, I could sort the
sym_code_functions[] array and perform a binary search for better
performance. There are about 80 entries in the array.

Checkpatch
==========

I am getting the following error on SYM_CODE_END() that I have defined for
arm64. These macros are only used in assembly. I am not sure how to deal
with these. Can someone help?

ERROR: Macros with multiple statements should be enclosed in a do - while loop
#13: FILE: arch/arm64/include/asm/linkage.h:67:
+#define SYM_CODE_END(name)				\
+	SYM_END(name, SYM_T_NONE)			;\
+	99:						;\
+	.pushsection "sym_code_functions", "aw"		;\
+	.quad	name					;\
+	.quad	99b					;\
+	.popsection

CHECK: Macro argument reuse 'name' - possible side-effects?
#13: FILE: arch/arm64/include/asm/linkage.h:67:
+#define SYM_CODE_END(name)				\
+	SYM_END(name, SYM_T_NONE)			;\
+	99:						;\
+	.pushsection "sym_code_functions", "aw"		;\
+	.quad	name					;\
+	.quad	99b					;\
+	.popsection

ERROR: spaces required around that ':' (ctx:VxW)
#15: FILE: arch/arm64/include/asm/linkage.h:69:
+	99:						;\
 	  ^

WARNING: labels should not be indented
#15: FILE: arch/arm64/include/asm/linkage.h:69:
+	99:						;\

total: 2 errors, 1 warnings, 1 checks, 171 lines checked
---
Changelog:

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

v4: https://lore.kernel.org/linux-arm-kernel/20210516040018.128105-1-madvenka@linux.microsoft.com/
v3: https://lore.kernel.org/linux-arm-kernel/20210503173615.21576-1-madvenka@linux.microsoft.com/
v2: https://lore.kernel.org/linux-arm-kernel/20210405204313.21346-1-madvenka@linux.microsoft.com/
v1: https://lore.kernel.org/linux-arm-kernel/20210330190955.13707-1-madvenka@linux.microsoft.com/

Madhavan T. Venkataraman (2):
  arm64: Introduce stack trace reliability checks in the unwinder
  arm64: Create a list of SYM_CODE functions, check return PC against
    list

 arch/arm64/include/asm/linkage.h    |  12 +++
 arch/arm64/include/asm/sections.h   |   1 +
 arch/arm64/include/asm/stacktrace.h |   9 ++
 arch/arm64/kernel/stacktrace.c      | 154 +++++++++++++++++++++++++++-
 arch/arm64/kernel/vmlinux.lds.S     |   7 ++
 5 files changed, 178 insertions(+), 5 deletions(-)


base-commit: bf05bf16c76bb44ab5156223e1e58e26dfe30a88
-- 
2.25.1

