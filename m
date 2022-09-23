Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2884E5E7965
	for <lists+live-patching@lfdr.de>; Fri, 23 Sep 2022 13:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiIWLWF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 23 Sep 2022 07:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbiIWLWB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 23 Sep 2022 07:22:01 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFE413791F;
        Fri, 23 Sep 2022 04:21:56 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MYqPj1wz6z1P6vv;
        Fri, 23 Sep 2022 19:17:45 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 19:21:54 +0800
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
Subject: [PATCH v5 04/10] scripts/kallsyms: generate kallsyms_best_token_table[]
Date:   Fri, 23 Sep 2022 19:20:27 +0800
Message-ID: <20220923112033.1958-5-thunder.leizhen@huawei.com>
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

To speed up the lookup of a symbol in the kernel, we'd better compress
the searched symbol first and then make a quick comparison based on the
compressed length and content. But the tokens in kallsyms_token_table[]
have been expanded, a more complex process is required to complete the
compression of a symbol. So generate kallsyms_best_token_table[] helps
us to compress a symbol in the kernel using a process similar to
compress_symbol().

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

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/kallsyms_internal.h |  1 +
 scripts/kallsyms.c         | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

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
index ca378a7e9425c00..40a6fe6d14ef03f 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -499,6 +499,24 @@ static void write_src(void)
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

