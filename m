Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 688E8140D34
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgAQPDj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:03:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:45270 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726827AbgAQPDj (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:03:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 20ECBBB71;
        Fri, 17 Jan 2020 15:03:36 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 00/23] livepatch: Split livepatch module per-object
Date:   Fri, 17 Jan 2020 16:03:00 +0100
Message-Id: <20200117150323.21801-1-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

first, do not get scared by the size of the patchset. There are only
few patches that are really complicated and need attention at this
stage. I just wanted to split it as much as possible to review
and discuss each change separately.

Now to the problem. There are long term complains about maintainability
of the arch-specific code that is needed to livepatch modules that
are loaded after the livepatch itself.

There was always an idea about splitting the livepatch module
per-livepatched object. One interesting approach was drafted
on the last Livepatch microconference at Linux Plubmers 2019.

I played with the idea and came up with this POC. Of course,
there are pros and cons.

On the positive note:

    + The approach seems to work.

    + The same scenarios are supported. It is even newly possible to use
      the livepatch-specific relocations and reload the livepatched module.

    + The livepatch-specific relocations are still needed but
      they are handled together with other relocations. As
      a result, the other code modifications work out of box,
      e.g. alternatives, parainstructions.

    + Some problematic code could get removed (last 4 patches):

      + module_disable_ro()
      + arch_klp_init_object_loaded()
      + copy_module_elf()

    + The amount if livepatch-specific hooks in the module loader
      is about the same. They are _not_ longer arch-specific. But
      they are a bit tricky, see negatives below.


On the negative side:

    + It adds dependency on userspace tool "modprobe" called
      via usermodhelper. It brings several new problems:

       + How to distinguish modprobe called by user or by kernel
         when resolving races and errors.

       + How to pass the real error code to the usermodhelper caller.

       + Automatic dependencies are generated and handled in
         the userspace. Might create unwanted cyclic load.
	 It requires crazy workarounds from the kernel side,
	 see the patch 19.

     + There is a new bunch of races that sometimes need a tricky
       solution. For example, see the patches 8, 9, 15.

     + It might be slightly more complicated to prepare and use
       the livepatches. There are more modules that need to built
       and are visibly to the administrators. Also it complicates
       sharing some common helper functionality.


From my point of view. The new code is much less arch-dependent
and more self-contained. Therefore it should be easier to maintain
in the long term.

On the other hand, it is more tricky regarding possible races and
infinite loops. They are not always easy to solve because of
"modprobe" called via userspace and because of more switches
between klp_mutex and module_mutex guarded code. Anyway, once
this is solved, it should just work for a long time as is.

All in all, I think that this approach is worth exploring.
I am curious about your opinion.

Best Regards,
Petr

PS: The patchset applies against Linus' master (v5.5-rc6).

Petr Mladek (23):
  module: Allow to delete module also from inside kernel
  livepatch: Split livepatch modules per livepatched object
  livepatch: Better checks of struct klp_object definition
  livepatch: Prevent loading livepatch sub-module unintentionally.
  livepatch: Initialize and free livepatch submodule
  livepatch: Enable the livepatch submodule
  livepatch: Remove obsolete functionality from klp_module_coming()
  livepatch: Automatically load livepatch module when the patch module
    is loaded
  livepatch: Handle race when livepatches are reloaded during a module
    load
  livepatch: Handle modprobe exit code
  livepatch: Safely detect forced transition when removing split
    livepatch modules
  livepatch: Automatically remove livepatch module when the object is
    freed
  livepatch: Remove livepatch module when the livepatched module is
    unloaded
  livepatch: Never block livepatch modules when the related module is
    being removed
  livepatch: Prevent infinite loop when loading livepatch module
  livepatch: Add patch into the global list early
  livepatch: Load livepatches for modules when loading  the main
    livepatch
  module: Refactor add_unformed_module()
  module/livepatch: Allow to use exported symbols from livepatch module
    for "vmlinux"
  module/livepatch: Relocate local variables in the module loaded when
    the livepatch is being loaded
  livepatch: Remove obsolete arch_klp_init_object_loaded()
  livepatch/module: Remove obsolete copy_module_elf()
  module: Remove obsolete module_disable_ro()

 Documentation/livepatch/module-elf-format.rst      |  15 +-
 arch/x86/kernel/Makefile                           |   1 -
 arch/x86/kernel/livepatch.c                        |  53 --
 include/linux/livepatch.h                          |  36 +-
 include/linux/module.h                             |  10 +-
 kernel/livepatch/core.c                            | 743 ++++++++++++++-------
 kernel/livepatch/core.h                            |   5 -
 kernel/livepatch/transition.c                      |  22 +-
 kernel/module.c                                    | 279 ++++----
 lib/livepatch/Makefile                             |   2 +
 lib/livepatch/test_klp_atomic_replace.c            |  18 +-
 lib/livepatch/test_klp_callbacks_demo.c            |  90 ++-
 lib/livepatch/test_klp_callbacks_demo.h            |  11 +
 lib/livepatch/test_klp_callbacks_demo2.c           |  62 +-
 lib/livepatch/test_klp_callbacks_demo2.h           |  11 +
 ...t_klp_callbacks_demo__test_klp_callbacks_busy.c |  50 ++
 ...st_klp_callbacks_demo__test_klp_callbacks_mod.c |  42 ++
 lib/livepatch/test_klp_livepatch.c                 |  18 +-
 lib/livepatch/test_klp_state.c                     |  53 +-
 lib/livepatch/test_klp_state2.c                    |  53 +-
 samples/livepatch/Makefile                         |   4 +
 samples/livepatch/livepatch-callbacks-demo.c       |  90 ++-
 samples/livepatch/livepatch-callbacks-demo.h       |  11 +
 ...h-callbacks-demo__livepatch-callbacks-busymod.c |  54 ++
 ...patch-callbacks-demo__livepatch-callbacks-mod.c |  46 ++
 samples/livepatch/livepatch-sample.c               |  18 +-
 samples/livepatch/livepatch-shadow-fix1.c          | 120 +---
 .../livepatch-shadow-fix1__livepatch-shadow-mod.c  | 155 +++++
 samples/livepatch/livepatch-shadow-fix2.c          |  92 +--
 .../livepatch-shadow-fix2__livepatch-shadow-mod.c  | 127 ++++
 .../testing/selftests/livepatch/test-callbacks.sh  |  19 +-
 31 files changed, 1424 insertions(+), 886 deletions(-)
 delete mode 100644 arch/x86/kernel/livepatch.c
 create mode 100644 lib/livepatch/test_klp_callbacks_demo.h
 create mode 100644 lib/livepatch/test_klp_callbacks_demo2.h
 create mode 100644 lib/livepatch/test_klp_callbacks_demo__test_klp_callbacks_busy.c
 create mode 100644 lib/livepatch/test_klp_callbacks_demo__test_klp_callbacks_mod.c
 create mode 100644 samples/livepatch/livepatch-callbacks-demo.h
 create mode 100644 samples/livepatch/livepatch-callbacks-demo__livepatch-callbacks-busymod.c
 create mode 100644 samples/livepatch/livepatch-callbacks-demo__livepatch-callbacks-mod.c
 create mode 100644 samples/livepatch/livepatch-shadow-fix1__livepatch-shadow-mod.c
 create mode 100644 samples/livepatch/livepatch-shadow-fix2__livepatch-shadow-mod.c

-- 
2.16.4

