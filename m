Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31A0342856
	for <lists+live-patching@lfdr.de>; Fri, 19 Mar 2021 23:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhCSWDd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 19 Mar 2021 18:03:33 -0400
Received: from linux.microsoft.com ([13.77.154.182]:43628 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbhCSWDL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 19 Mar 2021 18:03:11 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 17C3420B39C5;
        Fri, 19 Mar 2021 15:03:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 17C3420B39C5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1616191390;
        bh=Ky/VX3m6s8WqSfAj51xXeUV0UTf0QhLUBID5a5TMekY=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=LZGMzILyYMHPo2MwcAJb2YdbYvUL0Usx/BQwXAmLIjsHEa3oDvUSGT3nVqOil03Yq
         aAnZUDgHGIQ/A4Pw3mow5BZKNp8tvgX/tPp/k5efVfXKKH4elb0ZAQonJJV3PjUcuu
         +MJbCwEd4dZuj/dxreGrP04TMHWs6UTAEb21IEOM=
Subject: Re: [RFC PATCH v2 1/8] arm64: Implement stack trace termination
 record
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-2-madvenka@linux.microsoft.com>
 <20210318150905.GL5469@sirena.org.uk>
 <8591e34a-c181-f3ff-e691-a6350225e5b4@linux.microsoft.com>
 <20210319123023.GC5619@sirena.org.uk>
 <5dbaf34f-b2fc-b9b8-3918-83356f2f752a@linux.microsoft.com>
 <6e3ac22b-99b8-7d99-59bd-6a2d1158b3c9@linux.microsoft.com>
Message-ID: <254ed4a1-8342-d879-2fbc-3933118df949@linux.microsoft.com>
Date:   Fri, 19 Mar 2021 17:03:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <6e3ac22b-99b8-7d99-59bd-6a2d1158b3c9@linux.microsoft.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 3/19/21 1:19 PM, Madhavan T. Venkataraman wrote:
> 
> 
> On 3/19/21 9:29 AM, Madhavan T. Venkataraman wrote:
>>
>>
>> On 3/19/21 7:30 AM, Mark Brown wrote:
>>> On Thu, Mar 18, 2021 at 03:26:13PM -0500, Madhavan T. Venkataraman wrote:
>>>> On 3/18/21 10:09 AM, Mark Brown wrote:
>>>
>>>>> If we are going to add the extra record there would probably be less
>>>>> potential for confusion if we pointed it at some sensibly named dummy
>>>>> function so anything or anyone that does see it on the stack doesn't get
>>>>> confused by a NULL.
>>>
>>>> I agree. I will think about this some more. If no other solution presents
>>>> itself, I will add the dummy function.
>>>
>>> After discussing this with Mark Rutland offlist he convinced me that so
>>> long as we ensure the kernel doesn't print the NULL record we're
>>> probably OK here, the effort setting the function pointer up correctly
>>> in all circumstances (especially when we're not in the normal memory
>>> map) is probably not worth it for the limited impact it's likely to have
>>> to see the NULL pointer (probably mainly a person working with some
>>> external debugger).  It should be noted in the changelog though, and/or
>>> merged in with the relevant change to the unwinder.
>>>
>>
>> OK. I will add a comment as well as note it in the changelog.
>>
>> Thanks to both of you.
>>
>> Madhavan
>>
> 
> I thought about this some more. I think I have a simple solution. I will
> prepare a patch and send it out. If you and Mark Rutland approve, I will
> include it in the next version of this RFC.
> 
> Madhavan
> 

I solved this by using existing functions logically instead of inventing a
dummy function. I initialize pt_regs->stackframe[1] to an existing function
so that the stack trace will not show a 0x0 entry as well as the kernel and
gdb will show identical stack traces.

For all task stack traces including the idle tasks, the stack trace will
end at copy_thread() as copy_thread() is the function that initializes the
pt_regs and the first stack frame for a task.

For EL0 exceptions, the stack trace will end with vectors() as vectors
entries call the EL0 handlers.

Here are sample stack traces (I only show the ending of each trace):

Idle task on primary CPU
========================

		 ...
[    0.022557]   start_kernel+0x5b8/0x5f4
[    0.022570]   __primary_switched+0xa8/0xb8
[    0.022578]   copy_thread+0x0/0x188

Idle task on secondary CPU
==========================

		 ...
[    0.023397]   secondary_start_kernel+0x188/0x1e0
[    0.023406]   __secondary_switched+0x40/0x88
[    0.023415]   copy_thread+0x0/0x188

All other kernel threads
========================

		 ...
[   13.501062]   ret_from_fork+0x10/0x18
[   13.507998]   copy_thread+0x0/0x188

User threads (EL0 exception)
============

write(2) system call example:

		 ...
[  521.686148]   vfs_write+0xc8/0x2c0
[  521.686156]   ksys_write+0x74/0x108
[  521.686161]   __arm64_sys_write+0x24/0x30
[  521.686166]   el0_svc_common.constprop.0+0x70/0x1a8
[  521.686175]   do_el0_svc+0x2c/0x98
[  521.686180]   el0_svc+0x2c/0x70
[  521.686188]   el0_sync_handler+0xb0/0xb8
[  521.686193]   el0_sync+0x17c/0x180
[  521.686198]   vectors+0x0/0x7d8

Here are the code changes:

========================================================================
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index a31a0a713c85..514307e80b79 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -261,16 +261,19 @@ alternative_else_nop_endif
 	stp	lr, x21, [sp, #S_LR]
 
 	/*
-	 * For exceptions from EL0, terminate the callchain here.
+	 * For exceptions from EL0, terminate the callchain here at
+	 * task_pt_regs(current)->stackframe.
+	 *
 	 * For exceptions from EL1, create a synthetic frame record so the
 	 * interrupted code shows up in the backtrace.
 	 */
 	.if \el == 0
-	mov	x29, xzr
+	ldr	x17, =vectors
+	stp	xzr, x17, [sp, #S_STACKFRAME]
 	.else
 	stp	x29, x22, [sp, #S_STACKFRAME]
-	add	x29, sp, #S_STACKFRAME
 	.endif
+	add	x29, sp, #S_STACKFRAME
 
 #ifdef CONFIG_ARM64_SW_TTBR0_PAN
 alternative_if_not ARM64_HAS_PAN
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 66b0e0b66e31..699e0dd313a1 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -393,6 +393,29 @@ SYM_FUNC_START_LOCAL(__create_page_tables)
 	ret	x28
 SYM_FUNC_END(__create_page_tables)
 
+	/*
+	 * The boot task becomes the idle task for the primary CPU. The
+	 * CPU startup task on each secondary CPU becomes the idle task
+	 * for the secondary CPU.
+	 *
+	 * The idle task does not require pt_regs. But create a dummy
+	 * pt_regs so that task_pt_regs(idle_task)->stackframe can be
+	 * set up to be the last frame on the idle task stack just like
+	 * all the other kernel tasks. This helps the unwinder to
+	 * terminate the stack trace at a well-known stack offset.
+	 *
+	 * Also, set up the last return PC to be copy_thread() just
+	 * like all the other kernel tasks so that the stack trace of
+	 * all kernel tasks ends with the same function.
+	 */
+	.macro setup_last_frame
+	sub	sp, sp, #PT_REGS_SIZE
+	ldr	x17, =copy_thread
+	stp	xzr, x17, [sp, #S_STACKFRAME]
+	add	x29, sp, #S_STACKFRAME
+	adr	x30, #0
+	.endm
+
 /*
  * The following fragment of code is executed with the MMU enabled.
  *
@@ -447,8 +470,7 @@ SYM_FUNC_START_LOCAL(__primary_switched)
 #endif
 	bl	switch_to_vhe			// Prefer VHE if possible
 	add	sp, sp, #16
-	mov	x29, #0
-	mov	x30, #0
+	setup_last_frame
 	b	start_kernel
 SYM_FUNC_END(__primary_switched)
 
@@ -606,8 +628,7 @@ SYM_FUNC_START_LOCAL(__secondary_switched)
 	cbz	x2, __secondary_too_slow
 	msr	sp_el0, x2
 	scs_load x2, x3
-	mov	x29, #0
-	mov	x30, #0
+	setup_last_frame
 
 #ifdef CONFIG_ARM64_PTR_AUTH
 	ptrauth_keys_init_cpu x2, x3, x4, x5
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 325c83b1a24d..9050699ff67c 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -437,6 +437,12 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
 	}
 	p->thread.cpu_context.pc = (unsigned long)ret_from_fork;
 	p->thread.cpu_context.sp = (unsigned long)childregs;
+	/*
+	 * For the benefit of the unwinder, set up childregs->stackframe
+	 * as the last frame for the new task.
+	 */
+	p->thread.cpu_context.fp = (unsigned long)childregs->stackframe;
+	childregs->stackframe[1] = (unsigned long)copy_thread;
 
 	ptrace_hw_copy_thread(p);
 
======================================================================

If you approve, the above will become RFC Patch v3 1/8 in the next version.

Let me know.

Also, I could introduce an extra frame in the EL1 exception stack trace that
includes vectors so the stack trace would look like this (timer interrupt example):

call_timer_fn
run_timer_softirq
__do_softirq
irq_exit
__handle_domain_irq
gic_handle_irq
el1_irq
vectors

This way, if the unwinder finds vectors, it knows that it is an exception frame.

Madhavan
