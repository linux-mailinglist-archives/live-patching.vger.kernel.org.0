Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23FCA4F89B5
	for <lists+live-patching@lfdr.de>; Fri,  8 Apr 2022 00:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiDGUkL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 7 Apr 2022 16:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiDGUj4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 7 Apr 2022 16:39:56 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23978354D0B;
        Thu,  7 Apr 2022 13:26:08 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 3F0EA20BE4A2;
        Thu,  7 Apr 2022 13:26:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3F0EA20BE4A2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1649363168;
        bh=1f354olQC82jt6SKYXp7qOC11JdNZtSHsPWQ+YANWz4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Mr+4sZOPJJ4ze0MzCAM8sWBqpc1ChwRlWwhuQWpM+3LQ2oMGgwPO07iENgnKGLMhH
         qVn40PS2Fv/tMaFsh36C01v6AxLahKYjfuyLEKJTxtkT2V9epGseQlnqGfPCxVfSB/
         PzlBnPjsZbY7+tm4o7VN9PhMqHN957uSd42016nE=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v1 8/9] dwarf: Miscellaneous changes required for enabling livepatch
Date:   Thu,  7 Apr 2022 15:25:17 -0500
Message-Id: <20220407202518.19780-9-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407202518.19780-1-madvenka@linux.microsoft.com>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

	- Create arch/arm64/include/asm/livepatch.h and define
	  klp_arch_set_pc() and klp_get_ftrace_location() which
	  are required for livepatch.

	- Define TIF_PATCH_PENDING in arch/arm64/include/asm/thread_info.h
	  for livepatch.

	- Check TIF_PATCH_PENDING in do_notify_resume() to patch the
	  current task for livepatch.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/arm64/include/asm/livepatch.h   | 42 ++++++++++++++++++++++++++++
 arch/arm64/include/asm/thread_info.h |  4 ++-
 arch/arm64/kernel/signal.c           |  4 +++
 3 files changed, 49 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/livepatch.h

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
index e1317b7c4525..a1d8999dbdcc 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -68,6 +68,7 @@ int arch_dup_task_struct(struct task_struct *dst,
 #define TIF_UPROBE		4	/* uprobe breakpoint or singlestep */
 #define TIF_MTE_ASYNC_FAULT	5	/* MTE Asynchronous Tag Check Fault */
 #define TIF_NOTIFY_SIGNAL	6	/* signal notifications exist */
+#define TIF_PATCH_PENDING	7	/* pending live patching update */
 #define TIF_SYSCALL_TRACE	8	/* syscall trace active */
 #define TIF_SYSCALL_AUDIT	9	/* syscall auditing */
 #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */
@@ -98,11 +99,12 @@ int arch_dup_task_struct(struct task_struct *dst,
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
index 8f6372b44b65..b42dffc71fb0 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -18,6 +18,7 @@
 #include <linux/sizes.h>
 #include <linux/string.h>
 #include <linux/tracehook.h>
+#include <linux/livepatch.h>
 #include <linux/ratelimit.h>
 #include <linux/syscalls.h>
 
@@ -937,6 +938,9 @@ void do_notify_resume(struct pt_regs *regs, unsigned long thread_flags)
 					       (void __user *)NULL, current);
 			}
 
+			if (thread_flags & _TIF_PATCH_PENDING)
+				klp_update_patch_state(current);
+
 			if (thread_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 				do_signal(regs);
 
-- 
2.25.1

