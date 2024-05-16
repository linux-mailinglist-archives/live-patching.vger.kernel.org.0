Return-Path: <live-patching+bounces-272-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5171E8C77B0
	for <lists+live-patching@lfdr.de>; Thu, 16 May 2024 15:32:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2C04FB23393
	for <lists+live-patching@lfdr.de>; Thu, 16 May 2024 13:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C29F14D71F;
	Thu, 16 May 2024 13:30:43 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F38414D71A;
	Thu, 16 May 2024 13:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715866243; cv=none; b=tf3hDu3cPJX/6LpOLJysy8I/Cc7RuYONHysYB4RkqnCoMNFwSKUWDaWS5t80PmxDczbWN/JJEsRmzpQpYAijT1ji0QnRmcSSJba9ob07fHy21rq8g+aR4V0vY0en7MaQ8kml3BIcWCYOWx6CCKmI4zaAyG6r2kwd5HaQZBTHl9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715866243; c=relaxed/simple;
	bh=piBfHsdrx+bDkPiULo4ylAnu5ZGbeLfxNVM1FW2By5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AS3gQFAfBSSvLbR6X0O1a8hb2eK+5rSJQlc4eDhBnX9fGHWYKL4loXQIPL4jzJrRIytsJcjIj49TmU1y/HnQaezPVI9CxXUvLfe49k5M5lN0KNUkREtFKuG9d248q9Z8VW7Gq+RSkqeCAq3Um/Movkdl9+Iknv3I45z0oCJ3ByU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 94170349E1;
	Thu, 16 May 2024 13:30:39 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8786113991;
	Thu, 16 May 2024 13:30:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OYRbIH8KRmYkDQAAD6G6ig
	(envelope-from <lhruska@suse.cz>); Thu, 16 May 2024 13:30:39 +0000
From: Lukas Hruska <lhruska@suse.cz>
To: pmladek@suse.com,
	mbenes@suse.cz,
	jpoimboe@kernel.org
Cc: joe.lawrence@redhat.com,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	mpdesouza@suse.com,
	lhruska@suse.cz
Subject: [PATCH v2 6/6] selftests: livepatch: Test livepatching function using an external symbol
Date: Thu, 16 May 2024 15:30:09 +0200
Message-ID: <20240516133009.20224-7-lhruska@suse.cz>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240516133009.20224-1-lhruska@suse.cz>
References: <20240516133009.20224-1-lhruska@suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: 94170349E1
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action

The test proves that klp-convert works as intended and it is possible to
livepatch a function that use an external symbol.

Signed-off-by: Lukas Hruska <lhruska@suse.cz>
---
 .../testing/selftests/livepatch/functions.sh  | 16 +++++-
 .../selftests/livepatch/test-extern.sh        | 57 +++++++++++++++++++
 .../selftests/livepatch/test_modules/Makefile |  2 +
 .../livepatch/test_modules/test_klp_extern.c  | 51 +++++++++++++++++
 .../test_modules/test_klp_extern_hello.c      | 36 ++++++++++++
 5 files changed, 161 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/livepatch/test-extern.sh
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_extern.c
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_extern_hello.c

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index fc4c6a016d38..801d55dc06ac 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -7,6 +7,7 @@
 MAX_RETRIES=600
 RETRY_INTERVAL=".1"	# seconds
 KLP_SYSFS_DIR="/sys/kernel/livepatch"
+MODULE_SYSFS_DIR="/sys/module"
 
 # Kselftest framework requirement - SKIP code is 4
 ksft_skip=4
@@ -299,7 +300,7 @@ function check_result {
 	result=$(dmesg | awk -v last_dmesg="$LAST_DMESG" 'p; $0 == last_dmesg { p=1 }' | \
 		 grep -e 'livepatch:' -e 'test_klp' | \
 		 grep -v '\(tainting\|taints\) kernel' | \
-		 sed 's/^\[[ 0-9.]*\] //')
+		 sed 's/^\[[ 0-9.]*\] //' | sed 's/^test_klp_log: //')
 
 	if [[ "$expect" == "$result" ]] ; then
 		echo "ok"
@@ -344,3 +345,16 @@ function check_sysfs_value() {
 		die "Unexpected value in $path: $expected_value vs. $value"
 	fi
 }
+
+# read_module_param_value(modname, param) - read module parameter value
+#  modname - livepatch module creating the sysfs interface
+#  param - parameter name
+function read_module_param() {
+   local mod="$1"; shift
+   local param="$1"; shift
+
+   local path="$MODULE_SYSFS_DIR/$mod/parameters/$param"
+
+   log "% echo \"$mod/parameters/$param: \$(cat $path)\""
+   log "$mod/parameters/$param: $(cat $path)"
+}
diff --git a/tools/testing/selftests/livepatch/test-extern.sh b/tools/testing/selftests/livepatch/test-extern.sh
new file mode 100755
index 000000000000..3dde6cabb07c
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test-extern.sh
@@ -0,0 +1,57 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2024 Lukas Hruska <lhruska@suse.cz>
+
+. $(dirname $0)/functions.sh
+
+MOD_LIVEPATCH=test_klp_extern
+MOD_HELLO=test_klp_extern_hello
+PARAM_HELLO=hello
+
+setup_config
+
+# - load a module to be livepatched
+# - load a livepatch that modifies the output from 'hello' parameter
+#   of the previously loaded module and verify correct behaviour
+# - unload the livepatch and make sure the patch was removed
+# - unload the module that was livepatched
+
+start_test "livepatch with external symbol"
+
+load_mod $MOD_HELLO
+
+read_module_param $MOD_HELLO $PARAM_HELLO
+
+load_lp $MOD_LIVEPATCH
+
+read_module_param $MOD_HELLO $PARAM_HELLO
+
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
+
+read_module_param $MOD_HELLO $PARAM_HELLO
+
+unload_mod $MOD_HELLO
+
+check_result "% insmod test_modules/$MOD_HELLO.ko
+% echo \"$MOD_HELLO/parameters/$PARAM_HELLO: \$(cat /sys/module/$MOD_HELLO/parameters/$PARAM_HELLO)\"
+$MOD_HELLO/parameters/$PARAM_HELLO: Hello from kernel module.
+% insmod test_modules/$MOD_LIVEPATCH.ko
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+% echo \"$MOD_HELLO/parameters/$PARAM_HELLO: \$(cat /sys/module/$MOD_HELLO/parameters/$PARAM_HELLO)\"
+$MOD_HELLO/parameters/$PARAM_HELLO: Hello from livepatched module.
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH
+% echo \"$MOD_HELLO/parameters/$PARAM_HELLO: \$(cat /sys/module/$MOD_HELLO/parameters/$PARAM_HELLO)\"
+$MOD_HELLO/parameters/$PARAM_HELLO: Hello from kernel module.
+% rmmod $MOD_HELLO"
+
+exit 0
diff --git a/tools/testing/selftests/livepatch/test_modules/Makefile b/tools/testing/selftests/livepatch/test_modules/Makefile
index e6e638c4bcba..0d6df14787da 100644
--- a/tools/testing/selftests/livepatch/test_modules/Makefile
+++ b/tools/testing/selftests/livepatch/test_modules/Makefile
@@ -6,6 +6,8 @@ obj-m += test_klp_atomic_replace.o \
 	test_klp_callbacks_demo.o \
 	test_klp_callbacks_demo2.o \
 	test_klp_callbacks_mod.o \
+	test_klp_extern.o \
+	test_klp_extern_hello.o \
 	test_klp_livepatch.o \
 	test_klp_state.o \
 	test_klp_state2.o \
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_extern.c b/tools/testing/selftests/livepatch/test_modules/test_klp_extern.c
new file mode 100644
index 000000000000..2a88ae289668
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_extern.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2024 Lukas Hruska <lhruska@suse.cz>
+
+#define pr_fmt(fmt) "test_klp_extern_hello: " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+
+extern const char *hello_msg \
+		   KLP_RELOC_SYMBOL(test_klp_extern_hello, test_klp_extern_hello, hello_msg);
+
+static int hello_get(char *buffer, const struct kernel_param *kp)
+{
+	return sysfs_emit(buffer, "%s livepatched module.\n", hello_msg);
+}
+
+static struct klp_func funcs[] = {
+	{
+		.old_name = "hello_get",
+		.new_func = hello_get,
+	}, { }
+};
+
+static struct klp_object objs[] = {
+	{
+		.name = "test_klp_extern_hello",
+		.funcs = funcs,
+	}, { }
+};
+
+static struct klp_patch patch = {
+	.mod = THIS_MODULE,
+	.objs = objs,
+};
+
+static int test_klp_extern_init(void)
+{
+	return klp_enable_patch(&patch);
+}
+
+static void test_klp_extern_exit(void)
+{
+}
+
+module_init(test_klp_extern_init);
+module_exit(test_klp_extern_exit);
+MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
+MODULE_AUTHOR("Lukas Hruska <lhruska@suse.cz>");
+MODULE_DESCRIPTION("Livepatch test: external symbol relocation");
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_extern_hello.c b/tools/testing/selftests/livepatch/test_modules/test_klp_extern_hello.c
new file mode 100644
index 000000000000..58ce4e655eee
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_extern_hello.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2024 Lukas Hruska <lhruska@suse.cz>
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+
+const char *hello_msg = "Hello from";
+
+static int hello_get(char *buffer, const struct kernel_param *kp)
+{
+	return sysfs_emit(buffer, "%s kernel module.\n", hello_msg);
+}
+
+static const struct kernel_param_ops hello_ops = {
+	.get	= hello_get
+};
+
+module_param_cb(hello, &hello_ops, NULL, 0400);
+MODULE_PARM_DESC(hello, "Read only parameter greeting the reader.");
+
+static int test_klp_extern_hello_init(void)
+{
+	return 0;
+}
+
+static void test_klp_extern_hello_exit(void)
+{
+}
+
+module_init(test_klp_extern_hello_init);
+module_exit(test_klp_extern_hello_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Lukas Hruska <lhruska@suse.cz>");
+MODULE_DESCRIPTION("Livepatch test: external symbol relocation - test module");
-- 
2.45.0


