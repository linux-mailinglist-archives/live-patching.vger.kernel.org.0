Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DCB5B3895
	for <lists+live-patching@lfdr.de>; Fri,  9 Sep 2022 15:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiIIND1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Sep 2022 09:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiIINDV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Sep 2022 09:03:21 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212E0B8F1E;
        Fri,  9 Sep 2022 06:03:20 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MPGKV3mW2zlVqb;
        Fri,  9 Sep 2022 20:59:26 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 9 Sep 2022 21:03:18 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 9 Sep 2022 21:03:17 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Luis Chamberlain" <mcgrof@kernel.org>,
        <linux-modules@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v2 8/8] kallsyms: Add self-test facility
Date:   Fri, 9 Sep 2022 21:00:16 +0800
Message-ID: <20220909130016.727-9-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20220909130016.727-1-thunder.leizhen@huawei.com>
References: <20220909130016.727-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Add some test cases to test the function and performance of some kallsyms
interfaces, such as kallsyms_lookup_name. It also calculates the
compression rate of the kallsyms compression algorithm for the current
symbol set.

Start self-test automatically after system startup.

Example of output content: (prefix 'kallsyms_selftest:' is omitted)
start
There are 174101 symbols in total:
 --------------------------------------------------------------
|           |  compressed size  |  original size  |  ratio(%)  |
|--------------------------------------------------------------|
|  no  '\0' |        1785569    |       3750649   |   47.60    |
| with '\0' |        1959670    |       3924750   |   49.93    |
 --------------------------------------------------------------

kallsyms_lookup_name() looked up 174101 symbols
The time spent on each symbol is (ns): min=5350, max=985150, avg=295517
kallsyms_on_each_symbol() lookup vmap: 15806120 ns
kallsyms_on_each_symbol() traverse vmap: 15817140 ns
kallsyms_on_each_match_symbol() lookup vmap: 32840 ns
kallsyms_on_each_match_symbol() traverse vmap: 567370 ns

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 init/Kconfig               |  13 ++
 kernel/Makefile            |   1 +
 kernel/kallsyms_selftest.c | 243 +++++++++++++++++++++++++++++++++++++
 3 files changed, 257 insertions(+)
 create mode 100644 kernel/kallsyms_selftest.c

diff --git a/init/Kconfig b/init/Kconfig
index 532362fcfe31fd3..2fcace3b9f063bf 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1716,6 +1716,19 @@ config KALLSYMS
 	  symbolic stack backtraces. This increases the size of the kernel
 	  somewhat, as all symbols have to be loaded into the kernel image.
 
+config KALLSYMS_SELFTEST
+	bool "Test the function and performance of some interfaces in kallsyms"
+	depends on KALLSYMS
+	default n
+	help
+	  Test the function and performance of some interfaces, such as
+	  kallsyms_lookup_name. It also calculates the compression rate of the
+	  kallsyms compression algorithm for the current symbol set.
+
+	  Start self-test automatically after system startup. Suggest executing
+	  "dmesg | grep kallsyms_selftest" to collect test results. "finish" is
+	  displayed in the last line, indicating that the test is complete.
+
 config KALLSYMS_ALL
 	bool "Include all symbols in kallsyms"
 	depends on DEBUG_KERNEL && KALLSYMS
diff --git a/kernel/Makefile b/kernel/Makefile
index 318789c728d3290..122a5fed457bd98 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -68,6 +68,7 @@ endif
 obj-$(CONFIG_UID16) += uid16.o
 obj-$(CONFIG_MODULE_SIG_FORMAT) += module_signature.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
+obj-$(CONFIG_KALLSYMS_SELFTEST) += kallsyms_selftest.o
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_CRASH_CORE) += crash_core.o
 obj-$(CONFIG_KEXEC_CORE) += kexec_core.o
diff --git a/kernel/kallsyms_selftest.c b/kernel/kallsyms_selftest.c
new file mode 100644
index 000000000000000..d89d6b2f5dd763e
--- /dev/null
+++ b/kernel/kallsyms_selftest.c
@@ -0,0 +1,243 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Test the function and performance of kallsyms
+ *
+ * Copyright (C) Huawei Technologies Co., Ltd., 2022
+ *
+ * Authors: Zhen Lei <thunder.leizhen@huawei.com> Huawei
+ */
+
+#define pr_fmt(fmt) "kallsyms_selftest: " fmt
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kallsyms.h>
+#include <linux/kthread.h>
+#include <linux/sched/clock.h>
+#include <linux/vmalloc.h>
+
+#include "kallsyms_internal.h"
+
+
+struct test_stat {
+	int min;
+	int max;
+	int cnt;
+	u64 sum;
+	unsigned long addr;
+};
+
+
+static int match_symbol(void *data, unsigned long addr)
+{
+	struct test_stat *stat = (struct test_stat *)data;
+
+	stat->cnt++;
+	stat->addr = addr;
+
+	if (stat->cnt == stat->max)
+		return 1;
+
+	return 0;
+}
+
+static void test_kallsyms_on_each_match_symbol(void)
+{
+	u64 t0, t1;
+	unsigned long flags;
+	struct test_stat stat;
+
+	stat.cnt = 0;
+	stat.max = 1;
+	stat.addr = 0;
+	local_irq_save(flags);
+	t0 = sched_clock();
+	kallsyms_on_each_match_symbol(match_symbol, "vmap", &stat);
+	t1 = sched_clock();
+	local_irq_restore(flags);
+	if (stat.addr != (unsigned long)vmap || stat.cnt != 1) {
+		pr_info("kallsyms_on_each_match_symbol() test failed\n");
+		return;
+	}
+	pr_info("kallsyms_on_each_match_symbol() lookup vmap: %lld ns\n", t1 - t0);
+
+	stat.cnt = 0;
+	stat.max = INT_MAX;
+	stat.addr = 0;
+	local_irq_save(flags);
+	t0 = sched_clock();
+	kallsyms_on_each_match_symbol(match_symbol, "vmap", &stat);
+	t1 = sched_clock();
+	local_irq_restore(flags);
+	if (stat.addr != (unsigned long)vmap || stat.cnt != 1) {
+		pr_info("kallsyms_on_each_match_symbol() test failed\n");
+		return;
+	}
+	pr_info("kallsyms_on_each_match_symbol() traverse vmap: %lld ns\n", t1 - t0);
+}
+
+static int find_symbol(void *data, const char *name,
+		       struct module *mod, unsigned long addr)
+{
+	struct test_stat *stat = (struct test_stat *)data;
+
+	if (strcmp(name, "vmap") == 0) {
+		stat->cnt++;
+		stat->addr = addr;
+	}
+
+	if (stat->cnt == stat->max)
+		return 1;
+
+	return 0;
+}
+
+static void test_kallsyms_on_each_symbol(void)
+{
+	u64 t0, t1;
+	unsigned long flags;
+	struct test_stat stat;
+
+	stat.cnt = 0;
+	stat.sum = 1;
+	stat.addr = 0;
+	local_irq_save(flags);
+	t0 = sched_clock();
+	kallsyms_on_each_symbol(find_symbol, &stat);
+	t1 = sched_clock();
+	local_irq_restore(flags);
+	if (stat.addr != (unsigned long)vmap || stat.cnt != 1) {
+		pr_info("kallsyms_on_each_symbol() test failed\n");
+		return;
+	}
+	pr_info("kallsyms_on_each_symbol() lookup vmap: %lld ns\n", t1 - t0);
+
+	stat.cnt = 0;
+	stat.max = INT_MAX;
+	stat.addr = 0;
+	local_irq_save(flags);
+	t0 = sched_clock();
+	kallsyms_on_each_symbol(find_symbol, &stat);
+	t1 = sched_clock();
+	local_irq_restore(flags);
+	if (stat.addr != (unsigned long)vmap || stat.cnt != 1) {
+		pr_info("kallsyms_on_each_symbol() test failed\n");
+		return;
+	}
+	pr_info("kallsyms_on_each_symbol() traverse vmap: %lld ns\n", t1 - t0);
+}
+
+static int lookup_name(void *data, const char *name, struct module *mod, unsigned long addr)
+{
+	u64 t0, t1, t;
+	unsigned long flags;
+	struct test_stat *stat = (struct test_stat *)data;
+
+	local_irq_save(flags);
+	t0 = sched_clock();
+	(void)kallsyms_lookup_name(name);
+	t1 = sched_clock();
+	local_irq_restore(flags);
+
+	t = t1 - t0;
+	if (t < stat->min)
+		stat->min = t;
+
+	if (t > stat->max)
+		stat->max = t;
+
+	stat->cnt++;
+	stat->sum += t;
+
+	return 0;
+}
+
+static void test_kallsyms_lookup_name(void)
+{
+	struct test_stat stat;
+
+	stat.min = INT_MAX;
+	stat.max = 0;
+	stat.cnt = 0;
+	stat.sum = 0;
+	kallsyms_on_each_symbol(lookup_name, &stat);
+	pr_info("kallsyms_lookup_name() looked up %d symbols\n", stat.cnt);
+	pr_info("The time spent on each symbol is (ns): min=%d, max=%d, avg=%lld\n",
+		stat.min, stat.max, stat.sum / stat.cnt);
+
+	stat.addr = kallsyms_lookup_name("vmap");
+	if (stat.addr != (unsigned long)vmap)
+		pr_info("kallsyms_lookup_name() test failed\n");
+}
+
+static int stat_symbol_len(void *data, const char *name,
+			   struct module *mod, unsigned long addr)
+{
+	*(u32 *)data += strlen(name);
+
+	return 0;
+}
+
+static void test_kallsyms_compression_ratio(void)
+{
+	int i;
+	const u8 *name;
+	u32 pos;
+	u32 ratio, total_size, total_len = 0;
+
+	kallsyms_on_each_symbol(stat_symbol_len, &total_len);
+
+	pos = kallsyms_num_syms - 1;
+	name = &kallsyms_names[kallsyms_markers[pos >> 8]];
+	for (i = 0; i <= (pos & 0xff); i++)
+		name = name + (*name) + 1;
+
+	/* The length and string terminator are not counted */
+	total_size = (name - kallsyms_names) - (kallsyms_num_syms * 2);
+	pr_info("There are %d symbols in total:\n", kallsyms_num_syms);
+	pr_info(" --------------------------------------------------------------\n");
+	pr_info("|           |  compressed size  |  original size  |  ratio(%%)  |\n");
+	pr_info("|--------------------------------------------------------------|\n");
+	ratio = 10000ULL * total_size / total_len;
+	pr_info("|  no  '\\0' |     %10d    |    %10d   |   %2d.%-2d    |\n",
+			total_size, total_len, ratio / 100, ratio % 100);
+	total_size += kallsyms_num_syms;
+	total_len  += kallsyms_num_syms;
+	ratio = 10000ULL * total_size / total_len;
+	pr_info("| with '\\0' |     %10d    |    %10d   |   %2d.%-2d    |\n",
+			total_size, total_len, ratio / 100, ratio % 100);
+	pr_info(" --------------------------------------------------------------\n");
+	pr_info("\n");
+}
+
+static int test_entry(void *p)
+{
+	do {
+		schedule_timeout(5 * HZ);
+	} while (system_state != SYSTEM_RUNNING);
+
+	pr_info("start\n");
+	test_kallsyms_compression_ratio();
+	test_kallsyms_lookup_name();
+	test_kallsyms_on_each_symbol();
+	test_kallsyms_on_each_match_symbol();
+	pr_info("finish\n");
+
+	return 0;
+}
+
+static int __init kallsyms_test_init(void)
+{
+	struct task_struct *t;
+
+	t = kthread_create(test_entry, NULL, "kallsyms_test");
+	if (IS_ERR(t)) {
+		pr_info("Create kallsyms selftest task failed\n");
+		return PTR_ERR(t);
+	}
+	kthread_bind(t, 0);
+	wake_up_process(t);
+
+	return 0;
+}
+late_initcall(kallsyms_test_init);
-- 
2.25.1

