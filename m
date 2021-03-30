Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757DC34F171
	for <lists+live-patching@lfdr.de>; Tue, 30 Mar 2021 21:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbhC3TKZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Mar 2021 15:10:25 -0400
Received: from linux.microsoft.com ([13.77.154.182]:33602 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbhC3TKD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Mar 2021 15:10:03 -0400
Received: from x64host.home (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 6BB4C209A3BE;
        Tue, 30 Mar 2021 12:10:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6BB4C209A3BE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617131403;
        bh=GG8kxVyRHUszynZLbaLmaYkDzGRIdEPCAJXZRlpOYEc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=j4afsZ4c/srg0At0bkV35OdtQecnlyv/VmW2nQILG0S0df4/iRe0DMab6sag+eOdq
         WRunfBwRqN3r3bHHalYyoOHshAA6H777iunyWblj5l5NBoh7WbPsfRCTQCgbFa/K/H
         5mvN5rnjsKBiTuuy22skRQrawX0iicrR5L1PCms0=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v1 0/4] arm64: Implement stack trace reliability checks
Date:   Tue, 30 Mar 2021 14:09:51 -0500
Message-Id: <20210330190955.13707-1-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <77bd5edeea72d44533c769b1e8c0fea7a9d7eb3a>
References: <77bd5edeea72d44533c769b1e8c0fea7a9d7eb3a>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

There are a number of places in kernel code where the stack trace is not
reliable. Enhance the unwinder to check for those cases and mark the
stack trace as unreliable. Once all of the checks are in place, the unwinder
can be used for livepatching.

Except for the return address check, all the other checks involve checking
the return PC of every frame against certain kernel functions. To do this,
implement some infrastructure code:

	- Define a special_functions[] array and populate the array with
	  the special functions

	- Using kallsyms_lookup(), lookup the symbol table entries for the
	  functions and record their address ranges

	- Define an is_reliable_function(pc) to match a return PC against
	  the special functions.

The unwinder calls is_reliable_function(pc) for every return PC and marks
the stack trace as reliable or unreliable accordingly.

Return address check
====================

Check the return PC of every stack frame to make sure that it is a valid
kernel text address (and not some generated code, for example).

Detect EL1 exception frame
==========================

EL1 exceptions can happen on any instruction including instructions in
the frame pointer prolog or epilog. Depending on where exactly they happen,
they could render the stack trace unreliable.

Add all of the EL1 exception handlers to special_functions[].

	- el1_sync()
	- el1_irq()
	- el1_error()
	- el1_sync_invalid()
	- el1_irq_invalid()
	- el1_fiq_invalid()
	- el1_error_invalid()

Interrupts are EL1 exceptions. When a task is preempted, the preempt
interrupt EL1 frame will show on the stack and the stack trace is
considered unreliable. This is correct behavior as preemption can
happen anywhere.

Breakpoints are EL1 exceptions and can happen anywhere. Stack traces
taken from within the breakpoint handler are, therefore, unreliable.
This includes KProbe code that gets called from the breakpoint handler.

Mark Rutland wanted me to send the EL1 checks in a separate patch series
because the exception handling code is being reorganized. But the
infrastructure code is common to the EL1 detection and other cases listed
below. I was not entirely sure how to neatly split the patches.

Besides, all this patch does is include the EL1 exception handlers in
special_functions[]. When the names change because of the code reorg,
this array can simply be edited. So, in the interest of getting review
comments on this EL1 related work, I have included it in this patch
series.

Hope this is ok.

Detect ftrace frame
===================

When FTRACE executes at the beginning of a traced function, it creates two
frames and calls the tracer function:

	- One frame for the traced function

	- One frame for the caller of the traced function

That gives a sensible stack trace while executing in the tracer function.
When FTRACE returns to the traced function, the frames are popped and
everything is back to normal.

However, in cases like live patch, the tracer function redirects execution
to a different function. When FTRACE returns, control will go to that target
function. A stack trace taken in the tracer function will not show the target
function. The target function is the real function that we want to track.
So, the stack trace is unreliable.

To detect FTRACE in a stack trace, add the following to special_functions[]:

	- ftrace_graph_call()
	- ftrace_graph_caller()

Please see the diff for a comment that explains why ftrace_graph_call()
must be checked.

Also, the Function Graph Tracer modifies the return address of a traced
function to a return trampoline (return_to_handler()) to gather tracing
data on function return. Stack traces taken from the traced function and
functions it calls will not show the original caller of the traced function.
The unwinder handles this case by getting the original caller from FTRACE.

However, stack traces taken from the trampoline itself and functions it calls
are unreliable as the original return address may not be available in
that context. This is because the trampoline calls FTRACE to gather trace
data as well as to obtain the actual return address and FTRACE discards the
record of the original return address along the way.

Add return_to_handler() to special_functions[].

Check for kretprobe
===================

For functions with a kretprobe set up, probe code executes on entry
to the function and replaces the return address in the stack frame with a
kretprobe trampoline. Whenever the function returns, control is
transferred to the trampoline. The trampoline eventually returns to the
original return address.

A stack trace taken while executing in the function (or in functions that
get called from the function) will not show the original return address.
Similarly, a stack trace taken while executing in the trampoline itself
(and functions that get called from the trampoline) will not show the
original return address. This means that the caller of the probed function
will not show. This makes the stack trace unreliable.

Add the kretprobe trampoline to special_functions[].

FYI, each task contains a task->kretprobe_instances list that can
theoretically be consulted to find the orginal return address. But I am
not entirely sure how to safely traverse that list for stack traces
not on the current process. So, I have taken the easy way out.

Optprobes
=========

Optprobes may be implemented in the future for arm64. For optprobes,
the relevant trampoline(s) can be added to special_functions[].
---
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

Madhavan T. Venkataraman (4):
  arm64: Implement infrastructure for stack trace reliability checks
  arm64: Mark a stack trace unreliable if an EL1 exception frame is
    detected
  arm64: Detect FTRACE cases that make the stack trace unreliable
  arm64: Mark stack trace as unreliable if kretprobed functions are
    present

 arch/arm64/include/asm/exception.h  |   8 ++
 arch/arm64/include/asm/stacktrace.h |   2 +
 arch/arm64/kernel/entry-ftrace.S    |  10 ++
 arch/arm64/kernel/entry.S           |  14 +-
 arch/arm64/kernel/stacktrace.c      | 211 ++++++++++++++++++++++++++++
 5 files changed, 238 insertions(+), 7 deletions(-)


base-commit: 0d02ec6b3136c73c09e7859f0d0e4e2c4c07b49b
-- 
2.25.1

