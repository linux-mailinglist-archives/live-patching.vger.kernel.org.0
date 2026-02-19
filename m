Return-Path: <live-patching+bounces-2061-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wIBUM3CNl2lv0QIAu9opvQ
	(envelope-from <live-patching+bounces-2061-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 23:23:44 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 472F1163244
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 23:23:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 380DA3015A78
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 22:23:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7A9B32B9A9;
	Thu, 19 Feb 2026 22:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kcm6bgBB"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48E932B9A4
	for <live-patching@vger.kernel.org>; Thu, 19 Feb 2026 22:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771539820; cv=none; b=RyfzBjuvkimcUPl87LIGtNWR6eV3sfYptySqLSpm89AbHp90xrC0nrtIwriyxQfr8Px3V2uURo7vmyDQaO7+nmbpIKiPys6Y7WIzzW7TvTNhPae+GI6FKnKf8GdV0Il8WZoZHFeqQmak28LqACC7KtPWnqx3ml+AwNg7qUFnZSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771539820; c=relaxed/simple;
	bh=xJWMnk4774uO5kACm2ui1fwMNwas6CquIfTeFQMS0K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxITK4UTgTMvhkG9hLnKt5gHbLlPVU/Or4dOoLVZDiSywfNWIqRgKZPY+8IRJhAwFTEvwQwwYohoDe48JaR3iy9DG5tEUb7mlGxFq6k9/dDf/AyTQaMXQSXlAw1DlhZstYRK/elZT5UeZUBhQP2ML46Qd6djCPV19tDOaXJ/TCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kcm6bgBB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2048C4CEF7;
	Thu, 19 Feb 2026 22:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771539820;
	bh=xJWMnk4774uO5kACm2ui1fwMNwas6CquIfTeFQMS0K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kcm6bgBBkX9aMPMcEJdSj3i2sekFaUE+xXm8C1lywT8PgsOnaOwF453XT6oWf7O7F
	 6QFvm5/r69MysIriQDTyo6bAoBP5g2pGZWlBxWz07x1RxxtdX0eGzfM5TowBBuwxtJ
	 52tSKNcyMH7jpnhQ7fZDYspZXcEFDrGzR20tH9ik5gSOyYhPVf2rxL2dGs+GhSPX3H
	 d8Jyf749S3dHXOqV24JOiAdoKb8hz8GZzRC7Tm9/EZg5FnH+GttLOqn/+2wDwKwvNJ
	 RFuHSjEPftY5nbTS45AwYUhWY2CvpZdNyHtvQ8N+Pv5tJIneZ3t2rKN2+Vly0TU8RY
	 n7k97h4M5FG+A==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH v2 8/8] livepatch: Add tests for klp-build toolchain
Date: Thu, 19 Feb 2026 14:22:39 -0800
Message-ID: <20260219222239.3650400-9-song@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260219222239.3650400-1-song@kernel.org>
References: <20260219222239.3650400-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2061-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 472F1163244
X-Rspamd-Action: no action

Add selftests for the klp-build toolchain. This includes kernel side test
code and .patch files. The tests cover both livepatch to vmlinux and kernel
modules.

Check tools/testing/selftests/livepatch/test_patches/README for
instructions to run these tests.

Signed-off-by: Song Liu <song@kernel.org>

---

AI was used to wrote the test code and .patch files in this.
---
 kernel/livepatch/Kconfig                      |  20 +++
 kernel/livepatch/Makefile                     |   2 +
 kernel/livepatch/tests/Makefile               |   6 +
 kernel/livepatch/tests/klp_test_module.c      | 111 ++++++++++++++
 kernel/livepatch/tests/klp_test_module.h      |   8 +
 kernel/livepatch/tests/klp_test_vmlinux.c     | 138 ++++++++++++++++++
 kernel/livepatch/tests/klp_test_vmlinux.h     |  16 ++
 kernel/livepatch/tests/klp_test_vmlinux_aux.c |  59 ++++++++
 .../selftests/livepatch/test_patches/README   |  15 ++
 .../test_patches/klp_test_hash_change.patch   |  30 ++++
 .../test_patches/klp_test_module.patch        |  18 +++
 .../klp_test_nonstatic_to_static.patch        |  40 +++++
 .../klp_test_static_to_nonstatic.patch        |  39 +++++
 .../test_patches/klp_test_vmlinux.patch       |  18 +++
 14 files changed, 520 insertions(+)
 create mode 100644 kernel/livepatch/tests/Makefile
 create mode 100644 kernel/livepatch/tests/klp_test_module.c
 create mode 100644 kernel/livepatch/tests/klp_test_module.h
 create mode 100644 kernel/livepatch/tests/klp_test_vmlinux.c
 create mode 100644 kernel/livepatch/tests/klp_test_vmlinux.h
 create mode 100644 kernel/livepatch/tests/klp_test_vmlinux_aux.c
 create mode 100644 tools/testing/selftests/livepatch/test_patches/README
 create mode 100644 tools/testing/selftests/livepatch/test_patches/klp_test_hash_change.patch
 create mode 100644 tools/testing/selftests/livepatch/test_patches/klp_test_module.patch
 create mode 100644 tools/testing/selftests/livepatch/test_patches/klp_test_nonstatic_to_static.patch
 create mode 100644 tools/testing/selftests/livepatch/test_patches/klp_test_static_to_nonstatic.patch
 create mode 100644 tools/testing/selftests/livepatch/test_patches/klp_test_vmlinux.patch

diff --git a/kernel/livepatch/Kconfig b/kernel/livepatch/Kconfig
index 4c0a9c18d0b2..852049601389 100644
--- a/kernel/livepatch/Kconfig
+++ b/kernel/livepatch/Kconfig
@@ -30,3 +30,23 @@ config KLP_BUILD
 	select OBJTOOL
 	help
 	  Enable klp-build support
+
+config KLP_TEST
+	bool "Livepatch test code"
+	depends on LIVEPATCH
+	help
+	  Dummy kernel code for testing the klp-build livepatch toolchain.
+	  Provides built-in vmlinux functions with sysfs interfaces for
+	  verifying livepatches.
+
+	  If unsure, say N.
+
+config KLP_TEST_MODULE
+	tristate "Livepatch test module (klp_test_module)"
+	depends on KLP_TEST && m
+	help
+	  Test module for livepatch testing. Dummy kernel module for
+	  testing the klp-build toolchain. Provides sysfs interfaces for
+	  verifying livepatches.
+
+	  If unsure, say N.
diff --git a/kernel/livepatch/Makefile b/kernel/livepatch/Makefile
index cf03d4bdfc66..751080a62cec 100644
--- a/kernel/livepatch/Makefile
+++ b/kernel/livepatch/Makefile
@@ -2,3 +2,5 @@
 obj-$(CONFIG_LIVEPATCH) += livepatch.o
 
 livepatch-objs := core.o patch.o shadow.o state.o transition.o
+
+obj-$(CONFIG_KLP_TEST) += tests/
diff --git a/kernel/livepatch/tests/Makefile b/kernel/livepatch/tests/Makefile
new file mode 100644
index 000000000000..82ae48f54abe
--- /dev/null
+++ b/kernel/livepatch/tests/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-y                           += klp_test_vmlinux_all.o
+obj-$(CONFIG_KLP_TEST_MODULE)   += klp_test_module.o
+
+klp_test_vmlinux_all-y := klp_test_vmlinux.o \
+			   klp_test_vmlinux_aux.o
diff --git a/kernel/livepatch/tests/klp_test_module.c b/kernel/livepatch/tests/klp_test_module.c
new file mode 100644
index 000000000000..25cefbe36a2b
--- /dev/null
+++ b/kernel/livepatch/tests/klp_test_module.c
@@ -0,0 +1,111 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * klp_test_module.c - Single-file test module for livepatch/klp-build testing
+ *
+ * Copyright (C) 2026 Meta Platforms, Inc. and affiliates.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/string.h>
+#include "klp_test_module.h"
+#include "klp_test_vmlinux.h"
+
+static int klp_test_module_var1;
+static int klp_test_module_var2;
+
+static noinline ssize_t __klp_test_module_func1(char *buf, int len)
+{
+	ssize_t ret = 0;
+	int i;
+
+	for (i = 0; i < len; i++)
+		klp_test_module_var1 += i;
+
+	if (klp_test_module_var1 > 1000)
+		klp_test_module_var1 = 0;
+
+	ret = sysfs_emit(buf, "klp_test_module_func1 unpatched %d\n",
+			 klp_test_module_var1);
+	return ret;
+}
+
+ssize_t klp_test_module_func1(char *buf, int len)
+{
+	return __klp_test_module_func1(buf, len);
+}
+EXPORT_SYMBOL_GPL(klp_test_module_func1);
+
+static noinline ssize_t __klp_test_module_func2(char *buf, int len)
+{
+	ssize_t ret = 0;
+	int i;
+
+	for (i = 0; i < len; i++)
+		klp_test_module_var2 += i * 2;
+
+	if (klp_test_module_var2 > 1000)
+		klp_test_module_var2 = 0;
+
+	ret = sysfs_emit(buf, "klp_test_module_func2 unpatched %d\n",
+			 klp_test_module_var2);
+	return ret;
+}
+
+ssize_t klp_test_module_func2(char *buf, int len)
+{
+	return __klp_test_module_func2(buf, len);
+}
+EXPORT_SYMBOL_GPL(klp_test_module_func2);
+
+static ssize_t func1_show(struct kobject *kobj,
+			   struct kobj_attribute *attr, char *buf)
+{
+	return klp_test_module_func1(buf, 5);
+}
+
+static ssize_t func2_show(struct kobject *kobj,
+			   struct kobj_attribute *attr, char *buf)
+{
+	return klp_test_module_func2(buf, 5);
+}
+
+static struct kobj_attribute func1_attr = __ATTR_RO(func1);
+static struct kobj_attribute func2_attr = __ATTR_RO(func2);
+
+static struct attribute *klp_test_module_attrs[] = {
+	&func1_attr.attr,
+	&func2_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group klp_test_module_attr_group = {
+	.attrs = klp_test_module_attrs,
+};
+
+static struct kobject *klp_test_module_kobj;
+
+static int __init klp_test_module_init(void)
+{
+	klp_test_module_kobj = kobject_create_and_add("module",
+						      klp_test_kobj);
+	if (!klp_test_module_kobj)
+		return -ENOMEM;
+
+	return sysfs_create_group(klp_test_module_kobj,
+				  &klp_test_module_attr_group);
+}
+
+static void __exit klp_test_module_exit(void)
+{
+	sysfs_remove_group(klp_test_module_kobj, &klp_test_module_attr_group);
+	kobject_put(klp_test_module_kobj);
+}
+
+module_init(klp_test_module_init);
+module_exit(klp_test_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Livepatch single-file test module");
diff --git a/kernel/livepatch/tests/klp_test_module.h b/kernel/livepatch/tests/klp_test_module.h
new file mode 100644
index 000000000000..56a766f4744b
--- /dev/null
+++ b/kernel/livepatch/tests/klp_test_module.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _KLP_TEST_MODULE_H
+#define _KLP_TEST_MODULE_H
+
+ssize_t klp_test_module_func1(char *buf, int len);
+ssize_t klp_test_module_func2(char *buf, int len);
+
+#endif /* _KLP_TEST_MODULE_H */
diff --git a/kernel/livepatch/tests/klp_test_vmlinux.c b/kernel/livepatch/tests/klp_test_vmlinux.c
new file mode 100644
index 000000000000..bd4157ea97c0
--- /dev/null
+++ b/kernel/livepatch/tests/klp_test_vmlinux.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * klp_test_vmlinux.c - Dummy built-in code for livepatch/klp-build testing
+ *
+ * Copyright (C) 2026 Meta Platforms, Inc. and affiliates.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include "klp_test_vmlinux.h"
+
+static int klp_test_vmlinux_var1;
+static int klp_test_vmlinux_var2;
+
+static noinline int __helper(int x, int len)
+{
+	int i, sum = x;
+
+	for (i = 0; i < len; i++)
+		sum += i + 5;
+	if (sum > 1000)
+		sum = 0;
+	return sum;
+}
+
+static noinline ssize_t __klp_test_vmlinux_func1(char *buf, int len)
+{
+	ssize_t ret = 0;
+
+	klp_test_vmlinux_var1 = __helper(klp_test_vmlinux_var1, len);
+
+	ret = sysfs_emit(buf, "klp_test_vmlinux_func1 unpatched %d\n",
+			 klp_test_vmlinux_var1);
+	return ret;
+}
+
+ssize_t klp_test_vmlinux_func1(char *buf, int len)
+{
+	return __klp_test_vmlinux_func1(buf, len);
+}
+EXPORT_SYMBOL_GPL(klp_test_vmlinux_func1);
+
+static noinline ssize_t __klp_test_vmlinux_func2(char *buf, int len)
+{
+	ssize_t ret = 0;
+	int i;
+
+	for (i = 0; i < len; i++)
+		klp_test_vmlinux_var2 += i * 2;
+
+	if (klp_test_vmlinux_var2 > 1000)
+		klp_test_vmlinux_var2 = 0;
+
+	ret = sysfs_emit(buf, "klp_test_vmlinux_func2 unpatched %d\n",
+			 klp_test_vmlinux_var2);
+	return ret;
+}
+
+ssize_t klp_test_vmlinux_func2(char *buf, int len)
+{
+	return __klp_test_vmlinux_func2(buf, len);
+}
+EXPORT_SYMBOL_GPL(klp_test_vmlinux_func2);
+
+static ssize_t vmlinux_func1_show(struct kobject *kobj,
+				   struct kobj_attribute *attr, char *buf)
+{
+	return klp_test_vmlinux_func1(buf, 5);
+}
+
+static ssize_t vmlinux_func2_show(struct kobject *kobj,
+				   struct kobj_attribute *attr, char *buf)
+{
+	return klp_test_vmlinux_func2(buf, 5);
+}
+
+static struct kobj_attribute vmlinux_func1_attr = __ATTR_RO(vmlinux_func1);
+static struct kobj_attribute vmlinux_func2_attr = __ATTR_RO(vmlinux_func2);
+
+static struct attribute *klp_test_attrs[] = {
+	&vmlinux_func1_attr.attr,
+	&vmlinux_func2_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group klp_test_attr_group = {
+	.attrs = klp_test_attrs,
+};
+
+static struct kobject *klp_test_vmlinux_kobj;
+struct kobject *klp_test_kobj;
+EXPORT_SYMBOL_GPL(klp_test_kobj);
+
+static int __init klp_test_vmlinux_init(void)
+{
+	int ret;
+
+	klp_test_kobj = kobject_create_and_add("klp_test", kernel_kobj);
+	if (!klp_test_kobj)
+		return -ENOMEM;
+
+	klp_test_vmlinux_kobj = kobject_create_and_add("vmlinux", klp_test_kobj);
+	if (!klp_test_vmlinux_kobj) {
+		kobject_put(klp_test_kobj);
+		return -ENOMEM;
+	}
+
+	ret = sysfs_create_group(klp_test_vmlinux_kobj, &klp_test_attr_group);
+	if (ret)
+		goto err_group;
+
+	ret = klp_test_vmlinux_aux_init(klp_test_vmlinux_kobj);
+	if (ret)
+		goto err_aux;
+
+	return 0;
+
+err_aux:
+	sysfs_remove_group(klp_test_vmlinux_kobj, &klp_test_attr_group);
+err_group:
+	kobject_put(klp_test_vmlinux_kobj);
+	kobject_put(klp_test_kobj);
+	return ret;
+}
+
+static void __exit klp_test_vmlinux_exit(void)
+{
+	klp_test_vmlinux_aux_exit(klp_test_vmlinux_kobj);
+	sysfs_remove_group(klp_test_vmlinux_kobj, &klp_test_attr_group);
+	kobject_put(klp_test_vmlinux_kobj);
+	kobject_put(klp_test_kobj);
+}
+
+late_initcall(klp_test_vmlinux_init);
diff --git a/kernel/livepatch/tests/klp_test_vmlinux.h b/kernel/livepatch/tests/klp_test_vmlinux.h
new file mode 100644
index 000000000000..56d9f7b6d350
--- /dev/null
+++ b/kernel/livepatch/tests/klp_test_vmlinux.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _KLP_TEST_VMLINUX_H
+#define _KLP_TEST_VMLINUX_H
+
+#include <linux/kobject.h>
+
+extern struct kobject *klp_test_kobj;
+
+ssize_t klp_test_vmlinux_func1(char *buf, int len);
+ssize_t klp_test_vmlinux_func2(char *buf, int len);
+ssize_t klp_test_vmlinux_func3(char *buf, int len);
+
+int klp_test_vmlinux_aux_init(struct kobject *parent);
+void klp_test_vmlinux_aux_exit(struct kobject *parent);
+
+#endif /* _KLP_TEST_VMLINUX_H */
diff --git a/kernel/livepatch/tests/klp_test_vmlinux_aux.c b/kernel/livepatch/tests/klp_test_vmlinux_aux.c
new file mode 100644
index 000000000000..1d76b0308a11
--- /dev/null
+++ b/kernel/livepatch/tests/klp_test_vmlinux_aux.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * klp_test_vmlinux_aux.c - Auxiliary built-in code for livepatch/klp-build
+ *                          testing. This file has its own static __helper()
+ *                          to test ThinLTO .llvm.<hash> suffix handling.
+ *
+ * Copyright (C) 2026 Meta Platforms, Inc. and affiliates.
+ */
+
+#include <linux/kernel.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/string.h>
+#include "klp_test_vmlinux.h"
+
+static int klp_test_vmlinux_var3;
+
+static noinline int __helper(int x, int len)
+{
+	int i, sum = x;
+
+	for (i = 0; i < len; i++)
+		sum += i + 10;
+	if (sum > 1000)
+		sum = 0;
+	return sum;
+}
+
+static noinline ssize_t __klp_test_vmlinux_func3(char *buf, int len)
+{
+	klp_test_vmlinux_var3 = __helper(klp_test_vmlinux_var3, len);
+
+	return sysfs_emit(buf, "klp_test_vmlinux_func3 unpatched %d\n",
+			 klp_test_vmlinux_var3);
+}
+
+ssize_t klp_test_vmlinux_func3(char *buf, int len)
+{
+	return __klp_test_vmlinux_func3(buf, len);
+}
+EXPORT_SYMBOL_GPL(klp_test_vmlinux_func3);
+
+static ssize_t vmlinux_func3_show(struct kobject *kobj,
+				   struct kobj_attribute *attr, char *buf)
+{
+	return klp_test_vmlinux_func3(buf, 5);
+}
+
+static struct kobj_attribute vmlinux_func3_attr = __ATTR_RO(vmlinux_func3);
+
+int klp_test_vmlinux_aux_init(struct kobject *parent)
+{
+	return sysfs_create_file(parent, &vmlinux_func3_attr.attr);
+}
+
+void klp_test_vmlinux_aux_exit(struct kobject *parent)
+{
+	sysfs_remove_file(parent, &vmlinux_func3_attr.attr);
+}
diff --git a/tools/testing/selftests/livepatch/test_patches/README b/tools/testing/selftests/livepatch/test_patches/README
new file mode 100644
index 000000000000..8266348aab57
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_patches/README
@@ -0,0 +1,15 @@
+This is folder contains patches to test the klp-build toolchain.
+
+To run the test:
+
+1. Enable CONFIG_KLP_TEST and CONFIG_KLP_TEST_MODULE, and build the kernel.
+
+2. Build these patches with:
+
+  ./scripts/livepatch/klp-build tools/testing/selftests/livepatch/test_patches/*.patch
+
+3. Verify the correctness with:
+
+  modprobe klp_test_module
+  kpatch load livepatch-patch.ko
+  grep -q unpatched /sys/kernel/klp_test/*/* && echo FAIL || echo PASS
diff --git a/tools/testing/selftests/livepatch/test_patches/klp_test_hash_change.patch b/tools/testing/selftests/livepatch/test_patches/klp_test_hash_change.patch
new file mode 100644
index 000000000000..609d54d6d6f6
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_patches/klp_test_hash_change.patch
@@ -0,0 +1,30 @@
+Test ThinLTO .llvm.<hash> suffix handling.
+
+Modify a static __helper() function whose body change causes its
+.llvm.<hash> suffix to change under ThinLTO. Both klp_test_vmlinux.c
+and klp_test_vmlinux_aux.c define static __helper() with different
+bodies, so ThinLTO promotes both to globals with different hashes.
+This patch changes the __helper() in the aux file, which changes its
+hash, and klp-build must correctly match the old and new symbols.
+
+diff --git i/kernel/livepatch/tests/klp_test_vmlinux_aux.c w/kernel/livepatch/tests/klp_test_vmlinux_aux.c
+--- i/kernel/livepatch/tests/klp_test_vmlinux_aux.c
++++ w/kernel/livepatch/tests/klp_test_vmlinux_aux.c
+@@ -20,7 +20,7 @@
+ 	int i, sum = x;
+ 
+ 	for (i = 0; i < len; i++)
+-		sum += i + 10;
++		sum += i * 2 + 10;
+ 	if (sum > 1000)
+ 		sum = 0;
+ 	return sum;
+@@ -30,7 +30,7 @@
+ {
+ 	klp_test_vmlinux_var3 = __helper(klp_test_vmlinux_var3, len);
+ 
+-	return sysfs_emit(buf, "klp_test_vmlinux_func3 unpatched %d\n",
++	return sysfs_emit(buf, "klp_test_vmlinux_func3 hash_patched %d\n",
+ 			 klp_test_vmlinux_var3);
+ }
+ 
diff --git a/tools/testing/selftests/livepatch/test_patches/klp_test_module.patch b/tools/testing/selftests/livepatch/test_patches/klp_test_module.patch
new file mode 100644
index 000000000000..d86e75618136
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_patches/klp_test_module.patch
@@ -0,0 +1,18 @@
+Test basic module patching.
+
+Patch a loadable module function to verify that klp-build can generate
+a livepatch for module code. Changes __klp_test_module_func1() output
+from "unpatched" to "patched".
+
+diff --git i/kernel/livepatch/tests/klp_test_module.c w/kernel/livepatch/tests/klp_test_module.c
+--- i/kernel/livepatch/tests/klp_test_module.c
++++ w/kernel/livepatch/tests/klp_test_module.c
+@@ -27,7 +27,7 @@
+ 	if (klp_test_module_var1 > 1000)
+ 		klp_test_module_var1 = 0;
+ 
+-	ret = sysfs_emit(buf, "klp_test_module_func1 unpatched %d\n",
++	ret = sysfs_emit(buf, "klp_test_module_func1 patched %d\n",
+ 			 klp_test_module_var1);
+ 	return ret;
+ }
diff --git a/tools/testing/selftests/livepatch/test_patches/klp_test_nonstatic_to_static.patch b/tools/testing/selftests/livepatch/test_patches/klp_test_nonstatic_to_static.patch
new file mode 100644
index 000000000000..f26711c6bfac
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_patches/klp_test_nonstatic_to_static.patch
@@ -0,0 +1,40 @@
+Test nonstatic-to-static symbol change.
+
+Change klp_test_module_func2() from nonstatic (global) to static and
+remove its EXPORT_SYMBOL_GPL. Also remove its declaration from the
+header file. This tests klp-build's ability to handle symbol visibility
+changes where a function that was originally global becomes static in
+the patched kernel.
+
+diff --git i/kernel/livepatch/tests/klp_test_module.c w/kernel/livepatch/tests/klp_test_module.c
+--- i/kernel/livepatch/tests/klp_test_module.c
++++ w/kernel/livepatch/tests/klp_test_module.c
+@@ -49,16 +49,15 @@
+ 	if (klp_test_module_var2 > 1000)
+ 		klp_test_module_var2 = 0;
+
+-	ret = sysfs_emit(buf, "klp_test_module_func2 unpatched %d\n",
++	ret = sysfs_emit(buf, "klp_test_module_func2 patched_nts %d\n",
+ 			 klp_test_module_var2);
+ 	return ret;
+ }
+
+-ssize_t klp_test_module_func2(char *buf, int len)
++static noinline ssize_t klp_test_module_func2(char *buf, int len)
+ {
+ 	return __klp_test_module_func2(buf, len);
+ }
+-EXPORT_SYMBOL_GPL(klp_test_module_func2);
+
+ static ssize_t func1_show(struct kobject *kobj,
+ 			   struct kobj_attribute *attr, char *buf)
+diff --git i/kernel/livepatch/tests/klp_test_module.h w/kernel/livepatch/tests/klp_test_module.h
+--- i/kernel/livepatch/tests/klp_test_module.h
++++ w/kernel/livepatch/tests/klp_test_module.h
+@@ -3,6 +3,5 @@
+ #define _KLP_TEST_MODULE_H
+
+ ssize_t klp_test_module_func1(char *buf, int len);
+-ssize_t klp_test_module_func2(char *buf, int len);
+
+ #endif /* _KLP_TEST_MODULE_H */
diff --git a/tools/testing/selftests/livepatch/test_patches/klp_test_static_to_nonstatic.patch b/tools/testing/selftests/livepatch/test_patches/klp_test_static_to_nonstatic.patch
new file mode 100644
index 000000000000..673f6c42f698
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_patches/klp_test_static_to_nonstatic.patch
@@ -0,0 +1,39 @@
+Test static-to-nonstatic symbol change.
+
+Change __klp_test_vmlinux_func2() from static to nonstatic (global).
+This tests klp-build's ability to handle symbol visibility changes
+where a function that was originally static becomes globally visible
+in the patched kernel.
+
+diff --git i/kernel/livepatch/tests/klp_test_vmlinux.c w/kernel/livepatch/tests/klp_test_vmlinux.c
+--- i/kernel/livepatch/tests/klp_test_vmlinux.c
++++ w/kernel/livepatch/tests/klp_test_vmlinux.c
+@@ -44,7 +44,7 @@
+ }
+ EXPORT_SYMBOL_GPL(klp_test_vmlinux_func1);
+
+-static noinline ssize_t __klp_test_vmlinux_func2(char *buf, int len)
++noinline ssize_t __klp_test_vmlinux_func2(char *buf, int len)
+ {
+ 	ssize_t ret = 0;
+ 	int i;
+@@ -55,7 +55,7 @@
+ 	if (klp_test_vmlinux_var2 > 1000)
+ 		klp_test_vmlinux_var2 = 0;
+
+-	ret = sysfs_emit(buf, "klp_test_vmlinux_func2 unpatched %d\n",
++	ret = sysfs_emit(buf, "klp_test_vmlinux_func2 patched_stn %d\n",
+ 			 klp_test_vmlinux_var2);
+ 	return ret;
+ }
+diff --git i/kernel/livepatch/tests/klp_test_vmlinux.h w/kernel/livepatch/tests/klp_test_vmlinux.h
+--- i/kernel/livepatch/tests/klp_test_vmlinux.h
++++ w/kernel/livepatch/tests/klp_test_vmlinux.h
+@@ -9,6 +9,7 @@
+ ssize_t klp_test_vmlinux_func1(char *buf, int len);
+ ssize_t klp_test_vmlinux_func2(char *buf, int len);
+ ssize_t klp_test_vmlinux_func3(char *buf, int len);
++ssize_t __klp_test_vmlinux_func2(char *buf, int len);
+
+ int klp_test_vmlinux_aux_init(struct kobject *parent);
+ void klp_test_vmlinux_aux_exit(struct kobject *parent);
diff --git a/tools/testing/selftests/livepatch/test_patches/klp_test_vmlinux.patch b/tools/testing/selftests/livepatch/test_patches/klp_test_vmlinux.patch
new file mode 100644
index 000000000000..8b1d91381728
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_patches/klp_test_vmlinux.patch
@@ -0,0 +1,18 @@
+Test basic vmlinux patching.
+
+Patch a built-in vmlinux function to verify that klp-build can generate
+a livepatch for vmlinux code. Changes __klp_test_vmlinux_func1() output
+from "unpatched" to "patched".
+
+diff --git i/kernel/livepatch/tests/klp_test_vmlinux.c w/kernel/livepatch/tests/klp_test_vmlinux.c
+--- i/kernel/livepatch/tests/klp_test_vmlinux.c
++++ w/kernel/livepatch/tests/klp_test_vmlinux.c
+@@ -33,7 +33,7 @@
+ 
+ 	klp_test_vmlinux_var1 = __helper(klp_test_vmlinux_var1, len);
+ 
+-	ret = sysfs_emit(buf, "klp_test_vmlinux_func1 unpatched %d\n",
++	ret = sysfs_emit(buf, "klp_test_vmlinux_func1 patched %d\n",
+ 			 klp_test_vmlinux_var1);
+ 	return ret;
+ }
-- 
2.47.3


