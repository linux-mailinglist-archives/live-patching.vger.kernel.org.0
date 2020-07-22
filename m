Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E832294DF
	for <lists+live-patching@lfdr.de>; Wed, 22 Jul 2020 11:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgGVJ1e (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Jul 2020 05:27:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:49764 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726153AbgGVJ1e (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Jul 2020 05:27:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2CE5EABD2;
        Wed, 22 Jul 2020 09:27:38 +0000 (UTC)
Date:   Wed, 22 Jul 2020 11:27:30 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
cc:     keescook@chromium.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, arjan@linux.intel.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        rick.p.edgecombe@intel.com, live-patching@vger.kernel.org
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
In-Reply-To: <20200717170008.5949-1-kristen@linux.intel.com>
Message-ID: <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
References: <20200717170008.5949-1-kristen@linux.intel.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Let me CC live-patching ML, because from a quick glance this is something 
which could impact live patching code. At least it invalidates assumptions 
which "sympos" is based on.

Miroslav

On Fri, 17 Jul 2020, Kristen Carlson Accardi wrote:

> Function Granular Kernel Address Space Layout Randomization (fgkaslr)
> ---------------------------------------------------------------------
> 
> This patch set is an implementation of finer grained kernel address space
> randomization. It rearranges your kernel code at load time 
> on a per-function level granularity, with only around a second added to
> boot time.

[...]

> Background
> ----------
> KASLR was merged into the kernel with the objective of increasing the
> difficulty of code reuse attacks. Code reuse attacks reused existing code
> snippets to get around existing memory protections. They exploit software bugs
> which expose addresses of useful code snippets to control the flow of
> execution for their own nefarious purposes. KASLR moves the entire kernel
> code text as a unit at boot time in order to make addresses less predictable.
> The order of the code within the segment is unchanged - only the base address
> is shifted. There are a few shortcomings to this algorithm.
> 
> 1. Low Entropy - there are only so many locations the kernel can fit in. This
>    means an attacker could guess without too much trouble.
> 2. Knowledge of a single address can reveal the offset of the base address,
>    exposing all other locations for a published/known kernel image.
> 3. Info leaks abound.
> 
> Finer grained ASLR has been proposed as a way to make ASLR more resistant
> to info leaks. It is not a new concept at all, and there are many variations
> possible. Function reordering is an implementation of finer grained ASLR
> which randomizes the layout of an address space on a function level
> granularity. We use the term "fgkaslr" in this document to refer to the
> technique of function reordering when used with KASLR, as well as finer grained
> KASLR in general.
> 
> Proposed Improvement
> --------------------
> This patch set proposes adding function reordering on top of the existing
> KASLR base address randomization. The over-arching objective is incremental
> improvement over what we already have. It is designed to work in combination
> with the existing solution. The implementation is really pretty simple, and
> there are 2 main area where changes occur:
> 
> * Build time
> 
> GCC has had an option to place functions into individual .text sections for
> many years now. This option can be used to implement function reordering at
> load time. The final compiled vmlinux retains all the section headers, which
> can be used to help find the address ranges of each function. Using this
> information and an expanded table of relocation addresses, individual text
> sections can be suffled immediately after decompression. Some data tables
> inside the kernel that have assumptions about order require re-sorting
> after being updated when applying relocations. In order to modify these tables,
> a few key symbols are excluded from the objcopy symbol stripping process for
> use after shuffling the text segments.
> 
> Some highlights from the build time changes to look for:
> 
> The top level kernel Makefile was modified to add the gcc flag if it
> is supported. Currently, I am applying this flag to everything it is
> possible to randomize. Anything that is written in C and not present in a
> special input section is randomized. The final binary segment 0 retains a
> consolidated .text section, as well as all the individual .text.* sections.
> Future work could turn off this flags for selected files or even entire
> subsystems, although obviously at the cost of security.
> 
> The relocs tool is updated to add relative relocations. This information
> previously wasn't included because it wasn't necessary when moving the
> entire .text segment as a unit. 
> 
> A new file was created to contain a list of symbols that objcopy should
> keep. We use those symbols at load time as described below.
> 
> * Load time
> 
> The boot kernel was modified to parse the vmlinux elf file after
> decompression to check for our interesting symbols that we kept, and to
> look for any .text.* sections to randomize. The consolidated .text section
> is skipped and not moved. The sections are shuffled randomly, and copied
> into memory following the .text section in a new random order. The existing
> code which updated relocation addresses was modified to account for
> not just a fixed delta from the load address, but the offset that the function
> section was moved to. This requires inspection of each address to see if
> it was impacted by a randomization. We use a bsearch to make this less
> horrible on performance. Any tables that need to be modified with new
> addresses or resorted are updated using the symbol addresses parsed from the
> elf symbol table.
> 
> In order to hide our new layout, symbols reported through /proc/kallsyms
> will be displayed in a random order.
> 
> Security Considerations
> -----------------------
> The objective of this patch set is to improve a technology that is already
> merged into the kernel (KASLR). This code will not prevent all attacks,
> but should instead be considered as one of several tools that can be used.
> In particular, this code is meant to make KASLR more effective in the presence
> of info leaks.
> 
> How much entropy we are adding to the existing entropy of standard KASLR will
> depend on a few variables. Firstly and most obviously, the number of functions
> that are randomized matters. This implementation keeps the existing .text
> section for code that cannot be randomized - for example, because it was
> assembly code. The less sections to randomize, the less entropy. In addition,
> due to alignment (16 bytes for x86_64), the number of bits in a address that
> the attacker needs to guess is reduced, as the lower bits are identical.

[...]

> Modules
> -------
> Modules are randomized similarly to the rest of the kernel by shuffling
> the sections at load time prior to moving them into memory. The module must
> also have been build with the -ffunction-sections compiler option.
> 
> Although fgkaslr for the kernel is only supported for the X86_64 architecture,
> it is possible to use fgkaslr with modules on other architectures. To enable
> this feature, select
> 
> CONFIG_MODULE_FG_KASLR=y
> 
> This option is selected automatically for X86_64 when CONFIG_FG_KASLR is set.
> 
> Disabling
> ---------
> Disabling normal KASLR using the nokaslr command line option also disables
> fgkaslr. It is also possible to disable fgkaslr separately by booting with
> fgkaslr=off on the commandline.
