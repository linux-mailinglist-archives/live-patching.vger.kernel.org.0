Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDA3612F26
	for <lists+live-patching@lfdr.de>; Mon, 31 Oct 2022 03:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiJaCzI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 30 Oct 2022 22:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiJaCzH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 30 Oct 2022 22:55:07 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA9D6564;
        Sun, 30 Oct 2022 19:55:03 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N0yN25sj5zpW2f;
        Mon, 31 Oct 2022 10:51:30 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 10:55:01 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 10:55:00 +0800
Subject: Re: [PATCH v7 00/11] kallsyms: Optimizes the performance of lookup
 symbols
To:     David Laight <David.Laight@ACULAB.COM>,
        Luis Chamberlain <mcgrof@kernel.org>
CC:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
References: <20221017064950.2038-1-thunder.leizhen@huawei.com>
 <Y0/nEngJF6bbINEx@bombadil.infradead.org>
 <ad9e51c6-f77d-d9e9-9c13-42fcbbde7147@huawei.com>
 <Y1gisUFzgt1D1Jle@bombadil.infradead.org>
 <77f1c8f0-5e67-0e57-9285-15ba613044fb@huawei.com>
 <Y1mEiIvbld4SX1lx@bombadil.infradead.org>
 <4f06547b-456f-e1ec-c535-16577f502ff1@huawei.com>
 <d7393d45-84bb-9e7b-99f4-412eb9223208@huawei.com>
 <712fae84-aadc-7d29-f311-a3352bab6346@huawei.com>
 <9e4892b540584b25aa5481cc40f1fb42@AcuMS.aculab.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <842f626a-6d87-72c0-49ed-d66c1ad9534b@huawei.com>
Date:   Mon, 31 Oct 2022 10:55:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <9e4892b540584b25aa5481cc40f1fb42@AcuMS.aculab.com>
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



On 2022/10/29 20:49, David Laight wrote:
>>>> On 2022/10/27 3:03, Luis Chamberlain wrote:
>>>>> On Wed, Oct 26, 2022 at 02:44:36PM +0800, Leizhen (ThunderTown) wrote:
>>>>>> On 2022/10/26 1:53, Luis Chamberlain wrote:
>>>>>>> This answers how we don't use a hash table, the question was *should* we
>>>>>>> use one?
> 
> (Probably brainfart) thought...
> 
> Is the current table (effectively) a sorted list of strings?
> So the lookup is a binary chop - so O(log(n)).

Currently not sorted.

> 
> But your hashes are having 'trouble' stopping one chain
> being very long?
> So a linear search of that hash chain is slow.
> In fact that sort of hashed lookup in O(n).

You've analyzed it very well. The hash method is not good for sorting names
and then searching in binary mode. I figured it out when I was working on
the design these days.

Current Implementation:
---------------------------------------
| idx | addresses | markers |  names  |
---------------------------------------
|  0  |    addr0  |         |  name0  |
|  1  |    addr1  |         |  name1  |
| ... |    addrx  |   [0]   |  namex  |
| 255 |    addrx  |         |  name255|
---------------------------------------
| 256 |  addr256  |         |  name256|
| ... |    addrx  |   [1]   |  namex  |
| 511 |  addr511  |         |  name511|
---------------------------------------

markers[0] = offset_of(name0)
markers[1] = offset_of(name256)

1. Find name by address
   binary search addresses[], get idx, traverse names[] from  markers[idx>>8] to markers[(idx>>8) + 1], return name

2. Find address by name
   traverse names[], get idx, return addresses[idx]

Hash Implementation:
Add two new arrays: hash_table[] and names_offsets[]

-----------------------------------------------------------------
| key |      hash_table       |         names_offsets           |
|---------------------------------------------------------------|
|  0  |  names_offsets[key=0] | offsets of all names with key=0 |
|  1  |  names_offsets[key=1] | offsets of all names with key=1 |
| ... |          ...          | offsets of all names with key=k |
|---------------------------------------------------------------|

hash_table[0] = 0
hash_table[1] = hash_table[0] + sizeof(names_offsets[0]) * number_of_names(key=0)
hash_table[2] = hash_table[1] + sizeof(names_offsets[0]) * number_of_names(key=1)

1. Find address by name
   hash name, get key, traverse names_offsets[] from index=hash_table[key] to
   index=hash_table[key+1], get the offset of name in names[]. binary search markers[],
   get index, then traverse names[] from  markers[index] to markers[index + 1], until
   match the offset of name, return addresses[idx].
2. Find address by name
   No change.

Sorted names Implementation:
Add two new arrays: offsets_of_addr_to_name[] and offsets_of_name[]

offsets_of_addr_to_name[i] = offset of name i in names[]
offsets_of_name[i]         = offset of sorted name i in names[]

1. Find name by address
   binary search addresses[], get idx, return names[offsets_of_addr_to_name[idx]]

2. Find address by name
   binary search offsets_of_name[], get idx, return addresses[idx]

> 
> What if the symbols were sorted by hash then name?
> (Without putting the hash into each entry.)
> Then the code could do a binary chop search over
> the symbols with the same hash value.
> The additional data is then an array of symbol numbers
> indexed by the hash - 32 bits for each bucket.
> 
> If the hash table has 0x1000 entries it saves 12 compares.
> (All of which are likely to be data cache misses.)
> 
> If you add the hash to each table entry then you can do
> a binary chop search for the hash itself.
> While this is the same search as is done for the strings
> the comparison (just a number) will be faster than a
> string compare.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

-- 
Regards,
  Zhen Lei
