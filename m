Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE0560DB8A
	for <lists+live-patching@lfdr.de>; Wed, 26 Oct 2022 08:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbiJZGo7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 26 Oct 2022 02:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbiJZGox (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 26 Oct 2022 02:44:53 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942291A047;
        Tue, 25 Oct 2022 23:44:50 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MxzkL1NrmzJnGN;
        Wed, 26 Oct 2022 14:42:02 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 14:44:48 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 14:44:47 +0800
Subject: Re: [PATCH v7 00/11] kallsyms: Optimizes the performance of lookup
 symbols
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
        <linux-modules@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Ingo Molnar" <mingo@redhat.com>
References: <20221017064950.2038-1-thunder.leizhen@huawei.com>
 <Y0/nEngJF6bbINEx@bombadil.infradead.org>
 <ad9e51c6-f77d-d9e9-9c13-42fcbbde7147@huawei.com>
 <Y1gisUFzgt1D1Jle@bombadil.infradead.org>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <77f1c8f0-5e67-0e57-9285-15ba613044fb@huawei.com>
Date:   Wed, 26 Oct 2022 14:44:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <Y1gisUFzgt1D1Jle@bombadil.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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



On 2022/10/26 1:53, Luis Chamberlain wrote:
> On Wed, Oct 19, 2022 at 10:11:58PM +0800, Leizhen (ThunderTown) wrote:
>>
>>
>> On 2022/10/19 20:01, Luis Chamberlain wrote:
>>> On Mon, Oct 17, 2022 at 02:49:39PM +0800, Zhen Lei wrote:
>>>> Currently, to search for a symbol, we need to expand the symbols in
>>>> 'kallsyms_names' one by one, and then use the expanded string for
>>>> comparison. This is very slow.
>>>>
>>>> In fact, we can first compress the name being looked up and then use
>>>> it for comparison when traversing 'kallsyms_names'.
>>>>
>>>> This patch series optimizes the performance of function kallsyms_lookup_name(),
>>>> and function klp_find_object_symbol() in the livepatch module. Based on the
>>>> test results, the performance overhead is reduced to 5%. That is, the
>>>> performance of these functions is improved by 20 times.
>>>
>>> Stupid question, is a hash table in order?
>>
>> No hash table.
>>
>> All symbols are arranged in ascending order of address. For example: cat /proc/kallsyms
>>
>> The addresses of all symbols are stored in kallsyms_addresses[], and names of all symbols
>> are stored in kallsyms_names[]. The elements in these two arrays are in a one-to-one
>> relationship. For any symbol, it has the same index in both arrays.
>>
>> Therefore, when we look up a symbolic name based on an address, we use a binary lookup.
>> However, when we look up an address based on a symbol name, we can only traverse array
>> kallsyms_names[] in sequence. I think the reason why hash is not used is to save memory.
> 
> This answers how we don't use a hash table, the question was *should* we
> use one?

I'm not the original author, and I can only answer now based on my understanding. Maybe
the original author didn't think of the hash method, or he has weighed it out.

Hash is a good solution if only performance is required and memory overhead is not
considered. Using hash will increase the memory size by up to "4 * kallsyms_num_syms +
4 * ARRAY_SIZE(hashtable)" bytes, kallsyms_num_syms is about 1-2 million.

Because I don't know what hash algorithm will be used, the cost of generating the
hash value corresponding to the symbol name is unknown now. But I think it's gonna
be small. But it definitely needs a simpler algorithm, the tool needs to implement
the same hash algorithm.

If the hash is not very uniform or ARRAY_SIZE(hashtable) is small, then my current
approach still makes sense. So maybe hash can be deferred to the next phase of
improvement.

> 
>   Luis
> .
> 

-- 
Regards,
  Zhen Lei
