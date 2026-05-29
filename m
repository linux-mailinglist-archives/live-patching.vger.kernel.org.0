Return-Path: <live-patching+bounces-2924-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AEH9Fl4MGWp4pwgAu9opvQ
	(envelope-from <live-patching+bounces-2924-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 05:47:42 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D59755FCD28
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 05:47:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4D3D73039035
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 03:46:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C054F347BDC;
	Fri, 29 May 2026 03:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dTjvIdR9"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36E478F26
	for <live-patching@vger.kernel.org>; Fri, 29 May 2026 03:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780026364; cv=none; b=VdpoC0htoKL/AKKK1UHTriZzauMIFvlBgsi8Fs/LrU+ollafDcrtAf/tET4A/vSWQVW3ypcDyFccrb9LdR+GbgMbxpJvjnGOHS9Wl54X5WFQVSFFfFjeyMjtfeJWyTbHcnyE9CyE778azvfB0E8jZjILBCJTtCz6pafbWKXKXYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780026364; c=relaxed/simple;
	bh=Pq02smyprp8pU7ZpoipECK6D8EkZdyT4Nobk9pZiQw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hr0F73uUogsSVsikjyfoBt8HWJ4G66t0nZ1yMkDpx+6XqZUT9y23tKasgiRgdp1/SOEXtainZN4swlWJ9a7aR0CsbPqVP0oE8MZpGY778kuBxwpK7xElq3WdiBUdEHzY5f5jElaPzD73Bp3bCZkAuhpB08WVz/qeuIxCRQQNCTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dTjvIdR9; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-36ad15213fbso3063101a91.0
        for <live-patching@vger.kernel.org>; Thu, 28 May 2026 20:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780026362; x=1780631162; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OMqFTkqGZEHVm6xKmEhIEc131RKoD2F330poidKbh64=;
        b=dTjvIdR9yts2KAi2Bk8NHQnkRT9xewA2obRgLGpmk2+8y94eQICaBUfItYYVxyENMq
         9sN08yU8sUi5/Gf7tKaASGnnrK4xiuZJLlzWCIRclehAIWVPUsBd3WOg8mMqFOWszWUe
         iZ6BmOTvxMKU0fsB3wS5XbnxEOYsSO+Y6vNSuKg/q2lHgtvr5kf3Gz6tdwBPJrJKITp3
         gbUwKUcHjsVruyaLAK/CDWxdNtXO/kQIcUnalAExGb3Plmdg6c+MBhfQyGaYjosklmZn
         JAuLG0n4yV63Ipv0IoSesZoDe1/eeJNTddnsv7sXl+W01mw9Lzr/ZfxgfoNEXTZaW1ow
         aHrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780026362; x=1780631162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OMqFTkqGZEHVm6xKmEhIEc131RKoD2F330poidKbh64=;
        b=HFxRcygPX+72qR+ujEApqqRVJtf2WUloTcewv/K2ulx+LL+ut5uktxk3Igea4tM2yN
         Od4CzKZvAF+28XuqexGLtPO8aVHqrG/3VnE7XyEFL9WV0DsLoz/gYSIZjEJBIxMcD7vp
         lvS9ZuSfTu+xjk3zZxPlXOrZ7wRDKg+dG4P6oq1MK+IyjDPpUevzTaTlmCsDTu6jlM2M
         vq6BJP1auP1Cv643C+1rrHnWQPAxWpRhQDjjKp+K/Rjc6fUPIb3NFfUM6wV+u4tCpHPu
         QcY40hRd7IkhWm0002o43EqFcvFPloqRtb1MkcNk3GYjvWdk14fE8quTkUtQpHWxpxPo
         y+dg==
X-Gm-Message-State: AOJu0Yyk+IhTl7vkHnS7MV69EF46sxR4n2tf/BUfTyKtxRckWsaiJaVt
	0q7Y+TwXL9Dz7dYag2YiP8QadvVydifM5jUQIqKmEQWSb+1/nUy97FRq
X-Gm-Gg: Acq92OHQ4ia0YKBE9DOyw9eJ52EbpzKZDEgL3QMpokLQfsJiNhmW+Cii+dX9b/80el8
	I6OMKzCN8NnkybmhBNIzBTSpOhHas0VaZgtgAW/oWP5/P5D7zHQyeeSLUs98OUCkpKJ124SsQyt
	ck5bnJr2uOp0K/cDu1LXClrw7J5zxKoPAtKd7HxV2wHz1W0GR/tFxQsLVkCKw24h9srDXqH6Lgh
	j4AymuUfdfTzy9Cc5DHcX+mTSDovhDGSRvCcyElwe8LoxB2zWdz7EW0oIQ19UwR+JTs0mokZhwo
	piS6+xfNbcrq8Q28Sf+VRhHQc+dhnPpmT3mzNH9Mqk+RFPKjSyKzoHYqBzD2+SbhAwaSN3HMMli
	BvXirvwROiIT7hgfJ1BFTtChMmAEuZNHUSvfj+GMOyDW30QB7+CIqTYOHaoYMTQ/5nDfxygcYmF
	nFdBN4/ucJeQu2QneVcoNvy2y7McYB1xZYxf4Ws/R6UfH/PgNW+4I1iGNfBLr8L+/on2wT1BkFB
	aLP+1xEn1PkerQXsEWQNdPWeQE=
X-Received: by 2002:a17:90b:562d:b0:364:edd2:812 with SMTP id 98e67ed59e1d1-36bbd1176ffmr1407908a91.25.1780026362117;
        Thu, 28 May 2026 20:46:02 -0700 (PDT)
Received: from localhost.localdomain ([240e:46d:2000:3837:ec96:b29a:f0bb:6d68])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bc6a340b7sm298385a91.11.2026.05.28.20.45.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 28 May 2026 20:46:01 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	song@kernel.org
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v2 2/4] livepatch: Support scoped atomic replace using replace_set
Date: Fri, 29 May 2026 11:45:40 +0800
Message-ID: <20260529034542.68766-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260529034542.68766-1-laoar.shao@gmail.com>
References: <20260529034542.68766-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
	TAGGED_FROM(0.00)[bounces-2924-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,suse.com:email]
X-Rspamd-Queue-Id: D59755FCD28
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Convert the replace attribute from a boolean to a u32 to function as a
"replace set." A newly loaded livepatch will now atomically replace any
existing patch belonging to the same set. There can only ever be one active
livepatch for a given replace_set number.

This change currently supports function replacement only. Livepatches that
belong to different replace sets cannot modify the same function. If a new
livepatch attempts to modify a function already modified by an older
livepatch from a different replace_set, the loading of the new livepatch
will be refused.

Similarly, for the KLP state, livepatches belonging to different replace
sets cannot use the same state ID. The system will refuse to load a new
livepatch if it uses a state ID already in use by an older livepatch from
a different replace_set.

For the KLP shadow variable mechanism, developers must assign unique shadow
IDs to livepatches that belong to different replace sets.

Support for replace_set compatibility with KLP state and shadow variables
will be implemented after Petr's KLP state transfer work is completed [0].

Other user-visible changes include:
- The non-replace model is now deprecated
- /sys/kernel/livepatch/livepatch_XXX/replace attribute is replaced by
  /sys/kernel/livepatch/livepatch_XXX/replace_set

Link: https://github.com/pmladek/linux/tree/klp-state-transfer-v1-iter12 [0]
Suggested-by: Song Liu <song@kernel.org>
Suggested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../ABI/testing/sysfs-kernel-livepatch        |  5 +-
 .../livepatch/cumulative-patches.rst          | 23 ++++++---
 Documentation/livepatch/livepatch.rst         | 21 ++++----
 include/linux/livepatch.h                     |  6 +--
 kernel/livepatch/core.c                       | 24 +++++----
 kernel/livepatch/state.c                      | 51 +++++++++++++++----
 kernel/livepatch/transition.c                 | 11 ++--
 scripts/livepatch/init.c                      |  6 +--
 scripts/livepatch/klp-build                   | 16 +++---
 9 files changed, 104 insertions(+), 59 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
index 3c3f36b32b57..6d75235a6a2e 100644
--- a/Documentation/ABI/testing/sysfs-kernel-livepatch
+++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
@@ -47,13 +47,12 @@ Description:
 		disabled when the feature is used. See
 		Documentation/livepatch/livepatch.rst for more information.
 
-What:		/sys/kernel/livepatch/<patch>/replace
+What:		/sys/kernel/livepatch/<patch>/replace_set
 Date:		Jun 2024
 KernelVersion:	6.11.0
 Contact:	live-patching@vger.kernel.org
 Description:
-		An attribute which indicates whether the patch supports
-		atomic-replace.
+		An attribute to show the replace_set of this livepatch.
 
 What:		/sys/kernel/livepatch/<patch>/stack_order
 Date:		Jan 2025
diff --git a/Documentation/livepatch/cumulative-patches.rst b/Documentation/livepatch/cumulative-patches.rst
index 1931f318976a..0361adb12f6d 100644
--- a/Documentation/livepatch/cumulative-patches.rst
+++ b/Documentation/livepatch/cumulative-patches.rst
@@ -17,18 +17,20 @@ from all older livepatches and completely replace them in one transition.
 Usage
 -----
 
-The atomic replace can be enabled by setting "replace" flag in struct klp_patch,
-for example::
+The "replace_set" attribute in ``struct klp_patch`` acts as a **replace_set**,
+defining the scope of the replacement. By default, the replace_set is 0.
+
+For example::
 
 	static struct klp_patch patch = {
 		.mod = THIS_MODULE,
 		.objs = objs,
-		.replace = true,
+		.replace_set = 0,
 	};
 
 All processes are then migrated to use the code only from the new patch.
-Once the transition is finished, all older patches are automatically
-disabled.
+Once the transition is finished, all older patches with the same replace
+set are automatically disabled. Patches with different tags remain active.
 
 Ftrace handlers are transparently removed from functions that are no
 longer modified by the new cumulative patch.
@@ -62,9 +64,14 @@ Limitations:
 ------------
 
   - Once the operation finishes, there is no straightforward way
-    to reverse it and restore the replaced patches atomically.
-
-    A good practice is to set .replace flag in any released livepatch.
+    to reverse it and restore the replaced patches (with the same set)
+    atomically.
+
+    A good practice is to use only one (default) "replace_set". It
+    makes sure that there always will be only one enabled livepatch
+    on the system. The consistency model will ensure a safe update
+    between two versions. It prevents potential problems with installing
+    two livepatches doing incompatible functional changes.
     Then re-adding an older livepatch is equivalent to downgrading
     to that patch. This is safe as long as the livepatches do _not_ do
     extra modifications in (un)patching callbacks or in the module_init()
diff --git a/Documentation/livepatch/livepatch.rst b/Documentation/livepatch/livepatch.rst
index acb90164929e..221d8f1e91c4 100644
--- a/Documentation/livepatch/livepatch.rst
+++ b/Documentation/livepatch/livepatch.rst
@@ -347,15 +347,18 @@ to '0'.
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
+There always can be only one livepatch with a given "replace_set" number.
+They always replace each other.
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
index 70854f542c33..ab8cb3f77891 100644
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
@@ -218,7 +219,6 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
 struct klp_func *klp_find_func(struct klp_object *obj,
 			       struct klp_func *old_func);
 
-
 #else /* !CONFIG_LIVEPATCH */
 
 static inline int klp_module_coming(struct module *mod) { return 0; }
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index e97df3e59057..969fea2a9263 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -350,7 +350,7 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
  * /sys/kernel/livepatch/<patch>/enabled
  * /sys/kernel/livepatch/<patch>/transition
  * /sys/kernel/livepatch/<patch>/force
- * /sys/kernel/livepatch/<patch>/replace
+ * /sys/kernel/livepatch/<patch>/replace_set
  * /sys/kernel/livepatch/<patch>/stack_order
  * /sys/kernel/livepatch/<patch>/<object>
  * /sys/kernel/livepatch/<patch>/<object>/patched
@@ -448,13 +448,13 @@ static ssize_t force_store(struct kobject *kobj, struct kobj_attribute *attr,
 	return count;
 }
 
-static ssize_t replace_show(struct kobject *kobj,
+static ssize_t replace_set_show(struct kobject *kobj,
 			    struct kobj_attribute *attr, char *buf)
 {
 	struct klp_patch *patch;
 
 	patch = container_of(kobj, struct klp_patch, kobj);
-	return sysfs_emit(buf, "%d\n", patch->replace);
+	return sysfs_emit(buf, "%u\n", patch->replace_set);
 }
 
 static ssize_t stack_order_show(struct kobject *kobj,
@@ -481,13 +481,13 @@ static ssize_t stack_order_show(struct kobject *kobj,
 static struct kobj_attribute enabled_kobj_attr = __ATTR_RW(enabled);
 static struct kobj_attribute transition_kobj_attr = __ATTR_RO(transition);
 static struct kobj_attribute force_kobj_attr = __ATTR_WO(force);
-static struct kobj_attribute replace_kobj_attr = __ATTR_RO(replace);
+static struct kobj_attribute replace_set_kobj_attr = __ATTR_RO(replace_set);
 static struct kobj_attribute stack_order_kobj_attr = __ATTR_RO(stack_order);
 static struct attribute *klp_patch_attrs[] = {
 	&enabled_kobj_attr.attr,
 	&transition_kobj_attr.attr,
 	&force_kobj_attr.attr,
-	&replace_kobj_attr.attr,
+	&replace_set_kobj_attr.attr,
 	&stack_order_kobj_attr.attr,
 	NULL
 };
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
index 2565d039ade0..a1ac46637336 100644
--- a/kernel/livepatch/state.c
+++ b/kernel/livepatch/state.c
@@ -85,34 +85,65 @@ EXPORT_SYMBOL_GPL(klp_get_prev_state);
 
 /* Check if the patch is able to deal with the existing system state. */
 static bool klp_is_state_compatible(struct klp_patch *patch,
+				    struct klp_patch *old_patch,
 				    struct klp_state *old_state)
 {
 	struct klp_state *state;
 
 	state = klp_get_state(patch, old_state->id);
+	if (patch->replace_set == old_patch->replace_set) {
+		/*
+		 * If the new livepatch shares a state set with an existing
+		 * one, it must maintain compatibility with all states
+		 * modified by the old patch.
+		 */
+		if (!state)
+			return false;
+		return state->version >= old_state->version;
 
-	/* A cumulative livepatch must handle all already modified states. */
-	if (!state)
-		return !patch->replace;
+	}
 
-	return state->version >= old_state->version;
+	/*
+	 * Two livepatches with a different "replace_set" must _not_ use
+	 * the same "state->id.
+	 */
+	return !state;
 }
 
-/*
- * Check that the new livepatch will not break the existing system states.
- * Cumulative patches must handle all already modified states.
- * Non-cumulative patches can touch already modified states.
- */
+/* Check that the new livepatch will not break the existing system states. */
 bool klp_is_patch_compatible(struct klp_patch *patch)
 {
+	struct klp_object *obj, *old_obj;
 	struct klp_patch *old_patch;
 	struct klp_state *old_state;
+	struct klp_func *func;
 
 	klp_for_each_patch(old_patch) {
 		klp_for_each_state(old_patch, old_state) {
-			if (!klp_is_state_compatible(patch, old_state))
+			if (!klp_is_state_compatible(patch, old_patch, old_state))
 				return false;
 		}
+
+		if (old_patch->replace_set == patch->replace_set)
+			continue;
+
+		/*
+		 * Refuse loading a livepatch which would want to modify a
+		 * function which is already livepatched with the livepatch
+		 * with another "replace_set".
+		 */
+		klp_for_each_object_static(patch, obj) {
+			klp_for_each_object(old_patch, old_obj) {
+				if (!!obj->name != !!old_obj->name)
+					continue;
+				if (obj->name && strcmp(obj->name, old_obj->name))
+					continue;
+				klp_for_each_func_static(obj, func) {
+					if (klp_find_func(old_obj, func))
+						return false;
+				}
+			}
+		}
 	}
 
 	return true;
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index 2351a19ac2a9..8b756dbaa57e 100644
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
 
@@ -720,11 +720,12 @@ void klp_force_transition(void)
 		klp_update_patch_state(idle_task(cpu));
 
 	/* Set forced flag for patches being removed. */
-	if (klp_target_state == KLP_TRANSITION_UNPATCHED)
+	if (klp_target_state == KLP_TRANSITION_UNPATCHED) {
 		klp_transition_patch->forced = true;
-	else if (klp_transition_patch->replace) {
+	} else {
 		klp_for_each_patch(patch) {
-			if (patch != klp_transition_patch)
+			if (patch != klp_transition_patch &&
+			    patch->replace_set == klp_transition_patch->replace_set)
 				patch->forced = true;
 		}
 	}
diff --git a/scripts/livepatch/init.c b/scripts/livepatch/init.c
index f14d8c8fb35f..df4fbcaf4c12 100644
--- a/scripts/livepatch/init.c
+++ b/scripts/livepatch/init.c
@@ -72,10 +72,10 @@ static int __init livepatch_mod_init(void)
 
 	/* TODO patch->states */
 
-#ifdef KLP_NO_REPLACE
-	patch->replace = false;
+#ifdef KLP_REPLACE_SET
+	patch->replace_set = KLP_REPLACE_SET;
 #else
-	patch->replace = true;
+	patch->replace_set = 0;
 #endif
 
 	return klp_enable_patch(patch);
diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 0ad7e6631314..1c6c1c4f3190 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -22,7 +22,7 @@ shopt -s lastpipe
 
 unset DEBUG_CLONE DIFF_CHECKSUM SKIP_CLEANUP XTRACE
 
-REPLACE=1
+REPLACE_SET=0
 SHORT_CIRCUIT=0
 JOBS="$(getconf _NPROCESSORS_ONLN)"
 VERBOSE="-s"
@@ -134,7 +134,7 @@ Options:
    -f, --show-first-changed	Show address of first changed instruction
    -j, --jobs=<jobs>		Build jobs to run simultaneously [default: $JOBS]
    -o, --output=<file.ko>	Output file [default: livepatch-<patch-name>.ko]
-       --no-replace		Disable livepatch atomic replace
+   -s, --replace-set=<set>	Set the atomic replace set for this livepatch
    -v, --verbose		Pass V=1 to kernel/module builds
 
 Advanced Options:
@@ -159,8 +159,8 @@ process_args() {
 	local long
 	local args
 
-	short="hfj:o:vdS:T"
-	long="help,show-first-changed,jobs:,output:,no-replace,verbose,debug,short-circuit:,keep-tmp"
+	short="hfj:o:s:vdS:T"
+	long="help,show-first-changed,jobs:,output:,replace-set:,verbose,debug,short-circuit:,keep-tmp"
 
 	args=$(getopt --options "$short" --longoptions "$long" -- "$@") || {
 		echo; usage; exit
@@ -189,9 +189,9 @@ process_args() {
 				NAME="$(module_name_string "$NAME")"
 				shift 2
 				;;
-			--no-replace)
-				REPLACE=0
-				shift
+			-s | --replace-set)
+				REPLACE_SET="$2"
+				shift 2
 				;;
 			-v | --verbose)
 				VERBOSE="V=1"
@@ -777,7 +777,7 @@ build_patch_module() {
 
 	cflags=("-ffunction-sections")
 	cflags+=("-fdata-sections")
-	[[ $REPLACE -eq 0 ]] && cflags+=("-DKLP_NO_REPLACE")
+	cflags+=("-DKLP_REPLACE_SET=$REPLACE_SET")
 
 	cmd=("make")
 	cmd+=("$VERBOSE")
-- 
2.47.3


