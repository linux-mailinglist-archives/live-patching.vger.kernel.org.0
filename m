Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D298140D4E
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729277AbgAQPET (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:04:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:46518 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729107AbgAQPEF (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:04:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D1902BBBD;
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
Subject: [POC 22/23] livepatch/module: Remove obsolete copy_module_elf()
Date:   Fri, 17 Jan 2020 16:03:22 +0100
Message-Id: <20200117150323.21801-23-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The split livepatch modules can be relocated immedidately when they
are loaded. There is no longer needed to preserve the elf sections.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 Documentation/livepatch/module-elf-format.rst | 18 ++++++
 include/linux/module.h                        |  3 -
 kernel/module.c                               | 87 ---------------------------
 3 files changed, 18 insertions(+), 90 deletions(-)

diff --git a/Documentation/livepatch/module-elf-format.rst b/Documentation/livepatch/module-elf-format.rst
index 9f0c997d4940..8c6b894c4661 100644
--- a/Documentation/livepatch/module-elf-format.rst
+++ b/Documentation/livepatch/module-elf-format.rst
@@ -14,6 +14,7 @@ This document outlines the Elf format requirements that livepatch modules must f
    4. Livepatch symbols
       4.1 A livepatch module's symbol table
       4.2 Livepatch symbol format
+   5. Symbol table and Elf section access
 
 1. Background and motivation
 ============================
@@ -295,3 +296,20 @@ See include/uapi/linux/elf.h for the actual definitions.
 [*]
   Note that the 'Ndx' (Section index) for these symbols is SHN_LIVEPATCH (0xff20).
   "OS" means OS-specific.
+
+5. Symbol table and Elf section access
+======================================
+A livepatch module's symbol table is accessible through module->symtab.
+
+Since apply_relocate_add() requires access to a module's section headers,
+symbol table, and relocation section indices, Elf information is preserved for
+livepatch modules and is made accessible by the module loader through
+module->klp_info, which is a klp_modinfo struct. When a livepatch module loads,
+this struct is filled in by the module loader. Its fields are documented below::
+
+	struct klp_modinfo {
+		Elf_Ehdr hdr; /* Elf header */
+		Elf_Shdr *sechdrs; /* Section header table */
+		char *secstrings; /* String table for the section headers */
+		unsigned int symndx; /* The symbol table section index */
+	};
diff --git a/include/linux/module.h b/include/linux/module.h
index f69f3fd72dd5..8545f3087274 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -483,9 +483,6 @@ struct module {
 #ifdef CONFIG_LIVEPATCH
 	bool klp; /* Is this a livepatch module? */
 	bool klp_alive;
-
-	/* Elf information */
-	struct klp_modinfo *klp_info;
 #endif
 
 #ifdef CONFIG_MODULE_UNLOAD
diff --git a/kernel/module.c b/kernel/module.c
index c14b5135db27..442926fc5f34 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2125,82 +2125,6 @@ static void module_enable_nx(const struct module *mod) { }
 static void module_enable_x(const struct module *mod) { }
 #endif /* CONFIG_ARCH_HAS_STRICT_MODULE_RWX */
 
-
-#ifdef CONFIG_LIVEPATCH
-/*
- * Persist Elf information about a module. Copy the Elf header,
- * section header table, section string table, and symtab section
- * index from info to mod->klp_info.
- */
-static int copy_module_elf(struct module *mod, struct load_info *info)
-{
-	unsigned int size, symndx;
-	int ret;
-
-	size = sizeof(*mod->klp_info);
-	mod->klp_info = kmalloc(size, GFP_KERNEL);
-	if (mod->klp_info == NULL)
-		return -ENOMEM;
-
-	/* Elf header */
-	size = sizeof(mod->klp_info->hdr);
-	memcpy(&mod->klp_info->hdr, info->hdr, size);
-
-	/* Elf section header table */
-	size = sizeof(*info->sechdrs) * info->hdr->e_shnum;
-	mod->klp_info->sechdrs = kmemdup(info->sechdrs, size, GFP_KERNEL);
-	if (mod->klp_info->sechdrs == NULL) {
-		ret = -ENOMEM;
-		goto free_info;
-	}
-
-	/* Elf section name string table */
-	size = info->sechdrs[info->hdr->e_shstrndx].sh_size;
-	mod->klp_info->secstrings = kmemdup(info->secstrings, size, GFP_KERNEL);
-	if (mod->klp_info->secstrings == NULL) {
-		ret = -ENOMEM;
-		goto free_sechdrs;
-	}
-
-	/* Elf symbol section index */
-	symndx = info->index.sym;
-	mod->klp_info->symndx = symndx;
-
-	/*
-	 * For livepatch modules, core_kallsyms.symtab is a complete
-	 * copy of the original symbol table. Adjust sh_addr to point
-	 * to core_kallsyms.symtab since the copy of the symtab in module
-	 * init memory is freed at the end of do_init_module().
-	 */
-	mod->klp_info->sechdrs[symndx].sh_addr = \
-		(unsigned long) mod->core_kallsyms.symtab;
-
-	return 0;
-
-free_sechdrs:
-	kfree(mod->klp_info->sechdrs);
-free_info:
-	kfree(mod->klp_info);
-	return ret;
-}
-
-static void free_module_elf(struct module *mod)
-{
-	kfree(mod->klp_info->sechdrs);
-	kfree(mod->klp_info->secstrings);
-	kfree(mod->klp_info);
-}
-#else /* !CONFIG_LIVEPATCH */
-static int copy_module_elf(struct module *mod, struct load_info *info)
-{
-	return 0;
-}
-
-static void free_module_elf(struct module *mod)
-{
-}
-#endif /* CONFIG_LIVEPATCH */
-
 void __weak module_memfree(void *module_region)
 {
 	/*
@@ -2244,9 +2168,6 @@ static void free_module(struct module *mod)
 	/* Free any allocated parameters. */
 	destroy_params(mod->kp, mod->num_kp);
 
-	if (is_livepatch_module(mod))
-		free_module_elf(mod);
-
 	/* Now we can delete it from the lists */
 	mutex_lock(&module_mutex);
 	/* Unlink carefully: kallsyms could be walking list. */
@@ -3967,12 +3888,6 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	if (err < 0)
 		goto coming_cleanup;
 
-	if (is_livepatch_module(mod)) {
-		err = copy_module_elf(mod, info);
-		if (err < 0)
-			goto sysfs_cleanup;
-	}
-
 	/* Get rid of temporary copy. */
 	free_copy(info);
 
@@ -3981,8 +3896,6 @@ static int load_module(struct load_info *info, const char __user *uargs,
 
 	return do_init_module(mod);
 
- sysfs_cleanup:
-	mod_sysfs_teardown(mod);
  coming_cleanup:
 	mod->state = MODULE_STATE_GOING;
 	destroy_params(mod->kp, mod->num_kp);
-- 
2.16.4

