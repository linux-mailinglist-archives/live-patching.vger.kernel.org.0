Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD7B73655C
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 09:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbjFTHxi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 03:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbjFTHx0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 03:53:26 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BDA8410C2;
        Tue, 20 Jun 2023 00:53:03 -0700 (PDT)
Received: from loongson.cn (unknown [113.200.148.30])
        by gateway (Coremail) with SMTP id _____8BxrOqqWpFkJBwHAA--.14453S3;
        Tue, 20 Jun 2023 15:52:10 +0800 (CST)
Received: from bogon.localdomain (unknown [113.200.148.30])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxauWoWpFkdmghAA--.28374S2;
        Tue, 20 Jun 2023 15:52:08 +0800 (CST)
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
Subject: [RFC PATCH v1 15/23] objtool: Add ORC support for LoongArch
Date:   Tue, 20 Jun 2023 15:52:02 +0800
Message-Id: <1687247526-32258-1-git-send-email-tangyouling@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf8AxauWoWpFkdmghAA--.28374S2
X-CM-SenderInfo: 5wdqw5prxox03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj9fXoWftF1kJw17Kw1DAFyrAr15Jrc_yoW8ur18Go
        W7tF4Fkr4xGry7uF1Dt3s7GrZ5Xr4vkrWUJa4YvFZxJ3WrA34jkr109a15tay3tr4vgrZ5
        CFWxX3y3ArZ7JFn7l-sFpf9Il3svdjkaLaAFLSUrUUUUnb8apTn2vfkv8UJUUUU8wcxFpf
        9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
        UjIYCTnIWjp_UUUOI7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
        8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
        Y2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14
        v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x02
        67AKxVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804V
        CY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AK
        xVW8Xw0E3s1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y4
        8IcxkI7VAKI48JM4x0Y40E4IxF1VCIxcxG6Fyj6r4UJwCY1x0262kKe7AKxVWUAVWUtwCF
        04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtw
        C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
        wI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWDJVCq3wCI42IY6xIIjx
        v20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
        z280aVAFwI0_Gr1j6F4UJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2Kf
        nxnUUI43ZEXa7IUYyMKtUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Add ORC support for the LoongArch in objtool, mainly including ORC unwind
table generation and dumping, in preparation for subsequent ORC unwinder
support.

Co-developed-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Youling Tang <tangyouling@loongson.cn>
---
 arch/loongarch/Kconfig                        |   2 +
 arch/loongarch/Makefile                       |   4 +
 arch/loongarch/include/asm/orc_types.h        |  58 +++++++
 arch/loongarch/include/asm/unwind_hints.h     | 110 +++++++++++++
 scripts/Makefile                              |   5 +-
 tools/arch/loongarch/include/asm/orc_types.h  |  58 +++++++
 .../arch/loongarch/include/asm/unwind_hints.h |  86 ++++++++++
 tools/objtool/Makefile                        |   2 +
 tools/objtool/arch/loongarch/Build            |   1 +
 tools/objtool/arch/loongarch/decode.c         |  17 +-
 tools/objtool/arch/loongarch/orc.c            | 155 ++++++++++++++++++
 tools/objtool/include/objtool/objtool.h       |   3 +
 tools/objtool/orc_gen.c                       |   5 +
 tools/objtool/sync-check.sh                   |   2 +
 14 files changed, 506 insertions(+), 2 deletions(-)
 create mode 100644 arch/loongarch/include/asm/orc_types.h
 create mode 100644 arch/loongarch/include/asm/unwind_hints.h
 create mode 100644 tools/arch/loongarch/include/asm/orc_types.h
 create mode 100644 tools/objtool/arch/loongarch/orc.c

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 7fd51257e0ed..dd8143ea33c4 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -111,6 +111,7 @@ config LOONGARCH
 	select HAVE_KRETPROBES
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI
+	select HAVE_OBJTOOL if AS_HAS_EXPLICIT_RELOCS
 	select HAVE_PCI
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
@@ -119,6 +120,7 @@ config LOONGARCH
 	select HAVE_RSEQ
 	select HAVE_SETUP_PER_CPU_AREA if NUMA
 	select HAVE_STACKPROTECTOR
+	select HAVE_STACK_VALIDATION if HAVE_OBJTOOL
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_TIF_NOHZ
 	select HAVE_VIRT_CPU_ACCOUNTING_GEN if !SMP
diff --git a/arch/loongarch/Makefile b/arch/loongarch/Makefile
index f71edf574101..848b595332c2 100644
--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -25,6 +25,10 @@ endif
 32bit-emul		= elf32loongarch
 64bit-emul		= elf64loongarch
 
+ifeq ($(CONFIG_OBJTOOL),y)
+KBUILD_CFLAGS  += -fno-jump-tables
+endif
+
 ifdef CONFIG_DYNAMIC_FTRACE
 KBUILD_CPPFLAGS += -DCC_USING_PATCHABLE_FUNCTION_ENTRY
 CC_FLAGS_FTRACE := -fpatchable-function-entry=2
diff --git a/arch/loongarch/include/asm/orc_types.h b/arch/loongarch/include/asm/orc_types.h
new file mode 100644
index 000000000000..97976927bda5
--- /dev/null
+++ b/arch/loongarch/include/asm/orc_types.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _ORC_TYPES_H
+#define _ORC_TYPES_H
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+
+/*
+ * The ORC_REG_* registers are base registers which are used to find other
+ * registers on the stack.
+ *
+ * ORC_REG_PREV_SP, also known as DWARF Call Frame Address (CFA), is the
+ * address of the previous frame: the caller's SP before it called the current
+ * function.
+ *
+ * ORC_REG_UNDEFINED means the corresponding register's value didn't change in
+ * the current frame.
+ *
+ * The most commonly used base registers are SP and BP -- which the previous SP
+ * is usually based on -- and PREV_SP and UNDEFINED -- which the previous BP is
+ * usually based on.
+ *
+ * The rest of the base registers are needed for special cases like entry code
+ * and GCC realigned stacks.
+ */
+#define ORC_REG_UNDEFINED		0
+#define ORC_REG_PREV_SP			1
+#define ORC_REG_SP			2
+#define ORC_REG_BP			3
+#define ORC_REG_MAX			4
+
+#ifndef __ASSEMBLY__
+#include <asm/byteorder.h>
+
+/*
+ * This struct is more or less a vastly simplified version of the DWARF Call
+ * Frame Information standard.  It contains only the necessary parts of DWARF
+ * CFI, simplified for ease of access by the in-kernel unwinder.  It tells the
+ * unwinder how to find the previous SP and BP (and sometimes entry regs) on
+ * the stack for a given code address.  Each instance of the struct corresponds
+ * to one or more code locations.
+ */
+struct orc_entry {
+	s16		sp_offset;
+	s16		bp_offset;
+	s16		ra_offset;
+	unsigned int	sp_reg:4;
+	unsigned int	bp_reg:4;
+	unsigned int	ra_reg:4;
+	unsigned int	type:2;
+	unsigned	signal:1;
+	unsigned int	end:1;
+} __packed;
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ORC_TYPES_H */
diff --git a/arch/loongarch/include/asm/unwind_hints.h b/arch/loongarch/include/asm/unwind_hints.h
new file mode 100644
index 000000000000..de18b08de1fc
--- /dev/null
+++ b/arch/loongarch/include/asm/unwind_hints.h
@@ -0,0 +1,110 @@
+#ifndef _ASM_LOONGARCH_UNWIND_HINTS_H
+#define _ASM_LOONGARCH_UNWIND_HINTS_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+
+/*
+ * This struct is used by asm and inline asm code to manually annotate the
+ * location of registers on the stack.
+ */
+struct unwind_hint {
+	u32		ip;
+	s16		sp_offset;
+	u8		sp_reg;
+	u8		type;
+	u8		signal;
+	u8		end;
+};
+#endif
+
+#include <linux/objtool.h>
+
+#include "orc_types.h"
+
+#ifdef CONFIG_OBJTOOL
+
+#ifndef __ASSEMBLY__
+
+#define UNWIND_HINT(sp_reg, sp_offset, type, signal, end)	\
+	"987: \n\t"						\
+	".pushsection .discard.unwind_hints\n\t"		\
+	/* struct unwind_hint */				\
+	".long 987b - .\n\t"					\
+	".short " __stringify(sp_offset) "\n\t"			\
+	".byte " __stringify(sp_reg) "\n\t"			\
+	".byte " __stringify(type) "\n\t"			\
+	".byte " __stringify(signal) "\n\t"			\
+	".byte " __stringify(end) "\n\t"			\
+	".balign 4 \n\t"					\
+	".popsection\n\t"
+
+#else /* __ASSEMBLY__ */
+
+/*
+ * In asm, there are two kinds of code: normal C-type callable functions and
+ * the rest.  The normal callable functions can be called by other code, and
+ * don't do anything unusual with the stack.  Such normal callable functions
+ * are annotated with the ENTRY/ENDPROC macros.  Most asm code falls in this
+ * category.  In this case, no special debugging annotations are needed because
+ * objtool can automatically generate the ORC data for the ORC unwinder to read
+ * at runtime.
+ *
+ * Anything which doesn't fall into the above category, such as syscall and
+ * interrupt handlers, tends to not be called directly by other functions, and
+ * often does unusual non-C-function-type things with the stack pointer.  Such
+ * code needs to be annotated such that objtool can understand it.  The
+ * following CFI hint macros are for this type of code.
+ *
+ * These macros provide hints to objtool about the state of the stack at each
+ * instruction.  Objtool starts from the hints and follows the code flow,
+ * making automatic CFI adjustments when it sees pushes and pops, filling out
+ * the debuginfo as necessary.  It will also warn if it sees any
+ * inconsistencies.
+ */
+.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0 end=0
+.Lunwind_hint_ip_\@:
+	.pushsection .discard.unwind_hints
+		/* struct unwind_hint */
+		.long .Lunwind_hint_ip_\@ - .
+		.short \sp_offset
+		.byte \sp_reg
+		.byte \type
+		.byte \signal
+		.byte \end
+		.balign 4
+	.popsection
+.endm
+
+#endif /* __ASSEMBLY__ */
+
+#else /* !CONFIG_OBJTOOL */
+
+#ifndef __ASSEMBLY__
+#define UNWIND_HINT(sp_reg, sp_offset, type, signal, end)	\
+	"\n\t"
+#else
+.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0 end=0
+.endm
+#endif
+
+#endif /* CONFIG_OBJTOOL */
+
+#ifdef __ASSEMBLY__
+
+.macro UNWIND_HINT_EMPTY
+	UNWIND_HINT sp_reg=ORC_REG_UNDEFINED type=UNWIND_HINT_TYPE_CALL end=1
+.endm
+
+.macro UNWIND_HINT_REGS base=ORC_REG_SP offset=0
+	UNWIND_HINT sp_reg=\base sp_offset=\offset type=UNWIND_HINT_TYPE_REGS
+.endm
+
+.macro UNWIND_HINT_FUNC sp_offset=0
+	UNWIND_HINT sp_reg=ORC_REG_SP sp_offset=\sp_offset type=UNWIND_HINT_TYPE_CALL
+.endm
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_LOONGARCH_UNWIND_HINTS_H */
diff --git a/scripts/Makefile b/scripts/Makefile
index 32b6ba722728..d62d85f86658 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -29,7 +29,10 @@ ifdef CONFIG_UNWINDER_ORC
 ifeq ($(ARCH),x86_64)
 ARCH := x86
 endif
-HOSTCFLAGS_sorttable.o += -I$(srctree)/tools/arch/x86/include
+ifeq ($(ARCH),loongarch)
+ARCH := loongarch
+endif
+HOSTCFLAGS_sorttable.o += -I$(srctree)/tools/arch/$(ARCH)/include
 HOSTCFLAGS_sorttable.o += -DUNWINDER_ORC_ENABLED
 endif
 
diff --git a/tools/arch/loongarch/include/asm/orc_types.h b/tools/arch/loongarch/include/asm/orc_types.h
new file mode 100644
index 000000000000..97976927bda5
--- /dev/null
+++ b/tools/arch/loongarch/include/asm/orc_types.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _ORC_TYPES_H
+#define _ORC_TYPES_H
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+
+/*
+ * The ORC_REG_* registers are base registers which are used to find other
+ * registers on the stack.
+ *
+ * ORC_REG_PREV_SP, also known as DWARF Call Frame Address (CFA), is the
+ * address of the previous frame: the caller's SP before it called the current
+ * function.
+ *
+ * ORC_REG_UNDEFINED means the corresponding register's value didn't change in
+ * the current frame.
+ *
+ * The most commonly used base registers are SP and BP -- which the previous SP
+ * is usually based on -- and PREV_SP and UNDEFINED -- which the previous BP is
+ * usually based on.
+ *
+ * The rest of the base registers are needed for special cases like entry code
+ * and GCC realigned stacks.
+ */
+#define ORC_REG_UNDEFINED		0
+#define ORC_REG_PREV_SP			1
+#define ORC_REG_SP			2
+#define ORC_REG_BP			3
+#define ORC_REG_MAX			4
+
+#ifndef __ASSEMBLY__
+#include <asm/byteorder.h>
+
+/*
+ * This struct is more or less a vastly simplified version of the DWARF Call
+ * Frame Information standard.  It contains only the necessary parts of DWARF
+ * CFI, simplified for ease of access by the in-kernel unwinder.  It tells the
+ * unwinder how to find the previous SP and BP (and sometimes entry regs) on
+ * the stack for a given code address.  Each instance of the struct corresponds
+ * to one or more code locations.
+ */
+struct orc_entry {
+	s16		sp_offset;
+	s16		bp_offset;
+	s16		ra_offset;
+	unsigned int	sp_reg:4;
+	unsigned int	bp_reg:4;
+	unsigned int	ra_reg:4;
+	unsigned int	type:2;
+	unsigned	signal:1;
+	unsigned int	end:1;
+} __packed;
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ORC_TYPES_H */
diff --git a/tools/arch/loongarch/include/asm/unwind_hints.h b/tools/arch/loongarch/include/asm/unwind_hints.h
index ac48ee34bf7b..de18b08de1fc 100644
--- a/tools/arch/loongarch/include/asm/unwind_hints.h
+++ b/tools/arch/loongarch/include/asm/unwind_hints.h
@@ -21,4 +21,90 @@ struct unwind_hint {
 
 #include <linux/objtool.h>
 
+#include "orc_types.h"
+
+#ifdef CONFIG_OBJTOOL
+
+#ifndef __ASSEMBLY__
+
+#define UNWIND_HINT(sp_reg, sp_offset, type, signal, end)	\
+	"987: \n\t"						\
+	".pushsection .discard.unwind_hints\n\t"		\
+	/* struct unwind_hint */				\
+	".long 987b - .\n\t"					\
+	".short " __stringify(sp_offset) "\n\t"			\
+	".byte " __stringify(sp_reg) "\n\t"			\
+	".byte " __stringify(type) "\n\t"			\
+	".byte " __stringify(signal) "\n\t"			\
+	".byte " __stringify(end) "\n\t"			\
+	".balign 4 \n\t"					\
+	".popsection\n\t"
+
+#else /* __ASSEMBLY__ */
+
+/*
+ * In asm, there are two kinds of code: normal C-type callable functions and
+ * the rest.  The normal callable functions can be called by other code, and
+ * don't do anything unusual with the stack.  Such normal callable functions
+ * are annotated with the ENTRY/ENDPROC macros.  Most asm code falls in this
+ * category.  In this case, no special debugging annotations are needed because
+ * objtool can automatically generate the ORC data for the ORC unwinder to read
+ * at runtime.
+ *
+ * Anything which doesn't fall into the above category, such as syscall and
+ * interrupt handlers, tends to not be called directly by other functions, and
+ * often does unusual non-C-function-type things with the stack pointer.  Such
+ * code needs to be annotated such that objtool can understand it.  The
+ * following CFI hint macros are for this type of code.
+ *
+ * These macros provide hints to objtool about the state of the stack at each
+ * instruction.  Objtool starts from the hints and follows the code flow,
+ * making automatic CFI adjustments when it sees pushes and pops, filling out
+ * the debuginfo as necessary.  It will also warn if it sees any
+ * inconsistencies.
+ */
+.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0 end=0
+.Lunwind_hint_ip_\@:
+	.pushsection .discard.unwind_hints
+		/* struct unwind_hint */
+		.long .Lunwind_hint_ip_\@ - .
+		.short \sp_offset
+		.byte \sp_reg
+		.byte \type
+		.byte \signal
+		.byte \end
+		.balign 4
+	.popsection
+.endm
+
+#endif /* __ASSEMBLY__ */
+
+#else /* !CONFIG_OBJTOOL */
+
+#ifndef __ASSEMBLY__
+#define UNWIND_HINT(sp_reg, sp_offset, type, signal, end)	\
+	"\n\t"
+#else
+.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0 end=0
+.endm
+#endif
+
+#endif /* CONFIG_OBJTOOL */
+
+#ifdef __ASSEMBLY__
+
+.macro UNWIND_HINT_EMPTY
+	UNWIND_HINT sp_reg=ORC_REG_UNDEFINED type=UNWIND_HINT_TYPE_CALL end=1
+.endm
+
+.macro UNWIND_HINT_REGS base=ORC_REG_SP offset=0
+	UNWIND_HINT sp_reg=\base sp_offset=\offset type=UNWIND_HINT_TYPE_REGS
+.endm
+
+.macro UNWIND_HINT_FUNC sp_offset=0
+	UNWIND_HINT sp_reg=ORC_REG_SP sp_offset=\sp_offset type=UNWIND_HINT_TYPE_CALL
+.endm
+
+#endif /* __ASSEMBLY__ */
+
 #endif /* _ASM_LOONGARCH_UNWIND_HINTS_H */
diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index 034fbd9f3f13..d641423aa70b 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -59,9 +59,11 @@ ifeq ($(SRCARCH),x86)
 endif
 
 ifeq ($(SRCARCH),loongarch)
+	BUILD_ORC := y
 	STATIC_CHECK := y
 endif
 
+
 export BUILD_ORC STATIC_CHECK
 export srctree OUTPUT CFLAGS SRCARCH AWK
 include $(srctree)/tools/build/Makefile.include
diff --git a/tools/objtool/arch/loongarch/Build b/tools/objtool/arch/loongarch/Build
index d24d5636a5b8..1d4b784b6887 100644
--- a/tools/objtool/arch/loongarch/Build
+++ b/tools/objtool/arch/loongarch/Build
@@ -1,2 +1,3 @@
 objtool-y += decode.o
 objtool-y += special.o
+objtool-y += orc.o
diff --git a/tools/objtool/arch/loongarch/decode.c b/tools/objtool/arch/loongarch/decode.c
index fc24efd6dba2..90adbbeab8d4 100644
--- a/tools/objtool/arch/loongarch/decode.c
+++ b/tools/objtool/arch/loongarch/decode.c
@@ -5,6 +5,7 @@
 
 #include <linux/bitops.h>
 #include <asm/inst.h>
+#include <asm/orc_types.h>
 
 #include <objtool/check.h>
 #include <objtool/elf.h>
@@ -49,7 +50,21 @@ bool arch_callee_saved_reg(unsigned char reg)
 
 int arch_decode_hint_reg(u8 sp_reg, int *base)
 {
-	exit(-1);
+	switch (sp_reg) {
+	case ORC_REG_UNDEFINED:
+		*base = CFI_UNDEFINED;
+		break;
+	case ORC_REG_SP:
+		*base = CFI_SP;
+		break;
+	case ORC_REG_BP:
+		*base = CFI_FP;
+		break;
+	default:
+		return -1;
+	}
+
+	return 0;
 }
 
 const char *arch_nop_insn(int len)
diff --git a/tools/objtool/arch/loongarch/orc.c b/tools/objtool/arch/loongarch/orc.c
new file mode 100644
index 000000000000..a1adb1e6755b
--- /dev/null
+++ b/tools/objtool/arch/loongarch/orc.c
@@ -0,0 +1,155 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <stdlib.h>
+
+#include <linux/objtool.h>
+
+#include <objtool/check.h>
+#include <objtool/orc.h>
+#include <objtool/warn.h>
+#include <objtool/endianness.h>
+
+int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi,
+		   struct instruction *insn)
+{
+	struct cfi_reg *bp = &cfi->regs[CFI_BP];
+	struct cfi_reg *ra = &cfi->regs[CFI_RA];
+
+	memset(orc, 0, sizeof(*orc));
+
+	if (!cfi) {
+		orc->end = 0;
+		orc->sp_reg = ORC_REG_UNDEFINED;
+		return 0;
+	}
+
+	orc->end = cfi->end;
+
+	if (cfi->cfa.base == CFI_UNDEFINED) {
+		orc->sp_reg = ORC_REG_UNDEFINED;
+		return 0;
+	}
+
+	switch (cfi->cfa.base) {
+	case CFI_SP:
+		orc->sp_reg = ORC_REG_SP;
+		break;
+	case CFI_BP:
+		orc->sp_reg = ORC_REG_BP;
+		break;
+	default:
+		WARN_FUNC("unknown CFA base reg %d",
+			  insn->sec, insn->offset, cfi->cfa.base);
+		return -1;
+	}
+
+	switch (bp->base) {
+	case CFI_UNDEFINED:
+		orc->bp_reg = ORC_REG_UNDEFINED;
+		orc->bp_offset = 0;
+		break;
+	case CFI_CFA:
+		orc->bp_reg = ORC_REG_PREV_SP;
+		orc->bp_offset = bp->offset;
+		break;
+	default:
+		WARN_FUNC("unknown BP base reg %d",
+			  insn->sec, insn->offset, bp->base);
+		return -1;
+	}
+
+	switch (ra->base) {
+	case CFI_UNDEFINED:
+		orc->ra_reg = ORC_REG_UNDEFINED;
+		orc->ra_offset = 0;
+		break;
+	case CFI_CFA:
+		orc->ra_reg = ORC_REG_PREV_SP;
+		orc->ra_offset = ra->offset;
+		break;
+	default:
+		WARN_FUNC("unknown BP base reg %d",
+			  insn->sec, insn->offset, bp->base);
+		return -1;
+	}
+
+	orc->sp_offset = cfi->cfa.offset;
+	orc->type = cfi->type;
+
+	return 0;
+}
+
+static const char *reg_name(unsigned int reg)
+{
+	switch (reg) {
+	case ORC_REG_SP:
+		return "sp";
+	case ORC_REG_BP:
+		return "fp";
+	case ORC_REG_PREV_SP:
+		return "prevsp";
+	default:
+		return "?";
+	}
+}
+
+static const char *orc_type_name(unsigned int type)
+{
+	switch (type) {
+	case UNWIND_HINT_TYPE_CALL:
+		return "call";
+	case UNWIND_HINT_TYPE_REGS:
+		return "regs";
+	case UNWIND_HINT_TYPE_REGS_PARTIAL:
+		return "regs (partial)";
+	default:
+		return "?";
+	}
+}
+
+static void orc_print_reg(unsigned int reg, int offset)
+{
+	if (reg == ORC_REG_UNDEFINED)
+		printf(" (und) ");
+	else
+		printf("%s + %3d", reg_name(reg), offset);
+
+}
+
+static void orc_print_sp(void)
+{
+	printf(" sp:");
+}
+
+static void orc_print_fp(void)
+{
+	printf(" fp:");
+}
+
+static void orc_print_ra(void)
+{
+	printf(" ra:");
+}
+
+void orc_print_dump(struct elf *dummy_elf, struct orc_entry *orc, int i)
+{
+	orc_print_sp();
+
+	orc_print_reg(orc[i].sp_reg, bswap_if_needed(dummy_elf, orc[i].sp_offset));
+
+	orc_print_fp();
+
+	orc_print_reg(orc[i].bp_reg, bswap_if_needed(dummy_elf, orc[i].bp_offset));
+
+	orc_print_ra();
+
+	orc_print_reg(orc[i].ra_reg, bswap_if_needed(dummy_elf, orc[i].ra_offset));
+
+	printf(" type:%s signal:%d end:%d\n",
+	       orc_type_name(orc[i].type), orc[i].signal, orc[i].end);
+}
+
+void __weak arch_write_orc(struct elf *elf, struct orc_entry *orc)
+{
+	orc->ra_offset = bswap_if_needed(elf, orc->ra_offset);
+}
diff --git a/tools/objtool/include/objtool/objtool.h b/tools/objtool/include/objtool/objtool.h
index 94a33ee7b363..046b4bd816c1 100644
--- a/tools/objtool/include/objtool/objtool.h
+++ b/tools/objtool/include/objtool/objtool.h
@@ -12,6 +12,8 @@
 
 #include <objtool/elf.h>
 
+#include <asm/orc_types.h>
+
 #define __weak __attribute__((weak))
 
 struct pv_state {
@@ -46,5 +48,6 @@ void objtool_pv_add(struct objtool_file *file, int idx, struct symbol *func);
 int check(struct objtool_file *file);
 int orc_dump(const char *objname);
 int orc_create(struct objtool_file *file);
+void arch_write_orc(struct elf *elf, struct orc_entry *orc);
 
 #endif /* _OBJTOOL_H */
diff --git a/tools/objtool/orc_gen.c b/tools/objtool/orc_gen.c
index 08c5a27252a2..bff46c7a7987 100644
--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
@@ -14,6 +14,10 @@
 #include <objtool/warn.h>
 #include <objtool/endianness.h>
 
+void __weak arch_write_orc(struct elf *elf, struct orc_entry *orc)
+{
+}
+
 static int write_orc_entry(struct elf *elf, struct section *orc_sec,
 			   struct section *ip_sec, unsigned int idx,
 			   struct section *insn_sec, unsigned long insn_off,
@@ -26,6 +30,7 @@ static int write_orc_entry(struct elf *elf, struct section *orc_sec,
 	memcpy(orc, o, sizeof(*orc));
 	orc->sp_offset = bswap_if_needed(elf, orc->sp_offset);
 	orc->bp_offset = bswap_if_needed(elf, orc->bp_offset);
+	arch_write_orc(elf, orc);
 
 	/* populate reloc for ip */
 	if (elf_add_reloc_to_insn(elf, ip_sec, idx * sizeof(int), R_PCREL,
diff --git a/tools/objtool/sync-check.sh b/tools/objtool/sync-check.sh
index cfee9a034fa7..69c68a4ca5c4 100755
--- a/tools/objtool/sync-check.sh
+++ b/tools/objtool/sync-check.sh
@@ -31,6 +31,8 @@ fi
 if [ "$SRCARCH" = "loongarch" ]; then
 FILES="$FILES
 arch/loongarch/include/asm/asm.h
+arch/loongarch/include/asm/unwind_hints.h
+arch/loongarch/include/asm/orc_types.h
 "
 fi
 
-- 
2.39.2

