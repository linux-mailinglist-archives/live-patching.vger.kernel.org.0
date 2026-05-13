Return-Path: <live-patching+bounces-2800-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gMs3JzmNBGqvLQIAu9opvQ
	(envelope-from <live-patching+bounces-2800-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 16:39:53 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D25853541F
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 16:39:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C7A9E3011A68
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 14:34:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CEDA43E48B;
	Wed, 13 May 2026 14:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n2j8V3PB"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3477143D4F5
	for <live-patching@vger.kernel.org>; Wed, 13 May 2026 14:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778682846; cv=none; b=vGfelsCuSA0ujgD9qw/EC3jH0s8F7cmRWb/aC+LRkRYic4SVDCvG8gCLQw47Bg7u+ic+RWt7q83EXuDl1aYTW122bzTuRHamwPtrr+uPrYeN5Y4c3LYG57GE5jc1lRjegs2XM9MuJAxYJxEuEPM/b3t93TmZFbWVjxHVYryg8W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778682846; c=relaxed/simple;
	bh=lCYqD2JiSAOHBx6e4bmzqUbMez6V1AevXA5tXBJYjGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKjyxT+xGRzj3qF4ZG8jcI4darV3DuqAV839Zfhj9h8h7dgFqpWHLNnioZsbPzV5/PVw6ioxkR8aJQpLL6JwNp3gSxNpgAkRqnXtowhF6FIpMsFgZBQr5ZxT5gx+ad3kgA+VwNivDDokpyAy/KgdDW8FABcSMus3PUnKpf8Ssu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n2j8V3PB; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c8028fa6039so4574568a12.2
        for <live-patching@vger.kernel.org>; Wed, 13 May 2026 07:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778682841; x=1779287641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E3WlnSjCoD10LWJ1eCDHsCqAYOqtvfuYE7b1t5qlnmY=;
        b=n2j8V3PB4ApeYtK7XFZJFr/fWkGTEyeIEpBMdifFpQkQoS/3rBRlasHKJxScYtKSik
         g762mEv9R/mSo5Nqr75u6UCEtGTVgRuTa3p2Dq4rJDHrrxdVL9wzQ3NXkgqRJXrr1pbw
         LPR19yuqHdL4zJJ/tOt2rvpT4PSnCRY42ODkC/+v6YHlYBgGc3y8eSoqKc4THzLVvPsq
         PxMCZsiL1SkxgaYISOE13vLR/jgsr51Z0G24S3Rgs81oTEbmjeHNQIVfxiziScqNg2xw
         eNifI4CawJ5W5cjk0I290HVkTLyA7qhFBrjJCx+gmitTJeA1yKiCYXeF0o/9lX7YM+zs
         YGZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778682841; x=1779287641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E3WlnSjCoD10LWJ1eCDHsCqAYOqtvfuYE7b1t5qlnmY=;
        b=RGaqH7drhxaxDN48y3pn/AUvA7c7Pia/j6iWYOmCLL8OnRrCEhqeTHd+HzKD1IWHbh
         vrkjl2eVQAiGhRUljxBqnzPj2X8QiQYItUI9xxvbnIz2rPxEEQtz0cA/kLA18/JGsl+0
         vMz5YfolH5I1yd2fK8mMQoUb2oNPVxGpQgHh/hDMdmXQE1UNnOrgK8hCcws8dnzw5o9h
         bHhJIwkOr56DV9lCzv45pJxndfqNAgkEWAHTNLkbG8fiDXDaYWgBC30LVZFZ2NLA+Fhq
         v9XxDF35Z1W/sxvC5Lg81RbBt4KU2wClum7twcaLibdrBDSivvE6WrjI8XZb8TXi5QM4
         Y8Bw==
X-Gm-Message-State: AOJu0Yxe+YJ4mc/kSqh/SV+s/SYTxZRdGrm2rynP9iVvrb/Xgi1wJ5+B
	LSzJJkXI9uVigZY6k0bjfxC3i0QnIzPBRKPS7gFOtER9Owq8BmyHRqYk
X-Gm-Gg: Acq92OHVA7BMnsDqjmgCwETC23lj0GAeW7/GZbkwthK1QK7ICaiEt9oeItE3KeN8KA3
	s8M+r+WI8QLfUAPskNymwBGt8d1Fi9UI1UCbMx2fBr/IUOPmm20gci7t1SxlbrTYpoSn4cUShh9
	3uXa6MmsYlK+FDLL7Zpgssan73pV691WAPbCoCSm6waJsV9Cylfp+0P0MMTuWhZm0rUz9B+1S8k
	MNZISeTDgm2yOtsWOSWheViquiS9VWy7fc0O6t/twtjh9NHE4nqLPWKr+ue2eaEkvjzP5Z+Tcns
	c/cSin4U1mVSO4SwaxIAWmL+9gwSApjkLPei5WjMhK1mAX7hq+DTxN3KFxvsn4C30+yY/QbMuT3
	ulBzgNfU+QiJ9yfYLTdU4gVCB2Ok8WALPY4LTVPWY0y+C+LPWDjP87aigZN04nzEhdMzuzcq0pM
	aC88uczmt4CxIjW8Aj64a7cxOTB/HbP3sY3gtyZ3R6r5TGeWUmSS7fe5D4tcPYxQxJ9BrIFDwTl
	Deov8ZFPwY7wic=
X-Received: by 2002:a05:6a20:1596:b0:39b:a48e:6a77 with SMTP id adf61e73a8af0-3af83280430mr4017708637.37.1778682841060;
        Wed, 13 May 2026 07:34:01 -0700 (PDT)
Received: from localhost.localdomain ([240e:46c:2200:3c3:e555:e58a:71d1:ef1d])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c826771018bsm15006418a12.17.2026.05.13.07.33.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 07:34:00 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	song@kernel.org
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH 1/6] livepatch: Support scoped atomic replace using replace set
Date: Wed, 13 May 2026 22:33:16 +0800
Message-ID: <20260513143321.26185-2-laoar.shao@gmail.com>
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
X-Rspamd-Queue-Id: 1D25853541F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2800-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

Convert the replace attribute from a boolean to a u32 to function as a
"replace set." A newly loaded livepatch will now atomically replace
existing patches that belong to the same set.

This change currently supports function replacement only; support for
state and shadow variables will be introduced in subsequent patches.

Suggested-by: Song Liu <song@kernel.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../livepatch/cumulative-patches.rst          | 17 ++++++++------
 Documentation/livepatch/livepatch.rst         | 23 +++++++++++--------
 include/linux/livepatch.h                     |  5 ++--
 kernel/livepatch/core.c                       | 16 ++++++++-----
 kernel/livepatch/state.c                      | 17 +++++++-------
 kernel/livepatch/transition.c                 | 10 ++++----
 scripts/livepatch/init.c                      |  7 +-----
 scripts/livepatch/klp-build                   | 14 +++++------
 8 files changed, 59 insertions(+), 50 deletions(-)

diff --git a/Documentation/livepatch/cumulative-patches.rst b/Documentation/livepatch/cumulative-patches.rst
index 1931f318976a..6ef49748110e 100644
--- a/Documentation/livepatch/cumulative-patches.rst
+++ b/Documentation/livepatch/cumulative-patches.rst
@@ -17,18 +17,20 @@ from all older livepatches and completely replace them in one transition.
 Usage
 -----
 
-The atomic replace can be enabled by setting "replace" flag in struct klp_patch,
-for example::
+The "replace_set" attribute in ``struct klp_patch`` acts as a **replace set**,
+defining the scope of the replacement. By default, the replace set is 1.
+
+For example::
 
 	static struct klp_patch patch = {
 		.mod = THIS_MODULE,
 		.objs = objs,
-		.replace = true,
+		.replace_set = 1,
 	};
 
 All processes are then migrated to use the code only from the new patch.
-Once the transition is finished, all older patches are automatically
-disabled.
+Once the transition is finished, all older patches with the same replace
+set are automatically disabled. Patches with different tags remain active.
 
 Ftrace handlers are transparently removed from functions that are no
 longer modified by the new cumulative patch.
@@ -62,9 +64,10 @@ Limitations:
 ------------
 
   - Once the operation finishes, there is no straightforward way
-    to reverse it and restore the replaced patches atomically.
+    to reverse it and restore the replaced patches (with the same set)
+    atomically.
 
-    A good practice is to set .replace flag in any released livepatch.
+    A good practice is to set a consistent .replace set in related livepatches.
     Then re-adding an older livepatch is equivalent to downgrading
     to that patch. This is safe as long as the livepatches do _not_ do
     extra modifications in (un)patching callbacks or in the module_init()
diff --git a/Documentation/livepatch/livepatch.rst b/Documentation/livepatch/livepatch.rst
index acb90164929e..07c8d5a13003 100644
--- a/Documentation/livepatch/livepatch.rst
+++ b/Documentation/livepatch/livepatch.rst
@@ -347,15 +347,20 @@ to '0'.
 5.3. Replacing
 --------------
 
-All enabled patches might get replaced by a cumulative patch that
-has the .replace flag set.
-
-Once the new patch is enabled and the 'transition' finishes then
-all the functions (struct klp_func) associated with the replaced
-patches are removed from the corresponding struct klp_ops. Also
-the ftrace handler is unregistered and the struct klp_ops is
-freed when the related function is not modified by the new patch
-and func_stack list becomes empty.
+All currently enabled patches may be superseded by a cumulative patch that
+has the same ``.replace_set`` attribute. Once the new patch is enabled and
+the transition finishes, the livepatching core identifies all existing
+patches that share the same replace set.
+
+Once the transition is complete, all functions (``struct klp_func``)
+associated with the matching replaced patches are removed from the
+corresponding ``struct klp_ops``. If a function is no longer modified by
+the new patch and its ``func_stack`` list becomes empty, the ftrace
+handler is unregistered and the ``struct klp_ops`` is freed.
+
+Patches with a different replace set are not affected by this process
+and remain active. This allows for the independent management and
+stacking of multiple, non-conflicting livepatch sets.
 
 See Documentation/livepatch/cumulative-patches.rst for more details.
 
diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index ba9e3988c07c..171c08328299 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -123,7 +123,8 @@ struct klp_state {
  * @mod:	reference to the live patch module
  * @objs:	object entries for kernel objects to be patched
  * @states:	system states that can get modified
- * @replace:	replace all actively used patches
+ * @replace_set:Livepatch using the same @replace_set will get atomically
+ *		replaced.
  * @list:	list node for global list of actively used patches
  * @kobj:	kobject for sysfs resources
  * @obj_list:	dynamic list of the object entries
@@ -137,7 +138,7 @@ struct klp_patch {
 	struct module *mod;
 	struct klp_object *objs;
 	struct klp_state *states;
-	bool replace;
+	unsigned int replace_set;
 
 	/* internal */
 	struct list_head list;
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 28d15ba58a26..9eeded1f9cf0 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -454,7 +454,7 @@ static ssize_t replace_show(struct kobject *kobj,
 	struct klp_patch *patch;
 
 	patch = container_of(kobj, struct klp_patch, kobj);
-	return sysfs_emit(buf, "%d\n", patch->replace);
+	return sysfs_emit(buf, "%d\n", patch->replace_set);
 }
 
 static ssize_t stack_order_show(struct kobject *kobj,
@@ -621,6 +621,8 @@ static int klp_add_nops(struct klp_patch *patch)
 		klp_for_each_object(old_patch, old_obj) {
 			int err;
 
+			if (patch->replace_set != old_patch->replace_set)
+				continue;
 			err = klp_add_object_nops(patch, old_obj);
 			if (err)
 				return err;
@@ -793,6 +795,8 @@ void klp_free_replaced_patches_async(struct klp_patch *new_patch)
 	klp_for_each_patch_safe(old_patch, tmp_patch) {
 		if (old_patch == new_patch)
 			return;
+		if (old_patch->replace_set != new_patch->replace_set)
+			continue;
 		klp_free_patch_async(old_patch);
 	}
 }
@@ -988,11 +992,9 @@ static int klp_init_patch(struct klp_patch *patch)
 	if (ret)
 		return ret;
 
-	if (patch->replace) {
-		ret = klp_add_nops(patch);
-		if (ret)
-			return ret;
-	}
+	ret = klp_add_nops(patch);
+	if (ret)
+		return ret;
 
 	klp_for_each_object(patch, obj) {
 		ret = klp_init_object(patch, obj);
@@ -1195,6 +1197,8 @@ void klp_unpatch_replaced_patches(struct klp_patch *new_patch)
 		if (old_patch == new_patch)
 			return;
 
+		if (old_patch->replace_set != new_patch->replace_set)
+			continue;
 		old_patch->enabled = false;
 		klp_unpatch_objects(old_patch);
 	}
diff --git a/kernel/livepatch/state.c b/kernel/livepatch/state.c
index 2565d039ade0..a2d223f2bbc0 100644
--- a/kernel/livepatch/state.c
+++ b/kernel/livepatch/state.c
@@ -85,24 +85,25 @@ EXPORT_SYMBOL_GPL(klp_get_prev_state);
 
 /* Check if the patch is able to deal with the existing system state. */
 static bool klp_is_state_compatible(struct klp_patch *patch,
+				    struct klp_patch *old_patch,
 				    struct klp_state *old_state)
 {
 	struct klp_state *state;
 
 	state = klp_get_state(patch, old_state->id);
 
-	/* A cumulative livepatch must handle all already modified states. */
+	/*
+	 * If the new livepatch shares a state set with an existing one, it
+	 * must maintain compatibility with all states modified by the old
+	 * patch.
+	 */
 	if (!state)
-		return !patch->replace;
+		return patch->replace_set != old_patch->replace_set;
 
 	return state->version >= old_state->version;
 }
 
-/*
- * Check that the new livepatch will not break the existing system states.
- * Cumulative patches must handle all already modified states.
- * Non-cumulative patches can touch already modified states.
- */
+/* Check that the new livepatch will not break the existing system states. */
 bool klp_is_patch_compatible(struct klp_patch *patch)
 {
 	struct klp_patch *old_patch;
@@ -110,7 +111,7 @@ bool klp_is_patch_compatible(struct klp_patch *patch)
 
 	klp_for_each_patch(old_patch) {
 		klp_for_each_state(old_patch, old_state) {
-			if (!klp_is_state_compatible(patch, old_state))
+			if (!klp_is_state_compatible(patch, old_patch, old_state))
 				return false;
 		}
 	}
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 2351a19ac2a9..d9f5968fecdc 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -89,7 +89,7 @@ static void klp_complete_transition(void)
 		 klp_transition_patch->mod->name,
 		 klp_target_state == KLP_TRANSITION_PATCHED ? "patching" : "unpatching");
 
-	if (klp_transition_patch->replace && klp_target_state == KLP_TRANSITION_PATCHED) {
+	if (klp_target_state == KLP_TRANSITION_PATCHED) {
 		klp_unpatch_replaced_patches(klp_transition_patch);
 		klp_discard_nops(klp_transition_patch);
 	}
@@ -498,7 +498,7 @@ void klp_try_complete_transition(void)
 	 */
 	if (!patch->enabled)
 		klp_free_patch_async(patch);
-	else if (patch->replace)
+	else
 		klp_free_replaced_patches_async(patch);
 }
 
@@ -720,11 +720,11 @@ void klp_force_transition(void)
 		klp_update_patch_state(idle_task(cpu));
 
 	/* Set forced flag for patches being removed. */
-	if (klp_target_state == KLP_TRANSITION_UNPATCHED)
+	if (klp_target_state == KLP_TRANSITION_UNPATCHED) {
 		klp_transition_patch->forced = true;
-	else if (klp_transition_patch->replace) {
+	} else {
 		klp_for_each_patch(patch) {
-			if (patch != klp_transition_patch)
+			if (patch->replace_set == klp_transition_patch->replace_set)
 				patch->forced = true;
 		}
 	}
diff --git a/scripts/livepatch/init.c b/scripts/livepatch/init.c
index f14d8c8fb35f..659db21a5b53 100644
--- a/scripts/livepatch/init.c
+++ b/scripts/livepatch/init.c
@@ -72,12 +72,7 @@ static int __init livepatch_mod_init(void)
 
 	/* TODO patch->states */
 
-#ifdef KLP_NO_REPLACE
-	patch->replace = false;
-#else
-	patch->replace = true;
-#endif
-
+	patch->replace_set = KLP_REPLACE_TAG;
 	return klp_enable_patch(patch);
 
 err_free_objs:
diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 7b82c7503c2b..66d4a0631f1b 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -117,7 +117,7 @@ Options:
    -f, --show-first-changed	Show address of first changed instruction
    -j, --jobs=<jobs>		Build jobs to run simultaneously [default: $JOBS]
    -o, --output=<file.ko>	Output file [default: livepatch-<patch-name>.ko]
-       --no-replace		Disable livepatch atomic replace
+   -s, --replace-set=<set>	Set the atomic replace set for this livepatch
    -v, --verbose		Pass V=1 to kernel/module builds
 
 Advanced Options:
@@ -142,8 +142,8 @@ process_args() {
 	local long
 	local args
 
-	short="hfj:o:vdS:T"
-	long="help,show-first-changed,jobs:,output:,no-replace,verbose,debug,short-circuit:,keep-tmp"
+	short="hfj:o:s:vdS:T"
+	long="help,show-first-changed,jobs:,output:,replace-set:,verbose,debug,short-circuit:,keep-tmp"
 
 	args=$(getopt --options "$short" --longoptions "$long" -- "$@") || {
 		echo; usage; exit
@@ -172,9 +172,9 @@ process_args() {
 				NAME="$(module_name_string "$NAME")"
 				shift 2
 				;;
-			--no-replace)
-				REPLACE=0
-				shift
+			-s | --replace-set)
+				REPLACE="$2"
+				shift 2
 				;;
 			-v | --verbose)
 				VERBOSE="V=1"
@@ -759,7 +759,7 @@ build_patch_module() {
 
 	cflags=("-ffunction-sections")
 	cflags+=("-fdata-sections")
-	[[ $REPLACE -eq 0 ]] && cflags+=("-DKLP_NO_REPLACE")
+	cflags+=("-DKLP_REPLACE_TAG=$REPLACE")
 
 	cmd=("make")
 	cmd+=("$VERBOSE")
-- 
2.47.3


