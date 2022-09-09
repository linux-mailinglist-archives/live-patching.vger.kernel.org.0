Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582995B387C
	for <lists+live-patching@lfdr.de>; Fri,  9 Sep 2022 15:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiIINDS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Sep 2022 09:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiIINDR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Sep 2022 09:03:17 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EC8D741B;
        Fri,  9 Sep 2022 06:03:15 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MPGJf1VLHzZck4;
        Fri,  9 Sep 2022 20:58:42 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 9 Sep 2022 21:03:13 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 9 Sep 2022 21:03:13 +0800
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
Subject: [PATCH v2 2/8] scripts/kallsyms: rename build_initial_tok_table()
Date:   Fri, 9 Sep 2022 21:00:10 +0800
Message-ID: <20220909130016.727-3-thunder.leizhen@huawei.com>
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

Except for the function build_initial_tok_table(), no token abbreviation
is used elsewhere.

$ cat scripts/kallsyms.c | grep tok | wc -l
33
$ cat scripts/kallsyms.c | grep token | wc -l
31

Here, it would be clearer to use the full name.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 scripts/kallsyms.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index ab6fe7cd014efd1..678ebe7d4c1cc38 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -526,7 +526,7 @@ static void forget_symbol(const unsigned char *symbol, int len)
 }
 
 /* do the initial token count */
-static void build_initial_tok_table(void)
+static void build_initial_token_table(void)
 {
 	unsigned int i;
 
@@ -651,7 +651,7 @@ static void insert_real_symbols_in_table(void)
 
 static void optimize_token_table(void)
 {
-	build_initial_tok_table();
+	build_initial_token_table();
 
 	insert_real_symbols_in_table();
 
-- 
2.25.1

