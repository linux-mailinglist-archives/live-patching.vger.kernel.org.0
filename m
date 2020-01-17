Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80700140D4F
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgAQPET (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:04:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:46214 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729187AbgAQPEF (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:04:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 636FCBBBC;
        Fri, 17 Jan 2020 15:04:03 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 21/23] livepatch: Remove obsolete arch_klp_init_object_loaded()
Date:   Fri, 17 Jan 2020 16:03:21 +0100
Message-Id: <20200117150323.21801-22-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The livepatch specific-relocation is finally done together with the normal
module relocations. As a result, alternatives, paraintructions, and other
architecture-specific modifications are done correctly by the module
loader out of box. There is no longer need to do them explicitely by
arch_klp_init_object_loaded().

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 Documentation/livepatch/module-elf-format.rst | 29 ---------------
 arch/x86/kernel/Makefile                      |  1 -
 arch/x86/kernel/livepatch.c                   | 52 ---------------------------
 include/linux/livepatch.h                     |  2 --
 kernel/livepatch/core.c                       | 11 ------
 5 files changed, 95 deletions(-)
 delete mode 100644 arch/x86/kernel/livepatch.c

diff --git a/Documentation/livepatch/module-elf-format.rst b/Documentation/livepatch/module-elf-format.rst
index 2a591e6f8e6c..9f0c997d4940 100644
--- a/Documentation/livepatch/module-elf-format.rst
+++ b/Documentation/livepatch/module-elf-format.rst
@@ -14,8 +14,6 @@ This document outlines the Elf format requirements that livepatch modules must f
    4. Livepatch symbols
       4.1 A livepatch module's symbol table
       4.2 Livepatch symbol format
-   5. Architecture-specific sections
-   6. Symbol table and Elf section access
 
 1. Background and motivation
 ============================
@@ -297,30 +295,3 @@ See include/uapi/linux/elf.h for the actual definitions.
 [*]
   Note that the 'Ndx' (Section index) for these symbols is SHN_LIVEPATCH (0xff20).
   "OS" means OS-specific.
-
-5. Architecture-specific sections
-=================================
-Architectures may override arch_klp_init_object_loaded() to perform
-additional arch-specific tasks when a target module loads, such as applying
-arch-specific sections. On x86 for example, we must apply per-object
-.altinstructions and .parainstructions sections when a target module loads.
-These sections must be prefixed with ".klp.arch.$objname." so that they can
-be easily identified when iterating through a patch module's Elf sections
-(See arch/x86/kernel/livepatch.c for a complete example).
-
-6. Symbol table and Elf section access
-======================================
-A livepatch module's symbol table is accessible through module->symtab.
-
-Since apply_relocate_add() requires access to a module's section headers,
-symbol table, and relocation section indices, Elf information is preserved for
-livepatch modules and is made accessible by the module loader through
-module->klp_info, which is a klp_modinfo struct. When a livepatch module loads,
-this struct is filled in by the module loader. Its fields are documented below::
-
-	struct klp_modinfo {
-		Elf_Ehdr hdr; /* Elf header */
-		Elf_Shdr *sechdrs; /* Section header table */
-		char *secstrings; /* String table for the section headers */
-		unsigned int symndx; /* The symbol table section index */
-	};
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 6175e370ee4a..21540cac67b9 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -89,7 +89,6 @@ obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-y				+= apic/
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
-obj-$(CONFIG_LIVEPATCH)	+= livepatch.o
 obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace_$(BITS).o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
 obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
diff --git a/arch/x86/kernel/livepatch.c b/arch/x86/kernel/livepatch.c
deleted file mode 100644
index 728b44eaa168..000000000000
--- a/arch/x86/kernel/livepatch.c
+++ /dev/null
@@ -1,52 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * livepatch.c - x86-specific Kernel Live Patching Core
- */
-
-#include <linux/module.h>
-#include <linux/kallsyms.h>
-#include <linux/livepatch.h>
-#include <asm/text-patching.h>
-
-/* Apply per-object alternatives. Based on x86 module_finalize() */
-void arch_klp_init_object_loaded(struct klp_object *obj)
-{
-	int cnt;
-	struct klp_modinfo *info;
-	Elf_Shdr *s, *alt = NULL, *para = NULL;
-	void *aseg, *pseg;
-	const char *objname;
-	char sec_objname[MODULE_NAME_LEN];
-	char secname[KSYM_NAME_LEN];
-
-	info = obj->mod->klp_info;
-	objname = obj->name ? obj->name : "vmlinux";
-
-	/* See livepatch core code for BUILD_BUG_ON() explanation */
-	BUILD_BUG_ON(MODULE_NAME_LEN < 56 || KSYM_NAME_LEN != 128);
-
-	for (s = info->sechdrs; s < info->sechdrs + info->hdr.e_shnum; s++) {
-		/* Apply per-object .klp.arch sections */
-		cnt = sscanf(info->secstrings + s->sh_name,
-			     ".klp.arch.%55[^.].%127s",
-			     sec_objname, secname);
-		if (cnt != 2)
-			continue;
-		if (strcmp(sec_objname, objname))
-			continue;
-		if (!strcmp(".altinstructions", secname))
-			alt = s;
-		if (!strcmp(".parainstructions", secname))
-			para = s;
-	}
-
-	if (alt) {
-		aseg = (void *) alt->sh_addr;
-		apply_alternatives(aseg, aseg + alt->sh_size);
-	}
-
-	if (para) {
-		pseg = (void *) para->sh_addr;
-		apply_paravirt(pseg, pseg + para->sh_size);
-	}
-}
diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index d721e79ac691..3b27ef1a7291 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -204,8 +204,6 @@ struct klp_patch {
 int klp_enable_patch(struct klp_patch *);
 int klp_add_object(struct klp_object *);
 
-void arch_klp_init_object_loaded(struct klp_object *obj);
-
 /* Called from the module loader during module coming/going states */
 bool klp_break_recursion(struct module *mod);
 int klp_module_coming(struct module *mod);
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 4da6bbd687d0..cc0ac93fe8cd 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -701,23 +701,12 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
 			   func->old_sympos ? func->old_sympos : 1);
 }
 
-/* Arches may override this to finish any remaining arch-specific tasks */
-void __weak arch_klp_init_object_loaded(struct klp_object *obj)
-{
-}
-
 /* parts of the initialization that is done only when the object is loaded */
 static int klp_init_object_loaded(struct klp_object *obj)
 {
 	struct klp_func *func;
 	int ret;
 
-	mutex_lock(&text_mutex);
-	module_disable_ro(obj->mod);
-	arch_klp_init_object_loaded(obj);
-	module_enable_ro(obj->mod, true);
-	mutex_unlock(&text_mutex);
-
 	klp_for_each_func(obj, func) {
 		ret = klp_find_object_symbol(obj->name, func->old_name,
 					     func->old_sympos,
-- 
2.16.4

