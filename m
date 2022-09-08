Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81BB35B1E1E
	for <lists+live-patching@lfdr.de>; Thu,  8 Sep 2022 15:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbiIHNKq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 8 Sep 2022 09:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbiIHNKc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 8 Sep 2022 09:10:32 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82E55F20F;
        Thu,  8 Sep 2022 06:10:11 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MNfX90jnXzjXLP;
        Thu,  8 Sep 2022 21:06:33 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 8 Sep 2022 21:10:09 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 8 Sep 2022 21:10:08 +0800
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
Subject: [PATCH 0/7] kallsyms: Optimizes the performance of lookup symbols
Date:   Thu, 8 Sep 2022 21:09:29 +0800
Message-ID: <20220908130936.674-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
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


Zhen Lei (7):
  scripts/kallsyms: don't compress symbol type when
    CONFIG_KALLSYMS_ALL=y
  scripts/kallsyms: rename build_initial_tok_table()
  kallsyms: Adjust the types of some local variables
  kallsyms: Improve the performance of kallsyms_lookup_name()
  kallsyms: Add helper kallsyms_on_each_match_symbol()
  livepatch: Use kallsyms_on_each_match_symbol() to improve performance
  livepatch: Improve the search performance of
    module_kallsyms_on_each_symbol()

 include/linux/kallsyms.h |   8 +++
 kernel/kallsyms.c        | 135 +++++++++++++++++++++++++++++++++++++--
 kernel/livepatch/core.c  |  25 ++++++--
 kernel/module/kallsyms.c |  13 +++-
 scripts/kallsyms.c       |  19 ++++--
 5 files changed, 184 insertions(+), 16 deletions(-)

-- 
2.25.1

