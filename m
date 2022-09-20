Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D91F5BDDE6
	for <lists+live-patching@lfdr.de>; Tue, 20 Sep 2022 09:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiITHOZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Sep 2022 03:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiITHOW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Sep 2022 03:14:22 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D4C5C36C;
        Tue, 20 Sep 2022 00:14:21 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MWt3V3rmkz14QlX;
        Tue, 20 Sep 2022 15:10:14 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 15:14:19 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 15:14:19 +0800
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
Subject: [PATCH v4 4/8] kallsyms: Improve the performance of kallsyms_lookup_name()
Date:   Tue, 20 Sep 2022 15:13:13 +0800
Message-ID: <20220920071317.1787-5-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20220920071317.1787-1-thunder.leizhen@huawei.com>
References: <20220920071317.1787-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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
 kernel/kallsyms.c | 79 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 76 insertions(+), 3 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 3e7e2c2ad2f75ef..2d76196cfe89f34 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -87,6 +87,71 @@ static unsigned int kallsyms_expand_symbol(unsigned int off,
 	return off;
 }
 
+static int kallsyms_name_to_tokens(const char *name, char *buf)
+{
+	int i, j, k, n;
+	int len, token_len;
+	const char *token;
+	unsigned char token_idx[KSYM_NAME_LEN];
+	unsigned char token_bak[KSYM_NAME_LEN];
+
+	/*
+	 * n, number of tokens in the string name.
+	 * token_idx[i], the start index of the ith token.
+	 * token_idx[n] is used to calculate the length of the last token.
+	 */
+	n = strlen(name);
+	if (n >= KSYM_NAME_LEN) {
+		buf[0] = 0;
+		return 0;
+	}
+	for (i = 0; i <= n; i++)
+		token_idx[i] = (unsigned char)i;
+
+	/*
+	 * For tokens whose token_len >= 2, a larger index value indicates
+	 * a higher occurrence frequency. See scripts/kallsyms.c
+	 */
+	for (i = 255; i >= 0; i--) {
+		token = &kallsyms_token_table[kallsyms_token_index[i]];
+		token_len = strlen(token);
+		if (token_len <= 1)
+			continue;
+
+		/*
+		 * Find and merge two tokens into one.
+		 *
+		 *                |<-- new_token -->|
+		 *                | token1 | token2 |
+		 * token_idx[]:   j       j+1      j+2
+		 *
+		 */
+		for (j = 0; j < n - 1; j++) {
+			len = token_idx[j + 2] - token_idx[j];
+			if (len == token_len &&
+			    !strncmp(name + token_idx[j], token, len)) {
+				token_bak[token_idx[j]] = (unsigned char)i;
+				for (k = j + 1; k < n; k++)
+					token_idx[k] = token_idx[k + 1];
+				n--;
+			}
+		}
+	}
+
+	for (j = 0; j < n; j++) {
+		len = token_idx[j + 1] - token_idx[j];
+		if (len <= 1) {
+			buf[j] = name[token_idx[j]];
+			continue;
+		}
+
+		buf[j] = token_bak[token_idx[j]];
+	}
+	buf[n] = 0;
+
+	return n;
+}
+
 /*
  * Get symbol type information. This is encoded as a single char at the
  * beginning of the symbol name.
@@ -192,20 +257,28 @@ unsigned long kallsyms_lookup_name(const char *name)
 	char namebuf[KSYM_NAME_LEN];
 	unsigned long i;
 	unsigned int off;
+	int len;
 
 	/* Skip the search for empty string. */
 	if (!*name)
 		return 0;
 
+	len = kallsyms_name_to_tokens(name, namebuf);
+	for (i = 0, off = 0; len && i < kallsyms_num_syms; i++) {
+		if (kallsyms_names[off] == len + 1 &&
+		    !memcmp(&kallsyms_names[off + 2], namebuf, len))
+			return kallsyms_sym_address(i);
+
+		off += kallsyms_names[off] + 1;
+	}
+
 	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
 		off = kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
 
-		if (strcmp(namebuf, name) == 0)
-			return kallsyms_sym_address(i);
-
 		if (cleanup_symbol_name(namebuf) && strcmp(namebuf, name) == 0)
 			return kallsyms_sym_address(i);
 	}
+
 	return module_kallsyms_lookup_name(name);
 }
 
-- 
2.25.1

