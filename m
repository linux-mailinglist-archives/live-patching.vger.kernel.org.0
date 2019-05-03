Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAED11303E
	for <lists+live-patching@lfdr.de>; Fri,  3 May 2019 16:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbfECOao (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 May 2019 10:30:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:45536 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726720AbfECOao (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 May 2019 10:30:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 70F80AEBA;
        Fri,  3 May 2019 14:30:42 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        live-patching@vger.kernel.org, Petr Mladek <pmladek@suse.com>
Subject: [PATCH 2/2] docs/livepatch: Unify style of livepatch documentation in the ReST format
Date:   Fri,  3 May 2019 16:30:24 +0200
Message-Id: <20190503143024.28358-3-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190503143024.28358-1-pmladek@suse.com>
References: <20190503143024.28358-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Make the structure of "Livepatch module Elf format" document similar
to the main "Livepatch" document.

Also make the structure of "(Un)patching Callbacks" document similar
to the "Shadow Variables" document.

It fixes the most visible inconsistencies of the documentation
generated from the ReST format.

Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/livepatch/callbacks.rst         |  33 ++---
 Documentation/livepatch/module-elf-format.rst | 186 ++++++++++++--------------
 2 files changed, 104 insertions(+), 115 deletions(-)

diff --git a/Documentation/livepatch/callbacks.rst b/Documentation/livepatch/callbacks.rst
index d76d1f0d9fcf..470944aa8658 100644
--- a/Documentation/livepatch/callbacks.rst
+++ b/Documentation/livepatch/callbacks.rst
@@ -4,7 +4,7 @@
 
 Livepatch (un)patch-callbacks provide a mechanism for livepatch modules
 to execute callback functions when a kernel object is (un)patched.  They
-can be considered a "power feature" that extends livepatching abilities
+can be considered a **power feature** that **extends livepatching abilities**
 to include:
 
   - Safe updates to global data
@@ -17,6 +17,9 @@ In most cases, (un)patch callbacks will need to be used in conjunction
 with memory barriers and kernel synchronization primitives, like
 mutexes/spinlocks, or even stop_machine(), to avoid concurrency issues.
 
+1. Motivation
+=============
+
 Callbacks differ from existing kernel facilities:
 
   - Module init/exit code doesn't run when disabling and re-enabling a
@@ -28,6 +31,9 @@ Callbacks are part of the klp_object structure and their implementation
 is specific to that klp_object.  Other livepatch objects may or may not
 be patched, irrespective of the target klp_object's current state.
 
+2. Callback types
+=================
+
 Callbacks can be registered for the following livepatch actions:
 
   * Pre-patch
@@ -47,6 +53,9 @@ be patched, irrespective of the target klp_object's current state.
                    been restored and no tasks are running patched code,
                    used to cleanup pre-patch callback resources
 
+3. How it works
+===============
+
 Each callback is optional, omitting one does not preclude specifying any
 other.  However, the livepatching core executes the handlers in
 symmetry: pre-patch callbacks have a post-unpatch counterpart and
@@ -90,11 +99,14 @@ If the object did successfully patch, but the patch transition never
 started for some reason (e.g., if another object failed to patch),
 only the post-unpatch callback will be called.
 
+4. Use cases
+============
 
-Example Use-cases
-=================
+Sample livepatch modules demonstrating the callback API can be found in
+samples/livepatch/ directory.  These samples were modified for use in
+kselftests and can be found in the lib/livepatch directory.
 
-Update global data
+Global data update
 ------------------
 
 A pre-patch callback can be useful to update a global variable.  For
@@ -107,24 +119,15 @@ patch the data *after* patching is complete with a post-patch callback,
 so that tcp_send_challenge_ack() could first be changed to read
 sysctl_tcp_challenge_ack_limit with READ_ONCE.
 
-
-Support __init and probe function patches
+__init and probe function patches support
 -----------------------------------------
 
 Although __init and probe functions are not directly livepatch-able, it
 may be possible to implement similar updates via pre/post-patch
 callbacks.
 
-48900cb6af42 ("virtio-net: drop NETIF_F_FRAGLIST") change the way that
+The commit ``48900cb6af42 ("virtio-net: drop NETIF_F_FRAGLIST")`` change the way that
 virtnet_probe() initialized its driver's net_device features.  A
 pre/post-patch callback could iterate over all such devices, making a
 similar change to their hw_features value.  (Client functions of the
 value may need to be updated accordingly.)
-
-
-Other Examples
-==============
-
-Sample livepatch modules demonstrating the callback API can be found in
-samples/livepatch/ directory.  These samples were modified for use in
-kselftests and can be found in the lib/livepatch directory.
diff --git a/Documentation/livepatch/module-elf-format.rst b/Documentation/livepatch/module-elf-format.rst
index 7f557c6f6deb..2a591e6f8e6c 100644
--- a/Documentation/livepatch/module-elf-format.rst
+++ b/Documentation/livepatch/module-elf-format.rst
@@ -7,30 +7,18 @@ This document outlines the Elf format requirements that livepatch modules must f
 
 .. Table of Contents
 
-   0. Background and motivation
-   1. Livepatch modinfo field
-   2. Livepatch relocation sections
-      2.1 What are livepatch relocation sections?
-      2.2 Livepatch relocation section format
-          2.2.1 Required flags
-          2.2.2 Required name format
-          2.2.3 Example livepatch relocation section names
-          2.2.4 Example `readelf --sections` output
-          2.2.5 Example `readelf --relocs` output
-   3. Livepatch symbols
-      3.1 What are livepatch symbols?
-      3.2 A livepatch module's symbol table
-      3.3 Livepatch symbol format
-          3.3.1 Required flags
-          3.3.2 Required name format
-          3.3.3 Example livepatch symbol names
-          3.3.4 Example `readelf --symbols` output
-   4. Architecture-specific sections
-   5. Symbol table and Elf section access
-
-----------------------------
-0. Background and motivation
-----------------------------
+   1. Background and motivation
+   2. Livepatch modinfo field
+   3. Livepatch relocation sections
+      3.1 Livepatch relocation section format
+   4. Livepatch symbols
+      4.1 A livepatch module's symbol table
+      4.2 Livepatch symbol format
+   5. Architecture-specific sections
+   6. Symbol table and Elf section access
+
+1. Background and motivation
+============================
 
 Formerly, livepatch required separate architecture-specific code to write
 relocations. However, arch-specific code to write relocations already
@@ -52,8 +40,8 @@ relocation sections and symbols, which are described in this document. The
 Elf constants used to mark livepatch symbols and relocation sections were
 selected from OS-specific ranges according to the definitions from glibc.
 
-0.1 Why does livepatch need to write its own relocations?
----------------------------------------------------------
+Why does livepatch need to write its own relocations?
+-----------------------------------------------------
 A typical livepatch module contains patched versions of functions that can
 reference non-exported global symbols and non-included local symbols.
 Relocations referencing these types of symbols cannot be left in as-is
@@ -72,13 +60,8 @@ relas reference are special livepatch symbols (see section 2 and 3). The
 arch-specific livepatch relocation code is replaced by a call to
 apply_relocate_add().
 
-================================
-PATCH MODULE FORMAT REQUIREMENTS
-================================
-
---------------------------
-1. Livepatch modinfo field
---------------------------
+2. Livepatch modinfo field
+==========================
 
 Livepatch modules are required to have the "livepatch" modinfo attribute.
 See the sample livepatch module in samples/livepatch/ for how this is done.
@@ -87,8 +70,10 @@ Livepatch modules can be identified by users by using the 'modinfo' command
 and looking for the presence of the "livepatch" field. This field is also
 used by the kernel module loader to identify livepatch modules.
 
-Example modinfo output:
------------------------
+Example:
+--------
+
+**Modinfo output:**
 
 ::
 
@@ -99,13 +84,9 @@ used by the kernel module loader to identify livepatch modules.
 	depends:
 	vermagic:		4.3.0+ SMP mod_unload
 
---------------------------------
-2. Livepatch relocation sections
---------------------------------
+3. Livepatch relocation sections
+================================
 
--------------------------------------------
-2.1 What are livepatch relocation sections?
--------------------------------------------
 A livepatch module manages its own Elf relocation sections to apply
 relocations to modules as well as to the kernel (vmlinux) at the
 appropriate time. For example, if a patch module patches a driver that is
@@ -130,12 +111,9 @@ Every symbol referenced by a rela in a livepatch relocation section is a
 livepatch symbol. These must be resolved before livepatch can call
 apply_relocate_add(). See Section 3 for more information.
 
----------------------------------------
-2.2 Livepatch relocation section format
----------------------------------------
+3.1 Livepatch relocation section format
+=======================================
 
-2.2.1 Required flags
---------------------
 Livepatch relocation sections must be marked with the SHF_RELA_LIVEPATCH
 section flag. See include/uapi/linux/elf.h for the definition. The module
 loader recognizes this flag and will avoid applying those relocation sections
@@ -143,8 +121,6 @@ at patch module load time. These sections must also be marked with SHF_ALLOC,
 so that the module loader doesn't discard them on module load (i.e. they will
 be copied into memory along with the other SHF_ALLOC sections).
 
-2.2.2 Required name format
---------------------------
 The name of a livepatch relocation section must conform to the following
 format::
 
@@ -153,19 +129,28 @@ The name of a livepatch relocation section must conform to the following
   |________||_____| |__________|
      [A]      [B]        [C]
 
-  [A] The relocation section name is prefixed with the string ".klp.rela."
-  [B] The name of the object (i.e. "vmlinux" or name of module) to
-      which the relocation section belongs follows immediately after the prefix.
-  [C] The actual name of the section to which this relocation section applies.
+[A]
+  The relocation section name is prefixed with the string ".klp.rela."
 
-2.2.3 Example livepatch relocation section names:
--------------------------------------------------
-.klp.rela.ext4.text.ext4_attr_store
-.klp.rela.vmlinux.text.cmdline_proc_show
+[B]
+  The name of the object (i.e. "vmlinux" or name of module) to
+  which the relocation section belongs follows immediately after the prefix.
 
-2.2.4 Example `readelf --sections` output for a patch
-module that patches vmlinux and modules 9p, btrfs, ext4:
---------------------------------------------------------
+[C]
+  The actual name of the section to which this relocation section applies.
+
+Examples:
+---------
+
+**Livepatch relocation section names:**
+
+::
+
+  .klp.rela.ext4.text.ext4_attr_store
+  .klp.rela.vmlinux.text.cmdline_proc_show
+
+**`readelf --sections` output for a patch
+module that patches vmlinux and modules 9p, btrfs, ext4:**
 
 ::
 
@@ -182,13 +167,14 @@ The name of a livepatch relocation section must conform to the following
   [ snip ]                                       ^                                             ^
                                                  |                                             |
                                                 [*]                                           [*]
-  [*] Livepatch relocation sections are SHT_RELA sections but with a few special
+
+[*]
+  Livepatch relocation sections are SHT_RELA sections but with a few special
   characteristics. Notice that they are marked SHF_ALLOC ("A") so that they will
   not be discarded when the module is loaded into memory, as well as with the
   SHF_RELA_LIVEPATCH flag ("o" - for OS-specific).
 
-2.2.5 Example `readelf --relocs` output for a patch module:
------------------------------------------------------------
+**`readelf --relocs` output for a patch module:**
 
 ::
 
@@ -200,16 +186,14 @@ The name of a livepatch relocation section must conform to the following
   000000000000004c  0000004900000002 R_X86_64_PC32          0000000000000000 .klp.sym.vmlinux.snprintf,0 - 4
   [ snip ]                                                                   ^
                                                                              |
-                                                                          [*]
-  [*] Every symbol referenced by a relocation is a livepatch symbol.
+                                                                            [*]
+
+[*]
+  Every symbol referenced by a relocation is a livepatch symbol.
 
---------------------
-3. Livepatch symbols
---------------------
+4. Livepatch symbols
+====================
 
--------------------------------
-3.1 What are livepatch symbols?
--------------------------------
 Livepatch symbols are symbols referred to by livepatch relocation sections.
 These are symbols accessed from new versions of functions for patched
 objects, whose addresses cannot be resolved by the module loader (because
@@ -229,9 +213,8 @@ loader can identify and ignore them. Livepatch modules keep these symbols
 in their symbol tables, and the symbol table is made accessible through
 module->symtab.
 
--------------------------------------
-3.2 A livepatch module's symbol table
--------------------------------------
+4.1 A livepatch module's symbol table
+=====================================
 Normally, a stripped down copy of a module's symbol table (containing only
 "core" symbols) is made available through module->symtab (See layout_symtab()
 in kernel/module.c). For livepatch modules, the symbol table copied into memory
@@ -255,18 +238,13 @@ preserved in order for apply_relocate_add() to find the right symbol.
   94: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT OS [0xff20] .klp.sym.vmlinux.printk,0
   [ snip ]
 
----------------------------
-3.3 Livepatch symbol format
----------------------------
+4.2 Livepatch symbol format
+===========================
 
-3.3.1 Required flags
---------------------
 Livepatch symbols must have their section index marked as SHN_LIVEPATCH, so
 that the module loader can identify them and not attempt to resolve them.
 See include/uapi/linux/elf.h for the actual definitions.
 
-3.3.2 Required name format
---------------------------
 Livepatch symbol names must conform to the following format::
 
   .klp.sym.objname.symbol_name,sympos
@@ -274,17 +252,26 @@ See include/uapi/linux/elf.h for the actual definitions.
   |_______||_____| |_________| |
      [A]     [B]       [C]    [D]
 
-  [A] The symbol name is prefixed with the string ".klp.sym."
-  [B] The name of the object (i.e. "vmlinux" or name of module) to
-      which the symbol belongs follows immediately after the prefix.
-  [C] The actual name of the symbol.
-  [D] The position of the symbol in the object (as according to kallsyms)
-      This is used to differentiate duplicate symbols within the same
-      object. The symbol position is expressed numerically (0, 1, 2...).
-      The symbol position of a unique symbol is 0.
+[A]
+  The symbol name is prefixed with the string ".klp.sym."
+
+[B]
+  The name of the object (i.e. "vmlinux" or name of module) to
+  which the symbol belongs follows immediately after the prefix.
 
-3.3.3 Example livepatch symbol names:
--------------------------------------
+[C]
+  The actual name of the symbol.
+
+[D]
+  The position of the symbol in the object (as according to kallsyms)
+  This is used to differentiate duplicate symbols within the same
+  object. The symbol position is expressed numerically (0, 1, 2...).
+  The symbol position of a unique symbol is 0.
+
+Examples:
+---------
+
+**Livepatch symbol names:**
 
 ::
 
@@ -292,8 +279,7 @@ See include/uapi/linux/elf.h for the actual definitions.
 	.klp.sym.vmlinux.printk,0
 	.klp.sym.btrfs.btrfs_ktype,0
 
-3.3.4 Example `readelf --symbols` output for a patch module:
-------------------------------------------------------------
+**`readelf --symbols` output for a patch module:**
 
 ::
 
@@ -307,12 +293,13 @@ See include/uapi/linux/elf.h for the actual definitions.
     [ snip ]                                               ^
                                                            |
                                                           [*]
-  [*] Note that the 'Ndx' (Section index) for these symbols is SHN_LIVEPATCH (0xff20).
-      "OS" means OS-specific.
 
----------------------------------
-4. Architecture-specific sections
----------------------------------
+[*]
+  Note that the 'Ndx' (Section index) for these symbols is SHN_LIVEPATCH (0xff20).
+  "OS" means OS-specific.
+
+5. Architecture-specific sections
+=================================
 Architectures may override arch_klp_init_object_loaded() to perform
 additional arch-specific tasks when a target module loads, such as applying
 arch-specific sections. On x86 for example, we must apply per-object
@@ -321,9 +308,8 @@ These sections must be prefixed with ".klp.arch.$objname." so that they can
 be easily identified when iterating through a patch module's Elf sections
 (See arch/x86/kernel/livepatch.c for a complete example).
 
---------------------------------------
-5. Symbol table and Elf section access
---------------------------------------
+6. Symbol table and Elf section access
+======================================
 A livepatch module's symbol table is accessible through module->symtab.
 
 Since apply_relocate_add() requires access to a module's section headers,
-- 
2.16.4

