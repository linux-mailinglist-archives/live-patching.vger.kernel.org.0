Return-Path: <live-patching+bounces-506-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0276A95ABB2
	for <lists+live-patching@lfdr.de>; Thu, 22 Aug 2024 05:06:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 232A31C24E40
	for <lists+live-patching@lfdr.de>; Thu, 22 Aug 2024 03:06:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B94A14EC59;
	Thu, 22 Aug 2024 03:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lIVeahH2"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DD714BF98;
	Thu, 22 Aug 2024 03:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295731; cv=none; b=qqp8m1ygG4Q0aFcwGzluEWPWhB45YnsKTNzHfLPQ/riYLd4aRVl8+6r1B8oaxZINR0M60cp2/VyebHO/v1DWMf7sRjxv+856Xzed93Z+KGtF3wi9yu2ojU0ij55JNCN0QKdJSw1LII6UWZdxsaI0B2wNEooO81fcJmTj5GgniXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295731; c=relaxed/simple;
	bh=EFhTdL4JDrWhz7egQuKLZtyT8qFxrU8THk0T+Y1e/Ek=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kP67XD6VVs6gpZM0dA/Lrij7rJrGuzOL+FW+/BaFsPhILd0WVsukp8ecUt1Vk+TApHUydJDtk44mEK4XIUI3Jg5u6hBOHfvTWYYFIsX25Pj7IeCauylN/OX4kNM5EA3S3ozGGP5EfNs5ZfqXrWd2ERwO34UPyOJO7LqMSTz0hJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lIVeahH2; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1fee6435a34so2335155ad.0;
        Wed, 21 Aug 2024 20:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724295729; x=1724900529; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jXffx1MNp7jjR5lJ90c1VAOlUzhYbo/9PPCBtdxT0r8=;
        b=lIVeahH2XBWLvHMzRTQJOlHL+/31kcDyMTicQowP9PC9hAM3SulAoL26gWxXDDEpGi
         rUNkEtmLhw1j8UwN6589OGk2/calLXw/Wa2Fh2rs5/fh0N0JN6NvhV/i0eVMq5bHFsYS
         Md/yFzdBN67AvoWhhUB7THiuSCulg43SuWSpRYBlycqAWkqtVWCTuhK5xXpXtLlNnKLe
         M46rfrju/GCcrd+Aecpb9cRNn/HIjk3vvcWlsVDA7Q8WfsUlE2e45nTjsui1mCHbDf3/
         EAf75Xm6MGEDV8X+n37Xw1Rfgl+OzbLhJfCfLE4iBise8LYdHUW3q60nDAYTgvBEygf1
         GTNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724295729; x=1724900529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jXffx1MNp7jjR5lJ90c1VAOlUzhYbo/9PPCBtdxT0r8=;
        b=ph3ZUlzoBS4TZfkSDwS4JaTTH+J8roiyGBdPyTSpEEDeYF6Pw0tJGApbnEZfL1YMO2
         XjbUheQUEcYDWrfTISXRQkAe84LOCR4+98ypY67LEDDk7SvQwqp7Aa1cpe7QhepzaH5J
         twpyJj7o6zPbVLdQpKPceCZXK3ZoW2MUYYugJRASs/glT1nNR6msaMpI6uCm9yzLqCo9
         Xr72M0IEkR9H9fxESO9H6Ali7tfBamDNN5GVdOMuUSN/ZzB9vyWvgrwcbcf9BYxc9K0z
         271gPLeSOOJ0+OnG+2CQ53ANO67fVju6ZHNHvd4D4pn7fLn4jYbT2L3gtWbMzWKEOXWV
         diFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLoPNzw8EaJwpcT+yXp8JZuxX2B2E+khMgzIAT1IF6IOsVJ4Es/KtCn1y6E22L2Rp4FBHQcSnLCQL70yA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8juYSSxqxuvqCcS/EpgKIgpGqnMtioRqrIDkrmpTZDdjjfzVY
	kAMmeYPjzXEFFNM/bVe+35Ls2KRZ4Tfj0xsgosGMFF/qe7CfLQi8
X-Google-Smtp-Source: AGHT+IHHMd9z8kgAqFrYKywxvNfRu7JWKk0JqlA9ppU56T5BJVF5x00DtN7oEJWPaYB5AZv/rGC0gA==
X-Received: by 2002:a17:903:2343:b0:202:330f:1512 with SMTP id d9443c01a7336-203681e3acdmr43158565ad.44.1724295728935;
        Wed, 21 Aug 2024 20:02:08 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.124])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2038557f093sm2878835ad.63.2024.08.21.20.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 20:02:08 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH v3 1/2] Introduce klp_ops into klp_func structure
Date: Thu, 22 Aug 2024 11:01:58 +0800
Message-Id: <20240822030159.96035-2-zhangwarden@gmail.com>
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

1. Move klp_ops into klp_func structure.
Rewrite the logic of klp_find_ops and
other logic to get klp_ops of a function.

2. Move definition of struct klp_ops into
include/linux/livepatch.h

Signed-off-by: Wardenjohn <zhangwarden@gmail.com>

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 51a258c24ff5..d874aecc817b 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -22,6 +22,25 @@
 #define KLP_TRANSITION_UNPATCHED	 0
 #define KLP_TRANSITION_PATCHED		 1
 
+/**
+ * struct klp_ops - structure for tracking registered ftrace ops structs
+ *
+ * A single ftrace_ops is shared between all enabled replacement functions
+ * (klp_func structs) which have the same old_func.  This allows the switch
+ * between function versions to happen instantaneously by updating the klp_ops
+ * struct's func_stack list.  The winner is the klp_func at the top of the
+ * func_stack (front of the list).
+ *
+ * @node:	node for the global klp_ops list
+ * @func_stack:	list head for the stack of klp_func's (active func is on top)
+ * @fops:	registered ftrace ops struct
+ */
+struct klp_ops {
+	struct list_head node;
+	struct list_head func_stack;
+	struct ftrace_ops fops;
+};
+
 /**
  * struct klp_func - function structure for live patching
  * @old_name:	name of the function to be patched
@@ -32,6 +51,7 @@
  * @kobj:	kobject for sysfs resources
  * @node:	list node for klp_object func_list
  * @stack_node:	list node for klp_ops func_stack list
+ * @ops:	pointer to klp_ops struct for this function
  * @old_size:	size of the old function
  * @new_size:	size of the new function
  * @nop:        temporary patch to use the original code again; dyn. allocated
@@ -71,6 +91,7 @@ struct klp_func {
 	struct kobject kobj;
 	struct list_head node;
 	struct list_head stack_node;
+	struct klp_ops *ops;
 	unsigned long old_size, new_size;
 	bool nop;
 	bool patched;
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 52426665eecc..e4572bf34316 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -760,6 +760,8 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
 	if (!func->old_name)
 		return -EINVAL;
 
+	func->ops = NULL;
+
 	/*
 	 * NOPs get the address later. The patched module must be loaded,
 	 * see klp_init_object_loaded().
diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
index 90408500e5a3..8ab9c35570f4 100644
--- a/kernel/livepatch/patch.c
+++ b/kernel/livepatch/patch.c
@@ -20,18 +20,25 @@
 #include "patch.h"
 #include "transition.h"
 
-static LIST_HEAD(klp_ops);
 
 struct klp_ops *klp_find_ops(void *old_func)
 {
-	struct klp_ops *ops;
+	struct klp_patch *patch;
+	struct klp_object *obj;
 	struct klp_func *func;
 
-	list_for_each_entry(ops, &klp_ops, node) {
-		func = list_first_entry(&ops->func_stack, struct klp_func,
-					stack_node);
-		if (func->old_func == old_func)
-			return ops;
+	klp_for_each_patch(patch) {
+		klp_for_each_object(patch, obj) {
+			klp_for_each_func(obj, func) {
+				/*
+				 * Ignore entry where func->ops has not been
+				 * assigned yet. It is most likely the one
+				 * which is about to be created/added.
+				 */
+				if (func->old_func == old_func && func->ops)
+					return func->ops;
+			}
+		}
 	}
 
 	return NULL;
@@ -133,7 +140,7 @@ static void klp_unpatch_func(struct klp_func *func)
 	if (WARN_ON(!func->old_func))
 		return;
 
-	ops = klp_find_ops(func->old_func);
+	ops = func->ops;
 	if (WARN_ON(!ops))
 		return;
 
@@ -149,6 +156,7 @@ static void klp_unpatch_func(struct klp_func *func)
 
 		list_del_rcu(&func->stack_node);
 		list_del(&ops->node);
+		func->ops = NULL;
 		kfree(ops);
 	} else {
 		list_del_rcu(&func->stack_node);
@@ -168,7 +176,7 @@ static int klp_patch_func(struct klp_func *func)
 	if (WARN_ON(func->patched))
 		return -EINVAL;
 
-	ops = klp_find_ops(func->old_func);
+	ops = func->ops;
 	if (!ops) {
 		unsigned long ftrace_loc;
 
@@ -191,8 +199,6 @@ static int klp_patch_func(struct klp_func *func)
 				  FTRACE_OPS_FL_IPMODIFY |
 				  FTRACE_OPS_FL_PERMANENT;
 
-		list_add(&ops->node, &klp_ops);
-
 		INIT_LIST_HEAD(&ops->func_stack);
 		list_add_rcu(&func->stack_node, &ops->func_stack);
 
@@ -211,7 +217,7 @@ static int klp_patch_func(struct klp_func *func)
 			goto err;
 		}
 
-
+		func->ops = ops;
 	} else {
 		list_add_rcu(&func->stack_node, &ops->func_stack);
 	}
@@ -224,6 +230,7 @@ static int klp_patch_func(struct klp_func *func)
 	list_del_rcu(&func->stack_node);
 	list_del(&ops->node);
 	kfree(ops);
+	func->ops = NULL;
 	return ret;
 }
 
diff --git a/kernel/livepatch/patch.h b/kernel/livepatch/patch.h
index d5f2fbe373e0..21d0d20b7189 100644
--- a/kernel/livepatch/patch.h
+++ b/kernel/livepatch/patch.h
@@ -6,25 +6,6 @@
 #include <linux/list.h>
 #include <linux/ftrace.h>
 
-/**
- * struct klp_ops - structure for tracking registered ftrace ops structs
- *
- * A single ftrace_ops is shared between all enabled replacement functions
- * (klp_func structs) which have the same old_func.  This allows the switch
- * between function versions to happen instantaneously by updating the klp_ops
- * struct's func_stack list.  The winner is the klp_func at the top of the
- * func_stack (front of the list).
- *
- * @node:	node for the global klp_ops list
- * @func_stack:	list head for the stack of klp_func's (active func is on top)
- * @fops:	registered ftrace ops struct
- */
-struct klp_ops {
-	struct list_head node;
-	struct list_head func_stack;
-	struct ftrace_ops fops;
-};
-
 struct klp_ops *klp_find_ops(void *old_func);
 
 int klp_patch_object(struct klp_object *obj);
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index ba069459c101..d9a3f9c7a93b 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -230,7 +230,7 @@ static int klp_check_stack_func(struct klp_func *func, unsigned long *entries,
 		 * Check for the to-be-patched function
 		 * (the previous func).
 		 */
-		ops = klp_find_ops(func->old_func);
+		ops = func->ops;
 
 		if (list_is_singular(&ops->func_stack)) {
 			/* original function */
-- 
2.18.2


