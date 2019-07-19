Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B82D86E5AE
	for <lists+live-patching@lfdr.de>; Fri, 19 Jul 2019 14:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbfGSM2o (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 19 Jul 2019 08:28:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:49126 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727637AbfGSM2o (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 19 Jul 2019 08:28:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DFDCAAECD;
        Fri, 19 Jul 2019 12:28:42 +0000 (UTC)
From:   Miroslav Benes <mbenes@suse.cz>
To:     jikos@kernel.org, jpoimboe@redhat.com, pmladek@suse.com
Cc:     joe.lawrence@redhat.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH 1/2] livepatch: Nullify obj->mod in klp_module_coming()'s error path
Date:   Fri, 19 Jul 2019 14:28:39 +0200
Message-Id: <20190719122840.15353-2-mbenes@suse.cz>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190719122840.15353-1-mbenes@suse.cz>
References: <20190719122840.15353-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

klp_module_coming() is called for every module appearing in the system.
It sets obj->mod to a patched module for klp_object obj. Unfortunately
it leaves it set even if an error happens later in the function and the
patched module is not allowed to be loaded.

klp_is_object_loaded() uses obj->mod variable and could currently give a
wrong return value. The bug is probably harmless as of now.

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
Reviewed-by: Petr Mladek <pmladek@suse.com>
---
 kernel/livepatch/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index c4ce08f43bd6..ab4a4606d19b 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1175,6 +1175,7 @@ int klp_module_coming(struct module *mod)
 	pr_warn("patch '%s' failed for module '%s', refusing to load module '%s'\n",
 		patch->mod->name, obj->mod->name, obj->mod->name);
 	mod->klp_alive = false;
+	obj->mod = NULL;
 	klp_cleanup_module_patches_limited(mod, patch);
 	mutex_unlock(&klp_mutex);
 
-- 
2.22.0

