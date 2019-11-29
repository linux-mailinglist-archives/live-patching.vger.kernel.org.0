Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E795E10D97A
	for <lists+live-patching@lfdr.de>; Fri, 29 Nov 2019 19:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfK2SQn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 29 Nov 2019 13:16:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:44808 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726985AbfK2SQm (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 29 Nov 2019 13:16:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C1375B321;
        Fri, 29 Nov 2019 18:16:39 +0000 (UTC)
Date:   Fri, 29 Nov 2019 19:16:38 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Vasily Gorbik <gor@linux.ibm.com>
cc:     heiko.carstens@de.ibm.com, borntraeger@de.ibm.com,
        jpoimboe@redhat.com, joe.lawrence@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        jikos@kernel.org, pmladek@suse.com, nstange@suse.de,
        live-patching@vger.kernel.org, lpechacek@suse.cz
Subject: Re: [PATCH v3 4/4] s390/livepatch: Implement reliable stack tracing
 for the consistency model
In-Reply-To: <cover.thread-a0061f.your-ad-here.call-01575012971-ext-9115@work.hours>
Message-ID: <alpine.LSU.2.21.1911291522140.23789@pobox.suse.cz>
References: <20191106095601.29986-5-mbenes@suse.cz> <cover.thread-a0061f.your-ad-here.call-01575012971-ext-9115@work.hours>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 29 Nov 2019, Vasily Gorbik wrote:

> On Wed, Nov 06, 2019 at 10:56:01AM +0100, Miroslav Benes wrote:
> > The livepatch consistency model requires reliable stack tracing
> > architecture support in order to work properly. In order to achieve
> > this, two main issues have to be solved. First, reliable and consistent
> > call chain backtracing has to be ensured. Second, the unwinder needs to
> > be able to detect stack corruptions and return errors.
> 
> I tried to address that in a patch series I pushed here:
> https://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git/log/?h=livepatch
> 
> It partially includes your changes from this patch which have been split
> in 2 patches:
> s390/unwind: add stack pointer alignment sanity checks
> s390/livepatch: Implement reliable stack tracing for the consistency model
> 
> The primary goal was to make our backchain unwinder reliable itself. And
> suitable for livepatching as is (we extra checks at the caller, see
> below). Besides unwinder changes few things have been improved to avoid
> special handling during unwinding.
> - all tasks now have pt_regs at the bottom of task stack.
> - final backchain always contains 0, no further references to no_dat stack.
> - successful unwinding means reaching pt_regs at the bottom of task stack,
> and unwinder guarantees that unwind_error() reflects that.
> - final pt_regs at the bottom of task stack is never included in unwinding
> results. It never was for user tasks. And kernel tasks cannot return to
> that state anyway (and in some cases pt_regs are empty).
> - unwinder starts unwinding from a reliable state (not "sp" passed as
> an argument).

Great. Thanks for doing that. It all looks good to me and the outcome is 
definitely better. I obviously still had some misconceptions about the 
code and it is much clearer now.

> There is also s390 specific unwinder testing module.
>
> > Idle tasks are a bit special. Their final back chains point to no_dat
> > stacks. See for reference CALL_ON_STACK() in smp_start_secondary()
> > callback used in __cpu_up(). The unwinding is stopped there and it is
> > not considered to be a stack corruption.
> I changed that with commit:
> s390: avoid misusing CALL_ON_STACK for task stack setup
> Now idle tasks are not special, final back chain contains 0.
> 
> > ---
> >  arch/s390/Kconfig             |  1 +
> >  arch/s390/kernel/dumpstack.c  | 11 +++++++
> >  arch/s390/kernel/stacktrace.c | 46 ++++++++++++++++++++++++++
> >  arch/s390/kernel/unwind_bc.c  | 61 +++++++++++++++++++++++++++--------
> >  4 files changed, 106 insertions(+), 13 deletions(-)
> > 
> > --- a/arch/s390/kernel/dumpstack.c
> > +++ b/arch/s390/kernel/dumpstack.c
> > @@ -94,12 +94,23 @@ int get_stack_info(unsigned long sp, struct task_struct *task,
> >  	if (!sp)
> >  		goto unknown;
> >  
> > +	/* Sanity check: ABI requires SP to be aligned 8 bytes. */
> > +	if (sp & 0x7)
> > +		goto unknown;
> > +
> This has been split in a separate commit:
> s390/unwind: add stack pointer alignment sanity checks
> 
> > +	/*
> > +	 * The reliable unwinding should not start on nodat_stack, async_stack
> > +	 * or restart_stack. The task is either current or must be inactive.
> > +	 */
> > +	if (unwind_reliable)
> > +		goto unknown;
> I moved this check in arch_stack_walk_reliable itself. See below.
> 
> >  static bool unwind_use_regs(struct unwind_state *state)
> > @@ -85,10 +94,13 @@ static bool unwind_use_frame(struct unwind_state *state, unsigned long sp,
> >  	struct stack_frame *sf;
> >  	unsigned long ip;
> >  
> > -	if (unlikely(outside_of_stack(state, sp))) {
> > -		if (!update_stack_info(state, sp))
> > -			goto out_err;
> > -	}
> > +	/*
> > +	 * No need to update stack info when unwind_reliable is true. We should
> > +	 * be on a task stack and everything else is an error.
> > +	 */
> > +	if (unlikely(outside_of_stack(state, sp)) &&
> > +	    (unwind_reliable || !update_stack_info(state, sp)))
> > +		goto out_err;
> I moved this check in arch_stack_walk_reliable itself. See below.
> 
> > +	/* Unwind reliable */
> > +	if ((unsigned long)regs != info->end - sizeof(struct pt_regs))
> > +		goto out_err;
> I moved this check in arch_stack_walk_reliable itself. See below.
> 
> 
> > @@ -136,8 +162,17 @@ bool unwind_next_frame(struct unwind_state *state, bool unwind_reliable)
> >  	sf = (struct stack_frame *) state->sp;
> >  	sp = READ_ONCE_NOCHECK(sf->back_chain);
> >  
> > -	/* Non-zero back-chain points to the previous frame */
> > -	if (likely(sp))
> > +	/*
> > +	 * Non-zero back-chain points to the previous frame
> > +	 *
> > +	 * unwind_reliable case: Idle tasks are special. The final
> > +	 * back-chain points to nodat_stack.  See CALL_ON_STACK() in
> > +	 * smp_start_secondary() callback used in __cpu_up(). We just
> > +	 * accept it and look for pt_regs.
> > +	 */
> > +	if (likely(sp) &&
> > +	    (!unwind_reliable || !(is_idle_task(state->task) &&
> > +				   outside_of_stack(state, sp))))
> >  		return unwind_use_frame(state, sp, unwind_reliable);
> This is not needed anymore.
> 
> In the end this all boils down to arch_stack_walk_reliable
> implementation. I made the following changes compaired to your version:
> ---
> - use plain unwind_for_each_frame
> - "state.stack_info.type != STACK_TYPE_TASK" guarantees that we are
>   not leaving task stack.
> - "if (state.regs)" guarantees that we have not met an program interrupt
>   pt_regs (page faults) or preempted. Corresponds to yours:
> > +	if ((unsigned long)regs != info->end - sizeof(struct pt_regs))
> > +		goto out_err;

Agreed. All this should be equivalent to the changes I made.

> - I don't see a point in storing "kernel_thread_starter", am I missing
>   something?

No, you don't. It was just for the sake of completeness and it is not 
worth it.

[...]
 
> I'd appreciate if you could give those changes a spin. And check if
> something is missing or broken. Or share your livepatching testing
> procedure. If everything goes well, I might include these changes in
> second pull request for this 5.5 merge window.
> 
> I did successfully run ./testing/selftests/livepatch/test-livepatch.sh

'make run_tests' in tools/testing/selftests/livepatch/ would call all the 
tests in the directory. Especially test-callbacks.sh which stresses the 
livepatching even more.
 
> https://github.com/lpechacek/qa_test_klp seems outdated. I was able to
> fix and run some tests of it but haven't had time to figure out all of
> them. Is there a version that would run on top of current Linus tree?

Ah, sorry. I should have mentioned that. The code became outdated with 
recent upstream changes. Libor is working on the updates (CCed).

Anyway, I ran it here and it all works fine.

Tested-by: Miroslav Benes <mbenes@suse.cz>

Thanks a lot
Miroslav
