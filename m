Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F03439C0F
	for <lists+live-patching@lfdr.de>; Mon, 25 Oct 2021 18:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbhJYQv4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 25 Oct 2021 12:51:56 -0400
Received: from foss.arm.com ([217.140.110.172]:48120 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234054AbhJYQvz (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 25 Oct 2021 12:51:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B118B1FB;
        Mon, 25 Oct 2021 09:49:32 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.75.8])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C43E93F70D;
        Mon, 25 Oct 2021 09:49:29 -0700 (PDT)
Date:   Mon, 25 Oct 2021 17:49:25 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 05/11] arm64: Make dump_stacktrace() use
 arch_stack_walk()
Message-ID: <20211025164925.GB2001@C02TD0UTHF1T.local>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-6-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015025847.17694-6-madvenka@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Oct 14, 2021 at 09:58:41PM -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Currently, dump_stacktrace() in ARM64 code walks the stack using
> start_backtrace() and unwind_frame(). Make it use arch_stack_walk()
> instead. This makes maintenance easier.
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  arch/arm64/kernel/stacktrace.c | 44 +++++-----------------------------
>  1 file changed, 6 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index 8982a2b78acf..776c4debb5a7 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -151,24 +151,20 @@ void notrace walk_stackframe(struct task_struct *tsk, struct stackframe *frame,
>  }
>  NOKPROBE_SYMBOL(walk_stackframe);
>  
> -static void dump_backtrace_entry(unsigned long where, const char *loglvl)
> +static bool dump_backtrace_entry(void *arg, unsigned long where)
>  {
> +	char *loglvl = arg;
>  	printk("%s %pSb\n", loglvl, (void *)where);
> +	return true;
>  }
>  
>  void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
>  		    const char *loglvl)
>  {
> -	struct stackframe frame;
> -	int skip = 0;
> -
>  	pr_debug("%s(regs = %p tsk = %p)\n", __func__, regs, tsk);
>  
> -	if (regs) {
> -		if (user_mode(regs))
> -			return;
> -		skip = 1;
> -	}
> +	if (regs && user_mode(regs))
> +		return;
>  
>  	if (!tsk)
>  		tsk = current;
> @@ -176,36 +172,8 @@ void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
>  	if (!try_get_task_stack(tsk))
>  		return;
>  
> -	if (tsk == current) {
> -		start_backtrace(&frame,
> -				(unsigned long)__builtin_frame_address(0),
> -				(unsigned long)dump_backtrace);
> -	} else {
> -		/*
> -		 * task blocked in __switch_to
> -		 */
> -		start_backtrace(&frame,
> -				thread_saved_fp(tsk),
> -				thread_saved_pc(tsk));
> -	}
> -
>  	printk("%sCall trace:\n", loglvl);
> -	do {
> -		/* skip until specified stack frame */
> -		if (!skip) {
> -			dump_backtrace_entry(frame.pc, loglvl);
> -		} else if (frame.fp == regs->regs[29]) {
> -			skip = 0;
> -			/*
> -			 * Mostly, this is the case where this function is
> -			 * called in panic/abort. As exception handler's
> -			 * stack frame does not contain the corresponding pc
> -			 * at which an exception has taken place, use regs->pc
> -			 * instead.
> -			 */
> -			dump_backtrace_entry(regs->pc, loglvl);
> -		}
> -	} while (!unwind_frame(tsk, &frame));
> +	arch_stack_walk(dump_backtrace_entry, (void *)loglvl, tsk, regs);

This looks really nice!

Unfortunately, removing the `skip` logic higlights a latent issue with
the unwinder (which we previously worked around here but not elsewhere),
whreby we can report erroneous entries when unwinding from regs, because
the fgraph ret stack can have entries added between exception entry and
performing unwind steps.

With this patch as-is, if you enable the function graph tracer, then use
magic-sysrq l, you can see something like:

| sysrq: Show backtrace of all active CPUs
| sysrq: CPU0:
| CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.15.0-rc4-00005-g9097969cd989 #2
| Hardware name: linux,dummy-virt (DT)
| pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
| pc : arch_cpu_idle+0x1c/0x30
| lr : arch_cpu_idle+0x14/0x30
| sp : ffffc74542823d50
| x29: ffffc74542823d50 x28: 000000004129444c x27: 0000000000000000
| x26: ffffc74542833f00 x25: 0000000000000000 x24: 0000000000000000
| x23: ffffc74542829b10 x22: ffffc7454213ccb8 x21: ffffc745428299e8
| x20: ffffc74542829ae0 x19: ffffc7454212d000 x18: 0000000000000000
| x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
| x14: 0000000000000000 x13: 0000000000000001 x12: 0000000002c00ff0
| x11: 0000000002c00000 x10: ffffc74542823d30 x9 : ffff26b8cc7ba600
| x8 : 0000000000000001 x7 : 0000000000000089 x6 : 000000291c72cca9
| x5 : ffff5f74b4953000 x4 : 0000000000004a09 x3 : ffff5f74b4953000
| x2 : 0000000000004a09 x1 : ffff26b9f6a91e20 x0 : 00000000000000e0
| Call trace:
|  arch_cpu_idle+0x1c/0x30
|  default_idle_call+0x4c/0x19c
|  dump_backtrace+0x30/0x3c
|  show_regs+0x38/0x50
|  rest_init+0xf0/0x100
|  arch_call_rest_init+0x1c/0x28
|  start_kernel+0x69c/0x6dc
|  __primary_switched+0xc0/0xc8

The 'dump_backtrace` and `show_regs` entries don't belong there, and are
hiding the real entries at that part of the callchain.

I think the fix for that is something like the below, which we should
take as a preparatory fix, but as this could trigger warnings in
legitimate usage scenarios we'll need to think a bit harder about the
case of unwinding from regs, and whether the WARN_ON_ONCE() is
warranted.

Thanks,
Mark.

---->8----
From f3e66ca75aff3474355839f72d123276028204e1 Mon Sep 17 00:00:00 2001
From: Mark Rutland <mark.rutland@arm.com>
Date: Mon, 25 Oct 2021 13:23:11 +0100
Subject: [PATCH] arm64: ftrace: use HAVE_FUNCTION_GRAPH_RET_ADDR_PTR

When CONFIG_FUNCTION_GRAPH_TRACER is selected, and the function graph:
tracer is in use, unwind_frame() may erroneously asscociate a traced
function with an incorrect return address. This can happen when starting
an unwind from a pt_regs, or when unwinding across an exception
boundary.

The underlying problem is that ftrace_graph_get_ret_stack() takes an
index offset from the most recent entry added to the fgraph return
stack. We start an unwind at offset 0, and increment the offset each
time we encounter `return_to_handler`, which indicates a rewritten
return address. This is broken in two cases:

* Between creating a pt_regs and starting the unwind, function calls may
  place entries on the stack, leaving an abitrary offset which we can
  only determine by performing a full unwind from the caller of the
  unwind code. While this initial unwind is open-coded in
  dump_backtrace(), this is not performed for other unwinders such as
  perf_callchain_kernel().

* When unwinding across an exception boundary (whether continuing an
  unwind or starting a new unwind from regs), we always consume the LR
  of the interrupted context, though this may not have been live at the
  time of the exception. Where the LR was not live but happened to
  contain `return_to_handler`, we'll recover an address from the graph
  return stack and increment the current offset, leaving subsequent
  entries off-by-one.

  Where the LR was not live and did not contain `return_to_handler`, we
  will still report an erroneous address, but subsequent entries will be
  unaffected.

We can fix the graph return address issues by using
HAVE_FUNCTION_GRAPH_RET_ADDR_PTR, and associating each rewritten return
address with a unique location on the stack. As the return address is
passed in the LR (and so is not guaranteed a unique location in memory),
we use the FP upon entry to the function (i.e. the address of the
caller's frame record) as the return address pointer.

NOTE: With this patch applied, unwinding using regs from a context where
LR is not live but contains `return_to_handler` should consistently
trigger the WARN_ON_ONCE() in unwind_frame(), as the FP must be
different to the FP upon entry to the function. So far I have been
unable to trigger this in local testing. This is a latent bug which
already existed, but could have been masked by the prior behviour of
consuming extra entries in the ftrace graph stack. So far I have not
been able to trigger this in local testing.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/ftrace.h     | 11 +++++++++++
 arch/arm64/include/asm/stacktrace.h |  6 ------
 arch/arm64/kernel/ftrace.c          |  6 +++---
 arch/arm64/kernel/stacktrace.c      | 12 +++++-------
 4 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
index 91fa4baa1a93..c96d47cb8f46 100644
--- a/arch/arm64/include/asm/ftrace.h
+++ b/arch/arm64/include/asm/ftrace.h
@@ -12,6 +12,17 @@
 
 #define HAVE_FUNCTION_GRAPH_FP_TEST
 
+/*
+ * HAVE_FUNCTION_GRAPH_RET_ADDR_PTR means that the architecture can provide a
+ * "return address pointer" which can be used to uniquely identify a return
+ * address which has been overwritten.
+ *
+ * On arm64 we use the address of the caller's frame record, which remains the
+ * same for the lifetime of the instrumented function, unlike the return
+ * address in the LR.
+ */
+#define HAVE_FUNCTION_GRAPH_RET_ADDR_PTR
+
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
 #define ARCH_SUPPORTS_FTRACE_OPS 1
 #else
diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 8aebc00c1718..9a319eca5cab 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -46,9 +46,6 @@ struct stack_info {
  * @prev_type:   The type of stack this frame record was on, or a synthetic
  *               value of STACK_TYPE_UNKNOWN. This is used to detect a
  *               transition from one stack to another.
- *
- * @graph:       When FUNCTION_GRAPH_TRACER is selected, holds the index of a
- *               replacement lr value in the ftrace graph stack.
  */
 struct stackframe {
 	unsigned long fp;
@@ -56,9 +53,6 @@ struct stackframe {
 	DECLARE_BITMAP(stacks_done, __NR_STACK_TYPES);
 	unsigned long prev_fp;
 	enum stack_type prev_type;
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	int graph;
-#endif
 };
 
 extern int unwind_frame(struct task_struct *tsk, struct stackframe *frame);
diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
index 7f467bd9db7a..3e5d0ed63eb7 100644
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -249,8 +249,6 @@ int __init ftrace_dyn_arch_init(void)
  * on the way back to parent. For this purpose, this function is called
  * in _mcount() or ftrace_caller() to replace return address (*parent) on
  * the call stack to return_to_handler.
- *
- * Note that @frame_pointer is used only for sanity check later.
  */
 void prepare_ftrace_return(unsigned long self_addr, unsigned long *parent,
 			   unsigned long frame_pointer)
@@ -268,8 +266,10 @@ void prepare_ftrace_return(unsigned long self_addr, unsigned long *parent,
 	 */
 	old = *parent;
 
-	if (!function_graph_enter(old, self_addr, frame_pointer, NULL))
+	if (!function_graph_enter(old, self_addr, frame_pointer,
+	    (void *)frame_pointer)) {
 		*parent = return_hooker;
+	}
 }
 
 #ifdef CONFIG_DYNAMIC_FTRACE
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 8982a2b78acf..749b680b4999 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -38,9 +38,6 @@ void start_backtrace(struct stackframe *frame, unsigned long fp,
 {
 	frame->fp = fp;
 	frame->pc = pc;
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	frame->graph = 0;
-#endif
 
 	/*
 	 * Prime the first unwind.
@@ -116,17 +113,18 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	if (tsk->ret_stack &&
 		(ptrauth_strip_insn_pac(frame->pc) == (unsigned long)return_to_handler)) {
-		struct ftrace_ret_stack *ret_stack;
+		unsigned long orig_pc;
 		/*
 		 * This is a case where function graph tracer has
 		 * modified a return address (LR) in a stack frame
 		 * to hook a function return.
 		 * So replace it to an original value.
 		 */
-		ret_stack = ftrace_graph_get_ret_stack(tsk, frame->graph++);
-		if (WARN_ON_ONCE(!ret_stack))
+		orig_pc = ftrace_graph_ret_addr(tsk, NULL, frame->pc,
+						(void *)frame->fp);
+		if (WARN_ON_ONCE(frame->pc == orig_pc))
 			return -EINVAL;
-		frame->pc = ret_stack->ret;
+		frame->pc = orig_pc;
 	}
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
-- 
2.11.0

