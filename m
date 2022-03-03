Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8864CBB71
	for <lists+live-patching@lfdr.de>; Thu,  3 Mar 2022 11:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbiCCKeU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 3 Mar 2022 05:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiCCKeT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 3 Mar 2022 05:34:19 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DAF32ED1
        for <live-patching@vger.kernel.org>; Thu,  3 Mar 2022 02:33:29 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id 15-20020a17090a098f00b001bef0376d5cso4443779pjo.5
        for <live-patching@vger.kernel.org>; Thu, 03 Mar 2022 02:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Oja3CIqE9fA451Twve2pF1vRqS/QrpX6zmesqNzXMcA=;
        b=N2wLZPHbeKHF/4+voaEtvGxD4D0DSWyFiqi97W2sREHJv/ENo8uK3Hw2n9e7A8qvDo
         bRnCP8++kh/M1T6jTh2vnsUxNhP55uzjf6FwKhRll3JN6V4st8JWD8EjUYMgQH6Gu2m9
         nIqW2sYZaRtLvnOcgLgz4RtyvzU9oNl8C4llgeoPWxSBTL9wQZv/A06uyPaoC7uoA0x6
         hwt7zKUvioPFQ+yGUbePCCrclL+jR+ca+xK/4HQJz4Au+x4aJogZj+hQiyzSuPvauxNe
         QTyL+t9uIlHdaKPct5K3nCbb7IwbeJsBMYPvKl+zRIHZJHAhZhoNItFaepYo/neCFKYn
         yVDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Oja3CIqE9fA451Twve2pF1vRqS/QrpX6zmesqNzXMcA=;
        b=1DqDSFHEgljRCyjZOvYJIhWmBLN10Z8CPZVmbQWoY3NSPkZ0RSojtvxiXOdWuTgd52
         9XMQc7/8B+UiiyMgQ9i3f090waC3qxR8MXDiUArRhqkUx6olkg2vbbbaPEJ3v/nX1Tjb
         uEiRnztngcU0SJ5fktGs8EdYMLrXw7JRy0sfuCTj3QE8SMpSzpnFw7xlotkRmjH7Vahz
         6NCeLSep8WwRVim10KvOCnIQVM2DJJVb6sMyymSOZuhywRXvR+Bfw/EwaTMMpWIooni8
         WF7XCOIsaHaJhGClFY9Aqkr2z2AtqqoLD456q3j8FW7fnjyHRvGbSEKDm5WojkLJOzK4
         zJsw==
X-Gm-Message-State: AOAM530Ij6ugs29wlnm4bwVkeRaKayTGDXGNZNdqkk+xq41Vy/N9+39h
        cUZ4FTW09ducmofngrngyZePPV+8NqjsMA==
X-Google-Smtp-Source: ABdhPJwutRy4qdqPFYgzNqskFDJ/moT5feFg+cSc2e2YBVONBSsWgVv8iInhQ+HQBDY5RsXkZaBwQA==
X-Received: by 2002:a17:90b:4d86:b0:1bd:223f:6cb5 with SMTP id oj6-20020a17090b4d8600b001bd223f6cb5mr4604124pjb.151.1646303609319;
        Thu, 03 Mar 2022 02:33:29 -0800 (PST)
Received: from [10.255.179.141] ([139.177.225.237])
        by smtp.gmail.com with ESMTPSA id q9-20020a056a00150900b004f4735396fesm2163786pfu.191.2022.03.03.02.33.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 02:33:28 -0800 (PST)
Message-ID: <1929669c-7674-035b-8cf1-5b5007ecccec@bytedance.com>
Date:   Thu, 3 Mar 2022 18:33:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [External] Re: [PATCH] livepatch: Only block the removal of
 KLP_UNPATCHED forced transition patch
Content-Language: en-US
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     jpoimboe@redhat.com, jikos@kernel.org, pmladek@suse.com,
        joe.lawrence@redhat.com, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, songmuchun@bytedance.com,
        qirui.001@bytedance.com
References: <20220301140840.29345-1-zhouchengming@bytedance.com>
 <alpine.LSU.2.21.2203021052470.5895@pobox.suse.cz>
 <fe2b9225-44c3-2041-f8a3-6f17f9d1be40@bytedance.com>
 <alpine.LSU.2.21.2203030847430.704@pobox.suse.cz>
From:   Chengming Zhou <zhouchengming@bytedance.com>
In-Reply-To: <alpine.LSU.2.21.2203030847430.704@pobox.suse.cz>
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

On 2022/3/3 3:51 下午, Miroslav Benes wrote:
> On Thu, 3 Mar 2022, Chengming Zhou wrote:
> 
>> Hi,
>>
>> On 2022/3/2 5:55 下午, Miroslav Benes wrote:
>>> Hi,
>>>
>>> On Tue, 1 Mar 2022, Chengming Zhou wrote:
>>>
>>>> module_put() is currently never called for a patch with forced flag, to block
>>>> the removal of that patch module that might still be in use after a forced
>>>> transition.
>>>>
>>>> But klp_force_transition() will flag all patches on the list to be forced, since
>>>> commit d67a53720966 ("livepatch: Remove ordering (stacking) of the livepatches")
>>>> has removed stack ordering of the livepatches, it will cause all other patches can't
>>>> be unloaded after disabled even if they have completed the KLP_UNPATCHED transition.
>>>>
>>>> In fact, we don't need to flag a patch to forced if it's a KLP_PATCHED forced
>>>> transition. It can still be unloaded only if it has passed through the consistency
>>>> model in KLP_UNPATCHED transition.
>>>>
>>>> So this patch only set forced flag and block the removal of a KLP_UNPATCHED forced
>>>> transition livepatch.
>>>>
>>>> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
>>>> ---
>>>>  kernel/livepatch/transition.c | 4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
>>>> index 5683ac0d2566..8b296ad9e407 100644
>>>> --- a/kernel/livepatch/transition.c
>>>> +++ b/kernel/livepatch/transition.c
>>>> @@ -641,6 +641,6 @@ void klp_force_transition(void)
>>>>  	for_each_possible_cpu(cpu)
>>>>  		klp_update_patch_state(idle_task(cpu));
>>>>  
>>>> -	klp_for_each_patch(patch)
>>>> -		patch->forced = true;
>>>> +	if (klp_target_state == KLP_UNPATCHED)
>>>> +		klp_transition_patch->forced = true;
>>>
>>> I do not think this would interact nicely with the atomic replace feature. 
>>> If you force the transition of a patch with ->replace set to true, no 
>>> existing patch would get ->forced set with this change, which means all 
>>> patches will be removed at the end of klp_try_complete_transition(). And 
>>> that is something we want to prevent.
>>
>> Good point, I should check if it's an atomic replace livepatch in the else
>> branch, in which case we have to set all existing patches to forced.
> 
> Yes, but that leads to a question if it then brings any value. Forcing a 
> transition should be exceptional. If it is needed, there may be other 
> issues involved which should probably be fixed. Have you come across a 
> practical situation where the patch helped?

Yes, you're right, the correct way is to find and fix the issues that
make us to use this "force" transition interface, until we don't need
to use it.

Apart from this reason, another reason we may use "force" transition
is that we want to speed up the transition process of some patches
when load them, and we can make sure these patches are safe to do so.
(just like a consistency model check disable option when load a patch)

Then I find it confusing and limited that force transition in loading
a patch will make all previous patches can't be unloaded, so can't be
reverted and enabled again (updated or not).

Anyway, I think this patch won't decrease the security performance of
livepatch, but can increase flexibility in some user experience.

Thanks.

> 
> Thanks
> 
> Miroslav
