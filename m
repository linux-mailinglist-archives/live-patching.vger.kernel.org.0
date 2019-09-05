Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC1CAA370
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2019 14:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389503AbfIEMpZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Sep 2019 08:45:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:40678 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731492AbfIEMpT (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Sep 2019 08:45:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 42A42B658;
        Thu,  5 Sep 2019 12:45:17 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     jikos@kernel.org, jpoimboe@redhat.com, pmladek@suse.com
Cc:     joe.lawrence@redhat.com, nstange@suse.de,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miroslav Benes <mbenes@suse.cz>
Subject: [RFC PATCH v2 2/3] livepatch: Unify functions for writing and clearing object relocations
Date:   Thu,  5 Sep 2019 14:45:13 +0200
Message-Id: <20190905124514.8944-3-mbenes@suse.cz>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190905124514.8944-1-mbenes@suse.cz>
References: <20190905124514.8944-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Functions klp_write_object_relocations() and
klp_clear_object_relocations() share a lot of code. Take the code out to
a common function and provide the specific actions through callbacks.

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
 kernel/livepatch/core.c | 84 +++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 50 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index f0b380d2a17a..023c9333c276 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -245,8 +245,11 @@ static int klp_resolve_symbols(Elf_Shdr *relasec, struct module *pmod)
 	return 0;
 }
 
-static int klp_write_object_relocations(struct module *pmod,
-					struct klp_object *obj)
+typedef int (reloc_update_fn_t)(struct module *, unsigned int);
+
+static int klp_update_object_relocations(struct module *pmod,
+					 struct klp_object *obj,
+					 reloc_update_fn_t reloc_update_fn)
 {
 	int i, cnt, ret = 0;
 	const char *objname, *secname;
@@ -281,13 +284,7 @@ static int klp_write_object_relocations(struct module *pmod,
 		if (strcmp(objname, sec_objname))
 			continue;
 
-		ret = klp_resolve_symbols(sec, pmod);
-		if (ret)
-			break;
-
-		ret = apply_relocate_add(pmod->klp_info->sechdrs,
-					 pmod->core_kallsyms.strtab,
-					 pmod->klp_info->symndx, i, pmod);
+		ret = reloc_update_fn(pmod, i);
 		if (ret)
 			break;
 	}
@@ -295,45 +292,6 @@ static int klp_write_object_relocations(struct module *pmod,
 	return ret;
 }
 
-static void klp_clear_object_relocations(struct module *pmod,
-					struct klp_object *obj)
-{
-	int i, cnt;
-	const char *objname, *secname;
-	char sec_objname[MODULE_NAME_LEN];
-	Elf_Shdr *sec;
-
-	objname = klp_is_module(obj) ? obj->name : "vmlinux";
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
-		secname = pmod->klp_info->secstrings + sec->sh_name;
-		cnt = sscanf(secname, ".klp.rela.%55[^.]", sec_objname);
-		if (cnt != 1) {
-			pr_err("section %s has an incorrectly formatted name\n",
-			       secname);
-			continue;
-		}
-
-		if (strcmp(objname, sec_objname))
-			continue;
-
-		clear_relocate_add(pmod->klp_info->sechdrs,
-				   pmod->core_kallsyms.strtab,
-				   pmod->klp_info->symndx, i, pmod);
-	}
-}
-
 /*
  * Sysfs Interface
  *
@@ -751,6 +709,21 @@ void __weak arch_klp_init_object_loaded(struct klp_patch *patch,
 {
 }
 
+static int klp_write_relocations(struct module *pmod,
+				 unsigned int relsec)
+{
+	int ret;
+
+	ret = klp_resolve_symbols(pmod->klp_info->sechdrs + relsec, pmod);
+	if (ret)
+		return ret;
+
+	ret = apply_relocate_add(pmod->klp_info->sechdrs,
+				 pmod->core_kallsyms.strtab,
+				 pmod->klp_info->symndx, relsec, pmod);
+	return ret;
+}
+
 /* parts of the initialization that is done only when the object is loaded */
 static int klp_init_object_loaded(struct klp_patch *patch,
 				  struct klp_object *obj)
@@ -761,7 +734,8 @@ static int klp_init_object_loaded(struct klp_patch *patch,
 	mutex_lock(&text_mutex);
 
 	module_disable_ro(patch->mod);
-	ret = klp_write_object_relocations(patch->mod, obj);
+	ret = klp_update_object_relocations(patch->mod, obj,
+					    klp_write_relocations);
 	if (ret) {
 		module_enable_ro(patch->mod, true);
 		mutex_unlock(&text_mutex);
@@ -1111,6 +1085,15 @@ void klp_discard_nops(struct klp_patch *new_patch)
 	klp_free_objects_dynamic(klp_transition_patch);
 }
 
+static int klp_clear_relocations(struct module *pmod,
+				 unsigned int relsec)
+{
+	clear_relocate_add(pmod->klp_info->sechdrs,
+			   pmod->core_kallsyms.strtab,
+			   pmod->klp_info->symndx, relsec, pmod);
+	return 0;
+}
+
 /*
  * Remove parts of patches that touch a given kernel module. The list of
  * patches processed might be limited. When limit is NULL, all patches
@@ -1141,7 +1124,8 @@ static void klp_cleanup_module_patches_limited(struct module *mod,
 
 			mutex_lock(&text_mutex);
 			module_disable_ro(patch->mod);
-			klp_clear_object_relocations(patch->mod, obj);
+			klp_update_object_relocations(patch->mod, obj,
+						      klp_clear_relocations);
 			module_enable_ro(patch->mod, true);
 			mutex_unlock(&text_mutex);
 
-- 
2.23.0

