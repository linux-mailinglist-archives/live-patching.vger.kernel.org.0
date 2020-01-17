Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6AE140D3D
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgAQPD7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:03:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:46182 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729073AbgAQPD6 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:03:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 10BA1BBAB;
        Fri, 17 Jan 2020 15:03:57 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 06/23] livepatch: Enable the livepatch submodule
Date:   Fri, 17 Jan 2020 16:03:06 +0100
Message-Id: <20200117150323.21801-7-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The final step when loading livepatch module for livepatching a module
is to actually enable the livepatch.

The steps are exactly the same as in kmp_module_comming().

Note that there is no need to call klp_cleanup_module_patches_limited()
in the error path. klp_add_object() modifies only the single matching
struct klp_patch.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/livepatch/core.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 6c27b635e5a7..c21bd9ec2012 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1011,6 +1011,28 @@ int klp_add_object(struct klp_object *obj)
 		goto err_free;
 	}
 
+	pr_notice("applying patch '%s' to loading module '%s'\n",
+		  patch->obj->patch_name, obj->name);
+
+	ret = klp_pre_patch_callback(obj);
+	if (ret) {
+		pr_warn("pre-patch callback failed for object '%s'\n",
+			obj->name);
+		goto err_free;
+	}
+
+	ret = klp_patch_object(obj);
+	if (ret) {
+		pr_warn("failed to apply patch '%s' to module '%s' (%d)\n",
+			patch->obj->patch_name, obj->name, ret);
+
+		klp_post_unpatch_callback(obj);
+		goto err_free;
+	}
+
+	if (patch != klp_transition_patch)
+		klp_post_patch_callback(obj);
+
 	mutex_unlock(&klp_mutex);
 	return 0;
 
-- 
2.16.4

