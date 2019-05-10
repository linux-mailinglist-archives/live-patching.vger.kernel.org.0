Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 010ED1A1A5
	for <lists+live-patching@lfdr.de>; Fri, 10 May 2019 18:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfEJQim (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 10 May 2019 12:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727660AbfEJQil (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 10 May 2019 12:38:41 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03805217F5;
        Fri, 10 May 2019 16:38:41 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hP8Xg-0004mP-4K; Fri, 10 May 2019 12:38:40 -0400
Message-Id: <20190510163840.022020606@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 10 May 2019 12:35:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
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
Subject: [RFC][PATCH 1/2 v2] ftrace/x86_32: Remove support for non DYNAMIC_FTRACE
References: <20190510163519.794235443@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When DYNAMIC_FTRACE is enabled in the kernel, all the functions that can be
traced by the function tracer have a "nop" placeholder at the start of the
function. When function tracing is enabled, the nop is converted into a call
to the tracing infrastructure where the functions get traced. This also
allows for specifying specific functions to trace, and a lot of
infrastructure is built on top of this.

When DYNAMIC_FTRACE is not enabled, all the functions have a call to the
ftrace trampoline. A check is made to see if a function pointer is the
ftrace_stub or not, and if it is not, it calls the function pointer to trace
the code. This adds over 10% overhead to the kernel even when tracing is
disabled.

When an architecture supports DYNAMIC_FTRACE there really is no reason to
use the static tracing. I have kept non DYNAMIC_FTRACE available in x86 so
that the generic code for non DYNAMIC_FTRACE can be tested. There is no
reason to support non DYNAMIC_FTRACE for both x86_64 and x86_32. As the non
DYNAMIC_FTRACE for x86_32 does not even support fentry, and we want to
remove mcount completely, there's no reason to keep non DYNAMIC_FTRACE
around for x86_32.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 arch/x86/Kconfig            | 11 +++++++++++
 arch/x86/kernel/ftrace_32.S | 39 -------------------------------------
 2 files changed, 11 insertions(+), 39 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5ad92419be19..0544041ae3a2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -31,6 +31,17 @@ config X86_64
 	select X86_DEV_DMA_OPS
 	select ARCH_HAS_SYSCALL_WRAPPER
 
+config FORCE_DYNAMIC_FTRACE
+	def_bool y
+	depends on X86_32
+	depends on FUNCTION_TRACER
+	select DYNAMIC_FTRACE
+	help
+	 We keep the static function tracing (!DYNAMIC_FTRACE) around
+	 in order to test the non static function tracing in the
+	 generic code, as other architectures still use it. But we
+	 only need to keep it around for x86_64. No need to keep it
+	 for x86_32. For x86_32, force DYNAMIC_FTRACE. 
 #
 # Arch settings
 #
diff --git a/arch/x86/kernel/ftrace_32.S b/arch/x86/kernel/ftrace_32.S
index 4c8440de3355..459e6b4a19bc 100644
--- a/arch/x86/kernel/ftrace_32.S
+++ b/arch/x86/kernel/ftrace_32.S
@@ -18,8 +18,6 @@ EXPORT_SYMBOL(__fentry__)
 EXPORT_SYMBOL(mcount)
 #endif
 
-#ifdef CONFIG_DYNAMIC_FTRACE
-
 /* mcount uses a frame pointer even if CONFIG_FRAME_POINTER is not set */
 #if !defined(CC_USING_FENTRY) || defined(CONFIG_FRAME_POINTER)
 # define USING_FRAME_POINTER
@@ -170,43 +168,6 @@ GLOBAL(ftrace_regs_call)
 	lea	3*4(%esp), %esp			/* Skip orig_ax, ip and cs */
 
 	jmp	.Lftrace_ret
-#else /* ! CONFIG_DYNAMIC_FTRACE */
-
-ENTRY(function_hook)
-	cmpl	$__PAGE_OFFSET, %esp
-	jb	ftrace_stub			/* Paging not enabled yet? */
-
-	cmpl	$ftrace_stub, ftrace_trace_function
-	jnz	.Ltrace
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	cmpl	$ftrace_stub, ftrace_graph_return
-	jnz	ftrace_graph_caller
-
-	cmpl	$ftrace_graph_entry_stub, ftrace_graph_entry
-	jnz	ftrace_graph_caller
-#endif
-.globl ftrace_stub
-ftrace_stub:
-	ret
-
-	/* taken from glibc */
-.Ltrace:
-	pushl	%eax
-	pushl	%ecx
-	pushl	%edx
-	movl	0xc(%esp), %eax
-	movl	0x4(%ebp), %edx
-	subl	$MCOUNT_INSN_SIZE, %eax
-
-	movl	ftrace_trace_function, %ecx
-	CALL_NOSPEC %ecx
-
-	popl	%edx
-	popl	%ecx
-	popl	%eax
-	jmp	ftrace_stub
-END(function_hook)
-#endif /* CONFIG_DYNAMIC_FTRACE */
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 ENTRY(ftrace_graph_caller)
-- 
2.20.1


