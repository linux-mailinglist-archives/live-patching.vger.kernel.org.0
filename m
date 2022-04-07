Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10DD4F8A30
	for <lists+live-patching@lfdr.de>; Fri,  8 Apr 2022 00:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiDGUkR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 7 Apr 2022 16:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiDGUjn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 7 Apr 2022 16:39:43 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B449D353AB5;
        Thu,  7 Apr 2022 13:26:00 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 88709201CBCC;
        Thu,  7 Apr 2022 13:25:59 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 88709201CBCC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1649363160;
        bh=/gfnb0ak0fJCGgoV6dpwvVzvCrTJZ1mbTfaolXv/xtU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=a+M9AdFPGSGfc6wvwQBk6Nrs4evgpoKBcgIBI3b8Hme9b3EX0+srFKXkaEwk+pV31
         qfzAHizR8wxJ/JhgoTGbtnUPqmT4KNkQK1Cmu6pMNo+6YfOKGDak23KbN3My0sx7GP
         LlFvErgm+WstXZv05NSpJ6AD0anHxNY70K2DEG0Y=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v1 0/9] arm64: livepatch: Use DWARF Call Frame Information for frame pointer validation
Date:   Thu,  7 Apr 2022 15:25:09 -0500
Message-Id: <20220407202518.19780-1-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

Introduction
============

The livepatch feature requires an unwinder that can provide a reliable stack
trace. General requirements for a reliable unwinder are described in this
document from Mark Rutland:

	Documentation/livepatch/reliable-stacktrace.rst

The requirements have two parts:

1. The unwinder must be enhanced with certain features. E.g.,

	- Identifying successful termination of stack trace
	- Identifying unwindable and non-unwindable code
	- Identifying interrupts and exceptions occurring in the frame pointer
	  prolog and epilog
	- Identifying features such as kretprobe and ftrace graph tracing
	  that can modify the return address stored on the stack
	- Identifying corrupted/unreliable stack contents
	- Architecture-specific items that can render a stack trace unreliable
	  at certain points in code

	Some of these features are already in the arm64 unwinder. I am pursuing
	the rest in another patch series. This is work in progress. The latest
	submission as of this writing is here:

https://lore.kernel.org/linux-arm-kernel/20220117145608.6781-1-madvenka@linux.microsoft.com/T/#t

2. Validation of the frame pointer

	This assumes that the unwinder is based on the frame pointer (FP).
	The actual frame pointer that the unwinder uses cannot just be
	assumed to be correct. It needs to be validated somehow.

	This patch series is to address this requirement.

Validation of the FP (aka STACK_VALIDATION)
====================

The current approach in Linux is to use objtool, a build time tool, for this
purpose. When configured, objtool is invoked on every relocatable object file
during kernel build. It performs static analysis of the code in each file. It
walks the instructions in every function and notes the changes to the stack
pointer (SP) and the frame pointer (FP). It makes sure that the changes are in
accordance with the ABI rules. Once objtool completes successfully, the kernel
can then be used for livepatch purposes.

Objtool can have uses other than just FP validation. For instance, it can check
control flow integrity during its analysis.

Problem
=======

Objtool is complex and highly architecture-dependent. It presents a great
challenge to support livepatch on an architecture. We need an alternative
solution for livepatch, preferably one that is largely architecture
independent.

A different approach
====================

I would like to propose a different approach for FP validation - one that is
simpler as well as architecture-independent for the most part. This initial
work is for arm64. But it can easily be extended to other architectures.

In this approach, objtool is used to generate data for the unwinder. The
unwinder uses the data during a stack trace to validate the FP in each
frame. In other words, the FP is validated dynamically and not statically
at build time.

Background for the solution
===========================

DWARF is a debugging file format used by many compilers and debuggers to
support source level debugging. One of the components of DWARF is the
DWARF Call Frame Information (CFI). A special section called .debug_frame
is generated by the compiler to contain CFI. CFI supplies all the rules
required to compute the contents of every register at every instruction
address. A complete unwinder can be built from CFI.

However, DWARF is complex and building a complete unwinder from DWARF CFI
is a ship that has already sailed. That is not the purpose of this patch
series.

The solution
============

The goal here is to use the absolute minimum CFI needed to compute the FP at
every instruction address. The unwinder can compute the FP in each frame,
compare the actual FP with the computed one and validate the actual FP.

Objtool is enhanced to parse the CFI, extract just the rules required,
encode them in compact data structures and create special sections for
the rules. The unwinder uses the special sections to find the rules for
a given instruction address and compute the FP.

Objtool can be invoked as follows:

	objtool dwarf generate <object-file>

The version of the DWARF standard supported in this work is version 4. The
official documentation for this version is here:

	https://dwarfstd.org/doc/DWARF4.pdf

Section 6.4 contains the description of the CFI.

Register rules in CFI
=====================

CFI defines the Canonical Frame Address (CFA) as the value of the stack
pointer (SP) when a call instruction is executed. For the called function,
register values are expressed relative to the CFA.

DWARF CFI defines the following rules to obtain the value of a register
in the previous frame, given a current frame:

1. Same_Value:

	The current and previous values of the register are the same.

2. Val_Offset(N):

	The previous value is (CFA + N) where N is a signed offset.

3. Offset(N):

	The previous value is saved at (CFA + N).

4. register(R):

	The previous value is saved in register R.

5. Val_Expression(E):

	The previous value is the value produced by evaluating a given
	DWARF expression. DWARF expressions are evaluated on a stack. That
	is, operands are pushed and popped on a stack, DWARF operators are
	applied on them and the result is obtained.

6. Expression(E):

	The previous value is stored at the address computed from a DWARF
	expression.

7. Architectural:

	The previous value is obtained in an architecture-specific way via
	an architecture-specific "augmentor". Augmentors are vendor specific
	and are not part of the DWARF standard.

The minimum CFI needed for this work
====================================

Fortunately, gcc and clang only generate rules (1), (2) and (3) for the
SP, FP and return address (RA). So, this implementation only supports these
3 rules. These are very simple rules. At the time of this writing, these
rules are found to be sufficient for ARM, ARM64 and RISCV.

As an exercise, I also ran my CFI parser on X64. For a very small percentage
of the functions, DWARF expressions are indeed used. Of course, X64 already
has a complete objtool-based static stack validation scheme. So, X64 does
not need this.

I have not checked other architectures so far.

Compact encoding of CFI
=======================

The CFI is defined in a very generic format to allow all of the above rules
to be defined. Since this work uses only a minimal subset of the rules, the
supported CFI rules can be encoded in a more compact format. Also, this
subset of the rules can be statically evaluated at build time by objtool.
The kernel does not have to do any CFI parsing.

Unsupported rules
=================

There are three main reasons why I chose not to support rules (4) thru (7).

	- the compiler does not generate these for the SP, FP and RA for
	  arm64. So, arm64 does not need them.

	- They have complexity.

	- Objtool may not be able to do all the work for rules (4) thru (7).
	  The kernel may be required to evaluate expressions that involve
	  dereferencing an address, getting the value stored in a register,
	  etc.

That does not mean that they cannot be supported. But supporting them would
increase the complexity. I strongly suggest that this work be used only for
architectures where all of the parsing and record generation can be done in
objtool at build time. The kernel part of the implementation should be kept
simple.

How to deal with unsupported rules, if they are present?
========================================================

objtool does not generate any rule data for the code locations at which
unsupported rules exist. When the unwinder tries to find a rule for any of
these locations, it will not find any. Then, it will simply consider the
code locations unreliable from an unwind perspective. The requirement for
the unwinder is really that it must be able to identify reliable and
unreliable code. It can still do this.

So, livepatch can be supported even on architectures where unsupported rules
are generated by the compiler. It only means that the code ranges that contain
those rules will be considered unreliable by the unwinder. If they occur in
frequently used functions, then it is definitely a problem. If not, they may
result in some retries during the livepatch process. But livepatch can still
be done.

FP prolog, epilog and leaf functions
====================================

DWARF CFI rules allow objtool to recognize these cases. Objtool does not
generate any rule data for a function unless the frame is completely setup. If
an interrupt or an exception happens in code where the frame is not set up
or not set up completely, the unwinder will not find the rules for such code.
Automatically, the stack trace is considered unreliable as it should be.

Assembly functions
==================

DWARF CFI is generated by the compiler only for C functions. This means that
the unwinder will not find any rules for assembly code. So, assembly functions
are automatically considered unreliable from an unwind perspective.

For assembly functions, DWARF annotations are defined that can be placed in
assembly code. In that case, DWARF CFI can be generated for assembly functions
as well. However, DWARF annotations are a PITA to maintain. So, this is not
a good path to go down.

Now, there are certain points in assembly code that we would like to unwind
through reliably. Like interrupt and exception handlers. This is mainly for
getting reliable stack traces in these cases and reducing the number of
retries during the livepatch process. For these, unwind hints can be placed
at strategic points in assembly code. Only a small number of these hints
should be needed.

In this work, I have defined the following unwind hints so stack traces that
contain these can be done reliably:

	- Exception handlers
	- Interrupt handlers
	- FTrace tracer functions
	- FTrace graph return prepare code
	- FTrace callsites
	- Kretprobe Trampoline

Unwind hints are collected in a special section. Objtool converts unwind hints
to rule data just like the CFI based ones. The kernel does not need special
code to process unwind hints.

Generated code
==============

Generated code will not have any DWARF rules. Such code will be considered
unreliable by the kernel.

Size of the memory consumed within the kernel for this feature
==============================================================

This depends on the amount of code in the kernel which, in turn, depends on
the number of configs turned on. E.g., on the kernel on my arm64 system, the
.debug_frame section generated by the compiler in vmlinux is about 3.42 MB.
But the rule data generated by objtool for vmlinux is only about 1.06 MB.

Architecture-dependent part
===========================

The following architecture-dependent items must be supplied to support
an architecture:

	- Mapping from DWARF register numbers to actual registers. This is
	  required only for the SP and FP (and RA, if the architecture
	  defines an RA register).

	- Relocation information for the special section created by objtool.
	  Relocation types are processor-specific.

	- Architecture-specific rule checking. For instance, the return
	  address and the frame pointer are saved on adjacent locations
	  on the stack for arm64. This is checked by an arm64-specific
	  rule checker during CFI parsing.

The architecture dependent portion is very small.

Items like endianness and address size are already handled in generic code.

GitHub repository
=================

I have created a github repo to share my work. For each version I will create
a branch. For version 1, it is here:

https://github.com/madvenka786/linux/tree/dwarftool_v1

Please feel free to clone and check it out. And, please let me know if you
find any issues.

Testing
=======

I have run all of the livepatch selftests successfully. I have written a
couple of extra selftests myself which I will be posting separately.

There is an open source utility called dwarfdump. It parses the CFI and
produces ASCII output of the same. I have written a tool to extract that
information and compare it with what my parser generates. The comparison
is successful. So, the parser has been well tested.

I have extracted the same instruction addresses from vmlinux and fed
them to the lookup function in the kernel that the unwinder uses. I have
verified that the correct CFI rules are looked up for every single
input address. So, the lookup function has been well tested.

TBD
===

- Objtool generates a table of instruction addresses or PCs for the kernel.
  These need to be sorted for doing an efficient binary search. Currently,
  the sorting is done in the kernel during boot. I will add support to the
  sorttable script so that the sorting can be done at build time.

- I need to perform more rigorous testing with different scenarios. This
  is work in progress. Any ideas or suggestions are welcome.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>

Madhavan T. Venkataraman (9):
  objtool: Parse DWARF Call Frame Information in object files
  objtool: Generate DWARF rules and place them in a special section
  dwarf: Build the kernel with DWARF information
  dwarf: Implement DWARF rule processing in the kernel
  dwarf: Implement DWARF support for modules
  arm64: unwinder: Add a reliability check in the unwinder based on
    DWARF CFI
  arm64: dwarf: Implement unwind hints
  dwarf: Enable livepatch for ARM64

Suraj Jitindar Singh (1):
  dwarf: Miscellaneous changes required for enabling livepatch

 arch/Kconfig                                  |   4 +-
 arch/arm64/Kconfig                            |   7 +
 arch/arm64/Kconfig.debug                      |   5 +
 arch/arm64/configs/defconfig                  |   1 +
 arch/arm64/include/asm/livepatch.h            |  42 ++
 arch/arm64/include/asm/sections.h             |   4 +
 arch/arm64/include/asm/stacktrace.h           |   9 +
 arch/arm64/include/asm/thread_info.h          |   4 +-
 arch/arm64/include/asm/unwind_hints.h         |  28 +
 arch/arm64/kernel/entry-ftrace.S              |  23 +
 arch/arm64/kernel/entry.S                     |   3 +
 arch/arm64/kernel/ftrace.c                    |  16 +
 arch/arm64/kernel/probes/kprobes_trampoline.S |   2 +
 arch/arm64/kernel/signal.c                    |   4 +
 arch/arm64/kernel/stacktrace.c                | 131 ++++
 arch/arm64/kernel/vmlinux.lds.S               |  22 +
 include/linux/dwarf.h                         |  90 +++
 include/linux/ftrace.h                        |   4 +
 include/linux/module.h                        |   3 +
 kernel/Makefile                               |   1 +
 kernel/dwarf_fp.c                             | 305 ++++++++++
 kernel/module.c                               |  31 +
 scripts/Makefile.build                        |   4 +
 scripts/link-vmlinux.sh                       |   6 +
 tools/include/linux/dwarf.h                   |  90 +++
 tools/objtool/Build                           |   5 +
 tools/objtool/Makefile                        |  10 +-
 tools/objtool/arch/arm64/Build                |   2 +
 tools/objtool/arch/arm64/dwarf_arch.c         | 114 ++++
 tools/objtool/arch/arm64/dwarf_clang.c        |  53 ++
 .../arch/arm64/include/arch/dwarf_reg.h       |  17 +
 tools/objtool/builtin-dwarf.c                 |  75 +++
 tools/objtool/dwarf_op.c                      | 560 ++++++++++++++++++
 tools/objtool/dwarf_parse.c                   | 351 +++++++++++
 tools/objtool/dwarf_rules.c                   | 265 +++++++++
 tools/objtool/dwarf_util.c                    | 280 +++++++++
 tools/objtool/elf.c                           |   2 +-
 tools/objtool/include/objtool/builtin.h       |   1 +
 tools/objtool/include/objtool/dwarf_def.h     | 460 ++++++++++++++
 tools/objtool/include/objtool/elf.h           |   1 +
 tools/objtool/include/objtool/objtool.h       |   3 +
 tools/objtool/objtool.c                       |   1 +
 tools/objtool/sync-check.sh                   |   6 +
 tools/objtool/weak.c                          |  38 ++
 44 files changed, 3079 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm64/include/asm/livepatch.h
 create mode 100644 arch/arm64/include/asm/unwind_hints.h
 create mode 100644 include/linux/dwarf.h
 create mode 100644 kernel/dwarf_fp.c
 create mode 100644 tools/include/linux/dwarf.h
 create mode 100644 tools/objtool/arch/arm64/Build
 create mode 100644 tools/objtool/arch/arm64/dwarf_arch.c
 create mode 100644 tools/objtool/arch/arm64/dwarf_clang.c
 create mode 100644 tools/objtool/arch/arm64/include/arch/dwarf_reg.h
 create mode 100644 tools/objtool/builtin-dwarf.c
 create mode 100644 tools/objtool/dwarf_op.c
 create mode 100644 tools/objtool/dwarf_parse.c
 create mode 100644 tools/objtool/dwarf_rules.c
 create mode 100644 tools/objtool/dwarf_util.c
 create mode 100644 tools/objtool/include/objtool/dwarf_def.h


base-commit: fc74e0a40e4f9fd0468e34045b0c45bba11dcbb2
-- 
2.25.1

