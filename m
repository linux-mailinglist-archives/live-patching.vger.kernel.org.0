Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4EF3649AF
	for <lists+live-patching@lfdr.de>; Mon, 19 Apr 2021 20:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbhDSSR3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 19 Apr 2021 14:17:29 -0400
Received: from linux.microsoft.com ([13.77.154.182]:41012 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbhDSSR2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 19 Apr 2021 14:17:28 -0400
Received: from [192.168.254.32] (unknown [47.187.223.33])
        by linux.microsoft.com (Postfix) with ESMTPSA id DB03320B8000;
        Mon, 19 Apr 2021 11:16:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DB03320B8000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618856218;
        bh=cRJmWH03/XKOttU3OaDRbl+mvZMfWqX2u8y+9sokYqs=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=ptdT+5pNQXQ5X8C8cgYoQOv4klVxRcD3Vo9K86GurDgWobBYYu5HCKvkR5h4g6ECi
         MoJiH1y5lWTQBYt+RuYLvfM2P5ZT2AzsEwrpBexZENPxXNUQUHsB8Ndv0IWDQRiM1D
         JBTLKWH8dlsTq6NAD8WBjSWbnxp/pfzO6rf4Ifp0=
Subject: Re: [RFC PATCH v2 0/1] arm64: Implement stack trace termination
 record
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <659f3d5cc025896ba4c49aea431aa8b1abc2b741>
 <20210402032404.47239-1-madvenka@linux.microsoft.com>
Cc:     pasha.tatashin@soleen.com
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <96b4deb8-c841-b0fd-f1f9-ad0b737ec8a7@linux.microsoft.com>
Date:   Mon, 19 Apr 2021 13:16:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210402032404.47239-1-madvenka@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

CCing Pavel Tatashin <pasha.tatashin@soleen.com> on request.

Pasha,

This is v2. v1 is here:

https://lore.kernel.org/linux-arm-kernel/20210324184607.120948-1-madvenka@linux.microsoft.com/

Thanks!
                       
Madhavan

On 4/1/21 10:24 PM, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Reliable stacktracing requires that we identify when a stacktrace is
> terminated early. We can do this by ensuring all tasks have a final
> frame record at a known location on their task stack, and checking
> that this is the final frame record in the chain.
> 
> All tasks have a pt_regs structure right after the task stack in the stack
> page. The pt_regs structure contains a stackframe field. Make this stackframe
> field the final frame in the task stack so all stack traces end at a fixed
> stack offset.
> 
> For kernel tasks, this is simple to understand. For user tasks, there is
> some extra detail. User tasks get created via fork() et al. Once they return
> from fork, they enter the kernel only on an EL0 exception. In arm64,
> system calls are also EL0 exceptions.
> 
> The EL0 exception handler uses the task pt_regs mentioned above to save
> register state and call different exception functions. All stack traces
> from EL0 exception code must end at the pt_regs. So, make pt_regs->stackframe
> the final frame in the EL0 exception stack.
> 
> To summarize, task_pt_regs(task)->stackframe will always be the final frame
> in a stack trace.
> 
> Sample stack traces
> ===================
> 
> The final frame for the idle tasks is different from v1. The rest of the
> stack traces are the same.
> 
> Primary CPU's idle task (changed from v1)
> =======================
> 
> [    0.022365]   arch_stack_walk+0x0/0xd0
> [    0.022376]   callfd_stack+0x30/0x60
> [    0.022387]   rest_init+0xd8/0xf8
> [    0.022397]   arch_call_rest_init+0x18/0x24
> [    0.022411]   start_kernel+0x5b8/0x5f4
> [    0.022424]   __primary_switched+0xa8/0xac
> 
> Secondary CPU's idle task (changed from v1)
> =========================
> 
> [    0.022484]   arch_stack_walk+0x0/0xd0
> [    0.022494]   callfd_stack+0x30/0x60
> [    0.022502]   secondary_start_kernel+0x188/0x1e0
> [    0.022513]   __secondary_switched+0x80/0x84
> 
> ---
> Changelog:
> 
> v1
> 	- Set up task_pt_regs(current)->stackframe as the final frame
> 	  when a new task is initialized in copy_thread().
> 
> 	- Create pt_regs for the idle tasks and set up pt_regs->stackframe
> 	  as the final frame for the idle tasks.
> 
> 	- Set up task_pt_regs(current)->stackframe as the final frame in
> 	  the EL0 exception handler so the EL0 exception stack trace ends
> 	  there.
> 
> 	- Terminate the stack trace successfully in unwind_frame() when
> 	  the FP reaches task_pt_regs(current)->stackframe.
> 
> 	- The stack traces (above) in the kernel will terminate at the
> 	  correct place. Debuggers may show an extra record 0x0 at the end
> 	  for pt_regs->stackframe. That said, I did not see that extra frame
> 	  when I did stack traces using gdb.
> v2
> 	- Changed some wordings as suggested by Mark Rutland.
> 
> 	- Removed the synthetic return PC for idle tasks. Changed the
> 	  branches to start_kernel() and secondary_start_kernel() to
> 	  calls so that they will have a proper return PC.
> 
> Madhavan T. Venkataraman (1):
>   arm64: Implement stack trace termination record
> 
>  arch/arm64/kernel/entry.S      |  8 +++++---
>  arch/arm64/kernel/head.S       | 29 +++++++++++++++++++++++------
>  arch/arm64/kernel/process.c    |  5 +++++
>  arch/arm64/kernel/stacktrace.c | 10 +++++-----
>  4 files changed, 38 insertions(+), 14 deletions(-)
> 
> 
> base-commit: 0d02ec6b3136c73c09e7859f0d0e4e2c4c07b49b
> 
