Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590C44CD776
	for <lists+live-patching@lfdr.de>; Fri,  4 Mar 2022 16:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240137AbiCDPPQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 4 Mar 2022 10:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240158AbiCDPPP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 4 Mar 2022 10:15:15 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCDE1C3D0D
        for <live-patching@vger.kernel.org>; Fri,  4 Mar 2022 07:14:26 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id w37so7763908pga.7
        for <live-patching@vger.kernel.org>; Fri, 04 Mar 2022 07:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xhFNSR/yOd/Vz2Wc1wvXRDHBYyMuBGWniHzjkl431mo=;
        b=hZqCZVGG2Aw1yowZxJka1HJssTZXGRCsk53g2yvR0SODyOvwf/Elxr1eAcI0NP8w/P
         BRDWVY2OXYvTkI05nb6CaZLDi8M4tfwFREo8tfWo3RcBYvU+nRJwzoMrogAapw+XAFqt
         ucRdR6ma6mQtKOLch8k2c7d6q7eppyhx/GjM/pMapljT1kyYVlvGRVUEbw/Y/J2GAIAQ
         H/W8p3rXzvOKbhlwBWE6s2bCCkFbZSO+ltnQ/DM81ItTC/ICR85g0BdzMn5vGbPGb1Tm
         Llm+qe/OCV86hyLcMmc4t6rH03ovFSYNvLF56nIuv2jRARRe5rozks826lfRrlnriH3X
         OzOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xhFNSR/yOd/Vz2Wc1wvXRDHBYyMuBGWniHzjkl431mo=;
        b=odnJyhbdbPq3fZRXu3pgEZhnYarQWPwHi/VoTej76zVDlbZsp082vlZS6dd896q4K0
         mwJfITtwtb8bKVVOKG2mD/6Ue1vtNPsVZ3E4Vv/W6VRzOQpuvreVFl1xHTicbHiSyIL5
         zORNLYVKgjEFTv8pZeqjbH30gjTKHRsmWYz1W3doh1jjHE+cKu+AOs2/wpQgPpKEnyqW
         WvXHNpTOqbOYDN490ot/VHzPNyP71SuRiUNilo76y9rw0nZHHRAb7WRLfMvKAm6uLvVF
         8pFzI+5v9hWqQ7IQSsCGZOnBP+//bmKKKvVNeV90rc4SwOMYtbVFW3oZyg30FqVnu8gH
         JhPA==
X-Gm-Message-State: AOAM532bcXLWOdC4l9Rc/4wDG69oBNIIn+CFYni4bR7yPBfTn8FxmNJr
        +7Q0ahU+/iaMMnR9A6UARlKq4hw7x5VYtQ==
X-Google-Smtp-Source: ABdhPJzb5cC534BnnexfsDG8sjS4Ey8TsFio0KuvhUEFwq3AjNNBbWTwq1gSZOU15bdx3t7INixUwA==
X-Received: by 2002:a05:6a00:1593:b0:4f6:6c38:f75d with SMTP id u19-20020a056a00159300b004f66c38f75dmr9260095pfk.81.1646406865430;
        Fri, 04 Mar 2022 07:14:25 -0800 (PST)
Received: from ?IPV6:2409:8a28:e6d:cc00:d089:89fd:5c33:f12? ([2409:8a28:e6d:cc00:d089:89fd:5c33:f12])
        by smtp.gmail.com with ESMTPSA id on18-20020a17090b1d1200b001b9cfbfbf00sm4958261pjb.40.2022.03.04.07.14.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 07:14:25 -0800 (PST)
Message-ID: <306a5d51-25e5-b7ce-cbdd-ca7e2f3a3ad5@bytedance.com>
Date:   Fri, 4 Mar 2022 23:14:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [External] Re: [PATCH] livepatch: Only block the removal of
 KLP_UNPATCHED forced transition patch
Content-Language: en-US
To:     Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     jpoimboe@redhat.com, jikos@kernel.org, pmladek@suse.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        songmuchun@bytedance.com, qirui.001@bytedance.com
References: <20220301140840.29345-1-zhouchengming@bytedance.com>
 <alpine.LSU.2.21.2203021052470.5895@pobox.suse.cz>
 <fe2b9225-44c3-2041-f8a3-6f17f9d1be40@bytedance.com>
 <alpine.LSU.2.21.2203030847430.704@pobox.suse.cz>
 <1929669c-7674-035b-8cf1-5b5007ecccec@bytedance.com>
 <c1ab3333-7fea-d2d5-272d-850f4c7afb74@redhat.com>
From:   Chengming Zhou <zhouchengming@bytedance.com>
In-Reply-To: <c1ab3333-7fea-d2d5-272d-850f4c7afb74@redhat.com>
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

On 2022/3/3 11:43 下午, Joe Lawrence wrote:
> On 3/3/22 5:33 AM, Chengming Zhou wrote:
>> On 2022/3/3 3:51 下午, Miroslav Benes wrote:
>>> On Thu, 3 Mar 2022, Chengming Zhou wrote:
>>>
>>>> Hi,
>>>>
>>>> On 2022/3/2 5:55 下午, Miroslav Benes wrote:
>>>>> Hi,
>>>>>
>>>>> On Tue, 1 Mar 2022, Chengming Zhou wrote:
>>>>>
>>>>>> module_put() is currently never called for a patch with forced flag, to block
>>>>>> the removal of that patch module that might still be in use after a forced
>>>>>> transition.
>>>>>>
>>>>>> But klp_force_transition() will flag all patches on the list to be forced, since
>>>>>> commit d67a53720966 ("livepatch: Remove ordering (stacking) of the livepatches")
>>>>>> has removed stack ordering of the livepatches, it will cause all other patches can't
>>>>>> be unloaded after disabled even if they have completed the KLP_UNPATCHED transition.
>>>>>>
>>>>>> In fact, we don't need to flag a patch to forced if it's a KLP_PATCHED forced
>>>>>> transition. It can still be unloaded only if it has passed through the consistency
>>>>>> model in KLP_UNPATCHED transition.
>>>>>>
>>>>>> So this patch only set forced flag and block the removal of a KLP_UNPATCHED forced
>>>>>> transition livepatch.
>>>>>>
>>>>>> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
>>>>>> ---
>>>>>>  kernel/livepatch/transition.c | 4 ++--
>>>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
>>>>>> index 5683ac0d2566..8b296ad9e407 100644
>>>>>> --- a/kernel/livepatch/transition.c
>>>>>> +++ b/kernel/livepatch/transition.c
>>>>>> @@ -641,6 +641,6 @@ void klp_force_transition(void)
>>>>>>  	for_each_possible_cpu(cpu)
>>>>>>  		klp_update_patch_state(idle_task(cpu));
>>>>>>  
>>>>>> -	klp_for_each_patch(patch)
>>>>>> -		patch->forced = true;
>>>>>> +	if (klp_target_state == KLP_UNPATCHED)
>>>>>> +		klp_transition_patch->forced = true;
>>>>>
>>>>> I do not think this would interact nicely with the atomic replace feature. 
>>>>> If you force the transition of a patch with ->replace set to true, no 
>>>>> existing patch would get ->forced set with this change, which means all 
>>>>> patches will be removed at the end of klp_try_complete_transition(). And 
>>>>> that is something we want to prevent.
>>>>
>>>> Good point, I should check if it's an atomic replace livepatch in the else
>>>> branch, in which case we have to set all existing patches to forced.
>>>
>>> Yes, but that leads to a question if it then brings any value. Forcing a 
>>> transition should be exceptional. If it is needed, there may be other 
>>> issues involved which should probably be fixed. Have you come across a 
>>> practical situation where the patch helped?
>>
>> Yes, you're right, the correct way is to find and fix the issues that
>> make us to use this "force" transition interface, until we don't need
>> to use it.
>>
>> Apart from this reason, another reason we may use "force" transition
>> is that we want to speed up the transition process of some patches
>> when load them, and we can make sure these patches are safe to do so.
>> (just like a consistency model check disable option when load a patch)
>>
> 
> Interesting use case.  Can you share any example livepatches where the
> transition time was exceptionally long and that lead to requiring this
> patch?

Sorry, I haven't easy reproducible testcase on hand, maybe I could try to
make one to simulate the production environment later.

> 
> From a kpatch developer's perspective, it would be interesting to read
> how you go about ensuring forced livepatch safety.  We don't generally
> build forced livepatches, so I'm curious how the dev/review process goes.

We also use kpatch-build for some patches too, but for some other patches,
which need to add new members to some struct type, or fix some kernel function
bugs, we may need to rewrite the source patch to make a livepatch module.

There are some types that don't need per-task consistency or even can replace
the old functions when tasks stack in the old functions. We may want to use
"force" transition in case load process timeout.

Thanks.

> 
> Thanks,
