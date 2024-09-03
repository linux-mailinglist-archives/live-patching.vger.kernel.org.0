Return-Path: <live-patching+bounces-534-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A840696926A
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:00:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2DCEF1F233B5
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:00:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5A8F45003;
	Tue,  3 Sep 2024 04:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lZ//cwH9"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887642A1CA;
	Tue,  3 Sep 2024 04:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336029; cv=none; b=Ye+IYzDGWbDmIN+g6Lfonydqf7OXyDjyuFG6klcFQ3/oyMazPZrzdSZKujDxEAK968xYmqgQwMkFm04jhcQ2cOHBRK7NCV8pKk8SClelwrim8loS9hY+aB2cAzpOnAMQVsY0URcs3wSRW6iVRwmrXbNz4nMwBXFkArB/RzLtve0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336029; c=relaxed/simple;
	bh=LQfg1VzcDwJ3gm6jVtsTgxwWpZDCtBC0zgWadHHdIq0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hSrF4Oo2q7bEq0//W6S5msjQ+vIb4CjZ91IXJqcBbUxiHlWU//r8kUat2L7wsLnjFVc+rlHcq2qFmlS0pmMuV9IZ0Qn1wxGKtK3NSE56ZhWtbgTNbB8WphcLlBmW/a33mzvDXgLIY1gMPsx3sayS6rxG+dcdcz3vLv+DHUgpgP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lZ//cwH9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900BFC4CEC5;
	Tue,  3 Sep 2024 04:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336029;
	bh=LQfg1VzcDwJ3gm6jVtsTgxwWpZDCtBC0zgWadHHdIq0=;
	h=From:To:Cc:Subject:Date:From;
	b=lZ//cwH98Ji3wXjofTtRQbcOaObGwLuVhWrW+HgkdwKWrzlHDXfLovHrWDeQFqouD
	 IFlLh6BjFlXAwFAIGspqYhI3rflMgXc7DTGAC/SGp6JCuWP4PhsfFBM2ZpWfD/wGiW
	 eaXxwDPbUgMWxkdnw4A/Ek/pxHFSVe3/AbAFTWB54ZlWprimmmPAUCb/Ew5DMUvnGd
	 dVsmCL5u0g4NnvZSiUvp4EXuqZsX3tz/yGNPXYXV2ibqdw9OwJMO5ZGbtuepvMzL1N
	 xocXBCdsvzrG0xom8aHuxKwZ3ncBT8nNrMcWv5sVM+xRvVQi2NHnBJtRgIrHkOB4br
	 aQyGDNJzO73Qw==
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
Subject: [RFC 00/31] objtool, livepatch: Livepatch module generation
Date: Mon,  2 Sep 2024 20:59:43 -0700
Message-ID: <cover.1725334260.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Here's a new way to build livepatch modules called klp-build.

I started working on it when I realized that objtool already does 99% of
the work needed for detecting function changes.

This is similar in concept to kpatch-build, but the implementation is
much cleaner.

Personally I still have reservations about the "source-based" approach
(klp-convert and friends), including the fragility and performance
concerns of -flive-patching.  I would submit that klp-build might be
considered the "official" way to make livepatch modules.

Please try it out and let me know what you think.  Based on v6.10.

Also avaiable at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git klp-build-rfc

More details (cribbed from the big final patch):

------

Add a klp-build script which makes use of a new "objtool klp" subcommand
to generate livepatch modules using a source patch as input.

The concept is similar to kpatch-build which has been a successful
out-of-tree project for over a decade.  It takes a source .patch as an
input, builds kernels before and after, does a binary diff, and copies
any changed functions into a new object file which is then linked into a
livepatch module.

By making use of existing objtool functionality, and taking from lessons
learned over the last decade of maintaining kpatch-build, the overall
design is much simpler.  In fact, it's a complete redesign and has been
written from scratch (no copied code).

Advantages over kpatch-build:

  - Runs on vmlinux.o, so it's compatible with late-linked features like
    IBT and LTO

  - Much simpler design: ~3k fewer LOC

  - Makes use of existing objtool CFG functionality to create checksums
    for trivially detecting changed functions

  - Offset __LINE__ changes are no longer a problem thanks to the
    adjust-patch-lines script

  - In-tree means less cruft, easier maintenance, and a larger pool of
    potential maintainers

To use, run the following from the kernel source root:

  scripts/livepatch/klp-build /path/to/my.patch

If it succeeds, the patch module (livepatch.ko) will be created in the
current directory.

TODO:

  - specify module name on cmdline
  - handle edge cases like correlation of static locals
  - support other arches (currently x86-64 only)
  - support clang
  - performance optimization
  - automated testing
  - documentation

Josh Poimboeuf (31):
  x86/alternative: Refactor INT3 call emulation selftest
  x86/module: Improve relocation error messages
  x86/kprobes: Remove STACK_FRAME_NON_STANDARD annotation
  kernel/sys: Don't reference UTS_RELEASE directly
  x86/compiler: Tweak __UNIQUE_ID naming
  elfnote: Use __UNIQUE_ID() for note symbols
  kbuild: Remove "kmod" prefix from __KBUILD_MODNAME
  objtool: Remove .parainstructions reference
  objtool: Const string cleanup
  objtool: Use 'struct elf' in elf macros
  objtool: Add section/symbol type helpers
  objtool: 'objname' refactoring
  objtool: Support references to all symbol types in special sections
  objtool: Refactor add_jump_destinations()
  objtool: Interval tree cleanups
  objtool: Simplify fatal error handling
  objtool: Open up the elf API
  objtool: Disallow duplicate prefix symbols
  objtool: Add elf_create_file()
  objtool: Add UD1 detection
  objtool: Fix x86 addend calcuation
  objtool: Make find_symbol_containing() less arbitrary
  objtool: Handle __pa_symbol() relocations
  objtool: Make STACK_FRAME_NON_STANDARD consistent
  objtool: Fix interval tree insertion for zero-length symbols
  objtool: Make interval tree functions "static inline"
  objtool: Fix weak symbol detection
  x86/alternative: Create symbols for special section entries
  objtool: Calculate function checksums
  livepatch: Enable -ffunction-sections -fdata-sections
  objtool, livepatch: Livepatch module generation

 .gitignore                              |    3 +
 Makefile                                |    9 +
 arch/x86/include/asm/alternative.h      |   50 +-
 arch/x86/include/asm/asm.h              |   24 +-
 arch/x86/include/asm/bug.h              |    2 +
 arch/x86/include/asm/cpufeature.h       |    2 +
 arch/x86/include/asm/jump_label.h       |    2 +
 arch/x86/kernel/alternative.c           |   51 +-
 arch/x86/kernel/kprobes/opt.c           |    4 -
 arch/x86/kernel/module.c                |   15 +-
 include/asm-generic/vmlinux.lds.h       |    2 +-
 include/linux/compiler.h                |    8 +-
 include/linux/elfnote.h                 |   12 +-
 include/linux/init.h                    |    3 +-
 include/linux/livepatch.h               |   25 +-
 include/linux/livepatch_ext.h           |   83 ++
 include/linux/livepatch_patch.h         |   73 ++
 include/linux/objtool.h                 |   38 +-
 kernel/livepatch/core.c                 |    8 +-
 kernel/sys.c                            |    2 +-
 scripts/Makefile.lib                    |    5 +-
 scripts/livepatch/adjust-patch-lines    |  181 +++
 scripts/livepatch/klp-build             |  355 ++++++
 scripts/livepatch/module.c              |  120 ++
 scripts/module.lds.S                    |   22 +-
 tools/include/linux/livepatch_ext.h     |   83 ++
 tools/objtool/Build                     |    4 +-
 tools/objtool/Makefile                  |   34 +-
 tools/objtool/arch/loongarch/decode.c   |    6 +-
 tools/objtool/arch/loongarch/orc.c      |   30 +-
 tools/objtool/arch/powerpc/decode.c     |    6 +-
 tools/objtool/arch/x86/decode.c         |  118 +-
 tools/objtool/arch/x86/orc.c            |   27 +-
 tools/objtool/arch/x86/special.c        |    2 +-
 tools/objtool/builtin-check.c           |   66 +-
 tools/objtool/check.c                   | 1414 ++++++++++-------------
 tools/objtool/elf.c                     | 1059 +++++++++--------
 tools/objtool/include/objtool/arch.h    |    5 +-
 tools/objtool/include/objtool/builtin.h |    4 +-
 tools/objtool/include/objtool/check.h   |    5 +-
 tools/objtool/include/objtool/elf.h     |  156 ++-
 tools/objtool/include/objtool/klp.h     |   25 +
 tools/objtool/include/objtool/objtool.h |    6 +-
 tools/objtool/include/objtool/orc.h     |   10 +-
 tools/objtool/include/objtool/special.h |    2 +-
 tools/objtool/include/objtool/warn.h    |   50 +-
 tools/objtool/klp-diff.c                | 1112 ++++++++++++++++++
 tools/objtool/klp-link.c                |  122 ++
 tools/objtool/klp.c                     |   57 +
 tools/objtool/objtool.c                 |   78 +-
 tools/objtool/orc_dump.c                |  100 +-
 tools/objtool/orc_gen.c                 |   48 +-
 tools/objtool/special.c                 |   58 +-
 tools/objtool/sync-check.sh             |    1 +
 tools/objtool/weak.c                    |   11 +-
 55 files changed, 4076 insertions(+), 1722 deletions(-)
 create mode 100644 include/linux/livepatch_ext.h
 create mode 100644 include/linux/livepatch_patch.h
 create mode 100755 scripts/livepatch/adjust-patch-lines
 create mode 100755 scripts/livepatch/klp-build
 create mode 100644 scripts/livepatch/module.c
 create mode 100644 tools/include/linux/livepatch_ext.h
 create mode 100644 tools/objtool/include/objtool/klp.h
 create mode 100644 tools/objtool/klp-diff.c
 create mode 100644 tools/objtool/klp-link.c
 create mode 100644 tools/objtool/klp.c

-- 
2.45.2


