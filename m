Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1030A4B8E3B
	for <lists+live-patching@lfdr.de>; Wed, 16 Feb 2022 17:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236535AbiBPQkK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Feb 2022 11:40:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236552AbiBPQkH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Feb 2022 11:40:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98AE025DA49
        for <live-patching@vger.kernel.org>; Wed, 16 Feb 2022 08:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645029592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TWBzzg6Rcc9SQb68GdH8ak/9dKzDZ+UsAvS1lAIu2wE=;
        b=MNnby1yEd8lWAoyW4iO8QQ/eJHfb9u2N7NHQTm8dj2jf4Dd6032lzkqQ/8PFMFG62IVRVd
        6xHj43L+98AMeq7iFRgGzr6srTzgSvnqIfCCqTsL8365J01xyTPo7dbXM44ehq3PmyysQb
        YFNwDkyuSIuZW7vAZi8JfVPfkwh3uZE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-kvyjJ4hUMJ68Hcb7EQBgmA-1; Wed, 16 Feb 2022 11:39:49 -0500
X-MC-Unique: kvyjJ4hUMJ68Hcb7EQBgmA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 533D014755;
        Wed, 16 Feb 2022 16:39:48 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (unknown [10.22.8.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4169753CD;
        Wed, 16 Feb 2022 16:39:47 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [RFC PATCH v6 09/12] livepatch/selftests: test multiple sections
Date:   Wed, 16 Feb 2022 11:39:37 -0500
Message-Id: <20220216163940.228309-10-joe.lawrence@redhat.com>
In-Reply-To: <20220216163940.228309-1-joe.lawrence@redhat.com>
References: <20220216163940.228309-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Add a test case in which klp-convert needs to convert a symbol that is
shared across ELF sections.  Special sections like .altinstructions do
this.  It is possible that symbols may be shared across various .text
sections as well.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 lib/livepatch/Makefile                        |   1 +
 lib/livepatch/test_klp_convert_sections.c     | 120 ++++++++++++++++++
 .../selftests/livepatch/test-livepatch.sh     |  43 +++++++
 3 files changed, 164 insertions(+)
 create mode 100644 lib/livepatch/test_klp_convert_sections.c

diff --git a/lib/livepatch/Makefile b/lib/livepatch/Makefile
index ced00515ff84..77e21317d4da 100644
--- a/lib/livepatch/Makefile
+++ b/lib/livepatch/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_TEST_LIVEPATCH) += test_klp_atomic_replace.o \
 				test_klp_callbacks_mod.o \
 				test_klp_convert1.o \
 				test_klp_convert2.o \
+				test_klp_convert_sections.o \
 				test_klp_convert_mod.o \
 				test_klp_livepatch.o \
 				test_klp_shadow_vars.o \
diff --git a/lib/livepatch/test_klp_convert_sections.c b/lib/livepatch/test_klp_convert_sections.c
new file mode 100644
index 000000000000..b3f734bf5524
--- /dev/null
+++ b/lib/livepatch/test_klp_convert_sections.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2020 Joe Lawrence <joe.lawrence@redhat.com>
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+#include "test_klp_convert.h"
+
+/* klp-convert symbols - vmlinux */
+extern char *saved_command_line;
+
+/*
+ * Scatter references to the same symbol (saved_command_line) across a
+ * few different ELF sections.  At the same time, include multiple
+ * references within the same function.
+ */
+__section(".text.print_saved_command_line")
+void print_saved_command_line(void)
+{
+	pr_info("saved_command_line (1): %s\n", saved_command_line);
+}
+
+__section(".text.print_saved_command_line2")
+void print_saved_command_line2(void)
+{
+	pr_info("saved_command_line (1): %s\n", saved_command_line);
+	pr_info("saved_command_line (2): %s\n", saved_command_line);
+}
+
+__section(".text.print_saved_command_line3")
+void print_saved_command_line3(void)
+{
+	pr_info("saved_command_line (1): %s\n", saved_command_line);
+	pr_info("saved_command_line (2): %s\n", saved_command_line);
+	pr_info("saved_command_line (3): %s\n", saved_command_line);
+}
+
+/*
+ * Create relocations in .rela.data that need conversion, sharing
+ * symbols with ordinary .text relas.
+ */
+const char *(*p_test_klp_get_driver_name)(void) = test_klp_get_driver_name;
+const char *(*p_get_homonym_string)(void) = get_homonym_string;
+
+void print_via_function_pointers(void)
+{
+	pr_info("test_klp_get_driver_name(): %s\n", test_klp_get_driver_name());
+	pr_info("p_test_klp_get_driver_name(): %s\n", p_test_klp_get_driver_name());
+	pr_info("get_homonym_string(): %s\n", get_homonym_string());
+	pr_info("p_get_homonym_string(): %s\n", p_get_homonym_string());
+}
+
+/* provide a sysfs handle to invoke debug functions */
+static int print_debug;
+static int print_debug_set(const char *val, const struct kernel_param *kp)
+{
+	print_saved_command_line();
+	print_saved_command_line2();
+	print_saved_command_line3();
+	print_via_function_pointers();
+
+	return 0;
+}
+static const struct kernel_param_ops print_debug_ops = {
+	.set = print_debug_set,
+	.get = param_get_int,
+};
+
+module_param_cb(print_debug, &print_debug_ops, &print_debug, 0200);
+MODULE_PARM_DESC(print_debug, "print klp-convert debugging info");
+
+
+KLP_MODULE_RELOC(test_klp_convert_mod) test_klp_convert_mod_relocs_a[] = {
+	KLP_SYMPOS(get_homonym_string, 1),
+};
+
+static struct klp_func funcs[] = {
+	{
+	}, { }
+};
+
+static struct klp_object objs[] = {
+	{
+		/* name being NULL means vmlinux */
+		.funcs = funcs,
+	},
+	{
+		.name = "test_klp_convert_mod",
+		.funcs = funcs,
+	}, { }
+};
+
+static struct klp_patch patch = {
+	.mod = THIS_MODULE,
+	.objs = objs,
+};
+
+static int test_klp_convert_sections_init(void)
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
+static void test_klp_convert_sections_exit(void)
+{
+}
+
+module_init(test_klp_convert_sections_init);
+module_exit(test_klp_convert_sections_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Joe Lawrence <joe.lawrence@redhat.com>");
+MODULE_DESCRIPTION("Livepatch test: klp-convert-sections");
+MODULE_INFO(livepatch, "Y");
diff --git a/tools/testing/selftests/livepatch/test-livepatch.sh b/tools/testing/selftests/livepatch/test-livepatch.sh
index 25c21ddf30f0..bcb8b468b80a 100755
--- a/tools/testing/selftests/livepatch/test-livepatch.sh
+++ b/tools/testing/selftests/livepatch/test-livepatch.sh
@@ -293,4 +293,47 @@ livepatch: '$MOD_KLP_CONVERT2': unpatching complete
 % rmmod $MOD_KLP_CONVERT2
 % rmmod $MOD_KLP_CONVERT_MOD"
 
+
+# TEST: klp-convert symbols across ELF sections
+# - load a livepatch that references symbols that require klp-convert
+#   and reference the same symbol from multiple ELF sections
+# - verify correct behavior
+# - unload the livepatch
+
+start_test "klp-convert symbols across ELF sections"
+
+saved_cmdline=$(cat /proc/cmdline)
+
+load_mod $MOD_KLP_CONVERT_MOD
+load_lp $MOD_KLP_CONVERT_SECTIONS
+echo 1 > /sys/module/$MOD_KLP_CONVERT_SECTIONS/parameters/print_debug
+disable_lp $MOD_KLP_CONVERT_SECTIONS
+unload_lp $MOD_KLP_CONVERT_SECTIONS
+unload_mod $MOD_KLP_CONVERT_MOD
+
+check_result "% modprobe $MOD_KLP_CONVERT_MOD
+% modprobe $MOD_KLP_CONVERT_SECTIONS
+livepatch: enabling patch '$MOD_KLP_CONVERT_SECTIONS'
+livepatch: '$MOD_KLP_CONVERT_SECTIONS': initializing patching transition
+livepatch: '$MOD_KLP_CONVERT_SECTIONS': starting patching transition
+livepatch: '$MOD_KLP_CONVERT_SECTIONS': completing patching transition
+livepatch: '$MOD_KLP_CONVERT_SECTIONS': patching complete
+$MOD_KLP_CONVERT_SECTIONS: saved_command_line (1): $saved_cmdline
+$MOD_KLP_CONVERT_SECTIONS: saved_command_line (1): $saved_cmdline
+$MOD_KLP_CONVERT_SECTIONS: saved_command_line (2): $saved_cmdline
+$MOD_KLP_CONVERT_SECTIONS: saved_command_line (1): $saved_cmdline
+$MOD_KLP_CONVERT_SECTIONS: saved_command_line (2): $saved_cmdline
+$MOD_KLP_CONVERT_SECTIONS: saved_command_line (3): $saved_cmdline
+$MOD_KLP_CONVERT_SECTIONS: test_klp_get_driver_name(): $MOD_KLP_CONVERT_MOD
+$MOD_KLP_CONVERT_SECTIONS: p_test_klp_get_driver_name(): $MOD_KLP_CONVERT_MOD
+$MOD_KLP_CONVERT_SECTIONS: get_homonym_string(): homonym string A
+$MOD_KLP_CONVERT_SECTIONS: p_get_homonym_string(): homonym string A
+% echo 0 > /sys/kernel/livepatch/$MOD_KLP_CONVERT_SECTIONS/enabled
+livepatch: '$MOD_KLP_CONVERT_SECTIONS': initializing unpatching transition
+livepatch: '$MOD_KLP_CONVERT_SECTIONS': starting unpatching transition
+livepatch: '$MOD_KLP_CONVERT_SECTIONS': completing unpatching transition
+livepatch: '$MOD_KLP_CONVERT_SECTIONS': unpatching complete
+% rmmod $MOD_KLP_CONVERT_SECTIONS
+% rmmod $MOD_KLP_CONVERT_MOD"
+
 exit 0
-- 
2.26.3

