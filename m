Return-Path: <live-patching+bounces-390-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0A2B930B6E
	for <lists+live-patching@lfdr.de>; Sun, 14 Jul 2024 22:00:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E99A81C208DE
	for <lists+live-patching@lfdr.de>; Sun, 14 Jul 2024 20:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE54513C81C;
	Sun, 14 Jul 2024 20:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m/ORFj9P"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DD27492
	for <live-patching@vger.kernel.org>; Sun, 14 Jul 2024 20:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720987223; cv=none; b=ebG+3pH04cXgsmjtx7XRiw7QraHKLxFxnRi2hXIdysn4eT/16KGg6OeO/gzBJOki70XKOPZC1qTffwR8nsLRNqe+CZtFl47ayGbaev7zjB/Ct2rjn72oerbnXkRDasdV5Q6e3yYlQVAa6l1iu7xHF4vps3BXGhFEAIjzUqEue5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720987223; c=relaxed/simple;
	bh=81V/6dr6KEyIf8Z/jINP1KQQEVVeNs26V297Ov4ui7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+QbV9A+PvlIH1QnuUKkyVnA9me6Dgp1u8qLg1PL95N9dMg0BCMkDSMQ7tzWTCDsE3Kh07BXGxYv8gmY1gWJuweLOtyiw7KFHG0EDVhwiY8dOMYy5OQKB1SVvnw/JRuL8LUpn7WH3dLvI7pWGNc6NhQqZkkt0/LVUH+JbZTvi7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m/ORFj9P; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4266ea6a488so28093315e9.1
        for <live-patching@vger.kernel.org>; Sun, 14 Jul 2024 13:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720987218; x=1721592018; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pq5URGty2b/nUw3CDWTJHMb+yNgCcqf5uC08oad2Wzs=;
        b=m/ORFj9PWOKvnjFNQ3r+nB6z04v4AU3K60ZimVdZkM8nMWdkr8lWhhsH6oBuVzl0Rg
         2PlpK+55sxiCSHdjcoyFp2VcJG2+PxJwyXrO7KnyG6Gmv1mDlsyqsqzfgerpjSoDe4pv
         ujURu2zSGsG+I7pyrQhValmYfESIQV6M6RP22S909XJvy9uYB+mlVqKVKePhlzxDAX50
         ZZgjLZ1IaCMgr5n8/G7qFUxSUbU1yy2iTzS7hCYRefoD8jdGOGY+GwYTkQ6pYx2HXR8T
         0itTAslC784HdL4eBLAcPj+I7PkEW99LYJqw/nmhSU8Axqq0XsBAdmapM5YHlQTmK8o3
         sKOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720987218; x=1721592018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pq5URGty2b/nUw3CDWTJHMb+yNgCcqf5uC08oad2Wzs=;
        b=cifnkmqZfQAiG54RbsuW71oE0XqF1H7cIHWdFoKRSeZLGjuzrsm40o8DwbUGj5PlVd
         NQRzh9pA7Tg4N5/zBKyhJjlQZuzSELaCctg2luW8uuygWXIfcIy3wa8vjfg4v0tuSoFT
         OYaKWPqYkSwP6x16VSTkzqGWGIzVplD0N7ERYqBQ/8wPUX9jQytBvVbJ7URcXOOz8lf6
         MMiDICcOfDp8g7CxvP+tndg3dLQv/vvfhrQ74RaXBA5nS9FPqVsyiCuZ0TzKesR/UB9g
         wfsUMBPOiCfQJFNmy6PTI+O4KEQ9aw70DPbjHsE5duxg/5WLSA1tt3ZPKneamwAxhBf0
         FdEQ==
X-Gm-Message-State: AOJu0YxPnb84U7WLHG5juZI2eVA5Xf4hJX1ZH09yrB4Fgb9U8Jg6W+Fn
	3g/JLRQ57EJKTnNrBFGrfUtTG0b5CNVCzEwpmJ0G5LvNehGJ6VeRzXRrlca7NEA=
X-Google-Smtp-Source: AGHT+IFizF05NAxMe9khbHYL48i8BbIsEESETePqn2sydNbQ6ffGYCJ+DJgUDeCjQBU3JQ47zFBCag==
X-Received: by 2002:a05:600c:4aa9:b0:426:5b44:2be7 with SMTP id 5b1f17b1804b1-426707cea49mr146702525e9.10.1720987218211;
        Sun, 14 Jul 2024 13:00:18 -0700 (PDT)
Received: from roman-work.. ([77.222.27.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427a5edb525sm61145985e9.34.2024.07.14.13.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jul 2024 13:00:18 -0700 (PDT)
From: raschupkin.ri@gmail.com
To: live-patching@vger.kernel.org,
	joe.lawrence@redhat.com,
	pmladek@suse.com,
	mbenes@suse.cz,
	jikos@kernel.org,
	jpoimboe@kernel.org
Cc: Roman Rashchupkin <raschupkin.ri@gmail.com>
Subject: [PATCH 2/2] selftests/livepatch: Add tests for kprefcount_t support
Date: Sun, 14 Jul 2024 21:59:34 +0200
Message-ID: <20240714195958.692313-3-raschupkin.ri@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240714195958.692313-1-raschupkin.ri@gmail.com>
References: <20240714195958.692313-1-raschupkin.ri@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Roman Rashchupkin <raschupkin.ri@gmail.com>

Signed-off-by: Roman Rashchupkin <raschupkin.ri@gmail.com>
---
 tools/testing/selftests/livepatch/Makefile    |   3 +-
 .../selftests/livepatch/test-kprefcount.sh    |  16 +++
 .../selftests/livepatch/test_modules/Makefile |   4 +-
 .../test_modules/test_klp_kprefcount.c        | 120 ++++++++++++++++++
 .../test_modules/test_klp_refcount.c          |  65 ++++++++++
 5 files changed, 206 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/livepatch/test-kprefcount.sh
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_kprefcount.c
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_refcount.c

diff --git a/tools/testing/selftests/livepatch/Makefile b/tools/testing/selftests/livepatch/Makefile
index 35418a4790be..48926ebc77f2 100644
--- a/tools/testing/selftests/livepatch/Makefile
+++ b/tools/testing/selftests/livepatch/Makefile
@@ -10,7 +10,8 @@ TEST_PROGS := \
 	test-state.sh \
 	test-ftrace.sh \
 	test-sysfs.sh \
-	test-syscall.sh
+	test-syscall.sh \
+	test-kprefcount.sh
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/livepatch/test-kprefcount.sh b/tools/testing/selftests/livepatch/test-kprefcount.sh
new file mode 100755
index 000000000000..8ea6c18f59dd
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test-kprefcount.sh
@@ -0,0 +1,16 @@
+#!/bin/sh
+insmod test_modules/test_klp_refcount.ko
+insmod test_modules/test_klp_kprefcount.ko
+livepatch_enabled=/sys/kernel/livepatch/test_klp_kprefcount/enabled
+while [ ! -e $livepatch_enabled -o $(cat $livepatch_enabled) -eq 0 ]; do
+	sleep 0.01;
+done
+echo 0 > $livepatch_enabled
+while [ $(cat $livepatch_enabled) -eq 1 ]; do
+	sleep 0.01;
+done
+while [ -e $livepatch_enabled ]; do
+	sleep 0.01;
+done
+rmmod test_klp_kprefcount
+rmmod test_klp_refcount
diff --git a/tools/testing/selftests/livepatch/test_modules/Makefile b/tools/testing/selftests/livepatch/test_modules/Makefile
index e6e638c4bcba..c26797372e0d 100644
--- a/tools/testing/selftests/livepatch/test_modules/Makefile
+++ b/tools/testing/selftests/livepatch/test_modules/Makefile
@@ -11,7 +11,9 @@ obj-m += test_klp_atomic_replace.o \
 	test_klp_state2.o \
 	test_klp_state3.o \
 	test_klp_shadow_vars.o \
-	test_klp_syscall.o
+	test_klp_syscall.o \
+	test_klp_refcount.o \
+	test_klp_kprefcount.o
 
 # Ensure that KDIR exists, otherwise skip the compilation
 modules:
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_kprefcount.c b/tools/testing/selftests/livepatch/test_modules/test_klp_kprefcount.c
new file mode 100644
index 000000000000..063f286ebcec
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_kprefcount.c
@@ -0,0 +1,120 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/livepatch.h>
+#include <linux/livepatch_refcount.h>
+
+extern refcount_t test_refcount;
+extern int TEST_LIVEPATCH_KPREFCOUNT;
+
+#define ITER 100
+#define NREF 10
+#define KP_NREF 10
+static struct ref_holder {
+	unsigned char v;
+} kp_ref_holders[KP_NREF] = { 0 };
+kprefcount_t *kp_test_ref = 0;
+
+static int livepatch_refcount_test_iter(void)
+{
+	int k, i;
+	for (k=0; k<ITER; k++) {
+		for (i=0; i<KP_NREF; i++)
+			refcount_inc(&test_refcount);
+		for (i=0; i<KP_NREF; i++)
+			if (kprefcount_dec_and_test(kp_test_ref, 0, 1)) {
+				pr_alert("livepatch refcount underflow\n");
+				return -1;
+			}
+	}
+	TEST_LIVEPATCH_KPREFCOUNT = 0;
+	return 0;
+}
+
+struct delayed_work kp_work_refcount;
+static void kp_test_refcount(struct work_struct *work)
+{
+	int i, k;
+	for (k=0; k<ITER; k++) {
+		for (i=0; i<KP_NREF; i++)
+			kprefcount_dec(kp_test_ref, &kp_ref_holders[i].v, 1);
+		// Intentional refcounter underflow for additional testing
+		for (i=0; i<KP_NREF-1; i++)
+			kprefcount_inc(kp_test_ref, &kp_ref_holders[i].v, 1);
+	}
+}
+
+static void kp_post_patch_callback(struct klp_object *klp_obj)
+{
+	schedule_delayed_work(&kp_work_refcount, 0);
+}
+
+static void kp_pre_unpatch_callback(struct klp_object *klp_obj)
+{
+	cancel_delayed_work_sync(&kp_work_refcount);
+}
+
+static struct klp_func funcs[] = {
+	{
+		.old_name = "refcount_test_iter",
+		.new_func = livepatch_refcount_test_iter,
+	}, { }
+};
+
+static struct klp_object objs[] = {
+	{
+		.name = "test_klp_refcount",
+		.funcs = funcs,
+		.callbacks = {
+			.post_patch = kp_post_patch_callback,
+			.pre_unpatch = kp_pre_unpatch_callback,
+		},
+	}, { }
+};
+
+static struct klp_patch patch = {
+	.mod = THIS_MODULE,
+	.objs = objs,
+};
+
+struct delayed_work work_refcount;
+
+static void do_test_refcount(struct work_struct *work)
+{
+	int i;
+	for (i=0; i<NREF; i++) {
+		if (refcount_read(&test_refcount) <= 1)
+			pr_info("LIVEPATCH refcount test done.\n");
+			return;
+		refcount_dec(&test_refcount);
+		if (refcount_read(&test_refcount) < 0)
+			pr_alert("post-livepatch refcount underflow\n");
+	}
+	for (i=0; i<NREF; i++)
+		refcount_inc(&test_refcount);
+}
+
+static int refcount_test_init(void)
+{
+	int ret;
+	kp_test_ref = kprefcount_alloc(&test_refcount, GFP_KERNEL);
+	if (!kp_test_ref) {
+		pr_alert("kprefcount_livepatch: memory allocation_failed");
+		return -1;
+	}
+	ret = klp_enable_patch(&patch);
+	INIT_DELAYED_WORK(&kp_work_refcount, kp_test_refcount);
+	return 0;
+}
+
+static void refcount_test_exit(void)
+{
+}
+
+module_init(refcount_test_init);
+module_exit(refcount_test_exit);
+MODULE_INFO(livepatch, "Y");
+MODULE_AUTHOR("Roman Rashchupkin <raschupkin.ri@gmail.com>");
+MODULE_DESCRIPTION("Livepatch test: kprefcount");
+MODULE_LICENSE("GPL");
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_refcount.c b/tools/testing/selftests/livepatch/test_modules/test_klp_refcount.c
new file mode 100644
index 000000000000..bd9c57e63476
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_refcount.c
@@ -0,0 +1,65 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/livepatch.h>
+#include <linux/livepatch_refcount.h>
+
+#define ITER 100
+#define NREF 10
+int TEST_LIVEPATCH_KPREFCOUNT = 1;
+EXPORT_SYMBOL(TEST_LIVEPATCH_KPREFCOUNT);
+refcount_t test_refcount = REFCOUNT_INIT(1);
+EXPORT_SYMBOL(test_refcount);
+
+int refcount_test_iter(void)
+{
+	int i;
+	for (i=0; i<NREF; i++)
+		refcount_inc(&test_refcount);
+	for (i=0; i<NREF; i++)
+		if (refcount_dec_and_test(&test_refcount))
+			return -1;
+	return 0;
+}
+
+int refcount_test(void)
+{
+	int i;
+	for (i=0; i<ITER; i++) {
+		if (refcount_test_iter())
+			return -1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(refcount_test);
+
+struct delayed_work kp_test_work;
+void start_refcount_test(struct work_struct *work)
+{
+	if (!TEST_LIVEPATCH_KPREFCOUNT)
+		return;
+	if (refcount_test()) {
+		pr_alert(KERN_ERR "refcount_test: error.\n");
+		return;
+	}
+	schedule_delayed_work(&kp_test_work, msecs_to_jiffies(50));
+}
+
+static int refcount_test_init(void)
+{
+	INIT_DELAYED_WORK(&kp_test_work, start_refcount_test);
+	schedule_delayed_work(&kp_test_work, msecs_to_jiffies(50));
+	return 0;
+}
+
+static void refcount_test_exit(void)
+{
+	cancel_delayed_work_sync(&kp_test_work);
+}
+
+module_init(refcount_test_init);
+module_exit(refcount_test_exit);
+MODULE_AUTHOR("Roman Rashchupkin <raschupkin.ri@gmail.com>");
+MODULE_DESCRIPTION("Livepatch test: refcount");
+MODULE_LICENSE("GPL");
-- 
2.43.0


