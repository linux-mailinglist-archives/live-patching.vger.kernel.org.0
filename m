Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1DCF436BF0
	for <lists+live-patching@lfdr.de>; Thu, 21 Oct 2021 22:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhJUUXP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Oct 2021 16:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhJUUXO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Oct 2021 16:23:14 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84ADFC061764;
        Thu, 21 Oct 2021 13:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KA30CcQ+4Zl2U8f/hBVPDhwHffIA5aIp2amvt4GoJrM=; b=CWjJHQhLrboPEBy9YoYtlMNNiI
        RYw4KkS1dnmVQq52gKWRnvOUCr3ngxsIi8Ya8MfmH2h03WpC1XbmHUdlah8jm6tc/Jj5u5JzKPKOD
        PS5QD2BTX0o4CvGpmBB1iP2CGV/hWlo1PEQYbMKBsPlNkds6dbxMU6IMHAmKVfVmQzrLUF8AiExGO
        R/mcQ6TN6m97Ps/5yZOPB00No9jfz8yeLUjeeR9U6ZJy1zVoKgMkKutZZB11+6o2ZwC37sdCjXOKs
        iZpK23hkNUsTs5zVnY488pSLSxtryI2w5oQuR472Psr3SoYTZzEZdTNUcy/MMDQeG4UeZcFvXZVNc
        +7Pu6XwQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mdeWi-00BQaN-VH; Thu, 21 Oct 2021 20:19:40 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id BC6D89812EB; Thu, 21 Oct 2021 22:18:59 +0200 (CEST)
Date:   Thu, 21 Oct 2021 22:18:59 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: Re: [RFC][PATCH v2 11/11] context_tracking,x86: Fix text_poke_sync()
 vs NOHZ_FULL
Message-ID: <20211021201859.GX174703@worktop.programming.kicks-ass.net>
References: <20210929151723.162004989@infradead.org>
 <20210929152429.186930629@infradead.org>
 <20211021183935.GA9071@fuller.cnet>
 <20211021192543.GV174703@worktop.programming.kicks-ass.net>
 <20211021195709.GA22422@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021195709.GA22422@fuller.cnet>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Oct 21, 2021 at 04:57:09PM -0300, Marcelo Tosatti wrote:
> > Pretty much everything in noinstr is magical, we just have to think
> > harder there (and possibly start writing more comments there).
> 
> mds_user_clear_cpu_buffers happens after sync_core, in your patchset, 
> if i am not mistaken.

Of course it does, mds_user_clear_cpu_buffers() is on exit, the
sync_core() is on entry.

> > > > +             /* NMI happens here and must still do/finish CT_WORK_n */
> > > > +             sync_core();
> > > 
> > > But after the discussion with you, it seems doing the TLB checking 
> > > and (also sync_core) checking very late/very early on exit/entry 
> > > makes things easier to review.
> > 
> > I don't know about late, it must happen *very* early in entry. The
> > sync_core() must happen before any self-modifying code gets called
> > (static_branch, static_call, etc..) with possible exception of the
> > context_tracking static_branch.
> > 
> > The TLBi must also happen super early, possibly while still on the
> > entry stack (since the task stack is vmap'ed).
> 
> But will it be ever be freed/remapped from other CPUs while the task
> is running?

Probably not, still something we need to be really careful with.
> 
> > We currently don't run C
> > code on the entry stack, that needs quite a bit of careful work to make
> > happen.
> 
> Was thinking of coding in ASM after (as early as possible) the write to 
> switch to kernel CR3:

No, we're not going to add new feature to ASM. You'll just have to wait
until all that gets lifted to C.

>  Kernel entry:
>  -------------
> 
>        cpu = smp_processor_id();
> 
>        if (isolation_enabled(cpu)) {
>                reqs = atomic_xchg(&percpudata->user_kernel_state, IN_KERNEL_MODE);
>                if (reqs & CPU_REQ_FLUSH_TLB)
> 			flush_tlb_all();
>                if (reqs & CPU_REQ_SYNC_CORE)
> 			sync_core();
>        }                           
> 
> Exit to userspace (as close to write to CR3 with user pagetable
> pointer):
>  -----------------
> 
>        cpu = smp_processor_id();
> 
>        if (isolation_enabled(cpu)) {
>                atomic_or(IN_USER_MODE, &percpudata->user_kernel_state);
>        }
> 
> You think that is a bad idea (in ASM, not C) ? 

Those atomics are a bad idea and not goig to happen.

> > We're not going to add an atomic to context tracking. There is one, we
> > just got to extract/share it with RCU.
> 
> Again, to avoid kernel TLB flushes you'd have to ensure:

I know how it works, but we're not going to add a second atomic to
entry/exit. RCU has one in there, that's going to be it. Again, we just
got to extract/share.
