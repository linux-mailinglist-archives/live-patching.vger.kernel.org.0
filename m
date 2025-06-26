Return-Path: <live-patching+bounces-1531-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82C90AEAB03
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 01:56:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E84B07B2BE1
	for <lists+live-patching@lfdr.de>; Thu, 26 Jun 2025 23:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AE90227E80;
	Thu, 26 Jun 2025 23:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X8inAFdL"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44DD2264D9;
	Thu, 26 Jun 2025 23:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982171; cv=none; b=l6IibJFzgJz2IHX96EFHs5TrMjpgrgRAhvgGzG6sAeai2llxpYNTeQS5QTlBddZsYXsMD45U/aUyVEHfRC6uR7mnpsHz45eVw3GwmteYIOv5kQozaS4DwYaiZGjE+9aGjnoOryy0N/MTo8fy0vE9WMCFVadc0q+868bYp5qQFQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982171; c=relaxed/simple;
	bh=8yUis0ttC5s/To7QOmC1xQBBCAITvayqTc1UgstYbdc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kQDzFJu67WO/at4NQsklprhYsibLA/cA2cVwdJIK6RbtFdg3PC1M8cqewXKmTOJGRvHHopSI9+dXTyt9aJ37RzeWRf4039XrxusV8NAMg0MJSG6AXSMy80ctTLiHqPlGuJ3JnujmD5ia4MM4bTyg92pRyLRRgUdNtrJUBDIHM8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X8inAFdL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0117CC4CEEB;
	Thu, 26 Jun 2025 23:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982170;
	bh=8yUis0ttC5s/To7QOmC1xQBBCAITvayqTc1UgstYbdc=;
	h=From:To:Cc:Subject:Date:From;
	b=X8inAFdLLKyVup9T8rhn12bVSXBmqzQA97VPASqUCC3RtEqfgTgUk68Nm6cm8EjXW
	 8BwXpBtE4eqX18dLs+w/WZpsA1DP9X6N673xqquwp80JCj380h31JbNLBgZjIQdXpY
	 dsEY5/8FL4WccHonAivfssi5PukqJYfAJmV1qPqKKsm3xzY+bQJzIxa+Fp94pVQgWJ
	 p4hRdDUj8ypBU68voLJYlCWSz3Ls9PAkspRCCmrbG57EVtjDJOGGAtzkmYc4ro08aR
	 ob260buSHuWGC08ky+Xoq8VqqMxGzWLYdsPv/3OgKpkiR/U8VRIzJ4ZHHPJnW2K99J
	 2eUpE1Ir5BkrA==
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
	Dylan Hatch <dylanbhatch@google.com>
Subject: [PATCH v3 00/64] objtool,livepatch: klp-build livepatch module generation
Date: Thu, 26 Jun 2025 16:54:47 -0700
Message-ID: <cover.1750980516.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Changes since v2: https://lore.kernel.org/cover.1725334260.git.jpoimboe@kernel.org

  - Fix bisection issue (Joe)
  - Add CONFIG_KLP_BUILD to prevent powerpc from doing objtool-on-vmlinux (Joe)
  - Use arch_pc_relative_reloc() in arch_insn_adjusted_addend() (Peter)
  - Drop "objtool: Suppress section skipping warnings with --dryrun" (Peter)
  - Resurrect --backup (Peter)
  - Remove 16 byte prefix assumption (Peter, robot)
  - Bump SEC_NAME_LEN to 1024 (Peter)
  - Add sprintf error checking (Peter)
  - Fix brace usage (Peter)
  - Improve buggy linker sh_entsize warning (Peter)
  - Refactor add_jump_destinations() some more to work with ITS retpolines
  - Simplify error handling boilerplate
  - Run "make clean" before original kernel build
  - Fix .cmd file copying for CONFIG_MODVERSIONS (Joe)
  - Add a line to setlocalversion rather than replacing the whole file
  - Fix unset 'found' variable (Joe)
  - Define section entry struct sizes in asm-offset.c and bounds.c (Brian)
  - Fix STACK_FRAME_NON_STANDARD entry size unification (robot)
  - Check for .rodata.*, .bss.* (Joe)
  - Copy import_ns= entries from .modinfo (Joe)
  - Strip signature from 'git format-patch' patches (Joe)
  - Fix add_jump_destinations() (robot)
  - ARCH=um fixes (robot)
  - Fix vmlinux.o/vmlinux sympos mismatch
  - Add klp-build --jobs option
  - Allow .git to be a file (Dylan)
  - Static branch/call fixes (Joe)
  - Disable .printk_index support for now (Joe)
  - Strip .BTF section (Joe)

Josh Poimboeuf (64):
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
  kbuild,x86: Fix special section module permissions
  x86/alternative: Define ELF section entry size for alternatives
  x86/jump_label: Define ELF section entry size for jump labels
  x86/static_call: Define ELF section entry size of static calls
  x86/extable: Define ELF section entry size for exception table
  x86/bug: Define ELF section entry size for bug table
  x86/orc: Define ELF section entry size for unwind hints
  objtool: Unify STACK_FRAME_NON_STANDARD entry sizes
  objtool/klp: Add --checksum option to generate per-function checksums
  objtool/klp: Add --debug-checksum=<funcs> to show per-instruction
    checksums
  objtool/klp: Introduce klp diff subcommand for diffing object files
  objtool/klp: Add --debug option to show cloning decisions
  objtool/klp: Add post-link subcommand to finalize livepatch modules
  objtool: Disallow duplicate prefix symbols
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
 arch/Kconfig                                  |    3 +
 arch/s390/include/asm/nospec-insn.h           |    2 +-
 arch/s390/kernel/vmlinux.lds.S                |    2 +-
 arch/um/include/asm/Kbuild                    |    1 -
 arch/um/include/shared/common-offsets.h       |    3 +
 arch/x86/Kconfig                              |    2 +
 arch/x86/include/asm/alternative.h            |    5 +-
 arch/x86/include/asm/asm.h                    |   22 +-
 arch/x86/include/asm/bug.h                    |   45 +-
 arch/x86/include/asm/jump_label.h             |   17 +-
 arch/x86/include/asm/static_call.h            |    3 +-
 arch/x86/kernel/alternative.c                 |   51 +-
 arch/x86/kernel/asm-offsets.c                 |    3 +
 arch/x86/kernel/kprobes/opt.c                 |    4 -
 arch/x86/kernel/module.c                      |   15 +-
 arch/x86/um/shared/sysdep/kernel-offsets.h    |    2 +
 include/asm-generic/vmlinux.lds.h             |   40 +-
 include/linux/compiler.h                      |    8 +-
 include/linux/elfnote.h                       |   13 +-
 include/linux/init.h                          |    3 +-
 include/linux/livepatch.h                     |   25 +-
 include/linux/livepatch_external.h            |   76 +
 include/linux/livepatch_helpers.h             |   79 +
 include/linux/objtool.h                       |   13 +-
 include/linux/static_call.h                   |    6 -
 include/linux/static_call_types.h             |    6 +
 kernel/bounds.c                               |   13 +
 kernel/livepatch/Kconfig                      |   12 +
 kernel/livepatch/core.c                       |    8 +-
 scripts/Makefile.lib                          |    6 +-
 scripts/Makefile.modfinal                     |   19 +-
 scripts/Makefile.vmlinux_o                    |    2 +-
 scripts/link-vmlinux.sh                       |    3 +-
 scripts/livepatch/fix-patch-lines             |   79 +
 scripts/livepatch/init.c                      |  108 ++
 scripts/livepatch/klp-build                   |  831 ++++++++
 scripts/mod/devicetable-offsets.c             |    1 +
 scripts/mod/modpost.c                         |    5 +
 scripts/module.lds.S                          |   26 +-
 tools/include/linux/interval_tree_generic.h   |    2 +-
 tools/include/linux/livepatch_external.h      |   76 +
 tools/include/linux/static_call_types.h       |    6 +
 tools/include/linux/string.h                  |   14 +
 tools/objtool/Build                           |    4 +-
 tools/objtool/Makefile                        |   48 +-
 tools/objtool/arch/loongarch/decode.c         |    6 +-
 tools/objtool/arch/powerpc/decode.c           |    6 +-
 tools/objtool/arch/x86/decode.c               |   62 +-
 tools/objtool/arch/x86/special.c              |    2 +-
 tools/objtool/builtin-check.c                 |   95 +-
 tools/objtool/builtin-klp.c                   |   53 +
 tools/objtool/check.c                         |  826 ++++----
 tools/objtool/elf.c                           |  765 ++++++--
 tools/objtool/include/objtool/arch.h          |    5 +-
 tools/objtool/include/objtool/builtin.h       |    9 +-
 tools/objtool/include/objtool/check.h         |    6 +-
 tools/objtool/include/objtool/checksum.h      |   43 +
 .../objtool/include/objtool/checksum_types.h  |   25 +
 tools/objtool/include/objtool/elf.h           |  185 +-
 tools/objtool/include/objtool/klp.h           |   35 +
 tools/objtool/include/objtool/objtool.h       |    6 +-
 tools/objtool/include/objtool/util.h          |   19 +
 tools/objtool/include/objtool/warn.h          |   40 +
 tools/objtool/klp-diff.c                      | 1677 +++++++++++++++++
 tools/objtool/klp-post-link.c                 |  168 ++
 tools/objtool/objtool.c                       |   42 +-
 tools/objtool/orc_gen.c                       |    8 +-
 tools/objtool/special.c                       |   13 +-
 tools/objtool/sync-check.sh                   |    1 +
 tools/objtool/weak.c                          |    7 +
 71 files changed, 5007 insertions(+), 812 deletions(-)
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

Diff between v2 and v3:

diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index 04ab3b653a48..1934fa0df888 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -5,7 +5,6 @@ generic-y += device.h
 generic-y += dma-mapping.h
 generic-y += emergency-restart.h
 generic-y += exec.h
-generic-y += extable.h
 generic-y += ftrace.h
 generic-y += hw_irq.h
 generic-y += irq_regs.h
diff --git a/arch/um/include/shared/common-offsets.h b/arch/um/include/shared/common-offsets.h
index 8ca66a1918c3..a6f77cb6aa7e 100644
--- a/arch/um/include/shared/common-offsets.h
+++ b/arch/um/include/shared/common-offsets.h
@@ -18,3 +18,6 @@ DEFINE(UM_NSEC_PER_USEC, NSEC_PER_USEC);
 DEFINE(UM_KERN_GDT_ENTRY_TLS_ENTRIES, GDT_ENTRY_TLS_ENTRIES);
 
 DEFINE(UM_SECCOMP_ARCH_NATIVE, SECCOMP_ARCH_NATIVE);
+
+DEFINE(ALT_INSTR_SIZE, sizeof(struct alt_instr));
+DEFINE(EXTABLE_SIZE,   sizeof(struct exception_table_entry));
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 62faa62b5959..448c6bfb71d6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -266,6 +266,7 @@ config X86
 	select HAVE_FUNCTION_ERROR_INJECTION
 	select HAVE_KRETPROBES
 	select HAVE_RETHOOK
+	select HAVE_KLP_BUILD			if X86_64
 	select HAVE_LIVEPATCH			if X86_64
 	select HAVE_MIXED_BREAKPOINTS_REGS
 	select HAVE_MOD_ARCH_SPECIFIC
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index e206e0f96568..eb24d9ba30d7 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -16,8 +16,6 @@
 #define ALT_DIRECT_CALL(feature) ((ALT_FLAG_DIRECT_CALL << ALT_FLAGS_SHIFT) | (feature))
 #define ALT_CALL_ALWAYS		ALT_DIRECT_CALL(X86_FEATURE_ALWAYS)
 
-#define ALTINSTR_SIZE		14
-
 #ifndef __ASSEMBLER__
 
 #include <linux/stddef.h>
@@ -200,7 +198,7 @@ static inline int alternatives_text_reserved(void *start, void *end)
 
 #define ALTINSTR_ENTRY(ft_flags)					      \
 	".pushsection .altinstructions, \"aM\", @progbits, "		      \
-		      __stringify(ALTINSTR_SIZE) "\n"			      \
+		      __stringify(ALT_INSTR_SIZE) "\n"			      \
 	" .long 771b - .\n"				/* label           */ \
 	" .long 774f - .\n"				/* new instruction */ \
 	" .4byte " __stringify(ft_flags) "\n"		/* feature + flags */ \
@@ -363,7 +361,7 @@ void nop_func(void);
 741:									\
 	.skip -(((744f-743f)-(741b-740b)) > 0) * ((744f-743f)-(741b-740b)),0x90	;\
 742:									\
-	.pushsection .altinstructions, "aM", @progbits, ALTINSTR_SIZE ;	\
+	.pushsection .altinstructions, "aM", @progbits, ALT_INSTR_SIZE ;\
 	altinstr_entry 740b,743f,flag,742b-740b,744f-743f ;		\
 	.popsection ;							\
 	.pushsection .altinstr_replacement,"ax"	;			\
diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 62dff336f206..e9b6d2d006c6 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -136,9 +136,11 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
 
 #ifdef __KERNEL__
 
-# include <asm/extable_fixup_types.h>
+#ifndef COMPILE_OFFSETS
+#include <asm/asm-offsets.h>
+#endif
 
-#define EXTABLE_SIZE 12
+# include <asm/extable_fixup_types.h>
 
 /* Exception table entry */
 #ifdef __ASSEMBLER__
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 6081c33e1566..7a6b0e5d85c1 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -12,31 +12,34 @@
 #include <linux/stringify.h>
 #include <linux/types.h>
 
-#define JUMP_TABLE_ENTRY(key, label, size)				\
-	".pushsection __jump_table, \"aM\", @progbits, " size "\n\t"	\
-	_ASM_ALIGN "\n\t"						\
-	".long 1b - . \n\t"						\
-	".long " label " - . \n\t"					\
-	_ASM_PTR " " key " - . \n\t"					\
+#ifndef COMPILE_OFFSETS
+#include <generated/bounds.h>
+#endif
+
+#define JUMP_TABLE_ENTRY(key, label)				\
+	".pushsection __jump_table,  \"aM\", @progbits, "	\
+	__stringify(JUMP_ENTRY_SIZE) "\n\t"			\
+	_ASM_ALIGN "\n\t"					\
+	".long 1b - . \n\t"					\
+	".long " label " - . \n\t"				\
+	_ASM_PTR " " key " - . \n\t"				\
 	".popsection \n\t"
 
 /* This macro is also expanded on the Rust side. */
 #ifdef CONFIG_HAVE_JUMP_LABEL_HACK
-#define ARCH_STATIC_BRANCH_ASM(key, label, size)	\
+#define ARCH_STATIC_BRANCH_ASM(key, label)		\
 	"1: jmp " label " # objtool NOPs this \n\t"	\
-	JUMP_TABLE_ENTRY(key " + 2", label, size)
+	JUMP_TABLE_ENTRY(key " + 2", label)
 #else /* !CONFIG_HAVE_JUMP_LABEL_HACK */
-#define ARCH_STATIC_BRANCH_ASM(key, label, size)	\
+#define ARCH_STATIC_BRANCH_ASM(key, label)		\
 	"1: .byte " __stringify(BYTES_NOP5) "\n\t"	\
-	JUMP_TABLE_ENTRY(key, label, size)
+	JUMP_TABLE_ENTRY(key, label)
 #endif /* CONFIG_HAVE_JUMP_LABEL_HACK */
 
 static __always_inline bool arch_static_branch(struct static_key * const key, const bool branch)
 {
-	asm goto(ARCH_STATIC_BRANCH_ASM("%c[key] + %c[branch]", "%l[l_yes]", "%c[size]")
-		 : : [key] "i" (key), [branch] "i" (branch),
-		     [size] "i" (sizeof(struct jump_entry))
-		 : : l_yes);
+	asm goto(ARCH_STATIC_BRANCH_ASM("%c0 + %c1", "%l[l_yes]")
+		: :  "i" (key), "i" (branch) : : l_yes);
 
 	return false;
 l_yes:
@@ -47,10 +50,8 @@ static __always_inline bool arch_static_branch_jump(struct static_key * const ke
 {
 	asm goto("1:"
 		"jmp %l[l_yes]\n\t"
-		JUMP_TABLE_ENTRY("%c[key] + %c[branch]", "%l[l_yes]", "%c[size]")
-		: : [key] "i" (key), [branch] "i" (branch),
-		    [size] "i" (sizeof(struct jump_entry))
-		: : l_yes);
+		JUMP_TABLE_ENTRY("%c0 + %c1", "%l[l_yes]")
+		: :  "i" (key), "i" (branch) : : l_yes);
 
 	return false;
 l_yes:
diff --git a/arch/x86/include/asm/static_call.h b/arch/x86/include/asm/static_call.h
index 41502bd2afd6..e03ad9bbbf59 100644
--- a/arch/x86/include/asm/static_call.h
+++ b/arch/x86/include/asm/static_call.h
@@ -58,7 +58,8 @@
 	ARCH_DEFINE_STATIC_CALL_TRAMP(name, __static_call_return0)
 
 #define ARCH_ADD_TRAMP_KEY(name)					\
-	asm(".pushsection .static_call_tramp_key, \"a\"		\n"	\
+	asm(".pushsection .static_call_tramp_key, \"aM\", @progbits, "	\
+	    __stringify(STATIC_CALL_TRAMP_KEY_SIZE) "\n"		\
 	    ".long " STATIC_CALL_TRAMP_STR(name) " - .		\n"	\
 	    ".long " STATIC_CALL_KEY_STR(name) " - .		\n"	\
 	    ".popsection					\n")
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 499dc1ca2050..bacd6c157626 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -622,8 +622,6 @@ void __init_or_module noinline apply_alternatives(struct alt_instr *start,
 	u8 *instr, *replacement;
 	struct alt_instr *a, *b;
 
-	BUILD_BUG_ON(ALTINSTR_SIZE != sizeof(struct alt_instr));
-
 	DPRINTK(ALT, "alt table %px, -> %px", start, end);
 
 	/*
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 6259b474073b..3d3eef7fae32 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -123,4 +123,7 @@ static void __used common(void)
 	OFFSET(ARIA_CTX_rounds, aria_ctx, rounds);
 #endif
 
+	BLANK();
+	DEFINE(ALT_INSTR_SIZE,	 sizeof(struct alt_instr));
+	DEFINE(EXTABLE_SIZE,	 sizeof(struct exception_table_entry));
 }
diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 4624d6d916a2..977ee75e047c 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -199,8 +199,6 @@ static struct orc_entry *orc_find(unsigned long ip)
 {
 	static struct orc_entry *orc;
 
-	BUILD_BUG_ON(UNWIND_HINT_SIZE != sizeof(struct unwind_hint));
-
 	if (ip == 0)
 		return &null_orc_entry;
 
diff --git a/arch/x86/um/shared/sysdep/kernel-offsets.h b/arch/x86/um/shared/sysdep/kernel-offsets.h
index 6fd1ed400399..8215a0200ddd 100644
--- a/arch/x86/um/shared/sysdep/kernel-offsets.h
+++ b/arch/x86/um/shared/sysdep/kernel-offsets.h
@@ -1,4 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#define COMPILE_OFFSETS
 #include <linux/stddef.h>
 #include <linux/sched.h>
 #include <linux/elf.h>
@@ -7,6 +8,7 @@
 #include <linux/audit.h>
 #include <asm/mman.h>
 #include <asm/seccomp.h>
+#include <asm/extable.h>
 
 /* workaround for a warning with -Wmissing-prototypes */
 void foo(void);
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 3a0865e0a1a7..928e175254f6 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -91,7 +91,7 @@
  * but exclude '.text..*'.
  *
  * Special .text.* sections that are typically grouped separately, such as
- * .text.unlikely or .text.hot, must be matched explicitly before invoking
+ * .text.unlikely or .text.hot, must be matched explicitly before using
  * TEXT_MAIN.
  */
 #define TEXT_MAIN .text .text.[0-9a-zA-Z_]*
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index b90422671874..2039da81cf16 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -287,7 +287,7 @@ static inline void *offset_to_ptr(const int *off)
  */
 #define ___ADDRESSABLE(sym, __attrs)						\
 	static void * __used __attrs						\
-	__UNIQUE_ID(__PASTE(addressable_,sym)) = (void *)(uintptr_t)&sym;
+	__UNIQUE_ID(__PASTE(addressable_, sym)) = (void *)(uintptr_t)&sym;
 
 #define __ADDRESSABLE(sym) \
 	___ADDRESSABLE(sym, __section(".discard.addressable"))
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 9ff1ecc8e7a8..fdb79dd1ebd8 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -110,20 +110,16 @@ struct static_key {
 #endif /* __ASSEMBLY__ */
 
 #ifdef CONFIG_JUMP_LABEL
+#include <asm/jump_label.h>
+
+#ifndef __ASSEMBLY__
+#ifdef CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE
 
-#if defined(CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE) && !defined(__ASSEMBLY__)
-/* Must be defined before including <asm/jump_label.h> */
 struct jump_entry {
 	s32 code;
 	s32 target;
 	long key;	// key may be far away from the core kernel under KASLR
 };
-#endif
-
-#include <asm/jump_label.h>
-
-#ifndef __ASSEMBLY__
-#ifdef CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE
 
 static inline unsigned long jump_entry_code(const struct jump_entry *entry)
 {
@@ -142,7 +138,7 @@ static inline struct static_key *jump_entry_key(const struct jump_entry *entry)
 	return (struct static_key *)((unsigned long)&entry->key + offset);
 }
 
-#else /* !CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE */
+#else
 
 static inline unsigned long jump_entry_code(const struct jump_entry *entry)
 {
@@ -159,7 +155,7 @@ static inline struct static_key *jump_entry_key(const struct jump_entry *entry)
 	return (struct static_key *)((unsigned long)entry->key & ~3UL);
 }
 
-#endif /* !CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE */
+#endif
 
 static inline bool jump_entry_is_branch(const struct jump_entry *entry)
 {
@@ -188,8 +184,8 @@ static inline int jump_entry_size(struct jump_entry *entry)
 #endif
 }
 
-#endif /* !__ASSEMBLY__ */
-#endif /* CONFIG_JUMP_LABEL */
+#endif
+#endif
 
 #ifndef __ASSEMBLY__
 
diff --git a/include/linux/livepatch_helpers.h b/include/linux/livepatch_helpers.h
index 09f4a2d53fd7..337bee91d7da 100644
--- a/include/linux/livepatch_helpers.h
+++ b/include/linux/livepatch_helpers.h
@@ -35,6 +35,17 @@
 	klp_post_unpatch_t __used __section(KLP_CALLBACK_PTRS)			\
 		__PASTE(__KLP_POST_UNPATCH_PREFIX, KLP_OBJNAME) = func
 
+/*
+ * KLP_STATIC_CALL
+ *
+ * Replace static_call() usage with this macro when create-diff-object
+ * recommends it due to the original static call key living in a module.
+ *
+ * This converts the static call to a regular indirect call.
+ */
+#define KLP_STATIC_CALL(name) \
+	((typeof(STATIC_CALL_TRAMP(name))*)(STATIC_CALL_KEY(name).func))
+
 /* Syscall patching */
 
 #define KLP_SYSCALL_DEFINE1(name, ...) KLP_SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index d4137a46ee70..7d7bb7f1af69 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -2,14 +2,16 @@
 #ifndef _LINUX_OBJTOOL_H
 #define _LINUX_OBJTOOL_H
 
+#ifndef COMPILE_OFFSETS
+#include <generated/bounds.h>
+#endif
+
 #include <linux/objtool_types.h>
 
 #ifdef CONFIG_OBJTOOL
 
 #include <asm/asm.h>
 
-#define UNWIND_HINT_SIZE 12
-
 #ifndef __ASSEMBLY__
 
 #define UNWIND_HINT(type, sp_reg, sp_offset, signal)		\
@@ -33,10 +35,9 @@
  *
  * For more information, see tools/objtool/Documentation/objtool.txt.
  */
-#define STACK_FRAME_NON_STANDARD(func)						\
-	asm(".pushsection .discard.func_stack_frame_non_standard, \"aw\"\n\t"	\
-	    ".long " __stringify(func) " - .\n\t"				\
-	    ".popsection")
+#define STACK_FRAME_NON_STANDARD(func) \
+	static void __used __section(".discard.func_stack_frame_non_standard") \
+		*__func_stack_frame_non_standard_##func = func
 
 /*
  * STACK_FRAME_NON_STANDARD_FP() is a frame-pointer-specific function ignore
@@ -105,7 +106,7 @@
 
 .macro STACK_FRAME_NON_STANDARD func:req
 	.pushsection .discard.func_stack_frame_non_standard, "aw"
-	.long \func - .
+	.quad \func
 	.popsection
 .endm
 
diff --git a/include/linux/static_call.h b/include/linux/static_call.h
index 78a77a4ae0ea..5210612817f2 100644
--- a/include/linux/static_call.h
+++ b/include/linux/static_call.h
@@ -172,12 +172,6 @@ struct static_call_mod {
 	struct static_call_site *sites;
 };
 
-/* For finding the key associated with a trampoline */
-struct static_call_tramp_key {
-	s32 tramp;
-	s32 key;
-};
-
 extern void __static_call_update(struct static_call_key *key, void *tramp, void *func);
 extern int static_call_mod_init(struct module *mod);
 extern int static_call_text_reserved(void *start, void *end);
diff --git a/include/linux/static_call_types.h b/include/linux/static_call_types.h
index 5a00b8b2cf9f..eb772df625d4 100644
--- a/include/linux/static_call_types.h
+++ b/include/linux/static_call_types.h
@@ -34,6 +34,12 @@ struct static_call_site {
 	s32 key;
 };
 
+/* For finding the key associated with a trampoline */
+struct static_call_tramp_key {
+	s32 tramp;
+	s32 key;
+};
+
 #define DECLARE_STATIC_CALL(name, func)					\
 	extern struct static_call_key STATIC_CALL_KEY(name);		\
 	extern typeof(func) STATIC_CALL_TRAMP(name);
diff --git a/kernel/bounds.c b/kernel/bounds.c
index 29b2cd00df2c..f9bc13727721 100644
--- a/kernel/bounds.c
+++ b/kernel/bounds.c
@@ -6,12 +6,16 @@
  */
 
 #define __GENERATING_BOUNDS_H
+#define COMPILE_OFFSETS
 /* Include headers that define the enum constants of interest */
 #include <linux/page-flags.h>
 #include <linux/mmzone.h>
 #include <linux/kbuild.h>
 #include <linux/log2.h>
 #include <linux/spinlock_types.h>
+#include <linux/jump_label.h>
+#include <linux/static_call_types.h>
+#include <linux/objtool_types.h>
 
 int main(void)
 {
@@ -28,6 +32,15 @@ int main(void)
 #else
 	DEFINE(LRU_GEN_WIDTH, 0);
 	DEFINE(__LRU_REFS_WIDTH, 0);
+#endif
+#if defined(CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE) && defined(CONFIG_JUMP_LABEL)
+	DEFINE(JUMP_ENTRY_SIZE, sizeof(struct jump_entry));
+#endif
+#ifdef CONFIG_HAVE_STATIC_CALL_INLINE
+	DEFINE(STATIC_CALL_TRAMP_KEY_SIZE, sizeof(struct static_call_tramp_key));
+#endif
+#ifdef CONFIG_OBJTOOL
+	DEFINE(UNWIND_HINT_SIZE, sizeof(struct unwind_hint));
 #endif
 	/* End of constants */
 
diff --git a/kernel/extable.c b/kernel/extable.c
index 0ae3ee2ef266..71f482581cab 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -55,8 +55,6 @@ const struct exception_table_entry *search_exception_tables(unsigned long addr)
 {
 	const struct exception_table_entry *e;
 
-	BUILD_BUG_ON(EXTABLE_SIZE != sizeof(struct exception_table_entry));
-
 	e = search_kernel_exception_table(addr);
 	if (!e)
 		e = search_module_extables(addr);
diff --git a/kernel/livepatch/Kconfig b/kernel/livepatch/Kconfig
index 53d51ed619a3..4c0a9c18d0b2 100644
--- a/kernel/livepatch/Kconfig
+++ b/kernel/livepatch/Kconfig
@@ -18,3 +18,15 @@ config LIVEPATCH
 	  module uses the interface provided by this option to register
 	  a patch, causing calls to patched functions to be redirected
 	  to new function code contained in the patch module.
+
+config HAVE_KLP_BUILD
+	bool
+	help
+	  Arch supports klp-build
+
+config KLP_BUILD
+	def_bool y
+	depends on LIVEPATCH && HAVE_KLP_BUILD
+	select OBJTOOL
+	help
+	  Enable klp-build support
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 41420d24e62e..28a1c08e3b22 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -197,7 +197,7 @@ objtool-args = $(objtool-args-y)					\
 	$(if $(delay-objtool), --link)					\
 	$(if $(part-of-module), --module)
 
-delay-objtool := $(or $(CONFIG_LTO_CLANG),$(CONFIG_X86_KERNEL_IBT),$(CONFIG_LIVEPATCH))
+delay-objtool := $(or $(CONFIG_LTO_CLANG),$(CONFIG_X86_KERNEL_IBT),$(CONFIG_KLP_BUILD))
 
 cmd_objtool = $(if $(objtool-enabled), ; $(objtool) $(objtool-args) $@)
 cmd_gen_objtooldep = $(if $(objtool-enabled), { echo ; echo '$@: $$(wildcard $(objtool))' ; } >> $(dot-target).cmd)
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index 878d0d25a461..7a888e1ff70f 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -31,7 +31,8 @@ ccflags-remove-y := $(CC_FLAGS_CFI)
 ifdef CONFIG_NEED_MODULE_PERMISSIONS_FIX
 cmd_fix_mod_permissions =						\
 	$(OBJCOPY) --set-section-flags __jump_table=alloc,data		\
-		   --set-section-flags __bug_table=alloc,data $@
+		   --set-section-flags __bug_table=alloc,data $@	\
+		   --set-section-flags .static_call_sites=alloc,data $@
 endif
 
 quiet_cmd_ld_ko_o = LD [M]  $@
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index acffa3c935f2..59f875236292 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -61,7 +61,7 @@ vmlinux_link()
 	shift
 
 	if is_enabled CONFIG_LTO_CLANG || is_enabled CONFIG_X86_KERNEL_IBT ||
-	   is_enabled CONFIG_LIVEPATCH; then
+	   is_enabled CONFIG_KLP_BUILD; then
 		# Use vmlinux.o instead of performing the slow LTO link again.
 		objs=vmlinux.o
 		libs=
diff --git a/scripts/livepatch/fix-patch-lines b/scripts/livepatch/fix-patch-lines
index 73c5e3dea46e..fa7d4f6592e6 100755
--- a/scripts/livepatch/fix-patch-lines
+++ b/scripts/livepatch/fix-patch-lines
@@ -23,7 +23,7 @@ BEGIN {
 
 	in_hunk = 1
 
-	# for @@ -1,3 +1,4 @@:
+	# @@ -1,3 +1,4 @@:
 	#   1: line number in old file
 	#   3: how many lines the hunk covers in old file
 	#   1: line number in new file
diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index f7d88726ed4f..e47056f75475 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -2,12 +2,11 @@
 # SPDX-License-Identifier: GPL-2.0
 #
 # Build a livepatch module
-#
 
-# shellcheck disable=SC1090
+# shellcheck disable=SC1090,SC2155
 
-if (( BASH_VERSINFO[0] < 4 \
-	|| (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] < 4) )); then
+if (( BASH_VERSINFO[0]  < 4 || \
+     (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] < 4) )); then
 		echo "error: this script requires bash 4.4+" >&2
 	exit 1
 fi
@@ -22,16 +21,16 @@ set -o nounset
 shopt -s lastpipe
 
 unset DEBUG_CLONE DIFF_CHECKSUM SKIP_CLEANUP XTRACE
+
 REPLACE=1
 SHORT_CIRCUIT=0
+JOBS="$(getconf _NPROCESSORS_ONLN)"
+VERBOSE="-s"
 shopt -o xtrace | grep -q 'on' && XTRACE=1
+
 # Avoid removing the previous $TMP_DIR until args have been fully processed.
 KEEP_TMP=1
 
-CPUS="$(getconf _NPROCESSORS_ONLN)"
-VERBOSE="-s"
-
-
 SCRIPT="$(basename "$0")"
 SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
 FIX_PATCH_LINES="$SCRIPT_DIR/fix-patch-lines"
@@ -62,7 +61,7 @@ status() {
 }
 
 warn() {
-	echo "error: $(basename "$SCRIPT"): $*" >&2
+	echo "error: $SCRIPT: $*" >&2
 }
 
 die() {
@@ -99,7 +98,7 @@ cleanup() {
 	revert_patches "--recount"
 	restore_files
 	[[ "$KEEP_TMP" -eq 0 ]] && rm -rf "$TMP_DIR"
-	true
+	return 0
 }
 
 trap_err() {
@@ -116,12 +115,13 @@ Generate a livepatch module.
 
 Options:
    -f, --show-first-changed	Show address of first changed instruction
-   -o, --output <file.ko>	Output file [default: livepatch-<patch-name>.ko]
+   -j, --jobs=<jobs>		Build jobs to run simultaneously [default: $JOBS]
+   -o, --output=<file.ko>	Output file [default: livepatch-<patch-name>.ko]
        --no-replace		Disable livepatch atomic replace
    -v, --verbose		Pass V=1 to kernel/module builds
 
 Advanced Options:
-   -D, --debug			Show symbol/reloc cloning decisions
+   -d, --debug			Show symbol/reloc cloning decisions
    -S, --short-circuit=STEP	Start at build step (requires prior --keep-tmp)
 				   1|orig	Build original kernel (default)
 				   2|patched	Build patched kernel
@@ -142,8 +142,8 @@ process_args() {
 	local long
 	local args
 
-	short="hfo:vDS:T"
-	long="help,show-first-changed,output:,no-replace,verbose,debug,short-circuit:,keep-tmp"
+	short="hfj:o:vdS:T"
+	long="help,show-first-changed,jobs:,output:,no-replace,verbose,debug,short-circuit:,keep-tmp"
 
 	args=$(getopt --options "$short" --longoptions "$long" -- "$@") || {
 		echo; usage; exit
@@ -160,6 +160,10 @@ process_args() {
 				DIFF_CHECKSUM=1
 				shift
 				;;
+			-j | --jobs)
+				JOBS="$2"
+				shift 2
+				;;
 			-o | --output)
 				[[ "$2" != *.ko ]] && die "output filename should end with .ko"
 				OUTFILE="$2"
@@ -176,7 +180,7 @@ process_args() {
 				VERBOSE="V=1"
 				shift
 				;;
-			-D | --debug)
+			-d | --debug)
 				DEBUG_CLONE=1
 				keep_tmp=1
 				shift
@@ -233,14 +237,17 @@ validate_config() {
 	source "$CONFIG" || die "no .config file in $(dirname "$CONFIG")"
 	xtrace_restore
 
-	[[ -v CONFIG_LIVEPATCH ]]			\
-		|| die "CONFIG_LIVEPATCH not enabled"
+	[[ -v CONFIG_LIVEPATCH ]] ||			\
+		die "CONFIG_LIVEPATCH not enabled"
 
-	[[ -v CONFIG_GCC_PLUGIN_LATENT_ENTROPY ]]	\
-		&& die "kernel option 'CONFIG_GCC_PLUGIN_LATENT_ENTROPY' not supported"
+	[[ -v CONFIG_KLP_BUILD ]] ||			\
+		die "CONFIG_KLP_BUILD not enabled"
 
-	[[ -v CONFIG_GCC_PLUGIN_RANDSTRUCT ]]		\
-		&& die "kernel option 'CONFIG_GCC_PLUGIN_RANDSTRUCT' not supported"
+	[[ -v CONFIG_GCC_PLUGIN_LATENT_ENTROPY ]] &&	\
+		die "kernel option 'CONFIG_GCC_PLUGIN_LATENT_ENTROPY' not supported"
+
+	[[ -v CONFIG_GCC_PLUGIN_RANDSTRUCT ]] &&	\
+		die "kernel option 'CONFIG_GCC_PLUGIN_RANDSTRUCT' not supported"
 
 	return 0
 }
@@ -282,7 +289,7 @@ set_kernelversion() {
 	localversion="$(cd "$SRC" && KERNELVERSION="$localversion" ./scripts/setlocalversion)"
 	[[ -z "$localversion" ]] && die "setlocalversion failed"
 
-	echo "echo $localversion" > "$file"
+	sed -i "2i echo $localversion; exit 0" scripts/setlocalversion
 }
 
 get_patch_files() {
@@ -299,7 +306,7 @@ git_refresh() {
 	local patch="$1"
 	local files=()
 
-	[[ ! -d "$SRC/.git" ]] && return
+	[[ ! -e "$SRC/.git" ]] && return
 
 	get_patch_files "$patch" | mapfile -t files
 
@@ -334,7 +341,14 @@ apply_patch() {
 
 	[[ ! -f "$patch" ]] && die "$patch doesn't exist"
 
-	( cd "$SRC" && git apply "${extra_args[@]}" "$patch" )
+	(
+		cd "$SRC"
+
+		# The sed strips the version signature from 'git format-patch',
+		# otherwise 'git apply --recount' warns.
+		sed -n '/^-- /q;p' "$patch" |
+			git apply "${extra_args[@]}"
+	)
 
 	APPLIED_PATCHES+=("$patch")
 }
@@ -345,7 +359,12 @@ revert_patch() {
 	local extra_args=("$@")
 	local tmp=()
 
-	( cd "$SRC" && git apply --reverse "${extra_args[@]}" "$patch" )
+	(
+		cd "$SRC"
+
+		sed -n '/^-- /q;p' "$patch" |
+			git apply --reverse "${extra_args[@]}"
+	)
 	git_refresh "$patch"
 
 	for p in "${APPLIED_PATCHES[@]}"; do
@@ -373,9 +392,6 @@ revert_patches() {
 	done
 
 	APPLIED_PATCHES=()
-
-	# Make sure git actually sees the patches have been reverted.
-	[[ -d "$SRC/.git" ]] && (cd "$SRC" && git update-index -q --refresh)
 }
 
 validate_patches() {
@@ -412,10 +428,8 @@ refresh_patch() {
 	mkdir -p "$tmpdir/a"
 	mkdir -p "$tmpdir/b"
 
-	# Find all source files affected by the patch
-	grep0 -E '^(--- |\+\+\+ )[^ /]+' "$patch"	|
-		sed -E 's/(--- |\+\+\+ )[^ /]+\///'	|
-		sort | uniq | mapfile -t files
+	# Get all source files affected by the patch
+	get_patch_files "$patch" | mapfile -t files
 
 	# Copy orig source files to 'a'
 	( cd "$SRC" && echo "${files[@]}" | xargs cp --parents --target-directory="$tmpdir/a" )
@@ -459,13 +473,26 @@ fix_patches() {
 	done
 }
 
+clean_kernel() {
+	local cmd=()
+
+	cmd=("make")
+	cmd+=("--silent")
+	cmd+=("-j$JOBS")
+	cmd+=("clean")
+
+	(
+		cd "$SRC"
+		"${cmd[@]}"
+	)
+}
+
 build_kernel() {
 	local log="$TMP_DIR/build.log"
 	local objtool_args=()
 	local cmd=()
 
 	objtool_args=("--checksum")
-	[[ -v OBJTOOL_ARGS ]] && objtool_args+=("${OBJTOOL_ARGS}")
 
 	cmd=("make")
 
@@ -487,7 +514,7 @@ build_kernel() {
 	cmd+=("KBUILD_MODPOST_WARN=1")
 
 	cmd+=("$VERBOSE")
-	cmd+=("-j$CPUS")
+	cmd+=("-j$JOBS")
 	cmd+=("KCFLAGS=-ffunction-sections -fdata-sections")
 	cmd+=("OBJTOOL_ARGS=${objtool_args[*]}")
 	cmd+=("vmlinux")
@@ -496,7 +523,7 @@ build_kernel() {
 	(
 		cd "$SRC"
 		"${cmd[@]}"							\
-			> >(tee -a "$log")					\
+			1> >(tee -a "$log")					\
 			2> >(tee -a "$log" | grep0 -v "modpost.*undefined!" >&2)
 	)
 }
@@ -512,18 +539,31 @@ find_objects() {
 		    -printf '%P\n'
 }
 
-# Copy all objects (.o archives) to $ORIG_DIR
+# Copy all .o archives to $ORIG_DIR
 copy_orig_objects() {
+	local files=()
 
 	rm -rf "$ORIG_DIR"
 	mkdir -p "$ORIG_DIR"
 
-	(
-		cd "$OBJ"
-		find_objects						\
-			| sed 's/\.ko$/.o/'				\
-			| xargs cp --parents --target-directory="$ORIG_DIR"
-	)
+	find_objects | mapfile -t files
+
+	xtrace_save "copying orig objects"
+	for _file in "${files[@]}"; do
+		local rel_file="${_file/.ko/.o}"
+		local file="$OBJ/$rel_file"
+		local file_dir="$(dirname "$file")"
+		local orig_file="$ORIG_DIR/$rel_file"
+		local orig_dir="$(dirname "$orig_file")"
+		local cmd_file="$file_dir/.$(basename "$file").cmd"
+
+		[[ ! -f "$file" ]] && die "missing $(basename "$file") for $_file"
+
+		mkdir -p "$orig_dir"
+		cp -f "$file" "$orig_dir"
+		[[ -e "$cmd_file" ]] && cp -f "$cmd_file" "$orig_dir"
+	done
+	xtrace_restore
 
 	mv -f "$TMP_DIR/build.log" "$ORIG_DIR"
 	touch "$TIMESTAMP"
@@ -531,9 +571,9 @@ copy_orig_objects() {
 
 # Copy all changed objects to $PATCHED_DIR
 copy_patched_objects() {
-	local found
 	local files=()
 	local opts=()
+	local found=0
 
 	rm -rf "$PATCHED_DIR"
 	mkdir -p "$PATCHED_DIR"
@@ -544,24 +584,25 @@ copy_patched_objects() {
 
 	find_objects "${opts[@]}" | mapfile -t files
 
-	xtrace_save "processing all objects"
+	xtrace_save "copying changed objects"
 	for _file in "${files[@]}"; do
 		local rel_file="${_file/.ko/.o}"
 		local file="$OBJ/$rel_file"
 		local orig_file="$ORIG_DIR/$rel_file"
 		local patched_file="$PATCHED_DIR/$rel_file"
+		local patched_dir="$(dirname "$patched_file")"
 
 		[[ ! -f "$file" ]] && die "missing $(basename "$file") for $_file"
 
 		cmp -s "$orig_file" "$file" && continue
 
-		mkdir -p "$(dirname "$patched_file")"
-		cp -f "$file" "$patched_file"
+		mkdir -p "$patched_dir"
+		cp -f "$file" "$patched_dir"
 		found=1
 	done
 	xtrace_restore
 
-	[[ -n "$found" ]] || die "no changes detected"
+	(( found == 0 )) && die "no changes detected"
 
 	mv -f "$TMP_DIR/build.log" "$PATCHED_DIR"
 }
@@ -610,9 +651,9 @@ diff_objects() {
 		(
 			cd "$ORIG_DIR"
 			"${cmd[@]}"							\
-				> >(tee -a "$log")					\
-				2> >(tee -a "$log" | "${filter[@]}" >&2)		\
-				|| die "objtool klp diff failed"
+				1> >(tee -a "$log")					\
+				2> >(tee -a "$log" | "${filter[@]}" >&2) ||		\
+				die "objtool klp diff failed"
 		)
 	done
 }
@@ -653,12 +694,12 @@ diff_checksums() {
 
 		(
 			cd "$ORIG_DIR"
-			"${cmd[@]}" "$opt" "$file" &> "$orig_log"	\
-				|| ( cat "$orig_log" >&2; die "objtool --debug-checksum failed" )
+			"${cmd[@]}" "$opt" "$file" &> "$orig_log" || \
+				( cat "$orig_log" >&2; die "objtool --debug-checksum failed" )
 
 			cd "$PATCHED_DIR"
-			"${cmd[@]}" "$opt" "$file" &> "$patched_log"	\
-				|| ( cat "$patched_log" >&2; die "objtool --debug-checksum failed" )
+			"${cmd[@]}" "$opt" "$file" &> "$patched_log" ||	\
+				( cat "$patched_log" >&2; die "objtool --debug-checksum failed" )
 		)
 
 		for func in ${funcs[$file]}; do
@@ -677,6 +718,7 @@ diff_checksums() {
 build_patch_module() {
 	local makefile="$KMOD_DIR/Kbuild"
 	local log="$KMOD_DIR/build.log"
+	local kmod_file
 	local cflags=()
 	local files=()
 	local cmd=()
@@ -694,19 +736,20 @@ build_patch_module() {
 
 	for file in "${files[@]}"; do
 		local rel_file="${file#"$DIFF_DIR"/}"
+		local orig_file="$ORIG_DIR/$rel_file"
+		local orig_dir="$(dirname "$orig_file")"
 		local kmod_file="$KMOD_DIR/$rel_file"
-		local cmd_file
+		local kmod_dir="$(dirname "$kmod_file")"
+		local cmd_file="$orig_dir/.$(basename "$file").cmd"
 
-		mkdir -p "$(dirname "$kmod_file")"
-		cp -f "$file" "$kmod_file"
+		mkdir -p "$kmod_dir"
+		cp -f "$file" "$kmod_dir"
+		[[ -e "$cmd_file" ]] && cp -f "$cmd_file" "$kmod_dir"
 
 		# Tell kbuild this is a prebuilt object
 		cp -f "$file" "${kmod_file}_shipped"
 
 		echo -n " $rel_file" >> "$makefile"
-
-		cmd_file="$ORIG_DIR/$(dirname "$rel_file")/.$(basename "$rel_file").cmd"
-		[[ -e "$cmd_file" ]] && cp -f "$cmd_file" "$(dirname "$kmod_file")"
 	done
 
 	echo >> "$makefile"
@@ -717,7 +760,7 @@ build_patch_module() {
 
 	cmd=("make")
 	cmd+=("$VERBOSE")
-	cmd+=("-j$CPUS")
+	cmd+=("-j$JOBS")
 	cmd+=("--directory=.")
 	cmd+=("M=$KMOD_DIR")
 	cmd+=("KCFLAGS=${cflags[*]}")
@@ -726,17 +769,22 @@ build_patch_module() {
 	(
 		cd "$SRC"
 		"${cmd[@]}"							\
-			>  >(tee -a "$log")					\
+			1> >(tee -a "$log")					\
 			2> >(tee -a "$log" >&2)
 	)
 
+	kmod_file="$KMOD_DIR/$NAME.ko"
+
 	# Save off the intermediate binary for debugging
-	cp -f "$KMOD_DIR/$NAME.ko" "$KMOD_DIR/$NAME.ko.orig"
+	cp -f "$kmod_file" "$kmod_file.orig"
+
+	# Work around issue where slight .config change makes corrupt BTF
+	objcopy --remove-section=.BTF "$kmod_file"
 
 	# Fix (and work around) linker wreckage for klp syms / relocs
-	"$SRC/tools/objtool/objtool" klp post-link "$KMOD_DIR/$NAME.ko" || die "objtool klp post-link failed"
+	"$SRC/tools/objtool/objtool" klp post-link "$kmod_file" || die "objtool klp post-link failed"
 
-	cp -f "$KMOD_DIR/$NAME.ko" "$OUTFILE"
+	cp -f "$kmod_file" "$OUTFILE"
 }
 
 
@@ -746,8 +794,10 @@ process_args "$@"
 do_init
 
 if (( SHORT_CIRCUIT <= 1 )); then
-	status "Building original kernel"
+	status "Validating patches"
 	validate_patches
+	status "Building original kernel"
+	clean_kernel
 	build_kernel
 	status "Copying original object files"
 	copy_orig_objects
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index d3d00e85edf7..ef2ffb68f69d 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#define COMPILE_OFFSETS
 #include <linux/kbuild.h>
 #include <linux/mod_devicetable.h>
 
diff --git a/tools/include/linux/static_call_types.h b/tools/include/linux/static_call_types.h
index 5a00b8b2cf9f..eb772df625d4 100644
--- a/tools/include/linux/static_call_types.h
+++ b/tools/include/linux/static_call_types.h
@@ -34,6 +34,12 @@ struct static_call_site {
 	s32 key;
 };
 
+/* For finding the key associated with a trampoline */
+struct static_call_tramp_key {
+	s32 tramp;
+	s32 key;
+};
+
 #define DECLARE_STATIC_CALL(name, func)					\
 	extern struct static_call_key STATIC_CALL_KEY(name);		\
 	extern typeof(func) STATIC_CALL_TRAMP(name);
diff --git a/tools/include/linux/string.h b/tools/include/linux/string.h
index 8499f509f03e..51ad3cf4fa82 100644
--- a/tools/include/linux/string.h
+++ b/tools/include/linux/string.h
@@ -44,6 +44,20 @@ static inline bool strstarts(const char *str, const char *prefix)
 	return strncmp(str, prefix, strlen(prefix)) == 0;
 }
 
+/*
+ * Checks if a string ends with another.
+ */
+static inline bool str_ends_with(const char *str, const char *substr)
+{
+	size_t len = strlen(str);
+	size_t sublen = strlen(substr);
+
+	if (sublen > len)
+		return false;
+
+	return !strcmp(str + len - sublen, substr);
+}
+
 extern char * __must_check skip_spaces(const char *);
 
 extern char *strim(char *);
diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index 3b40afe144fe..c4d6b90b1134 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -83,14 +83,8 @@ s64 arch_insn_adjusted_addend(struct instruction *insn, struct reloc *reloc)
 {
 	s64 addend = reloc_addend(reloc);
 
-	switch (reloc_type(reloc)) {
-	case R_X86_64_PC32:
-	case R_X86_64_PLT32:
+	if (arch_pc_relative_reloc(reloc))
 		addend += insn->offset + insn->len - reloc_offset(reloc);
-		break;
-	default:
-		break;
-	}
 
 	return phys_to_virt(addend);
 }
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 84918593d935..cd2c4a387100 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -92,6 +92,7 @@ static const struct option check_options[] = {
 
 	OPT_GROUP("Options:"),
 	OPT_BOOLEAN(0,		 "backtrace", &opts.backtrace, "unwind on error"),
+	OPT_BOOLEAN(0,		 "backup", &opts.backup, "create backup (.orig) file on warning/error"),
 	OPT_STRING(0,		 "debug-checksum", &opts.debug_checksum,  "funcs", "enable checksum debug output"),
 	OPT_BOOLEAN(0,		 "dry-run", &opts.dryrun, "don't write modifications"),
 	OPT_BOOLEAN(0,		 "link", &opts.link, "object is a linked object"),
@@ -260,12 +261,9 @@ static void save_argv(int argc, const char **argv)
 	};
 }
 
-void print_args(void)
+int make_backup(void)
 {
-	char *backup = NULL;
-
-	if (opts.output || opts.dryrun)
-		goto print;
+	char *backup;
 
 	/*
 	 * Make a backup before kbuild deletes the file so the error
@@ -274,33 +272,32 @@ void print_args(void)
 	backup = malloc(strlen(objname) + strlen(ORIG_SUFFIX) + 1);
 	if (!backup) {
 		ERROR_GLIBC("malloc");
-		goto print;
+		return 1;
 	}
 
 	strcpy(backup, objname);
 	strcat(backup, ORIG_SUFFIX);
-	if (copy_file(objname, backup)) {
-		backup = NULL;
-		goto print;
-	}
+	if (copy_file(objname, backup))
+		return 1;
 
-print:
 	/*
-	 * Print the cmdline args to make it easier to recreate.  If '--output'
-	 * wasn't used, add it to the printed args with the backup as input.
+	 * Print the cmdline args to make it easier to recreate.
 	 */
+
 	fprintf(stderr, "%s", orig_argv[0]);
 
 	for (int i = 1; i < orig_argc; i++) {
 		char *arg = orig_argv[i];
 
-		if (backup && !strcmp(arg, objname))
+		/* Modify the printed args to use the backup */
+		if (!opts.output && !strcmp(arg, objname))
 			fprintf(stderr, " %s -o %s", backup, objname);
 		else
 			fprintf(stderr, " %s", arg);
 	}
 
 	fprintf(stderr, "\n");
+	return 0;
 }
 
 int objtool_run(int argc, const char **argv)
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 9848ca612683..1eb6489ae459 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -187,20 +187,6 @@ static bool is_sibling_call(struct instruction *insn)
 	return (is_static_jump(insn) && insn_call_dest(insn));
 }
 
-/*
- * Checks if a string ends with another.
- */
-static bool str_ends_with(const char *s, const char *sub)
-{
-	const int slen = strlen(s);
-	const int sublen = strlen(sub);
-
-	if (sublen > slen)
-		return 0;
-
-	return !memcmp(s + slen - sublen, sub, sublen);
-}
-
 /*
  * Checks if a function is a Rust "noreturn" one.
  */
@@ -431,7 +417,6 @@ static int decode_instructions(struct objtool_file *file)
 	struct symbol *func;
 	unsigned long offset;
 	struct instruction *insn;
-	int ret;
 
 	for_each_sec(file->elf, sec) {
 		struct instruction *insns = NULL;
@@ -480,11 +465,8 @@ static int decode_instructions(struct objtool_file *file)
 			insn->offset = offset;
 			insn->prev_len = prev_len;
 
-			ret = arch_decode_instruction(file, sec, offset,
-						      sec_size(sec) - offset,
-						      insn);
-			if (ret)
-				return ret;
+			if (arch_decode_instruction(file, sec, offset, sec_size(sec) - offset, insn))
+				return -1;
 
 			prev_len = insn->len;
 
@@ -600,7 +582,7 @@ static int init_pv_ops(struct objtool_file *file)
 	};
 	const char *pv_ops;
 	struct symbol *sym;
-	int idx, nr, ret;
+	int idx, nr;
 
 	if (!opts.noinstr)
 		return 0;
@@ -622,9 +604,8 @@ static int init_pv_ops(struct objtool_file *file)
 		INIT_LIST_HEAD(&file->pv_ops[idx].targets);
 
 	for (idx = 0; (pv_ops = pv_ops_tables[idx]); idx++) {
-		ret = add_pv_ops(file, pv_ops);
-		if (ret)
-			return ret;
+		if (add_pv_ops(file, pv_ops))
+			return -1;
 	}
 
 	return 0;
@@ -660,7 +641,7 @@ static int create_static_call_sections(struct objtool_file *file)
 		 * site entries to take advantage of vmlinux static call
 		 * privileges.
 		 */
-		if (!!opts.dryrun || !file->klp)
+		if (!file->klp)
 			WARN("file already has .static_call_sites section, skipping");
 
 		return 0;
@@ -678,8 +659,15 @@ static int create_static_call_sections(struct objtool_file *file)
 	if (!sec)
 		return -1;
 
-	/* Allow modules to modify the low bits of static_call_site::key */
-	sec->sh.sh_flags |= SHF_WRITE;
+	/*
+	 * Set SHF_MERGE to prevent tooling from stripping entsize.
+	 *
+	 * SHF_WRITE would also get set here to allow modules to modify the low
+	 * bits of static_call_site::key, but the LLVM linker doesn't allow
+	 * SHF_MERGE+SHF_WRITE for whatever reason.  That gets fixed up by the
+	 * makefiles with CONFIG_NEED_MODULE_PERMISSIONS_FIX.
+	 */
+	sec->sh.sh_flags |= SHF_MERGE;
 
 	idx = 0;
 	list_for_each_entry(insn, &file->static_call_list, call_node) {
@@ -744,9 +732,7 @@ static int create_retpoline_sites_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, ".retpoline_sites");
 	if (sec) {
-		if (!opts.dryrun)
-			WARN("file already has .retpoline_sites, skipping");
-
+		WARN("file already has .retpoline_sites, skipping");
 		return 0;
 	}
 
@@ -784,9 +770,7 @@ static int create_return_sites_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, ".return_sites");
 	if (sec) {
-		if (!opts.dryrun)
-			WARN("file already has .return_sites, skipping");
-
+		WARN("file already has .return_sites, skipping");
 		return 0;
 	}
 
@@ -824,9 +808,7 @@ static int create_ibt_endbr_seal_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, ".ibt_endbr_seal");
 	if (sec) {
-		if (!opts.dryrun)
-			WARN("file already has .ibt_endbr_seal, skipping");
-
+		WARN("file already has .ibt_endbr_seal, skipping");
 		return 0;
 	}
 
@@ -883,9 +865,7 @@ static int create_cfi_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, ".cfi_sites");
 	if (sec) {
-		if (!opts.dryrun)
-			WARN("file already has .cfi_sites section, skipping");
-
+		WARN("file already has .cfi_sites section, skipping");
 		return 0;
 	}
 
@@ -937,7 +917,7 @@ static int create_mcount_loc_sections(struct objtool_file *file)
 		 * Livepatch modules have already extracted their __mcount_loc
 		 * entries to cover the !CONFIG_FTRACE_MCOUNT_USE_OBJTOOL case.
 		 */
-		if (!opts.dryrun && !file->klp)
+		if (!file->klp)
 			WARN("file already has __mcount_loc section, skipping");
 
 		return 0;
@@ -983,9 +963,7 @@ static int create_direct_call_sections(struct objtool_file *file)
 
 	sec = find_section_by_name(file->elf, ".call_sites");
 	if (sec) {
-		if (!opts.dryrun)
-			WARN("file already has .call_sites section, skipping");
-
+		WARN("file already has .call_sites section, skipping");
 		return 0;
 	}
 
@@ -1548,7 +1526,6 @@ static int add_jump_destinations(struct objtool_file *file)
 {
 	struct instruction *insn;
 	struct reloc *reloc;
-	int ret;
 
 	for_each_insn(file, insn) {
 		struct symbol *func = insn_func(insn);
@@ -1556,7 +1533,6 @@ static int add_jump_destinations(struct objtool_file *file)
 		struct section *dest_sec;
 		struct symbol *dest_sym;
 		unsigned long dest_off;
-		bool dest_undef = false;
 
 		if (!is_static_jump(insn))
 			continue;
@@ -1573,78 +1549,85 @@ static int add_jump_destinations(struct objtool_file *file)
 		if (!reloc) {
 			dest_sec = insn->sec;
 			dest_off = arch_jump_destination(insn);
-		} else if (is_undef_sym(reloc->sym)) {
-			dest_sym = reloc->sym;
-			dest_undef = true;
+			dest_sym = dest_sec->sym;
 		} else {
-			dest_sec = reloc->sym->sec;
-			dest_off = reloc->sym->sym.st_value +
-				   arch_insn_adjusted_addend(insn, reloc);
-		}
-
-		if (!dest_undef) {
-			dest_insn = find_insn(file, dest_sec, dest_off);
-			if (!dest_insn) {
-				struct symbol *sym = find_symbol_by_offset(dest_sec, dest_off);
-
-				/*
-				 * retbleed_untrain_ret() jumps to
-				 * __x86_return_thunk(), but objtool can't find
-				 * the thunk's starting RET instruction,
-				 * because the RET is also in the middle of
-				 * another instruction.  Objtool only knows
-				 * about the outer instruction.
-				 */
-				if (sym && sym->embedded_insn) {
-					add_return_call(file, insn, false);
+			dest_sym = reloc->sym;
+			if (is_undef_sym(dest_sym)) {
+				if (dest_sym->retpoline_thunk) {
+					if (add_retpoline_call(file, insn))
+						return -1;
 					continue;
 				}
 
-				/*
-				 * GCOV/KCOV dead code can jump to the end of
-				 * the function/section.
-				 */
-				if (file->ignore_unreachables && func &&
-				    dest_sec == insn->sec &&
-				    dest_off == func->offset + func->len)
+				if (dest_sym->return_thunk) {
+					add_return_call(file, insn, true);
 					continue;
+				}
 
-				ERROR_INSN(insn, "can't find jump dest instruction at %s+0x%lx",
-					  dest_sec->name, dest_off);
-				return -1;
+				/* External symbol */
+				if (func) {
+					/* External sibling call */
+					if (add_call_dest(file, insn, dest_sym, true))
+						return -1;
+					continue;
+				}
+
+				/* Non-func asm code jumping to external symbol */
+				continue;
 			}
 
+			dest_sec = dest_sym->sec;
+			dest_off = dest_sym->offset + arch_insn_adjusted_addend(insn, reloc);
+		}
+
+		dest_insn = find_insn(file, dest_sec, dest_off);
+		if (!dest_insn) {
+			struct symbol *sym = find_symbol_by_offset(dest_sec, dest_off);
+
+			/*
+			 * retbleed_untrain_ret() jumps to
+			 * __x86_return_thunk(), but objtool can't find
+			 * the thunk's starting RET instruction,
+			 * because the RET is also in the middle of
+			 * another instruction.  Objtool only knows
+			 * about the outer instruction.
+			 */
+			if (sym && sym->embedded_insn) {
+				add_return_call(file, insn, false);
+				continue;
+			}
+
+			/*
+			 * GCOV/KCOV dead code can jump to the end of
+			 * the function/section.
+			 */
+			if (file->ignore_unreachables && func &&
+			    dest_sec == insn->sec &&
+			    dest_off == func->offset + func->len)
+				continue;
+
+			ERROR_INSN(insn, "can't find jump dest instruction at %s",
+				   offstr(dest_sec, dest_off));
+			return -1;
+		}
+
+		if (!dest_sym || is_sec_sym(dest_sym)) {
 			dest_sym = dest_insn->sym;
 			if (!dest_sym)
 				goto set_jump_dest;
 		}
 
-		if (dest_sym->retpoline_thunk) {
-			ret = add_retpoline_call(file, insn);
-			if (ret)
-				return ret;
+		if (dest_sym->retpoline_thunk && dest_insn->offset == dest_sym->offset) {
+			if (add_retpoline_call(file, insn))
+				return -1;
 			continue;
 		}
 
-		if (dest_sym->return_thunk) {
+		if (dest_sym->return_thunk && dest_insn->offset == dest_sym->offset) {
 			add_return_call(file, insn, true);
 			continue;
 		}
 
-		if (dest_undef) {
-			/* External symbol */
-			if (func) {
-				/* External sibling call */
-				ret = add_call_dest(file, insn, dest_sym, true);
-				if (ret)
-					return ret;
-				continue;
-			}
-
-			/* Non-func asm code jumping to external symbol */
-			continue;
-		}
-
 		if (!insn->sym || insn->sym == dest_insn->sym)
 			goto set_jump_dest;
 
@@ -1675,9 +1658,8 @@ static int add_jump_destinations(struct objtool_file *file)
 
 		if (is_first_func_insn(file, dest_insn)) {
 			/* Internal sibling call */
-			ret = add_call_dest(file, insn, dest_sym, true);
-			if (ret)
-				return ret;
+			if (add_call_dest(file, insn, dest_sym, true))
+				return -1;
 			continue;
 		}
 
@@ -1708,7 +1690,6 @@ static int add_call_destinations(struct objtool_file *file)
 	unsigned long dest_off;
 	struct symbol *dest;
 	struct reloc *reloc;
-	int ret;
 
 	for_each_insn(file, insn) {
 		struct symbol *func = insn_func(insn);
@@ -1720,9 +1701,8 @@ static int add_call_destinations(struct objtool_file *file)
 			dest_off = arch_jump_destination(insn);
 			dest = find_call_destination(insn->sec, dest_off);
 
-			ret = add_call_dest(file, insn, dest, false);
-			if (ret)
-				return ret;
+			if (add_call_dest(file, insn, dest, false))
+				return -1;
 
 			if (func && func->ignore)
 				continue;
@@ -1746,19 +1726,16 @@ static int add_call_destinations(struct objtool_file *file)
 				return -1;
 			}
 
-			ret = add_call_dest(file, insn, dest, false);
-			if (ret)
-				return ret;
+			if (add_call_dest(file, insn, dest, false))
+				return -1;
 
 		} else if (reloc->sym->retpoline_thunk) {
-			ret = add_retpoline_call(file, insn);
-			if (ret)
-				return ret;
+			if (add_retpoline_call(file, insn))
+				return -1;
 
 		} else {
-			ret = add_call_dest(file, insn, reloc->sym, false);
-			if (ret)
-				return ret;
+			if (add_call_dest(file, insn, reloc->sym, false))
+				return -1;
 		}
 	}
 
@@ -1976,7 +1953,6 @@ static int add_special_section_alts(struct objtool_file *file)
 	struct instruction *orig_insn, *new_insn;
 	struct special_alt *special_alt, *tmp;
 	struct alternative *alt;
-	int ret;
 
 	if (special_get_alts(file->elf, &special_alts))
 		return -1;
@@ -2008,16 +1984,12 @@ static int add_special_section_alts(struct objtool_file *file)
 				continue;
 			}
 
-			ret = handle_group_alt(file, special_alt, orig_insn,
-					       &new_insn);
-			if (ret)
-				return ret;
+			if (handle_group_alt(file, special_alt, orig_insn, &new_insn))
+				return -1;
 
 		} else if (special_alt->jump_or_nop) {
-			ret = handle_jump_alt(file, special_alt, orig_insn,
-					      &new_insn);
-			if (ret)
-				return ret;
+			if (handle_jump_alt(file, special_alt, orig_insn, &new_insn))
+				return -1;
 		}
 
 		alt = calloc(1, sizeof(*alt));
@@ -2205,15 +2177,13 @@ static int add_func_jump_tables(struct objtool_file *file,
 				  struct symbol *func)
 {
 	struct instruction *insn;
-	int ret;
 
 	func_for_each_insn(file, func, insn) {
 		if (!insn_jump_table(insn))
 			continue;
 
-		ret = add_jump_table(file, insn);
-		if (ret)
-			return ret;
+		if (add_jump_table(file, insn))
+			return -1;
 	}
 
 	return 0;
@@ -2227,7 +2197,6 @@ static int add_func_jump_tables(struct objtool_file *file,
 static int add_jump_table_alts(struct objtool_file *file)
 {
 	struct symbol *func;
-	int ret;
 
 	if (!file->rodata)
 		return 0;
@@ -2237,9 +2206,8 @@ static int add_jump_table_alts(struct objtool_file *file)
 			continue;
 
 		mark_func_jump_tables(file, func);
-		ret = add_func_jump_tables(file, func);
-		if (ret)
-			return ret;
+		if (add_func_jump_tables(file, func))
+			return -1;
 	}
 
 	return 0;
@@ -2356,7 +2324,7 @@ static int read_annotate(struct objtool_file *file,
 	struct instruction *insn;
 	struct reloc *reloc;
 	uint64_t offset;
-	int type, ret;
+	int type;
 
 	sec = find_section_by_name(file->elf, ".discard.annotate_insn");
 	if (!sec)
@@ -2390,9 +2358,8 @@ static int read_annotate(struct objtool_file *file,
 			return -1;
 		}
 
-		ret = func(file, type, insn);
-		if (ret < 0)
-			return ret;
+		if (func(file, type, insn))
+			return -1;
 	}
 
 	return 0;
@@ -2636,70 +2603,57 @@ static bool validate_branch_enabled(void)
 
 static int decode_sections(struct objtool_file *file)
 {
-	int ret;
-
 	file->klp = is_livepatch_module(file);
 
 	mark_rodata(file);
 
-	ret = init_pv_ops(file);
-	if (ret)
-		return ret;
+	if (init_pv_ops(file))
+		return -1;
 
 	/*
 	 * Must be before add_{jump_call}_destination.
 	 */
-	ret = classify_symbols(file);
-	if (ret)
-		return ret;
+	if (classify_symbols(file))
+		return -1;
 
-	ret = decode_instructions(file);
-	if (ret)
-		return ret;
+	if (decode_instructions(file))
+		return -1;
 
-	ret = add_ignores(file);
-	if (ret)
-		return ret;
+	if (add_ignores(file))
+		return -1;
 
 	add_uaccess_safe(file);
 
-	ret = read_annotate(file, __annotate_early);
-	if (ret)
-		return ret;
+	if (read_annotate(file, __annotate_early))
+		return -1;
 
 	/*
 	 * Must be before add_jump_destinations(), which depends on 'func'
 	 * being set for alternatives, to enable proper sibling call detection.
 	 */
 	if (validate_branch_enabled() || opts.noinstr) {
-		ret = add_special_section_alts(file);
-		if (ret)
-			return ret;
+		if (add_special_section_alts(file))
+			return -1;
 	}
 
-	ret = add_jump_destinations(file);
-	if (ret)
-		return ret;
+	if (add_jump_destinations(file))
+		return -1;
 
 	/*
 	 * Must be before add_call_destination(); it changes INSN_CALL to
 	 * INSN_JUMP.
 	 */
-	ret = read_annotate(file, __annotate_ifc);
-	if (ret)
-		return ret;
+	if (read_annotate(file, __annotate_ifc))
+		return -1;
 
-	ret = add_call_destinations(file);
-	if (ret)
-		return ret;
+	if (add_call_destinations(file))
+		return -1;
 
-	ret = add_jump_table_alts(file);
-	if (ret)
-		return ret;
+	if (add_jump_table_alts(file))
+		return -1;
 
-	ret = read_unwind_hints(file);
-	if (ret)
-		return ret;
+	if (read_unwind_hints(file))
+		return -1;
 
 	/* Must be after add_jump_destinations() */
 	mark_holes(file);
@@ -2708,9 +2662,8 @@ static int decode_sections(struct objtool_file *file)
 	 * Must be after add_call_destinations() such that it can override
 	 * dead_end_function() marks.
 	 */
-	ret = read_annotate(file, __annotate_late);
-	if (ret)
-		return ret;
+	if (read_annotate(file, __annotate_late))
+		return -1;
 
 	return 0;
 }
@@ -3464,7 +3417,7 @@ static bool pv_call_dest(struct objtool_file *file, struct instruction *insn)
 	if (!reloc || strcmp(reloc->sym->name, "pv_ops"))
 		return false;
 
-	idx = (arch_insn_adjusted_addend(insn, reloc) / sizeof(void *));
+	idx = arch_insn_adjusted_addend(insn, reloc) / sizeof(void *);
 
 	if (file->pv_ops[idx].clean)
 		return true;
@@ -3692,45 +3645,44 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
 				 struct instruction *insn)
 {
 	struct reloc *reloc = insn_reloc(file, insn);
-	struct symbol *dest = insn_call_dest(insn);
+	unsigned long offset;
+	struct symbol *sym;
 
-	if (dest && !reloc) {
-		checksum_update(func, insn, insn->sec->data->d_buf + insn->offset, 1);
-		checksum_update(func, insn, dest->name, strlen(dest->name));
-	} else if (!insn->fake) {
-		checksum_update(func, insn, insn->sec->data->d_buf + insn->offset, insn->len);
+	if (insn->fake)
+		return;
+
+	checksum_update(func, insn, insn->sec->data->d_buf + insn->offset, insn->len);
+
+	if (!reloc) {
+		struct symbol *call_dest = insn_call_dest(insn);
+
+		if (call_dest)
+			checksum_update(func, insn, call_dest->demangled_name,
+					strlen(call_dest->demangled_name));
+		return;
 	}
 
-	if (reloc) {
-		struct symbol *sym = reloc->sym;
+	sym = reloc->sym;
+	offset = arch_insn_adjusted_addend(insn, reloc);
 
-		if (sym->sec && is_string_sec(sym->sec)) {
-			s64 addend;
-			char *str;
+	if (is_string_sec(sym->sec)) {
+		char *str;
 
-			addend = arch_insn_adjusted_addend(insn, reloc);
-
-			str = sym->sec->data->d_buf + sym->offset + addend;
-
-			checksum_update(func, insn, str, strlen(str));
-
-		} else {
-			u64 offset = arch_insn_adjusted_addend(insn, reloc);
-
-			if (is_sec_sym(sym)) {
-				sym = find_symbol_containing(reloc->sym->sec, offset);
-				if (!sym)
-					return;
-
-				offset -= sym->offset;
-			}
-
-			checksum_update(func, insn, sym->demangled_name,
-					    strlen(sym->demangled_name));
-
-			checksum_update(func, insn, &offset, sizeof(offset));
-		}
+		str = sym->sec->data->d_buf + sym->offset + offset;
+		checksum_update(func, insn, str, strlen(str));
+		return;
 	}
+
+	if (is_sec_sym(sym)) {
+		sym = find_symbol_containing(reloc->sym->sec, offset);
+		if (!sym)
+			return;
+
+		offset -= sym->offset;
+	}
+
+	checksum_update(func, insn, sym->demangled_name, strlen(sym->demangled_name));
+	checksum_update(func, insn, &offset, sizeof(offset));
 }
 
 /*
@@ -4992,9 +4944,11 @@ int check(struct objtool_file *file)
 	if (opts.verbose) {
 		if (opts.werror && warnings)
 			WARN("%d warning(s) upgraded to errors", warnings);
-		print_args();
 		disas_warned_funcs(file);
 	}
 
+	if (opts.backup && make_backup())
+		return 1;
+
 	return ret;
 }
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index ae1c852ff8d8..f9eed5d50de5 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -492,8 +492,8 @@ static int elf_add_symbol(struct elf *elf, struct symbol *sym)
 	elf_hash_add(symbol, &sym->hash, sym->idx);
 	elf_hash_add(symbol_name, &sym->name_hash, str_hash(sym->name));
 
-	if (is_func_sym(sym) && sym->len == 16 &&
-	    (strstarts(sym->name, "__pfx") || strstarts(sym->name, "__cfi_")))
+	if (is_func_sym(sym) &&
+	    (strstarts(sym->name, "__pfx_") || strstarts(sym->name, "__cfi_")))
 		sym->prefix = 1;
 
 	if (strstarts(sym->name, ".klp.sym"))
diff --git a/tools/objtool/include/objtool/builtin.h b/tools/objtool/include/objtool/builtin.h
index e8eb3c54c373..e60438577000 100644
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -30,6 +30,7 @@ struct opts {
 
 	/* options: */
 	bool backtrace;
+	bool backup;
 	const char *debug_checksum;
 	bool dryrun;
 	bool link;
@@ -49,7 +50,7 @@ int cmd_parse_options(int argc, const char **argv, const char * const usage[]);
 
 int objtool_run(int argc, const char **argv);
 
-void print_args(void);
+int make_backup(void);
 
 int cmd_klp(int argc, const char **argv);
 
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index adfe508f96f5..1212f81f40e0 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -17,7 +17,7 @@
 #include <objtool/checksum_types.h>
 #include <arch/elf.h>
 
-#define SEC_NAME_LEN		512
+#define SEC_NAME_LEN		1024
 #define SYM_NAME_LEN		512
 
 #ifdef LIBELF_USE_DEPRECATED
diff --git a/tools/objtool/include/objtool/util.h b/tools/objtool/include/objtool/util.h
new file mode 100644
index 000000000000..a0180b312f73
--- /dev/null
+++ b/tools/objtool/include/objtool/util.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _UTIL_H
+#define _UTIL_H
+
+#include <objtool/warn.h>
+
+#define snprintf_check(str, size, format, args...)			\
+({									\
+	int __ret = snprintf(str, size, format, args);			\
+	if (__ret < 0)							\
+		ERROR_GLIBC("snprintf");				\
+	else if (__ret >= size)						\
+		ERROR("snprintf() failed for '" format "'", args);	\
+	else								\
+		__ret = 0;						\
+	__ret;								\
+})
+
+#endif /* _UTIL_H */
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 144525e74da3..15b554b53da6 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -11,6 +11,7 @@
 #include <objtool/warn.h>
 #include <objtool/arch.h>
 #include <objtool/klp.h>
+#include <objtool/util.h>
 #include <arch/special.h>
 
 #include <linux/livepatch_external.h>
@@ -80,42 +81,11 @@ static char *escape_str(const char *orig)
 	return new;
 }
 
-/*
- * Do a sanity check to make sure the changed object was built with
- * -ffunction-sections and -fdata-sections.
- */
-static int validate_ffunction_fdata_sections(struct elf *elf)
-{
-	struct symbol *sym;
-	bool found_text = false, found_data = false;
-
-	for_each_sym(elf, sym) {
-		char sec_name[SEC_NAME_LEN];
-
-		if (!found_text && is_func_sym(sym)) {
-			snprintf(sec_name, SEC_NAME_LEN, ".text.%s", sym->name);
-			if (!strcmp(sym->sec->name, sec_name))
-				found_text = true;
-		}
-
-		if (!found_data && is_object_sym(sym)) {
-			snprintf(sec_name, SEC_NAME_LEN, ".data.%s", sym->name);
-			if (!strcmp(sym->sec->name, sec_name))
-				found_data = true;
-		}
-
-		if (found_text && found_data)
-			return 0;
-	}
-
-	ERROR("changed object '%s' not built with -ffunction-sections and -fdata-sections", elf->name);
-	return -1;
-}
-
 static int read_exports(void)
 {
 	const char *symvers = "Module.symvers";
 	char line[1024], *path = NULL;
+	unsigned int line_num = 1;
 	FILE *file;
 
 	file = fopen(symvers, "r");
@@ -134,12 +104,12 @@ static int read_exports(void)
 	}
 
 	while (fgets(line, 1024, file)) {
-		char *sym, *mod, *exp;
+		char *sym, *mod, *type;
 		struct export *export;
 
 		sym = strchr(line, '\t');
 		if (!sym) {
-			ERROR("malformed Module.symvers");
+			ERROR("malformed Module.symvers (sym) at line %d", line_num);
 			return -1;
 		}
 
@@ -147,22 +117,22 @@ static int read_exports(void)
 
 		mod = strchr(sym, '\t');
 		if (!mod) {
-			ERROR("malformed Module.symvers");
+			ERROR("malformed Module.symvers (mod) at line %d", line_num);
 			return -1;
 		}
 
 		*mod++ = '\0';
 
-		exp = strchr(mod, '\t');
-		if (!exp) {
-			ERROR("malformed Module.symvers");
+		type = strchr(mod, '\t');
+		if (!type) {
+			ERROR("malformed Module.symvers (type) at line %d", line_num);
 			return -1;
 		}
 
-		*exp++ = '\0';
+		*type++ = '\0';
 
 		if (*sym == '\0' || *mod == '\0') {
-			ERROR("malformed Module.symvers");
+			ERROR("malformed Module.symvers at line %d", line_num);
 			return -1;
 		}
 
@@ -177,6 +147,7 @@ static int read_exports(void)
 			ERROR_GLIBC("strdup");
 			return -1;
 		}
+
 		export->sym = strdup(sym);
 		if (!export->sym) {
 			ERROR_GLIBC("strdup");
@@ -244,18 +215,20 @@ static struct symbol *first_file_symbol(struct elf *elf)
 {
 	struct symbol *sym;
 
-	for_each_sym(elf, sym)
+	for_each_sym(elf, sym) {
 		if (is_file_sym(sym))
 			return sym;
+	}
 
 	return NULL;
 }
 
 static struct symbol *next_file_symbol(struct elf *elf, struct symbol *sym)
 {
-	for_each_sym_continue(elf, sym)
+	for_each_sym_continue(elf, sym) {
 		if (is_file_sym(sym))
 			return sym;
+	}
 
 	return NULL;
 }
@@ -267,11 +240,14 @@ static struct symbol *next_file_symbol(struct elf *elf, struct symbol *sym)
 static bool is_uncorrelated_static_local(struct symbol *sym)
 {
 	static const char * const vars[] = {
-		"__key.",
-		"__warned.",
 		"__already_done.",
 		"__func__.",
+		"__key.",
+		"__warned.",
+		"_entry.",
+		"_entry_ptr.",
 		"_rs.",
+		"descriptor.",
 		"CSWTCH.",
 	};
 
@@ -324,14 +300,19 @@ static bool is_special_section(struct section *sec)
 		SYM_CHECKSUM_SEC,
 	};
 
-	for (int i = 0; i < ARRAY_SIZE(specials); i++)
+	if (is_text_sec(sec))
+		return false;
+
+	for (int i = 0; i < ARRAY_SIZE(specials); i++) {
 		if (!strcmp(sec->name, specials[i]))
 			return true;
+	}
 
-	/* Most .discard sections are special */
-	for (int i = 0; i < ARRAY_SIZE(non_special_discards); i++)
+	/* Most .discard data sections are special */
+	for (int i = 0; i < ARRAY_SIZE(non_special_discards); i++) {
 		if (!strcmp(sec->name, non_special_discards[i]))
 			return false;
+	}
 
 	return strstarts(sec->name, ".discard.");
 }
@@ -347,9 +328,10 @@ static bool is_special_section_aux(struct section *sec)
 		".altinstr_aux",
 	};
 
-	for (int i = 0; i < ARRAY_SIZE(specials_aux); i++)
+	for (int i = 0; i < ARRAY_SIZE(specials_aux); i++) {
 		if (!strcmp(sec->name, specials_aux[i]))
 			return true;
+	}
 
 	return false;
 }
@@ -460,6 +442,7 @@ static int correlate_symbols(struct elfs *e)
 /* "sympos" is used by livepatch to disambiguate duplicate symbol names */
 static unsigned long find_sympos(struct elf *elf, struct symbol *sym)
 {
+	bool vmlinux = str_ends_with(objname, "vmlinux.o");
 	unsigned long sympos = 0, nr_matches = 0;
 	bool has_dup = false;
 	struct symbol *s;
@@ -467,13 +450,43 @@ static unsigned long find_sympos(struct elf *elf, struct symbol *sym)
 	if (sym->bind != STB_LOCAL)
 		return 0;
 
-	for_each_sym(elf, s) {
-		if (!strcmp(s->name, sym->name)) {
-			nr_matches++;
-			if (s == sym)
-				sympos = nr_matches;
-			else
-				has_dup = true;
+	if (vmlinux && sym->type == STT_FUNC) {
+		/*
+		 * HACK: Unfortunately, symbol ordering can differ between
+		 * vmlinux.o and vmlinux due to the linker script emitting
+		 * .text.unlikely* before .text*.  Count .text.unlikely* first.
+		 *
+		 * TODO: Disambiguate symbols more reliably (checksums?)
+		 */
+		for_each_sym(elf, s) {
+			if (strstarts(s->sec->name, ".text.unlikely") &&
+			    !strcmp(s->name, sym->name)) {
+				nr_matches++;
+				if (s == sym)
+					sympos = nr_matches;
+				else
+					has_dup = true;
+			}
+		}
+		for_each_sym(elf, s) {
+			if (!strstarts(s->sec->name, ".text.unlikely") &&
+			    !strcmp(s->name, sym->name)) {
+				nr_matches++;
+				if (s == sym)
+					sympos = nr_matches;
+				else
+					has_dup = true;
+			}
+		}
+	} else {
+		for_each_sym(elf, s) {
+			if (!strcmp(s->name, sym->name)) {
+				nr_matches++;
+				if (s == sym)
+					sympos = nr_matches;
+				else
+					has_dup = true;
+			}
 		}
 	}
 
@@ -565,7 +578,7 @@ static const char *sym_type(struct symbol *sym)
 static const char *sym_bind(struct symbol *sym)
 {
 	switch (sym->bind) {
-	case STB_LOCAL :  return "LOCAL";
+	case STB_LOCAL:   return "LOCAL";
 	case STB_GLOBAL:  return "GLOBAL";
 	case STB_WEAK:    return "WEAK";
 	default:	  return "UNKNOWN";
@@ -727,7 +740,7 @@ static struct export *find_export(struct symbol *sym)
 
 static const char *__find_modname(struct elfs *e)
 {
-	struct section  *sec;
+	struct section *sec;
 	char *name;
 
 	sec = find_section_by_name(e->orig, ".modinfo");
@@ -795,7 +808,7 @@ static bool klp_reloc_needed(struct reloc *patched_reloc)
 
 	/*
 	 * If exported by a module, it has to be a klp reloc.  Thanks to the
-	 * clusterfoot that is late module patching, the patch module is
+	 * clusterfunk that is late module patching, the patch module is
 	 * allowed to be loaded before any modules it depends on.
 	 *
 	 * If exported by vmlinux, a normal reloc will do.
@@ -942,8 +955,9 @@ static int clone_reloc_klp(struct elfs *e, struct reloc *patched_reloc,
 	}
 
 	/* symbol format: .klp.sym.modname.sym_name,sympos */
-	snprintf(sym_name, SYM_NAME_LEN, KLP_SYM_PREFIX "%s.%s,%ld",
-		 sym_modname, sym_orig_name, sympos);
+	if (snprintf_check(sym_name, SYM_NAME_LEN, KLP_SYM_PREFIX "%s.%s,%ld",
+		      sym_modname, sym_orig_name, sympos))
+		return -1;
 
 	klp_sym = find_symbol_by_name(e->out, sym_name);
 	if (!klp_sym) {
@@ -1155,11 +1169,102 @@ static bool should_keep_special_sym(struct elf *elf, struct symbol *sym)
 	return false;
 }
 
+/*
+ * Klp relocations aren't allowed for __jump_table and .static_call_sites if
+ * the referenced symbol lives in a kernel module, because such klp relocs may
+ * be applied after static branch/call init, resulting in code corruption.
+ *
+ * Validate a special section entry to avoid that.  Note that an inert
+ * tracepoint is harmless enough, in that case just skip the entry and print a
+ * warning.  Otherwise, return an error.
+ *
+ * This is only a temporary limitation which will be fixed when livepatch adds
+ * support for submodules: fully self-contained modules which are embedded in
+ * the top-level livepatch module's data and which can be loaded on demand when
+ * their corresponding to-be-patched module gets loaded.  Then klp relocs can
+ * be retired.
+ *
+ * Return:
+ *   -1: error: validation failed
+ *    1: warning: tracepoint skipped
+ *    0: success
+ */
+static int validate_special_section_klp_reloc(struct elfs *e, struct symbol *sym)
+{
+	bool static_branch = !strcmp(sym->sec->name, "__jump_table");
+	bool static_call   = !strcmp(sym->sec->name, ".static_call_sites");
+	struct symbol *code_sym = NULL;
+	unsigned long code_offset = 0;
+	struct reloc *reloc;
+	int ret = 0;
+
+	if (!static_branch && !static_call)
+		return 0;
+
+	sym_for_each_reloc(e->patched, sym, reloc) {
+		const char *sym_modname;
+		struct export *export;
+
+		/* Static branch/call keys are always STT_OBJECT */
+		if (reloc->sym->type != STT_OBJECT) {
+
+			/* Save code location which can be printed below */
+			if (reloc->sym->type == STT_FUNC && !code_sym) {
+				code_sym = reloc->sym;
+				code_offset = reloc_addend(reloc);
+			}
+
+			continue;
+		}
+
+		if (!klp_reloc_needed(reloc))
+			continue;
+
+		export = find_export(reloc->sym);
+		if (export) {
+			sym_modname = export->mod;
+		} else {
+			sym_modname = find_modname(e);
+			if (!sym_modname)
+				return -1;
+		}
+
+		/* vmlinux keys are ok */
+		if (!strcmp(sym_modname, "vmlinux"))
+			continue;
+
+		if (static_branch) {
+			if (strstarts(reloc->sym->name, "__tracepoint_")) {
+				WARN("%s: disabling unsupported tracepoint %s",
+				     code_sym->name, reloc->sym->name + 13);
+				ret = 1;
+				continue;
+			}
+
+			ERROR("%s+0x%lx: unsupported static branch key %s.  Use static_key_enabled() instead",
+			      code_sym->name, code_offset, reloc->sym->name);
+			return -1;
+		}
+
+		/* static call */
+		if (strstarts(reloc->sym->name, "__SCK__tp_func_")) {
+			ret = 1;
+			continue;
+		}
+
+		ERROR("%s()+0x%lx: unsupported static call key %s.  Use KLP_STATIC_CALL() instead",
+		      code_sym->name, code_offset, reloc->sym->name);
+		return -1;
+	}
+
+	return ret;
+}
+
 static int special_section_entry_size(struct section *sec)
 {
 	unsigned int reloc_size;
 
-	if (sec->sh.sh_entsize)
+	if ((sec->sh.sh_flags & SHF_MERGE) && sec->sh.sh_entsize)
 		return sec->sh.sh_entsize;
 
 	if (!sec->rsec)
@@ -1176,12 +1281,13 @@ static int special_section_entry_size(struct section *sec)
 static int create_fake_symbol(struct elf *elf, struct section *sec,
 			      unsigned long offset, size_t size)
 {
+	char name[SYM_NAME_LEN];
 	unsigned int type;
-	char name[256];
 	static int ctr;
 	char *c;
 
-	snprintf(name, 256, "__DISCARD_%s_%d", sec->name, ctr++);
+	if (snprintf_check(name, SYM_NAME_LEN, "__DISCARD_%s_%d", sec->name, ctr++))
+		return -1;
 
 	for (c = name; *c; c++)
 		if (*c == '.')
@@ -1206,7 +1312,15 @@ static int clone_special_section(struct elfs *e, struct section *patched_sec)
 
 	entry_size = special_section_entry_size(patched_sec);
 	if (!entry_size) {
-		ERROR("%s: unknown entry size", patched_sec->name);
+		/*
+		 * Any special section more complex than a simple array of
+		 * pointers must have its entry size specified in sh_entsize
+		 * (and the SHF_MERGE flag set so the linker preserves it).
+		 *
+		 * Clang older than version 20 doesn't properly preserve
+		 * sh_entsize and will error out here.
+		 */
+		ERROR("%s: buggy linker and/or missing sh_entsize", patched_sec->name);
 		return -1;
 	}
 
@@ -1242,12 +1356,20 @@ static int clone_special_section(struct elfs *e, struct section *patched_sec)
 	 * reference included functions.
 	 */
 	sec_for_each_sym(patched_sec, patched_sym) {
+		int ret;
+
 		if (!is_object_sym(patched_sym))
 			continue;
 
 		if (!should_keep_special_sym(e->patched, patched_sym))
 			continue;
 
+		ret = validate_special_section_klp_reloc(e, patched_sym);
+		if (ret < 0)
+			return -1;
+		if (ret > 0)
+			continue;
+
 		if (!clone_symbol(e, patched_sym, true))
 			return -1;
 	}
@@ -1388,7 +1510,9 @@ static int create_klp_sections(struct elfs *e)
 	 * friends, and add them to the klp object.
 	 */
 
-	snprintf(sym_name, SYM_NAME_LEN, KLP_PRE_PATCH_PREFIX "%s", modname);
+	if (snprintf_check(sym_name, SYM_NAME_LEN, KLP_PRE_PATCH_PREFIX "%s", modname))
+		return -1;
+
 	sym = find_symbol_by_name(e->out, sym_name);
 	if (sym) {
 		struct reloc *reloc;
@@ -1402,7 +1526,9 @@ static int create_klp_sections(struct elfs *e)
 			return -1;
 	}
 
-	snprintf(sym_name, SYM_NAME_LEN, KLP_POST_PATCH_PREFIX "%s", modname);
+	if (snprintf_check(sym_name, SYM_NAME_LEN, KLP_POST_PATCH_PREFIX "%s", modname))
+		return -1;
+
 	sym = find_symbol_by_name(e->out, sym_name);
 	if (sym) {
 		struct reloc *reloc;
@@ -1416,7 +1542,9 @@ static int create_klp_sections(struct elfs *e)
 			return -1;
 	}
 
-	snprintf(sym_name, SYM_NAME_LEN, KLP_PRE_UNPATCH_PREFIX "%s", modname);
+	if (snprintf_check(sym_name, SYM_NAME_LEN, KLP_PRE_UNPATCH_PREFIX "%s", modname))
+		return -1;
+
 	sym = find_symbol_by_name(e->out, sym_name);
 	if (sym) {
 		struct reloc *reloc;
@@ -1430,7 +1558,9 @@ static int create_klp_sections(struct elfs *e)
 			return -1;
 	}
 
-	snprintf(sym_name, SYM_NAME_LEN, KLP_POST_UNPATCH_PREFIX "%s", modname);
+	if (snprintf_check(sym_name, SYM_NAME_LEN, KLP_POST_UNPATCH_PREFIX "%s", modname))
+		return -1;
+
 	sym = find_symbol_by_name(e->out, sym_name);
 	if (sym) {
 		struct reloc *reloc;
@@ -1447,6 +1577,51 @@ static int create_klp_sections(struct elfs *e)
 	return 0;
 }
 
+/*
+ * Copy all .modinfo import_ns= tags to ensure all namespaced exported symbols
+ * can be accessed via normal relocs.
+ */
+static int copy_import_ns(struct elfs *e)
+{
+	struct section *patched_sec, *out_sec = NULL;
+	char *import_ns, *data_end;
+
+	patched_sec = find_section_by_name(e->patched, ".modinfo");
+	if (!patched_sec)
+		return 0;
+
+	import_ns = patched_sec->data->d_buf;
+	if (!import_ns)
+		return 0;
+
+	for (data_end = import_ns + sec_size(patched_sec);
+	     import_ns < data_end;
+	     import_ns += strlen(import_ns) + 1) {
+
+		import_ns = memmem(import_ns, data_end - import_ns, "import_ns=", 10);
+		if (!import_ns)
+			return 0;
+
+		if (!out_sec) {
+			out_sec = find_section_by_name(e->out, ".modinfo");
+			if (!out_sec) {
+				out_sec = elf_create_section(e->out, ".modinfo", 0,
+							     patched_sec->sh.sh_entsize,
+							     patched_sec->sh.sh_type,
+							     patched_sec->sh.sh_addralign,
+							     patched_sec->sh.sh_flags);
+				if (!out_sec)
+					return -1;
+			}
+		}
+
+		if (!elf_add_data(e->out, out_sec, import_ns, strlen(import_ns) + 1))
+			return -1;
+	}
+
+	return 0;
+}
+
 int cmd_klp_diff(int argc, const char **argv)
 {
 	struct elfs e = {0};
@@ -1479,10 +1654,6 @@ int cmd_klp_diff(int argc, const char **argv)
 	if (mark_changed_functions(&e))
 		return 0;
 
-	if (validate_ffunction_fdata_sections(e.orig) ||
-	    validate_ffunction_fdata_sections(e.patched))
-		return -1;
-
 	e.out = elf_create_file(&e.orig->ehdr, argv[2]);
 	if (!e.out)
 		return -1;
@@ -1496,9 +1667,11 @@ int cmd_klp_diff(int argc, const char **argv)
 	if (create_klp_sections(&e))
 		return -1;
 
+	if (copy_import_ns(&e))
+		return -1;
+
 	if  (elf_write(e.out))
 		return -1;
 
 	return elf_close(e.out);
 }
-
diff --git a/tools/objtool/klp-post-link.c b/tools/objtool/klp-post-link.c
index 05be6251e35f..c013e39957b1 100644
--- a/tools/objtool/klp-post-link.c
+++ b/tools/objtool/klp-post-link.c
@@ -16,6 +16,7 @@
 #include <objtool/objtool.h>
 #include <objtool/warn.h>
 #include <objtool/klp.h>
+#include <objtool/util.h>
 #include <linux/livepatch_external.h>
 
 static int fix_klp_relocs(struct elf *elf)
@@ -81,8 +82,10 @@ static int fix_klp_relocs(struct elf *elf)
 		 */
 
 		/* section format: .klp.rela.sec_objname.section_name */
-		snprintf(rsec_name, SEC_NAME_LEN, KLP_RELOC_SEC_PREFIX "%s.%s",
-			 sym_modname, sec->name);
+		if (snprintf_check(rsec_name, SEC_NAME_LEN,
+				   KLP_RELOC_SEC_PREFIX "%s.%s",
+				   sym_modname, sec->name))
+			return -1;
 
 		klp_rsec = find_section_by_name(elf, rsec_name);
 		if (!klp_rsec) {
diff --git a/tools/objtool/special.c b/tools/objtool/special.c
index 9cfdd424e173..fc2cf8dba1c0 100644
--- a/tools/objtool/special.c
+++ b/tools/objtool/special.c
@@ -133,7 +133,7 @@ int special_get_alts(struct elf *elf, struct list_head *alts)
 	struct section *sec;
 	unsigned int nr_entries;
 	struct special_alt *alt;
-	int idx, ret;
+	int idx;
 
 	INIT_LIST_HEAD(alts);
 
@@ -157,11 +157,8 @@ int special_get_alts(struct elf *elf, struct list_head *alts)
 			}
 			memset(alt, 0, sizeof(*alt));
 
-			ret = get_alt_entry(elf, entry, sec, idx, alt);
-			if (ret > 0)
-				continue;
-			if (ret < 0)
-				return ret;
+			if (get_alt_entry(elf, entry, sec, idx, alt))
+				return -1;
 
 			list_add_tail(&alt->list, alts);
 		}

