Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44295615E4E
	for <lists+live-patching@lfdr.de>; Wed,  2 Nov 2022 09:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiKBIux (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 2 Nov 2022 04:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiKBIuu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 2 Nov 2022 04:50:50 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B7827CFA;
        Wed,  2 Nov 2022 01:50:34 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N2LFK2YjJz15MC9;
        Wed,  2 Nov 2022 16:50:29 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:50:32 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:50:31 +0800
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
        <linux-modules@vger.kernel.org>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
CC:     Zhen Lei <thunder.leizhen@huawei.com>,
        David Laight <David.Laight@ACULAB.COM>
Subject: [PATCH v8 7/9] livepatch: Improve the search performance of module_kallsyms_on_each_symbol()
Date:   Wed, 2 Nov 2022 16:49:19 +0800
Message-ID: <20221102084921.1615-8-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.37.3.windows.1
In-Reply-To: <20221102084921.1615-1-thunder.leizhen@huawei.com>
References: <20221102084921.1615-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
directly in this function and call hook 'fn' after matching. And the
parameter 'struct module *' in the hook 'fn' can also be deleted.

Phase1: mod1-->mod2..(subsequent modules do not need to be compared)
                |
Phase2:          -->f1-->f2-->f3

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 include/linux/module.h   |  4 ++--
 kernel/livepatch/core.c  | 13 ++-----------
 kernel/module/kallsyms.c | 15 ++++++++++++---
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index ec61fb53979a92a..0a3b44ff885a48c 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -879,8 +879,8 @@ static inline bool module_sig_ok(struct module *module)
 }
 #endif	/* CONFIG_MODULE_SIG */
 
-int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
-					     struct module *, unsigned long),
+int module_kallsyms_on_each_symbol(const char *modname,
+				   int (*fn)(void *, const char *, unsigned long),
 				   void *data);
 
 #endif /* _LINUX_MODULE_H */
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 50bfc3481a4ee38..d4fe2d1b0e562bc 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -118,27 +118,19 @@ static struct klp_object *klp_find_object(struct klp_patch *patch,
 }
 
 struct klp_find_arg {
-	const char *objname;
 	const char *name;
 	unsigned long addr;
 	unsigned long count;
 	unsigned long pos;
 };
 
-static int klp_find_callback(void *data, const char *name,
-			     struct module *mod, unsigned long addr)
+static int klp_find_callback(void *data, const char *name, unsigned long addr)
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
 	args->addr = addr;
 	args->count++;
 
@@ -175,7 +167,6 @@ static int klp_find_object_symbol(const char *objname, const char *name,
 				  unsigned long sympos, unsigned long *addr)
 {
 	struct klp_find_arg args = {
-		.objname = objname,
 		.name = name,
 		.addr = 0,
 		.count = 0,
@@ -183,7 +174,7 @@ static int klp_find_object_symbol(const char *objname, const char *name,
 	};
 
 	if (objname)
-		module_kallsyms_on_each_symbol(klp_find_callback, &args);
+		module_kallsyms_on_each_symbol(objname, klp_find_callback, &args);
 	else
 		kallsyms_on_each_match_symbol(klp_match_callback, name, &args);
 
diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
index f5c5c9175333df7..329cef573675d49 100644
--- a/kernel/module/kallsyms.c
+++ b/kernel/module/kallsyms.c
@@ -495,8 +495,8 @@ unsigned long module_kallsyms_lookup_name(const char *name)
 }
 
 #ifdef CONFIG_LIVEPATCH
-int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
-					     struct module *, unsigned long),
+int module_kallsyms_on_each_symbol(const char *modname,
+				   int (*fn)(void *, const char *, unsigned long),
 				   void *data)
 {
 	struct module *mod;
@@ -510,6 +510,9 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 		if (mod->state == MODULE_STATE_UNFORMED)
 			continue;
 
+		if (strcmp(modname, mod->name))
+			continue;
+
 		/* Use rcu_dereference_sched() to remain compliant with the sparse tool */
 		preempt_disable();
 		kallsyms = rcu_dereference_sched(mod->kallsyms);
@@ -522,10 +525,16 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 				continue;
 
 			ret = fn(data, kallsyms_symbol_name(kallsyms, i),
-				 mod, kallsyms_symbol_value(sym));
+				 kallsyms_symbol_value(sym));
 			if (ret != 0)
 				goto out;
 		}
+
+		/*
+		 * The given module is found, the subsequent modules do not
+		 * need to be compared.
+		 */
+		break;
 	}
 out:
 	mutex_unlock(&module_mutex);
-- 
2.25.1

