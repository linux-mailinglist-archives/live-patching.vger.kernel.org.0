Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABDFE39D978
	for <lists+live-patching@lfdr.de>; Mon,  7 Jun 2021 12:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhFGKWy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 7 Jun 2021 06:22:54 -0400
Received: from foss.arm.com ([217.140.110.172]:57346 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhFGKWx (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 7 Jun 2021 06:22:53 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 60B351063;
        Mon,  7 Jun 2021 03:21:02 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.4.24])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 97F443F73D;
        Mon,  7 Jun 2021 03:21:00 -0700 (PDT)
Date:   Mon, 7 Jun 2021 11:20:58 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Suraj Jitindar Singh <surajjs@amazon.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, catalin.marinas@arm.com,
        will@kernel.org, broonie@kernel.org, madvenka@linux.microsoft.com,
        duwe@lst.de, sjitindarsingh@gmail.com, benh@kernel.crashing.org
Subject: Re: [RFC PATCH 1/1] arm64: implement live patching
Message-ID: <20210607102058.GB97489@C02TD0UTHF1T.local>
References: <20210604235930.603-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604235930.603-1-surajjs@amazon.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jun 04, 2021 at 04:59:30PM -0700, Suraj Jitindar Singh wrote:
> It's my understanding that the two pieces of work required to enable live
> patching on arm are in flight upstream;
> - Reliable stack traces as implemented by Madhavan T. Venkataraman [1]
> - Objtool as implemented by Julien Thierry [2]

We also need to rework the arm64 patching code to not rely on any code
which may itself be patched. Currently there's a reasonable amount of
patching code that can either be patched directly, or can be
instrumented by code that can be patched.

I have some WIP patches for that at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=arm64/patching/rework

... but there's still a lot to do, and it's not clear to me if there's
other stuff we need to rework to make patch-safe.

Do we have any infrastructure for testing LIVEPATCH?

> This is the remaining part required to enable live patching on arm.
> Based on work by Torsten Duwe [3]
> 
> Allocate a task flag used to represent the patch pending state for the
> task. Also implement generic functions klp_arch_set_pc() &
> klp_get_ftrace_location().
> 
> In klp_arch_set_pc() it is sufficient to set regs->pc as in
> ftrace_common_return() the return address is loaded from the stack.
> 
> ldr     x9, [sp, #S_PC]
> <snip>
> ret     x9
> 
> In klp_get_ftrace_location() it is necessary to advance the address by
> AARCH64_INSN_SIZE (4) to point to the BL in the callsite as 2 nops were
> placed at the start of the function, one to be patched to save the LR and
> another to be patched to branch to the ftrace call, and
> klp_get_ftrace_location() is expected to return the address of the BL. It
> may also be necessary to advance the address by another AARCH64_INSN_SIZE
> if CONFIG_ARM64_BTI_KERNEL is enabled due to the instruction placed at the
> branch target to satisfy BTI,
> 
> Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
> 
> [1] https://lkml.org/lkml/2021/5/26/1212
> [2] https://lkml.org/lkml/2021/3/3/1135
> [3] https://lkml.org/lkml/2018/10/26/536
> ---
>  arch/arm64/Kconfig                   |  3 ++
>  arch/arm64/include/asm/livepatch.h   | 42 ++++++++++++++++++++++++++++
>  arch/arm64/include/asm/thread_info.h |  4 ++-
>  arch/arm64/kernel/signal.c           |  4 +++
>  4 files changed, 52 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/include/asm/livepatch.h
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index b098dabed8c2..c4636990c01d 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -187,6 +187,7 @@ config ARM64
>  	select HAVE_GCC_PLUGINS
>  	select HAVE_HW_BREAKPOINT if PERF_EVENTS
>  	select HAVE_IRQ_TIME_ACCOUNTING
> +	select HAVE_LIVEPATCH
>  	select HAVE_NMI
>  	select HAVE_PATA_PLATFORM
>  	select HAVE_PERF_EVENTS
> @@ -1946,3 +1947,5 @@ source "arch/arm64/kvm/Kconfig"
>  if CRYPTO
>  source "arch/arm64/crypto/Kconfig"
>  endif
> +
> +source "kernel/livepatch/Kconfig"
> diff --git a/arch/arm64/include/asm/livepatch.h b/arch/arm64/include/asm/livepatch.h
> new file mode 100644
> index 000000000000..72d7cd86f158
> --- /dev/null
> +++ b/arch/arm64/include/asm/livepatch.h
> @@ -0,0 +1,42 @@
> +/* SPDX-License-Identifier: GPL-2.0
> + *
> + * livepatch.h - arm64-specific Kernel Live Patching Core
> + */
> +#ifndef _ASM_ARM64_LIVEPATCH_H
> +#define _ASM_ARM64_LIVEPATCH_H
> +
> +#include <linux/ftrace.h>
> +
> +static inline void klp_arch_set_pc(struct ftrace_regs *fregs, unsigned long ip)
> +{
> +	struct pt_regs *regs = ftrace_get_regs(fregs);
> +
> +	regs->pc = ip;
> +}
> +
> +/*
> + * klp_get_ftrace_location is expected to return the address of the BL to the
> + * relevant ftrace handler in the callsite. The location of this can vary based
> + * on several compilation options.
> + * CONFIG_DYNAMIC_FTRACE_WITH_REGS
> + *	- Inserts 2 nops on function entry the second of which is the BL
> + *	  referenced above. (See ftrace_init_nop() for the callsite sequence)
> + *	  (this is required by livepatch and must be selected)
> + * CONFIG_ARM64_BTI_KERNEL:
> + *	- Inserts a hint #0x22 on function entry if the function is called
> + *	  indirectly (to satisfy BTI requirements), which is inserted before
> + *	  the two nops from above.
> + */
> +#define klp_get_ftrace_location klp_get_ftrace_location
> +static inline unsigned long klp_get_ftrace_location(unsigned long faddr)

Is `faddr` the address of the function, or the addresds of the patch site (the
dyn_ftrace::ip)? Either way, I think there's a problem; see below.

> +{
> +	unsigned long addr = faddr + AARCH64_INSN_SIZE;
> +
> +#if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL)
> +	addr = ftrace_location_range(addr, addr + AARCH64_INSN_SIZE);
> +#endif

I don't think this is right; function are not guaranteed to have a BTI,
since e.g. static functions which are called directly may not be given
one:

| [mark@lakrids:/mnt/data/tests/bti-patching]% cat test.c
| #define noinline __attribute__((noinline))
| 
| static noinline void a(void)
| {
|         asm volatile("" ::: "memory");
| }
| 
| void b(void)
| {
|         a();
| }
| [mark@lakrids:/mnt/data/tests/bti-patching]% usekorg 10.3.0 aarch64-linux-gcc -c test.c -fpatchable-function-entry=2 -mbranch-protection=bti -O2
| [mark@lakrids:/mnt/data/tests/bti-patching]% usekorg 10.3.0 aarch64-linux-objdump -d test.o                                                     
| 
| test.o:     file format elf64-littleaarch64
| 
| 
| Disassembly of section .text:
| 
| 0000000000000000 <a>:
|    0:   d503201f        nop
|    4:   d503201f        nop
|    8:   d65f03c0        ret
|    c:   d503201f        nop
| 
| 0000000000000010 <b>:
|   10:   d503245f        bti     c
|   14:   d503201f        nop
|   18:   d503201f        nop
|   1c:   17fffff9        b       0 <a>

If `faddr` is the address of the function, then we'll need to do
something dynamic to skip any BTI. If it's the address of the patch
site, then we shouldn't need to consider the BTI at all: att boot time
the recorded lcoation points at the first NOP, and at init time we point
dyn_ftrace::ip at the second NOP -- see ftrace_call_adjust().

Thanks,
Mark.

> +
> +	return addr;
> +}
> +
> +#endif /* _ASM_ARM64_LIVEPATCH_H */
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index 6623c99f0984..cca936d53a40 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -67,6 +67,7 @@ int arch_dup_task_struct(struct task_struct *dst,
>  #define TIF_UPROBE		4	/* uprobe breakpoint or singlestep */
>  #define TIF_MTE_ASYNC_FAULT	5	/* MTE Asynchronous Tag Check Fault */
>  #define TIF_NOTIFY_SIGNAL	6	/* signal notifications exist */
> +#define TIF_PATCH_PENDING	7	/* pending live patching update */
>  #define TIF_SYSCALL_TRACE	8	/* syscall trace active */
>  #define TIF_SYSCALL_AUDIT	9	/* syscall auditing */
>  #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */
> @@ -97,11 +98,12 @@ int arch_dup_task_struct(struct task_struct *dst,
>  #define _TIF_SVE		(1 << TIF_SVE)
>  #define _TIF_MTE_ASYNC_FAULT	(1 << TIF_MTE_ASYNC_FAULT)
>  #define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
> +#define _TIF_PATCH_PENDING	(1 << TIF_PATCH_PENDING)
>  
>  #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
>  				 _TIF_NOTIFY_RESUME | _TIF_FOREIGN_FPSTATE | \
>  				 _TIF_UPROBE | _TIF_MTE_ASYNC_FAULT | \
> -				 _TIF_NOTIFY_SIGNAL)
> +				 _TIF_NOTIFY_SIGNAL | _TIF_PATCH_PENDING)
>  
>  #define _TIF_SYSCALL_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
>  				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP | \
> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
> index 6237486ff6bb..d1eedb0589a7 100644
> --- a/arch/arm64/kernel/signal.c
> +++ b/arch/arm64/kernel/signal.c
> @@ -18,6 +18,7 @@
>  #include <linux/sizes.h>
>  #include <linux/string.h>
>  #include <linux/tracehook.h>
> +#include <linux/livepatch.h>
>  #include <linux/ratelimit.h>
>  #include <linux/syscalls.h>
>  
> @@ -932,6 +933,9 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
>  					       (void __user *)NULL, current);
>  			}
>  
> +			if (thread_flags & _TIF_PATCH_PENDING)
> +				klp_update_patch_state(current);
> +
>  			if (thread_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
>  				do_signal(regs);
>  
> -- 
> 2.17.1
> 
