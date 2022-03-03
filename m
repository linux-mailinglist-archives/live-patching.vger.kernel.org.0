Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404EF4CB730
	for <lists+live-patching@lfdr.de>; Thu,  3 Mar 2022 07:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiCCGwR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 3 Mar 2022 01:52:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiCCGwP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 3 Mar 2022 01:52:15 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B8116A591
        for <live-patching@vger.kernel.org>; Wed,  2 Mar 2022 22:51:30 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id g1so3996852pfv.1
        for <live-patching@vger.kernel.org>; Wed, 02 Mar 2022 22:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vGPyMpAI10MU3XsGD8/28ugapGuzl32gSygdZuFaXgw=;
        b=yIJColnGqvEfF3gxpGrZzpxyWOXquzYrHsw7ceFq03On82nwLIBBCnVm/3e+v56jIP
         EEKkcwh55HyhxvrLfJ4jHN7cKEsg1KPi5rnISAIuv8l6GjBnDDYTJyZrz3gyEs+VBNFH
         6LnJ57fiNZvwjgzPgfaeUlRQS8h4l7m56MPnwbpNOoxxSwROtq8sRz4hq0ThMh4LONTe
         Cy/n3HyIQUqIsu1EhKUqwJB3MGI1rZJPQ2btIcgTb1YOg516qdIMHOGBFkytAKS9awm4
         +3OJHn7bFwqievUKBMZeXcmw8XsVhl4GCBrZxdprh1OEPN6arqHNa+OVINarcPxtftJ9
         uPaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vGPyMpAI10MU3XsGD8/28ugapGuzl32gSygdZuFaXgw=;
        b=WdoFHeRoPRlQmewWzKHKVJeYWt64/vOcM8h5ClmxDljci38X+HW1jHG8R/q2hOiyzx
         czwcsMzExqTPdhOLN7yP/OBinior5H+9JcQuwu5AEUA/J+fA8mOfKeJ1/C7B7vtxMsh1
         omDkarHEPfBggbidwkhDhq5T5WWq1asnWSrKKYUyF/5P53YVjDsRY75V7zQKoI469iFJ
         63AIXtb/ud3MNa56Ags0MfROYl8DxQWSCX8S2rWBZPgO8eVGiVApvYTUSgVkxClVtUL8
         +ytf2qV6x4nKTC7eaKSndGQOymjF4blji3GNigocIJtqs5wTXqUP7XO/o4l7+t+U80By
         5lPg==
X-Gm-Message-State: AOAM530xxCbn2WmX8ryhJ71bK2m29jgsSiTdxgr3aUR4G4FKbCBZ50AB
        hH3yxqIS0wHeEV1BavX//p+DJQ==
X-Google-Smtp-Source: ABdhPJyMNs6bPxpLikwLoiCY7jFG5Q++vQC4lxr4Qp4i25BW6Zgp/1KyngyZLACjE6eZIDlpGoawIA==
X-Received: by 2002:a05:6a00:150a:b0:4cc:f6a6:1bc6 with SMTP id q10-20020a056a00150a00b004ccf6a61bc6mr37154677pfu.74.1646290290328;
        Wed, 02 Mar 2022 22:51:30 -0800 (PST)
Received: from [10.255.179.141] ([139.177.225.237])
        by smtp.gmail.com with ESMTPSA id d10-20020a63360a000000b0037947abe4bbsm1121746pga.34.2022.03.02.22.51.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 22:51:29 -0800 (PST)
Message-ID: <fe2b9225-44c3-2041-f8a3-6f17f9d1be40@bytedance.com>
Date:   Thu, 3 Mar 2022 14:51:23 +0800
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
From:   Chengming Zhou <zhouchengming@bytedance.com>
In-Reply-To: <alpine.LSU.2.21.2203021052470.5895@pobox.suse.cz>
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

On 2022/3/2 5:55 下午, Miroslav Benes wrote:
> Hi,
> 
> On Tue, 1 Mar 2022, Chengming Zhou wrote:
> 
>> module_put() is currently never called for a patch with forced flag, to block
>> the removal of that patch module that might still be in use after a forced
>> transition.
>>
>> But klp_force_transition() will flag all patches on the list to be forced, since
>> commit d67a53720966 ("livepatch: Remove ordering (stacking) of the livepatches")
>> has removed stack ordering of the livepatches, it will cause all other patches can't
>> be unloaded after disabled even if they have completed the KLP_UNPATCHED transition.
>>
>> In fact, we don't need to flag a patch to forced if it's a KLP_PATCHED forced
>> transition. It can still be unloaded only if it has passed through the consistency
>> model in KLP_UNPATCHED transition.
>>
>> So this patch only set forced flag and block the removal of a KLP_UNPATCHED forced
>> transition livepatch.
>>
>> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
>> ---
>>  kernel/livepatch/transition.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
>> index 5683ac0d2566..8b296ad9e407 100644
>> --- a/kernel/livepatch/transition.c
>> +++ b/kernel/livepatch/transition.c
>> @@ -641,6 +641,6 @@ void klp_force_transition(void)
>>  	for_each_possible_cpu(cpu)
>>  		klp_update_patch_state(idle_task(cpu));
>>  
>> -	klp_for_each_patch(patch)
>> -		patch->forced = true;
>> +	if (klp_target_state == KLP_UNPATCHED)
>> +		klp_transition_patch->forced = true;
> 
> I do not think this would interact nicely with the atomic replace feature. 
> If you force the transition of a patch with ->replace set to true, no 
> existing patch would get ->forced set with this change, which means all 
> patches will be removed at the end of klp_try_complete_transition(). And 
> that is something we want to prevent.

Good point, I should check if it's an atomic replace livepatch in the else
branch, in which case we have to set all existing patches to forced.

Thanks.

> 
> Miroslav
