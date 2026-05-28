Return-Path: <live-patching+bounces-2914-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iNd4LKz7F2oTYQgAu9opvQ
	(envelope-from <live-patching+bounces-2914-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 28 May 2026 10:24:12 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EBCF5EE80C
	for <lists+live-patching@lfdr.de>; Thu, 28 May 2026 10:24:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6C5753053BC7
	for <lists+live-patching@lfdr.de>; Thu, 28 May 2026 08:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5492737B41B;
	Thu, 28 May 2026 08:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="f7b3rlwj"
X-Original-To: live-patching@vger.kernel.org
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15C5378832;
	Thu, 28 May 2026 08:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779956616; cv=none; b=itSOf5qc9KH1H7BhMWoF1epMcgEFdAQA3BwrYgRo8UH0hNHkchdAgk2AfkF6iSNGb0LOnoe0h+Fr1NOcW86KC8HKNutNszM7IveDIsIO4GeE6y5mtoV4iAcI2JlQLQxvs/D5PUhEaX+OWXbIMx0M0vnS/vvsn4oRpVilmoI+GOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779956616; c=relaxed/simple;
	bh=rJTpGctB5TiBnQ6rpCNL39EXf9Dg1gX7PuW2RUXrJHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8ftw6Q0G/CuzHNCXps3AObXItMmIQWu9Q2HbAeLp5s727FR4rag7La0zfXi5Us5Pzhpr5iAwOILdgGm732gJu4xwW9HitU+E/SiVDGc2Y7T9yaWfdIfE45jIx1UK/Mwau5DPZniOKKXnCRXaiNbLfOSo2SKHP8U87B+vOIKedo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=f7b3rlwj; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779956605; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=taLhBQxJ5s+l+O/bxsWiY19+xL1yAFoWJ0rAvA51baU=;
	b=f7b3rlwjzNAcAk+9QObWqjFxFh2xWwCI19azZm/td8+fZSMehIxWi4SbBWDN0qB+9+zDIynccAqJabnhx9v2T+Se/BUrSq9K+UgqX1vZKJvL4vEu/1foyEjIkFPCr699eL6m1UK7jLa4KxAtxFJffq5qX72BCNDt+on5f0e+EMI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=wanghan@linux.alibaba.com;NM=1;PH=DS;RN=34;SR=0;TI=SMTPD_---0X3lxQPa_1779956602;
Received: from wanghan-Workstation..(mailfrom:wanghan@linux.alibaba.com fp:SMTPD_---0X3lxQPa_1779956602 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 28 May 2026 16:23:23 +0800
From: Wang Han <wanghan@linux.alibaba.com>
To: Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Pei <cp0613@linux.alibaba.com>,
	Andy Chiu <andybnac@gmail.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Deepak Gupta <debug@rivosinc.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	oliver.yang@linux.alibaba.com,
	xueshuai@linux.alibaba.com,
	zhuo.song@linux.alibaba.com,
	jkchen@linux.alibaba.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: [PATCH v2 6/8] riscv: stacktrace: switch to frame-pointer based unwinder
Date: Thu, 28 May 2026 16:23:08 +0800
Message-ID: <20260528082310.1994388-7-wanghan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260527123530.2593918-1-wanghan@linux.alibaba.com>
References: <20260527123530.2593918-1-wanghan@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	TAGGED_FROM(0.00)[bounces-2914-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[goodmis.org,ghiti.fr,kernel.org,arm.com,linux.alibaba.com,gmail.com,rivosinc.com,microchip.com,suse.cz,suse.com,redhat.com,infradead.org,lists.infradead.org,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[wanghan@linux.alibaba.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 3EBCF5EE80C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Replace the open-coded frame-pointer walker in arch_stack_walk() with a
robust kunwind state machine, modelled on arch/arm64/kernel/stacktrace.c
and retargeted to the RISC-V {fp, ra} frame record convention. The new
walker tracks stack bounds, consumes frame records monotonically,
understands the metadata pt_regs records added in the previous frame
record metadata patch, and recovers return addresses replaced by
function graph tracing and kretprobes.

This commit introduces arch_stack_walk_reliable() but does not yet
select HAVE_RELIABLE_STACKTRACE; that is done in a follow-up Kconfig
patch so this commit can be reviewed and bisected as a pure unwinder
replacement. Until that Kconfig change lands, livepatch is not yet
enabled and arch_stack_walk_reliable() has no in-tree caller.

Three related callers are updated to keep the same frame-record
assumptions everywhere:

  * Function graph tracing: the old RISC-V unwinder matched function
    graph return-stack entries by the saved return-address slot. That
    was consistent with the static mcount path, but not with the dynamic
    ftrace path where the parent slot is ftrace_regs::ra. Use the
    architectural frame pointer as the function graph return-address
    cookie, matching the kunwind walker.

  * Perf callchains: route kernel callchain collection through
    arch_stack_walk() so perf sees the same frame-pointer unwind
    behaviour as dump_stack() and the upcoming livepatch path.

  * dump_backtrace() / __get_wchan() / show_stack(): these now go
    through arch_stack_walk(); the explicit "Call Trace:" header is
    moved into dump_backtrace() to preserve the original output.

The non-frame-pointer fallback walker is kept untouched for
!CONFIG_FRAME_POINTER builds.

Signed-off-by: Wang Han <wanghan@linux.alibaba.com>
---
 arch/riscv/kernel/ftrace.c         |   6 +-
 arch/riscv/kernel/perf_callchain.c |   2 +-
 arch/riscv/kernel/stacktrace.c     | 560 ++++++++++++++++++++++++-----
 3 files changed, 472 insertions(+), 96 deletions(-)

diff --git a/arch/riscv/kernel/ftrace.c b/arch/riscv/kernel/ftrace.c
index b430edfb83f4..5d55199a9230 100644
--- a/arch/riscv/kernel/ftrace.c
+++ b/arch/riscv/kernel/ftrace.c
@@ -242,7 +242,8 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 	 */
 	old = *parent;
 
-	if (!function_graph_enter(old, self_addr, frame_pointer, parent))
+	if (!function_graph_enter(old, self_addr, frame_pointer,
+				  (void *)frame_pointer))
 		*parent = return_hooker;
 }
 
@@ -264,7 +265,8 @@ void ftrace_graph_func(unsigned long ip, unsigned long parent_ip,
 	 */
 	old = *parent;
 
-	if (!function_graph_enter_regs(old, ip, frame_pointer, parent, fregs))
+	if (!function_graph_enter_regs(old, ip, frame_pointer,
+				       (void *)frame_pointer, fregs))
 		*parent = return_hooker;
 }
 #endif /* CONFIG_DYNAMIC_FTRACE */
diff --git a/arch/riscv/kernel/perf_callchain.c b/arch/riscv/kernel/perf_callchain.c
index b465bc9eb870..436af96ea59c 100644
--- a/arch/riscv/kernel/perf_callchain.c
+++ b/arch/riscv/kernel/perf_callchain.c
@@ -44,5 +44,5 @@ void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
 		return;
 	}
 
-	walk_stackframe(NULL, regs, fill_callchain, entry);
+	arch_stack_walk(fill_callchain, entry, NULL, regs);
 }
diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 2692d3a06afa..0d76320b3a29 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -11,98 +11,16 @@
 #include <linux/sched/task_stack.h>
 #include <linux/stacktrace.h>
 #include <linux/ftrace.h>
+#include <linux/kprobes.h>
+#include <linux/llist.h>
 
 #include <asm/stacktrace.h>
 
-#ifdef CONFIG_FRAME_POINTER
-
 /*
- * This disables KASAN checking when reading a value from another task's stack,
- * since the other task could be running on another CPU and could have poisoned
- * the stack in the meantime.
+ * Non-frame-pointer fallback unwinder.
+ * Only compiled when CONFIG_FRAME_POINTER is not enabled.
  */
-#define READ_ONCE_TASK_STACK(task, x)			\
-({							\
-	unsigned long val;				\
-	unsigned long addr = x;				\
-	if ((task) == current)				\
-		val = READ_ONCE(addr);			\
-	else						\
-		val = READ_ONCE_NOCHECK(addr);		\
-	val;						\
-})
-
-extern asmlinkage void handle_exception(void);
-extern unsigned long ret_from_exception_end;
-
-static inline int fp_is_valid(unsigned long fp, unsigned long sp)
-{
-	unsigned long low, high;
-
-	low = sp + sizeof(struct stackframe);
-	high = ALIGN(sp, THREAD_SIZE);
-
-	return !(fp < low || fp > high || fp & 0x07);
-}
-
-void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
-			     bool (*fn)(void *, unsigned long), void *arg)
-{
-	unsigned long fp, sp, pc;
-	int graph_idx = 0;
-	int level = 0;
-
-	if (regs) {
-		fp = frame_pointer(regs);
-		sp = user_stack_pointer(regs);
-		pc = instruction_pointer(regs);
-	} else if (task == NULL || task == current) {
-		fp = (unsigned long)__builtin_frame_address(0);
-		sp = current_stack_pointer;
-		pc = (unsigned long)walk_stackframe;
-		level = -1;
-	} else {
-		/* task blocked in __switch_to */
-		fp = task->thread.s[0];
-		sp = task->thread.sp;
-		pc = task->thread.ra;
-	}
-
-	for (;;) {
-		struct stackframe *frame;
-
-		if (unlikely(!__kernel_text_address(pc) || (level++ >= 0 && !fn(arg, pc))))
-			break;
-
-		if (unlikely(!fp_is_valid(fp, sp)))
-			break;
-
-		/* Unwind stack frame */
-		frame = (struct stackframe *)fp - 1;
-		sp = fp;
-		if (regs && (regs->epc == pc) && fp_is_valid(frame->ra, sp)) {
-			/* We hit function where ra is not saved on the stack */
-			fp = frame->ra;
-			pc = regs->ra;
-		} else {
-			fp = READ_ONCE_TASK_STACK(task, frame->fp);
-			pc = READ_ONCE_TASK_STACK(task, frame->ra);
-			pc = ftrace_graph_ret_addr(task, &graph_idx, pc,
-						   &frame->ra);
-			if (pc >= (unsigned long)handle_exception &&
-			    pc < (unsigned long)&ret_from_exception_end) {
-				if (unlikely(!fn(arg, pc)))
-					break;
-
-				pc = ((struct pt_regs *)sp)->epc;
-				fp = ((struct pt_regs *)sp)->s0;
-			}
-		}
-
-	}
-}
-
-#else /* !CONFIG_FRAME_POINTER */
+#ifndef CONFIG_FRAME_POINTER
 
 void notrace walk_stackframe(struct task_struct *task,
 	struct pt_regs *regs, bool (*fn)(void *, unsigned long), void *arg)
@@ -133,7 +51,12 @@ void notrace walk_stackframe(struct task_struct *task,
 	}
 }
 
-#endif /* CONFIG_FRAME_POINTER */
+#endif /* !CONFIG_FRAME_POINTER */
+
+/*
+ * Common trace helpers.
+ * These are used by both the FP (kunwind) and non-FP (walk_stackframe) paths.
+ */
 
 static bool print_trace_address(void *arg, unsigned long pc)
 {
@@ -146,12 +69,12 @@ static bool print_trace_address(void *arg, unsigned long pc)
 noinline void dump_backtrace(struct pt_regs *regs, struct task_struct *task,
 		    const char *loglvl)
 {
-	walk_stackframe(task, regs, print_trace_address, (void *)loglvl);
+	printk("%sCall Trace:\n", loglvl);
+	arch_stack_walk(print_trace_address, (void *)loglvl, task, regs);
 }
 
 void show_stack(struct task_struct *task, unsigned long *sp, const char *loglvl)
 {
-	pr_cont("%sCall Trace:\n", loglvl);
 	dump_backtrace(NULL, task, loglvl);
 }
 
@@ -171,17 +94,468 @@ unsigned long __get_wchan(struct task_struct *task)
 
 	if (!try_get_task_stack(task))
 		return 0;
-	walk_stackframe(task, NULL, save_wchan, &pc);
+	arch_stack_walk(save_wchan, &pc, task, NULL);
 	put_task_stack(task);
 	return pc;
 }
 
-noinline noinstr void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
-		     struct task_struct *task, struct pt_regs *regs)
+/*
+ * Frame-pointer-based kernel unwind infrastructure.
+ * Only compiled when CONFIG_FRAME_POINTER is enabled.
+ *
+ * See: arch/arm64/kernel/stacktrace.c for the reference implementation.
+ */
+#ifdef CONFIG_FRAME_POINTER
+
+/*
+ * Per-cpu stacks are only accessible when unwinding the current task in a
+ * non-preemptible context.
+ */
+#define STACKINFO_CPU(task, name)				\
+	({							\
+		(((task) == current) && !preemptible())		\
+			? stackinfo_get_##name()		\
+			: stackinfo_get_unknown();		\
+	})
+
+enum kunwind_source {
+	KUNWIND_SOURCE_UNKNOWN,
+	KUNWIND_SOURCE_FRAME,
+	KUNWIND_SOURCE_CALLER,
+	KUNWIND_SOURCE_TASK,
+	KUNWIND_SOURCE_REGS_PC,
+};
+
+union unwind_flags {
+	unsigned long	all;
+	struct {
+		unsigned long	fgraph : 1,
+				kretprobe : 1;
+	};
+};
+
+/*
+ * Kernel unwind state
+ *
+ * @common:    Common unwind state.
+ * @task:      The task being unwound.
+ * @graph_idx: Used by ftrace_graph_ret_addr() for optimized stack unwinding.
+ * @kr_cur:    When KRETPROBES is selected, holds the kretprobe instance
+ *             associated with the most recently encountered replacement ra
+ *             value.
+ */
+struct kunwind_state {
+	struct unwind_state common;
+	struct task_struct *task;
+	int graph_idx;
+#ifdef CONFIG_KRETPROBES
+	struct llist_node *kr_cur;
+#endif
+	enum kunwind_source source;
+	union unwind_flags flags;
+	struct pt_regs *regs;
+};
+
+static __always_inline void
+kunwind_init(struct kunwind_state *state,
+	     struct task_struct *task)
+{
+	unwind_init_common(&state->common);
+	state->task = task;
+	state->source = KUNWIND_SOURCE_UNKNOWN;
+	state->flags.all = 0;
+	state->regs = NULL;
+}
+
+/*
+ * Start an unwind from a pt_regs.
+ *
+ * The unwind will begin at the PC within the regs.
+ *
+ * The regs must be on a stack currently owned by the calling task.
+ */
+static __always_inline void
+kunwind_init_from_regs(struct kunwind_state *state,
+		       struct pt_regs *regs)
+{
+	kunwind_init(state, current);
+
+	state->regs = regs;
+	state->common.fp = frame_pointer(regs);
+	state->common.pc = instruction_pointer(regs);
+	state->source = KUNWIND_SOURCE_REGS_PC;
+}
+
+/*
+ * Start an unwind from a caller.
+ *
+ * The unwind will begin at the caller of whichever function this is inlined
+ * into.
+ *
+ * The function which invokes this must be noinline.
+ */
+static __always_inline void
+kunwind_init_from_caller(struct kunwind_state *state)
+{
+	unsigned long fp = (unsigned long)__builtin_frame_address(0);
+	struct frame_record *record = (struct frame_record *)fp - 1;
+
+	kunwind_init(state, current);
+
+	state->common.fp = READ_ONCE(record->fp);
+	state->common.pc = READ_ONCE(record->ra);
+	state->source = KUNWIND_SOURCE_CALLER;
+}
+
+/*
+ * Start an unwind from a blocked task.
+ *
+ * The unwind will begin at the blocked task's saved PC (i.e. the caller of
+ * __switch_to).
+ *
+ * The caller should ensure the task is blocked in __switch_to for the
+ * duration of the unwind, or the unwind will be bogus. It is never valid to
+ * call this for the current task.
+ */
+static __always_inline void
+kunwind_init_from_task(struct kunwind_state *state,
+		       struct task_struct *task)
+{
+	kunwind_init(state, task);
+
+	state->common.fp = task->thread.s[0];
+	state->common.pc = task->thread.ra;
+	state->source = KUNWIND_SOURCE_TASK;
+}
+
+static __always_inline int
+kunwind_recover_return_address(struct kunwind_state *state)
+{
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	if (state->task->ret_stack &&
+	    state->common.pc == (unsigned long)return_to_handler) {
+		unsigned long orig_pc;
+
+		orig_pc = ftrace_graph_ret_addr(state->task, &state->graph_idx,
+						state->common.pc,
+						(void *)state->common.fp);
+		if (state->common.pc == orig_pc) {
+			WARN_ON_ONCE(state->task == current);
+			return -EINVAL;
+		}
+		state->common.pc = orig_pc;
+		state->flags.fgraph = 1;
+	}
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
+#ifdef CONFIG_KRETPROBES
+	if (is_kretprobe_trampoline(state->common.pc)) {
+		unsigned long orig_pc;
+
+		orig_pc = kretprobe_find_ret_addr(state->task,
+						  (void *)state->common.fp,
+						  &state->kr_cur);
+		if (!orig_pc)
+			return -EINVAL;
+		state->common.pc = orig_pc;
+		state->flags.kretprobe = 1;
+	}
+#endif /* CONFIG_KRETPROBES */
+
+	return 0;
+}
+
+/*
+ * When we reach an exception boundary marked by a metadata frame record,
+ * extract pt_regs from the stack and continue unwinding from the saved
+ * context (epc and s0/fp).
+ *
+ * On RISC-V, fp points above the metadata record, so the record's
+ * frame_record portion is at fp - sizeof(struct frame_record).
+ */
+static __always_inline int
+kunwind_next_regs_pc(struct kunwind_state *state)
+{
+	struct stack_info *info;
+	unsigned long fp = state->common.fp;
+	struct pt_regs *regs;
+
+	regs = container_of((unsigned long *)(fp - sizeof(struct frame_record)),
+			    struct pt_regs, stackframe.record.fp);
+
+	info = unwind_find_stack(&state->common, (unsigned long)regs,
+				 sizeof(*regs));
+	if (!info)
+		return -EINVAL;
+
+	unwind_consume_stack(&state->common, info, (unsigned long)regs,
+			     sizeof(*regs));
+
+	state->regs = regs;
+	state->common.pc = regs->epc;
+	state->common.fp = frame_pointer(regs);
+	state->regs = NULL;
+	state->source = KUNWIND_SOURCE_REGS_PC;
+	return 0;
+}
+
+/*
+ * Handle a metadata frame record embedded in pt_regs.
+ *
+ * On RISC-V, fp points above the record (fp = metadata + 16), so the
+ * frame_record_meta starts at fp - sizeof(struct frame_record).
+ *
+ * FRAME_META_TYPE_FINAL: This is the outermost exception entry
+ *   (user -> kernel). Unwinding terminates successfully.
+ * FRAME_META_TYPE_PT_REGS: This is a nested exception entry
+ *   (kernel -> kernel). Continue unwinding from the saved context.
+ */
+static __always_inline int
+kunwind_next_frame_record_meta(struct kunwind_state *state)
+{
+	struct task_struct *tsk = state->task;
+	unsigned long fp = state->common.fp;
+	unsigned long meta_base = fp - sizeof(struct frame_record);
+	struct frame_record_meta *meta;
+	struct stack_info *info;
+
+	info = unwind_find_stack(&state->common, meta_base, sizeof(*meta));
+	if (!info)
+		return -EINVAL;
+
+	meta = (struct frame_record_meta *)meta_base;
+	switch (READ_ONCE(meta->type)) {
+	case FRAME_META_TYPE_FINAL:
+		if (meta == &task_pt_regs(tsk)->stackframe)
+			return -ENOENT;
+		WARN_ON_ONCE(tsk == current);
+		return -EINVAL;
+	case FRAME_META_TYPE_PT_REGS:
+		return kunwind_next_regs_pc(state);
+	default:
+		WARN_ON_ONCE(tsk == current);
+		return -EINVAL;
+	}
+}
+
+/*
+ * Unwind from one frame record to the next.
+ *
+ * On RISC-V, the frame record sits at fp - sizeof(struct frame_record),
+ * immediately below the address pointed to by fp/s0. This applies to both
+ * normal frame records and metadata frame records (embedded in pt_regs).
+ *
+ * A metadata record is identified by both fp and ra being zero in the
+ * frame_record portion, with a type value following at fp + 16.
+ */
+static __always_inline int
+kunwind_next_frame_record(struct kunwind_state *state)
+{
+	unsigned long fp = state->common.fp;
+	struct frame_record *record;
+	struct stack_info *info;
+	unsigned long new_fp, new_pc;
+	unsigned long record_base;
+
+	if (fp & 0x7)
+		return -EINVAL;
+
+	record_base = fp - sizeof(*record);
+
+	info = unwind_find_stack(&state->common, record_base, sizeof(*record));
+	if (!info)
+		return -EINVAL;
+
+	record = (struct frame_record *)record_base;
+	new_fp = READ_ONCE(record->fp);
+	new_pc = READ_ONCE(record->ra);
+
+	if (!new_fp && !new_pc)
+		return kunwind_next_frame_record_meta(state);
+
+	unwind_consume_stack(&state->common, info, record_base,
+			     sizeof(*record));
+
+	state->common.fp = new_fp;
+	state->common.pc = new_pc;
+	state->source = KUNWIND_SOURCE_FRAME;
+
+	return 0;
+}
+
+/*
+ * Unwind from one frame record (A) to the next frame record (B).
+ *
+ * We terminate early if the location of B indicates a malformed chain of frame
+ * records (e.g. a cycle), determined based on the location and fp value of A
+ * and the location (but not the fp value) of B.
+ */
+static __always_inline int
+kunwind_next(struct kunwind_state *state)
+{
+	int err;
+
+	state->flags.all = 0;
+
+	switch (state->source) {
+	case KUNWIND_SOURCE_FRAME:
+	case KUNWIND_SOURCE_CALLER:
+	case KUNWIND_SOURCE_TASK:
+	case KUNWIND_SOURCE_REGS_PC:
+		err = kunwind_next_frame_record(state);
+		break;
+	default:
+		err = -EINVAL;
+	}
+
+	if (err)
+		return err;
+
+	return kunwind_recover_return_address(state);
+}
+
+typedef bool (*kunwind_consume_fn)(const struct kunwind_state *state, void *cookie);
+
+static __always_inline int
+do_kunwind(struct kunwind_state *state, kunwind_consume_fn consume_state,
+	   void *cookie)
+{
+	int ret;
+
+	ret = kunwind_recover_return_address(state);
+	if (ret)
+		return ret;
+
+	while (1) {
+		if (!consume_state(state, cookie))
+			return -EINVAL;
+		ret = kunwind_next(state);
+		if (ret == -ENOENT)
+			return 0;
+		if (ret < 0)
+			return ret;
+	}
+}
+
+static __always_inline int
+kunwind_stack_walk(kunwind_consume_fn consume_state,
+		   void *cookie, struct task_struct *task,
+		   struct pt_regs *regs)
+{
+	struct task_struct *tsk = task ?: current;
+	struct stack_info stacks[] = {
+		stackinfo_get_task(tsk),
+		STACKINFO_CPU(tsk, irq),
+#ifdef CONFIG_VMAP_STACK
+		STACKINFO_CPU(tsk, overflow),
+#endif
+	};
+	struct kunwind_state state = {
+		.common = {
+			.stacks = stacks,
+			.nr_stacks = ARRAY_SIZE(stacks),
+		},
+	};
+
+	if (regs) {
+		if (tsk != current)
+			return -EINVAL;
+		kunwind_init_from_regs(&state, regs);
+	} else if (tsk == current) {
+		kunwind_init_from_caller(&state);
+	} else {
+		kunwind_init_from_task(&state, tsk);
+	}
+
+	return do_kunwind(&state, consume_state, cookie);
+}
+
+struct kunwind_consume_entry_data {
+	stack_trace_consume_fn consume_entry;
+	void *cookie;
+};
+
+static __always_inline bool
+arch_kunwind_consume_entry(const struct kunwind_state *state, void *cookie)
+{
+	struct kunwind_consume_entry_data *data = cookie;
+
+	return data->consume_entry(data->cookie, state->common.pc);
+}
+
+static __always_inline bool
+arch_reliable_kunwind_consume_entry(const struct kunwind_state *state, void *cookie)
+{
+	/*
+	 * At an exception boundary we can reliably consume the saved PC. We do
+	 * not know whether the LR was live when the exception was taken, and
+	 * so we cannot perform the next unwind step reliably.
+	 *
+	 * All that matters is whether the *entire* unwind is reliable, so give
+	 * up as soon as we hit an exception boundary.
+	 */
+	if (state->source == KUNWIND_SOURCE_REGS_PC)
+		return false;
+
+	return arch_kunwind_consume_entry(state, cookie);
+}
+
+#endif /* CONFIG_FRAME_POINTER */
+
+/*
+ * arch_stack_walk - dual implementation.
+ *
+ * When CONFIG_FRAME_POINTER is enabled, uses the kunwind infrastructure for
+ * robust frame-pointer-based unwinding, consistent with arch_stack_walk_reliable.
+ *
+ * When CONFIG_FRAME_POINTER is disabled, falls back to the simple stack scan
+ * in walk_stackframe().
+ */
+#ifdef CONFIG_FRAME_POINTER
+
+noinline noinstr void arch_stack_walk(stack_trace_consume_fn consume_entry,
+				      void *cookie, struct task_struct *task,
+				      struct pt_regs *regs)
+{
+	struct kunwind_consume_entry_data data = {
+		.consume_entry = consume_entry,
+		.cookie = cookie,
+	};
+
+	kunwind_stack_walk(arch_kunwind_consume_entry, &data, task, regs);
+}
+
+#else
+
+noinline noinstr void arch_stack_walk(stack_trace_consume_fn consume_entry,
+				      void *cookie, struct task_struct *task,
+				      struct pt_regs *regs)
 {
 	walk_stackframe(task, regs, consume_entry, cookie);
 }
 
+#endif /* CONFIG_FRAME_POINTER */
+
+/*
+ * Reliable stack walk for livepatch (CONFIG_FRAME_POINTER only).
+ */
+#ifdef CONFIG_FRAME_POINTER
+
+noinline noinstr int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
+					      void *cookie,
+					      struct task_struct *task)
+{
+	struct kunwind_consume_entry_data data = {
+		.consume_entry = consume_entry,
+		.cookie = cookie,
+	};
+
+	return kunwind_stack_walk(arch_reliable_kunwind_consume_entry, &data,
+				  task, NULL);
+}
+
+#endif /* CONFIG_FRAME_POINTER */
+
 /*
  * Get the return address for a single stackframe and return a pointer to the
  * next frame tail.
-- 
2.43.0


