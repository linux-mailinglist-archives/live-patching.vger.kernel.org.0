Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBE4600703
	for <lists+live-patching@lfdr.de>; Mon, 17 Oct 2022 08:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiJQGwZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 17 Oct 2022 02:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbiJQGwD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 17 Oct 2022 02:52:03 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD6A5809C;
        Sun, 16 Oct 2022 23:51:08 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MrSFX63pNzmVSC;
        Mon, 17 Oct 2022 14:46:24 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 14:50:43 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 14:50:42 +0800
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
Subject: [PATCH v7 07/11] kallsyms: Add helper kallsyms_on_each_match_symbol()
Date:   Mon, 17 Oct 2022 14:49:46 +0800
Message-ID: <20221017064950.2038-8-thunder.leizhen@huawei.com>
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

Function kallsyms_on_each_symbol() traverses all symbols and submits each
symbol to the hook 'fn' for judgment and processing. For some cases, the
hook actually only handles the matched symbol, such as livepatch.

So that, we can first compress the name being looked up and then use
it for comparison when traversing 'kallsyms_names', this greatly reduces
the time consumed by traversing.

The pseudo code of the test case is as follows:
static int tst_find(void *data, const char *name,
		    struct module *mod, unsigned long addr)
{
	if (strcmp(name, "stub_name") == 0)
		*(unsigned long *)data = addr;
        return 0;
}

static int tst_match(void *data, unsigned long addr)
{
        *(unsigned long *)data = addr;
        return 0;
}

start = sched_clock();
kallsyms_on_each_match_symbol(tst_match, "stub_name", &addr);
end = sched_clock();

start = sched_clock();
kallsyms_on_each_symbol(tst_find, &addr);
end = sched_clock();

The test results are as follows (twice):
kallsyms_on_each_match_symbol:   557400,   583900
kallsyms_on_each_symbol      : 16659500, 16113950

kallsyms_on_each_match_symbol() consumes only 3.48% of
kallsyms_on_each_symbol()'s time.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 include/linux/kallsyms.h |  8 ++++++++
 kernel/kallsyms.c        | 44 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 649faac31ddb162..0cd33be7142ad0d 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -69,6 +69,8 @@ static inline void *dereference_symbol_descriptor(void *ptr)
 int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 				      unsigned long),
 			    void *data);
+int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long),
+				  const char *name, void *data);
 
 /* Lookup the address for a symbol. Returns 0 if not found. */
 unsigned long kallsyms_lookup_name(const char *name);
@@ -168,6 +170,12 @@ static inline int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long),
+						const char *name, void *data)
+{
+	return -EOPNOTSUPP;
+}
 #endif /*CONFIG_KALLSYMS*/
 
 static inline void print_ip_sym(const char *loglvl, unsigned long ip)
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index bd1f263b1c69b53..a1d3aa2c44e8d6f 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -286,14 +286,17 @@ static bool cleanup_compressed_symbol_name(int token)
 	return false;
 }
 
-static int kallsyms_lookup_compressed_name(unsigned char *namebuf, int namelen,
-					   unsigned long *addr)
+static int __kallsyms_lookup_compressed_name(unsigned char *namebuf, int namelen,
+					     unsigned int *index,
+					     unsigned int *offset,
+					     unsigned long *addr)
 {
-	unsigned int i, off;
+	unsigned int i = *index;
+	unsigned int off = *offset;
 	unsigned int len, x;
 	const unsigned char *name;
 
-	for (i = 0, off = 0; namelen && i < kallsyms_num_syms; i++) {
+	for (; namelen && i < kallsyms_num_syms; i++) {
 		/*
 		 * For each entry in kallsyms_names[], the storage format is:
 		 *  ----------------------------
@@ -317,6 +320,10 @@ static int kallsyms_lookup_compressed_name(unsigned char *namebuf, int namelen,
 			continue;
 
 		if (!memcmp(name, namebuf, namelen)) {
+			/* Prepare for the next iteration */
+			*index = i + 1;
+			*offset = off;
+
 			*addr = kallsyms_sym_address(i);
 			return 0;
 		}
@@ -325,6 +332,14 @@ static int kallsyms_lookup_compressed_name(unsigned char *namebuf, int namelen,
 	return -ENOENT;
 }
 
+static int kallsyms_lookup_compressed_name(unsigned char *namebuf, int len,
+					   unsigned long *addr)
+{
+	unsigned int i = 0, off = 0;
+
+	return __kallsyms_lookup_compressed_name(namebuf, len, &i, &off, addr);
+}
+
 /* Lookup the address for this symbol. Returns 0 if not found. */
 unsigned long kallsyms_lookup_name(const char *name)
 {
@@ -367,6 +382,27 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 	return 0;
 }
 
+int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long),
+				  const char *name, void *data)
+{
+	int ret, len;
+	unsigned long addr;
+	unsigned int i = 0, off = 0;
+	char namebuf[KSYM_NAME_LEN];
+
+	len = kallsyms_compress_symbol_name(name, namebuf, ARRAY_SIZE(namebuf));
+	do {
+		ret = __kallsyms_lookup_compressed_name(namebuf, len, &i, &off, &addr);
+		if (ret)
+			return 0;	/* end of lookup */
+
+		ret = fn(data, addr);
+		cond_resched();
+	} while (!ret);
+
+	return ret;
+}
+
 static unsigned long get_symbol_pos(unsigned long addr,
 				    unsigned long *symbolsize,
 				    unsigned long *offset)
-- 
2.25.1

