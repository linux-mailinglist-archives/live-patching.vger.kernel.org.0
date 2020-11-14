Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AAB2B2E08
	for <lists+live-patching@lfdr.de>; Sat, 14 Nov 2020 16:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgKNPfC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 14 Nov 2020 10:35:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:48560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbgKNPfB (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Sat, 14 Nov 2020 10:35:01 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AB9622280;
        Sat, 14 Nov 2020 15:35:00 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kdxZr-000HlI-68; Sat, 14 Nov 2020 10:34:59 -0500
Message-ID: <20201114153459.070853484@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 14 Nov 2020 10:32:24 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, live-patching@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Miroslav Benes <mbenes@suse.cz>
Subject: [for-next][PATCH 3/4] livepatch: Use the default ftrace_ops instead of REGS when ARGS is
 available
References: <20201114153221.050150744@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS is available, the ftrace call
will be able to set the ip of the calling function. This will improve the
performance of live kernel patching where it does not need all the regs to
be stored just to change the instruction pointer.

If all archs that support live kernel patching also support
HAVE_DYNAMIC_FTRACE_WITH_ARGS, then the architecture specific function
klp_arch_set_pc() could be made generic.

It is possible that an arch can support HAVE_DYNAMIC_FTRACE_WITH_ARGS but
not HAVE_DYNAMIC_FTRACE_WITH_REGS and then have access to live patching.

Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: live-patching@vger.kernel.org
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 arch/powerpc/include/asm/livepatch.h | 4 +++-
 arch/s390/include/asm/livepatch.h    | 5 ++++-
 arch/x86/include/asm/ftrace.h        | 3 +++
 arch/x86/include/asm/livepatch.h     | 4 ++--
 arch/x86/kernel/ftrace_64.S          | 4 ++++
 include/linux/ftrace.h               | 7 +++++++
 kernel/livepatch/Kconfig             | 2 +-
 kernel/livepatch/patch.c             | 9 +++++----
 8 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/include/asm/livepatch.h b/arch/powerpc/include/asm/livepatch.h
index 4a3d5d25fed5..ae25e6e72997 100644
--- a/arch/powerpc/include/asm/livepatch.h
+++ b/arch/powerpc/include/asm/livepatch.h
@@ -12,8 +12,10 @@
 #include <linux/sched/task_stack.h>
 
 #ifdef CONFIG_LIVEPATCH
-static inline void klp_arch_set_pc(struct pt_regs *regs, unsigned long ip)
+static inline void klp_arch_set_pc(struct ftrace_regs *fregs, unsigned long ip)
 {
+	struct pt_regs *regs = ftrace_get_regs(fregs);
+
 	regs->nip = ip;
 }
 
diff --git a/arch/s390/include/asm/livepatch.h b/arch/s390/include/asm/livepatch.h
index 818612b784cd..d578a8c76676 100644
--- a/arch/s390/include/asm/livepatch.h
+++ b/arch/s390/include/asm/livepatch.h
@@ -11,10 +11,13 @@
 #ifndef ASM_LIVEPATCH_H
 #define ASM_LIVEPATCH_H
 
+#include <linux/ftrace.h>
 #include <asm/ptrace.h>
 
-static inline void klp_arch_set_pc(struct pt_regs *regs, unsigned long ip)
+static inline void klp_arch_set_pc(struct ftrace_regs *fregs, unsigned long ip)
 {
+	struct pt_regs *regs = ftrace_get_regs(fregs);
+
 	regs->psw.addr = ip;
 }
 
diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index e00fe88146e0..9f3130f40807 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -54,6 +54,9 @@ arch_ftrace_get_regs(struct ftrace_regs *fregs)
 		return NULL;
 	return &fregs->regs;
 }
+
+#define ftrace_instruction_pointer_set(fregs, _ip)	\
+	do { (fregs)->regs.ip = (_ip); } while (0)
 #endif
 
 #ifdef CONFIG_DYNAMIC_FTRACE
diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
index 1fde1ab6559e..7c5cc6660e4b 100644
--- a/arch/x86/include/asm/livepatch.h
+++ b/arch/x86/include/asm/livepatch.h
@@ -12,9 +12,9 @@
 #include <asm/setup.h>
 #include <linux/ftrace.h>
 
-static inline void klp_arch_set_pc(struct pt_regs *regs, unsigned long ip)
+static inline void klp_arch_set_pc(struct ftrace_regs *fregs, unsigned long ip)
 {
-	regs->ip = ip;
+	ftrace_instruction_pointer_set(fregs, ip);
 }
 
 #endif /* _ASM_X86_LIVEPATCH_H */
diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
index 60e3b64f5ea6..0d54099c2a3a 100644
--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -157,6 +157,10 @@ SYM_INNER_LABEL(ftrace_caller_op_ptr, SYM_L_GLOBAL)
 SYM_INNER_LABEL(ftrace_call, SYM_L_GLOBAL)
 	call ftrace_stub
 
+	/* Handlers can change the RIP */
+	movq RIP(%rsp), %rax
+	movq %rax, MCOUNT_REG_SIZE(%rsp)
+
 	restore_mcount_regs
 
 	/*
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 588ea7023a7a..9a8ce28e4485 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -97,6 +97,13 @@ struct ftrace_regs {
 };
 #define arch_ftrace_get_regs(fregs) (&(fregs)->regs)
 
+/*
+ * ftrace_instruction_pointer_set() is to be defined by the architecture
+ * if to allow setting of the instruction pointer from the ftrace_regs
+ * when HAVE_DYNAMIC_FTRACE_WITH_ARGS is set and it supports
+ * live kernel patching.
+ */
+#define ftrace_instruction_pointer_set(fregs, ip) do { } while (0)
 #endif /* CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS */
 
 static __always_inline struct pt_regs *ftrace_get_regs(struct ftrace_regs *fregs)
diff --git a/kernel/livepatch/Kconfig b/kernel/livepatch/Kconfig
index 54102deb50ba..53d51ed619a3 100644
--- a/kernel/livepatch/Kconfig
+++ b/kernel/livepatch/Kconfig
@@ -6,7 +6,7 @@ config HAVE_LIVEPATCH
 
 config LIVEPATCH
 	bool "Kernel Live Patching"
-	depends on DYNAMIC_FTRACE_WITH_REGS
+	depends on DYNAMIC_FTRACE_WITH_REGS || DYNAMIC_FTRACE_WITH_ARGS
 	depends on MODULES
 	depends on SYSFS
 	depends on KALLSYMS_ALL
diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
index f89f9e7e9b07..e8029aea67f1 100644
--- a/kernel/livepatch/patch.c
+++ b/kernel/livepatch/patch.c
@@ -42,7 +42,6 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 				       struct ftrace_ops *fops,
 				       struct ftrace_regs *fregs)
 {
-	struct pt_regs *regs = ftrace_get_regs(fregs);
 	struct klp_ops *ops;
 	struct klp_func *func;
 	int patch_state;
@@ -118,7 +117,7 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 	if (func->nop)
 		goto unlock;
 
-	klp_arch_set_pc(regs, (unsigned long)func->new_func);
+	klp_arch_set_pc(fregs, (unsigned long)func->new_func);
 
 unlock:
 	preempt_enable_notrace();
@@ -200,8 +199,10 @@ static int klp_patch_func(struct klp_func *func)
 			return -ENOMEM;
 
 		ops->fops.func = klp_ftrace_handler;
-		ops->fops.flags = FTRACE_OPS_FL_SAVE_REGS |
-				  FTRACE_OPS_FL_DYNAMIC |
+		ops->fops.flags = FTRACE_OPS_FL_DYNAMIC |
+#ifndef CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS
+				  FTRACE_OPS_FL_SAVE_REGS |
+#endif
 				  FTRACE_OPS_FL_IPMODIFY |
 				  FTRACE_OPS_FL_PERMANENT;
 
-- 
2.28.0


