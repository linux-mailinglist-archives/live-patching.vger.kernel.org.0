Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD04140D3E
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 16:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgAQPEB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 10:04:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:46284 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729107AbgAQPEA (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 10:04:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AC481BBAE;
        Fri, 17 Jan 2020 15:03:58 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [POC 10/23] livepatch: Handle modprobe exit code
Date:   Fri, 17 Jan 2020 16:03:10 +0100
Message-Id: <20200117150323.21801-11-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200117150323.21801-1-pmladek@suse.com>
References: <20200117150323.21801-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

request_module() returns classic negative error codes when it was
not even able to call "modprobe" from some reasons. Otherwise,
it returns the exit code multiplied by 256.

modprobe exit code is always 1 in case of error. Use -EINVAL
instead as the least ugly internal error code.

A better solution would be to somehow pass the original error
code from the init_module() syscall or at least the error code
from klp_module_add() functions. But there is no obvious way
how to pass the information.

Global variable is not enough because more livepatch modules
can be loaded simultaneously from klp_enable_patch() and
klp_module_comming().

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/livepatch/core.c                             | 3 +++
 tools/testing/selftests/livepatch/test-callbacks.sh | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 8e693c58b736..19ca8baa2f16 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -1109,6 +1109,9 @@ static int klp_try_load_object(const char *patch_name, const char *obj_name)
 
 	ret = request_module("%s__%s", patch_name, obj_name);
 	if (ret) {
+		/* modprobe always set exit code 1 on error */
+		if (ret > 0)
+			ret = -EINVAL;
 		pr_info("Module load failed: %s__%s\n", patch_name, obj_name);
 		return ret;
 	}
diff --git a/tools/testing/selftests/livepatch/test-callbacks.sh b/tools/testing/selftests/livepatch/test-callbacks.sh
index 39a4f35e5f8e..060e5b512367 100755
--- a/tools/testing/selftests/livepatch/test-callbacks.sh
+++ b/tools/testing/selftests/livepatch/test-callbacks.sh
@@ -331,7 +331,7 @@ $MOD_LIVEPATCH: pre_patch_callback: $MOD_TARGET -> [MODULE_STATE_COMING] Full fo
 livepatch: pre-patch callback failed for object '$MOD_TARGET'
 livepatch: patch '$MOD_LIVEPATCH' failed for module '$MOD_TARGET', refusing to load module '$MOD_TARGET'
 livepatch: Module load failed: ${MOD_LIVEPATCH}__${MOD_TARGET}
-modprobe: ERROR: could not insert '$MOD_TARGET': No such device
+modprobe: ERROR: could not insert '$MOD_TARGET': Invalid argument
 % echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
 livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
 $MOD_LIVEPATCH: pre_unpatch_callback: vmlinux
-- 
2.16.4

