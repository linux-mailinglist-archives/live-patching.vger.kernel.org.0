Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2319D5B3882
	for <lists+live-patching@lfdr.de>; Fri,  9 Sep 2022 15:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiIINDQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Sep 2022 09:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiIINDP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Sep 2022 09:03:15 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A0CD1E05;
        Fri,  9 Sep 2022 06:03:14 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MPGKN6HrkzlVqG;
        Fri,  9 Sep 2022 20:59:20 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 9 Sep 2022 21:03:12 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 9 Sep 2022 21:03:11 +0800
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
Subject: [PATCH v2 0/8] kallsyms: Optimizes the performance of lookup symbols
Date:   Fri, 9 Sep 2022 21:00:08 +0800
Message-ID: <20220909130016.727-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

v1 --> v2:
Add self-test facility

v1:
Currently, to search for a symbol, we need to expand the symbols in
'kallsyms_names' one by one, and then use the expanded string for
comparison. This is very slow.

In fact, we can first compress the name being looked up and then use
it for comparison when traversing 'kallsyms_names'.

This patch series optimizes the performance of function kallsyms_lookup_name(),
and function klp_find_object_symbol() in the livepatch module. Based on the
test results, the performance overhead is reduced to 5%. That is, the
performance of these functions is improved by 20 times.

To avoid increasing the kernel size in non-debug mode, the optimization is only
for the case CONFIG_KALLSYMS_ALL=y.

Zhen Lei (8):
  scripts/kallsyms: don't compress symbol type when
    CONFIG_KALLSYMS_ALL=y
  scripts/kallsyms: rename build_initial_tok_table()
  kallsyms: Adjust the types of some local variables
  kallsyms: Improve the performance of kallsyms_lookup_name()
  kallsyms: Add helper kallsyms_on_each_match_symbol()
  livepatch: Use kallsyms_on_each_match_symbol() to improve performance
  livepatch: Improve the search performance of
    module_kallsyms_on_each_symbol()
  kallsyms: Add self-test facility

 include/linux/kallsyms.h   |   8 ++
 init/Kconfig               |  13 ++
 kernel/Makefile            |   1 +
 kernel/kallsyms.c          | 135 ++++++++++++++++++++-
 kernel/kallsyms_selftest.c | 243 +++++++++++++++++++++++++++++++++++++
 kernel/livepatch/core.c    |  25 +++-
 kernel/module/kallsyms.c   |  13 +-
 scripts/kallsyms.c         |  19 ++-
 8 files changed, 441 insertions(+), 16 deletions(-)
 create mode 100644 kernel/kallsyms_selftest.c

-- 
2.25.1

