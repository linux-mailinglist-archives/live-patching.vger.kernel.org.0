Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8772247C32A
	for <lists+live-patching@lfdr.de>; Tue, 21 Dec 2021 16:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhLUPkf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Dec 2021 10:40:35 -0500
Received: from mail-qt1-f169.google.com ([209.85.160.169]:37381 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234903AbhLUPkf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Dec 2021 10:40:35 -0500
Received: by mail-qt1-f169.google.com with SMTP id f9so1187613qtk.4;
        Tue, 21 Dec 2021 07:40:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K/7/aJ245qHZBRnwrgebDMGdYWGyeFFsJAMEqsKGr5E=;
        b=vDhHAOnNBS0/gVyrPxGtoMssCoyw1wTX4OLXiUYqRppPtJ/QBUAyugpD0OGXtWbQBT
         k4ZebSHggvYCaJPWvwQ6vP3qO4Fi5MozmuwDxbnv36hIe9/J9tVNaK5Jpo/erBg7jAyP
         enj1qWhWtmny3B4kWVc+QB4aos4aiKCuQIF4PElBqFI8g0pT5ZtzWN1oZuXO8NIPl2D6
         tw681aik4fLsWquRSNbD1kH3zA+g7JNHj0Jfx9zCZRAGpXCe1mS5ak3lmACLqGQCEqV5
         9nmKYvu7qSZxbM+op4v45UcmaWGIKaQHO7JKztXr4zQsGqsEGy0QqgTYeUxb+eV08RGK
         UB2Q==
X-Gm-Message-State: AOAM530CNW1dfIAX5zVizZY1ByGXTh/2nX9/dC+JHj1PlK2c8cCVwjgg
        j1a3rZJX1/HvZiQ8YaudUINwOs6YVT9hQg==
X-Google-Smtp-Source: ABdhPJxgXnHuHH/pOEjG1VrbJI75Nxg9kpYOj5UFM3wgUlhoOwob9WyXgMfpHbUdTsdACURDmI4deQ==
X-Received: by 2002:a05:622a:1a1c:: with SMTP id f28mr2662366qtb.308.1640101234068;
        Tue, 21 Dec 2021 07:40:34 -0800 (PST)
Received: from localhost (fwdproxy-ash-018.fbsv.net. [2a03:2880:20ff:12::face:b00c])
        by smtp.gmail.com with ESMTPSA id k8sm13594143qko.130.2021.12.21.07.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:40:33 -0800 (PST)
From:   David Vernet <void@manifault.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, pmladek@suse.com, jikos@kernel.org,
        mbenes@suse.cz, joe.lawrence@redhat.com, corbet@lwn.net
Cc:     void@manifault.com
Subject: [PATCH v3] livepatch: Fix kobject refcount bug on klp_init_patch_early failure path
Date:   Tue, 21 Dec 2021 07:39:31 -0800
Message-Id: <20211221153930.137579-1-void@manifault.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

When enabling a klp patch with klp_enable_patch(), klp_init_patch_early()
is invoked to initialize the kobjects for the patch itself, as well as the
'struct klp_object' and 'struct klp_func' objects that comprise it.
However, there are some error paths in klp_enable_patch() where some
kobjects may have been initialized with kobject_init(), but an error code
is still returned due to e.g. a 'struct klp_object' having a NULL funcs
pointer.

In these paths, the initial reference of the kobject of the 'struct
klp_patch' may never be released, along with one or more of its objects and
their functions, as kobject_put() is not invoked on the cleanup path if
klp_init_patch_early() returns an error code.

For example, if an object entry such as the following were added to the
sample livepatch module's klp patch, it would cause the vmlinux klp_object,
and its klp_func which updates 'cmdline_proc_show', to never be released:

static struct klp_object objs[] = {
	{
		/* name being NULL means vmlinux */
		.funcs = funcs,
	},
	{
		/* NULL funcs -- would cause reference leak */
		.name = "kvm",
	}, { }
};

Without this change, if CONFIG_DEBUG_KOBJECT is enabled, and the sample klp
patch is loaded, the kobjects (the patch, the vmlinux 'struct klp_object',
and its func) are observed as initialized, but never released, in the dmesg
log output.  With the change, these kobject references no longer fail to be
released as the error case is properly handled before they are initialized.

Signed-off-by: David Vernet <void@manifault.com>
---
v3:
  - Update patch description to not specifically claim to be fixing a
    "leak", but rather a kobject reference counting bug.
  - Make klp_init_patch_early() void to match klp_init_object_early() and
    klp_init_func_early(), and move the arg validation that previously
    resided there into klp_enable_patch() (where other argument validation
    logic already resides).

v2:
  - Move try_module_get() and the patch->objs NULL check out of
    klp_init_patch_early() to ensure that it's safe to jump to the 'err'
    label on the error path in klp_enable_patch().
  - Fix the patch description to not use markdown, and to use imperative
    language.

 kernel/livepatch/core.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 335d988bd811..7d228cdb44c5 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -862,14 +862,11 @@ static void klp_init_object_early(struct klp_patch *patch,
 	list_add_tail(&obj->node, &patch->obj_list);
 }
 
-static int klp_init_patch_early(struct klp_patch *patch)
+static void klp_init_patch_early(struct klp_patch *patch)
 {
 	struct klp_object *obj;
 	struct klp_func *func;
 
-	if (!patch->objs)
-		return -EINVAL;
-
 	INIT_LIST_HEAD(&patch->list);
 	INIT_LIST_HEAD(&patch->obj_list);
 	kobject_init(&patch->kobj, &klp_ktype_patch);
@@ -879,20 +876,12 @@ static int klp_init_patch_early(struct klp_patch *patch)
 	init_completion(&patch->finish);
 
 	klp_for_each_object_static(patch, obj) {
-		if (!obj->funcs)
-			return -EINVAL;
-
 		klp_init_object_early(patch, obj);
 
 		klp_for_each_func_static(obj, func) {
 			klp_init_func_early(obj, func);
 		}
 	}
-
-	if (!try_module_get(patch->mod))
-		return -ENODEV;
-
-	return 0;
 }
 
 static int klp_init_patch(struct klp_patch *patch)
@@ -1024,10 +1013,17 @@ static int __klp_enable_patch(struct klp_patch *patch)
 int klp_enable_patch(struct klp_patch *patch)
 {
 	int ret;
+	struct klp_object *obj;
 
-	if (!patch || !patch->mod)
+	if (!patch || !patch->mod || !patch->objs)
 		return -EINVAL;
 
+	klp_for_each_object_static(patch, obj) {
+		if (!obj->funcs)
+			return -EINVAL;
+	}
+
+
 	if (!is_livepatch_module(patch->mod)) {
 		pr_err("module %s is not marked as a livepatch module\n",
 		       patch->mod->name);
@@ -1051,11 +1047,10 @@ int klp_enable_patch(struct klp_patch *patch)
 		return -EINVAL;
 	}
 
-	ret = klp_init_patch_early(patch);
-	if (ret) {
-		mutex_unlock(&klp_mutex);
-		return ret;
-	}
+	if (!try_module_get(patch->mod))
+		return -ENODEV;
+
+	klp_init_patch_early(patch);
 
 	ret = klp_init_patch(patch);
 	if (ret)
-- 
2.30.2

