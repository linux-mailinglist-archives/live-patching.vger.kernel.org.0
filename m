Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0355B388D
	for <lists+live-patching@lfdr.de>; Fri,  9 Sep 2022 15:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiIINDU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Sep 2022 09:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbiIINDS (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Sep 2022 09:03:18 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CA1696F5;
        Fri,  9 Sep 2022 06:03:17 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MPGJf6pFXzZckB;
        Fri,  9 Sep 2022 20:58:42 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 9 Sep 2022 21:03:14 +0800
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
Subject: [PATCH v2 3/8] kallsyms: Adjust the types of some local variables
Date:   Fri, 9 Sep 2022 21:00:11 +0800
Message-ID: <20220909130016.727-4-thunder.leizhen@huawei.com>
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

The type of kallsyms_num_syms is 'unsigned int', adjust the type of
local variables associated with it for indexing, so that their types
are consistent.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/kallsyms.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 3e7e2c2ad2f75ef..9dd4774b6c6edf6 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -190,8 +190,7 @@ static bool cleanup_symbol_name(char *s)
 unsigned long kallsyms_lookup_name(const char *name)
 {
 	char namebuf[KSYM_NAME_LEN];
-	unsigned long i;
-	unsigned int off;
+	unsigned int i, off;
 
 	/* Skip the search for empty string. */
 	if (!*name)
@@ -218,8 +217,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 			    void *data)
 {
 	char namebuf[KSYM_NAME_LEN];
-	unsigned long i;
-	unsigned int off;
+	unsigned int i, off;
 	int ret;
 
 	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
@@ -237,7 +235,7 @@ static unsigned long get_symbol_pos(unsigned long addr,
 				    unsigned long *offset)
 {
 	unsigned long symbol_start = 0, symbol_end = 0;
-	unsigned long i, low, high, mid;
+	unsigned int i, low, high, mid;
 
 	/* This kernel should never had been booted. */
 	if (!IS_ENABLED(CONFIG_KALLSYMS_BASE_RELATIVE))
-- 
2.25.1

