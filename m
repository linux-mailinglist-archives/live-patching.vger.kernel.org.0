Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68704BC1DA
	for <lists+live-patching@lfdr.de>; Fri, 18 Feb 2022 22:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239808AbiBRV0C (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 18 Feb 2022 16:26:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239875AbiBRVZw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 18 Feb 2022 16:25:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D80EE4CD53
        for <live-patching@vger.kernel.org>; Fri, 18 Feb 2022 13:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645219534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hPDODXaR8/3AGDN8QUDZ31HR9/DK1gkzEtjlaYiIfVA=;
        b=K4lzqFqzOvDsMbsIPWM26JeCBOvkK6XKEKblMXQhzttUfcYfu+3MPPoI3NuUTna/OGPjyT
        i5lT3sLzaz7uC2FSkWVUlvGDMV2vNGr/gmCiUJF9LYC7fX9pmNHY1hioNAiQ2sH458Xagg
        Y2xMAN1Snci41cHO92nJNI9ZgM4t9mY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-yHsTyEmrPuCEoXTEhQLizQ-1; Fri, 18 Feb 2022 16:25:19 -0500
X-MC-Unique: yHsTyEmrPuCEoXTEhQLizQ-1
Received: by mail-wm1-f72.google.com with SMTP id h82-20020a1c2155000000b003552c13626cso6473697wmh.3
        for <live-patching@vger.kernel.org>; Fri, 18 Feb 2022 13:25:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hPDODXaR8/3AGDN8QUDZ31HR9/DK1gkzEtjlaYiIfVA=;
        b=XTJov6hCo6lJkT6GRsS0JY8jvxlxA86DxfZ52BHnCAUId8tbHSG/IA9kJUNf99aPsO
         DMczSU3EzLFgbaawCjzoWA88xgdvcOn9JW40qs6Yywuv5j+i+8zEebbouifihub5aKS0
         RGGGzYLOtvOswqZ+VKEwyYKXOudqhZpqTj/lQPEUszw83lEJVkWwiCwm/SxEtdmSRTOe
         I0LV1TcitsDTarzOH9oDQ9nBfRDU9FajP5kWdu8ZkVigE9mscpIc4PBrJEwquDPBUzYB
         jfWAiqEQnEhIAOjULF0BYX1NjXnxcBVM2nNaPsdNkCQoctHpsNsBP4lhlEzddBRDRFeg
         S12Q==
X-Gm-Message-State: AOAM53347TbIUr58s2tbkYKOBGtqer+aNci+LKCyJyipWSCtVcD9rSfA
        Oq6PyrE6wapZgUhRDwEJlmVUq5gj7V+JZ1d9FlQY+7tprHDMt+FZnb3orYtBc8uiLHiThzK1AKQ
        kRfUOQFfNhm+A4uRioRvhltzX
X-Received: by 2002:a5d:4ccc:0:b0:1e3:222b:40fc with SMTP id c12-20020a5d4ccc000000b001e3222b40fcmr7087018wrt.296.1645219518202;
        Fri, 18 Feb 2022 13:25:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzqme855dEAUGl23LY67f9MJyl8g1VKrcxsCOhX5MZPi4XlnoMw1fBOdo1a8apdoYozJ9eC8A==
X-Received: by 2002:a5d:4ccc:0:b0:1e3:222b:40fc with SMTP id c12-20020a5d4ccc000000b001e3222b40fcmr7087007wrt.296.1645219518004;
        Fri, 18 Feb 2022 13:25:18 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id 14sm12854628wrb.34.2022.02.18.13.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 13:25:17 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, joe@perches.com,
        christophe.leroy@csgroup.eu, msuchanek@suse.de,
        oleksandr@natalenko.name
Subject: [PATCH v6 04/13] module: Move livepatch support to a separate file
Date:   Fri, 18 Feb 2022 21:25:02 +0000
Message-Id: <20220218212511.887059-5-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218212511.887059-1-atomlin@redhat.com>
References: <20220218212511.887059-1-atomlin@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 include/linux/module.h    |   9 ++--
 kernel/module/Makefile    |   1 +
 kernel/module/internal.h  |  22 ++++++++
 kernel/module/livepatch.c |  74 +++++++++++++++++++++++++++
 kernel/module/main.c      | 102 ++++----------------------------------
 5 files changed, 110 insertions(+), 98 deletions(-)
 create mode 100644 kernel/module/livepatch.c

diff --git a/include/linux/module.h b/include/linux/module.h
index 1e135fd5c076..7ec9715de7dc 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -663,17 +663,14 @@ static inline bool module_requested_async_probing(struct module *module)
 	return module && module->async_probe_requested;
 }
 
-#ifdef CONFIG_LIVEPATCH
 static inline bool is_livepatch_module(struct module *mod)
 {
+#ifdef CONFIG_LIVEPATCH
 	return mod->klp;
-}
-#else /* !CONFIG_LIVEPATCH */
-static inline bool is_livepatch_module(struct module *mod)
-{
+#else
 	return false;
+#endif
 }
-#endif /* CONFIG_LIVEPATCH */
 
 bool is_module_sig_enforced(void);
 void set_module_sig_enforced(void);
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
index e0775e66bcf7..ad7a444253ed 100644
--- a/kernel/module/internal.h
+++ b/kernel/module/internal.h
@@ -57,6 +57,28 @@ struct load_info {
 
 int mod_verify_sig(const void *mod, struct load_info *info);
 
+#ifdef CONFIG_LIVEPATCH
+int copy_module_elf(struct module *mod, struct load_info *info);
+void free_module_elf(struct module *mod);
+#else /* !CONFIG_LIVEPATCH */
+static inline int copy_module_elf(struct module *mod, struct load_info *info)
+{
+	return 0;
+}
+
+static inline void free_module_elf(struct module *mod) { }
+#endif /* CONFIG_LIVEPATCH */
+
+static inline bool set_livepatch_module(struct module *mod)
+{
+#ifdef CONFIG_LIVEPATCH
+	mod->klp = true;
+	return true;
+#else
+	return false;
+#endif
+}
+
 #ifdef CONFIG_MODULE_DECOMPRESS
 int module_decompress(struct load_info *info, const void *buf, size_t size);
 void module_decompress_cleanup(struct load_info *info);
diff --git a/kernel/module/livepatch.c b/kernel/module/livepatch.c
new file mode 100644
index 000000000000..486d4ff92719
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
+	if (!mod->klp_info)
+		return -ENOMEM;
+
+	/* Elf header */
+	size = sizeof(mod->klp_info->hdr);
+	memcpy(&mod->klp_info->hdr, info->hdr, size);
+
+	/* Elf section header table */
+	size = sizeof(*info->sechdrs) * info->hdr->e_shnum;
+	mod->klp_info->sechdrs = kmemdup(info->sechdrs, size, GFP_KERNEL);
+	if (!mod->klp_info->sechdrs) {
+		ret = -ENOMEM;
+		goto free_info;
+	}
+
+	/* Elf section name string table */
+	size = info->sechdrs[info->hdr->e_shstrndx].sh_size;
+	mod->klp_info->secstrings = kmemdup(info->secstrings, size, GFP_KERNEL);
+	if (!mod->klp_info->secstrings) {
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
+	mod->klp_info->sechdrs[symndx].sh_addr = (unsigned long)mod->core_kallsyms.symtab;
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
index 5f5e21f972dd..3596ebf3a6c3 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -2043,81 +2043,6 @@ static int module_enforce_rwx_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
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
@@ -3092,30 +3017,23 @@ static int copy_chunked_from_user(void *dst, const void __user *usrc, unsigned l
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
+	       mod->name);
+	return -ENOEXEC;
 }
-#endif /* CONFIG_LIVEPATCH */
 
 static void check_modinfo_retpoline(struct module *mod, struct load_info *info)
 {
-- 
2.34.1

