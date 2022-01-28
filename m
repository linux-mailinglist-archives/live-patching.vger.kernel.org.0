Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAF54A0212
	for <lists+live-patching@lfdr.de>; Fri, 28 Jan 2022 21:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344402AbiA1Ujr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 28 Jan 2022 15:39:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:42060 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239213AbiA1Ujo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 28 Jan 2022 15:39:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643402383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0CNcxvm7n1RCGlI5KmT6BeLnySyjUrrthgmbjpeW11k=;
        b=DZg6u0g6eE67Vv/WKPaCCsm1dcXWeHyPyjdE7aR/ANMob7hyH3ICzGparSDptQ9Uu/tDOv
        jPbwyJCiuE7fO7oZTK5LbW4oETczKfndk31/xdfJE5uCJgPBjo5KABe8/GXSz1ECovPmUJ
        eYgy7qQjtadWKFCOtrU5c6Rz9mTXEo8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-gqS0wgL0MgWH_0BLRtyO6g-1; Fri, 28 Jan 2022 15:39:42 -0500
X-MC-Unique: gqS0wgL0MgWH_0BLRtyO6g-1
Received: by mail-wm1-f69.google.com with SMTP id bg32-20020a05600c3ca000b00349f2aca1beso3446799wmb.9
        for <live-patching@vger.kernel.org>; Fri, 28 Jan 2022 12:39:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0CNcxvm7n1RCGlI5KmT6BeLnySyjUrrthgmbjpeW11k=;
        b=jrtkNseYo2i1Uja12h6eCszubRmIaF9ArWa5tR//bbQEweVmMp+ggORNYpIXZubTP/
         TbdigG1V4EW3mVY6xL83WF12ej0LGyh2d1omr3Qw/HnXZpAJRjGX3hKrekWjhjoMTqrr
         80sB1+10xRb7as35XW1Y8U+cpIiA9ImAI4DjttSyfN/REX2VMvo5w76Borel8MItUbjw
         5Un411E71LSLqk5WjMoAJicy5QPOdpx/S9e/K/o/5oI4xUehGy8xNiwtz2T2irT+4XQy
         AbHVc1l9FePClcYO5qrptu88aBd+Y7kMya1YqdCT9iW7jqiWkVF8eUW24rT22ihs9IDm
         zDIQ==
X-Gm-Message-State: AOAM5317ia8SZMAS82ic8JBCjYHGquC+Ym3iy7WofcjSTg0nXnFSiZuq
        fbxo6Rj3CcmSO74LJURXXpGXCOF4bF6tR0Z2p2PDYVAsslGRqppUKt+YHA0ztGxNyUrWQyLiJBl
        g8mn6pPSXZ0OG0aXOdG9e3gnC
X-Received: by 2002:a1c:cc05:: with SMTP id h5mr17222261wmb.32.1643402381038;
        Fri, 28 Jan 2022 12:39:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwLUdJTerc/z0Y5BOoF7WuuUHjf7RDGJvwRwKDPSht7koL78mE0rpXlafn0RtjHb0qHvrc+qA==
X-Received: by 2002:a1c:cc05:: with SMTP id h5mr17222242wmb.32.1643402380810;
        Fri, 28 Jan 2022 12:39:40 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id a9sm3158690wmm.32.2022.01.28.12.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 12:39:40 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com
Subject: [RFC PATCH v3 04/13] module: Move latched RB-tree support to a separate file
Date:   Fri, 28 Jan 2022 20:39:25 +0000
Message-Id: <20220128203934.600247-5-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128203934.600247-1-atomlin@redhat.com>
References: <20220128203934.600247-1-atomlin@redhat.com>
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
 include/linux/module.h      |  37 +++++++++-
 kernel/module/Makefile      |   1 +
 kernel/module/main.c        | 134 ------------------------------------
 kernel/module/tree_lookup.c | 108 +++++++++++++++++++++++++++++
 4 files changed, 144 insertions(+), 136 deletions(-)
 create mode 100644 kernel/module/tree_lookup.c

diff --git a/include/linux/module.h b/include/linux/module.h
index 8d49f12a7601..377bdb9952cf 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -340,11 +340,44 @@ struct module_layout {
 };
 
 #ifdef CONFIG_MODULES_TREE_LOOKUP
+struct mod_tree_root {
+	struct latch_tree_root root;
+	unsigned long addr_min;
+	unsigned long addr_max;
+} mod_tree __cacheline_aligned = {
+	.addr_min = -1UL,
+};
+
+#define module_addr_min mod_tree.addr_min
+#define module_addr_max mod_tree.addr_max
+
+extern void mod_tree_insert(struct module *mod);
+extern void mod_tree_remove_init(struct module *mod);
+extern void mod_tree_remove(struct module *mod);
+extern struct module *mod_find(unsigned long addr);
 /* Only touch one cacheline for common rbtree-for-core-layout case. */
 #define __module_layout_align ____cacheline_aligned
-#else
+#else /* !CONFIG_MODULES_TREE_LOOKUP */
+
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
 #define __module_layout_align
-#endif
+#endif /* CONFIG_MODULES_TREE_LOOKUP */
 
 struct mod_kallsyms {
 	Elf_Sym *symtab;
diff --git a/kernel/module/Makefile b/kernel/module/Makefile
index ba3ebdb7055b..5990d2e4566d 100644
--- a/kernel/module/Makefile
+++ b/kernel/module/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_MODULE_DECOMPRESS) += decompress.o
 obj-$(CONFIG_MODULE_SIG) += signing.o
 obj-$(CONFIG_MODULE_SIG_FORMAT) += signature.o
 obj-$(CONFIG_LIVEPATCH) += livepatch.o
+obj-$(CONFIG_MODULES_TREE_LOOKUP) += tree_lookup.o
diff --git a/kernel/module/main.c b/kernel/module/main.c
index c91c7e57bca7..5c7c3201b5b4 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -89,140 +89,6 @@ static void do_free_init(struct work_struct *w);
 static DECLARE_WORK(init_free_wq, do_free_init);
 static LLIST_HEAD(init_free_list);
 
-#ifdef CONFIG_MODULES_TREE_LOOKUP
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
-	.addr_min = -1UL,
-};
-
-#define module_addr_min mod_tree.addr_min
-#define module_addr_max mod_tree.addr_max
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
-
 /*
  * Bounds of module text, for speeding up __module_address.
  * Protected by module_mutex.
diff --git a/kernel/module/tree_lookup.c b/kernel/module/tree_lookup.c
new file mode 100644
index 000000000000..5f6d6de2dc60
--- /dev/null
+++ b/kernel/module/tree_lookup.c
@@ -0,0 +1,108 @@
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
+noinline void __mod_tree_insert(struct mod_tree_node *node)
+{
+	latch_tree_insert(&node->node, &mod_tree.root, &mod_tree_ops);
+}
+
+void __mod_tree_remove(struct mod_tree_node *node)
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

