Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEC66597A9
	for <lists+live-patching@lfdr.de>; Fri, 30 Dec 2022 12:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbiL3L3M (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 30 Dec 2022 06:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiL3L2u (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 30 Dec 2022 06:28:50 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767631AD95;
        Fri, 30 Dec 2022 03:28:49 -0800 (PST)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Nk2zb1xwpzRqJn;
        Fri, 30 Dec 2022 19:27:23 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 30 Dec 2022 19:28:46 +0800
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
Subject: [PATCH 1/3] livepatch: Improve the search performance of module_kallsyms_on_each_symbol()
Date:   Fri, 30 Dec 2022 19:27:27 +0800
Message-ID: <20221230112729.351-2-thunder.leizhen@huawei.com>
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
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Currently we traverse all symbols of all modules to find the specified
function for the specified module. But in reality, we just need to find
the given module and then traverse all the symbols in it.

Let's add a new parameter 'const char *modname' to function
module_kallsyms_on_each_symbol(), then we can compare the module names
directly in this function and call hook 'fn' after matching. If 'modname'
is NULL, the symbols of all modules are still traversed for compatibility
with other usage cases.

Phase1: mod1-->mod2..(subsequent modules do not need to be compared)
                |
Phase2:          -->f1-->f2-->f3

Assuming that there are m modules, each module has n symbols on average,
then the time complexity is reduced from O(m * n) to O(m) + O(n).

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 include/linux/module.h   |  6 ++++--
 kernel/livepatch/core.c  | 10 +---------
 kernel/module/kallsyms.c | 13 ++++++++++++-
 kernel/trace/bpf_trace.c |  2 +-
 kernel/trace/ftrace.c    |  2 +-
 5 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 8c5909c0076c6e1..514bc81568c5220 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -879,11 +879,13 @@ static inline bool module_sig_ok(struct module *module)
 #endif	/* CONFIG_MODULE_SIG */
 
 #if defined(CONFIG_MODULES) && defined(CONFIG_KALLSYMS)
-int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
+int module_kallsyms_on_each_symbol(const char *modname,
+				   int (*fn)(void *, const char *,
 					     struct module *, unsigned long),
 				   void *data);
 #else
-static inline int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
+static inline int module_kallsyms_on_each_symbol(const char *modname,
+						 int (*fn)(void *, const char *,
 						 struct module *, unsigned long),
 						 void *data)
 {
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 201f0c0482fb56d..c973ed9e42f8177 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -118,7 +118,6 @@ static struct klp_object *klp_find_object(struct klp_patch *patch,
 }
 
 struct klp_find_arg {
-	const char *objname;
 	const char *name;
 	unsigned long addr;
 	unsigned long count;
@@ -148,15 +147,9 @@ static int klp_find_callback(void *data, const char *name,
 {
 	struct klp_find_arg *args = data;
 
-	if ((mod && !args->objname) || (!mod && args->objname))
-		return 0;
-
 	if (strcmp(args->name, name))
 		return 0;
 
-	if (args->objname && strcmp(args->objname, mod->name))
-		return 0;
-
 	return klp_match_callback(data, addr);
 }
 
@@ -164,7 +157,6 @@ static int klp_find_object_symbol(const char *objname, const char *name,
 				  unsigned long sympos, unsigned long *addr)
 {
 	struct klp_find_arg args = {
-		.objname = objname,
 		.name = name,
 		.addr = 0,
 		.count = 0,
@@ -172,7 +164,7 @@ static int klp_find_object_symbol(const char *objname, const char *name,
 	};
 
 	if (objname)
-		module_kallsyms_on_each_symbol(klp_find_callback, &args);
+		module_kallsyms_on_each_symbol(objname, klp_find_callback, &args);
 	else
 		kallsyms_on_each_match_symbol(klp_match_callback, name, &args);
 
diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
index 4523f99b03589e3..ab2376a1be88e7e 100644
--- a/kernel/module/kallsyms.c
+++ b/kernel/module/kallsyms.c
@@ -494,7 +494,8 @@ unsigned long module_kallsyms_lookup_name(const char *name)
 	return ret;
 }
 
-int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
+int module_kallsyms_on_each_symbol(const char *modname,
+				   int (*fn)(void *, const char *,
 					     struct module *, unsigned long),
 				   void *data)
 {
@@ -509,6 +510,9 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 		if (mod->state == MODULE_STATE_UNFORMED)
 			continue;
 
+		if (modname && strcmp(modname, mod->name))
+			continue;
+
 		/* Use rcu_dereference_sched() to remain compliant with the sparse tool */
 		preempt_disable();
 		kallsyms = rcu_dereference_sched(mod->kallsyms);
@@ -525,6 +529,13 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 			if (ret != 0)
 				goto out;
 		}
+
+		/*
+		 * The given module is found, the subsequent modules do not
+		 * need to be compared.
+		 */
+		if (modname)
+			break;
 	}
 out:
 	mutex_unlock(&module_mutex);
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 3bbd3f0c810c895..5f3be4bc16403a5 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2737,7 +2737,7 @@ static int get_modules_for_addrs(struct module ***mods, unsigned long *addrs, u3
 	int err;
 
 	/* We return either err < 0 in case of error, ... */
-	err = module_kallsyms_on_each_symbol(module_callback, &args);
+	err = module_kallsyms_on_each_symbol(NULL, module_callback, &args);
 	if (err) {
 		kprobe_multi_put_modules(args.mods, args.mods_cnt);
 		kfree(args.mods);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 442438b93fe9804..d249a55d9005765 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -8324,7 +8324,7 @@ int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *a
 	found_all = kallsyms_on_each_symbol(kallsyms_callback, &args);
 	if (found_all)
 		return 0;
-	found_all = module_kallsyms_on_each_symbol(kallsyms_callback, &args);
+	found_all = module_kallsyms_on_each_symbol(NULL, kallsyms_callback, &args);
 	return found_all ? 0 : -ESRCH;
 }
 
-- 
2.25.1

