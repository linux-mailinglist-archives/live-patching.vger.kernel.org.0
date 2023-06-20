Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B067365F0
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 10:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbjFTISt (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 04:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbjFTISq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 04:18:46 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B78C5DB;
        Tue, 20 Jun 2023 01:18:44 -0700 (PDT)
Received: from loongson.cn (unknown [113.200.148.30])
        by gateway (Coremail) with SMTP id _____8DxzOrjYJFk3h4HAA--.14572S3;
        Tue, 20 Jun 2023 16:18:43 +0800 (CST)
Received: from bogon.localdomain (unknown [113.200.148.30])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxReThYJFkJ3AhAA--.28832S4;
        Tue, 20 Jun 2023 16:18:42 +0800 (CST)
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
Subject: [RFC PATCH v1 22/23] objtool: Make update_cfi_state() arch-specific function
Date:   Tue, 20 Jun 2023 16:18:31 +0800
Message-Id: <1687249112-2790-3-git-send-email-tangyouling@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1687249112-2790-1-git-send-email-tangyouling@loongson.cn>
References: <1687249112-2790-1-git-send-email-tangyouling@loongson.cn>
X-CM-TRANSID: AQAAf8CxReThYJFkJ3AhAA--.28832S4
X-CM-SenderInfo: 5wdqw5prxox03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoW3GFyUWFWUGr4kGw1kKw47Jrc_yoWxGF47pF
        WDZ3yrGrWUWw4xuwnFqrZ0gFZxKws7Wr10gryxJ34ftry2grn5JFs29FyqyF4rWrs5ua42
        qFWakr4UXa1ay3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVWxJr0_GcWln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
        xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
        6rW5McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x
        0EwIxGrwACjcxG6xCI17CEII8vrVW3JVW8Jr1lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IY
        c2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxV
        Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
        6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Xr0_Ar1lIxAIcVC0I7IYx2IY6x
        kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AK
        xVW8Jr0_Cr1UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyT
        uYvjxUDdOzDUUUU
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Currently update_cfi_state() is implemented for the x86_64 architecture. This
function is specific to the architecture. In order to avoid powerpc build
errors, define x86_64 as the default implementation and rename update_cfi_state()
to arch_update_cfi_state().

LoongArch will reimplement arch_update_cfi_state().

Co-developed-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Youling Tang <tangyouling@loongson.cn>
---
 tools/objtool/arch/loongarch/decode.c | 76 +++++++++++++++++++++++++++
 tools/objtool/check.c                 | 10 ++--
 tools/objtool/include/objtool/arch.h  |  3 ++
 tools/objtool/include/objtool/check.h |  5 ++
 4 files changed, 89 insertions(+), 5 deletions(-)

diff --git a/tools/objtool/arch/loongarch/decode.c b/tools/objtool/arch/loongarch/decode.c
index 90adbbeab8d4..6ca8cbad6813 100644
--- a/tools/objtool/arch/loongarch/decode.c
+++ b/tools/objtool/arch/loongarch/decode.c
@@ -4,6 +4,8 @@
 #include <stdlib.h>
 
 #include <linux/bitops.h>
+#include <linux/objtool.h>
+
 #include <asm/inst.h>
 #include <asm/orc_types.h>
 
@@ -274,3 +276,77 @@ void arch_initial_func_cfi_state(struct cfi_init_state *state)
 	state->cfa.base = CFI_SP;
 	state->cfa.offset = 0;
 }
+
+
+int arch_update_cfi_state(struct instruction *insn,
+			  struct instruction *next_insn,
+			  struct cfi_state *cfi, struct stack_op *op)
+{
+	struct cfi_reg *cfa = &cfi->cfa;
+	struct cfi_reg *regs = cfi->regs;
+
+	/* stack operations don't make sense with an undefined CFA */
+	if (cfa->base == CFI_UNDEFINED) {
+		if (insn_func(insn)) {
+			WARN_FUNC("undefined stack state", insn->sec, insn->offset);
+			return -1;
+		}
+		return 0;
+	}
+
+	if (cfi->type == UNWIND_HINT_TYPE_REGS)
+		return update_cfi_state_regs(insn, cfi, op);
+
+
+	switch (op->dest.type) {
+	case OP_DEST_REG:
+		switch (op->src.type) {
+		case OP_SRC_ADD:
+			if (op->dest.reg == CFI_SP && op->src.reg == CFI_SP) {
+				/* addi.d sp, sp, imm */
+				cfi->stack_size -= op->src.offset;
+				if (cfa->base == CFI_SP)
+					cfa->offset -= op->src.offset;
+			} else if (op->dest.reg == CFI_FP && op->src.reg == CFI_SP) {
+				/* addi.d fp, sp, imm */
+				if (cfa->base == CFI_SP && cfa->offset == op->src.offset) {
+					cfa->base = CFI_FP;
+					cfa->offset = 0;
+				}
+			} else if (op->dest.reg == CFI_SP && op->src.reg == CFI_FP) {
+				/* addi.d sp, fp, imm */
+				if (cfa->base == CFI_FP && cfa->offset == 0) {
+					cfa->base = CFI_SP;
+					cfa->offset = -op->src.offset;
+				}
+			}
+			break;
+		case OP_SRC_REG_INDIRECT:
+			/* ld.d _reg, sp, imm */
+			if (op->src.reg == CFI_SP &&
+				op->src.offset == (regs[op->dest.reg].offset + cfi->stack_size)) {
+				restore_reg(cfi, op->dest.reg);
+				/* Gcc may not restore sp, we adjust it directly. */
+				if (cfa->base == CFI_FP && cfa->offset == 0) {
+					cfa->base = CFI_SP;
+					cfa->offset = cfi->stack_size;
+				}
+			}
+			break;
+		default:
+			break;
+		}
+		break;
+	case OP_DEST_REG_INDIRECT:
+		if (op->src.type == OP_SRC_REG)
+			/* st.d _reg, sp, imm */
+			if (op->dest.offset)
+				save_reg(cfi, op->src.reg, CFI_CFA, op->dest.offset - cfi->stack_size);
+		break;
+	default:
+		WARN_FUNC("unknown stack-related instruction", insn->sec, insn->offset);
+		return -1;
+	}
+
+	return 0;
+}
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index c637e54088f6..42f87a33f558 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2230,7 +2230,7 @@ static bool has_valid_stack_frame(struct insn_state *state)
 	return false;
 }
 
-static int update_cfi_state_regs(struct instruction *insn,
+int update_cfi_state_regs(struct instruction *insn,
 				  struct cfi_state *cfi,
 				  struct stack_op *op)
 {
@@ -2255,7 +2255,7 @@ static int update_cfi_state_regs(struct instruction *insn,
 	return 0;
 }
 
-static void save_reg(struct cfi_state *cfi, unsigned char reg, int base, int offset)
+void save_reg(struct cfi_state *cfi, unsigned char reg, int base, int offset)
 {
 	if (arch_callee_saved_reg(reg) &&
 	    cfi->regs[reg].base == CFI_UNDEFINED) {
@@ -2264,7 +2264,7 @@ static void save_reg(struct cfi_state *cfi, unsigned char reg, int base, int off
 	}
 }
 
-static void restore_reg(struct cfi_state *cfi, unsigned char reg)
+void restore_reg(struct cfi_state *cfi, unsigned char reg)
 {
 	cfi->regs[reg].base = initial_func_cfi.regs[reg].base;
 	cfi->regs[reg].offset = initial_func_cfi.regs[reg].offset;
@@ -2323,7 +2323,7 @@ static void restore_reg(struct cfi_state *cfi, unsigned char reg)
  *   41 5d			pop    %r13
  *   c3				retq
  */
-static int update_cfi_state(struct instruction *insn,
+int __weak arch_update_cfi_state(struct instruction *insn,
 			    struct instruction *next_insn,
 			    struct cfi_state *cfi, struct stack_op *op)
 {
@@ -2795,7 +2795,7 @@ static int handle_insn_ops(struct instruction *insn,
 
 	for (op = insn->stack_ops; op; op = op->next) {
 
-		if (update_cfi_state(insn, next_insn, &state->cfi, op))
+		if (arch_update_cfi_state(insn, next_insn, &state->cfi, op))
 			return 1;
 
 		if (!insn->alt_group)
diff --git a/tools/objtool/include/objtool/arch.h b/tools/objtool/include/objtool/arch.h
index 2b6d2ce4f9a5..88570c598752 100644
--- a/tools/objtool/include/objtool/arch.h
+++ b/tools/objtool/include/objtool/arch.h
@@ -95,4 +95,7 @@ int arch_rewrite_retpolines(struct objtool_file *file);
 
 bool arch_pc_relative_reloc(struct reloc *reloc);
 
+int __weak arch_update_cfi_state(struct instruction *insn,
+			    struct instruction *next_insn,
+			    struct cfi_state *cfi, struct stack_op *op);
 #endif /* _ARCH_H */
diff --git a/tools/objtool/include/objtool/check.h b/tools/objtool/include/objtool/check.h
index 34898364bf03..dd1b95c67620 100644
--- a/tools/objtool/include/objtool/check.h
+++ b/tools/objtool/include/objtool/check.h
@@ -33,4 +33,9 @@ struct alt_group {
 
 extern unsigned long nr_insns;
 
+int update_cfi_state_regs(struct instruction *insn,
+				  struct cfi_state *cfi,
+				  struct stack_op *op);
+void save_reg(struct cfi_state *cfi, unsigned char reg, int base, int offset);
+void restore_reg(struct cfi_state *cfi, unsigned char reg);
 #endif /* _CHECK_H */
-- 
2.39.2

