Return-Path: <live-patching+bounces-530-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C394961C09
	for <lists+live-patching@lfdr.de>; Wed, 28 Aug 2024 04:24:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 67304B2291E
	for <lists+live-patching@lfdr.de>; Wed, 28 Aug 2024 02:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F4E12CDBF;
	Wed, 28 Aug 2024 02:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DuJ/6eA4"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30B883A18;
	Wed, 28 Aug 2024 02:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724811845; cv=none; b=drSUJqJylCYwFrDU55MnsWe9uqew/TmMigwVNGd1nhE//RLRKZsIvV87E3F0ELBp71WS+5RLRoh9jdP/2KweEaPvYM33IuJ6Nq4373xyYXNDmB/ug/fRSctJTIfrtQaO9vB0bhhKjAESG9vldVbViCrU3x2DA2f76YrniROWxTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724811845; c=relaxed/simple;
	bh=bZWLFjys3NIGBzgcT2U9dkvDvvCcmWI1KgUXIFSEGGg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f7ggyuv3KVEH/vXd0LKrEp/HEohSj3czLvIofj2W6LBlm+H685MnhG1scDtkBl+wMtlAUB+wHY5bqltJBbQTTxODYkGZgPWKdLlZPACIItEd5C5oU6YJJYI3+xOkadpIQV5tMTQCFW2HdiGtg+Ed06ocdSuTcaVNlVt1mydp/Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DuJ/6eA4; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2d3b36f5366so4418038a91.0;
        Tue, 27 Aug 2024 19:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724811843; x=1725416643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Apcvyw1xq4hJ3a5464uCDyi79f8hZvk4+hLSTzZliGg=;
        b=DuJ/6eA4keR7kCTYzIkN3DUq/q2Od0KgGTo6jxDhU79xrJk9PqfPOEnaR5WmDbS6Sj
         suTmRZCTP2liufvdqL3v97mk1v6Wf1aWvHb520ZoCsV7jlOaFGFSn3+LWUNeDDN+IZcw
         d1clo9c6Y+/DDhIlzSf10TVSmwx1sq62LX7ybK3Q1HchTE4UB9n/f1zDpYuQ0UuSAKPe
         +ZyQe7PxgNN2c3ddwhR5TOhadGMojA7C7ArA8l76hwoQqjuMdynJ+Rz3cEEDgYYMvCP+
         VI7zgPwhjqjjiIffaEL1dVBvcMlSxYZ+hc93wpFe7YXh0E000bAyrSDm3q6ID+3VsFkE
         XXRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724811843; x=1725416643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Apcvyw1xq4hJ3a5464uCDyi79f8hZvk4+hLSTzZliGg=;
        b=hrsnBLlRxKejx7cJu6SykQUO32yHaYH/+gn0YhEcja8vDv0vTGkz0MOp5IsUB5F/LO
         NimSywTStj9DbS1sxkBok0BksPKJFoz6q0ZXyc8Ig9rIFtTRK/eSI5qkaW78iF6lBou7
         Upp2KvgftEmX92cWakB26mzA+gSSKT3ocelDaRq6SIIRUGFB40/qy8S2Q709+vCn1bSA
         DS6dyzr7pFmJAk62nCsx5b7UD/FB5LkKSKwRR5yKZvIyzUFF41wQlg2c7AeozjYS91XB
         hTEnhad09HXplHkDJy8d+G5UF6bpY2PkLCQRl5JwyAHt7yNOytB5LW7ubEIu69+Jp+ZY
         jDsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZ0G8jvyHA73fqqSq0A33TEV+GFQoMUPo7oPrw6v2qCrNESZpK3VYVmqQThWT3JwPb8ptxRe77Cf7wMpE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPFEixv9OFQqyafYPcDl3s0RZoj4WfoL1EFJE6jcMF5cvHmIGj
	Wu98FjDZRCs7riF7Kt9qNwjZHhGmVQIT9LgiCXga1p2q78zoEiCV
X-Google-Smtp-Source: AGHT+IEgLe/H8gVjxowQ17a3WJxHaMd6VDZzYcc2jhxPLwTa+4yBu4mDNVV0J+9RTZI0T0knV9QGIw==
X-Received: by 2002:a17:90b:180f:b0:2d3:d414:4511 with SMTP id 98e67ed59e1d1-2d8440eb8bdmr786382a91.24.1724811843173;
        Tue, 27 Aug 2024 19:24:03 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.122])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d8445db943sm270469a91.9.2024.08.27.19.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 19:24:02 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH v4 2/2] livepatch: Add using attribute to klp_func for using function show
Date: Wed, 28 Aug 2024 10:23:50 +0800
Message-Id: <20240828022350.71456-3-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20240828022350.71456-1-zhangwarden@gmail.com>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
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


