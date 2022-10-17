Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A932660070F
	for <lists+live-patching@lfdr.de>; Mon, 17 Oct 2022 08:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiJQGxg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 17 Oct 2022 02:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiJQGxT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 17 Oct 2022 02:53:19 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9F759261;
        Sun, 16 Oct 2022 23:52:11 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MrSJl5bwDzJn55;
        Mon, 17 Oct 2022 14:49:11 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 14:50:40 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 14:50:39 +0800
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
Subject: [PATCH v7 04/11] kallsyms: Add helper kallsyms_compress_symbol_name()
Date:   Mon, 17 Oct 2022 14:49:43 +0800
Message-ID: <20221017064950.2038-5-thunder.leizhen@huawei.com>
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

To speed up the lookup of a symbol in the kernel, we'd better compress
the searched symbol first and then make a quick comparison based on the
compressed length and content. But the tokens in kallsyms_token_table[]
have been expanded, a more complex process is required to complete the
compression of a symbol. So generate kallsyms_best_token_table[] helps
us to compress a symbol in the kernel using a process similar to
compress_symbol(). The implementation of kallsyms_compress_symbol_name()
is almost the same as that of compress_symbols() in scripts/kallsyms.c.

Some minor changes have been made to reduce memory usage and improve
compression performance.
1. Some entries in best_table[] are single characters, and most of them
   are clustered together. such as a-z, A-Z, 0-9. These individual
   characters are not used in the process of compressing a symbol. Let
   kallsyms_best_token_table[i][0] = 0x00, [i][0] = number of consecutive
   single characters (for exampe, a-z is 26). When [i][0] = 0x00 is
   encountered, we can skip to the next token with two elements.
2. Now ARRAY_SIZE(kallsyms_best_token_table) is not fixed, we store
   the content of best_table[] to kallsyms_best_token_table[] in reverse
   order. That is, the higher the frequency, the lower the index.

The modifier '__maybe_unused' of kallsyms_compress_symbol_name() is
temporary and will be removed in the next patch.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/kallsyms.c          | 80 ++++++++++++++++++++++++++++++++++++++
 kernel/kallsyms_internal.h |  1 +
 scripts/kallsyms.c         | 18 +++++++++
 3 files changed, 99 insertions(+)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 60c20f301a6ba2c..f1fe404af184047 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -95,6 +95,86 @@ static unsigned int kallsyms_expand_symbol(unsigned int off,
 	return off;
 }
 
+static unsigned char *find_token(unsigned char *str, int len,
+				 const unsigned char *token)
+{
+	int i;
+
+	for (i = 0; i < len - 1; i++) {
+		if (str[i] == token[0] && str[i+1] == token[1])
+			return &str[i];
+	}
+	return NULL;
+}
+
+static int __maybe_unused kallsyms_compress_symbol_name(const char *name, char *buf, size_t size)
+{
+	int i, j, n, len;
+	unsigned char *p1, *p2;
+	const unsigned char *token;
+
+	len = strscpy(buf, name, size);
+	if (WARN_ON_ONCE(len <= 0))
+		return 0;
+
+	/*
+	 * For each entry in kallsyms_best_token_table[], the storage
+	 * format is:
+	 * 1. For tokens that cannot be used to compress characters, the value
+	 *    at [j] is 0, and the value at [j+1] is the number of consecutive
+	 *    tokens with this feature.
+	 * 2. For each token: the larger the token value, the higher the
+	 *    frequency, and the lower the index.
+	 *
+	 *  -------------------------------
+	 * |  j  |   [j]  [j+1]  |  token  |
+	 *  -----|---------------|---------|
+	 * |  0  |   ??    ??	 |   255   |
+	 * |  2  |   ??    ??    |   254   |
+	 * | ... |   ??    ??    |   ...   |
+	 * | n-2 |   ??    ??    |    x    |
+	 * |  n  |   00    len   |   x-1   |
+	 * | n+2 |   ??    ??    | x-1-len |
+	 *      above '??' is non-zero
+	 */
+	for (i = 255, j = 0; i >= 0; i--, j += 2) {
+		if (!kallsyms_best_token_table[j]) {
+			i -= kallsyms_best_token_table[j + 1];
+			if (i < 0)
+				break;
+			j += 2;
+		}
+		token = &kallsyms_best_token_table[j];
+
+		p1 = buf;
+
+		/* find the token on the symbol */
+		p2 = find_token(p1, len, token);
+		if (!p2)
+			continue;
+
+		n = len;
+
+		do {
+			*p2 = i;
+			p2++;
+			n -= (p2 - p1);
+			memmove(p2, p2 + 1, n);
+			p1 = p2;
+			len--;
+
+			if (n < 2)
+				break;
+
+			/* find the token on the symbol */
+			p2 = find_token(p1, n, token);
+
+		} while (p2);
+	}
+
+	return len;
+}
+
 /*
  * Get symbol type information. This is encoded as a single char at the
  * beginning of the symbol name.
diff --git a/kernel/kallsyms_internal.h b/kernel/kallsyms_internal.h
index 2d0c6f2f0243a28..d9672ede8cfc215 100644
--- a/kernel/kallsyms_internal.h
+++ b/kernel/kallsyms_internal.h
@@ -26,5 +26,6 @@ extern const char kallsyms_token_table[] __weak;
 extern const u16 kallsyms_token_index[] __weak;
 
 extern const unsigned int kallsyms_markers[] __weak;
+extern const unsigned char kallsyms_best_token_table[] __weak;
 
 #endif // LINUX_KALLSYMS_INTERNAL_H_
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 60686094f665164..9864ce5e6c5bfc1 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -548,6 +548,24 @@ static void write_src(void)
 	for (i = 0; i < 256; i++)
 		printf("\t.short\t%d\n", best_idx[i]);
 	printf("\n");
+
+	output_label("kallsyms_best_token_table");
+	for (i = 255, k = 0; (int)i >= 0; i--) {
+		if (best_table_len[i] <= 1) {
+			k++;
+			continue;
+		}
+
+		if (k) {
+			printf("\t.byte 0x00, 0x%02x\n", k);
+			k = 0;
+		}
+
+		printf("\t.byte 0x%02x, 0x%02x\n", best_table[i][0], best_table[i][1]);
+	}
+	if (k)
+		printf("\t.byte 0x00, 0x%02x\n", k);
+	printf("\n");
 }
 
 
-- 
2.25.1

