Return-Path: <live-patching+bounces-437-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70FA694758C
	for <lists+live-patching@lfdr.de>; Mon,  5 Aug 2024 08:47:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 936131C203E6
	for <lists+live-patching@lfdr.de>; Mon,  5 Aug 2024 06:47:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC411448D2;
	Mon,  5 Aug 2024 06:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IvO7lvRr"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1641422D8;
	Mon,  5 Aug 2024 06:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722840445; cv=none; b=K+Ra14J4G0g2hC2jx5MoLMgijA3vJQVhK7Kn29HoNOKFFb6FIWKCrdpwBvLs1VPNPR+N1I8nhdhYobysgC7ELPBD6qwIk8GVTvbNRbq/8CErmIvdk88xmic7ATo8zgGQVPBrDjtNqZ7FS3cA8+cgxgVKPuIgytv5b6iChyKTRAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722840445; c=relaxed/simple;
	bh=JCwi4pqULnK+De9P8X/K+Fs6x8d1Lfr6J0cR9DtLCI8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bnfB5W+D9arYKrCkluzcOPBq866tddJyWgZFn2gOeI0Zzo3/Rc3oJvOYei4MtzeA4nB/Aa7A9wDmejlNwVtP9ijfvQ8k3HMmNIA/uV/PEj92AFSl8m27CwDkSQs9cv9xEJ4gSo5iMdrF6UmB0tbAihOlBtvUOy5b/iOg3DXtC9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IvO7lvRr; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-6c5bcb8e8edso7577103a12.2;
        Sun, 04 Aug 2024 23:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722840443; x=1723445243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ndJnJKzY17dnKqkOo66uXEo6sO/l+xUTX/p6sZK+sk=;
        b=IvO7lvRrhdlWvDfwfs9QWPpTy2gGngvx37J13Nd5/Zs55vXoYEl5tk3mktro+RGvXE
         1fEAiYRc85Bfmx+WD6BZkz4uX6lAixP7/LuYsmiXguWru4aMRruiLz5+DBuL9t/piLR8
         L1Xjb3ut3AZUHD2VW4xABUACe0PZgwmmkOs7AePFY2FRz/37qrO/zldWoU7rwE/DQPZM
         kY+Pkpklc3Gg0e64wVCLBCGbeKQAGuu8csfXjjcqmdp86EjoG/FuXIVLKh5/MN2QYfYv
         yX+qGphZxGQPaRCdOOOmaf0TPFNd+2UiQshAC8J7mjtuM3fKg59lNDb39Nso6icjB3SI
         NBJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722840443; x=1723445243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ndJnJKzY17dnKqkOo66uXEo6sO/l+xUTX/p6sZK+sk=;
        b=JO0IGADjhEywArB11I9NtI/T7OU8BfpyCJRyXXmrsPD84rSaLiz8uhCK8Ik5NjOlZW
         SXOxyZjin5nzHyr+8MDysTymEXRCZa3+HunMWSk8TfDDSG7nWlA63qqFf+sMFOqN5+JJ
         WM3WUU4B8yiF+zbKx2azj7YX+sqMCEn51kwgeuZSnAzGgBytH9fu+3Chs02VkFgZRISd
         CA2gmuJGCisQQFKjGDpWqrajtNiyQsCjGUPobIQdWTKvi6dWiED7c+IYppa47xqrv5la
         T+wDTjZk0/iYT3E0kjsnFQi/bm6zKMRGTHtntEQAs26iKoBT6oK9Zzo0jAxiVeYQqhOE
         g4nQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPl3PggP6I8Yzta+HnfCCg3P5xDcyWC57B2qvkE8ScUNxxHPgiSNo5O3/Wehj5bqWAcC3kysOc4fuKcokuEzVSr/hwu2PGctjIvmJF
X-Gm-Message-State: AOJu0YwoFHdXJEtdc7eqFexAlB77NYAG680GULbShyTuAHfZGziT886C
	OiOeOqyt+Azl2Jh+fp1BP4bubldEASbDDH5hueprxIFtyxu0C57m
X-Google-Smtp-Source: AGHT+IG7bkBoNRFWaN3nv/2ok8wbhVVQegR0dOukRFOPqSkrpCoELKlchfBIp1ZCKullpey+XjhBBQ==
X-Received: by 2002:a05:6a20:ba29:b0:1c6:b099:6f8d with SMTP id adf61e73a8af0-1c6b0997583mr5877238637.17.1722840442867;
        Sun, 04 Aug 2024 23:47:22 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.121])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cfdc4cf16bsm9538444a91.44.2024.08.04.23.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Aug 2024 23:47:22 -0700 (PDT)
From: "zhangyongde.zyd" <zhangwarden@gmail.com>
X-Google-Original-From: "zhangyongde.zyd" <zhangyongde.zyd@alibaba-inc.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH v2 1/1] livepatch: Add using attribute to klp_func for using function show
Date: Mon,  5 Aug 2024 14:46:56 +0800
Message-Id: <20240805064656.40017-2-zhangyongde.zyd@alibaba-inc.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20240805064656.40017-1-zhangyongde.zyd@alibaba-inc.com>
References: <20240805064656.40017-1-zhangyongde.zyd@alibaba-inc.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wardenjohn <zhangwarden@gmail.com>

One system may contains more than one livepatch module. We can see
which patch is enabled. If some patches applied to one system
modifing the same function, livepatch will use the function enabled
on top of the function stack. However, we can not excatly know
which function of which patch is now enabling.

This patch introduce one sysfs attribute of "using" to klp_func.
For example, if there are serval patches  make changes to function
"meminfo_proc_show", the attribute "enabled" of all the patch is 1.
With this attribute, we can easily know the version enabling belongs
to which patch.

The "using" is set as three state. 0 is disabled, it means that this
version of function is not used. 1 is running, it means that this
version of function is now running. -1 is unknown, it means that
this version of function is under transition, some task is still
chaning their running version of this function.

cat /sys/kernel/livepatch/<patch1>/<object1>/<function1,sympos>/using -> 0
means that the function1 of patch1 is disabled.

cat /sys/kernel/livepatch/<patchN>/<object1>/<function1,sympos>/using -> 1
means that the function1 of patchN is enabled.

cat /sys/kernel/livepatch/<patchN>/<object1>/<function1,sympos>/using -> -1
means that the function1 of patchN is under transition and unknown.

Signed-off-by: Wardenjohn <zhangwarden@gmail.com>

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 51a258c24ff5..fd8224969c5c 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -37,6 +37,7 @@
  * @nop:        temporary patch to use the original code again; dyn. allocated
  * @patched:	the func has been added to the klp_ops list
  * @transition:	the func is currently being applied or reverted
+ * @using:    the func is on top of the function stack that is using
  *
  * The patched and transition variables define the func's patching state.  When
  * patching, a func is always in one of the following states:
@@ -52,6 +53,12 @@
  *   patched=1 transition=1: patched, may be visible to some tasks
  *   patched=0 transition=1: unpatched, temporary ending state
  *   patched=0 transition=0: unpatched
+ * 
+ *  'using' flag is used to show if this function is now using
+ * 
+ *   using=-1 (unknown): the function is now under transition
+ *   using=1  (using):   the function is now running
+ *   using=0  (not used): the function is not used
  */
 struct klp_func {
 	/* external */
@@ -75,6 +82,7 @@ struct klp_func {
 	bool nop;
 	bool patched;
 	bool transition;
+	int using;
 };
 
 struct klp_object;
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 52426665eecc..67630f9f1a21 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -349,6 +349,7 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
  * /sys/kernel/livepatch/<patch>/<object>
  * /sys/kernel/livepatch/<patch>/<object>/patched
  * /sys/kernel/livepatch/<patch>/<object>/<function,sympos>
+ * /sys/kernel/livepatch/<patch>/<object>/<function,sympos>/using
  */
 static int __klp_disable_patch(struct klp_patch *patch);
 
@@ -470,6 +471,22 @@ static struct attribute *klp_object_attrs[] = {
 };
 ATTRIBUTE_GROUPS(klp_object);
 
+static ssize_t using_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	struct klp_func *func;
+
+	func = container_of(kobj, struct klp_func, kobj);
+	return sysfs_emit(buf, "%d\n", func->using);
+}
+
+static struct kobj_attribute using_kobj_attr = __ATTR_RO(using);
+static struct attribute *klp_func_attrs[] = {
+	&using_kobj_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(klp_func);
+
 static void klp_free_object_dynamic(struct klp_object *obj)
 {
 	kfree(obj->name);
@@ -631,6 +648,7 @@ static void klp_kobj_release_func(struct kobject *kobj)
 static const struct kobj_type klp_ktype_func = {
 	.release = klp_kobj_release_func,
 	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = klp_func_groups,
 };
 
 static void __klp_free_funcs(struct klp_object *obj, bool nops_only)
@@ -773,6 +791,7 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
 	INIT_LIST_HEAD(&func->stack_node);
 	func->patched = false;
 	func->transition = false;
+	func->using = 0;
 
 	/* The format for the sysfs directory is <function,sympos> where sympos
 	 * is the nth occurrence of this symbol in kallsyms for the patched
@@ -903,6 +922,7 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
 static void klp_init_func_early(struct klp_object *obj,
 				struct klp_func *func)
 {
+	func->using = false;
 	kobject_init(&func->kobj, &klp_ktype_func);
 	list_add_tail(&func->node, &obj->func_list);
 }
diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
index 90408500e5a3..bf4a8edbd888 100644
--- a/kernel/livepatch/patch.c
+++ b/kernel/livepatch/patch.c
@@ -104,7 +104,7 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 			 * original function.
 			 */
 			func = list_entry_rcu(func->stack_node.next,
-					      struct klp_func, stack_node);
+						struct klp_func, stack_node);
 
 			if (&func->stack_node == &ops->func_stack)
 				goto unlock;
@@ -127,6 +127,7 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 static void klp_unpatch_func(struct klp_func *func)
 {
 	struct klp_ops *ops;
+	struct klp_func *stack_top_func;
 
 	if (WARN_ON(!func->patched))
 		return;
@@ -152,6 +153,10 @@ static void klp_unpatch_func(struct klp_func *func)
 		kfree(ops);
 	} else {
 		list_del_rcu(&func->stack_node);
+		// the previous function is deleted, the stack top is under transition
+		stack_top_func = list_first_entry(&ops->func_stack, struct klp_func,
+							stack_node);
+		stack_top_func->using = -1;
 	}
 
 	func->patched = false;
@@ -160,6 +165,7 @@ static void klp_unpatch_func(struct klp_func *func)
 static int klp_patch_func(struct klp_func *func)
 {
 	struct klp_ops *ops;
+	struct klp_func *stack_top_func;
 	int ret;
 
 	if (WARN_ON(!func->old_func))
@@ -170,6 +176,7 @@ static int klp_patch_func(struct klp_func *func)
 
 	ops = klp_find_ops(func->old_func);
 	if (!ops) {
+		// this function is the first time to be patched
 		unsigned long ftrace_loc;
 
 		ftrace_loc = ftrace_location((unsigned long)func->old_func);
@@ -211,11 +218,16 @@ static int klp_patch_func(struct klp_func *func)
 			goto err;
 		}
 
-
 	} else {
+		// stack_top_func is going to be in transition
+		stack_top_func = list_first_entry(&ops->func_stack, struct klp_func,
+							stack_node);
+		stack_top_func->using = -1;
+		// The new patched function is the one enabling
 		list_add_rcu(&func->stack_node, &ops->func_stack);
-	}
+	}  
 
+	func->using = -1;
 	func->patched = true;
 
 	return 0;
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index ba069459c101..12241dabce6f 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -90,8 +90,9 @@ static void klp_synchronize_transition(void)
 static void klp_complete_transition(void)
 {
 	struct klp_object *obj;
-	struct klp_func *func;
+	struct klp_func *func, *next_func, *stack_top_func;
 	struct task_struct *g, *task;
+	struct klp_ops *ops;
 	unsigned int cpu;
 
 	pr_debug("'%s': completing %s transition\n",
@@ -119,9 +120,35 @@ static void klp_complete_transition(void)
 		klp_synchronize_transition();
 	}
 
-	klp_for_each_object(klp_transition_patch, obj)
-		klp_for_each_func(obj, func)
-			func->transition = false;
+	/*
+	* The transition patch is finished. The stack top function is now truly
+	* running. The previous function should be set as 0 as none task is 
+	* using this function anymore.
+	* 
+	* If this is a patching patch, all function is using.
+	* if this patch is unpatching, all function of the func stack top is using
+	*/
+	if (klp_target_state == KLP_TRANSITION_PATCHED)
+		klp_for_each_object(klp_transition_patch, obj)
+			klp_for_each_func(obj, func){
+				func->using = 1;
+				func->transition = false;
+				next_func = list_entry_rcu(func->stack_node.next,
+								struct klp_func, stack_node);
+				next_func->using = 0;
+			}
+	else
+		// for the unpatch func, if ops exist, the top of this func is using
+		klp_for_each_object(klp_transition_patch, obj)
+			klp_for_each_func(obj, func){
+				func->transition = false;
+				ops = klp_find_ops(func->old_func);
+				if (ops){
+					stack_top_func = list_first_entry(&ops->func_stack, struct klp_func,
+							stack_node);
+					stack_top_func->using = 1;
+				}
+			}
 
 	/* Prevent klp_ftrace_handler() from seeing KLP_TRANSITION_IDLE state */
 	if (klp_target_state == KLP_TRANSITION_PATCHED)
@@ -538,6 +565,7 @@ void klp_start_transition(void)
 		  klp_transition_patch->mod->name,
 		  klp_target_state == KLP_TRANSITION_PATCHED ? "patching" : "unpatching");
 
+
 	/*
 	 * Mark all normal tasks as needing a patch state update.  They'll
 	 * switch either in klp_try_complete_transition() or as they exit the
@@ -633,6 +661,9 @@ void klp_init_transition(struct klp_patch *patch, int state)
 	 *
 	 * When unpatching, the funcs are already in the func_stack and so are
 	 * already visible to the ftrace handler.
+	 * 
+	 * When this patch is in transition, all functions of this patch will
+	 * set to be unknown
 	 */
 	klp_for_each_object(patch, obj)
 		klp_for_each_func(obj, func)
-- 
2.18.2


