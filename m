Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A474A0227
	for <lists+live-patching@lfdr.de>; Fri, 28 Jan 2022 21:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351401AbiA1UkF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 28 Jan 2022 15:40:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46149 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351132AbiA1Uj4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 28 Jan 2022 15:39:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643402396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oIuGCKEhKJ0rfok+3CzzqJj1VmBNcHrM7R91RoSbBf4=;
        b=Ei07AgpD4T3Uk2gOYt30KX0ImiVA3AOGsD8cHpKRFR4RZnG/cZGjw/V2IbIxK9L969zPfw
        GG6S20wkuaei5ec8soH3aYTc7MDm5qZ4P3PxmDqxOWSrDHUqac8SkvcLiJvK5qO9DTzjC6
        f5LKxCGukrPoT4WF51Fpul2mJsXkEt4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-zLYQH0fENsGW_PEzbCTToQ-1; Fri, 28 Jan 2022 15:39:54 -0500
X-MC-Unique: zLYQH0fENsGW_PEzbCTToQ-1
Received: by mail-wm1-f69.google.com with SMTP id bg23-20020a05600c3c9700b0034bb19dfdc0so1678127wmb.1
        for <live-patching@vger.kernel.org>; Fri, 28 Jan 2022 12:39:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oIuGCKEhKJ0rfok+3CzzqJj1VmBNcHrM7R91RoSbBf4=;
        b=3LkPg2M4EklGDH/N1XqE+D3MdRXQHQnq9ogV3DLE786cI2tgr232OkLo+t4bERRl+O
         Y18Whgk4GLOmxYmxsRnRbkA2EitDsu5qslQZodvcplWnRzDx2mKtP5e4T7s2cBRgxAM+
         OTTd9kjNMpFkY8jdhmroGQ+/MD5AdrV95lwVnDgJx2ZuvWApsJCa5HMT5yf0msSnjnS0
         L/in7ddrW9nCljk35/Rl2G34GLU+4uUNZ0ys+hyHYYilHvRdZvoLd511LsN6rQCra5rX
         AUw3XDYsdabLOVhSzbJ+GFcGWFJv5k4ZvpmBMxHPSuV0KVulAivOXe32e2GGk9ERNF2J
         /HjQ==
X-Gm-Message-State: AOAM533pmGhUda8k83j+HnBNThu0+I/6VExC4vMdEhmXX/UFdRytdlWR
        bvWQ6QOXNJe0H11Qg6sy5joT9K9tlyDkQ4ft7vKImHuXaf7eB8pCBDlTYl/zbx93TUHhK6OXZXe
        dZ7/wtyfHBoLmidB1KCrE1eqZ
X-Received: by 2002:a05:6000:184c:: with SMTP id c12mr8062466wri.388.1643402393318;
        Fri, 28 Jan 2022 12:39:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyIGqq2vfwnVZdpWgko/zZy8zCcphccPJeJWTP0SY1PFuMr0RUTmN/3jqnJJRw2GWOw1tInig==
X-Received: by 2002:a05:6000:184c:: with SMTP id c12mr8062454wri.388.1643402393062;
        Fri, 28 Jan 2022 12:39:53 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id w6sm2614345wmi.15.2022.01.28.12.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 12:39:52 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com
Subject: [RFC PATCH v3 13/13] module: Move version support into a separate file
Date:   Fri, 28 Jan 2022 20:39:34 +0000
Message-Id: <20220128203934.600247-14-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128203934.600247-1-atomlin@redhat.com>
References: <20220128203934.600247-1-atomlin@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

No functional change.

This patch migrates module version support out of core code into
kernel/module/version.c. In addition simple code refactoring to
make this possible.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
---
 kernel/module/Makefile   |   1 +
 kernel/module/internal.h |  51 +++++++++++++
 kernel/module/main.c     | 150 +--------------------------------------
 kernel/module/version.c  | 110 ++++++++++++++++++++++++++++
 4 files changed, 164 insertions(+), 148 deletions(-)
 create mode 100644 kernel/module/version.c

diff --git a/kernel/module/Makefile b/kernel/module/Makefile
index 44b9b4924d71..8b88ae28e714 100644
--- a/kernel/module/Makefile
+++ b/kernel/module/Makefile
@@ -15,3 +15,4 @@ obj-$(CONFIG_DEBUG_KMEMLEAK) += debug_kmemleak.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_PROC_FS) += procfs.o
 obj-$(CONFIG_SYSFS) += sysfs.o
+obj-$(CONFIG_MODVERSIONS) += version.o
diff --git a/kernel/module/internal.h b/kernel/module/internal.h
index bf2746949e93..94c6cfddf0a2 100644
--- a/kernel/module/internal.h
+++ b/kernel/module/internal.h
@@ -59,7 +59,31 @@ struct load_info {
 	} index;
 };
 
+struct symsearch {
+	const struct kernel_symbol *start, *stop;
+	const s32 *crcs;
+	enum mod_license {
+		NOT_GPL_ONLY,
+		GPL_ONLY,
+	} license;
+};
+
+struct find_symbol_arg {
+	/* Input */
+	const char *name;
+	bool gplok;
+	bool warn;
+
+	/* Output */
+	struct module *owner;
+	const s32 *crc;
+	const struct kernel_symbol *sym;
+	enum mod_license license;
+};
+
 extern int mod_verify_sig(const void *mod, struct load_info *info);
+extern int try_to_force_load(struct module *mod, const char *reason);
+extern bool find_symbol(struct find_symbol_arg *fsa);
 extern struct module *find_module_all(const char *name, size_t len, bool even_unformed);
 extern unsigned long kernel_symbol_value(const struct kernel_symbol *sym);
 extern int cmp_name(const void *name, const void *sym);
@@ -149,3 +173,30 @@ static inline void module_remove_modinfo_attrs(struct module *mod, int end) { }
 static inline void del_usage_links(struct module *mod) { }
 static inline void init_param_lock(struct module *mod) { }
 #endif /* CONFIG_SYSFS */
+
+#ifdef CONFIG_MODVERSIONS
+extern int check_version(const struct load_info *info,
+			 const char *symname, struct module *mod, const s32 *crc);
+extern int check_modstruct_version(const struct load_info *info, struct module *mod);
+extern int same_magic(const char *amagic, const char *bmagic, bool has_crcs);
+#else /* !CONFIG_MODVERSIONS */
+static inline int check_version(const struct load_info *info,
+				const char *symname,
+				struct module *mod,
+				const s32 *crc)
+{
+	return 1;
+}
+
+static inline int check_modstruct_version(const struct load_info *info,
+					  struct module *mod)
+{
+	return 1;
+}
+
+static inline int same_magic(const char *amagic, const char *bmagic,
+			    bool has_crcs)
+{
+	return strcmp(amagic, bmagic) == 0;
+}
+#endif /* CONFIG_MODVERSIONS */
diff --git a/kernel/module/main.c b/kernel/module/main.c
index 1f16e67f687f..0a1bd11d2a6e 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -231,28 +231,6 @@ static __maybe_unused void *any_section_objs(const struct load_info *info,
 #define symversion(base, idx) ((base != NULL) ? ((base) + (idx)) : NULL)
 #endif
 
-struct symsearch {
-	const struct kernel_symbol *start, *stop;
-	const s32 *crcs;
-	enum mod_license {
-		NOT_GPL_ONLY,
-		GPL_ONLY,
-	} license;
-};
-
-struct find_symbol_arg {
-	/* Input */
-	const char *name;
-	bool gplok;
-	bool warn;
-
-	/* Output */
-	struct module *owner;
-	const s32 *crc;
-	const struct kernel_symbol *sym;
-	enum mod_license license;
-};
-
 static bool check_exported_symbol(const struct symsearch *syms,
 				  struct module *owner,
 				  unsigned int symnum, void *data)
@@ -323,7 +301,7 @@ static bool find_exported_symbol_in_section(const struct symsearch *syms,
  * Find an exported symbol and return it, along with, (optional) crc and
  * (optional) module which owns it.  Needs preempt disabled or module_mutex.
  */
-static bool find_symbol(struct find_symbol_arg *fsa)
+bool find_symbol(struct find_symbol_arg *fsa)
 {
 	static const struct symsearch arr[] = {
 		{ __start___ksymtab, __stop___ksymtab, __start___kcrctab,
@@ -997,7 +975,7 @@ size_t modinfo_attrs_count = ARRAY_SIZE(modinfo_attrs);
 
 static const char vermagic[] = VERMAGIC_STRING;
 
-static int try_to_force_load(struct module *mod, const char *reason)
+int try_to_force_load(struct module *mod, const char *reason)
 {
 #ifdef CONFIG_MODULE_FORCE_LOAD
 	if (!test_taint(TAINT_FORCED_MODULE))
@@ -1009,115 +987,6 @@ static int try_to_force_load(struct module *mod, const char *reason)
 #endif
 }
 
-#ifdef CONFIG_MODVERSIONS
-
-static u32 resolve_rel_crc(const s32 *crc)
-{
-	return *(u32 *)((void *)crc + *crc);
-}
-
-static int check_version(const struct load_info *info,
-			 const char *symname,
-			 struct module *mod,
-			 const s32 *crc)
-{
-	Elf_Shdr *sechdrs = info->sechdrs;
-	unsigned int versindex = info->index.vers;
-	unsigned int i, num_versions;
-	struct modversion_info *versions;
-
-	/* Exporting module didn't supply crcs?  OK, we're already tainted. */
-	if (!crc)
-		return 1;
-
-	/* No versions at all?  modprobe --force does this. */
-	if (versindex == 0)
-		return try_to_force_load(mod, symname) == 0;
-
-	versions = (void *) sechdrs[versindex].sh_addr;
-	num_versions = sechdrs[versindex].sh_size
-		/ sizeof(struct modversion_info);
-
-	for (i = 0; i < num_versions; i++) {
-		u32 crcval;
-
-		if (strcmp(versions[i].name, symname) != 0)
-			continue;
-
-		if (IS_ENABLED(CONFIG_MODULE_REL_CRCS))
-			crcval = resolve_rel_crc(crc);
-		else
-			crcval = *crc;
-		if (versions[i].crc == crcval)
-			return 1;
-		pr_debug("Found checksum %X vs module %lX\n",
-			 crcval, versions[i].crc);
-		goto bad_version;
-	}
-
-	/* Broken toolchain. Warn once, then let it go.. */
-	pr_warn_once("%s: no symbol version for %s\n", info->name, symname);
-	return 1;
-
-bad_version:
-	pr_warn("%s: disagrees about version of symbol %s\n",
-	       info->name, symname);
-	return 0;
-}
-
-static inline int check_modstruct_version(const struct load_info *info,
-					  struct module *mod)
-{
-	struct find_symbol_arg fsa = {
-		.name	= "module_layout",
-		.gplok	= true,
-	};
-
-	/*
-	 * Since this should be found in kernel (which can't be removed), no
-	 * locking is necessary -- use preempt_disable() to placate lockdep.
-	 */
-	preempt_disable();
-	if (!find_symbol(&fsa)) {
-		preempt_enable();
-		BUG();
-	}
-	preempt_enable();
-	return check_version(info, "module_layout", mod, fsa.crc);
-}
-
-/* First part is kernel version, which we ignore if module has crcs. */
-static inline int same_magic(const char *amagic, const char *bmagic,
-			     bool has_crcs)
-{
-	if (has_crcs) {
-		amagic += strcspn(amagic, " ");
-		bmagic += strcspn(bmagic, " ");
-	}
-	return strcmp(amagic, bmagic) == 0;
-}
-#else
-static inline int check_version(const struct load_info *info,
-				const char *symname,
-				struct module *mod,
-				const s32 *crc)
-{
-	return 1;
-}
-
-static inline int check_modstruct_version(const struct load_info *info,
-					  struct module *mod)
-{
-	return 1;
-}
-
-static inline int same_magic(const char *amagic, const char *bmagic,
-			     bool has_crcs)
-{
-	return strcmp(amagic, bmagic) == 0;
-}
-#endif /* CONFIG_MODVERSIONS */
-
 static char *get_modinfo(const struct load_info *info, const char *tag);
 static char *get_next_modinfo(const struct load_info *info, const char *tag,
 			      char *prev);
@@ -3229,18 +3098,3 @@ void print_modules(void)
 		pr_cont(" [last unloaded: %s]", last_unloaded_module);
 	pr_cont("\n");
 }
-
-#ifdef CONFIG_MODVERSIONS
-/*
- * Generate the signature for all relevant module structures here.
- * If these change, we don't want to try to parse the module.
- */
-void module_layout(struct module *mod,
-		   struct modversion_info *ver,
-		   struct kernel_param *kp,
-		   struct kernel_symbol *ks,
-		   struct tracepoint * const *tp)
-{
-}
-EXPORT_SYMBOL(module_layout);
-#endif
diff --git a/kernel/module/version.c b/kernel/module/version.c
new file mode 100644
index 000000000000..6a2c9ae1c5c5
--- /dev/null
+++ b/kernel/module/version.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Module version support
+ *
+ * Copyright (C) 2008 Rusty Russell
+ */
+
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/printk.h>
+#include "internal.h"
+
+/*
+ * Generate the signature for all relevant module structures here.
+ * If these change, we don't want to try to parse the module.
+ */
+void module_layout(struct module *mod,
+		   struct modversion_info *ver,
+		   struct kernel_param *kp,
+		   struct kernel_symbol *ks,
+		   struct tracepoint * const *tp)
+{
+}
+EXPORT_SYMBOL(module_layout);
+
+static u32 resolve_rel_crc(const s32 *crc)
+{
+	return *(u32 *)((void *)crc + *crc);
+}
+
+int check_version(const struct load_info *info,
+			 const char *symname,
+			 struct module *mod,
+			 const s32 *crc)
+{
+	Elf_Shdr *sechdrs = info->sechdrs;
+	unsigned int versindex = info->index.vers;
+	unsigned int i, num_versions;
+	struct modversion_info *versions;
+
+	/* Exporting module didn't supply crcs?  OK, we're already tainted. */
+	if (!crc)
+		return 1;
+
+	/* No versions at all?  modprobe --force does this. */
+	if (versindex == 0)
+		return try_to_force_load(mod, symname) == 0;
+
+	versions = (void *) sechdrs[versindex].sh_addr;
+	num_versions = sechdrs[versindex].sh_size
+		/ sizeof(struct modversion_info);
+
+	for (i = 0; i < num_versions; i++) {
+		u32 crcval;
+
+		if (strcmp(versions[i].name, symname) != 0)
+			continue;
+
+		if (IS_ENABLED(CONFIG_MODULE_REL_CRCS))
+			crcval = resolve_rel_crc(crc);
+		else
+			crcval = *crc;
+		if (versions[i].crc == crcval)
+			return 1;
+		pr_debug("Found checksum %X vs module %lX\n",
+			 crcval, versions[i].crc);
+		goto bad_version;
+	}
+
+	/* Broken toolchain. Warn once, then let it go.. */
+	pr_warn_once("%s: no symbol version for %s\n", info->name, symname);
+	return 1;
+
+bad_version:
+	pr_warn("%s: disagrees about version of symbol %s\n",
+	       info->name, symname);
+	return 0;
+}
+
+inline int check_modstruct_version(const struct load_info *info,
+					  struct module *mod)
+{
+	struct find_symbol_arg fsa = {
+		.name	= "module_layout",
+		.gplok	= true,
+	};
+
+	/*
+	 * Since this should be found in kernel (which can't be removed), no
+	 * locking is necessary -- use preempt_disable() to placate lockdep.
+	 */
+	preempt_disable();
+	if (!find_symbol(&fsa)) {
+		preempt_enable();
+		BUG();
+	}
+	preempt_enable();
+	return check_version(info, "module_layout", mod, fsa.crc);
+}
+
+/* First part is kernel version, which we ignore if module has crcs. */
+inline int same_magic(const char *amagic, const char *bmagic,
+			     bool has_crcs)
+{
+	if (has_crcs) {
+		amagic += strcspn(amagic, " ");
+		bmagic += strcspn(bmagic, " ");
+	}
+	return strcmp(amagic, bmagic) == 0;
+}
-- 
2.34.1

