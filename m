Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C56534601
	for <lists+live-patching@lfdr.de>; Wed, 25 May 2022 23:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbiEYVtm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 25 May 2022 17:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbiEYVtl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 25 May 2022 17:49:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14613AF313;
        Wed, 25 May 2022 14:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=RVugMhF/7mbE+vFdQU3Gf9ejg7y8BAfWWy/60v2i0bg=; b=q2RoTzhWQV+xA1dSmfcMKjzL3u
        NHa3CTz3mX9Qse00kqBoPRwtXZCdCM9VNMHOd6sKD1T06FShOIPzr7iDZ5ghP25f6xZeC7t6PryNB
        nGYv7/lwppc6SFOlT6rxWb3hSWzLwD6U0ppW5UDU0dUq8PXP2OBIst2PGv/4VrUfipCvMQhPJPE5u
        985JBtqT90TVcUPFT8yz8u5ywN/O5xW4+eYIZzJ8nhZjlVWDg0eSSXnGo40/8LljiH8Vzxvb7FSXp
        5asiqrJTbZS//Q63MKiYtSdAaDzz1xDZJrVm6nFtGoR010bZPhn/aRv1YBLATX53RqHJ3t05Bbxcj
        KUlov7vw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ntyso-00Cmc4-Ia; Wed, 25 May 2022 21:49:34 +0000
Date:   Wed, 25 May 2022 14:49:34 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     patches@lists.linux.dev, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Lecopzer Chen <lecopzer.chen@mediatek.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Song Liu <song@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Keith Busch <kbusch@kernel.org>, mcgrof@kernel.org
Subject: [GIT PULL] Modules fixes for v5.19-rc1
Message-ID: <Yo6kboq8M8nUwy45@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

OK, finally some changes for modules. It is still pretty boring,
but I am hopefull that the cleanup will yield nice results in the
future as further cleanups will make the code much easier to
read, maintain and test. Perhaps the most exciting thing is
Christophe Leroy's CONFIG_ARCH_WANTS_MODULES_DATA_IN_VMALLOC.
In reviewing Rick Edgecombe's prior work on enhancements for
special allocators I suspect this is going to help as module
space was the more complex aspect to deal with in his work.

AFAICT you *may* run into conflicts *if* bpf folks submit the
module_alloc_huge() stuff which I was still reviewing with Rick.
To my taste that effort seems to be going fast and I like to
take time to consider a proper interface for it which aligns well
with that others have in mind, specially in consideration for what
other architectures might need. The VM_FLUSH_RESET_PERMS stuff was
what was loose there. It doesn't seem we can address that stuff in
a generic neat way yet, and so the x86 open codes its own solution
for it.

I suspect we'll also need more tests on the huge page front so that
if more module_alloc() users want to convert we can enable folks to
give more realistic performance information rather than loose
numbers. In the future I suspect we'll just generalize module_alloc()
to vmalloc_exec() as its users are growing and the technical debt
of not drawing a clean API for it is growing.

Let me know if there are any issues.

  Luis

The following changes since commit 3123109284176b1532874591f7c81f3837bbdc17:

  Linux 5.18-rc1 (2022-04-03 14:08:21 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/modules-5.19-rc1

for you to fetch changes up to 7390b94a3c2d93272d6da4945b81a9cf78055b7b:

  module: merge check_exported_symbol() into find_exported_symbol_in_section() (2022-05-12 10:29:41 -0700)

----------------------------------------------------------------
Modules updates for v5.19-rc1

As promised, for v5.19 I queued up quite a bit of work for modules, but
still with a pretty conservative eye. These changes have been soaking on
modules-next (and so linux-next) for quite some time, the code shift was
merged onto modules-next on March 22, and the last patch was queued on May
5th.

The following are the highlights of what bells and whistles we will get for
v5.19:

 1) It was time to tidy up kernel/module.c and one way of starting with
    that effort was to split it up into files. At my request Aaron Tomlin
    spearheaded that effort with the goal to not introduce any
    functional at all during that endeavour.  The penalty for the split
    is +1322 bytes total, +112 bytes in data, +1210 bytes in text while
    bss is unchanged. One of the benefits of this other than helping
    make the code easier to read and review is summoning more help on review
    for changes with livepatching so kernel/module/livepatch.c is now
    pegged as maintained by the live patching folks.

    The before and after with just the move on a defconfig on x86-64:

     $ size kernel/module.o
        text    data     bss     dec     hex filename
       38434    4540     104   43078    a846 kernel/module.o

     $ size -t kernel/module/*.o
        text    data     bss     dec     hex filename
       4785     120       0    4905    1329 kernel/module/kallsyms.o
      28577    4416     104   33097    8149 kernel/module/main.o
       1158       8       0    1166     48e kernel/module/procfs.o
        902     108       0    1010     3f2 kernel/module/strict_rwx.o
       3390       0       0    3390     d3e kernel/module/sysfs.o
        832       0       0     832     340 kernel/module/tree_lookup.o
      39644    4652     104   44400    ad70 (TOTALS)

 2) Aaron added module unload taint tracking (MODULE_UNLOAD_TAINT_TRACKING),
    so to enable tracking unloaded modules which did taint the kernel.

 3) Christophe Leroy added CONFIG_ARCH_WANTS_MODULES_DATA_IN_VMALLOC
    which lets architectures to request having modules data in vmalloc
    area instead of module area. There are three reasons why an
    architecture might want this:

    a) On some architectures (like book3s/32) it is not possible to protect
       against execution on a page basis. The exec stuff can be mapped by
       different arch segment sizes (on book3s/32 that is 256M segments). By
       default the module area is in an Exec segment while vmalloc area is in
       a NoExec segment. Using vmalloc lets you muck with module data as
       NoExec on those architectures whereas before you could not.

    b) By pushing more module data to vmalloc you also increase the
       probability of module text to remain within a closer distance
       from kernel core text and this reduces trampolines, this has been
       reported on arm first and powerpc folks are following that lead.

    c) Free'ing module_alloc() (Exec by default) area leaves this
       exposed as Exec by default, some architectures have some
       security enhancements to set this as NoExec on free, and splitting
       module data with text let's future generic special allocators
       be added to the kernel without having developers try to grok
       the tribal knowledge per arch. Work like Rick Edgecombe's
       permission vmalloc interface [0] becomes easier to address over
       time.

       [0] https://lore.kernel.org/lkml/20201120202426.18009-1-rick.p.edgecombe@intel.com/#r

 4) Masahiro Yamada's symbol search enhancements

----------------------------------------------------------------
Aaron Tomlin (17):
      module: Move all into module/
      module: Simple refactor in preparation for split
      module: Make internal.h and decompress.c more compliant
      module: Move livepatch support to a separate file
      module: Move latched RB-tree support to a separate file
      module: Move strict rwx support to a separate file
      module: Move extra signature support out of core code
      module: Move kmemleak support to a separate file
      module: Move kallsyms support into a separate file
      module: kallsyms: Fix suspicious rcu usage
      module: Move procfs support into a separate file
      module: Move sysfs support into a separate file
      module: Move kdb module related code out of main kdb code
      module: Move version support into a separate file
      module: Make module_flags_taint() accept a module's taints bitmap and usable outside core code
      module: Move module_assert_mutex_or_preempt() to internal.h
      module: Introduce module unload taint tracking

Alexey Dobriyan (1):
      module: fix [e_shstrndx].sh_size=0 OOB access

Christophe Leroy (10):
      module: Make module_enable_x() independent of CONFIG_ARCH_HAS_STRICT_MODULE_RWX
      module: Move module_enable_x() and frob_text() in strict_rwx.c
      module: Rework layout alignment to avoid BUG_ON()s
      module: Rename debug_align() as strict_align()
      module: Always have struct mod_tree_root
      module: Prepare for handling several RB trees
      module: Introduce data_layout
      module: Add CONFIG_ARCH_WANTS_MODULES_DATA_IN_VMALLOC
      module: Remove module_addr_min and module_addr_max
      powerpc: Select ARCH_WANTS_MODULES_DATA_IN_VMALLOC on book3s/32 and 8xx

Greg Kroah-Hartman (1):
      module.h: simplify MODULE_IMPORT_NS

Lecopzer Chen (1):
      module: show disallowed symbol name for inherit_taint()

Masahiro Yamada (3):
      module: do not pass opaque pointer for symbol search
      module: do not binary-search in __ksymtab_gpl if fsa->gplok is false
      module: merge check_exported_symbol() into find_exported_symbol_in_section()

 MAINTAINERS                                        |    4 +-
 arch/Kconfig                                       |    6 +
 arch/powerpc/Kconfig                               |    1 +
 include/linux/kdb.h                                |    1 +
 include/linux/module.h                             |   32 +-
 init/Kconfig                                       |   11 +
 kernel/Makefile                                    |    5 +-
 kernel/debug/kdb/kdb_io.c                          |    1 -
 kernel/debug/kdb/kdb_keyboard.c                    |    1 -
 kernel/debug/kdb/kdb_main.c                        |   49 -
 kernel/debug/kdb/kdb_private.h                     |    4 -
 kernel/debug/kdb/kdb_support.c                     |    1 -
 kernel/module-internal.h                           |   50 -
 kernel/module/Makefile                             |   21 +
 kernel/module/debug_kmemleak.c                     |   30 +
 .../{module_decompress.c => module/decompress.c}   |    5 +-
 kernel/module/internal.h                           |  302 +++
 kernel/module/kallsyms.c                           |  512 +++++
 kernel/module/kdb.c                                |   62 +
 kernel/module/livepatch.c                          |   74 +
 kernel/{module.c => module/main.c}                 | 2081 ++------------------
 kernel/module/procfs.c                             |  146 ++
 kernel/module/signing.c                            |  122 ++
 kernel/module/strict_rwx.c                         |  143 ++
 kernel/module/sysfs.c                              |  436 ++++
 kernel/module/tracking.c                           |   61 +
 kernel/module/tree_lookup.c                        |  117 ++
 kernel/module/version.c                            |  109 +
 kernel/module_signing.c                            |   45 -
 29 files changed, 2382 insertions(+), 2050 deletions(-)
 delete mode 100644 kernel/module-internal.h
 create mode 100644 kernel/module/Makefile
 create mode 100644 kernel/module/debug_kmemleak.c
 rename kernel/{module_decompress.c => module/decompress.c} (99%)
 create mode 100644 kernel/module/internal.h
 create mode 100644 kernel/module/kallsyms.c
 create mode 100644 kernel/module/kdb.c
 create mode 100644 kernel/module/livepatch.c
 rename kernel/{module.c => module/main.c} (61%)
 create mode 100644 kernel/module/procfs.c
 create mode 100644 kernel/module/signing.c
 create mode 100644 kernel/module/strict_rwx.c
 create mode 100644 kernel/module/sysfs.c
 create mode 100644 kernel/module/tracking.c
 create mode 100644 kernel/module/tree_lookup.c
 create mode 100644 kernel/module/version.c
 delete mode 100644 kernel/module_signing.c
