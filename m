Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3937365ED
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 10:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbjFTISq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 04:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjFTISp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 04:18:45 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C11BDD;
        Tue, 20 Jun 2023 01:18:43 -0700 (PDT)
Received: from loongson.cn (unknown [113.200.148.30])
        by gateway (Coremail) with SMTP id _____8AxnOriYJFkyh4HAA--.14406S3;
        Tue, 20 Jun 2023 16:18:42 +0800 (CST)
Received: from bogon.localdomain (unknown [113.200.148.30])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxReThYJFkJ3AhAA--.28832S2;
        Tue, 20 Jun 2023 16:18:41 +0800 (CST)
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
Subject: [RFC PATCH v1 20/23] LoongArch: Move some data definitions into the .data section
Date:   Tue, 20 Jun 2023 16:18:29 +0800
Message-Id: <1687249112-2790-1-git-send-email-tangyouling@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf8CxReThYJFkJ3AhAA--.28832S2
X-CM-SenderInfo: 5wdqw5prxox03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoW7ZF1fJFyrZw1kAw13Kr1xWFX_yoW8Aw4rpr
        13A34kKr48Gr1UJa4UXa4ku3yUJa4DWw43Wa1qk3s5GwnFvF1DX3W0vr92qFyvv3yxKr4F
        qFn5trs2v3WUCwbCm3ZEXasCq-sJn29KB7ZKAUJUUUUx529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVWxJr0_GcWln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
        xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r12
        6r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x
        0EwIxGrwACjcxG6xCI17CEII8vrVW3JVW8Jr1lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IY
        c2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxV
        Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
        6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6x
        kF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AK
        xVW8Jr0_Cr1UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyT
        uYvjxUDqQDUUUUU
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Make part of the data definition into the .data section, avoid objtool
to detect "unreachable instruction" warning.

At the same time, removing unreachable instruction flow operations
(b process_entry).

Co-developed-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Youling Tang <tangyouling@loongson.cn>
---
 arch/loongarch/kernel/genex.S           | 2 ++
 arch/loongarch/kernel/relocate_kernel.S | 7 +++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/kernel/genex.S b/arch/loongarch/kernel/genex.S
index 44ff1ff64260..883b718b5ffe 100644
--- a/arch/loongarch/kernel/genex.S
+++ b/arch/loongarch/kernel/genex.S
@@ -77,7 +77,9 @@ SYM_FUNC_END(except_vec_cex)
 	668:
 	RESTORE_ALL_AND_RET
 	SYM_FUNC_END(handle_\exception)
+	.pushsection	".data", "aw", %progbits
 	SYM_DATA(unwind_hint_\exception, .word 668b - 666b)
+	.popsection
 	.endm
 
 	BUILD_HANDLER ade ade badv
diff --git a/arch/loongarch/kernel/relocate_kernel.S b/arch/loongarch/kernel/relocate_kernel.S
index d0123fa2b511..1ea3df967b46 100644
--- a/arch/loongarch/kernel/relocate_kernel.S
+++ b/arch/loongarch/kernel/relocate_kernel.S
@@ -75,7 +75,6 @@ copy_word:
 	LONG_ADDI	s5, s5, -1
 	beqz		s5, process_entry
 	b		copy_word
-	b		process_entry
 
 done:
 	ibar		0
@@ -112,6 +111,6 @@ SYM_CODE_END(kexec_smp_wait)
 
 relocate_new_kernel_end:
 
-SYM_DATA_START(relocate_new_kernel_size)
-	PTR		relocate_new_kernel_end - relocate_new_kernel
-SYM_DATA_END(relocate_new_kernel_size)
+.pushsection	".data", "aw", %progbits
+SYM_DATA(relocate_new_kernel_size, .long relocate_new_kernel_end - relocate_new_kernel)
+.popsection
-- 
2.39.2

