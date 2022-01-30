Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92BB4A3A83
	for <lists+live-patching@lfdr.de>; Sun, 30 Jan 2022 22:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356482AbiA3Vdg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 30 Jan 2022 16:33:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29152 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356614AbiA3Vcd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 30 Jan 2022 16:32:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643578353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=al/jYJxi8UyrW4mEBmLd1lyNjLUXPonhqIBGpMy93Lw=;
        b=ZHgSOhdfic7wHsAQ2xR+1KSFavYbZV6igYvbZYdjn0p5mo7AVdQ+fC9N1Xl3BGhz3/CP9k
        pnssGgvZT1a1M8qYyDzzNfVA7tbK9XTe2pZhruZbY8YdjUmLDF0J1drsryhw1ftxSlAnc1
        PsF7hD3xmuCjzwhJAy+fMx6C8qzuavk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644--DOFDcY0Oq6Kx8ynbHNs0w-1; Sun, 30 Jan 2022 16:32:31 -0500
X-MC-Unique: -DOFDcY0Oq6Kx8ynbHNs0w-1
Received: by mail-wm1-f69.google.com with SMTP id t2-20020a7bc3c2000000b003528fe59cb9so1537020wmj.5
        for <live-patching@vger.kernel.org>; Sun, 30 Jan 2022 13:32:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=al/jYJxi8UyrW4mEBmLd1lyNjLUXPonhqIBGpMy93Lw=;
        b=a7LfKXyGLv0LYQnW4Gexbf9IGm/K26rvmhedd+YX+4vVQEDHsn5P9bNig8Lmt40JwT
         gpYIBDU7W/tUHbm9UKGzyZnU5OVx3BALrXqdxAAN6xn8uSzgv5bVo0m2/0G+mTARbmX9
         W/KUQY+paavCJ2olNylAX1uJAMU4/J76f14owR2TckHiMFhRBVfOdE8x0wd9ZbyYtdXI
         2FU9F8DwJQec2fEqdMUS2fli/b4v1pM4NW2qbD4ZLRoxwAleGzCnezmgCHXe+Zetqw6P
         PMO8X6AcW2sGzQGrtBV6D5KOJbRcbPmhOMvflrKHi7O1bN2u9At4Qr2hSmYC7shQZDtw
         O9Fw==
X-Gm-Message-State: AOAM5312U4pdMDjkkKOx6lPay5ESfoG2uikAGljl5WwICH8SNg87zACv
        XpOlkU1jeTULSmse8+pHYIBSuMvJ2vY/SBY+P0NhnkAybeQqOJKIoMdT9Gwa4/k+bDjAvbWqyT9
        ok3W2a/vT3womO6YKX+D3bdhQ
X-Received: by 2002:a5d:4f08:: with SMTP id c8mr15236681wru.710.1643578350369;
        Sun, 30 Jan 2022 13:32:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwU0FmzRtmHVNoE9ddKC8OpTlksQWrPP2QV0qL/lMtoozpTHWYbo2UIdJxcVd9J5gyWDMSz8w==
X-Received: by 2002:a5d:4f08:: with SMTP id c8mr15236666wru.710.1643578350053;
        Sun, 30 Jan 2022 13:32:30 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id 5sm11630584wrb.113.2022.01.30.13.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 13:32:29 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com
Subject: [RFC PATCH v4 10/13] module: Move procfs support into a separate file
Date:   Sun, 30 Jan 2022 21:32:11 +0000
Message-Id: <20220130213214.1042497-11-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220130213214.1042497-1-atomlin@redhat.com>
References: <20220130213214.1042497-1-atomlin@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

No functional change.

This patch migrates code that allows one to generate a
list of loaded/or linked modules via /proc when procfs
support is enabled into kernel/module/procfs.c.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
---
 kernel/module/Makefile   |   1 +
 kernel/module/internal.h |   1 +
 kernel/module/main.c     | 131 +-----------------------------------
 kernel/module/procfs.c   | 142 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 145 insertions(+), 130 deletions(-)
 create mode 100644 kernel/module/procfs.c

diff --git a/kernel/module/Makefile b/kernel/module/Makefile
index 906f83e1931b..812f11ad090e 100644
--- a/kernel/module/Makefile
+++ b/kernel/module/Makefile
@@ -14,4 +14,5 @@ obj-$(CONFIG_ARCH_HAS_STRICT_MODULE_RWX) += arch_strict_rwx.o
 obj-$(CONFIG_STRICT_MODULE_RWX) += strict_rwx.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += debug_kmemleak.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
+obj-$(CONFIG_PROC_FS) += procfs.o
 endif
diff --git a/kernel/module/internal.h b/kernel/module/internal.h
index 866fce7c1a33..09484a9382bc 100644
--- a/kernel/module/internal.h
+++ b/kernel/module/internal.h
@@ -62,6 +62,7 @@ extern unsigned long kernel_symbol_value(const struct kernel_symbol *sym);
 extern int cmp_name(const void *name, const void *sym);
 extern long get_offset(struct module *mod, unsigned int *size, Elf_Shdr *sechdr,
 		       unsigned int section);
+extern char *module_flags(struct module *mod, char *buf);
 
 #ifdef CONFIG_LIVEPATCH
 extern int copy_module_elf(struct module *mod, struct load_info *info);
diff --git a/kernel/module/main.c b/kernel/module/main.c
index 363a54298f7e..1c20393ab76d 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -21,7 +21,6 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/elf.h>
-#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/syscalls.h>
 #include <linux/fcntl.h>
@@ -810,31 +809,6 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 	return ret;
 }
 
-static inline void print_unload_info(struct seq_file *m, struct module *mod)
-{
-	struct module_use *use;
-	int printed_something = 0;
-
-	seq_printf(m, " %i ", module_refcount(mod));
-
-	/*
-	 * Always include a trailing , so userspace can differentiate
-	 * between this and the old multi-field proc format.
-	 */
-	list_for_each_entry(use, &mod->source_list, source_list) {
-		printed_something = 1;
-		seq_printf(m, "%s,", use->source->name);
-	}
-
-	if (mod->init != NULL && mod->exit == NULL) {
-		printed_something = 1;
-		seq_puts(m, "[permanent],");
-	}
-
-	if (!printed_something)
-		seq_puts(m, "-");
-}
-
 void __symbol_put(const char *symbol)
 {
 	struct find_symbol_arg fsa = {
@@ -924,12 +898,6 @@ void module_put(struct module *module)
 EXPORT_SYMBOL(module_put);
 
 #else /* !CONFIG_MODULE_UNLOAD */
-static inline void print_unload_info(struct seq_file *m, struct module *mod)
-{
-	/* We don't know the usage count, or what modules are using. */
-	seq_puts(m, " - -");
-}
-
 static inline void module_unload_free(struct module *mod)
 {
 }
@@ -3576,7 +3544,7 @@ static void cfi_cleanup(struct module *mod)
 }
 
 /* Keep in sync with MODULE_FLAGS_BUF_SIZE !!! */
-static char *module_flags(struct module *mod, char *buf)
+char *module_flags(struct module *mod, char *buf)
 {
 	int bx = 0;
 
@@ -3599,103 +3567,6 @@ static char *module_flags(struct module *mod, char *buf)
 	return buf;
 }
 
-#ifdef CONFIG_PROC_FS
-/* Called by the /proc file system to return a list of modules. */
-static void *m_start(struct seq_file *m, loff_t *pos)
-{
-	mutex_lock(&module_mutex);
-	return seq_list_start(&modules, *pos);
-}
-
-static void *m_next(struct seq_file *m, void *p, loff_t *pos)
-{
-	return seq_list_next(p, &modules, pos);
-}
-
-static void m_stop(struct seq_file *m, void *p)
-{
-	mutex_unlock(&module_mutex);
-}
-
-static int m_show(struct seq_file *m, void *p)
-{
-	struct module *mod = list_entry(p, struct module, list);
-	char buf[MODULE_FLAGS_BUF_SIZE];
-	void *value;
-
-	/* We always ignore unformed modules. */
-	if (mod->state == MODULE_STATE_UNFORMED)
-		return 0;
-
-	seq_printf(m, "%s %u",
-		   mod->name, mod->init_layout.size + mod->core_layout.size);
-	print_unload_info(m, mod);
-
-	/* Informative for users. */
-	seq_printf(m, " %s",
-		   mod->state == MODULE_STATE_GOING ? "Unloading" :
-		   mod->state == MODULE_STATE_COMING ? "Loading" :
-		   "Live");
-	/* Used by oprofile and other similar tools. */
-	value = m->private ? NULL : mod->core_layout.base;
-	seq_printf(m, " 0x%px", value);
-
-	/* Taints info */
-	if (mod->taints)
-		seq_printf(m, " %s", module_flags(mod, buf));
-
-	seq_puts(m, "\n");
-	return 0;
-}
-
-/*
- * Format: modulename size refcount deps address
- *
- * Where refcount is a number or -, and deps is a comma-separated list
- * of depends or -.
- */
-static const struct seq_operations modules_op = {
-	.start	= m_start,
-	.next	= m_next,
-	.stop	= m_stop,
-	.show	= m_show
-};
-
-/*
- * This also sets the "private" pointer to non-NULL if the
- * kernel pointers should be hidden (so you can just test
- * "m->private" to see if you should keep the values private).
- *
- * We use the same logic as for /proc/kallsyms.
- */
-static int modules_open(struct inode *inode, struct file *file)
-{
-	int err = seq_open(file, &modules_op);
-
-	if (!err) {
-		struct seq_file *m = file->private_data;
-		m->private = kallsyms_show_value(file->f_cred) ? NULL : (void *)8ul;
-	}
-
-	return err;
-}
-
-static const struct proc_ops modules_proc_ops = {
-	.proc_flags	= PROC_ENTRY_PERMANENT,
-	.proc_open	= modules_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= seq_release,
-};
-
-static int __init proc_modules_init(void)
-{
-	proc_create("modules", 0, NULL, &modules_proc_ops);
-	return 0;
-}
-module_init(proc_modules_init);
-#endif
-
 /* Given an address, look for it in the module exception tables. */
 const struct exception_table_entry *search_module_extables(unsigned long addr)
 {
diff --git a/kernel/module/procfs.c b/kernel/module/procfs.c
new file mode 100644
index 000000000000..d706a798b52e
--- /dev/null
+++ b/kernel/module/procfs.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Module proc support
+ *
+ * Copyright (C) 2008 Alexey Dobriyan
+ */
+
+#include <linux/module.h>
+#include <linux/kallsyms.h>
+#include <linux/mutex.h>
+#include <linux/seq_file.h>
+#include <linux/proc_fs.h>
+#include "internal.h"
+
+#ifdef CONFIG_MODULE_UNLOAD
+static inline void print_unload_info(struct seq_file *m, struct module *mod)
+{
+	struct module_use *use;
+	int printed_something = 0;
+
+	seq_printf(m, " %i ", module_refcount(mod));
+
+	/*
+	 * Always include a trailing , so userspace can differentiate
+	 * between this and the old multi-field proc format.
+	 */
+	list_for_each_entry(use, &mod->source_list, source_list) {
+		printed_something = 1;
+		seq_printf(m, "%s,", use->source->name);
+	}
+
+	if (mod->init != NULL && mod->exit == NULL) {
+		printed_something = 1;
+		seq_puts(m, "[permanent],");
+	}
+
+	if (!printed_something)
+		seq_puts(m, "-");
+}
+#else /* !CONFIG_MODULE_UNLOAD */
+static inline void print_unload_info(struct seq_file *m, struct module *mod)
+{
+	/* We don't know the usage count, or what modules are using. */
+	seq_puts(m, " - -");
+}
+#endif /* CONFIG_MODULE_UNLOAD */
+
+/* Called by the /proc file system to return a list of modules. */
+static void *m_start(struct seq_file *m, loff_t *pos)
+{
+	mutex_lock(&module_mutex);
+	return seq_list_start(&modules, *pos);
+}
+
+static void *m_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	return seq_list_next(p, &modules, pos);
+}
+
+static void m_stop(struct seq_file *m, void *p)
+{
+	mutex_unlock(&module_mutex);
+}
+
+static int m_show(struct seq_file *m, void *p)
+{
+	struct module *mod = list_entry(p, struct module, list);
+	char buf[MODULE_FLAGS_BUF_SIZE];
+	void *value;
+
+	/* We always ignore unformed modules. */
+	if (mod->state == MODULE_STATE_UNFORMED)
+		return 0;
+
+	seq_printf(m, "%s %u",
+		   mod->name, mod->init_layout.size + mod->core_layout.size);
+	print_unload_info(m, mod);
+
+	/* Informative for users. */
+	seq_printf(m, " %s",
+		   mod->state == MODULE_STATE_GOING ? "Unloading" :
+		   mod->state == MODULE_STATE_COMING ? "Loading" :
+		   "Live");
+	/* Used by oprofile and other similar tools. */
+	value = m->private ? NULL : mod->core_layout.base;
+	seq_printf(m, " 0x%px", value);
+
+	/* Taints info */
+	if (mod->taints)
+		seq_printf(m, " %s", module_flags(mod, buf));
+
+	seq_puts(m, "\n");
+	return 0;
+}
+
+/*
+ * Format: modulename size refcount deps address
+ *
+ * Where refcount is a number or -, and deps is a comma-separated list
+ * of depends or -.
+ */
+static const struct seq_operations modules_op = {
+	.start	= m_start,
+	.next	= m_next,
+	.stop	= m_stop,
+	.show	= m_show
+};
+
+/*
+ * This also sets the "private" pointer to non-NULL if the
+ * kernel pointers should be hidden (so you can just test
+ * "m->private" to see if you should keep the values private).
+ *
+ * We use the same logic as for /proc/kallsyms.
+ */
+static int modules_open(struct inode *inode, struct file *file)
+{
+	int err = seq_open(file, &modules_op);
+
+	if (!err) {
+		struct seq_file *m = file->private_data;
+
+		m->private = kallsyms_show_value(file->f_cred) ? NULL : (void *)8ul;
+	}
+
+	return err;
+}
+
+static const struct proc_ops modules_proc_ops = {
+	.proc_flags	= PROC_ENTRY_PERMANENT,
+	.proc_open	= modules_open,
+	.proc_read	= seq_read,
+	.proc_lseek	= seq_lseek,
+	.proc_release	= seq_release,
+};
+
+static int __init proc_modules_init(void)
+{
+	proc_create("modules", 0, NULL, &modules_proc_ops);
+	return 0;
+}
+module_init(proc_modules_init);
-- 
2.34.1

