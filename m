Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8253B4DBC20
	for <lists+live-patching@lfdr.de>; Thu, 17 Mar 2022 02:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243587AbiCQBQv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Mar 2022 21:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiCQBQu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Mar 2022 21:16:50 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0881D323
        for <live-patching@vger.kernel.org>; Wed, 16 Mar 2022 18:15:35 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mm23-20020a17090b359700b001bfceefd8c6so6565176pjb.3
        for <live-patching@vger.kernel.org>; Wed, 16 Mar 2022 18:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=n4UekLFhKuoj6t1J4RjnJqfB3Vjx/zOk+L3n0fvA5S8=;
        b=NYllIOUTO0smOmOzO5Wo68IPf4JO5lDnCbO8FCGio+UqyURyfxzFMwu1g0Tw0P10tT
         pEVyxWAN2dDoxhPnhjfzS9WDI9CslV/AnkysdyglA5d1O9XwFOzEacTWM9r1jgGXWetM
         roBNV4lo0y9sCRrsR8FTy1RWZedd51E5YedgHr8JlrVaYsI59ZZ5o9bcZFgGnd+T0zw9
         NNmNlfT92dshwo9/5CBlvR95RbcmR8zCPMdkk+2SauoWugzSopxU+1KPYhHyjiApvZRS
         kMHg4wulqYwf9goCSMBFHZd7YIqCnPQVP2dDdpVo0GK299TNPoCMbEEqyxyo3V8vdvHt
         fbBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=n4UekLFhKuoj6t1J4RjnJqfB3Vjx/zOk+L3n0fvA5S8=;
        b=a09l4+poe8nE/r01lgCGk8Qy+m66MsG8Lm+isqbCNrejPxjok5BxxmIIY0Rextt6rc
         RB7D/+e9tCfyLOZQiV+yx1B9F/w8eUd8tiaXResII/dzHusfS77n8ter5l2uXZFuAadO
         rob4sBRqIsCphj9rgVDFjSCwh6ESUAJtNq5xh38xF+dH8oZnVwO6ukrI/qwRfZrDeLCs
         +7aTyIddRXzmFvMEakVlKcBg+V7ri6oh8lLzdLwdhxfhOisFk62h9yPbF6qiK3BywIv9
         ZgGvxLR7Ki2U/MeHdE1C4sEXP/HmDbQHgS7D4UH1uCSEMSxqHzyKftbIarTXonxO/fU9
         hDmA==
X-Gm-Message-State: AOAM530QemKO0diMWWjJZI+yFEvQD3E6/N+W+pVnT4wvkyuicPslKacT
        +mee1/+7f4uWGGWSmjyTs5qr5iwDNdviGA==
X-Google-Smtp-Source: ABdhPJwAZrP/Jb/nuiOdj4wyKSq/7tixRkzsZDvwjYBHg2pQubfx2QGocD6YCGDjunmElxW3jURwNA==
X-Received: by 2002:a17:90b:3b92:b0:1c6:3c6b:a2b9 with SMTP id pc18-20020a17090b3b9200b001c63c6ba2b9mr11314342pjb.156.1647479734605;
        Wed, 16 Mar 2022 18:15:34 -0700 (PDT)
Received: from ?IPV6:2409:8a28:e6e:c590:e574:d032:858c:2ca1? ([2409:8a28:e6e:c590:e574:d032:858c:2ca1])
        by smtp.gmail.com with ESMTPSA id v6-20020a056a00148600b004f9f9b9092fsm4708428pfu.113.2022.03.16.18.15.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 18:15:34 -0700 (PDT)
Message-ID: <f27650d5-5ff5-f954-5eb2-745a7bfc0dcb@bytedance.com>
Date:   Thu, 17 Mar 2022 09:15:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [External] Re: [PATCH v3] livepatch: Don't block removal of
 patches that are safe to unload
Content-Language: en-US
To:     Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>
Cc:     jpoimboe@redhat.com, jikos@kernel.org, joe.lawrence@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        songmuchun@bytedance.com, qirui.001@bytedance.com
References: <20220312152220.88127-1-zhouchengming@bytedance.com>
 <alpine.LSU.2.21.2203161536330.6444@pobox.suse.cz> <YjH7rniD4rBO6JIP@alley>
From:   Chengming Zhou <zhouchengming@bytedance.com>
In-Reply-To: <YjH7rniD4rBO6JIP@alley>
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

On 2022/3/16 11:01 下午, Petr Mladek wrote:
> On Wed 2022-03-16 15:48:25, Miroslav Benes wrote:
>> On Sat, 12 Mar 2022, Chengming Zhou wrote:
>>
>>> module_put() is not called for a patch with "forced" flag. It should
>>> block the removal of the livepatch module when the code might still
>>> be in use after forced transition.
>>>
>>> klp_force_transition() currently sets "forced" flag for all patches on
>>> the list.
>>>
>>> In fact, any patch can be safely unloaded when it passed through
>>> the consistency model in KLP_UNPATCHED transition.
>>>
>>> By other words, the "forced" flag must be set only for livepatches
>>
>> s/By/In/
>>
>>> that are being removed. In particular, set the "forced" flag:
>>>
>>>   + only for klp_transition_patch when the transition to KLP_UNPATCHED
>>>     state was forced.
>>>
>>>   + all replaced patches when the transition to KLP_PATCHED state was
>>>     forced and the patch was replacing the existing patches.
>>>
>>> index 5683ac0d2566..7f25a5ae89f6 100644
>>> --- a/kernel/livepatch/transition.c
>>> +++ b/kernel/livepatch/transition.c
>>> @@ -641,6 +641,18 @@ void klp_force_transition(void)
>>>  	for_each_possible_cpu(cpu)
>>>  		klp_update_patch_state(idle_task(cpu));
>>>  
>>> -	klp_for_each_patch(patch)
>>> -		patch->forced = true;
>>> +	/*
>>> +	 * Only need to set forced flag for the transition patch
>>> +	 * when force transition to KLP_UNPATCHED state, but
>>> +	 * have to set forced flag for all replaced patches
>>> +	 * when force atomic replace transition.
>>> +	 */
>>
>> How about something like
>>
>> /*
>>  * Set forced flag for patches being removed, which is the transition
>>  * patch in KLP_UNPATCHED state or all replaced patches when forcing
>>  * the atomic replace transition.
>>  */
> 
> Or just the first sentence:
> 
> 	/* Set forced flag for patches being removed */
> 
> The rest is visible from the code.
> 
> Either version works for me. If we agree on it then I update
> the text when pushing the patch.

Ok, this works for me too ;-)

Thanks.

> 
> Best Regards,
> Petr
