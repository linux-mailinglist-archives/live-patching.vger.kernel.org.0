Return-Path: <live-patching+bounces-2804-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QDZeCPKYBGpiLwIAu9opvQ
	(envelope-from <live-patching+bounces-2804-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 17:29:54 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 777D2536250
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 17:29:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 67A99326C344
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 14:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1494943D4EC;
	Wed, 13 May 2026 14:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mr9/ph5J"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0710443C04B
	for <live-patching@vger.kernel.org>; Wed, 13 May 2026 14:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778682865; cv=none; b=D7ewbnpedW+p2NsjlTN0sflfJM12Kbrd03Ykx0ic5sUZyg0OxsACpeIGhu6VmNxIuOVbEFYTW1EgEh6nQeqKiDOikuculCxPmclzl0+c9Pu1mRZemZsazqSz7hF81eHo7DPFN1OTk7M79XK9/Eqp0yYChaCqLuxBsxYZpcPXSmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778682865; c=relaxed/simple;
	bh=ZTK57FPR0fRH176q3hZ4E8zWXqmRTFGyn13aOYEGdlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpDEePXnY9GijeiQWkuL3WdY8IH5J5AwQumX183F8ySysLwngIH1L0FOPqodjD4QSsG7qrFPOQQvWT5QGjKN3t6/8TciuXcX6/h+lHx3yJaPkGfW9+uo1lFGpOVk5jYx6n2c9Apzzd9s9f3+Uw/8ph7WAQPzK4EerH4Jfq/GXcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mr9/ph5J; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c828daf83e2so1773551a12.2
        for <live-patching@vger.kernel.org>; Wed, 13 May 2026 07:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778682862; x=1779287662; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LbTGwcT4+2y+ODg3LUQ6agKvi3RZJcLWM5ra2jzAlRE=;
        b=mr9/ph5Jfkc+uQvZTvAP2QRfZloVlbcR3Wt6FU3mnKfWgpac9Zpo4HWugSJg7hofNk
         Qa25SepR6C0EVdq3GBEzW2BFe1960ocp46eRI2jvh1tb4AGQ6mqzbJnQzw59laxxD83O
         oO9A2LN18x/lDPn0zhU0d3jf00mGhEg56n/aaPO7ZW8Ptip+MzYzySvo1FVhtoOcGprS
         41o2Pfnu4svcsJduhZ8Hf30GaWG4YkRe5Mp0CmMP9mz4Ly4KPjea2XfuvLgoOL1SzNzP
         Nx+UCm5mJVrWpShf+r1hWobKn7R9pYpmNLO8uLNzKoJeDg84AnCMiLZCC/HuCPsD0t6D
         xrDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778682862; x=1779287662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LbTGwcT4+2y+ODg3LUQ6agKvi3RZJcLWM5ra2jzAlRE=;
        b=bEhlSMis5fMQQGMcz6ZaF8euLldTVqlcKjFUQ8yT9N0oCijIkaXPWssLjO6KH2jKuZ
         fphnOQeiAqa8QypC8uxopIGUQETEEj1AaGJXWqwO2jee2s860ht9Nfy2NILyj77A4siK
         9OvzaNU5foKcTFgXito2HG47TYj3bP+mIk1f+puwsy5xGRrXvIHiqy3kX7aNwb7VnNuU
         nYSImZ4OTN0BZnCqB/NHfF4CVMkkYpbjvSZ/thhnslUd8hr4YjOUZI3yeEORZpAVO3w7
         ICdGp3iIuoWVMOZiuKrGMiHz8AH3fph6/smKSVNqDnufMiertJS3EykfMLH+QiLB9NWm
         oxQA==
X-Gm-Message-State: AOJu0Yzh+x7mnzZ4bwGzYFo7DQrr75fvkKBtVOs7lfAnDJXM1UFqcwwN
	Kgslb+QbqXogDlod0UoJjtj3gXBysZte7+7lwduUiFCYv/fP2mCT0zd4
X-Gm-Gg: Acq92OE2Qsub+Uia/1fHGvA65dK8mvXrRCQmHrtxq4j70HOmIKmxYJzWQSjpNcTckfh
	w80nIGgK9yShiiclLZLSQE5e2BLrJRh9U1rmw3aAMVAyQlHEUnE6vaXYBueCMPBlVWU1V9JYT2Q
	dPF8l7LYSkgV1srreFgW2xIl4giFYWncU2t9JFKn8WZi/bY7fWG0CBf6AficvPQvWYA2/V3AZHy
	1DXva2siDq8VtUEHYHakaCcl7CXSuaoLQRHsJG6/jIyrVMO5DKC2wlHKX9qYqKCfgzbtTMh2bcm
	qgw8kiV9t4GNco6fNK37az/bkHRfb1vQuoR2Zuj8qkMDz02l6gkkdBh7iTUQH09+AoTt1GpTBBN
	5quHYyiYCjw9mkwAhzzgZeveJ+OTvXfm9j6QQAWbIPmCKffi2kNADRESOWDAzBBX/YvZhs/WdBd
	A2CiNTHINRtlpHrqrz5pHehPKG4WIMwFB/QPhd77RLYofChSVA6arNWN1TDElajLZo27/WT4J3+
	rL9U44c0RlSOPs=
X-Received: by 2002:a05:6300:210e:b0:3a1:2dbd:c30 with SMTP id adf61e73a8af0-3afb1a11236mr3672258637.45.1778682861843;
        Wed, 13 May 2026 07:34:21 -0700 (PDT)
Received: from localhost.localdomain ([240e:46c:2200:3c3:e555:e58a:71d1:ef1d])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c826771018bsm15006418a12.17.2026.05.13.07.34.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 07:34:21 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	song@kernel.org
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH 5/6] livepatch: Remove obsolete per-object callbacks
Date: Wed, 13 May 2026 22:33:20 +0800
Message-ID: <20260513143321.26185-6-laoar.shao@gmail.com>
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
X-Rspamd-Queue-Id: 777D2536250
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2804-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email]
X-Rspamd-Action: no action

This commit removes the obsolete per-object callbacks from the livepatch
framework.  All selftests have been migrated to the new per-state
callbacks, making the per-object callbacks redundant.

Instead, use the new per-state callbacks. They offer improved semantics
by associating callbacks and shadow variables with a specific state,
enabling better lifetime management of changes.

Originally-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/livepatch.h                | 40 ---------------
 include/linux/livepatch_external.h       | 62 +++++++++++++++---------
 kernel/livepatch/core.c                  | 29 -----------
 kernel/livepatch/core.h                  | 33 -------------
 kernel/livepatch/transition.c            |  9 ----
 scripts/livepatch/init.c                 |  2 -
 tools/include/linux/livepatch_external.h | 62 +++++++++++++++---------
 tools/objtool/klp-diff.c                 | 16 +++---
 8 files changed, 84 insertions(+), 169 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 340b04a0de83..221f176f1f51 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -95,7 +95,6 @@ struct klp_object {
 	/* external */
 	const char *name;
 	struct klp_func *funcs;
-	struct klp_callbacks callbacks;
 
 	/* internal */
 	struct kobject kobj;
@@ -106,45 +105,6 @@ struct klp_object {
 	bool patched;
 };
 
-struct klp_patch;
-struct klp_state;
-
-typedef int (*klp_shadow_ctor_t)(void *obj,
-				 void *shadow_data,
-				 void *ctor_data);
-typedef void (*klp_shadow_dtor_t)(void *obj, void *shadow_data);
-
-/**
- * struct klp_state_callbacks - callbacks manipulating the state
- * @pre_patch:		 executed only when the state is being enabled
- *			 before code patching
- * @post_patch:		 executed only when the state is being enabled
- *			 after code patching
- * @pre_unpatch:	 executed only when the state is being disabled
- *			 before code unpatching
- * @post_unpatch:	 executed only when the state is being disabled
- *			 after code unpatching
- * @shadow_dtor:	 destructor for the related shadow variable
- * @pre_patch_succeeded: internal state used by a rollback on error
- *
- * All callbacks are optional.
- *
- * @pre_patch callback returns 0 on success and an error code otherwise.
- *
- * Any error prevents enabling the livepatch. @post_unpatch() callbacks are
- * then called to rollback @pre_patch callbacks which has already succeeded
- * before. Also @post_patch callbacks are called for to-be-removed states
- * to rollback pre_unpatch() callbacks when they were called.
- */
-struct klp_state_callbacks {
-	int (*pre_patch)(struct klp_patch *patch, struct klp_state *state);
-	void (*post_patch)(struct klp_patch *patch, struct klp_state *state);
-	void (*pre_unpatch)(struct klp_patch *patch, struct klp_state *state);
-	void (*post_unpatch)(struct klp_patch *patch, struct klp_state *state);
-	klp_shadow_dtor_t shadow_dtor;
-	bool pre_patch_succeeded;
-};
-
 /**
  * struct klp_state - state of the system modified by the livepatch
  * @id:		system state identifier (non-zero)
diff --git a/include/linux/livepatch_external.h b/include/linux/livepatch_external.h
index 138af19b0f5c..d9123d0c5dff 100644
--- a/include/linux/livepatch_external.h
+++ b/include/linux/livepatch_external.h
@@ -21,33 +21,48 @@
 #define KLP_PRE_UNPATCH_PREFIX		__stringify(__KLP_PRE_UNPATCH_PREFIX)
 #define KLP_POST_UNPATCH_PREFIX		__stringify(__KLP_POST_UNPATCH_PREFIX)
 
-struct klp_object;
-
-typedef int (*klp_pre_patch_t)(struct klp_object *obj);
-typedef void (*klp_post_patch_t)(struct klp_object *obj);
-typedef void (*klp_pre_unpatch_t)(struct klp_object *obj);
-typedef void (*klp_post_unpatch_t)(struct klp_object *obj);
+struct klp_state;
+struct klp_patch;
+typedef int (*klp_shadow_ctor_t)(void *obj,
+				 void *shadow_data,
+				 void *ctor_data);
+typedef void (*klp_shadow_dtor_t)(void *obj, void *shadow_data);
 
 /**
- * struct klp_callbacks - pre/post live-(un)patch callback structure
- * @pre_patch:		executed before code patching
- * @post_patch:		executed after code patching
- * @pre_unpatch:	executed before code unpatching
- * @post_unpatch:	executed after code unpatching
- * @post_unpatch_enabled:	flag indicating if post-unpatch callback
- *				should run
+ * struct klp_state_callbacks - callbacks manipulating the state
+ * @pre_patch:		 executed only when the state is being enabled
+ *			 before code patching
+ * @post_patch:		 executed only when the state is being enabled
+ *			 after code patching
+ * @pre_unpatch:	 executed only when the state is being disabled
+ *			 before code unpatching
+ * @post_unpatch:	 executed only when the state is being disabled
+ *			 after code unpatching
+ * @shadow_dtor:	 destructor for the related shadow variable
+ * @pre_patch_succeeded: internal state used by a rollback on error
+ *
+ * All callbacks are optional.
+ *
+ * @pre_patch callback returns 0 on success and an error code otherwise.
  *
- * All callbacks are optional.  Only the pre-patch callback, if provided,
- * will be unconditionally executed.  If the parent klp_object fails to
- * patch for any reason, including a non-zero error status returned from
- * the pre-patch callback, no further callbacks will be executed.
+ * Any error prevents enabling the livepatch. @post_unpatch() callbacks are
+ * then called to rollback @pre_patch callbacks which has already succeeded
+ * before. Also @post_patch callbacks are called for to-be-removed states
+ * to rollback pre_unpatch() callbacks when they were called.
  */
-struct klp_callbacks {
-	klp_pre_patch_t		pre_patch;
-	klp_post_patch_t	post_patch;
-	klp_pre_unpatch_t	pre_unpatch;
-	klp_post_unpatch_t	post_unpatch;
-	bool post_unpatch_enabled;
+struct klp_state_callbacks {
+	int (*pre_patch)(struct klp_patch *patch, struct klp_state *state);
+	void (*post_patch)(struct klp_patch *patch, struct klp_state *state);
+	void (*pre_unpatch)(struct klp_patch *patch, struct klp_state *state);
+	void (*post_unpatch)(struct klp_patch *patch, struct klp_state *state);
+	klp_shadow_dtor_t shadow_dtor;
+	bool pre_patch_succeeded;
+};
+
+struct klp_state_ext {
+	unsigned long id;
+	unsigned int version;
+	struct klp_state_callbacks callbacks;
 };
 
 /*
@@ -69,7 +84,6 @@ struct klp_func_ext {
 struct klp_object_ext {
 	const char *name;
 	struct klp_func_ext *funcs;
-	struct klp_callbacks callbacks;
 	unsigned int nr_funcs;
 };
 
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 95c099a8f594..eae807916ca0 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1009,8 +1009,6 @@ static int klp_init_patch(struct klp_patch *patch)
 
 static int __klp_disable_patch(struct klp_patch *patch)
 {
-	struct klp_object *obj;
-
 	if (WARN_ON(!patch->enabled))
 		return -EINVAL;
 
@@ -1021,10 +1019,6 @@ static int __klp_disable_patch(struct klp_patch *patch)
 
 	klp_states_pre_unpatch(patch);
 
-	klp_for_each_object(patch, obj)
-		if (obj->patched)
-			klp_pre_unpatch_callback(obj);
-
 	/*
 	 * Enforce the order of the func->transition writes in
 	 * klp_init_transition() and the TIF_PATCH_PENDING writes in
@@ -1075,13 +1069,6 @@ static int __klp_enable_patch(struct klp_patch *patch)
 		if (!klp_is_object_loaded(obj))
 			continue;
 
-		ret = klp_pre_patch_callback(obj);
-		if (ret) {
-			pr_warn("pre-patch callback failed for object '%s'\n",
-				klp_is_module(obj) ? obj->name : "vmlinux");
-			goto err;
-		}
-
 		ret = klp_patch_object(obj);
 		if (ret) {
 			pr_warn("failed to patch object '%s'\n",
@@ -1253,14 +1240,10 @@ static void klp_cleanup_module_patches_limited(struct module *mod,
 			if (!klp_is_module(obj) || strcmp(obj->name, mod->name))
 				continue;
 
-			if (patch != klp_transition_patch)
-				klp_pre_unpatch_callback(obj);
-
 			pr_notice("reverting patch '%s' on unloading module '%s'\n",
 				  patch->mod->name, obj->mod->name);
 			klp_unpatch_object(obj);
 
-			klp_post_unpatch_callback(obj);
 			klp_clear_object_relocs(patch, obj);
 			klp_free_object_loaded(obj);
 			break;
@@ -1307,25 +1290,13 @@ int klp_module_coming(struct module *mod)
 			pr_notice("applying patch '%s' to loading module '%s'\n",
 				  patch->mod->name, obj->mod->name);
 
-			ret = klp_pre_patch_callback(obj);
-			if (ret) {
-				pr_warn("pre-patch callback failed for object '%s'\n",
-					obj->name);
-				goto err;
-			}
-
 			ret = klp_patch_object(obj);
 			if (ret) {
 				pr_warn("failed to apply patch '%s' to module '%s' (%d)\n",
 					patch->mod->name, obj->mod->name, ret);
-
-				klp_post_unpatch_callback(obj);
 				goto err;
 			}
 
-			if (patch != klp_transition_patch)
-				klp_post_patch_callback(obj);
-
 			break;
 		}
 	}
diff --git a/kernel/livepatch/core.h b/kernel/livepatch/core.h
index 38209c7361b6..02b8364f6779 100644
--- a/kernel/livepatch/core.h
+++ b/kernel/livepatch/core.h
@@ -23,37 +23,4 @@ static inline bool klp_is_object_loaded(struct klp_object *obj)
 	return !obj->name || obj->mod;
 }
 
-static inline int klp_pre_patch_callback(struct klp_object *obj)
-{
-	int ret = 0;
-
-	if (obj->callbacks.pre_patch)
-		ret = (*obj->callbacks.pre_patch)(obj);
-
-	obj->callbacks.post_unpatch_enabled = !ret;
-
-	return ret;
-}
-
-static inline void klp_post_patch_callback(struct klp_object *obj)
-{
-	if (obj->callbacks.post_patch)
-		(*obj->callbacks.post_patch)(obj);
-}
-
-static inline void klp_pre_unpatch_callback(struct klp_object *obj)
-{
-	if (obj->callbacks.pre_unpatch)
-		(*obj->callbacks.pre_unpatch)(obj);
-}
-
-static inline void klp_post_unpatch_callback(struct klp_object *obj)
-{
-	if (obj->callbacks.post_unpatch_enabled &&
-	    obj->callbacks.post_unpatch)
-		(*obj->callbacks.post_unpatch)(obj);
-
-	obj->callbacks.post_unpatch_enabled = false;
-}
-
 #endif /* _LIVEPATCH_CORE_H */
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 1a2b11be7b5a..f844283b5423 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -145,15 +145,6 @@ static void klp_complete_transition(void)
 		klp_states_post_unpatch(klp_transition_patch);
 	}
 
-	klp_for_each_object(klp_transition_patch, obj) {
-		if (!klp_is_object_loaded(obj))
-			continue;
-		if (klp_target_state == KLP_TRANSITION_PATCHED)
-			klp_post_patch_callback(obj);
-		else if (klp_target_state == KLP_TRANSITION_UNPATCHED)
-			klp_post_unpatch_callback(obj);
-	}
-
 	pr_notice("'%s': %s complete\n", klp_transition_patch->mod->name,
 		  klp_target_state == KLP_TRANSITION_PATCHED ? "patching" : "unpatching");
 
diff --git a/scripts/livepatch/init.c b/scripts/livepatch/init.c
index 659db21a5b53..04e8d20bab2a 100644
--- a/scripts/livepatch/init.c
+++ b/scripts/livepatch/init.c
@@ -63,8 +63,6 @@ static int __init livepatch_mod_init(void)
 
 		obj->name = obj_ext->name;
 		obj->funcs = funcs;
-
-		memcpy(&obj->callbacks, &obj_ext->callbacks, sizeof(struct klp_callbacks));
 	}
 
 	patch->mod = THIS_MODULE;
diff --git a/tools/include/linux/livepatch_external.h b/tools/include/linux/livepatch_external.h
index 138af19b0f5c..d9123d0c5dff 100644
--- a/tools/include/linux/livepatch_external.h
+++ b/tools/include/linux/livepatch_external.h
@@ -21,33 +21,48 @@
 #define KLP_PRE_UNPATCH_PREFIX		__stringify(__KLP_PRE_UNPATCH_PREFIX)
 #define KLP_POST_UNPATCH_PREFIX		__stringify(__KLP_POST_UNPATCH_PREFIX)
 
-struct klp_object;
-
-typedef int (*klp_pre_patch_t)(struct klp_object *obj);
-typedef void (*klp_post_patch_t)(struct klp_object *obj);
-typedef void (*klp_pre_unpatch_t)(struct klp_object *obj);
-typedef void (*klp_post_unpatch_t)(struct klp_object *obj);
+struct klp_state;
+struct klp_patch;
+typedef int (*klp_shadow_ctor_t)(void *obj,
+				 void *shadow_data,
+				 void *ctor_data);
+typedef void (*klp_shadow_dtor_t)(void *obj, void *shadow_data);
 
 /**
- * struct klp_callbacks - pre/post live-(un)patch callback structure
- * @pre_patch:		executed before code patching
- * @post_patch:		executed after code patching
- * @pre_unpatch:	executed before code unpatching
- * @post_unpatch:	executed after code unpatching
- * @post_unpatch_enabled:	flag indicating if post-unpatch callback
- *				should run
+ * struct klp_state_callbacks - callbacks manipulating the state
+ * @pre_patch:		 executed only when the state is being enabled
+ *			 before code patching
+ * @post_patch:		 executed only when the state is being enabled
+ *			 after code patching
+ * @pre_unpatch:	 executed only when the state is being disabled
+ *			 before code unpatching
+ * @post_unpatch:	 executed only when the state is being disabled
+ *			 after code unpatching
+ * @shadow_dtor:	 destructor for the related shadow variable
+ * @pre_patch_succeeded: internal state used by a rollback on error
+ *
+ * All callbacks are optional.
+ *
+ * @pre_patch callback returns 0 on success and an error code otherwise.
  *
- * All callbacks are optional.  Only the pre-patch callback, if provided,
- * will be unconditionally executed.  If the parent klp_object fails to
- * patch for any reason, including a non-zero error status returned from
- * the pre-patch callback, no further callbacks will be executed.
+ * Any error prevents enabling the livepatch. @post_unpatch() callbacks are
+ * then called to rollback @pre_patch callbacks which has already succeeded
+ * before. Also @post_patch callbacks are called for to-be-removed states
+ * to rollback pre_unpatch() callbacks when they were called.
  */
-struct klp_callbacks {
-	klp_pre_patch_t		pre_patch;
-	klp_post_patch_t	post_patch;
-	klp_pre_unpatch_t	pre_unpatch;
-	klp_post_unpatch_t	post_unpatch;
-	bool post_unpatch_enabled;
+struct klp_state_callbacks {
+	int (*pre_patch)(struct klp_patch *patch, struct klp_state *state);
+	void (*post_patch)(struct klp_patch *patch, struct klp_state *state);
+	void (*pre_unpatch)(struct klp_patch *patch, struct klp_state *state);
+	void (*post_unpatch)(struct klp_patch *patch, struct klp_state *state);
+	klp_shadow_dtor_t shadow_dtor;
+	bool pre_patch_succeeded;
+};
+
+struct klp_state_ext {
+	unsigned long id;
+	unsigned int version;
+	struct klp_state_callbacks callbacks;
 };
 
 /*
@@ -69,7 +84,6 @@ struct klp_func_ext {
 struct klp_object_ext {
 	const char *name;
 	struct klp_func_ext *funcs;
-	struct klp_callbacks callbacks;
 	unsigned int nr_funcs;
 };
 
diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index c2c4e4968bc2..128fbe054417 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1606,8 +1606,8 @@ static int create_klp_sections(struct elfs *e)
 		reloc = find_reloc_by_dest(e->out, sym->sec, sym->offset);
 
 		if (!elf_create_reloc(e->out, obj_sec,
-				      offsetof(struct klp_object_ext, callbacks) +
-				      offsetof(struct klp_callbacks, pre_patch),
+				      offsetof(struct klp_state_ext, callbacks) +
+				      offsetof(struct klp_state_callbacks, pre_patch),
 				      reloc->sym, reloc_addend(reloc), R_ABS64))
 			return -1;
 	}
@@ -1622,8 +1622,8 @@ static int create_klp_sections(struct elfs *e)
 		reloc = find_reloc_by_dest(e->out, sym->sec, sym->offset);
 
 		if (!elf_create_reloc(e->out, obj_sec,
-				      offsetof(struct klp_object_ext, callbacks) +
-				      offsetof(struct klp_callbacks, post_patch),
+				      offsetof(struct klp_state_ext, callbacks) +
+				      offsetof(struct klp_state_callbacks, post_patch),
 				      reloc->sym, reloc_addend(reloc), R_ABS64))
 			return -1;
 	}
@@ -1638,8 +1638,8 @@ static int create_klp_sections(struct elfs *e)
 		reloc = find_reloc_by_dest(e->out, sym->sec, sym->offset);
 
 		if (!elf_create_reloc(e->out, obj_sec,
-				      offsetof(struct klp_object_ext, callbacks) +
-				      offsetof(struct klp_callbacks, pre_unpatch),
+				      offsetof(struct klp_state_ext, callbacks) +
+				      offsetof(struct klp_state_callbacks, pre_unpatch),
 				      reloc->sym, reloc_addend(reloc), R_ABS64))
 			return -1;
 	}
@@ -1654,8 +1654,8 @@ static int create_klp_sections(struct elfs *e)
 		reloc = find_reloc_by_dest(e->out, sym->sec, sym->offset);
 
 		if (!elf_create_reloc(e->out, obj_sec,
-				      offsetof(struct klp_object_ext, callbacks) +
-				      offsetof(struct klp_callbacks, post_unpatch),
+				      offsetof(struct klp_state_ext, callbacks) +
+				      offsetof(struct klp_state_callbacks, post_unpatch),
 				      reloc->sym, reloc_addend(reloc), R_ABS64))
 			return -1;
 	}
-- 
2.47.3


