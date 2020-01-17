Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9775F140D3B
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgAQPD6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:03:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:46120 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729066AbgAQPD6 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:03:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 952F1AFA8;
        Fri, 17 Jan 2020 15:03:56 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 05/23] livepatch: Initialize and free livepatch submodule
Date:   Fri, 17 Jan 2020 16:03:05 +0100
Message-Id: <20200117150323.21801-6-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Another step when loading livepatches to livepatch modules is
to initialize the structure, create sysfs entries, do livepatch
specific relocations.

These operation can fail and the objects must be freed that case.
The error message is taken from klp_module_coming() to match
selftests.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/livepatch/core.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index e2c7dc6c2d5f..6c27b635e5a7 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -583,18 +583,23 @@ static void klp_free_object_loaded(struct klp_object *obj)
 	}
 }
 
+static void klp_free_object(struct klp_object *obj, bool nops_only)
+{
+	__klp_free_funcs(obj, nops_only);
+
+	if (nops_only && !obj->dynamic)
+		return;
+
+	list_del(&obj->node);
+	kobject_put(&obj->kobj);
+}
+
 static void __klp_free_objects(struct klp_patch *patch, bool nops_only)
 {
 	struct klp_object *obj, *tmp_obj;
 
 	klp_for_each_object_safe(patch, obj, tmp_obj) {
-		__klp_free_funcs(obj, nops_only);
-
-		if (nops_only && !obj->dynamic)
-			continue;
-
-		list_del(&obj->node);
-		kobject_put(&obj->kobj);
+		klp_free_object(obj, nops_only);
 	}
 }
 
@@ -812,6 +817,8 @@ static int klp_init_object_early(struct klp_patch *patch,
 	if (obj->dynamic || try_module_get(obj->mod))
 		return 0;
 
+	/* patch stays when this function fails in klp_add_object() */
+	list_del(&obj->node);
 	return -ENODEV;
 }
 
@@ -993,9 +1000,22 @@ int klp_add_object(struct klp_object *obj)
 		goto err;
 	}
 
+	ret = klp_init_object_early(patch, obj);
+	if (ret)
+		goto err;
+
+	ret = klp_init_object(patch, obj);
+	if (ret) {
+		pr_warn("failed to initialize patch '%s' for module '%s' (%d)\n",
+			patch->obj->patch_name, obj->name, ret);
+		goto err_free;
+	}
+
 	mutex_unlock(&klp_mutex);
 	return 0;
 
+err_free:
+	klp_free_object(obj, false);
 err:
 	/*
 	 * If a patch is unsuccessfully applied, return
-- 
2.16.4

