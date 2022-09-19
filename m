Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493EF5BD053
	for <lists+live-patching@lfdr.de>; Mon, 19 Sep 2022 17:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiISPRE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 19 Sep 2022 11:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiISPQo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 19 Sep 2022 11:16:44 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A50B9C;
        Mon, 19 Sep 2022 08:16:30 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MWSpW5hg5zmVRr;
        Mon, 19 Sep 2022 23:12:35 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 23:16:28 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 23:16:28 +0800
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
Subject: [PATCH v3 3/8] scripts/kallsyms: don't compress symbol types
Date:   Mon, 19 Sep 2022 23:15:28 +0800
Message-ID: <20220919151533.1734-4-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20220919151533.1734-1-thunder.leizhen@huawei.com>
References: <20220919151533.1734-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Currently, to search for a symbol, we need to expand the symbols in
'kallsyms_names' one by one, and then use the expanded string for
comparison. Because we do not know the symbol type, and the symbol type
may be combined with the following characters to form a token.

So if we don't compress the symbol type, we can first compress the
searched symbol and then make a quick comparison based on the compressed
length and content. In this way, for entries with mismatched lengths,
there is no need to expand and compare strings. And for those matching
lengths, there's no need to expand the symbol. This saves a lot of time.
According to my test results, the average performance of
kallsyms_lookup_name() can be improved by 20 to 30 times.

Of course, because the symbol type is forcibly not compressed, the
compression rate also decreases. Here are the test results with
defconfig:

arm64: <<<<<<
        ---------------------------------------------------------------
       | ALL | nr_symbols | compressed size | original size | ratio(%) |
        -----|---------------------------------------------------------|
Before |  Y  |     174094 |       1884938   |      3750653  |  50.25   |
After  |  Y  |     174099 |       1960154   |      3750756  |  52.26   |
Before |  N  |      61744 |        725507   |      1222737  |  59.33   |
After  |  N  |      61747 |        745733   |      1222801  |  60.98   |
        ---------------------------------------------------------------
The memory overhead is increased by:
  73.5KiB and 4.0% if CONFIG_KALLSYMS_ALL=y.
  19.8KiB and 2.8% if CONFIG_KALLSYMS_ALL=n.

x86: <<<<<<<<
       ---------------------------------------------------------------
       | ALL | nr_symbols | compressed size | original size | ratio(%) |
        -----|---------------------------------------------------------|
Before |  Y  |     131415 |       1697542   |      3161216  |  53.69   |
After  |  Y  |     131540 |       1747769   |      3163933  |  55.24   |
Before |  N  |      60695 |        737627   |      1283046  |  57.49   |
After  |  N  |      60699 |        754797   |      1283149  |  58.82   |
        ---------------------------------------------------------------
The memory overhead is increased by:
  49.0KiB and 3.0% if CONFIG_KALLSYMS_ALL=y.
  16.8KiB and 2.3% if CONFIG_KALLSYMS_ALL=n.

This additional memory overhead is worth it compared to the performance
improvement, I think.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 scripts/kallsyms.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 3319d9f38d7a5f2..1ae9ce773d2a31d 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -61,6 +61,15 @@ static int all_symbols;
 static int absolute_percpu;
 static int base_relative;
 
+/*
+ * Each entry in the symbol table consists of the symbol type and the symbol
+ * itself. To optimize the performance of finding or traversing symbols in
+ * kernel, do not compress the symbol type. In this way, when looking for a
+ * symbol of unknown type, we can first compress the searched symbol and then
+ * make a quick comparison based on the compressed length and content.
+ */
+static int sym_start_idx = 1;
+
 static int token_profit[0x10000];
 
 /* the table that holds the result of the compression */
@@ -511,7 +520,7 @@ static void learn_symbol(const unsigned char *symbol, int len)
 {
 	int i;
 
-	for (i = 0; i < len - 1; i++)
+	for (i = sym_start_idx; i < len - 1; i++)
 		token_profit[ symbol[i] + (symbol[i + 1] << 8) ]++;
 }
 
@@ -520,7 +529,7 @@ static void forget_symbol(const unsigned char *symbol, int len)
 {
 	int i;
 
-	for (i = 0; i < len - 1; i++)
+	for (i = sym_start_idx; i < len - 1; i++)
 		token_profit[ symbol[i] + (symbol[i + 1] << 8) ]--;
 }
 
@@ -538,7 +547,7 @@ static unsigned char *find_token(unsigned char *str, int len,
 {
 	int i;
 
-	for (i = 0; i < len - 1; i++) {
+	for (i = sym_start_idx; i < len - 1; i++) {
 		if (str[i] == token[0] && str[i+1] == token[1])
 			return &str[i];
 	}
-- 
2.25.1

