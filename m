Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6716F615E40
	for <lists+live-patching@lfdr.de>; Wed,  2 Nov 2022 09:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiKBIu3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 2 Nov 2022 04:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKBIu2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 2 Nov 2022 04:50:28 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E083C25289;
        Wed,  2 Nov 2022 01:50:26 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N2L7W21KpzRntq;
        Wed,  2 Nov 2022 16:45:27 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:50:24 +0800
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:50:23 +0800
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
Subject: [PATCH v8 0/9] kallsyms: Optimizes the performance of lookup symbols
Date:   Wed, 2 Nov 2022 16:49:12 +0800
Message-ID: <20221102084921.1615-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.37.3.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,HEXHASH_WORD,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

v7 --> v8:
Sort the symbols by name and implement kallsyms_lookup_name() using a binary
search. The performance is more than 20 times higher than that of v7. Of course,
the memory overhead is also extended to (3 * kallsyms_num_syms) bytes. Discard
all implementations of compression and then comparison in v7.

In addition, all sparse warnings about kallsyms_selftest.c are cleared.


v6 --> v7:
1. Improve the performance of kallsyms_lookup_name() when CONFIG_LTO_CLANG=y
   To achieve this, restrict '.' to be at the beginning of a substring, not in
   the middle or end.
2. kallsyms_selftest.c adds support for CONFIG_LTO_CLANG=y.
3. Patches 4-6 are rearranged, centralize implementations of the same
   functionality in one patch, rather than split it based on whether it
   belongs to the tool or kernel.
4. Due to the impact of the following patches, some adaptations are made.
   aa221f2ea58655f kallsyms: take the input file instead of reading stdin
   73bbb94466fd3f8 kallsyms: support "big" kernel symbols
   dfb352ab1162f73 kallsyms: Drop CONFIG_CFI_CLANG workarounds


v5 --> v6:
1. Add patch 6/11, kallsyms: Add helper kallsyms_lookup_clang_name()
2. Update commit message of patch 9/11.

v4 --> v5:
1. In scripts/kallsyms.c, we use an extra field to hold type and eventually
   put it together with name in write_src().
2. Generate a new table kallsyms_best_token_table[], so that we compress a
   symbol in the kernel using a process similar to compress_symbol().
3. Remove helper sym_name(), and rename field 'sym[]' to 'name[]' in
   scripts/kallsyms.c
4. Add helper __kallsyms_lookup_compressed_name() to avoid duplicate code in
   functions kallsyms_lookup_name() and kallsyms_on_each_match_symbol().
5. Add a new parameter "const char *modname" to module_kallsyms_on_each_symbol(),
   this makes the code logic clearer.
6. Delete the parameter 'struct module *' in the hook function associated with
   kallsyms_on_each_symbol(), it's unused now.

v3 --> v4:
1. Move the declaration of function kallsyms_sym_address() to linux/kallsyms.h,
   fix a build warning.

v2 --> v3:
1. Improve test cases, perform complete functional tests on functions
   kallsyms_lookup_name(), kallsyms_on_each_symbol() and
   kallsyms_on_each_match_symbol().
2. Add patch [PATCH v3 2/8] scripts/kallsyms: ensure that all possible
   combinations are compressed.
3. The symbol type is not compressed regardless of whether
   CONFIG_KALLSYMS_ALL is set or not. The memory overhead is increased
   by less than 20KiB if CONFIG_KALLSYMS_ALL=n.
4. Discard [PATCH v2 3/8] kallsyms: Adjust the types of some local variables

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


Zhen Lei (9):
  scripts/kallsyms: rename build_initial_tok_table()
  kallsyms: Improve the performance of kallsyms_lookup_name()
  kallsyms: Correctly sequence symbols when CONFIG_LTO_CLANG=y
  kallsyms: Reduce the memory occupied by kallsyms_seqs_of_names[]
  kallsyms: Add helper kallsyms_on_each_match_symbol()
  livepatch: Use kallsyms_on_each_match_symbol() to improve performance
  livepatch: Improve the search performance of
    module_kallsyms_on_each_symbol()
  kallsyms: Delete an unused parameter related to
    kallsyms_on_each_symbol()
  kallsyms: Add self-test facility

 include/linux/kallsyms.h   |  12 +-
 include/linux/module.h     |   4 +-
 init/Kconfig               |  13 +
 kernel/Makefile            |   1 +
 kernel/kallsyms.c          | 121 +++++++--
 kernel/kallsyms_internal.h |   1 +
 kernel/kallsyms_selftest.c | 485 +++++++++++++++++++++++++++++++++++++
 kernel/kallsyms_selftest.h |  13 +
 kernel/livepatch/core.c    |  31 ++-
 kernel/module/kallsyms.c   |  15 +-
 kernel/trace/ftrace.c      |   3 +-
 scripts/kallsyms.c         |  78 +++++-
 scripts/link-vmlinux.sh    |   4 +
 13 files changed, 743 insertions(+), 38 deletions(-)
 create mode 100644 kernel/kallsyms_selftest.c
 create mode 100644 kernel/kallsyms_selftest.h

-- 
2.25.1

