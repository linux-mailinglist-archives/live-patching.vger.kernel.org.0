Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12B6587C73
	for <lists+live-patching@lfdr.de>; Tue,  2 Aug 2022 14:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbiHBMbL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Aug 2022 08:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiHBMbK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Aug 2022 08:31:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 76A0312AE7
        for <live-patching@vger.kernel.org>; Tue,  2 Aug 2022 05:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659443468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tMC4yG0I6LetQCzZhId20/r4mCiedZBP2tXBz39Ikrk=;
        b=Eljg7XzEIl34wx1VudyLuMssUH3DKKo9suXyKvW/C2+SX7ZLrkiWpbFco2wYIGeiIZeJjR
        WDmpvIINuv4sKviE4RPVhMuYGF600iScUgdLysv78iVs6xjhUZAgsFnLo8hQFldpTvRXQS
        OcuAMQYqG8zc+xRer6t8/mbzCoP6Xfk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-YuRzPrv2PruUaeHG4fSITQ-1; Tue, 02 Aug 2022 08:31:07 -0400
X-MC-Unique: YuRzPrv2PruUaeHG4fSITQ-1
Received: by mail-qk1-f197.google.com with SMTP id az14-20020a05620a170e00b006b666c4627bso11567171qkb.23
        for <live-patching@vger.kernel.org>; Tue, 02 Aug 2022 05:31:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=tMC4yG0I6LetQCzZhId20/r4mCiedZBP2tXBz39Ikrk=;
        b=cCc2US0UbRFOO1wo4Wrs2f+ojWRcCdCkGuN4bsmNStP5hO/FUGQewUlDslzcSadI21
         rbRg50sAbOEI1MmY1RAjWKkjqd0Xrvb3czDZr3NpFV7jfhWck3yBc9aDCcPUzBo5AwW9
         ylALNfWsjWIF6OEIZfVcSP245G8v6Y4N/AQK4DA98RiifGGMGdnaFfdbqfgCnjL6+9Ud
         QQ8mir2Ue1WtLiS4arzGfHJafYEw5gNu5dslBos+CkbCdf88WhDBm6nB1ACRl435GiXB
         1zdsTPKxime2dOd80QLxGmwPFRooeIUBXafdgnxA+N/lIkCuOYOCZMN567dwe7cr4i7w
         l0HA==
X-Gm-Message-State: ACgBeo2TJ0QS23+WjgSbLjKvPTExplh5Fa9LomAnV7188XWEyXf3fev/
        1iZuzYrLsV1uR/ctfQH6lEdz8XaJMQVLmDiJtUf5AQkakU3rDMAH9VJ5Vr/7Muq0DdxZnGSdBof
        gvSTInY8G+nn8mFrt7KVOGmniWA==
X-Received: by 2002:a05:6214:d62:b0:476:576c:cae2 with SMTP id 2-20020a0562140d6200b00476576ccae2mr11926224qvs.19.1659443467098;
        Tue, 02 Aug 2022 05:31:07 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7DteEg96Qf3Kjl5X9cbYEyKHUqHunfyp1YdsqSVMyh17IKW8CrUMtVkJbhxub7/xHogwTItA==
X-Received: by 2002:a05:6214:d62:b0:476:576c:cae2 with SMTP id 2-20020a0562140d6200b00476576ccae2mr11926185qvs.19.1659443466705;
        Tue, 02 Aug 2022 05:31:06 -0700 (PDT)
Received: from [10.211.55.14] (pool-68-163-101-245.bstnma.fios.verizon.net. [68.163.101.245])
        by smtp.gmail.com with ESMTPSA id e9-20020ac81309000000b0031d283f4c4dsm8545525qtj.60.2022.08.02.05.31.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Aug 2022 05:31:06 -0700 (PDT)
Message-ID: <d216c822-aa79-7ad8-2f6c-d74406ee8632@redhat.com>
Date:   Tue, 2 Aug 2022 08:31:04 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Song Liu <song@kernel.org>, Petr Mladek <pmladek@suse.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        live-patching@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, X86 ML <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
References: <20220721175147.214642-1-song@kernel.org>
 <20220726233302.zwloxsammnu7clu4@treble>
 <CAPhsuW7tmRt=yx1+i62HPRJJ4Gp8xB_3XvpVxUC=SyGv6iCBEQ@mail.gmail.com>
 <CAPhsuW4F8f9GLHF9C54oWyFiyJ0eT5HOwfhmoxSJ3HeRr8zCSw@mail.gmail.com>
 <CAPhsuW4VFjyoYta6fEGXg4S1dbg8ynkdKZzuwYSp3FMEGPP0aA@mail.gmail.com>
 <Yuep+uKnDc0L2ICi@alley>
 <CAPhsuW7FLVQ4CeBp0crTh5TQk30E113=ZMz_iHh5xK-QGNcT+g@mail.gmail.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v3] livepatch: Clear relocation targets on a module
 removal
In-Reply-To: <CAPhsuW7FLVQ4CeBp0crTh5TQk30E113=ZMz_iHh5xK-QGNcT+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 8/1/22 17:19, Song Liu wrote:
> On Mon, Aug 1, 2022 at 3:25 AM Petr Mladek <pmladek@suse.com> wrote:
>>
>> On Sat 2022-07-30 20:20:22, Song Liu wrote:
>>> On Sat, Jul 30, 2022 at 3:32 PM Song Liu <song@kernel.org> wrote:
>>>>
>>>> On Tue, Jul 26, 2022 at 8:54 PM Song Liu <song@kernel.org> wrote:
>>>>>
>>>>> On Tue, Jul 26, 2022 at 4:33 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>>>>>>
>>>>>> On Thu, Jul 21, 2022 at 10:51:47AM -0700, Song Liu wrote:
>>>>>>> From: Miroslav Benes <mbenes@suse.cz>
>>>>>>>
>>>>>>> Josh reported a bug:
>>>>>>>
>>>>>>>   When the object to be patched is a module, and that module is
>>>>>>>   rmmod'ed and reloaded, it fails to load with:
>>>>>>>
>>>>>>>   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
>>>>>>>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
>>>>>>>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
>>>>>>>
>>>>>>>   The livepatch module has a relocation which references a symbol
>>>>>>>   in the _previous_ loading of nfsd. When apply_relocate_add()
>>>>>>>   tries to replace the old relocation with a new one, it sees that
>>>>>>>   the previous one is nonzero and it errors out.
>>>>>>>
>>>>>>>   On ppc64le, we have a similar issue:
>>>>>>>
>>>>>>>   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
>>>>>>>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
>>>>>>>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
>>>>>>>
>>>>>> 3) A selftest would be a good idea.
>>>>>
>>>>
>>>> I found it is pretty tricky to run the selftests inside a qemu VM. How about
>>>> we test it with modules in samples/livepatch? Specifically, we can add a
>>>> script try to reload livepatch-shadow-mod.ko.
>>>
>>> Actually, livepatch-shadow-mod.ko doesn't have the reload problem before
>>> the fix. Is this expected?
>>
>> Good question. I am afraid that there is no easy way to prepare
>> the selftest at the moment.
>>
>> There are two situations when a symbol from the livepatched module is
>> relocated:
>>
>>
>> 1. The livepatch might access a symbol exported by the module via
>>    EXPORT_SYMBOL(). In this case, it is "normal" external symbol
>>    and it gets relocated by the module loader.
>>
>>    But EXPORT_SYMBOL() will create an explicit dependency between the
>>    livepatch and livepatched module. As a result, the livepatch
>>    module could be loaded only when the livepatched module is loaded.
>>    And the livepatched module could not be removed when the livepatch
>>    module is loaded.
>>
>>    In this case, the problem will not exist. Well, the developers
>>    of the livepatch module will probably want to avoid this
>>    dependency.
>>
>>
>> 2. The livepatch module might access a non-exported symbol from another
>>    module using the special elf section for klp relocation, see
>>    section, see Documentation/livepatch/module-elf-format.rst
>>
>>    These symbols are relocated in klp_apply_section_relocs().
>>
>>    The problem is that upstream does not have a support to
>>    create this elf section. There is a patchset for this, see
>>    https://lore.kernel.org/all/20220216163940.228309-1-joe.lawrence@redhat.com/
>>    It requires some more review.
>>
>>
>> Resume: I think that we could not prepare the selftest without
>>         upstreaming klp-convert tool.
> 
> Thanks for the explanation! I suspected the same issue, but couldn't
> connect all the logic.
> 
> I guess the selftests can wait until the klp-convert tool.
> 

Hi Song,

Petr is correct about selftests and these relocations.  Let me know if
rebasing the klp-convert patchset would be helpful in your testing.
Otherwise kpatch-build is the only (easy?) way to create klp-relocations
as far as I know.  (For limited arches anyway.)

Thanks,

-- 
Joe

