Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F026A61630F
	for <lists+live-patching@lfdr.de>; Wed,  2 Nov 2022 13:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiKBMwC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 2 Nov 2022 08:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiKBMwB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 2 Nov 2022 08:52:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFC0240B5
        for <live-patching@vger.kernel.org>; Wed,  2 Nov 2022 05:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667393466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VVR6mfIEsbO7Viq6nhBqa/UeO+Z7RfWK9UcMzFO3U9w=;
        b=JZ+H3ZPiAuCUVAKCvGb3ZrhXPUPr6RujIqCVw+O65GwFRcINhgO5AdmZzZdGJ+RDGbJQ/H
        mpXmajfcJ204oSOYybU+lcg8oMUDdeivdt3pZu8TaI6L5Yd5uVW2fPoKQBBzEl0CzTkxLP
        Dat1Y5CmSRR2cj5HvotiSO9V4BppXc8=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-107-WZqZyP4bPnuOVgUbsYabNg-1; Wed, 02 Nov 2022 08:51:03 -0400
X-MC-Unique: WZqZyP4bPnuOVgUbsYabNg-1
Received: by mail-qv1-f69.google.com with SMTP id d8-20020a0cfe88000000b004bb65193fdcso9795265qvs.12
        for <live-patching@vger.kernel.org>; Wed, 02 Nov 2022 05:51:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:subject:from:references:cc:to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VVR6mfIEsbO7Viq6nhBqa/UeO+Z7RfWK9UcMzFO3U9w=;
        b=IUQ6OhrfaTzLXG3rEcD9Wwf/Mjc3R7c5Pgx1uLuflKeHmwXSMUlaXvlzdujK4++a2g
         wuBVH83+e1/kb+Khu1tpS8jz1ebNyzCVRXq2ySk7qTwouW8iSzkG5gYq0Ro5nQBRPcHB
         YepGTLXUnYEMdoBygMGy5yw+IES9j/aVFF+9DHhp4pc9jylHI1OfLRJqBS3Ci69Klqqm
         44Yp9LMzbeXeNK1ff6QxI47eeTASExdIlkY217XFbGJll6sDQwWAoMpy/Fs24eec2unN
         sUGDOHSraZPGumAjM4VKjpHuO938mdz7cYrlvP0HQjOf3T6i1WfknzdSntskuueDMKHg
         4Qww==
X-Gm-Message-State: ACrzQf1zTOqGEGzRdXnwHsSJr0M7WKkK0TBP5ALOhvivFQ20Q/DJklK1
        VM6hAE6dHb6EXVdm6xPVi0CvhVMxZY5iiiphXJ9fUX4sDOY57j64wS7kHvext63bhBKaoRu1xHG
        AT8RSciIhe3X5AGDfBdk7RpKocQ==
X-Received: by 2002:a05:6214:5088:b0:4bb:a8bc:6332 with SMTP id kk8-20020a056214508800b004bba8bc6332mr20818098qvb.63.1667393462663;
        Wed, 02 Nov 2022 05:51:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7HNIGLnR59O/8scC5tl6vJCPMIlHvkbV+n6ShgrPdo+xP5Yt1I8Jdln2Hb1Luz128wxx2g+Q==
X-Received: by 2002:a05:6214:5088:b0:4bb:a8bc:6332 with SMTP id kk8-20020a056214508800b004bba8bc6332mr20818072qvb.63.1667393462335;
        Wed, 02 Nov 2022 05:51:02 -0700 (PDT)
Received: from [192.168.1.9] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id ay7-20020a05620a178700b006cfc1d827cbsm8302320qkb.9.2022.11.02.05.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 05:51:01 -0700 (PDT)
To:     Petr Mladek <pmladek@suse.com>
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        live-patching@vger.kernel.org, jpoimboe@redhat.com, mbenes@suse.cz,
        nstange@suse.de
References: <20220701194817.24655-1-mpdesouza@suse.com>
 <20220701194817.24655-5-mpdesouza@suse.com>
 <b5fc2891-2fb0-4aa7-01dd-861da22bb7ea@redhat.com> <Y1aqkxKWnzVo7pfP@alley>
 <Y2D83wFbIcBoknQL@alley>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH 4/4] livepatch/shadow: Add garbage collection of shadow
 variables
Message-ID: <a0a03167-1d49-1c58-12c3-4a881e924224@redhat.com>
Date:   Wed, 2 Nov 2022 08:51:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Y2D83wFbIcBoknQL@alley>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 11/1/22 7:02 AM, Petr Mladek wrote:
> On Mon 2022-10-24 17:09:08, Petr Mladek wrote:
>> On Thu 2022-08-25 12:26:25, Joe Lawrence wrote:
>>> On 7/1/22 3:48 PM, Marcos Paulo de Souza wrote:
>>>> The life of shadow variables is not completely trivial to maintain.
>>>> They might be used by more livepatches and more livepatched objects.
>>>> They should stay as long as there is any user.
>>>>
>>>> In practice, it requires to implement reference counting in callbacks
>>>> of all users. They should register all the user and remove the shadow
>>>> variables only when there is no user left.
>>>>
>>>> This patch hides the reference counting into the klp_shadow API.
>>>> The counter is connected with the shadow variable @id. It requires
>>>> an API to take and release the reference. The release function also
>>>> calls the related dtor() when defined.
>>>>
>>>> An easy solution would be to add some get_ref()/put_ref() API.
>>>> But it would need to get called from pre()/post_un() callbacks.
>>>> It might be easy to forget a callback and make it wrong.
>>>>
>>>> A more safe approach is to associate the klp_shadow_type with
>>>> klp_objects that use the shadow variables. The livepatch core
>>>> code might then handle the reference counters on background.
>>>>
>>>> The shadow variable type might then be added into a new @shadow_types
>>>> member of struct klp_object. They will get then automatically registered
>>>> and unregistered when the object is being livepatched. The registration
>>>> increments the reference count. Unregistration decreases the reference
>>>> count. All shadow variables of the given type are freed when the reference
>>>> count reaches zero.
>>>>
>>>> All klp_shadow_alloc/get/free functions also checks whether the requested
>>>> type is registered. It will help to catch missing registration and might
>>>> also help to catch eventual races.
>>>>
>>>> --- a/include/linux/livepatch.h
>>>> +++ b/include/linux/livepatch.h
>>>> @@ -100,11 +100,14 @@ struct klp_callbacks {
>>>>  	bool post_unpatch_enabled;
>>>>  };
>>>>  
>>>> +struct klp_shadow_type;
>>>> +
>>>>  /**
>>>>   * struct klp_object - kernel object structure for live patching
>>>>   * @name:	module name (or NULL for vmlinux)
>>>>   * @funcs:	function entries for functions to be patched in the object
>>>>   * @callbacks:	functions to be executed pre/post (un)patching
>>>> + * @shadow_types: shadow variable types used by the livepatch for the klp_object
>>>>   * @kobj:	kobject for sysfs resources
>>>>   * @func_list:	dynamic list of the function entries
>>>>   * @node:	list node for klp_patch obj_list
>>>> @@ -118,6 +121,7 @@ struct klp_object {
>>>>  	const char *name;
>>>>  	struct klp_func *funcs;
>>>>  	struct klp_callbacks callbacks;
>>>> +	struct klp_shadow_type **shadow_types;
>>>>  
>>>
>>> Hmm.  The implementation of shadow_types inside klp_object might be
>>> difficult to integrate into kpatch-build.  For kpatches, we do utilize
>>> the kernel's shadow variable API directly, but at kpatch author time we
>>> don't have any of klp_patch objects in hand -- those are generated by
>>> template after the binary before/after comparison is completed.
>>
>> I am sorry but I am not much familiar with kPatch. But I am surprised.
>> It should be similar to klp_callbacks. If it was possible to define
>> struct klp_callbacks for a particular struct klp_object then it
>> should be possible to define struct klp_shadow_types ** similar way.

Right.  For klp_callbacks, the kpatch author would logically provide the
callback code right in the compilation unit for said klp_object.
Additionally, kpatch uses callback macros to provide hints in the ELF
file so that kpatch-build can collect up the callbacks for each
klp_object to plug its the livepatch template.

In the case of shadow variables, we might use a similar hint mechanism.
 Also, we could implement additional sanity checking to detect if the
kpatch author is trying to access klp_object A's shadow_types from
klp_object B.  If there is a legit use case for that, then I would think
the klp_object better be vmlinux, else the kpatch may introduce
use-after-frees.

> Note that adding the used klp_shadow_types into struct klp_object
> is not strictly required.
> 
> Alternative solution is to register/unregister the used types using
> klp_callbacks or module init()/exit() callbacks. This approach
> is used in lib/livepatch/test_klp_shadow_vars.c.
> 
> I believe that this would be usable for kpatch-build.
> You needed to remove not-longer used shadow variables
> using these callbacks even before this patchset. I would
> consider it a bug if you did not remove them. The new API
> just allows to do this a safe way.
> 

Ah, let me dig into that example for alternative usage.  At first
glance, it looks like you're right -- kpatch already supports callbacks,
so just (un)register the shadow variables here.  I'll be back with more
info hopefully later this week.

Thanks,

-- 
Joe

