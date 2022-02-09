Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7D54AF7CC
	for <lists+live-patching@lfdr.de>; Wed,  9 Feb 2022 18:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbiBIRIU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 9 Feb 2022 12:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237605AbiBIRIU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 9 Feb 2022 12:08:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC7F9C05CB82
        for <live-patching@vger.kernel.org>; Wed,  9 Feb 2022 09:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644426502;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7x5zYig7PVcv0wtCDoN3cLooQwpWC51uI2dgVOT1jmc=;
        b=Y2IMmKIXo+LKjavq5h+XScwGcqGtFc3rpwbIIRgKnFPEtaeKcEagbcylBE0SgaQAZDNlkW
        GdtEcGrNl8CrHFRwZX+JKGtiR8mMopZToqpluDhEveIf+0X+kswovFQg8cwwc8VV34IYbd
        EUQr0nrbqIQsPGmIY/VrDIj3B/JI/a0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-sOK9dupsMzSLZplzxLyGjw-1; Wed, 09 Feb 2022 12:08:20 -0500
X-MC-Unique: sOK9dupsMzSLZplzxLyGjw-1
Received: by mail-wm1-f69.google.com with SMTP id l4-20020a05600c4f0400b0037bb2ce79d8so2943180wmq.9
        for <live-patching@vger.kernel.org>; Wed, 09 Feb 2022 09:08:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=7x5zYig7PVcv0wtCDoN3cLooQwpWC51uI2dgVOT1jmc=;
        b=ZjUO6VBGDVUBLPQF4KkUNcUyCHOBKfuFiCByJ1RUhChf1PCW+rWpQSEPoyihf1DzUt
         g6iriImTkDF1RtMvj/lsm1u/mmDb7uCGwVpGXcKIt+WIyQc7kulGDgBdUFH1MbqubEOn
         3RIJcPnPdk6AsdIMdix/Bx7dPTzgJ7tCRoDl2hApfKXGRc4WVwfaZNJlaK3g0tEPDP8T
         Ktf/taFpl9TTgJo14Xin0xGXigpd8JMyrBTwqpTtRuuSEo4nJ9sqD+mN/TXuGZV+GbAr
         EjyXkUFK4YLjUOoCv1wFR2lnNPnPdCYf+Cn0QLMTg1IG91EspRk0Eub4shyXkokL/DGO
         Wc0Q==
X-Gm-Message-State: AOAM533FG4MG/gF2jvKlTubEI9cMnl9nfRdLfLSl42uuW4NvJt0j25eV
        oUS6Afcv8xBVeNvV3ekkqTmYNwJKPmaWQ76CnW28AD0jTJSuaAwM39FSkwtGS2dcE5YcpRaRNxT
        bM0KTlLPF4WvTc2E1H6iaAMa+
X-Received: by 2002:a05:600c:301:: with SMTP id q1mr2861030wmd.129.1644426499225;
        Wed, 09 Feb 2022 09:08:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwV7GXeeSC/liqjsp2wkFZ6klpsI3nml2FQxFGkLUgATVaqMLB9YpdZCXFp9IbdrclFocpJvg==
X-Received: by 2002:a05:600c:301:: with SMTP id q1mr2861001wmd.129.1644426498878;
        Wed, 09 Feb 2022 09:08:18 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id b16sm6168930wrj.26.2022.02.09.09.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 09:08:18 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com, christophe.leroy@csgroup.eu, msuchanek@suse.de,
        oleksandr@natalenko.name
Subject: [PATCH v5 10/13] module: Move procfs support into a separate file
Date:   Wed,  9 Feb 2022 17:08:11 +0000
Message-Id: <20220209170814.3268487-4-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209170814.3268487-1-atomlin@redhat.com>
References: <20220209170814.3268487-1-atomlin@redhat.com>
Reply-To: 20220209170358.3266629-1-atomlin@redhat.com
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
index 868b13c06920..c6be08060252 100644
--- a/kernel/module/Makefile
+++ b/kernel/module/Makefile
@@ -13,4 +13,5 @@ obj-$(CONFIG_MODULES_TREE_LOOKUP) += tree_lookup.o
 obj-$(CONFIG_STRICT_MODULE_RWX) += strict_rwx.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += debug_kmemleak.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
+obj-$(CONFIG_PROC_FS) += procfs.o
 endif
diff --git a/kernel/module/internal.h b/kernel/module/internal.h
index 7973666452c3..b67ce836746a 100644
--- a/kernel/module/internal.h
+++ b/kernel/module/internal.h
@@ -74,6 +74,7 @@ unsigned long kernel_symbol_value(const struct kernel_symbol *sym);
 int cmp_name(const void *name, const void *sym);
 long get_offset(struct module *mod, unsigned int *size, Elf_Shdr *sechdr,
 		       unsigned int section);
+char *module_flags(struct module *mod, char *buf);
 
 #ifdef CONFIG_LIVEPATCH
 int copy_module_elf(struct module *mod, struct load_info *info);
diff --git a/kernel/module/main.c b/kernel/module/main.c
index 378dd7fd1b6a..ff39c556bdf8 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -22,7 +22,6 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/elf.h>
-#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/syscalls.h>
 #include <linux/fcntl.h>
@@ -811,31 +810,6 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
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
@@ -925,12 +899,6 @@ void module_put(struct module *module)
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
@@ -3601,7 +3569,7 @@ static void cfi_cleanup(struct module *mod)
 }
 
 /* Keep in sync with MODULE_FLAGS_BUF_SIZE !!! */
-static char *module_flags(struct module *mod, char *buf)
+char *module_flags(struct module *mod, char *buf)
 {
 	int bx = 0;
 
@@ -3624,103 +3592,6 @@ static char *module_flags(struct module *mod, char *buf)
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

