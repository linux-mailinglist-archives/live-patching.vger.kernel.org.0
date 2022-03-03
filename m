Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280844CC1D4
	for <lists+live-patching@lfdr.de>; Thu,  3 Mar 2022 16:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234671AbiCCPoK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 3 Mar 2022 10:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbiCCPoJ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 3 Mar 2022 10:44:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 94E379FD1
        for <live-patching@vger.kernel.org>; Thu,  3 Mar 2022 07:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646322202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s27HdtG2F+kYjD9zNRAATi4qiD6z55RkiHx0Wy7hg6M=;
        b=LuX+2qdmJpX4zgEPxnkRexB/KKxzQyvXN4nTNd5vz+sN+vUApHj+0/DmXmNlemrNYYtJAF
        kWuIoXr95NOI4IFafLcwfrDOKgOGsmKjzLoQGPgqK1VRzeIu58OiHpsV8KxpXXmNEgxxwF
        m/zdrm+RUMH34hpVk6fDpcn3oBtCcUo=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-GOdDV9phPcSfRyhy0Eg2zg-1; Thu, 03 Mar 2022 10:43:21 -0500
X-MC-Unique: GOdDV9phPcSfRyhy0Eg2zg-1
Received: by mail-qv1-f70.google.com with SMTP id o7-20020a0cfa87000000b004352258d2d1so3975820qvn.10
        for <live-patching@vger.kernel.org>; Thu, 03 Mar 2022 07:43:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s27HdtG2F+kYjD9zNRAATi4qiD6z55RkiHx0Wy7hg6M=;
        b=Qht5P7l1/jUmxSdXoguGdKk8ys78ZJO3dliFaC5c26rSIltFob6LYTBTCevXuWlYbW
         rrcLLEV04qQzPO57ZqXcJJ8J5GNyjHHlyonH3rv8pCS+aRtXsDAfEoLv2E/71c4JOGY2
         2UmT8LI/7DOdHF45r87sRcT45oqzS+acnybhebQJg4iiPCXYdiwE+bhUdSd21pgnMmyw
         4FUMD9Qab+BGtLnaFg2GBq0smlEVBLI5uhIt38KMaxq/9qBEySjtpm3cvdE92Q85nB7R
         yzwwqi21ybDEtqPxXymcqQF3ea1dlz9KrfGRQ9hemzn7akLimQvbu1ZVbpFn51P3Rgmm
         RLgw==
X-Gm-Message-State: AOAM532WgdNM53Cx6yHR4YgpAifQYJMmAtcfBSCv5cayuNBOk4LyP2B+
        Vc9URZ0bPyCHwC4RXmxQi+Dri4PiBZsXexHqFQ0m/d1QApOkYmDVaTt+7TE1dVly6puL8JVln9P
        Jdij7dic1KkJtcU2cBTSm+77r+Q==
X-Received: by 2002:a05:6214:62c:b0:435:1b3d:17e1 with SMTP id a12-20020a056214062c00b004351b3d17e1mr5989414qvx.113.1646322201106;
        Thu, 03 Mar 2022 07:43:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyJ4x1B+q1c6ph1nzGsavaUdqL3Vw9wJh+N9VuBih6K+ZIjq2AOc2qKU9DLJmJXuyzjTtYY8g==
X-Received: by 2002:a05:6214:62c:b0:435:1b3d:17e1 with SMTP id a12-20020a056214062c00b004351b3d17e1mr5989402qvx.113.1646322200848;
        Thu, 03 Mar 2022 07:43:20 -0800 (PST)
Received: from [192.168.1.9] (pool-68-163-101-245.bstnma.fios.verizon.net. [68.163.101.245])
        by smtp.gmail.com with ESMTPSA id c16-20020a05622a059000b002dc93dc92d1sm1777989qtb.48.2022.03.03.07.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 07:43:19 -0800 (PST)
To:     Chengming Zhou <zhouchengming@bytedance.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     jpoimboe@redhat.com, jikos@kernel.org, pmladek@suse.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        songmuchun@bytedance.com, qirui.001@bytedance.com
References: <20220301140840.29345-1-zhouchengming@bytedance.com>
 <alpine.LSU.2.21.2203021052470.5895@pobox.suse.cz>
 <fe2b9225-44c3-2041-f8a3-6f17f9d1be40@bytedance.com>
 <alpine.LSU.2.21.2203030847430.704@pobox.suse.cz>
 <1929669c-7674-035b-8cf1-5b5007ecccec@bytedance.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [External] Re: [PATCH] livepatch: Only block the removal of
 KLP_UNPATCHED forced transition patch
Message-ID: <c1ab3333-7fea-d2d5-272d-850f4c7afb74@redhat.com>
Date:   Thu, 3 Mar 2022 10:43:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1929669c-7674-035b-8cf1-5b5007ecccec@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 3/3/22 5:33 AM, Chengming Zhou wrote:
> On 2022/3/3 3:51 下午, Miroslav Benes wrote:
>> On Thu, 3 Mar 2022, Chengming Zhou wrote:
>>
>>> Hi,
>>>
>>> On 2022/3/2 5:55 下午, Miroslav Benes wrote:
>>>> Hi,
>>>>
>>>> On Tue, 1 Mar 2022, Chengming Zhou wrote:
>>>>
>>>>> module_put() is currently never called for a patch with forced flag, to block
>>>>> the removal of that patch module that might still be in use after a forced
>>>>> transition.
>>>>>
>>>>> But klp_force_transition() will flag all patches on the list to be forced, since
>>>>> commit d67a53720966 ("livepatch: Remove ordering (stacking) of the livepatches")
>>>>> has removed stack ordering of the livepatches, it will cause all other patches can't
>>>>> be unloaded after disabled even if they have completed the KLP_UNPATCHED transition.
>>>>>
>>>>> In fact, we don't need to flag a patch to forced if it's a KLP_PATCHED forced
>>>>> transition. It can still be unloaded only if it has passed through the consistency
>>>>> model in KLP_UNPATCHED transition.
>>>>>
>>>>> So this patch only set forced flag and block the removal of a KLP_UNPATCHED forced
>>>>> transition livepatch.
>>>>>
>>>>> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
>>>>> ---
>>>>>  kernel/livepatch/transition.c | 4 ++--
>>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
>>>>> index 5683ac0d2566..8b296ad9e407 100644
>>>>> --- a/kernel/livepatch/transition.c
>>>>> +++ b/kernel/livepatch/transition.c
>>>>> @@ -641,6 +641,6 @@ void klp_force_transition(void)
>>>>>  	for_each_possible_cpu(cpu)
>>>>>  		klp_update_patch_state(idle_task(cpu));
>>>>>  
>>>>> -	klp_for_each_patch(patch)
>>>>> -		patch->forced = true;
>>>>> +	if (klp_target_state == KLP_UNPATCHED)
>>>>> +		klp_transition_patch->forced = true;
>>>>
>>>> I do not think this would interact nicely with the atomic replace feature. 
>>>> If you force the transition of a patch with ->replace set to true, no 
>>>> existing patch would get ->forced set with this change, which means all 
>>>> patches will be removed at the end of klp_try_complete_transition(). And 
>>>> that is something we want to prevent.
>>>
>>> Good point, I should check if it's an atomic replace livepatch in the else
>>> branch, in which case we have to set all existing patches to forced.
>>
>> Yes, but that leads to a question if it then brings any value. Forcing a 
>> transition should be exceptional. If it is needed, there may be other 
>> issues involved which should probably be fixed. Have you come across a 
>> practical situation where the patch helped?
> 
> Yes, you're right, the correct way is to find and fix the issues that
> make us to use this "force" transition interface, until we don't need
> to use it.
> 
> Apart from this reason, another reason we may use "force" transition
> is that we want to speed up the transition process of some patches
> when load them, and we can make sure these patches are safe to do so.
> (just like a consistency model check disable option when load a patch)
> 

Interesting use case.  Can you share any example livepatches where the
transition time was exceptionally long and that lead to requiring this
patch?

From a kpatch developer's perspective, it would be interesting to read
how you go about ensuring forced livepatch safety.  We don't generally
build forced livepatches, so I'm curious how the dev/review process goes.

Thanks,
-- 
Joe

