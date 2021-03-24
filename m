Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F383480E0
	for <lists+live-patching@lfdr.de>; Wed, 24 Mar 2021 19:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237391AbhCXSrB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 24 Mar 2021 14:47:01 -0400
Received: from linux.microsoft.com ([13.77.154.182]:57474 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237532AbhCXSqg (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 24 Mar 2021 14:46:36 -0400
Received: from x64host.home (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id CD89720B5680;
        Wed, 24 Mar 2021 11:46:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CD89720B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1616611596;
        bh=/DQ0Kpr6KrIt6d8Mcz3Cfl93aJt8TaoUE+dzxu5+xMc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=bhn7c10geVPdJG/vxrJ9h2WuUMZKX/mlZQHOKRsUpVgRpPl03f5COUpFd4KC18/yr
         EAxlelM7NrsTSevOm+Ci+m3RCTifs6wDZmd01LTKIaoQSVmPEdOxuCCnygmKo9yvlg
         p0q0BFUjbXEppZuyA/NTrs3MgiazVfozsYtOtpkA=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v1 0/1] arm64: Implement stack trace termination record
Date:   Wed, 24 Mar 2021 13:46:06 -0500
Message-Id: <20210324184607.120948-1-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <b6144b5b1dc66bf775fe66374bba31af7e5f1d54>
References: <b6144b5b1dc66bf775fe66374bba31af7e5f1d54>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

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

Sample stack traces
===================

These stack traces were taken using a test driver called callfd from
certain locations.

Primary CPU's idle task
=======================

[    0.022932]   arch_stack_walk+0x0/0xd0
[    0.022944]   callfd_stack+0x30/0x60
[    0.022955]   rest_init+0xd8/0xf8
[    0.022968]   arch_call_rest_init+0x18/0x24
[    0.022984]   start_kernel+0x5b8/0x5f4
[    0.022993]   ret_from_fork+0x0/0x18

Secondary CPU's idle task
=========================

[    0.023043]   arch_stack_walk+0x0/0xd0
[    0.023052]   callfd_stack+0x30/0x60
[    0.023061]   secondary_start_kernel+0x188/0x1e0
[    0.023071]   ret_from_fork+0x0/0x18

Sample kernel thread
====================

[   12.000679]   arch_stack_walk+0x0/0xd0
[   12.007616]   callfd_stack+0x30/0x60
[   12.014347]   kernel_init+0x84/0x148
[   12.021026]   ret_from_fork+0x10/0x18

kernel_clone() system call
==========================

Showing EL0 exception:

[  364.152827]   arch_stack_walk+0x0/0xd0
[  364.152833]   callfd_stack+0x30/0x60
[  364.152839]   kernel_clone+0x57c/0x590
[  364.152846]   __do_sys_clone+0x58/0x88
[  364.152851]   __arm64_sys_clone+0x28/0x38
[  364.152856]   el0_svc_common.constprop.0+0x70/0x1a8
[  364.152863]   do_el0_svc+0x2c/0x98
[  364.152868]   el0_svc+0x2c/0x70
[  364.152873]   el0_sync_handler+0xb0/0xb8
[  364.152879]   el0_sync+0x178/0x180

Timer interrupt
===============

Showing EL1 exception (Interrupt happened on a secondary CPU):

[  364.195456]   arch_stack_walk+0x0/0xd0
[  364.195467]   callfd_stack+0x30/0x60
[  364.195475]   callfd_callback+0x2c/0x38
[  364.195482]   call_timer_fn+0x38/0x180
[  364.195489]   run_timer_softirq+0x43c/0x6b8
[  364.195495]   __do_softirq+0x138/0x37c
[  364.195501]   irq_exit+0xc0/0xe8
[  364.195512]   __handle_domain_irq+0x70/0xc8
[  364.195521]   gic_handle_irq+0xd4/0x2f4
[  364.195527]   el1_irq+0xc0/0x180
[  364.195533]   arch_cpu_idle+0x18/0x40
[  364.195540]   default_idle_call+0x44/0x170
[  364.195548]   do_idle+0x224/0x278
[  364.195567]   cpu_startup_entry+0x2c/0x98
[  364.195573]   secondary_start_kernel+0x198/0x1e0
[  364.195581]   ret_from_fork+0x0/0x18
---
Changelog:

v1
	- Set up task_pt_regs(current)->stackframe as the last frame
	  when a new task is initialized in copy_thread().

	- Create pt_regs for the idle tasks and set up pt_regs->stackframe
	  as the last frame for the idle tasks.

	- Set up task_pt_regs(current)->stackframe as the last frame in
	  the EL0 exception handler so the EL0 exception stack trace ends
	  there.

	- Terminate the stack trace successfully in unwind_frame() when
	  the FP reaches task_pt_regs(current)->stackframe.

	- The stack traces (above) in the kernel will terminate at the
	  correct place. Debuggers may show an extra record 0x0 at the end
	  for pt_regs->stackframe. That said, I did not see that extra frame
	  when I did stack traces using gdb.

Madhavan T. Venkataraman (1):
  arm64: Implement stack trace termination record

 arch/arm64/kernel/entry.S      |  8 +++++---
 arch/arm64/kernel/head.S       | 28 ++++++++++++++++++++++++----
 arch/arm64/kernel/process.c    |  5 +++++
 arch/arm64/kernel/stacktrace.c |  8 ++++----
 4 files changed, 38 insertions(+), 11 deletions(-)


base-commit: 0d02ec6b3136c73c09e7859f0d0e4e2c4c07b49b
-- 
2.25.1

