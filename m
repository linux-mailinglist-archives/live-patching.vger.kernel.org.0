Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FF735494F
	for <lists+live-patching@lfdr.de>; Tue,  6 Apr 2021 01:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239157AbhDEXkC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 5 Apr 2021 19:40:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241872AbhDEXkA (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 5 Apr 2021 19:40:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D68B561394;
        Mon,  5 Apr 2021 23:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617665990;
        bh=u77T+CyeEIo78wTl5ur+Bsoh/E1m67J1hQzRCHnIuvA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qhsMDBmi5howpd/jXdQT24qxs9bd/zfvdgZVy+0nMG6k2/eILWbi4OrAbO/Ek1ymn
         1QT1yb/BJn3cUIhvpp3Ex7ApfhM5ZQqzQnB/MfTEMYzVLISVKYm5RveuGP7Fq+tzzU
         ANLWDY6H7rW04T9enapNFrubA8djRLE+GyHhHa+PbWjF0bzHIPL/3AadreILCQ9Axy
         ncBF97G52FCYLekwsFry7NnZZxDLmS5kBLNF/hjSfksZ00bf1aj5ozFp7fUGySsRKa
         FhgLlx/Z4Rzr9JZGYitWz/gCMv0tYQVaVMtIDw5sIvXUoEWoCQjq2V/RhA1x84mCvG
         mW3tF1kSJ3FHg==
Date:   Tue, 6 Apr 2021 08:39:45 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, mark.rutland@arm.com,
        broonie@kernel.org, jthierry@redhat.com, catalin.marinas@arm.com,
        will@kernel.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/4] arm64: Implement stack trace reliability
 checks
Message-Id: <20210406083945.0ae2f3ca8f02b59759c891b1@kernel.org>
In-Reply-To: <380d0437-e205-5eab-3664-f17aa9adc3eb@linux.microsoft.com>
References: <77bd5edeea72d44533c769b1e8c0fea7a9d7eb3a>
        <20210330190955.13707-1-madvenka@linux.microsoft.com>
        <20210403170159.gegqjrsrg7jshlne@treble>
        <bd13a433-c060-c501-8e76-5e856d77a225@linux.microsoft.com>
        <20210405222436.4fda9a930676d95e862744af@kernel.org>
        <7dda9af3-1ecf-5e6f-1e46-8870a2a5e550@linux.microsoft.com>
        <380d0437-e205-5eab-3664-f17aa9adc3eb@linux.microsoft.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 5 Apr 2021 12:12:08 -0500
"Madhavan T. Venkataraman" <madvenka@linux.microsoft.com> wrote:

> 
> 
> On 4/5/21 9:56 AM, Madhavan T. Venkataraman wrote:
> > 
> > 
> > On 4/5/21 8:24 AM, Masami Hiramatsu wrote:
> >> Hi Madhaven,
> >>
> >> On Sat, 3 Apr 2021 22:29:12 -0500
> >> "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com> wrote:
> >>
> >>
> >>>>> Check for kretprobe
> >>>>> ===================
> >>>>>
> >>>>> For functions with a kretprobe set up, probe code executes on entry
> >>>>> to the function and replaces the return address in the stack frame with a
> >>>>> kretprobe trampoline. Whenever the function returns, control is
> >>>>> transferred to the trampoline. The trampoline eventually returns to the
> >>>>> original return address.
> >>>>>
> >>>>> A stack trace taken while executing in the function (or in functions that
> >>>>> get called from the function) will not show the original return address.
> >>>>> Similarly, a stack trace taken while executing in the trampoline itself
> >>>>> (and functions that get called from the trampoline) will not show the
> >>>>> original return address. This means that the caller of the probed function
> >>>>> will not show. This makes the stack trace unreliable.
> >>>>>
> >>>>> Add the kretprobe trampoline to special_functions[].
> >>>>>
> >>>>> FYI, each task contains a task->kretprobe_instances list that can
> >>>>> theoretically be consulted to find the orginal return address. But I am
> >>>>> not entirely sure how to safely traverse that list for stack traces
> >>>>> not on the current process. So, I have taken the easy way out.
> >>>>
> >>>> For kretprobes, unwinding from the trampoline or kretprobe handler
> >>>> shouldn't be a reliability concern for live patching, for similar
> >>>> reasons as above.
> >>>>
> >>>
> >>> Please see previous answer.
> >>>
> >>>> Otherwise, when unwinding from a blocked task which has
> >>>> 'kretprobe_trampoline' on the stack, the unwinder needs a way to get the
> >>>> original return address.  Masami has been working on an interface to
> >>>> make that possible for x86.  I assume something similar could be done
> >>>> for arm64.
> >>>>
> >>>
> >>> OK. Until that is available, this case needs to be addressed.
> >>
> >> Actually, I've done that on arm64 :) See below patch.
> >> (and I also have a similar code for arm32, what I'm considering is how
> >> to unify x86/arm/arm64 kretprobe_find_ret_addr(), since those are very
> >> similar.)
> >>
> >> This is applicable on my x86 series v5
> >>
> >> https://lore.kernel.org/bpf/161676170650.330141.6214727134265514123.stgit@devnote2/
> >>
> >> Thank you,
> >>
> >>
> > 
> > I took a brief look at your changes. Looks reasonable.
> > 
> > However, for now, I am going to include the kretprobe_trampoline in the special_functions[]
> > array until your changes are merged. At that point, it is just a matter of deleting
> > kretprobe_trampoline from the special_functions[] array. That is all.
> > 
> > I hope that is fine with everyone.
> > 
> 
> Actually, there may still be a problem to solve.
> 
> If arch_stack_walk_reliable() is ever called from within kretprobe_trampoline() for debugging or
> other purposes after the instance is deleted from the task instance list, it would not be able
> to retrieve the original return address.
> 
> The stack trace would be unreliable in that case, would it not?

Good catch! I'm preparing a patch to fix that case (currently only for x86, see below).
This is currently only for x86. Arm64 kretprobe may have to modify its stack
layout similar to x86 so that unwinder can find the return address from
stack.

Thank you,

From cdca74a1ebc174062eb99a376072002ae21f7d7e Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Mon, 8 Mar 2021 00:22:51 +0900
Subject: [PATCH] x86/kprobes: Fixup return address in generic trampoline
 handler

In x86, kretprobe trampoline address on the stack frame will
be replaced with the real return address after returning from
trampoline_handler. Before fixing the return address, the real
return address can be found in the current->kretprobe_instances.

However, since there is a window between updating the
current->kretprobe_instances and fixing the address on the stack,
if an interrupt caused at that timing and the interrupt handler
does stacktrace, it may fail to unwind because it can not get
the correct return address from current->kretprobe_instances.

This will minimize that window by fixing the return address
right before updating current->kretprobe_instances.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 arch/x86/kernel/kprobes/core.c | 14 ++++++++++++--
 kernel/kprobes.c               |  8 ++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 00c5944ae8f6..950b8e873937 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -1032,6 +1032,7 @@ STACK_FRAME_NON_STANDARD(kretprobe_trampoline);
 #undef UNWIND_HINT_FUNC
 #define UNWIND_HINT_FUNC
 #endif
+
 /*
  * When a retprobed function returns, this code saves registers and
  * calls trampoline_handler() runs, which calls the kretprobe's handler.
@@ -1073,6 +1074,16 @@ asm(
 );
 NOKPROBE_SYMBOL(kretprobe_trampoline);
 
+void arch_kretprobe_fixup_return(struct pt_regs *regs,
+				 unsigned long correct_ret_addr)
+{
+	unsigned long *frame_pointer;
+	frame_pointer = ((unsigned long *)&regs->sp) + 1;
+
+	/* Replace fake return address with real one. */
+	*frame_pointer = correct_ret_addr;
+}
+
 /*
  * Called from kretprobe_trampoline
  */
@@ -1090,8 +1101,7 @@ __used __visible void trampoline_handler(struct pt_regs *regs)
 	regs->sp += sizeof(long);
 	frame_pointer = ((unsigned long *)&regs->sp) + 1;
 
-	/* Replace fake return address with real one. */
-	*frame_pointer = kretprobe_trampoline_handler(regs, frame_pointer);
+	kretprobe_trampoline_handler(regs, frame_pointer);
 	/*
 	 * Move flags to sp so that kretprobe_trapmoline can return
 	 * right after popf.
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 12677a463561..3c72df5b31dd 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1899,6 +1899,12 @@ unsigned long __weak kretprobe_find_ret_addr(struct task_struct *tsk,
 }
 NOKPROBE_SYMBOL(kretprobe_find_ret_addr);
 
+void __weak arch_kretprobe_fixup_return(struct pt_regs *regs,
+					unsigned long correct_ret_addr)
+{
+	/* Do nothing by default. */
+}
+
 unsigned long __kretprobe_trampoline_handler(struct pt_regs *regs,
 					     void *frame_pointer)
 {
@@ -1939,6 +1945,8 @@ unsigned long __kretprobe_trampoline_handler(struct pt_regs *regs,
 		first = first->next;
 	}
 
+	arch_kretprobe_fixup_return(regs, (unsigned long)correct_ret_addr);
+
 	/* Unlink all nodes for this frame. */
 	first = current->kretprobe_instances.first;
 	current->kretprobe_instances.first = node->next;
-- 
2.25.1





-- 
Masami Hiramatsu <mhiramat@kernel.org>
