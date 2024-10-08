Return-Path: <live-patching+bounces-725-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8509C994194
	for <lists+live-patching@lfdr.de>; Tue,  8 Oct 2024 10:27:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B89A280CF2
	for <lists+live-patching@lfdr.de>; Tue,  8 Oct 2024 08:27:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BF571E32BA;
	Tue,  8 Oct 2024 07:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="akMgeOCG"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5AF1E0DC8;
	Tue,  8 Oct 2024 07:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728373944; cv=none; b=ZLPsZkE1J8MOWnpIVZwv4fmc/Z8bQBzkyInGZg7qqV0LKK5F8mDqYjhdfMHpVkOjjVa4lm6ReLSk2UqxWph6bQtCrcIjUipoHBsU5hhyt+Dh2Q4eaI8fyh/xglmL5X9rdJp4mPv/iXG3TJyq1FDrDuXCroLxc3O5yEp0RlnGD08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728373944; c=relaxed/simple;
	bh=E5/Tv6HjmWYUa0Fe3qdacgKyA78b/Z9v9zA8sb7xqCc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=D1W/xbxrdiHvTV4VMPuUH9XxtYhxSLAxrHEtakkhliL/B8mTflPXJg3eXRzjDClq8r/VoErA2Ct8NlVdzhsKs7AGwW6IyUYTLMJanNEW/gatBp1h7abzA9gJrZrvAueyD1bpuyUqGzcEzMwOhNpm+zyZpOaeRnTdSJUvPws7mtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=akMgeOCG; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20b6c311f62so46376205ad.0;
        Tue, 08 Oct 2024 00:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728373942; x=1728978742; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fT+4orNZSJ95ptt3DjOUEUl5oE3zkfTpES9svRxwpnc=;
        b=akMgeOCGDUY43MuhJiRN+A82+FWr4wCl36sLfTD0/wUbFiYsPuOTlu2ZVgiIvWQo71
         AB5tnWpADy1dL5OcwZJzVpPm1BeRZlXjBr2gWyQ+I1iyOxUib+zDzM1ggVJi6QBuPfxf
         +Px174gm6jS8wRszjWL3HjZOGUlRzV7yn8LzRiEK13AavLG6RnrtkXMi1Z5AYhYUlvfa
         0261hTKJdAK+HbiHHcA7CH84BMBVSNIBtFLMGTLDj3NSj0SZEojjiu6+TYwAwUoSmaTm
         LtdstlZblskG2PYX+jejeKOjpd0nCivjYakjEeUrYZtPfuELJT0YuRAoJt/cBh16UCJe
         Ew/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728373942; x=1728978742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fT+4orNZSJ95ptt3DjOUEUl5oE3zkfTpES9svRxwpnc=;
        b=BlLz0FoOqVhNJkWDdlm6+X9RqWT9T/Tz7tgxjYJ6L/BcpGbgErb3ygS5oz4a8AcGLR
         f4d5MZSqJwWS3XZZ035yMTSjMhrotIJNXsUP6aPqzoKZoBpQnJwQZn4F3uDE+JmtcZuX
         lMTsSunKwMseVemD/DVLkDziRIRv14ieMmXmeCIEaZIvmuNOty/rldCmxSm9Ku7m55ZJ
         rvCPO9gMR/+0N9dNmjdTZ8lqCxZnJGECS97g7lD5qIFRni03r2nZIkpC87S5Zy+ziYTq
         6kNSuED1P4tNuTt9qs8OOLlvYl1Pt9YvX1dGMGDO5BfiLA6STCQsJrJm1mrzfHP2u2Uw
         uBxA==
X-Forwarded-Encrypted: i=1; AJvYcCUuGWR8SeN/oXxFdQJBH8D2wCuXoxERKJIcqDUeId4NIEhcoVovWEbB8YjsgwHK1EiXU/0DLtacLQhr+/w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1t63t7e5kq+d1lu5veSPl8QiW+2PWVXES1L+NnpWYu7TmOE0z
	TL86RXgGsf7eX62sq1fhE3ZFJSiKM/xcKcJyShU5og/76t5Ac3VkLTcY127p0jA=
X-Google-Smtp-Source: AGHT+IF/qZVJo6kkSQtl175gT5LYezVSfU12M2aDJISSKacx7kXs7WHGCLNa5N9AljwDW+4blpq64Q==
X-Received: by 2002:a17:903:8c6:b0:20b:54cc:b339 with SMTP id d9443c01a7336-20bfe07bb9emr177849225ad.17.1728373941964;
        Tue, 08 Oct 2024 00:52:21 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.123])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c138afd1dsm50497195ad.36.2024.10.08.00.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2024 00:52:21 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH 1/1] selftests: livepatch: add test cases of stack_order sysfs interface
Date: Tue,  8 Oct 2024 15:52:03 +0800
Message-Id: <20241008075203.36235-2-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20241008075203.36235-1-zhangwarden@gmail.com>
References: <20241008075203.36235-1-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add selftest test cases to sysfs attribute 'stack_order'.

Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
---
 .../testing/selftests/livepatch/test-sysfs.sh | 71 +++++++++++++++++++
 .../selftests/livepatch/test_modules/Makefile |  5 +-
 .../test_klp_livepatch_noreplace.c            | 53 ++++++++++++++
 .../test_klp_livepatch_noreplace2.c           | 53 ++++++++++++++
 .../test_klp_livepatch_noreplace3.c           | 53 ++++++++++++++
 5 files changed, 234 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_noreplace.c
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_noreplace2.c
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_noreplace3.c

diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index 05a14f5a7bfb..a086b62fb488 100755
--- a/tools/testing/selftests/livepatch/test-sysfs.sh
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -5,6 +5,9 @@
 . $(dirname $0)/functions.sh
 
 MOD_LIVEPATCH=test_klp_livepatch
+MOD_LIVEPATCH_NOREPLACE=test_klp_livepatch_noreplace
+MOD_LIVEPATCH_NOREPLACE2=test_klp_livepatch_noreplace2
+MOD_LIVEPATCH_NOREPLACE3=test_klp_livepatch_noreplace3
 
 setup_config
 
@@ -131,4 +134,72 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 
+start_test "sysfs test stack_order read"
+
+load_lp $MOD_LIVEPATCH_NOREPLACE
+
+check_sysfs_rights "$MOD_LIVEPATCH_NOREPLACE" "stack_order" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH_NOREPLACE" "stack_order" "1"
+
+load_lp $MOD_LIVEPATCH_NOREPLACE2
+
+check_sysfs_rights "$MOD_LIVEPATCH_NOREPLACE2" "stack_order" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH_NOREPLACE2" "stack_order" "2"
+
+load_lp $MOD_LIVEPATCH_NOREPLACE3
+
+check_sysfs_rights "$MOD_LIVEPATCH_NOREPLACE3" "stack_order" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH_NOREPLACE3" "stack_order" "3"
+
+disable_lp $MOD_LIVEPATCH_NOREPLACE2
+unload_lp $MOD_LIVEPATCH_NOREPLACE2
+
+check_sysfs_rights "$MOD_LIVEPATCH_NOREPLACE" "stack_order" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH_NOREPLACE" "stack_order" "1"
+check_sysfs_rights "$MOD_LIVEPATCH_NOREPLACE3" "stack_order" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH_NOREPLACE3" "stack_order" "2"
+
+disable_lp $MOD_LIVEPATCH_NOREPLACE3
+unload_lp $MOD_LIVEPATCH_NOREPLACE3
+
+disable_lp $MOD_LIVEPATCH_NOREPLACE
+unload_lp $MOD_LIVEPATCH_NOREPLACE
+
+check_result "% insmod test_modules/$MOD_LIVEPATCH_NOREPLACE.ko
+livepatch: enabling patch '$MOD_LIVEPATCH_NOREPLACE'
+livepatch: '$MOD_LIVEPATCH_NOREPLACE': initializing patching transition
+livepatch: '$MOD_LIVEPATCH_NOREPLACE': starting patching transition
+livepatch: '$MOD_LIVEPATCH_NOREPLACE': completing patching transition
+livepatch: '$MOD_LIVEPATCH_NOREPLACE': patching complete
+% insmod test_modules/$MOD_LIVEPATCH_NOREPLACE2.ko
+livepatch: enabling patch '$MOD_LIVEPATCH_NOREPLACE2'
+livepatch: '$MOD_LIVEPATCH_NOREPLACE2': initializing patching transition
+livepatch: '$MOD_LIVEPATCH_NOREPLACE2': starting patching transition
+livepatch: '$MOD_LIVEPATCH_NOREPLACE2': completing patching transition
+livepatch: '$MOD_LIVEPATCH_NOREPLACE2': patching complete
+% insmod test_modules/$MOD_LIVEPATCH_NOREPLACE3.ko
+livepatch: enabling patch '$MOD_LIVEPATCH_NOREPLACE3'
+livepatch: '$MOD_LIVEPATCH_NOREPLACE3': initializing patching transition
+livepatch: '$MOD_LIVEPATCH_NOREPLACE3': starting patching transition
+livepatch: '$MOD_LIVEPATCH_NOREPLACE3': completing patching transition
+livepatch: '$MOD_LIVEPATCH_NOREPLACE3': patching complete
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH_NOREPLACE2/enabled
+livepatch: '$MOD_LIVEPATCH_NOREPLACE2': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH_NOREPLACE2': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH_NOREPLACE2': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH_NOREPLACE2': unpatching complete
+% rmmod $MOD_LIVEPATCH_NOREPLACE2
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH_NOREPLACE3/enabled
+livepatch: '$MOD_LIVEPATCH_NOREPLACE3': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH_NOREPLACE3': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH_NOREPLACE3': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH_NOREPLACE3': unpatching complete
+% rmmod $MOD_LIVEPATCH_NOREPLACE3
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH_NOREPLACE/enabled
+livepatch: '$MOD_LIVEPATCH_NOREPLACE': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH_NOREPLACE': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH_NOREPLACE': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH_NOREPLACE': unpatching complete
+% rmmod $MOD_LIVEPATCH_NOREPLACE"
+
 exit 0
diff --git a/tools/testing/selftests/livepatch/test_modules/Makefile b/tools/testing/selftests/livepatch/test_modules/Makefile
index e6e638c4bcba..dad6ca00d3e6 100644
--- a/tools/testing/selftests/livepatch/test_modules/Makefile
+++ b/tools/testing/selftests/livepatch/test_modules/Makefile
@@ -11,7 +11,10 @@ obj-m += test_klp_atomic_replace.o \
 	test_klp_state2.o \
 	test_klp_state3.o \
 	test_klp_shadow_vars.o \
-	test_klp_syscall.o
+	test_klp_syscall.o \
+	test_klp_livepatch_noreplace.o \
+	test_klp_livepatch_noreplace2.o \
+	test_klp_livepatch_noreplace3.o \
 
 # Ensure that KDIR exists, otherwise skip the compilation
 modules:
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_noreplace.c b/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_noreplace.c
new file mode 100644
index 000000000000..ead609aeac67
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_noreplace.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+
+#include <linux/seq_file.h>
+static int livepatch_cmdline_proc_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%s: %s\n", THIS_MODULE->name,
+		   "this has been live patched with number 1");
+	return 0;
+}
+
+static struct klp_func funcs[] = {
+	{
+		.old_name = "cmdline_proc_show",
+		.new_func = livepatch_cmdline_proc_show,
+	}, { }
+};
+
+static struct klp_object objs[] = {
+	{
+		/* name being NULL means vmlinux */
+		.funcs = funcs,
+	}, { }
+};
+
+static struct klp_patch patch = {
+	.mod = THIS_MODULE,
+	.objs = objs,
+	.replace = false,
+};
+
+static int test_klp_livepatch_init(void)
+{
+	return klp_enable_patch(&patch);
+}
+
+static void test_klp_livepatch_exit(void)
+{
+}
+
+module_init(test_klp_livepatch_init);
+module_exit(test_klp_livepatch_exit);
+MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
+MODULE_AUTHOR("Seth Jennings <sjenning@redhat.com>");
+MODULE_AUTHOR("Wardenjohn <zhangwarden@gmail.com>");
+MODULE_DESCRIPTION("Livepatch test: livepatch module");
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_noreplace2.c b/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_noreplace2.c
new file mode 100644
index 000000000000..8d54b0976be1
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_noreplace2.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+
+#include <linux/seq_file.h>
+static int livepatch_cmdline_proc_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%s: %s\n", THIS_MODULE->name,
+		   "this has been live patched with number 2");
+	return 0;
+}
+
+static struct klp_func funcs[] = {
+	{
+		.old_name = "cmdline_proc_show",
+		.new_func = livepatch_cmdline_proc_show,
+	}, { }
+};
+
+static struct klp_object objs[] = {
+	{
+		/* name being NULL means vmlinux */
+		.funcs = funcs,
+	}, { }
+};
+
+static struct klp_patch patch = {
+	.mod = THIS_MODULE,
+	.objs = objs,
+	.replace = false,
+};
+
+static int test_klp_livepatch_init(void)
+{
+	return klp_enable_patch(&patch);
+}
+
+static void test_klp_livepatch_exit(void)
+{
+}
+
+module_init(test_klp_livepatch_init);
+module_exit(test_klp_livepatch_exit);
+MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
+MODULE_AUTHOR("Seth Jennings <sjenning@redhat.com>");
+MODULE_AUTHOR("Wardenjohn <zhangwarden@gmail.com>");
+MODULE_DESCRIPTION("Livepatch test: livepatch module");
diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_noreplace3.c b/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_noreplace3.c
new file mode 100644
index 000000000000..a267c58e07d4
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_noreplace3.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+
+#include <linux/seq_file.h>
+static int livepatch_cmdline_proc_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%s: %s\n", THIS_MODULE->name,
+		   "this has been live patched with number 3");
+	return 0;
+}
+
+static struct klp_func funcs[] = {
+	{
+		.old_name = "cmdline_proc_show",
+		.new_func = livepatch_cmdline_proc_show,
+	}, { }
+};
+
+static struct klp_object objs[] = {
+	{
+		/* name being NULL means vmlinux */
+		.funcs = funcs,
+	}, { }
+};
+
+static struct klp_patch patch = {
+	.mod = THIS_MODULE,
+	.objs = objs,
+	.replace = false,
+};
+
+static int test_klp_livepatch_init(void)
+{
+	return klp_enable_patch(&patch);
+}
+
+static void test_klp_livepatch_exit(void)
+{
+}
+
+module_init(test_klp_livepatch_init);
+module_exit(test_klp_livepatch_exit);
+MODULE_LICENSE("GPL");
+MODULE_INFO(livepatch, "Y");
+MODULE_AUTHOR("Seth Jennings <sjenning@redhat.com>");
+MODULE_AUTHOR("Wardenjohn <zhangwarden@gmail.com>");
+MODULE_DESCRIPTION("Livepatch test: livepatch module");
-- 
2.43.5


