Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72ED7664111
	for <lists+live-patching@lfdr.de>; Tue, 10 Jan 2023 14:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbjAJNBn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 Jan 2023 08:01:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbjAJNBl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 Jan 2023 08:01:41 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F3543A02;
        Tue, 10 Jan 2023 05:01:39 -0800 (PST)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NrrRh3gWzzqTsX;
        Tue, 10 Jan 2023 20:56:48 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 10 Jan 2023 21:01:33 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, <bpf@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        <linux-modules@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v3] kallsyms: Remove the performance test from kallsyms_selftest.c
Date:   Tue, 10 Jan 2023 21:01:21 +0800
Message-ID: <20230110130121.1279-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.37.3.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

[T58] BUG: sleeping function called from invalid context at kernel/kallsyms.c:305
[T58] in_atomic(): 0, irqs_disabled(): 128, non_block: 0, pid: 58, name: kallsyms_test
[T58] preempt_count: 0, expected: 0
[T58] RCU nest depth: 0, expected: 0
[T58] no locks held by kallsyms_test/58.
[T58] irq event stamp: 18899904
[T58] hardirqs last enabled at (18899903): finish_task_switch.isra.0 (core.c:?)
[T58] hardirqs last disabled at (18899904): test_perf_kallsyms_on_each_symbol (kallsyms_selftest.c:?)
[T58] softirqs last enabled at (18899886): __do_softirq (??:?)
[T58] softirqs last disabled at (18899879): ____do_softirq (irq.c:?)
[T58] CPU: 0 PID: 58 Comm: kallsyms_test Tainted: G T  6.1.0-next-20221215 #2
[T58] Hardware name: linux,dummy-virt (DT)
[T58] Call trace:
[T58] dump_backtrace (??:?)
[T58] show_stack (??:?)
[T58] dump_stack_lvl (??:?)
[T58] dump_stack (??:?)
[T58] __might_resched (??:?)
[T58] kallsyms_on_each_symbol (??:?)
[T58] test_perf_kallsyms_on_each_symbol (kallsyms_selftest.c:?)
[T58] test_entry (kallsyms_selftest.c:?)
[T58] kthread (kthread.c:?)
[T58] ret_from_fork (??:?)
[T58] kallsyms_selftest: kallsyms_on_each_symbol() traverse all: 5744310840 ns
[T58] kallsyms_selftest: kallsyms_on_each_match_symbol() traverse all: 1164580 ns
[T58] kallsyms_selftest: finish

Functions kallsyms_on_each_symbol() and kallsyms_on_each_match_symbol()
call the user-registered hook function for each symbol that meets the
requirements. Because it is uncertain how long that hook function will
execute, they call cond_resched() to avoid consuming CPU resources for a
long time. Therefore, they cannot be called with irqs disabled.

Given that people don't care about the performance of kallsyms, let's
simply remove it.

Fixes: 30f3bb09778d ("kallsyms: Add self-test facility")
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Suggested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/kallsyms_selftest.c | 88 +-------------------------------------
 1 file changed, 1 insertion(+), 87 deletions(-)

v1 --> v2:
1. Keep calling cond_resched() when CONFIG_KALLSYMS_SELFTEST=y. Instead,
   function kallsyms_on_each_match_symbol() and kallsyms_on_each_symbol()
   are not protected by local_irq_save() in kallsyms_selftest.c.

v2 --> v3:
1. Remove the performance test functions.

[v2] https://lkml.org/lkml/2022/12/27/762

diff --git a/kernel/kallsyms_selftest.c b/kernel/kallsyms_selftest.c
index f35d9cc1aab1544..79c42d80b8f69a1 100644
--- a/kernel/kallsyms_selftest.c
+++ b/kernel/kallsyms_selftest.c
@@ -12,9 +12,9 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
+#include <linux/kthread.h>
 #include <linux/random.h>
 #include <linux/sched/clock.h>
-#include <linux/kthread.h>
 #include <linux/vmalloc.h>
 
 #include "kallsyms_internal.h"
@@ -93,7 +93,6 @@ static struct test_item test_items[] = {
 #endif
 };
 
-static char stub_name[KSYM_NAME_LEN];
 
 static int stat_symbol_len(void *data, const char *name, struct module *mod, unsigned long addr)
 {
@@ -109,16 +108,6 @@ static void test_kallsyms_compression_ratio(void)
 
 	kallsyms_on_each_symbol(stat_symbol_len, &total_len);
 
-	/*
-	 * A symbol name cannot start with a number. This stub name helps us
-	 * traverse the entire symbol table without finding a match. It's used
-	 * for subsequent performance tests, and its length is the average
-	 * length of all symbol names.
-	 */
-	memset(stub_name, '4', sizeof(stub_name));
-	pos = total_len / kallsyms_num_syms;
-	stub_name[pos] = 0;
-
 	pos = 0;
 	num = 0;
 	off = 0;
@@ -154,43 +143,6 @@ static void test_kallsyms_compression_ratio(void)
 	pr_info(" ---------------------------------------------------------\n");
 }
 
-static int lookup_name(void *data, const char *name, struct module *mod, unsigned long addr)
-{
-	u64 t0, t1, t;
-	unsigned long flags;
-	struct test_stat *stat = (struct test_stat *)data;
-
-	local_irq_save(flags);
-	t0 = sched_clock();
-	(void)kallsyms_lookup_name(name);
-	t1 = sched_clock();
-	local_irq_restore(flags);
-
-	t = t1 - t0;
-	if (t < stat->min)
-		stat->min = t;
-
-	if (t > stat->max)
-		stat->max = t;
-
-	stat->real_cnt++;
-	stat->sum += t;
-
-	return 0;
-}
-
-static void test_perf_kallsyms_lookup_name(void)
-{
-	struct test_stat stat;
-
-	memset(&stat, 0, sizeof(stat));
-	stat.min = INT_MAX;
-	kallsyms_on_each_symbol(lookup_name, &stat);
-	pr_info("kallsyms_lookup_name() looked up %d symbols\n", stat.real_cnt);
-	pr_info("The time spent on each symbol is (ns): min=%d, max=%d, avg=%lld\n",
-		stat.min, stat.max, div_u64(stat.sum, stat.real_cnt));
-}
-
 static bool match_cleanup_name(const char *s, const char *name)
 {
 	char *p;
@@ -231,24 +183,6 @@ static int find_symbol(void *data, const char *name, struct module *mod, unsigne
 	return 0;
 }
 
-static void test_perf_kallsyms_on_each_symbol(void)
-{
-	u64 t0, t1;
-	unsigned long flags;
-	struct test_stat stat;
-
-	memset(&stat, 0, sizeof(stat));
-	stat.max = INT_MAX;
-	stat.name = stub_name;
-	stat.perf = 1;
-	local_irq_save(flags);
-	t0 = sched_clock();
-	kallsyms_on_each_symbol(find_symbol, &stat);
-	t1 = sched_clock();
-	local_irq_restore(flags);
-	pr_info("kallsyms_on_each_symbol() traverse all: %lld ns\n", t1 - t0);
-}
-
 static int match_symbol(void *data, unsigned long addr)
 {
 	struct test_stat *stat = (struct test_stat *)data;
@@ -267,23 +201,6 @@ static int match_symbol(void *data, unsigned long addr)
 	return 0;
 }
 
-static void test_perf_kallsyms_on_each_match_symbol(void)
-{
-	u64 t0, t1;
-	unsigned long flags;
-	struct test_stat stat;
-
-	memset(&stat, 0, sizeof(stat));
-	stat.max = INT_MAX;
-	stat.name = stub_name;
-	local_irq_save(flags);
-	t0 = sched_clock();
-	kallsyms_on_each_match_symbol(match_symbol, stat.name, &stat);
-	t1 = sched_clock();
-	local_irq_restore(flags);
-	pr_info("kallsyms_on_each_match_symbol() traverse all: %lld ns\n", t1 - t0);
-}
-
 static int test_kallsyms_basic_function(void)
 {
 	int i, j, ret;
@@ -460,9 +377,6 @@ static int test_entry(void *p)
 	}
 
 	test_kallsyms_compression_ratio();
-	test_perf_kallsyms_lookup_name();
-	test_perf_kallsyms_on_each_symbol();
-	test_perf_kallsyms_on_each_match_symbol();
 	pr_info("finish\n");
 
 	return 0;
-- 
2.25.1

