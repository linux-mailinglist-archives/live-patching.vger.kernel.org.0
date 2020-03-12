Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C49321832B4
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2020 15:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbgCLOUN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 12 Mar 2020 10:20:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:58400 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727390AbgCLOUM (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 12 Mar 2020 10:20:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CD2FCB2FA;
        Thu, 12 Mar 2020 14:20:10 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, jpoimboe@redhat.com
Cc:     x86@kernel.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jslaby@suse.cz, Miroslav Benes <mbenes@suse.cz>
Subject: [RFC PATCH 2/2] x86/xen: Make the secondary CPU idle tasks reliable
Date:   Thu, 12 Mar 2020 15:20:07 +0100
Message-Id: <20200312142007.11488-3-mbenes@suse.cz>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200312142007.11488-1-mbenes@suse.cz>
References: <20200312142007.11488-1-mbenes@suse.cz>
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

RFC: I haven't found the way to teach the unwinder about the state of
the stack there. Thus the ugly hack using assembly. Similar to what
startup_xen() has got for boot CPU.

It introduces objtool "unreachable instruction" warning just right after
the jump to cpu_bringup_and_idle(). It should show the idea what needs
to be done though, I think. Ideas welcome.

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
 arch/x86/xen/smp_pv.c   |  3 ++-
 arch/x86/xen/xen-head.S | 10 ++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

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
index 642f346bfe02..c9a9c0bb79ed 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -56,6 +56,16 @@ SYM_CODE_START(startup_xen)
 1:
 SYM_CODE_END(startup_xen)
 	__FINIT
+
+.pushsection .text
+SYM_CODE_START(asm_cpu_bringup_and_idle)
+	UNWIND_HINT_EMPTY
+
+	push $1f
+	jmp cpu_bringup_and_idle
+1:
+SYM_CODE_END(asm_cpu_bringup_and_idle)
+.popsection
 #endif
 
 .pushsection .text
-- 
2.25.1

