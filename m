Return-Path: <live-patching+bounces-276-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6767A8C9797
	for <lists+live-patching@lfdr.de>; Mon, 20 May 2024 02:58:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AB20281467
	for <lists+live-patching@lfdr.de>; Mon, 20 May 2024 00:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3E502F37;
	Mon, 20 May 2024 00:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KntSlvE7"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38031367;
	Mon, 20 May 2024 00:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716166720; cv=none; b=hsSiNI5tsqbyvXVMNLLM+DUBpicA8M9KR06oNApBzPUhIgD23OjIlfixZkg9F39RKDU5TyDmIr7+Rl9d9Bs3dyEXUt41gnN61xY8MRRGxfl7Lneg2HfuqU5jLcS5EJOapcZxHPbaHyX6C6GHnuR+SBASx8Wqj2LwExV91ZfT76I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716166720; c=relaxed/simple;
	bh=i1mOX2qbdDLFdh20/WuRl3gItDHEzJa60ng7LxxRFbQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BFlBTWIKrOm3BEOVJznculBu3yC8YUG/i6SZZ863TFAgrGMZtzQggCyeg8Ae5voWcycSBCig1yEHyT7VNR3P8zLM/rkM+wtU9CbxzkWiClWKbdUGFKkNMs8XrV6SSAYGa7y45+f6XjfyW/fhxf3IasGxgha0uUGGSitQxwogu4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KntSlvE7; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1ee42b97b32so60653055ad.2;
        Sun, 19 May 2024 17:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716166718; x=1716771518; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eDNaJH2eClVaWSLjdzfpUFgxTWpHFkUfhCj+owegG/o=;
        b=KntSlvE7YsOSALX5B0l1BhMD3zcza0S15qqHMAhoexmcghfzyHsYvQElihj+iWte84
         CKMlNNQDCnp6yxwiWsFw4hUeK8c+8GKlAnx24UbQPjm64b8CHe8oi6dPvYZoJkK+nREA
         Vc7ks9tn2+eAsS6R4+28Qzri44GOaFkks+oxut7p4c1+AUAY71H+O9G43aq+a/XKiF/e
         rLePh0NEKvoIgjX5NDyQuSIwp4obBR/TEP5rQNCQCKPFwWzbHnao4IBn0XiAtmPZhw0N
         rFJRfFc7x94W1+xtI4Y4bosEOOJ131SzbT3K2CijvcJWe3+fOI4rPRCbC2T5q4K2j1Dq
         Qiow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716166718; x=1716771518;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eDNaJH2eClVaWSLjdzfpUFgxTWpHFkUfhCj+owegG/o=;
        b=hkwh+GJ3Szq3UAgfBSUQDWQNBknp43GY5tY3Wt3tTssQthp6bliQzDzmaiOB4XQRdf
         gsztfWuLFKtZhUlxopBJf7vsBGfQka3omx8f3gbZ6sC3UU5IDtxS6PlKkc5H+J+hhl26
         yDDSUw+UhM776YmK90FD1nLrG4E/E7V69a+WIfMshOdYpASS5SQpi3YIe4olELKCStrv
         H5H0n736XTSAmdwaxSvMuVbq0GwIm1n+7GFD+JoHb26Cxt21A/s5z252LAxCOdu3WWb1
         qVmsgwAwSM2CKQfD2iucz4oMLv3+MS+8sQ1o1VgKDM9dFgvXDOPW7Rxds9VznNcouwi2
         rbfg==
X-Forwarded-Encrypted: i=1; AJvYcCWvgXMeA04u9udr1bO0b1Q/8RTrGo7F2v8OQ7N/QWpDWCrGB63VuIP/r6H/9c2VOD0CTAzY2OaY2zKWSFPC68iZfBGCnzu59oBBdIYM
X-Gm-Message-State: AOJu0YzwUVZznmF1COXYhI3ekgNKRv8U/qwHvBN3gI8xuK/f24o9mOxi
	z6CiJ9OZAij7PRPLdOM1wot253lV5zgKuvEJFJKwPPkFusMjRJ1O
X-Google-Smtp-Source: AGHT+IH1LWXde24576gl+A3hxZhqwMU0AHScEyfWun2C0EnHqt/S8ICFn/5tAIR5x0Mv7tJ+wDEypg==
X-Received: by 2002:a05:6a20:e687:b0:1b1:d2a5:c7b1 with SMTP id adf61e73a8af0-1b1d2a5c804mr3114746637.49.1716166718372;
        Sun, 19 May 2024 17:58:38 -0700 (PDT)
Received: from localhost.localdomain ([2409:895a:3250:11f0:652a:6d4c:60e5:a0ae])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0c25628esm190535385ad.288.2024.05.19.17.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 May 2024 17:58:38 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH] livepatch: introduce klp_func called interface
Date: Mon, 20 May 2024 08:58:26 +0800
Message-Id: <20240520005826.17281-1-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Livepatch module usually used to modify kernel functions.
If the patched function have bug, it may cause serious result
such as kernel crash.

This is a kobject attribute of klp_func. Sysfs interface named
 "called" is introduced to livepatch which will be set as true
if the patched function is called.

/sys/kernel/livepatch/<patch>/<object>/<function,sympos>/called

This value "called" is quite necessary for kernel stability
assurance for livepatching module of a running system.
Testing process is important before a livepatch module apply to
a production system. With this interface, testing process can
easily find out which function is successfully called.
Any testing process can make sure they have successfully cover
all the patched function that changed with the help of this interface.

Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
---
 include/linux/livepatch.h |  2 ++
 kernel/livepatch/core.c   | 18 ++++++++++++++++++
 kernel/livepatch/patch.c  |  2 ++
 3 files changed, 22 insertions(+)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 51a258c24ff5..026431825593 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -37,6 +37,7 @@
  * @nop:        temporary patch to use the original code again; dyn. allocated
  * @patched:	the func has been added to the klp_ops list
  * @transition:	the func is currently being applied or reverted
+ * @called:		the func is called
  *
  * The patched and transition variables define the func's patching state.  When
  * patching, a func is always in one of the following states:
@@ -75,6 +76,7 @@ struct klp_func {
 	bool nop;
 	bool patched;
 	bool transition;
+	bool called;
 };
 
 struct klp_object;
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 52426665eecc..a840ddd41d00 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -470,6 +470,22 @@ static struct attribute *klp_object_attrs[] = {
 };
 ATTRIBUTE_GROUPS(klp_object);
 
+static ssize_t called_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	struct klp_func *func;
+
+	func = container_of(kobj, struct klp_func, kobj);
+	return sysfs_emit(buf, "%d\n", func->called);
+}
+
+static struct kobj_attribute called_kobj_attr = __ATTR_RO(called);
+static struct attribute *klp_func_attrs[] = {
+	&called_kobj_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(klp_func);
+
 static void klp_free_object_dynamic(struct klp_object *obj)
 {
 	kfree(obj->name);
@@ -631,6 +647,7 @@ static void klp_kobj_release_func(struct kobject *kobj)
 static const struct kobj_type klp_ktype_func = {
 	.release = klp_kobj_release_func,
 	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = klp_func_groups,
 };
 
 static void __klp_free_funcs(struct klp_object *obj, bool nops_only)
@@ -903,6 +920,7 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
 static void klp_init_func_early(struct klp_object *obj,
 				struct klp_func *func)
 {
+	func->called = false;
 	kobject_init(&func->kobj, &klp_ktype_func);
 	list_add_tail(&func->node, &obj->func_list);
 }
diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
index 90408500e5a3..75b9603a183f 100644
--- a/kernel/livepatch/patch.c
+++ b/kernel/livepatch/patch.c
@@ -118,6 +118,8 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 	if (func->nop)
 		goto unlock;
 
+	if (!func->called)
+		func->called = true;
 	ftrace_regs_set_instruction_pointer(fregs, (unsigned long)func->new_func);
 
 unlock:
-- 
2.37.3


