Return-Path: <live-patching+bounces-507-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DDF795ABB4
	for <lists+live-patching@lfdr.de>; Thu, 22 Aug 2024 05:06:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12F4E28CDE3
	for <lists+live-patching@lfdr.de>; Thu, 22 Aug 2024 03:06:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7B5015C13A;
	Thu, 22 Aug 2024 03:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I6IdUap9"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBE11531D2;
	Thu, 22 Aug 2024 03:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295734; cv=none; b=rzq4r5vXieZEliMJuSf2yyGy0LIqFULeS3hc95RxKm9ClNfeiyIUkvlTGkckRxiBlSXrjlZDyjsIOgJm3BaVNumAUy6VhDjeazN3aE7wK8cv9H0IMZIhG0q6LT6I+x+TJD0X6k868N1TFv63U7wfCNC2+4XPTPjmqVqWZz3eUH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295734; c=relaxed/simple;
	bh=bZWLFjys3NIGBzgcT2U9dkvDvvCcmWI1KgUXIFSEGGg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Er0LnXzVGrhrNLBKco/M3egRjPasrRNn/lBLQ20/BZs8lSIm9IlQC0KUEIAjoFLv5T5gSS/MnYij8BPxknbGAIhExfdPte9yspNi5BKF8MJztwGyNs6Bf0xjqNHUFnpfByV75641ylBKkc5dz6nKBklKzqSpahecN+gIwX9rUZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I6IdUap9; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-202146e9538so3018805ad.3;
        Wed, 21 Aug 2024 20:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724295732; x=1724900532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Apcvyw1xq4hJ3a5464uCDyi79f8hZvk4+hLSTzZliGg=;
        b=I6IdUap9Qs/0iisPpmNEc/7BWV/FzcrH4MKF9IR8vqlrB+ELnu8o3VdXrvwxskKhYP
         xKWAY+DmAdUJAZ5Lad8K2bhryeyolUoyBwXQVBh/GJJcS/hk8Zpi0FlQb4DCAZBTZhg3
         zxtWh+AldzlDc+1HYyH/xFwm0XY6toP/QgbRsRJsKkXeI0GZdiqCj0ewH1HZv3L1eovk
         Pl7TlFDEseC7I63KNPCX0Nqr7e3gdRnqeiQRUfUU5evy/sgLUEIzP+KqqMDJ23Xcr+Qp
         EZo4YrhDgAwsnXK87sjgIrd1k8zUupymP5VUW8u7kAfnuDVEtug/oY6CZEwSdSVy6Zg5
         YeHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724295732; x=1724900532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Apcvyw1xq4hJ3a5464uCDyi79f8hZvk4+hLSTzZliGg=;
        b=b8HMbjkPIkk+LTfHYdjX0Xv5xl5I3fLy43c8k5dwmsMNOkO49uiHdwS1dpRYnitjU7
         V/WqzA9XUXJQAZnLAY/a3RsyJgdmBPp8hRutFUYY4mEcCeFC9ZYKGzcL6cgsNzEA+zon
         xQtFrkxGf4h6PnEmq1JxvL/6yYOIwPAzk+nSzJRGK6vqGZ981N5W66Mdl3MlMMZb11EH
         kwvbqRonvokkNirLfOKCLLxJE4RTjj91z6o759K+VsP2mf8qFX7TXyNiZA7Lbid83hXY
         3SNYq6p7ksOmlS/F4WgDxdLXA841v4IY+1sP3eE27pq8tUtAGGrw7st4hhcLfB5g5sk9
         33gw==
X-Forwarded-Encrypted: i=1; AJvYcCVVpGHkbVODGsSPlwHgDcEtGhizfUEtsyEQU/9F7XLqzaxOVO6iop8q1d5wsKLDzSdjHlXitcGuQ40r3uo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuHhAvISJLJ2NvtzKiE/HuPVs1atCnLPTUW74qowiez4iFCn/F
	Mjh7aLFwIs4ydiTCu1hTB/49gNxUmFGV5Yp36CiT+MpiMSadQ+4c
X-Google-Smtp-Source: AGHT+IHqrAzPdEy8ucnuyCnA3HRhS/NGuWuzYPMWl/TgXYazFlIoLDJM5radOPxGvdyJYNDY0ZtLLw==
X-Received: by 2002:a17:902:ced0:b0:1fa:abda:cf7b with SMTP id d9443c01a7336-2038820eb70mr6886025ad.9.1724295732535;
        Wed, 21 Aug 2024 20:02:12 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.124])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2038557f093sm2878835ad.63.2024.08.21.20.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 20:02:12 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH v3 2/2] livepatch: Add using attribute to klp_func for using function show
Date: Thu, 22 Aug 2024 11:01:59 +0800
Message-Id: <20240822030159.96035-3-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20240822030159.96035-1-zhangwarden@gmail.com>
References: <20240822030159.96035-1-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index d874aecc817b..5a6bacebd66f 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -57,6 +57,7 @@ struct klp_ops {
  * @nop:        temporary patch to use the original code again; dyn. allocated
  * @patched:	the func has been added to the klp_ops list
  * @transition:	the func is currently being applied or reverted
+ * @using:      the func is on top of the function stack that is using
  *
  * The patched and transition variables define the func's patching state.  When
  * patching, a func is always in one of the following states:
@@ -72,6 +73,12 @@ struct klp_ops {
  *   patched=1 transition=1: patched, may be visible to some tasks
  *   patched=0 transition=1: unpatched, temporary ending state
  *   patched=0 transition=0: unpatched
+ *
+ * 'using' flag is used to show if this function is now using
+ *
+ *   using=-1 (unknown): the function is now under transition
+ *   using=1  (using):   the function is now running
+ *   using=0  (not used): the function is not used
  */
 struct klp_func {
 	/* external */
@@ -96,6 +103,7 @@ struct klp_func {
 	bool nop;
 	bool patched;
 	bool transition;
+	int using;
 };
 
 struct klp_object;
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index e4572bf34316..bc1b2085e3c5 100644
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
@@ -775,6 +793,7 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
 	INIT_LIST_HEAD(&func->stack_node);
 	func->patched = false;
 	func->transition = false;
+	func->using = 0;
 
 	/* The format for the sysfs directory is <function,sympos> where sympos
 	 * is the nth occurrence of this symbol in kallsyms for the patched
diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
index 8ab9c35570f4..5138cedfcfaa 100644
--- a/kernel/livepatch/patch.c
+++ b/kernel/livepatch/patch.c
@@ -134,6 +134,7 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 static void klp_unpatch_func(struct klp_func *func)
 {
 	struct klp_ops *ops;
+	struct klp_func *stack_top_func;
 
 	if (WARN_ON(!func->patched))
 		return;
@@ -160,6 +161,10 @@ static void klp_unpatch_func(struct klp_func *func)
 		kfree(ops);
 	} else {
 		list_del_rcu(&func->stack_node);
+		// the previous function is deleted, the stack top is under transition
+		stack_top_func = list_first_entry(&ops->func_stack, struct klp_func,
+							stack_node);
+		stack_top_func->using = -1;
 	}
 
 	func->patched = false;
@@ -168,6 +173,7 @@ static void klp_unpatch_func(struct klp_func *func)
 static int klp_patch_func(struct klp_func *func)
 {
 	struct klp_ops *ops;
+	struct klp_func *stack_top_func;
 	int ret;
 
 	if (WARN_ON(!func->old_func))
@@ -219,10 +225,16 @@ static int klp_patch_func(struct klp_func *func)
 
 		func->ops = ops;
 	} else {
+		// stack_top_func is going to be in transition
+		stack_top_func = list_first_entry(&ops->func_stack, struct klp_func,
+							stack_node);
+		stack_top_func->using = -1;
+		// The new patched function is the one enabling
 		list_add_rcu(&func->stack_node, &ops->func_stack);
 	}
 
 	func->patched = true;
+	func->using = -1;
 
 	return 0;
 
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index d9a3f9c7a93b..365dac635efe 100644
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
@@ -119,9 +120,39 @@ static void klp_complete_transition(void)
 		klp_synchronize_transition();
 	}
 
-	klp_for_each_object(klp_transition_patch, obj)
-		klp_for_each_func(obj, func)
-			func->transition = false;
+	/*
+	 * The transition patch is finished. The stack top function is now truly
+	 * running. The previous function should be set as 0 as none task is
+	 * using this function anymore.
+	 *
+	 * If this is a patching patch, all function is using.
+	 * if this patch is unpatching, all function of the func stack top is using
+	 */
+	if (klp_target_state == KLP_TRANSITION_PATCHED) {
+		klp_for_each_object(klp_transition_patch, obj) {
+			klp_for_each_func(obj, func) {
+				func->using = 1;
+				func->transition = false;
+				next_func = list_entry_rcu(func->stack_node.next,
+								struct klp_func, stack_node);
+				if (&func->stack_node != &func->ops->func_stack)
+					next_func->using = 0;
+			}
+		}
+	} else {
+		// for the unpatch func, if ops exist, the top of this func is using
+		klp_for_each_object(klp_transition_patch, obj) {
+			klp_for_each_func(obj, func) {
+				func->transition = false;
+				ops = func->ops;
+				if (ops) {
+					stack_top_func = list_first_entry(&ops->func_stack,
+							struct klp_func, stack_node);
+					stack_top_func->using = 1;
+				}
+			}
+		}
+	}
 
 	/* Prevent klp_ftrace_handler() from seeing KLP_TRANSITION_IDLE state */
 	if (klp_target_state == KLP_TRANSITION_PATCHED)
-- 
2.18.2


