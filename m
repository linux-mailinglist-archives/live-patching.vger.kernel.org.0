Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9515E8C45
	for <lists+live-patching@lfdr.de>; Sat, 24 Sep 2022 14:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiIXMWy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 24 Sep 2022 08:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbiIXMWx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 24 Sep 2022 08:22:53 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71725FDE;
        Sat, 24 Sep 2022 05:22:51 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MZSlm4qgRzHpv3;
        Sat, 24 Sep 2022 20:20:36 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 20:22:49 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 20:22:48 +0800
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
Subject: [PATCH v6 02/11] scripts/kallsyms: don't compress symbol types
Date:   Sat, 24 Sep 2022 20:20:42 +0800
Message-ID: <20220924122051.362-3-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20220924122051.362-1-thunder.leizhen@huawei.com>
References: <20220924122051.362-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
 scripts/kallsyms.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 8caccc8f4a23703..296277128d450ff 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -34,6 +34,7 @@ struct sym_entry {
 	unsigned int len;
 	unsigned int start_pos;
 	unsigned int percpu_absolute;
+	unsigned char type;
 	unsigned char sym[];
 };
 
@@ -77,7 +78,7 @@ static void usage(void)
 
 static char *sym_name(const struct sym_entry *s)
 {
-	return (char *)s->sym + 1;
+	return (char *)s->sym;
 }
 
 static bool is_ignored_symbol(const char *name, char type)
@@ -227,11 +228,7 @@ static struct sym_entry *read_symbol(FILE *in)
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
@@ -240,7 +237,7 @@ static struct sym_entry *read_symbol(FILE *in)
 	}
 	sym->addr = addr;
 	sym->len = len;
-	sym->sym[0] = type;
+	sym->type = type;
 	strcpy(sym_name(sym), name);
 	sym->percpu_absolute = 0;
 
@@ -471,12 +468,18 @@ static void write_src(void)
 		if ((i & 0xFF) == 0)
 			markers[i >> 8] = off;
 
-		printf("\t.byte 0x%02x", table[i]->len);
+		/*
+		 * Store the symbol type togerher with symbol name.
+		 * It helps to reduce the size.
+		 */
+		printf("\t.byte 0x%02x", table[i]->len + 1);
+		printf(", 0x%02x", table[i]->type);
 		for (k = 0; k < table[i]->len; k++)
 			printf(", 0x%02x", table[i]->sym[k]);
 		printf("\n");
 
-		off += table[i]->len + 1;
+		/* fields 'len' and 'type' occupy one byte each */
+		off += table[i]->len + 1 + 1;
 	}
 	printf("\n");
 
@@ -637,14 +640,18 @@ static void optimize_result(void)
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
 
@@ -661,7 +668,7 @@ static void optimize_token_table(void)
 static int may_be_linker_script_provide_symbol(const struct sym_entry *se)
 {
 	const char *symbol = sym_name(se);
-	int len = se->len - 1;
+	int len = se->len;
 
 	if (len < 8)
 		return 0;
@@ -705,8 +712,8 @@ static int compare_symbols(const void *a, const void *b)
 		return -1;
 
 	/* sort by "weakness" type */
-	wa = (sa->sym[0] == 'w') || (sa->sym[0] == 'W');
-	wb = (sb->sym[0] == 'w') || (sb->sym[0] == 'W');
+	wa = (sa->type == 'w') || (sa->type == 'W');
+	wb = (sb->type == 'w') || (sb->type == 'W');
 	if (wa != wb)
 		return wa - wb;
 
@@ -742,7 +749,7 @@ static void make_percpus_absolute(void)
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

