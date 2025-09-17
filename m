Return-Path: <live-patching+bounces-1655-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A03E5B80D1F
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:04:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 698907A9D09
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BB90281356;
	Wed, 17 Sep 2025 16:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LYYQ3oKG"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6874826773C;
	Wed, 17 Sep 2025 16:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125056; cv=none; b=Pu893zXinlAu1DIOQhBCWIvy0EvA9tFa+kPqtZbc9WgSpAc6T6py9WCwXt9ytO7S8sQS8FWbda4DF6DXkC+3/hylc0gwh54QjdcsXxT97u0HR2xddYlvHZALAPKgQUQsp7QzR4ED9M6DT3LIZYxYKdtNIHfCzKxKhhC/opNugy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125056; c=relaxed/simple;
	bh=jTcqUGXtWoVPGh+8cg0pNlASKA2dG+yFOLCZUshOHXw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XG6cS2Mb7w7Wvzz3dVbAyDhICuZ0U0o6dHgeQWXWZDqnMX36bcz+36LuKxxh85ROEyCtwqvK0UEdhQb89zuuox/RpB/NvY1aoPYpFNqcXHEHTUeMMRc0BK2fnsSP0icqprsmJrDOuV6o9AQCBMui3G0YfLMpXLUgiujEYWnVf7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LYYQ3oKG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5A9C4CEE7;
	Wed, 17 Sep 2025 16:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125055;
	bh=jTcqUGXtWoVPGh+8cg0pNlASKA2dG+yFOLCZUshOHXw=;
	h=From:To:Cc:Subject:Date:From;
	b=LYYQ3oKGrVYSpaMIWqyt7n6dMHeO9xgTEJpmH1iPXzSfmj6qWP8qV6udTcKOjBYI2
	 aetqGA2kn0553uHnFiZIkx2ZKCI27qB1+AlsSRjnDeumdTa8ZlabwVpmNCZ4wbFQyP
	 0MUgCZVVwv+p6RBbU42PfwTXQDfKKNSxu0X7oWh8UAybH8ijFuAfO1NEoUZ+X2KKhT
	 hUDog6MVO3gYiE71H+UNHdCECmTiyw2I0+Ec1NzdYlyAzXvvyquXdcSHfPfkwjXkC7
	 Q4RPE45FW9DNE4jAEjAjy/ojoSHzEqicvpT4tNLIlJAsoKiNrDt6qy7KvAnjT405cf
	 rJfTeYMy6i55g==
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
Subject: [PATCH v4 00/63] objtool,livepatch: klp-build livepatch module generation
Date: Wed, 17 Sep 2025 09:03:08 -0700
Message-ID: <cover.1758067942.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v3 (https://lore.kernel.org/cover.1750980516.git.jpoimboe@kernel.org):

- Get rid of the SHF_MERGE+SHF_WRITE toolchain shenanigans in favor of
  simple .discard.annotate_data annotations
- Fix potential double free in elf_create_reloc()
- Sync interval_tree_generic.h (Peter)
- Refactor prefix symbol creation error handling
- Rebase on tip/master and fix new issue (--checksum getting added with --noabs)

(v3..v4 diff below)

----

This series introduces new objtool features and a klp-build script to
generate livepatch modules using a source .patch as input.

This builds on concepts from the longstanding out-of-tree kpatch [1]
project which began in 2012 and has been used for many years to generate
livepatch modules for production kernels.  However, this is a complete
rewrite which incorporates hard-earned lessons from 12+ years of
maintaining kpatch.

Key improvements compared to kpatch-build:

  - Integrated with objtool: Leverages objtool's existing control-flow
    graph analysis to help detect changed functions.

  - Works on vmlinux.o: Supports late-linked objects, making it
    compatible with LTO, IBT, and similar.

  - Simplified code base: ~3k fewer lines of code.

  - Upstream: No more out-of-tree #ifdef hacks, far less cruft.

  - Cleaner internals: Vastly simplified logic for symbol/section/reloc
    inclusion and special section extraction.

  - Robust __LINE__ macro handling: Avoids false positive binary diffs
    caused by the __LINE__ macro by introducing a fix-patch-lines script
    which injects #line directives into the source .patch to preserve
    the original line numbers at compile time.

The primary user interface is the klp-build script which does the
following:

  - Builds an original kernel with -function-sections and
    -fdata-sections, plus objtool function checksumming.

  - Applies the .patch file and rebuilds the kernel using the same
    options.

  - Runs 'objtool klp diff' to detect changed functions and generate
    intermediate binary diff objects.

  - Builds a kernel module which links the diff objects with some
    livepatch module init code (scripts/livepatch/init.c).

  - Finalizes the livepatch module (aka work around linker wreckage)
    using 'objtool klp post-link'.

I've tested with a variety of patches on defconfig and Fedora-config
kernels with both GCC and Clang.

These patches can also be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git klp-build-v3

Please test!

[1] https://github.com/dynup/kpatch

Josh Poimboeuf (63):
  s390/vmlinux.lds.S: Prevent thunk functions from getting placed with
    normal text
  vmlinux.lds: Unify TEXT_MAIN, DATA_MAIN, and related macros
  x86/module: Improve relocation error messages
  x86/kprobes: Remove STACK_FRAME_NON_STANDARD annotation
  compiler: Tweak __UNIQUE_ID() naming
  compiler.h: Make addressable symbols less of an eyesore
  elfnote: Change ELFNOTE() to use __UNIQUE_ID()
  kbuild: Remove 'kmod_' prefix from __KBUILD_MODNAME
  modpost: Ignore unresolved section bounds symbols
  x86/alternative: Refactor INT3 call emulation selftest
  interval_tree: Sync interval_tree_generic.h with tools
  interval_tree: Fix ITSTATIC usage for *_subtree_search()
  objtool: Make find_symbol_containing() less arbitrary
  objtool: Fix broken error handling in read_symbols()
  objtool: Propagate elf_truncate_section() error in elf_write()
  objtool: Remove error handling boilerplate
  objtool: Add empty symbols to the symbol tree again
  objtool: Fix interval tree insertion for zero-length symbols
  objtool: Fix weak symbol detection
  objtool: Fix x86 addend calculation
  objtool: Fix __pa_symbol() relocation handling
  objtool: Fix "unexpected end of section" warning for alternatives
  objtool: Check for missing annotation entries in read_annotate()
  objtool: Const string cleanup
  objtool: Clean up compiler flag usage
  objtool: Remove .parainstructions reference
  objtool: Convert elf iterator macros to use 'struct elf'
  objtool: Add section/symbol type helpers
  objtool: Mark .cold subfunctions
  objtool: Fix weak symbol hole detection for .cold functions
  objtool: Mark prefix functions
  objtool: Simplify reloc offset calculation in unwind_read_hints()
  objtool: Avoid emptying lists for duplicate sections
  objtool: Rename --Werror to --werror
  objtool: Resurrect --backup option
  objtool: Reindent check_options[]
  objtool: Refactor add_jump_destinations()
  objtool: Simplify special symbol handling in elf_update_symbol()
  objtool: Generalize elf_create_symbol()
  objtool: Generalize elf_create_section()
  objtool: Add elf_create_data()
  objtool: Add elf_create_reloc() and elf_init_reloc()
  objtool: Add elf_create_file()
  objtool: Add annotype() helper
  objtool: Move ANNOTATE* macros to annotate.h
  objtool: Add ANNOTATE_DATA_SPECIAL
  x86/asm: Annotate special section entries
  objtool: Unify STACK_FRAME_NON_STANDARD entry sizes
  objtool/klp: Add --checksum option to generate per-function checksums
  objtool/klp: Add --debug-checksum=<funcs> to show per-instruction
    checksums
  objtool/klp: Introduce klp diff subcommand for diffing object files
  objtool/klp: Add --debug option to show cloning decisions
  objtool/klp: Add post-link subcommand to finalize livepatch modules
  objtool: Refactor prefix symbol creation code
  objtool: Add base objtool support for livepatch modules
  livepatch: Add CONFIG_KLP_BUILD
  kbuild,objtool: Defer objtool validation step for CONFIG_KLP_BUILD
  livepatch/klp-build: Introduce fix-patch-lines script to avoid
    __LINE__ diff noise
  livepatch/klp-build: Add stub init code for livepatch modules
  livepatch/klp-build: Introduce klp-build script for generating
    livepatch modules
  livepatch/klp-build: Add --debug option to show cloning decisions
  livepatch/klp-build: Add --show-first-changed option to show function
    divergence
  livepatch: Introduce source code helpers for livepatch modules

 MAINTAINERS                                   |    3 +-
 arch/s390/include/asm/nospec-insn.h           |    2 +-
 arch/s390/kernel/vmlinux.lds.S                |    2 +-
 arch/x86/Kconfig                              |    1 +
 arch/x86/include/asm/alternative.h            |    4 +
 arch/x86/include/asm/asm.h                    |    5 +
 arch/x86/include/asm/bug.h                    |    1 +
 arch/x86/include/asm/cpufeature.h             |    1 +
 arch/x86/include/asm/jump_label.h             |    1 +
 arch/x86/kernel/alternative.c                 |   51 +-
 arch/x86/kernel/kprobes/opt.c                 |    4 -
 arch/x86/kernel/module.c                      |   15 +-
 include/asm-generic/vmlinux.lds.h             |   40 +-
 include/linux/annotate.h                      |  134 ++
 include/linux/compiler.h                      |    8 +-
 include/linux/elfnote.h                       |   13 +-
 include/linux/init.h                          |    3 +-
 include/linux/interval_tree.h                 |    4 +
 include/linux/interval_tree_generic.h         |    2 +-
 include/linux/livepatch.h                     |   25 +-
 include/linux/livepatch_external.h            |   76 +
 include/linux/livepatch_helpers.h             |   77 +
 include/linux/mm.h                            |    2 +
 include/linux/objtool.h                       |   96 +-
 include/linux/objtool_types.h                 |    2 +
 kernel/livepatch/Kconfig                      |   12 +
 kernel/livepatch/core.c                       |    8 +-
 scripts/Makefile.lib                          |    7 +-
 scripts/Makefile.vmlinux_o                    |    2 +-
 scripts/link-vmlinux.sh                       |    3 +-
 scripts/livepatch/fix-patch-lines             |   79 +
 scripts/livepatch/init.c                      |  108 ++
 scripts/livepatch/klp-build                   |  827 ++++++++
 scripts/mod/modpost.c                         |    5 +
 scripts/module.lds.S                          |   22 +-
 tools/include/linux/interval_tree_generic.h   |   10 +-
 tools/include/linux/livepatch_external.h      |   76 +
 tools/include/linux/objtool_types.h           |    2 +
 tools/include/linux/string.h                  |   14 +
 tools/objtool/Build                           |    4 +-
 tools/objtool/Makefile                        |   48 +-
 tools/objtool/arch/loongarch/decode.c         |    6 +-
 tools/objtool/arch/loongarch/orc.c            |    1 -
 tools/objtool/arch/powerpc/decode.c           |    7 +-
 tools/objtool/arch/x86/decode.c               |   63 +-
 tools/objtool/arch/x86/orc.c                  |    1 -
 tools/objtool/arch/x86/special.c              |    2 +-
 tools/objtool/builtin-check.c                 |   96 +-
 tools/objtool/builtin-klp.c                   |   53 +
 tools/objtool/check.c                         |  875 +++++----
 tools/objtool/elf.c                           |  781 ++++++--
 tools/objtool/include/objtool/arch.h          |    5 +-
 tools/objtool/include/objtool/builtin.h       |   11 +-
 tools/objtool/include/objtool/check.h         |    6 +-
 tools/objtool/include/objtool/checksum.h      |   43 +
 .../objtool/include/objtool/checksum_types.h  |   25 +
 tools/objtool/include/objtool/elf.h           |  196 +-
 tools/objtool/include/objtool/endianness.h    |    9 +-
 tools/objtool/include/objtool/klp.h           |   35 +
 tools/objtool/include/objtool/objtool.h       |    4 +-
 tools/objtool/include/objtool/util.h          |   19 +
 tools/objtool/include/objtool/warn.h          |   40 +
 tools/objtool/klp-diff.c                      | 1723 +++++++++++++++++
 tools/objtool/klp-post-link.c                 |  168 ++
 tools/objtool/objtool.c                       |   42 +-
 tools/objtool/orc_dump.c                      |    1 -
 tools/objtool/orc_gen.c                       |    9 +-
 tools/objtool/special.c                       |   14 +-
 tools/objtool/sync-check.sh                   |    2 +
 tools/objtool/weak.c                          |    7 +
 70 files changed, 5152 insertions(+), 891 deletions(-)
 create mode 100644 include/linux/annotate.h
 create mode 100644 include/linux/livepatch_external.h
 create mode 100644 include/linux/livepatch_helpers.h
 create mode 100755 scripts/livepatch/fix-patch-lines
 create mode 100644 scripts/livepatch/init.c
 create mode 100755 scripts/livepatch/klp-build
 create mode 100644 tools/include/linux/livepatch_external.h
 create mode 100644 tools/objtool/builtin-klp.c
 create mode 100644 tools/objtool/include/objtool/checksum.h
 create mode 100644 tools/objtool/include/objtool/checksum_types.h
 create mode 100644 tools/objtool/include/objtool/klp.h
 create mode 100644 tools/objtool/include/objtool/util.h
 create mode 100644 tools/objtool/klp-diff.c
 create mode 100644 tools/objtool/klp-post-link.c

-- 
2.50.0

diff --git a/arch/Kconfig b/arch/Kconfig
index 4fb74eade61af..b13e86ad23e2f 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1368,9 +1368,6 @@ config HAVE_NOINSTR_HACK
 config HAVE_NOINSTR_VALIDATION
 	bool
 
-config NEED_MODULE_PERMISSIONS_FIX
-	bool
-
 config HAVE_UACCESS_VALIDATION
 	bool
 	select OBJTOOL
diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index 1b9b82bbe3220..b6810db24ca4d 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -5,6 +5,7 @@ generic-y += device.h
 generic-y += dma-mapping.h
 generic-y += emergency-restart.h
 generic-y += exec.h
+generic-y += extable.h
 generic-y += ftrace.h
 generic-y += hw_irq.h
 generic-y += irq_regs.h
diff --git a/arch/um/include/shared/common-offsets.h b/arch/um/include/shared/common-offsets.h
index a6f77cb6aa7e1..8ca66a1918c3a 100644
--- a/arch/um/include/shared/common-offsets.h
+++ b/arch/um/include/shared/common-offsets.h
@@ -18,6 +18,3 @@ DEFINE(UM_NSEC_PER_USEC, NSEC_PER_USEC);
 DEFINE(UM_KERN_GDT_ENTRY_TLS_ENTRIES, GDT_ENTRY_TLS_ENTRIES);
 
 DEFINE(UM_SECCOMP_ARCH_NATIVE, SECCOMP_ARCH_NATIVE);
-
-DEFINE(ALT_INSTR_SIZE, sizeof(struct alt_instr));
-DEFINE(EXTABLE_SIZE,   sizeof(struct exception_table_entry));
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 073274e35da5e..986d31587e999 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -305,7 +305,6 @@ config X86
 	select HOTPLUG_SPLIT_STARTUP		if SMP && X86_32
 	select IRQ_FORCED_THREADING
 	select LOCK_MM_AND_FIND_VMA
-	select NEED_MODULE_PERMISSIONS_FIX
 	select NEED_PER_CPU_EMBED_FIRST_CHUNK
 	select NEED_PER_CPU_PAGE_FIRST_CHUNK
 	select NEED_SG_DMA_LENGTH
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index eb24d9ba30d7f..b14c045679e16 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -197,8 +197,8 @@ static inline int alternatives_text_reserved(void *start, void *end)
 	"773:\n"
 
 #define ALTINSTR_ENTRY(ft_flags)					      \
-	".pushsection .altinstructions, \"aM\", @progbits, "		      \
-		      __stringify(ALT_INSTR_SIZE) "\n"			      \
+	".pushsection .altinstructions,\"a\"\n"				      \
+	ANNOTATE_DATA_SPECIAL						      \
 	" .long 771b - .\n"				/* label           */ \
 	" .long 774f - .\n"				/* new instruction */ \
 	" .4byte " __stringify(ft_flags) "\n"		/* feature + flags */ \
@@ -208,6 +208,7 @@ static inline int alternatives_text_reserved(void *start, void *end)
 
 #define ALTINSTR_REPLACEMENT(newinstr)		/* replacement */	\
 	".pushsection .altinstr_replacement, \"ax\"\n"			\
+	ANNOTATE_DATA_SPECIAL						\
 	"# ALT: replacement\n"						\
 	"774:\n\t" newinstr "\n775:\n"					\
 	".popsection\n"
@@ -338,6 +339,7 @@ void nop_func(void);
  * instruction. See apply_alternatives().
  */
 .macro altinstr_entry orig alt ft_flags orig_len alt_len
+	ANNOTATE_DATA_SPECIAL
 	.long \orig - .
 	.long \alt - .
 	.4byte \ft_flags
@@ -361,11 +363,12 @@ void nop_func(void);
 741:									\
 	.skip -(((744f-743f)-(741b-740b)) > 0) * ((744f-743f)-(741b-740b)),0x90	;\
 742:									\
-	.pushsection .altinstructions, "aM", @progbits, ALT_INSTR_SIZE ;\
+	.pushsection .altinstructions,"a" ;				\
 	altinstr_entry 740b,743f,flag,742b-740b,744f-743f ;		\
 	.popsection ;							\
 	.pushsection .altinstr_replacement,"ax"	;			\
 743:									\
+	ANNOTATE_DATA_SPECIAL ;						\
 	newinst	;							\
 744:									\
 	.popsection ;
diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index ecb28d2bc6730..bd62bd87a841e 100644
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
@@ -124,21 +126,18 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
 
 #ifdef __KERNEL__
 
-#ifndef COMPILE_OFFSETS
-#include <asm/asm-offsets.h>
-#endif
-
 # include <asm/extable_fixup_types.h>
 
 /* Exception table entry */
 #ifdef __ASSEMBLER__
 
-# define _ASM_EXTABLE_TYPE(from, to, type)				\
-	.pushsection "__ex_table", "aM", @progbits, EXTABLE_SIZE;	\
-	.balign 4 ;							\
-	.long (from) - . ;						\
-	.long (to) - . ;						\
-	.long type ;							\
+# define _ASM_EXTABLE_TYPE(from, to, type)			\
+	.pushsection "__ex_table","a" ;				\
+	.balign 4 ;						\
+	ANNOTATE_DATA_SPECIAL ;					\
+	.long (from) - . ;					\
+	.long (to) - . ;					\
+	.long type ;						\
 	.popsection
 
 # ifdef CONFIG_KPROBES
@@ -181,18 +180,18 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
 	".purgem extable_type_reg\n"
 
 # define _ASM_EXTABLE_TYPE(from, to, type)			\
-	" .pushsection __ex_table, \"aM\", @progbits, "		\
-		       __stringify(EXTABLE_SIZE) "\n"		\
+	" .pushsection \"__ex_table\",\"a\"\n"			\
 	" .balign 4\n"						\
+	ANNOTATE_DATA_SPECIAL					\
 	" .long (" #from ") - .\n"				\
 	" .long (" #to ") - .\n"				\
 	" .long " __stringify(type) " \n"			\
 	" .popsection\n"
 
 # define _ASM_EXTABLE_TYPE_REG(from, to, type, reg)				\
-	" .pushsection __ex_table, \"aM\", @progbits, "				\
-		       __stringify(EXTABLE_SIZE) "\n"				\
+	" .pushsection \"__ex_table\",\"a\"\n"					\
 	" .balign 4\n"								\
+	ANNOTATE_DATA_SPECIAL							\
 	" .long (" #from ") - .\n"						\
 	" .long (" #to ") - .\n"						\
 	DEFINE_EXTABLE_TYPE_REG							\
diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index db1522fdbd108..3910db28e2f5b 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -56,7 +56,8 @@
 
 #define _BUG_FLAGS_ASM(ins, file, line, flags, size, extra)		\
 	"1:\t" ins "\n"							\
-	".pushsection __bug_table, \"aM\", @progbits, " size "\n"	\
+	".pushsection __bug_table,\"aw\"\n"				\
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
index 7a6b0e5d85c19..e0a6930a4029a 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -12,17 +12,13 @@
 #include <linux/stringify.h>
 #include <linux/types.h>
 
-#ifndef COMPILE_OFFSETS
-#include <generated/bounds.h>
-#endif
-
-#define JUMP_TABLE_ENTRY(key, label)				\
-	".pushsection __jump_table,  \"aM\", @progbits, "	\
-	__stringify(JUMP_ENTRY_SIZE) "\n\t"			\
-	_ASM_ALIGN "\n\t"					\
-	".long 1b - . \n\t"					\
-	".long " label " - . \n\t"				\
-	_ASM_PTR " " key " - . \n\t"				\
+#define JUMP_TABLE_ENTRY(key, label)			\
+	".pushsection __jump_table,  \"aw\" \n\t"	\
+	_ASM_ALIGN "\n\t"				\
+	ANNOTATE_DATA_SPECIAL				\
+	".long 1b - . \n\t"				\
+	".long " label " - . \n\t"			\
+	_ASM_PTR " " key " - . \n\t"			\
 	".popsection \n\t"
 
 /* This macro is also expanded on the Rust side. */
diff --git a/arch/x86/include/asm/static_call.h b/arch/x86/include/asm/static_call.h
index e03ad9bbbf59d..41502bd2afd64 100644
--- a/arch/x86/include/asm/static_call.h
+++ b/arch/x86/include/asm/static_call.h
@@ -58,8 +58,7 @@
 	ARCH_DEFINE_STATIC_CALL_TRAMP(name, __static_call_return0)
 
 #define ARCH_ADD_TRAMP_KEY(name)					\
-	asm(".pushsection .static_call_tramp_key, \"aM\", @progbits, "	\
-	    __stringify(STATIC_CALL_TRAMP_KEY_SIZE) "\n"		\
+	asm(".pushsection .static_call_tramp_key, \"a\"		\n"	\
 	    ".long " STATIC_CALL_TRAMP_STR(name) " - .		\n"	\
 	    ".long " STATIC_CALL_KEY_STR(name) " - .		\n"	\
 	    ".popsection					\n")
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 0586d237b8866..32ba599a51f88 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -124,7 +124,4 @@ static void __used common(void)
 	OFFSET(ARIA_CTX_rounds, aria_ctx, rounds);
 #endif
 
-	BLANK();
-	DEFINE(ALT_INSTR_SIZE,	 sizeof(struct alt_instr));
-	DEFINE(EXTABLE_SIZE,	 sizeof(struct exception_table_entry));
 }
diff --git a/arch/x86/um/shared/sysdep/kernel-offsets.h b/arch/x86/um/shared/sysdep/kernel-offsets.h
index 8215a0200ddd9..6fd1ed4003992 100644
--- a/arch/x86/um/shared/sysdep/kernel-offsets.h
+++ b/arch/x86/um/shared/sysdep/kernel-offsets.h
@@ -1,5 +1,4 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#define COMPILE_OFFSETS
 #include <linux/stddef.h>
 #include <linux/sched.h>
 #include <linux/elf.h>
@@ -8,7 +7,6 @@
 #include <linux/audit.h>
 #include <asm/mman.h>
 #include <asm/seccomp.h>
-#include <asm/extable.h>
 
 /* workaround for a warning with -Wmissing-prototypes */
 void foo(void);
diff --git a/include/linux/annotate.h b/include/linux/annotate.h
new file mode 100644
index 0000000000000..7c10d34d198cf
--- /dev/null
+++ b/include/linux/annotate.h
@@ -0,0 +1,134 @@
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
+#define __ASM_ANNOTATE(section, label, type)				\
+	".pushsection " section ",\"M\", @progbits, 8\n\t"		\
+	".long " __stringify(label) " - .\n\t"				\
+	".long " __stringify(type) "\n\t"				\
+	".popsection\n\t"
+
+#define ASM_ANNOTATE_LABEL(label, type)					\
+	__ASM_ANNOTATE(".discard.annotate_insn", label, type)
+
+#define ASM_ANNOTATE(type)						\
+	"911:\n\t"							\
+	ASM_ANNOTATE_LABEL(911b, type)
+
+#define ASM_ANNOTATE_DATA(type)						\
+	"912:\n\t"							\
+	__ASM_ANNOTATE(".discard.annotate_data", 912b, type)
+
+#else /* __ASSEMBLY__ */
+
+.macro __ANNOTATE section, type
+.Lhere_\@:
+	.pushsection \section, "M", @progbits, 8
+	.long	.Lhere_\@ - .
+	.long	\type
+	.popsection
+.endm
+
+.macro ANNOTATE type
+	__ANNOTATE ".discard.annotate_insn", \type
+.endm
+
+.macro ANNOTATE_DATA type
+	__ANNOTATE ".discard.annotate_data", \type
+.endm
+
+#endif /* __ASSEMBLY__ */
+
+#else /* !CONFIG_OBJTOOL */
+#ifndef __ASSEMBLY__
+#define ASM_ANNOTATE_LABEL(label, type) ""
+#define ASM_ANNOTATE(type)
+#define ASM_ANNOTATE_DATA(type)
+#else /* __ASSEMBLY__ */
+.macro ANNOTATE type
+.endm
+.macro ANNOTATE_DATA type
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
+#define ANNOTATE_NOENDBR_SYM(sym)	asm(ASM_ANNOTATE_LABEL(sym, ANNOTYPE_NOENDBR))
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
+#define ANNOTATE_INSTR_BEGIN(label)	ASM_ANNOTATE_LABEL(label, ANNOTYPE_INSTR_BEGIN)
+#define ANNOTATE_INSTR_END(label)	ASM_ANNOTATE_LABEL(label, ANNOTYPE_INSTR_END)
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
+#define ANNOTATE_REACHABLE(label)	ASM_ANNOTATE_LABEL(label, ANNOTYPE_REACHABLE)
+/*
+ * This should not be used; it annotates away CFI violations. There are a few
+ * valid use cases like kexec handover to the next kernel image, and there is
+ * no security concern there.
+ *
+ * There are also a few real issues annotated away, like EFI because we can't
+ * control the EFI code.
+ */
+#define ANNOTATE_NOCFI_SYM(sym)		asm(ASM_ANNOTATE_LABEL(sym, ANNOTYPE_NOCFI))
+
+/*
+ * Annotate a special section entry.  This emables livepatch module generation
+ * to find and extract individual special section entries as needed.
+ */
+#define ANNOTATE_DATA_SPECIAL		ASM_ANNOTATE_DATA(ANNOTYPE_DATA_SPECIAL)
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
+#define ANNOTATE_DATA_SPECIAL		ANNOTATE_DATA type=ANNOTYPE_DATA_SPECIAL
+#endif /* __ASSEMBLY__ */
+
+#endif /* _LINUX_ANNOTATE_H */
diff --git a/include/linux/interval_tree.h b/include/linux/interval_tree.h
index 2b8026a399064..9d5791e9f737a 100644
--- a/include/linux/interval_tree.h
+++ b/include/linux/interval_tree.h
@@ -19,6 +19,10 @@ extern void
 interval_tree_remove(struct interval_tree_node *node,
 		     struct rb_root_cached *root);
 
+extern struct interval_tree_node *
+interval_tree_subtree_search(struct interval_tree_node *node,
+			     unsigned long start, unsigned long last);
+
 extern struct interval_tree_node *
 interval_tree_iter_first(struct rb_root_cached *root,
 			 unsigned long start, unsigned long last);
diff --git a/include/linux/interval_tree_generic.h b/include/linux/interval_tree_generic.h
index 1b400f26f63d6..c5a2fed49eb0d 100644
--- a/include/linux/interval_tree_generic.h
+++ b/include/linux/interval_tree_generic.h
@@ -77,7 +77,7 @@ ITSTATIC void ITPREFIX ## _remove(ITSTRUCT *node,			      \
  *   Cond2: start <= ITLAST(node)					      \
  */									      \
 									      \
-static ITSTRUCT *							      \
+ITSTATIC ITSTRUCT *							      \
 ITPREFIX ## _subtree_search(ITSTRUCT *node, ITTYPE start, ITTYPE last)	      \
 {									      \
 	while (true) {							      \
diff --git a/include/linux/livepatch_helpers.h b/include/linux/livepatch_helpers.h
index 337bee91d7daf..99d68d0773fa8 100644
--- a/include/linux/livepatch_helpers.h
+++ b/include/linux/livepatch_helpers.h
@@ -36,8 +36,6 @@
 		__PASTE(__KLP_POST_UNPATCH_PREFIX, KLP_OBJNAME) = func
 
 /*
- * KLP_STATIC_CALL
- *
  * Replace static_call() usage with this macro when create-diff-object
  * recommends it due to the original static call key living in a module.
  *
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec75..69baa9a1e2cb4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3265,6 +3265,8 @@ void vma_interval_tree_insert_after(struct vm_area_struct *node,
 				    struct rb_root_cached *root);
 void vma_interval_tree_remove(struct vm_area_struct *node,
 			      struct rb_root_cached *root);
+struct vm_area_struct *vma_interval_tree_subtree_search(struct vm_area_struct *node,
+				unsigned long start, unsigned long last);
 struct vm_area_struct *vma_interval_tree_iter_first(struct rb_root_cached *root,
 				unsigned long start, unsigned long last);
 struct vm_area_struct *vma_interval_tree_iter_next(struct vm_area_struct *node,
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index b5081aea3b69d..b18ab53561c99 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -2,22 +2,17 @@
 #ifndef _LINUX_OBJTOOL_H
 #define _LINUX_OBJTOOL_H
 
-#ifndef COMPILE_OFFSETS
-#include <generated/bounds.h>
-#endif
-
 #include <linux/objtool_types.h>
+#include <linux/annotate.h>
 
 #ifdef CONFIG_OBJTOOL
 
-#include <asm/asm.h>
-
 #ifndef __ASSEMBLY__
 
 #define UNWIND_HINT(type, sp_reg, sp_offset, signal)		\
 	"987: \n\t"						\
-	".pushsection .discard.unwind_hints, \"M\", @progbits, "\
-		      __stringify(UNWIND_HINT_SIZE) "\n\t"	\
+	".pushsection .discard.unwind_hints\n\t"		\
+	ANNOTATE_DATA_SPECIAL					\
 	/* struct unwind_hint */				\
 	".long 987b - .\n\t"					\
 	".short " __stringify(sp_offset) "\n\t"			\
@@ -58,16 +53,6 @@
 
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
@@ -93,7 +78,8 @@
  */
 .macro UNWIND_HINT type:req sp_reg=0 sp_offset=0 signal=0
 .Lhere_\@:
-	.pushsection .discard.unwind_hints, "M", @progbits, UNWIND_HINT_SIZE
+	.pushsection .discard.unwind_hints
+		ANNOTATE_DATA_SPECIAL
 		/* struct unwind_hint */
 		.long .Lhere_\@ - .
 		.short \sp_offset
@@ -116,14 +102,6 @@
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
@@ -133,84 +111,15 @@
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
diff --git a/include/linux/static_call.h b/include/linux/static_call.h
index 5210612817f2e..78a77a4ae0ea8 100644
--- a/include/linux/static_call.h
+++ b/include/linux/static_call.h
@@ -172,6 +172,12 @@ struct static_call_mod {
 	struct static_call_site *sites;
 };
 
+/* For finding the key associated with a trampoline */
+struct static_call_tramp_key {
+	s32 tramp;
+	s32 key;
+};
+
 extern void __static_call_update(struct static_call_key *key, void *tramp, void *func);
 extern int static_call_mod_init(struct module *mod);
 extern int static_call_text_reserved(void *start, void *end);
diff --git a/include/linux/static_call_types.h b/include/linux/static_call_types.h
index eb772df625d4e..5a00b8b2cf9fc 100644
--- a/include/linux/static_call_types.h
+++ b/include/linux/static_call_types.h
@@ -34,12 +34,6 @@ struct static_call_site {
 	s32 key;
 };
 
-/* For finding the key associated with a trampoline */
-struct static_call_tramp_key {
-	s32 tramp;
-	s32 key;
-};
-
 #define DECLARE_STATIC_CALL(name, func)					\
 	extern struct static_call_key STATIC_CALL_KEY(name);		\
 	extern typeof(func) STATIC_CALL_TRAMP(name);
diff --git a/kernel/bounds.c b/kernel/bounds.c
index f9bc13727721e..29b2cd00df2cc 100644
--- a/kernel/bounds.c
+++ b/kernel/bounds.c
@@ -6,16 +6,12 @@
  */
 
 #define __GENERATING_BOUNDS_H
-#define COMPILE_OFFSETS
 /* Include headers that define the enum constants of interest */
 #include <linux/page-flags.h>
 #include <linux/mmzone.h>
 #include <linux/kbuild.h>
 #include <linux/log2.h>
 #include <linux/spinlock_types.h>
-#include <linux/jump_label.h>
-#include <linux/static_call_types.h>
-#include <linux/objtool_types.h>
 
 int main(void)
 {
@@ -32,15 +28,6 @@ int main(void)
 #else
 	DEFINE(LRU_GEN_WIDTH, 0);
 	DEFINE(__LRU_REFS_WIDTH, 0);
-#endif
-#if defined(CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE) && defined(CONFIG_JUMP_LABEL)
-	DEFINE(JUMP_ENTRY_SIZE, sizeof(struct jump_entry));
-#endif
-#ifdef CONFIG_HAVE_STATIC_CALL_INLINE
-	DEFINE(STATIC_CALL_TRAMP_KEY_SIZE, sizeof(struct static_call_tramp_key));
-#endif
-#ifdef CONFIG_OBJTOOL
-	DEFINE(UNWIND_HINT_SIZE, sizeof(struct unwind_hint));
 #endif
 	/* End of constants */
 
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 28a1c08e3b221..f4b33919ec371 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -173,6 +173,7 @@ ifdef CONFIG_OBJTOOL
 
 objtool := $(objtree)/tools/objtool/objtool
 
+objtool-args-$(CONFIG_KLP_BUILD)			+= --checksum
 objtool-args-$(CONFIG_HAVE_JUMP_LABEL_HACK)		+= --hacks=jump_label
 objtool-args-$(CONFIG_HAVE_NOINSTR_HACK)		+= --hacks=noinstr
 objtool-args-$(CONFIG_MITIGATION_CALL_DEPTH_TRACKING)	+= --hacks=skylake
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index 7a888e1ff70f2..542ba462ed3ec 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -28,24 +28,12 @@ ccflags-remove-y := $(CC_FLAGS_CFI)
 .module-common.o: $(srctree)/scripts/module-common.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
-ifdef CONFIG_NEED_MODULE_PERMISSIONS_FIX
-cmd_fix_mod_permissions =						\
-	$(OBJCOPY) --set-section-flags __jump_table=alloc,data		\
-		   --set-section-flags __bug_table=alloc,data $@	\
-		   --set-section-flags .static_call_sites=alloc,data $@
-endif
-
 quiet_cmd_ld_ko_o = LD [M]  $@
       cmd_ld_ko_o =							\
 	$(LD) -r $(KBUILD_LDFLAGS)					\
 		$(KBUILD_LDFLAGS_MODULE) $(LDFLAGS_MODULE)		\
 		-T $(objtree)/scripts/module.lds -o $@ $(filter %.o, $^)
 
-define rule_ld_ko_o
-	$(call cmd_and_savecmd,ld_ko_o)
-	$(call cmd,fix_mod_permissions)
-endef
-
 quiet_cmd_btf_ko = BTF [M] $@
       cmd_btf_ko = 							\
 	if [ ! -f $(objtree)/vmlinux ]; then				\
@@ -58,11 +46,14 @@ quiet_cmd_btf_ko = BTF [M] $@
 # Same as newer-prereqs, but allows to exclude specified extra dependencies
 newer_prereqs_except = $(filter-out $(PHONY) $(1),$?)
 
-if_changed_rule_except = $(if $(call newer_prereqs_except,$(2))$(cmd-check),$(rule_$(1)),@:)
+# Same as if_changed, but allows to exclude specified extra dependencies
+if_changed_except = $(if $(call newer_prereqs_except,$(2))$(cmd-check),      \
+	$(cmd);                                                              \
+	printf '%s\n' 'savedcmd_$@ := $(make-cmd)' > $(dot-target).cmd, @:)
 
 # Re-generate module BTFs if either module's .ko or vmlinux changed
 %.ko: %.o %.mod.o .module-common.o $(objtree)/scripts/module.lds $(and $(CONFIG_DEBUG_INFO_BTF_MODULES),$(KBUILD_BUILTIN),$(objtree)/vmlinux) FORCE
-	+$(call if_changed_rule_except,ld_ko_o,$(objtree)/vmlinux)
+	+$(call if_changed_except,ld_ko_o,$(objtree)/vmlinux)
 ifdef CONFIG_DEBUG_INFO_BTF_MODULES
 	+$(if $(newer-prereqs),$(call cmd,btf_ko))
 endif
diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index e47056f75475e..881e052e7faef 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -489,11 +489,8 @@ clean_kernel() {
 
 build_kernel() {
 	local log="$TMP_DIR/build.log"
-	local objtool_args=()
 	local cmd=()
 
-	objtool_args=("--checksum")
-
 	cmd=("make")
 
 	# When a patch to a kernel module references a newly created unexported
@@ -516,7 +513,6 @@ build_kernel() {
 	cmd+=("$VERBOSE")
 	cmd+=("-j$JOBS")
 	cmd+=("KCFLAGS=-ffunction-sections -fdata-sections")
-	cmd+=("OBJTOOL_ARGS=${objtool_args[*]}")
 	cmd+=("vmlinux")
 	cmd+=("modules")
 
@@ -794,7 +790,7 @@ process_args "$@"
 do_init
 
 if (( SHORT_CIRCUIT <= 1 )); then
-	status "Validating patches"
+	status "Validating patch(es)"
 	validate_patches
 	status "Building original kernel"
 	clean_kernel
@@ -804,7 +800,7 @@ if (( SHORT_CIRCUIT <= 1 )); then
 fi
 
 if (( SHORT_CIRCUIT <= 2 )); then
-	status "Fixing patches"
+	status "Fixing patch(es)"
 	fix_patches
 	apply_patches
 	status "Building patched kernel"
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index ef2ffb68f69d1..d3d00e85edf73 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -1,5 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-#define COMPILE_OFFSETS
 #include <linux/kbuild.h>
 #include <linux/mod_devicetable.h>
 
diff --git a/tools/include/linux/interval_tree_generic.h b/tools/include/linux/interval_tree_generic.h
index c0ec9dbdfbaf2..c5a2fed49eb0d 100644
--- a/tools/include/linux/interval_tree_generic.h
+++ b/tools/include/linux/interval_tree_generic.h
@@ -104,12 +104,8 @@ ITPREFIX ## _subtree_search(ITSTRUCT *node, ITTYPE start, ITTYPE last)	      \
 		if (ITSTART(node) <= last) {		/* Cond1 */	      \
 			if (start <= ITLAST(node))	/* Cond2 */	      \
 				return node;	/* node is leftmost match */  \
-			if (node->ITRB.rb_right) {			      \
-				node = rb_entry(node->ITRB.rb_right,	      \
-						ITSTRUCT, ITRB);	      \
-				if (start <= node->ITSUBTREE)		      \
-					continue;			      \
-			}						      \
+			node = rb_entry(node->ITRB.rb_right, ITSTRUCT, ITRB); \
+			continue;					      \
 		}							      \
 		return NULL;	/* No match */				      \
 	}								      \
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
diff --git a/tools/include/linux/static_call_types.h b/tools/include/linux/static_call_types.h
index eb772df625d4e..5a00b8b2cf9fc 100644
--- a/tools/include/linux/static_call_types.h
+++ b/tools/include/linux/static_call_types.h
@@ -34,12 +34,6 @@ struct static_call_site {
 	s32 key;
 };
 
-/* For finding the key associated with a trampoline */
-struct static_call_tramp_key {
-	s32 tramp;
-	s32 key;
-};
-
 #define DECLARE_STATIC_CALL(name, func)					\
 	extern struct static_call_key STATIC_CALL_KEY(name);		\
 	extern typeof(func) STATIC_CALL_TRAMP(name);
diff --git a/tools/objtool/arch/loongarch/orc.c b/tools/objtool/arch/loongarch/orc.c
index b58c5ff443c92..ffd3a3c858ae7 100644
--- a/tools/objtool/arch/loongarch/orc.c
+++ b/tools/objtool/arch/loongarch/orc.c
@@ -5,7 +5,6 @@
 #include <objtool/check.h>
 #include <objtool/orc.h>
 #include <objtool/warn.h>
-#include <objtool/endianness.h>
 
 int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi, struct instruction *insn)
 {
diff --git a/tools/objtool/arch/powerpc/decode.c b/tools/objtool/arch/powerpc/decode.c
index d4cb02120a6bd..3a9b748216edc 100644
--- a/tools/objtool/arch/powerpc/decode.c
+++ b/tools/objtool/arch/powerpc/decode.c
@@ -7,7 +7,6 @@
 #include <objtool/arch.h>
 #include <objtool/warn.h>
 #include <objtool/builtin.h>
-#include <objtool/endianness.h>
 
 int arch_ftrace_match(const char *name)
 {
diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index 6f3aa117027a6..5c72beeaa3a71 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -19,7 +19,6 @@
 #include <objtool/elf.h>
 #include <objtool/arch.h>
 #include <objtool/warn.h>
-#include <objtool/endianness.h>
 #include <objtool/builtin.h>
 #include <arch/elf.h>
 
diff --git a/tools/objtool/arch/x86/orc.c b/tools/objtool/arch/x86/orc.c
index 7176b9ec5b058..735e150ca6b73 100644
--- a/tools/objtool/arch/x86/orc.c
+++ b/tools/objtool/arch/x86/orc.c
@@ -5,7 +5,6 @@
 #include <objtool/check.h>
 #include <objtool/orc.h>
 #include <objtool/warn.h>
-#include <objtool/endianness.h>
 
 int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi, struct instruction *insn)
 {
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index c4e45236a561d..b20b0077449b2 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -74,7 +74,7 @@ static int parse_hacks(const struct option *opt, const char *str, int unset)
 static const struct option check_options[] = {
 	OPT_GROUP("Actions:"),
 	OPT_BOOLEAN(0,		 "checksum", &opts.checksum, "generate per-function checksums"),
-	OPT_BOOLEAN(0  ,	 "cfi", &opts.cfi, "annotate kernel control flow integrity (kCFI) function preambles"),
+	OPT_BOOLEAN(0,		 "cfi", &opts.cfi, "annotate kernel control flow integrity (kCFI) function preambles"),
 	OPT_CALLBACK_OPTARG('h', "hacks", NULL, NULL, "jump_label,noinstr,skylake", "patch toolchain bugs/limitations", parse_hacks),
 	OPT_BOOLEAN('i',	 "ibt", &opts.ibt, "validate and annotate IBT"),
 	OPT_BOOLEAN('m',	 "mcount", &opts.mcount, "annotate mcount/fentry calls for ftrace"),
@@ -162,7 +162,6 @@ static bool opts_valid(void)
 		return false;
 	}
 
-
 #ifndef BUILD_KLP
 	if (opts.checksum) {
 		ERROR("--checksum not supported; install xxhash-devel and recompile");
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 2f0c86ba14a5c..ba591a325d52e 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -15,8 +15,8 @@
 #include <objtool/check.h>
 #include <objtool/special.h>
 #include <objtool/warn.h>
-#include <objtool/endianness.h>
 #include <objtool/checksum.h>
+#include <objtool/util.h>
 
 #include <linux/objtool_types.h>
 #include <linux/hashtable.h>
@@ -660,15 +660,8 @@ static int create_static_call_sections(struct objtool_file *file)
 	if (!sec)
 		return -1;
 
-	/*
-	 * Set SHF_MERGE to prevent tooling from stripping entsize.
-	 *
-	 * SHF_WRITE would also get set here to allow modules to modify the low
-	 * bits of static_call_site::key, but the LLVM linker doesn't allow
-	 * SHF_MERGE+SHF_WRITE for whatever reason.  That gets fixed up by the
-	 * makefiles with CONFIG_NEED_MODULE_PERMISSIONS_FIX.
-	 */
-	sec->sh.sh_flags |= SHF_MERGE;
+	/* Allow modules to modify the low bits of static_call_site::key */
+	sec->sh.sh_flags |= SHF_WRITE;
 
 	idx = 0;
 	list_for_each_entry(insn, &file->static_call_list, call_node) {
@@ -1003,10 +996,10 @@ static int create_sym_checksum_section(struct objtool_file *file)
 	struct sym_checksum *checksum;
 	size_t entsize = sizeof(struct sym_checksum);
 
-	sec = find_section_by_name(file->elf, SYM_CHECKSUM_SEC);
+	sec = find_section_by_name(file->elf, ".discard.sym_checksum");
 	if (sec) {
 		if (!opts.dryrun)
-			WARN("file already has " SYM_CHECKSUM_SEC " section, skipping");
+			WARN("file already has .discard.sym_checksum section, skipping");
 
 		return 0;
 	}
@@ -2349,9 +2342,7 @@ static int read_annotate(struct objtool_file *file,
 	}
 
 	for_each_reloc(sec->rsec, reloc) {
-		type = *(u32 *)(sec->data->d_buf + (reloc_idx(reloc) * sec->sh.sh_entsize) + 4);
-		type = bswap_if_needed(file->elf, type);
-
+		type = annotype(file->elf, sec, reloc);
 		offset = reloc->sym->offset + reloc_addend(reloc);
 		insn = find_insn(file, reloc->sym->sec, offset);
 
@@ -4283,48 +4274,82 @@ static bool ignore_unreachable_insn(struct objtool_file *file, struct instructio
 	return false;
 }
 
-static int add_prefix_symbol(struct objtool_file *file, struct symbol *func)
+/*
+ * For FineIBT or kCFI, a certain number of bytes preceding the function may be
+ * NOPs.  Those NOPs may be rewritten at runtime and executed, so give them a
+ * proper function name: __pfx_<func>.
+ *
+ * The NOPs may not exist for the following cases:
+ *
+ *   - compiler cloned functions (*.cold, *.part0, etc)
+ *   - asm functions created with inline asm or without SYM_FUNC_START()
+ *
+ * Also, the function may already have a prefix from a previous objtool run
+ * (livepatch extracted functions, or manually running objtool multiple times).
+ *
+ * So return 0 if the NOPs are missing or the function already has a prefix
+ * symbol.
+ */
+static int create_prefix_symbol(struct objtool_file *file, struct symbol *func)
 {
 	struct instruction *insn, *prev;
+	char name[SYM_NAME_LEN];
 	struct cfi_state *cfi;
 
-	insn = find_insn(file, func->sec, func->offset);
-	if (!insn)
+	if (!is_func_sym(func) || is_prefix_func(func) ||
+	    func->cold || func->static_call_tramp)
+		return 0;
+
+	if ((strlen(func->name) + sizeof("__pfx_") > SYM_NAME_LEN)) {
+		WARN("%s: symbol name too long, can't create __pfx_ symbol",
+		      func->name);
+		return 0;
+	}
+
+	if (snprintf_check(name, SYM_NAME_LEN, "__pfx_%s", func->name))
 		return -1;
 
+	if (file->klp) {
+		struct symbol *pfx;
+
+		pfx = find_symbol_by_offset(func->sec, func->offset - opts.prefix);
+		if (pfx && is_prefix_func(pfx) && !strcmp(pfx->name, name))
+			return 0;
+	}
+
+	insn = find_insn(file, func->sec, func->offset);
+	if (!insn) {
+		WARN("%s: can't find starting instruction", func->name);
+		return -1;
+	}
+
 	for (prev = prev_insn_same_sec(file, insn);
 	     prev;
 	     prev = prev_insn_same_sec(file, prev)) {
-		struct symbol *sym_pfx;
 		u64 offset;
 
 		if (prev->type != INSN_NOP)
-			return -1;
+			return 0;
 
 		offset = func->offset - prev->offset;
 
 		if (offset > opts.prefix)
-			return -1;
+			return 0;
 
 		if (offset < opts.prefix)
 			continue;
 
-		/*
-		 * Ignore attempts to make duplicate symbols in livepatch
-		 * modules.  They've already extracted the prefix symbols
-		 * except for the newly compiled init.c.
-		 */
-		sym_pfx = elf_create_prefix_symbol(file->elf, func, opts.prefix);
-		if (!sym_pfx && !file->klp) {
-			WARN("duplicate prefix symbol for %s\n", func->name);
+		if (!elf_create_symbol(file->elf, name, func->sec,
+				       GELF_ST_BIND(func->sym.st_info),
+				       GELF_ST_TYPE(func->sym.st_info),
+				       prev->offset, opts.prefix))
 			return -1;
-		}
 
 		break;
 	}
 
 	if (!prev)
-		return -1;
+		return 0;
 
 	if (!insn->cfi) {
 		/*
@@ -4342,7 +4367,7 @@ static int add_prefix_symbol(struct objtool_file *file, struct symbol *func)
 	return 0;
 }
 
-static int add_prefix_symbols(struct objtool_file *file)
+static int create_prefix_symbols(struct objtool_file *file)
 {
 	struct section *sec;
 	struct symbol *func;
@@ -4352,14 +4377,8 @@ static int add_prefix_symbols(struct objtool_file *file)
 			continue;
 
 		sec_for_each_sym(sec, func) {
-			if (!is_func_sym(func))
-				continue;
-
-			/*
-			 * Ignore this error on purpose, there are valid
-			 * reasons for this to fail.
-			 */
-			add_prefix_symbol(file, func);
+			if (create_prefix_symbol(file, func))
+				return -1;
 		}
 	}
 
@@ -4987,7 +5006,7 @@ int check(struct objtool_file *file)
 	}
 
 	if (opts.prefix) {
-		ret = add_prefix_symbols(file);
+		ret = create_prefix_symbols(file);
 		if (ret)
 			goto out;
 	}
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 2551a5727949f..5feeefc7fc8f8 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -945,32 +945,6 @@ struct symbol *elf_create_section_symbol(struct elf *elf, struct section *sec)
 	return sym;
 }
 
-struct symbol *
-elf_create_prefix_symbol(struct elf *elf, struct symbol *orig, size_t size)
-{
-	size_t namelen = strlen(orig->name) + sizeof("__pfx_");
-	char name[SYM_NAME_LEN];
-	unsigned long offset;
-	struct symbol *sym;
-
-	snprintf(name, namelen, "__pfx_%s", orig->name);
-
-	sym = orig;
-	offset = orig->sym.st_value - size;
-
-	sec_for_each_sym_continue_reverse(orig->sec, sym) {
-		if (sym->offset < offset)
-			break;
-		if (sym->offset == offset && !strcmp(sym->name, name))
-			return NULL;
-	}
-
-	return elf_create_symbol(elf, name, orig->sec,
-				 GELF_ST_BIND(orig->sym.st_info),
-				 GELF_ST_TYPE(orig->sym.st_info),
-				 offset, size);
-}
-
 struct reloc *elf_init_reloc(struct elf *elf, struct section *rsec,
 			     unsigned int reloc_idx, unsigned long offset,
 			     struct symbol *sym, s64 addend, unsigned int type)
@@ -1075,8 +1049,10 @@ static int read_relocs(struct elf *elf)
 
 		rsec->base->rsec = rsec;
 
-		rsec->nr_alloc_relocs = sec_num_entries(rsec);
-		rsec->relocs = calloc(rsec->nr_alloc_relocs, sizeof(*reloc));
+		/* nr_alloc_relocs=0: libelf owns d_buf */
+		rsec->nr_alloc_relocs = 0;
+
+		rsec->relocs = calloc(sec_num_entries(rsec), sizeof(*reloc));
 		if (!rsec->relocs) {
 			ERROR_GLIBC("calloc");
 			return -1;
@@ -1496,15 +1472,32 @@ static int elf_alloc_reloc(struct elf *elf, struct section *rsec)
 	nr_alloc = MAX(64, ALIGN_UP_POW2(nr_relocs_new));
 	if (nr_alloc <= rsec->nr_alloc_relocs)
 		return 0;
-	rsec->nr_alloc_relocs = nr_alloc;
 
-	rsec->data->d_buf = realloc(rsec->data->d_buf,
-				    nr_alloc * elf_rela_size(elf));
-	if (!rsec->data->d_buf) {
-		ERROR_GLIBC("realloc");
-		return -1;
+	if (rsec->data->d_buf && !rsec->nr_alloc_relocs) {
+		void *orig_buf = rsec->data->d_buf;
+
+		/*
+		 * The original d_buf is owned by libelf so it can't be
+		 * realloced.
+		 */
+		rsec->data->d_buf = malloc(nr_alloc * elf_rela_size(elf));
+		if (!rsec->data->d_buf) {
+			ERROR_GLIBC("malloc");
+			return -1;
+		}
+		memcpy(rsec->data->d_buf, orig_buf,
+		       nr_relocs_old * elf_rela_size(elf));
+	} else {
+		rsec->data->d_buf = realloc(rsec->data->d_buf,
+					    nr_alloc * elf_rela_size(elf));
+		if (!rsec->data->d_buf) {
+			ERROR_GLIBC("realloc");
+			return -1;
+		}
 	}
 
+	rsec->nr_alloc_relocs = nr_alloc;
+
 	old_relocs = rsec->relocs;
 	new_relocs = calloc(nr_alloc, sizeof(struct reloc));
 	if (!new_relocs) {
@@ -1623,6 +1616,8 @@ struct reloc *elf_create_reloc(struct elf *elf, struct section *sec,
 	if (elf_alloc_reloc(elf, rsec))
 		return NULL;
 
+	mark_sec_changed(elf, rsec, true);
+
 	return elf_init_reloc(elf, rsec, sec_num_entries(rsec) - 1, offset, sym,
 			      addend, type);
 }
diff --git a/tools/objtool/include/objtool/builtin.h b/tools/objtool/include/objtool/builtin.h
index 8a0d42aa4d858..bb0b25eb08ba4 100644
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -10,6 +10,7 @@
 struct opts {
 	/* actions: */
 	bool cfi;
+	bool checksum;
 	bool dump_orc;
 	bool hack_jump_label;
 	bool hack_noinstr;
@@ -25,7 +26,6 @@ struct opts {
 	bool sls;
 	bool stackval;
 	bool static_call;
-	bool checksum;
 	bool uaccess;
 	int prefix;
 
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 64e75ade01c90..21d8b825fd8f0 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -14,12 +14,15 @@
 #include <linux/rbtree.h>
 #include <linux/jhash.h>
 
+#include <objtool/endianness.h>
 #include <objtool/checksum_types.h>
 #include <arch/elf.h>
 
 #define SEC_NAME_LEN		1024
 #define SYM_NAME_LEN		512
 
+#define bswap_if_needed(elf, val) __bswap_if_needed(&elf->ehdr, val)
+
 #ifdef LIBELF_USE_DEPRECATED
 # define elf_getshdrnum    elf_getshnum
 # define elf_getshdrstrndx elf_getshstrndx
@@ -146,8 +149,6 @@ struct symbol *elf_create_symbol(struct elf *elf, const char *name,
 				 unsigned int type, unsigned long offset,
 				 size_t size);
 struct symbol *elf_create_section_symbol(struct elf *elf, struct section *sec);
-struct symbol *elf_create_prefix_symbol(struct elf *elf, struct symbol *orig,
-					size_t size);
 
 void *elf_add_data(struct elf *elf, struct section *sec, const void *data,
 		   size_t size);
@@ -274,7 +275,7 @@ static inline bool is_local_sym(struct symbol *sym)
 
 static inline bool is_prefix_func(struct symbol *sym)
 {
-	return is_func_sym(sym) && sym->prefix;
+	return sym->prefix;
 }
 
 static inline bool is_reloc_sec(struct section *sec)
@@ -414,6 +415,15 @@ static inline void set_reloc_type(struct elf *elf, struct reloc *reloc, unsigned
 	mark_sec_changed(elf, reloc->sec, true);
 }
 
+static inline unsigned int annotype(struct elf *elf, struct section *sec,
+				    struct reloc *reloc)
+{
+	unsigned int type;
+
+	type = *(u32 *)(sec->data->d_buf + (reloc_idx(reloc) * 8) + 4);
+	return bswap_if_needed(elf, type);
+}
+
 #define RELOC_JUMP_TABLE_BIT 1UL
 
 /* Does reloc mark the beginning of a jump table? */
@@ -445,9 +455,6 @@ static inline void set_sym_next_reloc(struct reloc *reloc, struct reloc *next)
 #define sec_for_each_sym(sec, sym)					\
 	list_for_each_entry(sym, &sec->symbol_list, list)
 
-#define sec_for_each_sym_continue_reverse(sec, sym)			\
-	list_for_each_entry_continue_reverse(sym, &sec->symbol_list, list)
-
 #define sec_prev_sym(sym)						\
 	sym->sec && sym->list.prev != &sym->sec->symbol_list ?		\
 	list_prev_entry(sym, list) : NULL
@@ -467,6 +474,10 @@ static inline void set_sym_next_reloc(struct reloc *reloc, struct reloc *next)
 #define for_each_reloc_from(rsec, reloc)				\
 	for (; reloc; reloc = rsec_next_reloc(rsec, reloc))
 
+#define for_each_reloc_continue(rsec, reloc)				\
+	for (reloc = rsec_next_reloc(rsec, reloc); reloc;		\
+	     reloc = rsec_next_reloc(rsec, reloc))
+
 #define sym_for_each_reloc(elf, sym, reloc)				\
 	for (reloc = find_reloc_by_dest_range(elf, sym->sec,		\
 					      sym->offset, sym->len);	\
diff --git a/tools/objtool/include/objtool/endianness.h b/tools/objtool/include/objtool/endianness.h
index 4d2aa9b0fe2fd..aebcd23386685 100644
--- a/tools/objtool/include/objtool/endianness.h
+++ b/tools/objtool/include/objtool/endianness.h
@@ -4,7 +4,6 @@
 
 #include <linux/kernel.h>
 #include <endian.h>
-#include <objtool/elf.h>
 
 /*
  * Does a byte swap if target file endianness doesn't match the host, i.e. cross
@@ -12,16 +11,16 @@
  * To be used for multi-byte values conversion, which are read from / about
  * to be written to a target native endianness ELF file.
  */
-static inline bool need_bswap(struct elf *elf)
+static inline bool need_bswap(GElf_Ehdr *ehdr)
 {
 	return (__BYTE_ORDER == __LITTLE_ENDIAN) ^
-	       (elf->ehdr.e_ident[EI_DATA] == ELFDATA2LSB);
+	       (ehdr->e_ident[EI_DATA] == ELFDATA2LSB);
 }
 
-#define bswap_if_needed(elf, val)					\
+#define __bswap_if_needed(ehdr, val)					\
 ({									\
 	__typeof__(val) __ret;						\
-	bool __need_bswap = need_bswap(elf);				\
+	bool __need_bswap = need_bswap(ehdr);				\
 	switch (sizeof(val)) {						\
 	case 8:								\
 		__ret = __need_bswap ? bswap_64(val) : (val); break;	\
diff --git a/tools/objtool/include/objtool/objtool.h b/tools/objtool/include/objtool/objtool.h
index 731965a742e99..f7051bbe0bcb2 100644
--- a/tools/objtool/include/objtool/objtool.h
+++ b/tools/objtool/include/objtool/objtool.h
@@ -14,8 +14,6 @@
 
 #define __weak __attribute__((weak))
 
-#define SYM_CHECKSUM_SEC ".discard.sym_checksum"
-
 struct pv_state {
 	bool clean;
 	struct list_head targets;
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 15b554b53da63..4d1f9e9977eb9 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -14,6 +14,7 @@
 #include <objtool/util.h>
 #include <arch/special.h>
 
+#include <linux/objtool_types.h>
 #include <linux/livepatch_external.h>
 #include <linux/stringify.h>
 #include <linux/string.h>
@@ -167,15 +168,15 @@ static int read_sym_checksums(struct elf *elf)
 {
 	struct section *sec;
 
-	sec = find_section_by_name(elf, SYM_CHECKSUM_SEC);
+	sec = find_section_by_name(elf, ".discard.sym_checksum");
 	if (!sec) {
-		ERROR("'%s' missing " SYM_CHECKSUM_SEC " section, file not processed by 'objtool --checksum'?",
+		ERROR("'%s' missing .discard.sym_checksum section, file not processed by 'objtool --checksum'?",
 		      elf->name);
 		return -1;
 	}
 
 	if (!sec->rsec) {
-		ERROR("missing reloc section for " SYM_CHECKSUM_SEC);
+		ERROR("missing reloc section for .discard.sym_checksum");
 		return -1;
 	}
 
@@ -297,7 +298,7 @@ static bool is_special_section(struct section *sec)
 
 	static const char * const non_special_discards[] = {
 		".discard.addressable",
-		SYM_CHECKSUM_SEC,
+		".discard.sym_checksum",
 	};
 
 	if (is_text_sec(sec))
@@ -1150,6 +1151,135 @@ static int clone_sym_relocs(struct elfs *e, struct symbol *patched_sym)
 
 }
 
+static int create_fake_symbol(struct elf *elf, struct section *sec,
+			      unsigned long offset, size_t size)
+{
+	char name[SYM_NAME_LEN];
+	unsigned int type;
+	static int ctr;
+	char *c;
+
+	if (snprintf_check(name, SYM_NAME_LEN, "%s_%d", sec->name, ctr++))
+		return -1;
+
+	for (c = name; *c; c++)
+		if (*c == '.')
+			*c = '_';
+
+	/*
+	 * STT_NOTYPE: Prevent objtool from validating .altinstr_replacement
+	 *	       while still allowing objdump to disassemble it.
+	 */
+	type = is_text_sec(sec) ? STT_NOTYPE : STT_OBJECT;
+	return elf_create_symbol(elf, name, sec, STB_LOCAL, type, offset, size) ? 0 : -1;
+}
+
+/*
+ * Special sections (alternatives, etc) are basically arrays of structs.
+ * For all the special sections, create a symbol for each struct entry.  This
+ * is a bit cumbersome, but it makes the extracting of the individual entries
+ * much more straightforward.
+ *
+ * There are three ways to identify the entry sizes for a special section:
+ *
+ * 1) ELF section header sh_entsize: Ideally this would be used almost
+ *    everywhere.  But unfortunately the toolchains make it difficult.  The
+ *    assembler .[push]section directive syntax only takes entsize when
+ *    combined with SHF_MERGE.  But Clang disallows combining SHF_MERGE with
+ *    SHF_WRITE.  And some special sections do need to be writable.
+ *
+ *    Another place this wouldn't work is .altinstr_replacement, whose entries
+ *    don't have a fixed size.
+ *
+ * 2) ANNOTATE_DATA_SPECIAL: This is a lightweight objtool annotation which
+ *    points to the beginning of each entry.  The size of the entry is then
+ *    inferred by the location of the subsequent annotation (or end of
+ *    section).
+ *
+ * 3) Simple array of pointers: If the special section is just a basic array of
+ *    pointers, the entry size can be inferred by the number of relocations.
+ *    No annotations needed.
+ *
+ * Note I also tried to create per-entry symbols at the time of creation, in
+ * the original [inline] asm.  Unfortunately, creating uniquely named symbols
+ * is trickier than one might think, especially with Clang inline asm.  I
+ * eventually just gave up trying to make that work, in favor of using
+ * ANNOTATE_DATA_SPECIAL and creating the symbols here after the fact.
+ */
+static int create_fake_symbols(struct elf *elf)
+{
+	struct section *sec;
+	struct reloc *reloc;
+
+	/*
+	 * 1) Make symbols for all the ANNOTATE_DATA_SPECIAL entries:
+	 */
+
+	sec = find_section_by_name(elf, ".discard.annotate_data");
+	if (!sec || !sec->rsec)
+		return 0;
+
+	for_each_reloc(sec->rsec, reloc) {
+		unsigned long offset, size;
+		struct reloc *next_reloc;
+
+		if (annotype(elf, sec, reloc) != ANNOTYPE_DATA_SPECIAL)
+			continue;
+
+		offset = reloc_addend(reloc);
+
+		size = 0;
+		next_reloc = reloc;
+		for_each_reloc_continue(sec->rsec, next_reloc) {
+			if (annotype(elf, sec, next_reloc) != ANNOTYPE_DATA_SPECIAL ||
+			    next_reloc->sym->sec != reloc->sym->sec)
+				continue;
+
+			size = reloc_addend(next_reloc) - offset;
+			break;
+		}
+
+		if (!size)
+			size = sec_size(reloc->sym->sec) - offset;
+
+		if (create_fake_symbol(elf, reloc->sym->sec, offset, size))
+			return -1;
+	}
+
+	/*
+	 * 2) Make symbols for sh_entsize, and simple arrays of pointers:
+	 */
+
+	for_each_sec(elf, sec) {
+		unsigned int entry_size;
+		unsigned long offset;
+
+		if (!is_special_section(sec) || find_symbol_by_offset(sec, 0))
+			continue;
+
+		if (!sec->rsec) {
+			ERROR("%s: missing special section relocations", sec->name);
+			return -1;
+		}
+
+		entry_size = sec->sh.sh_entsize;
+		if (!entry_size) {
+			entry_size = arch_reloc_size(sec->rsec->relocs);
+			if (sec_size(sec) != entry_size * sec_num_entries(sec->rsec)) {
+				ERROR("%s: missing special section entsize or annotations", sec->name);
+				return -1;
+			}
+		}
+
+		for (offset = 0; offset < sec_size(sec); offset += entry_size) {
+			if (create_fake_symbol(elf, sec, offset, entry_size))
+				return -1;
+		}
+	}
+
+	return 0;
+}
+
 /* Keep a special section entry if it references an included function */
 static bool should_keep_special_sym(struct elf *elf, struct symbol *sym)
 {
@@ -1260,99 +1390,12 @@ static int validate_special_section_klp_reloc(struct elfs *e, struct symbol *sym
 	return ret;
 }
 
-static int special_section_entry_size(struct section *sec)
-{
-	unsigned int reloc_size;
-
-	if ((sec->sh.sh_flags & SHF_MERGE) && sec->sh.sh_entsize)
-		return sec->sh.sh_entsize;
-
-	if (!sec->rsec)
-		return 0;
-
-	/* Check for a simple array of pointers */
-	reloc_size = arch_reloc_size(sec->rsec->relocs);
-	if (sec_size(sec) == reloc_size * sec_num_entries(sec->rsec))
-		return reloc_size;
-
-	return 0;
-}
-
-static int create_fake_symbol(struct elf *elf, struct section *sec,
-			      unsigned long offset, size_t size)
-{
-	char name[SYM_NAME_LEN];
-	unsigned int type;
-	static int ctr;
-	char *c;
-
-	if (snprintf_check(name, SYM_NAME_LEN, "__DISCARD_%s_%d", sec->name, ctr++))
-		return -1;
-
-	for (c = name; *c; c++)
-		if (*c == '.')
-			*c = '_';
-
-	/*
-	 * STT_NOTYPE: Prevent objtool from validating .altinstr_replacement
-	 *	       while still allowing objdump to disassemble it.
-	 */
-	type = is_text_sec(sec) ? STT_NOTYPE : STT_OBJECT;
-	if (!elf_create_symbol(elf, name, sec, STB_LOCAL, type, offset, size))
-		return -1;
-
-	return 0;
-}
-
 static int clone_special_section(struct elfs *e, struct section *patched_sec)
 {
 	struct symbol *patched_sym;
-	unsigned int entry_size;
-	unsigned long offset;
-
-	entry_size = special_section_entry_size(patched_sec);
-	if (!entry_size) {
-		/*
-		 * Any special section more complex than a simple array of
-		 * pointers must have its entry size specified in sh_entsize
-		 * (and the SHF_MERGE flag set so the linker preserves it).
-		 *
-		 * Clang older than version 20 doesn't properly preserve
-		 * sh_entsize and will error out here.
-		 */
-		ERROR("%s: buggy linker and/or missing sh_entsize", patched_sec->name);
-		return -1;
-	}
 
 	/*
-	 * In the patched object, create a fake symbol for each special section
-	 * entry.  This makes the below extracting of entries much easier.
-	 */
-	for (offset = 0; offset < sec_size(patched_sec); offset += entry_size) {
-		if (create_fake_symbol(e->patched, patched_sec, offset, entry_size))
-			return -1;
-
-		/* Symbolize alternative replacements: */
-		if (!strcmp(patched_sec->name, ".altinstructions")) {
-			struct reloc *reloc;
-			unsigned char size;
-
-			reloc = find_reloc_by_dest(e->patched, patched_sec, offset + ALT_NEW_OFFSET);
-			if (!reloc) {
-				ERROR_FUNC(patched_sec, offset + ALT_NEW_OFFSET, "can't find new reloc");
-				return -1;
-			}
-
-			size = *(unsigned char *)(patched_sec->data->d_buf + offset + ALT_NEW_LEN_OFFSET);
-
-			if (create_fake_symbol(e->patched, reloc->sym->sec,
-					       reloc->sym->offset + reloc_addend(reloc), size))
-				return -1;
-		}
-	}
-
-	/*
-	 * Extract all special section entries (and their dependencies) which
+	 * Extract all special section symbols (and their dependencies) which
 	 * reference included functions.
 	 */
 	sec_for_each_sym(patched_sec, patched_sym) {
@@ -1382,6 +1425,9 @@ static int clone_special_sections(struct elfs *e)
 {
 	struct section *patched_sec;
 
+	if (create_fake_symbols(e->patched))
+		return -1;
+
 	for_each_sec(e->patched, patched_sec) {
 		if (is_special_section(patched_sec)) {
 			if (clone_special_section(e, patched_sec))
diff --git a/tools/objtool/orc_dump.c b/tools/objtool/orc_dump.c
index 1dd9fc18fe624..5a979f52425ab 100644
--- a/tools/objtool/orc_dump.c
+++ b/tools/objtool/orc_dump.c
@@ -8,7 +8,6 @@
 #include <objtool/objtool.h>
 #include <objtool/orc.h>
 #include <objtool/warn.h>
-#include <objtool/endianness.h>
 
 int orc_dump(const char *filename)
 {
diff --git a/tools/objtool/orc_gen.c b/tools/objtool/orc_gen.c
index 9d380abc2ed35..1045e1380ffde 100644
--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
@@ -12,7 +12,6 @@
 #include <objtool/check.h>
 #include <objtool/orc.h>
 #include <objtool/warn.h>
-#include <objtool/endianness.h>
 
 struct orc_list_entry {
 	struct list_head list;
diff --git a/tools/objtool/special.c b/tools/objtool/special.c
index fc2cf8dba1c03..e262af9171436 100644
--- a/tools/objtool/special.c
+++ b/tools/objtool/special.c
@@ -15,7 +15,6 @@
 #include <objtool/builtin.h>
 #include <objtool/special.h>
 #include <objtool/warn.h>
-#include <objtool/endianness.h>
 
 struct special_entry {
 	const char *sec;
diff --git a/tools/objtool/sync-check.sh b/tools/objtool/sync-check.sh
index e1d98fb031575..e38167ca56a95 100755
--- a/tools/objtool/sync-check.sh
+++ b/tools/objtool/sync-check.sh
@@ -16,6 +16,7 @@ arch/x86/include/asm/orc_types.h
 arch/x86/include/asm/emulate_prefix.h
 arch/x86/lib/x86-opcode-map.txt
 arch/x86/tools/gen-insn-attr-x86.awk
+include/linux/interval_tree_generic.h
 include/linux/livepatch_external.h
 include/linux/static_call_types.h
 "

