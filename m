Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6279E600705
	for <lists+live-patching@lfdr.de>; Mon, 17 Oct 2022 08:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiJQGw1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 17 Oct 2022 02:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiJQGwE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 17 Oct 2022 02:52:04 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7E6580A5;
        Sun, 16 Oct 2022 23:51:09 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MrSFY5BTXzmVdG;
        Mon, 17 Oct 2022 14:46:25 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 14:50:41 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 14:50:40 +0800
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
Subject: [PATCH v7 05/11] kallsyms: Improve the performance of kallsyms_lookup_name()
Date:   Mon, 17 Oct 2022 14:49:44 +0800
Message-ID: <20221017064950.2038-6-thunder.leizhen@huawei.com>
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
comparison. This process can be optimized.

And now scripts/kallsyms no longer compresses the symbol types, each
symbol type always occupies one byte. So we can first compress the
searched symbol and then make a quick comparison based on the compressed
length and content. In this way, for entries with mismatched lengths,
there is no need to expand and compare strings. And for those matching
lengths, there's no need to expand the symbol. This saves a lot of time.
According to my test results, the average performance of
kallsyms_lookup_name() can be improved by 20 to 30 times.

The pseudo code of the test case is as follows:
static int stat_find_name(...)
{
	start = sched_clock();
	(void)kallsyms_lookup_name(name);
	end = sched_clock();
	//Update min, max, cnt, sum
}

/*
 * Traverse all symbols in sequence and collect statistics on the time
 * taken by kallsyms_lookup_name() to lookup each symbol.
 */
kallsyms_on_each_symbol(stat_find_name, NULL);

The test results are as follows (twice):
After : min=5250, max=  726560, avg= 302132
After : min=5320, max=  726850, avg= 301978
Before: min=170,  max=15949190, avg=7553906
Before: min=160,  max=15877280, avg=7517784

The average time consumed is only 4.01% and the maximum time consumed is
only 4.57% of the time consumed before optimization.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/kallsyms.c | 50 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 4 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index f1fe404af184047..7f3987cc975be3b 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -107,7 +107,7 @@ static unsigned char *find_token(unsigned char *str, int len,
 	return NULL;
 }
 
-static int __maybe_unused kallsyms_compress_symbol_name(const char *name, char *buf, size_t size)
+static int kallsyms_compress_symbol_name(const char *name, char *buf, size_t size)
 {
 	int i, j, n, len;
 	unsigned char *p1, *p2;
@@ -267,23 +267,65 @@ static bool cleanup_symbol_name(char *s)
 	return false;
 }
 
+static int kallsyms_lookup_compressed_name(unsigned char *namebuf, int namelen,
+					   unsigned long *addr)
+{
+	unsigned int i, off;
+	unsigned int len, x;
+	const unsigned char *name;
+
+	for (i = 0, off = 0; namelen && i < kallsyms_num_syms; i++) {
+		/*
+		 * For each entry in kallsyms_names[], the storage format is:
+		 *  ----------------------------
+		 * | len(1-2) | type(1) | name(x) |
+		 *  ----------------------------
+		 *
+		 * Number of bytes in parentheses, and: len = 1 + x
+		 */
+		len = kallsyms_names[off];
+		off++;
+		if (len & 0x80) {
+			len = (len & 0x7f) | (kallsyms_names[off] << 7);
+			off++;
+		}
+		name = &kallsyms_names[off + 1];
+		off += len;
+
+		x = len - 1;
+		if (x != namelen)
+			continue;
+
+		if (!memcmp(name, namebuf, namelen)) {
+			*addr = kallsyms_sym_address(i);
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+
 /* Lookup the address for this symbol. Returns 0 if not found. */
 unsigned long kallsyms_lookup_name(const char *name)
 {
 	char namebuf[KSYM_NAME_LEN];
 	unsigned long i;
 	unsigned int off;
+	unsigned long addr;
+	int ret, len;
 
 	/* Skip the search for empty string. */
 	if (!*name)
 		return 0;
 
+	len = kallsyms_compress_symbol_name(name, namebuf, ARRAY_SIZE(namebuf));
+	ret = kallsyms_lookup_compressed_name(namebuf, len, &addr);
+	if (!ret)
+		return addr;
+
 	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
 		off = kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
 
-		if (strcmp(namebuf, name) == 0)
-			return kallsyms_sym_address(i);
-
 		if (cleanup_symbol_name(namebuf) && strcmp(namebuf, name) == 0)
 			return kallsyms_sym_address(i);
 	}
-- 
2.25.1

