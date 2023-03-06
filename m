Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25846AC2DA
	for <lists+live-patching@lfdr.de>; Mon,  6 Mar 2023 15:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbjCFORl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 Mar 2023 09:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjCFORX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 Mar 2023 09:17:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B507930B32
        for <live-patching@vger.kernel.org>; Mon,  6 Mar 2023 06:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678112079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C3T4cQVbWMtjxm03/QxVsrwc84RWdeJZN2OA0wo1jZE=;
        b=XHf4QlBwWZEbWEn1kLZUeU9fyZA6BD5FFRLeMUI+Tm4V24AURwJldYkOnqqtrUUSTrvIUj
        BhAFqAEl1VEtulJugYJEXYeyb/MZoYg4SUucd+Hne3ghWtzQN4R5AuURqVTwcF0N4/B38l
        Qe/PY5MCHc+MlxUVdRkmr8pkpFrq2A0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-z2XGW4OYNIyTGljoTBp9SQ-1; Mon, 06 Mar 2023 09:08:30 -0500
X-MC-Unique: z2XGW4OYNIyTGljoTBp9SQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 698C73C02184;
        Mon,  6 Mar 2023 14:08:30 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (unknown [10.22.17.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1457E40C945A;
        Mon,  6 Mar 2023 14:08:30 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH v7 09/10] livepatch/selftests: add data relocations test
Date:   Mon,  6 Mar 2023 09:08:23 -0500
Message-Id: <20230306140824.3858543-10-joe.lawrence@redhat.com>
In-Reply-To: <20230306140824.3858543-1-joe.lawrence@redhat.com>
References: <20230306140824.3858543-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Add a test which creates a variety of klp-data-relocations.  Note that
this test case exercises late-klp-relocations for references to data.
For this, we only need to adjust pointer storage classes (and not the
target data) to affect where the relocation ends up.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 lib/livepatch/Makefile                        |   4 +-
 lib/livepatch/test_klp_convert.h              |  21 ++
 lib/livepatch/test_klp_convert_data.c         | 190 ++++++++++++++++++
 lib/livepatch/test_klp_convert_mod_c.c        |  36 ++++
 .../selftests/livepatch/test-livepatch.sh     |  95 +++++++++
 5 files changed, 345 insertions(+), 1 deletion(-)
 create mode 100644 lib/livepatch/test_klp_convert_data.c
 create mode 100644 lib/livepatch/test_klp_convert_mod_c.c

diff --git a/lib/livepatch/Makefile b/lib/livepatch/Makefile
index 77e21317d4da..da39aaa5c8fc 100644
--- a/lib/livepatch/Makefile
+++ b/lib/livepatch/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_TEST_LIVEPATCH) += test_klp_atomic_replace.o \
 				test_klp_callbacks_mod.o \
 				test_klp_convert1.o \
 				test_klp_convert2.o \
+				test_klp_convert_data.o \
 				test_klp_convert_sections.o \
 				test_klp_convert_mod.o \
 				test_klp_livepatch.o \
@@ -19,4 +20,5 @@ obj-$(CONFIG_TEST_LIVEPATCH) += test_klp_atomic_replace.o \
 
 test_klp_convert_mod-y := \
 	test_klp_convert_mod_a.o \
-	test_klp_convert_mod_b.o
+	test_klp_convert_mod_b.o \
+	test_klp_convert_mod_c.o
diff --git a/lib/livepatch/test_klp_convert.h b/lib/livepatch/test_klp_convert.h
index 42befbfd63cb..08c0f4b1dc6b 100644
--- a/lib/livepatch/test_klp_convert.h
+++ b/lib/livepatch/test_klp_convert.h
@@ -12,5 +12,26 @@ extern const char *get_homonym_string(void);
 extern const char *test_klp_get_driver_name(void);
 extern char klp_string_a[] __asm__("klp_string.12345");
 extern char klp_string_b[] __asm__("klp_string.67890");
+extern int global_small;
+// .rela.data.rel.ro, .rela.rodata supported ???:
+extern int const_global_small;
+extern int static_small;
+extern int static_const_small;
+extern int global_large[];
+// .rela.data.rel.ro, .rela.rodata supported ???:
+extern int const_global_large[];
+extern int static_large[];
+extern int static_const_large[];
+extern int local_small;
+extern int const_local_small;
+extern int static_local_small;
+extern int static_const_local_small;
+extern int local_large[4];
+extern int const_local_large[4];
+extern int static_local_large[4];
+extern int static_const_local_large[4];
+// .rela.data..ro_after_init supported ???:
+extern int static_ro_after_init;
+extern int static_read_mostly;
 
 #endif
diff --git a/lib/livepatch/test_klp_convert_data.c b/lib/livepatch/test_klp_convert_data.c
new file mode 100644
index 000000000000..da94f7af272f
--- /dev/null
+++ b/lib/livepatch/test_klp_convert_data.c
@@ -0,0 +1,190 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2021 Joe Lawrence <joe.lawrence@redhat.com>
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/cache.h>
+#include <linux/livepatch.h>
+#include "test_klp_convert.h"
+
+/* Small global */
+int *p_global_small = &global_small;
+
+/* Small global (const) */
+// .rela.data.rel.ro, .rela.rodata supported ???:
+int * const p_const_global_small = &const_global_small;
+
+/* Small file-static */
+static int *p_static_small = &static_small;
+
+/* Small file-static (constant) */
+static int * const p_static_const_small = &static_const_small;
+
+/* Large global */
+int *p_global_large[4] = {
+	&global_large[0], &global_large[1],
+	&global_large[2], &global_large[3],
+};
+
+/* Large global (const) */
+// .rela.data.rel.ro, .rela.rodata supported ???:
+int * const p_const_global_large[4] = {
+	&const_global_large[0], &const_global_large[1],
+	&const_global_large[2], &const_global_large[3],
+};
+
+/* Large file-static global */
+static int *p_static_large[4] = {
+	&static_large[0], &static_large[1],
+	&static_large[2], &static_large[3],
+};
+
+/* Large file-static (const) */
+static int * const p_static_const_large[4] = {
+	&static_const_large[0], &static_const_large[1],
+	&static_const_large[2], &static_const_large[3],
+};
+
+// .rela.data.rel.ro, .rela.rodata supported ???:
+// static int * __ro_after_init p_static_ro_after_init = &static_ro_after_init;
+static int * __read_mostly p_static_read_mostly = &static_read_mostly;
+
+static void print_variables(void)
+{
+	/* Small local */
+	int *p_local_small = &local_small;
+
+	/* Small local (const) */
+	int * const p_const_local_small = &const_local_small;
+
+	/* Small static-local */
+	static int *p_static_local_small = &static_local_small;
+
+	/* Small static-local (const) */
+	static int * const p_static_const_local_small = &static_const_local_small;
+
+	/* Large local */
+	int *p_local_large[4] = {
+		&local_large[0], &local_large[1],
+		&local_large[2], &local_large[3],
+	};
+
+	/* Large local (const) */
+	int * const p_const_local_large[4] = {
+		&const_local_large[0], &const_local_large[1],
+		&const_local_large[2], &const_local_large[3],
+	};
+
+	/* Large static-local local */
+	static int *p_static_local_large[4] = {
+		&static_local_large[0], &static_local_large[1],
+		&static_local_large[2], &static_local_large[3],
+	};
+
+	/* Large static-local (const) */
+	static int * const p_static_const_local_large[4] = {
+		&static_const_local_large[0], &static_const_local_large[1],
+		&static_const_local_large[2], &static_const_local_large[3],
+	};
+
+	pr_info("local_small: %x\n", *p_local_small);
+	pr_info("const_local_small: %x\n", *p_const_local_small);
+	pr_info("static_local_small: %x\n", *p_static_local_small);
+	pr_info("static_const_local_small: %x\n", *p_static_const_local_small);
+	pr_info("local_large[0..3]: %x %x %x %x\n",
+		*p_local_large[0], *p_local_large[1],
+		*p_local_large[2], *p_local_large[3]);
+	pr_info("const_local_large[0..3]: %x %x %x %x\n",
+		*p_const_local_large[0], *p_const_local_large[1],
+		*p_const_local_large[2], *p_const_local_large[3]);
+	pr_info("static_local_large[0..3]: %x %x %x %x\n",
+		*p_static_local_large[0], *p_static_local_large[1],
+		*p_static_local_large[2], *p_static_local_large[3]);
+	pr_info("static_const_local_large[0..3]: %x %x %x %x\n",
+		*p_static_const_local_large[0], *p_static_const_local_large[1],
+		*p_static_const_local_large[2], *p_static_const_local_large[3]);
+
+	pr_info("global_small: %x\n", *p_global_small);
+	// .rela.data.rel.ro, .rela.rodata supported ???:
+	pr_info("const_global_small: %x\n", *p_const_global_small);
+	pr_info("static_small: %x\n", *p_static_small);
+	pr_info("static_const_small: %x\n", *p_static_const_small);
+	pr_info("global_large[0..3]: %x %x %x %x\n",
+		*p_global_large[0], *p_global_large[1],
+		*p_global_large[2], *p_global_large[3]);
+	// .rela.data.rel.ro, .rela.rodata supported ???:
+	pr_info("const_global_large[0..3]: %x %x %x %x\n",
+		*p_const_global_large[0], *p_const_global_large[1],
+		*p_const_global_large[2], *p_const_global_large[3]);
+	pr_info("static_large[0..3]: %x %x %x %x\n",
+		*p_static_large[0], *p_static_large[1],
+		*p_static_large[2], *p_static_large[3]);
+	pr_info("static_const_large[0..3]: %x %x %x %x\n",
+		*p_static_const_large[0], *p_static_const_large[1],
+		*p_static_const_large[2], *p_static_const_large[3]);
+
+	// .rela.data..ro_after_init supported ???:
+	// pr_info("static_ro_after_init: %x\n", *p_static_ro_after_init);
+	pr_info("static_read_mostly: %x\n", *p_static_read_mostly);
+}
+
+/* provide a sysfs handle to invoke debug functions */
+static int print_debug;
+static int print_debug_set(const char *val, const struct kernel_param *kp)
+{
+	print_variables();
+
+	return 0;
+}
+static const struct kernel_param_ops print_debug_ops = {
+	.set = print_debug_set,
+	.get = param_get_int,
+};
+module_param_cb(print_debug, &print_debug_ops, &print_debug, 0200);
+MODULE_PARM_DESC(print_debug, "print klp-convert debugging info");
+
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
+MODULE_DESCRIPTION("Livepatch test: klp-convert-data");
+MODULE_INFO(livepatch, "Y");
diff --git a/lib/livepatch/test_klp_convert_mod_c.c b/lib/livepatch/test_klp_convert_mod_c.c
new file mode 100644
index 000000000000..8f94a313e651
--- /dev/null
+++ b/lib/livepatch/test_klp_convert_mod_c.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2021 Joe Lawrence <joe.lawrence@redhat.com>
+
+#include <linux/types.h>
+
+/*
+ * test_klp_convert_data will create klp-relocations to these variables.
+ * They are named for the storage class of the variable that refers to
+ * the.  This makes it easier to correlate those symbols to the
+ * relocations that refer to them in readelf output.
+ */
+__used static int global_small = 0x1111;
+// .rela.data.rel.ro, .rela.rodata supported ???:
+__used static int const_global_small = 0x2222;
+__used static int static_small = 0x3333;
+__used static int static_const_small = 0x4444;
+
+__used static int global_large[4] = { 0x1111, 0x2222, 0x3333, 0x4444 };
+// .rela.data.rel.ro, .rela.rodata supported ???:
+__used static int const_global_large[4] = { 0x5555, 0x6666, 0x7777, 0x8888 };
+__used static int static_large[4] = { 0x9999, 0xaaaa, 0xbbbb, 0xcccc };
+__used static int static_const_large[4] = { 0xdddd, 0xeeee, 0xffff, 0x0000 };
+
+__used static int local_small = 0x1111;
+__used static int const_local_small = 0x2222;
+__used static int static_local_small = 0x3333;
+__used static int static_const_local_small = 0x4444;
+
+__used static int local_large[4] = { 0x1111, 0x2222, 0x3333, 0x4444 };
+__used static int const_local_large[4] = { 0x5555, 0x6666, 0x7777, 0x8888 };
+__used static int static_local_large[4] = { 0x9999, 0xaaaa, 0xbbbb, 0xcccc };
+__used static int static_const_local_large[4] = { 0xdddd, 0xeeee, 0xffff, 0x0000 };
+
+// .rela.data..ro_after_init supported ???:
+// __used static int static_ro_after_init = 0x1111;
+__used static int static_read_mostly = 0x2222;
diff --git a/tools/testing/selftests/livepatch/test-livepatch.sh b/tools/testing/selftests/livepatch/test-livepatch.sh
index ec3b6c919b01..5bda36b65bb5 100755
--- a/tools/testing/selftests/livepatch/test-livepatch.sh
+++ b/tools/testing/selftests/livepatch/test-livepatch.sh
@@ -9,6 +9,7 @@ MOD_REPLACE=test_klp_atomic_replace
 MOD_KLP_CONVERT_MOD=test_klp_convert_mod
 MOD_KLP_CONVERT1=test_klp_convert1
 MOD_KLP_CONVERT2=test_klp_convert2
+MOD_KLP_CONVERT_DATA=test_klp_convert_data
 MOD_KLP_CONVERT_SECTIONS=test_klp_convert_sections
 
 setup_config
@@ -340,4 +341,98 @@ livepatch: '$MOD_KLP_CONVERT_SECTIONS': unpatching complete
 % rmmod $MOD_KLP_CONVERT_SECTIONS
 % rmmod $MOD_KLP_CONVERT_MOD"
 
+
+# TEST: klp-convert data relocations
+
+start_test "klp-convert data relocations"
+
+load_mod $MOD_KLP_CONVERT_MOD
+load_lp $MOD_KLP_CONVERT_DATA
+
+echo 1 > /sys/module/$MOD_KLP_CONVERT_DATA/parameters/print_debug
+
+disable_lp $MOD_KLP_CONVERT_DATA
+unload_lp $MOD_KLP_CONVERT_DATA
+unload_mod $MOD_KLP_CONVERT_MOD
+
+check_result "% modprobe $MOD_KLP_CONVERT_MOD
+% modprobe $MOD_KLP_CONVERT_DATA
+livepatch: enabling patch '$MOD_KLP_CONVERT_DATA'
+livepatch: '$MOD_KLP_CONVERT_DATA': initializing patching transition
+livepatch: '$MOD_KLP_CONVERT_DATA': starting patching transition
+livepatch: '$MOD_KLP_CONVERT_DATA': completing patching transition
+livepatch: '$MOD_KLP_CONVERT_DATA': patching complete
+$MOD_KLP_CONVERT_DATA: local_small: 1111
+$MOD_KLP_CONVERT_DATA: const_local_small: 2222
+$MOD_KLP_CONVERT_DATA: static_local_small: 3333
+$MOD_KLP_CONVERT_DATA: static_const_local_small: 4444
+$MOD_KLP_CONVERT_DATA: local_large[0..3]: 1111 2222 3333 4444
+$MOD_KLP_CONVERT_DATA: const_local_large[0..3]: 5555 6666 7777 8888
+$MOD_KLP_CONVERT_DATA: static_local_large[0..3]: 9999 aaaa bbbb cccc
+$MOD_KLP_CONVERT_DATA: static_const_local_large[0..3]: dddd eeee ffff 0
+$MOD_KLP_CONVERT_DATA: global_small: 1111
+$MOD_KLP_CONVERT_DATA: const_global_small: 2222
+$MOD_KLP_CONVERT_DATA: static_small: 3333
+$MOD_KLP_CONVERT_DATA: static_const_small: 4444
+$MOD_KLP_CONVERT_DATA: global_large[0..3]: 1111 2222 3333 4444
+$MOD_KLP_CONVERT_DATA: const_global_large[0..3]: 5555 6666 7777 8888
+$MOD_KLP_CONVERT_DATA: static_large[0..3]: 9999 aaaa bbbb cccc
+$MOD_KLP_CONVERT_DATA: static_const_large[0..3]: dddd eeee ffff 0
+$MOD_KLP_CONVERT_DATA: static_read_mostly: 2222
+% echo 0 > /sys/kernel/livepatch/$MOD_KLP_CONVERT_DATA/enabled
+livepatch: '$MOD_KLP_CONVERT_DATA': initializing unpatching transition
+livepatch: '$MOD_KLP_CONVERT_DATA': starting unpatching transition
+livepatch: '$MOD_KLP_CONVERT_DATA': completing unpatching transition
+livepatch: '$MOD_KLP_CONVERT_DATA': unpatching complete
+% rmmod $MOD_KLP_CONVERT_DATA
+% rmmod $MOD_KLP_CONVERT_MOD"
+
+
+# TEST: klp-convert data relocations (late module patching)
+
+start_test "klp-convert data relocations (late module patching)"
+
+load_lp $MOD_KLP_CONVERT_DATA
+load_mod $MOD_KLP_CONVERT_MOD
+
+echo 1 > /sys/module/$MOD_KLP_CONVERT_DATA/parameters/print_debug
+
+disable_lp $MOD_KLP_CONVERT_DATA
+unload_lp $MOD_KLP_CONVERT_DATA
+unload_mod $MOD_KLP_CONVERT_MOD
+
+check_result "% modprobe $MOD_KLP_CONVERT_DATA
+livepatch: enabling patch '$MOD_KLP_CONVERT_DATA'
+livepatch: '$MOD_KLP_CONVERT_DATA': initializing patching transition
+livepatch: '$MOD_KLP_CONVERT_DATA': starting patching transition
+livepatch: '$MOD_KLP_CONVERT_DATA': completing patching transition
+livepatch: '$MOD_KLP_CONVERT_DATA': patching complete
+% modprobe $MOD_KLP_CONVERT_MOD
+livepatch: applying patch '$MOD_KLP_CONVERT_DATA' to loading module '$MOD_KLP_CONVERT_MOD'
+$MOD_KLP_CONVERT_DATA: local_small: 1111
+$MOD_KLP_CONVERT_DATA: const_local_small: 2222
+$MOD_KLP_CONVERT_DATA: static_local_small: 3333
+$MOD_KLP_CONVERT_DATA: static_const_local_small: 4444
+$MOD_KLP_CONVERT_DATA: local_large[0..3]: 1111 2222 3333 4444
+$MOD_KLP_CONVERT_DATA: const_local_large[0..3]: 5555 6666 7777 8888
+$MOD_KLP_CONVERT_DATA: static_local_large[0..3]: 9999 aaaa bbbb cccc
+$MOD_KLP_CONVERT_DATA: static_const_local_large[0..3]: dddd eeee ffff 0
+$MOD_KLP_CONVERT_DATA: global_small: 1111
+$MOD_KLP_CONVERT_DATA: const_global_small: 2222
+$MOD_KLP_CONVERT_DATA: static_small: 3333
+$MOD_KLP_CONVERT_DATA: static_const_small: 4444
+$MOD_KLP_CONVERT_DATA: global_large[0..3]: 1111 2222 3333 4444
+$MOD_KLP_CONVERT_DATA: const_global_large[0..3]: 5555 6666 7777 8888
+$MOD_KLP_CONVERT_DATA: static_large[0..3]: 9999 aaaa bbbb cccc
+$MOD_KLP_CONVERT_DATA: static_const_large[0..3]: dddd eeee ffff 0
+$MOD_KLP_CONVERT_DATA: static_read_mostly: 2222
+% echo 0 > /sys/kernel/livepatch/$MOD_KLP_CONVERT_DATA/enabled
+livepatch: '$MOD_KLP_CONVERT_DATA': initializing unpatching transition
+livepatch: '$MOD_KLP_CONVERT_DATA': starting unpatching transition
+livepatch: '$MOD_KLP_CONVERT_DATA': completing unpatching transition
+livepatch: '$MOD_KLP_CONVERT_DATA': unpatching complete
+% rmmod $MOD_KLP_CONVERT_DATA
+% rmmod $MOD_KLP_CONVERT_MOD"
+
+
 exit 0
-- 
2.39.2

