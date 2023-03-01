Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389706A6F19
	for <lists+live-patching@lfdr.de>; Wed,  1 Mar 2023 16:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjCAPOs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 Mar 2023 10:14:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbjCAPOr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 Mar 2023 10:14:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2143E0AB
        for <live-patching@vger.kernel.org>; Wed,  1 Mar 2023 07:14:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C4C0B81088
        for <live-patching@vger.kernel.org>; Wed,  1 Mar 2023 15:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67A6C4339C;
        Wed,  1 Mar 2023 15:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677683677;
        bh=Co4QluaAtxvLEB8dkOgx4FCxJeAqaxySRMmaWhhoNsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BhGDFLyNw9w2enup5FcYI7aUmvWFwMTuEMdVJcIOS4a9WC6YRIFaAA34wu+qcyw4s
         OVfQGLoUUcWtib7WmKT4z75oeYi+2QEt98Rxgqc4KbDP8Lj8G6rY+Vl/X5RNjVhrJB
         ejg7mAddH31KGKpuc8hDK5nAUBBmOUMzWM5Wz7QU3vS3cdRUSyDIroIFkGwxKj6Xhk
         rFca9uTLPRrORGXfqBUIbU7uRe7y8tJWfoHH3IohPg9UzaIeNrvMi3ev5a/MzQfGMX
         HOb3RQSK/UZVLsQR0ooaZnwBwhVR4QMT3dkblXpPaWsci9Lzy6tGxGuOAaf7QmcW1J
         8Kd8fphlEp2jQ==
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     x86@kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        live-patching@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/6] objtool: Add objtool_types.h
Date:   Wed,  1 Mar 2023 07:13:07 -0800
Message-Id: <dec622720851210ceafa12d4f4c5f9e73c832152.1677683419.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677683419.git.jpoimboe@kernel.org>
References: <cover.1677683419.git.jpoimboe@kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Reduce the amount of header sync churn by splitting the shared objtool.h
types into a new file.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 MAINTAINERS                         |   2 +-
 include/linux/objtool.h             |  42 +-----
 include/linux/objtool_types.h       |  48 +++++++
 tools/include/linux/objtool.h       | 200 ----------------------------
 tools/include/linux/objtool_types.h |  48 +++++++
 tools/objtool/check.c               |   2 +-
 tools/objtool/orc_dump.c            |   2 +-
 tools/objtool/orc_gen.c             |   2 +-
 tools/objtool/sync-check.sh         |   2 +-
 9 files changed, 102 insertions(+), 246 deletions(-)
 create mode 100644 include/linux/objtool_types.h
 delete mode 100644 tools/include/linux/objtool.h
 create mode 100644 tools/include/linux/objtool_types.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 2368a813e7ae..0873a33c3af9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14988,8 +14988,8 @@ OBJTOOL
 M:	Josh Poimboeuf <jpoimboe@kernel.org>
 M:	Peter Zijlstra <peterz@infradead.org>
 S:	Supported
+F:	include/linux/objtool*.h
 F:	tools/objtool/
-F:	include/linux/objtool.h
 
 OCELOT ETHERNET SWITCH DRIVER
 M:	Vladimir Oltean <vladimir.oltean@nxp.com>
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index 9ac3df3fccf0..8375792acfc0 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -2,47 +2,7 @@
 #ifndef _LINUX_OBJTOOL_H
 #define _LINUX_OBJTOOL_H
 
-#ifndef __ASSEMBLY__
-
-#include <linux/types.h>
-
-/*
- * This struct is used by asm and inline asm code to manually annotate the
- * location of registers on the stack.
- */
-struct unwind_hint {
-	u32		ip;
-	s16		sp_offset;
-	u8		sp_reg;
-	u8		type;
-	u8		signal;
-	u8		end;
-};
-#endif
-
-/*
- * UNWIND_HINT_TYPE_CALL: Indicates that sp_reg+sp_offset resolves to PREV_SP
- * (the caller's SP right before it made the call).  Used for all callable
- * functions, i.e. all C code and all callable asm functions.
- *
- * UNWIND_HINT_TYPE_REGS: Used in entry code to indicate that sp_reg+sp_offset
- * points to a fully populated pt_regs from a syscall, interrupt, or exception.
- *
- * UNWIND_HINT_TYPE_REGS_PARTIAL: Used in entry code to indicate that
- * sp_reg+sp_offset points to the iret return frame.
- *
- * UNWIND_HINT_FUNC: Generate the unwind metadata of a callable function.
- * Useful for code which doesn't have an ELF function annotation.
- *
- * UNWIND_HINT_ENTRY: machine entry without stack, SYSCALL/SYSENTER etc.
- */
-#define UNWIND_HINT_TYPE_CALL		0
-#define UNWIND_HINT_TYPE_REGS		1
-#define UNWIND_HINT_TYPE_REGS_PARTIAL	2
-#define UNWIND_HINT_TYPE_FUNC		3
-#define UNWIND_HINT_TYPE_ENTRY		4
-#define UNWIND_HINT_TYPE_SAVE		5
-#define UNWIND_HINT_TYPE_RESTORE	6
+#include <linux/objtool_types.h>
 
 #ifdef CONFIG_OBJTOOL
 
diff --git a/include/linux/objtool_types.h b/include/linux/objtool_types.h
new file mode 100644
index 000000000000..8513537a30ed
--- /dev/null
+++ b/include/linux/objtool_types.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_OBJTOOL_TYPES_H
+#define _LINUX_OBJTOOL_TYPES_H
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
+
+#endif /* __ASSEMBLY__ */
+
+/*
+ * UNWIND_HINT_TYPE_CALL: Indicates that sp_reg+sp_offset resolves to PREV_SP
+ * (the caller's SP right before it made the call).  Used for all callable
+ * functions, i.e. all C code and all callable asm functions.
+ *
+ * UNWIND_HINT_TYPE_REGS: Used in entry code to indicate that sp_reg+sp_offset
+ * points to a fully populated pt_regs from a syscall, interrupt, or exception.
+ *
+ * UNWIND_HINT_TYPE_REGS_PARTIAL: Used in entry code to indicate that
+ * sp_reg+sp_offset points to the iret return frame.
+ *
+ * UNWIND_HINT_FUNC: Generate the unwind metadata of a callable function.
+ * Useful for code which doesn't have an ELF function annotation.
+ *
+ * UNWIND_HINT_ENTRY: machine entry without stack, SYSCALL/SYSENTER etc.
+ */
+#define UNWIND_HINT_TYPE_CALL		0
+#define UNWIND_HINT_TYPE_REGS		1
+#define UNWIND_HINT_TYPE_REGS_PARTIAL	2
+#define UNWIND_HINT_TYPE_FUNC		3
+#define UNWIND_HINT_TYPE_ENTRY		4
+#define UNWIND_HINT_TYPE_SAVE		5
+#define UNWIND_HINT_TYPE_RESTORE	6
+
+#endif /* _LINUX_OBJTOOL_TYPES_H */
diff --git a/tools/include/linux/objtool.h b/tools/include/linux/objtool.h
deleted file mode 100644
index 9ac3df3fccf0..000000000000
--- a/tools/include/linux/objtool.h
+++ /dev/null
@@ -1,200 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _LINUX_OBJTOOL_H
-#define _LINUX_OBJTOOL_H
-
-#ifndef __ASSEMBLY__
-
-#include <linux/types.h>
-
-/*
- * This struct is used by asm and inline asm code to manually annotate the
- * location of registers on the stack.
- */
-struct unwind_hint {
-	u32		ip;
-	s16		sp_offset;
-	u8		sp_reg;
-	u8		type;
-	u8		signal;
-	u8		end;
-};
-#endif
-
-/*
- * UNWIND_HINT_TYPE_CALL: Indicates that sp_reg+sp_offset resolves to PREV_SP
- * (the caller's SP right before it made the call).  Used for all callable
- * functions, i.e. all C code and all callable asm functions.
- *
- * UNWIND_HINT_TYPE_REGS: Used in entry code to indicate that sp_reg+sp_offset
- * points to a fully populated pt_regs from a syscall, interrupt, or exception.
- *
- * UNWIND_HINT_TYPE_REGS_PARTIAL: Used in entry code to indicate that
- * sp_reg+sp_offset points to the iret return frame.
- *
- * UNWIND_HINT_FUNC: Generate the unwind metadata of a callable function.
- * Useful for code which doesn't have an ELF function annotation.
- *
- * UNWIND_HINT_ENTRY: machine entry without stack, SYSCALL/SYSENTER etc.
- */
-#define UNWIND_HINT_TYPE_CALL		0
-#define UNWIND_HINT_TYPE_REGS		1
-#define UNWIND_HINT_TYPE_REGS_PARTIAL	2
-#define UNWIND_HINT_TYPE_FUNC		3
-#define UNWIND_HINT_TYPE_ENTRY		4
-#define UNWIND_HINT_TYPE_SAVE		5
-#define UNWIND_HINT_TYPE_RESTORE	6
-
-#ifdef CONFIG_OBJTOOL
-
-#include <asm/asm.h>
-
-#ifndef __ASSEMBLY__
-
-#define UNWIND_HINT(sp_reg, sp_offset, type, signal, end)	\
-	"987: \n\t"						\
-	".pushsection .discard.unwind_hints\n\t"		\
-	/* struct unwind_hint */				\
-	".long 987b - .\n\t"					\
-	".short " __stringify(sp_offset) "\n\t"			\
-	".byte " __stringify(sp_reg) "\n\t"			\
-	".byte " __stringify(type) "\n\t"			\
-	".byte " __stringify(signal) "\n\t"			\
-	".byte " __stringify(end) "\n\t"			\
-	".balign 4 \n\t"					\
-	".popsection\n\t"
-
-/*
- * This macro marks the given function's stack frame as "non-standard", which
- * tells objtool to ignore the function when doing stack metadata validation.
- * It should only be used in special cases where you're 100% sure it won't
- * affect the reliability of frame pointers and kernel stack traces.
- *
- * For more information, see tools/objtool/Documentation/objtool.txt.
- */
-#define STACK_FRAME_NON_STANDARD(func) \
-	static void __used __section(".discard.func_stack_frame_non_standard") \
-		*__func_stack_frame_non_standard_##func = func
-
-/*
- * STACK_FRAME_NON_STANDARD_FP() is a frame-pointer-specific function ignore
- * for the case where a function is intentionally missing frame pointer setup,
- * but otherwise needs objtool/ORC coverage when frame pointers are disabled.
- */
-#ifdef CONFIG_FRAME_POINTER
-#define STACK_FRAME_NON_STANDARD_FP(func) STACK_FRAME_NON_STANDARD(func)
-#else
-#define STACK_FRAME_NON_STANDARD_FP(func)
-#endif
-
-#define ANNOTATE_NOENDBR					\
-	"986: \n\t"						\
-	".pushsection .discard.noendbr\n\t"			\
-	_ASM_PTR " 986b\n\t"					\
-	".popsection\n\t"
-
-#define ASM_REACHABLE							\
-	"998:\n\t"							\
-	".pushsection .discard.reachable\n\t"				\
-	".long 998b - .\n\t"						\
-	".popsection\n\t"
-
-#else /* __ASSEMBLY__ */
-
-/*
- * This macro indicates that the following intra-function call is valid.
- * Any non-annotated intra-function call will cause objtool to issue a warning.
- */
-#define ANNOTATE_INTRA_FUNCTION_CALL				\
-	999:							\
-	.pushsection .discard.intra_function_calls;		\
-	.long 999b;						\
-	.popsection;
-
-/*
- * In asm, there are two kinds of code: normal C-type callable functions and
- * the rest.  The normal callable functions can be called by other code, and
- * don't do anything unusual with the stack.  Such normal callable functions
- * are annotated with the ENTRY/ENDPROC macros.  Most asm code falls in this
- * category.  In this case, no special debugging annotations are needed because
- * objtool can automatically generate the ORC data for the ORC unwinder to read
- * at runtime.
- *
- * Anything which doesn't fall into the above category, such as syscall and
- * interrupt handlers, tends to not be called directly by other functions, and
- * often does unusual non-C-function-type things with the stack pointer.  Such
- * code needs to be annotated such that objtool can understand it.  The
- * following CFI hint macros are for this type of code.
- *
- * These macros provide hints to objtool about the state of the stack at each
- * instruction.  Objtool starts from the hints and follows the code flow,
- * making automatic CFI adjustments when it sees pushes and pops, filling out
- * the debuginfo as necessary.  It will also warn if it sees any
- * inconsistencies.
- */
-.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0 end=0
-.Lunwind_hint_ip_\@:
-	.pushsection .discard.unwind_hints
-		/* struct unwind_hint */
-		.long .Lunwind_hint_ip_\@ - .
-		.short \sp_offset
-		.byte \sp_reg
-		.byte \type
-		.byte \signal
-		.byte \end
-		.balign 4
-	.popsection
-.endm
-
-.macro STACK_FRAME_NON_STANDARD func:req
-	.pushsection .discard.func_stack_frame_non_standard, "aw"
-	_ASM_PTR \func
-	.popsection
-.endm
-
-.macro STACK_FRAME_NON_STANDARD_FP func:req
-#ifdef CONFIG_FRAME_POINTER
-	STACK_FRAME_NON_STANDARD \func
-#endif
-.endm
-
-.macro ANNOTATE_NOENDBR
-.Lhere_\@:
-	.pushsection .discard.noendbr
-	.quad	.Lhere_\@
-	.popsection
-.endm
-
-.macro REACHABLE
-.Lhere_\@:
-	.pushsection .discard.reachable
-	.long	.Lhere_\@ - .
-	.popsection
-.endm
-
-#endif /* __ASSEMBLY__ */
-
-#else /* !CONFIG_OBJTOOL */
-
-#ifndef __ASSEMBLY__
-
-#define UNWIND_HINT(sp_reg, sp_offset, type, signal, end) \
-	"\n\t"
-#define STACK_FRAME_NON_STANDARD(func)
-#define STACK_FRAME_NON_STANDARD_FP(func)
-#define ANNOTATE_NOENDBR
-#define ASM_REACHABLE
-#else
-#define ANNOTATE_INTRA_FUNCTION_CALL
-.macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0 end=0
-.endm
-.macro STACK_FRAME_NON_STANDARD func:req
-.endm
-.macro ANNOTATE_NOENDBR
-.endm
-.macro REACHABLE
-.endm
-#endif
-
-#endif /* CONFIG_OBJTOOL */
-
-#endif /* _LINUX_OBJTOOL_H */
diff --git a/tools/include/linux/objtool_types.h b/tools/include/linux/objtool_types.h
new file mode 100644
index 000000000000..8513537a30ed
--- /dev/null
+++ b/tools/include/linux/objtool_types.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_OBJTOOL_TYPES_H
+#define _LINUX_OBJTOOL_TYPES_H
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
+
+#endif /* __ASSEMBLY__ */
+
+/*
+ * UNWIND_HINT_TYPE_CALL: Indicates that sp_reg+sp_offset resolves to PREV_SP
+ * (the caller's SP right before it made the call).  Used for all callable
+ * functions, i.e. all C code and all callable asm functions.
+ *
+ * UNWIND_HINT_TYPE_REGS: Used in entry code to indicate that sp_reg+sp_offset
+ * points to a fully populated pt_regs from a syscall, interrupt, or exception.
+ *
+ * UNWIND_HINT_TYPE_REGS_PARTIAL: Used in entry code to indicate that
+ * sp_reg+sp_offset points to the iret return frame.
+ *
+ * UNWIND_HINT_FUNC: Generate the unwind metadata of a callable function.
+ * Useful for code which doesn't have an ELF function annotation.
+ *
+ * UNWIND_HINT_ENTRY: machine entry without stack, SYSCALL/SYSENTER etc.
+ */
+#define UNWIND_HINT_TYPE_CALL		0
+#define UNWIND_HINT_TYPE_REGS		1
+#define UNWIND_HINT_TYPE_REGS_PARTIAL	2
+#define UNWIND_HINT_TYPE_FUNC		3
+#define UNWIND_HINT_TYPE_ENTRY		4
+#define UNWIND_HINT_TYPE_SAVE		5
+#define UNWIND_HINT_TYPE_RESTORE	6
+
+#endif /* _LINUX_OBJTOOL_TYPES_H */
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 5822de376d9a..3d4b650d3284 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -17,7 +17,7 @@
 #include <objtool/warn.h>
 #include <objtool/endianness.h>
 
-#include <linux/objtool.h>
+#include <linux/objtool_types.h>
 #include <linux/hashtable.h>
 #include <linux/kernel.h>
 #include <linux/static_call_types.h>
diff --git a/tools/objtool/orc_dump.c b/tools/objtool/orc_dump.c
index 2d8ebdcd1db3..9f6c528c26f2 100644
--- a/tools/objtool/orc_dump.c
+++ b/tools/objtool/orc_dump.c
@@ -4,7 +4,7 @@
  */
 
 #include <unistd.h>
-#include <linux/objtool.h>
+#include <linux/objtool_types.h>
 #include <asm/orc_types.h>
 #include <objtool/objtool.h>
 #include <objtool/warn.h>
diff --git a/tools/objtool/orc_gen.c b/tools/objtool/orc_gen.c
index 57a4527d5988..f49630a21e0f 100644
--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
@@ -6,7 +6,7 @@
 #include <stdlib.h>
 #include <string.h>
 
-#include <linux/objtool.h>
+#include <linux/objtool_types.h>
 #include <asm/orc_types.h>
 
 #include <objtool/check.h>
diff --git a/tools/objtool/sync-check.sh b/tools/objtool/sync-check.sh
index 105a291ff8e7..81d120d05442 100755
--- a/tools/objtool/sync-check.sh
+++ b/tools/objtool/sync-check.sh
@@ -6,7 +6,7 @@ if [ -z "$SRCARCH" ]; then
 	exit 1
 fi
 
-FILES="include/linux/objtool.h"
+FILES="include/linux/objtool_types.h"
 
 if [ "$SRCARCH" = "x86" ]; then
 FILES="$FILES
-- 
2.39.1

