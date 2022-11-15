Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2D4629380
	for <lists+live-patching@lfdr.de>; Tue, 15 Nov 2022 09:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbiKOIoF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Nov 2022 03:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbiKOIoD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Nov 2022 03:44:03 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C72F12091;
        Tue, 15 Nov 2022 00:44:01 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NBKPS5bH9zqSQQ;
        Tue, 15 Nov 2022 16:40:12 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 16:43:59 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 16:43:58 +0800
Subject: Re: [PATCH v9] kallsyms: Add self-test facility
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
CC:     David Laight <David.Laight@ACULAB.COM>
References: <20221115083349.1662-1-thunder.leizhen@huawei.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <f21eb27b-4c7f-5136-85ab-61a8ca762496@huawei.com>
Date:   Tue, 15 Nov 2022 16:43:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20221115083349.1662-1-thunder.leizhen@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2022/11/15 16:33, Zhen Lei wrote:
> Added test cases for basic functions and performance of functions
> kallsyms_lookup_name(), kallsyms_on_each_symbol() and
> kallsyms_on_each_match_symbol(). It also calculates the compression rate
> of the kallsyms compression algorithm for the current symbol set.
> 
> The basic functions test begins by testing a set of symbols whose address
> values are known. Then, traverse all symbol addresses and find the
> corresponding symbol name based on the address. It's impossible to
> determine whether these addresses are correct, but we can use the above
> three functions along with the addresses to test each other. Due to the
> traversal operation of kallsyms_on_each_symbol() is too slow, only 60
> symbols can be tested in one second, so let it test on average once
> every 128 symbols. The other two functions validate all symbols.
> 
> If the basic functions test is passed, print only performance test
> results. If the test fails, print error information, but do not perform
> subsequent performance tests.
> 
> Start self-test automatically after system startup if
> CONFIG_KALLSYMS_SELFTEST=y.
> 
> Example of output content: (prefix 'kallsyms_selftest:' is omitted
>  start
>   ---------------------------------------------------------
>  | nr_symbols | compressed size | original size | ratio(%) |
>  |---------------------------------------------------------|
>  |     107543 |       1357912   |      2407433  |  56.40   |
>   ---------------------------------------------------------
>  kallsyms_lookup_name() looked up 107543 symbols
>  The time spent on each symbol is (ns): min=630, max=35295, avg=7353
>  kallsyms_on_each_symbol() traverse all: 11782628 ns
>  kallsyms_on_each_match_symbol() traverse all: 9261 ns
>  finish
> 
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  include/linux/kallsyms.h   |   1 +
>  init/Kconfig               |  13 +
>  kernel/Makefile            |   1 +
>  kernel/kallsyms.c          |   2 +-
>  kernel/kallsyms_selftest.c | 485 +++++++++++++++++++++++++++++++++++++
>  kernel/kallsyms_selftest.h |  13 +
>  6 files changed, 514 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/kallsyms_selftest.c
>  create mode 100644 kernel/kallsyms_selftest.h

v8 --> v9:
[v8] https://lkml.org/lkml/2022/11/2/225

Adjust the prototype of some callback functions. Because 7/9 and 8/9
in v8 are dropped.

-- 
Regards,
  Zhen Lei
