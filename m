Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBD16597A1
	for <lists+live-patching@lfdr.de>; Fri, 30 Dec 2022 12:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbiL3L3K (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 30 Dec 2022 06:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbiL3L2x (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 30 Dec 2022 06:28:53 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D01A140C0;
        Fri, 30 Dec 2022 03:28:52 -0800 (PST)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Nk2w02KdgzqTHX;
        Fri, 30 Dec 2022 19:24:16 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 30 Dec 2022 19:28:49 +0800
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
Subject: [PATCH 3/3] kallsyms: Delete an unused parameter related to {module_}kallsyms_on_each_symbol()
Date:   Fri, 30 Dec 2022 19:27:29 +0800
Message-ID: <20221230112729.351-4-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.37.3.windows.1
In-Reply-To: <20221230112729.351-1-thunder.leizhen@huawei.com>
References: <20221230112729.351-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The parameter 'struct module *' in the hook function associated with
{module_}kallsyms_on_each_symbol() is no longer used. Delete it.

Suggested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 include/linux/kallsyms.h   | 3 +--
 include/linux/module.h     | 6 ++----
 kernel/kallsyms.c          | 5 ++---
 kernel/kallsyms_selftest.c | 6 +++---
 kernel/livepatch/core.c    | 3 +--
 kernel/module/kallsyms.c   | 5 ++---
 kernel/trace/ftrace.c      | 3 +--
 7 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 0065209cc00424b..d4079b3d951d1ef 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -67,8 +67,7 @@ static inline void *dereference_symbol_descriptor(void *ptr)
 
 #ifdef CONFIG_KALLSYMS
 unsigned long kallsyms_sym_address(int idx);
-int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
-				      unsigned long),
+int kallsyms_on_each_symbol(int (*fn)(void *, const char *, unsigned long),
 			    void *data);
 int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long),
 				  const char *name, void *data);
diff --git a/include/linux/module.h b/include/linux/module.h
index 514bc81568c5220..39f928e9d9fed7e 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -880,13 +880,11 @@ static inline bool module_sig_ok(struct module *module)
 
 #if defined(CONFIG_MODULES) && defined(CONFIG_KALLSYMS)
 int module_kallsyms_on_each_symbol(const char *modname,
-				   int (*fn)(void *, const char *,
-					     struct module *, unsigned long),
+				   int (*fn)(void *, const char *, unsigned long),
 				   void *data);
 #else
 static inline int module_kallsyms_on_each_symbol(const char *modname,
-						 int (*fn)(void *, const char *,
-						 struct module *, unsigned long),
+						 int (*fn)(void *, const char *, unsigned long),
 						 void *data)
 {
 	return -EOPNOTSUPP;
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 83f499182c9aa31..77747391f49b66c 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -288,8 +288,7 @@ unsigned long kallsyms_lookup_name(const char *name)
  * Iterate over all symbols in vmlinux.  For symbols from modules use
  * module_kallsyms_on_each_symbol instead.
  */
-int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
-				      unsigned long),
+int kallsyms_on_each_symbol(int (*fn)(void *, const char *, unsigned long),
 			    void *data)
 {
 	char namebuf[KSYM_NAME_LEN];
@@ -299,7 +298,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 
 	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
 		off = kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
-		ret = fn(data, namebuf, NULL, kallsyms_sym_address(i));
+		ret = fn(data, namebuf, kallsyms_sym_address(i));
 		if (ret != 0)
 			return ret;
 		cond_resched();
diff --git a/kernel/kallsyms_selftest.c b/kernel/kallsyms_selftest.c
index 9c94f06aa951971..1b6891a0a79052b 100644
--- a/kernel/kallsyms_selftest.c
+++ b/kernel/kallsyms_selftest.c
@@ -97,7 +97,7 @@ static struct test_item test_items[] = {
 
 static char stub_name[KSYM_NAME_LEN];
 
-static int stat_symbol_len(void *data, const char *name, struct module *mod, unsigned long addr)
+static int stat_symbol_len(void *data, const char *name, unsigned long addr)
 {
 	*(u32 *)data += strlen(name);
 
@@ -156,7 +156,7 @@ static void test_kallsyms_compression_ratio(void)
 	pr_info(" ---------------------------------------------------------\n");
 }
 
-static int lookup_name(void *data, const char *name, struct module *mod, unsigned long addr)
+static int lookup_name(void *data, const char *name, unsigned long addr)
 {
 	u64 t0, t1, t;
 	unsigned long flags;
@@ -212,7 +212,7 @@ static bool match_cleanup_name(const char *s, const char *name)
 	return !strncmp(s, name, len);
 }
 
-static int find_symbol(void *data, const char *name, struct module *mod, unsigned long addr)
+static int find_symbol(void *data, const char *name, unsigned long addr)
 {
 	struct test_stat *stat = (struct test_stat *)data;
 
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index c973ed9e42f8177..bdb40a4b1f29845 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -142,8 +142,7 @@ static int klp_match_callback(void *data, unsigned long addr)
 	return 0;
 }
 
-static int klp_find_callback(void *data, const char *name,
-			     struct module *mod, unsigned long addr)
+static int klp_find_callback(void *data, const char *name, unsigned long addr)
 {
 	struct klp_find_arg *args = data;
 
diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
index ab2376a1be88e7e..c4fe856e5052ff7 100644
--- a/kernel/module/kallsyms.c
+++ b/kernel/module/kallsyms.c
@@ -495,8 +495,7 @@ unsigned long module_kallsyms_lookup_name(const char *name)
 }
 
 int module_kallsyms_on_each_symbol(const char *modname,
-				   int (*fn)(void *, const char *,
-					     struct module *, unsigned long),
+				   int (*fn)(void *, const char *, unsigned long),
 				   void *data)
 {
 	struct module *mod;
@@ -525,7 +524,7 @@ int module_kallsyms_on_each_symbol(const char *modname,
 				continue;
 
 			ret = fn(data, kallsyms_symbol_name(kallsyms, i),
-				 mod, kallsyms_symbol_value(sym));
+				 kallsyms_symbol_value(sym));
 			if (ret != 0)
 				goto out;
 		}
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d249a55d9005765..8f12524f8062686 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -8271,8 +8271,7 @@ struct kallsyms_data {
  * and returns 1 in case we resolved all the requested symbols,
  * 0 otherwise.
  */
-static int kallsyms_callback(void *data, const char *name,
-			     struct module *mod, unsigned long addr)
+static int kallsyms_callback(void *data, const char *name, unsigned long addr)
 {
 	struct kallsyms_data *args = data;
 	const char **sym;
-- 
2.25.1

