Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360D3345BDC
	for <lists+live-patching@lfdr.de>; Tue, 23 Mar 2021 11:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhCWKZC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Mar 2021 06:25:02 -0400
Received: from foss.arm.com ([217.140.110.172]:43510 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230266AbhCWKYu (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Mar 2021 06:24:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5E5A1042;
        Tue, 23 Mar 2021 03:24:49 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A46953F719;
        Tue, 23 Mar 2021 03:24:47 -0700 (PDT)
Date:   Tue, 23 Mar 2021 10:24:41 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Mark Brown <broonie@kernel.org>, jpoimboe@redhat.com,
        jthierry@redhat.com, catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/8] arm64: Implement stack trace termination
 record
Message-ID: <20210323102339.GA95840@C02TD0UTHF1T.local>
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-2-madvenka@linux.microsoft.com>
 <20210318150905.GL5469@sirena.org.uk>
 <8591e34a-c181-f3ff-e691-a6350225e5b4@linux.microsoft.com>
 <20210319123023.GC5619@sirena.org.uk>
 <5dbaf34f-b2fc-b9b8-3918-83356f2f752a@linux.microsoft.com>
 <6e3ac22b-99b8-7d99-59bd-6a2d1158b3c9@linux.microsoft.com>
 <254ed4a1-8342-d879-2fbc-3933118df949@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <254ed4a1-8342-d879-2fbc-3933118df949@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Mar 19, 2021 at 05:03:09PM -0500, Madhavan T. Venkataraman wrote:
> I solved this by using existing functions logically instead of inventing a
> dummy function. I initialize pt_regs->stackframe[1] to an existing function
> so that the stack trace will not show a 0x0 entry as well as the kernel and
> gdb will show identical stack traces.
> 
> For all task stack traces including the idle tasks, the stack trace will
> end at copy_thread() as copy_thread() is the function that initializes the
> pt_regs and the first stack frame for a task.

I don't think this is a good idea, as it will mean that copy_thread()
will appear to be live in every thread, and therefore will not be
patchable.

There are other things people need to be aware of when using an external
debugger (e.g. during EL0<->ELx transitions there are periods when X29
and X30 contain the EL0 values, and cannot be used to unwind), so I
don't think there's a strong need to make this look prettier to an
external debugger.

> For EL0 exceptions, the stack trace will end with vectors() as vectors
> entries call the EL0 handlers.
> 
> Here are sample stack traces (I only show the ending of each trace):
> 
> Idle task on primary CPU
> ========================
> 
> 		 ...
> [    0.022557]   start_kernel+0x5b8/0x5f4
> [    0.022570]   __primary_switched+0xa8/0xb8
> [    0.022578]   copy_thread+0x0/0x188
> 
> Idle task on secondary CPU
> ==========================
> 
> 		 ...
> [    0.023397]   secondary_start_kernel+0x188/0x1e0
> [    0.023406]   __secondary_switched+0x40/0x88
> [    0.023415]   copy_thread+0x0/0x188
> 
> All other kernel threads
> ========================
> 
> 		 ...
> [   13.501062]   ret_from_fork+0x10/0x18
> [   13.507998]   copy_thread+0x0/0x188
> 
> User threads (EL0 exception)
> ============
> 
> write(2) system call example:
> 
> 		 ...
> [  521.686148]   vfs_write+0xc8/0x2c0
> [  521.686156]   ksys_write+0x74/0x108
> [  521.686161]   __arm64_sys_write+0x24/0x30
> [  521.686166]   el0_svc_common.constprop.0+0x70/0x1a8
> [  521.686175]   do_el0_svc+0x2c/0x98
> [  521.686180]   el0_svc+0x2c/0x70
> [  521.686188]   el0_sync_handler+0xb0/0xb8
> [  521.686193]   el0_sync+0x17c/0x180
> [  521.686198]   vectors+0x0/0x7d8

[...]

> If you approve, the above will become RFC Patch v3 1/8 in the next version.

As above, I don't think we should repurpose an existing function here,
and my preference is to use 0x0.

> Let me know.
> 
> Also, I could introduce an extra frame in the EL1 exception stack trace that
> includes vectors so the stack trace would look like this (timer interrupt example):
> 
> call_timer_fn
> run_timer_softirq
> __do_softirq
> irq_exit
> __handle_domain_irq
> gic_handle_irq
> el1_irq
> vectors
> 
> This way, if the unwinder finds vectors, it knows that it is an exception frame.

I can see this might make it simpler to detect exception boundaries, but
I suspect that we need other information anyway, so this doesn't become
all that helpful. For EL0<->EL1 exception boundaries we want to
successfully terminate a robust stacktrace whereas for EL1<->EL1
exception boundaries we want to fail a robust stacktrace.

I reckon we have to figure that out from the el1_* and el0_* entry
points (which I am working to reduce/simplify as part of the entry
assembly conversion to C). With that we can terminate unwind at the
el0_* parts, and reject unwinding across any other bit of .entry.text.

Thanks,
Mark.

