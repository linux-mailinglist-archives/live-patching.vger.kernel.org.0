Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D60418C00
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2019 16:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfEIOjR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 May 2019 10:39:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48866 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbfEIOjQ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 May 2019 10:39:16 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CA0F9308FF32;
        Thu,  9 May 2019 14:39:15 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (ovpn-123-90.rdu2.redhat.com [10.10.123.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2BDD5DF49;
        Thu,  9 May 2019 14:39:14 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH v4 08/10] documentation: Update on livepatch elf format
Date:   Thu,  9 May 2019 10:38:57 -0400
Message-Id: <20190509143859.9050-9-joe.lawrence@redhat.com>
In-Reply-To: <20190509143859.9050-1-joe.lawrence@redhat.com>
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 09 May 2019 14:39:15 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Joao Moreira <jmoreira@suse.de>

Add a section to Documentation/livepatch/module-elf-format.txt
describing how klp-convert works for fixing relocations.

Signed-off-by: Joao Moreira <jmoreira@suse.de>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 Documentation/livepatch/livepatch.txt         |  3 ++
 Documentation/livepatch/module-elf-format.txt | 50 ++++++++++++++++---
 2 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/Documentation/livepatch/livepatch.txt b/Documentation/livepatch/livepatch.txt
index 4627b41ff02e..873c11aee038 100644
--- a/Documentation/livepatch/livepatch.txt
+++ b/Documentation/livepatch/livepatch.txt
@@ -274,6 +274,9 @@ into three levels:
     absolute position in the database, but rather the order it has been found
     only for a particular object ( vmlinux or a kernel module ). Note that
     kallsyms allows for searching symbols according to the object name.
+    Uniquely named symbols may use a symbol position of 0.  Non-unique
+    symbols need to specify their object / kallsyms position, starting
+    at position 1.
 
   + struct klp_object defines an array of patched functions (struct
     klp_func) in the same object. Where the object is either vmlinux
diff --git a/Documentation/livepatch/module-elf-format.txt b/Documentation/livepatch/module-elf-format.txt
index f21a5289a09c..7bef8432352a 100644
--- a/Documentation/livepatch/module-elf-format.txt
+++ b/Documentation/livepatch/module-elf-format.txt
@@ -2,7 +2,8 @@
 Livepatch module Elf format
 ===========================
 
-This document outlines the Elf format requirements that livepatch modules must follow.
+This document outlines the Elf format requirements that livepatch modules must
+follow.
 
 -----------------
 Table of Contents
@@ -25,8 +26,9 @@ Table of Contents
        3.3.2 Required name format
        3.3.3 Example livepatch symbol names
        3.3.4 Example `readelf --symbols` output
-4. Architecture-specific sections
-5. Symbol table and Elf section access
+4. Automatic conversion of unresolved relocations
+5. Architecture-specific sections
+6. Symbol table and Elf section access
 
 ----------------------------
 0. Background and motivation
@@ -270,7 +272,8 @@ Livepatch symbol names must conform to the following format:
 [D] The position of the symbol in the object (as according to kallsyms)
     This is used to differentiate duplicate symbols within the same
     object. The symbol position is expressed numerically (0, 1, 2...).
-    The symbol position of a unique symbol is 0.
+    The symbol position of a unique symbol is 0.  The symbol position of
+    the first non-unique symbol is 1, the second is 2, etc.
 
 3.3.3 Example livepatch symbol names:
 -------------------------------------
@@ -293,8 +296,43 @@ Symbol table '.symtab' contains 127 entries:
 [*] Note that the 'Ndx' (Section index) for these symbols is SHN_LIVEPATCH (0xff20).
     "OS" means OS-specific.
 
+--------------------------------------------------
+4.  Automatic conversion of unresolved relocations
+--------------------------------------------------
+Sometimes livepatches may operate on symbols which are not self-contained nor
+exported. When this happens, these symbols remain unresolved in the elf object
+and will trigger an error during the livepatch instantiation.
+
+Whenever possible, the kernel building infrastructure solves this problem
+automatically. First, a symbol database containing information on all compiled
+objects is built. Second, this database - a file named Symbols.list, placed in
+the kernel source root directory - is used to identify targets for unresolved
+relocations, converting them in the livepatch elf accordingly to the
+specifications above-described. While the first stage is fully handled by the
+building system, the second is done by a tool called klp-convert, which can be
+found in "scripts/livepatch".
+
+When an unresolved relocation has as target a symbol whose name is also used by
+different symbols throughout the kernel, the relocation cannot be resolved
+automatically. In these cases, the livepatch developer must add annotations to
+the livepatch, making it possible for the system to identify which is the
+correct target amongst multiple homonymous symbols. Such annotations must be
+done through a data structure as follows:
+
+struct KLP_MODULE_RELOC(object) data_structure_name[] = {
+	KLP_SYMPOS(symbol, pos)
+};
+
+In the above example, object refers to the object file which contains the
+symbol, being vmlinux or a module; symbol refers to the symbol name that will
+be relocated and pos is its position in the object.
+
+When a data structure like this is added to the livepatch, the resulting elf
+will hold symbols that will be identified by klp-convert and used to solve name
+ambiguities.
+
 ---------------------------------
-4. Architecture-specific sections
+5. Architecture-specific sections
 ---------------------------------
 Architectures may override arch_klp_init_object_loaded() to perform
 additional arch-specific tasks when a target module loads, such as applying
@@ -305,7 +343,7 @@ be easily identified when iterating through a patch module's Elf sections
 (See arch/x86/kernel/livepatch.c for a complete example).
 
 --------------------------------------
-5. Symbol table and Elf section access
+6. Symbol table and Elf section access
 --------------------------------------
 A livepatch module's symbol table is accessible through module->symtab.
 
-- 
2.20.1

