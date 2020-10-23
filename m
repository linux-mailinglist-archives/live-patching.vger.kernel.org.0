Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9616D297265
	for <lists+live-patching@lfdr.de>; Fri, 23 Oct 2020 17:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S465773AbgJWPfk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 23 Oct 2020 11:35:40 -0400
Received: from foss.arm.com ([217.140.110.172]:55304 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S462565AbgJWPfj (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 23 Oct 2020 11:35:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A7B0B113E;
        Fri, 23 Oct 2020 08:35:37 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 184683F66E;
        Fri, 23 Oct 2020 08:35:35 -0700 (PDT)
From:   Mark Rutland <mark.rutland@arm.com>
To:     linux-kernel@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, linux-doc@vgert.kernel.org,
        live-patching@vger.kernel.org
Subject: [PATCH] Documentation: livepatch: document reliable stacktrace
Date:   Fri, 23 Oct 2020 16:35:27 +0100
Message-Id: <20201023153527.36346-1-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Add documentation for reliable stacktrace. This is intended to describe
the semantics and to be an aid for implementing architecture support for
HAVE_RELIABLE_STACKTRACE.

Unwinding is a subtle area, and architectures vary greatly in both
implementation and the set of concerns that affect them, so I've tried
to avoid making this too specific to any given architecture. I've used
examples from both x86_64 and arm64 to explain corner cases in more
detail, but I've tried to keep the descriptions sufficient for those who
are unfamiliar with the particular architecture.

I've tried to give rationale for all the recommendations/requirements,
since that makes it easier to spot nearby issues, or when a check
happens to catch a few things at once. I believe what I have written is
sound, but as some of this was reverse-engineered I may have missed
things worth noting.

I've made a few assumptions about preferred behaviour, notably:

* If you can reliably unwind through exceptions, you should (as x86_64
  does).

* It's fine to omit ftrace_return_to_handler and other return
  trampolines so long as these are not subject to patching and the
  original return address is reported. Most architectures do this for
  ftrace_return_handler, but not other return trampolines.

* For cases where link register unreliability could result in duplicate
  entries in the trace or an inverted trace, I've assumed this should be
  treated as unreliable. This specific case shouldn't matter to
  livepatching, but I assume that that we want a reliable trace to have
  the correct order.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: linux-doc@vgert.kernel.org
Cc: live-patching@vger.kernel.org
---
 Documentation/livepatch/index.rst               |   1 +
 Documentation/livepatch/reliable-stacktrace.rst | 303 ++++++++++++++++++++++++
 2 files changed, 304 insertions(+)
 create mode 100644 Documentation/livepatch/reliable-stacktrace.rst

diff --git a/Documentation/livepatch/index.rst b/Documentation/livepatch/index.rst
index 525944063be7a..43cce5fad705f 100644
--- a/Documentation/livepatch/index.rst
+++ b/Documentation/livepatch/index.rst
@@ -13,6 +13,7 @@ Kernel Livepatching
     module-elf-format
     shadow-vars
     system-state
+    reliable-stacktrace
 
 .. only::  subproject and html
 
diff --git a/Documentation/livepatch/reliable-stacktrace.rst b/Documentation/livepatch/reliable-stacktrace.rst
new file mode 100644
index 0000000000000..d296c93f6f0e0
--- /dev/null
+++ b/Documentation/livepatch/reliable-stacktrace.rst
@@ -0,0 +1,303 @@
+===================
+Reliable Stacktrace
+===================
+
+This document outlines basic information about reliable stacktracing.
+
+.. Table of Contents:
+
+    1. Introduction
+    2. Requirements
+    3. Considerations
+       3.1 Identifying successful termination
+       3.2 Identifying unwindable code
+       3.3 Unwinding across interrupts and exceptions
+       3.4 Rewriting of return addresses
+       3.5 Obscuring of return addresses
+       3.6 Link register unreliability
+
+1. Introduction
+===============
+
+The kernel livepatch consistency model relies on accurately identifying which
+functions may have live state and therefore may not be safe to patch. One way
+to identify which functions are live is to use a stacktrace.
+
+Existing stacktrace code may not always give an accurate picture of all
+functions with live state, and best-effort approaches which can be helpful for
+debugging are unsound for livepatching. Livepatching depends on architectures
+to provide a *reliable* stacktrace which ensures it never omits any live
+functions from a trace.
+
+
+2. Requirements
+===============
+
+Architectures must implement one of the reliable stacktrace functions.
+Architectures using CONFIG_ARCH_STACKWALK should implement
+'arch_stack_walk_reliable', and other architectures should implement
+'save_stack_trace_tsk_reliable'.
+
+Principally, the reliable stacktrace function must ensure that either:
+
+* The trace includes all functions that the task may be returned to, and the
+  return code is zero to indicate that the trace is reliable.
+
+* The return code is non-zero to indicate that the trace is not reliable.
+
+.. note::
+   In some cases it is legitimate to omit specific functions from the trace,
+   but all other functions must be reported. These cases are described in
+   futher detail below.
+
+Secondly, the reliable stacktrace function should be robust to cases where the
+stack or other unwind state is corrupt or otherwise unreliable. The function
+should attempt to detect such cases and return a non-zero error code, and
+should not get stuck in an infinite loop or access memory in an unsafe way.
+Specific cases are described in further detail below.
+
+
+3. Considerations
+=================
+
+The unwinding process varies across architectures, their respective procedure
+call standards, and kernel configurations. This section describes common
+details that architectures should consider.
+
+3.1 Identifying successful termination
+--------------------------------------
+
+Unwinding may terminate early for a number of reasons, including:
+
+* Stack or frame pointer corruption.
+
+* Missing unwind support for an uncommon scenario, or a bug in the unwinder.
+
+* Dynamically generated code (e.g. eBPF) or foreign code (e.g. EFI runtime
+  services) not following the conventions expected by the unwinder.
+
+To ensure that this does not result in functions being omitted from the trace,
+even if not caught by other checks, it is strongly recommended that
+architectures verify that a stacktrace ends at an expected location, e.g.
+
+* Within a specific function that is an entry point to the kernel.
+
+* At a specific location on a stack expected for a kernel entry point.
+
+* On a specific stack expected for a kernel entry point (e.g. if the
+  architecture has separate task and IRQ stacks).
+
+3.2 Identifying unwindable code
+-------------------------------
+
+Unwinding typically relies on code following specific conventions (e.g.
+manipulating a frame pointer), but there can be code which may not follow these
+conventions and may require special handling in the unwinder, e.g.
+
+* Exception vectors and entry assembly.
+
+* Procedure Linkage Table (PLT) entries and veneer functions.
+
+* Trampoline assembly (e.g. ftrace, kprobes).
+
+* Dynamically generated code (e.g. eBPF, optprobe trampolines).
+
+* Foreign code (e.g. EFI runtime services).
+
+To ensure that such cases do not result in functions being omitted from a
+trace, it is strongly recommended that architectures positively identify code
+which is known to be reliable to unwind from, and reject unwinding from all
+other code.
+
+Kernel code including modules and eBPF can be distinguished from foreign code
+using '__kernel_text_address()'. Checking for this also helps to detect stack
+corruption.
+
+There are several ways an architecture may identify kernel code which is deemed
+unreliable to unwind from, e.g.
+
+* Using metadata created by objtool, with such code annotated with
+  SYM_CODE_{START,END} or STACKFRAME_NON_STANDARD().
+
+* Placing such code into special linker sections, and rejecting unwinding from
+  any code in these sections.
+
+* Identifying specific portions of code using bounds information.
+
+3.3 Unwinding across interrupts and exceptions
+----------------------------------------------
+
+At function call boundaries the stack and other unwind state is expected to be
+in a consistent state suitable for reliable unwinding, but this may not be the
+case part-way through a function. For example, during a function prologue or
+epilogue a frame pointer may be transiently invalid, or during the function
+body the return address may be held in an arbitrary general purpose register.
+For some architectures this may change at runtime as a result of dynamic
+instrumentation.
+
+If an interrupt or other exception is taken while the stack or other unwind
+state is in an inconsistent state, it may not be possible to reliably unwind,
+and it may not be possible to identify whether such unwinding will be reliable.
+See below for examples.
+
+Architectures which cannot identify when it is reliable to unwind such cases
+(or where it is never reliable) should reject unwinding across exception
+boundaries. Note that it may be reliable to unwind across certain exceptions
+(e.g. IRQ) but unreliable to unwind across other exceptions (e.g. NMI).
+
+Architectures which can identify when it is reliable to unwind such cases (or
+have no such cases) should attempt to unwind across exception boundaries, as
+doing so can prevent unnecessarily stalling livepatch consistency checks and
+permits livepatch transitions to complete more quickly.
+
+3.4 Rewriting of return addresses
+---------------------------------
+
+Some trampolines temporarily modify the return address of a function in order
+to intercept when that function returns with a return trampoline, e.g.
+
+* An ftrace trampoline may modify the return address so that function graph
+  tracing can intercept returns.
+
+* A kprobes (or optprobes) trampoline may modify the return address so that
+  kretprobes can intercept returns.
+
+When this happens, the original return address will not be in its usual
+location. For trampolines which are not subject to live patching, where an
+unwinder can reliably determine the original return address and no unwind state
+is altered by the trampoline, the unwinder may report the original return
+address in place of the trampoline and report this as reliable. Otherwise, an
+unwinder must report these cases as unreliable.
+
+Special care is required when identifying the original return address, as this
+information is not in a consistent location for the duration of the entry
+trampoline or return trampoline. For example, considering the x86_64
+'return_to_handler' return trampoline:
+
+.. code-block:: none
+
+   SYM_CODE_START(return_to_handler)
+           UNWIND_HINT_EMPTY
+           subq  $24, %rsp
+
+           /* Save the return values */
+           movq %rax, (%rsp)
+           movq %rdx, 8(%rsp)
+           movq %rbp, %rdi
+
+           call ftrace_return_to_handler
+
+           movq %rax, %rdi
+           movq 8(%rsp), %rdx
+           movq (%rsp), %rax
+           addq $24, %rsp
+           JMP_NOSPEC rdi
+   SYM_CODE_END(return_to_handler)
+
+While the traced function runs its return address points on the stack points to
+the start of return_to_handler, and the original return address is stored in
+the task's cur_ret_stack. During this time the unwinder can find the return
+address using ftrace_graph_ret_addr().
+
+When the traced function returns to return_to_handler, there is no longer a
+return address on the stack, though the original return address is still stored
+in the task's cur_ret_stack. Within ftrace_return_to_handler(), the original
+return address is removed from cur_ret_stack and is transiently moved
+arbitrarily by the compiler before being returned in rax. The return_to_handler
+trampoline moves this into rdi before jumping to it.
+
+Architectures might not always be able to unwind such sequences, such as when
+ftrace_return_to_handler() has removed the address from cur_ret_stack, and the
+location of the return address cannot be reliably determined.
+
+It is recommended that architectures unwind cases where return_to_handler has
+not yet been returned to, but architectures are not required to unwind from the
+middle of return_to_handler and can report this as unreliable. Architectures
+are not required to unwind from other trampolines which modify the return
+address.
+
+3.5 Obscuring of return addresses
+---------------------------------
+
+Some trampolines do not rewrite the return address in order to intercept
+returns, but do transiently clobber the return address or other unwind state.
+
+For example, the x86_64 implementation of optprobes patches the probed function
+with a JMP instruction which targets the associated optprobe trampoline. When
+the probe is hit, the CPU will branch to the optprobe trampoline, and the
+address of the probed function is not held in any register or on the stack.
+
+Similarly, the arm64 implementation of DYNAMIC_FTRACE_WITH_REGS patches traced
+functions with the following:
+
+.. code-block:: none
+
+   MOV X9, X30
+   BL <trampoline>
+
+The MOV saves the link register (X30) into X9 to preserve the return address
+before the BL clobbers the link register and branches to the trampoline. At the
+start of the trampoline, the address of the traced function is in X9 rather
+than the link register as would usually be the case.
+
+Architectures should ensure that unwinders either reliably unwind such cases,
+or report the unwinding as unreliable.
+
+3.6 Link register unreliability
+-------------------------------
+
+On some other architectures, 'call' instructions place the return address into a
+link register, and 'return' instructions consume the return address from the
+link register without modifying the register. On these architectures software
+must save the return address to the stack prior to making a function call. Over
+the duration of a function call, the return address may be held in the link
+register alone, on the stack alone, or in both locations.
+
+Unwinders typically assume the link register is always live, but this
+assumption can lead to unreliable stack traces. For example, consider the
+following arm64 assembly for a simple function:
+
+.. code-block:: none
+
+   function:
+           STP X29, X30, [SP, -16]!
+           MOV X29, SP
+           BL <other_function>
+           LDP X29, X30, [SP], #16
+           RET
+
+At entry to the function, the link register (x30) points to the caller, and the
+frame pointer (X29) points to the caller's frame including the caller's return
+address. The first two instructions create a new stackframe and update the
+frame pointer, and at this point the link register and the frame pointer both
+describe this function's return address. A trace at this point may describe
+this function twice, and if the function return is being traced, the unwinder
+may consume two entries from the fgraph return stack rather than one entry.
+
+The BL invokes 'other_function' with the link register pointing to this
+function's LDR and the frame pointer pointing to this function's stackframe.
+When 'other_function' returns, the link register is left pointing at the BL,
+and so a trace at this point could result in 'function' appearing twice in the
+backtrace.
+
+Similarly, a function may deliberately clobber the LR, e.g.
+
+.. code-block:: none
+
+   caller:
+           STP X29, X30, [SP, -16]!
+           MOV X29, SP
+           ADR LR, <callee>
+           BLR LR
+           LDP X29, X30, [SP], #16
+           RET
+
+The ADR places the address of 'callee' into the LR, before the BLR branches to
+this address. If a trace is made immediately after the ADR, 'callee' will
+appear to be the parent of 'caller', rather than the child.
+
+Due to cases such as the above, it may only be possible to reliably consume a
+link register value at a function call boundary. Architectures where this is
+the case must reject unwinding across exception boundaries unless they can
+reliably identify when the LR or stack value should be used (e.g. using
+metadata generated by objtool).
-- 
2.11.0

