Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 201D9140D3A
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgAQPD6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:03:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:46084 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729015AbgAQPD5 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:03:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AC2F3BB96;
        Fri, 17 Jan 2020 15:03:55 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 03/23] livepatch: Better checks of struct klp_object definition
Date:   Fri, 17 Jan 2020 16:03:03 +0100
Message-Id: <20200117150323.21801-4-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The number of user defined fields increased in struct klp_object after
spliting per-object livepatches. It was sometimes unclear why exactly
the module could not get loded when returned -EINVAL.

Add more checks for the split modules and write useful error
messages on particular errors.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/livepatch/core.c | 91 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 82 insertions(+), 9 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index bb62c5407b75..ec7ffc7db3a7 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -756,9 +756,6 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
 	int ret;
 	const char *name;
 
-	if (klp_is_module(obj) && strlen(obj->name) >= MODULE_NAME_LEN)
-		return -EINVAL;
-
 	obj->patched = false;
 
 	name = obj->name ? obj->name : "vmlinux";
@@ -851,8 +848,86 @@ static int klp_init_patch(struct klp_patch *patch)
 	return 0;
 }
 
+static int klp_check_module_name(struct klp_object *obj, bool is_module)
+{
+	char mod_name[MODULE_NAME_LEN];
+	const char *expected_name;
+
+	if (is_module) {
+		snprintf(mod_name, sizeof(mod_name), "%s__%s",
+			 obj->patch_name, obj->name);
+		expected_name = mod_name;
+	} else {
+		expected_name = obj->patch_name;
+	}
+
+	if (strcmp(expected_name, obj->mod->name)) {
+		pr_err("The module name %s does not match with obj->patch_name and obj->name. The expected name is: %s\n",
+		       obj->mod->name, expected_name);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int klp_check_object(struct klp_object *obj, bool is_module)
+{
+
+	if (!obj->mod)
+		return -EINVAL;
+
+	if (!is_livepatch_module(obj->mod)) {
+		pr_err("module %s is not marked as a livepatch module\n",
+		       obj->mod->name);
+		return -EINVAL;
+	}
+
+	if (!obj->patch_name) {
+		pr_err("module %s does not have set obj->patch_name\n",
+		       obj->mod->name);
+		return -EINVAL;
+	}
+
+	if (strlen(obj->patch_name) >= MODULE_NAME_LEN) {
+		pr_err("module %s has too long obj->patch_name\n",
+		       obj->mod->name);
+		return -EINVAL;
+	}
+
+	if (is_module) {
+		if (!obj->name) {
+			pr_err("module %s does not have set obj->name\n",
+			       obj->mod->name);
+			return -EINVAL;
+		}
+		if (strlen(obj->name) >= MODULE_NAME_LEN) {
+			pr_err("module %s has too long obj->name\n",
+			       obj->mod->name);
+			return -EINVAL;
+		}
+	} else if (obj->name) {
+		pr_err("module %s for vmlinux must not have set obj->name\n",
+		       obj->mod->name);
+		return -EINVAL;
+	}
+
+	if (!obj->funcs) {
+		pr_err("module %s does not have set obj->funcs\n",
+		       obj->mod->name);
+		return -EINVAL;
+	}
+
+	return klp_check_module_name(obj, is_module);
+}
+
 int klp_add_object(struct klp_object *obj)
 {
+	int ret;
+
+	ret = klp_check_object(obj, true);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(klp_add_object);
@@ -958,14 +1033,12 @@ int klp_enable_patch(struct klp_patch *patch)
 {
 	int ret;
 
-	if (!patch || !patch->obj || !patch->obj->mod)
+	if (!patch || !patch->obj)
 		return -EINVAL;
 
-	if (!is_livepatch_module(patch->obj->mod)) {
-		pr_err("module %s is not marked as a livepatch module\n",
-		       patch->obj->patch_name);
-		return -EINVAL;
-	}
+	ret = klp_check_object(patch->obj, false);
+	if (ret)
+		return ret;
 
 	if (!klp_initialized())
 		return -ENODEV;
-- 
2.16.4

