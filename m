Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE0C4AF799
	for <lists+live-patching@lfdr.de>; Wed,  9 Feb 2022 18:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237802AbiBIRER (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 9 Feb 2022 12:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237769AbiBIREH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 9 Feb 2022 12:04:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 00D1AC05CB89
        for <live-patching@vger.kernel.org>; Wed,  9 Feb 2022 09:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644426249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zu116mg0opc6Hve6tCnaZmfAZvjmDPpkF/dW1Iacd4Q=;
        b=IZfccYTVBZXg6gaXQdLRn/c3dtKpxnVpCMxF9XePGqBQ6mTi8OWPHJqOETqtAQLnHjF+j+
        EGzwdExlOfsVVO+KpHYf4gBn73gESFtkkkR6uzG/fXBJa6ql/HZvYNNkGu+lE7xoDPHJIc
        M6u4+dsgPKQaZ8e5WogHfZVheQo/m3A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-AhbQA9ZYPluL9DQEmsVF8w-1; Wed, 09 Feb 2022 12:04:08 -0500
X-MC-Unique: AhbQA9ZYPluL9DQEmsVF8w-1
Received: by mail-wm1-f70.google.com with SMTP id i186-20020a1c3bc3000000b0037bb9f6feeeso1506224wma.5
        for <live-patching@vger.kernel.org>; Wed, 09 Feb 2022 09:04:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zu116mg0opc6Hve6tCnaZmfAZvjmDPpkF/dW1Iacd4Q=;
        b=SRI0XQxAtPYV2n6cz0oF/n05L0jRBkhJ97rJhJP1e4qHA8vc76KLStzTNFqj91mcI7
         G0gxFAzHiTe5xZyy5xakSJOgV2MSPyyHKMhkbAFfwcQSC+zd61ayDBn3xYGVAZEBGhNd
         rEit1gPz0RC3EZR+SWI3pvZwmFER6ZDwiKBMsZvCTSzzzg8/vQlGEgW9QhOEj5/n2xbX
         QenoNFrPNea06UgY0GTdNNyau/DWGLi+oQBfpDszqQ5wYzX7BEWZvwqU+fYWE6ZEIf4k
         mfhIkXyy7+yyKI777QLtV+Fj5dGmqZqcvDyoMwWixt0D2Cz1EN4A1sPyhi0yDn5euAXS
         jzHg==
X-Gm-Message-State: AOAM533h6H3CAlCoNRTXSStcXr1d3s5e+Zp+FXRt00m6CUw/5F+L8Oe2
        3kQEDb+Y9UfV3TnjNF5fha63aldfI/G0Q6JCFpH67t2VWK2fVDKw/k0IgSQcamelr4K19GGLV6R
        ixUr+D6lo5ZwuphwcfNCVqtR1
X-Received: by 2002:a5d:5986:: with SMTP id n6mr2795717wri.574.1644426246673;
        Wed, 09 Feb 2022 09:04:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyXyw4VQzsrdxK5LRdAEZYVOvmJhgJ2JBRTTQ9XSh6fKhHYYqW8JPjPFXoVpWksDdjv+xKVNg==
X-Received: by 2002:a5d:5986:: with SMTP id n6mr2795684wri.574.1644426246442;
        Wed, 09 Feb 2022 09:04:06 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id g6sm15793753wrq.97.2022.02.09.09.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 09:04:05 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com, christophe.leroy@csgroup.eu, msuchanek@suse.de,
        oleksandr@natalenko.name
Subject: [PATCH v5 05/13] module: Move latched RB-tree support to a separate file
Date:   Wed,  9 Feb 2022 17:03:50 +0000
Message-Id: <20220209170358.3266629-6-atomlin@redhat.com>
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

This patch migrates module latched RB-tree support
(e.g. see __module_address()) from core module code
into kernel/module/tree_lookup.c.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
---
 include/linux/module.h      |   4 +-
 kernel/module/Makefile      |   1 +
 kernel/module/internal.h    |  34 ++++++++++
 kernel/module/main.c        | 129 +-----------------------------------
 kernel/module/tree_lookup.c | 109 ++++++++++++++++++++++++++++++
 5 files changed, 148 insertions(+), 129 deletions(-)
 create mode 100644 kernel/module/tree_lookup.c

diff --git a/include/linux/module.h b/include/linux/module.h
index 680b31ff57fa..fd6161d78127 100644
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
index d252e0af1c54..08b6be037b72 100644
--- a/kernel/module/internal.h
+++ b/kernel/module/internal.h
@@ -9,6 +9,7 @@
 #include <linux/compiler.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/rculist.h>
 
 #ifndef ARCH_SHF_SMALL
 #define ARCH_SHF_SMALL 0
@@ -90,3 +91,36 @@ static inline void module_decompress_cleanup(struct load_info *info)
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
+void mod_tree_insert(struct module *mod);
+void mod_tree_remove_init(struct module *mod);
+void mod_tree_remove(struct module *mod);
+struct module *mod_find(unsigned long addr);
+#else /* !CONFIG_MODULES_TREE_LOOKUP */
+static unsigned long module_addr_min = -1UL, module_addr_max;
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
index 5f5bd7152b55..f733a719c65d 100644
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

