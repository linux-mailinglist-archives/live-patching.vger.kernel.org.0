Return-Path: <live-patching+bounces-1700-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BB02B80E81
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:15:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42E9017A565
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D577136C061;
	Wed, 17 Sep 2025 16:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OvHQZ4dZ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8EA36934E;
	Wed, 17 Sep 2025 16:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125088; cv=none; b=LIUuqJDyrKBHY3CkRIeYjl9yWrG3OFJcO5PPIf+fbH2CUyEBFPXgJHOqTBT9p+5PNEflE0jxLoO946aYJHFaFficnf9acjFrQPruf+lbozP1tvV1c/m4MB5FwUSanVP9kDLBBORchRva4YkhjnpbseojnhiHXSHiyA8tNj8HJr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125088; c=relaxed/simple;
	bh=dyarjm1xnkXEQqDQJdR8GfvVVJMHgRWaLc78TUKfOQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FE9XqSGK2yLw8j5BlKQg+pNgo4nphLyLbnPsJk9o2rW8ov3kv/wBFjPKtfNE/JXMIy1nYFWlACLZg3+odI2xoiS7z5Yv1m47bv0y2ZtyneXKu+ut3KWojx+7KKgROYP05u5jFd4zrYjiSOf2/LerAuu3lcQIpjEIVpiVbT1X0DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OvHQZ4dZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0710C4CEFC;
	Wed, 17 Sep 2025 16:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125088;
	bh=dyarjm1xnkXEQqDQJdR8GfvVVJMHgRWaLc78TUKfOQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OvHQZ4dZkzOvGa2hXg5RNMDRCrxqh4z/Ad/98S8Jm0SzAL3Gj2vCvVpZdl7hmFktv
	 JkMtS2YmTVCORtRnItS6bQ7Av/Ye65qQehtS5ucLXO6AMeoLG+xeLDtcgjzFxyw/WC
	 dpv+nLzboDGZ4udGZajfGM1SiVKvbrDthS0Cl1zhwI5yRX7r5mcLafslNyR6MyeH2q
	 Qnqxg8XWrrAdDYVmuHfXoJFE1ozJxqFUbQwUyBr9NS4XapxIOCVRjUMl/3LsnIrt7X
	 WFMia7ZZCxOzAQl7KGY4B6iVEie6/ImuGgwjJG31lEDgomfkWOzIR/sSTopLViAf0o
	 aZvskHeMZC9Yg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org,
	Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v4 45/63] objtool: Move ANNOTATE* macros to annotate.h
Date: Wed, 17 Sep 2025 09:03:53 -0700
Message-ID: <989f6ff0c9b9b6723de5dcd55b3e7530a996c06c.1758067943.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <cover.1758067942.git.jpoimboe@kernel.org>
References: <cover.1758067942.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for using the objtool annotation macros in higher-level
objtool.h macros like UNWIND_HINT, move them to their own file.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/annotate.h | 109 +++++++++++++++++++++++++++++++++++++++
 include/linux/objtool.h  |  90 +-------------------------------
 2 files changed, 110 insertions(+), 89 deletions(-)
 create mode 100644 include/linux/annotate.h

diff --git a/include/linux/annotate.h b/include/linux/annotate.h
new file mode 100644
index 0000000000000..ccb445496331c
--- /dev/null
+++ b/include/linux/annotate.h
@@ -0,0 +1,109 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_ANNOTATE_H
+#define _LINUX_ANNOTATE_H
+
+#include <linux/objtool_types.h>
+
+#ifdef CONFIG_OBJTOOL
+
+#ifndef __ASSEMBLY__
+
+#define __ASM_ANNOTATE(label, type)					\
+	".pushsection .discard.annotate_insn,\"M\",@progbits,8\n\t"	\
+	".long " __stringify(label) " - .\n\t"				\
+	".long " __stringify(type) "\n\t"				\
+	".popsection\n\t"
+
+#define ASM_ANNOTATE(type)						\
+	"911:\n\t"							\
+	__ASM_ANNOTATE(911b, type)
+
+#else /* __ASSEMBLY__ */
+
+.macro ANNOTATE type:req
+.Lhere_\@:
+	.pushsection .discard.annotate_insn,"M",@progbits,8
+	.long	.Lhere_\@ - .
+	.long	\type
+	.popsection
+.endm
+
+#endif /* __ASSEMBLY__ */
+
+#else /* !CONFIG_OBJTOOL */
+#ifndef __ASSEMBLY__
+#define __ASM_ANNOTATE(label, type) ""
+#define ASM_ANNOTATE(type)
+#else /* __ASSEMBLY__ */
+.macro ANNOTATE type:req
+.endm
+#endif /* __ASSEMBLY__ */
+#endif /* !CONFIG_OBJTOOL */
+
+#ifndef __ASSEMBLY__
+
+/*
+ * Annotate away the various 'relocation to !ENDBR` complaints; knowing that
+ * these relocations will never be used for indirect calls.
+ */
+#define ANNOTATE_NOENDBR		ASM_ANNOTATE(ANNOTYPE_NOENDBR)
+#define ANNOTATE_NOENDBR_SYM(sym)	asm(__ASM_ANNOTATE(sym, ANNOTYPE_NOENDBR))
+
+/*
+ * This should be used immediately before an indirect jump/call. It tells
+ * objtool the subsequent indirect jump/call is vouched safe for retpoline
+ * builds.
+ */
+#define ANNOTATE_RETPOLINE_SAFE		ASM_ANNOTATE(ANNOTYPE_RETPOLINE_SAFE)
+/*
+ * See linux/instrumentation.h
+ */
+#define ANNOTATE_INSTR_BEGIN(label)	__ASM_ANNOTATE(label, ANNOTYPE_INSTR_BEGIN)
+#define ANNOTATE_INSTR_END(label)	__ASM_ANNOTATE(label, ANNOTYPE_INSTR_END)
+/*
+ * objtool annotation to ignore the alternatives and only consider the original
+ * instruction(s).
+ */
+#define ANNOTATE_IGNORE_ALTERNATIVE	ASM_ANNOTATE(ANNOTYPE_IGNORE_ALTS)
+/*
+ * This macro indicates that the following intra-function call is valid.
+ * Any non-annotated intra-function call will cause objtool to issue a warning.
+ */
+#define ANNOTATE_INTRA_FUNCTION_CALL	ASM_ANNOTATE(ANNOTYPE_INTRA_FUNCTION_CALL)
+/*
+ * Use objtool to validate the entry requirement that all code paths do
+ * VALIDATE_UNRET_END before RET.
+ *
+ * NOTE: The macro must be used at the beginning of a global symbol, otherwise
+ * it will be ignored.
+ */
+#define ANNOTATE_UNRET_BEGIN		ASM_ANNOTATE(ANNOTYPE_UNRET_BEGIN)
+/*
+ * This should be used to refer to an instruction that is considered
+ * terminating, like a noreturn CALL or UD2 when we know they are not -- eg
+ * WARN using UD2.
+ */
+#define ANNOTATE_REACHABLE(label)	__ASM_ANNOTATE(label, ANNOTYPE_REACHABLE)
+/*
+ * This should not be used; it annotates away CFI violations. There are a few
+ * valid use cases like kexec handover to the next kernel image, and there is
+ * no security concern there.
+ *
+ * There are also a few real issues annotated away, like EFI because we can't
+ * control the EFI code.
+ */
+#define ANNOTATE_NOCFI_SYM(sym)		asm(__ASM_ANNOTATE(sym, ANNOTYPE_NOCFI))
+
+#else /* __ASSEMBLY__ */
+#define ANNOTATE_NOENDBR		ANNOTATE type=ANNOTYPE_NOENDBR
+#define ANNOTATE_RETPOLINE_SAFE		ANNOTATE type=ANNOTYPE_RETPOLINE_SAFE
+/*	ANNOTATE_INSTR_BEGIN		ANNOTATE type=ANNOTYPE_INSTR_BEGIN */
+/*	ANNOTATE_INSTR_END		ANNOTATE type=ANNOTYPE_INSTR_END */
+#define ANNOTATE_IGNORE_ALTERNATIVE	ANNOTATE type=ANNOTYPE_IGNORE_ALTS
+#define ANNOTATE_INTRA_FUNCTION_CALL	ANNOTATE type=ANNOTYPE_INTRA_FUNCTION_CALL
+#define ANNOTATE_UNRET_BEGIN		ANNOTATE type=ANNOTYPE_UNRET_BEGIN
+#define ANNOTATE_REACHABLE		ANNOTATE type=ANNOTYPE_REACHABLE
+#define ANNOTATE_NOCFI_SYM		ANNOTATE type=ANNOTYPE_NOCFI
+#endif /* __ASSEMBLY__ */
+
+#endif /* _LINUX_ANNOTATE_H */
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index 46ebaa46e6c58..1973e9f14bf95 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -3,11 +3,10 @@
 #define _LINUX_OBJTOOL_H
 
 #include <linux/objtool_types.h>
+#include <linux/annotate.h>
 
 #ifdef CONFIG_OBJTOOL
 
-#include <asm/asm.h>
-
 #ifndef __ASSEMBLY__
 
 #define UNWIND_HINT(type, sp_reg, sp_offset, signal)	\
@@ -53,16 +52,6 @@
 
 #define __ASM_BREF(label)	label ## b
 
-#define __ASM_ANNOTATE(label, type)					\
-	".pushsection .discard.annotate_insn,\"M\",@progbits,8\n\t"	\
-	".long " __stringify(label) " - .\n\t"			\
-	".long " __stringify(type) "\n\t"				\
-	".popsection\n\t"
-
-#define ASM_ANNOTATE(type)						\
-	"911:\n\t"						\
-	__ASM_ANNOTATE(911b, type)
-
 #else /* __ASSEMBLY__ */
 
 /*
@@ -111,14 +100,6 @@
 #endif
 .endm
 
-.macro ANNOTATE type:req
-.Lhere_\@:
-	.pushsection .discard.annotate_insn,"M",@progbits,8
-	.long	.Lhere_\@ - .
-	.long	\type
-	.popsection
-.endm
-
 #endif /* __ASSEMBLY__ */
 
 #else /* !CONFIG_OBJTOOL */
@@ -128,84 +109,15 @@
 #define UNWIND_HINT(type, sp_reg, sp_offset, signal) "\n\t"
 #define STACK_FRAME_NON_STANDARD(func)
 #define STACK_FRAME_NON_STANDARD_FP(func)
-#define __ASM_ANNOTATE(label, type) ""
-#define ASM_ANNOTATE(type)
 #else
 .macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0
 .endm
 .macro STACK_FRAME_NON_STANDARD func:req
 .endm
-.macro ANNOTATE type:req
-.endm
 #endif
 
 #endif /* CONFIG_OBJTOOL */
 
-#ifndef __ASSEMBLY__
-/*
- * Annotate away the various 'relocation to !ENDBR` complaints; knowing that
- * these relocations will never be used for indirect calls.
- */
-#define ANNOTATE_NOENDBR		ASM_ANNOTATE(ANNOTYPE_NOENDBR)
-#define ANNOTATE_NOENDBR_SYM(sym)	asm(__ASM_ANNOTATE(sym, ANNOTYPE_NOENDBR))
-
-/*
- * This should be used immediately before an indirect jump/call. It tells
- * objtool the subsequent indirect jump/call is vouched safe for retpoline
- * builds.
- */
-#define ANNOTATE_RETPOLINE_SAFE		ASM_ANNOTATE(ANNOTYPE_RETPOLINE_SAFE)
-/*
- * See linux/instrumentation.h
- */
-#define ANNOTATE_INSTR_BEGIN(label)	__ASM_ANNOTATE(label, ANNOTYPE_INSTR_BEGIN)
-#define ANNOTATE_INSTR_END(label)	__ASM_ANNOTATE(label, ANNOTYPE_INSTR_END)
-/*
- * objtool annotation to ignore the alternatives and only consider the original
- * instruction(s).
- */
-#define ANNOTATE_IGNORE_ALTERNATIVE	ASM_ANNOTATE(ANNOTYPE_IGNORE_ALTS)
-/*
- * This macro indicates that the following intra-function call is valid.
- * Any non-annotated intra-function call will cause objtool to issue a warning.
- */
-#define ANNOTATE_INTRA_FUNCTION_CALL	ASM_ANNOTATE(ANNOTYPE_INTRA_FUNCTION_CALL)
-/*
- * Use objtool to validate the entry requirement that all code paths do
- * VALIDATE_UNRET_END before RET.
- *
- * NOTE: The macro must be used at the beginning of a global symbol, otherwise
- * it will be ignored.
- */
-#define ANNOTATE_UNRET_BEGIN		ASM_ANNOTATE(ANNOTYPE_UNRET_BEGIN)
-/*
- * This should be used to refer to an instruction that is considered
- * terminating, like a noreturn CALL or UD2 when we know they are not -- eg
- * WARN using UD2.
- */
-#define ANNOTATE_REACHABLE(label)	__ASM_ANNOTATE(label, ANNOTYPE_REACHABLE)
-/*
- * This should not be used; it annotates away CFI violations. There are a few
- * valid use cases like kexec handover to the next kernel image, and there is
- * no security concern there.
- *
- * There are also a few real issues annotated away, like EFI because we can't
- * control the EFI code.
- */
-#define ANNOTATE_NOCFI_SYM(sym)		asm(__ASM_ANNOTATE(sym, ANNOTYPE_NOCFI))
-
-#else
-#define ANNOTATE_NOENDBR		ANNOTATE type=ANNOTYPE_NOENDBR
-#define ANNOTATE_RETPOLINE_SAFE		ANNOTATE type=ANNOTYPE_RETPOLINE_SAFE
-/*	ANNOTATE_INSTR_BEGIN		ANNOTATE type=ANNOTYPE_INSTR_BEGIN */
-/*	ANNOTATE_INSTR_END		ANNOTATE type=ANNOTYPE_INSTR_END */
-#define ANNOTATE_IGNORE_ALTERNATIVE	ANNOTATE type=ANNOTYPE_IGNORE_ALTS
-#define ANNOTATE_INTRA_FUNCTION_CALL	ANNOTATE type=ANNOTYPE_INTRA_FUNCTION_CALL
-#define ANNOTATE_UNRET_BEGIN		ANNOTATE type=ANNOTYPE_UNRET_BEGIN
-#define ANNOTATE_REACHABLE		ANNOTATE type=ANNOTYPE_REACHABLE
-#define ANNOTATE_NOCFI_SYM		ANNOTATE type=ANNOTYPE_NOCFI
-#endif
-
 #if defined(CONFIG_NOINSTR_VALIDATION) && \
 	(defined(CONFIG_MITIGATION_UNRET_ENTRY) || defined(CONFIG_MITIGATION_SRSO))
 #define VALIDATE_UNRET_BEGIN	ANNOTATE_UNRET_BEGIN
-- 
2.50.0


