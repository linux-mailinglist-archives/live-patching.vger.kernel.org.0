Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 101AD140D42
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgAQPEF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:04:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:46524 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729157AbgAQPED (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:04:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1CE80BBB7;
        Fri, 17 Jan 2020 15:04:02 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 18/23] module: Refactor add_unformed_module()
Date:   Fri, 17 Jan 2020 16:03:18 +0100
Message-Id: <20200117150323.21801-19-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The livepatching code will need to add another condition to avoid
waiting. Let's make the code slightly less hairy.

Of course, it is a matter of taste. The main ideas of refactoring:

  + Make it clear what happens when old->state == MODULE_STATE_LIVE.

  + Make it more clear when we are leaving the function immediately
    and when we are doing some extra actions.

  + Be able to add another check that has to be done outside
    module_mutex and can result into an immediate return.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/module.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index b3f11524f8f9..ac45d465ff23 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3721,28 +3721,30 @@ static int add_unformed_module(struct module *mod)
 again:
 	mutex_lock(&module_mutex);
 	old = find_module_all(mod->name, strlen(mod->name), true);
+
 	if (old != NULL) {
-		if (old->state != MODULE_STATE_LIVE) {
-			/* Wait in case it fails to load. */
+		if (old->state == MODULE_STATE_LIVE) {
 			mutex_unlock(&module_mutex);
-			err = wait_event_interruptible(module_wq,
-					       finished_loading(mod->name));
-			if (err)
-				goto out_unlocked;
-			goto again;
+			return -EEXIST;
 		}
-		err = -EEXIST;
-		goto out;
+
+		/* Wait in case it fails to load. */
+		mutex_unlock(&module_mutex);
+		err = wait_event_interruptible(module_wq,
+					       finished_loading(mod->name));
+		if (err)
+			return err;
+
+		/* Did the load succeded or failed? */
+		goto again;
 	}
+
 	mod_update_bounds(mod);
 	list_add_rcu(&mod->list, &modules);
 	mod_tree_insert(mod);
-	err = 0;
 
-out:
 	mutex_unlock(&module_mutex);
-out_unlocked:
-	return err;
+	return 0;
 }
 
 static int complete_formation(struct module *mod, struct load_info *info)
-- 
2.16.4

