Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9114F140D41
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbgAQPEE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:04:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:46352 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729073AbgAQPEE (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:04:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F0010BBBB;
        Fri, 17 Jan 2020 15:04:02 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 20/23] module/livepatch: Relocate local variables in the module loaded when the livepatch is being loaded
Date:   Fri, 17 Jan 2020 16:03:20 +0100
Message-Id: <20200117150323.21801-21-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The special SHF_RELA_LIVEPATCH section is still needed to find static
(non-exported) symbols. But it can be done together with the other
relocations when the livepatch module is being loaded.

There is no longer needed to copy the info section. The related
code in the module loaded will get removed in separate patch.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/livepatch.h |  4 +++
 kernel/livepatch/core.c   | 62 +++--------------------------------------------
 kernel/module.c           | 16 +++++++-----
 3 files changed, 18 insertions(+), 64 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 4776deb7418c..d721e79ac691 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -211,6 +211,10 @@ bool klp_break_recursion(struct module *mod);
 int klp_module_coming(struct module *mod);
 void klp_module_going(struct module *mod);
 
+int klp_resolve_symbols(Elf_Shdr *sechdrs,
+			unsigned int relsec,
+			struct module *pmod);
+
 void klp_copy_process(struct task_struct *child);
 void klp_update_patch_state(struct task_struct *task);
 
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 9e00871fbc06..4da6bbd687d0 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -196,12 +196,15 @@ static int klp_find_object_symbol(const char *objname, const char *name,
 	return -EINVAL;
 }
 
-static int klp_resolve_symbols(Elf_Shdr *relasec, struct module *pmod)
+int klp_resolve_symbols(Elf_Shdr *sechdrs,
+			unsigned int relsec,
+			struct module *pmod)
 {
 	int i, cnt, vmlinux, ret;
 	char objname[MODULE_NAME_LEN];
 	char symname[KSYM_NAME_LEN];
 	char *strtab = pmod->core_kallsyms.strtab;
+	Elf_Shdr *relasec = sechdrs + relsec;
 	Elf_Rela *relas;
 	Elf_Sym *sym;
 	unsigned long sympos, addr;
@@ -251,54 +254,6 @@ static int klp_resolve_symbols(Elf_Shdr *relasec, struct module *pmod)
 	return 0;
 }
 
-static int klp_write_object_relocations(struct klp_object *obj)
-{
-	int i, cnt, ret = 0;
-	const char *objname, *secname;
-	char sec_objname[MODULE_NAME_LEN];
-	struct module *pmod;
-	Elf_Shdr *sec;
-
-	objname = klp_is_module(obj) ? obj->name : "vmlinux";
-	pmod = obj->mod;
-
-	/* For each klp relocation section */
-	for (i = 1; i < pmod->klp_info->hdr.e_shnum; i++) {
-		sec = pmod->klp_info->sechdrs + i;
-		secname = pmod->klp_info->secstrings + sec->sh_name;
-		if (!(sec->sh_flags & SHF_RELA_LIVEPATCH))
-			continue;
-
-		/*
-		 * Format: .klp.rela.sec_objname.section_name
-		 * See comment in klp_resolve_symbols() for an explanation
-		 * of the selected field width value.
-		 */
-		cnt = sscanf(secname, ".klp.rela.%55[^.]", sec_objname);
-		if (cnt != 1) {
-			pr_err("section %s has an incorrectly formatted name\n",
-			       secname);
-			ret = -EINVAL;
-			break;
-		}
-
-		if (strcmp(objname, sec_objname))
-			continue;
-
-		ret = klp_resolve_symbols(sec, pmod);
-		if (ret)
-			break;
-
-		ret = apply_relocate_add(pmod->klp_info->sechdrs,
-					 pmod->core_kallsyms.strtab,
-					 pmod->klp_info->symndx, i, pmod);
-		if (ret)
-			break;
-	}
-
-	return ret;
-}
-
 /*
  * Sysfs Interface
  *
@@ -758,18 +713,9 @@ static int klp_init_object_loaded(struct klp_object *obj)
 	int ret;
 
 	mutex_lock(&text_mutex);
-
 	module_disable_ro(obj->mod);
-	ret = klp_write_object_relocations(obj);
-	if (ret) {
-		module_enable_ro(obj->mod, true);
-		mutex_unlock(&text_mutex);
-		return ret;
-	}
-
 	arch_klp_init_object_loaded(obj);
 	module_enable_ro(obj->mod, true);
-
 	mutex_unlock(&text_mutex);
 
 	klp_for_each_func(obj, func) {
diff --git a/kernel/module.c b/kernel/module.c
index bd92854b42c2..c14b5135db27 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2410,16 +2410,20 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
 		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
 			continue;
 
-		/* Livepatch relocation sections are applied by livepatch */
-		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
-			continue;
-
-		if (info->sechdrs[i].sh_type == SHT_REL)
+		/* Livepatch need to resolve static symbols. */
+		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH) {
+			err = klp_resolve_symbols(info->sechdrs, i, mod);
+			if (err < 0)
+				break;
+			err = apply_relocate_add(info->sechdrs, info->strtab,
+						 info->index.sym, i, mod);
+		} else if (info->sechdrs[i].sh_type == SHT_REL) {
 			err = apply_relocate(info->sechdrs, info->strtab,
 					     info->index.sym, i, mod);
-		else if (info->sechdrs[i].sh_type == SHT_RELA)
+		} else if (info->sechdrs[i].sh_type == SHT_RELA) {
 			err = apply_relocate_add(info->sechdrs, info->strtab,
 						 info->index.sym, i, mod);
+		}
 		if (err < 0)
 			break;
 	}
-- 
2.16.4

