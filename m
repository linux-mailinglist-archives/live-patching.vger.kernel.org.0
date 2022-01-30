Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB90C4A3A73
	for <lists+live-patching@lfdr.de>; Sun, 30 Jan 2022 22:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356510AbiA3Vcm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 30 Jan 2022 16:32:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31861 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356533AbiA3VcZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 30 Jan 2022 16:32:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643578345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hyabKM8+59CUwT2B0d7qLIZay/RH+beAzDXJmHYL03U=;
        b=cTNUC0k2uNB2QpVB0SJ6z21f88GmRyl2RdpTDFtBfb6QNmeuzRJB2lzeni0TwJiqPeZfhZ
        vE+OZw0WZaCewNZ63DvwMNV/7Vk+KWAxDOR0pkIEF/BLq61mBF8Ro8V3Z/QRSPgCz6TbpF
        C1qBWpfbvRGfk40Y6bX6Ms54AIKoyT0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-436-_kNwdh51Me2AlDuTv9RN4w-1; Sun, 30 Jan 2022 16:32:23 -0500
X-MC-Unique: _kNwdh51Me2AlDuTv9RN4w-1
Received: by mail-wm1-f70.google.com with SMTP id q71-20020a1ca74a000000b003507f38e330so9286037wme.9
        for <live-patching@vger.kernel.org>; Sun, 30 Jan 2022 13:32:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hyabKM8+59CUwT2B0d7qLIZay/RH+beAzDXJmHYL03U=;
        b=LQYYMTcyoNT67EdCFVQrONaXzkAnuP7v5la6MUMWnkbXKtuh2yeUG4FzT4P+trsky2
         xbcCr7u7s79H1z+T92w7Wf5t37/ZhJJ3346eIYM86Xoj3fIYRQQCUegLgAmnqRwFHnIP
         T/LmmsMBdwEloETROpVIgsvBAbTA350y8oWvf2YgyvYmRRm2sNknWxc/+EJXHMOlOjAR
         ytjBfoMqCbb3EGWqPyCZbwp8TgwOtxMqOUIIvVCF9uw2Y+txbe23dj04j6OQO29/zo1X
         hvlAKmZU6SzSgLarvtPPjkqMj8/hqeKfaZdhueoRh46Eqx283T8EkR9tijaiYTxZU79G
         EYwA==
X-Gm-Message-State: AOAM530K+PmZjDy1iAY3FMEzW+Ax4QI9BEdpQ9YOalY/4ttLfzPpqJxL
        fK3rXcIcMrGn0IsabY2sMxGL9e0seiGwf4IXeqVaFW1yCyUCENfZEbIwlOPBYaQjync3V7UILvE
        49OmT+Fs1G9nqb4eU0Eh2tocc
X-Received: by 2002:a5d:6a8d:: with SMTP id s13mr14618943wru.280.1643578342408;
        Sun, 30 Jan 2022 13:32:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy9iOV5OMv/gnyHQLbIxe8/bgndYMZGYUBXI+D8eIusi6O3MhgTP7iKtz7IbLdk3wGD6R+fug==
X-Received: by 2002:a5d:6a8d:: with SMTP id s13mr14618933wru.280.1643578342171;
        Sun, 30 Jan 2022 13:32:22 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id v5sm11998503wrx.114.2022.01.30.13.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 13:32:21 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com
Subject: [RFC PATCH v4 04/13] module: Move latched RB-tree support to a separate file
Date:   Sun, 30 Jan 2022 21:32:05 +0000
Message-Id: <20220130213214.1042497-5-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220130213214.1042497-1-atomlin@redhat.com>
References: <20220130213214.1042497-1-atomlin@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

No functional change.

This patch migrates module latched RB-tree support
(e.g. see __module_address()) from core module code
into kernel/module/tree_lookup.c.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
---
 include/linux/module.h      |   4 +-
 kernel/module/Makefile      |   1 +
 kernel/module/internal.h    |  33 +++++++++
 kernel/module/main.c        | 129 +-----------------------------------
 kernel/module/tree_lookup.c | 109 ++++++++++++++++++++++++++++++
 5 files changed, 147 insertions(+), 129 deletions(-)
 create mode 100644 kernel/module/tree_lookup.c

diff --git a/include/linux/module.h b/include/linux/module.h
index c7daac4d16ee..faeb7ae49b89 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -342,9 +342,9 @@ struct module_layout {
 #ifdef CONFIG_MODULES_TREE_LOOKUP
 /* Only touch one cacheline for common rbtree-for-core-layout case. */
 #define __module_layout_align ____cacheline_aligned
-#else
+#else /* !CONFIG_MODULES_TREE_LOOKUP */
 #define __module_layout_align
-#endif
+#endif /* CONFIG_MODULES_TREE_LOOKUP */
 
 struct mod_kallsyms {
 	Elf_Sym *symtab;
diff --git a/kernel/module/Makefile b/kernel/module/Makefile
index ee20d864ad19..fc6d7a053a62 100644
--- a/kernel/module/Makefile
+++ b/kernel/module/Makefile
@@ -9,4 +9,5 @@ obj-$(CONFIG_MODULE_SIG) += signing.o
 obj-$(CONFIG_MODULE_SIG_FORMAT) += signature.o
 ifdef CONFIG_MODULES
 obj-$(CONFIG_LIVEPATCH) += livepatch.o
+obj-$(CONFIG_MODULES_TREE_LOOKUP) += tree_lookup.o
 endif
diff --git a/kernel/module/internal.h b/kernel/module/internal.h
index 6150ec5ae042..de28d6bb7b5b 100644
--- a/kernel/module/internal.h
+++ b/kernel/module/internal.h
@@ -81,3 +81,36 @@ static inline void module_decompress_cleanup(struct load_info *info)
 {
 }
 #endif
+
+#ifdef CONFIG_MODULES_TREE_LOOKUP
+struct mod_tree_root {
+	struct latch_tree_root root;
+	unsigned long addr_min;
+	unsigned long addr_max;
+};
+
+extern struct mod_tree_root mod_tree;
+
+extern void mod_tree_insert(struct module *mod);
+extern void mod_tree_remove_init(struct module *mod);
+extern void mod_tree_remove(struct module *mod);
+extern struct module *mod_find(unsigned long addr);
+#else /* !CONFIG_MODULES_TREE_LOOKUP */
+static unsigned long module_addr_min = -1UL, module_addr_max = 0;
+
+static void mod_tree_insert(struct module *mod) { }
+static void mod_tree_remove_init(struct module *mod) { }
+static void mod_tree_remove(struct module *mod) { }
+static struct module *mod_find(unsigned long addr)
+{
+	struct module *mod;
+
+	list_for_each_entry_rcu(mod, &modules, list,
+				lockdep_is_held(&module_mutex)) {
+		if (within_module(addr, mod))
+			return mod;
+	}
+
+	return NULL;
+}
+#endif /* CONFIG_MODULES_TREE_LOOKUP */
diff --git a/kernel/module/main.c b/kernel/module/main.c
index c91c7e57bca7..941be7788626 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -90,138 +90,13 @@ static DECLARE_WORK(init_free_wq, do_free_init);
 static LLIST_HEAD(init_free_list);
 
 #ifdef CONFIG_MODULES_TREE_LOOKUP
-
-/*
- * Use a latched RB-tree for __module_address(); this allows us to use
- * RCU-sched lookups of the address from any context.
- *
- * This is conditional on PERF_EVENTS || TRACING because those can really hit
- * __module_address() hard by doing a lot of stack unwinding; potentially from
- * NMI context.
- */
-
-static __always_inline unsigned long __mod_tree_val(struct latch_tree_node *n)
-{
-	struct module_layout *layout = container_of(n, struct module_layout, mtn.node);
-
-	return (unsigned long)layout->base;
-}
-
-static __always_inline unsigned long __mod_tree_size(struct latch_tree_node *n)
-{
-	struct module_layout *layout = container_of(n, struct module_layout, mtn.node);
-
-	return (unsigned long)layout->size;
-}
-
-static __always_inline bool
-mod_tree_less(struct latch_tree_node *a, struct latch_tree_node *b)
-{
-	return __mod_tree_val(a) < __mod_tree_val(b);
-}
-
-static __always_inline int
-mod_tree_comp(void *key, struct latch_tree_node *n)
-{
-	unsigned long val = (unsigned long)key;
-	unsigned long start, end;
-
-	start = __mod_tree_val(n);
-	if (val < start)
-		return -1;
-
-	end = start + __mod_tree_size(n);
-	if (val >= end)
-		return 1;
-
-	return 0;
-}
-
-static const struct latch_tree_ops mod_tree_ops = {
-	.less = mod_tree_less,
-	.comp = mod_tree_comp,
-};
-
-static struct mod_tree_root {
-	struct latch_tree_root root;
-	unsigned long addr_min;
-	unsigned long addr_max;
-} mod_tree __cacheline_aligned = {
+struct mod_tree_root mod_tree __cacheline_aligned = {
 	.addr_min = -1UL,
 };
 
 #define module_addr_min mod_tree.addr_min
 #define module_addr_max mod_tree.addr_max
-
-static noinline void __mod_tree_insert(struct mod_tree_node *node)
-{
-	latch_tree_insert(&node->node, &mod_tree.root, &mod_tree_ops);
-}
-
-static void __mod_tree_remove(struct mod_tree_node *node)
-{
-	latch_tree_erase(&node->node, &mod_tree.root, &mod_tree_ops);
-}
-
-/*
- * These modifications: insert, remove_init and remove; are serialized by the
- * module_mutex.
- */
-static void mod_tree_insert(struct module *mod)
-{
-	mod->core_layout.mtn.mod = mod;
-	mod->init_layout.mtn.mod = mod;
-
-	__mod_tree_insert(&mod->core_layout.mtn);
-	if (mod->init_layout.size)
-		__mod_tree_insert(&mod->init_layout.mtn);
-}
-
-static void mod_tree_remove_init(struct module *mod)
-{
-	if (mod->init_layout.size)
-		__mod_tree_remove(&mod->init_layout.mtn);
-}
-
-static void mod_tree_remove(struct module *mod)
-{
-	__mod_tree_remove(&mod->core_layout.mtn);
-	mod_tree_remove_init(mod);
-}
-
-static struct module *mod_find(unsigned long addr)
-{
-	struct latch_tree_node *ltn;
-
-	ltn = latch_tree_find((void *)addr, &mod_tree.root, &mod_tree_ops);
-	if (!ltn)
-		return NULL;
-
-	return container_of(ltn, struct mod_tree_node, node)->mod;
-}
-
-#else /* MODULES_TREE_LOOKUP */
-
-static unsigned long module_addr_min = -1UL, module_addr_max = 0;
-
-static void mod_tree_insert(struct module *mod) { }
-static void mod_tree_remove_init(struct module *mod) { }
-static void mod_tree_remove(struct module *mod) { }
-
-static struct module *mod_find(unsigned long addr)
-{
-	struct module *mod;
-
-	list_for_each_entry_rcu(mod, &modules, list,
-				lockdep_is_held(&module_mutex)) {
-		if (within_module(addr, mod))
-			return mod;
-	}
-
-	return NULL;
-}
-
-#endif /* MODULES_TREE_LOOKUP */
+#endif
 
 /*
  * Bounds of module text, for speeding up __module_address.
diff --git a/kernel/module/tree_lookup.c b/kernel/module/tree_lookup.c
new file mode 100644
index 000000000000..037d6eb2f56f
--- /dev/null
+++ b/kernel/module/tree_lookup.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Modules tree lookup
+ *
+ * Copyright (C) 2015 Peter Zijlstra
+ * Copyright (C) 2015 Rusty Russell
+ */
+
+#include <linux/module.h>
+#include <linux/rbtree_latch.h>
+#include "internal.h"
+
+/*
+ * Use a latched RB-tree for __module_address(); this allows us to use
+ * RCU-sched lookups of the address from any context.
+ *
+ * This is conditional on PERF_EVENTS || TRACING because those can really hit
+ * __module_address() hard by doing a lot of stack unwinding; potentially from
+ * NMI context.
+ */
+
+__always_inline unsigned long __mod_tree_val(struct latch_tree_node *n)
+{
+	struct module_layout *layout = container_of(n, struct module_layout, mtn.node);
+
+	return (unsigned long)layout->base;
+}
+
+__always_inline unsigned long __mod_tree_size(struct latch_tree_node *n)
+{
+	struct module_layout *layout = container_of(n, struct module_layout, mtn.node);
+
+	return (unsigned long)layout->size;
+}
+
+__always_inline bool
+mod_tree_less(struct latch_tree_node *a, struct latch_tree_node *b)
+{
+	return __mod_tree_val(a) < __mod_tree_val(b);
+}
+
+__always_inline int
+mod_tree_comp(void *key, struct latch_tree_node *n)
+{
+	unsigned long val = (unsigned long)key;
+	unsigned long start, end;
+
+	start = __mod_tree_val(n);
+	if (val < start)
+		return -1;
+
+	end = start + __mod_tree_size(n);
+	if (val >= end)
+		return 1;
+
+	return 0;
+}
+
+const struct latch_tree_ops mod_tree_ops = {
+	.less = mod_tree_less,
+	.comp = mod_tree_comp,
+};
+
+static noinline void __mod_tree_insert(struct mod_tree_node *node)
+{
+	latch_tree_insert(&node->node, &mod_tree.root, &mod_tree_ops);
+}
+
+static void __mod_tree_remove(struct mod_tree_node *node)
+{
+	latch_tree_erase(&node->node, &mod_tree.root, &mod_tree_ops);
+}
+
+/*
+ * These modifications: insert, remove_init and remove; are serialized by the
+ * module_mutex.
+ */
+void mod_tree_insert(struct module *mod)
+{
+	mod->core_layout.mtn.mod = mod;
+	mod->init_layout.mtn.mod = mod;
+
+	__mod_tree_insert(&mod->core_layout.mtn);
+	if (mod->init_layout.size)
+		__mod_tree_insert(&mod->init_layout.mtn);
+}
+
+void mod_tree_remove_init(struct module *mod)
+{
+	if (mod->init_layout.size)
+		__mod_tree_remove(&mod->init_layout.mtn);
+}
+
+void mod_tree_remove(struct module *mod)
+{
+	__mod_tree_remove(&mod->core_layout.mtn);
+	mod_tree_remove_init(mod);
+}
+
+struct module *mod_find(unsigned long addr)
+{
+	struct latch_tree_node *ltn;
+
+	ltn = latch_tree_find((void *)addr, &mod_tree.root, &mod_tree_ops);
+	if (!ltn)
+		return NULL;
+
+	return container_of(ltn, struct mod_tree_node, node)->mod;
+}
-- 
2.34.1

