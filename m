Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A19687693
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 08:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbjBBHmx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 02:42:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbjBBHmu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 02:42:50 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E348841A2;
        Wed,  1 Feb 2023 23:42:35 -0800 (PST)
Received: from x64host.home (unknown [47.187.213.40])
        by linux.microsoft.com (Postfix) with ESMTPSA id A987B2086203;
        Wed,  1 Feb 2023 23:42:34 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A987B2086203
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675323755;
        bh=4fW0dt8uJ6yPubxoQOl47EhlJ/H7JCFSPjMi/D921fM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=mhzukO34LKeqP16XWJzkrtzw10Vu4jVQh4Ow/u5GFP36iXhsLeZI4pjRsvhpkfozh
         2cV9upnaldaqgEYwf5xQjRxoy/VmR55R7tHHlKhKtMTRUOnQErGFX9iRDImUFCWgab
         5X4LEd4KPZxGJ7WSqesDmwh8rOcrr2/0q23oCEQg=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 10/22] objtool: arm64: Implement decoder for Dynamic FP validation
Date:   Thu,  2 Feb 2023 01:40:24 -0600
Message-Id: <20230202074036.507249-11-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202074036.507249-1-madvenka@linux.microsoft.com>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Implement arch_decode_instruction() for ARM64. For Dynamic FP validation,
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

	Miscellaneous instructions:

	- Break instruction used for bugs
	- Paciasp instruction that occurs at the beginning of the frame
	  pointer prolog

The rest of the instructions are either dont-care from an unwind
perspective or unexpected from the compiler. Add checks for the unexpected
ones to catch them if the compiler ever generates them.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 tools/objtool/arch/arm64/decode.c    | 506 ++++++++++++++++++++++++++-
 tools/objtool/include/objtool/arch.h |   2 +
 2 files changed, 507 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/arch/arm64/decode.c b/tools/objtool/arch/arm64/decode.c
index 69f851337537..aaae16791807 100644
--- a/tools/objtool/arch/arm64/decode.c
+++ b/tools/objtool/arch/arm64/decode.c
@@ -1,5 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
+ * decode.c - ARM64 instruction decoder for dynamic FP validation. Only a
+ *            small subset of the instructions need to be decoded. The rest
+ *            only need to be sanity checked.
+ *
  * Author: Madhavan T. Venkataraman (madvenka@linux.microsoft.com)
  *
  * Copyright (C) 2022 Microsoft Corporation
@@ -7,15 +11,515 @@
 
 #include <stdio.h>
 #include <stdlib.h>
+#include <stdint.h>
 
 #include <objtool/check.h>
+#include <objtool/elf.h>
+#include <objtool/warn.h>
+
+/* ARM64 instructions are all 4 bytes wide. */
+#define INSN_SIZE	4
+
+/* --------------------- instruction decode structs ------------------------ */
+
+struct decode_var {
+	u32			insn;
+	enum insn_type		type;
+	s64			imm;
+	unsigned int		mode1;
+	unsigned int		mode2;
+	unsigned int		check_reg;
+	struct list_head	*ops;
+};
+
+struct decode {
+	unsigned long	opmask;
+	unsigned long	op;
+	unsigned int	width;
+	unsigned int	shift;
+	unsigned int	bits;
+	unsigned int	sign_extend;
+	unsigned int	mult;
+	unsigned int	mode1;
+	unsigned int	mode2;
+	void		(*func)(struct decode *decode, struct decode_var *var);
+};
+
+struct class {
+	unsigned long	opmask;
+	unsigned long	op;
+	void		(*check)(struct decode_var *var);
+};
+
+/* ------------------------ stack operations ------------------------------- */
+
+static void add_stack_op(unsigned char src_reg, enum op_src_type src_type,
+			 s64 src_offset,
+			 unsigned char dest_reg, enum op_dest_type dest_type,
+			 s64 dest_offset,
+			 struct list_head *ops)
+{
+	struct stack_op *op;
+
+	op = calloc(1, sizeof(*op));
+	if (!op) {
+		WARN("calloc failed");
+		return;
+	}
+
+	op->src.reg = src_reg;
+	op->src.type = src_type;
+	op->src.offset = src_offset;
+	op->dest.reg = dest_reg;
+	op->dest.type = dest_type;
+	op->dest.offset = dest_offset;
+
+	list_add_tail(&op->list, ops);
+}
+
+static void add_op(struct decode_var *var,
+		   unsigned char rn, s64 offset, unsigned char rd)
+{
+	add_stack_op(rn, OP_SRC_ADD, offset, rd, OP_DEST_REG, 0, var->ops);
+}
+
+static void load_op(struct decode_var *var, s64 offset, unsigned char rd)
+{
+	add_stack_op(CFI_SP, OP_SRC_REG_INDIRECT, offset, rd, OP_DEST_REG, 0,
+		     var->ops);
+}
+
+static void store_op(struct decode_var *var, s64 offset, unsigned char rd)
+{
+	add_stack_op(CFI_SP, OP_SRC_REG, 0, rd, OP_DEST_REG_INDIRECT, offset,
+		     var->ops);
+}
+
+/* ------------------------ decode functions ------------------------------- */
+
+#define is_saved_reg(rt)	((rt) == CFI_FP || (rt) == CFI_RA)
+#define is_frame_reg(rt)	((rt) == CFI_FP || (rt) == CFI_SP)
+
+/* ----- Add/Subtract instructions. ----- */
+
+#define CMN_OP		0x31000000	/* Alias of ADDS imm */
+#define CMP_OP		0x71000000	/* Alias of SUBS imm */
+
+static void add(struct decode *decode, struct decode_var *var)
+{
+	unsigned int	rd = var->insn & 0x1F;
+	unsigned int	rn = (var->insn >> 5) & 0x1F;
+	unsigned int	shift = (var->insn >> 22) & 1;
+
+	if (decode->op == CMN_OP || decode->op == CMP_OP)
+		return;
+
+	if (!is_frame_reg(rd))
+		return;
+
+	if (is_frame_reg(rn)) {
+		if (shift)
+			var->imm <<= 12;
+		add_op(var, rn, var->imm, rd);
+	} else {
+		var->type = INSN_UNRELIABLE;
+	}
+}
+
+#define CMN_EXT_OP	0x2B200000	/* Alias of ADDS ext */
+#define CMP_EXT_OP	0x6B200000	/* Alias of SUBS ext */
+
+static void addc(struct decode *decode, struct decode_var *var)
+{
+	unsigned int	rd = var->insn & 0x1F;
+
+	if (decode->op == CMN_EXT_OP || decode->op == CMP_EXT_OP)
+		return;
+
+	if (is_frame_reg(rd))
+		var->type = INSN_UNRELIABLE;
+}
+
+static void sub(struct decode *decode, struct decode_var *var)
+{
+	var->imm = -var->imm;
+	return add(decode, var);
+}
+
+/* ----- Load instructions. ----- */
+
+/*
+ * For some instructions, the target register cannot be FP. There are 3 cases:
+ *
+ *	- The register width is 32 bits. FP cannot be 32 bits.
+ *	- The register is loaded from one that is not the SP. We do not track
+ *	  the value of other registers in static analysis.
+ *	- The instruction does not make sense for the FP to be the target.
+ */
+static void check_reg(unsigned int reg, struct decode_var *var)
+{
+	if (reg == CFI_FP)
+		var->type = INSN_UNRELIABLE;
+}
+
+static void ldp(struct decode *decode, struct decode_var *var)
+{
+	unsigned int	rt1 = var->insn & 0x1F;
+	unsigned int	rt2 = (var->insn >> 10) & 0x1F;
+	unsigned int	rn = (var->insn >> 5) & 0x1F;
+	s64		imm;
+
+	if (rn != CFI_SP || var->check_reg) {
+		check_reg(rt1, var);
+		check_reg(rt2, var);
+	}
+
+	if (rn == CFI_SP) {
+		if (var->mode1 && var->mode2)	/* Pre-index */
+			add_op(var, CFI_SP, var->imm, CFI_SP);
+
+		imm = var->mode1 ? 0 : var->imm;
+		if (is_saved_reg(rt1))
+			load_op(var, imm, rt1);
+		if (is_saved_reg(rt2))
+			load_op(var, imm + 8, rt2);
+
+		if (var->mode1 && !var->mode2)	/* Post-index */
+			add_op(var, CFI_SP, var->imm, CFI_SP);
+	}
+}
+
+static void ldpc(struct decode *decode, struct decode_var *var)
+{
+	var->check_reg = 1;
+	ldp(decode, var);
+}
+
+static void ldr(struct decode *decode, struct decode_var *var)
+{
+	unsigned int	rd = var->insn & 0x1F;
+	unsigned int	rn = (var->insn >> 5) & 0x1F;
+	s64		imm;
+
+	if (rn != CFI_SP || var->check_reg)
+		check_reg(rd, var);
+
+	if (rn == CFI_SP) {
+		if (var->mode1 && var->mode2)	/* Pre-index */
+			add_op(var, CFI_SP, var->imm, CFI_SP);
+
+		imm = var->mode1 ? 0 : var->imm;
+		if (is_saved_reg(rd))
+			load_op(var, imm, rd);
+
+		if (var->mode1 && !var->mode2)	/* Post-index */
+			add_op(var, CFI_SP, var->imm, CFI_SP);
+	}
+}
+
+/* ----- Store instructions. ----- */
+
+static void stp(struct decode *decode, struct decode_var *var)
+{
+	unsigned int	rt1 = var->insn & 0x1F;
+	unsigned int	rt2 = (var->insn >> 10) & 0x1F;
+	unsigned int	rn = (var->insn >> 5) & 0x1F;
+	s64		imm;
+
+	if (var->check_reg) {
+		check_reg(rt1, var);
+		check_reg(rt2, var);
+	}
+
+	if (rn == CFI_SP) {
+		if (var->mode1 && var->mode2)	/* Pre-index */
+			add_op(var, CFI_SP, var->imm, CFI_SP);
+
+		imm = var->mode1 ? 0 : var->imm;
+		if (is_saved_reg(rt1))
+			store_op(var, imm, rt1);
+		if (is_saved_reg(rt2))
+			store_op(var, imm + 8, rt2);
+
+		if (var->mode1 && !var->mode2)	/* Post-index */
+			add_op(var, CFI_SP, var->imm, CFI_SP);
+	}
+}
+
+static void stpc(struct decode *decode, struct decode_var *var)
+{
+	var->check_reg = 1;
+	stp(decode, var);
+}
+
+static void str(struct decode *decode, struct decode_var *var)
+{
+	unsigned int	rd = var->insn & 0x1F;
+	unsigned int	rn = (var->insn >> 5) & 0x1F;
+	s64		imm;
+
+	if (var->check_reg)
+		check_reg(rd, var);
+
+	if (rn == CFI_SP) {
+		if (var->mode1 && var->mode2)	/* Pre-index */
+			add_op(var, CFI_SP, var->imm, CFI_SP);
+
+		imm = var->mode1 ? 0 : var->imm;
+		if (is_saved_reg(rd))
+			store_op(var, imm, rd);
+
+		if (var->mode1 && !var->mode2)	/* Post-index */
+			add_op(var, CFI_SP, var->imm, CFI_SP);
+	}
+}
+
+static void strc(struct decode *decode, struct decode_var *var)
+{
+	var->check_reg = 1;
+	str(decode, var);
+}
+
+/* ----- Control transfer instructions. ----- */
+
+#define BR_UNCONDITIONAL		0x14000000
+
+static void bra(struct decode *decode, struct decode_var *var)
+{
+	if (var->imm) {
+		if (decode->op == BR_UNCONDITIONAL)
+			var->type = INSN_JUMP_UNCONDITIONAL;
+		else
+			var->type = INSN_JUMP_CONDITIONAL;
+	} else {
+		var->type = INSN_JUMP_DYNAMIC;
+	}
+}
+
+static void call(struct decode *decode, struct decode_var *var)
+{
+	var->type = var->imm ? INSN_CALL : INSN_CALL_DYNAMIC;
+}
+
+static void ret(struct decode *decode, struct decode_var *var)
+{
+	var->type = INSN_RETURN;
+}
+
+/* ----- Miscellaneous instructions. ----- */
+
+static void bug(struct decode *decode, struct decode_var *var)
+{
+	var->type = INSN_BUG;
+}
+
+static void pac(struct decode *decode, struct decode_var *var)
+{
+	var->type = INSN_START;
+}
+
+/* ------------------------ Instruction decode ----------------------------- */
+
+struct decode	decode_array[] = {
+/*
+ * mask		OP code mask
+ * opcode	OP code
+ * width	Target register width. Values can be:
+ *			64 (64-bit)
+ *			32 (32-bit),
+ *			 X (64-bit if bit X in the instruction is set)
+ *			-X (32-bit if bit X in the instruction is set)
+ * shift	Shift for the immediate value
+ * bits		Number of bits in the immediate value
+ * sign		Sign extend the immediate value
+ * mult		Multiplier for the immediate value
+ * am1		Addressing mode bit 1
+ * am2		Addressing mode bit 2
+ * func		Decode function
+ *
+ * =============================== INSTRUCTIONS ===============================
+ * mask       opcode   width shift bits sign mult am1 am2 func
+ * ============================================================================
+ */
+{ 0x7E400000, 0x28400000,  31, 15,  7,  1,   0,   23, 24, ldp  /* LDP       */},
+{ 0x7E400000, 0x68400000,  32, 15,  7,  1,   4,   23, 24, ldp  /* LDPSW     */},
+{ 0x7FC00000, 0x28400000,  31, 15,  7,  1,   0,    0,  0, ldpc /* LDNP      */},
+{ 0xBFE00000, 0xB8400000,  30, 12,  9,  1,   1,   10, 11, ldr  /* LDR       */},
+{ 0xBFC00000, 0xB9400000,  30, 10, 12,  0,   0,    0,  0, ldr  /* LDR off   */},
+{ 0xFF200400, 0xF8200400,  64, 12,  9,  1,   8,   11, 11, ldr  /* LDRA      */},
+{ 0xFFC00000, 0x39400000,  32, 10, 12,  0,   1,    0,  0, ldr  /* LDRB off  */},
+{ 0xFFE00000, 0x38400000,  32, 12,  9,  1,   1,   10, 11, ldr  /* LDRB      */},
+{ 0xFFC00000, 0x79400000,  32, 10, 12,  0,   2,    0,  0, ldr  /* LDRH off  */},
+{ 0xFFE00000, 0x78400000,  32, 12,  9,  1,   1,   10, 11, ldr  /* LDRH      */},
+{ 0xFF800000, 0x39800000, -22, 10, 12,  0,   1,    0,  0, ldr  /* LDRSB off */},
+{ 0xFFA00000, 0x38800000, -22, 12,  9,  1,   1,   10, 11, ldr  /* LDRSB     */},
+{ 0xFF800000, 0x79800000, -22, 10, 12,  0,   2,    0,  0, ldr  /* LDRSH off */},
+{ 0xFFA00000, 0x78800000, -22, 12,  9,  1,   1,   10, 11, ldr  /* LDRSH     */},
+{ 0xFFC00000, 0xB9800000,  32, 10, 12,  0,   4,    0,  0, ldr  /* LDRSW off */},
+{ 0xFFE00000, 0xB8800000,  32, 12,  9,  1,   1,   10, 11, ldr  /* LDRSW     */},
+{ 0x7E000000, 0x28000000,  31, 15,  7,  1,   0,   23, 24, stp  /* STP       */},
+{ 0x7E400000, 0x28000000,  31, 15,  7,  1,   0,   23, 24, stp  /* STG       */},
+{ 0xFE400000, 0x68000000,  64, 15,  7,  1,  16,   23, 24, stpc /* STGP      */},
+{ 0x7FC00000, 0x28000000,  31, 15,  7,  1,   0,    0,  0, stpc /* STNP      */},
+{ 0xBFC00000, 0xB9000000,  30, 10, 12,  0,   0,    0,  0, str  /* STR off   */},
+{ 0xBFE00000, 0xB8000000,  30, 12,  9,  1,   1,   10, 11, str  /* STR       */},
+{ 0xFFE00000, 0xD9200000,  64, 12,  9,  1,  16,   10, 11, strc /* STG       */},
+{ 0xFFE00000, 0xD9A00000,  64, 12,  9,  1,  16,   10, 11, strc /* ST2G      */},
+{ 0x7F800000, 0x11000000,  31, 10, 12,  0,   1,    0,  0, add  /* ADD imm   */},
+{ 0x7FE00000, 0x0B200000,  31, 10,  3,  0,   1,    0,  0, addc /* ADD ext   */},
+{ 0x7F800000, 0x31000000,  31, 10, 12,  0,   1,    0,  0, add  /* ADDS imm  */},
+{ 0x7FE00000, 0x2B200000,  31, 10,  3,  0,   1,    0,  0, addc /* ADDS ext  */},
+{ 0x7F800000, 0x51000000,  31, 10, 12,  0,   1,    0,  0, sub  /* SUB imm   */},
+{ 0x7FE00000, 0x4B200000,  31, 10,  3,  0,   1,    0,  0, addc /* SUB ext   */},
+{ 0x7F800000, 0x71000000,  31, 10, 12,  0,   1,    0,  0, sub  /* SUBS imm  */},
+{ 0x7FE00000, 0x6B200000,  31, 10,  3,  0,   1,    0,  0, addc /* SUBS ext  */},
+{ 0xFC000000, 0x14000000,  64,  0, 26,  1,   4,    0,  0, bra  /* B         */},
+{ 0xFF000010, 0x54000000,  64,  5, 19,  1,   4,    0,  0, bra  /* B.cond    */},
+{ 0xFF000010, 0x54000010,  64,  5, 19,  1,   4,    0,  0, bra  /* BC.cond   */},
+{ 0xFFFFFC1F, 0xD61F0000,  64,  0,  0,  0,   0,    0,  0, bra  /* BR        */},
+{ 0xFEFFF800, 0xD61F0800,  64,  0,  0,  0,   0,    0,  0, bra  /* BRA       */},
+{ 0x7E000000, 0x34000000,  31,  5, 19,  1,   4,    0,  0, bra  /* CBZ/CBNZ  */},
+{ 0x7E000000, 0x36000000,  31,  5, 14,  1,   4,    0,  0, bra  /* TBZ/TBNZ  */},
+{ 0xFC000000, 0x94000000,  64,  0, 26,  1,   4,    0,  0, call /* BL        */},
+{ 0xFFFFFC1F, 0xD63F0000,  64,  0,  0,  0,   0,    0,  0, call /* BLR       */},
+{ 0xFEFFF800, 0xD63F0800,  64,  0,  0,  0,   0,    0,  0, call /* BLRA      */},
+{ 0xFFFFFC1F, 0xD65F0000,  64,  0,  0,  0,   0,    0,  0, ret  /* RET       */},
+{ 0xFFFFFBFF, 0xD65F0BFF,  64,  0,  0,  0,   0,    0,  0, ret  /* RETA      */},
+{ 0xFFFFFFFF, 0xD69F03E0,  64,  0,  0,  0,   0,    0,  0, ret  /* ERET      */},
+{ 0xFFFFFBFF, 0xD69F0BFF,  64,  0,  0,  0,   0,    0,  0, ret  /* ERETA     */},
+{ 0xFFE00000, 0xD4200000,  64,  5, 16,  0,   1,    0,  0, bug  /* BRK       */},
+{ 0xFFFFFFFF, 0xD503233F,  64,  0,  0,  0,   1,    0,  0, pac  /* PACIASP   */},
+};
+unsigned int	ndecode = ARRAY_SIZE(decode_array);
+
+static void ignore(struct decode_var *var)
+{
+}
+
+static void check_target(struct decode_var *var)
+{
+	unsigned int	rd = var->insn & 0x1F;
+
+	check_reg(rd, var);
+}
+
+struct class	class_array[] = {
+/*
+ * mask		Class OP mask
+ * opcode	Class OP code
+ * check	Function to perform checks
+ *
+ * ========================== INSTRUCTION CLASSES =============================
+ * mask       opcode       check
+ * ============================================================================
+ */
+{ 0x1E000000, 0x00000000,  ignore        /* RSVD_00 */         },
+{ 0x1E000000, 0x02000000,  ignore        /* UNALLOC_01 */      },
+{ 0x1E000000, 0x04000000,  ignore        /* SVE_02 */          },
+{ 0x1E000000, 0x06000000,  ignore        /* UNALLOC_03 */      },
+{ 0x1E000000, 0x08000000,  check_target  /* LOAD_STORE_04 */   },
+{ 0x1E000000, 0x0A000000,  check_target  /* DP_REGISTER_05 */  },
+{ 0x1E000000, 0x0C000000,  ignore        /* LOAD_STORE_06 */   },
+{ 0x1E000000, 0x0E000000,  ignore        /* SIMD_FP_07 */      },
+{ 0x1E000000, 0x12000000,  check_target  /* DP_IMMEDIATE_09 */ },
+{ 0x1E000000, 0x10000000,  check_target  /* DP_IMMEDIATE_08 */ },
+{ 0x1E000000, 0x14000000,  check_target  /* BR_SYS_10 */       },
+{ 0x1E000000, 0x16000000,  check_target  /* BR_SYS_11 */       },
+{ 0x1E000000, 0x18000000,  check_target  /* LOAD_STORE_12 */   },
+{ 0x1E000000, 0x1A000000,  ignore        /* DP_REGISTER_13 */  },
+{ 0x1E000000, 0x1C000000,  check_target  /* LOAD_STORE_14 */   },
+{ 0x1E000000, 0x1E000000,  ignore        /* SIMD_FP_15 */      },
+};
+unsigned int	nclass = ARRAY_SIZE(class_array);
+
+static inline s64 sign_extend(s64 imm, unsigned int bits)
+{
+	return (imm << (64 - bits)) >> (64 - bits);
+}
 
 int arch_decode_instruction(struct objtool_file *file,
 			    const struct section *sec,
 			    unsigned long offset, unsigned int maxlen,
 			    unsigned int *len, enum insn_type *type,
 			    unsigned long *immediate,
-			    struct list_head *ops_list)
+			    struct list_head *ops)
 {
+	struct decode		*decode;
+	struct decode_var	var;
+	struct class		*class;
+	unsigned int		width, mask, mult, i;
+
+	if (maxlen < INSN_SIZE)
+		return -1;
+	*len = INSN_SIZE;
+
+	var.insn = *(u32 *)(sec->data->d_buf + offset);
+	var.type = INSN_OTHER;
+	var.imm = 0;
+	var.ops = ops;
+
+	*type = INSN_OTHER;
+
+	/* Decode the instruction, if listed. */
+	for (i = 0; i < ndecode; i++) {
+		decode = &decode_array[i];
+
+		if ((var.insn & decode->opmask) != decode->op)
+			continue;
+
+		/* Extract addressing mode (for some instructions). */
+		var.mode1 = 0;
+		var.mode2 = 0;
+		if (decode->mode1)
+			var.mode1 = (var.insn >> decode->mode1) & 1;
+		if (decode->mode2)
+			var.mode2 = (var.insn >> decode->mode2) & 1;
+
+		/* Determine target register width. */
+		width = decode->width;
+		if (width < 0)
+			width = (var.insn & (1 << -width)) ? 32 : 64;
+		else if (width < 32)
+			width = (var.insn & (1 << width)) ? 64 : 32;
+
+		/*
+		 * If the target register width is 32 bits, set the check flag
+		 * so that the target registers are checked to make sure they
+		 * are not the FP or the RA. We should not be using 32-bit
+		 * values in these registers.
+		 */
+		var.check_reg = (width == 32);
+
+		/* Extract the immediate value. */
+		mask = (1 << decode->bits) - 1;
+		var.imm = (var.insn >> decode->shift) & mask;
+		if (decode->sign_extend)
+			var.imm = sign_extend(var.imm, decode->bits);
+
+		/* Scale the immediate value. */
+		mult = decode->mult;
+		if (!mult)
+			mult = (width == 32) ? 4 : 8;
+		var.imm *= mult;
+
+		/* Decode the instruction. */
+		decode->func(decode, &var);
+		goto out;
+	}
+
+	/*
+	 * Sanity check to make sure that the compiler has not generated
+	 * code that modifies the FP or the RA in an unexpected way.
+	 */
+	for (i = 0; i < nclass; i++) {
+		class = &class_array[i];
+		if ((var.insn & class->opmask) == class->op) {
+			class->check(&var);
+			goto out;
+		}
+	}
+out:
+	*immediate = var.imm;
+	*type = var.type;
 	return 0;
 }
diff --git a/tools/objtool/include/objtool/arch.h b/tools/objtool/include/objtool/arch.h
index beb2f3aa94ff..3c2f8c1b8265 100644
--- a/tools/objtool/include/objtool/arch.h
+++ b/tools/objtool/include/objtool/arch.h
@@ -29,6 +29,8 @@ enum insn_type {
 	INSN_TRAP,
 	INSN_ENDBR,
 	INSN_OTHER,
+	INSN_START,
+	INSN_UNRELIABLE,
 };
 
 enum op_dest_type {
-- 
2.25.1

