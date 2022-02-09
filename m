Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587744AF793
	for <lists+live-patching@lfdr.de>; Wed,  9 Feb 2022 18:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237618AbiBIREO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 9 Feb 2022 12:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237831AbiBIREM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 9 Feb 2022 12:04:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19E4FC05CB92
        for <live-patching@vger.kernel.org>; Wed,  9 Feb 2022 09:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644426251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qjQ2eX+DE08u8nDE36xb1CAtGQ1RKJjpQysC4eJJ9lM=;
        b=V9nzoBfssyXKXGuB8BrpvJzQbEsfsep5HoEy87Wp6l759zLxl3W/EO056EtZYMLD0pEWCT
        UIFOmIV7bZ090lws0uGW2AKOoUvp1gQXv2FxHwjxcmjElGvy4mF59H50+KIWOmSiEWaU3Z
        sLv+83Syhz9iAgByd84GLnR9qrSkNKk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-IA-QCqg5O_KIE5w5FifjGg-1; Wed, 09 Feb 2022 12:04:10 -0500
X-MC-Unique: IA-QCqg5O_KIE5w5FifjGg-1
Received: by mail-wr1-f71.google.com with SMTP id b8-20020adfc748000000b001e333edbe40so1346375wrh.6
        for <live-patching@vger.kernel.org>; Wed, 09 Feb 2022 09:04:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qjQ2eX+DE08u8nDE36xb1CAtGQ1RKJjpQysC4eJJ9lM=;
        b=w1G3Z5sh9CdEcD4f+cVWTLl3NOz3JHOH5tR4K14GbQiKhT/RPaxkoMOU+vCi1/+mbe
         PFN/q2x7OfBZyHlTzaZoVhb/50ZK4W+9rCL3Ay0P+2OvLTwY9BJP2ZQmY53pgbPIQ4VN
         MNnJc2Y6Gy5dCPIuSE5ViVob3x4N04LrrAJ4qsufGQMyKWzG7c8cLvbrbu6QgzbU3aiZ
         KhP2OhYxoFwjn5Loqh2QfXxvuzTi6Bqvmxg64Ljtj9ITNTqEmfPG/3euRZCRKSn9mosk
         KZnqmUBPeY02fccFVdyOc5od9d2gsVzQKdsd2tZ8eHp/L0gvqHqb8U3NnLNBd/pBuWaa
         IBvg==
X-Gm-Message-State: AOAM533WRi2QDq4uoZ1s5UqD7p6iFybbVRfdsD6lokBXjqjJu40AJIJ4
        yb1ya4BJ2BR41wUy6waiZAC75XY9Z4FfHr1uYv4wtgQOTl9TR3gOlKTuBQ1H/e8bu58H+8RkWHo
        8KuWdp7/gS2mh3Awx7u5MFuuW
X-Received: by 2002:adf:dd50:: with SMTP id u16mr2895346wrm.696.1644426248085;
        Wed, 09 Feb 2022 09:04:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzq+KCNXp3aAVqWNZ01eMCb1ujhJ35xEN2jvsyrI9Io9s7zz2to1Nlm8nnD3TbWQQLbEAoAoA==
X-Received: by 2002:adf:dd50:: with SMTP id u16mr2895318wrm.696.1644426247884;
        Wed, 09 Feb 2022 09:04:07 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id p7sm5304488wmq.20.2022.02.09.09.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 09:04:07 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com, christophe.leroy@csgroup.eu, msuchanek@suse.de,
        oleksandr@natalenko.name
Subject: [PATCH v5 06/13] module: Move strict rwx support to a separate file
Date:   Wed,  9 Feb 2022 17:03:51 +0000
Message-Id: <20220209170358.3266629-7-atomlin@redhat.com>
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

This patch migrates code that makes module text
and rodata memory read-only and non-text memory
non-executable from core module code into
kernel/module/strict_rwx.c.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
---
 kernel/module/Makefile     |  1 +
 kernel/module/internal.h   | 38 +++++++++++++++
 kernel/module/main.c       | 97 +-------------------------------------
 kernel/module/strict_rwx.c | 84 +++++++++++++++++++++++++++++++++
 4 files changed, 124 insertions(+), 96 deletions(-)
 create mode 100644 kernel/module/strict_rwx.c

diff --git a/kernel/module/Makefile b/kernel/module/Makefile
index fc6d7a053a62..8f2857d9ba1e 100644
--- a/kernel/module/Makefile
+++ b/kernel/module/Makefile
@@ -10,4 +10,5 @@ obj-$(CONFIG_MODULE_SIG_FORMAT) += signature.o
 ifdef CONFIG_MODULES
 obj-$(CONFIG_LIVEPATCH) += livepatch.o
 obj-$(CONFIG_MODULES_TREE_LOOKUP) += tree_lookup.o
+obj-$(CONFIG_STRICT_MODULE_RWX) += strict_rwx.o
 endif
diff --git a/kernel/module/internal.h b/kernel/module/internal.h
index 08b6be037b72..99204447ce86 100644
--- a/kernel/module/internal.h
+++ b/kernel/module/internal.h
@@ -21,6 +21,17 @@
 #define MODULE_FLAGS_BUF_SIZE (TAINT_FLAGS_COUNT + 4)
 #define MODULE_SECT_READ_SIZE (3 /* "0x", "\n" */ + (BITS_PER_LONG / 4))
 
+/*
+ * Modules' sections will be aligned on page boundaries
+ * to ensure complete separation of code and data, but
+ * only when CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
+ */
+#ifdef CONFIG_ARCH_HAS_STRICT_MODULE_RWX
+# define debug_align(X) ALIGN(X, PAGE_SIZE)
+#else
+# define debug_align(X) (X)
+#endif
+
 extern struct mutex module_mutex;
 extern struct list_head modules;
 
@@ -124,3 +135,30 @@ static struct module *mod_find(unsigned long addr)
 	return NULL;
 }
 #endif /* CONFIG_MODULES_TREE_LOOKUP */
+
+#ifdef CONFIG_ARCH_HAS_STRICT_MODULE_RWX
+void frob_text(const struct module_layout *layout, int (*set_memory)(unsigned long start,
+	       int num_pages));
+#endif /* CONFIG_ARCH_HAS_STRICT_MODULE_RWX */
+
+#ifdef CONFIG_STRICT_MODULE_RWX
+void frob_rodata(const struct module_layout *layout,
+			int (*set_memory)(unsigned long start, int num_pages));
+void frob_ro_after_init(const struct module_layout *layout,
+			       int (*set_memory)(unsigned long start, int num_pages));
+void frob_writable_data(const struct module_layout *layout,
+			       int (*set_memory)(unsigned long start, int num_pages));
+void module_enable_ro(const struct module *mod, bool after_init);
+void module_enable_nx(const struct module *mod);
+int module_enforce_rwx_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
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
diff --git a/kernel/module/main.c b/kernel/module/main.c
index f733a719c65d..abdedc15f4f1 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -63,17 +63,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
 
-/*
- * Modules' sections will be aligned on page boundaries
- * to ensure complete separation of code and data, but
- * only when CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
- */
-#ifdef CONFIG_ARCH_HAS_STRICT_MODULE_RWX
-# define debug_align(X) ALIGN(X, PAGE_SIZE)
-#else
-# define debug_align(X) (X)
-#endif
-
 /*
  * Mutex protects:
  * 1) List of modules (also safely readable with preempt_disable),
@@ -1815,7 +1804,7 @@ static void mod_sysfs_teardown(struct module *mod)
  * whether we are strict.
  */
 #ifdef CONFIG_ARCH_HAS_STRICT_MODULE_RWX
-static void frob_text(const struct module_layout *layout,
+void frob_text(const struct module_layout *layout,
 		      int (*set_memory)(unsigned long start, int num_pages))
 {
 	BUG_ON((unsigned long)layout->base & (PAGE_SIZE-1));
@@ -1833,90 +1822,6 @@ static void module_enable_x(const struct module *mod)
 static void module_enable_x(const struct module *mod) { }
 #endif /* CONFIG_ARCH_HAS_STRICT_MODULE_RWX */
 
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
index 000000000000..1933272056c7
--- /dev/null
+++ b/kernel/module/strict_rwx.c
@@ -0,0 +1,84 @@
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
+#include "internal.h"
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

