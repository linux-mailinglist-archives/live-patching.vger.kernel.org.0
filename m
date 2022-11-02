Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D5F615E46
	for <lists+live-patching@lfdr.de>; Wed,  2 Nov 2022 09:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbiKBIue (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 2 Nov 2022 04:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbiKBIub (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 2 Nov 2022 04:50:31 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB8B25289;
        Wed,  2 Nov 2022 01:50:29 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N2L9y05V0zJnKl;
        Wed,  2 Nov 2022 16:47:34 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:50:27 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:50:27 +0800
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
Subject: [PATCH v8 3/9] kallsyms: Correctly sequence symbols when CONFIG_LTO_CLANG=y
Date:   Wed, 2 Nov 2022 16:49:15 +0800
Message-ID: <20221102084921.1615-4-thunder.leizhen@huawei.com>
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

LLVM appends various suffixes for local functions and variables, suffixes
observed:
 - foo.llvm.[0-9a-f]+
 - foo.[0-9a-f]+

Therefore, when CONFIG_LTO_CLANG=y, kallsyms_lookup_name() needs to
truncate the suffix of the symbol name before comparing the local function
or variable name.

Old implementation code:
-	if (strcmp(namebuf, name) == 0)
-		return kallsyms_sym_address(i);
-	if (cleanup_symbol_name(namebuf) && strcmp(namebuf, name) == 0)
-		return kallsyms_sym_address(i);

The preceding process is traversed by address from low to high. That is,
for those with the same name after the suffix is removed, the one with
the smallest address is returned first. Therefore, when sorting in the
tool, if the raw names are the same, they should be sorted by address in
ascending order.

ASCII[.]   = 2e
ASCII[0-9] = 30,39
ASCII[A-Z] = 41,5a
ASCII[_]   = 5f
ASCII[a-z] = 61,7a

According to the preceding ASCII code values, the following sorting result
is strictly followed.
 ---------------------------------
|    main-key     |    sub-key    |
|---------------------------------|
|                 |  addr_lowest  |
| <name>          |      ...      |
| <name>.<suffix> |      ...      |
|                 |  addr_highest |
|---------------------------------|
| <name>?<others> |               |   //? is [_A-Za-z0-9]
 ---------------------------------

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 scripts/kallsyms.c      | 36 ++++++++++++++++++++++++++++++++++--
 scripts/link-vmlinux.sh |  4 ++++
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index df2d93fb0e8d095..07ecf7e5c49f616 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -78,6 +78,7 @@ static unsigned int table_size, table_cnt;
 static int all_symbols;
 static int absolute_percpu;
 static int base_relative;
+static int lto_clang;
 
 static int token_profit[0x10000];
 
@@ -89,7 +90,7 @@ static unsigned char best_table_len[256];
 static void usage(void)
 {
 	fprintf(stderr, "Usage: kallsyms [--all-symbols] [--absolute-percpu] "
-			"[--base-relative] in.map > out.S\n");
+			"[--base-relative] [--lto-clang] in.map > out.S\n");
 	exit(1);
 }
 
@@ -411,6 +412,34 @@ static int symbol_absolute(const struct sym_entry *s)
 	return s->percpu_absolute;
 }
 
+static char * s_name(char *buf)
+{
+	/* Skip the symbol type */
+	return buf + 1;
+}
+
+static void cleanup_symbol_name(char *s)
+{
+	char *p;
+
+	if (!lto_clang)
+		return;
+
+	/*
+	 * ASCII[.]   = 2e
+	 * ASCII[0-9] = 30,39
+	 * ASCII[A-Z] = 41,5a
+	 * ASCII[_]   = 5f
+	 * ASCII[a-z] = 61,7a
+	 *
+	 * As above, replacing '.' with '\0' does not affect the main sorting,
+	 * but it helps us with subsorting.
+	 */
+	p = strchr(s, '.');
+	if (p)
+		*p = '\0';
+}
+
 static int compare_names(const void *a, const void *b)
 {
 	int ret;
@@ -421,7 +450,9 @@ static int compare_names(const void *a, const void *b)
 
 	expand_symbol(sa->sym, sa->len, sa_namebuf);
 	expand_symbol(sb->sym, sb->len, sb_namebuf);
-	ret = strcmp(&sa_namebuf[1], &sb_namebuf[1]);
+	cleanup_symbol_name(s_name(sa_namebuf));
+	cleanup_symbol_name(s_name(sb_namebuf));
+	ret = strcmp(s_name(sa_namebuf), s_name(sb_namebuf));
 	if (!ret) {
 		if (sa->addr > sb->addr)
 			return 1;
@@ -855,6 +886,7 @@ int main(int argc, char **argv)
 			{"all-symbols",     no_argument, &all_symbols,     1},
 			{"absolute-percpu", no_argument, &absolute_percpu, 1},
 			{"base-relative",   no_argument, &base_relative,   1},
+			{"lto-clang",       no_argument, &lto_clang,       1},
 			{},
 		};
 
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 918470d768e9c7d..32e573943cf036b 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -156,6 +156,10 @@ kallsyms()
 		kallsymopt="${kallsymopt} --base-relative"
 	fi
 
+	if is_enabled CONFIG_LTO_CLANG; then
+		kallsymopt="${kallsymopt} --lto-clang"
+	fi
+
 	info KSYMS ${2}
 	scripts/kallsyms ${kallsymopt} ${1} > ${2}
 }
-- 
2.25.1

