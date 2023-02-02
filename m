Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD3B687684
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 08:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjBBHm3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 02:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbjBBHm2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 02:42:28 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C654E6E43A;
        Wed,  1 Feb 2023 23:42:25 -0800 (PST)
Received: from x64host.home (unknown [47.187.213.40])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9FE4120B7102;
        Wed,  1 Feb 2023 23:42:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9FE4120B7102
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675323745;
        bh=erpmqUPsJuKpGVNMqt2Yh5TP1OUBoO5MLZPE7Xxnw7w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=l/VBH8LcBbAYr6zTDdULfONe6oNnISAadLGYHRJeYt+GgRz9yHPNq8jMrCY/m7Phn
         LTYdO7KG8t3aaqqmKfHa2ypGzbuoX0tawkyX0kKOxMXd/njRH0VMnjfxq/5vQzi1Fe
         KZOBO936NCFTrGb4tF7CN9dNoa2XSIYNK8bW7ynY=
From:   madvenka@linux.microsoft.com
To:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame pointer validation
Date:   Thu,  2 Feb 2023 01:40:14 -0600
Message-Id: <20230202074036.507249-1-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
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

2. Validation of the frame pointer

	This assumes that the unwinder is based on the frame pointer (FP).
	The actual frame pointer that the unwinder uses cannot just be
	assumed to be correct. It needs to be validated somehow.

This patch series is to address the following:

	- Identifying unwindable and non-unwindable code
	- Identifying interrupts and exceptions occurring in the frame pointer
	  prolog and epilog
	- Validation of the frame pointer

The rest are already in place AFAICT.

Validation of the FP (aka FRAME_POINTER_VALIDATION)
====================

The current approach in Linux is to use objtool, a build time tool, for this
purpose. When configured, objtool is invoked on every relocatable object file
during kernel build. It performs static analysis of the code in each file. It
walks the instructions in every function and notes the changes to the stack
pointer (SP) and the frame pointer (FP). It makes sure that the changes are in
accordance with the ABI rules. There are also a lot of other checks that
Objtool performs. Once objtool completes successfully, the kernel can then be
used for livepatch purposes.

Objtool can have uses other than just FP validation. For instance, it can check
control flow integrity during its analysis.

Problem
=======

Objtool is complex and highly architecture-dependent. There are a lot of
different checks in objtool that all of the code in the kernel must pass
before livepatch can be enabled. If a check fails, it must be corrected
before we can proceed. Sometimes, the kernel code needs to be fixed.
Sometimes, it is a compiler bug that needs to be fixed. The challenge is
also to prove that all the work is complete for an architecture.

As such, it presents a great challenge to enable livepatch for an
architecture.

A different approach
====================

I would like to propose a different approach for FP validation. I would
like to be able to enable livepatch for an architecture as is. That is,
without "fixing" the kernel or the compiler for it:

There are three steps in this:

1. Objtool walks all the functions as usual. It computes the stack and
   frame pointer offsets at each instruction as usual. It generates ORC
   records and stores them in special sections as usual. This is simple
   enough to do.

2. Objtool performs validation of the offsets (see below) and checks
   if the frame is properly set up according to ABI rules. But the set
   of checks performed are a whole lot simpler than the existing Objtool
   checks for X86.
   
3. The unwinder in the kernel retrieves the ORC record for each PC in a
   stack trace. If there is no ORC record or if the ORC data indicates that
   a frame pointer has not been set up, the unwinder considers the stack
   frame unreliable. Otherwise, the unwinder computes a frame pointer from
   the ORC data. It compares the computed frame pointer with the actual
   frame pointer. If there is a match, the frame is reliable. If not, it
   isn't. A stack trace is reliable if every single frame in it is reliable.

   To summarize, the frame pointer validation is done dynamically instead
   of statically.

Using this scheme, the unwinder can always know what kernel code is reliable
for unwind and what is not. This is the requirement for livepatch.

Instruction decoder
===================

To do this, an instruction decoder needs to be implemented. I have implemented
a simple, table-driven decoder for ARM64. Only a subset of the instructions
needs to be fully decoded for this purpose:

	- Load-Store instructions
	- Add/Sub/Mov instructions
	- Branch instructions
	- Call instructions
	- Return instructions
	- Stack pointer authentication instruction

The rest of the instructions are either dont-care from an unwind perspective
or unexpected from the compiler. I have added checks for the unexpected ones
to catch them if the compiler ever generates them.

This decoder is simpler than a full-fledged one. But if a full-fledged one
is ever implemented, my decoder can be subsumed by it.

Code reorganization and reuse
=============================

Stack validation scheme
-----------------------

Currently, the stack validation scheme supported in Objtool is static stack
validation. Static stack validation is performed in check.c. There is a lot
of code in check.c that should be shared with other validation schemes such
as the dynamic FP validation scheme that I am proposing. Accordingly, I have
moved that code into separate files:

	- Code that walks instructions and decodes them
	- Code that manages instructions
	- CFI related code
	- Code that handles unwind hints

So, all of this is shared across all architectures and validation schemes.

Architecture-dependent code
---------------------------

Currently, the ORC definitions and code are X86-specific. I have separated
out the architecture-specific stuff from the generic stuff and placed
them in appropriate files so other architectures can share.

So, these are the architecture-specific parts that need to be supplied for
a new architecture for my proposal. Everything else is shared.

	- Instruction decoder as mentioned above
	- ORC register definitions
	- ORC support functions
	- Unwind hint support
	- Invoke ORC init from kernel initialization code
	- Invoke ORC init from module initialization code
	- Add ORC_UNWIND_TABLE to kernel data in vmlinux.lds.S
	- Modify the unwinder to use ORC data to validate the frame pointer
	- Add kernel config definitions for reliable stack trace and livepatch

Other than the decoder, all of this is very simple to do. Just follow the
example in ARM64.

For ARM64, the decoder turned out to be fairly simple. I cannot speak to
other architectures.

sorttable
---------

At build time, the ORC tables in special sections are sorted so that the
kernel does not have to spend time sorting them. The tables need to be
sorted for binary search. The sorttable program works without any change
in my proposal as well.

FP prolog, epilog, leaf functions, generated code, etc
======================================================

If the unwinder is not able to find an ORC record for a given instruction
address, it considers the code to be unreliable from an unwind perspective.
This enables the unwinder to deal with:

	- Generated code that will not have any ORC records.

If the unwinder finds an ORC record, but the record indicates that a frame
pointer has not been properly set up at that instruction, then the unwinder
considers that instruction unreliable from an unwind perspective. This enables
the unwinder to deal with:

	- Low level assembly code (SYM_CODE) that is not walked by Objtool.
	  See below.

	- Interrupts/exceptions in frame pointer prologs and epilogs.

	- Interrupts/exceptions in leaf functions that don't have a frame
	  setup.

	- Compiler not setting up the frame pointer properly before calling
	  a function. E.g., if inline assembly code occurs at the beginning
	  of a function and it contains a call.

If the unwinder finds an ORC record and the record indicates that a frame
pointer has been properly set up, then it computes a frame pointer from the
ORC data and compares it with the actual frame pointer. If the computed frame
pointer does not match the actual one, it considers the code to be unreliable
from an unwind perspective. This enables the unwinder to detect:

	- Cases where runtime patching of the kernel resulted in a change in
	  the ORC for an instruction

	- A corrupted frame pointer

Assembly functions
==================

Objtool does not walk SYM_CODE functions as they are low-level functions
that don't follow ABI rules or functions that manipulate register state
in such a way that unwind is unreliable. For these the ORC records will
show that the frame offset is 0. So, the unwinder will be able to tell that
they are unreliable for unwind.

As for SYM_FUNC functions, Objtool will walk them and compute ORC. However,
currently, most of the SYM_FUNC functions in ARM64 do not setup a frame.
So, these will look unreliable to the unwinder. While this will not impact
the ability to do livepatch, I plan to submit a separate patch series to add
a frame pointer prolog and epilog to many of these functions. This is to
reduce the number of retries during the livepatch process.

Unwind hints
============

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

Unwind hints are collected in a special section. Objtool converts unwind hints
to ORC data. The unwinder processes unwind hints to handle special cases
mentioned above.

Now, unwind hints are generally a problem to maintain. So, I have only
defined them for the above cases.

Size of the memory consumed within the kernel for this feature
==============================================================

This depends on the amount of code in the kernel which, in turn, depends on
the number of configs turned on. E.g., on the kernel on my arm64 system, the
ORC data size for vmlinux is about 2MB.

GitHub repository
=================

My github repo for this version is here:

https://github.com/madvenka786/linux/tree/orc_v3

Please feel free to clone and check it out. And, please let me know if you
find any issues.

Testing
=======

- I have run all of the livepatch selftests successfully. I have written a
  couple of extra selftests myself which I will be posting separately.

- I have a test driver to induce a NULL pointer exception to make sure
  that unwinding through exception handlers is reliable.

- I use the test driver to create a timer to make sure that unwinding through
  the timer IRQ is reliable.

- I call the unwinder from different places during boot to make sure that
  the unwinding in each of those cases is reliable.

TBD
===

- I need to perform more rigorous testing with different scenarios. This
  is work in progress. Any ideas or suggestions are welcome.

- I plan to add a return address check in the unwinder. The unwinder will
  decode the instruction at the call site for each frame and make sure that
  it is a valid call instruction. This is just a paranoid check to catch it
  if Objtool generates an incorrect ORC entry or if the FP is corrupted.
---
Changelog:

v3:
	From Mark Brown <broonie@kernel.org>
	====================================

	Objtool no longer uses sub commands.

		I have addressed this. Objtool calls check() to perform
		all the validation. I have defined a check() function for
		the Dynamic FP Validation feature. Based on the config,
		the correct files will be included so that there is only
		one check() defined within Objtool.

	From Chen Zhongjin <chenzhongjin@huawei.com>
	============================================

	No need to rewrite the decoder. Merge the decoder with my patch.

		My decoder is table based. So, it is very compact. Also,
		in that table, I have included checks for the instructions
		that alter the stack or frame pointers that the compiler
		should not be using. This catches all the cases where the
		compiler generates unexpected code. So, for now, I am
		keeping my decoder.

		But your point is a good one. May be, in the future, our
		decoders can be merged. Currently, both patchsets are
		relatively new. It is not as if either has received
		enough review.

	From Peter Zijlstra <peterz@infradead.org>
	==========================================================

	Why can't you use the validate_branch() defined currently?
	Why do you want to define your own?

		Originally, I responded to this comment by saying that
		I will use validate_branch(). I studied it. It will probably
		take a long time for all the pieces to be in place for the
		current validate_branch() to work for ARM64. So, I have taken
		a different approach to try to shorten the time to market.

		In my approach, I generate the ORC data based on the actual
		code by walking all the instructions and following all the
		code paths statically.

		Now, a hidden code path may not be followed during my
		static analysis. E.g.,
		
			- a retpoline is obscuring an actual branch

			- runtime patching can potentially change a code path

		In most of the cases, even if these things occur, the ORC data
		will not change. In the unlikely event that ORC data can be
		different for an instruction because of the above, the unwinder
		will handle that. There are two cases:

		1) The SP offset or the FP offset is zero in the generated ORC.

		2) The SP offset and the FP offset are both non-zero in the
		   generated ORC.

		In case (1), the unwinder will return an error right away
		and the stack trace will be considered unreliable. So,
		livepatch has to retry.

		In case (2), the unwinder will detect the problem because the
		computed frame pointer will not match the actual one. So,
		livepatch has to retry.

		As long as the number of such retries is small, livepatch can
		easily be supported with this approach.

		AFAICT, the only way this will not work is if the actual frame
		pointer gets corrupted because of buggy kernel code and just
		happens to match the computed frame pointer. According to an
		earlier comment from Josh (IIRC), corruption of the frame
		pointer in the kernel is a super rare event. Even if it does
		occur, the frame pointer getting corrupted in a fashion that
		it exactly matches the computed frame pointer should be even
		rarer.

		Even if that were to happen, the unwinder checks must pass for
		every frame in the stack trace. This will not happen if the
		frame pointer is corrupted along the way.

		Also, if the kernel has buggy code that can corrupt the frame
		pointer, then all bets are off anyway.

		If you find any holes here, please let me know. I will work
		on it some more. Appreciate your feedback.

		I have added a number of checks to validate the CFI since
		version 2. They are described in:

[RFC PATCH v3 13/21] objtool: arm64: Walk instructions and compute CFI for each instruction

		FWIW, I have also compared the CFI I am generating with DWARF
		information that the compiler generates. The CFIs match a
		100% for Clang. In the case of gcc, the comparison fails
		in 1.7% of the cases. I have analyzed those cases and found
		the DWARF information generated by gcc is incorrect. The
		ORC generated by my Objtool is correct.

	From Miroslav Benes <mbenes@suse.cz>
	====================================

	klp_arch_set_pc() has been replaced by ftrace_instruction_pointer_set().
	klp_get_ftrace_location() is not needed either.

		I have addressed this in version 3.

	From me Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
	================================================================

	- I have removed the unwind hints for FTrace and the Kretprobe
	  trampoline. These can be added later. I have retained only
	  the unwind hints for exceptions and interrupts.

	- I have enhanced the decoder to recognize the paciasp instruction.
	  Both gcc and Clang use this to begin a frame pointer prolog. This
	  is really useful for working out the CFI.

v2:
	From Josh Poimboeuf <jpoimboe@redhat.com>:
	==========================================

	DWARF is not proven to be reliable. So, depending on it for livepatch
	is a problem.

		I have removed the DWARF part from the patch series. Instead,
		I have implemented the minimum ARM64 instruction decoder
		required for this work. I have implemented code to walk all
		the instructions in an object file and generate ORC data.
		The ORC data will be used by the unwinder to compute a
		frame pointer and validate the actual frame pointer with it.

	Unwind hints are a problem from a maintenance perspective.

		This is true. But there are only a few unwind hints that I
		have introduced in this work. Also, if an unwind hint becomes
		outdated, the dynamic frame pointer check will catch it so
		that the unwinder will know that it is unreliable.
	
	Inline ASM code can cause problems that DWARF cannot catch.

		Now that I walk all of the instructions, this problem is solved.
		In version 2, the ORC data is generated based on the actual
		machine code in the object file. So, the data reflects the
		actual code. Unreliability in any part of the code will be
		caught by the unwinder when it looks up the ORC data and
		performs a frame pointer check.

	Rename kernel code and data that currently contains the name dwarf
	to avoid confusion.

		This problem is solved as I have dropped DWARF altogether.

	Try to reuse the existing ORC data format and code as much as possible.

		I have reorganized the code in the following ways:

		- I have placed code that was in check.c in separate files
		  so that different stack validation schemes can share the code.

		- I have separated architecture-specific code and structures
		  from generic ones so that different architectures can share
		  common stuff.

		- I am using the ORC structure as it is currently defined. The
		  only cosmetic change I have done is to rename the fields
		  bp_* to fp_* (FP for frame pointer).

		- I completely reuse the ORC definitions and code. E.g., in
		  the kernel the ORC lookup code is shared across architectures.

	Objtool contains other features which other architectures are looking
	into. So, should we just implement static stack validation for other
	architectures or use dynamic FP validation just for the livepatch
	feature?

		For one thing, it will take a long time before the static
		validation scheme can even be proved to be complete on ARM64.
		Livepatching is an immediate need for security fixes.

		Also, since I am using the traditional approach in v2 of
		walking the instructions, computing CFI, generating ORC, etc,
		my current approach can be combined with the traditional
		approach. Dynamic FP validation can be offered either as an
		alternative to static stack validation or as something that
		can be combined with static stack validation to make the
		feature even more robust. Objtool can always have bugs and
		there can be bad ORC data.

	From Peter Zijlstra <peterz@infradead.org>:
	===========================================

	Please use/extend ORC.

		Done. Please see my description above.

	Why deviate from the traditional approach of static stack validation?

		I have given the answer above.

	Mandating DWARF sucks. Compile times are so much worse with DWARVES.

		I have removed DWARF from the work. I use the traditional
		approach of decoding the instructions and computing the
		same data as DWARF but in ORC format.

	DWARF does not cover assembly code.

		In v2, I walk all of the functions including assembly functions.
		SYM_CODE functions are not walked by Objtool anyway. So, I
		don't do that. But I walk all the SYM_FUNC functions. Currently,
		only a few SYM_FUNC functions in ARM64 have a proper FP prolog
		and epilog. So, I plan to submit a separate patch series to
		add an FP prolog and epilog for other SYM_FUNC functions.
		But this is only to reduce retries during the livepatch process.
		It is not absolutely required for livepatch to work. But I
		plan to address this separately.

	Compilers don't consider DWARF generation to be a correctness issue.

		I totally agree. I have myself found 4 bugs that I have had
		to compensate for. So, I have dropped DWARF.

	From Chen Zhongjin <chenzhongjin@huawei.com>:
	=============================================

	One cannot depend on compilers to generate correct DWARF info.

		Agreed. I have dropped DWARF.

	DWARF does not cover assembly. So, what if too many assembly
	functions exist so that the livepatch process can encounter too
	many retries?

		DWARF has been dropped. The code in version 2 walks all the
		functions including assembly functions.

	There is a corner case where an interrupt or an exception can happen
	in FP prologs/epilogs. The stack trace would be unreliable.

		Yes. This will be caught by the reliable unwinder in the kernel
		in my scheme when it retrieves the ORC data and validates
		the actual frame pointer. The validation will fail and the
		stack trace will be considered unreliable.

v1:
	- Introduced the livepatch feature based on DWARF Call Frame
	  Information generated by the compilers.

Previous versions and discussion
================================

v2: https://lore.kernel.org/linux-arm-kernel/20220524001637.1707472-1-madvenka@linux.microsoft.com/T/#t
v1: https://lore.kernel.org/linux-arm-kernel/20220407202518.19780-1-madvenka@linux.microsoft.com/T/#t

Madhavan T. Venkataraman (22):
  objtool: Reorganize CFI code
  objtool: Reorganize instruction-related code
  objtool: Move decode_instructions() to a separate file
  objtool: Reorganize Unwind hint code
  objtool: Reorganize ORC types
  objtool: Reorganize ORC code
  objtool: Reorganize ORC kernel code
  objtool: Introduce STATIC_CHECK
  objtool: arm64: Add basic definitions and compile
  objtool: arm64: Implement decoder for Dynamic FP validation
  objtool: arm64: Invoke the decoder
  objtool: arm64: Compute destinations for call and jump instructions
  objtool: arm64: Walk instructions and compute CFI for each instruction
  objtool: arm64: Generate ORC data from CFI for object files
  objtool: arm64: Add unwind hint support
  arm64: Add unwind hints to exception handlers
  arm64: Add kernel and module support for ORC
  arm64: Build the kernel with ORC information
  arm64: unwinder: Add a reliability check in the unwinder based on ORC
  arm64: Define HAVE_DYNAMIC_FTRACE_WITH_ARGS
  arm64: Define TIF_PATCH_PENDING for livepatch
  arm64: Enable livepatch for ARM64

 arch/arm64/Kconfig                            |   5 +
 arch/arm64/Kconfig.debug                      |  33 +
 arch/arm64/include/asm/ftrace.h               |  20 +
 arch/arm64/include/asm/module.h               |  12 +-
 arch/arm64/include/asm/orc_types.h            |  35 ++
 arch/arm64/include/asm/stacktrace/common.h    |  15 +
 arch/arm64/include/asm/thread_info.h          |   4 +-
 arch/arm64/include/asm/unwind_hints.h         | 104 ++++
 arch/arm64/kernel/entry.S                     |   3 +
 arch/arm64/kernel/module.c                    |  13 +-
 arch/arm64/kernel/setup.c                     |   2 +
 arch/arm64/kernel/signal.c                    |   4 +
 arch/arm64/kernel/stacktrace.c                | 167 ++++-
 arch/arm64/kernel/vmlinux.lds.S               |   3 +
 arch/x86/include/asm/orc_types.h              |  37 +-
 arch/x86/include/asm/unwind.h                 |   5 -
 arch/x86/include/asm/unwind_hints.h           |  83 +++
 arch/x86/kernel/module.c                      |   7 +-
 arch/x86/kernel/unwind_orc.c                  | 258 +-------
 arch/x86/kernel/vmlinux.lds.S                 |   2 +-
 .../asm => include/asm-generic}/orc_lookup.h  |  42 ++
 include/linux/objtool.h                       |  72 +--
 include/linux/orc_entry.h                     |  39 ++
 kernel/Makefile                               |   2 +
 kernel/orc_lookup.c                           | 261 ++++++++
 scripts/Makefile                              |   4 +-
 scripts/Makefile.lib                          |   9 +
 tools/arch/arm64/include/asm/orc_types.h      |  35 ++
 tools/arch/arm64/include/asm/unwind_hints.h   | 104 ++++
 tools/arch/x86/include/asm/orc_types.h        |  37 +-
 tools/arch/x86/include/asm/unwind_hints.h     | 157 +++++
 tools/include/linux/objtool.h                 |  72 +--
 tools/include/linux/orc_entry.h               |  39 ++
 tools/objtool/Build                           |   9 +-
 tools/objtool/Makefile                        |   8 +-
 tools/objtool/arch/arm64/Build                |   2 +
 tools/objtool/arch/arm64/decode.c             | 573 ++++++++++++++++++
 .../arch/arm64/include/arch/cfi_regs.h        |  13 +
 tools/objtool/arch/arm64/include/arch/elf.h   |   9 +
 .../arch/arm64/include/arch/endianness.h      |   9 +
 tools/objtool/arch/arm64/orc.c                |  90 +++
 tools/objtool/arch/x86/Build                  |   1 +
 tools/objtool/arch/x86/include/arch/elf.h     |   1 +
 tools/objtool/arch/x86/orc.c                  | 150 +++++
 tools/objtool/cfi.c                           | 108 ++++
 tools/objtool/check.c                         | 492 +--------------
 tools/objtool/dcheck.c                        | 360 +++++++++++
 tools/objtool/decode.c                        | 107 ++++
 tools/objtool/include/objtool/arch.h          |   2 +
 tools/objtool/include/objtool/cfi.h           |  12 +
 tools/objtool/include/objtool/check.h         |  77 +--
 tools/objtool/include/objtool/endianness.h    |   1 +
 tools/objtool/include/objtool/insn.h          | 130 ++++
 tools/objtool/include/objtool/objtool.h       |   1 +
 tools/objtool/include/objtool/orc.h           |  18 +
 tools/objtool/insn.c                          | 215 +++++++
 tools/objtool/orc_dump.c                      |  63 +-
 tools/objtool/orc_gen.c                       |  89 +--
 tools/objtool/sync-check.sh                   |  10 +
 tools/objtool/unwind_hints.c                  | 110 ++++
 60 files changed, 3176 insertions(+), 1169 deletions(-)
 create mode 100644 arch/arm64/include/asm/orc_types.h
 create mode 100644 arch/arm64/include/asm/unwind_hints.h
 rename {arch/x86/include/asm => include/asm-generic}/orc_lookup.h (51%)
 create mode 100644 include/linux/orc_entry.h
 create mode 100644 kernel/orc_lookup.c
 create mode 100644 tools/arch/arm64/include/asm/orc_types.h
 create mode 100644 tools/arch/arm64/include/asm/unwind_hints.h
 create mode 100644 tools/arch/x86/include/asm/unwind_hints.h
 create mode 100644 tools/include/linux/orc_entry.h
 create mode 100644 tools/objtool/arch/arm64/Build
 create mode 100644 tools/objtool/arch/arm64/decode.c
 create mode 100644 tools/objtool/arch/arm64/include/arch/cfi_regs.h
 create mode 100644 tools/objtool/arch/arm64/include/arch/elf.h
 create mode 100644 tools/objtool/arch/arm64/include/arch/endianness.h
 create mode 100644 tools/objtool/arch/arm64/orc.c
 create mode 100644 tools/objtool/arch/x86/orc.c
 create mode 100644 tools/objtool/cfi.c
 create mode 100644 tools/objtool/dcheck.c
 create mode 100644 tools/objtool/decode.c
 create mode 100644 tools/objtool/include/objtool/insn.h
 create mode 100644 tools/objtool/include/objtool/orc.h
 create mode 100644 tools/objtool/insn.c
 create mode 100644 tools/objtool/unwind_hints.c


base-commit: 830b3c68c1fb1e9176028d02ef86f3cf76aa2476
-- 
2.25.1

