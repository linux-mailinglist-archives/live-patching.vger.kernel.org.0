Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303B96597A8
	for <lists+live-patching@lfdr.de>; Fri, 30 Dec 2022 12:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbiL3L3L (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 30 Dec 2022 06:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbiL3L2t (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 30 Dec 2022 06:28:49 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB9A1AD91;
        Fri, 30 Dec 2022 03:28:48 -0800 (PST)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Nk2zt4gXvzJqgF;
        Fri, 30 Dec 2022 19:27:38 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 30 Dec 2022 19:28:45 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, <bpf@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        <linux-modules@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 0/3] kallsyms: Optimize the search for module symbols by livepatch and bpf
Date:   Fri, 30 Dec 2022 19:27:26 +0800
Message-ID: <20221230112729.351-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.37.3.windows.1
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

Patches 7-8 in [1] have been delayed until now due to merge conflicts. The
current patch 1/3 corresponds to patch 7/9 in [1], and the current patch 3/3
corresponds to patch 8/9 in [1]. But there are some changes. Originally, only
livepatch uses function module_kallsyms_on_each_symbol(), it find the specified
function for the specified module. Now, bpf also uses function
module_kallsyms_on_each_symbol(), it needs to traverse all the modules. So for
the new parameter 'modname' of module_kallsyms_on_each_symbol(), if it's NULL,
the symbols of all modules are still traversed for compatibility with the case
of bpf.

Patch 2/3 is new, as I understand it, it should be fine. If it doesn't work,
then patch 3/3 should be dropped.

[1] https://lkml.org/lkml/2022/11/2/225

Zhen Lei (3):
  livepatch: Improve the search performance of
    module_kallsyms_on_each_symbol()
  bpf: Optimize get_modules_for_addrs()
  kallsyms: Delete an unused parameter related to
    {module_}kallsyms_on_each_symbol()

 include/linux/kallsyms.h   |   3 +-
 include/linux/module.h     |   8 +--
 kernel/kallsyms.c          |   5 +-
 kernel/kallsyms_selftest.c |   6 +--
 kernel/livepatch/core.c    |  13 +----
 kernel/module/kallsyms.c   |  16 ++++--
 kernel/trace/bpf_trace.c   | 101 +++++++++++++++----------------------
 kernel/trace/ftrace.c      |   5 +-
 8 files changed, 67 insertions(+), 90 deletions(-)

-- 
2.25.1

