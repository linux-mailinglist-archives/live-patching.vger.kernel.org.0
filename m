Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEDE5BA513
	for <lists+live-patching@lfdr.de>; Fri, 16 Sep 2022 05:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiIPDR1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 15 Sep 2022 23:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiIPDRX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 15 Sep 2022 23:17:23 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A1341999;
        Thu, 15 Sep 2022 20:17:20 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MTK0B6mtJzmVQv;
        Fri, 16 Sep 2022 11:13:30 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 16 Sep 2022 11:17:18 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 16 Sep 2022 11:17:17 +0800
Subject: Re: [PATCH v2 0/8] kallsyms: Optimizes the performance of lookup
 symbols
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
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
References: <20220909130016.727-1-thunder.leizhen@huawei.com>
 <453a0f71-7478-f118-d547-aa0547abdd73@huawei.com>
Message-ID: <f7ee24c4-3d36-90df-20b3-9663364844c7@huawei.com>
Date:   Fri, 16 Sep 2022 11:17:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <453a0f71-7478-f118-d547-aa0547abdd73@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2022/9/16 9:27, Leizhen (ThunderTown) wrote:
> Hi, everybody:
>   Can anyone review it? Maybe I should split this patch series
> into two parts: kallsyms and livepatch.
>   In fact, the performance can be improved even if the compression policy
> of the symbol type is not changed, that is, the scripts/callsyms.c file is
> not modified, but we perform the len-based filtering first. That way, it'll
> be easier for everyone to review. OK, I'm ready for v3.

Sorry, I didn't sleep well yesterday. The length is the length of the
compressed string. Therefore, the solution is not feasible.

> 
> 
> On 2022/9/9 21:00, Zhen Lei wrote:
>> v1 --> v2:
>> Add self-test facility
>>
>> v1:
>> Currently, to search for a symbol, we need to expand the symbols in
>> 'kallsyms_names' one by one, and then use the expanded string for
>> comparison. This is very slow.
>>
>> In fact, we can first compress the name being looked up and then use
>> it for comparison when traversing 'kallsyms_names'.
>>
>> This patch series optimizes the performance of function kallsyms_lookup_name(),
>> and function klp_find_object_symbol() in the livepatch module. Based on the
>> test results, the performance overhead is reduced to 5%. That is, the
>> performance of these functions is improved by 20 times.
>>
>> To avoid increasing the kernel size in non-debug mode, the optimization is only
>> for the case CONFIG_KALLSYMS_ALL=y.
>>
>> Zhen Lei (8):
>>   scripts/kallsyms: don't compress symbol type when
>>     CONFIG_KALLSYMS_ALL=y
>>   scripts/kallsyms: rename build_initial_tok_table()
>>   kallsyms: Adjust the types of some local variables
>>   kallsyms: Improve the performance of kallsyms_lookup_name()
>>   kallsyms: Add helper kallsyms_on_each_match_symbol()
>>   livepatch: Use kallsyms_on_each_match_symbol() to improve performance
>>   livepatch: Improve the search performance of
>>     module_kallsyms_on_each_symbol()
>>   kallsyms: Add self-test facility
>>
>>  include/linux/kallsyms.h   |   8 ++
>>  init/Kconfig               |  13 ++
>>  kernel/Makefile            |   1 +
>>  kernel/kallsyms.c          | 135 ++++++++++++++++++++-
>>  kernel/kallsyms_selftest.c | 243 +++++++++++++++++++++++++++++++++++++
>>  kernel/livepatch/core.c    |  25 +++-
>>  kernel/module/kallsyms.c   |  13 +-
>>  scripts/kallsyms.c         |  19 ++-
>>  8 files changed, 441 insertions(+), 16 deletions(-)
>>  create mode 100644 kernel/kallsyms_selftest.c
>>
> 

-- 
Regards,
  Zhen Lei
