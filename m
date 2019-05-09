Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C46F418C02
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2019 16:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfEIOjT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 May 2019 10:39:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56034 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbfEIOjS (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 May 2019 10:39:18 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E2EA7C070E13;
        Thu,  9 May 2019 14:39:16 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (ovpn-123-90.rdu2.redhat.com [10.10.123.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F43B5DF49;
        Thu,  9 May 2019 14:39:15 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH v4 09/10] livepatch/selftests: add klp-convert
Date:   Thu,  9 May 2019 10:38:58 -0400
Message-Id: <20190509143859.9050-10-joe.lawrence@redhat.com>
In-Reply-To: <20190509143859.9050-1-joe.lawrence@redhat.com>
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 09 May 2019 14:39:17 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Add a simple klp-convert livepatch selftest that exercises various
symbol homonym sympos scenarios.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 lib/livepatch/Makefile                        |  10 ++
 lib/livepatch/test_klp_convert1.c             | 106 ++++++++++++++++++
 lib/livepatch/test_klp_convert2.c             | 103 +++++++++++++++++
 lib/livepatch/test_klp_convert_mod_a.c        |  25 +++++
 lib/livepatch/test_klp_convert_mod_b.c        |  13 +++
 .../selftests/livepatch/test-livepatch.sh     |  64 +++++++++++
 6 files changed, 321 insertions(+)
 create mode 100644 lib/livepatch/test_klp_convert1.c
 create mode 100644 lib/livepatch/test_klp_convert2.c
 create mode 100644 lib/livepatch/test_klp_convert_mod_a.c
 create mode 100644 lib/livepatch/test_klp_convert_mod_b.c

diff --git a/lib/livepatch/Makefile b/lib/livepatch/Makefile
index 513d200b7942..b19253c72d72 100644
--- a/lib/livepatch/Makefile
+++ b/lib/livepatch/Makefile
@@ -5,6 +5,8 @@
 LIVEPATCH_test_klp_atomic_replace := y
 LIVEPATCH_test_klp_callbacks_demo := y
 LIVEPATCH_test_klp_callbacks_demo2 := y
+LIVEPATCH_test_klp_convert1 := y
+LIVEPATCH_test_klp_convert2 := y
 LIVEPATCH_test_klp_livepatch := y
 
 obj-$(CONFIG_TEST_LIVEPATCH) += test_klp_atomic_replace.o \
@@ -12,9 +14,17 @@ obj-$(CONFIG_TEST_LIVEPATCH) += test_klp_atomic_replace.o \
 				test_klp_callbacks_demo2.o \
 				test_klp_callbacks_busy.o \
 				test_klp_callbacks_mod.o \
+				test_klp_convert1.o \
+				test_klp_convert2.o \
+				test_klp_convert_mod.o \
 				test_klp_livepatch.o \
 				test_klp_shadow_vars.o
 
+test_klp_convert_mod-y := \
+	test_klp_convert_mod_a.o \
+	test_klp_convert_mod_b.o
+
 # Target modules to be livepatched require CC_FLAGS_FTRACE
 CFLAGS_test_klp_callbacks_busy.o	+= $(CC_FLAGS_FTRACE)
 CFLAGS_test_klp_callbacks_mod.o		+= $(CC_FLAGS_FTRACE)
+CFLAGS_test_klp_convert_mod.o		+= $(CC_FLAGS_FTRACE)
diff --git a/lib/livepatch/test_klp_convert1.c b/lib/livepatch/test_klp_convert1.c
new file mode 100644
index 000000000000..a359f69a8fdc
--- /dev/null
+++ b/lib/livepatch/test_klp_convert1.c
@@ -0,0 +1,106 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2019 Joe Lawrence <joe.lawrence@redhat.com>
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+
+/* klp-convert symbols - vmlinux */
+extern char *saved_command_line;
+/* klp-convert symbols - test_klp_convert_mod.ko */
+extern char driver_name[];
+extern char homonym_string[];
+extern const char *get_homonym_string(void);
+extern const char *get_driver_name(void);
+
+void print_saved_command_line(void)
+{
+	pr_info("saved_command_line, 0: %s\n", saved_command_line);
+}
+
+void print_driver_name(void)
+{
+	pr_info("driver_name, 0: %s\n", driver_name);
+	pr_info("get_driver_name(), 0: %s\n", get_driver_name());
+}
+
+void print_homonym_string(void)
+{
+	pr_info("homonym_string, 1: %s\n", homonym_string);
+	pr_info("get_homonym_string(), 1: %s\n", get_homonym_string());
+}
+
+/*
+ * saved_command_line is a unique symbol, so the sympos annotation is
+ * optional.  Provide to test that sympos=0 works correctly.
+ */
+KLP_MODULE_RELOC(vmlinux) vmlinux_relocs[] = {
+	KLP_SYMPOS(saved_command_line, 0)
+};
+
+/*
+ * driver_name symbols can be found in vmlinux (multiple) and also
+ * test_klp_convert_mod, therefore the annotation is required to
+ * clarify that we want the one from test_klp_convert_mod.
+ *
+ * test_klp_convert_mod contains multiple homonym_string and
+ * get_homonym_string symbols, test resolving the first set here and
+ *  the others in test_klp_convert2.c
+ *
+ * get_driver_name is a uniquely named symbol, test that sympos=0
+ * work correctly.
+ */
+KLP_MODULE_RELOC(test_klp_convert_mod) test_klp_convert_mod_relocs_a[] = {
+	KLP_SYMPOS(driver_name, 0),
+	KLP_SYMPOS(homonym_string, 1),
+	KLP_SYMPOS(get_homonym_string, 1),
+	KLP_SYMPOS(get_driver_name, 0),
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
+static int test_klp_convert_init(void)
+{
+	int ret;
+
+	ret = klp_enable_patch(&patch);
+	if (ret)
+		return ret;
+
+	print_saved_command_line();
+	print_driver_name();
+	print_homonym_string();
+
+	return 0;
+}
+
+static void test_klp_convert_exit(void)
+{
+}
+
+module_init(test_klp_convert_init);
+module_exit(test_klp_convert_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Joe Lawrence <joe.lawrence@redhat.com>");
+MODULE_DESCRIPTION("Livepatch test: klp-convert1");
diff --git a/lib/livepatch/test_klp_convert2.c b/lib/livepatch/test_klp_convert2.c
new file mode 100644
index 000000000000..7be9b2184fe1
--- /dev/null
+++ b/lib/livepatch/test_klp_convert2.c
@@ -0,0 +1,103 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2019 Joe Lawrence <joe.lawrence@redhat.com>
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+
+/* klp-convert symbols - vmlinux */
+extern char *saved_command_line;
+/* klp-convert symbols - test_klp_convert_mod.ko */
+extern char driver_name[];
+extern char homonym_string[];
+extern const char *get_homonym_string(void);
+extern const char *get_driver_name(void);
+
+void print_saved_command_line(void)
+{
+	pr_info("saved_command_line (auto): %s\n", saved_command_line);
+}
+
+void print_driver_name(void)
+{
+	pr_info("driver_name, 0: %s\n", driver_name);
+	pr_info("get_driver_name(), (auto): %s\n", get_driver_name());
+}
+
+void print_homonym_string(void)
+{
+	pr_info("homonym_string, 2: %s\n", homonym_string);
+	pr_info("get_homonym_string(), 2: %s\n", get_homonym_string());
+}
+
+/*
+ * saved_command_line is a uniquely named symbol, so the sympos
+ * annotation is optional.  Skip it and test that klp-convert can
+ * resolve the symbol on its own.
+ */
+
+/*
+ * driver_name symbols can be found in vmlinux (multiple) and also
+ * test_klp_convert_mod, therefore the annotation is required to
+ * clarify that we want the one from test_klp_convert_mod.
+ *
+ * test_klp_convert_mod contains multiple homonym_string symbols,
+ * test_klp_convert1.c resolved to the first one, resolve to the
+ * second one here.
+ *
+ * get_driver_name is a uniquely named symbol, test klp-convert can
+ * resolve it automatically.
+ */
+KLP_MODULE_RELOC(test_klp_convert_mod) test_klp_convert_mod_relocs_a[] = {
+	KLP_SYMPOS(driver_name, 0),
+	KLP_SYMPOS(homonym_string, 2),
+	KLP_SYMPOS(get_homonym_string, 2),
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
+static int test_klp_convert_init(void)
+{
+	int ret;
+
+	ret = klp_enable_patch(&patch);
+	if (ret)
+		return ret;
+
+	print_saved_command_line();
+	print_driver_name();
+	print_homonym_string();
+
+	return 0;
+}
+
+static void test_klp_convert_exit(void)
+{
+}
+
+module_init(test_klp_convert_init);
+module_exit(test_klp_convert_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Joe Lawrence <joe.lawrence@redhat.com>");
+MODULE_DESCRIPTION("Livepatch test: klp-convert2");
diff --git a/lib/livepatch/test_klp_convert_mod_a.c b/lib/livepatch/test_klp_convert_mod_a.c
new file mode 100644
index 000000000000..b2db9942fbd2
--- /dev/null
+++ b/lib/livepatch/test_klp_convert_mod_a.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2019 Joe Lawrence <joe.lawrence@redhat.com>
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+
+/* Unique symbols that don't need sympos annotation */
+static const char driver_name[] = KBUILD_MODNAME;
+__used static const char *get_driver_name(void)
+{
+	return driver_name;
+}
+
+/* Common symbol names that need sympos */
+static const char homonym_string[] = "homonym string A";
+__used static const char *get_homonym_string(void)
+{
+	return homonym_string;
+}
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Joe Lawrence <joe.lawrence@redhat.com>");
+MODULE_DESCRIPTION("Livepatch test: klp-convert module");
diff --git a/lib/livepatch/test_klp_convert_mod_b.c b/lib/livepatch/test_klp_convert_mod_b.c
new file mode 100644
index 000000000000..a3d529ff5f1f
--- /dev/null
+++ b/lib/livepatch/test_klp_convert_mod_b.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2019 Joe Lawrence <joe.lawrence@redhat.com>
+
+/*
+ * A second compilation unit to provide another set of similarly named
+ * symbols, forcing a livepatch to use sympos annotations.
+ */
+
+static char homonym_string[] = "homonym string B";
+__used static char *get_homonym_string(void)
+{
+	return homonym_string;
+}
diff --git a/tools/testing/selftests/livepatch/test-livepatch.sh b/tools/testing/selftests/livepatch/test-livepatch.sh
index f05268aea859..9c3745e8ba1d 100755
--- a/tools/testing/selftests/livepatch/test-livepatch.sh
+++ b/tools/testing/selftests/livepatch/test-livepatch.sh
@@ -6,6 +6,9 @@
 
 MOD_LIVEPATCH=test_klp_livepatch
 MOD_REPLACE=test_klp_atomic_replace
+MOD_KLP_CONVERT_MOD=test_klp_convert_mod
+MOD_KLP_CONVERT1=test_klp_convert1
+MOD_KLP_CONVERT2=test_klp_convert2
 
 set_dynamic_debug
 
@@ -165,4 +168,65 @@ livepatch: '$MOD_REPLACE': unpatching complete
 % rmmod $MOD_REPLACE"
 
 
+# TEST: klp-convert symbols
+# - load a livepatch that modifies the output from /proc/cmdline
+#   including a reference to vmlinux-local symbol that klp-convert
+#   will process
+# - verify correct behavior
+# - unload the livepatch and make sure the patch was removed
+
+echo -n "TEST: klp-convert symbols ... "
+dmesg -C
+
+saved_cmdline=$(cat /proc/cmdline)
+
+load_mod $MOD_KLP_CONVERT_MOD
+
+load_lp $MOD_KLP_CONVERT1
+disable_lp $MOD_KLP_CONVERT1
+unload_lp $MOD_KLP_CONVERT1
+
+load_lp $MOD_KLP_CONVERT2
+disable_lp $MOD_KLP_CONVERT2
+unload_lp $MOD_KLP_CONVERT2
+
+unload_mod $MOD_KLP_CONVERT_MOD
+
+check_result "% modprobe $MOD_KLP_CONVERT_MOD
+% modprobe $MOD_KLP_CONVERT1
+livepatch: enabling patch '$MOD_KLP_CONVERT1'
+livepatch: '$MOD_KLP_CONVERT1': initializing patching transition
+livepatch: '$MOD_KLP_CONVERT1': starting patching transition
+$MOD_KLP_CONVERT1: saved_command_line, 0: $saved_cmdline
+$MOD_KLP_CONVERT1: driver_name, 0: $MOD_KLP_CONVERT_MOD
+$MOD_KLP_CONVERT1: get_driver_name(), 0: $MOD_KLP_CONVERT_MOD
+$MOD_KLP_CONVERT1: homonym_string, 1: homonym string A
+$MOD_KLP_CONVERT1: get_homonym_string(), 1: homonym string A
+livepatch: '$MOD_KLP_CONVERT1': completing patching transition
+livepatch: '$MOD_KLP_CONVERT1': patching complete
+% echo 0 > /sys/kernel/livepatch/$MOD_KLP_CONVERT1/enabled
+livepatch: '$MOD_KLP_CONVERT1': initializing unpatching transition
+livepatch: '$MOD_KLP_CONVERT1': starting unpatching transition
+livepatch: '$MOD_KLP_CONVERT1': completing unpatching transition
+livepatch: '$MOD_KLP_CONVERT1': unpatching complete
+% rmmod $MOD_KLP_CONVERT1
+% modprobe $MOD_KLP_CONVERT2
+livepatch: enabling patch '$MOD_KLP_CONVERT2'
+livepatch: '$MOD_KLP_CONVERT2': initializing patching transition
+livepatch: '$MOD_KLP_CONVERT2': starting patching transition
+$MOD_KLP_CONVERT2: saved_command_line (auto): $saved_cmdline
+$MOD_KLP_CONVERT2: driver_name, 0: $MOD_KLP_CONVERT_MOD
+$MOD_KLP_CONVERT2: get_driver_name(), (auto): $MOD_KLP_CONVERT_MOD
+$MOD_KLP_CONVERT2: homonym_string, 2: homonym string B
+$MOD_KLP_CONVERT2: get_homonym_string(), 2: homonym string B
+livepatch: '$MOD_KLP_CONVERT2': completing patching transition
+livepatch: '$MOD_KLP_CONVERT2': patching complete
+% echo 0 > /sys/kernel/livepatch/$MOD_KLP_CONVERT2/enabled
+livepatch: '$MOD_KLP_CONVERT2': initializing unpatching transition
+livepatch: '$MOD_KLP_CONVERT2': starting unpatching transition
+livepatch: '$MOD_KLP_CONVERT2': completing unpatching transition
+livepatch: '$MOD_KLP_CONVERT2': unpatching complete
+% rmmod $MOD_KLP_CONVERT2
+% rmmod $MOD_KLP_CONVERT_MOD"
+
 exit 0
-- 
2.20.1

