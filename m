Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6D24A3A75
	for <lists+live-patching@lfdr.de>; Sun, 30 Jan 2022 22:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356748AbiA3Vcn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 30 Jan 2022 16:32:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35597 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356549AbiA3Vc2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 30 Jan 2022 16:32:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643578347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+8jA7bYfQPshsiLx0pkdrriw91RK3YxQWB2UbWGtHA0=;
        b=V5csWtGy+CBHW8A+iwxhbdEsUxhJOrtFpc1/ABlAYiAcqRpNpBdmpzfYItv13qg5ZTns6J
        3TgYdoLTMn+b6uwZwzDrRTsJgwsfsoHh2KdkoCSkDdWwrY/xinawRH6VpF8qlakf4gqMpB
        yiyVpj7rhxH9IFHGfiQ6NQKvQchXF70=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-rhH742HkODSlV9DiU21E8w-1; Sun, 30 Jan 2022 16:32:26 -0500
X-MC-Unique: rhH742HkODSlV9DiU21E8w-1
Received: by mail-wm1-f69.google.com with SMTP id n22-20020a05600c3b9600b00352d3f6a850so442112wms.3
        for <live-patching@vger.kernel.org>; Sun, 30 Jan 2022 13:32:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+8jA7bYfQPshsiLx0pkdrriw91RK3YxQWB2UbWGtHA0=;
        b=F/CVQik4b3yjBDlqjiQxF4Lke+zwmTCsW/pPza+p+BB89hHgq4v2NgU5xnSnMyHMja
         CSqxx7omT8QRWvjHwBSmLScPKOWOZm8TReICZEkEHYy53Nk2MUw9Dqqlw2a2+NBnZetn
         vT5+0Nks0RAtozfKJI8KBY7+mAcB3XEFlJ+BXHEBt3DXeoZ+G1Y6r3TMmke646D6nAMf
         cYwgsVk1PETsVHcTr2jGFIsD38eKfuRw8XetEuA1Joah7VXsTSGDsHKQDMFZ4TzuhxNK
         j1fvN4ic7UNsVD6ebGuZps/kJzCi8v5x8fM2hhVC+YRtVWlwMdaBH7eDYFbAt9rLsPgS
         CTtg==
X-Gm-Message-State: AOAM532IjEGWeSnL2S2yHgwZth0RrhYk1++nPY0VS2GMzp31UmUp0RHr
        P/N2pJ97NYeI0mezWz3LvVfqDu53op/nnhfZ8/sVF/zHXZakf2lwGhftdw42VtOjsgCfnZNtbjC
        5tdmuh0kkyi6Kb3VlwzipIY5S
X-Received: by 2002:a5d:550f:: with SMTP id b15mr5171584wrv.384.1643578344977;
        Sun, 30 Jan 2022 13:32:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyXgF4BvmYNdjyg50g9s9aIyE5u7AofJTtbWr5KA0J7EOgC8xa162nZ0tT185NM2i6SpoEnLg==
X-Received: by 2002:a5d:550f:: with SMTP id b15mr5171573wrv.384.1643578344807;
        Sun, 30 Jan 2022 13:32:24 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id n13sm10203712wrm.68.2022.01.30.13.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 13:32:24 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com
Subject: [RFC PATCH v4 06/13] module: Move strict rwx support to a separate file
Date:   Sun, 30 Jan 2022 21:32:07 +0000
Message-Id: <20220130213214.1042497-7-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220130213214.1042497-1-atomlin@redhat.com>
References: <20220130213214.1042497-1-atomlin@redhat.com>
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
index 8b75380bc340..520c0f4bb968 100644
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
 /* Only touch one cacheline for common rbtree-for-core-layout case. */
 #define __module_layout_align ____cacheline_aligned
diff --git a/kernel/module/Makefile b/kernel/module/Makefile
index 146509978708..d1dada641ad6 100644
--- a/kernel/module/Makefile
+++ b/kernel/module/Makefile
@@ -11,4 +11,5 @@ ifdef CONFIG_MODULES
 obj-$(CONFIG_LIVEPATCH) += livepatch.o
 obj-$(CONFIG_MODULES_TREE_LOOKUP) += tree_lookup.o
 obj-$(CONFIG_ARCH_HAS_STRICT_MODULE_RWX) += arch_strict_rwx.o
+obj-$(CONFIG_STRICT_MODULE_RWX) += strict_rwx.o
 endif
diff --git a/kernel/module/main.c b/kernel/module/main.c
index 7e98ea12b146..1a0e659a27bc 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1782,90 +1782,6 @@ static void mod_sysfs_teardown(struct module *mod)
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

