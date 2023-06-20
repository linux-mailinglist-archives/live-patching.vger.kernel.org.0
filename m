Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA2773655A
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 09:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbjFTHxh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 03:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbjFTHxY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 03:53:24 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EAB83E72;
        Tue, 20 Jun 2023 00:53:02 -0700 (PDT)
Received: from loongson.cn (unknown [113.200.148.30])
        by gateway (Coremail) with SMTP id _____8DxRumsWpFkQhwHAA--.12738S3;
        Tue, 20 Jun 2023 15:52:12 +0800 (CST)
Received: from bogon.localdomain (unknown [113.200.148.30])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxauWoWpFkdmghAA--.28374S5;
        Tue, 20 Jun 2023 15:52:11 +0800 (CST)
From:   Youling Tang <tangyouling@loongson.cn>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        madvenka@linux.microsoft.com
Cc:     chenzhongjin@huawei.com, WANG Xuerui <kernel@xen0n.name>,
        Xi Ruoyao <xry111@xry111.site>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        tangyouling00@gmail.com, youling.tang@outlook.com
Subject: [RFC PATCH v1 18/23] LoongArch: Fix fpu.S objtool warning
Date:   Tue, 20 Jun 2023 15:52:05 +0800
Message-Id: <1687247526-32258-4-git-send-email-tangyouling@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1687247526-32258-1-git-send-email-tangyouling@loongson.cn>
References: <1687247526-32258-1-git-send-email-tangyouling@loongson.cn>
X-CM-TRANSID: AQAAf8AxauWoWpFkdmghAA--.28374S5
X-CM-SenderInfo: 5wdqw5prxox03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoW7JF4xCFy7GF1ruFy3AFyfZrc_yoW8JF1rpr
        9xArZ5Kr45Wa4fAa4jyw18WrZ8Ga97Ga1293WvyrWxAFWjgF1jqw40yrZ7XFyaq3yfJr4F
        qws5Wr4Sva1DCwbCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
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

When objtool checked the fpu.o file, the following warnings appeared,
$ ./tools/objtool/objtool --orc arch/loongarch/kernel/fpu.o
arch/loongarch/kernel/fpu.o: warning: objtool: _save_fp_context() falls through
to next function fault()

This `fault` is only used in extable, it is not a function itself, and change
SYM_FUNC_START(fault) to the label method(.L_fault).

Signed-off-by: Youling Tang <tangyouling@loongson.cn>
---
 arch/loongarch/kernel/fpu.S | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/loongarch/kernel/fpu.S b/arch/loongarch/kernel/fpu.S
index ccde94140c89..8331835c0591 100644
--- a/arch/loongarch/kernel/fpu.S
+++ b/arch/loongarch/kernel/fpu.S
@@ -20,9 +20,13 @@
 #define LSX_REG_WIDTH		16
 #define LASX_REG_WIDTH		32
 
+.L_fault:
+	li.w	a0, -EFAULT				# failure
+	jr	ra
+
 	.macro	EX insn, reg, src, offs
 .ex\@:	\insn	\reg, \src, \offs
-	_asm_extable .ex\@, fault
+	_asm_extable .ex\@, .L_fault
 	.endm
 
 	.macro sc_save_fp base
@@ -243,8 +247,3 @@ SYM_FUNC_START(_restore_fp_context)
 	li.w		a0, 0				# success
 	jr		ra
 SYM_FUNC_END(_restore_fp_context)
-
-SYM_FUNC_START(fault)
-	li.w	a0, -EFAULT				# failure
-	jr	ra
-SYM_FUNC_END(fault)
-- 
2.39.2

