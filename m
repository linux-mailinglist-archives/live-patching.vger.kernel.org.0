Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD73736546
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 09:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbjFTHvE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 03:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbjFTHua (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 03:50:30 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CD8B170D;
        Tue, 20 Jun 2023 00:50:27 -0700 (PDT)
Received: from loongson.cn (unknown [113.200.148.30])
        by gateway (Coremail) with SMTP id _____8DxTutAWpFkkBsHAA--.14466S3;
        Tue, 20 Jun 2023 15:50:24 +0800 (CST)
Received: from bogon.localdomain (unknown [113.200.148.30])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxPMo+WpFkp2chAA--.19067S2;
        Tue, 20 Jun 2023 15:50:23 +0800 (CST)
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
Subject: [RFC PATCH v1 10/23] objtool: LoongArch: Implement decoder
Date:   Tue, 20 Jun 2023 15:50:06 +0800
Message-Id: <1687247415-32057-1-git-send-email-tangyouling@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf8AxPMo+WpFkp2chAA--.19067S2
X-CM-SenderInfo: 5wdqw5prxox03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoW3Jr4xJFykZF4fAFWfGFyfGrX_yoWxKr48pr
        WDur1kKrW5Xr1fur1UXay5C3sxGws3WrWaqFZ3G3srCry3tryfW3Z2gF1FyF93Kr4UC348
        WrZ3Xr12yF45AFXCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUmIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E
        14v26r4UJVWxJr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6x
        kI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v2
        6Fy26r45twAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2
        IYc2Ij64vIr41lF7xvrVCFI7AF6II2Y40_Zr0_Gr1UMxkF7I0En4kS14v26r126r1DMxAI
        w28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI
        8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AK
        xVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26w1j6s0DMIIF0xvE2Ix0cI
        8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E
        87Iv67AKxVW8Jr0_Cr1UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa
        73UjIFyTuYvjxUgBOJUUUUU
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Implement arch_decode_instruction() for LoongArch.

Add the decoding of the following part of the instruction,

Instructions that affect the SP:
  - Add instruction:
    addi.d
  - Load-Store instructions:
    st.d/ld.d
    stptr.d/ldptr.d

Instructions that affect control flow:
  - Branch and Jump instructions:
    beq/bne/blt/bge/bltu/bgeu/beqz/bnez/b
    jirl
  - Call instructions:
    bl
  - Return instructions:
    jr ra

Miscellaneous instructions:
  - Break instructionw:
    break
  - Nop instruction:
    nop
  - System instruction:
    ertn

Co-developed-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Youling Tang <tangyouling@loongson.cn>
---
 tools/arch/loongarch/include/asm/inst.h |   1 +
 tools/include/linux/bitops.h            |  10 ++
 tools/objtool/arch/loongarch/decode.c   | 136 ++++++++++++++++++++++++
 3 files changed, 147 insertions(+)

diff --git a/tools/arch/loongarch/include/asm/inst.h b/tools/arch/loongarch/include/asm/inst.h
index f0533fbc1e63..23d041cd76bf 100644
--- a/tools/arch/loongarch/include/asm/inst.h
+++ b/tools/arch/loongarch/include/asm/inst.h
@@ -56,6 +56,7 @@ enum reg2_op {
 	revbd_op	= 0x0f,
 	revh2w_op	= 0x10,
 	revhd_op	= 0x11,
+	ertn_op		= 0x1920e,
 };
 
 enum reg2i5_op {
diff --git a/tools/include/linux/bitops.h b/tools/include/linux/bitops.h
index f18683b95ea6..d81b52c070f5 100644
--- a/tools/include/linux/bitops.h
+++ b/tools/include/linux/bitops.h
@@ -87,4 +87,14 @@ static inline __u32 rol32(__u32 word, unsigned int shift)
 	return (word << shift) | (word >> ((-shift) & 31));
 }
 
+/**
+ * sign_extend64 - sign extend a 64-bit value using specified bit as sign-bit
+ * @value: value to sign extend
+ * @index: 0 based bit index (0<=index<64) to sign bit
+ */
+static __always_inline __s64 sign_extend64(__u64 value, int index)
+{
+	__u8 shift = 63 - index;
+	return (__s64)(value << shift) >> shift;
+}
 #endif
diff --git a/tools/objtool/arch/loongarch/decode.c b/tools/objtool/arch/loongarch/decode.c
index 3f795f57e914..fc24efd6dba2 100644
--- a/tools/objtool/arch/loongarch/decode.c
+++ b/tools/objtool/arch/loongarch/decode.c
@@ -3,6 +3,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 
+#include <linux/bitops.h>
 #include <asm/inst.h>
 
 #include <objtool/check.h>
@@ -13,6 +14,8 @@
 #include <objtool/endianness.h>
 #include <arch/cfi_regs.h>
 
+#define to_cfi_reg(reg) (reg)
+
 int arch_ftrace_match(char *name)
 {
 	return !strcmp(name, "_mcount");
@@ -74,11 +77,18 @@ const char *arch_ret_insn(int len)
 	return (const char *)&ret;
 }
 
+#define ADD_OP(op) \
+	if (!(op = calloc(1, sizeof(*op)))) \
+		return -1; \
+	else for (*ops_list = op, ops_list = &op->next; op; op = NULL)
+
 int arch_decode_instruction(struct objtool_file *file, const struct section *sec,
 			    unsigned long offset, unsigned int maxlen,
 			    struct instruction *insn)
 {
+	struct stack_op **ops_list = &insn->stack_ops;
 	const struct elf *elf = file->elf;
+	struct stack_op *op = NULL;
 	union loongarch_instruction inst;
 
 	if (!is_loongarch(elf))
@@ -97,6 +107,132 @@ int arch_decode_instruction(struct objtool_file *file, const struct section *sec
 	if (inst.word == 0)
 		insn->type = INSN_NOP;
 
+	switch (inst.reg2i12_format.opcode) {
+	case addid_op:
+		if ((inst.reg2i12_format.rj == CFI_SP) || (inst.reg2i12_format.rd == CFI_SP)) {
+			/* addi.d reg1,reg2,imm */
+			insn->immediate = sign_extend64(inst.reg2i12_format.immediate, 11);
+			ADD_OP(op) {
+				op->src.type = OP_SRC_ADD;
+				op->src.reg = to_cfi_reg(inst.reg2i12_format.rj);
+				op->src.offset = insn->immediate;
+				op->dest.type = OP_DEST_REG;
+				op->dest.reg = to_cfi_reg(inst.reg2i12_format.rd);
+			}
+		}
+		break;
+	case std_op:
+		if (inst.reg2i12_format.rj == CFI_SP) {
+			/* st.d reg,sp,imm */
+			insn->immediate = sign_extend64(inst.reg2i12_format.immediate, 11);
+			ADD_OP(op) {
+				op->src.type = OP_SRC_REG;
+				op->src.reg = to_cfi_reg(inst.reg2i12_format.rd);
+				op->dest.type = OP_DEST_REG_INDIRECT;
+				op->dest.reg = CFI_SP;
+				op->dest.offset = insn->immediate;
+			}
+		}
+		break;
+	case ldd_op:
+		if (inst.reg2i12_format.rj == CFI_SP) {
+			/* ld.d reg,sp,imm */
+			insn->immediate = sign_extend64(inst.reg2i12_format.immediate, 11);
+			ADD_OP(op) {
+				op->src.type = OP_SRC_REG_INDIRECT;
+				op->src.reg = CFI_SP;
+				op->src.offset = insn->immediate;
+				op->dest.type = OP_DEST_REG;
+				op->dest.reg = to_cfi_reg(inst.reg2i12_format.rd);
+			}
+		}
+		break;
+	case andi_op:
+		if (inst.reg2i12_format.immediate == 0 &&
+		     inst.reg2i12_format.rj == 0 &&
+		     inst.reg2i12_format.rd == 0)
+			/* nop */
+			insn->type = INSN_NOP;
+		break;
+	default:
+		switch (inst.reg2i16_format.opcode) {
+		case jirl_op:
+			if (inst.reg2i16_format.rj == CFI_RA &&
+			     inst.reg2i16_format.rd == 0) {
+				/* jr ra */
+				insn->type = INSN_RETURN;
+			} else if (inst.reg2i16_format.rd == CFI_RA) {
+				/* jalr reg */
+				insn->type = INSN_CALL_DYNAMIC;
+			} else if (inst.reg2i16_format.rd == 0) {
+				/* jr reg */
+				insn->type = INSN_JUMP_DYNAMIC;
+			} else if (!inst.reg2i16_format.immediate) {
+				/* jirl  */
+				insn->immediate = sign_extend64(inst.reg2i16_format.immediate, 15);
+				insn->type = INSN_JUMP_UNCONDITIONAL;
+			}
+			break;
+		case beq_op:
+		case bne_op:
+		case blt_op:
+		case bge_op:
+		case bltu_op:
+		case bgeu_op:
+			insn->immediate = sign_extend64(inst.reg2i16_format.immediate, 15);
+			insn->type = INSN_JUMP_CONDITIONAL;
+			break;
+		case beqz_op:
+		case bnez_op:
+			insn->immediate = sign_extend64(inst.reg1i21_format.immediate_h << 16 |
+					     inst.reg1i21_format.immediate_l, 20);
+			insn->type = INSN_JUMP_CONDITIONAL;
+			break;
+		case bl_op:
+			insn->immediate = sign_extend64(inst.reg0i26_format.immediate_h << 16 |
+					     inst.reg0i26_format.immediate_l, 25);
+			insn->type = INSN_CALL;
+			break;
+		case b_op:
+			insn->immediate = sign_extend64(inst.reg0i26_format.immediate_h << 16 |
+					     inst.reg0i26_format.immediate_l, 25);
+			insn->type = INSN_JUMP_UNCONDITIONAL;
+			break;
+		default:
+			if (inst.reg2i14_format.opcode == stptrd_op &&
+				inst.reg2i14_format.rj == CFI_SP) {
+				/* stptr.d reg,sp,imm */
+				insn->immediate = sign_extend64(inst.reg2i14_format.immediate, 13);
+				ADD_OP(op) {
+					op->src.type = OP_SRC_REG;
+					op->src.reg = to_cfi_reg(inst.reg2i14_format.rd);
+					op->dest.type = OP_DEST_REG_INDIRECT;
+					op->dest.reg = CFI_SP;
+					op->dest.offset = insn->immediate;
+				}
+			} else if (inst.reg2i14_format.opcode == ldptrd_op &&
+				inst.reg2i14_format.rj == CFI_SP) {
+				/* ldptr.d reg,sp,imm */
+				insn->immediate = sign_extend64(inst.reg2i14_format.immediate, 13);
+				ADD_OP(op) {
+					op->src.type = OP_SRC_REG_INDIRECT;
+					op->src.reg = CFI_SP;
+					op->src.offset = insn->immediate;
+					op->dest.type = OP_DEST_REG;
+					op->dest.reg = to_cfi_reg(inst.reg2i14_format.rd);
+				}
+			} else if (inst.reg0i15_format.opcode == break_op) {
+				/* break */
+				insn->type = INSN_BUG;
+			} else if (inst.reg2_format.opcode == ertn_op) {
+				/* ertn */
+				insn->type = INSN_RETURN;
+			}
+			break;
+		}
+		break;
+	}
+
 	return 0;
 }
 
-- 
2.39.2

