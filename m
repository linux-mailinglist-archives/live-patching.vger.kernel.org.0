Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D395960E92A
	for <lists+live-patching@lfdr.de>; Wed, 26 Oct 2022 21:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234889AbiJZTlz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 26 Oct 2022 15:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234432AbiJZTlt (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 26 Oct 2022 15:41:49 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE4EBC608;
        Wed, 26 Oct 2022 12:41:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DDCA722029;
        Wed, 26 Oct 2022 19:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1666813305; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Lk0jla7Dh3kqdUHZpu2RNb/LcgsWJikmOAgMB8CUfw=;
        b=TAfAc8VM1Vaf0+ZB5lC3dMQLSXTFUfue1NPEssJ+0NN/pyv8Di3AST3eqQ8Hc5h4anZVyY
        tU4HQLR1AHVZ1FAI+fz0XsWV1UIhc+C8IOUSyDInyo2vS7QdAYHNUT7VoM9ilfZMNbRawa
        B//bg2AVCQDEe8AdXK/5rFVNEzdUSdY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1B9D813A77;
        Wed, 26 Oct 2022 19:41:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IEzmNHaNWWNlFwAAMHmgww
        (envelope-from <mpdesouza@suse.com>); Wed, 26 Oct 2022 19:41:42 +0000
From:   Marcos Paulo de Souza <mpdesouza@suse.com>
To:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Cc:     jpoimboe@redhat.com, joe.lawrence@redhat.com, pmladek@suse.com,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of shadow variables
Date:   Wed, 26 Oct 2022 16:41:22 -0300
Message-Id: <20221026194122.11761-5-mpdesouza@suse.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221026194122.11761-1-mpdesouza@suse.com>
References: <20221026194122.11761-1-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The life of shadow variables is not completely trivial to maintain.
They might be used by more livepatches and more livepatched objects.
They should stay as long as there is any user.

In practice, it requires to implement reference counting in callbacks
of all users. They should register all the user and remove the shadow
variables only when there is no user left.

This patch hides the reference counting into the klp_shadow API.
The counter is connected with the shadow variable @id. It requires
an API to take and release the reference. The release function also
calls the related dtor() when defined.

An easy solution would be to add some get_ref()/put_ref() API.
But it would need to get called from pre()/post_un() callbacks.
It might be easy to forget a callback and make it wrong.

A more safe approach is to associate the klp_shadow_type with
klp_objects that use the shadow variables. The livepatch core
code might then handle the reference counters on background.

The shadow variable type might then be added into a new @shadow_types
member of struct klp_object. They will get then automatically registered
and unregistered when the object is being livepatched. The registration
increments the reference count. Unregistration decreases the reference
count. All shadow variables of the given type are freed when the reference
count reaches zero.

All klp_shadow_alloc/get/free functions also checks whether the requested
type is registered. It will help to catch missing registration and might
also help to catch eventual races.

Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 Changes from v1:
 * Reordered my SoB (Josh)
 * Changed code comments (Petr)

 include/linux/livepatch.h                 |  21 ++++
 kernel/livepatch/core.c                   |  39 +++++++
 kernel/livepatch/core.h                   |   1 +
 kernel/livepatch/shadow.c                 | 124 ++++++++++++++++++++++
 kernel/livepatch/transition.c             |   4 +-
 lib/livepatch/test_klp_shadow_vars.c      |  18 +++-
 samples/livepatch/livepatch-shadow-fix1.c |   8 +-
 samples/livepatch/livepatch-shadow-fix2.c |   9 +-
 8 files changed, 214 insertions(+), 10 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 79e7bf3b35f6..fdd82fde86e6 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -100,11 +100,14 @@ struct klp_callbacks {
 	bool post_unpatch_enabled;
 };
 
+struct klp_shadow_type;
+
 /**
  * struct klp_object - kernel object structure for live patching
  * @name:	module name (or NULL for vmlinux)
  * @funcs:	function entries for functions to be patched in the object
  * @callbacks:	functions to be executed pre/post (un)patching
+ * @shadow_types: shadow variable types used by the livepatch for the klp_object
  * @kobj:	kobject for sysfs resources
  * @func_list:	dynamic list of the function entries
  * @node:	list node for klp_patch obj_list
@@ -118,6 +121,7 @@ struct klp_object {
 	const char *name;
 	struct klp_func *funcs;
 	struct klp_callbacks callbacks;
+	struct klp_shadow_type **shadow_types;
 
 	/* internal */
 	struct kobject kobj;
@@ -222,13 +226,30 @@ typedef void (*klp_shadow_dtor_t)(void *obj, void *shadow_data);
  * @ctor:	custom constructor to initialize the shadow data (optional)
  * @dtor:	custom callback that can be used to unregister the variable
  *		and/or free data that the shadow variable points to (optional)
+ * @registered: flag indicating if the variable was successfully registered
+ *
+ * All shadow variables used by the livepatch for the related klp_object
+ * must be listed here so that they are registered when the livepatch
+ * and the module is loaded. Otherwise, it will not be possible to
+ * allocate them.
  */
 struct klp_shadow_type {
 	unsigned long id;
 	klp_shadow_ctor_t ctor;
 	klp_shadow_dtor_t dtor;
+
+	/* internal */
+	bool registered;
 };
 
+#define klp_for_each_shadow_type(obj, shadow_type, i)			\
+	for (shadow_type = obj->shadow_types ? obj->shadow_types[0] : NULL, i = 1; \
+	     shadow_type; \
+	     shadow_type = obj->shadow_types[i++])
+
+int klp_shadow_register(struct klp_shadow_type *shadow_type);
+void klp_shadow_unregister(struct klp_shadow_type *shadow_type);
+
 void *klp_shadow_get(void *obj, struct klp_shadow_type *shadow_type);
 void *klp_shadow_alloc(void *obj, struct klp_shadow_type *shadow_type,
 		       size_t size, gfp_t gfp_flags, void *ctor_data);
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 9ada0bc5247b..44c9e5ea0d2c 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -928,6 +928,30 @@ static int klp_init_patch(struct klp_patch *patch)
 	return 0;
 }
 
+void klp_unregister_shadow_types(struct klp_object *obj)
+{
+	struct klp_shadow_type *shadow_type;
+	int i;
+
+	klp_for_each_shadow_type(obj, shadow_type, i) {
+		klp_shadow_unregister(shadow_type);
+	}
+}
+
+static int klp_register_shadow_types(struct klp_object *obj)
+{
+	struct klp_shadow_type *shadow_type;
+	int i, ret;
+
+	klp_for_each_shadow_type(obj, shadow_type, i) {
+		ret = klp_shadow_register(shadow_type);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int __klp_disable_patch(struct klp_patch *patch)
 {
 	struct klp_object *obj;
@@ -988,6 +1012,13 @@ static int __klp_enable_patch(struct klp_patch *patch)
 		if (!klp_is_object_loaded(obj))
 			continue;
 
+		ret = klp_register_shadow_types(obj);
+		if (ret) {
+			pr_warn("failed to register shadow types for object '%s'\n",
+				klp_is_module(obj) ? obj->name : "vmlinux");
+			goto err;
+		}
+
 		ret = klp_pre_patch_callback(obj);
 		if (ret) {
 			pr_warn("pre-patch callback failed for object '%s'\n",
@@ -1172,6 +1203,7 @@ static void klp_cleanup_module_patches_limited(struct module *mod,
 			klp_unpatch_object(obj);
 
 			klp_post_unpatch_callback(obj);
+			klp_unregister_shadow_types(obj);
 
 			klp_free_object_loaded(obj);
 			break;
@@ -1218,6 +1250,13 @@ int klp_module_coming(struct module *mod)
 			pr_notice("applying patch '%s' to loading module '%s'\n",
 				  patch->mod->name, obj->mod->name);
 
+			ret = klp_register_shadow_types(obj);
+			if (ret) {
+				pr_warn("failed to register shadow types for object '%s'\n",
+					obj->name);
+				goto err;
+			}
+
 			ret = klp_pre_patch_callback(obj);
 			if (ret) {
 				pr_warn("pre-patch callback failed for object '%s'\n",
diff --git a/kernel/livepatch/core.h b/kernel/livepatch/core.h
index 38209c7361b6..0b68f2407a82 100644
--- a/kernel/livepatch/core.h
+++ b/kernel/livepatch/core.h
@@ -13,6 +13,7 @@ extern struct list_head klp_patches;
 #define klp_for_each_patch(patch)	\
 	list_for_each_entry(patch, &klp_patches, list)
 
+void klp_unregister_shadow_types(struct klp_object *obj);
 void klp_free_patch_async(struct klp_patch *patch);
 void klp_free_replaced_patches_async(struct klp_patch *new_patch);
 void klp_unpatch_replaced_patches(struct klp_patch *new_patch);
diff --git a/kernel/livepatch/shadow.c b/kernel/livepatch/shadow.c
index 64e83853891d..9437dc1be7b2 100644
--- a/kernel/livepatch/shadow.c
+++ b/kernel/livepatch/shadow.c
@@ -34,6 +34,7 @@
 #include <linux/hashtable.h>
 #include <linux/slab.h>
 #include <linux/livepatch.h>
+#include "core.h"
 
 static DEFINE_HASHTABLE(klp_shadow_hash, 12);
 
@@ -59,6 +60,22 @@ struct klp_shadow {
 	char data[];
 };
 
+/**
+ * struct klp_shadow_type_reg - information about a registered shadow
+ *	variable type
+ * @id:		shadow variable type indentifier
+ * @count:	reference counter
+ * @list:	list node for list of registered shadow variable types
+ */
+struct klp_shadow_type_reg {
+	unsigned long id;
+	int ref_cnt;
+	struct list_head list;
+};
+
+/* List of registered shadow variable types */
+static LIST_HEAD(klp_shadow_types);
+
 /**
  * klp_shadow_match() - verify a shadow variable matches given <obj, id>
  * @shadow:	shadow variable to match
@@ -84,6 +101,13 @@ void *klp_shadow_get(void *obj, struct klp_shadow_type *shadow_type)
 {
 	struct klp_shadow *shadow;
 
+	/* Just the best effort. Can't take @klp_shadow_lock here. */
+	if (!shadow_type->registered) {
+		pr_err("Trying to get shadow variable of non-registered type: %lu\n",
+		       shadow_type->id);
+		return NULL;
+	}
+
 	rcu_read_lock();
 
 	hash_for_each_possible_rcu(klp_shadow_hash, shadow, node,
@@ -310,3 +334,103 @@ void klp_shadow_free_all(struct klp_shadow_type *shadow_type)
 	spin_unlock_irqrestore(&klp_shadow_lock, flags);
 }
 EXPORT_SYMBOL_GPL(klp_shadow_free_all);
+
+static struct klp_shadow_type_reg *
+klp_shadow_type_get_reg(struct klp_shadow_type *shadow_type)
+{
+	struct klp_shadow_type_reg *shadow_type_reg;
+	lockdep_assert_held(&klp_shadow_lock);
+
+	list_for_each_entry(shadow_type_reg, &klp_shadow_types, list) {
+		if (shadow_type_reg->id == shadow_type->id)
+			return shadow_type_reg;
+	}
+
+	return NULL;
+}
+
+/**
+ * klp_shadow_register() - register the given shadow variable type
+ * @shadow_type:	shadow type to be registered
+ *
+ * Tell the system that the given shadow type is going to used by the caller
+ * (livepatch module). It allows to check and maintain lifetime of shadow
+ * variables.
+ *
+ * Return: 0 on suceess, -ENOMEM when there is not enough memory.
+ */
+int klp_shadow_register(struct klp_shadow_type *shadow_type)
+{
+	struct klp_shadow_type_reg *shadow_type_reg;
+	struct klp_shadow_type_reg *new_shadow_type_reg;
+
+	new_shadow_type_reg =
+		kzalloc(sizeof(struct klp_shadow_type_reg), GFP_KERNEL);
+	if (!new_shadow_type_reg)
+		return -ENOMEM;
+
+	spin_lock_irq(&klp_shadow_lock);
+
+	if (shadow_type->registered) {
+		pr_err("Trying to register shadow variable type that is already registered: %lu",
+		       shadow_type->id);
+		kfree(new_shadow_type_reg);
+		goto out;
+	}
+
+	shadow_type_reg = klp_shadow_type_get_reg(shadow_type);
+	if (!shadow_type_reg) {
+		shadow_type_reg = new_shadow_type_reg;
+		shadow_type_reg->id = shadow_type->id;
+		list_add(&shadow_type_reg->list, &klp_shadow_types);
+	} else {
+		kfree(new_shadow_type_reg);
+	}
+
+	shadow_type_reg->ref_cnt++;
+	shadow_type->registered = true;
+out:
+	spin_unlock_irq(&klp_shadow_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(klp_shadow_register);
+
+/**
+ * klp_shadow_unregister() - unregister the give shadow variable type
+ * @shadow_type:	shadow type to be unregistered
+ *
+ * Tell the system that a given shadow variable ID is not longer be used by
+ * the caller (livepatch module). All existing shadow variables are freed
+ * when it was the last registered user.
+ */
+void klp_shadow_unregister(struct klp_shadow_type *shadow_type)
+{
+	struct klp_shadow_type_reg *shadow_type_reg;
+
+	spin_lock_irq(&klp_shadow_lock);
+
+	if (!shadow_type->registered) {
+		pr_err("Trying to unregister shadow variable type that is not registered: %lu",
+		       shadow_type->id);
+		goto out;
+	}
+
+	shadow_type_reg = klp_shadow_type_get_reg(shadow_type);
+	if (!shadow_type_reg) {
+		pr_err("Can't find shadow variable type registration: %lu", shadow_type->id);
+		goto out;
+	}
+
+	shadow_type->registered = false;
+	shadow_type_reg->ref_cnt--;
+
+	if (!shadow_type_reg->ref_cnt) {
+		__klp_shadow_free_all(shadow_type);
+		list_del(&shadow_type_reg->list);
+		kfree(shadow_type_reg);
+	}
+out:
+	spin_unlock_irq(&klp_shadow_lock);
+}
+EXPORT_SYMBOL_GPL(klp_shadow_unregister);
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 30187b1d8275..9c57941974a7 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -123,8 +123,10 @@ static void klp_complete_transition(void)
 			continue;
 		if (klp_target_state == KLP_PATCHED)
 			klp_post_patch_callback(obj);
-		else if (klp_target_state == KLP_UNPATCHED)
+		else if (klp_target_state == KLP_UNPATCHED) {
 			klp_post_unpatch_callback(obj);
+			klp_unregister_shadow_types(obj);
+		}
 	}
 
 	pr_notice("'%s': %s complete\n", klp_transition_patch->mod->name,
diff --git a/lib/livepatch/test_klp_shadow_vars.c b/lib/livepatch/test_klp_shadow_vars.c
index ee47c1fae8e2..6de1f6d11bcf 100644
--- a/lib/livepatch/test_klp_shadow_vars.c
+++ b/lib/livepatch/test_klp_shadow_vars.c
@@ -188,6 +188,17 @@ static int test_klp_shadow_vars_init(void)
 	int ret;
 	int i;
 
+	/* Registered manually since we don't have a klp_object instance. */
+	ret = klp_shadow_register(&shadow_type_1);
+	if (ret)
+		return ret;
+
+	ret = klp_shadow_register(&shadow_type_2);
+	if (ret) {
+		klp_shadow_unregister(&shadow_type_1);
+		return ret;
+	}
+
 	ptr_id(NULL);
 
 	/*
@@ -296,12 +307,9 @@ static int test_klp_shadow_vars_init(void)
 			pr_info("  got expected NULL result\n");
 	}
 
-	free_ptr_list();
-
-	return 0;
 out:
-	shadow_free_all(&shadow_type_1); /* 'char' pairs */
-	shadow_free_all(&shadow_type_2); /* 'int' pairs */
+	klp_shadow_unregister(&shadow_type_1); /* 'char' pairs */
+	klp_shadow_unregister(&shadow_type_2); /* 'int' pairs */
 	free_ptr_list();
 
 	return ret;
diff --git a/samples/livepatch/livepatch-shadow-fix1.c b/samples/livepatch/livepatch-shadow-fix1.c
index 0cc7d1e4b4bc..6718df9ec14b 100644
--- a/samples/livepatch/livepatch-shadow-fix1.c
+++ b/samples/livepatch/livepatch-shadow-fix1.c
@@ -141,6 +141,11 @@ static struct klp_shadow_type shadow_leak_type = {
 	.dtor = livepatch_fix1_dummy_leak_dtor,
 };
 
+struct klp_shadow_type *shadow_types[] = {
+	&shadow_leak_type,
+	NULL
+};
+
 static struct klp_func funcs[] = {
 	{
 		.old_name = "dummy_alloc",
@@ -156,6 +161,7 @@ static struct klp_object objs[] = {
 	{
 		.name = "livepatch_shadow_mod",
 		.funcs = funcs,
+		.shadow_types = shadow_types,
 	}, { }
 };
 
@@ -171,8 +177,6 @@ static int livepatch_shadow_fix1_init(void)
 
 static void livepatch_shadow_fix1_exit(void)
 {
-	/* Cleanup any existing SV_LEAK shadow variables */
-	klp_shadow_free_all(&shadow_leak_type);
 }
 
 module_init(livepatch_shadow_fix1_init);
diff --git a/samples/livepatch/livepatch-shadow-fix2.c b/samples/livepatch/livepatch-shadow-fix2.c
index 840100555152..290c7e3f96b0 100644
--- a/samples/livepatch/livepatch-shadow-fix2.c
+++ b/samples/livepatch/livepatch-shadow-fix2.c
@@ -103,6 +103,12 @@ static struct klp_shadow_type shadow_counter_type = {
 	.id = SV_COUNTER,
 };
 
+struct klp_shadow_type *shadow_types[] = {
+	&shadow_leak_type,
+	&shadow_counter_type,
+	NULL
+};
+
 static struct klp_func funcs[] = {
 	{
 		.old_name = "dummy_check",
@@ -118,6 +124,7 @@ static struct klp_object objs[] = {
 	{
 		.name = "livepatch_shadow_mod",
 		.funcs = funcs,
+		.shadow_types = shadow_types,
 	}, { }
 };
 
@@ -133,8 +140,6 @@ static int livepatch_shadow_fix2_init(void)
 
 static void livepatch_shadow_fix2_exit(void)
 {
-	/* Cleanup any existing SV_COUNTER shadow variables */
-	klp_shadow_free_all(&shadow_leak_type);
 }
 
 module_init(livepatch_shadow_fix2_init);
-- 
2.37.3

