Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EED15BD051
	for <lists+live-patching@lfdr.de>; Mon, 19 Sep 2022 17:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiISPRD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 19 Sep 2022 11:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiISPQo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 19 Sep 2022 11:16:44 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F50029B;
        Mon, 19 Sep 2022 08:16:31 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MWSrX3168zHnxQ;
        Mon, 19 Sep 2022 23:14:20 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 23:16:28 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 23:16:27 +0800
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
Subject: [PATCH v3 2/8] scripts/kallsyms: ensure that all possible combinations are compressed
Date:   Mon, 19 Sep 2022 23:15:27 +0800
Message-ID: <20220919151533.1734-3-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20220919151533.1734-1-thunder.leizhen@huawei.com>
References: <20220919151533.1734-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

For a symbol, there may be more than one place that can be merged. For
example: nfs_fs_proc_net_init, there are two "f"+"s_" combinations.
And we're only compressing the first combination at the moment. Let's
compress all possible combinations.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 scripts/kallsyms.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 8caccc8f4a23703..3319d9f38d7a5f2 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -553,7 +553,7 @@ static void compress_symbols(const unsigned char *str, int idx)
 	unsigned char *p1, *p2;
 
 	for (i = 0; i < table_cnt; i++) {
-
+retry:
 		len = table[i]->len;
 		p1 = table[i]->sym;
 
@@ -585,6 +585,9 @@ static void compress_symbols(const unsigned char *str, int idx)
 
 		/* increase the counts for this symbol's new tokens */
 		learn_symbol(table[i]->sym, len);
+
+		/* May be more than one place that can be merged, try again */
+		goto retry;
 	}
 }
 
-- 
2.25.1

