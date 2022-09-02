Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E74F5AA50A
	for <lists+live-patching@lfdr.de>; Fri,  2 Sep 2022 03:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbiIBB3F (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Sep 2022 21:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbiIBB3F (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Sep 2022 21:29:05 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3461479605;
        Thu,  1 Sep 2022 18:29:03 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MJgHz6Y4vzHnZW;
        Fri,  2 Sep 2022 09:27:11 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 2 Sep 2022 09:29:00 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 2 Sep 2022 09:29:00 +0800
Subject: Re: [PATCH] livepatch: Move error print out of lock protection in
 klp_enable_patch()
To:     Petr Mladek <pmladek@suse.com>
CC:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220901022706.813-1-thunder.leizhen@huawei.com>
 <YxC/L+fKInPWJPdy@alley>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <c1f6c6ec-2681-8d7a-506a-4da72a963ce8@huawei.com>
Date:   Fri, 2 Sep 2022 09:28:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <YxC/L+fKInPWJPdy@alley>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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



On 2022/9/1 22:18, Petr Mladek wrote:
> On Thu 2022-09-01 10:27:06, Zhen Lei wrote:
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
> 
> Please, is this part of some longterm effort to reduce the size of
> the kernel? Or is this just some random observation?
> 
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
> 
> I do not see how this change could reliably reduce the code size.
> 
> As Joe wrote, it looks like a random effect that is specific to a
> particular compiler version, compilation options, and architecture.
> 
> I am against these kind of random microptimizations. It is just a call
> for problems. If you move printk() outside of a lock, you need to make
> sure that the information is not racy.

OK.

	mutex_lock(&klp_mutex);
        if (!klp_is_patch_compatible(patch)) {
                mutex_unlock(&klp_mutex);
			<--------- Do you mean the incompatible patches maybe disabled at this point?
                pr_err("Livepatch patch (%s) ...\n", patch->mod->name);
                return -EINVAL;
        }

> 
> It might be safe in this particular case. But it is a bad practice.
> It adds an extra work. It is error-prone with questionable gain.
> 
> I am sorry but I NACK this patch. There must be better ways to

OK

> reduce the kernel binary size.
> 
> Best Regards,
> Petr
> .
> 

-- 
Regards,
  Zhen Lei
