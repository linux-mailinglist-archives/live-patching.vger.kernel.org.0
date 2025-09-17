Return-Path: <live-patching+bounces-1702-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CAA0B80E99
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:16:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4038E17E034
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:12:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66375372895;
	Wed, 17 Sep 2025 16:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gg3laYim"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7E137288A;
	Wed, 17 Sep 2025 16:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125090; cv=none; b=jSirFguZlLGY9eSnnR2quGd/a97C7occiu8C4i0ExbDS3RVDarQX6gOe/j0sjdzZRdeMty3kNl2L7U8GEHm2rQFQirl+i4YLqorZYKlqeQy5tVgvlGxv9EtSFiCW3wuUz+JjY4nQgdUfaYR3L6d66pUqNNp0uV58CjG3AT+Gijs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125090; c=relaxed/simple;
	bh=kuOzSwObcP2MhJmHeXatb/lvsCW/mw4D2h7dBTciV04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzSmJ0YQpc/oNlOXfV7u34FXk2s4k5nEZEyUANCnTbVFNtj0MtRpmxXklseFQ21ho7ETYIrOEINoUSd1a7MXI7vS4L3WxbVDYpZqFuES7tsL6Sli9Cc6NrAv1Udg5hPu/qw0vPqwGP2LUHfJdzeXJHakqdQE2JPtJiroNvAGEyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gg3laYim; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2217BC4CEF9;
	Wed, 17 Sep 2025 16:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125089;
	bh=kuOzSwObcP2MhJmHeXatb/lvsCW/mw4D2h7dBTciV04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gg3laYimk47tty35aFkK5homxb9se1HnStrcCK+SL7FdT3d+4JU+jmEnEnsaB+zf5
	 I6pU2AFQfRFPKte8ySdmUfrRCqQLYe7+d0+C3Nb8KbSImmQhYyLX4SEsdHAWGdCvwr
	 Gdc0X2hB5JoCq/znjuIBxchnwQNPe3MuICs/WpSWLoOgHXnCmwKG0vguX1uAfs6W32
	 lo9wayz0RwCh3nYha2xSulXXc2v+B9hKZBnOJXaA1mOB6YL07l8nlYuSTX2RtIQhaG
	 nGR76fsHkUugbDS3KOmDTxA0hg77Mpk0wqeWQfRmQaMFJ6/q5Kz74z+pPLSS0Xk8x4
	 H9KRkYb7aj7uw==
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
Subject: [PATCH v4 47/63] x86/asm: Annotate special section entries
Date: Wed, 17 Sep 2025 09:03:55 -0700
Message-ID: <b54089a4c24fa49334e4d432d60bd4bcb8a2adb5.1758067943.git.jpoimboe@kernel.org>
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

In preparation for the objtool klp diff subcommand, add annotations for
special section entries.  This will enable objtool to determine the size
and location of the entries and to extract them when needed.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/include/asm/alternative.h | 4 ++++
 arch/x86/include/asm/asm.h         | 5 +++++
 arch/x86/include/asm/bug.h         | 1 +
 arch/x86/include/asm/cpufeature.h  | 1 +
 arch/x86/include/asm/jump_label.h  | 1 +
 include/linux/objtool.h            | 4 +++-
 6 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 15bc07a5ebb39..b14c045679e16 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -198,6 +198,7 @@ static inline int alternatives_text_reserved(void *start, void *end)
 
 #define ALTINSTR_ENTRY(ft_flags)					      \
 	".pushsection .altinstructions,\"a\"\n"				      \
+	ANNOTATE_DATA_SPECIAL						      \
 	" .long 771b - .\n"				/* label           */ \
 	" .long 774f - .\n"				/* new instruction */ \
 	" .4byte " __stringify(ft_flags) "\n"		/* feature + flags */ \
@@ -207,6 +208,7 @@ static inline int alternatives_text_reserved(void *start, void *end)
 
 #define ALTINSTR_REPLACEMENT(newinstr)		/* replacement */	\
 	".pushsection .altinstr_replacement, \"ax\"\n"			\
+	ANNOTATE_DATA_SPECIAL						\
 	"# ALT: replacement\n"						\
 	"774:\n\t" newinstr "\n775:\n"					\
 	".popsection\n"
@@ -337,6 +339,7 @@ void nop_func(void);
  * instruction. See apply_alternatives().
  */
 .macro altinstr_entry orig alt ft_flags orig_len alt_len
+	ANNOTATE_DATA_SPECIAL
 	.long \orig - .
 	.long \alt - .
 	.4byte \ft_flags
@@ -365,6 +368,7 @@ void nop_func(void);
 	.popsection ;							\
 	.pushsection .altinstr_replacement,"ax"	;			\
 743:									\
+	ANNOTATE_DATA_SPECIAL ;						\
 	newinst	;							\
 744:									\
 	.popsection ;
diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index d5c8d3afe1964..bd62bd87a841e 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_ASM_H
 #define _ASM_X86_ASM_H
 
+#include <linux/annotate.h>
+
 #ifdef __ASSEMBLER__
 # define __ASM_FORM(x, ...)		x,## __VA_ARGS__
 # define __ASM_FORM_RAW(x, ...)		x,## __VA_ARGS__
@@ -132,6 +134,7 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
 # define _ASM_EXTABLE_TYPE(from, to, type)			\
 	.pushsection "__ex_table","a" ;				\
 	.balign 4 ;						\
+	ANNOTATE_DATA_SPECIAL ;					\
 	.long (from) - . ;					\
 	.long (to) - . ;					\
 	.long type ;						\
@@ -179,6 +182,7 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
 # define _ASM_EXTABLE_TYPE(from, to, type)			\
 	" .pushsection \"__ex_table\",\"a\"\n"			\
 	" .balign 4\n"						\
+	ANNOTATE_DATA_SPECIAL					\
 	" .long (" #from ") - .\n"				\
 	" .long (" #to ") - .\n"				\
 	" .long " __stringify(type) " \n"			\
@@ -187,6 +191,7 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
 # define _ASM_EXTABLE_TYPE_REG(from, to, type, reg)				\
 	" .pushsection \"__ex_table\",\"a\"\n"					\
 	" .balign 4\n"								\
+	ANNOTATE_DATA_SPECIAL							\
 	" .long (" #from ") - .\n"						\
 	" .long (" #to ") - .\n"						\
 	DEFINE_EXTABLE_TYPE_REG							\
diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index 70711183a020b..3910db28e2f5b 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -57,6 +57,7 @@
 #define _BUG_FLAGS_ASM(ins, file, line, flags, size, extra)		\
 	"1:\t" ins "\n"							\
 	".pushsection __bug_table,\"aw\"\n"				\
+	ANNOTATE_DATA_SPECIAL						\
 	__BUG_ENTRY(file, line, flags)					\
 	"\t.org 2b + " size "\n"					\
 	".popsection\n"							\
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 893cbca37fe99..fc5f32d4da6e1 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -101,6 +101,7 @@ static __always_inline bool _static_cpu_has(u16 bit)
 	asm goto(ALTERNATIVE_TERNARY("jmp 6f", %c[feature], "", "jmp %l[t_no]")
 		".pushsection .altinstr_aux,\"ax\"\n"
 		"6:\n"
+		ANNOTATE_DATA_SPECIAL
 		" testb %[bitnum], %a[cap_byte]\n"
 		" jnz %l[t_yes]\n"
 		" jmp %l[t_no]\n"
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 61dd1dee7812e..e0a6930a4029a 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -15,6 +15,7 @@
 #define JUMP_TABLE_ENTRY(key, label)			\
 	".pushsection __jump_table,  \"aw\" \n\t"	\
 	_ASM_ALIGN "\n\t"				\
+	ANNOTATE_DATA_SPECIAL				\
 	".long 1b - . \n\t"				\
 	".long " label " - . \n\t"			\
 	_ASM_PTR " " key " - . \n\t"			\
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index 1973e9f14bf95..4fea6a042b28f 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -9,9 +9,10 @@
 
 #ifndef __ASSEMBLY__
 
-#define UNWIND_HINT(type, sp_reg, sp_offset, signal)	\
+#define UNWIND_HINT(type, sp_reg, sp_offset, signal)		\
 	"987: \n\t"						\
 	".pushsection .discard.unwind_hints\n\t"		\
+	ANNOTATE_DATA_SPECIAL					\
 	/* struct unwind_hint */				\
 	".long 987b - .\n\t"					\
 	".short " __stringify(sp_offset) "\n\t"			\
@@ -78,6 +79,7 @@
 .macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0
 .Lhere_\@:
 	.pushsection .discard.unwind_hints
+		ANNOTATE_DATA_SPECIAL
 		/* struct unwind_hint */
 		.long .Lhere_\@ - .
 		.short \sp_offset
-- 
2.50.0


