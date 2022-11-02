Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC68615E5E
	for <lists+live-patching@lfdr.de>; Wed,  2 Nov 2022 09:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbiKBIvb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 2 Nov 2022 04:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiKBIu7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 2 Nov 2022 04:50:59 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC4427DF1;
        Wed,  2 Nov 2022 01:50:55 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N2LFQ6RwhzHvbD;
        Wed,  2 Nov 2022 16:50:34 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:50:26 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:50:25 +0800
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
Subject: [PATCH v8 2/9] kallsyms: Improve the performance of kallsyms_lookup_name()
Date:   Wed, 2 Nov 2022 16:49:14 +0800
Message-ID: <20221102084921.1615-3-thunder.leizhen@huawei.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Currently, to search for a symbol, we need to expand the symbols in
'kallsyms_names' one by one, and then use the expanded string for
comparison. It's O(n).

If we sort names in ascending order like addresses, we can also use
binary search. It's O(log(n)).

In order not to change the implementation of "/proc/kallsyms", the table
kallsyms_names[] is still stored in a one-to-one correspondence with the
address in ascending order.

Add array kallsyms_seqs_of_names[], it's indexed by the sequence number
of the sorted names, and the corresponding content is the sequence number
of the sorted addresses. For example:
Assume that the index of NameX in array kallsyms_seqs_of_names[] is 'i',
the content of kallsyms_seqs_of_names[i] is 'k', then the corresponding
address of NameX is kallsyms_addresses[k]. The offset in kallsyms_names[]
is get_symbol_offset(k).

Note that the memory usage will increase by (4 * kallsyms_num_syms)
bytes, the next two patches will reduce (1 * kallsyms_num_syms) bytes
and properly handle the case CONFIG_LTO_CLANG=y.

Performance test results: (x86)
Before:
min=234, max=10364402, avg=5206926
min=267, max=11168517, avg=5207587
After:
min=1016, max=90894, avg=7272
min=1014, max=93470, avg=7293

The average lookup performance of kallsyms_lookup_name() improved 715x.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/kallsyms.c          | 86 +++++++++++++++++++++++++++++++++-----
 kernel/kallsyms_internal.h |  1 +
 scripts/kallsyms.c         | 37 ++++++++++++++++
 3 files changed, 113 insertions(+), 11 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 60c20f301a6ba2c..ba351dfa109b6ac 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -187,26 +187,90 @@ static bool cleanup_symbol_name(char *s)
 	return false;
 }
 
+static int compare_symbol_name(const char *name, char *namebuf)
+{
+	int ret;
+
+	ret = strcmp(name, namebuf);
+	if (!ret)
+		return ret;
+
+	if (cleanup_symbol_name(namebuf) && !strcmp(name, namebuf))
+		return 0;
+
+	return ret;
+}
+
+static int kallsyms_lookup_names(const char *name,
+				 unsigned int *start,
+				 unsigned int *end)
+{
+	int ret;
+	int low, mid, high;
+	unsigned int seq, off;
+	char namebuf[KSYM_NAME_LEN];
+
+	low = 0;
+	high = kallsyms_num_syms - 1;
+
+	while (low <= high) {
+		mid = low + (high - low) / 2;
+		seq = kallsyms_seqs_of_names[mid];
+		off = get_symbol_offset(seq);
+		kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
+		ret = compare_symbol_name(name, namebuf);
+		if (ret > 0)
+			low = mid + 1;
+		else if (ret < 0)
+			high = mid - 1;
+		else
+			break;
+	}
+
+	if (low > high)
+		return -ESRCH;
+
+	low = mid;
+	while (low) {
+		seq = kallsyms_seqs_of_names[low - 1];
+		off = get_symbol_offset(seq);
+		kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
+		if (compare_symbol_name(name, namebuf))
+			break;
+		low--;
+	}
+	*start = low;
+
+	if (end) {
+		high = mid;
+		while (high < kallsyms_num_syms - 1) {
+			seq = kallsyms_seqs_of_names[high + 1];
+			off = get_symbol_offset(seq);
+			kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
+			if (compare_symbol_name(name, namebuf))
+				break;
+			high++;
+		}
+		*end = high;
+	}
+
+	return 0;
+}
+
 /* Lookup the address for this symbol. Returns 0 if not found. */
 unsigned long kallsyms_lookup_name(const char *name)
 {
-	char namebuf[KSYM_NAME_LEN];
-	unsigned long i;
-	unsigned int off;
+	int ret;
+	unsigned int i;
 
 	/* Skip the search for empty string. */
 	if (!*name)
 		return 0;
 
-	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
-		off = kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
-
-		if (strcmp(namebuf, name) == 0)
-			return kallsyms_sym_address(i);
+	ret = kallsyms_lookup_names(name, &i, NULL);
+	if (!ret)
+		return kallsyms_sym_address(kallsyms_seqs_of_names[i]);
 
-		if (cleanup_symbol_name(namebuf) && strcmp(namebuf, name) == 0)
-			return kallsyms_sym_address(i);
-	}
 	return module_kallsyms_lookup_name(name);
 }
 
diff --git a/kernel/kallsyms_internal.h b/kernel/kallsyms_internal.h
index 2d0c6f2f0243a28..a04b7a5cb1e3eaf 100644
--- a/kernel/kallsyms_internal.h
+++ b/kernel/kallsyms_internal.h
@@ -26,5 +26,6 @@ extern const char kallsyms_token_table[] __weak;
 extern const u16 kallsyms_token_index[] __weak;
 
 extern const unsigned int kallsyms_markers[] __weak;
+extern const unsigned int kallsyms_seqs_of_names[] __weak;
 
 #endif // LINUX_KALLSYMS_INTERNAL_H_
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index ab105bdde4efe4f..df2d93fb0e8d095 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -49,6 +49,7 @@ _Static_assert(
 struct sym_entry {
 	unsigned long long addr;
 	unsigned int len;
+	unsigned int seq;
 	unsigned int start_pos;
 	unsigned int percpu_absolute;
 	unsigned char sym[];
@@ -410,6 +411,35 @@ static int symbol_absolute(const struct sym_entry *s)
 	return s->percpu_absolute;
 }
 
+static int compare_names(const void *a, const void *b)
+{
+	int ret;
+	char sa_namebuf[KSYM_NAME_LEN];
+	char sb_namebuf[KSYM_NAME_LEN];
+	const struct sym_entry *sa = *(const struct sym_entry **)a;
+	const struct sym_entry *sb = *(const struct sym_entry **)b;
+
+	expand_symbol(sa->sym, sa->len, sa_namebuf);
+	expand_symbol(sb->sym, sb->len, sb_namebuf);
+	ret = strcmp(&sa_namebuf[1], &sb_namebuf[1]);
+	if (!ret) {
+		if (sa->addr > sb->addr)
+			return 1;
+		else if (sa->addr < sb->addr)
+			return -1;
+
+		/* keep old order */
+		return (int)(sa->seq - sb->seq);
+	}
+
+	return ret;
+}
+
+static void sort_symbols_by_name(void)
+{
+	qsort(table, table_cnt, sizeof(table[0]), compare_names);
+}
+
 static void write_src(void)
 {
 	unsigned int i, k, off;
@@ -495,6 +525,7 @@ static void write_src(void)
 	for (i = 0; i < table_cnt; i++) {
 		if ((i & 0xFF) == 0)
 			markers[i >> 8] = off;
+		table[i]->seq = i;
 
 		/* There cannot be any symbol of length zero. */
 		if (table[i]->len == 0) {
@@ -535,6 +566,12 @@ static void write_src(void)
 
 	free(markers);
 
+	sort_symbols_by_name();
+	output_label("kallsyms_seqs_of_names");
+	for (i = 0; i < table_cnt; i++)
+		printf("\t.long\t%u\n", table[i]->seq);
+	printf("\n");
+
 	output_label("kallsyms_token_table");
 	off = 0;
 	for (i = 0; i < 256; i++) {
-- 
2.25.1

