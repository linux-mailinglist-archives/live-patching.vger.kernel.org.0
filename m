Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206CD345FC7
	for <lists+live-patching@lfdr.de>; Tue, 23 Mar 2021 14:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhCWNgj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Mar 2021 09:36:39 -0400
Received: from foss.arm.com ([217.140.110.172]:46550 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231474AbhCWNgQ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Mar 2021 09:36:16 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4187D6E;
        Tue, 23 Mar 2021 06:36:15 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.24.204])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B3D8E3F719;
        Tue, 23 Mar 2021 06:36:13 -0700 (PDT)
Date:   Tue, 23 Mar 2021 13:36:11 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 5/8] arm64: Detect an FTRACE frame and mark a
 stack trace unreliable
Message-ID: <20210323133611.GB98545@C02TD0UTHF1T.local>
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-6-madvenka@linux.microsoft.com>
 <20210323105118.GE95840@C02TD0UTHF1T.local>
 <2167f3c5-e7d0-40c8-99e3-ae89ceb2d60e@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2167f3c5-e7d0-40c8-99e3-ae89ceb2d60e@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Mar 23, 2021 at 07:56:40AM -0500, Madhavan T. Venkataraman wrote:
> 
> 
> On 3/23/21 5:51 AM, Mark Rutland wrote:
> > On Mon, Mar 15, 2021 at 11:57:57AM -0500, madvenka@linux.microsoft.com wrote:
> >> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> >>
> >> When CONFIG_DYNAMIC_FTRACE_WITH_REGS is enabled and tracing is activated
> >> for a function, the ftrace infrastructure is called for the function at
> >> the very beginning. Ftrace creates two frames:
> >>
> >> 	- One for the traced function
> >>
> >> 	- One for the caller of the traced function
> >>
> >> That gives a reliable stack trace while executing in the ftrace
> >> infrastructure code. When ftrace returns to the traced function, the frames
> >> are popped and everything is back to normal.
> >>
> >> However, in cases like live patch, execution is redirected to a different
> >> function when ftrace returns. A stack trace taken while still in the ftrace
> >> infrastructure code will not show the target function. The target function
> >> is the real function that we want to track.
> >>
> >> So, if an FTRACE frame is detected on the stack, just mark the stack trace
> >> as unreliable.
> > 
> > To identify this case, please identify the ftrace trampolines instead,
> > e.g. ftrace_regs_caller, return_to_handler.
> > 
> 
> Yes. As part of the return address checking, I will check this. IIUC, I think that
> I need to check for the inner labels that are defined at the point where the
> instructions are patched for ftrace. E.g., ftrace_call and ftrace_graph_call.
> 
> SYM_INNER_LABEL(ftrace_call, SYM_L_GLOBAL)
>         bl      ftrace_stub	<====================================
> 
> #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> SYM_INNER_LABEL(ftrace_graph_call, SYM_L_GLOBAL) // ftrace_graph_caller();
>         nop	<=======                // If enabled, this will be replaced
>                                         // "b ftrace_graph_caller"
> #endif
> 
> For instance, the stack trace I got while tracing do_mmap() with the stack trace
> tracer looks like this:
> 
> 		 ...
> [  338.911793]   trace_function+0xc4/0x160
> [  338.911801]   function_stack_trace_call+0xac/0x130
> [  338.911807]   ftrace_graph_call+0x0/0x4
> [  338.911813]   do_mmap+0x8/0x598
> [  338.911820]   vm_mmap_pgoff+0xf4/0x188
> [  338.911826]   ksys_mmap_pgoff+0x1d8/0x220
> [  338.911832]   __arm64_sys_mmap+0x38/0x50
> [  338.911839]   el0_svc_common.constprop.0+0x70/0x1a8
> [  338.911846]   do_el0_svc+0x2c/0x98
> [  338.911851]   el0_svc+0x2c/0x70
> [  338.911859]   el0_sync_handler+0xb0/0xb8
> [  338.911864]   el0_sync+0x180/0x1c0
> 
> > It'd be good to check *exactly* when we need to reject, since IIUC when
> > we have a graph stack entry the unwind will be correct from livepatch's
> > PoV.
> > 
> 
> The current unwinder already handles this like this:
> 
> #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>         if (tsk->ret_stack &&
>                 (ptrauth_strip_insn_pac(frame->pc) == (unsigned long)return_to_handler)) {
>                 struct ftrace_ret_stack *ret_stack;
>                 /*
>                  * This is a case where function graph tracer has
>                  * modified a return address (LR) in a stack frame
>                  * to hook a function return.
>                  * So replace it to an original value.
>                  */
>                 ret_stack = ftrace_graph_get_ret_stack(tsk, frame->graph++);
>                 if (WARN_ON_ONCE(!ret_stack))
>                         return -EINVAL;
>                 frame->pc = ret_stack->ret;
>         }
> #endif /* CONFIG_FUNCTION_GRAPH_TRACER */

Beware that this handles the case where a function will return to
return_to_handler, but doesn't handle unwinding from *within*
return_to_handler, which we can't do reliably today, so that might need
special handling.

> Is there anything else that needs handling here?

I wrote up a few cases to consider in:

https://www.kernel.org/doc/html/latest/livepatch/reliable-stacktrace.html

... e.g. the "Obscuring of return addresses" case.

It might be that we're fine so long as we refuse to unwind across
exception boundaries, but it needs some thought. We probably need to go
over each of the trampolines instruction-by-instruction to consider
that.

As mentioned above, within return_to_handler when we call
ftrace_return_to_handler, there's a period where the real return address
has been removed from the ftrace return stack, but hasn't yet been
placed in x30, and wouldn't show up in a trace (e.g. if we could somehow
hook the return from ftrace_return_to_handler).

We might be saved by the fact we'll mark traces across exception
boundaries as unreliable, but I haven't thought very hard about it. We
might want to explciitly reject unwinds within return_to_handler in case
it's possible to interpose ftrace_return_to_handler somehow.

Thanks,
Mark.
