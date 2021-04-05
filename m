Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB22354256
	for <lists+live-patching@lfdr.de>; Mon,  5 Apr 2021 15:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235663AbhDENYs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 5 Apr 2021 09:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232694AbhDENYr (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 5 Apr 2021 09:24:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10402613AE;
        Mon,  5 Apr 2021 13:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617629081;
        bh=GzWTUhTx84OO6tFHIPGCur+SXJJT4/XuNd0dfMshivk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IyrWktd318uIivJ0IVfbgXFxBMRf9+ExIuSaTczkDVyTiupeD80JchSKL87ANUnz3
         Z4CADXCMDvop88DheFKaXCxUo3IZyH7lU156eeM6FzY8+mbwSqWfDWMTpctlptWaKn
         pP5L9rMm5Lft01htPEf6nRwnydyg2HxsPrAEJppcMYiNbIqsuP5aoxncAMXccJcjFM
         PYz7K1l+kn7gpc166AJJcG6tGDCYyLA2fnyU/zzsrxLoHSv5ByESvuxvjxz+/frEhB
         /hLP1kItUca2mR+Pv7dLMJOLV/wjR//JxFZIFGx49EldxFycEX9S9qXw6wh6LT8S0h
         3Ik5LpEX7+hew==
Date:   Mon, 5 Apr 2021 22:24:36 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, mark.rutland@arm.com,
        broonie@kernel.org, jthierry@redhat.com, catalin.marinas@arm.com,
        will@kernel.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [RFC PATCH v1 0/4] arm64: Implement stack trace reliability
 checks
Message-Id: <20210405222436.4fda9a930676d95e862744af@kernel.org>
In-Reply-To: <bd13a433-c060-c501-8e76-5e856d77a225@linux.microsoft.com>
References: <77bd5edeea72d44533c769b1e8c0fea7a9d7eb3a>
        <20210330190955.13707-1-madvenka@linux.microsoft.com>
        <20210403170159.gegqjrsrg7jshlne@treble>
        <bd13a433-c060-c501-8e76-5e856d77a225@linux.microsoft.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Madhaven,

On Sat, 3 Apr 2021 22:29:12 -0500
"Madhavan T. Venkataraman" <madvenka@linux.microsoft.com> wrote:


> >> Check for kretprobe
> >> ===================
> >>
> >> For functions with a kretprobe set up, probe code executes on entry
> >> to the function and replaces the return address in the stack frame with a
> >> kretprobe trampoline. Whenever the function returns, control is
> >> transferred to the trampoline. The trampoline eventually returns to the
> >> original return address.
> >>
> >> A stack trace taken while executing in the function (or in functions that
> >> get called from the function) will not show the original return address.
> >> Similarly, a stack trace taken while executing in the trampoline itself
> >> (and functions that get called from the trampoline) will not show the
> >> original return address. This means that the caller of the probed function
> >> will not show. This makes the stack trace unreliable.
> >>
> >> Add the kretprobe trampoline to special_functions[].
> >>
> >> FYI, each task contains a task->kretprobe_instances list that can
> >> theoretically be consulted to find the orginal return address. But I am
> >> not entirely sure how to safely traverse that list for stack traces
> >> not on the current process. So, I have taken the easy way out.
> > 
> > For kretprobes, unwinding from the trampoline or kretprobe handler
> > shouldn't be a reliability concern for live patching, for similar
> > reasons as above.
> > 
> 
> Please see previous answer.
> 
> > Otherwise, when unwinding from a blocked task which has
> > 'kretprobe_trampoline' on the stack, the unwinder needs a way to get the
> > original return address.  Masami has been working on an interface to
> > make that possible for x86.  I assume something similar could be done
> > for arm64.
> > 
> 
> OK. Until that is available, this case needs to be addressed.

Actually, I've done that on arm64 :) See below patch.
(and I also have a similar code for arm32, what I'm considering is how
to unify x86/arm/arm64 kretprobe_find_ret_addr(), since those are very
similar.)

This is applicable on my x86 series v5

https://lore.kernel.org/bpf/161676170650.330141.6214727134265514123.stgit@devnote2/

Thank you,


From 947cf6cf1fd4154edd5533d18c2f8dfedc8d993d Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Sat, 20 Mar 2021 00:14:29 +0900
Subject: [PATCH] arm64: Recover kretprobe modified return address in
 stacktrace

Since the kretprobe replaces the function return address with
the kretprobe_trampoline on the stack, arm64 unwinder shows it
instead of the correct return address.

This finds the correct return address from the per-task
kretprobe_instances list and verify it is in between the
caller fp and callee fp.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 arch/arm64/include/asm/stacktrace.h |  2 ++
 arch/arm64/kernel/probes/kprobes.c  | 28 ++++++++++++++++++++++++++++
 arch/arm64/kernel/stacktrace.c      |  3 +++
 kernel/kprobes.c                    |  8 ++++----
 4 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index eb29b1fe8255..50ebc9e9dba9 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -9,6 +9,7 @@
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
 #include <linux/types.h>
+#include <linux/llist.h>
 
 #include <asm/memory.h>
 #include <asm/ptrace.h>
@@ -59,6 +60,7 @@ struct stackframe {
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	int graph;
 #endif
+	struct llist_node *kr_cur;
 };
 
 extern int unwind_frame(struct task_struct *tsk, struct stackframe *frame);
diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index fce681fdfce6..204e475cbff3 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -410,6 +410,34 @@ int __init arch_populate_kprobe_blacklist(void)
 	return ret;
 }
 
+unsigned long __kretprobe_find_ret_addr(struct task_struct *tsk,
+					struct llist_node **cur);
+
+unsigned long kretprobe_find_ret_addr(struct task_struct *tsk,
+				void *fp, struct llist_node **cur)
+{
+	struct kretprobe_instance *ri;
+	unsigned long ret;
+
+	do {
+		ret = __kretprobe_find_ret_addr(tsk, cur);
+		if (!ret)
+			return ret;
+		ri = container_of(*cur, struct kretprobe_instance, llist);
+		/*
+		 * Since arm64 stores the stack pointer of the entry of target
+		 * function (callee) to ri->fp, the given real @fp must be
+		 * smaller than ri->fp, but bigger than the previous ri->fp.
+		 *
+		 * callee sp (prev ri->fp)
+		 * fp (and *saved_lr)
+		 * caller sp (ri->fp)
+		 */
+	} while (ri->fp <= fp);
+
+	return ret;
+}
+
 void __kprobes __used *trampoline_probe_handler(struct pt_regs *regs)
 {
 	return (void *)kretprobe_trampoline_handler(regs, (void *)kernel_stack_pointer(regs));
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index ad20981dfda4..956486d4ac10 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -105,6 +105,8 @@ int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
 		frame->pc = ret_stack->ret;
 	}
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+	if (is_kretprobe_trampoline(frame->pc))
+		frame->pc = kretprobe_find_ret_addr(tsk, (void *)fp, &frame->kr_cur);
 
 	frame->pc = ptrauth_strip_insn_pac(frame->pc);
 
@@ -199,6 +201,7 @@ void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
 {
 	struct stackframe frame;
 
+	memset(&frame, 0, sizeof(frame));
 	if (regs)
 		start_backtrace(&frame, regs->regs[29], regs->pc);
 	else if (task == current)
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 4ce3e6f5d28d..12677a463561 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1859,8 +1859,8 @@ static struct notifier_block kprobe_exceptions_nb = {
 #ifdef CONFIG_KRETPROBES
 
 /* This assumes the tsk is current or the task which is not running. */
-static unsigned long __kretprobe_find_ret_addr(struct task_struct *tsk,
-					       struct llist_node **cur)
+unsigned long __kretprobe_find_ret_addr(struct task_struct *tsk,
+					struct llist_node **cur)
 {
 	struct kretprobe_instance *ri = NULL;
 	struct llist_node *node = *cur;
@@ -1882,8 +1882,8 @@ static unsigned long __kretprobe_find_ret_addr(struct task_struct *tsk,
 }
 NOKPROBE_SYMBOL(__kretprobe_find_ret_addr);
 
-unsigned long kretprobe_find_ret_addr(struct task_struct *tsk, void *fp,
-				      struct llist_node **cur)
+unsigned long __weak kretprobe_find_ret_addr(struct task_struct *tsk,
+				void *fp, struct llist_node **cur)
 {
 	struct kretprobe_instance *ri = NULL;
 	unsigned long ret;
-- 
2.25.1



-- 
Masami Hiramatsu <mhiramat@kernel.org>
