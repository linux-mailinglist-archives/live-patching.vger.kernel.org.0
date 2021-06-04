Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1644539C427
	for <lists+live-patching@lfdr.de>; Sat,  5 Jun 2021 02:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhFEABv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 4 Jun 2021 20:01:51 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:50500 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhFEABv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 4 Jun 2021 20:01:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1622851205; x=1654387205;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=s3t6VihAkPp9eTSAWs95/T+GZwYoZ0V/3Fe9pqxjazo=;
  b=Nw5UXHuj19E+dPdEa8BM0g7s4n2X+pKKsiu2L0RMBPNC+hTgm30cr9vd
   PAc8kiSIAxfX7K0NDAhbzB9WbCgu8RD/KC8kQswhPEZBgMUnaRDakK7Lj
   qGYdPWLD7tNseE4VBMbVbby2iwUwiW5obE7bAFptq7jG2dUP4pWO54g9M
   s=;
X-IronPort-AV: E=Sophos;i="5.83,249,1616457600"; 
   d="scan'208";a="129358420"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 05 Jun 2021 00:00:04 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id D3003A052A;
        Fri,  4 Jun 2021 23:59:59 +0000 (UTC)
Received: from EX13D30UWC001.ant.amazon.com (10.43.162.128) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 4 Jun 2021 23:59:59 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.161.201) by
 EX13D30UWC001.ant.amazon.com (10.43.162.128) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 4 Jun 2021 23:59:58 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <linux-arm-kernel@lists.infradead.org>
CC:     <linux-kernel@vger.kernel.org>, <live-patching@vger.kernel.org>,
        <catalin.marinas@arm.com>, <will@kernel.org>,
        <mark.rutland@arm.com>, <broonie@kernel.org>,
        <madvenka@linux.microsoft.com>, <duwe@lst.de>,
        <sjitindarsingh@gmail.com>, <benh@kernel.crashing.org>,
        Suraj Jitindar Singh <surajjs@amazon.com>
Subject: [RFC PATCH 1/1] arm64: implement live patching
Date:   Fri, 4 Jun 2021 16:59:30 -0700
Message-ID: <20210604235930.603-1-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.201]
X-ClientProxiedBy: EX13D32UWA004.ant.amazon.com (10.43.160.193) To
 EX13D30UWC001.ant.amazon.com (10.43.162.128)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

It's my understanding that the two pieces of work required to enable live
patching on arm are in flight upstream;
- Reliable stack traces as implemented by Madhavan T. Venkataraman [1]
- Objtool as implemented by Julien Thierry [2]

This is the remaining part required to enable live patching on arm.
Based on work by Torsten Duwe [3]

Allocate a task flag used to represent the patch pending state for the
task. Also implement generic functions klp_arch_set_pc() &
klp_get_ftrace_location().

In klp_arch_set_pc() it is sufficient to set regs->pc as in
ftrace_common_return() the return address is loaded from the stack.

ldr     x9, [sp, #S_PC]
<snip>
ret     x9

In klp_get_ftrace_location() it is necessary to advance the address by
AARCH64_INSN_SIZE (4) to point to the BL in the callsite as 2 nops were
placed at the start of the function, one to be patched to save the LR and
another to be patched to branch to the ftrace call, and
klp_get_ftrace_location() is expected to return the address of the BL. It
may also be necessary to advance the address by another AARCH64_INSN_SIZE
if CONFIG_ARM64_BTI_KERNEL is enabled due to the instruction placed at the
branch target to satisfy BTI,

Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>

[1] https://lkml.org/lkml/2021/5/26/1212
[2] https://lkml.org/lkml/2021/3/3/1135
[3] https://lkml.org/lkml/2018/10/26/536
---
 arch/arm64/Kconfig                   |  3 ++
 arch/arm64/include/asm/livepatch.h   | 42 ++++++++++++++++++++++++++++
 arch/arm64/include/asm/thread_info.h |  4 ++-
 arch/arm64/kernel/signal.c           |  4 +++
 4 files changed, 52 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/livepatch.h

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b098dabed8c2..c4636990c01d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -187,6 +187,7 @@ config ARM64
 	select HAVE_GCC_PLUGINS
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_IRQ_TIME_ACCOUNTING
+	select HAVE_LIVEPATCH
 	select HAVE_NMI
 	select HAVE_PATA_PLATFORM
 	select HAVE_PERF_EVENTS
@@ -1946,3 +1947,5 @@ source "arch/arm64/kvm/Kconfig"
 if CRYPTO
 source "arch/arm64/crypto/Kconfig"
 endif
+
+source "kernel/livepatch/Kconfig"
diff --git a/arch/arm64/include/asm/livepatch.h b/arch/arm64/include/asm/livepatch.h
new file mode 100644
index 000000000000..72d7cd86f158
--- /dev/null
+++ b/arch/arm64/include/asm/livepatch.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * livepatch.h - arm64-specific Kernel Live Patching Core
+ */
+#ifndef _ASM_ARM64_LIVEPATCH_H
+#define _ASM_ARM64_LIVEPATCH_H
+
+#include <linux/ftrace.h>
+
+static inline void klp_arch_set_pc(struct ftrace_regs *fregs, unsigned long ip)
+{
+	struct pt_regs *regs = ftrace_get_regs(fregs);
+
+	regs->pc = ip;
+}
+
+/*
+ * klp_get_ftrace_location is expected to return the address of the BL to the
+ * relevant ftrace handler in the callsite. The location of this can vary based
+ * on several compilation options.
+ * CONFIG_DYNAMIC_FTRACE_WITH_REGS
+ *	- Inserts 2 nops on function entry the second of which is the BL
+ *	  referenced above. (See ftrace_init_nop() for the callsite sequence)
+ *	  (this is required by livepatch and must be selected)
+ * CONFIG_ARM64_BTI_KERNEL:
+ *	- Inserts a hint #0x22 on function entry if the function is called
+ *	  indirectly (to satisfy BTI requirements), which is inserted before
+ *	  the two nops from above.
+ */
+#define klp_get_ftrace_location klp_get_ftrace_location
+static inline unsigned long klp_get_ftrace_location(unsigned long faddr)
+{
+	unsigned long addr = faddr + AARCH64_INSN_SIZE;
+
+#if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL)
+	addr = ftrace_location_range(addr, addr + AARCH64_INSN_SIZE);
+#endif
+
+	return addr;
+}
+
+#endif /* _ASM_ARM64_LIVEPATCH_H */
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 6623c99f0984..cca936d53a40 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -67,6 +67,7 @@ int arch_dup_task_struct(struct task_struct *dst,
 #define TIF_UPROBE		4	/* uprobe breakpoint or singlestep */
 #define TIF_MTE_ASYNC_FAULT	5	/* MTE Asynchronous Tag Check Fault */
 #define TIF_NOTIFY_SIGNAL	6	/* signal notifications exist */
+#define TIF_PATCH_PENDING	7	/* pending live patching update */
 #define TIF_SYSCALL_TRACE	8	/* syscall trace active */
 #define TIF_SYSCALL_AUDIT	9	/* syscall auditing */
 #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */
@@ -97,11 +98,12 @@ int arch_dup_task_struct(struct task_struct *dst,
 #define _TIF_SVE		(1 << TIF_SVE)
 #define _TIF_MTE_ASYNC_FAULT	(1 << TIF_MTE_ASYNC_FAULT)
 #define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
+#define _TIF_PATCH_PENDING	(1 << TIF_PATCH_PENDING)
 
 #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
 				 _TIF_NOTIFY_RESUME | _TIF_FOREIGN_FPSTATE | \
 				 _TIF_UPROBE | _TIF_MTE_ASYNC_FAULT | \
-				 _TIF_NOTIFY_SIGNAL)
+				 _TIF_NOTIFY_SIGNAL | _TIF_PATCH_PENDING)
 
 #define _TIF_SYSCALL_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
 				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP | \
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 6237486ff6bb..d1eedb0589a7 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -18,6 +18,7 @@
 #include <linux/sizes.h>
 #include <linux/string.h>
 #include <linux/tracehook.h>
+#include <linux/livepatch.h>
 #include <linux/ratelimit.h>
 #include <linux/syscalls.h>
 
@@ -932,6 +933,9 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
 					       (void __user *)NULL, current);
 			}
 
+			if (thread_flags & _TIF_PATCH_PENDING)
+				klp_update_patch_state(current);
+
 			if (thread_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 				do_signal(regs);
 
-- 
2.17.1

