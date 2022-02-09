Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FE84AF7A8
	for <lists+live-patching@lfdr.de>; Wed,  9 Feb 2022 18:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237851AbiBIREN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 9 Feb 2022 12:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237779AbiBIREF (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 9 Feb 2022 12:04:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7156BC0613C9
        for <live-patching@vger.kernel.org>; Wed,  9 Feb 2022 09:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644426247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vxPPOiAgnn6U/GdcXOrorNiCMFgt/RKfYJSpNgieADs=;
        b=V5ihq0oPKIVvz57n7NvIT8VJdpjEjPOZD5w/qTVYsfV7jUHlT5yQubk1uJGn4sMR1Kc0xX
        oaOl36fj37swWmgcCFi3E4J9rQK8bh1jxaFF22zOWtzQwiQmtiRveVsiBKjfKlBwjgVMXr
        PDG2iMy7b9IuwiXpSdYYwgfg7PNUnyo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-533-ml_14h3KMiiywlOBXIL7og-1; Wed, 09 Feb 2022 12:04:06 -0500
X-MC-Unique: ml_14h3KMiiywlOBXIL7og-1
Received: by mail-wm1-f72.google.com with SMTP id p2-20020a05600c430200b0037bb72b5865so282725wme.8
        for <live-patching@vger.kernel.org>; Wed, 09 Feb 2022 09:04:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vxPPOiAgnn6U/GdcXOrorNiCMFgt/RKfYJSpNgieADs=;
        b=Y2qpR4v8TJX+gWQ93+1f2/S+0ZOeoCOsOyVkGZqk2rsGUsPAIpo/UH+vg1tnGFsbWZ
         2Lb1LLhFP7/Feuraz4RXaapHTP7wst4yMwYOoF4BGcX9BGNSOSCCkaGqtDnG8qfsY4yH
         coxg9/kWaQzX4xAA9bOT0BMylVYxsyXnDHOvTy6REjaDkqReSk4gIueKgfJ17wUZVTS+
         1piqKC3GUQ6xH8IXT6FSW1zR9bVteMY+38dYC/gVBP+1ttKl/ZZEclg9OiZBv/cF0L7J
         pm6zoeuoxXS1Zp4WfXz/EoZbVZz9KZlg8O45fd5FKVrdg0EBaS43ayOfJFOHw0O44ijp
         4IBQ==
X-Gm-Message-State: AOAM532QV3RtzHZlzFNaOVYFZls/Fbwc+3h5tZVp26nXsAl9/CpC9Exk
        u4gV9+sdBS4rIRvPMnBWXj2yKJlf2q4dY0TzSuOMWV92QLYRdaqBiQCiTZZxT+a8JG9SHF8KqrN
        A7n+qSzjF7wVSfcOFCpKnSft9
X-Received: by 2002:a7b:c302:: with SMTP id k2mr3498788wmj.182.1644426245325;
        Wed, 09 Feb 2022 09:04:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzYFXgpSoWeCHMnTLpK8wxU8hMNE2MxvfTQUv4r+T9pYUDVC+TZdpwBtiWHA7oM0HnXAouHJg==
X-Received: by 2002:a7b:c302:: with SMTP id k2mr3498770wmj.182.1644426245072;
        Wed, 09 Feb 2022 09:04:05 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id r6sm4632883wrn.74.2022.02.09.09.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 09:04:04 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com, christophe.leroy@csgroup.eu, msuchanek@suse.de,
        oleksandr@natalenko.name
Subject: [PATCH v5 04/13] module: Move livepatch support to a separate file
Date:   Wed,  9 Feb 2022 17:03:49 +0000
Message-Id: <20220209170358.3266629-5-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209170358.3266629-1-atomlin@redhat.com>
References: <20220209170358.3266629-1-atomlin@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
 include/linux/module.h    |   5 +-
 kernel/module/Makefile    |   3 ++
 kernel/module/internal.h  |  18 +++++++
 kernel/module/livepatch.c |  80 ++++++++++++++++++++++++++++++
 kernel/module/main.c      | 102 ++++----------------------------------
 5 files changed, 112 insertions(+), 96 deletions(-)
 create mode 100644 kernel/module/livepatch.c

diff --git a/include/linux/module.h b/include/linux/module.h
index 1e135fd5c076..680b31ff57fa 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -664,10 +664,7 @@ static inline bool module_requested_async_probing(struct module *module)
 }
 
 #ifdef CONFIG_LIVEPATCH
-static inline bool is_livepatch_module(struct module *mod)
-{
-	return mod->klp;
-}
+bool is_livepatch_module(struct module *mod);
 #else /* !CONFIG_LIVEPATCH */
 static inline bool is_livepatch_module(struct module *mod)
 {
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
index 1cf5d6dabc97..d252e0af1c54 100644
--- a/kernel/module/internal.h
+++ b/kernel/module/internal.h
@@ -58,6 +58,24 @@ struct load_info {
 
 int mod_verify_sig(const void *mod, struct load_info *info);
 
+#ifdef CONFIG_LIVEPATCH
+int copy_module_elf(struct module *mod, struct load_info *info);
+void free_module_elf(struct module *mod);
+bool set_livepatch_module(struct module *mod);
+#else /* !CONFIG_LIVEPATCH */
+static inline int copy_module_elf(struct module *mod, struct load_info *info)
+{
+	return 0;
+}
+
+static inline bool set_livepatch_module(struct module *mod)
+{
+	return false;
+}
+
+static inline void free_module_elf(struct module *mod) { }
+#endif /* CONFIG_LIVEPATCH */
+
 #ifdef CONFIG_MODULE_DECOMPRESS
 int module_decompress(struct load_info *info, const void *buf, size_t size);
 void module_decompress_cleanup(struct load_info *info);
diff --git a/kernel/module/livepatch.c b/kernel/module/livepatch.c
new file mode 100644
index 000000000000..7e9cf530c3f0
--- /dev/null
+++ b/kernel/module/livepatch.c
@@ -0,0 +1,80 @@
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
+
+inline bool set_livepatch_module(struct module *mod)
+{
+	mod->klp = true;
+	return true;
+}
diff --git a/kernel/module/main.c b/kernel/module/main.c
index 750e3ad28679..5f5bd7152b55 100644
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

