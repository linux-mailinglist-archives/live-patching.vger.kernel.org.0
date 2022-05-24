Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7408531FA4
	for <lists+live-patching@lfdr.de>; Tue, 24 May 2022 02:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbiEXARH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 23 May 2022 20:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiEXAQ5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 23 May 2022 20:16:57 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7221A6D4CB;
        Mon, 23 May 2022 17:16:55 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7F2F220B895B;
        Mon, 23 May 2022 17:16:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7F2F220B895B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1653351415;
        bh=NA16KWlQPMN0HiA+DBPspnlFwB3chkl/e0Ulkr5UDdA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=P/8Udr7JPl0jloM1OqtLgmnqIxrhl6BjF9tfhWnx5/slYQnE74waDWn2D96EQPP/X
         TyLxBMTcgWc6ZPLr/Nci9GakGN/DruUa59Y3DQKaD/ep3oR4502o1EjyLDUM6i9FSO
         Mlq1iVAkglieO/HQ9jXw5EUaz3fyKb4tr1kIau3Y=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v2 08/20] objtool: arm64: Implement decoder for FP validation
Date:   Mon, 23 May 2022 19:16:25 -0500
Message-Id: <20220524001637.1707472-9-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220524001637.1707472-1-madvenka@linux.microsoft.com>
References: <e81e773678f88f7c2ff7480e2eb096973ec198db>
 <20220524001637.1707472-1-madvenka@linux.microsoft.com>
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

Implement arch_decode_instruction() for ARM64. For dynamic FP validation,
we need to walk each function's code and determine the stack and frame
offsets at each instruction. So, the following instructions are completely
decoded:

	Instructions that affect the SP and FP:

	- Load-Store instructions
	- Add/Sub/Mov instructions

	Instructions that affect control flow:

	- Branch instructions
	- Call instructions
	- Return instructions

The rest of the instructions are either dont-care from an unwind
perspective or unexpected from the compiler. Add checks for the unexpected
ones to catch them if the compiler ever generates them.

Define CFI registers used by ARM64 in arch-specific cfi_regs.h. This is a
small subset of the ones used in x86.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 tools/objtool/arch/arm64/Build                |   1 +
 tools/objtool/arch/arm64/decode.c             | 342 ++++++++++++++++++
 .../arch/arm64/include/arch/cfi_regs.h        |  12 +
 tools/objtool/include/objtool/arch.h          |   1 +
 4 files changed, 356 insertions(+)
 create mode 100644 tools/objtool/arch/arm64/Build
 create mode 100644 tools/objtool/arch/arm64/decode.c
 create mode 100644 tools/objtool/arch/arm64/include/arch/cfi_regs.h

diff --git a/tools/objtool/arch/arm64/Build b/tools/objtool/arch/arm64/Build
new file mode 100644
index 000000000000..3ff1f00c6a47
--- /dev/null
+++ b/tools/objtool/arch/arm64/Build
@@ -0,0 +1 @@
+objtool-y += decode.o
diff --git a/tools/objtool/arch/arm64/decode.c b/tools/objtool/arch/arm64/decode.c
new file mode 100644
index 000000000000..8a9ff030085d
--- /dev/null
+++ b/tools/objtool/arch/arm64/decode.c
@@ -0,0 +1,342 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * decode.c - ARM64 instruction decoder for dynamic FP validation. Only a
+ *            small subset of the instructions need to be decoded.
+ *
+ * Author: Madhavan T. Venkataraman (madvenka@linux.microsoft.com)
+ *
+ * Copyright (C) 2022 Microsoft Corporation
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+
+#include <objtool/insn.h>
+#include <objtool/elf.h>
+#include <objtool/warn.h>
+#include <arch/cfi_regs.h>
+
+/* ARM64 instructions are all 4 bytes wide. */
+#define INSN_SIZE	4
+
+/* --------------------- instruction decode struct ------------------------- */
+
+struct decode {
+	unsigned long	opmask;
+	unsigned long	op;
+	unsigned int	shift;
+	unsigned int	bits;
+	unsigned int	size;
+	unsigned int	sign_extend;
+	void		(*func)(struct decode *decode,
+				u32 insn, enum insn_type *type,
+				s64 *imm, struct list_head *stack_ops);
+};
+
+/* --------------------- miscellaneous functions --------------------------- */
+
+static void reg_check(unsigned int sp_check, unsigned int fp_check,
+		      u32 insn, enum insn_type *type)
+{
+	unsigned int	rd = insn & 0x1F;
+
+	if ((sp_check && rd == CFI_SP) || (fp_check && rd == CFI_FP))
+		*type = INSN_UNRELIABLE;
+}
+
+static void add_stack_op(unsigned char src, unsigned char dest, s64 offset,
+			 struct list_head *stack_ops)
+{
+	struct stack_op *op;
+
+	op = calloc(1, sizeof(*op));
+	if (!op) {
+		WARN("calloc failed");
+		return;
+	}
+
+	op->src.reg = src;
+	op->src.type = OP_SRC_ADD;
+	op->src.offset = offset;
+	op->dest.reg = dest;
+	op->dest.type = OP_DEST_REG;
+
+	list_add_tail(&op->list, stack_ops);
+}
+
+/* ------------------------ decode functions ------------------------------- */
+
+#define STP_SOFF	0x29000000	/* STP signed offset */
+#define STR_SOFF	0xB9000000	/* STR signed offset */
+#define LDP_SOFF	0x29400000	/* LDP signed offset */
+#define LDR_SOFF	0xB9400000	/* LDR signed offset */
+
+/* Load-Store instructions. */
+static void ld_st(struct decode *decode,
+		       u32 insn, enum insn_type *type,
+		       s64 *imm, struct list_head *stack_ops)
+{
+	unsigned int	rn = (insn >> 5) & 0x1F;
+
+	if (decode->op == LDP_SOFF || decode->op == LDR_SOFF ||
+	    decode->op == STP_SOFF || decode->op == STR_SOFF)
+		return;
+	if (rn == CFI_SP)
+		add_stack_op(CFI_SP, CFI_SP, *imm, stack_ops);
+	else if (rn == CFI_FP)
+		add_stack_op(CFI_FP, CFI_FP, *imm, stack_ops);
+}
+
+/* Load-Store instructions. */
+static void ld_st_chk(struct decode *decode,
+			     u32 insn, enum insn_type *type,
+			     s64 *imm, struct list_head *stack_ops)
+{
+	ld_st(decode, insn, type, imm, stack_ops);
+	reg_check(0, 1, insn, type);
+}
+
+#define CMN_OP		0x31000000	/* Alias of ADDS imm */
+#define CMP_OP		0x71000000	/* Alias of SUBS imm */
+
+/* Add instructions. */
+static void add(struct decode *decode,
+		u32 insn, enum insn_type *type,
+		s64 *imm, struct list_head *stack_ops)
+{
+	unsigned int	rd = insn & 0x1F;
+	unsigned int	rn = (insn >> 5) & 0x1F;
+	unsigned int	shift = (insn >> 22) & 1;
+
+	if (shift)
+		*imm <<= 12;
+
+	if (rd == CFI_SP) {
+		if (rn == CFI_SP)
+			add_stack_op(CFI_SP, CFI_SP, *imm, stack_ops);
+		else if (rn == CFI_FP)
+			add_stack_op(CFI_FP, CFI_SP, *imm, stack_ops);
+		else if (decode->op != CMN_OP && decode->op != CMP_OP)
+			*type = INSN_UNRELIABLE;
+	} else if (rd == CFI_FP) {
+		if (rn == CFI_SP)
+			add_stack_op(CFI_SP, CFI_FP, *imm, stack_ops);
+		else if (rn == CFI_FP)
+			add_stack_op(CFI_FP, CFI_FP, *imm, stack_ops);
+		else
+			*type = INSN_UNRELIABLE;
+	}
+}
+
+/* Subtract instructions. */
+static void sub(struct decode *decode,
+		u32 insn, enum insn_type *type,
+		s64 *imm, struct list_head *stack_ops)
+{
+	*imm = -(*imm);
+	return add(decode, insn, type, imm, stack_ops);
+}
+
+#define BR_UNCONDITIONAL		0x14000000
+
+/* Branch and Return instructions. */
+static void branch(struct decode *decode,
+		   u32 insn, enum insn_type *type,
+		   s64 *imm, struct list_head *stack_ops)
+{
+	if (*imm) {
+		if (decode->op == BR_UNCONDITIONAL)
+			*type = INSN_JUMP_UNCONDITIONAL;
+		else
+			*type = INSN_JUMP_CONDITIONAL;
+	} else {
+		*type = INSN_JUMP_DYNAMIC;
+	}
+}
+
+static void call(struct decode *decode,
+		   u32 insn, enum insn_type *type,
+		   s64 *imm, struct list_head *stack_ops)
+{
+	*type = *imm ? INSN_CALL : INSN_CALL_DYNAMIC;
+}
+
+static void ret(struct decode *decode,
+		u32 insn, enum insn_type *type,
+		s64 *imm, struct list_head *stack_ops)
+{
+	*type = INSN_RETURN;
+}
+
+static void bug(struct decode *decode,
+		u32 insn, enum insn_type *type,
+		s64 *imm, struct list_head *stack_ops)
+{
+	*type = INSN_BUG;
+}
+
+/*
+ * Other instructions are not decoded. They don't generate any stack_ops.
+ * Only checks are done to make sure that the compiler does not generate
+ * any instructions to clobber the SP and FP registers in unexpected ways.
+ */
+static void sp_check(struct decode *decode,
+		     u32 insn, enum insn_type *type,
+		     s64 *imm, struct list_head *stack_ops)
+{
+	reg_check(1, 1, insn, type);
+}
+
+static void fp_check(struct decode *decode,
+		  u32 insn, enum insn_type *type,
+		  s64 *imm, struct list_head *stack_ops)
+{
+	reg_check(0, 1, insn, type);
+}
+
+static void ignore(struct decode *decode,
+		   u32 insn, enum insn_type *type,
+		   s64 *imm, struct list_head *stack_ops)
+{
+}
+
+/* ------------------------ Instruction decode ----------------------------- */
+
+struct decode	decode_array[] = {
+/* =============================== INSTRUCTIONS =============================*/
+/* operation           mask        opcode      shift bits size sign func     */
+/* ==========================================================================*/
+/* LDP pre */        { 0x7FC00000, 0x29C00000, 15,   7,   8,   1,   ld_st },
+/* LDP post */       { 0x7FC00000, 0x28C00000, 15,   7,   8,   1,   ld_st },
+/* LDP off */        { 0x7FC00000, 0x29400000, 15,   7,   8,   1,   ld_st },
+/* LDPSW pre */      { 0xFFC00000, 0x69C00000, 15,   7,   4,   1,   ld_st_chk },
+/* LDPSW post */     { 0xFFC00000, 0x68C00000, 15,   7,   4,   1,   ld_st_chk },
+/* LDR imm pre */    { 0xBFE00C00, 0xB8400C00, 12,   9,   1,   1,   ld_st },
+/* LDR imm post */   { 0xBFE00C00, 0xB8400400, 12,   9,   1,   1,   ld_st },
+/* LDR off */        { 0xBFC00000, 0xB9400000, 12,   9,   1,   1,   ld_st },
+/* LDRB imm pre */   { 0xFFE00C00, 0x38400C00, 12,   9,   1,   1,   ld_st_chk },
+/* LDRB imm post */  { 0xFFE00C00, 0x38400400, 12,   9,   1,   1,   ld_st_chk },
+/* LDRH imm pre */   { 0xFFE00C00, 0x78400C00, 12,   9,   1,   1,   ld_st_chk },
+/* LDRH imm post */  { 0xFFE00C00, 0x78400400, 12,   9,   1,   1,   ld_st_chk },
+/* LDRSB imm pre */  { 0xFF800C00, 0x38800C00, 12,   9,   1,   1,   ld_st_chk },
+/* LDRSB imm post */ { 0xFF800C00, 0x38800400, 12,   9,   1,   1,   ld_st_chk },
+/* LDRSH imm pre */  { 0xFF800C00, 0x78800C00, 12,   9,   1,   1,   ld_st_chk },
+/* LDRSH imm post */ { 0xFF800C00, 0x78800400, 12,   9,   1,   1,   ld_st_chk },
+/* LDRSW imm pre */  { 0xFFE00C00, 0xB8800C00, 12,   9,   1,   1,   ld_st_chk },
+/* LDRSW imm post */ { 0xFFE00C00, 0xB8800400, 12,   9,   1,   1,   ld_st_chk },
+/* STP pre */        { 0x7FC00000, 0x29800000, 15,   7,   8,   1,   ld_st },
+/* STP post */       { 0x7FC00000, 0x28800000, 15,   7,   8,   1,   ld_st },
+/* STP off */        { 0x7FC00000, 0x29000000, 15,   7,   8,   1,   ld_st },
+/* STGP imm pre */   { 0xFFC00000, 0x69800000, 15,   7,  16,   1,   ld_st },
+/* STGP imm post */  { 0xFFC00000, 0x68800000, 15,   7,  16,   1,   ld_st },
+/* STR imm pre */    { 0xBFC00C00, 0xB8000C00, 12,   9,   1,   1,   ld_st },
+/* STR imm post */   { 0xBFC00C00, 0xB8000400, 12,   9,   1,   1,   ld_st },
+/* STR off */        { 0xBFC00000, 0xB9000000, 10,  12,   1,   1,   ld_st },
+/* STG imm pre */    { 0xFFC00C00, 0xD9000C00, 12,   9,  16,   1,   ld_st },
+/* STG imm post */   { 0xFFC00C00, 0xD9000400, 12,   9,  16,   1,   ld_st },
+/* ST2G imm pre */   { 0xFFE00C00, 0xD9A00C00, 12,   9,  16,   1,   ld_st },
+/* ST2G imm post */  { 0xFFE00C00, 0xD9A00400, 12,   9,  16,   1,   ld_st },
+/* ADD imm */        { 0x7F800000, 0x11000000, 10,  12,   1,   0,   add },
+/* ADDS imm */       { 0x7F800000, 0x31000000, 10,  12,   1,   0,   add },
+/* ADD ext reg */    { 0x7FE00000, 0x0B200000,  0,   0,   1,   0,   sp_check },
+/* SUB imm */        { 0x7F800000, 0x51000000, 10,  12,   1,   0,   sub },
+/* SUBS imm */       { 0x7F800000, 0x71000000, 10,  12,   1,   0,   sub },
+/* SUB ext reg */    { 0x7FE00000, 0x4B200000,  0,   0,   1,   0,   sp_check },
+/* ORR imm */        { 0x7F800000, 0x32000000,  0,   0,   1,   0,   sp_check },
+/* B */              { 0xFC000000, 0x14000000,  0,  26,   4,   1,   branch },
+/* B.cond */         { 0xFF000010, 0x54000000,  5,  19,   4,   1,   branch },
+/* BC.cond */        { 0xFF000010, 0x54000010,  5,  19,   4,   1,   branch },
+/* BR */             { 0xFFFFFC00, 0xD61F0000,  0,   0,   4,   0,   branch },
+/* BRA */            { 0xFEFFF800, 0xD61F0800,  0,   0,   4,   0,   branch },
+/* CBZ */            { 0x7F000000, 0x34000000,  5,  19,   4,   1,   branch },
+/* CBNZ */           { 0x7F000000, 0x35000000,  5,  19,   4,   1,   branch },
+/* TBZ */            { 0x7F000000, 0x36000000,  5,  14,   4,   1,   branch },
+/* TBNZ */           { 0x7F000000, 0x37000000,  5,  14,   4,   1,   branch },
+/* BL */             { 0xFC000000, 0x94000000,  0,  26,   4,   1,   call },
+/* BLR */            { 0xFFFFFC00, 0xD63F0000,  0,   0,   4,   1,   call },
+/* BLRA */           { 0xFEFFF800, 0xD63F0800,  0,   0,   4,   1,   call },
+/* RET */            { 0xFFFFFC1F, 0xD65F0000,  0,   0,   1,   0,   ret },
+/* RETA */           { 0xFFFFFBFF, 0xD65F0BFF,  0,   0,   1,   0,   ret },
+/* ERET */           { 0xFFFFFFFF, 0xD69F03E0,  0,   0,   1,   0,   ret },
+/* ERETA */          { 0xFFFFFBFF, 0xD69F0BFF,  0,   0,   1,   0,   ret },
+/* BRK */            { 0xFFE00000, 0xD4200000,  0,   0,   1,   0,   bug },
+
+/* =========================== INSTRUCTION CLASSES ==========================*/
+/* operation           mask        opcode      shift bits size sign func     */
+/* ==========================================================================*/
+/* RSVD_00 */        { 0x1E000000, 0x00000000,  0,   0,   1,   0,   ignore },
+/* UNALLOC_01 */     { 0x1E000000, 0x02000000,  0,   0,   1,   0,   ignore },
+/* SVE_02 */         { 0x1E000000, 0x04000000,  0,   0,   1,   0,   ignore },
+/* UNALLOC_03 */     { 0x1E000000, 0x06000000,  0,   0,   1,   0,   ignore },
+/* LOAD_STORE_04 */  { 0x1E000000, 0x08000000,  0,   0,   1,   0,   fp_check },
+/* DP_REGISTER_05 */ { 0x1E000000, 0x0A000000,  0,   0,   1,   0,   fp_check },
+/* LOAD_STORE_06 */  { 0x1E000000, 0x0C000000,  0,   0,   1,   0,   ignore },
+/* SIMD_FP_07 */     { 0x1E000000, 0x0E000000,  0,   0,   1,   0,   ignore },
+/* DP_IMMEDIATE_08 */{ 0x1E000000, 0x10000000,  0,   0,   1,   0,   fp_check },
+/* DP_IMMEDIATE_09 */{ 0x1E000000, 0x12000000,  0,   0,   1,   0,   fp_check },
+/* BR_SYS_10 */      { 0x1E000000, 0x14000000,  0,   0,   1,   0,   fp_check },
+/* BR_SYS_11 */      { 0x1E000000, 0x16000000,  0,   0,   1,   0,   fp_check },
+/* LOAD_STORE_12 */  { 0x1E000000, 0x18000000,  0,   0,   1,   0,   fp_check },
+/* DP_REGISTER_13 */ { 0x1E000000, 0x1A000000,  0,   0,   1,   0,   ignore },
+/* LOAD_STORE_14 */  { 0x1E000000, 0x1C000000,  0,   0,   1,   0,   fp_check },
+/* SIMD_FP_15 */     { 0x1E000000, 0x1E000000,  0,   0,   1,   0,   ignore },
+};
+unsigned int	ndecode = ARRAY_SIZE(decode_array);
+
+static inline s64 sign_extend(s64 imm, unsigned int bits)
+{
+	return (imm << (64 - bits)) >> (64 - bits);
+}
+
+/*
+ * This decoder is only for generating stack ops for instructions that
+ * affect the SP and FP. The instructions that involve only immediate
+ * operands can be evaluated in this decoder. But instructions that
+ * involve other registers cannot be evaluated because the contents of
+ * those registers are known only at runtime. There are checks to catch
+ * it if the compiler generates these for the FP and SP. Such instructions
+ * are marked as unreliable.
+ */
+int arch_decode_instruction(struct objtool_file *file,
+			    const struct section *sec,
+			    unsigned long offset, unsigned int maxlen,
+			    unsigned int *len, enum insn_type *type,
+			    unsigned long *immediate,
+			    struct list_head *stack_ops)
+{
+	struct decode		*decode;
+	s64			imm;
+	u32			insn;
+	unsigned int		mask, i;
+
+	if (maxlen < INSN_SIZE)
+		return -1;
+
+	insn = *(u32 *)(sec->data->d_buf + offset);
+	*type = INSN_OTHER;
+	*len = INSN_SIZE;
+
+	/*
+	 * Find the decode structure for the specific instruction,
+	 * if listed.
+	 */
+	for (i = 0; i < ndecode; i++) {
+		decode = &decode_array[i];
+		if ((insn & decode->opmask) == decode->op) {
+			/*
+			 * Decode the instruction.
+			 */
+			mask = (1 << decode->bits) - 1;
+			imm = (insn >> decode->shift) & mask;
+			if (decode->sign_extend)
+				imm = sign_extend(imm, decode->bits);
+			imm *= decode->size;
+
+			decode->func(decode, insn, type, &imm, stack_ops);
+			*immediate = imm;
+			return 0;
+		}
+	}
+	/* Cannot happen. */
+	return -1;
+}
diff --git a/tools/objtool/arch/arm64/include/arch/cfi_regs.h b/tools/objtool/arch/arm64/include/arch/cfi_regs.h
new file mode 100644
index 000000000000..a3df37fe5290
--- /dev/null
+++ b/tools/objtool/arch/arm64/include/arch/cfi_regs.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _OBJTOOL_CFI_REGS_H
+#define _OBJTOOL_CFI_REGS_H
+
+#define CFI_FP			29
+#define CFI_RA			30
+#define CFI_SP			31
+
+#define CFI_NUM_REGS		32
+
+#endif /* _OBJTOOL_CFI_REGS_H */
diff --git a/tools/objtool/include/objtool/arch.h b/tools/objtool/include/objtool/arch.h
index 9b19cc304195..e23d5746daf0 100644
--- a/tools/objtool/include/objtool/arch.h
+++ b/tools/objtool/include/objtool/arch.h
@@ -29,6 +29,7 @@ enum insn_type {
 	INSN_TRAP,
 	INSN_ENDBR,
 	INSN_OTHER,
+	INSN_UNRELIABLE,
 };
 
 enum op_dest_type {
-- 
2.25.1

