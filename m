Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D5635349E
	for <lists+live-patching@lfdr.de>; Sat,  3 Apr 2021 17:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236724AbhDCQAB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 3 Apr 2021 12:00:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21100 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236426AbhDCQAB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 3 Apr 2021 12:00:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617465597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DUOJF2tENL+V20b7Norwu9+3fd7hFO0/P2ZvHDYWJZg=;
        b=JzCR8Nm3B17cTubemJA+RFoF7zmXQYQ77UQOUNdLDdbjobLKhHMDX9R7JFvp80wz7L31l3
        YAgFqg9kKirrzFyt53Skks22qMsBsCIT8mBu+uPLArOx9eJOz1bjR+O2eBQ1ToCCKdCnvv
        pJcuH/JZ8KQZKB56TD3QKWHtV7dUFFE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-QhxR3gKIPF-XW4wD9-Z3JQ-1; Sat, 03 Apr 2021 11:59:55 -0400
X-MC-Unique: QhxR3gKIPF-XW4wD9-Z3JQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A039D180FCA1;
        Sat,  3 Apr 2021 15:59:54 +0000 (UTC)
Received: from treble (ovpn-116-68.rdu2.redhat.com [10.10.116.68])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2428F5D9DC;
        Sat,  3 Apr 2021 15:59:49 +0000 (UTC)
Date:   Sat, 3 Apr 2021 10:59:48 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, broonie@kernel.org, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/1] arm64: Implement stack trace termination
 record
Message-ID: <20210403155948.ubbgtwmlsdyar7yp@treble>
References: <659f3d5cc025896ba4c49aea431aa8b1abc2b741>
 <20210402032404.47239-1-madvenka@linux.microsoft.com>
 <20210402032404.47239-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210402032404.47239-2-madvenka@linux.microsoft.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Apr 01, 2021 at 10:24:04PM -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> @@ -447,9 +464,9 @@ SYM_FUNC_START_LOCAL(__primary_switched)
>  #endif
>  	bl	switch_to_vhe			// Prefer VHE if possible
>  	add	sp, sp, #16
> -	mov	x29, #0
> -	mov	x30, #0
> -	b	start_kernel
> +	setup_final_frame
> +	bl	start_kernel
> +	nop
>  SYM_FUNC_END(__primary_switched)
>  
>  	.pushsection ".rodata", "a"
> @@ -606,14 +623,14 @@ SYM_FUNC_START_LOCAL(__secondary_switched)
>  	cbz	x2, __secondary_too_slow
>  	msr	sp_el0, x2
>  	scs_load x2, x3
> -	mov	x29, #0
> -	mov	x30, #0
> +	setup_final_frame
>  
>  #ifdef CONFIG_ARM64_PTR_AUTH
>  	ptrauth_keys_init_cpu x2, x3, x4, x5
>  #endif
>  
> -	b	secondary_start_kernel
> +	bl	secondary_start_kernel
> +	nop
>  SYM_FUNC_END(__secondary_switched)

I'm somewhat arm-ignorant, so take the following comments with a grain
of salt.


I don't think changing these to 'bl' is necessary, unless you wanted
__primary_switched() and __secondary_switched() to show up in the
stacktrace for some reason?  If so, that seems like a separate patch.


Also, why are nops added after the calls?  My guess would be because,
since these are basically tail calls to "noreturn" functions, the stack
dump code would otherwise show the wrong function, i.e. whatever
function happens to be after the 'bl'.

We had the same issue for x86.  It can be fixed by using '%pB' instead
of '%pS' when printing the address in dump_backtrace_entry().  See
sprint_backtrace() for more details.

BTW I think the same issue exists for GCC-generated code.  The following
shows several such cases:

  objdump -dr vmlinux |awk '/bl   / {bl=1;l=$0;next} bl == 1 && /^$/ {print l; print} // {bl=0}'


However, looking at how arm64 unwinds through exceptions in kernel
space, using '%pB' might have side effects when the exception LR
(elr_el1) points to the beginning of a function.  Then '%pB' would show
the end of the previous function, instead of the function which was
interrupted.

So you may need to rethink how to unwind through in-kernel exceptions.

Basically, when printing a stack return address, you want to use '%pB'
for a call return address and '%pS' for an interrupted address.

On x86, with the frame pointer unwinder, we encode the frame pointer by
setting a bit in %rbp which tells the unwinder that it's a special
pt_regs frame.  Then instead of treating it like a normal call frame,
the stack dump code prints the registers, and the return address
(regs->ip) gets printed with '%pS'.

>  SYM_FUNC_START_LOCAL(__secondary_too_slow)
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 325c83b1a24d..906baa232a89 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -437,6 +437,11 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
>  	}
>  	p->thread.cpu_context.pc = (unsigned long)ret_from_fork;
>  	p->thread.cpu_context.sp = (unsigned long)childregs;
> +	/*
> +	 * For the benefit of the unwinder, set up childregs->stackframe
> +	 * as the final frame for the new task.
> +	 */
> +	p->thread.cpu_context.fp = (unsigned long)childregs->stackframe;
>  
>  	ptrace_hw_copy_thread(p);
>  
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index ad20981dfda4..72f5af8c69dc 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -44,16 +44,16 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
>  	unsigned long fp = frame->fp;
>  	struct stack_info info;
>  
> -	/* Terminal record; nothing to unwind */
> -	if (!fp)
> +	if (!tsk)
> +		tsk = current;
> +
> +	/* Final frame; nothing to unwind */
> +	if (fp == (unsigned long) task_pt_regs(tsk)->stackframe)
>  		return -ENOENT;

As far as I can tell, the regs stackframe value is initialized to zero
during syscall entry, so isn't this basically just 'if (fp == 0)'?

Shouldn't it instead be comparing with the _address_ of the stackframe
field to make sure it reached the end?

-- 
Josh

