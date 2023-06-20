Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8037673655B
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 09:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbjFTHxi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 03:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbjFTHxZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 03:53:25 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E5CE1738;
        Tue, 20 Jun 2023 00:53:06 -0700 (PDT)
Received: from loongson.cn (unknown [113.200.148.30])
        by gateway (Coremail) with SMTP id _____8Dxi+qtWpFkTBwHAA--.14445S3;
        Tue, 20 Jun 2023 15:52:13 +0800 (CST)
Received: from bogon.localdomain (unknown [113.200.148.30])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxauWoWpFkdmghAA--.28374S6;
        Tue, 20 Jun 2023 15:52:12 +0800 (CST)
From:   Youling Tang <tangyouling@loongson.cn>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        madvenka@linux.microsoft.com
Cc:     chenzhongjin@huawei.com, WANG Xuerui <kernel@xen0n.name>,
        Xi Ruoyao <xry111@xry111.site>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        tangyouling00@gmail.com, youling.tang@outlook.com,
        Jinyang He <hejinyang@loongson.cn>
Subject: [RFC PATCH v1 19/23] LoongArch: Annotate unwind_hint
Date:   Tue, 20 Jun 2023 15:52:06 +0800
Message-Id: <1687247526-32258-5-git-send-email-tangyouling@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1687247526-32258-1-git-send-email-tangyouling@loongson.cn>
References: <1687247526-32258-1-git-send-email-tangyouling@loongson.cn>
X-CM-TRANSID: AQAAf8AxauWoWpFkdmghAA--.28374S6
X-CM-SenderInfo: 5wdqw5prxox03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoWxCw47Wry3uF4DXFW3tF45XFc_yoW5KFWrpF
        nrZrn7JrZYgrn7Aw1DJa4Y9rWUJw1DWw1agF1qka4rC3ZFqr15Xr1kZr1qgF1qqa1rKw40
        gFyFgwsFqa1UJacCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUm2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E
        14v26F4UJVW0owAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
        xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
        Gryq6s0DMcIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0x
        vY0x0EwIxGrwACjcxG6xCI17CEII8vrVW3JVW8Jr1lc7CjxVAaw2AFwI0_JF0_Jw1l42xK
        82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2
        IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v2
        6r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_tr0E3s1lIxAIcVC0I7IYx2
        IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2
        jsIE14v26r4UJVWxJr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvj
        DU0xZFpf9x07b3iihUUUUU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Some assembly symbols contain code that might be executed with an
unspecified stack state (e.g. invalid stack pointer,no stackframe, ...).

Annotate those symbol with UNWIND_HINT_EMPTY to let objtool be aware of
them.

When taking an exception/interrupt, add UNWIND_HINT_REGS to indicate
from which point the pt_regs is on stack.

Whether returning to userland or creating a new task, sp is
pointing to a pt_regs frame, add UNWIND_HINT_REGS after that.

Co-developed-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Youling Tang <tangyouling@loongson.cn>
---
 arch/loongarch/include/asm/stackframe.h | 3 +++
 arch/loongarch/kernel/entry.S           | 2 ++
 arch/loongarch/kernel/head.S            | 1 +
 arch/loongarch/kernel/relocate_kernel.S | 5 +++++
 4 files changed, 11 insertions(+)

diff --git a/arch/loongarch/include/asm/stackframe.h b/arch/loongarch/include/asm/stackframe.h
index 7df80e6ae9d2..ab16f2d10257 100644
--- a/arch/loongarch/include/asm/stackframe.h
+++ b/arch/loongarch/include/asm/stackframe.h
@@ -13,6 +13,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/loongarch.h>
 #include <asm/thread_info.h>
+#include <asm/unwind_hints.h>
 
 /* Make the addition of cfi info a little easier. */
 	.macro cfi_rel_offset reg offset=0 docfi=0
@@ -158,6 +159,7 @@
 	cfi_st  u0, PT_R21, \docfi
 	csrrd	u0, PERCPU_BASE_KS
 9:
+	UNWIND_HINT_REGS
 	.endm
 
 	.macro	SAVE_ALL docfi=0
@@ -215,6 +217,7 @@
 
 	.macro	RESTORE_SP_AND_RET docfi=0
 	cfi_ld	sp, PT_R3, \docfi
+	UNWIND_HINT_FUNC
 	ertn
 	.endm
 
diff --git a/arch/loongarch/kernel/entry.S b/arch/loongarch/kernel/entry.S
index d737e3cf42d3..458d4e8e126f 100644
--- a/arch/loongarch/kernel/entry.S
+++ b/arch/loongarch/kernel/entry.S
@@ -70,6 +70,7 @@ SYM_FUNC_END(handle_syscall)
 _ASM_NOKPROBE(handle_syscall)
 
 SYM_CODE_START(ret_from_fork)
+	UNWIND_HINT_REGS
 	bl		schedule_tail		# a0 = struct task_struct *prev
 	move		a0, sp
 	bl 		syscall_exit_to_user_mode
@@ -79,6 +80,7 @@ SYM_CODE_START(ret_from_fork)
 SYM_CODE_END(ret_from_fork)
 
 SYM_CODE_START(ret_from_kernel_thread)
+	UNWIND_HINT_REGS
 	bl		schedule_tail		# a0 = struct task_struct *prev
 	move		a0, s1
 	jirl		ra, s0, 0
diff --git a/arch/loongarch/kernel/head.S b/arch/loongarch/kernel/head.S
index aa64b179744f..73e5ec0006bb 100644
--- a/arch/loongarch/kernel/head.S
+++ b/arch/loongarch/kernel/head.S
@@ -43,6 +43,7 @@ SYM_DATA(kernel_offset, .long kernel_offset - _text);
 	.align 12
 
 SYM_CODE_START(kernel_entry)			# kernel entry point
+	UNWIND_HINT_EMPTY
 
 	/* Config direct window and set PG */
 	li.d		t0, CSR_DMW0_INIT	# UC, PLV0, 0x8000 xxxx xxxx xxxx
diff --git a/arch/loongarch/kernel/relocate_kernel.S b/arch/loongarch/kernel/relocate_kernel.S
index d13252553a7c..d0123fa2b511 100644
--- a/arch/loongarch/kernel/relocate_kernel.S
+++ b/arch/loongarch/kernel/relocate_kernel.S
@@ -13,8 +13,11 @@
 #include <asm/loongarch.h>
 #include <asm/stackframe.h>
 #include <asm/addrspace.h>
+#include <asm/unwind_hints.h>
 
 SYM_CODE_START(relocate_new_kernel)
+	UNWIND_HINT_EMPTY
+
 	/*
 	 * a0: EFI boot flag for the new kernel
 	 * a1: Command line pointer for the new kernel
@@ -91,6 +94,8 @@ SYM_CODE_END(relocate_new_kernel)
  * then start at the entry point from LOONGARCH_IOCSR_MBUF0.
  */
 SYM_CODE_START(kexec_smp_wait)
+	UNWIND_HINT_EMPTY
+
 1:	li.w		t0, 0x100			/* wait for init loop */
 2:	addi.w		t0, t0, -1			/* limit mailbox access */
 	bnez		t0, 2b
-- 
2.39.2

