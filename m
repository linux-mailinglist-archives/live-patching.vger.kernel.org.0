Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94053640F10
	for <lists+live-patching@lfdr.de>; Fri,  2 Dec 2022 21:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbiLBURw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 2 Dec 2022 15:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234232AbiLBURv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 2 Dec 2022 15:17:51 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F611D0C0
        for <live-patching@vger.kernel.org>; Fri,  2 Dec 2022 12:17:50 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id x13so2529733ilp.8
        for <live-patching@vger.kernel.org>; Fri, 02 Dec 2022 12:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dz8upIDeXYMZ+kSQUUBL/vXdiOXaA02Vt2EWQSTRpwY=;
        b=dlztUo3DWsqJGrq694cv0dBE2x65D04x8RAktc84aeNkOFh0nkONh1H1LgYc50tjUr
         tOIicn/7Zyu8k2H8Phs2AA61vi+q/CsfRHDHAbRg0u+FAmogdbpV5hg25sISwgNWURw1
         qa8cZrIfCl5hE5g7PLFQgV9/nb8YZAioSftks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dz8upIDeXYMZ+kSQUUBL/vXdiOXaA02Vt2EWQSTRpwY=;
        b=ZAjif29xChPsbqDkEI1CEd6tHk2NvHLNFXvm4Pu6PHvykBA6BOxZWvUAryP6uNVVjk
         PsQCz0zymTb0JapZ1CWGy9uOXKX00T4pkGaE27RrckLMLsxPkORCEv7aGZvqrCProcwY
         bbIRuFfFmToMfsrP6i4Vn1ryVMlIapZZCKP6+rLZKBnefOqYzYZvbqPIkxsfwxoxfOfu
         OLgoEccAgWEfIwEzyKcLAfPsvhz4oXoaUK6wappDiuPJYDHE9mYcFfvpJt95K1zXbIXa
         k1D4/2GL36uaOm1wCO+Xi6ZHg+w7col3PDPo/86NDvhwIObIPn2v2WOR94R3IovKPkbW
         ciCQ==
X-Gm-Message-State: ANoB5pl8KCJilpPmkOcGbemYuvbnvJiHHlnQUsioVzszcxQuYgFJJMQt
        lH910XEU0iMhE5WaeHcAlX+SqA==
X-Google-Smtp-Source: AA0mqf6am+iSndoTM3IUrCGSouyS41yBMmdcXZRBsCK6MwWvGAdogN4j/pFat8WokxELhwOaOHBkOg==
X-Received: by 2002:a05:6e02:219d:b0:302:cbad:e98b with SMTP id j29-20020a056e02219d00b00302cbade98bmr26143156ila.186.1670012269609;
        Fri, 02 Dec 2022 12:17:49 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id p8-20020a92c608000000b003030d8b3cb7sm2736589ilm.42.2022.12.02.12.17.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 12:17:48 -0800 (PST)
Message-ID: <7cd6f041-dcf3-2591-4959-1671f83d8e80@linuxfoundation.org>
Date:   Fri, 2 Dec 2022 13:17:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 0/2] livepatch: Move tests from lib/livepatch to
 selftests/livepatch
Content-Language: en-US
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
        shuah@kernel.org, jpoimboe@redhat.com,
        Petr Mladek <pmladek@suse.com>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220630141226.2802-1-mpdesouza@suse.com>
 <3f9f91a3-4c08-52f4-1d3c-79f835271222@linuxfoundation.org>
 <alpine.LSU.2.21.2207010931270.13603@pobox.suse.cz>
 <8ff95ef5-db76-171d-4c4c-a84d9981290d@linuxfoundation.org>
 <20220715144526.GF2737@pathway.suse.cz>
 <aae71b0b-74e3-5874-b12f-bf0d42d851e4@redhat.com>
 <c5a6cb8a-7b99-249e-5ba4-732fc0ed2e30@linuxfoundation.org>
 <alpine.LSU.2.21.2212020820390.5559@pobox.suse.cz>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <alpine.LSU.2.21.2212020820390.5559@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 12/2/22 00:33, Miroslav Benes wrote:
> On Thu, 1 Dec 2022, Shuah Khan wrote:
> 
>> On 11/30/22 15:22, Joe Lawrence wrote:
>>> On 7/15/22 10:45 AM, Petr Mladek wrote:
>>>> On Fri 2022-07-01 16:13:50, Shuah Khan wrote:
>>>>> On 7/1/22 1:48 AM, Miroslav Benes wrote:
>>>>>> On Thu, 30 Jun 2022, Shuah Khan wrote:
>>>>>>>
>>>>>>> Sorry Nack on this. Let's not add modules under selftests. Any usage of
>>>>>>> module_init()
>>>>>>> doesn't belong under selftests.
>>>>>
>>>>> Yes I did and after reviewing and thinking about it some more, I decided
>>>>> this
>>>>> is the right direction go down on.
>>>>
>>>> Do you have some particular reason why building modules in selftests
>>>> directory might cause problems, please?
>>>>
>>
>> My reasons are that with this change module_init() propagates out of
>> strictly kernel space and now is in selftests which are user-space.
>> Any changes to this interface will be tied to user-space change.
> 
> I do not understand this (have not had a cup of tea yet).
> 
> module_init() is defined in include/linux/module.h. It is API. Every
> kernel module, in-tree or out-of-tree, uses it. There is only one usage of
> module_init() in Marcos's patch. In a kernel module, in tools/
> subdirectory yes.
> 
> If there is a change to module_init, it might need editing all the call
> sites, yes. That is inherent.
>   
>> This is my main concern. That is reason why I still ask the question
>> about why is it necessary to make this change other than self-contained
>> sources?
> 
> I will quote myself from an earlier email in the thread which you have not
> replied to...
> 
> "
> My main question is different though. As Marcos mentioned before, we would
> like to have our tests really flexible and a possibility to prepare and
> load different live patch modules based on a template is a part of it.
> What is your proposal regarding this? I can imagine having a template in
> lib/livepatch/ which would not be compilable and a script in
> tools/testing/selftests/livepatch/ would copy it many times, amend the
> copies (meaning parameters would be filled in with sed or the code would
> be changed), compile them and load them. But this sounds horrible to me,
> especially when compared to Marcos' approach in this patch set which is
> quite straightforward.
> "
> 

Responded to Petr's message -

"Yes, kABI is not backward compatible. But building the tests
modules out-of-tree way would allow to build test modules with
different kABI from the same sources."

This is a solid reason for livepatch modules to live under
sefltests. Let's capture this in README and the other updates that
need to be made to it in v3.

thanks,
-- Shuah

