Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA4123F15A
	for <lists+live-patching@lfdr.de>; Fri,  7 Aug 2020 18:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgHGQib (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 7 Aug 2020 12:38:31 -0400
Received: from mga05.intel.com ([192.55.52.43]:6756 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgHGQia (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 7 Aug 2020 12:38:30 -0400
IronPort-SDR: hFpBP8UXw6QoAfJJhOoK4BD3nJD3NYwAdNFn7E5eAnNFLI1Q4pp1mkVOxVMbK6mu/SY6pL3J/1
 Sk48esSC1tZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9706"; a="237988008"
X-IronPort-AV: E=Sophos;i="5.75,446,1589266800"; 
   d="scan'208";a="237988008"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 09:38:23 -0700
IronPort-SDR: 1Q5X2Q7FZjtVAxi5iPqZdJS1AD4vZ64TYrP2m04iNjEe3LJHmL8S2KfYf9UsWkqsN+nDODLGUd
 QQBDpZXz4bqQ==
X-IronPort-AV: E=Sophos;i="5.75,446,1589266800"; 
   d="scan'208";a="333591219"
Received: from kcaccard-mobl.amr.corp.intel.com (HELO kcaccard-mobl1.jf.intel.com) ([10.209.57.23])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 09:38:14 -0700
Message-ID: <f8963aab93243bc046791dba6af5d006e15c91ff.camel@linux.intel.com>
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
From:   Kristen Carlson Accardi <kristen@linux.intel.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     keescook@chromium.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, arjan@linux.intel.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        rick.p.edgecombe@intel.com, live-patching@vger.kernel.org
Date:   Fri, 07 Aug 2020 09:38:11 -0700
In-Reply-To: <20200804182359.GA23533@redhat.com>
References: <20200717170008.5949-1-kristen@linux.intel.com>
         <20200804182359.GA23533@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 2020-08-04 at 14:23 -0400, Joe Lawrence wrote:
> On Fri, Jul 17, 2020 at 09:59:57AM -0700, Kristen Carlson Accardi
> wrote:
> > Function Granular Kernel Address Space Layout Randomization
> > (fgkaslr)
> > -----------------------------------------------------------------
> > ----
> > 
> > This patch set is an implementation of finer grained kernel address
> > space
> > randomization. It rearranges your kernel code at load time 
> > on a per-function level granularity, with only around a second
> > added to
> > boot time.
> > 
> > Changes in v4:
> > -------------
> > * dropped the patch to split out change to STATIC definition in
> >   x86/boot/compressed/misc.c and replaced with a patch authored
> >   by Kees Cook to avoid the duplicate malloc definitions
> > * Added a section to Documentation/admin-guide/kernel-
> > parameters.txt
> >   to document the fgkaslr boot option.
> > * redesigned the patch to hide the new layout when reading
> >   /proc/kallsyms. The previous implementation utilized a
> > dynamically
> >   allocated linked list to display the kernel and module symbols
> >   in alphabetical order. The new implementation uses a randomly
> >   shuffled index array to display the kernel and module symbols
> >   in a random order.
> > 
> > Changes in v3:
> > -------------
> > * Makefile changes to accommodate
> > CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
> > * removal of extraneous ALIGN_PAGE from _etext changes
> > * changed variable names in x86/tools/relocs to be less confusing
> > * split out change to STATIC definition in
> > x86/boot/compressed/misc.c
> > * Updates to Documentation to make it more clear what is preserved
> > in .text
> > * much more detailed commit message for function granular KASLR
> > patch
> > * minor tweaks and changes that make for more readable code
> > * this cover letter updated slightly to add additional details
> > 
> > Changes in v2:
> > --------------
> > * Fix to address i386 build failure
> > * Allow module reordering patch to be configured separately so that
> >   arm (or other non-x86_64 arches) can take advantage of module
> > function
> >   reordering. This support has not be tested by me, but smoke
> > tested by
> >   Ard Biesheuvel <ardb@kernel.org> on arm.
> > * Fix build issue when building on arm as reported by
> >   Ard Biesheuvel <ardb@kernel.org> 
> > 
> > Patches to objtool are included because they are dependencies for
> > this
> > patchset, however they have been submitted by their maintainer
> > separately.
> > 
> > Background
> > ----------
> > KASLR was merged into the kernel with the objective of increasing
> > the
> > difficulty of code reuse attacks. Code reuse attacks reused
> > existing code
> > snippets to get around existing memory protections. They exploit
> > software bugs
> > which expose addresses of useful code snippets to control the flow
> > of
> > execution for their own nefarious purposes. KASLR moves the entire
> > kernel
> > code text as a unit at boot time in order to make addresses less
> > predictable.
> > The order of the code within the segment is unchanged - only the
> > base address
> > is shifted. There are a few shortcomings to this algorithm.
> > 
> > 1. Low Entropy - there are only so many locations the kernel can
> > fit in. This
> >    means an attacker could guess without too much trouble.
> > 2. Knowledge of a single address can reveal the offset of the base
> > address,
> >    exposing all other locations for a published/known kernel image.
> > 3. Info leaks abound.
> > 
> > Finer grained ASLR has been proposed as a way to make ASLR more
> > resistant
> > to info leaks. It is not a new concept at all, and there are many
> > variations
> > possible. Function reordering is an implementation of finer grained
> > ASLR
> > which randomizes the layout of an address space on a function level
> > granularity. We use the term "fgkaslr" in this document to refer to
> > the
> > technique of function reordering when used with KASLR, as well as
> > finer grained
> > KASLR in general.
> > 
> > Proposed Improvement
> > --------------------
> > This patch set proposes adding function reordering on top of the
> > existing
> > KASLR base address randomization. The over-arching objective is
> > incremental
> > improvement over what we already have. It is designed to work in
> > combination
> > with the existing solution. The implementation is really pretty
> > simple, and
> > there are 2 main area where changes occur:
> > 
> > * Build time
> > 
> > GCC has had an option to place functions into individual .text
> > sections for
> > many years now. This option can be used to implement function
> > reordering at
> > load time. The final compiled vmlinux retains all the section
> > headers, which
> > can be used to help find the address ranges of each function. Using
> > this
> > information and an expanded table of relocation addresses,
> > individual text
> > sections can be suffled immediately after decompression. Some data
> > tables
> > inside the kernel that have assumptions about order require re-
> > sorting
> > after being updated when applying relocations. In order to modify
> > these tables,
> > a few key symbols are excluded from the objcopy symbol stripping
> > process for
> > use after shuffling the text segments.
> > 
> > Some highlights from the build time changes to look for:
> > 
> > The top level kernel Makefile was modified to add the gcc flag if
> > it
> > is supported. Currently, I am applying this flag to everything it
> > is
> > possible to randomize. Anything that is written in C and not
> > present in a
> > special input section is randomized. The final binary segment 0
> > retains a
> > consolidated .text section, as well as all the individual .text.*
> > sections.
> > Future work could turn off this flags for selected files or even
> > entire
> > subsystems, although obviously at the cost of security.
> > 
> > The relocs tool is updated to add relative relocations. This
> > information
> > previously wasn't included because it wasn't necessary when moving
> > the
> > entire .text segment as a unit. 
> > 
> > A new file was created to contain a list of symbols that objcopy
> > should
> > keep. We use those symbols at load time as described below.
> > 
> > * Load time
> > 
> > The boot kernel was modified to parse the vmlinux elf file after
> > decompression to check for our interesting symbols that we kept,
> > and to
> > look for any .text.* sections to randomize. The consolidated .text
> > section
> > is skipped and not moved. The sections are shuffled randomly, and
> > copied
> > into memory following the .text section in a new random order. The
> > existing
> > code which updated relocation addresses was modified to account for
> > not just a fixed delta from the load address, but the offset that
> > the function
> > section was moved to. This requires inspection of each address to
> > see if
> > it was impacted by a randomization. We use a bsearch to make this
> > less
> > horrible on performance. Any tables that need to be modified with
> > new
> > addresses or resorted are updated using the symbol addresses parsed
> > from the
> > elf symbol table.
> > 
> > In order to hide our new layout, symbols reported through
> > /proc/kallsyms
> > will be displayed in a random order.
> > 
> > Security Considerations
> > -----------------------
> > The objective of this patch set is to improve a technology that is
> > already
> > merged into the kernel (KASLR). This code will not prevent all
> > attacks,
> > but should instead be considered as one of several tools that can
> > be used.
> > In particular, this code is meant to make KASLR more effective in
> > the presence
> > of info leaks.
> > 
> > How much entropy we are adding to the existing entropy of standard
> > KASLR will
> > depend on a few variables. Firstly and most obviously, the number
> > of functions
> > that are randomized matters. This implementation keeps the existing
> > .text
> > section for code that cannot be randomized - for example, because
> > it was
> > assembly code. The less sections to randomize, the less entropy. In
> > addition,
> > due to alignment (16 bytes for x86_64), the number of bits in a
> > address that
> > the attacker needs to guess is reduced, as the lower bits are
> > identical.
> > 
> > Performance Impact
> > ------------------
> > There are two areas where function reordering can impact
> > performance: boot
> > time latency, and run time performance.
> > 
> > * Boot time latency
> > This implementation of finer grained KASLR impacts the boot time of
> > the kernel
> > in several places. It requires additional parsing of the kernel ELF
> > file to
> > obtain the section headers of the sections to be randomized. It
> > calls the
> > random number generator for each section to be randomized to
> > determine that
> > section's new memory location. It copies the decompressed kernel
> > into a new
> > area of memory to avoid corruption when laying out the newly
> > randomized
> > sections. It increases the number of relocations the kernel has to
> > perform at
> > boot time vs. standard KASLR, and it also requires a lookup on each
> > address
> > that needs to be relocated to see if it was in a randomized section
> > and needs
> > to be adjusted by a new offset. Finally, it re-sorts a few data
> > tables that
> > are required to be sorted by address.
> > 
> > Booting a test VM on a modern, well appointed system showed an
> > increase in
> > latency of approximately 1 second.
> > 
> > * Run time
> > The performance impact at run-time of function reordering varies by
> > workload.
> > Using kcbench, a kernel compilation benchmark, the performance of a
> > kernel
> > build with finer grained KASLR was about 1% slower than a kernel
> > with standard
> > KASLR. Analysis with perf showed a slightly higher percentage of 
> > L1-icache-load-misses. Other workloads were examined as well, with
> > varied
> > results. Some workloads performed significantly worse under
> > FGKASLR, while
> > others stayed the same or were mysteriously better. In general, it
> > will
> > depend on the code flow whether or not finer grained KASLR will
> > impact
> > your workload, and how the underlying code was designed. Because
> > the layout
> > changes per boot, each time a system is rebooted the performance of
> > a workload
> > may change.
> > 
> > Future work could identify hot areas that may not be randomized and
> > either
> > leave them in the .text section or group them together into a
> > single section
> > that may be randomized. If grouping things together helps, one
> > other thing to
> > consider is that if we could identify text blobs that should be
> > grouped together
> > to benefit a particular code flow, it could be interesting to
> > explore
> > whether this security feature could be also be used as a
> > performance
> > feature if you are interested in optimizing your kernel layout for
> > a
> > particular workload at boot time. Optimizing function layout for a
> > particular
> > workload has been researched and proven effective - for more
> > information
> > read the Facebook paper "Optimizing Function Placement for Large-
> > Scale
> > Data-Center Applications" (see references section below).
> > 
> > Image Size
> > ----------
> > Adding additional section headers as a result of compiling with
> > -ffunction-sections will increase the size of the vmlinux ELF file.
> > With a standard distro config, the resulting vmlinux was increased
> > by
> > about 3%. The compressed image is also increased due to the header
> > files,
> > as well as the extra relocations that must be added. You can expect
> > fgkaslr
> > to increase the size of the compressed image by about 15%.
> > 
> > Memory Usage
> > ------------
> > fgkaslr increases the amount of heap that is required at boot time,
> > although this extra memory is released when the kernel has finished
> > decompression. As a result, it may not be appropriate to use this
> > feature on
> > systems without much memory.
> > 
> > Building
> > --------
> > To enable fine grained KASLR, you need to have the following config
> > options
> > set (including all the ones you would use to build normal KASLR)
> > 
> > CONFIG_FG_KASLR=y
> > 
> > In addition, fgkaslr is only supported for the X86_64 architecture.
> > 
> > Modules
> > -------
> > Modules are randomized similarly to the rest of the kernel by
> > shuffling
> > the sections at load time prior to moving them into memory. The
> > module must
> > also have been build with the -ffunction-sections compiler option.
> > 
> > Although fgkaslr for the kernel is only supported for the X86_64
> > architecture,
> > it is possible to use fgkaslr with modules on other architectures.
> > To enable
> > this feature, select
> > 
> > CONFIG_MODULE_FG_KASLR=y
> > 
> > This option is selected automatically for X86_64 when
> > CONFIG_FG_KASLR is set.
> > 
> > Disabling
> > ---------
> > Disabling normal KASLR using the nokaslr command line option also
> > disables
> > fgkaslr. It is also possible to disable fgkaslr separately by
> > booting with
> > fgkaslr=off on the commandline.
> > 
> > References
> > ----------
> > There are a lot of academic papers which explore finer grained
> > ASLR.
> > This paper in particular contributed the most to my implementation
> > design
> > as well as my overall understanding of the problem space:
> > 
> > Selfrando: Securing the Tor Browser against De-anonymization
> > Exploits,
> > M. Conti, S. Crane, T. Frassetto, et al.
> > 
> > For more information on how function layout impacts performance,
> > see:
> > 
> > Optimizing Function Placement for Large-Scale Data-Center
> > Applications,
> > G. Ottoni, B. Maher
> > 
> > Kees Cook (2):
> >   x86/boot: Allow a "silent" kaslr random byte fetch
> >   x86/boot/compressed: Avoid duplicate malloc() implementations
> > 
> > Kristen Carlson Accardi (8):
> >   objtool: Do not assume order of parent/child functions
> >   x86: tools/relocs: Support >64K section headers
> >   x86: Makefile: Add build and config option for CONFIG_FG_KASLR
> >   x86: Make sure _etext includes function sections
> >   x86/tools: Add relative relocs for randomized functions
> >   x86: Add support for function granular KASLR
> >   kallsyms: Hide layout
> >   module: Reorder functions
> > 
> >  .../admin-guide/kernel-parameters.txt         |   7 +
> >  Documentation/security/fgkaslr.rst            | 172 ++++
> >  Documentation/security/index.rst              |   1 +
> >  Makefile                                      |   6 +-
> >  arch/x86/Kconfig                              |   4 +
> >  arch/x86/Makefile                             |   5 +
> >  arch/x86/boot/compressed/Makefile             |   9 +-
> >  arch/x86/boot/compressed/fgkaslr.c            | 811
> > ++++++++++++++++++
> >  arch/x86/boot/compressed/kaslr.c              |   4 -
> >  arch/x86/boot/compressed/misc.c               | 157 +++-
> >  arch/x86/boot/compressed/misc.h               |  30 +
> >  arch/x86/boot/compressed/utils.c              |  11 +
> >  arch/x86/boot/compressed/vmlinux.symbols      |  17 +
> >  arch/x86/include/asm/boot.h                   |  15 +-
> >  arch/x86/kernel/vmlinux.lds.S                 |  17 +-
> >  arch/x86/lib/kaslr.c                          |  18 +-
> >  arch/x86/tools/relocs.c                       | 143 ++-
> >  arch/x86/tools/relocs.h                       |   4 +-
> >  arch/x86/tools/relocs_common.c                |  15 +-
> >  include/asm-generic/vmlinux.lds.h             |  18 +-
> >  include/linux/decompress/mm.h                 |  12 +-
> >  include/uapi/linux/elf.h                      |   1 +
> >  init/Kconfig                                  |  26 +
> >  kernel/kallsyms.c                             | 163 +++-
> >  kernel/module.c                               |  81 ++
> >  tools/objtool/elf.c                           |   8 +-
> >  26 files changed, 1670 insertions(+), 85 deletions(-)
> >  create mode 100644 Documentation/security/fgkaslr.rst
> >  create mode 100644 arch/x86/boot/compressed/fgkaslr.c
> >  create mode 100644 arch/x86/boot/compressed/utils.c
> >  create mode 100644 arch/x86/boot/compressed/vmlinux.symbols
> > 
> > 
> > base-commit: 11ba468877bb23f28956a35e896356252d63c983
> > -- 
> > 2.20.1
> > 
> 
> Apologies in advance if this has already been discussed elsewhere,
> but I
> did finally get around to testing the patchset against the
> livepatching
> kselftests.
> 
> The livepatching kselftests fail as all livepatches stall their
> transitions.  It appears that reliable (ORC) stack unwinding is
> broken
> when fgkaslr is enabled.
> 
> Relevant config options:
> 
>   CONFIG_ARCH_HAS_FG_KASLR=y
>   CONFIG_ARCH_STACKWALK=y
>   CONFIG_FG_KASLR=y
>   CONFIG_HAVE_LIVEPATCH=y
>   CONFIG_HAVE_RELIABLE_STACKTRACE=y
>   CONFIG_LIVEPATCH=y
>   CONFIG_MODULE_FG_KASLR=y
>   CONFIG_TEST_LIVEPATCH=m
>   CONFIG_UNWINDER_ORC=y
> 
> The livepatch transitions are stuck along this call path:
> 
>   klp_check_stack
>     stack_trace_save_tsk_reliable
>       arch_stack_walk_reliable
>   
>           /* Check for stack corruption */
>           if (unwind_error(&state))
>                   return -EINVAL;
> 
> where the unwinder error is set by unwind_next_frame():
> 
>   arch/x86/kernel/unwind_orc.c
>   bool unwind_next_frame(struct unwind_state *state)
>  
> sometimes here:
>  
>   	/* End-of-stack check for kernel threads: */
>   	if (orc->sp_reg == ORC_REG_UNDEFINED) {
>   		if (!orc->end)
>   			goto err;
>   
>   		goto the_end;
>   	}
> 
> or here:
> 
>   	/* Prevent a recursive loop due to bad ORC data:
> */                                                                   
>              
>   	if (state->stack_info.type == prev_type
> &&                                                                   
>                       
>   	    on_stack(&state->stack_info, (void *)state->sp,
> sizeof(long))
> &&                                                               
>   	    state->sp <= prev_sp)
> {                                                                    
>                                     
>   		orc_warn_current("stack going in the wrong direction?
> at %pB\n",                                                           
>   				 (void
> *)orig_ip);                                                          
>                                
>   		goto
> err;                                                                 
>                                                  
>   	}
> 
> (and probably other places the ORC unwinder gets confused.)
> 
> 
> It also manifests itself in other, more visible ways.  For example, a
> kernel module that calls dump_stack() in its init function or even
> /proc/<pid>/stack:
> 
> (fgkaslr on)
> ------------
> 
> Call Trace:
>  ? dump_stack+0x57/0x73
>  ? 0xffffffffc0850000
>  ? mymodule_init+0xa/0x1000 [dumpstack]
>  ? do_one_initcall+0x46/0x1f0
>  ? free_unref_page_commit+0x91/0x100
>  ? _cond_resched+0x15/0x30
>  ? kmem_cache_alloc_trace+0x14b/0x210
>  ? do_init_module+0x5a/0x220
>  ? load_module+0x1912/0x1b20
>  ? __do_sys_finit_module+0xa8/0x110
>  ? __do_sys_finit_module+0xa8/0x110
>  ? do_syscall_64+0x47/0x80
>  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> % sudo cat /proc/$$/stack
> [<0>] do_wait+0x1c3/0x230
> [<0>] kernel_wait4+0xa6/0x140
> 
> 
> fgkaslr=off
> -----------
> 
> Call Trace:
>  dump_stack+0x57/0x73
>  ? 0xffffffffc04f2000
>  mymodule_init+0xa/0x1000 [readonly]
>  do_one_initcall+0x46/0x1f0
>  ? free_unref_page_commit+0x91/0x100
>  ? _cond_resched+0x15/0x30
>  ? kmem_cache_alloc_trace+0x14b/0x210
>  do_init_module+0x5a/0x220
>  load_module+0x1912/0x1b20
>  ? __do_sys_finit_module+0xa8/0x110
>  __do_sys_finit_module+0xa8/0x110
>  do_syscall_64+0x47/0x80
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> % sudo cat /proc/$$/stack
> [<0>] do_wait+0x1c3/0x230
> [<0>] kernel_wait4+0xa6/0x140
> [<0>] __do_sys_wait4+0x83/0x90
> [<0>] do_syscall_64+0x47/0x80
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> 
> I would think fixing and verifying these latter cases would be easier
> than
> chasing livepatch transitions (but would still probably fix klp case,
> too).
> Perhaps Josh or someone has other ORC unwinder tests that could be
> used?
> 
> -- Joe
> 

Hi Joe,
Thanks for testing. Yes, Josh and I have been discussing the orc_unwind
issues. I've root caused one issue already, in that objtool places an
orc_unwind_ip address just outside the section, so my algorithm fails
to relocate this address. There are other issues as well that I still
haven't root caused. I'll be addressing this in v5 and plan to have
something that passes livepatch testing with that version.

Kristen

