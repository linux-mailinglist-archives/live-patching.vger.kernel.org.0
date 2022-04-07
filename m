Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C0D4F89DD
	for <lists+live-patching@lfdr.de>; Fri,  8 Apr 2022 00:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiDGUkE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 7 Apr 2022 16:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiDGUjs (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 7 Apr 2022 16:39:48 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49DAC3542BE;
        Thu,  7 Apr 2022 13:26:05 -0700 (PDT)
Received: from x64host.home (unknown [47.189.24.195])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5E4C720B36F7;
        Thu,  7 Apr 2022 13:26:04 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5E4C720B36F7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1649363165;
        bh=JukkwBZel5zBVGcAdYt8iwRbZEdTiwAJnMVwnLhJEtE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=oXz+FrSrlVvwkKE55Ydy2W8QVsrhMLJlxkM8NZroNmyHKwGszPgWGXfrvCxjiLeGZ
         cJqtSdg/FAvDDhCwhMJQFxCJE5eg+3WHx/qfU6GEO22MXh7a+8AoYu3ahI5ygtzD7H
         ek8IPT20NhahH6otb9Rokfbt9KUC2aFV/FtBf328=
From:   madvenka@linux.microsoft.com
To:     mark.rutland@arm.com, broonie@kernel.org, jpoimboe@redhat.com,
        ardb@kernel.org, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jmorris@namei.org, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        madvenka@linux.microsoft.com
Subject: [RFC PATCH v1 5/9] dwarf: Implement DWARF support for modules
Date:   Thu,  7 Apr 2022 15:25:14 -0500
Message-Id: <20220407202518.19780-6-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407202518.19780-1-madvenka@linux.microsoft.com>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

When a module is loaded, allocate and initialize its struct dwarf_info. When
a module is unloaded, free the same.

Add code in dwarf_lookup() to look up a given address in modules, if vmlinux
does not contain the address.

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 include/linux/dwarf.h       | 18 ++++++++++
 include/linux/module.h      |  3 ++
 kernel/dwarf_fp.c           | 71 ++++++++++++++++++++++++++++++++++---
 kernel/module.c             | 31 ++++++++++++++++
 tools/include/linux/dwarf.h | 18 ++++++++++
 5 files changed, 136 insertions(+), 5 deletions(-)

diff --git a/include/linux/dwarf.h b/include/linux/dwarf.h
index 3df15e79003c..aa44a414b0b6 100644
--- a/include/linux/dwarf.h
+++ b/include/linux/dwarf.h
@@ -11,6 +11,7 @@
 #define _LINUX_DWARF_H
 
 #include <linux/types.h>
+#include <linux/module.h>
 
 /*
  * objtool generates two special sections that contain DWARF information that
@@ -54,11 +55,28 @@ struct dwarf_block {
 
 #ifdef CONFIG_DWARF_FP
 extern struct dwarf_rule	*dwarf_lookup(unsigned long pc);
+#ifdef CONFIG_MODULES
+extern void dwarf_module_alloc(struct module *mod,
+			       struct dwarf_rule *rules, size_t rules_size,
+			       unsigned long *pcs, size_t pcs_size);
+extern void dwarf_module_free(struct module *mod);
+#endif
 #else
 static inline struct dwarf_rule *dwarf_lookup(unsigned long pc)
 {
 	return NULL;
 }
+#ifdef CONFIG_MODULES
+static inline void dwarf_module_alloc(struct module *mod,
+					  struct dwarf_rule *rules,
+					  size_t rules_size,
+					  unsigned long *pcs, size_t pcs_size)
+{
+}
+static inline void dwarf_module_free(struct module *mod)
+{
+}
+#endif
 #endif
 
 #endif /* _LINUX_DWARF_H */
diff --git a/include/linux/module.h b/include/linux/module.h
index c9f1200b2312..bd7c69b82808 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -538,6 +538,9 @@ struct module {
 	struct error_injection_entry *ei_funcs;
 	unsigned int num_ei_funcs;
 #endif
+#ifdef CONFIG_DWARF_FP
+	void *dwarf_info;
+#endif
 } ____cacheline_aligned __randomize_layout;
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
diff --git a/kernel/dwarf_fp.c b/kernel/dwarf_fp.c
index bb14fbe3f3e1..07d647e828cd 100644
--- a/kernel/dwarf_fp.c
+++ b/kernel/dwarf_fp.c
@@ -164,6 +164,44 @@ static struct dwarf_info *dwarf_alloc(struct dwarf_rule *rules, int nrules,
 	return NULL;
 }
 
+#ifdef CONFIG_MODULES
+
+/*
+ * Errors encountered in this function should not be fatal. All it will mean
+ * is that stack traces through the module would be considered unreliable.
+ */
+void dwarf_module_alloc(struct module *mod,
+			struct dwarf_rule *rules, size_t rules_size,
+			unsigned long *pcs, size_t pcs_size)
+{
+	int		nrules, npcs;
+
+	mod->dwarf_info = NULL;
+
+	nrules = rules_size / sizeof(*rules);
+	npcs = pcs_size / sizeof(*pcs);
+	if (!nrules || npcs != nrules)
+		return;
+
+	mod->dwarf_info = dwarf_alloc(rules, nrules, pcs);
+}
+
+void dwarf_module_free(struct module *mod)
+{
+	struct dwarf_info	*info;
+
+	info = mod->dwarf_info;
+	mod->dwarf_info = NULL;
+
+	if (info) {
+		kfree(info->blocks);
+		kfree(info->offsets);
+		kfree(info);
+	}
+}
+
+#endif
+
 static struct dwarf_rule *dwarf_lookup_rule(struct dwarf_info *info,
 					    unsigned long pc)
 {
@@ -212,13 +250,36 @@ static struct dwarf_rule *dwarf_lookup_rule(struct dwarf_info *info,
 	return NULL;
 }
 
+#ifdef CONFIG_MODULES
+
+static struct dwarf_rule *dwarf_module_lookup_rule(unsigned long pc)
+{
+	struct module	*mod;
+
+	mod = __module_address(pc);
+	if (!mod || !mod->dwarf_info)
+		return NULL;
+
+	return dwarf_lookup_rule(mod->dwarf_info, pc);
+}
+
+#else
+
+static struct dwarf_rule *dwarf_module_lookup_rule(unsigned long pc)
+{
+	return NULL;
+}
+
+#endif
+
 struct dwarf_rule *dwarf_lookup(unsigned long pc)
 {
-	/*
-	 * Currently, only looks up vmlinux. Support for modules will be
-	 * added later.
-	 */
-	return dwarf_lookup_rule(vmlinux_dwarf_info, pc);
+	struct dwarf_rule	*rule;
+
+	rule = dwarf_lookup_rule(vmlinux_dwarf_info, pc);
+	if (!rule)
+		rule = dwarf_module_lookup_rule(pc);
+	return rule;
 }
 
 static int __init dwarf_init_feature(void)
diff --git a/kernel/module.c b/kernel/module.c
index 84a9141a5e15..d9b73995b70a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -59,6 +59,7 @@
 #include <linux/audit.h>
 #include <uapi/linux/module.h>
 #include "module-internal.h"
+#include <linux/dwarf.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
@@ -2153,6 +2154,7 @@ void __weak module_arch_freeing_init(struct module *mod)
 }
 
 static void cfi_cleanup(struct module *mod);
+static void module_dwarf_free(struct module *mod);
 
 /* Free a module, remove from lists, etc. */
 static void free_module(struct module *mod)
@@ -2175,6 +2177,9 @@ static void free_module(struct module *mod)
 	/* Arch-specific cleanup. */
 	module_arch_cleanup(mod);
 
+	/* Dwarf cleanup. */
+	module_dwarf_free(mod);
+
 	/* Module unload stuff */
 	module_unload_free(mod);
 
@@ -3946,6 +3951,7 @@ static int unknown_module_param_cb(char *param, char *val, const char *modname,
 }
 
 static void cfi_init(struct module *mod);
+static void module_dwarf_init(struct module *mod, struct load_info *info);
 
 /*
  * Allocate and load the module: note that size of section 0 is always
@@ -4074,6 +4080,8 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	if (err < 0)
 		goto free_modinfo;
 
+	module_dwarf_init(mod, info);
+
 	flush_module_icache(mod);
 
 	/* Setup CFI for the module. */
@@ -4154,6 +4162,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	kfree(mod->args);
  free_arch_cleanup:
 	cfi_cleanup(mod);
+	module_dwarf_free(mod);
 	module_arch_cleanup(mod);
  free_modinfo:
 	free_modinfo(mod);
@@ -4542,6 +4551,28 @@ static void cfi_cleanup(struct module *mod)
 #endif
 }
 
+static void module_dwarf_init(struct module *mod, struct load_info *info)
+{
+	Elf_Shdr *dwarf_rules, *dwarf_pcs;
+
+	dwarf_rules = &info->sechdrs[find_sec(info, ".dwarf_rules")];
+	dwarf_pcs = &info->sechdrs[find_sec(info, ".dwarf_pcs")];
+
+	if (!dwarf_rules || !dwarf_pcs)
+		return;
+
+	dwarf_module_alloc(mod,
+			   (void *) dwarf_rules->sh_addr,
+			   dwarf_rules->sh_size,
+			   (void *) dwarf_pcs->sh_addr,
+			   dwarf_pcs->sh_size);
+}
+
+static void module_dwarf_free(struct module *mod)
+{
+	dwarf_module_free(mod);
+}
+
 /* Maximum number of characters written by module_flags() */
 #define MODULE_FLAGS_BUF_SIZE (TAINT_FLAGS_COUNT + 4)
 
diff --git a/tools/include/linux/dwarf.h b/tools/include/linux/dwarf.h
index 3df15e79003c..aa44a414b0b6 100644
--- a/tools/include/linux/dwarf.h
+++ b/tools/include/linux/dwarf.h
@@ -11,6 +11,7 @@
 #define _LINUX_DWARF_H
 
 #include <linux/types.h>
+#include <linux/module.h>
 
 /*
  * objtool generates two special sections that contain DWARF information that
@@ -54,11 +55,28 @@ struct dwarf_block {
 
 #ifdef CONFIG_DWARF_FP
 extern struct dwarf_rule	*dwarf_lookup(unsigned long pc);
+#ifdef CONFIG_MODULES
+extern void dwarf_module_alloc(struct module *mod,
+			       struct dwarf_rule *rules, size_t rules_size,
+			       unsigned long *pcs, size_t pcs_size);
+extern void dwarf_module_free(struct module *mod);
+#endif
 #else
 static inline struct dwarf_rule *dwarf_lookup(unsigned long pc)
 {
 	return NULL;
 }
+#ifdef CONFIG_MODULES
+static inline void dwarf_module_alloc(struct module *mod,
+					  struct dwarf_rule *rules,
+					  size_t rules_size,
+					  unsigned long *pcs, size_t pcs_size)
+{
+}
+static inline void dwarf_module_free(struct module *mod)
+{
+}
+#endif
 #endif
 
 #endif /* _LINUX_DWARF_H */
-- 
2.25.1

