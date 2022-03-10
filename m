Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51F14D4775
	for <lists+live-patching@lfdr.de>; Thu, 10 Mar 2022 13:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbiCJM7D (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Mar 2022 07:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233273AbiCJM7C (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Mar 2022 07:59:02 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F47C4664B
        for <live-patching@vger.kernel.org>; Thu, 10 Mar 2022 04:58:01 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id bx5so5144490pjb.3
        for <live-patching@vger.kernel.org>; Thu, 10 Mar 2022 04:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ABjynNr7IG/7j/ecN/fk2K7CRcq07YcIgadt1mDYptM=;
        b=a/KArTwnTnLXssaJb+Fr0NDiwFJ1KPxV0OfxyDEt7Xc6jhfmBs6aDXDs1PwRCvhrm7
         cCXSPqYho5kVuwb8A4y5Z7hu3ywF11gOP53H54M89PHEMpc1an3v5rvoAK3iUXTVfnkd
         v+yZT/3X14BvTK7t8QRw0BWrhsq1W4W8Dj+78hYvuACrq5+G2+MnbsDNXbcMEz58bQ1S
         dhizSBCXTav20XHYPnRdnnPKqNzurywXEM2Tc141kXrWaon5Z2YCmWoW3eEKOYePL5DQ
         j8fbTYQMrK8P15vGJWD7Q+5MzhewHUE2Tk+XT/dYdCQe0kqP9vITmU2Ha9lX/jLyRZE2
         KmXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ABjynNr7IG/7j/ecN/fk2K7CRcq07YcIgadt1mDYptM=;
        b=O9pX60awFtUqECgjCx+cxNUecd3Ccxd6JuhxsUNoqMRuAbZumwo0inVVsbHGonD1NY
         A6S+qNxfyCMLFNcIvXCGl+BQfCROrDGjCgAL2kuk8rvnMQuwxFEmVHg1DaphMaKqa+Sn
         XbXfvCOSb02G3LrMFYLDns0RnOm9SEXIB7W7W6fKv0UqPhnESWv8k7cUCeDLFOnFl7Yy
         D+8v6/OLD1yMa0qRmGfX0MXUxiUzIL/Bm5qZdXjXePr05/Z41vfCYNDTotrIQ315Hqcx
         U/rpKprLStpbk0ASygz3fqmnU7fPLs3tYfuPjMe18ahev3ynX8RKyhDiYXKSEadVIZWA
         Ja1w==
X-Gm-Message-State: AOAM530LVjrdrWlojwE1EtpKLdv0IYDsLE8nnBUfMHT+1ccyDS92aNrt
        jDl7XWkSBm3ZAImuBNv9Y0wr6w==
X-Google-Smtp-Source: ABdhPJwWaI7OUB0xjsFNNyCmPiMUPkP0Z4Tg2y4MrQG2iaD6ziPzB0J+SkTkzZCndXW4irOZKsNGgA==
X-Received: by 2002:a17:903:192:b0:151:8df9:6cdb with SMTP id z18-20020a170903019200b001518df96cdbmr5029952plg.20.1646917080490;
        Thu, 10 Mar 2022 04:58:00 -0800 (PST)
Received: from [10.4.175.235] ([139.177.225.250])
        by smtp.gmail.com with ESMTPSA id b2-20020a056a000a8200b004e1414f0bb1sm7701478pfl.135.2022.03.10.04.57.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 04:58:00 -0800 (PST)
Message-ID: <849e57ee-d412-30bd-3cce-47ce3362409d@bytedance.com>
Date:   Thu, 10 Mar 2022 20:57:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [External] Re: [PATCH v2] livepatch: Don't block removal of
 patches that are safe to unload
Content-Language: en-US
To:     Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Cc:     jpoimboe@redhat.com, jikos@kernel.org, joe.lawrence@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220303105446.7152-1-zhouchengming@bytedance.com>
 <YicnIIatfgLc2NN2@alley> <alpine.LSU.2.21.2203081842120.9394@pobox.suse.cz>
From:   Chengming Zhou <zhouchengming@bytedance.com>
In-Reply-To: <alpine.LSU.2.21.2203081842120.9394@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

On 2022/3/9 1:49 上午, Miroslav Benes wrote:
> On Tue, 8 Mar 2022, Petr Mladek wrote:
> 
>> On Thu 2022-03-03 18:54:46, Chengming Zhou wrote:
>>> module_put() is currently never called for a patch with forced flag, to block
>>> the removal of that patch module that might still be in use after a forced
>>> transition.
>>>
>>> But klp_force_transition() will set all patches on the list to be forced, since
>>> commit d67a53720966 ("livepatch: Remove ordering (stacking) of the livepatches")
>>> has removed stack ordering of the livepatches, it will cause all other patches can't
>>> be unloaded after disabled even if they have completed the KLP_UNPATCHED transition.
>>>
>>> In fact, we don't need to set a patch to forced if it's a KLP_PATCHED forced
>>> transition. It can still be unloaded safely as long as it has passed through
>>> the consistency model in KLP_UNPATCHED transition.
>>
>> It really looks safe. klp_check_stack_func() makes sure that @new_func
>> is not on the stack when klp_target_state == KLP_UNPATCHED. As a
>> result, the system should not be using code from the livepatch module
>> when KLP_UNPATCHED transition cleanly finished.
>>
>>
>>> But the exception is when force transition of an atomic replace patch, we
>>> have to set all previous patches to forced, or they will be removed at
>>> the end of klp_try_complete_transition().
>>>
>>> This patch only set the klp_transition_patch to be forced in KLP_UNPATCHED
>>> case, and keep the old behavior when in atomic replace case.
>>>
>>> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
>>> ---
>>> v2: interact nicely with the atomic replace feature noted by Miroslav.
>>> ---
>>>  kernel/livepatch/transition.c | 8 ++++++--
>>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
>>> index 5683ac0d2566..34ffb8c014ed 100644
>>> --- a/kernel/livepatch/transition.c
>>> +++ b/kernel/livepatch/transition.c
>>> @@ -641,6 +641,10 @@ void klp_force_transition(void)
>>>  	for_each_possible_cpu(cpu)
>>>  		klp_update_patch_state(idle_task(cpu));
>>>  
>>> -	klp_for_each_patch(patch)
>>> -		patch->forced = true;
>>> +	if (klp_target_state == KLP_UNPATCHED)
>>> +		klp_transition_patch->forced = true;
>>> +	else if (klp_transition_patch->replace) {
>>> +		klp_for_each_patch(patch)
>>> +			patch->forced = true;
>>
>> This works only because there is should be only one patch when
>> klp_target_state == KLP_UNPATCHED and
>> klp_transition_patch->forced == true.
> 
> I probably misunderstand, but the above is not generally true, is it? I 
> mean, if the transition patch is forced during its disablement, it does 
> not say anything about the amount of enabled patches.
> 
>> But it is a bit tricky. I would do it the other way:
>>
>> 	if (klp_transition_patch->replace) {
>> 		klp_for_each_patch(patch)
>> 			patch->forced = true;
>> 	} else if (klp_target_state == KLP_UNPATCHED) {
>> 		klp_transition_patch->forced = true;
>> 	}
>>
>> It looks more sane. And it makes it more clear
>> that the special handling of KLP_UNPATCHED transition
>> is done only when the atomic replace is not used.
> 
> But it is not the same. ->replace being true only comes into play when a 
> patch is enabled. If it is disabled, then it behaves like any other patch.
> 
> So, if there is ->replace patch enabled (and it is the only patch present) 
> and then more !->replace patches are loaded and then if ->replace patch is 
> disabled and forced, your proposal would give a different result than what 
> Chengming submitted, because in your case all the other patches will get 
> ->forced set to true, while it is not the case in the original. It would 
> be an unnecessary restriction if I am not missing something.

At first glance, I thought both way is right. But after looking at the case
you mentioned above, they are not the same indeed. The original patch
treat ->replace and not ->replace patches the same in KLP_UNPATCHED transition,
and only set all patches to forced in the atomic replace transition.

Thanks.

> 
> However, I may got lost somewhere along the way.
> 
> Regards
> Miroslav
