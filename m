Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CCA5E7961
	for <lists+live-patching@lfdr.de>; Fri, 23 Sep 2022 13:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbiIWLWE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 23 Sep 2022 07:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbiIWLWB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 23 Sep 2022 07:22:01 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59F4137915;
        Fri, 23 Sep 2022 04:21:55 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MYqPh3pddz1P6sL;
        Fri, 23 Sep 2022 19:17:44 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 19:21:53 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 19:21:53 +0800
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
Subject: [PATCH v5 03/10] scripts/kallsyms: remove helper sym_name() and cleanup
Date:   Fri, 23 Sep 2022 19:20:26 +0800
Message-ID: <20220923112033.1958-4-thunder.leizhen@huawei.com>
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

Now, the type and name of a symbol are no longer stored together. So the
helper sym_name() is no longer needed. Correspondingly, replacing the
field name 'sym[]' with 'name[]' is more accurate.

Suggested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 scripts/kallsyms.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 296277128d450ff..ca378a7e9425c00 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -35,7 +35,7 @@ struct sym_entry {
 	unsigned int start_pos;
 	unsigned int percpu_absolute;
 	unsigned char type;
-	unsigned char sym[];
+	unsigned char name[];
 };
 
 struct addr_range {
@@ -76,11 +76,6 @@ static void usage(void)
 	exit(1);
 }
 
-static char *sym_name(const struct sym_entry *s)
-{
-	return (char *)s->sym;
-}
-
 static bool is_ignored_symbol(const char *name, char type)
 {
 	/* Symbol names that exactly match to the following are ignored.*/
@@ -238,7 +233,7 @@ static struct sym_entry *read_symbol(FILE *in)
 	sym->addr = addr;
 	sym->len = len;
 	sym->type = type;
-	strcpy(sym_name(sym), name);
+	strcpy((char *)sym->name, name);
 	sym->percpu_absolute = 0;
 
 	return sym;
@@ -262,7 +257,7 @@ static int symbol_in_range(const struct sym_entry *s,
 
 static int symbol_valid(const struct sym_entry *s)
 {
-	const char *name = sym_name(s);
+	const char *name = (char *)s->name;
 
 	/* if --all-symbols is not specified, then symbols outside the text
 	 * and inittext sections are discarded */
@@ -475,7 +470,7 @@ static void write_src(void)
 		printf("\t.byte 0x%02x", table[i]->len + 1);
 		printf(", 0x%02x", table[i]->type);
 		for (k = 0; k < table[i]->len; k++)
-			printf(", 0x%02x", table[i]->sym[k]);
+			printf(", 0x%02x", table[i]->name[k]);
 		printf("\n");
 
 		/* fields 'len' and 'type' occupy one byte each */
@@ -533,7 +528,7 @@ static void build_initial_token_table(void)
 	unsigned int i;
 
 	for (i = 0; i < table_cnt; i++)
-		learn_symbol(table[i]->sym, table[i]->len);
+		learn_symbol(table[i]->name, table[i]->len);
 }
 
 static unsigned char *find_token(unsigned char *str, int len,
@@ -558,14 +553,14 @@ static void compress_symbols(const unsigned char *str, int idx)
 	for (i = 0; i < table_cnt; i++) {
 
 		len = table[i]->len;
-		p1 = table[i]->sym;
+		p1 = table[i]->name;
 
 		/* find the token on the symbol */
 		p2 = find_token(p1, len, str);
 		if (!p2) continue;
 
 		/* decrease the counts for this symbol's tokens */
-		forget_symbol(table[i]->sym, len);
+		forget_symbol(table[i]->name, len);
 
 		size = len;
 
@@ -587,7 +582,7 @@ static void compress_symbols(const unsigned char *str, int idx)
 		table[i]->len = len;
 
 		/* increase the counts for this symbol's new tokens */
-		learn_symbol(table[i]->sym, len);
+		learn_symbol(table[i]->name, len);
 	}
 }
 
@@ -645,7 +640,7 @@ static void insert_real_symbols_in_table(void)
 
 	for (i = 0; i < table_cnt; i++) {
 		for (j = 0; j < table[i]->len; j++) {
-			c = table[i]->sym[j];
+			c = table[i]->name[j];
 			best_table[c][0] = c;
 			best_table_len[c] = 1;
 		}
@@ -667,7 +662,7 @@ static void optimize_token_table(void)
 /* guess for "linker script provide" symbol */
 static int may_be_linker_script_provide_symbol(const struct sym_entry *se)
 {
-	const char *symbol = sym_name(se);
+	const char *symbol = (char *)se->name;
 	int len = se->len;
 
 	if (len < 8)
@@ -724,8 +719,8 @@ static int compare_symbols(const void *a, const void *b)
 		return wa - wb;
 
 	/* sort by the number of prefix underscores */
-	wa = strspn(sym_name(sa), "_");
-	wb = strspn(sym_name(sb), "_");
+	wa = strspn((char *)sa->name, "_");
+	wb = strspn((char *)sb->name, "_");
 	if (wa != wb)
 		return wa - wb;
 
-- 
2.25.1

