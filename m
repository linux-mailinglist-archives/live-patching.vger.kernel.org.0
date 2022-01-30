Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484D84A3A6F
	for <lists+live-patching@lfdr.de>; Sun, 30 Jan 2022 22:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356434AbiA3Vcl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 30 Jan 2022 16:32:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36616 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356449AbiA3VcY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 30 Jan 2022 16:32:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643578343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QXh589vFvMrnMIUeph5M5xWx3C0pdmawJfK9iOmEPzA=;
        b=WJ9pjgh+dQ9C/mvBXjTgGfpvn18oNoW2x5Y3/9jzWniVj0Dv3zGA16SRPibm/CVOt4vARB
        Hr7LiEODgZ5dvCZiQPMjYvHoD6X612Nlm+la4X1aIBDC41YYO1QmMmVAYoabQlwMk4oihX
        DE23h5czLMBNRmBbfolKBPEm3nmsPVk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-529-48aNtegAMBSHr2GX98zZsg-1; Sun, 30 Jan 2022 16:32:22 -0500
X-MC-Unique: 48aNtegAMBSHr2GX98zZsg-1
Received: by mail-wm1-f70.google.com with SMTP id r83-20020a1c4456000000b00352cf8b74dcso84103wma.0
        for <live-patching@vger.kernel.org>; Sun, 30 Jan 2022 13:32:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QXh589vFvMrnMIUeph5M5xWx3C0pdmawJfK9iOmEPzA=;
        b=mk/LWbkZinFKyGC5odkNa6ZrcbpDF8Jn7/OaRPrYYwPIKcYleb7zuxOyjE7DG6v5iy
         6myVUHz9DQhTKDVibsmJaGCe+ZhNzGg7Or/qzyzgqCPjpCtZqq6Kk/Ant3UYnetu0gTy
         mjRpcNtRhru/3d4DbXUgS2/rx/8HTZlocZ9jPJ/Xjt6NlnZDWpOCSz3ICdFF92ucas6c
         9IlUa78jjDBMaq2fEhHz/hIglWGrAwpyBbj0ZvuXBWbioY9n7qaz12K/vkkLIAoZBSrf
         PVNnPF3md/ns4KlJPuu4xQ8G2gOYRUrPxpXyxVFy4OBhOOV/mgmWcFXPUgsW6Y80Oyah
         AmrQ==
X-Gm-Message-State: AOAM532j0PP1BXTffKWrAeUo2URTIDg8ULHJl71KJ4+XMey3zZKAjuS9
        ffqsDkLUy03kweqvP3aCcKRxpfc0gWQQWPEo+LfklOoyL0x82zDbQEOmlsbM2bbLuAuMiH88PnD
        E6btXXqU0uzb/kMvHjonqbg5U
X-Received: by 2002:a05:600c:510e:: with SMTP id o14mr16205193wms.163.1643578341080;
        Sun, 30 Jan 2022 13:32:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBcnZ7YuyjzrWriFHLlfRfjVX9SJyc6dZ5zw+jYQNPk97ekvd+lPSXxfjFIZ+Ucy2AitFlLQ==
X-Received: by 2002:a05:600c:510e:: with SMTP id o14mr16205184wms.163.1643578340898;
        Sun, 30 Jan 2022 13:32:20 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id q13sm10301815wrd.78.2022.01.30.13.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 13:32:20 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com
Subject: [RFC PATCH v4 03/13] module: Move livepatch support to a separate file
Date:   Sun, 30 Jan 2022 21:32:04 +0000
Message-Id: <20220130213214.1042497-4-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220130213214.1042497-1-atomlin@redhat.com>
References: <20220130213214.1042497-1-atomlin@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

No functional change.

This patch migrates livepatch support (i.e. used during module
add/or load and remove/or deletion) from core module code into
kernel/module/livepatch.c. At the moment it contains code to
persist Elf information about a given livepatch module, only.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
---
 include/linux/module.h    |  16 ++++--
 kernel/module/Makefile    |   3 ++
 kernel/module/internal.h  |  11 ++++
 kernel/module/livepatch.c |  74 +++++++++++++++++++++++++++
 kernel/module/main.c      | 102 ++++----------------------------------
 5 files changed, 109 insertions(+), 97 deletions(-)
 create mode 100644 kernel/module/livepatch.c

diff --git a/include/linux/module.h b/include/linux/module.h
index f4338235ed2c..c7daac4d16ee 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -663,17 +663,23 @@ static inline bool module_requested_async_probing(struct module *module)
 	return module && module->async_probe_requested;
 }
 
-#ifdef CONFIG_LIVEPATCH
 static inline bool is_livepatch_module(struct module *mod)
 {
-	return mod->klp;
+	if (IS_ENABLED(CONFIG_LIVEPATCH)) {
+		if (mod->klp)
+			return true;
+	}
+	return false;
 }
-#else /* !CONFIG_LIVEPATCH */
-static inline bool is_livepatch_module(struct module *mod)
+
+static inline bool set_livepatch_module(struct module *mod)
 {
+	if (IS_ENABLED(CONFIG_LIVEPATCH)) {
+		mod->klp = true;
+		return true;
+	}
 	return false;
 }
-#endif /* CONFIG_LIVEPATCH */
 
 bool is_module_sig_enforced(void);
 void set_module_sig_enforced(void);
diff --git a/kernel/module/Makefile b/kernel/module/Makefile
index 2902fc7d0ef1..ee20d864ad19 100644
--- a/kernel/module/Makefile
+++ b/kernel/module/Makefile
@@ -7,3 +7,6 @@ obj-$(CONFIG_MODULES) += main.o
 obj-$(CONFIG_MODULE_DECOMPRESS) += decompress.o
 obj-$(CONFIG_MODULE_SIG) += signing.o
 obj-$(CONFIG_MODULE_SIG_FORMAT) += signature.o
+ifdef CONFIG_MODULES
+obj-$(CONFIG_LIVEPATCH) += livepatch.o
+endif
diff --git a/kernel/module/internal.h b/kernel/module/internal.h
index e3c593f8767f..6150ec5ae042 100644
--- a/kernel/module/internal.h
+++ b/kernel/module/internal.h
@@ -57,6 +57,17 @@ struct load_info {
 
 extern int mod_verify_sig(const void *mod, struct load_info *info);
 
+#ifdef CONFIG_LIVEPATCH
+extern int copy_module_elf(struct module *mod, struct load_info *info);
+extern void free_module_elf(struct module *mod);
+#else /* !CONFIG_LIVEPATCH */
+static inline int copy_module_elf(struct module *mod, struct load_info *info)
+{
+	return 0;
+}
+static inline void free_module_elf(struct module *mod) { }
+#endif /* CONFIG_LIVEPATCH */
+
 #ifdef CONFIG_MODULE_DECOMPRESS
 int module_decompress(struct load_info *info, const void *buf, size_t size);
 void module_decompress_cleanup(struct load_info *info);
diff --git a/kernel/module/livepatch.c b/kernel/module/livepatch.c
new file mode 100644
index 000000000000..961045d32332
--- /dev/null
+++ b/kernel/module/livepatch.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Module livepatch support
+ *
+ * Copyright (C) 2016 Jessica Yu <jeyu@redhat.com>
+ */
+
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include "internal.h"
+
+/*
+ * Persist Elf information about a module. Copy the Elf header,
+ * section header table, section string table, and symtab section
+ * index from info to mod->klp_info.
+ */
+int copy_module_elf(struct module *mod, struct load_info *info)
+{
+	unsigned int size, symndx;
+	int ret;
+
+	size = sizeof(*mod->klp_info);
+	mod->klp_info = kmalloc(size, GFP_KERNEL);
+	if (mod->klp_info == NULL)
+		return -ENOMEM;
+
+	/* Elf header */
+	size = sizeof(mod->klp_info->hdr);
+	memcpy(&mod->klp_info->hdr, info->hdr, size);
+
+	/* Elf section header table */
+	size = sizeof(*info->sechdrs) * info->hdr->e_shnum;
+	mod->klp_info->sechdrs = kmemdup(info->sechdrs, size, GFP_KERNEL);
+	if (mod->klp_info->sechdrs == NULL) {
+		ret = -ENOMEM;
+		goto free_info;
+	}
+
+	/* Elf section name string table */
+	size = info->sechdrs[info->hdr->e_shstrndx].sh_size;
+	mod->klp_info->secstrings = kmemdup(info->secstrings, size, GFP_KERNEL);
+	if (mod->klp_info->secstrings == NULL) {
+		ret = -ENOMEM;
+		goto free_sechdrs;
+	}
+
+	/* Elf symbol section index */
+	symndx = info->index.sym;
+	mod->klp_info->symndx = symndx;
+
+	/*
+	 * For livepatch modules, core_kallsyms.symtab is a complete
+	 * copy of the original symbol table. Adjust sh_addr to point
+	 * to core_kallsyms.symtab since the copy of the symtab in module
+	 * init memory is freed at the end of do_init_module().
+	 */
+	mod->klp_info->sechdrs[symndx].sh_addr = (unsigned long) mod->core_kallsyms.symtab;
+
+	return 0;
+
+free_sechdrs:
+	kfree(mod->klp_info->sechdrs);
+free_info:
+	kfree(mod->klp_info);
+	return ret;
+}
+
+void free_module_elf(struct module *mod)
+{
+	kfree(mod->klp_info->sechdrs);
+	kfree(mod->klp_info->secstrings);
+	kfree(mod->klp_info);
+}
diff --git a/kernel/module/main.c b/kernel/module/main.c
index fee64c4957f3..c91c7e57bca7 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -2042,81 +2042,6 @@ static int module_enforce_rwx_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
 }
 #endif /*  CONFIG_STRICT_MODULE_RWX */
 
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
@@ -3091,30 +3016,23 @@ static int copy_chunked_from_user(void *dst, const void __user *usrc, unsigned l
 	return 0;
 }
 
-#ifdef CONFIG_LIVEPATCH
 static int check_modinfo_livepatch(struct module *mod, struct load_info *info)
 {
-	if (get_modinfo(info, "livepatch")) {
-		mod->klp = true;
+	if (!get_modinfo(info, "livepatch"))
+		/* Nothing more to do */
+		return 0;
+
+	if (set_livepatch_module(mod)) {
 		add_taint_module(mod, TAINT_LIVEPATCH, LOCKDEP_STILL_OK);
 		pr_notice_once("%s: tainting kernel with TAINT_LIVEPATCH\n",
-			       mod->name);
-	}
-
-	return 0;
-}
-#else /* !CONFIG_LIVEPATCH */
-static int check_modinfo_livepatch(struct module *mod, struct load_info *info)
-{
-	if (get_modinfo(info, "livepatch")) {
-		pr_err("%s: module is marked as livepatch module, but livepatch support is disabled",
-		       mod->name);
-		return -ENOEXEC;
+				mod->name);
+		return 0;
 	}
 
-	return 0;
+	pr_err("%s: module is marked as livepatch module, but livepatch support is disabled",
+		mod->name);
+	return -ENOEXEC;
 }
-#endif /* CONFIG_LIVEPATCH */
 
 static void check_modinfo_retpoline(struct module *mod, struct load_info *info)
 {
-- 
2.34.1

