Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73190444A12
	for <lists+live-patching@lfdr.de>; Wed,  3 Nov 2021 22:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhKCVKK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 3 Nov 2021 17:10:10 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:21791 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhKCVKK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 3 Nov 2021 17:10:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1635973654; x=1667509654;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=pwZqcl/VyJyVJhvsraqMbhkq73WN/eCXNJlf/Rr9QI0=;
  b=NmPvJW7B+iPZtIgBGAfMFqPluRxGbIKE/lbjr6k2RfMB6kjzJcInY1tu
   lbYbayEXEcdHLQbZwQeJkJMs3lC3G5O9oOUTIcP5z/jPlzGJjaDeHAOOh
   4sGbzTPGvv+oGOF1fYDEZyKuFi3MvTXRsRZ+ntzVy88SqSYL+O82aU6cQ
   0=;
X-IronPort-AV: E=Sophos;i="5.87,206,1631577600"; 
   d="scan'208";a="38972435"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-8691d7ea.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 03 Nov 2021 21:07:32 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-8691d7ea.us-east-1.amazon.com (Postfix) with ESMTPS id 8A1DEC0907;
        Wed,  3 Nov 2021 21:07:30 +0000 (UTC)
Received: from EX13D30UWC001.ant.amazon.com (10.43.162.128) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Wed, 3 Nov 2021 21:07:29 +0000
Received: from u3c3f5cfe23135f.ant.amazon.com (10.43.161.210) by
 EX13D30UWC001.ant.amazon.com (10.43.162.128) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Wed, 3 Nov 2021 21:07:29 +0000
From:   Suraj Jitindar Singh <surajjs@amazon.com>
To:     <linux-arm-kernel@lists.infradead.org>
CC:     <linux-kernel@vger.kernel.org>, <live-patching@vger.kernel.org>,
        <catalin.marinas@arm.com>, <will@kernel.org>,
        <sjitindarsingh@gmail.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
Subject: [PATCH] arm64: module: Use aarch64_insn_write when updating relocations later on
Date:   Wed, 3 Nov 2021 14:07:09 -0700
Message-ID: <20211103210709.31790-1-surajjs@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.210]
X-ClientProxiedBy: EX13D18UWC001.ant.amazon.com (10.43.162.105) To
 EX13D30UWC001.ant.amazon.com (10.43.162.128)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Livepatch modules have relocation sections named
.klp.rela.objname.section_name which are written on module load by calling
klp_apply_section_relocs(). This is called in apply_relocations() to write
relocations targeting objects in the vmlinux, before the module text is
mapped read-only in complete_formation(). However relocations which target
other modules are not written until after the mapping is made read-only
causing them to fault.

Avoid this fault by calling aarch64_insn_write() to update the instruction
if the module text has already been marked read-only. Preserve the current
behaviour if called before this has been done.

Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
---
 arch/arm64/kernel/module.c | 81 ++++++++++++++++++++++----------------
 1 file changed, 47 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index b5ec010c481f..35596ea870ab 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -19,6 +19,7 @@
 #include <asm/alternative.h>
 #include <asm/insn.h>
 #include <asm/sections.h>
+#include <asm/patching.h>
 
 void *module_alloc(unsigned long size)
 {
@@ -155,7 +156,8 @@ enum aarch64_insn_movw_imm_type {
 };
 
 static int reloc_insn_movw(enum aarch64_reloc_op op, __le32 *place, u64 val,
-			   int lsb, enum aarch64_insn_movw_imm_type imm_type)
+			   int lsb, enum aarch64_insn_movw_imm_type imm_type,
+			   bool early)
 {
 	u64 imm;
 	s64 sval;
@@ -187,7 +189,10 @@ static int reloc_insn_movw(enum aarch64_reloc_op op, __le32 *place, u64 val,
 
 	/* Update the instruction with the new encoding. */
 	insn = aarch64_insn_encode_immediate(AARCH64_INSN_IMM_16, insn, imm);
-	*place = cpu_to_le32(insn);
+	if (early)
+		*place = cpu_to_le32(insn);
+	else
+		aarch64_insn_write(place, insn);
 
 	if (imm > U16_MAX)
 		return -ERANGE;
@@ -196,7 +201,8 @@ static int reloc_insn_movw(enum aarch64_reloc_op op, __le32 *place, u64 val,
 }
 
 static int reloc_insn_imm(enum aarch64_reloc_op op, __le32 *place, u64 val,
-			  int lsb, int len, enum aarch64_insn_imm_type imm_type)
+			  int lsb, int len, enum aarch64_insn_imm_type imm_type,
+			  bool early)
 {
 	u64 imm, imm_mask;
 	s64 sval;
@@ -212,7 +218,10 @@ static int reloc_insn_imm(enum aarch64_reloc_op op, __le32 *place, u64 val,
 
 	/* Update the instruction's immediate field. */
 	insn = aarch64_insn_encode_immediate(imm_type, insn, imm);
-	*place = cpu_to_le32(insn);
+	if (early)
+		*place = cpu_to_le32(insn);
+	else
+		aarch64_insn_write(place, insn);
 
 	/*
 	 * Extract the upper value bits (including the sign bit) and
@@ -231,17 +240,17 @@ static int reloc_insn_imm(enum aarch64_reloc_op op, __le32 *place, u64 val,
 }
 
 static int reloc_insn_adrp(struct module *mod, Elf64_Shdr *sechdrs,
-			   __le32 *place, u64 val)
+			   __le32 *place, u64 val, bool early)
 {
 	u32 insn;
 
 	if (!is_forbidden_offset_for_adrp(place))
 		return reloc_insn_imm(RELOC_OP_PAGE, place, val, 12, 21,
-				      AARCH64_INSN_IMM_ADR);
+				      AARCH64_INSN_IMM_ADR, early);
 
 	/* patch ADRP to ADR if it is in range */
 	if (!reloc_insn_imm(RELOC_OP_PREL, place, val & ~0xfff, 0, 21,
-			    AARCH64_INSN_IMM_ADR)) {
+			    AARCH64_INSN_IMM_ADR, early)) {
 		insn = le32_to_cpu(*place);
 		insn &= ~BIT(31);
 	} else {
@@ -253,7 +262,10 @@ static int reloc_insn_adrp(struct module *mod, Elf64_Shdr *sechdrs,
 						   AARCH64_INSN_BRANCH_NOLINK);
 	}
 
-	*place = cpu_to_le32(insn);
+	if (early)
+		*place = cpu_to_le32(insn);
+	else
+		aarch64_insn_write(place, insn);
 	return 0;
 }
 
@@ -270,6 +282,7 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 	void *loc;
 	u64 val;
 	Elf64_Rela *rel = (void *)sechdrs[relsec].sh_addr;
+	bool early = me->state == MODULE_STATE_UNFORMED;
 
 	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
 		/* loc corresponds to P in the AArch64 ELF document. */
@@ -322,88 +335,88 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 			fallthrough;
 		case R_AARCH64_MOVW_UABS_G0:
 			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 0,
-					      AARCH64_INSN_IMM_MOVKZ);
+					      AARCH64_INSN_IMM_MOVKZ, early);
 			break;
 		case R_AARCH64_MOVW_UABS_G1_NC:
 			overflow_check = false;
 			fallthrough;
 		case R_AARCH64_MOVW_UABS_G1:
 			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 16,
-					      AARCH64_INSN_IMM_MOVKZ);
+					      AARCH64_INSN_IMM_MOVKZ, early);
 			break;
 		case R_AARCH64_MOVW_UABS_G2_NC:
 			overflow_check = false;
 			fallthrough;
 		case R_AARCH64_MOVW_UABS_G2:
 			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 32,
-					      AARCH64_INSN_IMM_MOVKZ);
+					      AARCH64_INSN_IMM_MOVKZ, early);
 			break;
 		case R_AARCH64_MOVW_UABS_G3:
 			/* We're using the top bits so we can't overflow. */
 			overflow_check = false;
 			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 48,
-					      AARCH64_INSN_IMM_MOVKZ);
+					      AARCH64_INSN_IMM_MOVKZ, early);
 			break;
 		case R_AARCH64_MOVW_SABS_G0:
 			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 0,
-					      AARCH64_INSN_IMM_MOVNZ);
+					      AARCH64_INSN_IMM_MOVNZ, early);
 			break;
 		case R_AARCH64_MOVW_SABS_G1:
 			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 16,
-					      AARCH64_INSN_IMM_MOVNZ);
+					      AARCH64_INSN_IMM_MOVNZ, early);
 			break;
 		case R_AARCH64_MOVW_SABS_G2:
 			ovf = reloc_insn_movw(RELOC_OP_ABS, loc, val, 32,
-					      AARCH64_INSN_IMM_MOVNZ);
+					      AARCH64_INSN_IMM_MOVNZ, early);
 			break;
 		case R_AARCH64_MOVW_PREL_G0_NC:
 			overflow_check = false;
 			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 0,
-					      AARCH64_INSN_IMM_MOVKZ);
+					      AARCH64_INSN_IMM_MOVKZ, early);
 			break;
 		case R_AARCH64_MOVW_PREL_G0:
 			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 0,
-					      AARCH64_INSN_IMM_MOVNZ);
+					      AARCH64_INSN_IMM_MOVNZ, early);
 			break;
 		case R_AARCH64_MOVW_PREL_G1_NC:
 			overflow_check = false;
 			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 16,
-					      AARCH64_INSN_IMM_MOVKZ);
+					      AARCH64_INSN_IMM_MOVKZ, early);
 			break;
 		case R_AARCH64_MOVW_PREL_G1:
 			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 16,
-					      AARCH64_INSN_IMM_MOVNZ);
+					      AARCH64_INSN_IMM_MOVNZ, early);
 			break;
 		case R_AARCH64_MOVW_PREL_G2_NC:
 			overflow_check = false;
 			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 32,
-					      AARCH64_INSN_IMM_MOVKZ);
+					      AARCH64_INSN_IMM_MOVKZ, early);
 			break;
 		case R_AARCH64_MOVW_PREL_G2:
 			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 32,
-					      AARCH64_INSN_IMM_MOVNZ);
+					      AARCH64_INSN_IMM_MOVNZ, early);
 			break;
 		case R_AARCH64_MOVW_PREL_G3:
 			/* We're using the top bits so we can't overflow. */
 			overflow_check = false;
 			ovf = reloc_insn_movw(RELOC_OP_PREL, loc, val, 48,
-					      AARCH64_INSN_IMM_MOVNZ);
+					      AARCH64_INSN_IMM_MOVNZ, early);
 			break;
 
 		/* Immediate instruction relocations. */
 		case R_AARCH64_LD_PREL_LO19:
 			ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 2, 19,
-					     AARCH64_INSN_IMM_19);
+					     AARCH64_INSN_IMM_19, early);
 			break;
 		case R_AARCH64_ADR_PREL_LO21:
 			ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 0, 21,
-					     AARCH64_INSN_IMM_ADR);
+					     AARCH64_INSN_IMM_ADR, early);
 			break;
 		case R_AARCH64_ADR_PREL_PG_HI21_NC:
 			overflow_check = false;
 			fallthrough;
 		case R_AARCH64_ADR_PREL_PG_HI21:
-			ovf = reloc_insn_adrp(me, sechdrs, loc, val);
+			ovf = reloc_insn_adrp(me, sechdrs, loc, val, early);
 			if (ovf && ovf != -ERANGE)
 				return ovf;
 			break;
@@ -411,40 +424,40 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 		case R_AARCH64_LDST8_ABS_LO12_NC:
 			overflow_check = false;
 			ovf = reloc_insn_imm(RELOC_OP_ABS, loc, val, 0, 12,
-					     AARCH64_INSN_IMM_12);
+					     AARCH64_INSN_IMM_12, early);
 			break;
 		case R_AARCH64_LDST16_ABS_LO12_NC:
 			overflow_check = false;
 			ovf = reloc_insn_imm(RELOC_OP_ABS, loc, val, 1, 11,
-					     AARCH64_INSN_IMM_12);
+					     AARCH64_INSN_IMM_12, early);
 			break;
 		case R_AARCH64_LDST32_ABS_LO12_NC:
 			overflow_check = false;
 			ovf = reloc_insn_imm(RELOC_OP_ABS, loc, val, 2, 10,
-					     AARCH64_INSN_IMM_12);
+					     AARCH64_INSN_IMM_12, early);
 			break;
 		case R_AARCH64_LDST64_ABS_LO12_NC:
 			overflow_check = false;
 			ovf = reloc_insn_imm(RELOC_OP_ABS, loc, val, 3, 9,
-					     AARCH64_INSN_IMM_12);
+					     AARCH64_INSN_IMM_12, early);
 			break;
 		case R_AARCH64_LDST128_ABS_LO12_NC:
 			overflow_check = false;
 			ovf = reloc_insn_imm(RELOC_OP_ABS, loc, val, 4, 8,
-					     AARCH64_INSN_IMM_12);
+					     AARCH64_INSN_IMM_12, early);
 			break;
 		case R_AARCH64_TSTBR14:
 			ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 2, 14,
-					     AARCH64_INSN_IMM_14);
+					     AARCH64_INSN_IMM_14, early);
 			break;
 		case R_AARCH64_CONDBR19:
 			ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 2, 19,
-					     AARCH64_INSN_IMM_19);
+					     AARCH64_INSN_IMM_19, early);
 			break;
 		case R_AARCH64_JUMP26:
 		case R_AARCH64_CALL26:
 			ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 2, 26,
-					     AARCH64_INSN_IMM_26);
+					     AARCH64_INSN_IMM_26, early);
 
 			if (IS_ENABLED(CONFIG_ARM64_MODULE_PLTS) &&
 			    ovf == -ERANGE) {
@@ -452,7 +465,7 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 				if (!val)
 					return -ENOEXEC;
 				ovf = reloc_insn_imm(RELOC_OP_PREL, loc, val, 2,
-						     26, AARCH64_INSN_IMM_26);
+						     26, AARCH64_INSN_IMM_26, early);
 			}
 			break;
 
-- 
2.17.1

