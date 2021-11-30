Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAED463DD0
	for <lists+live-patching@lfdr.de>; Tue, 30 Nov 2021 19:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239435AbhK3Scy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Nov 2021 13:32:54 -0500
Received: from foss.arm.com ([217.140.110.172]:45364 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233978AbhK3Scx (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Nov 2021 13:32:53 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2516B106F;
        Tue, 30 Nov 2021 10:29:34 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.65.89])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 469C23F694;
        Tue, 30 Nov 2021 10:29:32 -0800 (PST)
Date:   Tue, 30 Nov 2021 18:29:27 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 1/5] arm64: Call stack_backtrace() only from within
 walk_stackframe()
Message-ID: <YaZtUmBn1NUkY876@FVFF77S0Q05N>
References: <8b861784d85a21a9bf08598938c11aff1b1249b9>
 <20211123193723.12112-1-madvenka@linux.microsoft.com>
 <20211123193723.12112-2-madvenka@linux.microsoft.com>
 <YaY9zLNumYZ1lLkc@FVFF77S0Q05N>
 <f2dfa6cd-7a23-e1b7-09d5-737d4a95b90c@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2dfa6cd-7a23-e1b7-09d5-737d4a95b90c@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Nov 30, 2021 at 11:13:28AM -0600, Madhavan T. Venkataraman wrote:
> On 11/30/21 9:05 AM, Mark Rutland wrote:
> > On Tue, Nov 23, 2021 at 01:37:19PM -0600, madvenka@linux.microsoft.com wrote:
> >> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> >>
> >> Currently, arch_stack_walk() calls start_backtrace() and walk_stackframe()
> >> separately. There is no need to do that. Instead, call start_backtrace()
> >> from within walk_stackframe(). In other words, walk_stackframe() is the only
> >> unwind function a consumer needs to call.

> >> @@ -143,15 +140,19 @@ static int notrace unwind_frame(struct task_struct *tsk,
> >>  NOKPROBE_SYMBOL(unwind_frame);
> >>  
> >>  static void notrace walk_stackframe(struct task_struct *tsk,
> >> -				    struct stackframe *frame,
> >> +				    unsigned long fp, unsigned long pc,
> >>  				    bool (*fn)(void *, unsigned long), void *data)
> >>  {
> >> +	struct stackframe frame;
> >> +
> >> +	start_backtrace(&frame, fp, pc);
> >> +
> >>  	while (1) {
> >>  		int ret;
> >>  
> >> -		if (!fn(data, frame->pc))
> >> +		if (!fn(data, frame.pc))
> >>  			break;
> >> -		ret = unwind_frame(tsk, frame);
> >> +		ret = unwind_frame(tsk, &frame);
> >>  		if (ret < 0)
> >>  			break;
> >>  	}
> >> @@ -195,17 +196,19 @@ noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
> >>  			      void *cookie, struct task_struct *task,
> >>  			      struct pt_regs *regs)
> >>  {
> >> -	struct stackframe frame;
> >> -
> >> -	if (regs)
> >> -		start_backtrace(&frame, regs->regs[29], regs->pc);
> >> -	else if (task == current)
> >> -		start_backtrace(&frame,
> >> -				(unsigned long)__builtin_frame_address(1),
> >> -				(unsigned long)__builtin_return_address(0));
> >> -	else
> >> -		start_backtrace(&frame, thread_saved_fp(task),
> >> -				thread_saved_pc(task));
> >> -
> >> -	walk_stackframe(task, &frame, consume_entry, cookie);
> >> +	unsigned long fp, pc;
> >> +
> >> +	if (regs) {
> >> +		fp = regs->regs[29];
> >> +		pc = regs->pc;
> >> +	} else if (task == current) {
> >> +		/* Skip arch_stack_walk() in the stack trace. */
> >> +		fp = (unsigned long)__builtin_frame_address(1);
> >> +		pc = (unsigned long)__builtin_return_address(0);
> >> +	} else {
> >> +		/* Caller guarantees that the task is not running. */
> >> +		fp = thread_saved_fp(task);
> >> +		pc = thread_saved_pc(task);
> >> +	}
> >> +	walk_stackframe(task, fp, pc, consume_entry, cookie);
> > 
> > I'd prefer to leave this as-is. The new and old structure are largely
> > equivalent, so we haven't made this any simpler, but we have added more
> > arguments to walk_stackframe().
> > 
> 
> This is just to simplify things when we eventually add arch_stack_walk_reliable().
> That is all. All of the unwinding is done by a single unwinding function and
> there are two consumers of that unwinding function - arch_stack_walk() and
> arch_stack_walk_reliable().

I understand the theory, but I don't think that moving the start_backtrace()
call actually simplifies this in a meaningful way, and I think it'll make it
harder for us to make more meaningful simplifications later on.

As of patch 4 of this series, we'll have:

| noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
| 				      void *cookie, struct task_struct *task,
| 				      struct pt_regs *regs)
| {
| 	unsigned long fp, pc;
| 
| 	if (regs) {
| 		fp = regs->regs[29];
| 		pc = regs->pc;
| 	} else if (task == current) {
| 		/* Skip arch_stack_walk() in the stack trace. */
| 		fp = (unsigned long)__builtin_frame_address(1);
| 		pc = (unsigned long)__builtin_return_address(0);
| 	} else {
| 		/* Caller guarantees that the task is not running. */
| 		fp = thread_saved_fp(task);
| 		pc = thread_saved_pc(task);
| 	}
| 	walk_stackframe(task, fp, pc, consume_entry, cookie);
| }
| 
| noinline int notrace arch_stack_walk_reliable(stack_trace_consume_fn consume_fn,
|                                              void *cookie,
|                                              struct task_struct *task)
| {
| 	unsigned long fp, pc;
| 
| 	if (task == current) {
| 		/* Skip arch_stack_walk_reliable() in the stack trace. */
| 		fp = (unsigned long)__builtin_frame_address(1);
| 		pc = (unsigned long)__builtin_return_address(0);
| 	} else {
| 		/* Caller guarantees that the task is not running. */
| 		fp = thread_saved_fp(task);
| 		pc = thread_saved_pc(task);
| 	}
| 	if (unwind(task, fp, pc, consume_fn, cookie))
| 		return 0;
| 	return -EINVAL;
| }

Which I do not think is substantially simpler than the naive extrapolation from
what we currently have, e.g.

| noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
| 				      void *cookie, struct task_struct *task,
| 				      struct pt_regs *regs)
| {
|	struct stackframe frame;
| 
| 	if (regs) {
|		unwind_init(&frame, regs->regs[29], regs->pc)
| 	} else if (task == current) {
|		unwind_init(&frame, __builtin_frame_address(1),
|			    __builtin_return_address(0));
| 	} else {
|		unwind_init(&frame, thread_saved_fp(task),
|			    thread_saved_pc(task);
| 	}
| 	walk_stackframe(task, &frame, consume_entry, cookie);
| }
| 
| noinline int notrace arch_stack_walk_reliable(stack_trace_consume_fn consume_fn,
|                                              void *cookie,
|                                              struct task_struct *task)
| {
|	struct stackframe frame;
| 
| 	if (task == current) {
|		unwind_init(&frame, __builtin_frame_address(1),
|			    __builtin_return_address(0));
| 	} else {
|		unwind_init(&frame, thread_saved_fp(task),
|			    thread_saved_pc(task);
| 	}
| 	if (unwind(task, &frame, consume_fn, cookie))
| 		return 0;
| 	return -EINVAL;
| }

Further, I think we can factor this in a different way to reduce the
duplication:

| /*
|  * TODO: document requirements here
|  */
| static inline void unwind_init_from_current_regs(struct stackframe *frame,
| 						 struct pt_regs *regs)
| {
| 	unwind_init(frame, regs->regs[29], regs->pc);
| }
| 
| /*
|  * TODO: document requirements here
|  */
| static inline void unwind_init_from_blocked_task(struct stackframe *frame,
| 						 struct task_struct *tsk)
| {
| 	unwind_init(&frame, thread_saved_fp(task),
| 		    thread_saved_pc(task));
| }
| 
| /*
|  * TODO: document requirements here
|  *
|  * Note: this is always inlined, and we expect our caller to be a noinline
|  * function, such that this starts from our caller's caller.
|  */
| static __always_inline void unwind_init_from_caller(struct stackframe *frame)
| {
| 	unwind_init(frame, __builtin_frame_address(1),
| 		    __builtin_return_address(0));
| }
|
| noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
| 				      void *cookie, struct task_struct *task,
| 				      struct pt_regs *regs)
| {
|	struct stackframe frame;
| 
| 	if (regs)
|		unwind_init_current_regs(&frame, regs);
|	else if (task == current)
|		unwind_init_from_caller(&frame);
|	else
|		unwind_init_blocked_task(&frame, task);
|
|	unwind(task, &frame, consume_entry, cookie);
| }
|
| noinline int notrace arch_stack_walk_reliable(stack_trace_consume_fn consume_fn,
|                                              void *cookie,
|                                              struct task_struct *task)
| {
|	struct stackframe frame;
| 
| 	if (task == current)
|		unwind_init_from_caller(&frame);
| 	else
|		unwind_init_from_blocked_task(&frame, task);
|
| 	if (unwind(task, &frame, consume_fn, cookie))
| 		return 0;
| 	return -EINVAL;
| }

... which minimizes the duplication and allows us to add specialized
initialization for each case if necessary, which I believe we will need in
future to make unwinding across exception boundaries (such as when starting
with regs) more useful.

Thanks,
Mark.
