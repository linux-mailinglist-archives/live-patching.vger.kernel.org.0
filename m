Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48AE673653B
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 09:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbjFTHu0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 03:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjFTHuV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 03:50:21 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0D441A8;
        Tue, 20 Jun 2023 00:50:00 -0700 (PDT)
Received: from loongson.cn (unknown [113.200.148.30])
        by gateway (Coremail) with SMTP id _____8Cx_eonWpFkRRsHAA--.14763S3;
        Tue, 20 Jun 2023 15:49:59 +0800 (CST)
Received: from bogon.localdomain (unknown [113.200.148.30])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxG8oiWpFkN2chAA--.19346S5;
        Tue, 20 Jun 2023 15:49:57 +0800 (CST)
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
Subject: [RFC PATCH v1 08/23] tools: LoongArch: Copy inst.h and asm.h to tools
Date:   Tue, 20 Jun 2023 15:49:49 +0800
Message-Id: <1687247390-31979-4-git-send-email-tangyouling@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1687247390-31979-1-git-send-email-tangyouling@loongson.cn>
References: <1687247390-31979-1-git-send-email-tangyouling@loongson.cn>
X-CM-TRANSID: AQAAf8CxG8oiWpFkN2chAA--.19346S5
X-CM-SenderInfo: 5wdqw5prxox03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj9fXoWfAF4fCw4rKr1kJw15Ary5trc_yoW8tFW7Wo
        WUA3Z8K34rW3y3uwsxGrnavF4fZr1v9rWYy34Ivr1F9a1fZrsxKrnxZw4UXr1fCr42gFWx
        JayqqF1DAFy2vrn3l-sFpf9Il3svdjkaLaAFLSUrUUUUnb8apTn2vfkv8UJUUUU8wcxFpf
        9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
        UjIYCTnIWjp_UUUYE7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
        8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
        Y2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14
        v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x02
        67AKxVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804V
        CY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AK
        xVW3AVW8Xw1lYx0Ex4A2jsIE14v26F4j6r4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2
        IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC
        6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s
        026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF
        0xvE2Ix0cI8IcVAFwI0_tr0E3s1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIx
        AIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26F4j6r4UJwCI42IY6I8E
        87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU0wqXPUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Copy the inst.h and asm.h files to tools/arch/loongarch/include/asm.

In order to avoid subsequent build errors, is_self_loop_ins() is
temporarily removed and INSN_{NOP, BREAK} is renamed, inst.h is
not added to sync-check.sh.

Co-developed-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Youling Tang <tangyouling@loongson.cn>
---
 tools/arch/loongarch/include/asm/asm.h  | 201 ++++++++
 tools/arch/loongarch/include/asm/inst.h | 628 ++++++++++++++++++++++++
 tools/objtool/sync-check.sh             |   6 +
 3 files changed, 835 insertions(+)
 create mode 100644 tools/arch/loongarch/include/asm/asm.h
 create mode 100644 tools/arch/loongarch/include/asm/inst.h

diff --git a/tools/arch/loongarch/include/asm/asm.h b/tools/arch/loongarch/include/asm/asm.h
new file mode 100644
index 000000000000..f591b3245def
--- /dev/null
+++ b/tools/arch/loongarch/include/asm/asm.h
@@ -0,0 +1,201 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Some useful macros for LoongArch assembler code
+ *
+ * Copyright (C) 2020-2022 Loongson Technology Corporation Limited
+ *
+ * Derived from MIPS:
+ * Copyright (C) 1995, 1996, 1997, 1999, 2001 by Ralf Baechle
+ * Copyright (C) 1999 by Silicon Graphics, Inc.
+ * Copyright (C) 2001 MIPS Technologies, Inc.
+ * Copyright (C) 2002  Maciej W. Rozycki
+ */
+#ifndef __ASM_ASM_H
+#define __ASM_ASM_H
+
+/* LoongArch pref instruction. */
+#ifdef CONFIG_CPU_HAS_PREFETCH
+
+#define PREF(hint, addr, offs)				\
+		preld	hint, addr, offs;		\
+
+#define PREFX(hint, addr, index)			\
+		preldx	hint, addr, index;		\
+
+#else /* !CONFIG_CPU_HAS_PREFETCH */
+
+#define PREF(hint, addr, offs)
+#define PREFX(hint, addr, index)
+
+#endif /* !CONFIG_CPU_HAS_PREFETCH */
+
+/*
+ * Stack alignment
+ */
+#define STACK_ALIGN	~(0xf)
+
+/*
+ * Macros to handle different pointer/register sizes for 32/64-bit code
+ */
+
+/*
+ * Size of a register
+ */
+#ifndef __loongarch64
+#define SZREG	4
+#else
+#define SZREG	8
+#endif
+
+/*
+ * Use the following macros in assemblercode to load/store registers,
+ * pointers etc.
+ */
+#if (SZREG == 4)
+#define REG_L		ld.w
+#define REG_S		st.w
+#define REG_ADD		add.w
+#define REG_SUB		sub.w
+#else /* SZREG == 8 */
+#define REG_L		ld.d
+#define REG_S		st.d
+#define REG_ADD		add.d
+#define REG_SUB		sub.d
+#endif
+
+/*
+ * How to add/sub/load/store/shift C int variables.
+ */
+#if (__SIZEOF_INT__ == 4)
+#define INT_ADD		add.w
+#define INT_ADDI	addi.w
+#define INT_SUB		sub.w
+#define INT_L		ld.w
+#define INT_S		st.w
+#define INT_SLL		slli.w
+#define INT_SLLV	sll.w
+#define INT_SRL		srli.w
+#define INT_SRLV	srl.w
+#define INT_SRA		srai.w
+#define INT_SRAV	sra.w
+#endif
+
+#if (__SIZEOF_INT__ == 8)
+#define INT_ADD		add.d
+#define INT_ADDI	addi.d
+#define INT_SUB		sub.d
+#define INT_L		ld.d
+#define INT_S		st.d
+#define INT_SLL		slli.d
+#define INT_SLLV	sll.d
+#define INT_SRL		srli.d
+#define INT_SRLV	srl.d
+#define INT_SRA		srai.d
+#define INT_SRAV	sra.d
+#endif
+
+/*
+ * How to add/sub/load/store/shift C long variables.
+ */
+#if (__SIZEOF_LONG__ == 4)
+#define LONG_ADD	add.w
+#define LONG_ADDI	addi.w
+#define LONG_SUB	sub.w
+#define LONG_L		ld.w
+#define LONG_S		st.w
+#define LONG_SLL	slli.w
+#define LONG_SLLV	sll.w
+#define LONG_SRL	srli.w
+#define LONG_SRLV	srl.w
+#define LONG_SRA	srai.w
+#define LONG_SRAV	sra.w
+
+#ifdef __ASSEMBLY__
+#define LONG		.word
+#endif
+#define LONGSIZE	4
+#define LONGMASK	3
+#define LONGLOG		2
+#endif
+
+#if (__SIZEOF_LONG__ == 8)
+#define LONG_ADD	add.d
+#define LONG_ADDI	addi.d
+#define LONG_SUB	sub.d
+#define LONG_L		ld.d
+#define LONG_S		st.d
+#define LONG_SLL	slli.d
+#define LONG_SLLV	sll.d
+#define LONG_SRL	srli.d
+#define LONG_SRLV	srl.d
+#define LONG_SRA	srai.d
+#define LONG_SRAV	sra.d
+
+#ifdef __ASSEMBLY__
+#define LONG		.dword
+#endif
+#define LONGSIZE	8
+#define LONGMASK	7
+#define LONGLOG		3
+#endif
+
+/*
+ * How to add/sub/load/store/shift pointers.
+ */
+#if (__SIZEOF_POINTER__ == 4)
+#define PTR_ADD		add.w
+#define PTR_ADDI	addi.w
+#define PTR_SUB		sub.w
+#define PTR_L		ld.w
+#define PTR_S		st.w
+#define PTR_LI		li.w
+#define PTR_SLL		slli.w
+#define PTR_SLLV	sll.w
+#define PTR_SRL		srli.w
+#define PTR_SRLV	srl.w
+#define PTR_SRA		srai.w
+#define PTR_SRAV	sra.w
+
+#define PTR_SCALESHIFT	2
+
+#ifdef __ASSEMBLY__
+#define PTR		.word
+#endif
+#define PTRSIZE		4
+#define PTRLOG		2
+#endif
+
+#if (__SIZEOF_POINTER__ == 8)
+#define PTR_ADD		add.d
+#define PTR_ADDI	addi.d
+#define PTR_SUB		sub.d
+#define PTR_L		ld.d
+#define PTR_S		st.d
+#define PTR_LI		li.d
+#define PTR_SLL		slli.d
+#define PTR_SLLV	sll.d
+#define PTR_SRL		srli.d
+#define PTR_SRLV	srl.d
+#define PTR_SRA		srai.d
+#define PTR_SRAV	sra.d
+
+#define PTR_SCALESHIFT	3
+
+#ifdef __ASSEMBLY__
+#define PTR		.dword
+#endif
+#define PTRSIZE		8
+#define PTRLOG		3
+#endif
+
+/* Annotate a function as being unsuitable for kprobes. */
+#ifdef CONFIG_KPROBES
+#define _ASM_NOKPROBE(name)				\
+	.pushsection "_kprobe_blacklist", "aw";		\
+	.quad	name;					\
+	.popsection
+#else
+#define _ASM_NOKPROBE(name)
+#endif
+
+#endif /* __ASM_ASM_H */
diff --git a/tools/arch/loongarch/include/asm/inst.h b/tools/arch/loongarch/include/asm/inst.h
new file mode 100644
index 000000000000..f0533fbc1e63
--- /dev/null
+++ b/tools/arch/loongarch/include/asm/inst.h
@@ -0,0 +1,628 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020-2022 Loongson Technology Corporation Limited
+ */
+#ifndef _ASM_INST_H
+#define _ASM_INST_H
+
+#include <linux/types.h>
+#include <asm/asm.h>
+#include <asm/ptrace.h>
+
+#define LOONGARCH_INSN_NOP	0x03400000
+#define LOONGARCH_INSN_BREAK	0x002a0000
+
+#define ADDR_IMMMASK_LU52ID	0xFFF0000000000000
+#define ADDR_IMMMASK_LU32ID	0x000FFFFF00000000
+#define ADDR_IMMMASK_LU12IW	0x00000000FFFFF000
+#define ADDR_IMMMASK_ADDU16ID	0x00000000FFFF0000
+
+#define ADDR_IMMSHIFT_LU52ID	52
+#define ADDR_IMMSHIFT_LU32ID	32
+#define ADDR_IMMSHIFT_LU12IW	12
+#define ADDR_IMMSHIFT_ADDU16ID	16
+
+#define ADDR_IMM(addr, INSN)	((addr & ADDR_IMMMASK_##INSN) >> ADDR_IMMSHIFT_##INSN)
+
+enum reg0i15_op {
+	break_op	= 0x54,
+};
+
+enum reg0i26_op {
+	b_op		= 0x14,
+	bl_op		= 0x15,
+};
+
+enum reg1i20_op {
+	lu12iw_op	= 0x0a,
+	lu32id_op	= 0x0b,
+	pcaddi_op	= 0x0c,
+	pcalau12i_op	= 0x0d,
+	pcaddu12i_op	= 0x0e,
+	pcaddu18i_op	= 0x0f,
+};
+
+enum reg1i21_op {
+	beqz_op		= 0x10,
+	bnez_op		= 0x11,
+	bceqz_op	= 0x12, /* bits[9:8] = 0x00 */
+	bcnez_op	= 0x12, /* bits[9:8] = 0x01 */
+};
+
+enum reg2_op {
+	revb2h_op	= 0x0c,
+	revb4h_op	= 0x0d,
+	revb2w_op	= 0x0e,
+	revbd_op	= 0x0f,
+	revh2w_op	= 0x10,
+	revhd_op	= 0x11,
+};
+
+enum reg2i5_op {
+	slliw_op	= 0x81,
+	srliw_op	= 0x89,
+	sraiw_op	= 0x91,
+};
+
+enum reg2i6_op {
+	sllid_op	= 0x41,
+	srlid_op	= 0x45,
+	sraid_op	= 0x49,
+};
+
+enum reg2i12_op {
+	addiw_op	= 0x0a,
+	addid_op	= 0x0b,
+	lu52id_op	= 0x0c,
+	andi_op		= 0x0d,
+	ori_op		= 0x0e,
+	xori_op		= 0x0f,
+	ldb_op		= 0xa0,
+	ldh_op		= 0xa1,
+	ldw_op		= 0xa2,
+	ldd_op		= 0xa3,
+	stb_op		= 0xa4,
+	sth_op		= 0xa5,
+	stw_op		= 0xa6,
+	std_op		= 0xa7,
+	ldbu_op		= 0xa8,
+	ldhu_op		= 0xa9,
+	ldwu_op		= 0xaa,
+	flds_op		= 0xac,
+	fsts_op		= 0xad,
+	fldd_op		= 0xae,
+	fstd_op		= 0xaf,
+};
+
+enum reg2i14_op {
+	llw_op		= 0x20,
+	scw_op		= 0x21,
+	lld_op		= 0x22,
+	scd_op		= 0x23,
+	ldptrw_op	= 0x24,
+	stptrw_op	= 0x25,
+	ldptrd_op	= 0x26,
+	stptrd_op	= 0x27,
+};
+
+enum reg2i16_op {
+	jirl_op		= 0x13,
+	beq_op		= 0x16,
+	bne_op		= 0x17,
+	blt_op		= 0x18,
+	bge_op		= 0x19,
+	bltu_op		= 0x1a,
+	bgeu_op		= 0x1b,
+};
+
+enum reg2bstrd_op {
+	bstrinsd_op	= 0x2,
+	bstrpickd_op	= 0x3,
+};
+
+enum reg3_op {
+	addw_op		= 0x20,
+	addd_op		= 0x21,
+	subw_op		= 0x22,
+	subd_op		= 0x23,
+	nor_op		= 0x28,
+	and_op		= 0x29,
+	or_op		= 0x2a,
+	xor_op		= 0x2b,
+	orn_op		= 0x2c,
+	andn_op		= 0x2d,
+	sllw_op		= 0x2e,
+	srlw_op		= 0x2f,
+	sraw_op		= 0x30,
+	slld_op		= 0x31,
+	srld_op		= 0x32,
+	srad_op		= 0x33,
+	mulw_op		= 0x38,
+	mulhw_op	= 0x39,
+	mulhwu_op	= 0x3a,
+	muld_op		= 0x3b,
+	mulhd_op	= 0x3c,
+	mulhdu_op	= 0x3d,
+	divw_op		= 0x40,
+	modw_op		= 0x41,
+	divwu_op	= 0x42,
+	modwu_op	= 0x43,
+	divd_op		= 0x44,
+	modd_op		= 0x45,
+	divdu_op	= 0x46,
+	moddu_op	= 0x47,
+	ldxb_op		= 0x7000,
+	ldxh_op		= 0x7008,
+	ldxw_op		= 0x7010,
+	ldxd_op		= 0x7018,
+	stxb_op		= 0x7020,
+	stxh_op		= 0x7028,
+	stxw_op		= 0x7030,
+	stxd_op		= 0x7038,
+	ldxbu_op	= 0x7040,
+	ldxhu_op	= 0x7048,
+	ldxwu_op	= 0x7050,
+	fldxs_op	= 0x7060,
+	fldxd_op	= 0x7068,
+	fstxs_op	= 0x7070,
+	fstxd_op	= 0x7078,
+	amswapw_op	= 0x70c0,
+	amswapd_op	= 0x70c1,
+	amaddw_op	= 0x70c2,
+	amaddd_op	= 0x70c3,
+	amandw_op	= 0x70c4,
+	amandd_op	= 0x70c5,
+	amorw_op	= 0x70c6,
+	amord_op	= 0x70c7,
+	amxorw_op	= 0x70c8,
+	amxord_op	= 0x70c9,
+};
+
+enum reg3sa2_op {
+	alslw_op	= 0x02,
+	alslwu_op	= 0x03,
+	alsld_op	= 0x16,
+};
+
+struct reg0i15_format {
+	unsigned int immediate : 15;
+	unsigned int opcode : 17;
+};
+
+struct reg0i26_format {
+	unsigned int immediate_h : 10;
+	unsigned int immediate_l : 16;
+	unsigned int opcode : 6;
+};
+
+struct reg1i20_format {
+	unsigned int rd : 5;
+	unsigned int immediate : 20;
+	unsigned int opcode : 7;
+};
+
+struct reg1i21_format {
+	unsigned int immediate_h  : 5;
+	unsigned int rj : 5;
+	unsigned int immediate_l : 16;
+	unsigned int opcode : 6;
+};
+
+struct reg2_format {
+	unsigned int rd : 5;
+	unsigned int rj : 5;
+	unsigned int opcode : 22;
+};
+
+struct reg2i5_format {
+	unsigned int rd : 5;
+	unsigned int rj : 5;
+	unsigned int immediate : 5;
+	unsigned int opcode : 17;
+};
+
+struct reg2i6_format {
+	unsigned int rd : 5;
+	unsigned int rj : 5;
+	unsigned int immediate : 6;
+	unsigned int opcode : 16;
+};
+
+struct reg2i12_format {
+	unsigned int rd : 5;
+	unsigned int rj : 5;
+	unsigned int immediate : 12;
+	unsigned int opcode : 10;
+};
+
+struct reg2i14_format {
+	unsigned int rd : 5;
+	unsigned int rj : 5;
+	unsigned int immediate : 14;
+	unsigned int opcode : 8;
+};
+
+struct reg2i16_format {
+	unsigned int rd : 5;
+	unsigned int rj : 5;
+	unsigned int immediate : 16;
+	unsigned int opcode : 6;
+};
+
+struct reg2bstrd_format {
+	unsigned int rd : 5;
+	unsigned int rj : 5;
+	unsigned int lsbd : 6;
+	unsigned int msbd : 6;
+	unsigned int opcode : 10;
+};
+
+struct reg3_format {
+	unsigned int rd : 5;
+	unsigned int rj : 5;
+	unsigned int rk : 5;
+	unsigned int opcode : 17;
+};
+
+struct reg3sa2_format {
+	unsigned int rd : 5;
+	unsigned int rj : 5;
+	unsigned int rk : 5;
+	unsigned int immediate : 2;
+	unsigned int opcode : 15;
+};
+
+union loongarch_instruction {
+	unsigned int word;
+	struct reg0i15_format	reg0i15_format;
+	struct reg0i26_format	reg0i26_format;
+	struct reg1i20_format	reg1i20_format;
+	struct reg1i21_format	reg1i21_format;
+	struct reg2_format	reg2_format;
+	struct reg2i5_format	reg2i5_format;
+	struct reg2i6_format	reg2i6_format;
+	struct reg2i12_format	reg2i12_format;
+	struct reg2i14_format	reg2i14_format;
+	struct reg2i16_format	reg2i16_format;
+	struct reg2bstrd_format	reg2bstrd_format;
+	struct reg3_format	reg3_format;
+	struct reg3sa2_format	reg3sa2_format;
+};
+
+#define LOONGARCH_INSN_SIZE	sizeof(union loongarch_instruction)
+
+enum loongarch_gpr {
+	LOONGARCH_GPR_ZERO = 0,
+	LOONGARCH_GPR_RA = 1,
+	LOONGARCH_GPR_TP = 2,
+	LOONGARCH_GPR_SP = 3,
+	LOONGARCH_GPR_A0 = 4,	/* Reused as V0 for return value */
+	LOONGARCH_GPR_A1,	/* Reused as V1 for return value */
+	LOONGARCH_GPR_A2,
+	LOONGARCH_GPR_A3,
+	LOONGARCH_GPR_A4,
+	LOONGARCH_GPR_A5,
+	LOONGARCH_GPR_A6,
+	LOONGARCH_GPR_A7,
+	LOONGARCH_GPR_T0 = 12,
+	LOONGARCH_GPR_T1,
+	LOONGARCH_GPR_T2,
+	LOONGARCH_GPR_T3,
+	LOONGARCH_GPR_T4,
+	LOONGARCH_GPR_T5,
+	LOONGARCH_GPR_T6,
+	LOONGARCH_GPR_T7,
+	LOONGARCH_GPR_T8,
+	LOONGARCH_GPR_FP = 22,
+	LOONGARCH_GPR_S0 = 23,
+	LOONGARCH_GPR_S1,
+	LOONGARCH_GPR_S2,
+	LOONGARCH_GPR_S3,
+	LOONGARCH_GPR_S4,
+	LOONGARCH_GPR_S5,
+	LOONGARCH_GPR_S6,
+	LOONGARCH_GPR_S7,
+	LOONGARCH_GPR_S8,
+	LOONGARCH_GPR_MAX
+};
+
+#define is_imm12_negative(val)	is_imm_negative(val, 12)
+
+static inline bool is_imm_negative(unsigned long val, unsigned int bit)
+{
+	return val & (1UL << (bit - 1));
+}
+
+static inline bool is_break_ins(union loongarch_instruction *ip)
+{
+	return ip->reg0i15_format.opcode == break_op;
+}
+
+static inline bool is_pc_ins(union loongarch_instruction *ip)
+{
+	return ip->reg1i20_format.opcode >= pcaddi_op &&
+			ip->reg1i20_format.opcode <= pcaddu18i_op;
+}
+
+static inline bool is_branch_ins(union loongarch_instruction *ip)
+{
+	return ip->reg1i21_format.opcode >= beqz_op &&
+		ip->reg1i21_format.opcode <= bgeu_op;
+}
+
+static inline bool is_ra_save_ins(union loongarch_instruction *ip)
+{
+	/* st.d $ra, $sp, offset */
+	return ip->reg2i12_format.opcode == std_op &&
+		ip->reg2i12_format.rj == LOONGARCH_GPR_SP &&
+		ip->reg2i12_format.rd == LOONGARCH_GPR_RA &&
+		!is_imm12_negative(ip->reg2i12_format.immediate);
+}
+
+static inline bool is_stack_alloc_ins(union loongarch_instruction *ip)
+{
+	/* addi.d $sp, $sp, -imm */
+	return ip->reg2i12_format.opcode == addid_op &&
+		ip->reg2i12_format.rj == LOONGARCH_GPR_SP &&
+		ip->reg2i12_format.rd == LOONGARCH_GPR_SP &&
+		is_imm12_negative(ip->reg2i12_format.immediate);
+}
+
+void simu_pc(struct pt_regs *regs, union loongarch_instruction insn);
+void simu_branch(struct pt_regs *regs, union loongarch_instruction insn);
+
+int larch_insn_read(void *addr, u32 *insnp);
+int larch_insn_write(void *addr, u32 insn);
+int larch_insn_patch_text(void *addr, u32 insn);
+
+u32 larch_insn_gen_nop(void);
+u32 larch_insn_gen_b(unsigned long pc, unsigned long dest);
+u32 larch_insn_gen_bl(unsigned long pc, unsigned long dest);
+
+u32 larch_insn_gen_or(enum loongarch_gpr rd, enum loongarch_gpr rj, enum loongarch_gpr rk);
+u32 larch_insn_gen_move(enum loongarch_gpr rd, enum loongarch_gpr rj);
+
+u32 larch_insn_gen_lu12iw(enum loongarch_gpr rd, int imm);
+u32 larch_insn_gen_lu32id(enum loongarch_gpr rd, int imm);
+u32 larch_insn_gen_lu52id(enum loongarch_gpr rd, enum loongarch_gpr rj, int imm);
+u32 larch_insn_gen_jirl(enum loongarch_gpr rd, enum loongarch_gpr rj, unsigned long pc, unsigned long dest);
+
+static inline bool signed_imm_check(long val, unsigned int bit)
+{
+	return -(1L << (bit - 1)) <= val && val < (1L << (bit - 1));
+}
+
+static inline bool unsigned_imm_check(unsigned long val, unsigned int bit)
+{
+	return val < (1UL << bit);
+}
+
+#define DEF_EMIT_REG0I26_FORMAT(NAME, OP)				\
+static inline void emit_##NAME(union loongarch_instruction *insn,	\
+			       int offset)				\
+{									\
+	unsigned int immediate_l, immediate_h;				\
+									\
+	immediate_l = offset & 0xffff;					\
+	offset >>= 16;							\
+	immediate_h = offset & 0x3ff;					\
+									\
+	insn->reg0i26_format.opcode = OP;				\
+	insn->reg0i26_format.immediate_l = immediate_l;			\
+	insn->reg0i26_format.immediate_h = immediate_h;			\
+}
+
+DEF_EMIT_REG0I26_FORMAT(b, b_op)
+DEF_EMIT_REG0I26_FORMAT(bl, bl_op)
+
+#define DEF_EMIT_REG1I20_FORMAT(NAME, OP)				\
+static inline void emit_##NAME(union loongarch_instruction *insn,	\
+			       enum loongarch_gpr rd, int imm)		\
+{									\
+	insn->reg1i20_format.opcode = OP;				\
+	insn->reg1i20_format.immediate = imm;				\
+	insn->reg1i20_format.rd = rd;					\
+}
+
+DEF_EMIT_REG1I20_FORMAT(lu12iw, lu12iw_op)
+DEF_EMIT_REG1I20_FORMAT(lu32id, lu32id_op)
+DEF_EMIT_REG1I20_FORMAT(pcaddu18i, pcaddu18i_op)
+
+#define DEF_EMIT_REG2_FORMAT(NAME, OP)					\
+static inline void emit_##NAME(union loongarch_instruction *insn,	\
+			       enum loongarch_gpr rd,			\
+			       enum loongarch_gpr rj)			\
+{									\
+	insn->reg2_format.opcode = OP;					\
+	insn->reg2_format.rd = rd;					\
+	insn->reg2_format.rj = rj;					\
+}
+
+DEF_EMIT_REG2_FORMAT(revb2h, revb2h_op)
+DEF_EMIT_REG2_FORMAT(revb2w, revb2w_op)
+DEF_EMIT_REG2_FORMAT(revbd, revbd_op)
+
+#define DEF_EMIT_REG2I5_FORMAT(NAME, OP)				\
+static inline void emit_##NAME(union loongarch_instruction *insn,	\
+			       enum loongarch_gpr rd,			\
+			       enum loongarch_gpr rj,			\
+			       int imm)					\
+{									\
+	insn->reg2i5_format.opcode = OP;				\
+	insn->reg2i5_format.immediate = imm;				\
+	insn->reg2i5_format.rd = rd;					\
+	insn->reg2i5_format.rj = rj;					\
+}
+
+DEF_EMIT_REG2I5_FORMAT(slliw, slliw_op)
+DEF_EMIT_REG2I5_FORMAT(srliw, srliw_op)
+DEF_EMIT_REG2I5_FORMAT(sraiw, sraiw_op)
+
+#define DEF_EMIT_REG2I6_FORMAT(NAME, OP)				\
+static inline void emit_##NAME(union loongarch_instruction *insn,	\
+			       enum loongarch_gpr rd,			\
+			       enum loongarch_gpr rj,			\
+			       int imm)					\
+{									\
+	insn->reg2i6_format.opcode = OP;				\
+	insn->reg2i6_format.immediate = imm;				\
+	insn->reg2i6_format.rd = rd;					\
+	insn->reg2i6_format.rj = rj;					\
+}
+
+DEF_EMIT_REG2I6_FORMAT(sllid, sllid_op)
+DEF_EMIT_REG2I6_FORMAT(srlid, srlid_op)
+DEF_EMIT_REG2I6_FORMAT(sraid, sraid_op)
+
+#define DEF_EMIT_REG2I12_FORMAT(NAME, OP)				\
+static inline void emit_##NAME(union loongarch_instruction *insn,	\
+			       enum loongarch_gpr rd,			\
+			       enum loongarch_gpr rj,			\
+			       int imm)					\
+{									\
+	insn->reg2i12_format.opcode = OP;				\
+	insn->reg2i12_format.immediate = imm;				\
+	insn->reg2i12_format.rd = rd;					\
+	insn->reg2i12_format.rj = rj;					\
+}
+
+DEF_EMIT_REG2I12_FORMAT(addiw, addiw_op)
+DEF_EMIT_REG2I12_FORMAT(addid, addid_op)
+DEF_EMIT_REG2I12_FORMAT(lu52id, lu52id_op)
+DEF_EMIT_REG2I12_FORMAT(andi, andi_op)
+DEF_EMIT_REG2I12_FORMAT(ori, ori_op)
+DEF_EMIT_REG2I12_FORMAT(xori, xori_op)
+DEF_EMIT_REG2I12_FORMAT(ldbu, ldbu_op)
+DEF_EMIT_REG2I12_FORMAT(ldhu, ldhu_op)
+DEF_EMIT_REG2I12_FORMAT(ldwu, ldwu_op)
+DEF_EMIT_REG2I12_FORMAT(ldd, ldd_op)
+DEF_EMIT_REG2I12_FORMAT(stb, stb_op)
+DEF_EMIT_REG2I12_FORMAT(sth, sth_op)
+DEF_EMIT_REG2I12_FORMAT(stw, stw_op)
+DEF_EMIT_REG2I12_FORMAT(std, std_op)
+
+#define DEF_EMIT_REG2I14_FORMAT(NAME, OP)				\
+static inline void emit_##NAME(union loongarch_instruction *insn,	\
+			       enum loongarch_gpr rd,			\
+			       enum loongarch_gpr rj,			\
+			       int imm)					\
+{									\
+	insn->reg2i14_format.opcode = OP;				\
+	insn->reg2i14_format.immediate = imm;				\
+	insn->reg2i14_format.rd = rd;					\
+	insn->reg2i14_format.rj = rj;					\
+}
+
+DEF_EMIT_REG2I14_FORMAT(llw, llw_op)
+DEF_EMIT_REG2I14_FORMAT(scw, scw_op)
+DEF_EMIT_REG2I14_FORMAT(lld, lld_op)
+DEF_EMIT_REG2I14_FORMAT(scd, scd_op)
+DEF_EMIT_REG2I14_FORMAT(ldptrw, ldptrw_op)
+DEF_EMIT_REG2I14_FORMAT(stptrw, stptrw_op)
+DEF_EMIT_REG2I14_FORMAT(ldptrd, ldptrd_op)
+DEF_EMIT_REG2I14_FORMAT(stptrd, stptrd_op)
+
+#define DEF_EMIT_REG2I16_FORMAT(NAME, OP)				\
+static inline void emit_##NAME(union loongarch_instruction *insn,	\
+			       enum loongarch_gpr rj,			\
+			       enum loongarch_gpr rd,			\
+			       int offset)				\
+{									\
+	insn->reg2i16_format.opcode = OP;				\
+	insn->reg2i16_format.immediate = offset;			\
+	insn->reg2i16_format.rj = rj;					\
+	insn->reg2i16_format.rd = rd;					\
+}
+
+DEF_EMIT_REG2I16_FORMAT(beq, beq_op)
+DEF_EMIT_REG2I16_FORMAT(bne, bne_op)
+DEF_EMIT_REG2I16_FORMAT(blt, blt_op)
+DEF_EMIT_REG2I16_FORMAT(bge, bge_op)
+DEF_EMIT_REG2I16_FORMAT(bltu, bltu_op)
+DEF_EMIT_REG2I16_FORMAT(bgeu, bgeu_op)
+DEF_EMIT_REG2I16_FORMAT(jirl, jirl_op)
+
+#define DEF_EMIT_REG2BSTRD_FORMAT(NAME, OP)				\
+static inline void emit_##NAME(union loongarch_instruction *insn,	\
+			       enum loongarch_gpr rd,			\
+			       enum loongarch_gpr rj,			\
+			       int msbd,				\
+			       int lsbd)				\
+{									\
+	insn->reg2bstrd_format.opcode = OP;				\
+	insn->reg2bstrd_format.msbd = msbd;				\
+	insn->reg2bstrd_format.lsbd = lsbd;				\
+	insn->reg2bstrd_format.rj = rj;					\
+	insn->reg2bstrd_format.rd = rd;					\
+}
+
+DEF_EMIT_REG2BSTRD_FORMAT(bstrpickd, bstrpickd_op)
+
+#define DEF_EMIT_REG3_FORMAT(NAME, OP)					\
+static inline void emit_##NAME(union loongarch_instruction *insn,	\
+			       enum loongarch_gpr rd,			\
+			       enum loongarch_gpr rj,			\
+			       enum loongarch_gpr rk)			\
+{									\
+	insn->reg3_format.opcode = OP;					\
+	insn->reg3_format.rd = rd;					\
+	insn->reg3_format.rj = rj;					\
+	insn->reg3_format.rk = rk;					\
+}
+
+DEF_EMIT_REG3_FORMAT(addd, addd_op)
+DEF_EMIT_REG3_FORMAT(subd, subd_op)
+DEF_EMIT_REG3_FORMAT(muld, muld_op)
+DEF_EMIT_REG3_FORMAT(divdu, divdu_op)
+DEF_EMIT_REG3_FORMAT(moddu, moddu_op)
+DEF_EMIT_REG3_FORMAT(and, and_op)
+DEF_EMIT_REG3_FORMAT(or, or_op)
+DEF_EMIT_REG3_FORMAT(xor, xor_op)
+DEF_EMIT_REG3_FORMAT(sllw, sllw_op)
+DEF_EMIT_REG3_FORMAT(slld, slld_op)
+DEF_EMIT_REG3_FORMAT(srlw, srlw_op)
+DEF_EMIT_REG3_FORMAT(srld, srld_op)
+DEF_EMIT_REG3_FORMAT(sraw, sraw_op)
+DEF_EMIT_REG3_FORMAT(srad, srad_op)
+DEF_EMIT_REG3_FORMAT(ldxbu, ldxbu_op)
+DEF_EMIT_REG3_FORMAT(ldxhu, ldxhu_op)
+DEF_EMIT_REG3_FORMAT(ldxwu, ldxwu_op)
+DEF_EMIT_REG3_FORMAT(ldxd, ldxd_op)
+DEF_EMIT_REG3_FORMAT(stxb, stxb_op)
+DEF_EMIT_REG3_FORMAT(stxh, stxh_op)
+DEF_EMIT_REG3_FORMAT(stxw, stxw_op)
+DEF_EMIT_REG3_FORMAT(stxd, stxd_op)
+DEF_EMIT_REG3_FORMAT(amaddw, amaddw_op)
+DEF_EMIT_REG3_FORMAT(amaddd, amaddd_op)
+DEF_EMIT_REG3_FORMAT(amandw, amandw_op)
+DEF_EMIT_REG3_FORMAT(amandd, amandd_op)
+DEF_EMIT_REG3_FORMAT(amorw, amorw_op)
+DEF_EMIT_REG3_FORMAT(amord, amord_op)
+DEF_EMIT_REG3_FORMAT(amxorw, amxorw_op)
+DEF_EMIT_REG3_FORMAT(amxord, amxord_op)
+DEF_EMIT_REG3_FORMAT(amswapw, amswapw_op)
+DEF_EMIT_REG3_FORMAT(amswapd, amswapd_op)
+
+#define DEF_EMIT_REG3SA2_FORMAT(NAME, OP)				\
+static inline void emit_##NAME(union loongarch_instruction *insn,	\
+			       enum loongarch_gpr rd,			\
+			       enum loongarch_gpr rj,			\
+			       enum loongarch_gpr rk,			\
+			       int imm)					\
+{									\
+	insn->reg3sa2_format.opcode = OP;				\
+	insn->reg3sa2_format.immediate = imm;				\
+	insn->reg3sa2_format.rd = rd;					\
+	insn->reg3sa2_format.rj = rj;					\
+	insn->reg3sa2_format.rk = rk;					\
+}
+
+DEF_EMIT_REG3SA2_FORMAT(alsld, alsld_op)
+
+struct pt_regs;
+
+void emulate_load_store_insn(struct pt_regs *regs, void __user *addr, unsigned int *pc);
+unsigned long unaligned_read(void __user *addr, void *value, unsigned long n, bool sign);
+unsigned long unaligned_write(void __user *addr, unsigned long value, unsigned long n);
+
+#endif /* _ASM_INST_H */
diff --git a/tools/objtool/sync-check.sh b/tools/objtool/sync-check.sh
index ee49b4e9e72c..cfee9a034fa7 100755
--- a/tools/objtool/sync-check.sh
+++ b/tools/objtool/sync-check.sh
@@ -28,6 +28,12 @@ arch/x86/lib/insn.c
 '
 fi
 
+if [ "$SRCARCH" = "loongarch" ]; then
+FILES="$FILES
+arch/loongarch/include/asm/asm.h
+"
+fi
+
 check_2 () {
   file1=$1
   file2=$2
-- 
2.39.2

