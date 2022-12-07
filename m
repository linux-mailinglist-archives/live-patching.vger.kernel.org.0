Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848BC645285
	for <lists+live-patching@lfdr.de>; Wed,  7 Dec 2022 04:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiLGDY7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 6 Dec 2022 22:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiLGDY6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 6 Dec 2022 22:24:58 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131E654346;
        Tue,  6 Dec 2022 19:24:54 -0800 (PST)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NRjLW40LLz15N1W;
        Wed,  7 Dec 2022 11:24:03 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Dec 2022 11:24:51 +0800
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
        Luis Chamberlain <mcgrof@kernel.org>,
        <linux-modules@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH] livepatch: Call klp_match_callback() in klp_find_callback() to avoid code duplication
Date:   Wed, 7 Dec 2022 11:23:04 +0800
Message-ID: <20221207032304.2017-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.37.3.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The implementation of function klp_match_callback() is identical to the
partial implementation of function klp_find_callback(). So call function
klp_match_callback() in function klp_find_callback() instead of the
duplicated code.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/livepatch/core.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 50bfc3481a4ee38..201f0c0482fb56d 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -125,20 +125,10 @@ struct klp_find_arg {
 	unsigned long pos;
 };
 
-static int klp_find_callback(void *data, const char *name,
-			     struct module *mod, unsigned long addr)
+static int klp_match_callback(void *data, unsigned long addr)
 {
 	struct klp_find_arg *args = data;
 
-	if ((mod && !args->objname) || (!mod && args->objname))
-		return 0;
-
-	if (strcmp(args->name, name))
-		return 0;
-
-	if (args->objname && strcmp(args->objname, mod->name))
-		return 0;
-
 	args->addr = addr;
 	args->count++;
 
@@ -153,22 +143,21 @@ static int klp_find_callback(void *data, const char *name,
 	return 0;
 }
 
-static int klp_match_callback(void *data, unsigned long addr)
+static int klp_find_callback(void *data, const char *name,
+			     struct module *mod, unsigned long addr)
 {
 	struct klp_find_arg *args = data;
 
-	args->addr = addr;
-	args->count++;
+	if ((mod && !args->objname) || (!mod && args->objname))
+		return 0;
 
-	/*
-	 * Finish the search when the symbol is found for the desired position
-	 * or the position is not defined for a non-unique symbol.
-	 */
-	if ((args->pos && (args->count == args->pos)) ||
-	    (!args->pos && (args->count > 1)))
-		return 1;
+	if (strcmp(args->name, name))
+		return 0;
 
-	return 0;
+	if (args->objname && strcmp(args->objname, mod->name))
+		return 0;
+
+	return klp_match_callback(data, addr);
 }
 
 static int klp_find_object_symbol(const char *objname, const char *name,
-- 
2.25.1

