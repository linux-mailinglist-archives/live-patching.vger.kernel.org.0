Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A83B68DD5B
	for <lists+live-patching@lfdr.de>; Tue,  7 Feb 2023 16:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbjBGPzl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 Feb 2023 10:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbjBGPzk (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 Feb 2023 10:55:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DAFE1DBA5
        for <live-patching@vger.kernel.org>; Tue,  7 Feb 2023 07:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675785299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K03QlXe/LWJeYy5yFUyEedK5XS487p96FeOtyIz5qpg=;
        b=Tc7zLYj5Of7tycsYv2gyrm+eG7hwEKxEtZM0xO38Tcu/H+a+WwcMuI7I+fB1z2X+uwcnSg
        8h+YwkgXrcR809u5NNQ1/AO2Q5UT9F/QOZPYznbleBOtkqdTN+yFAUnZdcBezb6sDxuwNG
        PP3BAspbJmIUhPNuN5BqgN45Ah+OvIo=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-627-yuHaBDxTO5i03Nn15tHWrA-1; Tue, 07 Feb 2023 10:54:57 -0500
X-MC-Unique: yuHaBDxTO5i03Nn15tHWrA-1
Received: by mail-qv1-f70.google.com with SMTP id ib5-20020a0562141c8500b0053c23b938a0so7906944qvb.17
        for <live-patching@vger.kernel.org>; Tue, 07 Feb 2023 07:54:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K03QlXe/LWJeYy5yFUyEedK5XS487p96FeOtyIz5qpg=;
        b=woTCHnBJJW6lcsPWa64V/JJhgfKGvibw7oCo7oICVvEEM35yVb1PZVzq1byajr9NoN
         iDACHroPm6OdMSCSHnR5ikXDkE+1JFBIEFpgIbXYytrSdOoCisEUfGJPI6W7jBsmrre5
         H/OoMQ3TYNIMgb1zMy0IfHzZZJDs/wOhkEnxwvexqGP4WoSTmIB9P24jKbAN2HTVn7/t
         vyEVnAfU5UvprSB2AUm7T/5F3nrYi56tTkR91KBEJVrprZNlMAXmS1tJieVQsPJAr1lk
         aQiL5jrDd1cT8J5gJAM9EaFLW1FnskkZg079BuAuShn4QwtsKR3v2WOdx0c5hJAzNbHz
         WZ0Q==
X-Gm-Message-State: AO0yUKUlAvoDqKA+jiMDxKPswCEfSTzQma1WVWG9yz8I/EbqdU9orUue
        THyW2xaXTE1STkNZqXOV3+jis/owPGnYAAjI6RNhbX7twXnzRDB1YIisCWAgQvEIXGMn2Wr58hy
        mHZTm64QQydbzf5DOlWYi/d/INwY84fg=
X-Received: by 2002:ac8:7fc3:0:b0:3a8:a6f:fb7 with SMTP id b3-20020ac87fc3000000b003a80a6f0fb7mr6505868qtk.11.1675785296091;
        Tue, 07 Feb 2023 07:54:56 -0800 (PST)
X-Google-Smtp-Source: AK7set9C91L6f9dAU0a0etM+lArtoG4waSol9GtDeOaou0FYQen8Opv4jozWqehZNrsR/AFo+lN0uA==
X-Received: by 2002:ac8:7fc3:0:b0:3a8:a6f:fb7 with SMTP id b3-20020ac87fc3000000b003a80a6f0fb7mr6505828qtk.11.1675785295695;
        Tue, 07 Feb 2023 07:54:55 -0800 (PST)
Received: from [192.168.1.16] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id fd10-20020a05622a4d0a00b003bb50a9f9bbsm121805qtb.7.2023.02.07.07.54.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 07:54:54 -0800 (PST)
Message-ID: <d2187ca1-2e94-fc5b-a8db-e2123981a5fc@redhat.com>
Date:   Tue, 7 Feb 2023 10:54:53 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     Marcos Paulo de Souza <mpdesouza@suse.de>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
References: <20220216163940.228309-1-joe.lawrence@redhat.com>
 <20230207125759.xfcsnlma6ezehff7@daedalus>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [RFC PATCH v6 00/12] livepatch: klp-convert tool
In-Reply-To: <20230207125759.xfcsnlma6ezehff7@daedalus>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 2/7/23 07:57, Marcos Paulo de Souza wrote:
> On Wed, Feb 16, 2022 at 11:39:28AM -0500, Joe Lawrence wrote:
>> This mostly a rebase update of the livepatch klp-convert tool used to
>> generate klp-relocation types (explained in the summary below).
>>
>> I'm marking this as an RFC as it hasn't been extensively tested for all
>> livepatch supported arches.  There are may be a few symbol annotation
>> changes pending what may be implemented for the FGKASLR patchset, I've
>> left a few TODO and // question? marks in the code, etc.  At the same
>> time, I think "CET/IBT support and live-patches" highlighted a potential
>> need for this tooling, so I'm posting it in its current format for
>> discussion.  I'll reply to individual patches to highlight a few points
>> of interest.
>>
>>
>> Summary
>> -------
>>
>> Livepatches may use symbols which are not contained in its own scope,
>> and, because of that, may end up compiled with relocations that will
>> only be resolved during module load. Yet, when the referenced symbols
>> are not exported, solving this relocation requires information on the
>> object that holds the symbol (either vmlinux or modules) and its
>> position inside the object, as an object may contain multiple symbols
>> with the same name.  Providing such information must be done accordingly
>> to what is specified in Documentation/livepatch/module-elf-format.txt.
>>
>> Currently, there is no trivial way to embed the required information as
>> requested in the final livepatch elf object. klp-convert solves this
>> problem in two different forms: (i) by relying on a symbol map, which is
>> built during kernel compilation, to automatically infer the relocation
>> targeted symbol, and, when such inference is not possible (ii) by using
>> annotations in the elf object to convert the relocation accordingly to
>> the specification, enabling it to be handled by the livepatch loader.
>>
>> Given the above, add support for symbol mapping in the form of a
>> symbols.klp file; add klp-convert tool; integrate klp-convert tool into
>> kbuild; make livepatch modules discernible during kernel compilation
>> pipeline; add data-structure and macros to enable users to annotate
>> livepatch source code; make modpost stage compatible with livepatches;
>> update livepatch-sample and update documentation.
>>
>> The patch was tested under three use-cases:
>>
>> use-case 1: There is a relocation in the lp that can be automatically
>> resolved by klp-convert.  For example. see the saved_command_line
>> variable in lib/livepatch/test_klp_convert2.c.
>>
>> use-case 2: There is a relocation in the lp that cannot be automatically
>> resolved, as the name of the respective symbol appears in multiple
>> objects. The livepatch contains an annotation to enable a correct
>> relocation.  See the KLP_MODULE_RELOC / KLP_SYMPOS annotation sections
>> in lib/livepatch/test_klp_convert{1,2}.c.
>>
>> use-case 3: There is a relocation in the lp that cannot be automatically
>> resolved similarly as 2, but no annotation was provided in the
>> livepatch, triggering an error during compilation.  Reproducible by
>> removing the KLP_MODULE_RELOC / KLP_SYMPOS annotation sections in
>> lib/livepatch/test_klp_convert{1,2}.c.
>>
>> Selftests have been added to exercise these klp-convert use-cases
>> through several tests.
>>
>>
>> Branches
>> --------
>>
>>
>> Previous versions
>> -----------------
>>
>> RFC:
>>   https://lore.kernel.org/lkml/cover.1477578530.git.jpoimboe@redhat.com/
>> v2:
>>   https://lore.kernel.org/lkml/f52d29f7-7d1b-ad3d-050b-a9fa8878faf2@redhat.com/
>> v3:
>>   https://lore.kernel.org/lkml/20190410155058.9437-1-joe.lawrence@redhat.com/
>> v4:
>>   https://lore.kernel.org/lkml/20190509143859.9050-1-joe.lawrence@redhat.com/
>> v5:
>>   (not posted)
>>   https://github.com/joe-lawrence/klp-convert-tree/tree/klp-convert-v5-devel
>> v6:
>>   https://github.com/joe-lawrence/klp-convert-tree/tree/klp-convert-v6
>>   https://github.com/joe-lawrence/klp-convert-tree/tree/klp-convert-v6-devel
> 
> Hi Joe,
> 
> I send reviews to some patches of the v6 batch, but there is currently a v7 in
> your github profile. I believe that I sent Rb for patches that are the same
> between versions.
> 
> The current version is almost one year older already. Do you plan to send v7
> soon?
> 

Hi Marcos,

Thanks for the reviews and indeed, it has been a while since v6.

For v7, I would like to rebase on top of v6.2 so it includes the recent
x86/ppc64le relocation fixes from Song/Josh.

There are still a fair number of design questions that I have.. but a
fresh version will be much easier to test and review.  I'll try to get
it posted in the new few weeks.

-- 
Joe

