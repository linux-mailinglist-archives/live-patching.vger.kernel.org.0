Return-Path: <live-patching+bounces-398-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F0DF934FE4
	for <lists+live-patching@lfdr.de>; Thu, 18 Jul 2024 17:28:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C75C81F21B79
	for <lists+live-patching@lfdr.de>; Thu, 18 Jul 2024 15:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6652F1442E8;
	Thu, 18 Jul 2024 15:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZLemsSiT"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D672E143C55;
	Thu, 18 Jul 2024 15:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721316508; cv=none; b=O08N2Snr12vYMvSTbOOggyZrU9MPM4Nr9fhELAGoPUpgis8ZcEbXYOQ1vRe9IwD6GopyK9maDQaJRPFrKSeK5PuawovWNFnxK7/AfeEAyRA+Yo2vE61gQEroQTNyLpGac0IwJvd7klmb8YWmW/Rkz5p4ZFiiLfO6jMAxpC4CaPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721316508; c=relaxed/simple;
	bh=CVedG02G4At671gc+bKwvuSf2MZj/HrTTu8hpNydjGM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HlZz7Ei9ofNIK0ebcs6kKsWUF/hl2GninagGT6dvddf3WY+gHbLJOrVa5cEpnPzB4jfO8pPzdJGaXx2hboKMyfblbKO8qskXtpv0qJm+kLPy8h/GmBYtmiUStL1ZxiDFWANNo5gHf4BSi+xEFNS0zj62WvjmbrmRKGZHFw8pQkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZLemsSiT; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-70b0d0fefe3so751884b3a.2;
        Thu, 18 Jul 2024 08:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721316506; x=1721921306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nPDXT7LzfjA0TQveYTgHULbKtYYHuRlOhGoNHy98wN4=;
        b=ZLemsSiTk950dQ9ii2WFJ5FwJWV1DMNUXd9UobfSC8K1SA7kwrXspx+kINVr+DRo4z
         +qQut6lqp1x3ildsy2k23ymkdwtzg2k16zxddbj6BjGqMP4sXWxHLgehcKycrkdOvAOI
         54TOtCZTjW/yDJZraJXiAQhGlAKFnbpoCQs3WHl94ldCsH8HZHLowX3XBoYr36/Mq4PM
         aUk1pxhm9GQjIzL0eRWpRZ9xlYOoVVsraHuvxirp0P+urA42lVZ5sp8zEq3C91YtrVTe
         +ord2XcQeIzPta1+5ZtV7xarf8X+4OSl09B0y+NjVLuhfoEViEPRw3azLQBJlBok+Pud
         O5dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721316506; x=1721921306;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nPDXT7LzfjA0TQveYTgHULbKtYYHuRlOhGoNHy98wN4=;
        b=Ugzcn2DDRi85XiRIiHXEfG013o8FKE5J6GAGtgGmwKgzXkAIDSqumjtjtaagTAdBTB
         tgxO68Ac297XXAJl/Tu1jeXJFVpVgZPdlkrqKOdqGLRVg2WDBKEWOdN9FUXJcnJoLR/r
         4H99EtBnzg4LW9R+zynB9fprn722FGLfiNxPN/jZ2AiA6ijis8NBNud3+E/5RiKz4BEp
         ntHcRPyFMRAR2Pn7L3gpWiYGdNYwntXTAhPe6n9z08aN4LGa6qsyvdnq+OU16FQ60cJ4
         0RWWy4fEEmSEjoAKKLhDE5ZMhSX8JqTY6fl17Vv7MeRbeoFx1N3JsMdXX089bhtIUAWO
         cUow==
X-Forwarded-Encrypted: i=1; AJvYcCXWDFK3upmbsAUqM+U90gfDSx3fCTHF/HYUQPZcWBzWWzCGtS6YUXhdNMk91NNRIJ3KhuwQoWJfWE2lBtQOwcn4dwXsZGpRVpo1tB2B
X-Gm-Message-State: AOJu0Yxk+DG7Ml0E3qp0jY0BUl1kZZtZx0hmPe2qcSXYfyzgdYdWQ1Uu
	fxPPhChM0uN8hc2U3qPRujoLvEYi8PcxSuAJBcfP9fU5iECR5eT5
X-Google-Smtp-Source: AGHT+IFhMCM8du2CyAbSRCE2/FWL5NeGbGZjxxsDTrvN1kC2CXIfPodCyKxuQ34eHrdeuLOIr4xwOw==
X-Received: by 2002:a05:6a20:1586:b0:1c2:a59e:5afd with SMTP id adf61e73a8af0-1c3fdd3bd60mr6571904637.39.1721316505975;
        Thu, 18 Jul 2024 08:28:25 -0700 (PDT)
Received: from localhost.localdomain ([120.229.27.152])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fc0bb6fdc9sm94749205ad.52.2024.07.18.08.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 08:28:25 -0700 (PDT)
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
Subject: [PATCH] livepatch: Add using attribute to klp_func for using func show
Date: Thu, 18 Jul 2024 23:28:07 +0800
Message-Id: <20240718152807.92422-1-zhangyongde.zyd@alibaba-inc.com>
X-Mailer: git-send-email 2.37.3
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

cat /sys/kernel/livepatch/<patch1>/<object1>/<function1,sympos>/using -> 0
means that the function1 of patch1 is disabled.

cat /sys/kernel/livepatch/<patchN>/<object1>/<function1,sympos>/using -> 1
means that the function1 of patchN is enabled.

Signed-off-by: Wardenjohn <zhangwarden@gmail.com>

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 51a258c24ff5..26519c134578 100644
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
@@ -75,6 +76,7 @@ struct klp_func {
 	bool nop;
 	bool patched;
 	bool transition;
+	bool using;
 };
 
 struct klp_object;
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 52426665eecc..b938667f96e3 100644
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
@@ -903,6 +921,7 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
 static void klp_init_func_early(struct klp_object *obj,
 				struct klp_func *func)
 {
+	func->using = false;
 	kobject_init(&func->kobj, &klp_ktype_func);
 	list_add_tail(&func->node, &obj->func_list);
 }
diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
index 90408500e5a3..561bfb3f59f7 100644
--- a/kernel/livepatch/patch.c
+++ b/kernel/livepatch/patch.c
@@ -127,6 +127,7 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 static void klp_unpatch_func(struct klp_func *func)
 {
 	struct klp_ops *ops;
+	struct klp_func *stack_top_func;
 
 	if (WARN_ON(!func->patched))
 		return;
@@ -152,6 +153,9 @@ static void klp_unpatch_func(struct klp_func *func)
 		kfree(ops);
 	} else {
 		list_del_rcu(&func->stack_node);
+		stack_top_func = list_first_entry(&ops->func_stack, struct klp_func,
+							stack_node);
+		stack_top_func->using = true;
 	}
 
 	func->patched = false;
@@ -160,6 +164,7 @@ static void klp_unpatch_func(struct klp_func *func)
 static int klp_patch_func(struct klp_func *func)
 {
 	struct klp_ops *ops;
+	struct klp_func *stack_top_func;
 	int ret;
 
 	if (WARN_ON(!func->old_func))
@@ -170,6 +175,7 @@ static int klp_patch_func(struct klp_func *func)
 
 	ops = klp_find_ops(func->old_func);
 	if (!ops) {
+		// this function is the first time to be patched
 		unsigned long ftrace_loc;
 
 		ftrace_loc = ftrace_location((unsigned long)func->old_func);
@@ -211,9 +217,15 @@ static int klp_patch_func(struct klp_func *func)
 			goto err;
 		}
 
-
+		func->using = true;
 	} else {
+		// find the function that enabling at this time and mark it disabled.
+		stack_top_func = list_first_entry(&ops->func_stack, struct klp_func,
+							stack_node);
+		stack_top_func->using = false;
+		// now, this new patched function is the one enabling
 		list_add_rcu(&func->stack_node, &ops->func_stack);
+		func->using = true;
 	}
 
 	func->patched = true;
-- 
2.18.2


