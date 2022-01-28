Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B93F4A0214
	for <lists+live-patching@lfdr.de>; Fri, 28 Jan 2022 21:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239213AbiA1Ujs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 28 Jan 2022 15:39:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54054 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344421AbiA1Ujq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 28 Jan 2022 15:39:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643402386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xbb1waqP0kwmR38UUX09e82b0OEVG9z0fGYLb99+jx8=;
        b=Ti+BnmvYkizeh9Rc5WgOwBOhNsdVBSTALXYdn4wt//RpMbZWNZgq+hzsFcLOCQD+M3RVi2
        EhzKnL4ZYd0ccD9FmoblLjxHqZxrzAHIHh5tHfb9IeSVzZKQIIlvDtxwUWnZqPeLu+LBjd
        MTuicCT0btMxYWpidxbeBdyPWV3/Bb8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-68-Lc3BO-mWMsivBsZjkWsfrw-1; Fri, 28 Jan 2022 15:39:45 -0500
X-MC-Unique: Lc3BO-mWMsivBsZjkWsfrw-1
Received: by mail-wm1-f71.google.com with SMTP id c7-20020a1c3507000000b0034a0dfc86aaso4268387wma.6
        for <live-patching@vger.kernel.org>; Fri, 28 Jan 2022 12:39:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xbb1waqP0kwmR38UUX09e82b0OEVG9z0fGYLb99+jx8=;
        b=GccrSX2g0mgh7QBb9bGF+pJl804cKx9nyP+xossW0qHtUdMtgCHiXFjZ9X+nfs2QOu
         gMYimL2jpf4g9s+9pGWXqXJXvxS+/HlIFr6mFpgfSqq7lnJPp3YNLkBWpFTR9dE65qJ+
         NRsk1L3mpZNf3TVMUN3MrD+QyqiDyf9Vz+zfAeZum5gG2SkonY2d1EqOeUAgctnh5lMk
         T5/TiQSRFPW2Kh/2ANafUs+zLilUvjWpD1FKCf/JraN8m3Lk31VFX6myhdIapwqukqBr
         JteQ75F48kVuKfs2rxNIPYCB66ml1pbZJ58Jr3RqLkLMR+Pb+axpgMWGhOazvsfLT04v
         PKrw==
X-Gm-Message-State: AOAM530tR26nuE6zVmU3Iy05rAP1xGpaE1Oc7wnCSIyh2Vluato+EtJx
        nNDADwNeDv5AsSsQBzQnBc0PCSwvGZpvv/EskRmsiLQWqX1Q7TZrsgv7L5sxa9uqt2h6eGbrDlu
        2SwMHPOtjAekQklYJE0jgrHHX
X-Received: by 2002:a05:600c:410f:: with SMTP id j15mr16876888wmi.161.1643402383748;
        Fri, 28 Jan 2022 12:39:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz0KmH7Sb9LA6jQrXsRA9x/tDgc/8kIU0hC69q/zFCL5hL/lNYygPpGjv9MtiL0/f2oHiR/YA==
X-Received: by 2002:a05:600c:410f:: with SMTP id j15mr16876869wmi.161.1643402383571;
        Fri, 28 Jan 2022 12:39:43 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id f16sm1472309wmg.28.2022.01.28.12.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 12:39:43 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com
Subject: [RFC PATCH v3 06/13] module: Move strict rwx support to a separate file
Date:   Fri, 28 Jan 2022 20:39:27 +0000
Message-Id: <20220128203934.600247-7-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128203934.600247-1-atomlin@redhat.com>
References: <20220128203934.600247-1-atomlin@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

No functional change.

This patch migrates code that makes module text
and rodata memory read-only and non-text memory
non-executable from core module code into
kernel/module/strict_rwx.c.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
---
 include/linux/module.h     | 22 ++++++++++
 kernel/module/Makefile     |  1 +
 kernel/module/main.c       | 84 --------------------------------------
 kernel/module/strict_rwx.c | 83 +++++++++++++++++++++++++++++++++++++
 4 files changed, 106 insertions(+), 84 deletions(-)
 create mode 100644 kernel/module/strict_rwx.c

diff --git a/include/linux/module.h b/include/linux/module.h
index 35552164830d..7bf93c0d87e6 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -356,6 +356,28 @@ extern void module_enable_x(const struct module *mod);
 static void module_enable_x(const struct module *mod) { }
 #endif /* CONFIG_ARCH_HAS_STRICT_MODULE_RWX */
 
+#ifdef CONFIG_STRICT_MODULE_RWX
+extern void frob_rodata(const struct module_layout *layout,
+			int (*set_memory)(unsigned long start, int num_pages));
+extern void frob_ro_after_init(const struct module_layout *layout,
+			       int (*set_memory)(unsigned long start, int num_pages));
+extern void frob_writable_data(const struct module_layout *layout,
+			       int (*set_memory)(unsigned long start, int num_pages));
+extern void module_enable_ro(const struct module *mod, bool after_init);
+extern void module_enable_nx(const struct module *mod);
+extern int module_enforce_rwx_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
+				       char *secstrings, struct module *mod);
+
+#else /* !CONFIG_STRICT_MODULE_RWX */
+static void module_enable_nx(const struct module *mod) { }
+static void module_enable_ro(const struct module *mod, bool after_init) {}
+static int module_enforce_rwx_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
+				       char *secstrings, struct module *mod)
+{
+	return 0;
+}
+#endif /* CONFIG_STRICT_MODULE_RWX */
+
 #ifdef CONFIG_MODULES_TREE_LOOKUP
 struct mod_tree_root {
 	struct latch_tree_root root;
diff --git a/kernel/module/Makefile b/kernel/module/Makefile
index 71341f30c3f2..c4198fcf4772 100644
--- a/kernel/module/Makefile
+++ b/kernel/module/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_MODULE_SIG_FORMAT) += signature.o
 obj-$(CONFIG_LIVEPATCH) += livepatch.o
 obj-$(CONFIG_MODULES_TREE_LOOKUP) += tree_lookup.o
 obj-$(CONFIG_ARCH_HAS_STRICT_MODULE_RWX) += arch_strict_rwx.o
+obj-$(CONFIG_STRICT_MODULE_RWX) += strict_rwx.o
diff --git a/kernel/module/main.c b/kernel/module/main.c
index fbac043b07d7..4f590b0c7aca 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1773,90 +1773,6 @@ static void mod_sysfs_teardown(struct module *mod)
 	mod_sysfs_fini(mod);
 }
 
-#ifdef CONFIG_STRICT_MODULE_RWX
-static void frob_rodata(const struct module_layout *layout,
-			int (*set_memory)(unsigned long start, int num_pages))
-{
-	BUG_ON((unsigned long)layout->base & (PAGE_SIZE-1));
-	BUG_ON((unsigned long)layout->text_size & (PAGE_SIZE-1));
-	BUG_ON((unsigned long)layout->ro_size & (PAGE_SIZE-1));
-	set_memory((unsigned long)layout->base + layout->text_size,
-		   (layout->ro_size - layout->text_size) >> PAGE_SHIFT);
-}
-
-static void frob_ro_after_init(const struct module_layout *layout,
-				int (*set_memory)(unsigned long start, int num_pages))
-{
-	BUG_ON((unsigned long)layout->base & (PAGE_SIZE-1));
-	BUG_ON((unsigned long)layout->ro_size & (PAGE_SIZE-1));
-	BUG_ON((unsigned long)layout->ro_after_init_size & (PAGE_SIZE-1));
-	set_memory((unsigned long)layout->base + layout->ro_size,
-		   (layout->ro_after_init_size - layout->ro_size) >> PAGE_SHIFT);
-}
-
-static void frob_writable_data(const struct module_layout *layout,
-			       int (*set_memory)(unsigned long start, int num_pages))
-{
-	BUG_ON((unsigned long)layout->base & (PAGE_SIZE-1));
-	BUG_ON((unsigned long)layout->ro_after_init_size & (PAGE_SIZE-1));
-	BUG_ON((unsigned long)layout->size & (PAGE_SIZE-1));
-	set_memory((unsigned long)layout->base + layout->ro_after_init_size,
-		   (layout->size - layout->ro_after_init_size) >> PAGE_SHIFT);
-}
-
-static void module_enable_ro(const struct module *mod, bool after_init)
-{
-	if (!rodata_enabled)
-		return;
-
-	set_vm_flush_reset_perms(mod->core_layout.base);
-	set_vm_flush_reset_perms(mod->init_layout.base);
-	frob_text(&mod->core_layout, set_memory_ro);
-
-	frob_rodata(&mod->core_layout, set_memory_ro);
-	frob_text(&mod->init_layout, set_memory_ro);
-	frob_rodata(&mod->init_layout, set_memory_ro);
-
-	if (after_init)
-		frob_ro_after_init(&mod->core_layout, set_memory_ro);
-}
-
-static void module_enable_nx(const struct module *mod)
-{
-	frob_rodata(&mod->core_layout, set_memory_nx);
-	frob_ro_after_init(&mod->core_layout, set_memory_nx);
-	frob_writable_data(&mod->core_layout, set_memory_nx);
-	frob_rodata(&mod->init_layout, set_memory_nx);
-	frob_writable_data(&mod->init_layout, set_memory_nx);
-}
-
-static int module_enforce_rwx_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
-				       char *secstrings, struct module *mod)
-{
-	const unsigned long shf_wx = SHF_WRITE|SHF_EXECINSTR;
-	int i;
-
-	for (i = 0; i < hdr->e_shnum; i++) {
-		if ((sechdrs[i].sh_flags & shf_wx) == shf_wx) {
-			pr_err("%s: section %s (index %d) has invalid WRITE|EXEC flags\n",
-				mod->name, secstrings + sechdrs[i].sh_name, i);
-			return -ENOEXEC;
-		}
-	}
-
-	return 0;
-}
-
-#else /* !CONFIG_STRICT_MODULE_RWX */
-static void module_enable_nx(const struct module *mod) { }
-static void module_enable_ro(const struct module *mod, bool after_init) {}
-static int module_enforce_rwx_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
-				       char *secstrings, struct module *mod)
-{
-	return 0;
-}
-#endif /*  CONFIG_STRICT_MODULE_RWX */
-
 void __weak module_memfree(void *module_region)
 {
 	/*
diff --git a/kernel/module/strict_rwx.c b/kernel/module/strict_rwx.c
new file mode 100644
index 000000000000..39060021755a
--- /dev/null
+++ b/kernel/module/strict_rwx.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Module strict rwx
+ *
+ * Copyright (C) 2015 Rusty Russell
+ */
+
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+#include <linux/set_memory.h>
+
+void frob_rodata(const struct module_layout *layout,
+			int (*set_memory)(unsigned long start, int num_pages))
+{
+	BUG_ON((unsigned long)layout->base & (PAGE_SIZE-1));
+	BUG_ON((unsigned long)layout->text_size & (PAGE_SIZE-1));
+	BUG_ON((unsigned long)layout->ro_size & (PAGE_SIZE-1));
+	set_memory((unsigned long)layout->base + layout->text_size,
+		   (layout->ro_size - layout->text_size) >> PAGE_SHIFT);
+}
+
+void frob_ro_after_init(const struct module_layout *layout,
+				int (*set_memory)(unsigned long start, int num_pages))
+{
+	BUG_ON((unsigned long)layout->base & (PAGE_SIZE-1));
+	BUG_ON((unsigned long)layout->ro_size & (PAGE_SIZE-1));
+	BUG_ON((unsigned long)layout->ro_after_init_size & (PAGE_SIZE-1));
+	set_memory((unsigned long)layout->base + layout->ro_size,
+		   (layout->ro_after_init_size - layout->ro_size) >> PAGE_SHIFT);
+}
+
+void frob_writable_data(const struct module_layout *layout,
+			       int (*set_memory)(unsigned long start, int num_pages))
+{
+	BUG_ON((unsigned long)layout->base & (PAGE_SIZE-1));
+	BUG_ON((unsigned long)layout->ro_after_init_size & (PAGE_SIZE-1));
+	BUG_ON((unsigned long)layout->size & (PAGE_SIZE-1));
+	set_memory((unsigned long)layout->base + layout->ro_after_init_size,
+		   (layout->size - layout->ro_after_init_size) >> PAGE_SHIFT);
+}
+
+void module_enable_ro(const struct module *mod, bool after_init)
+{
+	if (!rodata_enabled)
+		return;
+
+	set_vm_flush_reset_perms(mod->core_layout.base);
+	set_vm_flush_reset_perms(mod->init_layout.base);
+	frob_text(&mod->core_layout, set_memory_ro);
+
+	frob_rodata(&mod->core_layout, set_memory_ro);
+	frob_text(&mod->init_layout, set_memory_ro);
+	frob_rodata(&mod->init_layout, set_memory_ro);
+
+	if (after_init)
+		frob_ro_after_init(&mod->core_layout, set_memory_ro);
+}
+
+void module_enable_nx(const struct module *mod)
+{
+	frob_rodata(&mod->core_layout, set_memory_nx);
+	frob_ro_after_init(&mod->core_layout, set_memory_nx);
+	frob_writable_data(&mod->core_layout, set_memory_nx);
+	frob_rodata(&mod->init_layout, set_memory_nx);
+	frob_writable_data(&mod->init_layout, set_memory_nx);
+}
+
+int module_enforce_rwx_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
+				       char *secstrings, struct module *mod)
+{
+	const unsigned long shf_wx = SHF_WRITE|SHF_EXECINSTR;
+	int i;
+
+	for (i = 0; i < hdr->e_shnum; i++) {
+		if ((sechdrs[i].sh_flags & shf_wx) == shf_wx) {
+			pr_err("%s: section %s (index %d) has invalid WRITE|EXEC flags\n",
+				mod->name, secstrings + sechdrs[i].sh_name, i);
+			return -ENOEXEC;
+		}
+	}
+
+	return 0;
+}
-- 
2.34.1

