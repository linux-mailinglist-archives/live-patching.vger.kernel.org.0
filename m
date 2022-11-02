Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3C3E615E4A
	for <lists+live-patching@lfdr.de>; Wed,  2 Nov 2022 09:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbiKBIuv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 2 Nov 2022 04:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbiKBIud (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 2 Nov 2022 04:50:33 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2306927DCD;
        Wed,  2 Nov 2022 01:50:32 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N2LB041PXzJnKw;
        Wed,  2 Nov 2022 16:47:36 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:50:30 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:50:29 +0800
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
Subject: [PATCH v8 5/9] kallsyms: Add helper kallsyms_on_each_match_symbol()
Date:   Wed, 2 Nov 2022 16:49:17 +0800
Message-ID: <20221102084921.1615-6-thunder.leizhen@huawei.com>
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

Function kallsyms_on_each_symbol() traverses all symbols and submits each
symbol to the hook 'fn' for judgment and processing. For some cases, the
hook actually only handles the matched symbol, such as livepatch.

Because all symbols are currently sorted by name, all the symbols with the
same name are clustered together. Function kallsyms_lookup_names() gets
the start and end positions of the set corresponding to the specified
name. So we can easily and quickly traverse all the matches.

The test results are as follows (twice): (x86)
kallsyms_on_each_match_symbol:     7454,     7984
kallsyms_on_each_symbol      : 11733809, 11785803

kallsyms_on_each_match_symbol() consumes only 0.066% of
kallsyms_on_each_symbol()'s time. In other words, 1523x better
performance.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 include/linux/kallsyms.h |  8 ++++++++
 kernel/kallsyms.c        | 18 ++++++++++++++++++
 2 files changed, 26 insertions(+)

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
index 48f36fd7e10b95e..0008ada2b135bef 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -307,6 +307,24 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 	return 0;
 }
 
+int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long),
+				  const char *name, void *data)
+{
+	int ret;
+	unsigned int i, start, end;
+
+	ret = kallsyms_lookup_names(name, &start, &end);
+	if (ret)
+		return 0;
+
+	for (i = start; !ret && i <= end; i++) {
+		ret = fn(data, kallsyms_sym_address(get_symbol_seq(i)));
+		cond_resched();
+	}
+
+	return ret;
+}
+
 static unsigned long get_symbol_pos(unsigned long addr,
 				    unsigned long *symbolsize,
 				    unsigned long *offset)
-- 
2.25.1

