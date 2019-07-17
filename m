Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEDDD6BAE5
	for <lists+live-patching@lfdr.de>; Wed, 17 Jul 2019 13:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbfGQLBi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 17 Jul 2019 07:01:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:59412 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725799AbfGQLBi (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 17 Jul 2019 07:01:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B3594AB87;
        Wed, 17 Jul 2019 11:01:35 +0000 (UTC)
Date:   Wed, 17 Jul 2019 13:01:27 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Joe Lawrence <joe.lawrence@redhat.com>
cc:     heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpoimboe@redhat.com,
        jikos@kernel.org, pmladek@suse.com, nstange@suse.de,
        live-patching@vger.kernel.org
Subject: Re: [PATCH] s390/livepatch: Implement reliable stack tracing for
 the consistency model
In-Reply-To: <20190716184549.GA26084@redhat.com>
Message-ID: <alpine.LSU.2.21.1907171223540.4492@pobox.suse.cz>
References: <20190710105918.22487-1-mbenes@suse.cz> <20190716184549.GA26084@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 16 Jul 2019, Joe Lawrence wrote:

> On Wed, Jul 10, 2019 at 12:59:18PM +0200, Miroslav Benes wrote:
> > The livepatch consistency model requires reliable stack tracing
> > architecture support in order to work properly. In order to achieve
> > this, two main issues have to be solved. First, reliable and consistent
> > call chain backtracing has to be ensured. Second, the unwinder needs to
> > be able to detect stack corruptions and return errors.
> > 
> > The "zSeries ELF Application Binary Interface Supplement" says:
> > 
> >   "The stack pointer points to the first word of the lowest allocated
> >   stack frame. If the "back chain" is implemented this word will point to
> >   the previously allocated stack frame (towards higher addresses), except
> >   for the first stack frame, which shall have a back chain of zero (NULL).
> >   The stack shall grow downwards, in other words towards lower addresses."
> > 
> > "back chain" is optional. GCC option -mbackchain enables it. Quoting
> > Martin Schwidefsky [1]:
> > 
> >   "The compiler is called with the -mbackchain option, all normal C
> >   function will store the backchain in the function prologue. All
> >   functions written in assembler code should do the same, if you find one
> >   that does not we should fix that. The end result is that a task that
> >   *voluntarily* called schedule() should have a proper backchain at all
> >   times.
> > 
> >   Dependent on the use case this may or may not be enough. Asynchronous
> >   interrupts may stop the CPU at the beginning of a function, if kernel
> >   preemption is enabled we can end up with a broken backchain.  The
> >   production kernels for IBM Z are all compiled *without* kernel
> >   preemption. So yes, we might get away without the objtool support.
> > 
> >   On a side-note, we do have a line item to implement the ORC unwinder for
> >   the kernel, that includes the objtool support. Once we have that we can
> >   drop the -mbackchain option for the kernel build. That gives us a nice
> >   little performance benefit. I hope that the change from backchain to the
> >   ORC unwinder will not be too hard to implement in the livepatch tools."
> > 
> > Thus, the call chain backtracing should be currently ensured and objtool
> > should not be necessary for livepatch purposes.
> 
> Hi Miroslav,
> 
> Should there be a CONFIG? dependency on -mbackchain and/or kernel
> preemption, or does the following ensure that we don't need a explicit
> build time checks?

I don't think we have to do anything explicit. -mbackchain is enabled by 
default (arch/s390/Makefile) and the following should ensure the rest. 
I'll make it clearer in v2.
 
> > Regarding the second issue, stack corruptions and non-reliable states
> > have to be recognized by the unwinder. Mainly it means to detect
> > preemption or page faults, the end of the task stack must be reached,
> > return addresses must be valid text addresses and hacks like function
> > graph tracing and kretprobes must be properly detected.
> > 
> > Unwinding a running task's stack is not a problem, because there is a
> > livepatch requirement that every checked task is blocked, except for the
> > current task. Due to that, the implementation can be much simpler
> > compared to the existing non-reliable infrastructure. We can consider a
> > task's kernel/thread stack only and skip the other stacks.
> > 
> > Idle tasks are a bit special. Their final back chains point to no_dat
> > stacks. See for reference CALL_ON_STACK() in smp_start_secondary()
> > callback used in __cpu_up(). The unwinding is stopped there and it is
> > not considered to be a stack corruption.
> > 
> > Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> > ---
> > - based on Linus' master
> > - passes livepatch kselftests
> > - passes tests from https://github.com/lpechacek/qa_test_klp, which
> >   stress the consistency model and the unwinder a bit more
> > 
> >  arch/s390/Kconfig                  |  1 +
> >  arch/s390/include/asm/stacktrace.h |  5 ++
> >  arch/s390/include/asm/unwind.h     | 19 ++++++
> >  arch/s390/kernel/dumpstack.c       | 28 +++++++++
> >  arch/s390/kernel/stacktrace.c      | 78 +++++++++++++++++++++++++
> >  arch/s390/kernel/unwind_bc.c       | 93 ++++++++++++++++++++++++++++++
> >  6 files changed, 224 insertions(+)
> > 
> > diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> > index fdb4246265a5..ea73e555063d 100644
> > --- a/arch/s390/Kconfig
> > +++ b/arch/s390/Kconfig
> > @@ -170,6 +170,7 @@ config S390
> >  	select HAVE_PERF_EVENTS
> >  	select HAVE_RCU_TABLE_FREE
> >  	select HAVE_REGS_AND_STACK_ACCESS_API
> > +	select HAVE_RELIABLE_STACKTRACE
> >  	select HAVE_RSEQ
> >  	select HAVE_SYSCALL_TRACEPOINTS
> >  	select HAVE_VIRT_CPU_ACCOUNTING
> > diff --git a/arch/s390/include/asm/stacktrace.h b/arch/s390/include/asm/stacktrace.h
> > index 0ae4bbf7779c..2b5c913c408f 100644
> > --- a/arch/s390/include/asm/stacktrace.h
> > +++ b/arch/s390/include/asm/stacktrace.h
> > @@ -23,6 +23,11 @@ const char *stack_type_name(enum stack_type type);
> >  int get_stack_info(unsigned long sp, struct task_struct *task,
> >  		   struct stack_info *info, unsigned long *visit_mask);
> >  
> > +#ifdef CONFIG_HAVE_RELIABLE_STACKTRACE
> > +int get_stack_info_reliable(unsigned long sp, struct task_struct *task,
> > +			    struct stack_info *info);
> > +#endif
> > +
> >  static inline bool on_stack(struct stack_info *info,
> >  			    unsigned long addr, size_t len)
> >  {
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
> >  static inline bool unwind_done(struct unwind_state *state)
> >  {
> >  	return state->stack_info.type == STACK_TYPE_UNKNOWN;
> > diff --git a/arch/s390/kernel/dumpstack.c b/arch/s390/kernel/dumpstack.c
> > index ac06c3949ab3..b21ef2a766ff 100644
> > --- a/arch/s390/kernel/dumpstack.c
> > +++ b/arch/s390/kernel/dumpstack.c
> > @@ -127,6 +127,34 @@ int get_stack_info(unsigned long sp, struct task_struct *task,
> >  	return -EINVAL;
> >  }
> >  
> > +#ifdef CONFIG_HAVE_RELIABLE_STACKTRACE
> > +int get_stack_info_reliable(unsigned long sp, struct task_struct *task,
> > +			    struct stack_info *info)
> > +{
> > +	if (!sp)
> > +		goto error;
> > +
> > +	/* Sanity check: ABI requires SP to be aligned 8 bytes. */
> > +	if (sp & 0x7)
> > +		goto error;
> > +
> 
> Does SP alignment only need to be checked for the initial frame, or
> should it be verified everytime it's moved in
> unwind_next_frame_reliable()?

Good spotting. It should have been verified everytime. It got lost during 
rebasing onto the new unwinding framework.
 
> > +	if (!task)
> > +		goto error;
> > +
> > +	/*
> > +	 * The unwinding should not start on nodat_stack, async_stack or
> > +	 * restart_stack. The task is either current or must be inactive.
> > +	 */
> > +	if (!in_task_stack(sp, task, info))
> > +		goto error;
> > +
> > +	return 0;
> > +error:
> > +	info->type = STACK_TYPE_UNKNOWN;
> > +	return -EINVAL;
> > +}
> > +#endif
> > +
> >  void show_stack(struct task_struct *task, unsigned long *stack)
> >  {
> >  	struct unwind_state state;
> > diff --git a/arch/s390/kernel/stacktrace.c b/arch/s390/kernel/stacktrace.c
> > index f6a620f854e1..7d774a325163 100644
> > --- a/arch/s390/kernel/stacktrace.c
> > +++ b/arch/s390/kernel/stacktrace.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/export.h>
> >  #include <asm/stacktrace.h>
> >  #include <asm/unwind.h>
> > +#include <asm/kprobes.h>
> >  
> >  void save_stack_trace(struct stack_trace *trace)
> >  {
> > @@ -60,3 +61,80 @@ void save_stack_trace_regs(struct pt_regs *regs, struct stack_trace *trace)
> >  	}
> >  }
> >  EXPORT_SYMBOL_GPL(save_stack_trace_regs);
> > +
> > +#ifdef CONFIG_HAVE_RELIABLE_STACKTRACE
> > +/*
> > + * This function returns an error if it detects any unreliable features of the
> > + * stack.  Otherwise it guarantees that the stack trace is reliable.
> > + *
> > + * If the task is not 'current', the caller *must* ensure the task is inactive.
> > + */
> > +static __always_inline int
> > +__save_stack_trace_tsk_reliable(struct task_struct *tsk,
> > +				struct stack_trace *trace)
> > +{
> > +	struct unwind_state state;
> > +
> > +	for (unwind_start_reliable(&state, tsk);
> > +	     !unwind_done(&state) && !unwind_error(&state);
> > +	     unwind_next_frame_reliable(&state)) {
> > +
> > +		if (!__kernel_text_address(state.ip))
> > +			return -EINVAL;
> > +
> > +#ifdef CONFIG_KPROBES
> > +		/*
> > +		 * Mark stacktraces with kretprobed functions on them
> > +		 * as unreliable.
> > +		 */
> > +		if (state.ip == (unsigned long)kretprobe_trampoline)
> > +			return -EINVAL;
> > +#endif
> > +
> > +		if (trace->nr_entries >= trace->max_entries)
> > +			return -E2BIG;
> > +
> > +		if (!trace->skip)
> > +			trace->entries[trace->nr_entries++] = state.ip;
> > +		else
> > +			trace->skip--;
> > +	}
> > +
> > +	/* Check for stack corruption */
> > +	if (unwind_error(&state))
> > +		return -EINVAL;
> > +
> > +	/* Store kernel_thread_starter, null for swapper/0 */
> > +	if (tsk->flags & (PF_KTHREAD | PF_IDLE)) {
> > +		if (trace->nr_entries >= trace->max_entries)
> > +			return -E2BIG;
> > +
> > +		if (!trace->skip)
> > +			trace->entries[trace->nr_entries++] =
> > +				state.regs->psw.addr;
> > +		else
> > +			trace->skip--;
> 
> An idea for a follow up patch: stuff this into a function like
> int save_trace_entry(struct stack_trace *trace, unsigned long entry);
> which could one day make the trace->entries[] code generic across arches. 

Yes. I was thinking about it and then decided to postpone it a bit. Thomas 
introduced more generic infrastructure with ARCH_STACKWALK. See x86 
implementation. There is consume_entry() which is exactly what you are 
proposing. So I thought it should be a part of a bigger rework in the 
future.
 
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +int save_stack_trace_tsk_reliable(struct task_struct *tsk,
> > +				  struct stack_trace *trace)
> > +{
> > +	int ret;
> > +
> > +	/*
> > +	 * If the task doesn't have a stack (e.g., a zombie), the stack is
> > +	 * "reliably" empty.
> > +	 */
> > +	if (!try_get_task_stack(tsk))
> > +		return 0;
> > +
> > +	ret = __save_stack_trace_tsk_reliable(tsk, trace);
> > +
> > +	put_task_stack(tsk);
> > +
> > +	return ret;
> > +}
> > +#endif
> > diff --git a/arch/s390/kernel/unwind_bc.c b/arch/s390/kernel/unwind_bc.c
> > index 3ce8a0808059..ada3a8538961 100644
> > --- a/arch/s390/kernel/unwind_bc.c
> > +++ b/arch/s390/kernel/unwind_bc.c
> > @@ -153,3 +153,96 @@ void __unwind_start(struct unwind_state *state, struct task_struct *task,
> >  	state->reliable = reliable;
> >  }
> >  EXPORT_SYMBOL_GPL(__unwind_start);
> > +
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
>                                                ^^^^
> double checking: we ignore the retp here and not in the next-frame case?

Frankly, I copy-pasted this from non-reliable versions and checked that 
powerpc ignored it as well. I'll double check.

It also calls for another cleanup. #ifdef seems to be superfluous and 
checking ip for return_to_handler too (because it is done in 
ftrace_graph_ret_addr() itself).
 
> > +#endif
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
> 
> minor nit: maybe the CONFIG_FUNCTION_GRAPH_TRACER and "Update unwind
> state" logic could be combined into a function?  (Not a big deal either
> way.)

I think it is better to open code it here, but it is a matter of taste for 
sure.
 
> > +	return true;
> > +
> > +out_err:
> > +	state->error = true;
> > +out_stop:
> > +	state->stack_info.type = STACK_TYPE_UNKNOWN;
> > +	return false;
> > +}
> > +#endif
> > -- 
> > 2.22.0
> > 
> 
> I've tested the patch with positive results, however I didn't stress it
> very hard (basically only selftests).  The code logic seems
> straightforward and correct by inspection.
> 
> On a related note, do you think it would be feasible to extend (in
> another patchset) the reliable stack unwinding code a bit so that we
> could feed it pre-baked stacks ... then we could verify that the code
> was finding interesting scenarios.  That was a passing thought I had
> back when Nicolai and I were debugging the ppc64le exception frame
> marker bug, but didn't think it worth the time/effort at the time.

That is an interesting thought. It would help the testing a lot. I will 
make a note in my todo list.

> One more note:  Using READ_ONCE_NOCHECK is probably correct here, but
> s390 happens to define a READ_ONCE_TASK_STACK macro which calls
> READ_ONCE_NOCHECK when task != current.  According to the code comments,
> this "disables KASAN checking when reading a value from another task's
> stack".  Is there any scenario here where we would want to use the that
> wrapper macro?

s/READ_ONCE_TASK_STACK/READ_ONCE_NOCHECK/ was a last minute change. s390 
does not define it anymore. See 20955746320e ("s390/kasan: avoid false 
positives during stack unwind") and da1776733617 ("s390/unwind: cleanup 
unused READ_ONCE_TASK_STACK").

Thanks for the review and testing!

Miroslav
