Return-Path: <live-patching+bounces-994-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B81A3A11BF9
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 09:29:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C5083A51DB
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 08:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE10823F292;
	Wed, 15 Jan 2025 08:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UoFNmoqv";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UoFNmoqv"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA44523F288;
	Wed, 15 Jan 2025 08:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929684; cv=none; b=lS6tMsb4FbdBa7vppNiI2/AHxoukFHnkbl89Alrs/YrMGAZXioTm5lGLkQuFdewLWoI4DT4eulP+eOcq+nximbg/Ijh6swcyhIYn7NiMIbaQN8+xJUsLZQ+V7dtg2QEq3bGJuTWHgLrbHvl7Zx8GQVeywgM2HhpfSt4k936vpBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929684; c=relaxed/simple;
	bh=zTarmIWertlY2GjRWyvop7PsEtBWKIqZkogNylG1ayI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szTVS3UUxBHJwSRJTsNgXNC32b0FtTzmywu0vf2ImpwMg7gf7xasFUN1U3MQvXa9VKg7IIvOI1docuTO+GptNecmP4fGQk5FTsoAP3QuG5BLO9E0/a2RMk80JDQKf4wkIQXekClBjVBPMAQ+XeH2NefijgkrrsTVlBFoJL62bsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UoFNmoqv; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UoFNmoqv; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from pathway.suse.cz (unknown [10.100.201.202])
	by smtp-out2.suse.de (Postfix) with ESMTP id 10D611F458;
	Wed, 15 Jan 2025 08:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929681; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kGnIdKOPLqvU2776tJFJ9PSlaxyqDyXk3XczcXYUoBA=;
	b=UoFNmoqvs3d13Q6BAQmgjPgvSfpl5+v8xGu2LvPLqCqlR8O9YKSVGcaoaP6KizZ1jSSFVT
	4C8T3V3fSywz5UlE/CAufaJpiIFrfVCzCd7ZyrwY3QFurCpab5d5wMg2b1W8IrOthw7hPH
	NZjX9e0cPojIHmBwBqD3zWREG5Q0V+A=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929681; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kGnIdKOPLqvU2776tJFJ9PSlaxyqDyXk3XczcXYUoBA=;
	b=UoFNmoqvs3d13Q6BAQmgjPgvSfpl5+v8xGu2LvPLqCqlR8O9YKSVGcaoaP6KizZ1jSSFVT
	4C8T3V3fSywz5UlE/CAufaJpiIFrfVCzCd7ZyrwY3QFurCpab5d5wMg2b1W8IrOthw7hPH
	NZjX9e0cPojIHmBwBqD3zWREG5Q0V+A=
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v1 19/19] livepatch: Remove obsolete per-object callbacks
Date: Wed, 15 Jan 2025 09:24:31 +0100
Message-ID: <20250115082431.5550-20-pmladek@suse.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250115082431.5550-1-pmladek@suse.com>
References: <20250115082431.5550-1-pmladek@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_ZERO(0.00)[0];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLj3e56pwiuh8u4wxetmhsq5s5)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,pathway.suse.cz:helo]
X-Spam-Score: -6.80
X-Spam-Flag: NO

This commit removes the obsolete per-object callbacks from the livepatch
framework.  All selftests have been migrated to the new per-state
callbacks, making the per-object callbacks redundant.

Instead, use the new per-state callbacks. They offer improved semantics
by associating callbacks and shadow variables with a specific state,
enabling better lifetime management of changes.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/livepatch.h     | 26 --------------------------
 kernel/livepatch/core.c       | 29 -----------------------------
 kernel/livepatch/core.h       | 33 ---------------------------------
 kernel/livepatch/transition.c |  9 ---------
 4 files changed, 97 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index d02d7a616338..428300181af3 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -77,35 +77,10 @@ struct klp_func {
 	bool transition;
 };
 
-struct klp_object;
-
-/**
- * struct klp_callbacks - pre/post live-(un)patch callback structure
- * @pre_patch:		executed before code patching
- * @post_patch:		executed after code patching
- * @pre_unpatch:	executed before code unpatching
- * @post_unpatch:	executed after code unpatching
- * @post_unpatch_enabled:	flag indicating if post-unpatch callback
- * 				should run
- *
- * All callbacks are optional.  Only the pre-patch callback, if provided,
- * will be unconditionally executed.  If the parent klp_object fails to
- * patch for any reason, including a non-zero error status returned from
- * the pre-patch callback, no further callbacks will be executed.
- */
-struct klp_callbacks {
-	int (*pre_patch)(struct klp_object *obj);
-	void (*post_patch)(struct klp_object *obj);
-	void (*pre_unpatch)(struct klp_object *obj);
-	void (*post_unpatch)(struct klp_object *obj);
-	bool post_unpatch_enabled;
-};
-
 /**
  * struct klp_object - kernel object structure for live patching
  * @name:	module name (or NULL for vmlinux)
  * @funcs:	function entries for functions to be patched in the object
- * @callbacks:	functions to be executed pre/post (un)patching
  * @kobj:	kobject for sysfs resources
  * @func_list:	dynamic list of the function entries
  * @node:	list node for klp_patch obj_list
@@ -118,7 +93,6 @@ struct klp_object {
 	/* external */
 	const char *name;
 	struct klp_func *funcs;
-	struct klp_callbacks callbacks;
 
 	/* internal */
 	struct kobject kobj;
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 4d244eef0e53..3d6b8edb3e2b 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -983,8 +983,6 @@ static int klp_init_patch(struct klp_patch *patch)
 
 static int __klp_disable_patch(struct klp_patch *patch)
 {
-	struct klp_object *obj;
-
 	if (WARN_ON(!patch->enabled))
 		return -EINVAL;
 
@@ -995,10 +993,6 @@ static int __klp_disable_patch(struct klp_patch *patch)
 
 	klp_states_pre_unpatch(patch);
 
-	klp_for_each_object(patch, obj)
-		if (obj->patched)
-			klp_pre_unpatch_callback(obj);
-
 	/*
 	 * Enforce the order of the func->transition writes in
 	 * klp_init_transition() and the TIF_PATCH_PENDING writes in
@@ -1050,13 +1044,6 @@ static int __klp_enable_patch(struct klp_patch *patch)
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
@@ -1226,14 +1213,10 @@ static void klp_cleanup_module_patches_limited(struct module *mod,
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
@@ -1280,25 +1263,13 @@ int klp_module_coming(struct module *mod)
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
index f3dce9fe9897..c5e9dcf3e453 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -155,15 +155,6 @@ static void klp_complete_transition(void)
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
 
-- 
2.47.1


