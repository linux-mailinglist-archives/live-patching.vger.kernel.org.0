Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E54EA18BFD
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2019 16:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfEIOjI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 May 2019 10:39:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbfEIOjI (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 May 2019 10:39:08 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CB0DB18DF7C;
        Thu,  9 May 2019 14:39:07 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (ovpn-123-90.rdu2.redhat.com [10.10.123.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B1F75DF4B;
        Thu,  9 May 2019 14:39:05 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH v4 00/10] klp-convert livepatch build tooling
Date:   Thu,  9 May 2019 10:38:49 -0400
Message-Id: <20190509143859.9050-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 09 May 2019 14:39:07 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi all,

Thanks for the feedback to v3, I've incorporated a few more bug fixes
and style/spelling nitpicks for the series.  v4 is a bit of a resting
place to collect loose ends before considering some heavier future work,
namely arch-specific special section support.  See the TODO section
below for more details.


Previous versions
-----------------

RFC:
  https://lore.kernel.org/lkml/cover.1477578530.git.jpoimboe@redhat.com/
v2:
  https://lore.kernel.org/lkml/f52d29f7-7d1b-ad3d-050b-a9fa8878faf2@redhat.com/
v3:
  https://lore.kernel.org/lkml/20190410155058.9437-1-joe.lawrence@redhat.com/


Summary
-------

Livepatches may use symbols which are not contained in its own scope,
and, because of that, may end up compiled with relocations that will
only be resolved during module load. Yet, when the referenced symbols are
not exported, solving this relocation requires information on the object
that holds the symbol (either vmlinux or modules) and its position inside
the object, as an object may contain multiple symbols with the same name.
Providing such information must be done accordingly to what is specified
in Documentation/livepatch/module-elf-format.txt.

Currently, there is no trivial way to embed the required information as
requested in the final livepatch elf object. klp-convert solves this
problem in two different forms: (i) by relying on a symbol map, which is
built during kernel compilation, to automatically infer the relocation
targeted symbol, and, when such inference is not possible (ii) by using
annotations in the elf object to convert the relocation accordingly to
the specification, enabling it to be handled by the livepatch loader.

Given the above, add support for symbol mapping in the form of
Symbols.list file; add klp-convert tool; integrate klp-convert tool into
kbuild; make livepatch modules discernible during kernel compilation
pipeline; add data-structure and macros to enable users to annotate
livepatch source code; make modpost stage compatible with livepatches;
update livepatch-sample and update documentation.

The patch was tested under three use-cases:

use-case 1: There is a relocation in the lp that can be automatically
resolved by klp-convert.  For example. see the saved_command_line
variable in lib/livepatch/test_klp_convert2.c.

use-case 2: There is a relocation in the lp that cannot be automatically
resolved, as the name of the respective symbol appears in multiple
objects. The livepatch contains an annotation to enable a correct
relocation.  See the KLP_MODULE_RELOC / KLP_SYMPOS annotation sections
in lib/livepatch/test_klp_convert{1,2}.c.

use-case 3: There is a relocation in the lp that cannot be automatically
resolved similarly as 2, but no annotation was provided in the
livepatch, triggering an error during compilation.  Reproducible by
removing the KLP_MODULE_RELOC / KLP_SYMPOS annotation sections in
lib/livepatch/test_klp_convert{1,2}.c.


Branches
--------

For review purposes, I posted two branches up to github:

  1 - an expanded branch with changes separate from the original
  https://github.com/joe-lawrence/linux/tree/klp-convert-v4-expanded

  2 - a squashed branch of (1) that comprises v4:
  https://github.com/joe-lawrence/linux/tree/klp-convert-v4

Non-trivial commits in the expanded branch have some extra commentary
and details for debugging in the commit message that were dropped when
squashing into their respective parent commits.


TODO
----

Summarized from the v3 thread, thanks to Miroslav, Joao and Josh for
feedback and parsing my long braindumps.

- Special (architecture specific) section support:

  .altinstructions, .altinst_replacement
  .parainstructions
   __jump_table

  We want to apply livepatch relocations *before* these sections are
  processed.  Or more precisely, the special section data structures
  entries which directly or indirectly involve livepatch relocations.
  Those need to be extracted into "klp.arch" sections, a corresponding
  rela section generated, and the kernel needs supporting code to handle
  deferred processing.

  Note that there is already x86-arch code present for handling
  .altinstruction and .parainstructions sections in
  arch/x86/kernel/livepatch.c.

- Support for multiple homonym <object, name> symbols with unique
  <position> values.  Consider a target module with symbol table that
  looks like:

     29: ... FILE    LOCAL  DEFAULT      ABS test_klp_convert_mod_a.c
     32: ... FUNC    LOCAL  DEFAULT        3 get_homonym_string
     33: ... OBJECT  LOCAL  DEFAULT        5 homonym_string
     37: ... FILE    LOCAL  DEFAULT      ABS test_klp_convert_mod_b.c
     38: ... FUNC    LOCAL  DEFAULT        3 get_homonym_string
     39: ... OBJECT  LOCAL  DEFAULT       11 homonym_string

- The BFD library is incapable of handling two rela sections with
  identical sh_info values *as relocation sections*.  This affects
  binutils and related programs like gdb, objdump, crash utility, etc.
  which fail to process klp-converted .ko files.

  https://sourceware.org/bugzilla/show_bug.cgi?id=24456
  https://sourceware.org/ml/binutils/2019-04/msg00194.html


Changelogs
----------

livepatch: Create and include UAPI headers
  v2:
  - jmoreira: split up and changelog
  v3:
  - joe: convert to SPDX license tags
  v4:
  - joe: from Masahiro, update UAPI headers with "GPL-2.0 WITH
    Linux-syscall-note"
  - joe: from Masahiro, types.h isn't needed by UAPI header

kbuild: Support for Symbols.list creation
  v3:
  - jmoreira: adjust for multiobject livepatch
  - joe: add klpclean to PHONY
  - joe: align KLP prefix
  - joe: update all in-tree livepatches with LIVEPATCH_* modinfo flag
  v4:
  - joe: from Miroslav, update the samples and self-test Makefiles with
    the LIVEPATCH_ build prefix.
  - joe: from Artem, use $(SLIST) in klpclean and $(call cmd,livepatch)
    instead of $(call cmd_livepatch)

livepatch: Add klp-convert tool
  v2:
  - khlebnikov: use HOSTLOADLIBES_ instead of HOSTLDFLAGS: -lelf must be
    at the end
  - jmoreira: add support to automatic relocation conversion in
    klp-convert.c, changelog
  v3:
  - joe: convert to SPDX license tags
  - jmoreira: add rela symbol name to WARNs
  - jmoreira: ignore relocations to .TOC and symbols with index 0
  - joe: separate and fix valid_sympos() sympos=0 and sympos=1..n checks
  - joe: fix symbol use-after-frees
  - joe: fix remaining valgrind leak complaints (non-error paths only)
  - joe: checkpatch nits
  v4:
  - joe: spelling nits s/Insuficient/Insufficient and s/clasic/classic
  - joe: from Miroslav, tweak klp-convert usage msg
  - joe: don't move multiple list elements in convert_rela() 
  - joe: relax duplicate user symbol check

livepatch: Add klp-convert annotation helpers
  v2:
  - jmoreira: split up: move KLP_MODULE_RELOC from previous patch to
    here, add KLP_SYMPOS, move macros from include/uapi/livepatch.h to
    include/linux/livepatch.h
  v3:
  - joe: from Josh, KLP_MODULE_RELOC macro should 4-byte align
    klp_module_reloc structures
  v4:
  - joe: remove the ',' struct array delimiter from KLP_SYMPOS

modpost: Integrate klp-convert
  v2:
  - khlebnikov: save cmd_ld_ko_o into .module.cmd, if_changed_rule
    doesn't do that.f
  - khlebnikov: fix bashisms for debian where /bin/sh is a symlink to
    /bin/dash
  - khlebnikov: rename rule_link_module to rule_ld_ko_o, otherwise
    arg-check inside if_changed_rule compares cmd_link_module and
    cmd_ld_ko_o.
  - khlebnikov: check modinfo -F livepatch only if CONFIG_LIVEPATCH is
    true.
  - mbenes: remove modinfo call. LIVEPATCH_ in Makefile
  - jmoreira: split up: move the .livepatch file-based scheme for
    identifying livepatches to a previous patch, as it was required for
    correctly building Symbols.list there.
  v3:
  - joe: adjust rule_ld_ko_o to call echo-cmd
  - joe: rebase for v5.1
  - joe: align KLP prefix
  v4:
  - joe: rule_ld_ko_o should include $(Q) to honor build verbosity

modpost: Add modinfo flag to livepatch modules
  v2:
  - jmoreira: fix modpost.c (add_livepatch_flag) to update module
    structure with livepatch flag and prevent modpost from breaking due to
    unresolved symbols
  v3:
  - joe: adjust modpost.c::get_modinfo() call for v5.0 version
  - joe: from Miroslav: remove MODULE_INFO(livepatch, "Y") from samples

livepatch: Add sample livepatch module
  v2:
  - jmoreira: update module to use KLP_SYMPOS
  - jmoreira: Comments on symbol resolution scheme
  - jmoreira: Update Makefile
  - jmoreira: Remove MODULE_INFO statement
  - jmoreira: Changelog
  v3:
  - joe: rebase for v5.1
  - joe: code shuffle to better match original source file

documentation: Update on livepatch elf format
  v3:
  - joe: clarify sympos=0 and sympos=1..n

livepatch/selftests: add klp-convert
  v3 (new)
  v4:
  - joe: Add a ',' struct array delimiter after KLP_SYMPOS

livepatch/klp-convert: abort on special sections
  v4 (new)


Git boilerplate
---------------

Joao Moreira (2):
  kbuild: Support for Symbols.list creation
  documentation: Update on livepatch elf format

Joe Lawrence (2):
  livepatch/selftests: add klp-convert
  livepatch/klp-convert: abort on special sections

Josh Poimboeuf (5):
  livepatch: Create and include UAPI headers
  livepatch: Add klp-convert tool
  livepatch: Add klp-convert annotation helpers
  modpost: Integrate klp-convert
  livepatch: Add sample livepatch module

Miroslav Benes (1):
  modpost: Add modinfo flag to livepatch modules

 .gitignore                                    |   1 +
 Documentation/livepatch/livepatch.txt         |   3 +
 Documentation/livepatch/module-elf-format.txt |  50 +-
 MAINTAINERS                                   |   2 +
 Makefile                                      |  30 +-
 include/linux/livepatch.h                     |  13 +
 include/uapi/linux/livepatch.h                |  20 +
 kernel/livepatch/core.c                       |   4 +-
 lib/livepatch/Makefile                        |  15 +
 lib/livepatch/test_klp_atomic_replace.c       |   1 -
 lib/livepatch/test_klp_callbacks_demo.c       |   1 -
 lib/livepatch/test_klp_callbacks_demo2.c      |   1 -
 lib/livepatch/test_klp_convert1.c             | 106 +++
 lib/livepatch/test_klp_convert2.c             | 103 +++
 lib/livepatch/test_klp_convert_mod_a.c        |  25 +
 lib/livepatch/test_klp_convert_mod_b.c        |  13 +
 lib/livepatch/test_klp_livepatch.c            |   1 -
 samples/livepatch/Makefile                    |   6 +
 .../livepatch/livepatch-annotated-sample.c    | 102 +++
 samples/livepatch/livepatch-callbacks-demo.c  |   1 -
 samples/livepatch/livepatch-sample.c          |   1 -
 samples/livepatch/livepatch-shadow-fix1.c     |   1 -
 samples/livepatch/livepatch-shadow-fix2.c     |   1 -
 scripts/Kbuild.include                        |   4 +-
 scripts/Makefile                              |   1 +
 scripts/Makefile.build                        |   7 +
 scripts/Makefile.modpost                      |  24 +-
 scripts/livepatch/.gitignore                  |   1 +
 scripts/livepatch/Makefile                    |   7 +
 scripts/livepatch/elf.c                       | 753 ++++++++++++++++++
 scripts/livepatch/elf.h                       |  73 ++
 scripts/livepatch/klp-convert.c               | 731 +++++++++++++++++
 scripts/livepatch/klp-convert.h               |  39 +
 scripts/livepatch/list.h                      | 391 +++++++++
 scripts/mod/modpost.c                         |  82 +-
 scripts/mod/modpost.h                         |   1 +
 .../selftests/livepatch/test-livepatch.sh     |  64 ++
 37 files changed, 2653 insertions(+), 26 deletions(-)
 create mode 100644 include/uapi/linux/livepatch.h
 create mode 100644 lib/livepatch/test_klp_convert1.c
 create mode 100644 lib/livepatch/test_klp_convert2.c
 create mode 100644 lib/livepatch/test_klp_convert_mod_a.c
 create mode 100644 lib/livepatch/test_klp_convert_mod_b.c
 create mode 100644 samples/livepatch/livepatch-annotated-sample.c
 create mode 100644 scripts/livepatch/.gitignore
 create mode 100644 scripts/livepatch/Makefile
 create mode 100644 scripts/livepatch/elf.c
 create mode 100644 scripts/livepatch/elf.h
 create mode 100644 scripts/livepatch/klp-convert.c
 create mode 100644 scripts/livepatch/klp-convert.h
 create mode 100644 scripts/livepatch/list.h

-- 
2.20.1

