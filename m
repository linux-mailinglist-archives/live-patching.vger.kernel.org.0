Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0508033C2D1
	for <lists+live-patching@lfdr.de>; Mon, 15 Mar 2021 17:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbhCOQ6m (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 15 Mar 2021 12:58:42 -0400
Received: from linux.microsoft.com ([13.77.154.182]:51014 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbhCOQ6L (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 15 Mar 2021 12:58:11 -0400
Received: from x64host.home (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8661B20B26E1;
        Mon, 15 Mar 2021 09:58:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8661B20B26E1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1615827491;
        bh=2IkLEY7rVpHOq8BnHCSOXhCoOChzmb9iFYxXyHpHlLY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=bOMGK6jhSSZAE3G6a/J4nJT9kIHG9Xay1WkstxQj1b4yPbS4YWb9PC2XG4pCYNay7
         z9rIyQ3D+RILG/3cvhTE93IQdxL2fehUiD5CXwqsdqiP6IO2vwJ6tjCZs5xF8U9Lb4
         Wt8kzJgFnPhG1h3w2vqPtw5vdsY36po0fLTKc7EQ=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, mark.rutland@arm.com, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 0/8] arm64: Implement reliable stack trace
Date:   Mon, 15 Mar 2021 11:57:52 -0500
Message-Id: <20210315165800.5948-1-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <5997dfe8d261a3a543667b83c902883c1e4bd270>
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

I have made an attempt to implement reliable stack trace for arm64 so
it can be used for livepatch. Below is the list of changes. I have
documented my understanding of the issues and solutions below as well
as in the patch descriptions and the code. Please let me know if my
understanding is incorrect or incomplete anywhere.

Stack termination record
========================

The unwinder needs to be able to reliably tell when it has reached the end
of a stack trace. One way to do this is to have the last stack frame at a
fixed offset from the base of the task stack. When the unwinder reaches
that offset, it knows it is done.

All tasks have a pt_regs structure right after the task stack in the stack
page. The pt_regs structure contains a stackframe field. Make this stackframe
field the last frame in the task stack so all stack traces end at a fixed
stack offset.

For kernel tasks, this is simple to understand. For user tasks, there is
some extra detail. User tasks get created via fork() et al. Once they return
from fork, they enter the kernel only on an EL0 exception. In arm64,
system calls are also EL0 exceptions.

The EL0 exception handler uses the task pt_regs mentioned above to save
register state and call different exception functions. All stack traces
from EL0 exception code must end at the pt_regs. So, make pt_regs->stackframe
the last frame in the EL0 exception stack.

To summarize, task_pt_regs(task)->stackframe will always be the stack
termination record.

Implement frame types
=====================

Apart from the task pt_regs, pt_regs is also created on the stack for two
other cases:

EL1 exceptions:
	When the kernel encounters an exception (more on this below),
	it is called an EL1 exception. A pt_regs is created on the
	stack at that point to save register state. In addition,
	pt_regs->stackframe is set up for the interrupted kernel function
	so that the function shows up in the EL1 exception stack trace.

Ftrace:
	When CONFIG_DYNAMIC_FTRACE_WITH_REGS is on, the ftrace infrastructure
	is called at the beginning of a traced function, ftrace creates a
	pt_regs on the stack at that point to save register state. In addition,
	it sets up pt_regs->stackframe for the traced function so that the
	traced function shows up in the stack trace taken from anywhere in
	the ftrace code after that point. When the ftrace code returns to the
	traced function, the pt_regs is removed from the stack.

To summarize, pt_regs->stackframe is used as a marker frame in stack traces.
To enable the unwinder to detect these frames, tag each pt_regs->stackframe
with a type. To record the type, use the unused2 field in struct pt_regs and
rename it to frame_type. The types are:

TASK_FRAME
	Terminating frame for a normal stack trace.
EL0_FRAME
	Terminating frame for an EL0 exception.
EL1_FRAME
	EL1 exception frame.
FTRACE_FRAME
	FTRACE frame.

These frame types will be used by the unwinder later to validate frames.

Proper termination of the stack trace
=====================================

In the unwinder, check the following for properly terminating the stack
trace:

	- Check every frame to see if it is task_pt_regs(stack)->stackframe.
	  If it is, terminate the stack trace successfully.

	- For additional validation, make sure that the frame_type is either
	  TASK_FRAME or EL0_FRAME.

Detect EL1 frame
================

The kernel runs at Exception Level 1. If an exception happens while
executing in the kernel, it is an EL1 exception. This includes interrupts
which are asynchronous exceptions in arm64.

EL1 exceptions can happen on any instruction including instructions in
the frame pointer prolog or epilog. Depending on where exactly they happen,
they could render the stack trace unreliable.

If an EL1 exception frame is found on the stack, mark the stack trace as
unreliable.

Now, the EL1 exception frame is not at any well-known offset on the stack.
It can be anywhere on the stack. In order to properly detect an EL1
exception frame, some checks must be done. See the patch description and
the code for more detail.

There are two special cases to be aware of:

	- At the end of an interrupt, the code checks if the current task
	  must be preempted for any reason. If so, it calls the preemption
	  code which takes the task off the CPU. A stack trace taken on
	  the task after the preemption will show the EL1 frame and will be
	  considered unreliable. Preemption can happen practically at any
	  point in code including the frame pointer prolog and epilog.

	- Breakpoints encountered in kernel code are also EL1 exceptions.
	  The probing infrastructure uses breakpoints for executing
	  probe code. While in the probe code, the stack trace will show
	  an EL1 frame and will be considered unreliable. There is one
	  special case, viz, kretprobe which is discussed below.

Detect ftrace frame
===================

The ftrace infrastructure called for a traced function creates two frames:

	- One for the traced function

	- One for the caller of the traced function

That gives a reliable stack trace while executing in the ftrace infrastructure
code. When ftrace returns to the traced function, the frames are popped and
everything is back to normal.

However, in cases like live patch, execution is redirected to a different
function when ftrace returns. A stack trace taken while still in the ftrace
infrastructure code will not show the target function. The target function
is the real function that we want to track.

If an ftrace frame is detected on the stack, mark the stack trace as
unreliable.

NOTE: For Function Graph Tracing where the return address of a function is
modified, the unwinder already has code to address that. It retrieves the
original address during unwinding.

Return address check
====================

Check the return PC of every stack frame to make sure that it is a valid
kernel text address (and not some generated code, for example).

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
will not show.

So, if the trampoline is detected in the stack trace, mark the stack trace
as unreliable.

FYI, each task contains a task->kretprobe_instances list that can
theoretically be consulted to find the orginal return address. But I am
not entirely sure how to safely traverse that list for stack traces
not on the current process.

I have taken the easy way out and marked the stack trace as unreliable.

Optprobes
=========

Optprobes may be implemented in the future for arm64. For optprobes, the
same approach to detect them as kretprobes will work.

Frame checks
============

I have a number of checks to make sure that the unwinder detects each frame
type correctly. So, I have not added a return address check. The return
address checks that could be added are:

TASK_FRAME
	Check for ret_from_fork().

EL0_FRAME
	Check for one of these:
		el0_sync
		el0_sync_compat
		el0_irq
		el0_irq_compat
		el0_error
		el0_error_compat

EL1_FRAME
	Check for one of these:
		el1_sync
		el1_irq
		el1_error

Currently these functions are local functions. Would need to make them
global so the unwinder can reference them. Also, Mark Rutland indicated
that these might need some reorg.

So, I am currently not doing these address checks at the frames. But if
the reviewers feel that I need to do them, I will add these checks.

Implement arch_stack_walk_reliable()
====================================

Now that the unwinder can mark the stack trace as reliable (or not),
implement arch_stack_walk_reliable() based on that.
---

Changelog:

v1
	- Introduced an implementation of reliable stack trace for arm64.

v2
	- Split the changes into logical individual patches.

	- I have inlined the code that was in a function called
	  update_frame() in unwind_frame() itself.

	- I have added a lot of documentation to record my
	  understanding of the issues and my solutions for them so
	  reviewers can comment on them.

	- In v1, all task stack traces ended in the same global frame.
	  I have changed that to a per-task termination record in the
	  task pt_regs->stackframe. This way, the stack trace always
	  ends at a particular stack offset.

	- The stack termination frame also contains FP == 0 and PC == 0
	  so that debuggers will continue to work when they take stack
	  traces.

	- I have removed the encoding of the frame pointer by setting the
	  LSB as it will mess up debuggers when they do stack traces.

	- I have implemented a frame type field in pt_regs. Each type of
	  frame is tagged with a specific pattern that can be checked by
	  the unwinder to validate the frame.

	- I have added the following reliability checks in the unwinder:

		- Check for proper stack trace termintaion

		- Check for EL1 exception frames

		- Check for ftrace exception frames

		- Check if the PC in every frame is a proper kernel text
		  address

		- Check for the kretprobed functions

	- Based on the above unwinder enhancements, I have implemented
	  arch_stack_walk_reliable().

Madhavan T. Venkataraman (8):
  arm64: Implement stack trace termination record
  arm64: Implement frame types
  arm64: Terminate the stack trace at TASK_FRAME and EL0_FRAME
  arm64: Detect an EL1 exception frame and mark a stack trace unreliable
  arm64: Detect an FTRACE frame and mark a stack trace unreliable
  arm64: Check the return PC of every stack frame
  arm64: Detect kretprobed functions in stack trace
  arm64: Implement arch_stack_walk_reliable()

 arch/arm64/Kconfig                  |   1 +
 arch/arm64/include/asm/ptrace.h     |  15 ++-
 arch/arm64/include/asm/stacktrace.h |   2 +
 arch/arm64/kernel/asm-offsets.c     |   1 +
 arch/arm64/kernel/entry-ftrace.S    |   2 +
 arch/arm64/kernel/entry.S           |  12 +-
 arch/arm64/kernel/head.S            |  30 ++++-
 arch/arm64/kernel/process.c         |   6 +
 arch/arm64/kernel/stacktrace.c      | 196 +++++++++++++++++++++++++++-
 9 files changed, 250 insertions(+), 15 deletions(-)


base-commit: a38fd8748464831584a19438cbb3082b5a2dab15
-- 
2.25.1

