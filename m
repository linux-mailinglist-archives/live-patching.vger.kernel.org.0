Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43FC3588C3E
	for <lists+live-patching@lfdr.de>; Wed,  3 Aug 2022 14:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbiHCMgj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 3 Aug 2022 08:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbiHCMgj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 3 Aug 2022 08:36:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 171B224BDF
        for <live-patching@vger.kernel.org>; Wed,  3 Aug 2022 05:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659530196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UgL/jjEgmxC4K8yyV+SfvktmXKnVh0iU6LF6NKBXXTk=;
        b=eTyTBq0SzfFJ3wZpzvxv00jYRVcq2X+4rGsn9PfVn1/+muf3U21pq0hFFbJ5sFud+UlMZM
        Eo+j5pmdhtoOUk8ahdwDNFNVgmIpH8wMYqs8ddy2RtFy2KvfVTesxDwr0DMBgQBUHupi88
        J07InCv49/EtCwEdRZ+xcmqeKA5pAxU=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-x6ctVSsvMiGVnvT9ihWCfA-1; Wed, 03 Aug 2022 08:36:35 -0400
X-MC-Unique: x6ctVSsvMiGVnvT9ihWCfA-1
Received: by mail-qt1-f200.google.com with SMTP id u12-20020a05622a010c00b0031ef5b46dc0so10891730qtw.16
        for <live-patching@vger.kernel.org>; Wed, 03 Aug 2022 05:36:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:subject:from:references:cc:to
         :x-gm-message-state:from:to:cc;
        bh=UgL/jjEgmxC4K8yyV+SfvktmXKnVh0iU6LF6NKBXXTk=;
        b=cn4WbXQb01yXdOLym0+Urdkx7OWYWBoaoT1iOy3HyK+Ez32VSxI3DnPDcMNEvqKDOZ
         Y93wzF26ZZRaWZrrK/u1XN7tNJzQKA08MiRc7bTsTpSvBCcQolnccNB0A5h9Z5yZFsz0
         /09NWdwnpmO6ZeH6pPGe1lZkRoV92sbovPE0ivfZR2YQMieXlvdlDaIiaqhlOjekwk3g
         lMCNx860xNhwyAlPexSQl+BIy3v0QKf/4BDYNb7fNO6MDFNttWBz0Ig4w9FeRTEIRPeX
         xF0d57MJn7nHPAx6tgJzhTe2Sx6tGS0pDX6rcCatazE2fsdrYr8YH/eFnA2pBQTRyJKC
         2LWA==
X-Gm-Message-State: ACgBeo2gJN0PCaRp/AZHLQuSlx4gPnGp41vh9zlwPJoL7Yg/7sOkhPU8
        WQaui1oXhdykH223r6iwO/iDQ13bQgI3GzE4Nw6ELf4Hk+1qeYVn4zWxX5p2LZ7R1ozY8eOIkYZ
        5PrToeHJv5NuL5295GERDPl5NKg==
X-Received: by 2002:ad4:5c8b:0:b0:474:9799:8134 with SMTP id o11-20020ad45c8b000000b0047497998134mr19178339qvh.38.1659530194541;
        Wed, 03 Aug 2022 05:36:34 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7KR83n7GqbmNxF91PiXZprHFE4pQ3LsqbcEmT4Eze+8CffcOBpU9EBBJqVczEScHfPYbMm2g==
X-Received: by 2002:ad4:5c8b:0:b0:474:9799:8134 with SMTP id o11-20020ad45c8b000000b0047497998134mr19178322qvh.38.1659530194315;
        Wed, 03 Aug 2022 05:36:34 -0700 (PDT)
Received: from [192.168.1.9] (pool-68-163-101-245.bstnma.fios.verizon.net. [68.163.101.245])
        by smtp.gmail.com with ESMTPSA id w18-20020a05620a425200b006b60c965024sm12629933qko.113.2022.08.03.05.36.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 05:36:33 -0700 (PDT)
To:     Song Liu <song@kernel.org>, Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>
References: <20220725220231.3273447-1-song@kernel.org>
 <YuKS1Bg8hlvEUSY2@alley>
 <CAPhsuW7Fm7q3CFrSK7H3hpd-mSyC8NLoD5M7HQDuFerdSRfQ1w@mail.gmail.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH RFC] livepatch: add sysfs entry "patched" for each
 klp_object
Message-ID: <5eb0aebd-21ea-1a88-67de-4257e77b62ef@redhat.com>
Date:   Wed, 3 Aug 2022 08:36:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW7Fm7q3CFrSK7H3hpd-mSyC8NLoD5M7HQDuFerdSRfQ1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 8/3/22 1:53 AM, Song Liu wrote:
> On Thu, Jul 28, 2022 at 6:44 AM Petr Mladek <pmladek@suse.com> wrote:
>>
>> On Mon 2022-07-25 15:02:31, Song Liu wrote:
>>> I was debugging an issue that a livepatch appears to be attached, but
>>> actually not. It turns out that there is a mismatch in module name
>>> (abc-xyz vs. abc_xyz), klp_find_object_module failed to find the module.
>>
>> This might be a quite common mistake. IMHO, the module name stored in
>> the module metadata always uses underscore '_' instead of dash '-'.
>>
>> If I get it correctly, it is done by the following command in
>> scripts/Makefile.lib:
>>
>> --- cut ---
>> # These flags are needed for modversions and compiling, so we define them here
>> # $(modname_flags) defines KBUILD_MODNAME as the name of the module it will
>> # end up in (or would, if it gets compiled in)
>> name-fix-token = $(subst $(comma),_,$(subst -,_,$1))
>> --- cut ---
> 
> Yeah, I can confirm the "name-fix" makes the change.
> 
> Hi Josh and Joe,
> 
> I hit this issue while building live patch for OOT module with kpatch-build.
> Do you have some suggestions on how to fix it? My current workaround is
> to manually edit the .ko file...
> 

Hi Song,

Was the original issue that the module's filename included '-' dash
character(s) while the module name ends up replaced those with '_'
underscores?

If that is the case, would you prefer that kpatch-build warn or refuse
to create .ko filenames that include '-' characters?

If you have ideas, feel free to post a new issue over on the project's
github.  No one should have to resort to manually (hex) editing .ko files :)

-- 
Joe

