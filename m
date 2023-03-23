Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98ECA6C6E87
	for <lists+live-patching@lfdr.de>; Thu, 23 Mar 2023 18:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjCWRRZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Mar 2023 13:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCWRRY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Mar 2023 13:17:24 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD00E2686C;
        Thu, 23 Mar 2023 10:17:22 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 488942F4;
        Thu, 23 Mar 2023 10:18:06 -0700 (PDT)
Received: from FVFF77S0Q05N.cambridge.arm.com (FVFF77S0Q05N.cambridge.arm.com [10.1.31.167])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4BE133F766;
        Thu, 23 Mar 2023 10:17:20 -0700 (PDT)
Date:   Thu, 23 Mar 2023 17:17:14 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        broonie@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/22] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
Message-ID: <ZByJmnc/XDcqQwoZ@FVFF77S0Q05N.cambridge.arm.com>
References: <0337266cf19f4c98388e3f6d09f590d9de258dc7>
 <20230202074036.507249-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202074036.507249-1-madvenka@linux.microsoft.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Madhavan,

At a high-level, I think this still falls afoul of our desire to not reverse
engineer control flow from the binary, and so I do not think this is the right
approach. I've expanded a bit on that below.

I do think it would be nice to have *some* of the objtool changes, as I do
think we will want to use objtool for some things in future (e.g. some
build-time binary patching such as table sorting).

On Thu, Feb 02, 2023 at 01:40:14AM -0600, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Introduction
> ============
> 
> The livepatch feature requires an unwinder that can provide a reliable stack
> trace. General requirements for a reliable unwinder are described in this
> document from Mark Rutland:
> 
> 	Documentation/livepatch/reliable-stacktrace.rst
> 
> The requirements have two parts:
> 
> 1. The unwinder must be enhanced with certain features. E.g.,
> 
> 	- Identifying successful termination of stack trace
> 	- Identifying unwindable and non-unwindable code
> 	- Identifying interrupts and exceptions occurring in the frame pointer
> 	  prolog and epilog
> 	- Identifying features such as kretprobe and ftrace graph tracing
> 	  that can modify the return address stored on the stack
> 	- Identifying corrupted/unreliable stack contents
> 	- Architecture-specific items that can render a stack trace unreliable
> 	  at certain points in code
> 
> 2. Validation of the frame pointer
> 
> 	This assumes that the unwinder is based on the frame pointer (FP).
> 	The actual frame pointer that the unwinder uses cannot just be
> 	assumed to be correct. It needs to be validated somehow.
> 
> This patch series is to address the following:
> 
> 	- Identifying unwindable and non-unwindable code
> 	- Identifying interrupts and exceptions occurring in the frame pointer
> 	  prolog and epilog
> 	- Validation of the frame pointer
> 
> The rest are already in place AFAICT.

Just as a note: there are a few issues remaining (e.g. the kretprobe and fgraph
PC recovery both have windows where they lose the original return address), and
there are a few compiler-generated trampoline functions with non-AAPCS calling
conventions that will need special care.

> Validation of the FP (aka FRAME_POINTER_VALIDATION)
> ====================
> 
> The current approach in Linux is to use objtool, a build time tool, for this
> purpose. When configured, objtool is invoked on every relocatable object file
> during kernel build. It performs static analysis of the code in each file. It
> walks the instructions in every function and notes the changes to the stack
> pointer (SP) and the frame pointer (FP). It makes sure that the changes are in
> accordance with the ABI rules. There are also a lot of other checks that
> Objtool performs. Once objtool completes successfully, the kernel can then be
> used for livepatch purposes.
> 
> Objtool can have uses other than just FP validation. For instance, it can check
> control flow integrity during its analysis.
> 
> Problem
> =======
> 
> Objtool is complex and highly architecture-dependent. There are a lot of
> different checks in objtool that all of the code in the kernel must pass
> before livepatch can be enabled. If a check fails, it must be corrected
> before we can proceed. Sometimes, the kernel code needs to be fixed.
> Sometimes, it is a compiler bug that needs to be fixed. The challenge is
> also to prove that all the work is complete for an architecture.
> 
> As such, it presents a great challenge to enable livepatch for an
> architecture.

There's a more fundamental issue here in that objtool has to reverse-engineer
control flow, and so even if the kernel code and compiled code generation is
*perfect*, it's possible that objtool won't recognise the structure of the
generated code, and won't be able to reverse-engineer the correct control flow.

We've seen issues where objtool didn't understand jump tables, so support for
that got disabled on x86. A key objection from the arm64 side is that we don't
want to disable compile code generation strategies like this. Further, as
compiles evolve, their code generation strategies will change, and it's likely
there will be other cases that crop up. This is inherently fragile.

The key objections from the arm64 side is that we don't want to
reverse-engineer details from the binary, as this is complex, fragile, and
unstable. This is why we've previously suggested that we should work with
compiler folk to get what we need.

I'll note that at the last Linux Plumbers Conference, there was a discussion
about what is now called SFrame, which *might* give us sufficient information,
but I have not had the time to dig into that as I have been chasing other
problems and trying to get other infrastructure in place.

> A different approach
> ====================
> 
> I would like to propose a different approach for FP validation. I would
> like to be able to enable livepatch for an architecture as is. That is,
> without "fixing" the kernel or the compiler for it:
> 
> There are three steps in this:
> 
> 1. Objtool walks all the functions as usual. It computes the stack and
>    frame pointer offsets at each instruction as usual. It generates ORC
>    records and stores them in special sections as usual. This is simple
>    enough to do.

This still requires reverse-engineering the forward-edge control flow in order
to compute those offets, so the same objections apply with this approach. I do
not think this is the right approach.

I would *strongly* prefer that we work with compiler folk to get the
information that we need.

[...]

> 		FWIW, I have also compared the CFI I am generating with DWARF
> 		information that the compiler generates. The CFIs match a
> 		100% for Clang. In the case of gcc, the comparison fails
> 		in 1.7% of the cases. I have analyzed those cases and found
> 		the DWARF information generated by gcc is incorrect. The
> 		ORC generated by my Objtool is correct.


Have you reported this to the GCC folk, and can you give any examples?
I'm sure they would be interested in fixing this, regardless of whether we end
up using it.

Thanks,
Mark.
