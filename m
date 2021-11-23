Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D1B45ADB1
	for <lists+live-patching@lfdr.de>; Tue, 23 Nov 2021 21:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhKWVCF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Nov 2021 16:02:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44694 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230383AbhKWVCF (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Nov 2021 16:02:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637701136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hn2zH4ggb9e6+Ub6QIBVav7QoZegdz0BDZQ908gF7aw=;
        b=blXTxlHYuajaZimpZPpMnVD9+ioonQoPvnGb9cGN36pPkPVHZh+iLR+bZHYyWwNpRijerx
        rx4W/nPUClqsLr2r3bNu5e2UwUIk7aB4g17RAiqlh1fFC8rttI2vSjm2VRFPUmDVrqkCog
        mfZ4Zde3GGRGPe8OAbRXvlBMuYky818=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-uCgM7bAkNya7mu-Hix0bfA-1; Tue, 23 Nov 2021 15:58:55 -0500
X-MC-Unique: uCgM7bAkNya7mu-Hix0bfA-1
Received: by mail-qk1-f198.google.com with SMTP id w2-20020a3794020000b02903b54f40b442so390411qkd.0
        for <live-patching@vger.kernel.org>; Tue, 23 Nov 2021 12:58:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hn2zH4ggb9e6+Ub6QIBVav7QoZegdz0BDZQ908gF7aw=;
        b=vLWzjlRb6PO4ElW3tIJALZo2uYAVaazmB9fTv6GNfOX6hmbtOIhRREeNLPY2T46/uB
         Aa0WVoKsRKqAL+RBGNDU2FQaCZ7zSO8mFLF15ABpQcE45jDyVji450Exz7AA+bQeYeOT
         7cu0qmLeX//MGJWsL1wnLIyRcTwep3x7zdnbE491pOXQf3wZS3SLE/m9n8hqzJaldzOK
         cvR9aBzI8J088RUQG8jaI1RTlwYdXhjKjjCtlcFniuX2Zuuv7K/PaibzvkUg+bZh9NQw
         cyLH0g8/+SttMreqG4VuX1NN0l4bt3Tn/g/Te/ykGiXp7JtC/htDKt3kUsEbuk3kOgeO
         ySJw==
X-Gm-Message-State: AOAM530yG3pxhRC5bQyukrmYDnTJRpCjbxvsqBrvRMRtyU670cMNapLf
        lO8YWbgyzQivwJYqE5dxCUBq3rH/zYwC2wf2Z14dgdEof8KHNHYulfDroGWD4+4RlFMelsoSwmi
        3ha8l0SVHFLMXaRD/hBdNpfGQEcrWwsx8kTQ/WyK5cq51m/fFWL248CCu1Io3ozrThYKBe7v4be
        IXQXnhs+Q=
X-Received: by 2002:a05:6214:21ae:: with SMTP id t14mr228949qvc.66.1637701134775;
        Tue, 23 Nov 2021 12:58:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxOS8Dkr2hriTgMPr45n7OLWCDtrrxmETJR22m1Sp4V4EpCZ4PJ/ignjpIoq74tdMLR1/AhOQ==
X-Received: by 2002:a05:6214:21ae:: with SMTP id t14mr228916qvc.66.1637701134498;
        Tue, 23 Nov 2021 12:58:54 -0800 (PST)
Received: from [192.168.1.9] (pool-68-163-101-245.bstnma.fios.verizon.net. [68.163.101.245])
        by smtp.gmail.com with ESMTPSA id z4sm6763754qtj.42.2021.11.23.12.58.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 12:58:53 -0800 (PST)
To:     Miroslav Benes <mbenes@suse.cz>, joao@overdrivepizza.com
Cc:     nstange@suse.de, pmladek@suse.cz,
        Peter Zijlstra <peterz@infradead.org>, jpoimboe@redhat.com,
        live-patching@vger.kernel.org
References: <70828ca9f840960c7a3f66cd8dc141f5@overdrivepizza.com>
 <alpine.LSU.2.21.2111231035460.15177@pobox.suse.cz>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: CET/IBT support and live-patches
Message-ID: <08d4a24d-02c2-6760-96bf-b72f51025808@redhat.com>
Date:   Tue, 23 Nov 2021 15:58:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.2111231035460.15177@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 11/23/21 4:58 AM, Miroslav Benes wrote:
> [ adding more CCs ]
> 
> On Mon, 22 Nov 2021, joao@overdrivepizza.com wrote:
> 
>> Hi Miroslav, Petr and Nicolai,
>>
>> Long time no talk, I hope you are all still doing great :)
> 
> Everything great here :)
> 
>> So, we have been cooking a few patches for enabling Intel CET/IBT support in
>> the kernel. The way IBT works is -- whenever you have an indirect branch, the
>> control-flow must land in an endbr instruction. The idea is to constrain
>> control-flow in a way to make it harder for attackers to achieve meaningful
>> computation through pointer/memory corruption (as in, an attacker that can
>> corrupt a function pointer by exploiting a memory corruption bug won't be able
>> to execute whatever piece of code, being restricted to jump into endbr
>> instructions). To make the allowed control-flow graph more restrict, we are
>> looking into how to minimize the number of endbrs in the final kernel binary
>> -- meaning that if a function is never called indirectly, it shouldn't have an
>> endbr instruction, thus increasing the security guarantees of the hardware
>> feature.
>>
>> Some ref about what is going on --
>> https://lore.kernel.org/lkml/20211122170805.149482391@infradead.org/T/
> 
> Yes, I noticed something was happening again. There was a thread on this 
> in February https://lore.kernel.org/all/20210207104022.GA32127@zn.tnic/ 
> and some concerns were raised back then around fentry and int3 patching if 
> I remember correctly. Is this still an issue?
> 
>> IIRC, live-patching used kallsyms/kallsyms_lookup_name for grabbing pointers
>> to the symbols in the running kernel and then used these pointers to invoke
>> the functions which reside outside of the live-patch (ie. previously existing
>> functions). With the above IBT support, if these functions were considered
>> non-indirectly-reachable, and were suppressed of an endbr, this would lead
>> into a crash. I remember we were working on klp-convert to fix this through
>> special relocations and that there were other proposals... but I'm not sure
>> where it went.
>>
>> So, would you mind giving a quick update on the general state of this? If the
>> IBT support would break this (and anything else) regarding live-patching...
>> and so on?
> 
> Right. So, this really depends on how downstream consumers approach this. 
> kpatch-build should be fine if I am not mistaken, because it uses the 
> .klp.rela support we have in the kernel. We (at SUSE) have a problem, 
> because we still exploit kallsyms/kallsyms_lookup_name to cope with this.
> 

Hi Miroslav, Joao,

Yep, kpatch-build uses its own klp-relocation conversion and not kallsyms.

I'm not familiar with CET/IBT, but it sounds like if a function pointer
is not taken at build time (or maybe some other annotation), the
compiler won't generate the needed endbr landing spot in said function?
 And that would be a problem for modules using kallsyms lookup to get to
said function.

> Joe, what is the current state of klp-convert? Do we still want to follow 
> that way?
> 

kpatch-build relies on klp-relocations and they work well enough across
the architectures we support.  Its code is slightly different than
klp-convert, but concepts the same.  Moving all of that into the kernel
build would definitely be better from a maintenance POV.

I can rebase the latest klp-convert patchset that I had worked on if we
want to test and review.  Apologies for losing momentum on that patchset
while waiting for .klp.arch stuff to drop out, in particular the subset
of static key relocations would still be supported.

-- 
Joe

