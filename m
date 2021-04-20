Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E98365FA1
	for <lists+live-patching@lfdr.de>; Tue, 20 Apr 2021 20:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbhDTSph (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Apr 2021 14:45:37 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58712 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233607AbhDTSpg (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Apr 2021 14:45:36 -0400
Received: from x64host.home (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9617020B8001;
        Tue, 20 Apr 2021 11:45:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9617020B8001
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618944304;
        bh=0DaS2ZAaR3tWrI17aOD2elYuIto8dgrtjnc7v28PGzg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=f8rQP2uXAZ3fqh9zU4UD8IGGpIaTLG0Yy2/SA8BY4qeqhSalsev4rMQZXTEW08Dzf
         qPROV9sDwhw9YggGmCQ7S5i0q65iu0v+z37KzljImaHuc6XshuvYWimq4vPkKHwv/X
         oOJRKyXnra3mok8S8i9GM4Tb/cqMjPl30OSl77n4=
From:   madvenka@linux.microsoft.com
To:     broonie@kernel.org, jpoimboe@redhat.com, mark.rutland@arm.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, pasha.tatashin@soleen.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [PATCH v3 0/1] arm64: Implement stack trace termination record
Date:   Tue, 20 Apr 2021 13:44:46 -0500
Message-Id: <20210420184447.16306-1-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <80cac661608c8d3623328b37b9b1696f63f45968>
References: <80cac661608c8d3623328b37b9b1696f63f45968>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Reliable stacktracing requires that we identify when a stacktrace is
terminated early. We can do this by ensuring all tasks have a final
frame record at a known location on their task stack, and checking
that this is the final frame record in the chain.

All tasks have a pt_regs structure right after the task stack in the stack
page. The pt_regs structure contains a stackframe field. Make this stackframe
field the final frame in the task stack so all stack traces end at a fixed
stack offset.

For kernel tasks, this is simple to understand. For user tasks, there is
some extra detail. User tasks get created via fork() et al. Once they return
from fork, they enter the kernel only on an EL0 exception. In arm64,
system calls are also EL0 exceptions.

The EL0 exception handler uses the task pt_regs mentioned above to save
register state and call different exception functions. All stack traces
from EL0 exception code must end at the pt_regs. So, make pt_regs->stackframe
the final frame in the EL0 exception stack.

To summarize, task_pt_regs(task)->stackframe will always be the final frame
in a stack trace.

Sample stack traces
===================

Showing just the last couple of frames in each stack trace to show how the
stack trace ends.

Primary CPU idle task
=====================

		 ...
[    0.077109]   rest_init+0x108/0x144
[    0.077188]   arch_call_rest_init+0x18/0x24
[    0.077220]   start_kernel+0x3ac/0x3e4
[    0.077293]   __primary_switched+0xac/0xb0

Secondary CPU idle task
=======================

		...
[    0.077264]   secondary_start_kernel+0x228/0x388
[    0.077326]   __secondary_switched+0x80/0x84

Sample kernel thread
====================

		 ...
[   24.543250]   kernel_init+0xa4/0x164
[   24.561850]   ret_from_fork+0x10/0x18

Write system call (EL0 exception)
=================

(using a test driver called callfd)

[ 1160.628723]   callfd_stack+0x3c/0x70
[ 1160.628768]   callfd_op+0x35c/0x3a8
[ 1160.628791]   callfd_write+0x5c/0xc8
[ 1160.628813]   vfs_write+0x104/0x3b8
[ 1160.628837]   ksys_write+0xd0/0x188
[ 1160.628859]   __arm64_sys_write+0x4c/0x60
[ 1160.628883]   el0_svc_common.constprop.0+0xa8/0x240
[ 1160.628904]   do_el0_svc+0x40/0xa8
[ 1160.628921]   el0_svc+0x2c/0x78
[ 1160.628942]   el0_sync_handler+0xb0/0xb8
[ 1160.628962]   el0_sync+0x17c/0x180

NULL pointer dereference exception (EL1 exception)
==================================

[ 1160.637984]   callfd_stack+0x3c/0x70
[ 1160.638015]   die_kernel_fault+0x80/0x108
[ 1160.638042]   do_page_fault+0x520/0x600
[ 1160.638075]   do_translation_fault+0xa8/0xdc
[ 1160.638102]   do_mem_abort+0x68/0x100
[ 1160.638120]   el1_abort+0x40/0x60
[ 1160.638138]   el1_sync_handler+0xac/0xc8
[ 1160.638157]   el1_sync+0x74/0x100
[ 1160.638174]   0x0                           <=== NULL pointer dereference
[ 1160.638189]   callfd_write+0x5c/0xc8
[ 1160.638211]   vfs_write+0x104/0x3b8
[ 1160.638234]   ksys_write+0xd0/0x188
[ 1160.638278]   __arm64_sys_write+0x4c/0x60
[ 1160.638325]   el0_svc_common.constprop.0+0xa8/0x240
[ 1160.638358]   do_el0_svc+0x40/0xa8
[ 1160.638379]   el0_svc+0x2c/0x78
[ 1160.638409]   el0_sync_handler+0xb0/0xb8
[ 1160.638452]   el0_sync+0x17c/0x180

Timer interrupt (EL1 exception)
===============

Secondary CPU idle task interrupted by the timer interrupt:

[ 1160.702949] callfd_callback:
[ 1160.703006]   callfd_stack+0x3c/0x70
[ 1160.703060]   callfd_callback+0x30/0x40
[ 1160.703087]   call_timer_fn+0x48/0x220
[ 1160.703113]   run_timer_softirq+0x7cc/0xc70
[ 1160.703144]   __do_softirq+0x1ec/0x608
[ 1160.703166]   irq_exit+0x138/0x180
[ 1160.703193]   __handle_domain_irq+0x8c/0xf0
[ 1160.703218]   gic_handle_irq+0xec/0x410
[ 1160.703253]   el1_irq+0xc0/0x180
[ 1160.703278]   arch_local_irq_enable+0xc/0x28
[ 1160.703329]   default_idle_call+0x54/0x1d8
[ 1160.703355]   do_idle+0x2d8/0x350
[ 1160.703388]   cpu_startup_entry+0x2c/0x98
[ 1160.703412]   secondary_start_kernel+0x238/0x388
[ 1160.703446]   __secondary_switched+0x80/0x84
---
Changelog:

v3:
	- Added Reviewed-by: Mark Brown <broonie@kernel.org>.
	- Fixed an extra space after a cast reported by checkpatch --strict.
	- Synced with mainline tip.

v2:
	- Changed some wordings as suggested by Mark Rutland.
	- Removed the synthetic return PC for idle tasks. Changed the
	  branches to start_kernel() and secondary_start_kernel() to
	  calls so that they will have a proper return PC.

v1:
	- Set up task_pt_regs(current)->stackframe as the final frame
	  when a new task is initialized in copy_thread().
	- Create pt_regs for the idle tasks and set up pt_regs->stackframe
	  as the final frame for the idle tasks.
	- Set up task_pt_regs(current)->stackframe as the final frame in
	  the EL0 exception handler so the EL0 exception stack trace ends
	  there.
	- Terminate the stack trace successfully in unwind_frame() when
	  the FP reaches task_pt_regs(current)->stackframe.
	- The stack traces (above) in the kernel will terminate at the
	  correct place. Debuggers may show an extra record 0x0 at the end
	  for pt_regs->stackframe. That said, I did not see that extra frame
	  when I did stack traces using gdb.

Testing:
	- Functional validation on a ThunderX system.

Previous versions and discussion
================================

v2: https://lore.kernel.org/linux-arm-kernel/20210402032404.47239-1-madvenka@linux.microsoft.com/
v1: https://lore.kernel.org/linux-arm-kernel/20210324184607.120948-1-madvenka@linux.microsoft.com/

Madhavan T. Venkataraman (1):
  arm64: Implement stack trace termination record

 arch/arm64/kernel/entry.S      |  8 +++++---
 arch/arm64/kernel/head.S       | 29 +++++++++++++++++++++++------
 arch/arm64/kernel/process.c    |  5 +++++
 arch/arm64/kernel/stacktrace.c | 10 +++++-----
 4 files changed, 38 insertions(+), 14 deletions(-)


base-commit: bf05bf16c76bb44ab5156223e1e58e26dfe30a88
-- 
2.25.1

