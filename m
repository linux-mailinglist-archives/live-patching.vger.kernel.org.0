Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12A53547B8
	for <lists+live-patching@lfdr.de>; Mon,  5 Apr 2021 22:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235671AbhDEUna (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 5 Apr 2021 16:43:30 -0400
Received: from linux.microsoft.com ([13.77.154.182]:36148 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237190AbhDEUna (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 5 Apr 2021 16:43:30 -0400
Received: from x64host.home (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id DB99020B39FD;
        Mon,  5 Apr 2021 13:43:22 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DB99020B39FD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617655403;
        bh=SlDME/9AuFX8jUD0WBWKSnHjXALRVZ6WWaOd9ahbIJo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=np/oZhF1XminpmGJ1kSAIvtqvuaQks9cmc361zoDOtbswfFD7vY5b94TPyFuJSckK
         DNCSlYsiJBYJMQpIP1Fr8Ub8OfjkITmnDtvcbLiy1uXhsVY2ZW6EC2UDaEfMPG0sip
         aUmxAhFcPXvlbfuymGpkPWLkpbOOCR8Wg7+utI1w=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 0/4] arm64: Implement stack trace reliability checks
Date:   Mon,  5 Apr 2021 15:43:09 -0500
Message-Id: <20210405204313.21346-1-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
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
fill that gap.

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

To detect stack traces from a tracer function, add the following to
special_functions[]:

	- ftrace_call + 4

ftrace_call is the label at which the tracer function is patched in. So,
ftrace_call + 4 is its return address. This is what will show up in a
stack trace taken from the tracer function.

When Function Graph Tracing is on, ftrace_graph_caller is patched in
at the label ftrace_graph_call. If a tracer function called before it has
redirected execution as mentioned above, the stack traces taken from within
ftrace_graph_caller will also be unreliable for the same reason as mentioned
above. So, add ftrace_graph_caller to special_functions[] as well.

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

Optprobes
=========

Optprobes may be implemented in the future for arm64. For optprobes,
the relevant trampoline(s) can be added to special_functions[].
---
Changelog:

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

v2
	- Removed the terminating entry { 0, 0 } in special_functions[]
	  and replaced it with the idiom { /* sentinel */ }.

	- Change the ftrace trampoline entry ftrace_graph_call in
	  special_functions[] to ftrace_call + 4 and added explanatory
	  comments.

	- Unnested #ifdefs in special_functions[] for FTRACE.

Madhavan T. Venkataraman (4):
  arm64: Implement infrastructure for stack trace reliability checks
  arm64: Mark a stack trace unreliable if an EL1 exception frame is
    detected
  arm64: Detect FTRACE cases that make the stack trace unreliable
  arm64: Mark stack trace as unreliable if kretprobed functions are
    present

 arch/arm64/include/asm/exception.h  |   8 ++
 arch/arm64/include/asm/stacktrace.h |   2 +
 arch/arm64/kernel/entry-ftrace.S    |  12 ++
 arch/arm64/kernel/entry.S           |  14 +-
 arch/arm64/kernel/stacktrace.c      | 215 ++++++++++++++++++++++++++++
 5 files changed, 244 insertions(+), 7 deletions(-)


base-commit: 0d02ec6b3136c73c09e7859f0d0e4e2c4c07b49b
-- 
2.25.1

