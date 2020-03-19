Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2262F18B09F
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2020 10:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgCSJ4O (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 19 Mar 2020 05:56:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:35502 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbgCSJ4N (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 19 Mar 2020 05:56:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6CB58AF85;
        Thu, 19 Mar 2020 09:56:11 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, jpoimboe@redhat.com
Cc:     x86@kernel.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jslaby@suse.cz, andrew.cooper3@citrix.com,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH v2 2/2] x86/xen: Make the secondary CPU idle tasks reliable
Date:   Thu, 19 Mar 2020 10:56:06 +0100
Message-Id: <20200319095606.23627-3-mbenes@suse.cz>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200319095606.23627-1-mbenes@suse.cz>
References: <20200319095606.23627-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The unwinder reports the secondary CPU idle tasks' stack on XEN PV as
unreliable, which affects at least live patching.
cpu_initialize_context() sets up the context of the CPU through
VCPUOP_initialise hypercall. After it is woken up, the idle task starts
in cpu_bringup_and_idle() function and its stack starts at the offset
right below pt_regs. The unwinder correctly detects the end of stack
there but it is confused by NULL return address in the last frame.

Introduce a wrapper in assembly, which just calls
cpu_bringup_and_idle(). The return address is thus pushed on the stack
and the wrapper contains the annotation hint for the unwinder regarding
the stack state.

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
 arch/x86/xen/smp_pv.c   | 3 ++-
 arch/x86/xen/xen-head.S | 8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/smp_pv.c b/arch/x86/xen/smp_pv.c
index 802ee5bba66c..6b88cdcbef8f 100644
--- a/arch/x86/xen/smp_pv.c
+++ b/arch/x86/xen/smp_pv.c
@@ -53,6 +53,7 @@ static DEFINE_PER_CPU(struct xen_common_irq, xen_irq_work) = { .irq = -1 };
 static DEFINE_PER_CPU(struct xen_common_irq, xen_pmu_irq) = { .irq = -1 };
 
 static irqreturn_t xen_irq_work_interrupt(int irq, void *dev_id);
+extern unsigned char asm_cpu_bringup_and_idle[];
 
 static void cpu_bringup(void)
 {
@@ -309,7 +310,7 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	 * pointing just below where pt_regs would be if it were a normal
 	 * kernel entry.
 	 */
-	ctxt->user_regs.eip = (unsigned long)cpu_bringup_and_idle;
+	ctxt->user_regs.eip = (unsigned long)asm_cpu_bringup_and_idle;
 	ctxt->flags = VGCF_IN_KERNEL;
 	ctxt->user_regs.eflags = 0x1000; /* IOPL_RING1 */
 	ctxt->user_regs.ds = __USER_DS;
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index edc776af0e0a..9dc6f9a420a8 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -58,6 +58,14 @@ SYM_CODE_START(startup_xen)
 	call xen_start_kernel
 SYM_CODE_END(startup_xen)
 	__FINIT
+
+.pushsection .text
+SYM_CODE_START(asm_cpu_bringup_and_idle)
+	UNWIND_HINT_EMPTY
+
+	call cpu_bringup_and_idle
+SYM_CODE_END(asm_cpu_bringup_and_idle)
+.popsection
 #endif
 
 .pushsection .text
-- 
2.25.1

