Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA57D3525AB
	for <lists+live-patching@lfdr.de>; Fri,  2 Apr 2021 05:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbhDBDYx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Apr 2021 23:24:53 -0400
Received: from linux.microsoft.com ([13.77.154.182]:37562 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233665AbhDBDYx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Apr 2021 23:24:53 -0400
Received: from x64host.home (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 3C7C920B5680;
        Thu,  1 Apr 2021 20:24:52 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3C7C920B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617333892;
        bh=2qY6T8BEHIyw9iP5KwzInnwBBHHwSzUczmWeiTG2BQQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=A8j510H+v8150Sb40gr46K4wJuKJk3Fx0fcjlct0aHliHvs+LFpY2pQn0Vy3AddpA
         e4IU58X0LZqh8tr/nzyESKZQZGU9BMEtNQSEv9mP1p08C5ffTblBrfOzh81lVvOojx
         KsumwLIQ7HG89j/kXrOsG8MnuW6oA+3BnaHLyQMY=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 0/1] arm64: Implement stack trace termination record
Date:   Thu,  1 Apr 2021 22:24:03 -0500
Message-Id: <20210402032404.47239-1-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <659f3d5cc025896ba4c49aea431aa8b1abc2b741>
References: <659f3d5cc025896ba4c49aea431aa8b1abc2b741>
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

The final frame for the idle tasks is different from v1. The rest of the
stack traces are the same.

Primary CPU's idle task (changed from v1)
=======================

[    0.022365]   arch_stack_walk+0x0/0xd0
[    0.022376]   callfd_stack+0x30/0x60
[    0.022387]   rest_init+0xd8/0xf8
[    0.022397]   arch_call_rest_init+0x18/0x24
[    0.022411]   start_kernel+0x5b8/0x5f4
[    0.022424]   __primary_switched+0xa8/0xac

Secondary CPU's idle task (changed from v1)
=========================

[    0.022484]   arch_stack_walk+0x0/0xd0
[    0.022494]   callfd_stack+0x30/0x60
[    0.022502]   secondary_start_kernel+0x188/0x1e0
[    0.022513]   __secondary_switched+0x80/0x84

---
Changelog:

v1
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
v2
	- Changed some wordings as suggested by Mark Rutland.

	- Removed the synthetic return PC for idle tasks. Changed the
	  branches to start_kernel() and secondary_start_kernel() to
	  calls so that they will have a proper return PC.

Madhavan T. Venkataraman (1):
  arm64: Implement stack trace termination record

 arch/arm64/kernel/entry.S      |  8 +++++---
 arch/arm64/kernel/head.S       | 29 +++++++++++++++++++++++------
 arch/arm64/kernel/process.c    |  5 +++++
 arch/arm64/kernel/stacktrace.c | 10 +++++-----
 4 files changed, 38 insertions(+), 14 deletions(-)


base-commit: 0d02ec6b3136c73c09e7859f0d0e4e2c4c07b49b
-- 
2.25.1

