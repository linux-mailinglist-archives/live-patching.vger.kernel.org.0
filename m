Return-Path: <live-patching+bounces-2897-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WD2PA3jlFmpIvAcAu9opvQ
	(envelope-from <live-patching+bounces-2897-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 14:37:12 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 569D05E443B
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 14:37:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4BBB43001C71
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 12:35:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A9D33F5BCF;
	Wed, 27 May 2026 12:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="FDyCNlVh"
X-Original-To: live-patching@vger.kernel.org
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EBD396573;
	Wed, 27 May 2026 12:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779885340; cv=none; b=p3FqqlyqRjcWOYF1+vq9vQ38TKR2o018w1amo39k8/4lgCnHTjl//kq44yM7/1TNrzVW//esOkZtQABPerYStACEYmmjqUz3btsDy/md4LmXfKfEnuwmwCWy2DR5BREe4WF9lBjaaJv0pxFlpeuFAx8Hj/s9/LownWOfscU6hHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779885340; c=relaxed/simple;
	bh=QNwiOuhyTWr+Ox33PE8kwKfbhzpl6N48E9qhoZXjXsc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SnwOYXzbpPXxw/CS5PhaBaM5WO1LlQZHyqBPdktOQCWHNZX1ujbuGD3m2hqf2ocN09YJY++KbAwgeQo1pSo1cdT+NF6ewXsJmEpp4/bf+frXigwxnQQ86vsFyV1Gt+lih2/RMar9Jh6aXAgFoBTcMRhkIOqLg9Hjz2UEPm4Buvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=FDyCNlVh; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779885334; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=jbjuGf+IXHrtw5IpG3dTHqRw4vxGFjsQYv+ha2pTkws=;
	b=FDyCNlVhYNDOmUofVP1lk3dxnxYEKIlXjS6oslHfa4EVTJ94UB0ra8xn+q2qnFxU/i8aJhwPpxnXPzbiYBux9OhUy47MmcM4k7pv9j0zLXKSbNb5FZBWI/mIErWXmJlvfYk/UtMO4F98uqVwy68g5OxYShBF1db0HZoo1GKjpH0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=wanghan@linux.alibaba.com;NM=1;PH=DS;RN=30;SR=0;TI=SMTPD_---0X3jh19m_1779885331;
Received: from wanghan-Workstation..(mailfrom:wanghan@linux.alibaba.com fp:SMTPD_---0X3jh19m_1779885331 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 27 May 2026 20:35:32 +0800
From: Wang Han <wanghan@linux.alibaba.com>
To: Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Pei <cp0613@linux.alibaba.com>,
	Andy Chiu <andybnac@gmail.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Deepak Gupta <debug@rivosinc.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: [PATCH 0/8] riscv: Add reliable stack unwinding for livepatch
Date: Wed, 27 May 2026 20:35:22 +0800
Message-ID: <20260527123530.2593918-1-wanghan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2897-lists,live-patching=lfdr.de];
	FREEMAIL_CC(0.00)[ghiti.fr,goodmis.org,kernel.org,arm.com,linux.alibaba.com,gmail.com,rivosinc.com,microchip.com,suse.cz,suse.com,redhat.com,infradead.org,lists.infradead.org,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[30];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[wanghan@linux.alibaba.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,linux.alibaba.com:mid,linux.alibaba.com:dkim]
X-Rspamd-Queue-Id: 569D05E443B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Problem
=======

Livepatch relies on HAVE_RELIABLE_STACKTRACE to decide whether a task
can safely switch to a patched implementation. RISC-V has a
frame-pointer stack walker, but it is not yet reliable enough for
livepatch. Three pieces are missing:

  * arch_stack_walk_reliable() itself, plus the strict stack-bound
    checks and forward-progress invariants a reliable unwinder needs.
  * Explicit unwind metadata at exception, task-entry and IRQ-stack
    boundaries, so the unwinder can distinguish a final user-to-kernel
    transition from a nested kernel pt_regs frame instead of guessing
    from return addresses.
  * Agreement between the ftrace function-graph, perf callchain and
    mcount paths and the same frame-record assumptions used by the
    reliable unwinder.

There is also a prerequisite ftrace issue on the current riscv/for-next
base. Commit 0ca1724b56af ("riscv: ftrace: select
HAVE_BUILDTIME_MCOUNT_SORT") enabled build-time sorting of the mcount
table. RISC-V uses patchable function entries, and the recorded patch
site is placed before the function symbol. scripts/sorttable currently
does not take that RISC-V layout into account, so valid ftrace sites
can be filtered out before the kernel boots.

Solution
========

Patch 1 fixes scripts/sorttable so the RISC-V build-time mcount sort
path accepts patchable function entries which precede the function
symbol. The fix carries a Fixes: tag for commit 0ca1724b56af ("riscv:
ftrace: select HAVE_BUILDTIME_MCOUNT_SORT") and is otherwise
independent; it can be picked into the RISC-V tree on its own if
preferred.

Patches 2-7 add the reliable unwinder in small, individually
reviewable steps. The design follows the same FP + metadata model
arm64 already uses for livepatch in production: the metadata frame
record in pt_regs, the unwind-state stack-bound bookkeeping, the
exception boundary handling, and the fgraph / kretprobe return-address
recovery are direct adaptations of arch/arm64/kernel/stacktrace.c,
retargeted to the RISC-V {fp, ra} frame record convention.

  * Patch 2 adds frame-record metadata for the RISC-V stack walker.
    Low-level entry and task setup code records whether a frame is a
    normal frame, an exception frame, or a task-entry boundary, so the
    reliable unwinder can validate what it is walking instead of
    guessing from the return address.
  * Patch 3 stops KASAN from instrumenting stacktrace.o, matching the
    arm, arm64 and x86 treatment of their stack unwinding code.
  * Patch 4 always preserves s0 in the dynamic ftrace register frame so
    the unwinder can use the architectural frame pointer as the
    function-graph return-address cookie regardless of FP_TEST.
  * Patch 5 introduces stack_info / unwind_state and the
    forward-progress-only stack-bound helpers that the reliable
    unwinder is built on. No caller is wired up yet.
  * Patch 6 switches arch_stack_walk() to the new frame-pointer based
    unwinder, adds arch_stack_walk_reliable() (still without an
    in-tree caller), routes perf callchains through arch_stack_walk(),
    and updates the function-graph cookie to match.
  * Patch 7 selects HAVE_RELIABLE_STACKTRACE and HAVE_LIVEPATCH under
    FRAME_POINTER && 64BIT and exposes the livepatch menu, finally
    enabling livepatch on RISC-V.

Two alternative directions were considered and deferred:

  * ORC, as used on x86, gives reliable unwinding without runtime FP
    cost, but requires RISC-V objtool stack validation, ORC metadata
    generation, and the runtime ORC unwinder. That is a much larger
    dependency chain than what this series adds.

  * SFrame is the more likely long-term replacement for FP-based
    unwinding on architectures without ORC. Kernel SFrame support is
    still under development and the currently documented SFrame ABI
    set does not cover RISC-V, so making RISC-V livepatch depend on
    SFrame would block it on toolchain and kernel infrastructure that
    is not available yet. SFrame is a replacement rather than an
    extension of the metadata frame record introduced here, so when it
    lands the metadata can be retired together with the FP unwinder.
    The interim cost (~24 bytes added to pt_regs and a handful of
    instructions on exception entry, fork and early init) is bounded
    and limited to FRAME_POINTER=y configurations, which is what the
    RISC-V kernel already builds with for stack tracing today.
    Selecting HAVE_RELIABLE_STACKTRACE under FRAME_POINTER && 64BIT
    therefore does not introduce a new build-time dependency relative
    to the status quo.

This is useful now because livepatch is increasingly important for
long-running server deployments where rebooting for critical fixes is
expensive, and recent RISC-V work (dynamic ftrace and patchable
function entries) has put the rest of the livepatch infrastructure in
place.

Module-side klp relocations rely on the existing RISC-V
apply_relocate_add(); the syscall livepatch selftest exercises the
full klp_apply_section_relocs() -> apply_relocate_add() path on RISC-V.

Patch 8 adds the RISC-V syscall wrapper prefix used by the livepatch
syscall selftest module. Without this, the syscall livepatch selftest
cannot resolve the expected target symbol on RISC-V.

Testing
=======

The series is based on riscv/for-next commit 0ca1724b56af ("riscv:
ftrace: select HAVE_BUILDTIME_MCOUNT_SORT").

Build and static checks:

  * git diff --check riscv/for-next..HEAD
  * scripts/checkpatch.pl --strict for each patch
  * RISC-V Image and modules build clean with:
      - gcc 15.2 (riscv64-unknown-linux-gnu-)
      - LLVM=1 clang 18.1.3
      - LLVM=1 clang 21.1.1
  * Each intermediate commit (patches 1-7) was built individually on
    riscv/for-next to confirm bisectability; all 7 intermediate trees
    plus the final HEAD compile clean.
  * livepatch selftest module build

The unfixed build-time sort path was reproduced under QEMU:

  ftrace: allocating 0 entries in 128 pages
  Testing tracer function: .. no entries found ..FAILED!
  Failed to init function_graph tracer, init returned -19

With the sorttable fix applied, the same QEMU boot finds the expected
ftrace entries and the ftrace startup tests pass:

  ftrace: allocating 46749 entries in 184 pages
  Testing tracer function: PASSED
  Testing dynamic ftrace: PASSED
  Testing tracer function_graph: PASSED

With all eight patches applied, RISC-V QEMU virt boots with SMP=2,
SMP=4, and SMP=8 completed the livepatch and tracing smoke tests. The
livepatch selftest result was the same in all runs:

  livepatch selftests: PASS: 7, SKIP: 1, FAIL: 0

Across these boots, the kernel brought up the requested CPU count and
the startup ftrace tests passed, including dynamic ftrace and
function_graph. The function graph selftests reported passed: 3,
failed: 0, unsupported: 3, and LKDTM WARNING_MESSAGE produced the
expected Call Trace and powered off normally.

The livepatch selftest skip is test-kprobe.sh. The test requires
CONFIG_KPROBES_ON_FTRACE, which is not provided by the current RISC-V
configuration.

Wang Han (8):
  scripts/sorttable: Handle RISC-V patchable ftrace entries
  riscv: stacktrace: Add frame record metadata
  riscv: stacktrace: disable KASAN instrumentation for stacktrace.o
  riscv: ftrace: always preserve s0 in dynamic ftrace register frame
  riscv: stacktrace: introduce stack-bound tracking helpers
  riscv: stacktrace: switch to frame-pointer based unwinder
  riscv: Kconfig: enable HAVE_RELIABLE_STACKTRACE and HAVE_LIVEPATCH
  selftests/livepatch: Add RISC-V syscall wrapper prefix

 arch/riscv/Kconfig                            |   4 +
 arch/riscv/include/asm/ptrace.h               |   9 +
 arch/riscv/include/asm/stacktrace.h           |  65 +-
 arch/riscv/include/asm/stacktrace/common.h    | 159 +++++
 arch/riscv/include/asm/stacktrace/frame.h     |  53 ++
 arch/riscv/kernel/Makefile                    |   5 +
 arch/riscv/kernel/asm-offsets.c               |   4 +
 arch/riscv/kernel/entry.S                     |  30 +-
 arch/riscv/kernel/ftrace.c                    |   6 +-
 arch/riscv/kernel/head.S                      |  23 +
 arch/riscv/kernel/mcount-dyn.S                |   4 -
 arch/riscv/kernel/perf_callchain.c            |   2 +-
 arch/riscv/kernel/process.c                   |  31 +-
 arch/riscv/kernel/stacktrace.c                | 560 +++++++++++++++---
 scripts/sorttable.c                           |   8 +-
 .../livepatch/test_modules/test_klp_syscall.c |   2 +
 16 files changed, 856 insertions(+), 109 deletions(-)
 create mode 100644 arch/riscv/include/asm/stacktrace/common.h
 create mode 100644 arch/riscv/include/asm/stacktrace/frame.h

-- 
2.43.0


