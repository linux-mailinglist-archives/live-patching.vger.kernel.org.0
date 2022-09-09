Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43A55B2B6A
	for <lists+live-patching@lfdr.de>; Fri,  9 Sep 2022 03:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiIIBRq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 8 Sep 2022 21:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiIIBRp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 8 Sep 2022 21:17:45 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F17E1098EF;
        Thu,  8 Sep 2022 18:17:44 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MNyfb0P30zZcl8;
        Fri,  9 Sep 2022 09:13:11 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 9 Sep 2022 09:17:41 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 9 Sep 2022 09:17:40 +0800
Subject: Re: [PATCH 0/7] kallsyms: Optimizes the performance of lookup symbols
To:     Luis Chamberlain <mcgrof@kernel.org>
CC:     Josh Poimboeuf <jpoimboe@kernel.org>,
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
        <linux-modules@vger.kernel.org>
References: <20220908130936.674-1-thunder.leizhen@huawei.com>
 <YxqDyyVwVUnqc8B1@bombadil.infradead.org>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <0e662541-baf8-1074-06bd-1398bdf7c2a7@huawei.com>
Date:   Fri, 9 Sep 2022 09:17:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <YxqDyyVwVUnqc8B1@bombadil.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2022/9/9 8:07, Luis Chamberlain wrote:
> On Thu, Sep 08, 2022 at 09:09:29PM +0800, Zhen Lei wrote:
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
> 
> WIthout having time yet to reveiw the implementation details, it would
> seem this is an area we may want to test for future improvements easily,
> so a selftest better yet a kunit test may be nice for this. Can you
> write one so we can easily gather a simple metric for "how long does
> this take"?

Good advice. I'll write it today.

> 
>   Luis
> .
> 

-- 
Regards,
  Zhen Lei
