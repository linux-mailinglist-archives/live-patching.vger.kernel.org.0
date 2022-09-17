Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821CB5BB842
	for <lists+live-patching@lfdr.de>; Sat, 17 Sep 2022 14:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiIQMlH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 17 Sep 2022 08:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiIQMlG (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 17 Sep 2022 08:41:06 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE4D32A84;
        Sat, 17 Sep 2022 05:41:04 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MV9V83vYGzHnX2;
        Sat, 17 Sep 2022 20:38:56 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 17 Sep 2022 20:41:01 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 17 Sep 2022 20:41:01 +0800
Subject: Re: [PATCH v2 8/8] kallsyms: Add self-test facility
To:     Kees Cook <keescook@chromium.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Masahiro Yamada" <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Luis Chamberlain" <mcgrof@kernel.org>,
        <linux-modules@vger.kernel.org>
References: <20220909130016.727-1-thunder.leizhen@huawei.com>
 <20220909130016.727-9-thunder.leizhen@huawei.com>
 <C889CF38-A80A-4DF6-9648-3B8947494CBC@chromium.org>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <dab5fc68-0ac5-306a-bd81-0165f3b741ec@huawei.com>
Date:   Sat, 17 Sep 2022 20:40:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <C889CF38-A80A-4DF6-9648-3B8947494CBC@chromium.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2022/9/17 16:07, Kees Cook wrote:
> 
> 
> On September 9, 2022 2:00:16 PM GMT+01:00, Zhen Lei <thunder.leizhen@huawei.com> wrote:
>> Add some test cases to test the function and performance of some kallsyms
>> interfaces, such as kallsyms_lookup_name. It also calculates the
>> compression rate of the kallsyms compression algorithm for the current
>> symbol set.
>>
>> Start self-test automatically after system startup.

if CONFIG_KALLSYMS_SELFTEST=y

> 
> I wonder if this would be better implemented as a kunit test? Shouldn't be too hard to convert. Take a look at things like lib/overflow_kunit.c, etc.

Yes, I can try to define one for each type of symbol, such as: bss, data, weak, static.
In addition, we can use kallsyms_offsets[] to do a full test.

> 
> -Kees
> 

-- 
Regards,
  Zhen Lei
