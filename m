Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE95F6AC2BD
	for <lists+live-patching@lfdr.de>; Mon,  6 Mar 2023 15:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjCFONW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 Mar 2023 09:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjCFOMw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 Mar 2023 09:12:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463893430C
        for <live-patching@vger.kernel.org>; Mon,  6 Mar 2023 06:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678111727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hRwJuStlwoNPKJ+bNuGeRuXsCV67grkKFsnnrCxSkdQ=;
        b=CYSaZMkd64LSKvbAJ25DUr4vDmOhm1RpQoB9vlUwFK2uTmAALyMI4jpWu4d5Rq8iZNO+Yk
        iPeNdyxukpxU42iVR+u3HOZ09tfjYzwLjDP2N8dbNuFwQDbkgqx6GCXhSK4S+QDM32Vp0S
        a+qExL1qMTedroQaQY5jgtjc5raVmWo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-FAoZp5ncNvWMUae1Mdcpqg-1; Mon, 06 Mar 2023 09:08:31 -0500
X-MC-Unique: FAoZp5ncNvWMUae1Mdcpqg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE9A7802D2A;
        Mon,  6 Mar 2023 14:08:30 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (unknown [10.22.17.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 791B640C10FA;
        Mon,  6 Mar 2023 14:08:30 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH v7 10/10] livepatch/selftests: add static keys test
Date:   Mon,  6 Mar 2023 09:08:24 -0500
Message-Id: <20230306140824.3858543-11-joe.lawrence@redhat.com>
In-Reply-To: <20230306140824.3858543-1-joe.lawrence@redhat.com>
References: <20230306140824.3858543-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Add a livepatch kselftest that exercises klp-convert support for static
keys:

  - Use static_branch_(un)likely() on vmlinux-defined keys, forcing
    .rela__jump_table klp-relocations for them.

  - Use only static_key_enable() on module-defined keys, creating .text
    klp-relocations for them.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 lib/livepatch/Makefile                        |   2 +
 lib/livepatch/test_klp_convert.h              |   8 ++
 lib/livepatch/test_klp_convert_keys.c         |  91 +++++++++++++
 lib/livepatch/test_klp_convert_keys_mod.c     |  52 +++++++
 .../selftests/livepatch/test-livepatch.sh     | 127 ++++++++++++++++++
 5 files changed, 280 insertions(+)
 create mode 100644 lib/livepatch/test_klp_convert_keys.c
 create mode 100644 lib/livepatch/test_klp_convert_keys_mod.c

diff --git a/lib/livepatch/Makefile b/lib/livepatch/Makefile
index da39aaa5c8fc..a3c2ac61387f 100644
--- a/lib/livepatch/Makefile
+++ b/lib/livepatch/Makefile
@@ -11,6 +11,8 @@ obj-$(CONFIG_TEST_LIVEPATCH) += test_klp_atomic_replace.o \
 				test_klp_convert2.o \
 				test_klp_convert_data.o \
 				test_klp_convert_sections.o \
+				test_klp_convert_keys.o \
+				test_klp_convert_keys_mod.o \
 				test_klp_convert_mod.o \
 				test_klp_livepatch.o \
 				test_klp_shadow_vars.o \
diff --git a/lib/livepatch/test_klp_convert.h b/lib/livepatch/test_klp_convert.h
index 08c0f4b1dc6b..97d4c26e4c39 100644
--- a/lib/livepatch/test_klp_convert.h
+++ b/lib/livepatch/test_klp_convert.h
@@ -34,4 +34,12 @@ extern int static_const_local_large[4];
 extern int static_ro_after_init;
 extern int static_read_mostly;
 
+/* klp-convert symbols - vmlinux */
+extern struct static_key_false tracepoint_printk_key;
+
+/* klp-convert symbols - test_klp_keys_mod.ko */
+extern struct static_key_true test_klp_true_key;
+extern struct static_key_false test_klp_false_key;
+
+
 #endif
diff --git a/lib/livepatch/test_klp_convert_keys.c b/lib/livepatch/test_klp_convert_keys.c
new file mode 100644
index 000000000000..90c20e84a146
--- /dev/null
+++ b/lib/livepatch/test_klp_convert_keys.c
@@ -0,0 +1,91 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2020 Joe Lawrence <joe.lawrence@redhat.com>
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+#include <linux/jump_label.h>
+#include "test_klp_convert.h"
+
+/*
+ * Carry our own copy of print_key_status() as we want static key code
+ * patching updates to occur in the livepatch module as well as the
+ * target module that defines the static keys.
+ */
+static void print_key_status(char *msg)
+{
+	pr_info("%s: %s\n", __func__, msg);
+
+	/* static_key_enable() only tests the key value */
+	pr_info("static_key_enabled(&tracepoint_printk_key) is %s\n",
+		static_key_enabled(&tracepoint_printk_key) ? "true" : "false");
+	pr_info("static_key_enabled(&test_klp_true_key) is %s\n",
+		static_key_enabled(&test_klp_true_key) ? "true" : "false");
+	pr_info("static_key_enabled(&test_klp_false_key) is %s\n",
+		static_key_enabled(&test_klp_false_key) ? "true" : "false");
+
+	/*
+	 * static_branch_(un)likely() requires code patching when the
+	 * key value changes
+	 */
+	pr_info("static_branch_unlikely(&tracepoint_printk_key) is %s\n",
+		static_branch_unlikely(&tracepoint_printk_key) ? "true" : "false");
+}
+
+/*
+ * sysfs interface to poke the key
+ */
+static bool enable_false_key;
+static int set_enable_false_key(const char *val, const struct kernel_param *kp)
+{
+	print_key_status("set_enable_false_key start");
+	static_branch_enable(&test_klp_false_key);
+	print_key_status("set_enable_false_key enabling test_klp_false_key");
+
+	return 0;
+}
+module_param_call(enable_false_key, set_enable_false_key, NULL,
+		  &enable_false_key, 0644);
+MODULE_PARM_DESC(enable_false_key, "Static branch enable");
+
+
+static struct klp_func funcs[] = {
+	{ }
+};
+
+static struct klp_object objs[] = {
+	{
+		.name = "test_klp_convert_keys_mod",
+		.funcs = funcs,
+	}, {}
+};
+
+static struct klp_patch patch = {
+	.mod = THIS_MODULE,
+	.objs = objs,
+};
+
+static int test_klp_convert_keys_init(void)
+{
+	int ret;
+
+	ret = klp_enable_patch(&patch);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static void test_klp_convert_keys_exit(void)
+{
+}
+
+module_init(test_klp_convert_keys_init);
+module_exit(test_klp_convert_keys_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Joe Lawrence <joe.lawrence@redhat.com>");
+MODULE_DESCRIPTION("Livepatch test: static keys");
+MODULE_INFO(livepatch, "Y");
diff --git a/lib/livepatch/test_klp_convert_keys_mod.c b/lib/livepatch/test_klp_convert_keys_mod.c
new file mode 100644
index 000000000000..7b11c2da09c9
--- /dev/null
+++ b/lib/livepatch/test_klp_convert_keys_mod.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2020 Joe Lawrence <joe.lawrence@redhat.com>
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/jump_label.h>
+
+static DEFINE_STATIC_KEY_TRUE(test_klp_true_key);
+static DEFINE_STATIC_KEY_FALSE(test_klp_false_key);
+
+static void print_key_status(char *msg)
+{
+	pr_info("%s: %s\n", __func__, msg);
+
+	/* static_key_enable() only tests the key value */
+	pr_info("static_key_enabled(&test_klp_true_key) is %s\n",
+		static_key_enabled(&test_klp_true_key) ? "true" : "false");
+	pr_info("static_key_enabled(&test_klp_false_key) is %s\n",
+		static_key_enabled(&test_klp_false_key) ? "true" : "false");
+
+	/*
+	 * static_branch_(un)likely() requires code patching when the
+	 * key value changes
+	 */
+	pr_info("static_branch_likely(&test_klp_true_key) is %s\n",
+		static_branch_likely(&test_klp_true_key) ? "true" : "false");
+	pr_info("static_branch_unlikely(&test_klp_false_key) is %s\n",
+		static_branch_unlikely(&test_klp_false_key) ? "true" : "false");
+}
+
+static int test_klp_keys_mod_init(void)
+{
+	print_key_status("initial conditions");
+	static_branch_disable(&test_klp_true_key);
+	print_key_status("disabled test_klp_true_key");
+
+	return 0;
+}
+
+static void test_klp_keys_mod_exit(void)
+{
+	print_key_status("unloading conditions");
+}
+
+module_init(test_klp_keys_mod_init);
+module_exit(test_klp_keys_mod_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Joe Lawrence <joe.lawrence@redhat.com>");
+MODULE_DESCRIPTION("Livepatch test: static keys target module");
diff --git a/tools/testing/selftests/livepatch/test-livepatch.sh b/tools/testing/selftests/livepatch/test-livepatch.sh
index 5bda36b65bb5..8ad284a57770 100755
--- a/tools/testing/selftests/livepatch/test-livepatch.sh
+++ b/tools/testing/selftests/livepatch/test-livepatch.sh
@@ -11,6 +11,8 @@ MOD_KLP_CONVERT1=test_klp_convert1
 MOD_KLP_CONVERT2=test_klp_convert2
 MOD_KLP_CONVERT_DATA=test_klp_convert_data
 MOD_KLP_CONVERT_SECTIONS=test_klp_convert_sections
+MOD_KLP_CONVERT_KEYS_MOD=test_klp_convert_keys_mod
+MOD_KLP_CONVERT_KEYS=test_klp_convert_keys
 
 setup_config
 
@@ -435,4 +437,129 @@ livepatch: '$MOD_KLP_CONVERT_DATA': unpatching complete
 % rmmod $MOD_KLP_CONVERT_MOD"
 
 
+# TEST: klp-convert static keys
+# - load a module which defines static keys, updates one of the keys on
+#   load (forcing jump table patching)
+# - load a livepatch that references the same keys, resolved by
+#   klp-convert tool
+# - poke the livepatch sysfs interface to update one of the key (forcing
+#   jump table patching again)
+# - disable and unload the livepatch
+# - remove the module
+
+start_test "klp-convert static keys"
+
+load_mod $MOD_KLP_CONVERT_KEYS_MOD
+load_lp $MOD_KLP_CONVERT_KEYS
+
+echo 1 > /sys/module/$MOD_KLP_CONVERT_KEYS/parameters/enable_false_key
+
+disable_lp $MOD_KLP_CONVERT_KEYS
+unload_lp $MOD_KLP_CONVERT_KEYS
+unload_mod $MOD_KLP_CONVERT_KEYS_MOD
+
+check_result "% modprobe $MOD_KLP_CONVERT_KEYS_MOD
+$MOD_KLP_CONVERT_KEYS_MOD: print_key_status: initial conditions
+$MOD_KLP_CONVERT_KEYS_MOD: static_key_enabled(&test_klp_true_key) is true
+$MOD_KLP_CONVERT_KEYS_MOD: static_key_enabled(&test_klp_false_key) is false
+$MOD_KLP_CONVERT_KEYS_MOD: static_branch_likely(&test_klp_true_key) is true
+$MOD_KLP_CONVERT_KEYS_MOD: static_branch_unlikely(&test_klp_false_key) is false
+$MOD_KLP_CONVERT_KEYS_MOD: print_key_status: disabled test_klp_true_key
+$MOD_KLP_CONVERT_KEYS_MOD: static_key_enabled(&test_klp_true_key) is false
+$MOD_KLP_CONVERT_KEYS_MOD: static_key_enabled(&test_klp_false_key) is false
+$MOD_KLP_CONVERT_KEYS_MOD: static_branch_likely(&test_klp_true_key) is false
+$MOD_KLP_CONVERT_KEYS_MOD: static_branch_unlikely(&test_klp_false_key) is false
+% modprobe $MOD_KLP_CONVERT_KEYS
+livepatch: enabling patch '$MOD_KLP_CONVERT_KEYS'
+livepatch: '$MOD_KLP_CONVERT_KEYS': initializing patching transition
+livepatch: '$MOD_KLP_CONVERT_KEYS': starting patching transition
+livepatch: '$MOD_KLP_CONVERT_KEYS': completing patching transition
+livepatch: '$MOD_KLP_CONVERT_KEYS': patching complete
+$MOD_KLP_CONVERT_KEYS: print_key_status: set_enable_false_key start
+$MOD_KLP_CONVERT_KEYS: static_key_enabled(&tracepoint_printk_key) is false
+$MOD_KLP_CONVERT_KEYS: static_key_enabled(&test_klp_true_key) is false
+$MOD_KLP_CONVERT_KEYS: static_key_enabled(&test_klp_false_key) is false
+$MOD_KLP_CONVERT_KEYS: static_branch_unlikely(&tracepoint_printk_key) is false
+$MOD_KLP_CONVERT_KEYS: print_key_status: set_enable_false_key enabling test_klp_false_key
+$MOD_KLP_CONVERT_KEYS: static_key_enabled(&tracepoint_printk_key) is false
+$MOD_KLP_CONVERT_KEYS: static_key_enabled(&test_klp_true_key) is false
+$MOD_KLP_CONVERT_KEYS: static_key_enabled(&test_klp_false_key) is true
+$MOD_KLP_CONVERT_KEYS: static_branch_unlikely(&tracepoint_printk_key) is false
+% echo 0 > /sys/kernel/livepatch/$MOD_KLP_CONVERT_KEYS/enabled
+livepatch: '$MOD_KLP_CONVERT_KEYS': initializing unpatching transition
+livepatch: '$MOD_KLP_CONVERT_KEYS': starting unpatching transition
+livepatch: '$MOD_KLP_CONVERT_KEYS': completing unpatching transition
+livepatch: '$MOD_KLP_CONVERT_KEYS': unpatching complete
+% rmmod $MOD_KLP_CONVERT_KEYS
+% rmmod $MOD_KLP_CONVERT_KEYS_MOD
+$MOD_KLP_CONVERT_KEYS_MOD: print_key_status: unloading conditions
+$MOD_KLP_CONVERT_KEYS_MOD: static_key_enabled(&test_klp_true_key) is false
+$MOD_KLP_CONVERT_KEYS_MOD: static_key_enabled(&test_klp_false_key) is true
+$MOD_KLP_CONVERT_KEYS_MOD: static_branch_likely(&test_klp_true_key) is false
+$MOD_KLP_CONVERT_KEYS_MOD: static_branch_unlikely(&test_klp_false_key) is true"
+
+
+# TEST: klp-convert static keys (late module patching)
+# - load a module which defines static keys, updates one of the keys on
+#   load (forcing jump table patching)
+# - load a livepatch that references the same keys, resolved by
+#   klp-convert tool
+# - poke the livepatch sysfs interface to update one of the key (forcing
+#   jump table patching again)
+# - disable and unload the livepatch
+# - remove the module
+
+start_test "klp-convert static keys (late module patching)"
+
+load_lp $MOD_KLP_CONVERT_KEYS
+load_mod $MOD_KLP_CONVERT_KEYS_MOD
+
+echo 1 > /sys/module/$MOD_KLP_CONVERT_KEYS/parameters/enable_false_key
+
+disable_lp $MOD_KLP_CONVERT_KEYS
+unload_lp $MOD_KLP_CONVERT_KEYS
+unload_mod $MOD_KLP_CONVERT_KEYS_MOD
+
+check_result "% modprobe $MOD_KLP_CONVERT_KEYS
+livepatch: enabling patch '$MOD_KLP_CONVERT_KEYS'
+livepatch: '$MOD_KLP_CONVERT_KEYS': initializing patching transition
+livepatch: '$MOD_KLP_CONVERT_KEYS': starting patching transition
+livepatch: '$MOD_KLP_CONVERT_KEYS': completing patching transition
+livepatch: '$MOD_KLP_CONVERT_KEYS': patching complete
+% modprobe $MOD_KLP_CONVERT_KEYS_MOD
+livepatch: applying patch '$MOD_KLP_CONVERT_KEYS' to loading module '$MOD_KLP_CONVERT_KEYS_MOD'
+$MOD_KLP_CONVERT_KEYS_MOD: print_key_status: initial conditions
+$MOD_KLP_CONVERT_KEYS_MOD: static_key_enabled(&test_klp_true_key) is true
+$MOD_KLP_CONVERT_KEYS_MOD: static_key_enabled(&test_klp_false_key) is false
+$MOD_KLP_CONVERT_KEYS_MOD: static_branch_likely(&test_klp_true_key) is true
+$MOD_KLP_CONVERT_KEYS_MOD: static_branch_unlikely(&test_klp_false_key) is false
+$MOD_KLP_CONVERT_KEYS_MOD: print_key_status: disabled test_klp_true_key
+$MOD_KLP_CONVERT_KEYS_MOD: static_key_enabled(&test_klp_true_key) is false
+$MOD_KLP_CONVERT_KEYS_MOD: static_key_enabled(&test_klp_false_key) is false
+$MOD_KLP_CONVERT_KEYS_MOD: static_branch_likely(&test_klp_true_key) is false
+$MOD_KLP_CONVERT_KEYS_MOD: static_branch_unlikely(&test_klp_false_key) is false
+$MOD_KLP_CONVERT_KEYS: print_key_status: set_enable_false_key start
+$MOD_KLP_CONVERT_KEYS: static_key_enabled(&tracepoint_printk_key) is false
+$MOD_KLP_CONVERT_KEYS: static_key_enabled(&test_klp_true_key) is false
+$MOD_KLP_CONVERT_KEYS: static_key_enabled(&test_klp_false_key) is false
+$MOD_KLP_CONVERT_KEYS: static_branch_unlikely(&tracepoint_printk_key) is false
+$MOD_KLP_CONVERT_KEYS: print_key_status: set_enable_false_key enabling test_klp_false_key
+$MOD_KLP_CONVERT_KEYS: static_key_enabled(&tracepoint_printk_key) is false
+$MOD_KLP_CONVERT_KEYS: static_key_enabled(&test_klp_true_key) is false
+$MOD_KLP_CONVERT_KEYS: static_key_enabled(&test_klp_false_key) is true
+$MOD_KLP_CONVERT_KEYS: static_branch_unlikely(&tracepoint_printk_key) is false
+% echo 0 > /sys/kernel/livepatch/$MOD_KLP_CONVERT_KEYS/enabled
+livepatch: '$MOD_KLP_CONVERT_KEYS': initializing unpatching transition
+livepatch: '$MOD_KLP_CONVERT_KEYS': starting unpatching transition
+livepatch: '$MOD_KLP_CONVERT_KEYS': completing unpatching transition
+livepatch: '$MOD_KLP_CONVERT_KEYS': unpatching complete
+% rmmod $MOD_KLP_CONVERT_KEYS
+% rmmod $MOD_KLP_CONVERT_KEYS_MOD
+$MOD_KLP_CONVERT_KEYS_MOD: print_key_status: unloading conditions
+$MOD_KLP_CONVERT_KEYS_MOD: static_key_enabled(&test_klp_true_key) is false
+$MOD_KLP_CONVERT_KEYS_MOD: static_key_enabled(&test_klp_false_key) is true
+$MOD_KLP_CONVERT_KEYS_MOD: static_branch_likely(&test_klp_true_key) is false
+$MOD_KLP_CONVERT_KEYS_MOD: static_branch_unlikely(&test_klp_false_key) is true"
+
+
 exit 0
-- 
2.39.2

