Return-Path: <live-patching+bounces-529-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2104961C07
	for <lists+live-patching@lfdr.de>; Wed, 28 Aug 2024 04:24:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A93A284C2B
	for <lists+live-patching@lfdr.de>; Wed, 28 Aug 2024 02:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 079176F06A;
	Wed, 28 Aug 2024 02:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h3cJkYRu"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7525B216;
	Wed, 28 Aug 2024 02:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724811841; cv=none; b=IS/zmu6aiIb76aZxRWWnws0Z9OmDhC/ijLB2VeDxz+v3PK4V1wPEJxXvXTENFxyYBZQGwjzG942LZVU6f/NzvIJa3GxlYfgu58GKUUmXNVm/RCnuT3SN7cmE8fCC0sqPiOwwrn761ITLvzsauPBhSjHHIu+ZuZKCUbpBIwwNTNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724811841; c=relaxed/simple;
	bh=9SX8a6fxg211PPdUPv0mz1xzgQFeiMzfc8pdTIvXoeM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HTODrIlJfFaQKW9YlLkumq1Gi12lHALezK7QT6clZ/fAdJhZvXXOTVgJolNDfEA4bcnrII8Gpt2mWCtijraC81YGRTxejQ4UF66YYaCmlmZNBX7/diBBci/nX6ETbfTJkfMKc/XXtxocVTLaCPAUsAmsEK4BruyPoAzp0kZ7OQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h3cJkYRu; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7141feed424so5109569b3a.2;
        Tue, 27 Aug 2024 19:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724811840; x=1725416640; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gh38ouzXlc3LPCDCpc5MGhhAkNdqfcgEgGoNhQyyPFM=;
        b=h3cJkYRuCadARzZV0xTwDJdXX5srWWCyx7rhStmrOzkfn0tXbp2KzeOwZrQMfpt0VJ
         z5qTG2SvJKsO+jOP/pbZCYR24wxW53RJTIAdqvm2R/vp4Enr8wol4BKjNKZRoYcB1TfJ
         virMZNehUMbWBsaiGH0xpO2kyLa93Du8nVA+TAf2gvrCf4VcmRO5zskWHL0+j8Pad8zn
         EzsXYR0a8FRW5Aj2se3ipqjD87ONl9meqAWCk/Mw2kePZX0PBp7INxhzkgIPaer+k7zV
         JuxUaREfz1wfWdGU71Gd7OWx7CucKL/jkus17+KwDVCpjbkEXsZrxEnFbClbGLDuyt1C
         TE9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724811840; x=1725416640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gh38ouzXlc3LPCDCpc5MGhhAkNdqfcgEgGoNhQyyPFM=;
        b=DEPhiZ4S2lRJcEEBWIo4aBiwGb/3aEoUO2IFelSO8eSx8wnTlPmBKkszST16EKqqAs
         Niu81m0idzGFefOmY0p72alKBtb+1m2iEcrjo7Gy3ktpZP/3vruoU/e2msFNiXshGTNf
         tPoQ/JxVYfuresLHlc+SxUyQ2BJAwmpSym9dOidqleIDKE4TKGp7WoZUDcFj90KcWSLI
         qlOL9+ucxdwUzfaJcLdJpTtX5fbC+1nMNvLg6QphHWfcsuEATz3QW6Lm1qe/Rd35XlGa
         uNjt9lU7cqujbL7F3V82k1nly7nn8gKBGKPhB5+RVMsjLTo54508FRntRCLyW8vx4XV6
         005w==
X-Forwarded-Encrypted: i=1; AJvYcCVz6Dn9ZuzAJAXS9A6VLb7gVVOCBu8HG4hMMbTCk2Ui5iMlEFgYhbmWd4+c1sTRo0O8Opa8gL2SZYgsIyY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNCALkCiq6Me+KEn+oDg/P41geQx9BvkhisZQvIh+JpN5GQAFR
	HLinrYxWXXRVIJ5U0Q5LOYl1NBD0ksQ5ZlsGUepqp1N6xGZ8YmRD
X-Google-Smtp-Source: AGHT+IGOEhG6zyF5RGM/dd/kxcIn2ut4a6AVC67AcZmFZ+Y+ImdyifG8Djv5FnSR4dGRA2oyyfxdBg==
X-Received: by 2002:a05:6a21:4a4a:b0:1c6:fc7d:5546 with SMTP id adf61e73a8af0-1cc8b58dd97mr16361788637.37.1724811839585;
        Tue, 27 Aug 2024 19:23:59 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.122])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d8445db943sm270469a91.9.2024.08.27.19.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 19:23:59 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH v4 1/2] Introduce klp_ops into klp_func structure
Date: Wed, 28 Aug 2024 10:23:49 +0800
Message-Id: <20240828022350.71456-2-zhangwarden@gmail.com>
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

Before introduce feature "using". Klp transition will need an
easier way to get klp_ops from klp_func.

This patch make changes as follows:
1. Move klp_ops into klp_func structure.
Rewrite the logic of klp_find_ops and
other logic to get klp_ops of a function.

2. Move definition of struct klp_ops into
include/linux/livepatch.h

With this changes, we can get klp_ops of a klp_func easily. 
klp_find_ops can also be simple and straightforward. And we 
do not need to maintain one global list for now.

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


