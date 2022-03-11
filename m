Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C324C4D6117
	for <lists+live-patching@lfdr.de>; Fri, 11 Mar 2022 12:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348424AbiCKMA3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 11 Mar 2022 07:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244771AbiCKMA2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 11 Mar 2022 07:00:28 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EFD1A94A7
        for <live-patching@vger.kernel.org>; Fri, 11 Mar 2022 03:59:25 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id bc27so7290904pgb.4
        for <live-patching@vger.kernel.org>; Fri, 11 Mar 2022 03:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=s+9J3fzeoHrpsTRQ13NQjokEARQep2qnKWa3WiCsX0Q=;
        b=eJ8NsL3DUayA/69NGeIxF3/euLXDYC0g1D6K4rRyT2N32cAd6QMb6QKp9yYDffC/So
         dcsMZS9unVMohlwtDD1VbLPlDVpY9LPUJA091tCGnynG0Hohn7iQ3IGXU04pJvkqNcIp
         QCVL6AsjgHwgFM1/3ekoaHoX2CZYigbohvyT+dcwC7PONZ/NG9UvweSs/bnQPeUJPtHm
         /S1pgRs0Od+hDFi+ngLRdpzxsZXl7moR2dQjcAfCaOGGSdOB4nC69ekWTNjq4TF1Ve3a
         CqfIrUgcexHPM6z2Mf6P8M8r+knKr+ErcjDwbj9mrCCtdwxygxvgoRHygPkxXBqRKkQO
         7y1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s+9J3fzeoHrpsTRQ13NQjokEARQep2qnKWa3WiCsX0Q=;
        b=qlvTJVrxscO/aEMGW1LmSKPGy+KzneD/fOjmeiuiZKmnfwBc7/ncskjWrVF+XPbP6/
         gt3zX3ClFOhd7P22sUPacrt+nm+NQTSX5iBnNx3Q6p5lCjXRjwpVotpbr6S7Qoa0pukN
         imELQlLyBQKrHuMPilcZmbvzBiLTnwxFYb+BBNwxIKhjRkH1urHzBLST8tb/IQB6EUkX
         GJ7fUaq4ybhQcky4LmwMpes3XPDN8knPT5c6H99HnziPYQ8wLO6b5aG2e5l30lkk9iI/
         6sj7rcJ5waLyUPQ+lDOnSPUnH4+vXvGZzd4LRmALsTS9sO0nARmbhZXnWU/rRpQoOFWs
         wJvg==
X-Gm-Message-State: AOAM531pTnxxf+gbH8Mx+WifY+I+dU98xOsEQnkmSWaoCRXNAcu1v4V8
        dSxPyz5VeWpTibu+/cqzToYeVw==
X-Google-Smtp-Source: ABdhPJwZF2lkVGEdOHZ1KKa19VO7dejeeUca7CMbSQNoV1PAZnDTo86W4BcrQJ9d3eQtJ2wA/y5EmA==
X-Received: by 2002:a05:6a00:2402:b0:4e1:3df2:5373 with SMTP id z2-20020a056a00240200b004e13df25373mr9553928pfh.40.1646999964639;
        Fri, 11 Mar 2022 03:59:24 -0800 (PST)
Received: from ?IPV6:2409:8a28:e6b:7130:ddd:2fc4:6858:5760? ([2409:8a28:e6b:7130:ddd:2fc4:6858:5760])
        by smtp.gmail.com with ESMTPSA id m11-20020a056a00080b00b004f791d0115esm1871923pfk.171.2022.03.11.03.59.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 03:59:23 -0800 (PST)
Message-ID: <791d2e92-cb88-aac9-67b4-e9d09448df0e@bytedance.com>
Date:   Fri, 11 Mar 2022 19:59:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [External] Re: [PATCH v2] livepatch: Don't block removal of
 patches that are safe to unload
Content-Language: en-US
To:     Petr Mladek <pmladek@suse.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, jpoimboe@redhat.com,
        jikos@kernel.org, joe.lawrence@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220303105446.7152-1-zhouchengming@bytedance.com>
 <YicnIIatfgLc2NN2@alley> <alpine.LSU.2.21.2203081842120.9394@pobox.suse.cz>
 <849e57ee-d412-30bd-3cce-47ce3362409d@bytedance.com> <Yionqn3d9OQF4UiT@alley>
From:   Chengming Zhou <zhouchengming@bytedance.com>
In-Reply-To: <Yionqn3d9OQF4UiT@alley>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 2022/3/11 12:30 上午, Petr Mladek wrote:
> On Thu 2022-03-10 20:57:54, Chengming Zhou wrote:
>> Hi,
>>
>> On 2022/3/9 1:49 上午, Miroslav Benes wrote:
>>> On Tue, 8 Mar 2022, Petr Mladek wrote:
>>>
>>>> On Thu 2022-03-03 18:54:46, Chengming Zhou wrote:
>>>>> module_put() is currently never called for a patch with forced flag, to block
>>>>> the removal of that patch module that might still be in use after a forced
>>>>> transition.
>>>>>
>>>>> But klp_force_transition() will set all patches on the list to be forced, since
>>>>> commit d67a53720966 ("livepatch: Remove ordering (stacking) of the livepatches")
>>>>> has removed stack ordering of the livepatches, it will cause all other patches can't
>>>>> be unloaded after disabled even if they have completed the KLP_UNPATCHED transition.
>>>>>
>>>>> In fact, we don't need to set a patch to forced if it's a KLP_PATCHED forced
>>>>> transition. It can still be unloaded safely as long as it has passed through
>>>>> the consistency model in KLP_UNPATCHED transition.
>>>>
>>>> It really looks safe. klp_check_stack_func() makes sure that @new_func
>>>> is not on the stack when klp_target_state == KLP_UNPATCHED. As a
>>>> result, the system should not be using code from the livepatch module
>>>> when KLP_UNPATCHED transition cleanly finished.
>>>>
>>>>
>>>>> But the exception is when force transition of an atomic replace patch, we
>>>>> have to set all previous patches to forced, or they will be removed at
>>>>> the end of klp_try_complete_transition().
>>>>>
>>>>> This patch only set the klp_transition_patch to be forced in KLP_UNPATCHED
>>>>> case, and keep the old behavior when in atomic replace case.
>>>>>
>>>>> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
>>>>> ---
>>>>> v2: interact nicely with the atomic replace feature noted by Miroslav.
>>>>> ---
>>>>>  kernel/livepatch/transition.c | 8 ++++++--
>>>>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
>>>>> index 5683ac0d2566..34ffb8c014ed 100644
>>>>> --- a/kernel/livepatch/transition.c
>>>>> +++ b/kernel/livepatch/transition.c
>>>>> @@ -641,6 +641,10 @@ void klp_force_transition(void)
>>>>>  	for_each_possible_cpu(cpu)
>>>>>  		klp_update_patch_state(idle_task(cpu));
>>>>>  
>>>>> -	klp_for_each_patch(patch)
>>>>> -		patch->forced = true;
>>>>> +	if (klp_target_state == KLP_UNPATCHED)
>>>>> +		klp_transition_patch->forced = true;
>>>>> +	else if (klp_transition_patch->replace) {
>>>>> +		klp_for_each_patch(patch)
>>>>> +			patch->forced = true;
>>>>
>>>> This works only because there is should be only one patch when
>>>> klp_target_state == KLP_UNPATCHED and
>>>> klp_transition_patch->forced == true.
>>>
>>> I probably misunderstand, but the above is not generally true, is it? I 
>>> mean, if the transition patch is forced during its disablement, it does 
>>> not say anything about the amount of enabled patches.
>>>
>>>> But it is a bit tricky. I would do it the other way:
>>>>
>>>> 	if (klp_transition_patch->replace) {
>>>> 		klp_for_each_patch(patch)
>>>> 			patch->forced = true;
>>>> 	} else if (klp_target_state == KLP_UNPATCHED) {
>>>> 		klp_transition_patch->forced = true;
>>>> 	}
>>>>
>>>> It looks more sane. And it makes it more clear
>>>> that the special handling of KLP_UNPATCHED transition
>>>> is done only when the atomic replace is not used.
>>>
>>> But it is not the same. ->replace being true only comes into play when a 
>>> patch is enabled. If it is disabled, then it behaves like any other patch.
>>>
>>> So, if there is ->replace patch enabled (and it is the only patch present) 
>>> and then more !->replace patches are loaded and then if ->replace patch is 
>>> disabled and forced, your proposal would give a different result than what 
>>> Chengming submitted, because in your case all the other patches will get 
>>> ->forced set to true, while it is not the case in the original. It would 
>>> be an unnecessary restriction if I am not missing something.
>>
>> At first glance, I thought both way is right. But after looking at the case
>> you mentioned above, they are not the same indeed. The original patch
>> treat ->replace and not ->replace patches the same in KLP_UNPATCHED transition,
>> and only set all patches to forced in the atomic replace transition.
> 
> I see. OK, Chengming's code makes sense. But we should make the commit
> message more clear. Something like:
> 
> <draft>
> module_put() is not called for a patch with "forced" flag. It should
> block the removal of the livepatch module when the code might still
> be in use after forced transition.
> 
> klp_force_transition() currently sets "force" flag for all patches on
> the list.
> 
> In fact, any patch can be safely unloaded when it passed through
> the consistency model in KLP_UNPATCHED transition.
> 
> By other words, the "forced" flag must be set only for livepatches
> that are being removed. In particular, set the "forced" flag:
> 
>   + only for klp_transition_patch when the transition to KLP_UNPATCHED
>     state was forced.
> 
>   + all replaced patches when the transition to KLP_PATCHED state was
>     forced and the patch was replacing the existing patches.
> </draft>

Ok, I will update the commit message, this draft is more clear.

> 
> It means that we should could actually do:
> 
> 	if (klp_target_state == KLP_UNPATCHED) {
> 		klp_transition_patch->forced = true;
> 	} else if (klp_transition_patch->replace) {
> 		klp_for_each_patch(patch) {
> 			if (patch != klp_transition_patch)
> 				patch->forced = true;
> 		}
> 	}
> 
> Huh, that is tricky ;-)

Yes, and I found similar tricky code at the end of
klp_try_complete_transition():

	if (!patch->enabled)
		klp_free_patch_async(patch);
	else if (patch->replace)
		klp_free_replaced_patches_async(patch);

Thanks.

> 
> Best Regards,
> Petr
