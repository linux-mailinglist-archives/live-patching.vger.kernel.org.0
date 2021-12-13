Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F7E4732E7
	for <lists+live-patching@lfdr.de>; Mon, 13 Dec 2021 18:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237795AbhLMR1A (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 13 Dec 2021 12:27:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33873 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237724AbhLMR06 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 13 Dec 2021 12:26:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639416417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y4o6oVIesfnDo84d/kPIVObUuOUn9rbV/Dxvkbz+Ve8=;
        b=bKoWlJJc8kZJXG//hXKyVdeCyREHTN0V/xONrJGI8KmSGQHrdQsoHIH82nM70tweLS5pF2
        dGMVdyiGufCDakK8H+Bt9UnZiB1sQQvaNuiEbdNF/SQskkt4HqTmnMpHclpDK/7OodsDTl
        973X5hKRlN1XH4T7ydLW0xl7Ifu+2pY=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-141-SJJVB5ZHN6q_wiPxdwAv0Q-1; Mon, 13 Dec 2021 12:26:56 -0500
X-MC-Unique: SJJVB5ZHN6q_wiPxdwAv0Q-1
Received: by mail-qv1-f70.google.com with SMTP id kl17-20020a056214519100b003ba5b03606fso24744913qvb.0
        for <live-patching@vger.kernel.org>; Mon, 13 Dec 2021 09:26:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y4o6oVIesfnDo84d/kPIVObUuOUn9rbV/Dxvkbz+Ve8=;
        b=6QcZRRMTmtbvJilb9bGrIkiBFk6+MHCZ/L789obhP0idewQDL7E/6KmstlmlvwKTnT
         KmJnqRwajIEQ4TCVKixIphBW7QuZqpgP7ULMq5z2pStrVTZ6ffAdPIhElEgzlD1WJ1pt
         yfpHj+yJH9wDDpE/H8kLoY9DCyWZDYKrWK30PrdiPabd1Rml0jmalF01yYbLYNLFf0Yw
         SmxROOFSHfHWhPmxmL2OJeTf38CBweAcFUx/knycbCo3cbkx5F54RORWoBVbfZrpIV1F
         lFSkMo9vwpTfrd2Tz7/S6HqOLSesmfcvZf5Llo4+Ywjqs2ycIm5XD4DTrAENy7yWbjl7
         gi3Q==
X-Gm-Message-State: AOAM531KtBDBgDa/pV/XuA5E5LuaM1oFU0Ta1vkZPheGuTZbH+miEbYy
        Dvxpf8R/Ei1vJB6SfjQmrheNY3jMVadTBm8dRQbj0YBG58mVkl9Xt5Ciw2QdkIIhIhkvNR9pUTH
        W7A8zC3WKquHjcOgPixuvOz7Fmw==
X-Received: by 2002:a05:622a:1487:: with SMTP id t7mr115311qtx.484.1639416416082;
        Mon, 13 Dec 2021 09:26:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwdKNR0RmU/rmZRwD07K87ZQ//xzz4YKuZVanITX8zCfz4ZzTxkAq+LnjECgKjaNNjJywk3Ww==
X-Received: by 2002:a05:622a:1487:: with SMTP id t7mr115261qtx.484.1639416415755;
        Mon, 13 Dec 2021 09:26:55 -0800 (PST)
Received: from [192.168.1.9] (pool-68-163-101-245.bstnma.fios.verizon.net. [68.163.101.245])
        by smtp.gmail.com with ESMTPSA id f21sm9581080qte.52.2021.12.13.09.26.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 09:26:55 -0800 (PST)
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
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: ppc64le STRICT_MODULE_RWX and livepatch apply_relocate_add()
 crashes
Message-ID: <8a68ffef-7e0d-b1ff-1102-2e6f2c999455@redhat.com>
Date:   Mon, 13 Dec 2021 12:26:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <61a5f29c-5123-5f0f-11aa-91cb0ac95a69@csgroup.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 12/13/21 11:36 AM, Christophe Leroy wrote:
> 
> 
> Le 13/12/2021 à 15:47, Joe Lawrence a écrit :
>> On 12/13/21 2:42 AM, Christophe Leroy wrote:
>>>
>>> Hello Joe,
>>>
>>> I'm implementing LIVEPATCH on PPC32 and I wanted to test with
>>> STRICT_MODULE_RWX enabled so I took your branch as suggested, but I'm
>>> getting the following errors on build. What shall I do ?
>>>
>>>     CALL    scripts/checksyscalls.sh
>>>     CALL    scripts/atomic/check-atomics.sh
>>>     CHK     include/generated/compile.h
>>>     KLP     lib/livepatch/test_klp_convert1.ko
>>> klp-convert: section .rela.klp.module_relocs.test_klp_convert_mod length
>>> beyond nr_entries
>>>
>>> klp-convert: Unable to load user-provided sympos
>>> make[2]: *** [scripts/Makefile.modfinal:79:
>>> lib/livepatch/test_klp_convert1.ko] Error 255
>>>     KLP     lib/livepatch/test_klp_convert2.ko
>>> klp-convert: section .rela.klp.module_relocs.test_klp_convert_mod length
>>> beyond nr_entries
>>>
>>> klp-convert: Unable to load user-provided sympos
>>> make[2]: *** [scripts/Makefile.modfinal:79:
>>> lib/livepatch/test_klp_convert2.ko] Error 255
>>>     KLP     lib/livepatch/test_klp_convert_sections.ko
>>> klp-convert: section .rela.klp.module_relocs.test_klp_convert_mod length
>>> beyond nr_entries
>>>
>>> klp-convert: Unable to load user-provided sympos
>>> make[2]: *** [scripts/Makefile.modfinal:79:
>>> lib/livepatch/test_klp_convert_sections.ko] Error 255
>>> make[2]: Target '__modfinal' not remade because of errors.
>>> make[1]: *** [scripts/Makefile.modpost:145: __modpost] Error 2
>>> make: *** [Makefile:1770: modules] Error 2
>>>
>>
>> Hi Christophe,
>>
>> Interesting failure mode.  That's klp-convert complaining that it found
>> more relocations in a .klp.module_relocs.<objname> section than
>> expected, i.e. nr_entries = sec->size / sizeof(struct klp_module_reloc).
>>
>> A few possibilities: the ELF sec->size was incorrectly set/read by
>> build/libelf (I doubt that).  Or maybe the layout/size of struct
>> klp_module_reloc is not consistent between kernel and userspace (I'm
>> more suspicious of this).
>>
>> Can you post a copy of the build's symbols.klp and
>> lib/livepatch/test_klp_convert1.tmp.ko somewhere?  I should be able to
>> start debug with those files.
>>
> 
> I sent you both files off list.
> 
> It looks like klp-convert doesn't use the correct size. It finds a 
> struct of size 12 hence 3 entries for a section of size 40.
> 
> On PPC32 the struct has size 8 (void * is 4 and int is 4).
> 
> But I'm cross-building from x86_64 where the struct is 8 + 4 = 12.
> 
> Can it be the reason ?
> 

I'm pretty sure that is it.  I haven't had much runtime with klp-convert
and cross-building (I've only found one big/little endian bug with
x86_64->s390x) and was going to ask you how you were testing :)

Do you know if there are other kernel build tools that deal with similar
situations?  This seems like a tricky job for the userspace build tool
to determine non-native target struct layout.

In the meantime, hacking in:

 struct klp_module_reloc {
-       void *sym;
+       uint32_t sym;
        unsigned int sympos;
 } __packed;

gets me generating an output .ko file, but the readelf output doesn't
look right.

I'll add this to the patchset TODO list, but may not get to it for a
while -- is there any chance the above hack works or could you test a
local non-cross build?

Thanks,

-- 
Joe

