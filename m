Return-Path: <live-patching+bounces-2757-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CKDDB7vxA2prBAIAu9opvQ
	(envelope-from <live-patching+bounces-2757-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:36:27 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B0EC52CCE2
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 05:36:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D577330B65A0
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 03:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C62B39A077;
	Wed, 13 May 2026 03:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NX/iHzqC"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047F2390616;
	Wed, 13 May 2026 03:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778643274; cv=none; b=XSD7JocbDakmftDSgaz+/AkqlTQMjBq/j6cYDHmBlipFaKPJduaA8dWawdwJyVTwd6DT2hdBT/4O7ks+ZwsTFtXczvrvqcY4hBW/kotOahahdjxdMvX6O4I4IaNkZBhknyrK25DYifzyv5jGq2pgNpOLWwT9BGJVvfuyfWOlh1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778643274; c=relaxed/simple;
	bh=BK3CifmQ1WkuFt4dX+U2VS/JvmYP9M9pIr3ObHQa0Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuVaMPu2R5EoTdyxHK7NbZXfiCH28b3xFKQpLn/xG9U4qhzUeChm7Un/9o81x12p1B/bhCKIOEazC0MtwhLN4nxD7htWjlZ6xY59OcU5+WCco28fEOBPuCv+7O2SaPL0iQPGcRMzxs1Y0f3y2zJUhjGtqWcgmMjO9jXJil3lWfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NX/iHzqC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789A3C2BCF7;
	Wed, 13 May 2026 03:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778643273;
	bh=BK3CifmQ1WkuFt4dX+U2VS/JvmYP9M9pIr3ObHQa0Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NX/iHzqC++d9fDwpHpwxGVQI4CcWNNVIKGcokC2Q73wMAhEomfPT94G1rpXDcvplf
	 qS2VgCf6IuzM1p630X9pQesvSitdpwIbYIq+ttx1GilDw9sWgzYODy/5VroJpmVvch
	 fmRUWc721PGaxyEW2UG3YmYwnmoRUDj5AuKUgJQCIA8zeaHpsohhOVkfDCSEua9r6f
	 nlyvsu9Nt0gw+BciMmIxWzl5at1I41WM8eCRFBA4/QDVxtek96RJ6i45BKnN21Cc+E
	 H7GFCZAt1Ut/rwV7uYHciOIgCBSvfKSKCTH4aSuXN+7Kel01q+NWT+ayRPK5Wk/IfZ
	 Z4Lk5UBSFK1TQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v3 06/21] arm64: Annotate special section entries
Date: Tue, 12 May 2026 20:33:40 -0700
Message-ID: <460a87108015a5afd9e0963e0d64525ebfa27401.1778642120.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1778642120.git.jpoimboe@kernel.org>
References: <cover.1778642120.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6B0EC52CCE2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2757-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

In preparation for adding arm64 support for "objtool klp checksum/diff"
to enable livepatch module generation, annotate special section entries.

This will allow objtool to determine the size and location of the
entries and to extract them when needed.

A new ANNOTATE_DATA_SPECIAL_END annotation is added to mark the end of
special data blocks, which is needed because arm64's replacement
instructions are emitted in .text rather than .altinstr_replacement, so
there's otherwise no way to determine where the last replacement block
ends.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/arm64/include/asm/alternative-macros.h | 27 ++++++++++++++++-----
 arch/arm64/include/asm/asm-bug.h            |  2 ++
 arch/arm64/include/asm/asm-extable.h        | 21 ++++++++++------
 arch/arm64/include/asm/jump_label.h         |  2 ++
 arch/arm64/kernel/asm-offsets.c             |  5 ++++
 include/linux/annotate.h                    | 14 ++++++++++-
 include/linux/objtool_types.h               |  1 +
 tools/include/linux/objtool_types.h         |  1 +
 tools/objtool/klp-diff.c                    |  5 +++-
 9 files changed, 62 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/alternative-macros.h b/arch/arm64/include/asm/alternative-macros.h
index 8624166248528..ba86d655af1d7 100644
--- a/arch/arm64/include/asm/alternative-macros.h
+++ b/arch/arm64/include/asm/alternative-macros.h
@@ -3,11 +3,16 @@
 #define __ASM_ALTERNATIVE_MACROS_H
 
 #include <linux/const.h>
+#include <linux/annotate.h>
 #include <vdso/bits.h>
 
 #include <asm/cpucaps.h>
 #include <asm/insn-def.h>
 
+#ifndef COMPILE_OFFSETS
+#include <asm/asm-offsets.h>
+#endif
+
 /*
  * Binutils 2.27.0 can't handle a 'UL' suffix on constants, so for the assembly
  * macros below we must use we must use `(1 << ARM64_CB_SHIFT)`.
@@ -58,15 +63,18 @@
 	"661:\n\t"							\
 	oldinstr "\n"							\
 	"662:\n"							\
-	".pushsection .altinstructions,\"a\"\n"				\
+	".pushsection .altinstructions,\"aM\", @progbits, "		\
+		      __stringify(ALT_INSTR_SIZE) "\n"			\
 	ALTINSTR_ENTRY(cpucap)						\
 	".popsection\n"							\
 	".subsection 1\n"						\
+	ANNOTATE_DATA_SPECIAL "\n"					\
 	"663:\n\t"							\
 	newinstr "\n"							\
 	"664:\n\t"							\
 	".org	. - (664b-663b) + (662b-661b)\n\t"			\
 	".org	. - (662b-661b) + (664b-663b)\n\t"			\
+	ANNOTATE_DATA_SPECIAL_END "\n\t"					\
 	".previous\n"							\
 	".endif\n"
 
@@ -75,7 +83,8 @@
 	"661:\n\t"							\
 	oldinstr "\n"							\
 	"662:\n"							\
-	".pushsection .altinstructions,\"a\"\n"				\
+	".pushsection .altinstructions,\"aM\", @progbits, "		\
+		      __stringify(ALT_INSTR_SIZE) "\n"			\
 	ALTINSTR_ENTRY_CB(cpucap, cb)					\
 	".popsection\n"							\
 	"663:\n\t"							\
@@ -102,13 +111,15 @@
 .macro alternative_insn insn1, insn2, cap, enable = 1
 	.if \enable
 661:	\insn1
-662:	.pushsection .altinstructions, "a"
+662:	.pushsection .altinstructions, "aM", @progbits, ALT_INSTR_SIZE
 	altinstruction_entry 661b, 663f, \cap, 662b-661b, 664f-663f
 	.popsection
 	.subsection 1
+	ANNOTATE_DATA_SPECIAL
 663:	\insn2
 664:	.org	. - (664b-663b) + (662b-661b)
 	.org	. - (662b-661b) + (664b-663b)
+	ANNOTATE_DATA_SPECIAL_END
 	.previous
 	.endif
 .endm
@@ -137,7 +148,7 @@
  */
 .macro alternative_if_not cap
 	.set .Lasm_alt_mode, 0
-	.pushsection .altinstructions, "a"
+	.pushsection .altinstructions, "aM", @progbits, ALT_INSTR_SIZE
 	altinstruction_entry 661f, 663f, \cap, 662f-661f, 664f-663f
 	.popsection
 661:
@@ -145,17 +156,18 @@
 
 .macro alternative_if cap
 	.set .Lasm_alt_mode, 1
-	.pushsection .altinstructions, "a"
+	.pushsection .altinstructions, "aM", @progbits, ALT_INSTR_SIZE
 	altinstruction_entry 663f, 661f, \cap, 664f-663f, 662f-661f
 	.popsection
 	.subsection 1
 	.align 2	/* So GAS knows label 661 is suitably aligned */
+	ANNOTATE_DATA_SPECIAL
 661:
 .endm
 
 .macro alternative_cb cap, cb
 	.set .Lasm_alt_mode, 0
-	.pushsection .altinstructions, "a"
+	.pushsection .altinstructions, "aM", @progbits, ALT_INSTR_SIZE
 	altinstruction_entry 661f, \cb, (1 << ARM64_CB_SHIFT) | \cap, 662f-661f, 0
 	.popsection
 661:
@@ -168,7 +180,9 @@
 662:
 	.if .Lasm_alt_mode==0
 	.subsection 1
+	ANNOTATE_DATA_SPECIAL
 	.else
+	ANNOTATE_DATA_SPECIAL_END
 	.previous
 	.endif
 663:
@@ -182,6 +196,7 @@
 	.org	. - (664b-663b) + (662b-661b)
 	.org	. - (662b-661b) + (664b-663b)
 	.if .Lasm_alt_mode==0
+	ANNOTATE_DATA_SPECIAL_END
 	.previous
 	.endif
 .endm
diff --git a/arch/arm64/include/asm/asm-bug.h b/arch/arm64/include/asm/asm-bug.h
index a5f13801b7840..22e1a9df9851d 100644
--- a/arch/arm64/include/asm/asm-bug.h
+++ b/arch/arm64/include/asm/asm-bug.h
@@ -5,6 +5,7 @@
  */
 #define __ASM_ASM_BUG_H
 
+#include <linux/annotate.h>
 #include <asm/brk-imm.h>
 
 #ifdef CONFIG_DEBUG_BUGVERBOSE
@@ -24,6 +25,7 @@
 #define __BUG_ENTRY_START				\
 		.pushsection __bug_table,"aw";		\
 		.align 2;				\
+		__ANNOTATE_DATA_SPECIAL;		\
 	14470:	.long 14471f - .;			\
 
 #define __BUG_ENTRY_END					\
diff --git a/arch/arm64/include/asm/asm-extable.h b/arch/arm64/include/asm/asm-extable.h
index d67e2fdd1aee5..e81700edbb936 100644
--- a/arch/arm64/include/asm/asm-extable.h
+++ b/arch/arm64/include/asm/asm-extable.h
@@ -5,6 +5,10 @@
 #include <linux/bits.h>
 #include <asm/gpr-num.h>
 
+#ifndef COMPILE_OFFSETS
+#include <asm/asm-offsets.h>
+#endif
+
 #define EX_TYPE_NONE			0
 #define EX_TYPE_BPF			1
 #define EX_TYPE_UACCESS_ERR_ZERO	2
@@ -29,13 +33,13 @@
 
 #ifdef __ASSEMBLER__
 
-#define __ASM_EXTABLE_RAW(insn, fixup, type, data)	\
-	.pushsection	__ex_table, "a";		\
-	.align		2;				\
-	.long		((insn) - .);			\
-	.long		((fixup) - .);			\
-	.short		(type);				\
-	.short		(data);				\
+#define __ASM_EXTABLE_RAW(insn, fixup, type, data)			\
+	.pushsection	__ex_table, "aM", @progbits, EXTABLE_SIZE;	\
+	.align		2;						\
+	.long		((insn) - .);					\
+	.long		((fixup) - .);					\
+	.short		(type);						\
+	.short		(data);						\
 	.popsection;
 
 #define EX_DATA_REG(reg, gpr)	\
@@ -82,7 +86,8 @@
 #include <linux/stringify.h>
 
 #define __ASM_EXTABLE_RAW(insn, fixup, type, data)	\
-	".pushsection	__ex_table, \"a\"\n"		\
+	".pushsection	__ex_table, \"aM\", @progbits, "\
+			__stringify(EXTABLE_SIZE) "\n"	\
 	".align		2\n"				\
 	".long		((" insn ") - .)\n"		\
 	".long		((" fixup ") - .)\n"		\
diff --git a/arch/arm64/include/asm/jump_label.h b/arch/arm64/include/asm/jump_label.h
index 0cb211d3607d3..4dacb28641d72 100644
--- a/arch/arm64/include/asm/jump_label.h
+++ b/arch/arm64/include/asm/jump_label.h
@@ -11,6 +11,7 @@
 #ifndef __ASSEMBLER__
 
 #include <linux/types.h>
+#include <linux/annotate.h>
 #include <asm/insn.h>
 
 #define HAVE_JUMP_LABEL_BATCH
@@ -19,6 +20,7 @@
 #define JUMP_TABLE_ENTRY(key, label)			\
 	".pushsection	__jump_table, \"aw\"\n\t"	\
 	".align		3\n\t"				\
+	ANNOTATE_DATA_SPECIAL "\n\t"			\
 	".long		1b - ., " label " - .\n\t"	\
 	".quad		" key " - .\n\t"		\
 	".popsection\n\t"
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 44b92f582c127..76251586e31c7 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -23,6 +23,8 @@
 #include <asm/suspend.h>
 #include <linux/kbuild.h>
 #include <linux/arm-smccc.h>
+#include <asm/alternative.h>
+#include <asm/extable.h>
 
 int main(void)
 {
@@ -185,5 +187,8 @@ int main(void)
 #endif
   DEFINE(PIE_E0_ASM, PIE_E0);
   DEFINE(PIE_E1_ASM, PIE_E1);
+  BLANK();
+  DEFINE(ALT_INSTR_SIZE,		sizeof(struct alt_instr));
+  DEFINE(EXTABLE_SIZE,			sizeof(struct exception_table_entry));
   return 0;
 }
diff --git a/include/linux/annotate.h b/include/linux/annotate.h
index 2f1599c9e5732..7f5aa15f353d6 100644
--- a/include/linux/annotate.h
+++ b/include/linux/annotate.h
@@ -3,6 +3,7 @@
 #define _LINUX_ANNOTATE_H
 
 #include <linux/objtool_types.h>
+#include <linux/stringify.h>
 
 #ifdef CONFIG_OBJTOOL
 
@@ -11,6 +12,10 @@
 	.long label - ., type;						\
 	.popsection
 
+#define __ASM_ANNOTATE_DATA(type)					\
+912:									\
+	__ASM_ANNOTATE(.discard.annotate_data, 912b, type)
+
 #ifndef __ASSEMBLY__
 
 #define ASM_ANNOTATE_LABEL(label, type)					\
@@ -39,6 +44,9 @@
 #endif /* __ASSEMBLY__ */
 
 #else /* !CONFIG_OBJTOOL */
+
+#define __ASM_ANNOTATE_DATA(type)
+
 #ifndef __ASSEMBLY__
 #define ASM_ANNOTATE_LABEL(label, type) ""
 #define ASM_ANNOTATE(type)
@@ -106,10 +114,12 @@
 #define ANNOTATE_NOCFI_SYM(sym)		asm(ASM_ANNOTATE_LABEL(sym, ANNOTYPE_NOCFI))
 
 /*
- * Annotate a special section entry.  This emables livepatch module generation
+ * Annotate a special section entry.  This enables livepatch module generation
  * to find and extract individual special section entries as needed.
  */
 #define ANNOTATE_DATA_SPECIAL		ASM_ANNOTATE_DATA(ANNOTYPE_DATA_SPECIAL)
+#define __ANNOTATE_DATA_SPECIAL		__ASM_ANNOTATE_DATA(ANNOTYPE_DATA_SPECIAL)
+#define ANNOTATE_DATA_SPECIAL_END	ASM_ANNOTATE_DATA(ANNOTYPE_DATA_SPECIAL_END)
 
 #else /* __ASSEMBLY__ */
 #define ANNOTATE_NOENDBR		ANNOTATE type=ANNOTYPE_NOENDBR
@@ -122,6 +132,8 @@
 #define ANNOTATE_REACHABLE		ANNOTATE type=ANNOTYPE_REACHABLE
 #define ANNOTATE_NOCFI_SYM		ANNOTATE type=ANNOTYPE_NOCFI
 #define ANNOTATE_DATA_SPECIAL		ANNOTATE_DATA type=ANNOTYPE_DATA_SPECIAL
+#define __ANNOTATE_DATA_SPECIAL		__ASM_ANNOTATE_DATA(ANNOTYPE_DATA_SPECIAL)
+#define ANNOTATE_DATA_SPECIAL_END	ANNOTATE_DATA type=ANNOTYPE_DATA_SPECIAL_END
 #endif /* __ASSEMBLY__ */
 
 #endif /* _LINUX_ANNOTATE_H */
diff --git a/include/linux/objtool_types.h b/include/linux/objtool_types.h
index c6def4049b1ae..744118ffd025f 100644
--- a/include/linux/objtool_types.h
+++ b/include/linux/objtool_types.h
@@ -68,5 +68,6 @@ struct unwind_hint {
 #define ANNOTYPE_NOCFI			9
 
 #define ANNOTYPE_DATA_SPECIAL		1
+#define ANNOTYPE_DATA_SPECIAL_END	2
 
 #endif /* _LINUX_OBJTOOL_TYPES_H */
diff --git a/tools/include/linux/objtool_types.h b/tools/include/linux/objtool_types.h
index c6def4049b1ae..744118ffd025f 100644
--- a/tools/include/linux/objtool_types.h
+++ b/tools/include/linux/objtool_types.h
@@ -68,5 +68,6 @@ struct unwind_hint {
 #define ANNOTYPE_NOCFI			9
 
 #define ANNOTYPE_DATA_SPECIAL		1
+#define ANNOTYPE_DATA_SPECIAL_END	2
 
 #endif /* _LINUX_OBJTOOL_TYPES_H */
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index f8787d7d14547..6a1cec57dc6a3 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1667,7 +1667,10 @@ static int create_fake_symbols(struct elf *elf)
 		size = 0;
 		next_reloc = reloc;
 		for_each_reloc_continue(sec->rsec, next_reloc) {
-			if (annotype(elf, sec, next_reloc) != ANNOTYPE_DATA_SPECIAL ||
+			unsigned int next_type = annotype(elf, sec, next_reloc);
+
+			if ((next_type != ANNOTYPE_DATA_SPECIAL &&
+			     next_type != ANNOTYPE_DATA_SPECIAL_END) ||
 			    next_reloc->sym->sec != reloc->sym->sec)
 				continue;
 
-- 
2.53.0


