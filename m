Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63584140D55
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgAQPEc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:04:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:46214 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729140AbgAQPEC (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:04:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C6A66BBA9;
        Fri, 17 Jan 2020 15:04:00 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 15/23] livepatch: Prevent infinite loop when loading livepatch module
Date:   Fri, 17 Jan 2020 16:03:15 +0100
Message-Id: <20200117150323.21801-16-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Livepatch modules should get automatically removed when the patched
module gets removed. But the problem with forced flag has shown that
there might be situations where it did not work as expected.

The problem with forced flag is solved now. But there might be other
situations that are not known at the moment.

Be on the safe side and add a paranoid check for preventing an infinite
loop in klp_module_coming() callback. It might happen when it tries to load
a livepatch module that has already been loaded in the past and that
was not removed because of a bug somewhere.

POC NOTE: The main purpose of this patch is to show potential problems
	with the split livepatches. It is hard to say if the check is
	worth it or whether even more checks are needed.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/livepatch/core.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 4b55d805f3ec..688ad81def14 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1316,6 +1316,25 @@ void klp_discard_nops(struct klp_patch *new_patch)
 	klp_free_objects_dynamic(klp_transition_patch);
 }
 
+static bool klp_is_object_module_alive(const char *patch_name,
+				       const char *obj_name)
+{
+	static char mod_name[MODULE_NAME_LEN];
+	struct module *mod;
+	bool alive = false;
+
+	mutex_lock(&module_mutex);
+
+	snprintf(mod_name, sizeof(mod_name), "%s__%s", patch_name, obj_name);
+	mod = find_module(mod_name);
+	if (mod && mod->state & MODULE_STATE_LIVE)
+		alive = true;
+
+	mutex_unlock(&module_mutex);
+
+	return alive;
+}
+
 int klp_module_coming(struct module *mod)
 {
 	char patch_name[MODULE_NAME_LEN];
@@ -1335,6 +1354,19 @@ int klp_module_coming(struct module *mod)
 		if (klp_is_object_loaded(patch, mod->name))
 			continue;
 
+		/*
+		 * Paranoid check. Prevent infinite loop when a livepatch
+		 * module is alive and klp_is_object_loaded() does not
+		 * see it. It might happen when the object is removed
+		 * and module_put() is not called. This should never happen
+		 * when everything works as expected.
+		 */
+		if (klp_is_object_module_alive(patch->obj->mod->name,
+					       mod->name)) {
+			ret = -EBUSY;
+			goto err;
+		}
+
 		strncpy(patch_name, patch->obj->patch_name, sizeof(patch_name));
 		patch_ts = patch->ts;
 		mutex_unlock(&klp_mutex);
-- 
2.16.4

