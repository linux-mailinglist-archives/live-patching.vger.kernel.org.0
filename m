Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31CCF612F8F
	for <lists+live-patching@lfdr.de>; Mon, 31 Oct 2022 05:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiJaE4I (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 31 Oct 2022 00:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiJaE4H (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 31 Oct 2022 00:56:07 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F35115D;
        Sun, 30 Oct 2022 21:56:03 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N112340HHzVjL5;
        Mon, 31 Oct 2022 12:51:07 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 12:56:01 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 12:56:01 +0800
Subject: Re: [PATCH v7 00/11] kallsyms: Optimizes the performance of lookup
 symbols
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
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
 <77f1c8f0-5e67-0e57-9285-15ba613044fb@huawei.com>
 <Y1mEiIvbld4SX1lx@bombadil.infradead.org>
 <4f06547b-456f-e1ec-c535-16577f502ff1@huawei.com>
 <d7393d45-84bb-9e7b-99f4-412eb9223208@huawei.com>
 <712fae84-aadc-7d29-f311-a3352bab6346@huawei.com>
Message-ID: <b7215b83-11ab-6db6-bd7f-9729725eaaeb@huawei.com>
Date:   Mon, 31 Oct 2022 12:55:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <712fae84-aadc-7d29-f311-a3352bab6346@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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



On 2022/10/29 16:10, Leizhen (ThunderTown) wrote:
> 
> 
> On 2022/10/27 14:27, Leizhen (ThunderTown) wrote:
>>
>>
>> On 2022/10/27 11:26, Leizhen (ThunderTown) wrote:
>>>
>>>
>>> On 2022/10/27 3:03, Luis Chamberlain wrote:
>>>> On Wed, Oct 26, 2022 at 02:44:36PM +0800, Leizhen (ThunderTown) wrote:
>>>>> On 2022/10/26 1:53, Luis Chamberlain wrote:
>>>>>> This answers how we don't use a hash table, the question was *should* we
>>>>>> use one?
>>>>>
>>>>> I'm not the original author, and I can only answer now based on my understanding. Maybe
>>>>> the original author didn't think of the hash method, or he has weighed it out.
>>>>>
>>>>> Hash is a good solution if only performance is required and memory overhead is not
>>>>> considered. Using hash will increase the memory size by up to "4 * kallsyms_num_syms +
>>>>> 4 * ARRAY_SIZE(hashtable)" bytes, kallsyms_num_syms is about 1-2 million.
>>
>> Sorry, 1-2 million ==> 0.1~0.2 million
>>
>>>>>
>>>>> Because I don't know what hash algorithm will be used, the cost of generating the
>>>>> hash value corresponding to the symbol name is unknown now. But I think it's gonna
>>>>> be small. But it definitely needs a simpler algorithm, the tool needs to implement
>>>>> the same hash algorithm.
>>>>
>>>> For instance, you can look at evaluating if alloc_large_system_hash() would help.
>>>
> 
> The following three hash algorithms are compared. The kernel is compiled by defconfig
> on arm64.
> 
> |---------------------------------------------------------------------------------------|
> |                           |             hash &= HASH_TABLE_SIZE - 1                   |
> |                           |             number of conflicts >= 1000                   |
> |---------------------------------------------------------------------------------------|
> |   ARRAY_SIZE(hash_table)  |       crc16        | jhash_one_at_a_time | string hash_32 |
> |---------------------------------------------------------------------------------------|
> |                           |     345b: 3905     |     0d40: 1013      |   4a4c: 6548   |
> |                           |     35bb: 1016     |     35ce: 6549      |   883a: 1015   |
> |        0x10000            |     385b: 6548     |     4440: 19126     |   d05f: 19129  |
> |                           |     f0ba: 19127    |     7ebe: 3916      |   ecda: 3903   |
> |---------------------------------------------------------------------------------------|
> |                           |      0ba: 19168    |      440: 19165     |    05f: 19170  |
> |                           |      45b: 3955     |      5ce: 6577      |    83a: 1066   |
> |        0x1000             |      5bb: 1069     |      d40: 1052      |    a4c: 6609   |
> |                           |      85b: 6582     |      ebe: 3938      |    cda: 3924   |
> |---------------------------------------------------------------------------------------|
> 
> Based on the above test results, I conclude that:
> 1. For the worst-case scenario, the three algorithms are not much different. But the kernel
>    only implements crc16 and string hash_32. The latter is not processed byte-by-byte, so
>    it is coupled with byte order and sizeof(long). So crc16 is the best choice.
> 2. For the worst-case scenario, there are almost 19K strings are mapped to the same hash
>    value，just over 1/10 of the total. And with my current compression-then-comparison
>    approach, it's 25-30 times faster. So there's still a need for my current approach, and
>    they can be combined.
>    if (nr_conflicts(key) >= CONST_N) {
>        newname = compress(name);
>        for_each_name_in_slot(key): compare(new_name)
>    } else {
>        for_each_name_in_slot(key): compare(name)
>    }
> 
>    Above CONST_N can be roughly calculated:
>    time_of_compress(name) + N * time_of_compare(new_name) <= N * time_of_compare(name)
> 3. For the worst-case scenario, there is no obvious difference between ARRAY_SIZE(hash_table)
>    0x10000 and 0x1000. So ARRAY_SIZE(hash_table)=0x1000 is enough.
>    Statistic information:
>    |------------------------------------------------------|
>    |   nr_conflicts(key)  |     ARRAY_SIZE(hash_table)    |
>    |------------------------------------------------------|
>    |         <= ?         |     0x1000    |    0x10000    |
>    |------------------------------------------------------|
>    |             0        |         0     |      7821     |
>    |            20        |        19     |     57375     |
>    |            40        |      2419     |       124     |
>    |            60        |      1343     |        70     |
>    |            80        |       149     |        73     |
>    |           100        |        38     |        49     |
>    |           200        |       108     |        16     |
>    |           400        |        14     |         2     |
>    |           600        |         2     |         2     |
>    |           800        |         0     |         0     |
>    |          1000        |         0     |         0     |
>    |        100000        |         4     |         4     |
>    |------------------------------------------------------|
> 
> 
> Also, I re-calculated:
> Using hash will increase the memory size by up to "6 * kallsyms_num_syms + 4 * ARRAY_SIZE(hashtable)"
>                                                    |---- What I said earlier was 4
> The increased size is close to 1 MB if CONFIG_KALLSYMS_ALL=y.
> 
> Hi, Luis:
>   For the reasons of the above-mentioned second conclusion. And except for patches 4-6,
> even if only the hash method is used, other patches and option "--lto-clang" in patch 6/11
> are also needed. If you don't mind, I'd like to use hash at the next stage. The current
> patch set is already huge.

I just had an update in response to David Laight's email. The hash solution is like
a centrist. It doesn't seem very feasible.

Now, we need to make a decision. Choose one of the two:
1. Continue with my current approach. Improve the average performance of
   kallsyms_lookup_name() by 20 to 30 times. The memory overhead is increased by:
   arm64 (defconfig):
     73.5KiB and 4.0% if CONFIG_KALLSYMS_ALL=y.
     19.8KiB and 2.8% if CONFIG_KALLSYMS_ALL=n.
   x86 (defconfig):
     49.0KiB and 3.0% if CONFIG_KALLSYMS_ALL=y.
     16.8KiB and 2.3% if CONFIG_KALLSYMS_ALL=n.
2. Sort names, binary search (The static function causes duplicate names. Additional work is required）
   2^18=262144, only up to 18 symbol expansions and comparisons are required.
   The performance is definitely excellent, although I haven't tested it yet.
   The memory overhead is increased by: 6 * kallsyms_num_syms
   arm64 (defconfig):
       1MiB if CONFIG_KALLSYMS_ALL=y.
     362KiB if CONFIG_KALLSYMS_ALL=n.
   x86 (defconfig):
     770KiB if CONFIG_KALLSYMS_ALL=y.
     356KiB if CONFIG_KALLSYMS_ALL=n.




> 
> 
>>> OK, I found the right hash function. In this way, the tool does not need to consider
>>> the byte order.
>>
>> https://en.wikipedia.org/wiki/Jenkins_hash_function
>>
>> Let's go with jenkins_one_at_a_time_hash(), which looks simpler and doesn't even
>> have to think about sizeof(long). It seems to be closest to our current needs.
>>
>> uint32_t jenkins_one_at_a_time_hash(const uint8_t* key, size_t length) {
>> 	size_t i = 0;
>> 	uint32_t hash = 0;
>>
>> 	while (i != length) {
>> 		hash += key[i++];
>> 		hash += hash << 10;
>> 		hash ^= hash >> 6;
>> 	}
>> 	hash += hash << 3;
>> 	hash ^= hash >> 11;
>> 	hash += hash << 15;
>>
>> 	return hash;
>> }
>>
>>>
>>> include/linux/stringhash.h
>>>
>>> /*
>>>  * Version 1: one byte at a time.  Example of use:
>>>  *
>>>  * unsigned long hash = init_name_hash;
>>>  * while (*p)
>>>  *      hash = partial_name_hash(tolower(*p++), hash);
>>>  * hash = end_name_hash(hash);
>>>
>>>
>>>>
>>>>   Luis
>>>> .
>>>>
>>>
>>
> 

-- 
Regards,
  Zhen Lei
