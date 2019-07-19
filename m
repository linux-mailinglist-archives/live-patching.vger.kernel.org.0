Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3842A6E5B1
	for <lists+live-patching@lfdr.de>; Fri, 19 Jul 2019 14:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfGSM2s (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 19 Jul 2019 08:28:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:49134 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727891AbfGSM2o (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 19 Jul 2019 08:28:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 477C4AF6B;
        Fri, 19 Jul 2019 12:28:43 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     jikos@kernel.org, jpoimboe@redhat.com, pmladek@suse.com
Cc:     joe.lawrence@redhat.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>
Subject: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module removal
Date:   Fri, 19 Jul 2019 14:28:40 +0200
Message-Id: <20190719122840.15353-3-mbenes@suse.cz>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190719122840.15353-1-mbenes@suse.cz>
References: <20190719122840.15353-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Josh reported a bug:

  When the object to be patched is a module, and that module is
  rmmod'ed and reloaded, it fails to load with:

  module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
  livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
  livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'

  The livepatch module has a relocation which references a symbol
  in the _previous_ loading of nfsd. When apply_relocate_add()
  tries to replace the old relocation with a new one, it sees that
  the previous one is nonzero and it errors out.

  On ppc64le, we have a similar issue:

  module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
  livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
  livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'

He also proposed three different solutions. We could remove the error
check in apply_relocate_add() introduced by commit eda9cec4c9a1
("x86/module: Detect and skip invalid relocations"). However the check
is useful for detecting corrupted modules.

We could also deny the patched modules to be removed. If it proved to be
a major drawback for users, we could still implement a different
approach. The solution would also complicate the existing code a lot.

We thus decided to reverse the relocation patching (clear all relocation
targets on x86_64, or return back nops on powerpc). The solution is not
universal and is too much arch-specific, but it may prove to be simpler
in the end.

Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
 arch/powerpc/kernel/Makefile    |  1 +
 arch/powerpc/kernel/livepatch.c | 75 +++++++++++++++++++++++++++++++++
 arch/powerpc/kernel/module.h    | 15 +++++++
 arch/powerpc/kernel/module_64.c |  7 +--
 arch/x86/kernel/livepatch.c     | 67 +++++++++++++++++++++++++++++
 include/linux/livepatch.h       |  5 +++
 kernel/livepatch/core.c         | 17 +++++---
 7 files changed, 176 insertions(+), 11 deletions(-)
 create mode 100644 arch/powerpc/kernel/livepatch.c
 create mode 100644 arch/powerpc/kernel/module.h

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 0ea6c4aa3a20..639000f78dc3 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -154,6 +154,7 @@ endif
 
 obj-$(CONFIG_EPAPR_PARAVIRT)	+= epapr_paravirt.o epapr_hcalls.o
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvm_emul.o
+obj-$(CONFIG_LIVEPATCH)	+= livepatch.o
 
 # Disable GCOV, KCOV & sanitizers in odd or sensitive code
 GCOV_PROFILE_prom_init.o := n
diff --git a/arch/powerpc/kernel/livepatch.c b/arch/powerpc/kernel/livepatch.c
new file mode 100644
index 000000000000..6f2468c60695
--- /dev/null
+++ b/arch/powerpc/kernel/livepatch.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * livepatch.c - powerpc-specific Kernel Live Patching Core
+ */
+
+#include <linux/livepatch.h>
+#include <asm/code-patching.h>
+#include "module.h"
+
+void arch_klp_free_object_loaded(struct klp_patch *patch,
+				 struct klp_object *obj)
+{
+	const char *objname, *secname, *symname;
+	char sec_objname[MODULE_NAME_LEN];
+	struct klp_modinfo *info;
+	Elf64_Shdr *s;
+	Elf64_Rela *rel;
+	Elf64_Sym *sym;
+	void *loc;
+	u32 *instruction;
+	int i, cnt;
+
+	info = patch->mod->klp_info;
+	objname = klp_is_module(obj) ? obj->name : "vmlinux";
+
+	/* See livepatch core code for BUILD_BUG_ON() explanation */
+	BUILD_BUG_ON(MODULE_NAME_LEN < 56 || KSYM_NAME_LEN != 128);
+
+	/* For each klp relocation section */
+	for (s = info->sechdrs; s < info->sechdrs + info->hdr.e_shnum; s++) {
+		if (!(s->sh_flags & SHF_RELA_LIVEPATCH))
+			continue;
+
+		/*
+		 * Format: .klp.rela.sec_objname.section_name
+		 */
+		secname = info->secstrings + s->sh_name;
+		cnt = sscanf(secname, ".klp.rela.%55[^.]", sec_objname);
+		if (cnt != 1) {
+			pr_err("section %s has an incorrectly formatted name\n",
+			       secname);
+			continue;
+		}
+
+		if (strcmp(objname, sec_objname))
+			continue;
+
+		rel = (void *)s->sh_addr;
+		for (i = 0; i < s->sh_size / sizeof(*rel); i++) {
+			loc = (void *)info->sechdrs[s->sh_info].sh_addr
+				+ rel[i].r_offset;
+			sym = (Elf64_Sym *)info->sechdrs[info->symndx].sh_addr
+				+ ELF64_R_SYM(rel[i].r_info);
+			symname = patch->mod->core_kallsyms.strtab
+				+ sym->st_name;
+
+			if (ELF64_R_TYPE(rel[i].r_info) != R_PPC_REL24)
+				continue;
+
+			if (sym->st_shndx != SHN_UNDEF &&
+			    sym->st_shndx != SHN_LIVEPATCH)
+				continue;
+
+			instruction = (u32 *)loc;
+			if (is_mprofile_mcount_callsite(symname, instruction))
+				continue;
+
+			if (!instr_is_relative_link_branch(*instruction))
+				continue;
+
+			instruction += 1;
+			*instruction = PPC_INST_NOP;
+		}
+	}
+}
diff --git a/arch/powerpc/kernel/module.h b/arch/powerpc/kernel/module.h
new file mode 100644
index 000000000000..748c38addf53
--- /dev/null
+++ b/arch/powerpc/kernel/module.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _POWERPC_ARCH_MODULE_H
+#define _POWERPC_ARCH_MODULE_H
+
+#ifdef CONFIG_MPROFILE_KERNEL
+bool is_mprofile_mcount_callsite(const char *name, u32 *instruction);
+#else
+static inline bool is_mprofile_mcount_callsite(const char *name, u32 *instruction)
+{
+	return false;
+}
+#endif
+
+#endif
diff --git a/arch/powerpc/kernel/module_64.c b/arch/powerpc/kernel/module_64.c
index a93b10c48000..5f34fbc3f1b8 100644
--- a/arch/powerpc/kernel/module_64.c
+++ b/arch/powerpc/kernel/module_64.c
@@ -450,7 +450,7 @@ static unsigned long stub_for_addr(const Elf64_Shdr *sechdrs,
 }
 
 #ifdef CONFIG_MPROFILE_KERNEL
-static bool is_mprofile_mcount_callsite(const char *name, u32 *instruction)
+bool is_mprofile_mcount_callsite(const char *name, u32 *instruction)
 {
 	if (strcmp("_mcount", name))
 		return false;
@@ -485,11 +485,6 @@ static void squash_toc_save_inst(const char *name, unsigned long addr)
 }
 #else
 static void squash_toc_save_inst(const char *name, unsigned long addr) { }
-
-static bool is_mprofile_mcount_callsite(const char *name, u32 *instruction)
-{
-	return false;
-}
 #endif
 
 /* We expect a noop next: if it is, replace it with instruction to
diff --git a/arch/x86/kernel/livepatch.c b/arch/x86/kernel/livepatch.c
index 6a68e41206e7..e99bc8dbf4a7 100644
--- a/arch/x86/kernel/livepatch.c
+++ b/arch/x86/kernel/livepatch.c
@@ -51,3 +51,70 @@ void arch_klp_init_object_loaded(struct klp_patch *patch,
 		apply_paravirt(pseg, pseg + para->sh_size);
 	}
 }
+
+void arch_klp_free_object_loaded(struct klp_patch *patch,
+				 struct klp_object *obj)
+{
+	const char *objname, *secname;
+	char sec_objname[MODULE_NAME_LEN];
+	struct klp_modinfo *info;
+	Elf64_Shdr *s;
+	Elf64_Rela *rel;
+	void *loc;
+	int i, cnt;
+
+	info = patch->mod->klp_info;
+	objname = klp_is_module(obj) ? obj->name : "vmlinux";
+
+	/* See livepatch core code for BUILD_BUG_ON() explanation */
+	BUILD_BUG_ON(MODULE_NAME_LEN < 56 || KSYM_NAME_LEN != 128);
+
+	/* For each klp relocation section */
+	for (s = info->sechdrs; s < info->sechdrs + info->hdr.e_shnum; s++) {
+		if (!(s->sh_flags & SHF_RELA_LIVEPATCH))
+			continue;
+
+		/*
+		 * Format: .klp.rela.sec_objname.section_name
+		 */
+		secname = info->secstrings + s->sh_name;
+		cnt = sscanf(secname, ".klp.rela.%55[^.]", sec_objname);
+		if (cnt != 1) {
+			pr_err("section %s has an incorrectly formatted name\n",
+			       secname);
+			continue;
+		}
+
+		if (strcmp(objname, sec_objname))
+			continue;
+
+		rel = (void *)s->sh_addr;
+		for (i = 0; i < s->sh_size / sizeof(*rel); i++) {
+			loc = (void *)info->sechdrs[s->sh_info].sh_addr
+				+ rel[i].r_offset;
+
+			switch (ELF64_R_TYPE(rel[i].r_info)) {
+			case R_X86_64_NONE:
+				break;
+			case R_X86_64_64:
+				*(u64 *)loc = 0;
+				break;
+			case R_X86_64_32:
+				*(u32 *)loc = 0;
+				break;
+			case R_X86_64_32S:
+				*(s32 *)loc = 0;
+				break;
+			case R_X86_64_PC32:
+			case R_X86_64_PLT32:
+				*(u32 *)loc = 0;
+				break;
+			case R_X86_64_PC64:
+				*(u64 *)loc = 0;
+				break;
+			default:
+				break;
+			}
+		}
+	}
+}
diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 273400814020..a227f473d5e5 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -202,6 +202,11 @@ static inline bool klp_have_reliable_stack(void)
 	       IS_ENABLED(CONFIG_HAVE_RELIABLE_STACKTRACE);
 }
 
+static inline bool klp_is_module(struct klp_object *obj)
+{
+	return obj->name;
+}
+
 typedef int (*klp_shadow_ctor_t)(void *obj,
 				 void *shadow_data,
 				 void *ctor_data);
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index ab4a4606d19b..7a5d0cd59ec1 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -43,11 +43,6 @@ LIST_HEAD(klp_patches);
 
 static struct kobject *klp_root_kobj;
 
-static bool klp_is_module(struct klp_object *obj)
-{
-	return obj->name;
-}
-
 /* sets obj->mod if object is not vmlinux and module is found */
 static void klp_find_object_module(struct klp_object *obj)
 {
@@ -712,6 +707,12 @@ void __weak arch_klp_init_object_loaded(struct klp_patch *patch,
 {
 }
 
+/* Arches may override this to finish any remaining arch-specific tasks */
+void __weak arch_klp_free_object_loaded(struct klp_patch *patch,
+					struct klp_object *obj)
+{
+}
+
 /* parts of the initialization that is done only when the object is loaded */
 static int klp_init_object_loaded(struct klp_patch *patch,
 				  struct klp_object *obj)
@@ -1100,6 +1101,12 @@ static void klp_cleanup_module_patches_limited(struct module *mod,
 
 			klp_post_unpatch_callback(obj);
 
+			mutex_lock(&text_mutex);
+			module_disable_ro(patch->mod);
+			arch_klp_free_object_loaded(patch, obj);
+			module_enable_ro(patch->mod, true);
+			mutex_unlock(&text_mutex);
+
 			klp_free_object_loaded(obj);
 			break;
 		}
-- 
2.22.0

