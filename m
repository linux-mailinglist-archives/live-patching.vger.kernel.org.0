Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B575A9951
	for <lists+live-patching@lfdr.de>; Thu,  1 Sep 2022 15:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbiIANpl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Sep 2022 09:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbiIANpk (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Sep 2022 09:45:40 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C16D78;
        Thu,  1 Sep 2022 06:45:33 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MJMgW4MFdznTs2;
        Thu,  1 Sep 2022 21:43:03 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 1 Sep 2022 21:45:31 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 1 Sep 2022 21:45:30 +0800
Subject: Re: [PATCH] livepatch: Move error print out of lock protection in
 klp_enable_patch()
To:     Joe Lawrence <joe.lawrence@redhat.com>
CC:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, <linux-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>
References: <20220901022706.813-1-thunder.leizhen@huawei.com>
 <65fe1978-60da-5bd4-9559-fddec13f03bf@redhat.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <19e0d24c-366a-a269-8c4d-bf32831e2079@huawei.com>
Date:   Thu, 1 Sep 2022 21:45:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <65fe1978-60da-5bd4-9559-fddec13f03bf@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2022/9/1 21:24, Joe Lawrence wrote:
> On 8/31/22 10:27 PM, Zhen Lei wrote:
>> The patch->mod is not a protected object of mutex_lock(&klp_mutex). Since
>> it's in the error handling branch, it might not be helpful to reduce lock
>> conflicts, but it can reduce some code size.
>>
>> Before:
>>    text    data     bss     dec     hex filename
>>   10330     464       8   10802    2a32 kernel/livepatch/core.o
>>
>> After:
>>    text    data     bss     dec     hex filename
>>   10307     464       8   10779    2a1b kernel/livepatch/core.o
>>
> 
> Is a size change expected, or is it just compiler fall out from
> shuffling the code around a little bit?

I thought it was because mutex_lock()/mutex_unlock() was close enough to
reduce a "&klp_mutex" operation. Now, I was wrong.

> 
> I see some arches do a little better, some a little worse with gcc-9.3.0
> cross compilers:

Sorry. This is what I should have done. I built it on x86_64 with gcc-8.4.0

> 
> Before
> ------
>    text    data     bss     dec     hex filename
>    8490     600       8    9098    238a arm64/kernel/livepatch/core.o
>    9424     680       8   10112    2780 s390/kernel/livepatch/core.o
>    9802     228       4   10034    2732 ppc32/kernel/livepatch/core.o
>   13746     456       8   14210    3782 ppc64le/kernel/livepatch/core.o
>   10443     464       8   10915    2aa3 x86_64/kernel/livepatch/core.o
> 
> 
> After
> -----
>    text    data     bss     dec     hex filename
>    8514     600       8    9122    23a2 arm64/kernel/livepatch/core.o
>    9424     680       8   10112    2780 s390/kernel/livepatch/core.o
>    9818     228       4   10050    2742 ppc32/kernel/livepatch/core.o
>   13762     456       8   14226    3792 ppc64le/kernel/livepatch/core.o
>   10446     464       8   10918    2aa6 x86_64/kernel/livepatch/core.o
> 
> In which case, I'd just omit the size savings from the commit msg.

OK. Should I send v2 to update commit message?

> 
>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
>> ---
>>  kernel/livepatch/core.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>> index 42f7e716d56bf72..cb7abc821a50584 100644
>> --- a/kernel/livepatch/core.c
>> +++ b/kernel/livepatch/core.c
>> @@ -1041,9 +1041,9 @@ int klp_enable_patch(struct klp_patch *patch)
>>  	mutex_lock(&klp_mutex);
>>  
>>  	if (!klp_is_patch_compatible(patch)) {
>> +		mutex_unlock(&klp_mutex);
>>  		pr_err("Livepatch patch (%s) is not compatible with the already installed livepatches.\n",
>>  			patch->mod->name);
>> -		mutex_unlock(&klp_mutex);
>>  		return -EINVAL;
>>  	}
>>  
>>
> 
> That said, I don't see anything obviously wrong about the change (we
> don't need to sync our error msgs, right?) so:

Yes

> 
> Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

Thanks

> 

-- 
Regards,
  Zhen Lei
