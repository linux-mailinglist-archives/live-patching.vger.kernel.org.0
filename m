Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A98B5B1E20
	for <lists+live-patching@lfdr.de>; Thu,  8 Sep 2022 15:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbiIHNKr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 8 Sep 2022 09:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbiIHNKd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 8 Sep 2022 09:10:33 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDAFBF61;
        Thu,  8 Sep 2022 06:10:12 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MNfWw45tNz14QMJ;
        Thu,  8 Sep 2022 21:06:20 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 8 Sep 2022 21:10:10 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 8 Sep 2022 21:10:09 +0800
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
Subject: [PATCH 1/7] scripts/kallsyms: don't compress symbol type when CONFIG_KALLSYMS_ALL=y
Date:   Thu, 8 Sep 2022 21:09:30 +0800
Message-ID: <20220908130936.674-2-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20220908130936.674-1-thunder.leizhen@huawei.com>
References: <20220908130936.674-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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

Currently, to search for a symbol, we need to expand the symbols in
'kallsyms_names' one by one, and then use the expanded string for
comparison. This is very slow.

In fact, we can first compress the name being looked up and then use
it for comparison when traversing 'kallsyms_names'.

This increases the size of 'kallsyms_names'. About 48KiB, 2.67%, on x86
with defconfig.
Before: kallsyms_num_syms=131392, sizeof(kallsyms_names)=1823659
After : kallsyms_num_syms=131392, sizeof(kallsyms_names)=1872418

However, if CONFIG_KALLSYMS_ALL is not set, the size of 'kallsyms_names'
does not change.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 scripts/kallsyms.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index f18e6dfc68c5839..ab6fe7cd014efd1 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -60,6 +60,7 @@ static unsigned int table_size, table_cnt;
 static int all_symbols;
 static int absolute_percpu;
 static int base_relative;
+static int sym_start_idx;
 
 static int token_profit[0x10000];
 
@@ -511,7 +512,7 @@ static void learn_symbol(const unsigned char *symbol, int len)
 {
 	int i;
 
-	for (i = 0; i < len - 1; i++)
+	for (i = sym_start_idx; i < len - 1; i++)
 		token_profit[ symbol[i] + (symbol[i + 1] << 8) ]++;
 }
 
@@ -520,7 +521,7 @@ static void forget_symbol(const unsigned char *symbol, int len)
 {
 	int i;
 
-	for (i = 0; i < len - 1; i++)
+	for (i = sym_start_idx; i < len - 1; i++)
 		token_profit[ symbol[i] + (symbol[i + 1] << 8) ]--;
 }
 
@@ -538,7 +539,7 @@ static unsigned char *find_token(unsigned char *str, int len,
 {
 	int i;
 
-	for (i = 0; i < len - 1; i++) {
+	for (i = sym_start_idx; i < len - 1; i++) {
 		if (str[i] == token[0] && str[i+1] == token[1])
 			return &str[i];
 	}
@@ -780,6 +781,14 @@ int main(int argc, char **argv)
 	} else if (argc != 1)
 		usage();
 
+	/*
+	 * Skip the symbol type, do not compress it to optimize the performance
+	 * of finding or traversing symbols in kernel, this is good for modules
+	 * such as livepatch.
+	 */
+	if (all_symbols)
+		sym_start_idx = 1;
+
 	read_map(stdin);
 	shrink_table();
 	if (absolute_percpu)
-- 
2.25.1

