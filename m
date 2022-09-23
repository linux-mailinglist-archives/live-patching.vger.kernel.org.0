Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B34F5E796C
	for <lists+live-patching@lfdr.de>; Fri, 23 Sep 2022 13:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiIWLWJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 23 Sep 2022 07:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbiIWLWD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 23 Sep 2022 07:22:03 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF6D13792C;
        Fri, 23 Sep 2022 04:21:58 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MYqPy2GsnzWgnK;
        Fri, 23 Sep 2022 19:17:58 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 19:21:56 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 19:21:56 +0800
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
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH v5 07/10] livepatch: Use kallsyms_on_each_match_symbol() to improve performance
Date:   Fri, 23 Sep 2022 19:20:30 +0800
Message-ID: <20220923112033.1958-8-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20220923112033.1958-1-thunder.leizhen@huawei.com>
References: <20220923112033.1958-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Based on the test results of kallsyms_on_each_match_symbol() and
kallsyms_on_each_symbol(), the average performance can be improved by 20
to 30 times.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/livepatch/core.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 42f7e716d56bf72..31b57ccf908017e 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -153,6 +153,24 @@ static int klp_find_callback(void *data, const char *name,
 	return 0;
 }
 
+static int klp_match_callback(void *data, unsigned long addr)
+{
+	struct klp_find_arg *args = data;
+
+	args->addr = addr;
+	args->count++;
+
+	/*
+	 * Finish the search when the symbol is found for the desired position
+	 * or the position is not defined for a non-unique symbol.
+	 */
+	if ((args->pos && (args->count == args->pos)) ||
+	    (!args->pos && (args->count > 1)))
+		return 1;
+
+	return 0;
+}
+
 static int klp_find_object_symbol(const char *objname, const char *name,
 				  unsigned long sympos, unsigned long *addr)
 {
@@ -167,7 +185,7 @@ static int klp_find_object_symbol(const char *objname, const char *name,
 	if (objname)
 		module_kallsyms_on_each_symbol(klp_find_callback, &args);
 	else
-		kallsyms_on_each_symbol(klp_find_callback, &args);
+		kallsyms_on_each_match_symbol(klp_match_callback, name, &args);
 
 	/*
 	 * Ensure an address was found. If sympos is 0, ensure symbol is unique;
-- 
2.25.1

