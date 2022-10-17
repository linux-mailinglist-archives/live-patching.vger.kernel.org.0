Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B07F600700
	for <lists+live-patching@lfdr.de>; Mon, 17 Oct 2022 08:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiJQGwY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 17 Oct 2022 02:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiJQGwD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 17 Oct 2022 02:52:03 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0AF5809D;
        Sun, 16 Oct 2022 23:51:08 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MrSFX5QCQzmVdM;
        Mon, 17 Oct 2022 14:46:24 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 14:50:38 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 14:50:37 +0800
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
Subject: [PATCH v7 02/11] scripts/kallsyms: don't compress symbol types
Date:   Mon, 17 Oct 2022 14:49:41 +0800
Message-ID: <20221017064950.2038-3-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.37.3.windows.1
In-Reply-To: <20221017064950.2038-1-thunder.leizhen@huawei.com>
References: <20221017064950.2038-1-thunder.leizhen@huawei.com>
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

Let's use an extra field to hold type and eventually put it together with
name in write_src().

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 scripts/kallsyms.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index ab105bdde4efe4f..d3aae0491b3e963 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -51,6 +51,7 @@ struct sym_entry {
 	unsigned int len;
 	unsigned int start_pos;
 	unsigned int percpu_absolute;
+	unsigned char type;
 	unsigned char sym[];
 };
 
@@ -94,7 +95,7 @@ static void usage(void)
 
 static char *sym_name(const struct sym_entry *s)
 {
-	return (char *)s->sym + 1;
+	return (char *)s->sym;
 }
 
 static bool is_ignored_symbol(const char *name, char type)
@@ -242,11 +243,7 @@ static struct sym_entry *read_symbol(FILE *in)
 	check_symbol_range(name, addr, text_ranges, ARRAY_SIZE(text_ranges));
 	check_symbol_range(name, addr, &percpu_range, 1);
 
-	/* include the type field in the symbol name, so that it gets
-	 * compressed together */
-
-	len = strlen(name) + 1;
-
+	len = strlen(name);
 	sym = malloc(sizeof(*sym) + len + 1);
 	if (!sym) {
 		fprintf(stderr, "kallsyms failure: "
@@ -255,7 +252,7 @@ static struct sym_entry *read_symbol(FILE *in)
 	}
 	sym->addr = addr;
 	sym->len = len;
-	sym->sym[0] = type;
+	sym->type = type;
 	strcpy(sym_name(sym), name);
 	sym->percpu_absolute = 0;
 
@@ -503,6 +500,12 @@ static void write_src(void)
 			exit(EXIT_FAILURE);
 		}
 
+		/*
+		 * Store the symbol type togerher with symbol name.
+		 * It helps to reduce the size.
+		 */
+		table[i]->len++;
+
 		/* Only lengths that fit in up-to-two-byte ULEB128 are supported. */
 		if (table[i]->len > 0x3FFF) {
 			fprintf(stderr, "kallsyms failure: "
@@ -522,7 +525,8 @@ static void write_src(void)
 				(table[i]->len >> 7) & 0x7F);
 			off += table[i]->len + 2;
 		}
-		for (k = 0; k < table[i]->len; k++)
+		printf(", 0x%02x", table[i]->type);
+		for (k = 0; k < table[i]->len - 1; k++)
 			printf(", 0x%02x", table[i]->sym[k]);
 		printf("\n");
 	}
@@ -685,14 +689,18 @@ static void optimize_result(void)
 /* start by placing the symbols that are actually used on the table */
 static void insert_real_symbols_in_table(void)
 {
-	unsigned int i, j, c;
+	unsigned int i, j;
+	unsigned char c;
 
 	for (i = 0; i < table_cnt; i++) {
 		for (j = 0; j < table[i]->len; j++) {
 			c = table[i]->sym[j];
-			best_table[c][0]=c;
-			best_table_len[c]=1;
+			best_table[c][0] = c;
+			best_table_len[c] = 1;
 		}
+		c = table[i]->type;
+		best_table[c][0] = c;
+		best_table_len[c] = 1;
 	}
 }
 
@@ -709,7 +717,7 @@ static void optimize_token_table(void)
 static int may_be_linker_script_provide_symbol(const struct sym_entry *se)
 {
 	const char *symbol = sym_name(se);
-	int len = se->len - 1;
+	int len = se->len;
 
 	if (len < 8)
 		return 0;
@@ -753,8 +761,8 @@ static int compare_symbols(const void *a, const void *b)
 		return -1;
 
 	/* sort by "weakness" type */
-	wa = (sa->sym[0] == 'w') || (sa->sym[0] == 'W');
-	wb = (sb->sym[0] == 'w') || (sb->sym[0] == 'W');
+	wa = (sa->type == 'w') || (sa->type == 'W');
+	wb = (sb->type == 'w') || (sb->type == 'W');
 	if (wa != wb)
 		return wa - wb;
 
@@ -790,7 +798,7 @@ static void make_percpus_absolute(void)
 			 * ensure consistent behavior compared to older
 			 * versions of this tool.
 			 */
-			table[i]->sym[0] = 'A';
+			table[i]->type = 'A';
 			table[i]->percpu_absolute = 1;
 		}
 }
-- 
2.25.1

