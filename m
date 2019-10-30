Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 093CCE99BA
	for <lists+live-patching@lfdr.de>; Wed, 30 Oct 2019 11:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfJ3KME (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 30 Oct 2019 06:12:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:46954 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726046AbfJ3KME (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 30 Oct 2019 06:12:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4E146B46F;
        Wed, 30 Oct 2019 10:12:01 +0000 (UTC)
Date:   Wed, 30 Oct 2019 11:12:00 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>
cc:     gor@linux.ibm.com, borntraeger@de.ibm.com, jpoimboe@redhat.com,
        joe.lawrence@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, jikos@kernel.org, pmladek@suse.com,
        nstange@suse.de, live-patching@vger.kernel.org
Subject: Re: [PATCH v2 0/3] s390/livepatch: Implement reliable stack tracing
 for the consistency model
In-Reply-To: <20191029163450.GI5646@osiris>
Message-ID: <alpine.LSU.2.21.1910301105550.18400@pobox.suse.cz>
References: <20191029143904.24051-1-mbenes@suse.cz> <20191029163450.GI5646@osiris>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 29 Oct 2019, Heiko Carstens wrote:

> On Tue, Oct 29, 2019 at 03:39:01PM +0100, Miroslav Benes wrote:
> > - I tried to use the existing infrastructure as much as possible with
> >   one exception. I kept unwind_next_frame_reliable() next to the
> >   ordinary unwind_next_frame(). I did not come up with a nice solution
> >   how to integrate it. The reliable unwinding is executed on a task
> >   stack only, which leads to a nice simplification. My integration
> >   attempts only obfuscated the existing unwind_next_frame() which is
> >   already not easy to read. Ideas are definitely welcome.
> 
> Ah, now I see. So patch 2 seems to be leftover(?). Could you just send
> how the result would look like?
> 
> I'd really like to have only one function, since some of the sanity
> checks you added also make sense for what we already have - so code
> would diverge from the beginning.

Ok, that is understandable. I tried a bit harder and the outcome does not 
look as bad as my previous attempts (read, I gave up too early).

I deliberately split unwind_reliable/!unwind_reliable case in "No 
back-chain, look for a pt_regs structure" branch, because the purpose is 
different there. In !unwind_reliable case we can continue on a different 
stack (if I understood the code correctly when I analyzed it in the past. 
I haven't found a good documentation unfortunately :(). While in 
unwind_realiable case we just check if there are pt_regs in the right 
place on a task stack and stop. If there are not, error out.

It applies on top of the patch set. Only compile tested though. If it 
looks ok-ish to you, I'll work on it.

Thanks
Miroslav

---
diff --git a/arch/s390/include/asm/unwind.h b/arch/s390/include/asm/unwind.h
index 87d1850d195a..282c158a3c2a 100644
--- a/arch/s390/include/asm/unwind.h
+++ b/arch/s390/include/asm/unwind.h
@@ -43,7 +43,7 @@ struct unwind_state {
 void __unwind_start(struct unwind_state *state, struct task_struct *task,
 		    struct pt_regs *regs, unsigned long first_frame,
 		    bool unwind_reliable);
-bool unwind_next_frame(struct unwind_state *state);
+bool unwind_next_frame(struct unwind_state *state, bool unwind_reliable);
 bool unwind_next_frame_reliable(struct unwind_state *state);
 unsigned long unwind_get_return_address(struct unwind_state *state);
 
@@ -75,7 +75,7 @@ static inline struct pt_regs *unwind_get_entry_regs(struct unwind_state *state)
 #define unwind_for_each_frame(state, task, regs, first_frame, unwind_reliable)	\
 	for (unwind_start(state, task, regs, first_frame, unwind_reliable);	\
 	     !unwind_done(state);						\
-	     unwind_next_frame(state))
+	     unwind_next_frame(state, unwind_reliable))
 
 static inline void unwind_init(void) {}
 static inline void unwind_module_init(struct module *mod, void *orc_ip,
diff --git a/arch/s390/kernel/stacktrace.c b/arch/s390/kernel/stacktrace.c
index cff9ba0715e6..c5e3a37763f7 100644
--- a/arch/s390/kernel/stacktrace.c
+++ b/arch/s390/kernel/stacktrace.c
@@ -38,7 +38,7 @@ int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
 
 	for (unwind_start(&state, task, NULL, 0, true);
 	     !unwind_done(&state) && !unwind_error(&state);
-	     unwind_next_frame_reliable(&state)) {
+	     unwind_next_frame(&state, true)) {
 
 		addr = unwind_get_return_address(&state);
 		if (!addr)
diff --git a/arch/s390/kernel/unwind_bc.c b/arch/s390/kernel/unwind_bc.c
index 8d3a1d137ad0..2a7c88b58089 100644
--- a/arch/s390/kernel/unwind_bc.c
+++ b/arch/s390/kernel/unwind_bc.c
@@ -36,7 +36,7 @@ static bool update_stack_info(struct unwind_state *state, unsigned long sp)
 	return true;
 }
 
-bool unwind_next_frame(struct unwind_state *state)
+bool unwind_next_frame(struct unwind_state *state, bool unwind_reliable)
 {
 	struct stack_info *info = &state->stack_info;
 	struct stack_frame *sf;
@@ -58,28 +58,59 @@ bool unwind_next_frame(struct unwind_state *state)
 	} else {
 		sf = (struct stack_frame *) state->sp;
 		sp = READ_ONCE_NOCHECK(sf->back_chain);
-		if (likely(sp)) {
-			/* Non-zero back-chain points to the previous frame */
-			if (unlikely(outside_of_stack(state, sp))) {
-				if (!update_stack_info(state, sp))
-					goto out_err;
-			}
+		/*
+		 * unwind_reliable case: Idle tasks are special. The final
+		 * back-chain points to nodat_stack.  See CALL_ON_STACK() in
+		 * smp_start_secondary() callback used in __cpu_up(). We just
+		 * accept it, go to else branch and look for pt_regs.
+		 */
+		if (likely(sp) &&
+		    (!unwind_reliable || !(is_idle_task(state->task) &&
+					   outside_of_stack(state, sp)))) {
+
+			/*
+			 * Non-zero back-chain points to the previous frame. No
+			 * need to update stack info when unwind_reliable is
+			 * true. We should be on a task stack and everything
+			 * else is an error.
+			 */
+			if (unlikely(outside_of_stack(state, sp)) &&
+			    ((!unwind_reliable && !update_stack_info(state, sp)) ||
+			     unwind_reliable))
+				goto out_err;
+
 			sf = (struct stack_frame *) sp;
 			ip = READ_ONCE_NOCHECK(sf->gprs[8]);
 			reliable = true;
 		} else {
 			/* No back-chain, look for a pt_regs structure */
 			sp = state->sp + STACK_FRAME_OVERHEAD;
-			if (!on_stack(info, sp, sizeof(struct pt_regs)))
-				goto out_stop;
 			regs = (struct pt_regs *) sp;
-			if (READ_ONCE_NOCHECK(regs->psw.mask) & PSW_MASK_PSTATE)
+
+			if (!unwind_reliable) {
+				if (!on_stack(info, sp, sizeof(struct pt_regs)))
+					goto out_stop;
+				if (READ_ONCE_NOCHECK(regs->psw.mask) & PSW_MASK_PSTATE)
+					goto out_stop;
+				ip = READ_ONCE_NOCHECK(regs->psw.addr);
+				reliable = true;
+			} else {
+				if ((unsigned long)regs != info->end - sizeof(struct pt_regs))
+					goto out_err;
+				if (!(state->task->flags & (PF_KTHREAD | PF_IDLE)) &&
+				      !user_mode(regs))
+					goto out_err;
+
+				state->regs = regs;
 				goto out_stop;
-			ip = READ_ONCE_NOCHECK(regs->psw.addr);
-			reliable = true;
+			}
 		}
 	}
 
+	/* Sanity check: ABI requires SP to be aligned 8 bytes. */
+	if (sp & 0x7)
+		goto out_err;
+
 	ip = ftrace_graph_ret_addr(state->task, &state->graph_idx,
 				   ip, (void *) sp);
 
@@ -98,62 +129,6 @@ bool unwind_next_frame(struct unwind_state *state)
 }
 EXPORT_SYMBOL_GPL(unwind_next_frame);
 
-bool unwind_next_frame_reliable(struct unwind_state *state)
-{
-	struct stack_info *info = &state->stack_info;
-	struct stack_frame *sf;
-	struct pt_regs *regs;
-	unsigned long sp, ip;
-
-	sf = (struct stack_frame *) state->sp;
-	sp = READ_ONCE_NOCHECK(sf->back_chain);
-	/*
-	 * Idle tasks are special. The final back-chain points to nodat_stack.
-	 * See CALL_ON_STACK() in smp_start_secondary() callback used in
-	 * __cpu_up(). We just accept it, go to else branch and look for
-	 * pt_regs.
-	 */
-	if (likely(sp && !(is_idle_task(state->task) &&
-			   outside_of_stack(state, sp)))) {
-		/* Non-zero back-chain points to the previous frame */
-		if (unlikely(outside_of_stack(state, sp)))
-			goto out_err;
-
-		sf = (struct stack_frame *) sp;
-		ip = READ_ONCE_NOCHECK(sf->gprs[8]);
-	} else {
-		/* No back-chain, look for a pt_regs structure */
-		sp = state->sp + STACK_FRAME_OVERHEAD;
-		regs = (struct pt_regs *) sp;
-		if ((unsigned long)regs != info->end - sizeof(struct pt_regs))
-			goto out_err;
-		if (!(state->task->flags & (PF_KTHREAD | PF_IDLE)) &&
-		      !user_mode(regs))
-			goto out_err;
-
-		state->regs = regs;
-		goto out_stop;
-	}
-
-	/* Sanity check: ABI requires SP to be aligned 8 bytes. */
-	if (sp & 0x7)
-		goto out_err;
-
-	ip = ftrace_graph_ret_addr(state->task, &state->graph_idx,
-				   ip, (void *) sp);
-
-	/* Update unwind state */
-	state->sp = sp;
-	state->ip = ip;
-	return true;
-
-out_err:
-	state->error = true;
-out_stop:
-	state->stack_info.type = STACK_TYPE_UNKNOWN;
-	return false;
-}
-
 void __unwind_start(struct unwind_state *state, struct task_struct *task,
 		    struct pt_regs *regs, unsigned long sp,
 		    bool unwind_reliable)
