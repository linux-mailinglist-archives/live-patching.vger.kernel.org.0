Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE0567818F
	for <lists+live-patching@lfdr.de>; Sun, 28 Jul 2019 22:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbfG1UpD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 28 Jul 2019 16:45:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37392 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbfG1UpC (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Sun, 28 Jul 2019 16:45:02 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1C2C0308FC20;
        Sun, 28 Jul 2019 20:45:02 +0000 (UTC)
Received: from treble (ovpn-120-102.rdu2.redhat.com [10.10.120.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F5A6600C7;
        Sun, 28 Jul 2019 20:44:58 +0000 (UTC)
Date:   Sun, 28 Jul 2019 15:44:56 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, jikos@kernel.org, pmladek@suse.com,
        joe.lawrence@redhat.com, nstange@suse.de,
        live-patching@vger.kernel.org
Subject: Re: [PATCH] s390/livepatch: Implement reliable stack tracing for the
 consistency model
Message-ID: <20190728204456.7bxnsbuo4o3tjxeq@treble>
References: <20190710105918.22487-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190710105918.22487-1-mbenes@suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Sun, 28 Jul 2019 20:45:02 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jul 10, 2019 at 12:59:18PM +0200, Miroslav Benes wrote:
> The livepatch consistency model requires reliable stack tracing
> architecture support in order to work properly. In order to achieve
> this, two main issues have to be solved. First, reliable and consistent
> call chain backtracing has to be ensured. Second, the unwinder needs to
> be able to detect stack corruptions and return errors.
> 
> The "zSeries ELF Application Binary Interface Supplement" says:
> 
>   "The stack pointer points to the first word of the lowest allocated
>   stack frame. If the "back chain" is implemented this word will point to
>   the previously allocated stack frame (towards higher addresses), except
>   for the first stack frame, which shall have a back chain of zero (NULL).
>   The stack shall grow downwards, in other words towards lower addresses."
> 
> "back chain" is optional. GCC option -mbackchain enables it. Quoting
> Martin Schwidefsky [1]:

This reference footnote seems to be missing at the bottom of the patch
description.

> diff --git a/arch/s390/include/asm/unwind.h b/arch/s390/include/asm/unwind.h
> index d827b5b9a32c..1cc96c54169c 100644
> --- a/arch/s390/include/asm/unwind.h
> +++ b/arch/s390/include/asm/unwind.h
> @@ -45,6 +45,25 @@ void __unwind_start(struct unwind_state *state, struct task_struct *task,
>  bool unwind_next_frame(struct unwind_state *state);
>  unsigned long unwind_get_return_address(struct unwind_state *state);
>  
> +#ifdef CONFIG_HAVE_RELIABLE_STACKTRACE
> +void __unwind_start_reliable(struct unwind_state *state,
> +			     struct task_struct *task, unsigned long sp);
> +bool unwind_next_frame_reliable(struct unwind_state *state);
> +
> +static inline void unwind_start_reliable(struct unwind_state *state,
> +					 struct task_struct *task)
> +{
> +	unsigned long sp;
> +
> +	if (task == current)
> +		sp = current_stack_pointer();
> +	else
> +		sp = task->thread.ksp;
> +
> +	__unwind_start_reliable(state, task, sp);
> +}
> +#endif
> +

(Ah, cool, I didn't realize s390 ported the x86 unwind interfaces.  We
should look at unifying them someday.)

Why do you need _reliable() variants of the unwind interfaces?  Can the
error checking be integrated into unwind_start() and unwind_next_frame()
like they are on x86?

> +#ifdef CONFIG_HAVE_RELIABLE_STACKTRACE
> +void __unwind_start_reliable(struct unwind_state *state,
> +			     struct task_struct *task, unsigned long sp)
> +{
> +	struct stack_info *info = &state->stack_info;
> +	struct stack_frame *sf;
> +	unsigned long ip;
> +
> +	memset(state, 0, sizeof(*state));
> +	state->task = task;
> +
> +	/* Get current stack pointer and initialize stack info */
> +	if (get_stack_info_reliable(sp, task, info) ||
> +	    !on_stack(info, sp, sizeof(struct stack_frame))) {
> +		/* Something is wrong with the stack pointer */
> +		info->type = STACK_TYPE_UNKNOWN;
> +		state->error = true;
> +		return;
> +	}
> +
> +	/* Get the instruction pointer from the stack frame */
> +	sf = (struct stack_frame *) sp;
> +	ip = READ_ONCE_NOCHECK(sf->gprs[8]);
> +
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	/* Decode any ftrace redirection */
> +	if (ip == (unsigned long) return_to_handler)
> +		ip = ftrace_graph_ret_addr(state->task, &state->graph_idx,
> +					   ip, NULL);
> +#endif

The return_to_handler and ifdef checks aren't needed.  Those are done
already by the call.

Also it seems a bit odd that the kretprobes check isn't done in this
function next to the ftrace check.

> +
> +	/* Update unwind state */
> +	state->sp = sp;
> +	state->ip = ip;
> +}
> +
> +bool unwind_next_frame_reliable(struct unwind_state *state)
> +{
> +	struct stack_info *info = &state->stack_info;
> +	struct stack_frame *sf;
> +	struct pt_regs *regs;
> +	unsigned long sp, ip;
> +
> +	sf = (struct stack_frame *) state->sp;
> +	sp = READ_ONCE_NOCHECK(sf->back_chain);
> +	/*
> +	 * Idle tasks are special. The final back-chain points to nodat_stack.
> +	 * See CALL_ON_STACK() in smp_start_secondary() callback used in
> +	 * __cpu_up(). We just accept it, go to else branch and look for
> +	 * pt_regs.
> +	 */
> +	if (likely(sp && !(is_idle_task(state->task) &&
> +			   outside_of_stack(state, sp)))) {
> +		/* Non-zero back-chain points to the previous frame */
> +		if (unlikely(outside_of_stack(state, sp)))
> +			goto out_err;
> +
> +		sf = (struct stack_frame *) sp;
> +		ip = READ_ONCE_NOCHECK(sf->gprs[8]);
> +	} else {
> +		/* No back-chain, look for a pt_regs structure */
> +		sp = state->sp + STACK_FRAME_OVERHEAD;
> +		regs = (struct pt_regs *) sp;
> +		if ((unsigned long)regs != info->end - sizeof(struct pt_regs))
> +			goto out_err;
> +		if (!(state->task->flags & (PF_KTHREAD | PF_IDLE)) &&
> +		     !user_mode(regs))
> +			goto out_err;
> +
> +		state->regs = regs;
> +		goto out_stop;
> +	}
> +
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	/* Decode any ftrace redirection */
> +	if (ip == (unsigned long) return_to_handler)
> +		ip = ftrace_graph_ret_addr(state->task, &state->graph_idx,
> +					   ip, (void *) sp);
> +#endif
> +
> +	/* Update unwind state */
> +	state->sp = sp;
> +	state->ip = ip;
> +	return true;
> +
> +out_err:
> +	state->error = true;
> +out_stop:
> +	state->stack_info.type = STACK_TYPE_UNKNOWN;
> +	return false;
> +}
> +#endif

For the _reliable() variants of the unwind interfaces, there's a lot of
code duplication with the non-reliable variants.  It looks like it would
be a lot cleaner (and easier to follow) if they were integrated.

Overall it's looking good though.

-- 
Josh
