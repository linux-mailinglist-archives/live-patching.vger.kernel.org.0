Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F7FF1304
	for <lists+live-patching@lfdr.de>; Wed,  6 Nov 2019 10:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731483AbfKFJ4I (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 6 Nov 2019 04:56:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:50014 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730038AbfKFJ4H (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 6 Nov 2019 04:56:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C462BB219;
        Wed,  6 Nov 2019 09:56:04 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, jpoimboe@redhat.com,
        joe.lawrence@redhat.com
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        jikos@kernel.org, pmladek@suse.com, nstange@suse.de,
        live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v3 4/4] s390/livepatch: Implement reliable stack tracing for the consistency model
Date:   Wed,  6 Nov 2019 10:56:01 +0100
Message-Id: <20191106095601.29986-5-mbenes@suse.cz>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191106095601.29986-1-mbenes@suse.cz>
References: <20191106095601.29986-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The livepatch consistency model requires reliable stack tracing
architecture support in order to work properly. In order to achieve
this, two main issues have to be solved. First, reliable and consistent
call chain backtracing has to be ensured. Second, the unwinder needs to
be able to detect stack corruptions and return errors.

The "zSeries ELF Application Binary Interface Supplement" says:

  "The stack pointer points to the first word of the lowest allocated
  stack frame. If the "back chain" is implemented this word will point to
  the previously allocated stack frame (towards higher addresses), except
  for the first stack frame, which shall have a back chain of zero (NULL).
  The stack shall grow downwards, in other words towards lower addresses."

"back chain" is optional. GCC option -mbackchain enables it. Quoting
Martin Schwidefsky [1]:

  "The compiler is called with the -mbackchain option, all normal C
  function will store the backchain in the function prologue. All
  functions written in assembler code should do the same, if you find one
  that does not we should fix that. The end result is that a task that
  *voluntarily* called schedule() should have a proper backchain at all
  times.

  Dependent on the use case this may or may not be enough. Asynchronous
  interrupts may stop the CPU at the beginning of a function, if kernel
  preemption is enabled we can end up with a broken backchain.  The
  production kernels for IBM Z are all compiled *without* kernel
  preemption. So yes, we might get away without the objtool support.

  On a side-note, we do have a line item to implement the ORC unwinder for
  the kernel, that includes the objtool support. Once we have that we can
  drop the -mbackchain option for the kernel build. That gives us a nice
  little performance benefit. I hope that the change from backchain to the
  ORC unwinder will not be too hard to implement in the livepatch tools."

Since -mbackchain is enabled by default when the kernel is compiled, the
call chain backtracing should be currently ensured and objtool should
not be necessary for livepatch purposes.

Regarding the second issue, stack corruptions and non-reliable states
have to be recognized by the unwinder. Mainly it means to detect
preemption or page faults, the end of the task stack must be reached,
return addresses must be valid text addresses and hacks like function
graph tracing and kretprobes must be properly detected.

Unwinding a running task's stack is not a problem, because there is a
livepatch requirement that every checked task is blocked, except for the
current task. Due to that, the implementation can be much simpler
compared to the existing non-reliable infrastructure. We can consider a
task's kernel/thread stack only and skip the other stacks.

Idle tasks are a bit special. Their final back chains point to no_dat
stacks. See for reference CALL_ON_STACK() in smp_start_secondary()
callback used in __cpu_up(). The unwinding is stopped there and it is
not considered to be a stack corruption.

[1] 20180912121106.31ffa97c@mschwideX1 [not archived on lore.kernel.org]

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
 arch/s390/Kconfig             |  1 +
 arch/s390/kernel/dumpstack.c  | 11 +++++++
 arch/s390/kernel/stacktrace.c | 46 ++++++++++++++++++++++++++
 arch/s390/kernel/unwind_bc.c  | 61 +++++++++++++++++++++++++++--------
 4 files changed, 106 insertions(+), 13 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 43a81d0ad507..9cfec1000abd 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -170,6 +170,7 @@ config S390
 	select HAVE_PERF_EVENTS
 	select HAVE_RCU_TABLE_FREE
 	select HAVE_REGS_AND_STACK_ACCESS_API
+	select HAVE_RELIABLE_STACKTRACE
 	select HAVE_RSEQ
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_VIRT_CPU_ACCOUNTING
diff --git a/arch/s390/kernel/dumpstack.c b/arch/s390/kernel/dumpstack.c
index 1ee19e6336cd..0081e75b957c 100644
--- a/arch/s390/kernel/dumpstack.c
+++ b/arch/s390/kernel/dumpstack.c
@@ -94,12 +94,23 @@ int get_stack_info(unsigned long sp, struct task_struct *task,
 	if (!sp)
 		goto unknown;
 
+	/* Sanity check: ABI requires SP to be aligned 8 bytes. */
+	if (sp & 0x7)
+		goto unknown;
+
 	task = task ? : current;
 
 	/* Check per-task stack */
 	if (in_task_stack(sp, task, info))
 		goto recursion_check;
 
+	/*
+	 * The reliable unwinding should not start on nodat_stack, async_stack
+	 * or restart_stack. The task is either current or must be inactive.
+	 */
+	if (unwind_reliable)
+		goto unknown;
+
 	if (task != current)
 		goto unknown;
 
diff --git a/arch/s390/kernel/stacktrace.c b/arch/s390/kernel/stacktrace.c
index 751c136172f7..c5e3a37763f7 100644
--- a/arch/s390/kernel/stacktrace.c
+++ b/arch/s390/kernel/stacktrace.c
@@ -9,6 +9,7 @@
 #include <linux/stacktrace.h>
 #include <asm/stacktrace.h>
 #include <asm/unwind.h>
+#include <asm/kprobes.h>
 
 void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
 		     struct task_struct *task, struct pt_regs *regs)
@@ -22,3 +23,48 @@ void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
 			break;
 	}
 }
+
+/*
+ * This function returns an error if it detects any unreliable features of the
+ * stack.  Otherwise it guarantees that the stack trace is reliable.
+ *
+ * If the task is not 'current', the caller *must* ensure the task is inactive.
+ */
+int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
+			     void *cookie, struct task_struct *task)
+{
+	struct unwind_state state;
+	unsigned long addr;
+
+	for (unwind_start(&state, task, NULL, 0, true);
+	     !unwind_done(&state) && !unwind_error(&state);
+	     unwind_next_frame(&state, true)) {
+
+		addr = unwind_get_return_address(&state);
+		if (!addr)
+			return -EINVAL;
+
+#ifdef CONFIG_KPROBES
+		/*
+		 * Mark stacktraces with kretprobed functions on them
+		 * as unreliable.
+		 */
+		if (state.ip == (unsigned long)kretprobe_trampoline)
+			return -EINVAL;
+#endif
+
+		if (!consume_entry(cookie, addr, false))
+			return -EINVAL;
+	}
+
+	/* Check for stack corruption */
+	if (unwind_error(&state))
+		return -EINVAL;
+
+	/* Store kernel_thread_starter, null for swapper/0 */
+	if ((task->flags & (PF_KTHREAD | PF_IDLE)) &&
+	    !consume_entry(cookie, state.regs->psw.addr, false))
+		return -EINVAL;
+
+	return 0;
+}
diff --git a/arch/s390/kernel/unwind_bc.c b/arch/s390/kernel/unwind_bc.c
index 092626f4e7c6..9b6bc7539a9e 100644
--- a/arch/s390/kernel/unwind_bc.c
+++ b/arch/s390/kernel/unwind_bc.c
@@ -40,6 +40,10 @@ static bool unwind_update_state(struct unwind_state *state,
 				unsigned long sp, unsigned long ip,
 				struct pt_regs *regs, bool reliable)
 {
+	/* Sanity check: ABI requires SP to be aligned 8 bytes. */
+	if (sp & 0x7)
+		goto out_err;
+
 	ip = ftrace_graph_ret_addr(state->task, &state->graph_idx,
 				   ip, (void *) sp);
 
@@ -49,6 +53,11 @@ static bool unwind_update_state(struct unwind_state *state,
 	state->regs = regs;
 	state->reliable = reliable;
 	return true;
+
+out_err:
+	state->error = true;
+	state->stack_info.type = STACK_TYPE_UNKNOWN;
+	return false;
 }
 
 static bool unwind_use_regs(struct unwind_state *state)
@@ -85,10 +94,13 @@ static bool unwind_use_frame(struct unwind_state *state, unsigned long sp,
 	struct stack_frame *sf;
 	unsigned long ip;
 
-	if (unlikely(outside_of_stack(state, sp))) {
-		if (!update_stack_info(state, sp))
-			goto out_err;
-	}
+	/*
+	 * No need to update stack info when unwind_reliable is true. We should
+	 * be on a task stack and everything else is an error.
+	 */
+	if (unlikely(outside_of_stack(state, sp)) &&
+	    (unwind_reliable || !update_stack_info(state, sp)))
+		goto out_err;
 
 	sf = (struct stack_frame *) sp;
 	ip = READ_ONCE_NOCHECK(sf->gprs[8]);
@@ -109,17 +121,31 @@ static bool unwind_look_for_regs(struct unwind_state *state,
 	unsigned long sp, ip;
 
 	sp = state->sp + STACK_FRAME_OVERHEAD;
-	if (!on_stack(info, sp, sizeof(struct pt_regs)))
-		goto out_stop;
-
 	regs = (struct pt_regs *) sp;
-	if (READ_ONCE_NOCHECK(regs->psw.mask) & PSW_MASK_PSTATE)
-		goto out_stop;
 
-	ip = READ_ONCE_NOCHECK(regs->psw.addr);
+	if (!unwind_reliable) {
+		if (!on_stack(info, sp, sizeof(struct pt_regs)))
+			goto out_stop;
 
-	return unwind_update_state(state, sp, ip, regs, true);
+		if (READ_ONCE_NOCHECK(regs->psw.mask) & PSW_MASK_PSTATE)
+			goto out_stop;
 
+		ip = READ_ONCE_NOCHECK(regs->psw.addr);
+		return unwind_update_state(state, sp, ip, regs, true);
+	}
+
+	/* Unwind reliable */
+	if ((unsigned long)regs != info->end - sizeof(struct pt_regs))
+		goto out_err;
+
+	if (!(state->task->flags & (PF_KTHREAD | PF_IDLE)) && !user_mode(regs))
+		goto out_err;
+
+	state->regs = regs;
+	goto out_stop;
+
+out_err:
+	state->error = true;
 out_stop:
 	state->stack_info.type = STACK_TYPE_UNKNOWN;
 	return false;
@@ -136,8 +162,17 @@ bool unwind_next_frame(struct unwind_state *state, bool unwind_reliable)
 	sf = (struct stack_frame *) state->sp;
 	sp = READ_ONCE_NOCHECK(sf->back_chain);
 
-	/* Non-zero back-chain points to the previous frame */
-	if (likely(sp))
+	/*
+	 * Non-zero back-chain points to the previous frame
+	 *
+	 * unwind_reliable case: Idle tasks are special. The final
+	 * back-chain points to nodat_stack.  See CALL_ON_STACK() in
+	 * smp_start_secondary() callback used in __cpu_up(). We just
+	 * accept it and look for pt_regs.
+	 */
+	if (likely(sp) &&
+	    (!unwind_reliable || !(is_idle_task(state->task) &&
+				   outside_of_stack(state, sp))))
 		return unwind_use_frame(state, sp, unwind_reliable);
 
 	/* No back-chain, look for a pt_regs structure */
-- 
2.23.0

