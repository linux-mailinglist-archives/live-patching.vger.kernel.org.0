Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E424A0209
	for <lists+live-patching@lfdr.de>; Fri, 28 Jan 2022 21:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240847AbiA1Ujn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 28 Jan 2022 15:39:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26096 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242880AbiA1Ujm (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 28 Jan 2022 15:39:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643402382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d16QLh1b9mk2jCD+hTXFdS67qH+rGFScBQ+xHFcVQ8Y=;
        b=P/ICiTHiJ1FPsKe/23avwPQ8jrverUFiEn4t5X5fp72MTlI0C7DUtx+6KuoyGkFHFAWh1F
        hKEkZWwW6VSwRtAnqEHgQTcjulX5ZBOl0ifbCbBkD9QWssTzPy2CHJHy0PvgTz+kdLPOT0
        3Sb/P9ILyjIlYlRr0MvIPIfy6D+IWpo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-3xfHMptCO8G4TiLPU_Bq0w-1; Fri, 28 Jan 2022 15:39:41 -0500
X-MC-Unique: 3xfHMptCO8G4TiLPU_Bq0w-1
Received: by mail-wm1-f69.google.com with SMTP id j18-20020a05600c1c1200b0034aeea95dacso6416531wms.8
        for <live-patching@vger.kernel.org>; Fri, 28 Jan 2022 12:39:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d16QLh1b9mk2jCD+hTXFdS67qH+rGFScBQ+xHFcVQ8Y=;
        b=kU4mBDAk8C4mUsWTq/eM+8VzEbkinpMsfGXgXlcSY0/HhvvBQil6+wacrlhYqAcoiV
         NVTjsSsPhJIcjSr83SoR8DxsalcWGr5hfuNCFchvQkyty3D30s8pFUcYufyM39NTLmXv
         72+07QkP+GxQ2gQghH6Rz/7148hOmJAbPqDl7JSkNsBA6XxX1IlFjPPqnR956X+N3Jyp
         Hgb6MfBLlSpdhzfDgDZiqY55q6B6Mt2ef/f9xQO5KkoNgwYpvTLuqvjJBm53hmkye3ok
         /5Znhas5LMdsCqYsDAqooH5btrDJuMzoiiD5VaO1qodayJ5ha7jO91645QxHwixs2Y3i
         yWlw==
X-Gm-Message-State: AOAM533749ZoGjNTBqC6X3YtuLM+QXZyMPGTxfGTR9mda+sAFEUr9yuS
        N5YH/Lvf06t0mbbP+9rxvJlYeur31c0yF1s0IqK/aT5rdcCqTB9zg4JweNaKAktr79JhFjUdrst
        2zCMd7QqRySd2lXD+V4Tgzg+K
X-Received: by 2002:a5d:458d:: with SMTP id p13mr8704486wrq.580.1643402379772;
        Fri, 28 Jan 2022 12:39:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJznnzOL+XK7/yi1zY0r025gKwZSHdCpphgz/2vVbU3vAB//bhuSlyCOuDAonCMMExhli3rjdg==
X-Received: by 2002:a5d:458d:: with SMTP id p13mr8704476wrq.580.1643402379519;
        Fri, 28 Jan 2022 12:39:39 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id u14sm5309946wrm.58.2022.01.28.12.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 12:39:39 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com
Subject: [RFC PATCH v3 03/13] module: Move livepatch support to a separate file
Date:   Fri, 28 Jan 2022 20:39:24 +0000
Message-Id: <20220128203934.600247-4-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128203934.600247-1-atomlin@redhat.com>
References: <20220128203934.600247-1-atomlin@redhat.com>
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
 include/linux/module.h    |  11 ++++
 kernel/module/Makefile    |   1 +
 kernel/module/internal.h  |  10 ++++
 kernel/module/livepatch.c |  74 +++++++++++++++++++++++++++
 kernel/module/main.c      | 102 ++++----------------------------------
 5 files changed, 106 insertions(+), 92 deletions(-)
 create mode 100644 kernel/module/livepatch.c

diff --git a/include/linux/module.h b/include/linux/module.h
index f4338235ed2c..8d49f12a7601 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -668,11 +668,22 @@ static inline bool is_livepatch_module(struct module *mod)
 {
 	return mod->klp;
 }
+
+static inline bool set_livepatch_module(struct module *mod)
+{
+	mod->klp = true;
+	return true;
+}
 #else /* !CONFIG_LIVEPATCH */
 static inline bool is_livepatch_module(struct module *mod)
 {
 	return false;
 }
+
+static inline bool set_livepatch_module(struct module *mod)
+{
+	return false;
+}
 #endif /* CONFIG_LIVEPATCH */
 
 bool is_module_sig_enforced(void);
diff --git a/kernel/module/Makefile b/kernel/module/Makefile
index 2902fc7d0ef1..ba3ebdb7055b 100644
--- a/kernel/module/Makefile
+++ b/kernel/module/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_MODULES) += main.o
 obj-$(CONFIG_MODULE_DECOMPRESS) += decompress.o
 obj-$(CONFIG_MODULE_SIG) += signing.o
 obj-$(CONFIG_MODULE_SIG_FORMAT) += signature.o
+obj-$(CONFIG_LIVEPATCH) += livepatch.o
diff --git a/kernel/module/internal.h b/kernel/module/internal.h
index e3c593f8767f..0cd624179545 100644
--- a/kernel/module/internal.h
+++ b/kernel/module/internal.h
@@ -57,6 +57,16 @@ struct load_info {
 
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

