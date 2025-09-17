Return-Path: <live-patching+bounces-1701-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB191B80E8A
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:16:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14D36320091
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:12:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45E8B37058B;
	Wed, 17 Sep 2025 16:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Be37gSe2"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B3136CE05;
	Wed, 17 Sep 2025 16:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125089; cv=none; b=kKfzubNu+rrr99jlz1vU1eV2q5+RtMqArm/OzCBzn0bh0XetsBSwTXdJf9UZggzMrGsQqiegShxJoZYd7aTOSJwF3EdyapDfakt6mwdmwaffLAKc2K7OieZsWaoHTP1ImNsf8geFKOriFr5cI3bIAIIPjHa0y8yFDs9OWkfVZco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125089; c=relaxed/simple;
	bh=HNv5N2ZAR+IB6DWyvTl068X9AwyvZ7qCJk12yzlbrrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vsla4NVZm4ROERZTRr4wkHhfsr2lw2q0DwcuIUPeOUexuFITG1Y+0um5s6QsrxvfMpSz+cAKLsAi17OcrOxixx5EzxZwWhA8nCRcjg+xiHNj1SNXrCGOUXJhRLxXVwf1Z3gWgSSk82JMw3YzNC8f4S7q/PW7Knz+c1VkJucTIHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Be37gSe2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698A3C4CEE7;
	Wed, 17 Sep 2025 16:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125089;
	bh=HNv5N2ZAR+IB6DWyvTl068X9AwyvZ7qCJk12yzlbrrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Be37gSe2QRTQKAP/l9DG+ns9BhCevf2VfEWDSI7iRFynpoIQc1ibA1O3O9tUWP2nm
	 GVvD8zSSKi9JbuSeq5dmVl8LLQcCE+6uvePRU7oaCpe2XW3wjazrhEPTEmWQWoMB+A
	 nr/hc7WAy3DQ/LNrok0V4FHdBtlVs8oHq+izl1uWSi0miW77J73W8kIsbTga86aDbP
	 s1H3RrX8Zm5Jx3cam/mgLT+9WDhTPjYg105BtULzKrg5+Oy1PCPHrkCnjbxszJgDsm
	 pgrDB6Y2PjSAca7/FxImncQ3iQ6qyTMadeY1RVNUsO9EeZdX0AV0fxyJzaCzdTj9lr
	 08/+ImBxzLkrQ==
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
Subject: [PATCH v4 46/63] objtool: Add ANNOTATE_DATA_SPECIAL
Date: Wed, 17 Sep 2025 09:03:54 -0700
Message-ID: <2325294d8e67f7a71fcb65f39c9418c2b0034657.1758067943.git.jpoimboe@kernel.org>
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

In preparation for the objtool klp diff subcommand, add an
ANNOTATE_DATA_SPECIAL macro which annotates special section entries so
that objtool can determine their size and location and extract them
when needed.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/annotate.h            | 49 ++++++++++++++++++++++-------
 include/linux/objtool_types.h       |  2 ++
 tools/include/linux/objtool_types.h |  2 ++
 3 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/include/linux/annotate.h b/include/linux/annotate.h
index ccb445496331c..7c10d34d198cf 100644
--- a/include/linux/annotate.h
+++ b/include/linux/annotate.h
@@ -8,34 +8,52 @@
 
 #ifndef __ASSEMBLY__
 
-#define __ASM_ANNOTATE(label, type)					\
-	".pushsection .discard.annotate_insn,\"M\",@progbits,8\n\t"	\
+#define __ASM_ANNOTATE(section, label, type)				\
+	".pushsection " section ",\"M\", @progbits, 8\n\t"		\
 	".long " __stringify(label) " - .\n\t"				\
 	".long " __stringify(type) "\n\t"				\
 	".popsection\n\t"
 
+#define ASM_ANNOTATE_LABEL(label, type)					\
+	__ASM_ANNOTATE(".discard.annotate_insn", label, type)
+
 #define ASM_ANNOTATE(type)						\
 	"911:\n\t"							\
-	__ASM_ANNOTATE(911b, type)
+	ASM_ANNOTATE_LABEL(911b, type)
+
+#define ASM_ANNOTATE_DATA(type)						\
+	"912:\n\t"							\
+	__ASM_ANNOTATE(".discard.annotate_data", 912b, type)
 
 #else /* __ASSEMBLY__ */
 
-.macro ANNOTATE type:req
+.macro __ANNOTATE section, type
 .Lhere_\@:
-	.pushsection .discard.annotate_insn,"M",@progbits,8
+	.pushsection \section, "M", @progbits, 8
 	.long	.Lhere_\@ - .
 	.long	\type
 	.popsection
 .endm
 
+.macro ANNOTATE type
+	__ANNOTATE ".discard.annotate_insn", \type
+.endm
+
+.macro ANNOTATE_DATA type
+	__ANNOTATE ".discard.annotate_data", \type
+.endm
+
 #endif /* __ASSEMBLY__ */
 
 #else /* !CONFIG_OBJTOOL */
 #ifndef __ASSEMBLY__
-#define __ASM_ANNOTATE(label, type) ""
+#define ASM_ANNOTATE_LABEL(label, type) ""
 #define ASM_ANNOTATE(type)
+#define ASM_ANNOTATE_DATA(type)
 #else /* __ASSEMBLY__ */
-.macro ANNOTATE type:req
+.macro ANNOTATE type
+.endm
+.macro ANNOTATE_DATA type
 .endm
 #endif /* __ASSEMBLY__ */
 #endif /* !CONFIG_OBJTOOL */
@@ -47,7 +65,7 @@
  * these relocations will never be used for indirect calls.
  */
 #define ANNOTATE_NOENDBR		ASM_ANNOTATE(ANNOTYPE_NOENDBR)
-#define ANNOTATE_NOENDBR_SYM(sym)	asm(__ASM_ANNOTATE(sym, ANNOTYPE_NOENDBR))
+#define ANNOTATE_NOENDBR_SYM(sym)	asm(ASM_ANNOTATE_LABEL(sym, ANNOTYPE_NOENDBR))
 
 /*
  * This should be used immediately before an indirect jump/call. It tells
@@ -58,8 +76,8 @@
 /*
  * See linux/instrumentation.h
  */
-#define ANNOTATE_INSTR_BEGIN(label)	__ASM_ANNOTATE(label, ANNOTYPE_INSTR_BEGIN)
-#define ANNOTATE_INSTR_END(label)	__ASM_ANNOTATE(label, ANNOTYPE_INSTR_END)
+#define ANNOTATE_INSTR_BEGIN(label)	ASM_ANNOTATE_LABEL(label, ANNOTYPE_INSTR_BEGIN)
+#define ANNOTATE_INSTR_END(label)	ASM_ANNOTATE_LABEL(label, ANNOTYPE_INSTR_END)
 /*
  * objtool annotation to ignore the alternatives and only consider the original
  * instruction(s).
@@ -83,7 +101,7 @@
  * terminating, like a noreturn CALL or UD2 when we know they are not -- eg
  * WARN using UD2.
  */
-#define ANNOTATE_REACHABLE(label)	__ASM_ANNOTATE(label, ANNOTYPE_REACHABLE)
+#define ANNOTATE_REACHABLE(label)	ASM_ANNOTATE_LABEL(label, ANNOTYPE_REACHABLE)
 /*
  * This should not be used; it annotates away CFI violations. There are a few
  * valid use cases like kexec handover to the next kernel image, and there is
@@ -92,7 +110,13 @@
  * There are also a few real issues annotated away, like EFI because we can't
  * control the EFI code.
  */
-#define ANNOTATE_NOCFI_SYM(sym)		asm(__ASM_ANNOTATE(sym, ANNOTYPE_NOCFI))
+#define ANNOTATE_NOCFI_SYM(sym)		asm(ASM_ANNOTATE_LABEL(sym, ANNOTYPE_NOCFI))
+
+/*
+ * Annotate a special section entry.  This emables livepatch module generation
+ * to find and extract individual special section entries as needed.
+ */
+#define ANNOTATE_DATA_SPECIAL		ASM_ANNOTATE_DATA(ANNOTYPE_DATA_SPECIAL)
 
 #else /* __ASSEMBLY__ */
 #define ANNOTATE_NOENDBR		ANNOTATE type=ANNOTYPE_NOENDBR
@@ -104,6 +128,7 @@
 #define ANNOTATE_UNRET_BEGIN		ANNOTATE type=ANNOTYPE_UNRET_BEGIN
 #define ANNOTATE_REACHABLE		ANNOTATE type=ANNOTYPE_REACHABLE
 #define ANNOTATE_NOCFI_SYM		ANNOTATE type=ANNOTYPE_NOCFI
+#define ANNOTATE_DATA_SPECIAL		ANNOTATE_DATA type=ANNOTYPE_DATA_SPECIAL
 #endif /* __ASSEMBLY__ */
 
 #endif /* _LINUX_ANNOTATE_H */
diff --git a/include/linux/objtool_types.h b/include/linux/objtool_types.h
index aceac94632c8a..c6def4049b1ae 100644
--- a/include/linux/objtool_types.h
+++ b/include/linux/objtool_types.h
@@ -67,4 +67,6 @@ struct unwind_hint {
 #define ANNOTYPE_REACHABLE		8
 #define ANNOTYPE_NOCFI			9
 
+#define ANNOTYPE_DATA_SPECIAL		1
+
 #endif /* _LINUX_OBJTOOL_TYPES_H */
diff --git a/tools/include/linux/objtool_types.h b/tools/include/linux/objtool_types.h
index aceac94632c8a..c6def4049b1ae 100644
--- a/tools/include/linux/objtool_types.h
+++ b/tools/include/linux/objtool_types.h
@@ -67,4 +67,6 @@ struct unwind_hint {
 #define ANNOTYPE_REACHABLE		8
 #define ANNOTYPE_NOCFI			9
 
+#define ANNOTYPE_DATA_SPECIAL		1
+
 #endif /* _LINUX_OBJTOOL_TYPES_H */
-- 
2.50.0


