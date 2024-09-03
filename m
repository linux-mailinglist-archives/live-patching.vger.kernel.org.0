Return-Path: <live-patching+bounces-562-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CBB709692A2
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:05:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57E731F22165
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 465F9200105;
	Tue,  3 Sep 2024 04:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rxbI3mU7"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF9A1DAC7C;
	Tue,  3 Sep 2024 04:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336044; cv=none; b=YpMy1DwubzxoDZHbz5cwWF9bEr/GFH2tDYGJyMVBu+7TYFFcjoD4KkXAQuAXjdze3JlvpAFXXfbHVHaSmyFDwpf5lhhQnhj8cqdbJvGtqbespZNMQettiwjDxsT+UvRf5ZMp5rEHIY6ogDxsG5OL0xi426OGIsDfN/f2RriQWfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336044; c=relaxed/simple;
	bh=1honWldDE9HPro70aVWOosNOZlcXniv/IfkuI0B+mzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTO1svyu9SVsrrVt3tUKCRJ5DuHVPP7TeczEJEyiLXhHBWYY0g052Hx9I7/Hi9Oh/hViQBK+dOFICxt2xmd7HyA3g/paNKTUvgcedvW/evOrR5Tz61n1Buzndze07jDfxGSA9HP0KbL0gOrHE9fzW4JMe+Ge1NasjHA0yGSgU94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rxbI3mU7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DC5C4CEC5;
	Tue,  3 Sep 2024 04:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336043;
	bh=1honWldDE9HPro70aVWOosNOZlcXniv/IfkuI0B+mzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxbI3mU7AbF5OwNxmY4B3N+/RwJwaKl66aeqNKAoM96V1Wbxk71uumDDogn329ofu
	 2DNcwcbWk33Sxd1q/js1ZioDL5nWJu2cZjcqBCMR719gajJR6guVK4CMPqxlRS1y4P
	 r/QlL00xn4X2jre6EtC9ceuN+0Q/ZY//hdR0ZEglggUdHJnoxYOdLoM1N8FwQkOf7X
	 HtINPBWeWl9EXjf8DissOrONz6TU9OPxssjDs/z/vL7IiJKXhElQRfESdu40YbvUgB
	 1cByk6YraAUGryt1W/4LTesxeEeg/wWriD5b8uVp42lPkrv+JX+xdNxdcpFIWfyTWG
	 8Fdqz1h60aMjA==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: [RFC 28/31] x86/alternative: Create symbols for special section entries
Date: Mon,  2 Sep 2024 21:00:11 -0700
Message-ID: <7bc1bcb1cd875350948f43c77c9895173bd22012.1725334260.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Create a symbol for each special section entry.  This helps objtool
extract needed entries.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/include/asm/alternative.h | 50 ++++++++++++++++++++----------
 arch/x86/include/asm/asm.h         | 24 +++++++++-----
 arch/x86/include/asm/bug.h         |  2 ++
 arch/x86/include/asm/cpufeature.h  |  2 ++
 arch/x86/include/asm/jump_label.h  |  2 ++
 include/linux/objtool.h            | 31 +++++++++++++++++-
 tools/objtool/check.c              | 22 +++++++++++--
 7 files changed, 104 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index ba99ef75f56c..2617253bcb00 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -157,7 +157,9 @@ static inline int alternatives_text_reserved(void *start, void *end)
 #define ALT_CALL_INSTR		"call BUG_func"
 
 #define b_replacement(num)	"664"#num
-#define e_replacement(num)	"665"#num
+
+#define __e_replacement(num)	__PASTE(665, num)
+#define e_replacement(num)	__stringify(__e_replacement(num))
 
 #define alt_end_marker		"663"
 #define alt_slen		"662b-661b"
@@ -203,15 +205,21 @@ static inline int alternatives_text_reserved(void *start, void *end)
 	alt_end_marker ":\n"
 
 #define ALTINSTR_ENTRY(ft_flags, num)					      \
+	FAKE_SYMBOL(__alt_, 681f)					      \
 	" .long 661b - .\n"				/* label           */ \
 	" .long " b_replacement(num)"f - .\n"		/* new instruction */ \
 	" .4byte " __stringify(ft_flags) "\n"		/* feature + flags */ \
 	" .byte " alt_total_slen "\n"			/* source len      */ \
-	" .byte " alt_rlen(num) "\n"			/* replacement len */
+	" .byte " alt_rlen(num) "\n"			/* replacement len */ \
+	"681:\n"
 
-#define ALTINSTR_REPLACEMENT(newinstr, num)		/* replacement */	\
+#define ALTINSTR_REPLACEMENT(newinstr, num)					\
 	"# ALT: replacement " #num "\n"						\
-	b_replacement(num)":\n\t" newinstr "\n" e_replacement(num) ":\n"
+	FAKE_SYMBOL(__alt_instr_, __PASTE(__e_replacement(num), f))		\
+	b_replacement(num) ":\n"						\
+	"\t" newinstr "\n"							\
+	e_replacement(num) ":\n"
+
 
 /* alternative assembly primitive: */
 #define ALTERNATIVE(oldinstr, newinstr, ft_flags)			\
@@ -370,12 +378,20 @@ void nop_func(void);
  * enough information for the alternatives patching code to patch an
  * instruction. See apply_alternatives().
  */
-.macro altinstr_entry orig alt ft_flags orig_len alt_len
+.macro ALTINSTR_ENTRY orig alt ft_flags orig_len alt_len
+	FAKE_SYMBOL(__alt_, 681f)
 	.long \orig - .
 	.long \alt - .
 	.4byte \ft_flags
 	.byte \orig_len
 	.byte \alt_len
+	681:
+.endm
+
+.macro ALTINSTR_REPLACEMENT newinstr
+	FAKE_SYMBOL(__alt_instr_, 681f)
+	\newinstr
+	681:
 .endm
 
 .macro ALT_CALL_INSTR
@@ -396,12 +412,12 @@ void nop_func(void);
 142:
 
 	.pushsection .altinstructions,"a"
-	altinstr_entry 140b,143f,\ft_flags,142b-140b,144f-143f
+	ALTINSTR_ENTRY 140b,143f,\ft_flags,142b-140b,144f-143f
 	.popsection
 
 	.pushsection .altinstr_replacement,"ax"
 143:
-	\newinstr
+	ALTINSTR_REPLACEMENT "\newinstr"
 144:
 	.popsection
 .endm
@@ -435,15 +451,15 @@ void nop_func(void);
 142:
 
 	.pushsection .altinstructions,"a"
-	altinstr_entry 140b,143f,\ft_flags1,142b-140b,144f-143f
-	altinstr_entry 140b,144f,\ft_flags2,142b-140b,145f-144f
+	ALTINSTR_ENTRY 140b,143f,\ft_flags1,142b-140b,144f-143f
+	ALTINSTR_ENTRY 140b,144f,\ft_flags2,142b-140b,145f-144f
 	.popsection
 
 	.pushsection .altinstr_replacement,"ax"
 143:
-	\newinstr1
+	ALTINSTR_REPLACEMENT "\newinstr1"
 144:
-	\newinstr2
+	ALTINSTR_REPLACEMENT "\newinstr2"
 145:
 	.popsection
 .endm
@@ -457,18 +473,18 @@ void nop_func(void);
 142:
 
 	.pushsection .altinstructions,"a"
-	altinstr_entry 140b,143f,\ft_flags1,142b-140b,144f-143f
-	altinstr_entry 140b,144f,\ft_flags2,142b-140b,145f-144f
-	altinstr_entry 140b,145f,\ft_flags3,142b-140b,146f-145f
+	ALTINSTR_ENTRY 140b,143f,\ft_flags1,142b-140b,144f-143f
+	ALTINSTR_ENTRY 140b,144f,\ft_flags2,142b-140b,145f-144f
+	ALTINSTR_ENTRY 140b,145f,\ft_flags3,142b-140b,146f-145f
 	.popsection
 
 	.pushsection .altinstr_replacement,"ax"
 143:
-	\newinstr1
+	ALTINSTR_REPLACEMENT "\newinstr1"
 144:
-	\newinstr2
+	ALTINSTR_REPLACEMENT "\newinstr2"
 145:
-	\newinstr3
+	ALTINSTR_REPLACEMENT "\newinstr3"
 146:
 	.popsection
 .endm
diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 2bec0c89a95c..c337240d342c 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_ASM_H
 #define _ASM_X86_ASM_H
 
+#include <linux/objtool.h>
+
 #ifdef __ASSEMBLY__
 # define __ASM_FORM(x, ...)		x,## __VA_ARGS__
 # define __ASM_FORM_RAW(x, ...)		x,## __VA_ARGS__
@@ -149,9 +151,11 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
 # define _ASM_EXTABLE_TYPE(from, to, type)			\
 	.pushsection "__ex_table","a" ;				\
 	.balign 4 ;						\
+	FAKE_SYMBOL(__ex_table_, 555f) ;			\
 	.long (from) - . ;					\
 	.long (to) - . ;					\
 	.long type ;						\
+	555: ;							\
 	.popsection
 
 # ifdef CONFIG_KPROBES
@@ -196,19 +200,23 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
 # define _ASM_EXTABLE_TYPE(from, to, type)			\
 	" .pushsection \"__ex_table\",\"a\"\n"			\
 	" .balign 4\n"						\
+	FAKE_SYMBOL(__ex_table_, 555f)			\
 	" .long (" #from ") - .\n"				\
 	" .long (" #to ") - .\n"				\
 	" .long " __stringify(type) " \n"			\
+	" 555:\n"						\
 	" .popsection\n"
 
-# define _ASM_EXTABLE_TYPE_REG(from, to, type, reg)				\
-	" .pushsection \"__ex_table\",\"a\"\n"					\
-	" .balign 4\n"								\
-	" .long (" #from ") - .\n"						\
-	" .long (" #to ") - .\n"						\
-	DEFINE_EXTABLE_TYPE_REG							\
-	"extable_type_reg reg=" __stringify(reg) ", type=" __stringify(type) " \n"\
-	UNDEFINE_EXTABLE_TYPE_REG						\
+# define _ASM_EXTABLE_TYPE_REG(from, to, type, reg)					\
+	" .pushsection \"__ex_table\",\"a\"\n"						\
+	" .balign 4\n"									\
+	FAKE_SYMBOL(__ex_table_, 555f)							\
+	" .long (" #from ") - .\n"							\
+	" .long (" #to ") - .\n"							\
+	DEFINE_EXTABLE_TYPE_REG								\
+	"extable_type_reg reg=" __stringify(reg) ", type=" __stringify(type) " \n"	\
+	UNDEFINE_EXTABLE_TYPE_REG							\
+	" 555:\n"									\
 	" .popsection\n"
 
 /* For C file, we already have NOKPROBE_SYMBOL macro */
diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index a3ec87d198ac..86304d7d68f5 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -27,6 +27,7 @@
 do {									\
 	asm_inline volatile("1:\t" ins "\n"				\
 		     ".pushsection __bug_table,\"aw\"\n"		\
+		     FAKE_SYMBOL(__bug_table_, . + %c3)			\
 		     "2:\t" __BUG_REL(1b) "\t# bug_entry::bug_addr\n"	\
 		     "\t"  __BUG_REL(%c0) "\t# bug_entry::file\n"	\
 		     "\t.word %c1"        "\t# bug_entry::line\n"	\
@@ -45,6 +46,7 @@ do {									\
 do {									\
 	asm_inline volatile("1:\t" ins "\n"				\
 		     ".pushsection __bug_table,\"aw\"\n"		\
+		     FAKE_SYMBOL(__bug_table_, . + %c1)			\
 		     "2:\t" __BUG_REL(1b) "\t# bug_entry::bug_addr\n"	\
 		     "\t.word %c0"        "\t# bug_entry::flags\n"	\
 		     "\t.org 2b+%c1\n"					\
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 0b9611da6c53..9decf644d55a 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -178,9 +178,11 @@ static __always_inline bool _static_cpu_has(u16 bit)
 	asm goto(ALTERNATIVE_TERNARY("jmp 6f", %c[feature], "", "jmp %l[t_no]")
 		".pushsection .altinstr_aux,\"ax\"\n"
 		"6:\n"
+		FAKE_SYMBOL(__alt_aux_, 681f)
 		" testb %[bitnum], %a[cap_byte]\n"
 		" jnz %l[t_yes]\n"
 		" jmp %l[t_no]\n"
+		"681:\n"
 		".popsection\n"
 		 : : [feature]  "i" (bit),
 		     [bitnum]   "i" (1 << (bit & 7)),
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index cbbef32517f0..731d7e69d244 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -15,9 +15,11 @@
 #define JUMP_TABLE_ENTRY				\
 	".pushsection __jump_table,  \"aw\" \n\t"	\
 	_ASM_ALIGN "\n\t"				\
+	FAKE_SYMBOL(__jump_table_, 2f)			\
 	".long 1b - . \n\t"				\
 	".long %l[l_yes] - . \n\t"			\
 	_ASM_PTR "%c0 + %c1 - .\n\t"			\
+	"2:\n\t"					\
 	".popsection \n\t"
 
 #ifdef CONFIG_HAVE_JUMP_LABEL_HACK
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index 5e66b6d26df5..ae5030cac10d 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -10,9 +10,27 @@
 
 #ifndef __ASSEMBLY__
 
-#define UNWIND_HINT(type, sp_reg, sp_offset, signal)	\
+#define DEFINE_FAKE_SYMBOL						\
+	".macro fake_symbol name, end\n\t"				\
+	"#ifdef __x86_64__\n"						\
+	".type \\name\\@, @object\n"					\
+	".size \\name\\@, \\end - .\n"					\
+	"\\name\\@:\n"							\
+	"#endif\n"							\
+	".endm\n\t"
+
+#define UNDEFINE_FAKE_SYMBOL						\
+	".purgem fake_symbol\n\t"
+
+#define FAKE_SYMBOL(name, end)							\
+	DEFINE_FAKE_SYMBOL							\
+	"fake_symbol " __stringify(name) ", \"" __stringify(end) "\"\n\t"	\
+	UNDEFINE_FAKE_SYMBOL
+
+#define UNWIND_HINT(type, sp_reg, sp_offset, signal)		\
 	"987: \n\t"						\
 	".pushsection .discard.unwind_hints\n\t"		\
+	FAKE_SYMBOL(__unwind_hint_, 988f)			\
 	/* struct unwind_hint */				\
 	".long 987b - .\n\t"					\
 	".short " __stringify(sp_offset) "\n\t"			\
@@ -20,6 +38,7 @@
 	".byte " __stringify(type) "\n\t"			\
 	".byte " __stringify(signal) "\n\t"			\
 	".balign 4 \n\t"					\
+	"988:\n\t"						\
 	".popsection\n\t"
 
 /*
@@ -60,6 +79,14 @@
 
 #else /* __ASSEMBLY__ */
 
+.macro fake_symbol name, end
+	.type \name\@, @object
+	.size \name\@, \end - .
+	\name\@:
+.endm
+
+#define FAKE_SYMBOL(name, end) fake_symbol name, __stringify(end)
+
 /*
  * This macro indicates that the following intra-function call is valid.
  * Any non-annotated intra-function call will cause objtool to issue a warning.
@@ -94,6 +121,7 @@
 .macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0
 .Lhere_\@:
 	.pushsection .discard.unwind_hints
+		FAKE_SYMBOL(__unwind_hint_, .Lend_\@)
 		/* struct unwind_hint */
 		.long .Lhere_\@ - .
 		.short \sp_offset
@@ -101,6 +129,7 @@
 		.byte \type
 		.byte \signal
 		.balign 4
+		.Lend_\@:
 	.popsection
 .endm
 
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 3c8d0903dfa7..5dd78a7f75c3 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -633,6 +633,18 @@ static void add_dead_ends(struct objtool_file *file)
 	}
 }
 
+static void create_fake_symbol(struct objtool_file *file, const char *name_pfx,
+			       struct section *sec, unsigned long offset,
+			       size_t size)
+{
+	char name[256];
+	static int ctr;
+
+	snprintf(name, 256, "%s_%d", name_pfx, ctr++);
+
+	elf_create_symbol(file->elf, name, sec, STB_LOCAL, STT_OBJECT, offset, size);
+}
+
 static void create_static_call_sections(struct objtool_file *file)
 {
 	struct static_call_site *site;
@@ -664,10 +676,11 @@ static void create_static_call_sections(struct objtool_file *file)
 
 	idx = 0;
 	list_for_each_entry(insn, &file->static_call_list, call_node) {
+		unsigned long offset = idx * sizeof(*site);
 
 		/* populate reloc for 'addr' */
-		elf_init_reloc_text_sym(file->elf, sec, idx * sizeof(*site),
-					idx * 2, insn->sec, insn->offset);
+		elf_init_reloc_text_sym(file->elf, sec, offset, idx * 2,
+					insn->sec, insn->offset);
 
 		/* find key symbol */
 		key_name = strdup(insn_call_dest(insn)->name);
@@ -698,10 +711,13 @@ static void create_static_call_sections(struct objtool_file *file)
 		free(key_name);
 
 		/* populate reloc for 'key' */
-		elf_init_reloc_data_sym(file->elf, sec, idx * sizeof(*site) + 4,
+		elf_init_reloc_data_sym(file->elf, sec, offset + 4,
 					(idx * 2) + 1, key_sym,
 					is_sibling_call(insn) * STATIC_CALL_SITE_TAIL);
 
+		create_fake_symbol(file, "__static_call_site_", sec,
+				   offset, sizeof(*site));
+
 		idx++;
 	}
 }
-- 
2.45.2


