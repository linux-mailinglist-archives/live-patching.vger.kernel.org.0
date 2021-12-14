Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D81E47431D
	for <lists+live-patching@lfdr.de>; Tue, 14 Dec 2021 14:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbhLNNAR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Dec 2021 08:00:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57922 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234209AbhLNNAO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Dec 2021 08:00:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639486814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kg87+iepEuXBJrlDYsDuqAwGIPCcapC3qDh2z9ZFHZI=;
        b=f7SAicWsRpiGTeIecoPEKdpoEGnp898pEaB5C2IlT4K33Ih3T3x7Fl4Beq0VucrLM82o7C
        5ulIgFymKpYlOaP37YI5cb0AZBREwm5SI7NSyVL+34T9ZE7nDyI7XupVJaCwrLBEG9KAVr
        6nOooaH9TLt+ZF9jSkmJwjKa5Ml43sg=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-EAgGK4CKOlqCKccb3R8y4Q-1; Tue, 14 Dec 2021 08:00:13 -0500
X-MC-Unique: EAgGK4CKOlqCKccb3R8y4Q-1
Received: by mail-qt1-f198.google.com with SMTP id h8-20020a05622a170800b002acc8656e05so26576433qtk.7
        for <live-patching@vger.kernel.org>; Tue, 14 Dec 2021 05:00:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kg87+iepEuXBJrlDYsDuqAwGIPCcapC3qDh2z9ZFHZI=;
        b=7l8S0xgtqdkQfJZaODLrp5kgJIlFCFr9o1ZXE4VdnRaVRmkD4waEvg8efanOF91K/R
         HhQ6EWPOYJ+h0GW6altmuDQgg97lhkKJaiA/KE0W7GcwfHBvStFJV9LHw5Q0jkqaHVar
         L/SYZV0qt5MvXAtIDX4L94rdPD7LaIXj2F3byoEY8/BnS6Lvy58+NlpyJdKxtb0bB+G/
         gZbubJTeZIEO3MoByct8zGbf5XSxDdzASP1nncW4tAsgUaGrRtS7ffTabt4N3SwK6J0f
         B9nDwIcTPo8IAtbw2ciT3tcWqNwh/HwcEvTvQ+wpzZvewWezAphsyqtZqdbEMyLVf31i
         Karg==
X-Gm-Message-State: AOAM531L243AxT88VNIsJGkqQW4v2nbbKEhu5QGsZN77kKapIxlH8Hno
        ouNgT9BbsMm8K4yvS3kNSy49uQf+j+DSRd6tXCqw/8Tw86JXWz7TdpjNsDo9vlXSliRQUyccPi1
        /jRIiwzJp/5/k7avaTb+GYbw8NA==
X-Received: by 2002:a05:6214:1c06:: with SMTP id u6mr5231067qvc.35.1639486812403;
        Tue, 14 Dec 2021 05:00:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy8MCP8C/P+JBe8G8JTUQ+MDM9AFEehMJUWgUeY0ZzVbaHyRwMLVGNqMJBHwYXERIkPClQxkQ==
X-Received: by 2002:a05:6214:1c06:: with SMTP id u6mr5231029qvc.35.1639486812037;
        Tue, 14 Dec 2021 05:00:12 -0800 (PST)
Received: from [192.168.1.9] (pool-68-163-101-245.bstnma.fios.verizon.net. [68.163.101.245])
        by smtp.gmail.com with ESMTPSA id f12sm11193854qtj.93.2021.12.14.05.00.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 05:00:11 -0800 (PST)
Subject: Re: ppc64le STRICT_MODULE_RWX and livepatch apply_relocate_add()
 crashes
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Russell Currey <ruscur@russell.cc>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Jordan Niethe <jniethe5@gmail.com>
References: <YX9UUBeudSUuJs01@redhat.com>
 <7ee0c84650617e6307b29674dd0a12c7258417cf.camel@russell.cc>
 <f8a96ac1-fda3-92da-cf27-0992a43a2f3f@redhat.com>
 <bed88ff4-e5d3-4b78-4f28-29fc635c2f97@csgroup.eu>
 <919a79b8-feff-b0a4-b96a-73f376b7f6dc@redhat.com>
 <61a5f29c-5123-5f0f-11aa-91cb0ac95a69@csgroup.eu>
 <8a68ffef-7e0d-b1ff-1102-2e6f2c999455@redhat.com>
 <27cee0a4-aa34-7a52-f98c-ab8c13aafb12@csgroup.eu>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <af1eb0c3-4beb-bbc4-39da-da42f104f6c7@redhat.com>
Date:   Tue, 14 Dec 2021 08:00:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <27cee0a4-aa34-7a52-f98c-ab8c13aafb12@csgroup.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 12/14/21 7:44 AM, Christophe Leroy wrote:
> 
> 
> Le 13/12/2021 à 18:26, Joe Lawrence a écrit :
>> On 12/13/21 11:36 AM, Christophe Leroy wrote:
>>>
>>>
>>> Le 13/12/2021 à 15:47, Joe Lawrence a écrit :
>>>> On 12/13/21 2:42 AM, Christophe Leroy wrote:
>>>>>
>>>>> Hello Joe,
>>>>>
>>>>> I'm implementing LIVEPATCH on PPC32 and I wanted to test with
>>>>> STRICT_MODULE_RWX enabled so I took your branch as suggested, but I'm
>>>>> getting the following errors on build. What shall I do ?
>>>>>
>>>>>      CALL    scripts/checksyscalls.sh
>>>>>      CALL    scripts/atomic/check-atomics.sh
>>>>>      CHK     include/generated/compile.h
>>>>>      KLP     lib/livepatch/test_klp_convert1.ko
>>>>> klp-convert: section .rela.klp.module_relocs.test_klp_convert_mod length
>>>>> beyond nr_entries
>>>>>
>>>>> klp-convert: Unable to load user-provided sympos
>>>>> make[2]: *** [scripts/Makefile.modfinal:79:
>>>>> lib/livepatch/test_klp_convert1.ko] Error 255
>>>>>      KLP     lib/livepatch/test_klp_convert2.ko
>>>>> klp-convert: section .rela.klp.module_relocs.test_klp_convert_mod length
>>>>> beyond nr_entries
>>>>>
>>>>> klp-convert: Unable to load user-provided sympos
>>>>> make[2]: *** [scripts/Makefile.modfinal:79:
>>>>> lib/livepatch/test_klp_convert2.ko] Error 255
>>>>>      KLP     lib/livepatch/test_klp_convert_sections.ko
>>>>> klp-convert: section .rela.klp.module_relocs.test_klp_convert_mod length
>>>>> beyond nr_entries
>>>>>
>>>>> klp-convert: Unable to load user-provided sympos
>>>>> make[2]: *** [scripts/Makefile.modfinal:79:
>>>>> lib/livepatch/test_klp_convert_sections.ko] Error 255
>>>>> make[2]: Target '__modfinal' not remade because of errors.
>>>>> make[1]: *** [scripts/Makefile.modpost:145: __modpost] Error 2
>>>>> make: *** [Makefile:1770: modules] Error 2
>>>>>
>>>>
>>>> Hi Christophe,
>>>>
>>>> Interesting failure mode.  That's klp-convert complaining that it found
>>>> more relocations in a .klp.module_relocs.<objname> section than
>>>> expected, i.e. nr_entries = sec->size / sizeof(struct klp_module_reloc).
>>>>
>>>> A few possibilities: the ELF sec->size was incorrectly set/read by
>>>> build/libelf (I doubt that).  Or maybe the layout/size of struct
>>>> klp_module_reloc is not consistent between kernel and userspace (I'm
>>>> more suspicious of this).
>>>>
>>>> Can you post a copy of the build's symbols.klp and
>>>> lib/livepatch/test_klp_convert1.tmp.ko somewhere?  I should be able to
>>>> start debug with those files.
>>>>
>>>
>>> I sent you both files off list.
>>>
>>> It looks like klp-convert doesn't use the correct size. It finds a
>>> struct of size 12 hence 3 entries for a section of size 40.
>>>
>>> On PPC32 the struct has size 8 (void * is 4 and int is 4).
>>>
>>> But I'm cross-building from x86_64 where the struct is 8 + 4 = 12.
>>>
>>> Can it be the reason ?
>>>
>>
>> I'm pretty sure that is it.  I haven't had much runtime with klp-convert
>> and cross-building (I've only found one big/little endian bug with
>> x86_64->s390x) and was going to ask you how you were testing :)
>>
>> Do you know if there are other kernel build tools that deal with similar
>> situations?  This seems like a tricky job for the userspace build tool
>> to determine non-native target struct layout.
>>
>> In the meantime, hacking in:
>>
>>   struct klp_module_reloc {
>> -       void *sym;
>> +       uint32_t sym;
>>          unsigned int sympos;
>>   } __packed;
>>
>> gets me generating an output .ko file, but the readelf output doesn't
>> look right.
>>
>> I'll add this to the patchset TODO list, but may not get to it for a
>> while -- is there any chance the above hack works or could you test a
>> local non-cross build?
>>
> 
> No I have no way to do a non-cross build. My target is an embedded board 
> with slow CPU and little memory.
> 
> I tested with your hack, I get:
> 
> root@vgoip:~# insmod /lib/modules/test_klp_convert1.ko
> insmod: can't insert '/lib/modules/test_klp_convert1.ko': unknown symbol 
> in module, or unknown parameter
> root@vgoip:~# insmod /lib/modules/test_klp_livepatch.ko
> insmod: can't insert '/lib/modules/test_klp_livepatch.ko': unknown 
> symbol in module, or unknown parameter
> 
> 
> I agree with you readelf shows something went wrong with relocations.
> 

Thanks for trying that.  Can you point me to the cross-compiler suite
that you are using for build and readelf?  Kernel .config would be handy
too and I can try to reproduce locally for debugging.

Thanks,

-- 
Joe

