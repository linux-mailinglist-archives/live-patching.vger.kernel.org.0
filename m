Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4481060E927
	for <lists+live-patching@lfdr.de>; Wed, 26 Oct 2022 21:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234623AbiJZTlt (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 26 Oct 2022 15:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234259AbiJZTlr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 26 Oct 2022 15:41:47 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BF9B7F60;
        Wed, 26 Oct 2022 12:41:43 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A3FCC21FFC;
        Wed, 26 Oct 2022 19:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1666813302; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gei3z6v/UM+glPIhIg6yXmE+bgYZJKhOzcfEW7UYnXE=;
        b=N2iFmJwA+h3N3On0xvFXRRkwYaywMAhOASQebk5eH9uB1w8BuhnS3NoPBCeCkTQU5JZ5Hy
        5yPxXIEMO0NHC4SvR0DVLwsSQT0nfW9NXZln5BULDOWkdEWGmps/VC7k2guLQwucYOVK5R
        3qozWqfYAWAzWjP34pSHjF9EYOY9wjo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B93CB13A77;
        Wed, 26 Oct 2022 19:41:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GFXDH3SNWWNlFwAAMHmgww
        (envelope-from <mpdesouza@suse.com>); Wed, 26 Oct 2022 19:41:40 +0000
From:   Marcos Paulo de Souza <mpdesouza@suse.com>
To:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Cc:     jpoimboe@redhat.com, joe.lawrence@redhat.com, pmladek@suse.com,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH v2 3/4] livepatch/shadow: Introduce klp_shadow_type structure
Date:   Wed, 26 Oct 2022 16:41:21 -0300
Message-Id: <20221026194122.11761-4-mpdesouza@suse.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221026194122.11761-1-mpdesouza@suse.com>
References: <20221026194122.11761-1-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The shadow variable type will be used in klp_shadow_alloc/get/free
functions instead of id/ctor/dtor parameters. As a result, all callers
use the same callbacks consistently[*][**].

The structure will be used in the next patch that will manage the
lifetime of shadow variables and execute garbage collection automatically.

[*] From the user POV, it might have been easier to pass $id instead
    of pointer to struct klp_shadow_type.

    It would require registering the klp_shadow_type so that
    the klp_shadow API could find ctor/dtor for the given id.
    It actually will be needed for the garbage collection anyway
    because it will define the lifetime of the variables.

    The bigger problem is that the same klp_shadow_type might be
    used by more livepatch modules. Each livepatch module need
    to duplicate the definition of klp_shadow_type and ctor/dtor
    callbacks. The klp_shadow API would need to choose one registered
    copy.

    The definitions should be compatible and they should stay as long
    as the type is registered. But it still feels more safe when
    klp_shadow API callers use struct klp_shadow_type and ctor/dtor
    callbacks defined in the same livepatch module.

    This problem is gone when each livepatch explicitly uses its
    own struct klp_shadow_type pointing to its own callbacks.

[**] test_klp_shadow_vars.c uses a custom @dtor to show that it was called.
    The message must be disabled when called via klp_shadow_free_all()
    because the ordering of freed variables is not well defined there.
    It has to be done using another hack after switching to
    klp_shadow_types.

Co-developed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 Changes from v1:
 * Added my SoB (Josh)
 * Added a Co-developed-by tag (Petr)
 * Changed the comment about throwing away speculative allocation (Petr)

 include/linux/livepatch.h                     |  29 +++--
 kernel/livepatch/shadow.c                     | 107 +++++++++---------
 lib/livepatch/test_klp_shadow_vars.c          | 105 ++++++++++-------
 samples/livepatch/livepatch-shadow-fix1.c     |  18 ++-
 samples/livepatch/livepatch-shadow-fix2.c     |  27 +++--
 .../selftests/livepatch/test-shadow-vars.sh   |   2 +-
 6 files changed, 165 insertions(+), 123 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 293e29960c6e..79e7bf3b35f6 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -216,15 +216,26 @@ typedef int (*klp_shadow_ctor_t)(void *obj,
 				 void *ctor_data);
 typedef void (*klp_shadow_dtor_t)(void *obj, void *shadow_data);
 
-void *klp_shadow_get(void *obj, unsigned long id);
-void *klp_shadow_alloc(void *obj, unsigned long id,
-		       size_t size, gfp_t gfp_flags,
-		       klp_shadow_ctor_t ctor, void *ctor_data);
-void *klp_shadow_get_or_alloc(void *obj, unsigned long id,
-			      size_t size, gfp_t gfp_flags,
-			      klp_shadow_ctor_t ctor, void *ctor_data);
-void klp_shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor);
-void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor);
+/**
+ * struct klp_shadow_type - shadow variable type used by the klp_object
+ * @id:		shadow variable type indentifier
+ * @ctor:	custom constructor to initialize the shadow data (optional)
+ * @dtor:	custom callback that can be used to unregister the variable
+ *		and/or free data that the shadow variable points to (optional)
+ */
+struct klp_shadow_type {
+	unsigned long id;
+	klp_shadow_ctor_t ctor;
+	klp_shadow_dtor_t dtor;
+};
+
+void *klp_shadow_get(void *obj, struct klp_shadow_type *shadow_type);
+void *klp_shadow_alloc(void *obj, struct klp_shadow_type *shadow_type,
+		       size_t size, gfp_t gfp_flags, void *ctor_data);
+void *klp_shadow_get_or_alloc(void *obj, struct klp_shadow_type *shadow_type,
+			      size_t size, gfp_t gfp_flags, void *ctor_data);
+void klp_shadow_free(void *obj, struct klp_shadow_type *shadow_type);
+void klp_shadow_free_all(struct klp_shadow_type *shadow_type);
 
 struct klp_state *klp_get_state(struct klp_patch *patch, unsigned long id);
 struct klp_state *klp_get_prev_state(unsigned long id);
diff --git a/kernel/livepatch/shadow.c b/kernel/livepatch/shadow.c
index aba44dcc0a88..64e83853891d 100644
--- a/kernel/livepatch/shadow.c
+++ b/kernel/livepatch/shadow.c
@@ -63,24 +63,24 @@ struct klp_shadow {
  * klp_shadow_match() - verify a shadow variable matches given <obj, id>
  * @shadow:	shadow variable to match
  * @obj:	pointer to parent object
- * @id:		data identifier
+ * @shadow_type: type of the wanted shadow variable
  *
  * Return: true if the shadow variable matches.
  */
 static inline bool klp_shadow_match(struct klp_shadow *shadow, void *obj,
-				unsigned long id)
+				struct klp_shadow_type *shadow_type)
 {
-	return shadow->obj == obj && shadow->id == id;
+	return shadow->obj == obj && shadow->id == shadow_type->id;
 }
 
 /**
  * klp_shadow_get() - retrieve a shadow variable data pointer
  * @obj:	pointer to parent object
- * @id:		data identifier
+ * @shadow_type: type of the wanted shadow variable
  *
  * Return: the shadow variable data element, NULL on failure.
  */
-void *klp_shadow_get(void *obj, unsigned long id)
+void *klp_shadow_get(void *obj, struct klp_shadow_type *shadow_type)
 {
 	struct klp_shadow *shadow;
 
@@ -89,7 +89,7 @@ void *klp_shadow_get(void *obj, unsigned long id)
 	hash_for_each_possible_rcu(klp_shadow_hash, shadow, node,
 				   (unsigned long)obj) {
 
-		if (klp_shadow_match(shadow, obj, id)) {
+		if (klp_shadow_match(shadow, obj, shadow_type)) {
 			rcu_read_unlock();
 			return shadow->data;
 		}
@@ -101,17 +101,16 @@ void *klp_shadow_get(void *obj, unsigned long id)
 }
 EXPORT_SYMBOL_GPL(klp_shadow_get);
 
-/* Check if the variable exists. Otherwise, add the pre-allocated one. */
-static void *__klp_shadow_get_or_add_locked(void *obj, unsigned long id,
-				     struct klp_shadow *new_shadow,
-				     klp_shadow_ctor_t ctor, void *ctor_data,
-				     bool *exist)
+static void *__klp_shadow_get_or_add_locked(void *obj,
+					struct klp_shadow_type *shadow_type,
+					struct klp_shadow *new_shadow,
+					void *ctor_data, bool *exist)
 {
 	void *shadow_data;
 
 	lockdep_assert_held(&klp_shadow_lock);
 
-	shadow_data = klp_shadow_get(obj, id);
+	shadow_data = klp_shadow_get(obj, shadow_type);
 	if (unlikely(shadow_data)) {
 		*exist = true;
 		return shadow_data;
@@ -119,15 +118,15 @@ static void *__klp_shadow_get_or_add_locked(void *obj, unsigned long id,
 	*exist = false;
 
 	new_shadow->obj = obj;
-	new_shadow->id = id;
+	new_shadow->id = shadow_type->id;
 
-	if (ctor) {
+	if (shadow_type->ctor) {
 		int err;
 
-		err = ctor(obj, new_shadow->data, ctor_data);
+		err = shadow_type->ctor(obj, new_shadow->data, ctor_data);
 		if (err) {
 			pr_err("Failed to construct shadow variable <%p, %lx> (%d)\n",
-			       obj, id, err);
+			       obj, shadow_type->id, err);
 			return NULL;
 		}
 	}
@@ -139,9 +138,8 @@ static void *__klp_shadow_get_or_add_locked(void *obj, unsigned long id,
 	return new_shadow->data;
 }
 
-static void *__klp_shadow_get_or_alloc(void *obj, unsigned long id,
-				       size_t size, gfp_t gfp_flags,
-				       klp_shadow_ctor_t ctor, void *ctor_data,
+static void *__klp_shadow_get_or_alloc(void *obj, struct klp_shadow_type *shadow_type,
+				       size_t size, gfp_t gfp_flags, void *ctor_data,
 				       bool warn_on_exist)
 {
 	struct klp_shadow *new_shadow;
@@ -150,7 +148,7 @@ static void *__klp_shadow_get_or_alloc(void *obj, unsigned long id,
 	unsigned long flags;
 
 	/* Check if the shadow variable already exists */
-	shadow_data = klp_shadow_get(obj, id);
+	shadow_data = klp_shadow_get(obj, shadow_type);
 	if (shadow_data)
 		return shadow_data;
 
@@ -159,22 +157,25 @@ static void *__klp_shadow_get_or_alloc(void *obj, unsigned long id,
 	 * More complex setting can be done by @ctor function.  But it is
 	 * called only when the buffer is really used (under klp_shadow_lock).
 	 */
-	new_shadow = kzalloc(size + sizeof(*new_shadow), gfp_flags);
+	new_shadow = kzalloc(size + sizeof(struct klp_shadow), gfp_flags);
 	if (!new_shadow)
 		return NULL;
 
 	/* Look for <obj, id> again under the lock */
 	spin_lock_irqsave(&klp_shadow_lock, flags);
-	shadow_data = __klp_shadow_get_or_add_locked(obj, id, new_shadow,
-					      ctor, ctor_data, &exist);
+	shadow_data = __klp_shadow_get_or_add_locked(obj, shadow_type,
+					      new_shadow, ctor_data, &exist);
 	spin_unlock_irqrestore(&klp_shadow_lock, flags);
 
-	/* Throw away unused speculative allocation. */
+	/*
+	 * Throw away unused speculative allocation if the ctor() failed
+	 * or the variable already existed.
+	 */
 	if (!shadow_data || exist)
 		kfree(new_shadow);
 
 	if (exist && warn_on_exist) {
-		WARN(1, "Duplicate shadow variable <%p, %lx>\n", obj, id);
+		WARN(1, "Duplicate shadow variable <%p, %lx>\n", obj, shadow_type->id);
 		return NULL;
 	}
 
@@ -184,10 +185,9 @@ static void *__klp_shadow_get_or_alloc(void *obj, unsigned long id,
 /**
  * klp_shadow_alloc() - allocate and add a new shadow variable
  * @obj:	pointer to parent object
- * @id:		data identifier
+ * @shadow_type: type of the wanted shadow variable
  * @size:	size of attached data
  * @gfp_flags:	GFP mask for allocation
- * @ctor:	custom constructor to initialize the shadow data (optional)
  * @ctor_data:	pointer to any data needed by @ctor (optional)
  *
  * Allocates @size bytes for new shadow variable data using @gfp_flags.
@@ -205,22 +205,21 @@ static void *__klp_shadow_get_or_alloc(void *obj, unsigned long id,
  * Return: the shadow variable data element, NULL on duplicate or
  * failure.
  */
-void *klp_shadow_alloc(void *obj, unsigned long id,
-		       size_t size, gfp_t gfp_flags,
-		       klp_shadow_ctor_t ctor, void *ctor_data)
+void *klp_shadow_alloc(void *obj, struct klp_shadow_type *shadow_type,
+		       size_t size, gfp_t gfp_flags, void *ctor_data)
 {
-	return __klp_shadow_get_or_alloc(obj, id, size, gfp_flags,
-					 ctor, ctor_data, true);
+	return __klp_shadow_get_or_alloc(obj, shadow_type, size,
+					 gfp_flags, ctor_data,
+					 true);
 }
 EXPORT_SYMBOL_GPL(klp_shadow_alloc);
 
 /**
  * klp_shadow_get_or_alloc() - get existing or allocate a new shadow variable
  * @obj:	pointer to parent object
- * @id:		data identifier
+ * @shadow_type: type of the wanted shadow variable
  * @size:	size of attached data
  * @gfp_flags:	GFP mask for allocation
- * @ctor:	custom constructor to initialize the shadow data (optional)
  * @ctor_data:	pointer to any data needed by @ctor (optional)
  *
  * Returns a pointer to existing shadow data if an <obj, id> shadow
@@ -234,35 +233,33 @@ EXPORT_SYMBOL_GPL(klp_shadow_alloc);
  *
  * Return: the shadow variable data element, NULL on failure.
  */
-void *klp_shadow_get_or_alloc(void *obj, unsigned long id,
-			      size_t size, gfp_t gfp_flags,
-			      klp_shadow_ctor_t ctor, void *ctor_data)
+void *klp_shadow_get_or_alloc(void *obj, struct klp_shadow_type *shadow_type,
+			      size_t size, gfp_t gfp_flags, void *ctor_data)
 {
-	return __klp_shadow_get_or_alloc(obj, id, size, gfp_flags,
-					 ctor, ctor_data, false);
+	return __klp_shadow_get_or_alloc(obj, shadow_type, size,
+					 gfp_flags, ctor_data,
+					 false);
 }
 EXPORT_SYMBOL_GPL(klp_shadow_get_or_alloc);
 
 static void klp_shadow_free_struct(struct klp_shadow *shadow,
-				   klp_shadow_dtor_t dtor)
+				   struct klp_shadow_type *shadow_type)
 {
 	hash_del_rcu(&shadow->node);
-	if (dtor)
-		dtor(shadow->obj, shadow->data);
+	if (shadow_type->dtor)
+		shadow_type->dtor(shadow->obj, shadow->data);
 	kfree_rcu(shadow, rcu_head);
 }
 
 /**
  * klp_shadow_free() - detach and free a <obj, id> shadow variable
  * @obj:	pointer to parent object
- * @id:		data identifier
- * @dtor:	custom callback that can be used to unregister the variable
- *		and/or free data that the shadow variable points to (optional)
+ * @shadow_type: type of to be freed shadow variable
  *
  * This function releases the memory for this <obj, id> shadow variable
  * instance, callers should stop referencing it accordingly.
  */
-void klp_shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor)
+void klp_shadow_free(void *obj, struct klp_shadow_type *shadow_type)
 {
 	struct klp_shadow *shadow;
 	unsigned long flags;
@@ -273,8 +270,8 @@ void klp_shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor)
 	hash_for_each_possible(klp_shadow_hash, shadow, node,
 			       (unsigned long)obj) {
 
-		if (klp_shadow_match(shadow, obj, id)) {
-			klp_shadow_free_struct(shadow, dtor);
+		if (klp_shadow_match(shadow, obj, shadow_type)) {
+			klp_shadow_free_struct(shadow, shadow_type);
 			break;
 		}
 	}
@@ -283,7 +280,7 @@ void klp_shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor)
 }
 EXPORT_SYMBOL_GPL(klp_shadow_free);
 
-static void __klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor)
+static void __klp_shadow_free_all(struct klp_shadow_type *shadow_type)
 {
 	struct klp_shadow *shadow;
 	int i;
@@ -292,26 +289,24 @@ static void __klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor)
 
 	/* Delete all <*, id> from hash */
 	hash_for_each(klp_shadow_hash, i, shadow, node) {
-		if (klp_shadow_match(shadow, shadow->obj, id))
-			klp_shadow_free_struct(shadow, dtor);
+		if (klp_shadow_match(shadow, shadow->obj, shadow_type))
+			klp_shadow_free_struct(shadow, shadow_type);
 	}
 }
 
 /**
  * klp_shadow_free_all() - detach and free all <_, id> shadow variables
- * @id:		data identifier
- * @dtor:	custom callback that can be used to unregister the variable
- *		and/or free data that the shadow variable points to (optional)
+ * @shadow_type: type of to be freed shadow variables
  *
  * This function releases the memory for all <_, id> shadow variable
  * instances, callers should stop referencing them accordingly.
  */
-void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor)
+void klp_shadow_free_all(struct klp_shadow_type *shadow_type)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&klp_shadow_lock, flags);
-	__klp_shadow_free_all(id, dtor);
+	__klp_shadow_free_all(shadow_type);
 	spin_unlock_irqrestore(&klp_shadow_lock, flags);
 }
 EXPORT_SYMBOL_GPL(klp_shadow_free_all);
diff --git a/lib/livepatch/test_klp_shadow_vars.c b/lib/livepatch/test_klp_shadow_vars.c
index b99116490858..ee47c1fae8e2 100644
--- a/lib/livepatch/test_klp_shadow_vars.c
+++ b/lib/livepatch/test_klp_shadow_vars.c
@@ -58,58 +58,64 @@ static int ptr_id(void *ptr)
  * to the kernel log for testing verification.  Don't display raw pointers,
  * but use the ptr_id() value instead.
  */
-static void *shadow_get(void *obj, unsigned long id)
+static void *shadow_get(void *obj, struct klp_shadow_type *shadow_type)
 {
 	int **sv;
 
-	sv = klp_shadow_get(obj, id);
+	sv = klp_shadow_get(obj, shadow_type);
 	pr_info("klp_%s(obj=PTR%d, id=0x%lx) = PTR%d\n",
-		__func__, ptr_id(obj), id, ptr_id(sv));
+		__func__, ptr_id(obj), shadow_type->id, ptr_id(sv));
 
 	return sv;
 }
 
-static void *shadow_alloc(void *obj, unsigned long id, size_t size,
-			  gfp_t gfp_flags, klp_shadow_ctor_t ctor,
-			  void *ctor_data)
+static void *shadow_alloc(void *obj, struct klp_shadow_type *shadow_type,
+			  size_t size, gfp_t gfp_flags, void *ctor_data)
 {
 	int **var = ctor_data;
 	int **sv;
 
-	sv = klp_shadow_alloc(obj, id, size, gfp_flags, ctor, var);
+	sv = klp_shadow_alloc(obj, shadow_type, size, gfp_flags, var);
 	pr_info("klp_%s(obj=PTR%d, id=0x%lx, size=%zx, gfp_flags=%pGg), ctor=PTR%d, ctor_data=PTR%d = PTR%d\n",
-		__func__, ptr_id(obj), id, size, &gfp_flags, ptr_id(ctor),
+		__func__, ptr_id(obj), shadow_type->id, size, &gfp_flags, ptr_id(shadow_type->ctor),
 		ptr_id(*var), ptr_id(sv));
 
 	return sv;
 }
 
-static void *shadow_get_or_alloc(void *obj, unsigned long id, size_t size,
-				 gfp_t gfp_flags, klp_shadow_ctor_t ctor,
-				 void *ctor_data)
+static void *shadow_get_or_alloc(void *obj, struct klp_shadow_type *shadow_type,
+				 size_t size, gfp_t gfp_flags, void *ctor_data)
 {
 	int **var = ctor_data;
 	int **sv;
 
-	sv = klp_shadow_get_or_alloc(obj, id, size, gfp_flags, ctor, var);
+	sv = klp_shadow_get_or_alloc(obj, shadow_type, size, gfp_flags, var);
 	pr_info("klp_%s(obj=PTR%d, id=0x%lx, size=%zx, gfp_flags=%pGg), ctor=PTR%d, ctor_data=PTR%d = PTR%d\n",
-		__func__, ptr_id(obj), id, size, &gfp_flags, ptr_id(ctor),
+		__func__, ptr_id(obj), shadow_type->id, size, &gfp_flags, ptr_id(shadow_type->ctor),
 		ptr_id(*var), ptr_id(sv));
 
 	return sv;
 }
 
-static void shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor)
+static void shadow_free(void *obj, struct klp_shadow_type *shadow_type)
 {
-	klp_shadow_free(obj, id, dtor);
+	klp_shadow_free(obj, shadow_type);
 	pr_info("klp_%s(obj=PTR%d, id=0x%lx, dtor=PTR%d)\n",
-		__func__, ptr_id(obj), id, ptr_id(dtor));
+		__func__, ptr_id(obj), shadow_type->id, ptr_id(shadow_type->dtor));
 }
 
-static void shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor)
+/*
+ * With more than one item to free in the list, order is not determined and
+ * shadow_dtor will not be passed to shadow_free_all() which would make the
+ * test fail. (see pass 6)
+ */
+static bool verbose_dtor = true;
+static void shadow_free_all(struct klp_shadow_type *shadow_type)
 {
-	klp_shadow_free_all(id, dtor);
-	pr_info("klp_%s(id=0x%lx, dtor=PTR%d)\n", __func__, id, ptr_id(dtor));
+	verbose_dtor = false;
+	klp_shadow_free_all(shadow_type);
+	verbose_dtor = true;
+	pr_info("klp_%s(id=0x%lx, dtor=PTR%d)\n", __func__, shadow_type->id, ptr_id(shadow_type->dtor));
 }
 
 
@@ -128,17 +134,14 @@ static int shadow_ctor(void *obj, void *shadow_data, void *ctor_data)
 	return 0;
 }
 
-/*
- * With more than one item to free in the list, order is not determined and
- * shadow_dtor will not be passed to shadow_free_all() which would make the
- * test fail. (see pass 6)
- */
 static void shadow_dtor(void *obj, void *shadow_data)
 {
 	int **sv = shadow_data;
 
-	pr_info("%s(obj=PTR%d, shadow_data=PTR%d)\n",
-		__func__, ptr_id(obj), ptr_id(sv));
+	if (verbose_dtor) {
+		pr_info("%s(obj=PTR%d, shadow_data=PTR%d)\n",
+			__func__, ptr_id(obj), ptr_id(sv));
+	}
 }
 
 /* number of objects we simulate that need shadow vars */
@@ -148,6 +151,18 @@ static void shadow_dtor(void *obj, void *shadow_data)
 #define SV_ID1 0x1234
 #define SV_ID2 0x1235
 
+struct klp_shadow_type shadow_type_1 = {
+	.id = SV_ID1,
+	.ctor = shadow_ctor,
+	.dtor = shadow_dtor,
+};
+
+struct klp_shadow_type shadow_type_2 = {
+	.id = SV_ID2,
+	.ctor = shadow_ctor,
+	.dtor = shadow_dtor,
+};
+
 /*
  * The main test case adds/removes new fields (shadow var) to each of these
  * test structure instances. The last group of fields in the struct represent
@@ -179,7 +194,7 @@ static int test_klp_shadow_vars_init(void)
 	 * With an empty shadow variable hash table, expect not to find
 	 * any matches.
 	 */
-	sv = shadow_get(&objs[0], SV_ID1);
+	sv = shadow_get(&objs[0], &shadow_type_1);
 	if (!sv)
 		pr_info("  got expected NULL result\n");
 
@@ -189,13 +204,13 @@ static int test_klp_shadow_vars_init(void)
 		ptr_id(pnfields1[i]);
 
 		if (i % 2) {
-			sv1[i] = shadow_alloc(&objs[i], SV_ID1,
+			sv1[i] = shadow_alloc(&objs[i], &shadow_type_1,
 					sizeof(pnfields1[i]), GFP_KERNEL,
-					shadow_ctor, &pnfields1[i]);
+					&pnfields1[i]);
 		} else {
-			sv1[i] = shadow_get_or_alloc(&objs[i], SV_ID1,
+			sv1[i] = shadow_get_or_alloc(&objs[i], &shadow_type_1,
 					sizeof(pnfields1[i]), GFP_KERNEL,
-					shadow_ctor, &pnfields1[i]);
+					&pnfields1[i]);
 		}
 		if (!sv1[i]) {
 			ret = -ENOMEM;
@@ -204,8 +219,9 @@ static int test_klp_shadow_vars_init(void)
 
 		pnfields2[i] = &nfields2[i];
 		ptr_id(pnfields2[i]);
-		sv2[i] = shadow_alloc(&objs[i], SV_ID2, sizeof(pnfields2[i]),
-					GFP_KERNEL, shadow_ctor, &pnfields2[i]);
+		sv2[i] = shadow_alloc(&objs[i], &shadow_type_2,
+				      sizeof(pnfields2[i]),
+				      GFP_KERNEL, &pnfields2[i]);
 		if (!sv2[i]) {
 			ret = -ENOMEM;
 			goto out;
@@ -215,7 +231,7 @@ static int test_klp_shadow_vars_init(void)
 	/* pass 2: verify we find allocated svars and where they point to */
 	for (i = 0; i < NUM_OBJS; i++) {
 		/* check the "char" svar for all objects */
-		sv = shadow_get(&objs[i], SV_ID1);
+		sv = shadow_get(&objs[i], &shadow_type_1);
 		if (!sv) {
 			ret = -EINVAL;
 			goto out;
@@ -225,7 +241,7 @@ static int test_klp_shadow_vars_init(void)
 				ptr_id(sv1[i]), ptr_id(*sv1[i]));
 
 		/* check the "int" svar for all objects */
-		sv = shadow_get(&objs[i], SV_ID2);
+		sv = shadow_get(&objs[i], &shadow_type_2);
 		if (!sv) {
 			ret = -EINVAL;
 			goto out;
@@ -240,8 +256,9 @@ static int test_klp_shadow_vars_init(void)
 		pndup[i] = &nfields1[i];
 		ptr_id(pndup[i]);
 
-		sv = shadow_get_or_alloc(&objs[i], SV_ID1, sizeof(pndup[i]),
-					GFP_KERNEL, shadow_ctor, &pndup[i]);
+		sv = shadow_get_or_alloc(&objs[i], &shadow_type_1,
+					 sizeof(pndup[i]),
+					 GFP_KERNEL, &pndup[i]);
 		if (!sv) {
 			ret = -EINVAL;
 			goto out;
@@ -253,15 +270,15 @@ static int test_klp_shadow_vars_init(void)
 
 	/* pass 4: free <objs[*], SV_ID1> pairs of svars, verify removal */
 	for (i = 0; i < NUM_OBJS; i++) {
-		shadow_free(&objs[i], SV_ID1, shadow_dtor); /* 'char' pairs */
-		sv = shadow_get(&objs[i], SV_ID1);
+		shadow_free(&objs[i], &shadow_type_1); /* 'char' pairs */
+		sv = shadow_get(&objs[i], &shadow_type_1);
 		if (!sv)
 			pr_info("  got expected NULL result\n");
 	}
 
 	/* pass 5: check we still find <objs[*], SV_ID2> svar pairs */
 	for (i = 0; i < NUM_OBJS; i++) {
-		sv = shadow_get(&objs[i], SV_ID2);	/* 'int' pairs */
+		sv = shadow_get(&objs[i], &shadow_type_2); /* 'int' pairs */
 		if (!sv) {
 			ret = -EINVAL;
 			goto out;
@@ -272,9 +289,9 @@ static int test_klp_shadow_vars_init(void)
 	}
 
 	/* pass 6: free all the <objs[*], SV_ID2> svar pairs too. */
-	shadow_free_all(SV_ID2, NULL);		/* 'int' pairs */
+	shadow_free_all(&shadow_type_2);		/* 'int' pairs */
 	for (i = 0; i < NUM_OBJS; i++) {
-		sv = shadow_get(&objs[i], SV_ID2);
+		sv = shadow_get(&objs[i], &shadow_type_2);
 		if (!sv)
 			pr_info("  got expected NULL result\n");
 	}
@@ -283,8 +300,8 @@ static int test_klp_shadow_vars_init(void)
 
 	return 0;
 out:
-	shadow_free_all(SV_ID1, NULL);		/* 'char' pairs */
-	shadow_free_all(SV_ID2, NULL);		/* 'int' pairs */
+	shadow_free_all(&shadow_type_1); /* 'char' pairs */
+	shadow_free_all(&shadow_type_2); /* 'int' pairs */
 	free_ptr_list();
 
 	return ret;
diff --git a/samples/livepatch/livepatch-shadow-fix1.c b/samples/livepatch/livepatch-shadow-fix1.c
index 6701641bf12d..0cc7d1e4b4bc 100644
--- a/samples/livepatch/livepatch-shadow-fix1.c
+++ b/samples/livepatch/livepatch-shadow-fix1.c
@@ -32,6 +32,8 @@
 /* Shadow variable enums */
 #define SV_LEAK		1
 
+static struct klp_shadow_type shadow_leak_type;
+
 /* Allocate new dummies every second */
 #define ALLOC_PERIOD	1
 /* Check for expired dummies after a few new ones have been allocated */
@@ -84,8 +86,8 @@ static struct dummy *livepatch_fix1_dummy_alloc(void)
 	if (!leak)
 		goto err_leak;
 
-	shadow_leak = klp_shadow_alloc(d, SV_LEAK, sizeof(leak), GFP_KERNEL,
-				       shadow_leak_ctor, &leak);
+	shadow_leak = klp_shadow_alloc(d, &shadow_leak_type, sizeof(leak),
+				       GFP_KERNEL, &leak);
 	if (!shadow_leak) {
 		pr_err("%s: failed to allocate shadow variable for the leaking pointer: dummy @ %p, leak @ %p\n",
 		       __func__, d, leak);
@@ -124,15 +126,21 @@ static void livepatch_fix1_dummy_free(struct dummy *d)
 	 * not exist (ie, dummy structures allocated before this livepatch
 	 * was loaded.)
 	 */
-	shadow_leak = klp_shadow_get(d, SV_LEAK);
+	shadow_leak = klp_shadow_get(d, &shadow_leak_type);
 	if (shadow_leak)
-		klp_shadow_free(d, SV_LEAK, livepatch_fix1_dummy_leak_dtor);
+		klp_shadow_free(d, &shadow_leak_type);
 	else
 		pr_info("%s: dummy @ %p leaked!\n", __func__, d);
 
 	kfree(d);
 }
 
+static struct klp_shadow_type shadow_leak_type = {
+	.id = SV_LEAK,
+	.ctor = shadow_leak_ctor,
+	.dtor = livepatch_fix1_dummy_leak_dtor,
+};
+
 static struct klp_func funcs[] = {
 	{
 		.old_name = "dummy_alloc",
@@ -164,7 +172,7 @@ static int livepatch_shadow_fix1_init(void)
 static void livepatch_shadow_fix1_exit(void)
 {
 	/* Cleanup any existing SV_LEAK shadow variables */
-	klp_shadow_free_all(SV_LEAK, livepatch_fix1_dummy_leak_dtor);
+	klp_shadow_free_all(&shadow_leak_type);
 }
 
 module_init(livepatch_shadow_fix1_init);
diff --git a/samples/livepatch/livepatch-shadow-fix2.c b/samples/livepatch/livepatch-shadow-fix2.c
index 361046a4f10c..840100555152 100644
--- a/samples/livepatch/livepatch-shadow-fix2.c
+++ b/samples/livepatch/livepatch-shadow-fix2.c
@@ -33,6 +33,9 @@
 #define SV_LEAK		1
 #define SV_COUNTER	2
 
+static struct klp_shadow_type shadow_leak_type;
+static struct klp_shadow_type shadow_counter_type;
+
 struct dummy {
 	struct list_head list;
 	unsigned long jiffies_expire;
@@ -47,9 +50,8 @@ static bool livepatch_fix2_dummy_check(struct dummy *d, unsigned long jiffies)
 	 * already have a SV_COUNTER shadow variable, then attach a
 	 * new one.
 	 */
-	shadow_count = klp_shadow_get_or_alloc(d, SV_COUNTER,
-				sizeof(*shadow_count), GFP_NOWAIT,
-				NULL, NULL);
+	shadow_count = klp_shadow_get_or_alloc(d, &shadow_counter_type,
+				sizeof(*shadow_count), GFP_NOWAIT, NULL);
 	if (shadow_count)
 		*shadow_count += 1;
 
@@ -72,9 +74,9 @@ static void livepatch_fix2_dummy_free(struct dummy *d)
 	int *shadow_count;
 
 	/* Patch: copy the memory leak patch from the fix1 module. */
-	shadow_leak = klp_shadow_get(d, SV_LEAK);
+	shadow_leak = klp_shadow_get(d, &shadow_leak_type);
 	if (shadow_leak)
-		klp_shadow_free(d, SV_LEAK, livepatch_fix2_dummy_leak_dtor);
+		klp_shadow_free(d, &shadow_leak_type);
 	else
 		pr_info("%s: dummy @ %p leaked!\n", __func__, d);
 
@@ -82,16 +84,25 @@ static void livepatch_fix2_dummy_free(struct dummy *d)
 	 * Patch: fetch the SV_COUNTER shadow variable and display
 	 * the final count.  Detach the shadow variable.
 	 */
-	shadow_count = klp_shadow_get(d, SV_COUNTER);
+	shadow_count = klp_shadow_get(d, &shadow_counter_type);
 	if (shadow_count) {
 		pr_info("%s: dummy @ %p, check counter = %d\n",
 			__func__, d, *shadow_count);
-		klp_shadow_free(d, SV_COUNTER, NULL);
+		klp_shadow_free(d, &shadow_counter_type);
 	}
 
 	kfree(d);
 }
 
+static struct klp_shadow_type shadow_leak_type = {
+	.id = SV_LEAK,
+	.dtor = livepatch_fix2_dummy_leak_dtor,
+};
+
+static struct klp_shadow_type shadow_counter_type = {
+	.id = SV_COUNTER,
+};
+
 static struct klp_func funcs[] = {
 	{
 		.old_name = "dummy_check",
@@ -123,7 +134,7 @@ static int livepatch_shadow_fix2_init(void)
 static void livepatch_shadow_fix2_exit(void)
 {
 	/* Cleanup any existing SV_COUNTER shadow variables */
-	klp_shadow_free_all(SV_COUNTER, NULL);
+	klp_shadow_free_all(&shadow_leak_type);
 }
 
 module_init(livepatch_shadow_fix2_init);
diff --git a/tools/testing/selftests/livepatch/test-shadow-vars.sh b/tools/testing/selftests/livepatch/test-shadow-vars.sh
index e04cb354f56b..01ef65bc1f0c 100755
--- a/tools/testing/selftests/livepatch/test-shadow-vars.sh
+++ b/tools/testing/selftests/livepatch/test-shadow-vars.sh
@@ -67,7 +67,7 @@ $MOD_TEST: klp_shadow_get(obj=PTR9, id=0x1235) = PTR11
 $MOD_TEST:   got expected PTR11 -> PTR10 result
 $MOD_TEST: klp_shadow_get(obj=PTR14, id=0x1235) = PTR16
 $MOD_TEST:   got expected PTR16 -> PTR15 result
-$MOD_TEST: klp_shadow_free_all(id=0x1235, dtor=PTR0)
+$MOD_TEST: klp_shadow_free_all(id=0x1235, dtor=PTR17)
 $MOD_TEST: klp_shadow_get(obj=PTR1, id=0x1235) = PTR0
 $MOD_TEST:   got expected NULL result
 $MOD_TEST: klp_shadow_get(obj=PTR9, id=0x1235) = PTR0
-- 
2.37.3

