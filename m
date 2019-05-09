Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCEB19309
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2019 21:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfEITtG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 May 2019 15:49:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbfEITtG (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 May 2019 15:49:06 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69E1E21744;
        Thu,  9 May 2019 19:49:03 +0000 (UTC)
Date:   Thu, 9 May 2019 15:49:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: [RFC][PATCH] ftrace/x86: Remove mcount support
Message-ID: <20190509154902.34ea14f8@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

There's two methods of enabling function tracing in Linux on x86. One is
with just "gcc -pg" and the other is "gcc -pg -mfentry". The former will use
calls to a special function "mcount" after the frame is set up in all C
functions. The latter will add calls to a special function called "fentry"
as the very first instruction of all C functions.

At compile time, there is a check to see if gcc supports, -mfentry, and if
it does, it will use that, because it is more versatile and less error prone
for function tracing.

Starting with v4.19, the minimum gcc supported to build the Linux kernel,
was raised to version 4.6. That also happens to be the first gcc version to
support -mfentry. Since on x86, using gcc versions from 4.6 and beyond will
unconditionally enable the -mfentry, it will no longer use mcount as the
method for inserting calls into the C functions of the kernel. This means
that there is no point in continuing to maintain mcount in x86.

Remove support for using mcount. This makes the code less complex, and will
also allow it to be simplified in the future.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h    |  8 +++----
 arch/x86/include/asm/livepatch.h |  3 ---
 arch/x86/kernel/ftrace_32.S      | 36 +++++---------------------------
 arch/x86/kernel/ftrace_64.S      | 28 +------------------------
 4 files changed, 9 insertions(+), 66 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index cf350639e76d..287f1f7b2e52 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -3,12 +3,10 @@
 #define _ASM_X86_FTRACE_H
 
 #ifdef CONFIG_FUNCTION_TRACER
-#ifdef CC_USING_FENTRY
-# define MCOUNT_ADDR		((unsigned long)(__fentry__))
-#else
-# define MCOUNT_ADDR		((unsigned long)(mcount))
-# define HAVE_FUNCTION_GRAPH_FP_TEST
+#ifndef CC_USING_FENTRY
+# error Compiler does not support fentry?
 #endif
+# define MCOUNT_ADDR		((unsigned long)(__fentry__))
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
 
 #ifdef CONFIG_DYNAMIC_FTRACE
diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
index ed80003ce3e2..2f2bdf0662f8 100644
--- a/arch/x86/include/asm/livepatch.h
+++ b/arch/x86/include/asm/livepatch.h
@@ -26,9 +26,6 @@
 
 static inline int klp_check_compiler_support(void)
 {
-#ifndef CC_USING_FENTRY
-	return 1;
-#endif
 	return 0;
 }
 
diff --git a/arch/x86/kernel/ftrace_32.S b/arch/x86/kernel/ftrace_32.S
index 4c8440de3355..79dcfdf9e96a 100644
--- a/arch/x86/kernel/ftrace_32.S
+++ b/arch/x86/kernel/ftrace_32.S
@@ -10,22 +10,12 @@
 #include <asm/ftrace.h>
 #include <asm/nospec-branch.h>
 
-#ifdef CC_USING_FENTRY
 # define function_hook	__fentry__
 EXPORT_SYMBOL(__fentry__)
-#else
-# define function_hook	mcount
-EXPORT_SYMBOL(mcount)
-#endif
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
-/* mcount uses a frame pointer even if CONFIG_FRAME_POINTER is not set */
-#if !defined(CC_USING_FENTRY) || defined(CONFIG_FRAME_POINTER)
-# define USING_FRAME_POINTER
-#endif
-
-#ifdef USING_FRAME_POINTER
+#ifdef CONFIG_FRAME_POINTER
 # define MCOUNT_FRAME			1	/* using frame = true  */
 #else
 # define MCOUNT_FRAME			0	/* using frame = false */
@@ -37,8 +27,7 @@ END(function_hook)
 
 ENTRY(ftrace_caller)
 
-#ifdef USING_FRAME_POINTER
-# ifdef CC_USING_FENTRY
+#ifdef CONFIG_FRAME_POINTER
 	/*
 	 * Frame pointers are of ip followed by bp.
 	 * Since fentry is an immediate jump, we are left with
@@ -49,7 +38,7 @@ ENTRY(ftrace_caller)
 	pushl	%ebp
 	movl	%esp, %ebp
 	pushl	2*4(%esp)			/* function ip */
-# endif
+
 	/* For mcount, the function ip is directly above */
 	pushl	%ebp
 	movl	%esp, %ebp
@@ -59,7 +48,7 @@ ENTRY(ftrace_caller)
 	pushl	%edx
 	pushl	$0				/* Pass NULL as regs pointer */
 
-#ifdef USING_FRAME_POINTER
+#ifdef CONFIG_FRAME_POINTER
 	/* Load parent ebp into edx */
 	movl	4*4(%esp), %edx
 #else
@@ -82,13 +71,11 @@ ftrace_call:
 	popl	%edx
 	popl	%ecx
 	popl	%eax
-#ifdef USING_FRAME_POINTER
+#ifdef CONFIG_FRAME_POINTER
 	popl	%ebp
-# ifdef CC_USING_FENTRY
 	addl	$4,%esp				/* skip function ip */
 	popl	%ebp				/* this is the orig bp */
 	addl	$4, %esp			/* skip parent ip */
-# endif
 #endif
 .Lftrace_ret:
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -133,11 +120,7 @@ ENTRY(ftrace_regs_caller)
 
 	movl	12*4(%esp), %eax		/* Load ip (1st parameter) */
 	subl	$MCOUNT_INSN_SIZE, %eax		/* Adjust ip */
-#ifdef CC_USING_FENTRY
 	movl	15*4(%esp), %edx		/* Load parent ip (2nd parameter) */
-#else
-	movl	0x4(%ebp), %edx			/* Load parent ip (2nd parameter) */
-#endif
 	movl	function_trace_op, %ecx		/* Save ftrace_pos in 3rd parameter */
 	pushl	%esp				/* Save pt_regs as 4th parameter */
 
@@ -215,13 +198,8 @@ ENTRY(ftrace_graph_caller)
 	pushl	%edx
 	movl	3*4(%esp), %eax
 	/* Even with frame pointers, fentry doesn't have one here */
-#ifdef CC_USING_FENTRY
 	lea	4*4(%esp), %edx
 	movl	$0, %ecx
-#else
-	lea	0x4(%ebp), %edx
-	movl	(%ebp), %ecx
-#endif
 	subl	$MCOUNT_INSN_SIZE, %eax
 	call	prepare_ftrace_return
 	popl	%edx
@@ -234,11 +212,7 @@ END(ftrace_graph_caller)
 return_to_handler:
 	pushl	%eax
 	pushl	%edx
-#ifdef CC_USING_FENTRY
 	movl	$0, %eax
-#else
-	movl	%ebp, %eax
-#endif
 	call	ftrace_return_to_handler
 	movl	%eax, %ecx
 	popl	%edx
diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
index 75f2b36b41a6..10eb2760ef2c 100644
--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -13,22 +13,12 @@
 	.code64
 	.section .entry.text, "ax"
 
-#ifdef CC_USING_FENTRY
 # define function_hook	__fentry__
 EXPORT_SYMBOL(__fentry__)
-#else
-# define function_hook	mcount
-EXPORT_SYMBOL(mcount)
-#endif
 
 #ifdef CONFIG_FRAME_POINTER
-# ifdef CC_USING_FENTRY
 /* Save parent and function stack frames (rip and rbp) */
 #  define MCOUNT_FRAME_SIZE	(8+16*2)
-# else
-/* Save just function stack frame (rip and rbp) */
-#  define MCOUNT_FRAME_SIZE	(8+16)
-# endif
 #else
 /* No need to save a stack frame */
 # define MCOUNT_FRAME_SIZE	0
@@ -75,17 +65,13 @@ EXPORT_SYMBOL(mcount)
 	 * fentry is called before the stack frame is set up, where as mcount
 	 * is called afterward.
 	 */
-#ifdef CC_USING_FENTRY
+
 	/* Save the parent pointer (skip orig rbp and our return address) */
 	pushq \added+8*2(%rsp)
 	pushq %rbp
 	movq %rsp, %rbp
 	/* Save the return address (now skip orig rbp, rbp and parent) */
 	pushq \added+8*3(%rsp)
-#else
-	/* Can't assume that rip is before this (unless added was zero) */
-	pushq \added+8(%rsp)
-#endif
 	pushq %rbp
 	movq %rsp, %rbp
 #endif /* CONFIG_FRAME_POINTER */
@@ -113,12 +99,7 @@ EXPORT_SYMBOL(mcount)
 	movq %rdx, RBP(%rsp)
 
 	/* Copy the parent address into %rsi (second parameter) */
-#ifdef CC_USING_FENTRY
 	movq MCOUNT_REG_SIZE+8+\added(%rsp), %rsi
-#else
-	/* %rdx contains original %rbp */
-	movq 8(%rdx), %rsi
-#endif
 
 	 /* Move RIP to its proper location */
 	movq MCOUNT_REG_SIZE+\added(%rsp), %rdi
@@ -303,15 +284,8 @@ ENTRY(ftrace_graph_caller)
 	/* Saves rbp into %rdx and fills first parameter  */
 	save_mcount_regs
 
-#ifdef CC_USING_FENTRY
 	leaq MCOUNT_REG_SIZE+8(%rsp), %rsi
 	movq $0, %rdx	/* No framepointers needed */
-#else
-	/* Save address of the return address of traced function */
-	leaq 8(%rdx), %rsi
-	/* ftrace does sanity checks against frame pointers */
-	movq (%rdx), %rdx
-#endif
 	call	prepare_ftrace_return
 
 	restore_mcount_regs
-- 
2.20.1

