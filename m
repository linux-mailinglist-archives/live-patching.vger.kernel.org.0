Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B77140D54
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgAQPEc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:04:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:46284 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729146AbgAQPEC (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:04:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 31657BBB3;
        Fri, 17 Jan 2020 15:04:01 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 16/23] livepatch: Add patch into the global list early
Date:   Fri, 17 Jan 2020 16:03:16 +0100
Message-Id: <20200117150323.21801-17-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The objects for livepatched modules need to be loaded before the livepatch
gets enabled. klp_add_module() has to find the patch. The code is easier
when the being-enabled patch can be found in the global list.

Fortunately, there is no problem to add patch into the list already
in the early init. klp_free_patch_start() will remove it in case
of any later error.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/livepatch/core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 688ad81def14..06676ec63ba7 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -852,6 +852,7 @@ static int klp_init_object_early(struct klp_patch *patch,
 static int klp_init_patch_early(struct klp_patch *patch)
 {
 	struct klp_object *obj = patch->obj;
+	int ret;
 
 	/* Main patch module is always for vmlinux */
 	if (obj->name)
@@ -865,7 +866,11 @@ static int klp_init_patch_early(struct klp_patch *patch)
 	INIT_WORK(&patch->free_work, klp_free_patch_work_fn);
 	init_completion(&patch->finish);
 
-	return klp_init_object_early(patch, obj);
+	ret = klp_init_object_early(patch, obj);
+	if (!ret)
+		list_add_tail(&patch->list, &klp_patches);
+
+	return ret;
 }
 
 static int klp_init_patch(struct klp_patch *patch)
@@ -889,8 +894,6 @@ static int klp_init_patch(struct klp_patch *patch)
 			return ret;
 	}
 
-	list_add_tail(&patch->list, &klp_patches);
-
 	return 0;
 }
 
-- 
2.16.4

