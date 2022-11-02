Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92DA0615E4C
	for <lists+live-patching@lfdr.de>; Wed,  2 Nov 2022 09:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbiKBIuw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 2 Nov 2022 04:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiKBIud (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 2 Nov 2022 04:50:33 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5150C27CFD;
        Wed,  2 Nov 2022 01:50:31 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N2LFG1g3fz15MF2;
        Wed,  2 Nov 2022 16:50:26 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:50:28 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:50:28 +0800
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
Subject: [PATCH v8 4/9] kallsyms: Reduce the memory occupied by kallsyms_seqs_of_names[]
Date:   Wed, 2 Nov 2022 16:49:16 +0800
Message-ID: <20221102084921.1615-5-thunder.leizhen@huawei.com>
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

kallsyms_seqs_of_names[] records the symbol index sorted by address, the
maximum value in kallsyms_seqs_of_names[] is the number of symbols. And
2^24 = 16777216, which means that three bytes are enough to store the
index. This can help us save (1 * kallsyms_num_syms) bytes of memory.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 kernel/kallsyms.c          | 18 ++++++++++++++----
 kernel/kallsyms_internal.h |  2 +-
 scripts/kallsyms.c         |  5 ++++-
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index ba351dfa109b6ac..48f36fd7e10b95e 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -201,6 +201,16 @@ static int compare_symbol_name(const char *name, char *namebuf)
 	return ret;
 }
 
+static unsigned int get_symbol_seq(int index)
+{
+	unsigned int i, seq = 0;
+
+	for (i = 0; i < 3; i++)
+		seq = (seq << 8) | kallsyms_seqs_of_names[3 * index + i];
+
+	return seq;
+}
+
 static int kallsyms_lookup_names(const char *name,
 				 unsigned int *start,
 				 unsigned int *end)
@@ -215,7 +225,7 @@ static int kallsyms_lookup_names(const char *name,
 
 	while (low <= high) {
 		mid = low + (high - low) / 2;
-		seq = kallsyms_seqs_of_names[mid];
+		seq = get_symbol_seq(mid);
 		off = get_symbol_offset(seq);
 		kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
 		ret = compare_symbol_name(name, namebuf);
@@ -232,7 +242,7 @@ static int kallsyms_lookup_names(const char *name,
 
 	low = mid;
 	while (low) {
-		seq = kallsyms_seqs_of_names[low - 1];
+		seq = get_symbol_seq(low - 1);
 		off = get_symbol_offset(seq);
 		kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
 		if (compare_symbol_name(name, namebuf))
@@ -244,7 +254,7 @@ static int kallsyms_lookup_names(const char *name,
 	if (end) {
 		high = mid;
 		while (high < kallsyms_num_syms - 1) {
-			seq = kallsyms_seqs_of_names[high + 1];
+			seq = get_symbol_seq(high + 1);
 			off = get_symbol_offset(seq);
 			kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
 			if (compare_symbol_name(name, namebuf))
@@ -269,7 +279,7 @@ unsigned long kallsyms_lookup_name(const char *name)
 
 	ret = kallsyms_lookup_names(name, &i, NULL);
 	if (!ret)
-		return kallsyms_sym_address(kallsyms_seqs_of_names[i]);
+		return kallsyms_sym_address(get_symbol_seq(i));
 
 	return module_kallsyms_lookup_name(name);
 }
diff --git a/kernel/kallsyms_internal.h b/kernel/kallsyms_internal.h
index a04b7a5cb1e3eaf..27fabdcc40f5793 100644
--- a/kernel/kallsyms_internal.h
+++ b/kernel/kallsyms_internal.h
@@ -26,6 +26,6 @@ extern const char kallsyms_token_table[] __weak;
 extern const u16 kallsyms_token_index[] __weak;
 
 extern const unsigned int kallsyms_markers[] __weak;
-extern const unsigned int kallsyms_seqs_of_names[] __weak;
+extern const u8 kallsyms_seqs_of_names[] __weak;
 
 #endif // LINUX_KALLSYMS_INTERNAL_H_
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 07ecf7e5c49f616..04e04fbd9625caf 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -600,7 +600,10 @@ static void write_src(void)
 	sort_symbols_by_name();
 	output_label("kallsyms_seqs_of_names");
 	for (i = 0; i < table_cnt; i++)
-		printf("\t.long\t%u\n", table[i]->seq);
+		printf("\t.byte 0x%02x, 0x%02x, 0x%02x\n",
+			(unsigned char)(table[i]->seq >> 16),
+			(unsigned char)(table[i]->seq >> 8),
+			(unsigned char)(table[i]->seq >> 0));
 	printf("\n");
 
 	output_label("kallsyms_token_table");
-- 
2.25.1

