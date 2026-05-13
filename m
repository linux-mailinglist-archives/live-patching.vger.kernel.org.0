Return-Path: <live-patching+bounces-2805-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yEyiBzWOBGoALgIAu9opvQ
	(envelope-from <live-patching+bounces-2805-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 16:44:05 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 17F8B535583
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 16:44:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E596A307A325
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 14:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D27A349CCE;
	Wed, 13 May 2026 14:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qQ7GZsuu"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CB740B6C4
	for <live-patching@vger.kernel.org>; Wed, 13 May 2026 14:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778682869; cv=none; b=pldHSRy4+4WXGnM9wetNuSZbptTrD4oiCGxH9bE6rVto/tGC4RaZl1LP240c1bdc/J76Ta22rCXx/pIy+M8M2AtJfNLYVTh0hKXGZ0K5mcv9Rj8hZmgvyl/kPLbaz2dANQ6O1f2wnRLvhOuIIqhICz2cYSSSbVP2ddGBgBmbn1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778682869; c=relaxed/simple;
	bh=hZFicFquxYtfO5mLpd1u3K0Uzyc0WUCMir+LZ66A3sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TyoMtn3j8bM16ksPWcX/KD4jOiA/t2dEKP7MitmaHx4pWgzLXqdIWfjnx7aGK44dUoRJa7Uaf3Vm/leT9QQ3OWa8aQCu8nzja4zMXof/VCynoqo7wswziZGfcirG2GtQfPpwiWgRg8KIpXUrZ48dIiVr3CFpC6uZZa0Fs7QBOz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qQ7GZsuu; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c801b30188dso3015556a12.3
        for <live-patching@vger.kernel.org>; Wed, 13 May 2026 07:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778682867; x=1779287667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a/CrZO7WeX011tyu8fc4oKQ4F5y7Mh/S66T31FiumP0=;
        b=qQ7GZsuunaLqgYAyufipt3+dwz3xQShTgwpSw11fhfQw4Xl6QCyK/+ThXFgsw0wqPw
         Oao/PcB2T9PaKWJPn1uNVeq2dI+JcXWmqVWZvybtg6ZfAljaC1CiwX9qMbCfy+dEHPXp
         lrARcIo4V4twkHSSfyELPuoeKEWta81xjrkJE0UCLbYW3chXHx6FcTIjmWC7DOmmGJMw
         1xHYl3W91qq4+AHpJ7ti+DZIb0cwExyMnrrn8YKxtGVwYxGUUIvFS9xQjG2hO/OgtnCF
         x7KkcsLiZglhvus8wjM5D5YYpRPKZm55hbayj97TG6JBG8s7PnJ2FB1ghxy6skN34l1I
         egzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778682867; x=1779287667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a/CrZO7WeX011tyu8fc4oKQ4F5y7Mh/S66T31FiumP0=;
        b=WO4NX5eRGciYjMR1TXpXt2zdRb6mGI/htYinWgHZ4ZrAr+kM/90HpcbOWPzNoWx5VX
         3eyjRmmopbmp3SRhY0/53JoDX/PlvGgC+tqX72vfNqA0ppoS2G1iG4C+dwB5aU3JxTtP
         WaYfSsb7LK1fxw4VZrFa+QJ58Lw4/mfzOVq7wKWKA/KcJeQ0qxLaevC+FiIBpS0bNiJT
         Dh4x4CsQkRHIixdCjA22uMARFc1iRi0YGdY5oJAoaIf7Tw4TmdrbXJKQkVAIzx5DnGOM
         Zs2ZAhW7iHxOGTs7N6qeDSyPEE2kZdFTMMmV4R0ZfOjs+nrrtkpk7/CtAUW0CVfYAD38
         7Cfg==
X-Gm-Message-State: AOJu0YwW4VgG73f+l0P+UW9obHy6ycCJ2eulvUTMVOrZzMTcGd4+UKHK
	aaXkIz382Jj59ewK1TH0I7Km/vri3DnisYY++9xmAyFWObMy0poP/gBG
X-Gm-Gg: Acq92OG7yoIT+Wx2dmsT17mJHzm9EZB9IBFvzpyJG6D8yNvcTyL+TuYe3NB5nYoqXCe
	TuFP66GvXyAAU2GHIwZUwL3ODXTkRLR1LN/LY0Ebhv8d1a3YR/gZVwFaoYFnLCHchkEkmaWaOZ9
	a/FggyX8q0Z40SAu7mBJUtE82HtAJeg/MYFEhi++Z/xnQuPRW21lIwvtvg7xg6WnSlF2OvidQZ9
	LOX6QXxZjU/beF9MgLMY05e+BIO8D3FagKuxugKYCHRgGwwSknraeR2p7Px7XBBP7CtHvkHs0Iu
	d5M/8RjFMcAgypPrRDvmokrB4WBsvCh1Kj5ISivi24zIVeJWmx8KdiKgRyP6eSiz3TDdI/A6CIK
	JrIPkoFYcj3bkGeEImqqs2k4FGLc9A+LVJK3yQRw1QFtRCr7wIR42DfSFJZTE1oV7egv/5SFqiD
	j0eME86uTJgOKyXbJpeA7PETvVKXX298dARiwafhtfkIC9YeAFwt09R7kcbUom0+BjIR0BDiGyH
	Jq0DBqH9tg+xf8=
X-Received: by 2002:a05:6a20:2592:b0:3a3:a55f:4055 with SMTP id adf61e73a8af0-3af84327859mr4002847637.54.1778682866601;
        Wed, 13 May 2026 07:34:26 -0700 (PDT)
Received: from localhost.localdomain ([240e:46c:2200:3c3:e555:e58a:71d1:ef1d])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c826771018bsm15006418a12.17.2026.05.13.07.34.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 07:34:26 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	song@kernel.org
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH 6/6] livepatch: Support replace_set in shadow variable API
Date: Wed, 13 May 2026 22:33:21 +0800
Message-ID: <20260513143321.26185-7-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513143321.26185-1-laoar.shao@gmail.com>
References: <20260513143321.26185-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 17F8B535583
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2805-lists,live-patching=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[live-patching];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

To support more complex livepatching scenarios where multiple
replacement sets might coexist, extend the klp_shadow API to
include a 'replace_set' identifier.

To maintain compatibility with the existing 64-bit storage in
'struct klp_shadow', the internal @id is now treated as a composite
value. The 64-bit identifier is constructed by packing two 32-bit
values:

  MSB (63-32)          LSB (31-0)
  +--------------------+--------------------+
  |    replace_set     |    original @id    |
  +--------------------+--------------------+

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/livepatch.h | 12 ++++---
 kernel/livepatch/shadow.c | 70 ++++++++++++++++++++++++---------------
 kernel/livepatch/state.c  |  3 +-
 3 files changed, 52 insertions(+), 33 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 221f176f1f51..2dd9fca8c01c 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -195,15 +195,17 @@ static inline bool klp_have_reliable_stack(void)
 	       IS_ENABLED(CONFIG_HAVE_RELIABLE_STACKTRACE);
 }
 
-void *klp_shadow_get(void *obj, unsigned long id);
-void *klp_shadow_alloc(void *obj, unsigned long id,
+void *klp_shadow_get(void *obj, unsigned int replace_set, unsigned int id);
+void *klp_shadow_alloc(void *obj, unsigned int replace_set, unsigned int id,
 		       size_t size, gfp_t gfp_flags,
 		       klp_shadow_ctor_t ctor, void *ctor_data);
-void *klp_shadow_get_or_alloc(void *obj, unsigned long id,
+void *klp_shadow_get_or_alloc(void *obj, unsigned int replace_set, unsigned int id,
 			      size_t size, gfp_t gfp_flags,
 			      klp_shadow_ctor_t ctor, void *ctor_data);
-void klp_shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor);
-void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor);
+void klp_shadow_free(void *obj, unsigned int replace_set, unsigned int id,
+		     klp_shadow_dtor_t dtor);
+void klp_shadow_free_all(unsigned int replace_set, unsigned int id,
+			 klp_shadow_dtor_t dtor);
 
 struct klp_state *klp_get_state(struct klp_patch *patch, unsigned long id);
 struct klp_state *klp_get_prev_state(unsigned long id);
diff --git a/kernel/livepatch/shadow.c b/kernel/livepatch/shadow.c
index c2e724d97ddf..35e507fae445 100644
--- a/kernel/livepatch/shadow.c
+++ b/kernel/livepatch/shadow.c
@@ -48,7 +48,8 @@ static DEFINE_SPINLOCK(klp_shadow_lock);
  * @node:	klp_shadow_hash hash table node
  * @rcu_head:	RCU is used to safely free this structure
  * @obj:	pointer to parent object
- * @id:		data identifier
+ * @id:		combined data identifier
+ *		higher 32 bits: replace_set, lower 32 bits: resource ID
  * @data:	data area
  */
 struct klp_shadow {
@@ -59,6 +60,11 @@ struct klp_shadow {
 	char data[];
 };
 
+static unsigned long klp_shadow_combined_id(unsigned int set, unsigned int id)
+{
+	return ((unsigned long)set << 32) | id;
+}
+
 /**
  * klp_shadow_match() - verify a shadow variable matches given <obj, id>
  * @shadow:	shadow variable to match
@@ -76,11 +82,12 @@ static inline bool klp_shadow_match(struct klp_shadow *shadow, void *obj,
 /**
  * klp_shadow_get() - retrieve a shadow variable data pointer
  * @obj:	pointer to parent object
+ * @replace_set:identifier for the livepatch replacement set
  * @id:		data identifier
  *
  * Return: the shadow variable data element, NULL on failure.
  */
-void *klp_shadow_get(void *obj, unsigned long id)
+void *klp_shadow_get(void *obj, unsigned int replace_set, unsigned int id)
 {
 	struct klp_shadow *shadow;
 
@@ -89,7 +96,8 @@ void *klp_shadow_get(void *obj, unsigned long id)
 	hash_for_each_possible_rcu(klp_shadow_hash, shadow, node,
 				   (unsigned long)obj) {
 
-		if (klp_shadow_match(shadow, obj, id)) {
+		if (klp_shadow_match(shadow, obj,
+				     klp_shadow_combined_id(replace_set, id))) {
 			rcu_read_unlock();
 			return shadow->data;
 		}
@@ -101,7 +109,7 @@ void *klp_shadow_get(void *obj, unsigned long id)
 }
 EXPORT_SYMBOL_GPL(klp_shadow_get);
 
-static void *__klp_shadow_get_or_alloc(void *obj, unsigned long id,
+static void *__klp_shadow_get_or_alloc(void *obj, unsigned int set, unsigned int id,
 				       size_t size, gfp_t gfp_flags,
 				       klp_shadow_ctor_t ctor, void *ctor_data,
 				       bool warn_on_exist)
@@ -111,7 +119,7 @@ static void *__klp_shadow_get_or_alloc(void *obj, unsigned long id,
 	unsigned long flags;
 
 	/* Check if the shadow variable already exists */
-	shadow_data = klp_shadow_get(obj, id);
+	shadow_data = klp_shadow_get(obj, set, id);
 	if (shadow_data)
 		goto exists;
 
@@ -126,7 +134,7 @@ static void *__klp_shadow_get_or_alloc(void *obj, unsigned long id,
 
 	/* Look for <obj, id> again under the lock */
 	spin_lock_irqsave(&klp_shadow_lock, flags);
-	shadow_data = klp_shadow_get(obj, id);
+	shadow_data = klp_shadow_get(obj, set, id);
 	if (unlikely(shadow_data)) {
 		/*
 		 * Shadow variable was found, throw away speculative
@@ -147,8 +155,8 @@ static void *__klp_shadow_get_or_alloc(void *obj, unsigned long id,
 		if (err) {
 			spin_unlock_irqrestore(&klp_shadow_lock, flags);
 			kfree(new_shadow);
-			pr_err("Failed to construct shadow variable <%p, %lx> (%d)\n",
-			       obj, id, err);
+			pr_err("Failed to construct shadow variable <%p, %x, %x> (%d)\n",
+			       obj, set, id, err);
 			return NULL;
 		}
 	}
@@ -162,7 +170,7 @@ static void *__klp_shadow_get_or_alloc(void *obj, unsigned long id,
 
 exists:
 	if (warn_on_exist) {
-		WARN(1, "Duplicate shadow variable <%p, %lx>\n", obj, id);
+		WARN(1, "Duplicate shadow variable <%p, %x, %x>\n", obj, set, id);
 		return NULL;
 	}
 
@@ -172,6 +180,7 @@ static void *__klp_shadow_get_or_alloc(void *obj, unsigned long id,
 /**
  * klp_shadow_alloc() - allocate and add a new shadow variable
  * @obj:	pointer to parent object
+ * @replace_set:identifier for the livepatch replacement set
  * @id:		data identifier
  * @size:	size of attached data
  * @gfp_flags:	GFP mask for allocation
@@ -183,8 +192,8 @@ static void *__klp_shadow_get_or_alloc(void *obj, unsigned long id,
  * function if it is not NULL.  The new shadow variable is then added
  * to the global hashtable.
  *
- * If an existing <obj, id> shadow variable can be found, this routine will
- * issue a WARN, exit early and return NULL.
+ * If an existing <obj, replace_set, id> shadow variable can be found, this
+ * routine will issue a WARN, exit early and return NULL.
  *
  * This function guarantees that the constructor function is called only when
  * the variable did not exist before.  The cost is that @ctor is called
@@ -193,11 +202,11 @@ static void *__klp_shadow_get_or_alloc(void *obj, unsigned long id,
  * Return: the shadow variable data element, NULL on duplicate or
  * failure.
  */
-void *klp_shadow_alloc(void *obj, unsigned long id,
+void *klp_shadow_alloc(void *obj, unsigned int replace_set, unsigned int id,
 		       size_t size, gfp_t gfp_flags,
 		       klp_shadow_ctor_t ctor, void *ctor_data)
 {
-	return __klp_shadow_get_or_alloc(obj, id, size, gfp_flags,
+	return __klp_shadow_get_or_alloc(obj, replace_set, id, size, gfp_flags,
 					 ctor, ctor_data, true);
 }
 EXPORT_SYMBOL_GPL(klp_shadow_alloc);
@@ -205,28 +214,29 @@ EXPORT_SYMBOL_GPL(klp_shadow_alloc);
 /**
  * klp_shadow_get_or_alloc() - get existing or allocate a new shadow variable
  * @obj:	pointer to parent object
+ * @replace_set:identifier for the livepatch replacement set
  * @id:		data identifier
  * @size:	size of attached data
  * @gfp_flags:	GFP mask for allocation
  * @ctor:	custom constructor to initialize the shadow data (optional)
  * @ctor_data:	pointer to any data needed by @ctor (optional)
  *
- * Returns a pointer to existing shadow data if an <obj, id> shadow
+ * Returns a pointer to existing shadow data if an <obj, replace_set, id> shadow
  * variable is already present.  Otherwise, it creates a new shadow
  * variable like klp_shadow_alloc().
  *
  * This function guarantees that only one shadow variable exists with the given
- * @id for the given @obj.  It also guarantees that the constructor function
- * will be called only when the variable did not exist before.  The cost is
- * that @ctor is called in atomic context under a spin lock.
+ * @id for the given @obj within the same replace_set.  It also guarantees that
+ * the constructor function will be called only when the variable did not exist
+ * before.  The cost is that @ctor is called in atomic context under a spin lock.
  *
  * Return: the shadow variable data element, NULL on failure.
  */
-void *klp_shadow_get_or_alloc(void *obj, unsigned long id,
-			      size_t size, gfp_t gfp_flags,
+void *klp_shadow_get_or_alloc(void *obj, unsigned int replace_set,
+			      unsigned int id, size_t size, gfp_t gfp_flags,
 			      klp_shadow_ctor_t ctor, void *ctor_data)
 {
-	return __klp_shadow_get_or_alloc(obj, id, size, gfp_flags,
+	return __klp_shadow_get_or_alloc(obj, replace_set, id, size, gfp_flags,
 					 ctor, ctor_data, false);
 }
 EXPORT_SYMBOL_GPL(klp_shadow_get_or_alloc);
@@ -243,14 +253,16 @@ static void klp_shadow_free_struct(struct klp_shadow *shadow,
 /**
  * klp_shadow_free() - detach and free a <obj, id> shadow variable
  * @obj:	pointer to parent object
+ * @replace_set:identifier for the livepatch replacement set
  * @id:		data identifier
  * @dtor:	custom callback that can be used to unregister the variable
  *		and/or free data that the shadow variable points to (optional)
  *
- * This function releases the memory for this <obj, id> shadow variable
+ * This function releases the memory for this <obj, replace_set, id> shadow variable
  * instance, callers should stop referencing it accordingly.
  */
-void klp_shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor)
+void klp_shadow_free(void *obj, unsigned int replace_set, unsigned int id,
+		     klp_shadow_dtor_t dtor)
 {
 	struct klp_shadow *shadow;
 	unsigned long flags;
@@ -261,7 +273,8 @@ void klp_shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor)
 	hash_for_each_possible(klp_shadow_hash, shadow, node,
 			       (unsigned long)obj) {
 
-		if (klp_shadow_match(shadow, obj, id)) {
+		if (klp_shadow_match(shadow, obj,
+				     klp_shadow_combined_id(replace_set, id))) {
 			klp_shadow_free_struct(shadow, dtor);
 			break;
 		}
@@ -272,15 +285,17 @@ void klp_shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor)
 EXPORT_SYMBOL_GPL(klp_shadow_free);
 
 /**
- * klp_shadow_free_all() - detach and free all <_, id> shadow variables
+ * klp_shadow_free_all() - detach and free all <_, replace_set, id> shadow variables
+ * @replace_set:identifier for the livepatch replacement set
  * @id:		data identifier
  * @dtor:	custom callback that can be used to unregister the variable
  *		and/or free data that the shadow variable points to (optional)
  *
- * This function releases the memory for all <_, id> shadow variable
+ * This function releases the memory for all <_, replace_set, id> shadow variable
  * instances, callers should stop referencing them accordingly.
  */
-void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor)
+void klp_shadow_free_all(unsigned int replace_set, unsigned int id,
+			 klp_shadow_dtor_t dtor)
 {
 	struct klp_shadow *shadow;
 	unsigned long flags;
@@ -290,7 +305,8 @@ void klp_shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor)
 
 	/* Delete all <_, id> from hash */
 	hash_for_each(klp_shadow_hash, i, shadow, node) {
-		if (klp_shadow_match(shadow, shadow->obj, id))
+		if (klp_shadow_match(shadow, shadow->obj,
+				     klp_shadow_combined_id(replace_set, id)))
 			klp_shadow_free_struct(shadow, dtor);
 	}
 
diff --git a/kernel/livepatch/state.c b/kernel/livepatch/state.c
index 43115e8e8453..6e3d6fb92e64 100644
--- a/kernel/livepatch/state.c
+++ b/kernel/livepatch/state.c
@@ -203,7 +203,8 @@ void klp_states_post_unpatch(struct klp_patch *patch)
 			state->callbacks.post_unpatch(patch, state);
 
 		if (state->is_shadow)
-			klp_shadow_free_all(state->id, state->callbacks.shadow_dtor);
+			klp_shadow_free_all(patch->replace_set, state->id,
+					    state->callbacks.shadow_dtor);
 
 		state->callbacks.pre_patch_succeeded = 0;
 	}
-- 
2.47.3


