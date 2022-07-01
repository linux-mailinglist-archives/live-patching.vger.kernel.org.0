Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111C4563A23
	for <lists+live-patching@lfdr.de>; Fri,  1 Jul 2022 21:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbiGATsn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 1 Jul 2022 15:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiGATsm (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 1 Jul 2022 15:48:42 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2273F24F11
        for <live-patching@vger.kernel.org>; Fri,  1 Jul 2022 12:48:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CB7EB222DC;
        Fri,  1 Jul 2022 19:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656704919; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XeR3QiHp++m0PGDRGRTUC3LIuqgqu3kcW+3gbWQoKYg=;
        b=BWD7E/rjYT90IRKKONrmPDcbXs3uU6JMqcSoM2JW9vkRHD/kLpB3eCPB3HRrJpY/6KCPq8
        zr2yBfjhf3fqz9WrMh3sfnb2/ezqK30AtK6tstWRMke1wUz7O7rXt3cXFYha7O/ROnGhWP
        YNIYjsQnKve6zRX9y4yvDxRL0MKg5Ss=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 30F0A13A20;
        Fri,  1 Jul 2022 19:48:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yE3YOZVPv2JTTgAAMHmgww
        (envelope-from <mpdesouza@suse.com>); Fri, 01 Jul 2022 19:48:37 +0000
From:   Marcos Paulo de Souza <mpdesouza@suse.com>
To:     live-patching@vger.kernel.org
Cc:     jpoimboe@redhat.com, mbenes@suse.cz, pmladek@suse.com,
        nstange@suse.de
Subject: [PATCH 1/4] livepatch/shadow: Separate code to get or use pre-allocated shadow variable
Date:   Fri,  1 Jul 2022 16:48:14 -0300
Message-Id: <20220701194817.24655-2-mpdesouza@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220701194817.24655-1-mpdesouza@suse.com>
References: <20220701194817.24655-1-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>

Separate code that is used in klp_shadow_get_or_alloc() under klp_mutex.
It splits a long spaghetti function into two. Also it unifies the error
handling. The old used a mix of duplicated code, direct returns,
and goto. The new code has only one unlock, free, and return calls.

Background: The change was needed by an earlier variant of the code adding
	garbage collection of shadow variables. It is not needed in
	the end. But the change still looks like an useful clean up.

It is code refactoring without any functional changes.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/livepatch/shadow.c | 77 ++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 34 deletions(-)

diff --git a/kernel/livepatch/shadow.c b/kernel/livepatch/shadow.c
index c2e724d97ddf..67c1313f6831 100644
--- a/kernel/livepatch/shadow.c
+++ b/kernel/livepatch/shadow.c
@@ -101,41 +101,19 @@ void *klp_shadow_get(void *obj, unsigned long id)
 }
 EXPORT_SYMBOL_GPL(klp_shadow_get);
 
-static void *__klp_shadow_get_or_alloc(void *obj, unsigned long id,
-				       size_t size, gfp_t gfp_flags,
-				       klp_shadow_ctor_t ctor, void *ctor_data,
-				       bool warn_on_exist)
+static void *__klp_shadow_get_or_use(void *obj, unsigned long id,
+				     struct klp_shadow *new_shadow,
+				     klp_shadow_ctor_t ctor, void *ctor_data,
+				     bool *exist)
 {
-	struct klp_shadow *new_shadow;
 	void *shadow_data;
-	unsigned long flags;
-
-	/* Check if the shadow variable already exists */
-	shadow_data = klp_shadow_get(obj, id);
-	if (shadow_data)
-		goto exists;
-
-	/*
-	 * Allocate a new shadow variable.  Fill it with zeroes by default.
-	 * More complex setting can be done by @ctor function.  But it is
-	 * called only when the buffer is really used (under klp_shadow_lock).
-	 */
-	new_shadow = kzalloc(size + sizeof(*new_shadow), gfp_flags);
-	if (!new_shadow)
-		return NULL;
 
-	/* Look for <obj, id> again under the lock */
-	spin_lock_irqsave(&klp_shadow_lock, flags);
 	shadow_data = klp_shadow_get(obj, id);
 	if (unlikely(shadow_data)) {
-		/*
-		 * Shadow variable was found, throw away speculative
-		 * allocation.
-		 */
-		spin_unlock_irqrestore(&klp_shadow_lock, flags);
-		kfree(new_shadow);
-		goto exists;
+		*exist = true;
+		return shadow_data;
 	}
+	*exist = false;
 
 	new_shadow->obj = obj;
 	new_shadow->id = id;
@@ -145,8 +123,6 @@ static void *__klp_shadow_get_or_alloc(void *obj, unsigned long id,
 
 		err = ctor(obj, new_shadow->data, ctor_data);
 		if (err) {
-			spin_unlock_irqrestore(&klp_shadow_lock, flags);
-			kfree(new_shadow);
 			pr_err("Failed to construct shadow variable <%p, %lx> (%d)\n",
 			       obj, id, err);
 			return NULL;
@@ -156,12 +132,45 @@ static void *__klp_shadow_get_or_alloc(void *obj, unsigned long id,
 	/* No <obj, id> found, so attach the newly allocated one */
 	hash_add_rcu(klp_shadow_hash, &new_shadow->node,
 		     (unsigned long)new_shadow->obj);
-	spin_unlock_irqrestore(&klp_shadow_lock, flags);
 
 	return new_shadow->data;
+}
+
+static void *__klp_shadow_get_or_alloc(void *obj, unsigned long id,
+				       size_t size, gfp_t gfp_flags,
+				       klp_shadow_ctor_t ctor, void *ctor_data,
+				       bool warn_on_exist)
+{
+	struct klp_shadow *new_shadow;
+	void *shadow_data;
+	bool exist;
+	unsigned long flags;
+
+	/* Check if the shadow variable already exists */
+	shadow_data = klp_shadow_get(obj, id);
+	if (shadow_data)
+		return shadow_data;
+
+	/*
+	 * Allocate a new shadow variable.  Fill it with zeroes by default.
+	 * More complex setting can be done by @ctor function.  But it is
+	 * called only when the buffer is really used (under klp_shadow_lock).
+	 */
+	new_shadow = kzalloc(size + sizeof(*new_shadow), gfp_flags);
+	if (!new_shadow)
+		return NULL;
+
+	/* Look for <obj, id> again under the lock */
+	spin_lock_irqsave(&klp_shadow_lock, flags);
+	shadow_data = __klp_shadow_get_or_use(obj, id, new_shadow,
+					      ctor, ctor_data, &exist);
+	spin_unlock_irqrestore(&klp_shadow_lock, flags);
+
+	/* Throw away unused speculative allocation. */
+	if (!shadow_data || exist)
+		kfree(new_shadow);
 
-exists:
-	if (warn_on_exist) {
+	if (exist && warn_on_exist) {
 		WARN(1, "Duplicate shadow variable <%p, %lx>\n", obj, id);
 		return NULL;
 	}
-- 
2.35.3

