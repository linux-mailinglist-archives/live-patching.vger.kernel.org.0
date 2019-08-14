Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 141788D180
	for <lists+live-patching@lfdr.de>; Wed, 14 Aug 2019 12:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfHNKwO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Aug 2019 06:52:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:57832 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725888AbfHNKwO (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Aug 2019 06:52:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 87819ADEF;
        Wed, 14 Aug 2019 10:52:12 +0000 (UTC)
Date:   Wed, 14 Aug 2019 12:52:07 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, jikos@kernel.org, pmladek@suse.com,
        joe.lawrence@redhat.com, nstange@suse.de,
        live-patching@vger.kernel.org
Subject: Re: [PATCH] s390/livepatch: Implement reliable stack tracing for
 the consistency model
In-Reply-To: <20190728204456.7bxnsbuo4o3tjxeq@treble>
Message-ID: <alpine.LSU.2.21.1908141241061.16696@pobox.suse.cz>
References: <20190710105918.22487-1-mbenes@suse.cz> <20190728204456.7bxnsbuo4o3tjxeq@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> > diff --git a/arch/s390/include/asm/unwind.h b/arch/s390/include/asm/unwind.h
> > index d827b5b9a32c..1cc96c54169c 100644
> > --- a/arch/s390/include/asm/unwind.h
> > +++ b/arch/s390/include/asm/unwind.h
> > @@ -45,6 +45,25 @@ void __unwind_start(struct unwind_state *state, struct task_struct *task,
> >  bool unwind_next_frame(struct unwind_state *state);
> >  unsigned long unwind_get_return_address(struct unwind_state *state);
> >  
> > +#ifdef CONFIG_HAVE_RELIABLE_STACKTRACE
> > +void __unwind_start_reliable(struct unwind_state *state,
> > +			     struct task_struct *task, unsigned long sp);
> > +bool unwind_next_frame_reliable(struct unwind_state *state);
> > +
> > +static inline void unwind_start_reliable(struct unwind_state *state,
> > +					 struct task_struct *task)
> > +{
> > +	unsigned long sp;
> > +
> > +	if (task == current)
> > +		sp = current_stack_pointer();
> > +	else
> > +		sp = task->thread.ksp;
> > +
> > +	__unwind_start_reliable(state, task, sp);
> > +}
> > +#endif
> > +
> 
> (Ah, cool, I didn't realize s390 ported the x86 unwind interfaces.  We
> should look at unifying them someday.)

Yes, it is quite recent change.
 
> Why do you need _reliable() variants of the unwind interfaces?  Can the
> error checking be integrated into unwind_start() and unwind_next_frame()
> like they are on x86?

Good question. I rebased the patch a lot of times and it was much easier 
in the end just to separate the original and reliable infrastructure. Not 
the best for upstream inclusion though.

unwind_start_reliable() is basically the same as the original. 
get_stack_info_reliable() is the main difference. It is much simpler in 
our case. I wanted to avoid a new parameter or a callback, but let me 
think about it again.

unwind_next_frame_reliable() is again a lot simpler than the original one, 
because we know that the unwinding happens only on a task stack. I'll 
think about inclusion to the unwind_next_frame() though. The code 
duplication is not nice.

> > +#ifdef CONFIG_HAVE_RELIABLE_STACKTRACE
> > +void __unwind_start_reliable(struct unwind_state *state,
> > +			     struct task_struct *task, unsigned long sp)
> > +{
> > +	struct stack_info *info = &state->stack_info;
> > +	struct stack_frame *sf;
> > +	unsigned long ip;
> > +
> > +	memset(state, 0, sizeof(*state));
> > +	state->task = task;
> > +
> > +	/* Get current stack pointer and initialize stack info */
> > +	if (get_stack_info_reliable(sp, task, info) ||
> > +	    !on_stack(info, sp, sizeof(struct stack_frame))) {
> > +		/* Something is wrong with the stack pointer */
> > +		info->type = STACK_TYPE_UNKNOWN;
> > +		state->error = true;
> > +		return;
> > +	}
> > +
> > +	/* Get the instruction pointer from the stack frame */
> > +	sf = (struct stack_frame *) sp;
> > +	ip = READ_ONCE_NOCHECK(sf->gprs[8]);
> > +
> > +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> > +	/* Decode any ftrace redirection */
> > +	if (ip == (unsigned long) return_to_handler)
> > +		ip = ftrace_graph_ret_addr(state->task, &state->graph_idx,
> > +					   ip, NULL);
> > +#endif
> 
> The return_to_handler and ifdef checks aren't needed.  Those are done
> already by the call.

Correct. I realized it when Joe asked about the hunk.
 
> Also it seems a bit odd that the kretprobes check isn't done in this
> function next to the ftrace check.

Ah, yes.

> > +
> > +	/* Update unwind state */
> > +	state->sp = sp;
> > +	state->ip = ip;
> > +}
> > +
> > +bool unwind_next_frame_reliable(struct unwind_state *state)
> > +{
> > +	struct stack_info *info = &state->stack_info;
> > +	struct stack_frame *sf;
> > +	struct pt_regs *regs;
> > +	unsigned long sp, ip;
> > +
> > +	sf = (struct stack_frame *) state->sp;
> > +	sp = READ_ONCE_NOCHECK(sf->back_chain);
> > +	/*
> > +	 * Idle tasks are special. The final back-chain points to nodat_stack.
> > +	 * See CALL_ON_STACK() in smp_start_secondary() callback used in
> > +	 * __cpu_up(). We just accept it, go to else branch and look for
> > +	 * pt_regs.
> > +	 */
> > +	if (likely(sp && !(is_idle_task(state->task) &&
> > +			   outside_of_stack(state, sp)))) {
> > +		/* Non-zero back-chain points to the previous frame */
> > +		if (unlikely(outside_of_stack(state, sp)))
> > +			goto out_err;
> > +
> > +		sf = (struct stack_frame *) sp;
> > +		ip = READ_ONCE_NOCHECK(sf->gprs[8]);
> > +	} else {
> > +		/* No back-chain, look for a pt_regs structure */
> > +		sp = state->sp + STACK_FRAME_OVERHEAD;
> > +		regs = (struct pt_regs *) sp;
> > +		if ((unsigned long)regs != info->end - sizeof(struct pt_regs))
> > +			goto out_err;
> > +		if (!(state->task->flags & (PF_KTHREAD | PF_IDLE)) &&
> > +		     !user_mode(regs))
> > +			goto out_err;
> > +
> > +		state->regs = regs;
> > +		goto out_stop;
> > +	}
> > +
> > +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> > +	/* Decode any ftrace redirection */
> > +	if (ip == (unsigned long) return_to_handler)
> > +		ip = ftrace_graph_ret_addr(state->task, &state->graph_idx,
> > +					   ip, (void *) sp);
> > +#endif
> > +
> > +	/* Update unwind state */
> > +	state->sp = sp;
> > +	state->ip = ip;
> > +	return true;
> > +
> > +out_err:
> > +	state->error = true;
> > +out_stop:
> > +	state->stack_info.type = STACK_TYPE_UNKNOWN;
> > +	return false;
> > +}
> > +#endif
> 
> For the _reliable() variants of the unwind interfaces, there's a lot of
> code duplication with the non-reliable variants.  It looks like it would
> be a lot cleaner (and easier to follow) if they were integrated.

True.
 
> Overall it's looking good though.

Great. Now let me try to make it nicer.

Thanks for the review.

Miroslav
