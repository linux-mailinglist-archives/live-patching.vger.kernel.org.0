Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480833A2111
	for <lists+live-patching@lfdr.de>; Thu, 10 Jun 2021 01:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhFIX75 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 9 Jun 2021 19:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFIX75 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 9 Jun 2021 19:59:57 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB728C061574;
        Wed,  9 Jun 2021 16:58:01 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id c12so93075pfl.3;
        Wed, 09 Jun 2021 16:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Vk0UTL6+Sr3hylCOhCf+QV7CND++qYiWdaTonsPK2w=;
        b=OXe+SG8oFTv9A5Ke643NKmVNh/IfaN5wF7UExUGkBNwDcJC/Ks6CPUo/1bfKxOyJIz
         ELEnV2/kEaTY0eMlsT94IDwnc9qhMXD+NxrSfo2ZW+QCUTRFUUVPrxQCbQuXnMaT6Fst
         M0ivii7Z3uZ2tWTcmLvux3QEtKqYJ0LsWYaH8MVsZwq6LSy+/NBmQuZPuma1bgBi2NYY
         rlBYQdgTEI6gSR7Y4xDNobzUl5SKBCaLDCUay3UM5rJbNVck0fGOUnwvww+JNi6aZMQN
         XkeGwAMlGQ/ccSfM4w1O2vCisx5mkokwaYeplDHjalUNunvF/FCONfs4wBDXerPScJ5y
         ic5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Vk0UTL6+Sr3hylCOhCf+QV7CND++qYiWdaTonsPK2w=;
        b=puHZoPdIlUMtu79KKyeW6eSX6FfSebQhVIZmwVyLb73U6O+YFob+tC1V3G8K1fwGpq
         DARkefxeHPjbr7RST5H7GVmF5eWN+mK+5bX0y4LAOU8lMz8dlr0qgvVxYJxPZWnlH7gK
         o0agiejszxhiNqg0C2+0wmxwTatc18eGejPUoIp1un4u3sGvyeRvUEFrZUrKfL/WMenG
         pcG23dZHPa0Ap2ggqQSk6cg4HSD4uryZ8uV7BGVbv4KQYCxjrlSQqVr1old0+8gr7x6H
         Fao2cfqgCxJQXkISm2Js3k/xzlcWjTgdIFz2WflcHpWmJkhQ1aSuC+As9eunk4UUB9hH
         aMXA==
X-Gm-Message-State: AOAM530Ge3lxxpVBAyu25oOc6EGNLrkKf5A/w3C1mFWspmXA+qLvYF86
        JT6rxDrdKYgz16xN8nCCn2U=
X-Google-Smtp-Source: ABdhPJw6OXSCSa3VURQB/IdwhS6RmKAynrJtG3O22OWxnpqaHkz3uEYcGsrEpZ5KfqALQU1THk3AwQ==
X-Received: by 2002:a63:701:: with SMTP id 1mr2190271pgh.198.1623283081360;
        Wed, 09 Jun 2021 16:58:01 -0700 (PDT)
Received: from freeip.amazon.com ([205.251.233.52])
        by smtp.googlemail.com with ESMTPSA id l70sm762743pgd.20.2021.06.09.16.58.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 09 Jun 2021 16:58:00 -0700 (PDT)
Message-ID: <96bc26898bdc8a23b772da9444a1d98227580c00.camel@gmail.com>
Subject: Re: [RFC PATCH 1/1] arm64: implement live patching
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, catalin.marinas@arm.com,
        will@kernel.org, broonie@kernel.org, madvenka@linux.microsoft.com,
        duwe@lst.de, benh@kernel.crashing.org
Date:   Wed, 09 Jun 2021 16:57:59 -0700
In-Reply-To: <1c7473ae13d45a41e94539d533d89bb6046faf6e.camel@gmail.com>
References: <20210604235930.603-1-surajjs@amazon.com>
         <20210607102058.GB97489@C02TD0UTHF1T.local>
         <1c7473ae13d45a41e94539d533d89bb6046faf6e.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 2021-06-08 at 17:32 -0700, Suraj Jitindar Singh wrote:
> On Mon, 2021-06-07 at 11:20 +0100, Mark Rutland wrote:
> > On Fri, Jun 04, 2021 at 04:59:30PM -0700, Suraj Jitindar Singh
> > wrote:
> > > It's my understanding that the two pieces of work required to
> > > enable live
> > > patching on arm are in flight upstream;
> > > - Reliable stack traces as implemented by Madhavan T.
> > > Venkataraman
> > > [1]
> > > - Objtool as implemented by Julien Thierry [2]
> > 
> > We also need to rework the arm64 patching code to not rely on any
> > code
> > which may itself be patched. Currently there's a reasonable amount
> > of
> > patching code that can either be patched directly, or can be
> > instrumented by code that can be patched.
> 
> If I understand correctly you're saying that it's unsafe for patching
> code to call any other code (directly or indirectly) which can itself
> be patched.
> 
> While I understand it's obviously important to fix this issue in the
> patching code as whole, live patching uses ftrace and as far as I can
> tell the only patching functions used by ftrace (in
> ftrace_modify_code()) is aarch64_insn_patch_text_nosync(). So would I
> be correct in my understanding that so long as that function doesn't
> call any other functions which can themselves be patched, then this
> would be safe?

On this note I now see that I was looking at a much older kernel tree
and this is much more involved than I previously thought.

- Suraj

> 
> > 
> > I have some WIP patches for that at:
> > 
> >   
> > 
https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=arm64/patching/rework
> > 
> > ... but there's still a lot to do, and it's not clear to me if
> > there's
> > other stuff we need to rework to make patch-safe.
> 
> Is there any work I could contribute to this?
> 
> > 
> > Do we have any infrastructure for testing LIVEPATCH?
> 
> Not currently. However I'm thinking something which attempted to
> trivially patch every patchable function would provide pretty good
> test
> coverage (while being very slow).
> 
> > 
> > > This is the remaining part required to enable live patching on
> > > arm.
> > > Based on work by Torsten Duwe [3]
> > > 
> > > Allocate a task flag used to represent the patch pending state
> > > for
> > > the
> > > task. Also implement generic functions klp_arch_set_pc() &
> > > klp_get_ftrace_location().
> > > 
> > > In klp_arch_set_pc() it is sufficient to set regs->pc as in
> > > ftrace_common_return() the return address is loaded from the
> > > stack.
> > > 
> > > ldr     x9, [sp, #S_PC]
> > > <snip>
> > > ret     x9
> > > 
> > > In klp_get_ftrace_location() it is necessary to advance the
> > > address
> > > by
> > > AARCH64_INSN_SIZE (4) to point to the BL in the callsite as 2
> > > nops
> > > were
> > > placed at the start of the function, one to be patched to save
> > > the
> > > LR and
> > > another to be patched to branch to the ftrace call, and
> > > klp_get_ftrace_location() is expected to return the address of
> > > the
> > > BL. It
> > > may also be necessary to advance the address by another
> > > AARCH64_INSN_SIZE
> > > if CONFIG_ARM64_BTI_KERNEL is enabled due to the instruction
> > > placed
> > > at the
> > > branch target to satisfy BTI,
> > > 
> > > Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
> > > 
> > > [1] https://lkml.org/lkml/2021/5/26/1212
> > > [2] https://lkml.org/lkml/2021/3/3/1135
> > > [3] https://lkml.org/lkml/2018/10/26/536
> > > ---
> > >  arch/arm64/Kconfig                   |  3 ++
> > >  arch/arm64/include/asm/livepatch.h   | 42
> > > ++++++++++++++++++++++++++++
> > >  arch/arm64/include/asm/thread_info.h |  4 ++-
> > >  arch/arm64/kernel/signal.c           |  4 +++
> > >  4 files changed, 52 insertions(+), 1 deletion(-)
> > >  create mode 100644 arch/arm64/include/asm/livepatch.h
> > > 
> > > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > > index b098dabed8c2..c4636990c01d 100644
> > > --- a/arch/arm64/Kconfig
> > > +++ b/arch/arm64/Kconfig
> > > @@ -187,6 +187,7 @@ config ARM64
> > >  	select HAVE_GCC_PLUGINS
> > >  	select HAVE_HW_BREAKPOINT if PERF_EVENTS
> > >  	select HAVE_IRQ_TIME_ACCOUNTING
> > > +	select HAVE_LIVEPATCH
> > >  	select HAVE_NMI
> > >  	select HAVE_PATA_PLATFORM
> > >  	select HAVE_PERF_EVENTS
> > > @@ -1946,3 +1947,5 @@ source "arch/arm64/kvm/Kconfig"
> > >  if CRYPTO
> > >  source "arch/arm64/crypto/Kconfig"
> > >  endif
> > > +
> > > +source "kernel/livepatch/Kconfig"
> > > diff --git a/arch/arm64/include/asm/livepatch.h
> > > b/arch/arm64/include/asm/livepatch.h
> > > new file mode 100644
> > > index 000000000000..72d7cd86f158
> > > --- /dev/null
> > > +++ b/arch/arm64/include/asm/livepatch.h
> > > @@ -0,0 +1,42 @@
> > > +/* SPDX-License-Identifier: GPL-2.0
> > > + *
> > > + * livepatch.h - arm64-specific Kernel Live Patching Core
> > > + */
> > > +#ifndef _ASM_ARM64_LIVEPATCH_H
> > > +#define _ASM_ARM64_LIVEPATCH_H
> > > +
> > > +#include <linux/ftrace.h>
> > > +
> > > +static inline void klp_arch_set_pc(struct ftrace_regs *fregs,
> > > unsigned long ip)
> > > +{
> > > +	struct pt_regs *regs = ftrace_get_regs(fregs);
> > > +
> > > +	regs->pc = ip;
> > > +}
> > > +
> > > +/*
> > > + * klp_get_ftrace_location is expected to return the address of
> > > the BL to the
> > > + * relevant ftrace handler in the callsite. The location of this
> > > can vary based
> > > + * on several compilation options.
> > > + * CONFIG_DYNAMIC_FTRACE_WITH_REGS
> > > + *	- Inserts 2 nops on function entry the second of which
> > > is the
> > > BL
> > > + *	  referenced above. (See ftrace_init_nop() for the
> > > callsite
> > > sequence)
> > > + *	  (this is required by livepatch and must be selected)
> > > + * CONFIG_ARM64_BTI_KERNEL:
> > > + *	- Inserts a hint #0x22 on function entry if the
> > > function is
> > > called
> > > + *	  indirectly (to satisfy BTI requirements), which is
> > > inserted
> > > before
> > > + *	  the two nops from above.
> > > + */
> > > +#define klp_get_ftrace_location klp_get_ftrace_location
> > > +static inline unsigned long klp_get_ftrace_location(unsigned
> > > long
> > > faddr)
> > 
> > Is `faddr` the address of the function, or the addresds of the
> > patch
> > site (the
> > dyn_ftrace::ip)? Either way, I think there's a problem; see below.
> > 
> 
> It is the address of the function.
> 
> > > +{
> > > +	unsigned long addr = faddr + AARCH64_INSN_SIZE;
> > > +
> > > +#if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL)
> > > +	addr = ftrace_location_range(addr, addr + AARCH64_INSN_SIZE);
> > > +#endif
> > 
> > I don't think this is right; function are not guaranteed to have a
> > BTI,
> > since e.g. static functions which are called directly may not be
> > given
> > one:
> 
> Correct, gcc only inserts the instruction on functions which it
> determines are called indirectly and thus validated.
> 
> > 
> > > [mark@lakrids:/mnt/data/tests/bti-patching]% cat test.c
> > > #define noinline __attribute__((noinline))
> > > 
> > > static noinline void a(void)
> > > {
> > >         asm volatile("" ::: "memory");
> > > }
> > > 
> > > void b(void)
> > > {
> > >         a();
> > > }
> > > [mark@lakrids:/mnt/data/tests/bti-patching]% usekorg 10.3.0
> > > aarch64-linux-gcc -c test.c -fpatchable-function-entry=2
> > > -mbranch-
> > > protection=bti -O2
> > > [mark@lakrids:/mnt/data/tests/bti-patching]% usekorg 10.3.0
> > > aarch64-linux-objdump -d
> > > test.o                                                     
> > > 
> > > test.o:     file format elf64-littleaarch64
> > > 
> > > 
> > > Disassembly of section .text:
> > > 
> > > 0000000000000000 <a>:
> > >    0:   d503201f        nop
> > >    4:   d503201f        nop
> > >    8:   d65f03c0        ret
> > >    c:   d503201f        nop
> > > 
> > > 0000000000000010 <b>:
> > >   10:   d503245f        bti     c
> > >   14:   d503201f        nop
> > >   18:   d503201f        nop
> > >   1c:   17fffff9        b       0 <a>
> > 
> > If `faddr` is the address of the function, then we'll need to do
> > something dynamic to skip any BTI. If it's the address of the patch
> > site, then we shouldn't need to consider the BTI at all: att boot
> > time
> > the recorded lcoation points at the first NOP, and at init time we
> > point
> > dyn_ftrace::ip at the second NOP -- see ftrace_call_adjust().
> 
> faddr is the address of the function.
> This concern is what my code attempts to address.
> 
> Either way we need the address of the branch which is
> AARCH64_INSN_SIZE
> after the function address if BTI is _disabled_.
> If BTI is _enabled_ the branch could be either at the address we just
> computed or AARCH64_INSN_SIZE after it depending on if the
> instruction
> was inserted by the compiler. This is why ftrace_location_range() is
> used as it finds the correct ftrace branch location within the
> specified range.
> So the range is from
> faddr + AARCH64_INSN_SIZE (BTI disabled or enabled & not inserted)
> to
> faddr + 2 * AARCH64_INSN_SIZE (BTI enabled and instr inserted)
> 
> > 
> > Thanks,
> > Mark.
> 
> Thanks for taking a look.
> Suraj.
> 
> > 
> > > +
> > > +	return addr;
> > > +}
> > > +
> > > +#endif /* _ASM_ARM64_LIVEPATCH_H */
> > > diff --git a/arch/arm64/include/asm/thread_info.h
> > > b/arch/arm64/include/asm/thread_info.h
> > > index 6623c99f0984..cca936d53a40 100644
> > > --- a/arch/arm64/include/asm/thread_info.h
> > > +++ b/arch/arm64/include/asm/thread_info.h
> > > @@ -67,6 +67,7 @@ int arch_dup_task_struct(struct task_struct
> > > *dst,
> > >  #define TIF_UPROBE		4	/* uprobe breakpoint or
> > > singlestep
> > > */
> > >  #define TIF_MTE_ASYNC_FAULT	5	/* MTE Asynchronous Tag
> > > Check Fault */
> > >  #define TIF_NOTIFY_SIGNAL	6	/* signal notifications
> > > exist */
> > > +#define TIF_PATCH_PENDING	7	/* pending live patching
> > > update */
> > >  #define TIF_SYSCALL_TRACE	8	/* syscall trace active
> > > */
> > >  #define TIF_SYSCALL_AUDIT	9	/* syscall auditing */
> > >  #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for
> > > ftrace */
> > > @@ -97,11 +98,12 @@ int arch_dup_task_struct(struct task_struct
> > > *dst,
> > >  #define _TIF_SVE		(1 << TIF_SVE)
> > >  #define _TIF_MTE_ASYNC_FAULT	(1 << TIF_MTE_ASYNC_FAULT)
> > >  #define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
> > > +#define _TIF_PATCH_PENDING	(1 << TIF_PATCH_PENDING)
> > >  
> > >  #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED |
> > > _TIF_SIGPENDING | \
> > >  				 _TIF_NOTIFY_RESUME |
> > > _TIF_FOREIGN_FPSTATE | \
> > >  				 _TIF_UPROBE | _TIF_MTE_ASYNC_FAULT | \
> > > -				 _TIF_NOTIFY_SIGNAL)
> > > +				 _TIF_NOTIFY_SIGNAL |
> > > _TIF_PATCH_PENDING)
> > >  
> > >  #define _TIF_SYSCALL_WORK	(_TIF_SYSCALL_TRACE |
> > > _TIF_SYSCALL_AUDIT | \
> > >  				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP
> > > > \
> > > 
> > > diff --git a/arch/arm64/kernel/signal.c
> > > b/arch/arm64/kernel/signal.c
> > > index 6237486ff6bb..d1eedb0589a7 100644
> > > --- a/arch/arm64/kernel/signal.c
> > > +++ b/arch/arm64/kernel/signal.c
> > > @@ -18,6 +18,7 @@
> > >  #include <linux/sizes.h>
> > >  #include <linux/string.h>
> > >  #include <linux/tracehook.h>
> > > +#include <linux/livepatch.h>
> > >  #include <linux/ratelimit.h>
> > >  #include <linux/syscalls.h>
> > >  
> > > @@ -932,6 +933,9 @@ asmlinkage void do_notify_resume(struct
> > > pt_regs
> > > *regs,
> > >  					       (void __user *)NULL,
> > > current);
> > >  			}
> > >  
> > > +			if (thread_flags & _TIF_PATCH_PENDING)
> > > +				klp_update_patch_state(current);
> > > +
> > >  			if (thread_flags & (_TIF_SIGPENDING |
> > > _TIF_NOTIFY_SIGNAL))
> > >  				do_signal(regs);
> > >  
> > > -- 
> > > 2.17.1
> > > 
> 
> 

