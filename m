Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A4F5E8C4C
	for <lists+live-patching@lfdr.de>; Sat, 24 Sep 2022 14:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbiIXMW5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 24 Sep 2022 08:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbiIXMWz (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 24 Sep 2022 08:22:55 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4737AE1090;
        Sat, 24 Sep 2022 05:22:54 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MZSjY5Tswz1P6qL;
        Sat, 24 Sep 2022 20:18:41 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 20:22:52 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 20:22:51 +0800
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
Subject: [PATCH v6 06/11] kallsyms: Add helper kallsyms_lookup_clang_name()
Date:   Sat, 24 Sep 2022 20:20:46 +0800
Message-ID: <20220924122051.362-7-thunder.leizhen@huawei.com>
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

Literally, there is no sense that cleanup_symbol_name() is associated
with CLANG. So add helper kallsyms_lookup_clang_name() can enhance the
readability of the code. More importantly, if CONFIG_LTO_CLANG=n, there
is no need to execute that loop at all.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/kallsyms.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 22281dc9a49e35d..7366995f40395ec 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -266,6 +266,28 @@ static bool cleanup_symbol_name(char *s)
 	return false;
 }
 
+static int kallsyms_lookup_clang_name(unsigned char *namebuf, int len,
+				      const char *name,
+				      unsigned long *addr)
+{
+	unsigned long i;
+	unsigned int off;
+
+	if (!IS_ENABLED(CONFIG_LTO_CLANG))
+		return -ENOENT;
+
+	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
+		off = kallsyms_expand_symbol(off, namebuf, len);
+
+		if (cleanup_symbol_name(namebuf) && strcmp(namebuf, name) == 0) {
+			*addr = kallsyms_sym_address(i);
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+
 static int kallsyms_lookup_compressed_name(unsigned char *namebuf, int len,
 					   unsigned long *addr)
 {
@@ -302,8 +324,7 @@ static int kallsyms_lookup_compressed_name(unsigned char *namebuf, int len,
 unsigned long kallsyms_lookup_name(const char *name)
 {
 	char namebuf[KSYM_NAME_LEN];
-	unsigned long i, addr;
-	unsigned int off;
+	unsigned long addr;
 	int ret, len;
 
 	/* Skip the search for empty string. */
@@ -315,12 +336,9 @@ unsigned long kallsyms_lookup_name(const char *name)
 	if (!ret)
 		return addr;
 
-	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
-		off = kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
-
-		if (cleanup_symbol_name(namebuf) && strcmp(namebuf, name) == 0)
-			return kallsyms_sym_address(i);
-	}
+	ret = kallsyms_lookup_clang_name(namebuf, len, name, &addr);
+	if (!ret)
+		return addr;
 
 	return module_kallsyms_lookup_name(name);
 }
-- 
2.25.1

