Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88DF5AC879
	for <lists+live-patching@lfdr.de>; Mon,  5 Sep 2022 03:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbiIEBUI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 4 Sep 2022 21:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiIEBUH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 4 Sep 2022 21:20:07 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF98E55;
        Sun,  4 Sep 2022 18:20:04 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MLVv96XGZzZc9x;
        Mon,  5 Sep 2022 09:15:33 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 5 Sep 2022 09:20:01 +0800
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 5 Sep 2022 09:20:01 +0800
Subject: Re: [PATCH] livepatch: Move error print out of lock protection in
 klp_enable_patch()
To:     Petr Mladek <pmladek@suse.com>
CC:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220901022706.813-1-thunder.leizhen@huawei.com>
 <YxC/L+fKInPWJPdy@alley> <c1f6c6ec-2681-8d7a-506a-4da72a963ce8@huawei.com>
 <20220902133628.GA29761@pathway.suse.cz>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <c5504552-dc31-2dc5-97a1-b08927900992@huawei.com>
Date:   Mon, 5 Sep 2022 09:20:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20220902133628.GA29761@pathway.suse.cz>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2022/9/2 21:36, Petr Mladek wrote:
> On Fri 2022-09-02 09:28:59, Leizhen (ThunderTown) wrote:
>>>> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>>>> index 42f7e716d56bf72..cb7abc821a50584 100644
>>>> --- a/kernel/livepatch/core.c
>>>> +++ b/kernel/livepatch/core.c
>>>> @@ -1041,9 +1041,9 @@ int klp_enable_patch(struct klp_patch *patch)
>>>>  	mutex_lock(&klp_mutex);
>>>>  
>>>>  	if (!klp_is_patch_compatible(patch)) {
>>>> +		mutex_unlock(&klp_mutex);
>>>>  		pr_err("Livepatch patch (%s) is not compatible with the already installed livepatches.\n",
>>>>  			patch->mod->name);
>>>> -		mutex_unlock(&klp_mutex);
>>>
>>> I do not see how this change could reliably reduce the code size.
>>>
>>> As Joe wrote, it looks like a random effect that is specific to a
>>> particular compiler version, compilation options, and architecture.
>>>
>>> I am against these kind of random microptimizations. It is just a call
>>> for problems. If you move printk() outside of a lock, you need to make
>>> sure that the information is not racy.
>>
>> OK.
>>
>> 	mutex_lock(&klp_mutex);
>>         if (!klp_is_patch_compatible(patch)) {
>>                 mutex_unlock(&klp_mutex);
>> 			<--------- Do you mean the incompatible patches maybe disabled at this point?
> 
> This particular change is safe in the current design.
> klp_enable_patch() is called from the module_init() callback
> where patch->mod->name is defined. So it can't change.
> 
> The problem is that it is not obvious that it is safe. One has to
> think about it. Also it might become dangerous when someone
> tries to call klp_enable_livepatch() for another livepatch module.

OK, I got it, thanks.

> 
>>                 pr_err("Livepatch patch (%s) ...\n", patch->mod->name);
>>                 return -EINVAL;
>>         }
>>
>>>
>>> It might be safe in this particular case. But it is a bad practice.
>>> It adds an extra work. It is error-prone with questionable gain.
>>>
>>> I am sorry but I NACK this patch. There must be better ways to
>>
>> OK
> 
> Thanks for understanding.
> 
> Best Regards,
> Petr
> .
> 

-- 
Regards,
  Zhen Lei
