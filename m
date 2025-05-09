Return-Path: <live-patching+bounces-1359-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 36630AB1DCA
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:17:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B01C1C20020
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:17:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C79825EF90;
	Fri,  9 May 2025 20:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R+bTI0A9"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DB62253B2;
	Fri,  9 May 2025 20:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821864; cv=none; b=WxqXilOSCOPs+5Od8r79VyKUcugUev0wcCMenVTfLV1njrwYfoe86sgZz1LCxrabl+NkOcqP8RVAy4Fiz3vLw5gC+9lhmRs4aVdyfY3JJUT9Wjpn/puXQPrFD56rsQ7VghIe7jeM7k2ekD0RhERvgyYNT6W8hY1/O0gnToXOttk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821864; c=relaxed/simple;
	bh=jvCgnEom86R9s4T48Jf10jBoMDXPjyacuB1Yv0QhXjM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s7AS9HOy9wlTosQWOv/u0AEhKhgB562VT4FsUry6a15DbmjBRtfaPL87KzHy+L6YSo4FqmiVeY0WhBFVqzGPku7PujocI1Ujd+a0rpeVwoXRRw0TErRkWQV1rT6VQQt/cyBU/NtIryC1CHlGj+kP/lPTnRYAT9zjKMzeW6pj8Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R+bTI0A9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DADDC4CEE4;
	Fri,  9 May 2025 20:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821863;
	bh=jvCgnEom86R9s4T48Jf10jBoMDXPjyacuB1Yv0QhXjM=;
	h=From:To:Cc:Subject:Date:From;
	b=R+bTI0A9ggTAb8/0JYpSwPGuefA4+4BXUIg9rxxkaprBsCkx7Us1NMaAgXZEDAEYq
	 xfZFO526cygBkAUfh1Ka9RuTpbE+d76F9aiO0v+NTpq9/fUn0SB44r/zTVJv5HChKY
	 93dGeyEm5maLULKZM3ADPmk3vA/JGJv3XAIB9xLGGf1SrJsA6uf+koi1XuGr6HVXT6
	 2S2vLDOzX1PpPhRMRzcq0NtyhiuWxsYXR8dq27RbuqZluIuAEJFYq5rCSTw01RZHS6
	 g4v+Nive33aZ9Gjk9nl8v2NwOBQEuOsx7xWZSX9PT65oTV5Te2ebjcrnKLEadc+ehQ
	 hBgQwWhBM1UPg==
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
	Puranjay Mohan <puranjay@kernel.org>
Subject: [PATCH v2 00/62] objtool,livepatch: klp-build livepatch module generation
Date: Fri,  9 May 2025 13:16:24 -0700
Message-ID: <cover.1746821544.git.jpoimboe@kernel.org>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git klp-build-v2

Please test!

[1] https://github.com/dynup/kpatch


Changes since the RFC: https://lore.kernel.org/cover.1725334260.git.jpoimboe@kernel.org
- Too many to list.  Doubled the patch count exactly ;-)


Josh Poimboeuf (62):
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
  objtool: Speed up SHT_GROUP reindexing
  objtool: Fix broken error handling in read_symbols()
  objtool: Propagate elf_truncate_section() error in elf_write()
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
  objtool: Suppress section skipping warnings with --dryrun
  objtool: Rename --Werror to --werror
  objtool: Reindent check_options[]
  objtool: Refactor add_jump_destinations()
  objtool: Simplify special symbol handling in elf_update_symbol()
  objtool: Generalize elf_create_symbol()
  objtool: Generalize elf_create_section()
  objtool: Add elf_create_data()
  objtool: Introduce elf_create_reloc() and elf_init_reloc()
  objtool: Add elf_create_file()
  kbuild,x86: Fix module permissions for __jump_table and __bug_table
  x86/alternative: Define ELF section entry size for alternatives
  x86/jump_label: Define ELF section entry size for jump table
  x86/extable: Define ELF section entry size for exception tables
  x86/bug: Define ELF section entry size for the bug table
  x86/orc: Define ELF section entry size for unwind hints
  objtool: Make STACK_FRAME_NON_STANDARD consistent
  kbuild,objtool: Defer objtool validation step for CONFIG_LIVEPATCH
  objtool/klp: Add --checksum option to generate per-function checksums
  objtool/klp: Add --debug-checksum=<funcs> to show per-instruction
    checksums
  objtool/klp: Introduce klp diff subcommand for diffing object files
  objtool/klp: Add --debug option to show cloning decisions
  objtool/klp: Add post-link subcommand to finalize livepatch modules
  objtool: Disallow duplicate prefix symbols
  objtool: Add base objtool support for livepatch modules
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
 arch/x86/Kconfig                              |    1 +
 arch/x86/include/asm/alternative.h            |    7 +-
 arch/x86/include/asm/asm.h                    |   20 +-
 arch/x86/include/asm/bug.h                    |   44 +-
 arch/x86/include/asm/jump_label.h             |   32 +-
 arch/x86/kernel/alternative.c                 |   53 +-
 arch/x86/kernel/kprobes/opt.c                 |    4 -
 arch/x86/kernel/module.c                      |   15 +-
 arch/x86/kernel/unwind_orc.c                  |    2 +
 include/asm-generic/vmlinux.lds.h             |   40 +-
 include/linux/compiler.h                      |    8 +-
 include/linux/elfnote.h                       |   13 +-
 include/linux/init.h                          |    3 +-
 include/linux/jump_label.h                    |   20 +-
 include/linux/livepatch.h                     |   25 +-
 include/linux/livepatch_external.h            |   76 +
 include/linux/livepatch_helpers.h             |   68 +
 include/linux/objtool.h                       |   16 +-
 kernel/extable.c                              |    2 +
 kernel/livepatch/core.c                       |    8 +-
 scripts/Makefile.lib                          |    6 +-
 scripts/Makefile.modfinal                     |   18 +-
 scripts/Makefile.vmlinux_o                    |    2 +-
 scripts/link-vmlinux.sh                       |    3 +-
 scripts/livepatch/fix-patch-lines             |   79 +
 scripts/livepatch/init.c                      |  108 ++
 scripts/livepatch/klp-build                   |  781 +++++++++
 scripts/mod/modpost.c                         |    5 +
 scripts/module.lds.S                          |   26 +-
 tools/include/linux/interval_tree_generic.h   |    2 +-
 tools/include/linux/livepatch_external.h      |   76 +
 tools/objtool/Build                           |    4 +-
 tools/objtool/Makefile                        |   48 +-
 tools/objtool/arch/loongarch/decode.c         |    6 +-
 tools/objtool/arch/powerpc/decode.c           |    6 +-
 tools/objtool/arch/x86/decode.c               |   68 +-
 tools/objtool/arch/x86/special.c              |    2 +-
 tools/objtool/builtin-check.c                 |   70 +-
 tools/objtool/builtin-klp.c                   |   53 +
 tools/objtool/check.c                         |  690 +++++---
 tools/objtool/elf.c                           |  812 ++++++---
 tools/objtool/include/objtool/arch.h          |    5 +-
 tools/objtool/include/objtool/builtin.h       |    6 +-
 tools/objtool/include/objtool/check.h         |    6 +-
 tools/objtool/include/objtool/checksum.h      |   43 +
 .../objtool/include/objtool/checksum_types.h  |   25 +
 tools/objtool/include/objtool/elf.h           |  186 +-
 tools/objtool/include/objtool/klp.h           |   35 +
 tools/objtool/include/objtool/objtool.h       |    6 +-
 tools/objtool/include/objtool/warn.h          |   40 +
 tools/objtool/klp-diff.c                      | 1504 +++++++++++++++++
 tools/objtool/klp-post-link.c                 |  165 ++
 tools/objtool/objtool.c                       |   42 +-
 tools/objtool/orc_gen.c                       |    8 +-
 tools/objtool/special.c                       |    4 +-
 tools/objtool/sync-check.sh                   |    1 +
 tools/objtool/weak.c                          |    7 +
 61 files changed, 4687 insertions(+), 728 deletions(-)
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
 create mode 100644 tools/objtool/klp-diff.c
 create mode 100644 tools/objtool/klp-post-link.c

-- 
2.49.0


