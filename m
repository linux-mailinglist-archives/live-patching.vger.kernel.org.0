Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4992C5B1E2A
	for <lists+live-patching@lfdr.de>; Thu,  8 Sep 2022 15:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbiIHNKv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 8 Sep 2022 09:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232251AbiIHNKf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 8 Sep 2022 09:10:35 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDB9719A7;
        Thu,  8 Sep 2022 06:10:15 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MNfX01FB1z14QQD;
        Thu,  8 Sep 2022 21:06:24 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 8 Sep 2022 21:10:13 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 8 Sep 2022 21:10:12 +0800
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
Subject: [PATCH 5/7] kallsyms: Add helper kallsyms_on_each_match_symbol()
Date:   Thu, 8 Sep 2022 21:09:34 +0800
Message-ID: <20220908130936.674-6-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20220908130936.674-1-thunder.leizhen@huawei.com>
References: <20220908130936.674-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

This requires CONFIG_KALLSYMS_ALL=y, so that scripts/kallsyms does not
compress that type character of each symbol.

If CONFIG_KALLSYMS_ALL=n, the traversal of symbols is rolled back to the
mode before optimization.

The pseudo code of the test case is as follows:
static int tst_find(void *data, const char *name,
		    struct module *mod, unsigned long addr)
{
	if (strcmp(name, "vmap") == 0)
		*(unsigned long *)data = addr;
        return 0;
}

static int tst_match(void *data, unsigned long addr)
{
        *(unsigned long *)data = addr;
        return 0;
}

start = sched_clock();
kallsyms_on_each_match_symbol(tst_match, "vmap", &addr);
end = sched_clock();

start = sched_clock();
kallsyms_on_each_symbol(tst_find, &addr);
end = sched_clock();

The test results are as follows (twice):
kallsyms_on_each_match_symbol:  1058511,  1079288
kallsyms_on_each_symbol      : 26097313, 24765180

kallsyms_on_each_match_symbol() consumes only 4.2% of
kallsyms_on_each_symbol()'s time.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 include/linux/kallsyms.h |  8 ++++++++
 kernel/kallsyms.c        | 41 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index ad39636e0c3f122..f9f2cc084cab16b 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -69,6 +69,8 @@ static inline void *dereference_symbol_descriptor(void *ptr)
 int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 				      unsigned long),
 			    void *data);
+extern int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long),
+					 const char *name, void *data);
 
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
index e1cd7305aa5f548..9816a0ac30c8c48 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -316,6 +316,47 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 	return 0;
 }
 
+int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long),
+				  const char *name, void *data)
+{
+	unsigned int i, off;
+	int len, ret;
+	char namebuf[KSYM_NAME_LEN];
+
+	len = kallsyms_name_to_tokens(name, namebuf);
+	if (!len)
+		goto slow_path;
+
+	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
+		if ((i & 0xfff) == 0)
+			cond_resched();
+
+		if ((kallsyms_names[off] == len + 1) &&
+		    !memcmp(&kallsyms_names[off + 2], namebuf, len)) {
+			ret = fn(data, kallsyms_sym_address(i));
+			if (ret != 0)
+				return ret;
+			cond_resched();
+		}
+		off += kallsyms_names[off] + 1;
+	}
+
+	return 0;
+
+slow_path:
+	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
+		off = kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
+		if (!strcmp(name, namebuf)) {
+			ret = fn(data, kallsyms_sym_address(i));
+			if (ret != 0)
+				return ret;
+		}
+		cond_resched();
+	}
+
+	return 0;
+}
+
 static unsigned long get_symbol_pos(unsigned long addr,
 				    unsigned long *symbolsize,
 				    unsigned long *offset)
-- 
2.25.1

