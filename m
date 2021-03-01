Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1249327D54
	for <lists+live-patching@lfdr.de>; Mon,  1 Mar 2021 12:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbhCALbi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 1 Mar 2021 06:31:38 -0500
Received: from mail.loongson.cn ([114.242.206.163]:50514 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233717AbhCALbX (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 1 Mar 2021 06:31:23 -0500
Received: from loongson.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9AxmdQ50Dxgz20SAA--.23162S2;
        Mon, 01 Mar 2021 19:30:01 +0800 (CST)
From:   Jinyang He <hejinyang@loongson.cn>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Xuefeng Li <lixuefeng@loongson.cn>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [PATCH RFC] MIPS: livepatch: Add LIVEPATCH basic code
Date:   Mon,  1 Mar 2021 19:30:01 +0800
Message-Id: <1614598201-17858-1-git-send-email-hejinyang@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9AxmdQ50Dxgz20SAA--.23162S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGr1kGw1Utw18Cw45KFyxGrg_yoW5Kr17pF
        Z8A3Z5Gr4Uur93GFya9w1Y9ry3Jas5WrWakFyxW34Fvas8Xa48Xrn7Krn8AryUXrWkta4x
        uFyYgr1UCr42vaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkq14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8KwCF
        04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
        1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUUAhltUUUUU==
X-CM-SenderInfo: pkhmx0p1dqwqxorr0wxvrqhubq/
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Add the basic code of livepatch. livepatch is temporarily unavailable.
Two core functions are missing, one is DYNAMIC_FTRACE_WITH_REGS, and
another is save_stack_trace_tsk_reliable().
`Huang Pei <huangpei@loongson.cn>` is doing for ftrace. He will use
`-fpatchable-function-entry` to achieve more complete ftrace.
save_stack_trace_tsk_reliable() currently has difficulties. This function
may be improved in the future, but that seems to be a long time away.
This is also the reason for delivering this RFC. Hope to get any help.

Signed-off-by: Jinyang He <hejinyang@loongson.cn>
---
 arch/mips/Kconfig                   |  1 +
 arch/mips/include/asm/livepatch.h   | 28 ++++++++++++++++++++++++++++
 arch/mips/include/asm/thread_info.h |  1 +
 arch/mips/kernel/mcount.S           |  9 +++++++++
 4 files changed, 39 insertions(+)
 create mode 100644 arch/mips/include/asm/livepatch.h

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 47715cb..8ef92dd 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -478,6 +478,7 @@ config MACH_LOONGSON64
 	select CEVT_R4K
 	select CPU_HAS_WB
 	select FORCE_PCI
+	select HAVE_LIVEPATCH
 	select ISA
 	select I8259
 	select IRQ_MIPS_CPU
diff --git a/arch/mips/include/asm/livepatch.h b/arch/mips/include/asm/livepatch.h
new file mode 100644
index 0000000..26e1212
--- /dev/null
+++ b/arch/mips/include/asm/livepatch.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * livepatch.h - mips-specific Kernel Live Patching Core
+ */
+
+#ifndef _ASM_MIPS_LIVEPATCH_H
+#define _ASM_MIPS_LIVEPATCH_H
+
+#include <linux/ftrace.h>
+#include <linux/kallsyms.h>
+
+static inline void klp_arch_set_pc(struct ftrace_regs *fregs, unsigned long ip)
+{
+	struct pt_regs *regs = ftrace_get_regs(fregs);
+
+	regs->regs[31] = ip;
+}
+
+#define klp_get_ftrace_location klp_get_ftrace_location
+static inline unsigned long klp_get_ftrace_location(unsigned long faddr)
+{
+	unsigned long func_size, offset;
+
+	kallsyms_lookup_size_offset(faddr, &func_size, &offset);
+	return ftrace_location_range(faddr, faddr + func_size);
+}
+
+#endif
diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
index e2c352d..1e78359 100644
--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -117,6 +117,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_UPROBE		6	/* breakpointed or singlestepping */
 #define TIF_NOTIFY_SIGNAL	7	/* signal notifications exist */
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
+#define TIF_PATCH_PENDING	10	/* pending live patching update */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_NOHZ		19	/* in adaptive nohz mode */
diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
index cff52b2..8bf4c6a 100644
--- a/arch/mips/kernel/mcount.S
+++ b/arch/mips/kernel/mcount.S
@@ -113,6 +113,15 @@ ftrace_stub:
 	RETURN_BACK
 	END(ftrace_caller)
 
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+NESTED(ftrace_regs_caller, PT_SIZE, ra)
+/* ftrace_regs_caller body */
+#ifdef CONFIG_LIVEPATCH
+/* Restore sp register */
+#endif
+	RETURN_BACK
+	END(ftrace_regs_caller)
+#endif
 #else	/* ! CONFIG_DYNAMIC_FTRACE */
 
 NESTED(_mcount, PT_SIZE, ra)
-- 
2.1.0

